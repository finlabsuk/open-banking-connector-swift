// ********************************************************************************
//
// This source file is a modified version of Sources/NIOHTTP1Server/main.swift from
// the SwiftNIO project ( https://github.com/apple/swift-nio ).
//
// Modifications are Copyright (C) 2019 Finnovation Labs and the
// Open Banking Connector project authors. See below for copyright notice from
// the original file.
//
// Licensed under Apache License v2.0. See LICENSE.txt for licence information.
// SPDX-License-Identifier: Apache-2.0
//
// ********************************************************************************


//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2017-2018 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//
import NIO
import NIOHTTP1
import Foundation
import Logging
import AccountTransactionTypes
import PaymentInitiationTypes

extension String {
    func chopPrefix(_ prefix: String) -> String? {
        if self.unicodeScalars.starts(with: prefix.unicodeScalars) {
            return String(self[self.index(self.startIndex, offsetBy: prefix.count)...])
        } else {
            return nil
        }
    }

    func containsDotDot() -> Bool {
        for idx in self.indices {
            if self[idx] == "." && idx < self.index(before: self.endIndex) && self[self.index(after: idx)] == "." {
                return true
            }
        }
        return false
    }
    
    func matchesRegex(regex: NSRegularExpression) -> [String]? {
        if let firstMatch = regex.firstMatch(in: self, range: NSMakeRange(0, self.utf16.count)) {
            return (0 ..< firstMatch.numberOfRanges).map {
                let nsRange = firstMatch.range(at: $0)
                guard let range = Range(nsRange, in: self) else {
                    return ""
                }
                return String(self[range])
            }
        } else {
            return nil
        }
    }
}

private func getSingleValuedHeader(fieldName: String, headers: HTTPHeaders) -> String? {
    let valueArray = headers[canonicalForm: fieldName]
    if valueArray.count == 1 {
        return String(valueArray[0])
    } else {
        return nil
    }
}

private func httpResponseHead(request: HTTPRequestHead, status: HTTPResponseStatus, headers: HTTPHeaders = HTTPHeaders()) -> HTTPResponseHead {
    var head = HTTPResponseHead(version: request.version, status: status, headers: headers)
    let connectionHeaders: [String] = head.headers[canonicalForm: "connection"].map { $0.lowercased() }

    if !connectionHeaders.contains("keep-alive") && !connectionHeaders.contains("close") {
        // the user hasn't pre-set either 'keep-alive' or 'close', so we might need to add headers

        switch (request.isKeepAlive, request.version.major, request.version.minor) {
        case (true, 1, 0):
            // HTTP/1.0 and the request has 'Connection: keep-alive', we should mirror that
            head.headers.add(name: "Connection", value: "keep-alive")
        case (false, 1, let n) where n >= 1:
            // HTTP/1.1 (or treated as such) and the request has 'Connection: close', we should mirror that
            head.headers.add(name: "Connection", value: "close")
        default:
            // we should match the default or are dealing with some HTTP that we don't support, let's leave as is
            ()
        }
    }
    return head
}

private final class HTTPHandler: ChannelInboundHandler {
    private enum FileIOMethod {
        case sendfile
        case nonblockingFileIO
    }
    public typealias InboundIn = HTTPServerRequestPart
    public typealias OutboundOut = HTTPServerResponsePart

    private enum State {
        case idle
        case waitingForRequestBody
        case sendingResponse

        mutating func requestReceived() {
            precondition(self == .idle, "Invalid state for request received: \(self)")
            self = .waitingForRequestBody
        }

        mutating func requestComplete() {
            precondition(self == .waitingForRequestBody, "Invalid state for request complete: \(self)")
            self = .sendingResponse
        }

        mutating func responseComplete() {
            precondition(self == .sendingResponse, "Invalid state for response complete: \(self)")
            self = .idle
        }
    }

    private var buffer: ByteBuffer! = nil
    private var keepAlive = false
    private var state = State.idle
    private let htdocsPath: String

    private var infoSavedRequestHead: HTTPRequestHead?
    private var infoSavedBodyBytes: Int = 0

    private var continuousCount: Int = 0

    private var handler: ((ChannelHandlerContext, HTTPServerRequestPart) -> Void)?
    private var handlerFuture: EventLoopFuture<Void>?
    private let fileIO: NonBlockingFileIO
    private let defaultResponse = "Hello World\r\n"

    public init(fileIO: NonBlockingFileIO, htdocsPath: String) {
        self.htdocsPath = htdocsPath
        self.fileIO = fileIO
    }

    func handleInfo(context: ChannelHandlerContext, request: HTTPServerRequestPart) {
        switch request {
        case .head(let request):
            self.infoSavedRequestHead = request
            self.infoSavedBodyBytes = 0
            self.keepAlive = request.isKeepAlive
            self.state.requestReceived()
        case .body(buffer: let buf):
            self.infoSavedBodyBytes += buf.readableBytes
        case .end:
            self.state.requestComplete()
            let response = """
            HTTP method: \(self.infoSavedRequestHead!.method)\r
            URL: \(self.infoSavedRequestHead!.uri)\r
            body length: \(self.infoSavedBodyBytes)\r
            headers: \(self.infoSavedRequestHead!.headers)\r
            client: \(context.remoteAddress?.description ?? "zombie")\r
            IO: SwiftNIO Electric Boogaloo™️\r\n
            """
            self.buffer.clear()
            self.buffer.writeString(response)
            var headers = HTTPHeaders()
            headers.add(name: "Content-Length", value: "\(response.utf8.count)")
            context.write(self.wrapOutboundOut(.head(httpResponseHead(request: self.infoSavedRequestHead!, status: .ok, headers: headers))), promise: nil)
            context.write(self.wrapOutboundOut(.body(.byteBuffer(self.buffer))), promise: nil)
            self.completeResponse(context, trailers: nil, promise: nil)
        }
    }

    func handleEcho(context: ChannelHandlerContext, request: HTTPServerRequestPart) {
        self.handleEcho(context: context, request: request, balloonInMemory: false)
    }

    func handleEcho(context: ChannelHandlerContext, request: HTTPServerRequestPart, balloonInMemory: Bool = false) {
        switch request {
        case .head(let request):
            self.keepAlive = request.isKeepAlive
            self.infoSavedRequestHead = request
            self.state.requestReceived()
            if balloonInMemory {
                self.buffer.clear()
            } else {
                context.writeAndFlush(self.wrapOutboundOut(.head(httpResponseHead(request: request, status: .ok))), promise: nil)
            }
        case .body(buffer: var buf):
            if balloonInMemory {
                self.buffer.writeBuffer(&buf)
            } else {
                context.writeAndFlush(self.wrapOutboundOut(.body(.byteBuffer(buf))), promise: nil)
            }
        case .end:
            self.state.requestComplete()
            if balloonInMemory {
                var headers = HTTPHeaders()
                headers.add(name: "Content-Length", value: "\(self.buffer.readableBytes)")
                context.write(self.wrapOutboundOut(.head(httpResponseHead(request: self.infoSavedRequestHead!, status: .ok, headers: headers))), promise: nil)
                context.write(self.wrapOutboundOut(.body(.byteBuffer(self.buffer))), promise: nil)
                self.completeResponse(context, trailers: nil, promise: nil)
            } else {
                self.completeResponse(context, trailers: nil, promise: nil)
            }
        }
    }

    func handleJustWrite(context: ChannelHandlerContext, request: HTTPServerRequestPart, statusCode: HTTPResponseStatus = .ok, string: String, trailer: (String, String)? = nil, delay: TimeAmount = .nanoseconds(0)) {
        switch request {
        case .head(let request):
            self.keepAlive = request.isKeepAlive
            self.state.requestReceived()
            context.writeAndFlush(self.wrapOutboundOut(.head(httpResponseHead(request: request, status: statusCode))), promise: nil)
        case .body(buffer: _):
            ()
        case .end:
            self.state.requestComplete()
            context.eventLoop.scheduleTask(in: delay) { () -> Void in
                var buf = context.channel.allocator.buffer(capacity: string.utf8.count)
                buf.writeString(string)
                context.writeAndFlush(self.wrapOutboundOut(.body(.byteBuffer(buf))), promise: nil)
                var trailers: HTTPHeaders? = nil
                if let trailer = trailer {
                    trailers = HTTPHeaders()
                    trailers?.add(name: trailer.0, value: trailer.1)
                }

                self.completeResponse(context, trailers: trailers, promise: nil)
            }
        }
    }

    func handleContinuousWrites(context: ChannelHandlerContext, request: HTTPServerRequestPart) {
        switch request {
        case .head(let request):
            self.keepAlive = request.isKeepAlive
            self.continuousCount = 0
            self.state.requestReceived()
            func doNext() {
                self.buffer.clear()
                self.continuousCount += 1
                self.buffer.writeString("line \(self.continuousCount)\n")
                context.writeAndFlush(self.wrapOutboundOut(.body(.byteBuffer(self.buffer)))).map {
                    context.eventLoop.scheduleTask(in: .milliseconds(400), doNext)
                }.whenFailure { (_: Error) in
                    self.completeResponse(context, trailers: nil, promise: nil)
                }
            }
            context.writeAndFlush(self.wrapOutboundOut(.head(httpResponseHead(request: request, status: .ok))), promise: nil)
            doNext()
        case .end:
            self.state.requestComplete()
        default:
            break
        }
    }

    func handleMultipleWrites(context: ChannelHandlerContext, request: HTTPServerRequestPart, strings: [String], delay: TimeAmount) {
        switch request {
        case .head(let request):
            self.keepAlive = request.isKeepAlive
            self.continuousCount = 0
            self.state.requestReceived()
            func doNext() {
                self.buffer.clear()
                self.buffer.writeString(strings[self.continuousCount])
                self.continuousCount += 1
                context.writeAndFlush(self.wrapOutboundOut(.body(.byteBuffer(self.buffer)))).whenSuccess {
                    if self.continuousCount < strings.count {
                        context.eventLoop.scheduleTask(in: delay, doNext)
                    } else {
                        self.completeResponse(context, trailers: nil, promise: nil)
                    }
                }
            }
            context.writeAndFlush(self.wrapOutboundOut(.head(httpResponseHead(request: request, status: .ok))), promise: nil)
            doNext()
        case .end:
            self.state.requestComplete()
        default:
            break
        }
    }

    func dynamicHandler(request reqHead: HTTPRequestHead) -> ((ChannelHandlerContext, HTTPServerRequestPart) -> Void)? {
        if let howLong = reqHead.uri.chopPrefix("/dynamic/write-delay/") {
            return { context, req in
                self.handleJustWrite(context: context,
                                     request: req, string: self.defaultResponse,
                                     delay: Int64(howLong).map { .milliseconds($0) } ?? .seconds(0))
            }
        }

        switch reqHead.uri {
        case "/dynamic/echo":
            return self.handleEcho
        case "/dynamic/echo_balloon":
            return { self.handleEcho(context: $0, request: $1, balloonInMemory: true) }
        case "/dynamic/pid":
            return { context, req in self.handleJustWrite(context: context, request: req, string: "\(getpid())") }
        case "/dynamic/write-delay":
            return { context, req in self.handleJustWrite(context: context, request: req, string: self.defaultResponse, delay: .milliseconds(100)) }
        case "/dynamic/info":
            return self.handleInfo
        case "/dynamic/trailers":
            return { context, req in self.handleJustWrite(context: context, request: req, string: "\(getpid())\r\n", trailer: ("Trailer-Key", "Trailer-Value")) }
        case "/dynamic/continuous":
            return self.handleContinuousWrites
        case "/dynamic/count-to-ten":
            return { self.handleMultipleWrites(context: $0, request: $1, strings: (1...10).map { "\($0)" }, delay: .milliseconds(100)) }
        case "/dynamic/client-ip":
            return { context, req in self.handleJustWrite(context: context, request: req, string: "\(context.remoteAddress.debugDescription)") }
        default:
            return { context, req in self.handleJustWrite(context: context, request: req, statusCode: .notFound, string: "not found") }
        }
    }

    private func handleFile(context: ChannelHandlerContext, request: HTTPServerRequestPart, ioMethod: FileIOMethod, path: String) {
        self.buffer.clear()

        func sendErrorResponse(request: HTTPRequestHead, _ error: Error) {
            var body = context.channel.allocator.buffer(capacity: 128)
            let response = { () -> HTTPResponseHead in
                switch error {
                case let e as IOError where e.errnoCode == ENOENT:
                    body.writeStaticString("IOError (not found)\r\n")
                    return httpResponseHead(request: request, status: .notFound)
                case let e as IOError:
                    body.writeStaticString("IOError (other)\r\n")
                    body.writeString(e.description)
                    body.writeStaticString("\r\n")
                    return httpResponseHead(request: request, status: .notFound)
                default:
                    body.writeString("\(type(of: error)) error\r\n")
                    return httpResponseHead(request: request, status: .internalServerError)
                }
            }()
            body.writeString("\(error)")
            body.writeStaticString("\r\n")
            context.write(self.wrapOutboundOut(.head(response)), promise: nil)
            context.write(self.wrapOutboundOut(.body(.byteBuffer(body))), promise: nil)
            context.writeAndFlush(self.wrapOutboundOut(.end(nil)), promise: nil)
            context.channel.close(promise: nil)
        }

        func responseHead(request: HTTPRequestHead, fileRegion region: FileRegion) -> HTTPResponseHead {
            var response = httpResponseHead(request: request, status: .ok)
            response.headers.add(name: "Content-Length", value: "\(region.endIndex)")
            response.headers.add(name: "Content-Type", value: "text/html; charset=utf-8")
            return response
        }

        switch request {
        case .head(let request):
            guard !request.uri.containsDotDot() else {
                let response = httpResponseHead(request: request, status: .forbidden)
                context.write(self.wrapOutboundOut(.head(response)), promise: nil)
                self.completeResponse(context, trailers: nil, promise: nil)
                return
            }
            let path = self.htdocsPath + "/" + path
            let fileHandleAndRegion = self.fileIO.openFile(path: path, eventLoop: context.eventLoop)
            fileHandleAndRegion.whenFailure {
                sendErrorResponse(request: request, $0)
            }
            fileHandleAndRegion.whenSuccess { (file, region) in
                switch ioMethod {
                case .nonblockingFileIO:
                    var responseStarted = false
                    let response = responseHead(request: request, fileRegion: region)
                    if region.readableBytes == 0 {
                        responseStarted = true
                        context.write(self.wrapOutboundOut(.head(response)), promise: nil)
                    }
                    return self.fileIO.readChunked(fileRegion: region,
                                                   chunkSize: 32 * 1024,
                                                   allocator: context.channel.allocator,
                                                   eventLoop: context.eventLoop) { buffer in
                                                    if !responseStarted {
                                                        responseStarted = true
                                                        context.write(self.wrapOutboundOut(.head(response)), promise: nil)
                                                    }
                                                    return context.writeAndFlush(self.wrapOutboundOut(.body(.byteBuffer(buffer))))
                    }.flatMap { () -> EventLoopFuture<Void> in
                        let p = context.eventLoop.makePromise(of: Void.self)
                        self.completeResponse(context, trailers: nil, promise: p)
                        return p.futureResult
                    }.flatMapError { error in
                        if !responseStarted {
                            let response = httpResponseHead(request: request, status: .ok)
                            context.write(self.wrapOutboundOut(.head(response)), promise: nil)
                            var buffer = context.channel.allocator.buffer(capacity: 100)
                            buffer.writeString("fail: \(error)")
                            context.write(self.wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
                            self.state.responseComplete()
                            return context.writeAndFlush(self.wrapOutboundOut(.end(nil)))
                        } else {
                            return context.close()
                        }
                    }.whenComplete { (_: Result<Void, Error>) in
                        _ = try? file.close()
                    }
                case .sendfile:
                    let response = responseHead(request: request, fileRegion: region)
                    context.write(self.wrapOutboundOut(.head(response)), promise: nil)
                    context.writeAndFlush(self.wrapOutboundOut(.body(.fileRegion(region)))).flatMap {
                        let p = context.eventLoop.makePromise(of: Void.self)
                        self.completeResponse(context, trailers: nil, promise: p)
                        return p.futureResult
                    }.flatMapError { (_: Error) in
                        context.close()
                    }.whenComplete { (_: Result<Void, Error>) in
                        _ = try? file.close()
                    }
                }
        }
        case .end:
            self.state.requestComplete()
        default:
            fatalError("oh noes: \(request)")
        }
    }

    private func completeResponse(_ context: ChannelHandlerContext, trailers: HTTPHeaders?, promise: EventLoopPromise<Void>?) {
        self.state.responseComplete()

        let promise = self.keepAlive ? promise : (promise ?? context.eventLoop.makePromise())
        if !self.keepAlive {
            promise!.futureResult.whenComplete { (_: Result<Void, Error>) in context.close(promise: nil) }
        }
        self.handler = nil

        context.writeAndFlush(self.wrapOutboundOut(.end(trailers)), promise: promise)
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        
        let reqPart = self.unwrapInboundIn(data)
        
        switch reqPart {
        case .head(let request):
            
            // Set up response callback
            func responseCallback(status: HTTPResponseStatus = .ok, data: Data) {
                self.state.requestComplete()
                
                let responseHead = httpResponseHead(request: request, status: status)
                // TODO: add any headers
                context.write(self.wrapOutboundOut(.head(responseHead)), promise: nil) // writeAndFlush?
                
                var responseBuffer = context.channel.allocator.buffer(capacity: data.count)
                responseBuffer.writeBytes(data)
                context.write(self.wrapOutboundOut(.body(.byteBuffer(responseBuffer))), promise: nil)
                
                self.completeResponse(context, trailers: nil, promise: nil)
            }
            
            /// Examine request to determine endpoint handler, return once one is found
            func setHandler() {
                
                // Loop through Account Transaction resources
                for accountTransactionResourceVariety in AccountTransactionResourceVariety.allCases {
                    
                    // GET {Account Transaction resource}
                    if
                        let regexMatch = request.uri.matchesRegex(regex: try! NSRegularExpression(
                            pattern: accountTransactionResourceVariety.urlRegexGetResource()
                            )),
                        let accountAccessConsentID = getSingleValuedHeader(fieldName: "x-obc-account-access-consent-id", headers: request.headers),
                        request.method == .GET
                    {
                        self.handler = { endpointHandlerGetOBATResource(
                            context: $0,
                            request: $1,
                            obatResourceType: accountTransactionResourceVariety,
                            regexMatch: regexMatch,
                            accountAccessConsentID: accountAccessConsentID,
                            responseCallback: responseCallback
                            )}
                        return
                    }
                }
                
                // Loop through Account Transaction Request OB objects
                for accountTransactionRequestObjectVariety in AccountTransactionRequestObjectVariety.allCases {
                    
                    // POST {Account Transaction request OB object}
                    if
                        let regexMatch = request.uri.matchesRegex(regex: try! NSRegularExpression(
                            pattern: accountTransactionRequestObjectVariety.urlRegexPostObject()
                            )),
                        let obClientProfileID = getSingleValuedHeader(fieldName: "x-obc-ob-client-id", headers: request.headers),
                        request.method == .POST
                    {
                        self.buffer.clear()
                        self.handler = { endpointHandlerPostAccountTransactionRequestObject(
                            context: $0,
                            request: $1,
                            requestObjectVariety: accountTransactionRequestObjectVariety,
                            regexMatch: regexMatch,
                            obClientProfileID: obClientProfileID,
                            responseCallback: responseCallback,
                            buffer: &self.buffer
                            )}
                        return
                    }
                }
                
                // Loop through Payment Initiation payment consent objects
                for paymentInitiationPaymentVariety in
                    PaymentInitiationPaymentVariety.allCases {
                    
                    // POST {Payment Initiation payment consent}
                    if
                        let regexMatch = request.uri.matchesRegex(regex: try! NSRegularExpression(
                            pattern: paymentInitiationPaymentVariety.urlRegexPostPaymentConsent()
                            )),
                        let obClientProfileID = getSingleValuedHeader(fieldName: "x-obc-ob-client-id", headers: request.headers),
                        request.method == .POST
                    {
                        self.buffer.clear()
                        self.handler = { endpointHandlerPostPaymentInitiationConsent(
                            context: $0,
                            request: $1,
                            requestObjectVariety: paymentInitiationPaymentVariety,
                            regexMatch: regexMatch,
                            obClientProfileID: obClientProfileID,
                            responseCallback: responseCallback,
                            buffer: &self.buffer
                            )}
                        return
                    }
                }

                // Loop through Payment Initiation payment objects
                for paymentInitiationPaymentVariety in
                    PaymentInitiationPaymentVariety.allCases {

                    // POST {Payment Initiation payment}
                    if
                        let regexMatch = request.uri.matchesRegex(regex: try! NSRegularExpression(
                            pattern: paymentInitiationPaymentVariety.urlRegexPostPayment()
                            )),
                        let paymentInitiationConsentID = getSingleValuedHeader(fieldName: "x-obc-consent-id", headers: request.headers),
                        request.method == .POST
                    {
                        self.buffer.clear()
                        self.handler = {
                            endpointHandlerPostPaymentInitiationPayment(
                                context: $0,
                                request: $1,
                                requestObjectVariety: paymentInitiationPaymentVariety,
                                regexMatch: regexMatch,
                                paymentInitiationConsentID: paymentInitiationConsentID,
                                responseCallback: responseCallback,
                                buffer: &self.buffer
                            )}
                        return
                    }
                }
            }
            
            // Validate request and assign handler
            let httpMethod = request.method
            if let path = request.uri.chopPrefix("/software-statement-profiles") {
                self.buffer.clear()
                self.handler = {
                    routeHandlerSoftwareStatementProfiles(
                        context: $0, request: $1, httpMethod: httpMethod, path: path, responseCallback: responseCallback,
                        buffer: &self.buffer
                    )
                }
            } else if let path = request.uri.chopPrefix("/register") {
                if
                    path == "",
                    httpMethod == .POST
                {
                    self.buffer.clear()
                    self.handler = { endpointHandlerPostRegister(
                        context: $0,
                        request: $1,
                        responseCallback: responseCallback,
                        buffer: &self.buffer
                        )}
                }
            } else if let path = request.uri.chopPrefix("/auth") {
                if path == "/fragment-redirect",
                    httpMethod == .GET
                {
                    self.handler = { self.handleFile(context: $0, request: $1, ioMethod: .nonblockingFileIO, path: "/auth-fragment-redirect.html")
                    }
                } else {
                    self.buffer.clear()
                    self.handler = { routeHandlerAuth(
                        context: $0, request: $1, httpMethod: httpMethod, path: path, responseCallback: responseCallback,
                        buffer: &self.buffer
                        )}
                }
            } else {
                setHandler()
            }
            
            if let handler = self.handler {
                self.keepAlive = request.isKeepAlive
                self.state.requestReceived()
                handler(context, reqPart)
            }
            
        case .body:
            
            if let handler = self.handler {
                handler(context, reqPart)
            }
            
        case .end:
            
            if let handler = self.handler {
                handler(context, reqPart)
            }
        }
    }

    func channelReadComplete(context: ChannelHandlerContext) {
        context.flush()
    }

    func handlerAdded(context: ChannelHandlerContext) {
        self.buffer = context.channel.allocator.buffer(capacity: 0)
    }

    func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
        switch event {
        case let evt as ChannelEvent where evt == ChannelEvent.inputClosed:
            // The remote peer half-closed the channel. At this time, any
            // outstanding response will now get the channel closed, and
            // if we are idle or waiting for a request body to finish we
            // will close the channel immediately.
            switch self.state {
            case .idle, .waitingForRequestBody:
                context.close(promise: nil)
            case .sendingResponse:
                self.keepAlive = false
            }
        default:
            context.fireUserInboundEventTriggered(event)
        }
    }
}

// First argument is the program path
var arguments = CommandLine.arguments.dropFirst(0) // just to get an ArraySlice<String> from [String]
var allowHalfClosure = true
if arguments.dropFirst().first == .some("--disable-half-closure") {
    allowHalfClosure = false
    arguments = arguments.dropFirst()
}
let arg1 = arguments.dropFirst().first
let arg2 = arguments.dropFirst(2).first
let arg3 = arguments.dropFirst(3).first

let defaultHost = "::1"
let defaultPort = 8888

let projectRootPath: String

enum BindTo {
    case ip(host: String, port: Int)
    case unixDomainSocket(path: String)
}

let bindTarget: BindTo

switch (arg1, arg1.flatMap(Int.init), arg2, arg2.flatMap(Int.init), arg3) {
case (.some(let h), _ , _, .some(let p), let shouldBeProjectRootPath):
    /* second arg an integer --> host port path */
    bindTarget = .ip(host: h, port: p)
    guard let projectRootPathTmp = shouldBeProjectRootPath else {
        fatalError("Second arg detected as Int (fine). But third arg not detectable as project root folder path (not fine).")
    }
    projectRootPath = projectRootPathTmp
case (_, .some(let p), let shouldBeProjectRootPath, _, _):
    /* first arg an integer --> port path */
    bindTarget = .ip(host: defaultHost, port: p)
    guard let projectRootPathTmp = shouldBeProjectRootPath else {
        fatalError("First but not second arg detected as Int (fine). But second arg not detectable as project root folder path (not fine).")
    }
    projectRootPath = projectRootPathTmp
case (let shouldBeProjectRootPath, _, _, _, _):
    /* no integers --> path */
    bindTarget = BindTo.ip(host: defaultHost, port: defaultPort)
    guard let projectRootPathTmp = shouldBeProjectRootPath else {
        fatalError("First and second arguments not detected as Int (fine). But first arg not detectable as project root folder path (not fine).")
    }
    projectRootPath = projectRootPathTmp
}

let htdocs = projectRootPath + "/Sources/OpenBankingConnector/HTTPDocs"

let logLevel: Logger.Level
#if DEBUG
logLevel = .debug
#else
logLevel = .info
#endif
LoggingSystem.bootstrap { label in
    var handler = StreamLogHandler.standardOutput(label: label)
    handler.logLevel = logLevel
    return handler
}

// Create event loop group and thread pool
let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
let threadPool = NIOThreadPool(numberOfThreads: 6)
threadPool.start()

// Create storage manager and database tables
let sm = StorageManager(
    file: projectRootPath + "/db.sqlite3",
    threadPool: threadPool
)
try! sm.createTables(
    dropTables: false,
    on: eventLoopGroup.next()
).wait()

// Create HTTP client manager
let hcm = HTTPClientManager(
    httpClientEventLoop: eventLoopGroup.next()
)

// Bootstrap HTTP server
let fileIO = NonBlockingFileIO(threadPool: threadPool)
let bootstrap = ServerBootstrap(group: eventLoopGroup)
    // Specify backlog and enable SO_REUSEADDR for the server itself
    .serverChannelOption(ChannelOptions.backlog, value: 256)
    .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

    // Set the handlers that are applied to the accepted Channels
    .childChannelInitializer { channel in
        channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).flatMap {
            channel.pipeline.addHandler(HTTPHandler(fileIO: fileIO, htdocsPath: htdocs))
        }
    }

    // Enable SO_REUSEADDR for the accepted Channels
    .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)
    .childChannelOption(ChannelOptions.allowRemoteHalfClosure, value: allowHalfClosure)
defer {
    try! eventLoopGroup.syncShutdownGracefully()
    try! threadPool.syncShutdownGracefully()
}

let channel = try { () -> Channel in
    switch bindTarget {
    case .ip(let host, let port):
        return try bootstrap.bind(host: host, port: port).wait()
    case .unixDomainSocket(let path):
        return try bootstrap.bind(unixDomainSocketPath: path).wait()
    }
}()

guard let localAddress = channel.localAddress else {
    fatalError("Address was unable to bind. Please check that the socket was not closed or that the address family was understood.")
}
print("Server started and listening on \(localAddress), project root path \(projectRootPath)")

// This will never unblock as we don't close the ServerChannel
try channel.closeFuture.wait()

print("Server closed")
