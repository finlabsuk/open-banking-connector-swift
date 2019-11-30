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

func endpointHandlerPostRegister(
    context: ChannelHandlerContext,
    request: HTTPServerRequestPart,
    responseCallback: @escaping (HTTPResponseStatus, Data) -> Void,
    buffer: inout ByteBuffer
) {
    
    switch request {
    case .head: break;
    case .body(buffer: var buf):
        buffer.writeBuffer(&buf)
    case .end:
        
        // Validate body data
        let obClientProfileConfiguration: OBClientProfilePublic
        do {
            let data = buffer.readData(length: buffer.readableBytes)!
            obClientProfileConfiguration = try hcm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(OBClientProfilePublic.self, from: data)
            print(obClientProfileConfiguration)
        } catch {
            print(error)
            responseCallback(.badRequest, try! JSONEncoder().encode("\(error)"))
            return
        }
        
        var openIDConfiguration: OpenIDConfiguration!
        var obClientRegistrationClaims: OBClientRegistrationClaims!
        
        context.eventLoop.makeSucceededFuture(())
            
            // Get OpenID configuration from well-known endpoint for issuer URL
            .flatMap({ OpenIDConfiguration.httpGet(
                issuerURL: obClientProfileConfiguration.issuerURL,
                overrides: obClientProfileConfiguration.openIDConfigurationOverrides
                )
            })
            
            // Create OB client registration claims
            .flatMap({ openIDConfigurationLocal -> EventLoopFuture<OBClientRegistrationClaims> in
                openIDConfiguration = openIDConfigurationLocal
                return OBClientRegistrationClaims.initAsync(
                    issuerURL: obClientProfileConfiguration.issuerURL,
                    softwareStatementId: obClientProfileConfiguration.softwareStatementProfileID,
                    overrides: obClientProfileConfiguration.obClientRegistrationClaimsOverrides
                )
            })
            
            // Load relevant OB clients that already exist
            .flatMap({ obClientRegistrationClaimsTmp -> EventLoopFuture<[OBClientProfile]> in
                obClientRegistrationClaims = obClientRegistrationClaimsTmp
                return OBClientProfile.load(
                    id: nil,
                    softwareStatementProfileId: obClientProfileConfiguration.softwareStatementProfileID,
                    issuerURL: obClientProfileConfiguration.issuerURL
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
                        softwareStatementProfileId: obClientProfileConfiguration.softwareStatementProfileID,
                        softwareStatementId: obClientProfileConfiguration.softwareStatementProfileID,
                        issuerURL: obClientProfileConfiguration.issuerURL,
                        xFapiFinancialId: obClientProfileConfiguration.xFapiFinancialID,
                        accountTransactionAPIVersion: obClientProfileConfiguration.accountTransactionAPIVersion,
                        accountTransactionAPIBaseURL: obClientProfileConfiguration.accountTransactionAPIBaseURL,
                        paymentInitiationAPIVersion: obClientProfileConfiguration.paymentInitiationAPIVersion,
                        paymentInitiationAPIBaseURL: obClientProfileConfiguration.paymentInitiationAPIBaseURL,
                        httpClientMTLSConfigurationOverrides: obClientProfileConfiguration.httpClientMTLSConfigurationOverrides,
                        obClientRegistrationResponseOverrides: obClientProfileConfiguration.obClientRegistrationResponseOverrides,
                        obAccountTransactionAPISettingsOverrides: obClientProfileConfiguration.obAccountTransactionAPISettingsOverrides,
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
        
    }
}




