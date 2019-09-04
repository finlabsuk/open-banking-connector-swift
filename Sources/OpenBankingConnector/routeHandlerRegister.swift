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
import NIO
import NIOHTTP1
import NIOFoundationCompat
import AsyncHTTPClient
import SQLKit

let decoder = JSONDecoder()

func routeHandlerRegister(
    context: ChannelHandlerContext,
    request: HTTPServerRequestPart,
    httpMethod: HTTPMethod,
    path: String,
    responseCallback: @escaping (HTTPResponseStatus, String) -> Void,
    issuerURL: String,
    softwareStatementProfileId: String
    ) {
    
    // Wait until request fully received
    if case .end = request {
        
        switch (httpMethod, path) {
        case (.POST, ""):
            
            let aspspOverrides = getASPSPOverrides(issuerURL: issuerURL)
            var issuerRegistrationEndpoint: String!
            
            context.eventLoop.makeSucceededFuture(())
                
                // Get OpenID configuration from well-known endpoint for issuer URL
                .flatMap({ OpenIDConfiguration.httpGet(
                    issuerURL: issuerURL,
                    overrides: aspspOverrides?.openIDConfigurationOverrides
                    )
                })
                
                // Create OB client registration claims
                .flatMap({ openIDConfiguration -> EventLoopFuture<OBClientRegistrationClaims> in
                    issuerRegistrationEndpoint = openIDConfiguration.registration_endpoint
                    return OBClientRegistrationClaims.initAsync(
                        issuerURL: issuerURL,
                        softwareStatementId: softwareStatementProfileId,
                        overrides: aspspOverrides?.obClientRegistrationClaimsOverrides
                    )
                })
                
                // TODO: Check if client with same claims already exists
                
                // Post OB client registration claims
                .flatMap({ obClientRegistrationClaims -> EventLoopFuture<OBClient> in
                    return obClientRegistrationClaims.httpPost(
                        issuerRegistrationURL: issuerRegistrationEndpoint,
                        softwareStatementId: softwareStatementProfileId,
                        httpClientMTLSConfigurationOverrides: aspspOverrides?.httpClientMTLSConfigurationOverrides,
                        obClientRegistrationResponseOverrides: aspspOverrides?.obClientRegistrationResponseOverrides
                    )
                })
                
                // Save OB client
                .flatMap({
                    obClient in obClient.insert()
                })
                
                // Send success response
                .flatMapThrowing({
                    responseCallback(.created, "Success text")
                })
                
                // Send failure response
                .whenFailure({
                    error in responseCallback(.internalServerError, "\(error)")
                })
            
        default: break;
        }
    }
}




