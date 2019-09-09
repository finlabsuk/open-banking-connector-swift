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
    responseCallback: @escaping (HTTPResponseStatus, Data) -> Void,
    issuerURL: String,
    xFapiFinancialId: String,
    softwareStatementProfileId: String,
    obBaseURL: String,
    obAccountAndTransactionAPIVersion: String
    ) {
    
    // Wait until request fully received
    if case .end = request {
        
        switch (httpMethod, path) {
        case (.POST, ""):
            
            let aspspOverrides = getASPSPOverrides(issuerURL: issuerURL)
            var openIDConfiguration: OpenIDConfiguration!
            var obClientRegistrationClaims: OBClientRegistrationClaims!
            
            context.eventLoop.makeSucceededFuture(())
                
                // Get OpenID configuration from well-known endpoint for issuer URL
                .flatMap({ OpenIDConfiguration.httpGet(
                    issuerURL: issuerURL,
                    overrides: aspspOverrides?.openIDConfigurationOverrides
                    )
                })
                
                // Create OB client registration claims
                .flatMap({ openIDConfigurationLocal -> EventLoopFuture<OBClientRegistrationClaims> in
                    openIDConfiguration = openIDConfigurationLocal
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
                .flatMap({obClientArray -> EventLoopFuture<String> in
                    //print(obClientRegistrationClaims)
                    var obClientId: String?
                    for obClient in obClientArray {
                        if obClient.registrationClaims == obClientRegistrationClaims {
                            obClientId = obClient.id
                        }
                    }
                    //print("HaveMatch: \(haveMatch)")
                    if let obClientIdUnwrapped = obClientId {
                        return context.eventLoop.makeSucceededFuture(obClientIdUnwrapped)
                    } else {
                        
                        // Post OB client registration claims
                        return obClientRegistrationClaims.httpPost(
                            softwareStatementProfileId: softwareStatementProfileId,
                            softwareStatementId: softwareStatementProfileId,
                            issuerURL: issuerURL,
                            xFapiFinancialId: xFapiFinancialId,
                            obAccountTransactionBaseURL: obBaseURL,
                            aspspOverrides: aspspOverrides,
                            openIDConfiguration: openIDConfiguration
                        )
                            // Save OB client
                            .flatMap({
                                obClient in
                                obClientId = obClient.id
                                return obClient.insert()
                            })
                            .flatMapThrowing {
                                return obClientId!
                        }
                    }
                })
                
                // Send success response
                .flatMapThrowing({ obClientId in
                    struct ReturnType: Encodable { let id: String }
                    let returnJson = try! JSONEncoder().encode(ReturnType(id: obClientId))
                    responseCallback(.created, returnJson)
                })
                
                // Send failure response
                .whenFailure({error in
                    struct ReturnType: Encodable { let error: String }
                    let returnJson = try! JSONEncoder().encode(ReturnType(error: "\(error)"))
                    responseCallback(.internalServerError, returnJson)
                })
            
        default: break;
        }
    }
}




