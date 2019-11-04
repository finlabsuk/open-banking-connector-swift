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
import AccountTransactionTypes
import AccountTransactionTypeRequirements

func endpointHandlerPostAccountTransactionRequestObject(
    context: ChannelHandlerContext,
    request: HTTPServerRequestPart,
    requestObjectVariety: AccountTransactionRequestObjectVariety,
    regexMatch: [String],
    obClientProfileID: String,
    responseCallback: @escaping (HTTPResponseStatus, Data) -> Void,
    buffer: inout ByteBuffer
) {

    // Buffer body of request
    switch request {
    case .head: break;
    case .body(buffer: var buf):
        buffer.writeBuffer(&buf)
    case .end:
        
        let bufferData = buffer.readData(length: buffer.readableBytes)!
        var obClientProfile: OBClientProfile!

        context.eventLoop.makeSucceededFuture(())
            
            // Load OB client
            .flatMap({ OBClientProfile.load(
                id: obClientProfileID,
                softwareStatementProfileId: nil,
                issuerURL: nil
                )
            })
            
            // Post client credentials grant request
            .flatMap({obClientArray -> EventLoopFuture<OBTokenEndpointResponse> in
                guard obClientArray.count == 1 else {
                    fatalError()
                }
                obClientProfile = obClientArray[0]
                return obClientProfile.httpPostClientCredentialsGrant(scope: "accounts")
            })
            
            // Post account access consent request
            .flatMap({ obTokenEndpointResponse -> EventLoopFuture<Void> in
                
                class TestBlock: AccountTransactionRequestOBObjectProcesingBlock {
                    typealias InputType = (
                        bufferData: Data,
                        obClientProfile: OBClientProfile,
                        obTokenEndpointResponse: OBTokenEndpointResponse,
                        responseCallback: (HTTPResponseStatus, Data) -> Void
                    )
                    static func executeInner<T1, T2: AccountTransactionRequestObjectLocalProtocol>(
                        type1: T1.Type, type2: T2.Type, input: InputType) throws -> EventLoopFuture<Void> where T2.AccountTransactionRequestObjectApi == T1 {
                        
                        var obCreatedItem: AccountTransactionConsent!
                        
                        let readConsentType = obATReadConsentType(apiVersion: input.obClientProfile.accountTransactionAPISettings.apiVersion)
                        let formatter = ISO8601DateFormatter()
                        let expirationDateTime = formatter.date(from: "2025-12-31T10:40:00Z")!
                        let transactionFromDateTime = formatter.date(from: "2016-01-01T10:40:00Z")!
                        let transactionToDateTime = formatter.date(from: "2025-12-31T10:40:00Z")!
                        let instance = readConsentType.init(
                            permissions: input.obClientProfile.accountTransactionAPISettings.accountAccessConsentPermissions,
                            expirationDateTime: expirationDateTime,
                            transactionFromDateTime: transactionFromDateTime,
                            transactionToDateTime: transactionToDateTime
                        )
                        
                        // Generate URL
                        let url = URL(string: input.obClientProfile.accountTransactionAPISettings.obBaseURL + "/account-access-consents")!
                        
                        return (instance as! T1).httpPost(obClient: input.obClientProfile, url: url, authHeader: "Bearer " + input.obTokenEndpointResponse.access_token, on: MultiThreadedEventLoopGroup.currentEventLoop!)
                            
                            // Save account access consent
                            .flatMap({
                                responseObject in
                                
                                // Create AccountAccessConsent
                                let obRequestObjectClaims = input.obClientProfile.getOBRequestObjectClaims(
                                    redirect_uri: input.obClientProfile.registrationClaims.redirect_uris[0],
                                    scope: .stringWithSpaces("openid accounts"),
                                    intentId: responseObject.data.consentId
                                )
                                obCreatedItem = AccountTransactionConsent(
                                    softwareStatementProfileId: input.obClientProfile.softwareStatementProfileId,
                                    issuerURL: input.obClientProfile.issuerURL,
                                    obClientId: input.obClientProfile.id,
                                    obRequestObjectClaims: obRequestObjectClaims
                                )
                                return obCreatedItem.insert()
                            })
                            
                            // Create auth URL
                            .flatMap({ () -> EventLoopFuture<String> in
                                return obCreatedItem.createAuthURL(
                                    authorization_endpoint: input.obClientProfile.openIDConfiguration.authorization_endpoint
                                )
                            })
                            
                            // Send success response
                            .flatMapThrowing({ authURL in
                                let response = PostConsentResponse(authURL: authURL, consentId: obCreatedItem.id)
                                let returnJson = try! JSONEncoder().encode(response)
                                input.responseCallback(.created, returnJson)
                            })
                        
                    }
                }
                
                return try! TestBlock.execute(
                    obClientProfile.accountTransactionAPISettings.apiVersion,
                    requestObjectVariety,
                    (bufferData, obClientProfile, obTokenEndpointResponse, responseCallback)
                )
            })
            
            // Send failure response
            .whenFailure({
                error in responseCallback(.internalServerError, try! JSONEncoder().encode("\(error)"))
            })
    }
}
