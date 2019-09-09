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

func routeHandlerAccountAccessConsents(
    context: ChannelHandlerContext,
    request: HTTPServerRequestPart,
    httpMethod: HTTPMethod,
    path: String,
    responseCallback: @escaping (HTTPResponseStatus, Data) -> Void,
    obClientID: String
    ) {
    
    // Wait until request fully received
    if case .end = request {
        
        switch (httpMethod, path) {
        case (.POST, ""):
            
            var obClient: OBClientProfile!
            var accountAccessConsent: AccountAccessConsent!
                        
            context.eventLoop.makeSucceededFuture(())
                
                // Load OB client
                .flatMap({ OBClientProfile.load(
                        id: obClientID,
                        softwareStatementProfileId: nil,
                        issuerURL: nil
                    )
                })
                
                // Post client credentials grant request
                .flatMap({obClientArray -> EventLoopFuture<OBTokenEndpointResponse> in
                    guard obClientArray.count == 1 else {
                        fatalError()
                    }
                    obClient = obClientArray[0]
                    return obClient.httpPostClientCredentialsGrant(scope: "accounts")
                })
                
                // Post account access consent request
                .flatMap({ obTokenEndpointResponse -> EventLoopFuture<AccountAccessConsent> in
                    let readConsentType = obATReadConsentType(apiVersion: obClient.obAccountTransactionAPISettings.apiVersion)
                    let formatter = ISO8601DateFormatter()
                    let expirationDateTime = formatter.date(from: "2025-12-31T10:40:00Z")!
                    let transactionFromDateTime = formatter.date(from: "2016-01-01T10:40:00Z")!
                    let transactionToDateTime = formatter.date(from: "2025-12-31T10:40:00Z")!
                    let instance = readConsentType.init(
                        permissions: obClient.obAccountTransactionAPISettings.accountAccessConsentPermissions,
                        expirationDateTime: expirationDateTime,
                        transactionFromDateTime: transactionFromDateTime,
                        transactionToDateTime: transactionToDateTime
                    )
                    
                    return instance.httpPost(obClient: obClient, obEndpointPath: "/account-access-consents", authHeader: "Bearer " + obTokenEndpointResponse.access_token, on: MultiThreadedEventLoopGroup.currentEventLoop!)
                })
                
                // Save account access consent
                .flatMap({
                    accountAccessConsentTmp in
                    accountAccessConsent = accountAccessConsentTmp
                    return accountAccessConsent.insert()
                })
                
                // Create auth URL
                .flatMap({ () -> EventLoopFuture<String> in
                    return accountAccessConsent.createAuthURL(
                        authorization_endpoint: obClient.openIDConfiguration.authorization_endpoint
                    )
                })
                
                // Send success response
                .flatMapThrowing({ authURL in
                    let response = AccountAccessConsentResponse(authURL: authURL, accountAccessConsentId: accountAccessConsent.id)
                    let returnJson = try! JSONEncoder().encode(response)
                    responseCallback(.created, returnJson)
                })

                
                // Send failure response
                .whenFailure({
                    error in responseCallback(.internalServerError, try! JSONEncoder().encode("\(error)"))
                })
            
        default: break;
        }
    }
}




