// ********************************************************************************
//
// This source file is part of the Open Banking Connector project
// ( https://github.com/finlabsuk/open-banking-connector ).
//
// Copyright (C) 2019 Finnovation Labs and the Open Banking Connector project authors.
//
// Licensed under Apache License v2.0. See LICENSE.txt for licence information.
// SPDX-License-Identifier: Apache-2.0
//
// ********************************************************************************

import Foundation
import AsyncHTTPClient
import NIO
import NIOSSL
import NIOHTTP1
import SQLKit

// Reference to singleton for convenient access
let hcm = HTTPClientManager.shared

extension NIORenegotiationSupport: RawRepresentable {
    public typealias RawValue = String
    public init?(rawValue: String) {
        switch rawValue {
        case "none": self = .none
        case "once": self = .once
        case "always": self = .always
        default: return nil
        }
    }
    public var rawValue: String {
        switch self {
        case .none: return "none"
        case .once: return "once"
        case .always: return "always"
        }
    }
}
extension NIORenegotiationSupport: Codable { }

extension CertificateVerification: RawRepresentable {
    public typealias RawValue = String
    public init?(rawValue: String) {
        switch rawValue {
        case "none": self = .none
        case "noHostnameVerification": self = .noHostnameVerification
        case "fullVerification": self = .fullVerification
        default: return nil
        }
    }
    public var rawValue: String {
        switch self {
        case .none: return "none"
        case .noHostnameVerification: return "noHostnameVerification"
        case .fullVerification: return "fullVerification"
        }
    }
}
extension CertificateVerification: Codable { }

struct HTTPClientMTLSConfiguration: Hashable, Codable {
    let softwareStatementId: String
    var tlsCertificateVerification: CertificateVerification = .fullVerification
    var tlsRenegotiationSupport: NIORenegotiationSupport = .none
    init( // TODO: Remove after Swift 5.1
        softwareStatementId: String
    ) {
        self.softwareStatementId = softwareStatementId
    }
    mutating func applyOverrides(overrides: HTTPClientMTLSConfigurationOverrides?) {
        if let overrides = overrides {
            if let newValue = overrides.tlsCertificateVerification {
                tlsCertificateVerification = newValue
            }
            if let newValue = overrides.tlsRenegotiationSupport {
                tlsRenegotiationSupport = newValue
            }
        }
    }
}

extension HTTPClientMTLSConfiguration {
    init(
        softwareStatementId: String,
        overrides: HTTPClientMTLSConfigurationOverrides?
    ) {
        self.init(softwareStatementId: softwareStatementId)
        self.applyOverrides(overrides: overrides)
    }
}

// Read-only "dictionary" which returns HTTPClient with correct MTLS based on software statement ID
final class HttpClientsMTLS { // class rather than struct to allow mutable capture of self in callbacks
    
    private var dict = [HTTPClientMTLSConfiguration: HTTPClient]()
    
    private func createClient(httpClientMTLSConfiguration: HTTPClientMTLSConfiguration) -> EventLoopFuture<HTTPClient> {
        
        return SoftwareStatementProfile.load(id: httpClientMTLSConfiguration.softwareStatementId)
            .flatMapThrowing({ softwareStatement -> HTTPClient in
                let transportKey = try NIOSSLPrivateKey(
                    bytes: Array(softwareStatement.obTransportKey.utf8),
                    format: .pem
                )
                let transportCertificates = try NIOSSLCertificate.fromPEMBytes(
                    Array(softwareStatement.obTransportPem.utf8)
                )
                
                var tlsConfiguration = TLSConfiguration.forClient()
                tlsConfiguration.trustRoots = .file("/Users/mark/GitHub/api/statements/obca.pem") // TODO: insert path to OB certificate
                tlsConfiguration.privateKey = .privateKey(transportKey)
                tlsConfiguration.certificateChain = [.certificate(transportCertificates[0])]
                tlsConfiguration.certificateVerification = httpClientMTLSConfiguration.tlsCertificateVerification
                tlsConfiguration.renegotiationSupport = httpClientMTLSConfiguration.tlsRenegotiationSupport
                
                let httpClientConfiguration = HTTPClient.Configuration(tlsConfiguration: tlsConfiguration)
                
                let client = HTTPClient(
                    eventLoopGroupProvider: .shared(eventLoopGroup),
                    configuration: httpClientConfiguration
                )
                self.dict[httpClientMTLSConfiguration] = client
                
                return client
            })
        
    }
    
    func getHTTPClientMTLS(
        httpClientMTLSConfiguration: HTTPClientMTLSConfiguration,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
        ) -> EventLoopFuture<HTTPClient> {
        
        // Create future on correct event loop and then hop back
        return httpClientEventLoop
            .makeSucceededFuture(())
            .flatMapThrowing({ [self] _ in
                if let client = self.dict[httpClientMTLSConfiguration] {
                    return client
                }
                throw "No client exists"
            })
            .flatMapError({ [self] _ in
                self.createClient(httpClientMTLSConfiguration: httpClientMTLSConfiguration)
            })
            .hop(to: eventLoop)
    }
}

final class HTTPClientManager {
    
    static var shared = HTTPClientManager()
    
    let jsonEncoderDateFormatISO8601WithSeconds: JSONEncoder = JSONEncoder()
    let jsonDecoderDateFormatISO8601WithSeconds: JSONDecoder = JSONDecoder()
    
    let jsonEncoderDateFormatISO8601WithMilliSeconds: JSONEncoder = JSONEncoder()
    let jsonDecoderDateFormatISO8601WithMilliSeconds: JSONDecoder = JSONDecoder()
    
    let jsonEncoderDateFormatSecondsSince1970: JSONEncoder = JSONEncoder()
    let jsonDecoderDateFormatSecondsSince1970: JSONDecoder = JSONDecoder()

    let jsonEncoderDateFormatMilliSecondsSince1970: JSONEncoder = JSONEncoder()
    let jsonDecoderDateFormatMilliSecondsSince1970: JSONDecoder = JSONDecoder()
    
    init() {
        
        jsonEncoderDateFormatISO8601WithSeconds.dateEncodingStrategy = .iso8601
        jsonDecoderDateFormatISO8601WithSeconds.dateDecodingStrategy = .iso8601
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        jsonEncoderDateFormatISO8601WithMilliSeconds.dateEncodingStrategy = .custom({ (date, encoder) in
            var container = encoder.singleValueContainer()
            try container.encode(dateFormatter.string(from: date))
        })
        jsonDecoderDateFormatISO8601WithMilliSeconds.dateDecodingStrategy = .custom({decoder in
            let value = try decoder.singleValueContainer()
            let stringValue = try value.decode(String.self)
            guard let date = dateFormatter.date(from: stringValue) else {
                throw "Can't convert from String to Date"
            }
            return date
        })
        
        jsonEncoderDateFormatSecondsSince1970.dateEncodingStrategy = .deferredToDate
        //jsonEncoderDateFormatSecondsSince1970.outputFormatting = .withoutEscapingSlashes
        jsonDecoderDateFormatSecondsSince1970.dateDecodingStrategy = .secondsSince1970

        jsonEncoderDateFormatMilliSecondsSince1970.dateEncodingStrategy = .deferredToDate
        jsonDecoderDateFormatMilliSecondsSince1970.dateDecodingStrategy = .millisecondsSince1970

    }
    
    let clientNoMTLS = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
    
    var clientsMTLS = HttpClientsMTLS()
    
    func getRequestStd(url: URL) -> HTTPClient.Request {
        return try! HTTPClient.Request(
            url: url,
            method: .GET,
            headers: [
                "Cache-Control": "no-cache",
                "Accept": "application/json"
        ])
    }
    
    func postRequestRegistration(url: URL) -> HTTPClient.Request {
        return try! HTTPClient.Request(
            url: url,
            method: .POST,
            headers: [
                "Cache-Control": "no-cache",
                "Content-Type": "application/jwt",
                "Accept": "application/json"
        ])
    }
    
    func postRequest(url: URL, xFapiFinancialId: String?, authHeader: String?, isFormUrlencoded: Bool = false) -> HTTPClient.Request {
        let headers = [
            "Cache-Control": "no-cache",
            "x-fapi-financial-id": xFapiFinancialId,
            "Authorization": authHeader,
            "Content-Type": isFormUrlencoded ? "application/x-www-form-urlencoded" : "application/json",
            "Accept": "application/json"
            ]
            .filter { $1 != nil } // remove Authorization or x-fapi-financial-id if values nil
            .map { ($0, $1!) } // force unwrap
        return try! HTTPClient.Request(
            url: url,
            method: .POST,
            headers: HTTPHeaders(headers)
        )
    }
    
    func executeMTLS(
        request: HTTPClient.Request,
        httpClientMTLSConfiguration: HTTPClientMTLSConfiguration,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<HTTPClient.Response> {
        return clientsMTLS.getHTTPClientMTLS(
            httpClientMTLSConfiguration: httpClientMTLSConfiguration,
            on: eventLoop
        )
            .flatMap({ httpClient in
                return httpClient.execute(request: request, eventLoop: .prefers(eventLoop))
            })
            .hop(to: eventLoop)
    }
    
}
