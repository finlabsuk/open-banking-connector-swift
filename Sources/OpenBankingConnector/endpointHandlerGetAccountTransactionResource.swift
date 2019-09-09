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
import LocalProtocols
import LocalTypes

func getSingleValuedHeader(fieldName: String, headers: HTTPHeaders) -> String? {
    let valueArray = headers[canonicalForm: fieldName]
    if valueArray.count == 1 {
        return String(valueArray[0])
    } else {
        return nil
    }
}

func endpointHandlerGetAccountTransactionResource<AccountTransactionType: OBCAccountTransactionResourceProtocol>(
    context: ChannelHandlerContext,
    request: HTTPServerRequestPart,
    type: AccountTransactionType.Type,
    regexMatch: [String],
    accountAccessConsentID: String,
    responseCallback: @escaping (HTTPResponseStatus, Data) -> Void
) {
    
    // Wait until request fully received
    if case .end = request {
        
        var obClient: OBClientProfile!
        var accountAccessConsent: AccountAccessConsent!

        context.eventLoop.makeSucceededFuture(())
            
            // Load account access consent
            .flatMap({ AccountAccessConsent.load(
                id: accountAccessConsentID,
                authState: nil
                )
            })
            
            // Store account acceess consent in memory
            .flatMapThrowing({accountAccessConsentArray in
                guard accountAccessConsentArray.count == 1 else {
                    fatalError()
                }
                accountAccessConsent = accountAccessConsentArray[0]
            })
            
            // Load OB client
            .flatMap({ OBClientProfile.load(
                id: accountAccessConsent.obClientId,
                    softwareStatementProfileId: nil,
                    issuerURL: nil
                )
            })
            
            // Store OB client in memory
            .flatMapThrowing({obClientArray in
                guard obClientArray.count == 1 else {
                    fatalError()
                }
                obClient = obClientArray[0]
            })

            
            // Get OpenID configuration from well-known endpoint for issuer URL
            .flatMap({ Transaction.httpGet(
                obClient: obClient,
                accountAccessConsent: accountAccessConsent,
                endpointPath: regexMatch[0]
                )
            })
            
            // Send success response
            .flatMapThrowing({ resources in
                let returnJson = try! JSONEncoder().encode(resources)
                responseCallback(.ok, returnJson)
            })
            
            
            // Send failure response
            .whenFailure({
                error in responseCallback(.internalServerError, try! JSONEncoder().encode("\(error)"))
            })

    }
}
