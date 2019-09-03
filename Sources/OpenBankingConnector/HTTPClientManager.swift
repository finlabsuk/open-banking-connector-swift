// ********************************************************************************
//
// This source file is part of the Open Banking Connector project.
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
import SQLKit

// Reference to singleton for convenient access
let hcm = HTTPClientManager.shared

struct HTTPClientMTLSConfiguration: Hashable {
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

    func executeMTLS(
        request: HTTPClient.Request,
        softwareStatementId: String,
        httpClientMTLSConfigurationOverrides: HTTPClientMTLSConfigurationOverrides?,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<HTTPClient.Response> {
        let httpClientMTLSConfiguration = HTTPClientMTLSConfiguration(
            softwareStatementId: softwareStatementId,
            overrides: httpClientMTLSConfigurationOverrides
        )
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
