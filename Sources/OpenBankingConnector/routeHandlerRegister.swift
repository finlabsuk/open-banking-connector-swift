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
            var obClientRegistrationClaims: OBClientRegistrationClaims!
            
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
                
                // Load relevant OB clients that already exist
                .flatMap({ obClientRegistrationClaimsTmp -> EventLoopFuture<[OBClient]> in
                    obClientRegistrationClaims = obClientRegistrationClaimsTmp
                    return OBClient.load(
                        id: nil,
                        softwareStatementProfileId: softwareStatementProfileId,
                        issuerURL: issuerURL
                    )
                })
                
                // If any has same registration claims, use that else create and save new OB client
                .flatMap({obClientArray -> EventLoopFuture<Void> in
                    //print(obClientRegistrationClaims)
                    var haveMatch = false
                    for obClient in obClientArray {
                        if obClient.registrationClaims == obClientRegistrationClaims {
                            haveMatch = true
                        }
                    }
                    //print("HaveMatch: \(haveMatch)")
                    if haveMatch {
                        return context.eventLoop.makeSucceededFuture(())
                    } else {
                        
                        // Post OB client registration claims
                        return obClientRegistrationClaims.httpPost(
                            softwareStatementProfileId: softwareStatementProfileId,
                            softwareStatementId: softwareStatementProfileId,
                            issuerURL: issuerURL,
                            issuerRegistrationURL: issuerRegistrationEndpoint,
                            httpClientMTLSConfigurationOverrides: aspspOverrides?.httpClientMTLSConfigurationOverrides,
                            obClientRegistrationResponseOverrides: aspspOverrides?.obClientRegistrationResponseOverrides
                        )
                            // Save OB client
                            .flatMap({
                                obClient in obClient.insert()
                            })
                    }
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




