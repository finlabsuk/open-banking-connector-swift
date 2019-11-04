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

func endpointHandlerGetOBATResource(
    context: ChannelHandlerContext,
    request: HTTPServerRequestPart,
    obatResourceType: AccountTransactionResourceVariety,
    regexMatch: [String],
    accountAccessConsentID: String,
    responseCallback: @escaping (HTTPResponseStatus, Data) -> Void
) {
    
    // Wait until request fully received
    if case .end = request {
        
        var obClient: OBClientProfile!
        var accountAccessConsent: AccountTransactionConsent!

        context.eventLoop.makeSucceededFuture(())
            
            // Load account access consent
            .flatMap({ AccountTransactionConsent.load(
                id: accountAccessConsentID,
                state: nil
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
            
            .flatMap({() -> EventLoopFuture<Void> in
                
                class TestBlock: AccountTransactionResourceProcesingBlock {
                    typealias InputType = (
                        obClientProfile: OBClientProfile,
                        accountAccessConsent: AccountTransactionConsent,
                        regexMatch: [String],
                        responseCallback: (HTTPResponseStatus, Data) -> Void
                    )
                    static func executeInner<T1, T2>(type1: T1.Type, type2: T2.Type, input: InputType) throws -> EventLoopFuture<Void> where T1 : OBATApiReadResourceProtocol, T2 : OBATLocalResourceProtocol, T2.OBATApiResourceType == T1.OBATApiReadResourceDataType.OBATApiResourceType {
                        
                        // Get resource
                        return T1.httpGet(
                            obClient: input.obClientProfile,
                            accountAccessConsent: input.accountAccessConsent,
                            endpointPath: input.regexMatch[0]
                        )
                            
                            // Convert to local type
                            .flatMapThrowing({apiData in
                                return apiData.data.resource?.map {
                                    T2.init(
                                        softwareStatementProfileId: input.obClientProfile.softwareStatementProfileId,
                                        issuerURL: input.obClientProfile.issuerURL,
                                        obClientId: input.obClientProfile.id,
                                        userId: "user",
                                        aspspData: $0
                                    )}
                            })
                            
                            // Send success response
                            .flatMapThrowing({ resources in
                                let returnJson = try! JSONEncoder().encode(resources)
                                input.responseCallback(.ok, returnJson)
                            })
                        
                    }
                }
                
                return try! TestBlock.execute(
                    obClient.accountTransactionAPISettings.apiVersion,
                    obatResourceType,
                    (obClient, accountAccessConsent, regexMatch, responseCallback)
                )
            })
            
            // Send failure response
            .whenFailure({
                error in responseCallback(.internalServerError, try! JSONEncoder().encode("\(error)"))
            })
        
    }
    
}
