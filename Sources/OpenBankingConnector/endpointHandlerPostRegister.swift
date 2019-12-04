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
    
    // Buffer body of request
    switch request {
    case .head: break;
    case .body(buffer: var buf):
        buffer.writeBuffer(&buf)
    case .end:
        
        // Validate request data
        let obClientProfilePublic: OBClientProfilePublic
        do {
            let data = buffer.readData(length: buffer.readableBytes)!
            if data.isEmpty {
                throw("No body data received in request")
            }
            obClientProfilePublic = try hcm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(OBClientProfilePublic.self, from: data)
        } catch {
            let errorBody = ErrorPublic(error: "\(error)")
            responseCallback(
                .badRequest,
                try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(errorBody)
            )
            return
        }
        
        var openIDConfiguration: OpenIDConfiguration!
        var obClientRegistrationClaims: OBClientRegistrationClaims!
        
        context.eventLoop.makeSucceededFuture(())
            
            // Get OpenID configuration from well-known endpoint for issuer URL
            .flatMap({ OpenIDConfiguration.httpGet(
                issuerURL: obClientProfilePublic.issuerURL,
                overrides: obClientProfilePublic.openIDConfigurationOverrides
                )
            })
            
            // Create OB client registration claims
            .flatMap({ openIDConfigurationLocal -> EventLoopFuture<OBClientRegistrationClaims> in
                openIDConfiguration = openIDConfigurationLocal
                return OBClientRegistrationClaims.initAsync(
                    issuerURL: obClientProfilePublic.issuerURL,
                    softwareStatementId: obClientProfilePublic.softwareStatementProfileID,
                    overrides: obClientProfilePublic.obClientRegistrationClaimsOverrides
                )
            })
            
            // Load relevant OB clients that already exist
            .flatMap({ obClientRegistrationClaimsTmp -> EventLoopFuture<[OBClientProfile]> in
                obClientRegistrationClaims = obClientRegistrationClaimsTmp
                return OBClientProfile.load(
                    id: nil,
                    softwareStatementProfileId: obClientProfilePublic.softwareStatementProfileID,
                    issuerURL: obClientProfilePublic.issuerURL
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
                        softwareStatementProfileId: obClientProfilePublic.softwareStatementProfileID,
                        softwareStatementId: obClientProfilePublic.softwareStatementProfileID,
                        issuerURL: obClientProfilePublic.issuerURL,
                        xFapiFinancialId: obClientProfilePublic.xFapiFinancialID,
                        accountTransactionAPIVersion: obClientProfilePublic.accountTransactionAPIVersion,
                        accountTransactionAPIBaseURL: obClientProfilePublic.accountTransactionAPIBaseURL,
                        paymentInitiationAPIVersion: obClientProfilePublic.paymentInitiationAPIVersion,
                        paymentInitiationAPIBaseURL: obClientProfilePublic.paymentInitiationAPIBaseURL,
                        httpClientMTLSConfigurationOverrides: obClientProfilePublic.httpClientMTLSConfigurationOverrides,
                        obClientRegistrationResponseOverrides: obClientProfilePublic.obClientRegistrationResponseOverrides,
                        obAccountTransactionAPISettingsOverrides: obClientProfilePublic.obAccountTransactionAPISettingsOverrides,
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
                let successBody = OBClientProfileResponsePublic(id: obClientId)
                responseCallback(
                    .created,
                    try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(successBody)
                )
            })
            
            // Send failure response
            .whenFailure({ error in
                let errorBody = ErrorPublic(error: "\(error)")
                responseCallback(
                    .internalServerError,
                    try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(errorBody)
                )
                return
            })
        
    }
}
