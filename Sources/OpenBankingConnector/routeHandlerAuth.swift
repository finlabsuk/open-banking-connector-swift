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

func routeHandlerAuth(
    context: ChannelHandlerContext,
    request: HTTPServerRequestPart,
    httpMethod: HTTPMethod,
    path: String,
    responseCallback: @escaping (HTTPResponseStatus, Data) -> Void,
    buffer: inout ByteBuffer
) {
    
    switch (httpMethod, path) {
    case (.POST, "/fragment-redirect-delegate"):
        
        switch request {
        case .head: break;
        case .body(buffer: var buf):
            buffer.writeBuffer(&buf)
        case .end:
            
            var consent: ConsentProtocol!
            
            // Validate body data
            let bufString = buffer.readString(length: buffer.readableBytes)!
            let authData = OBAuthData(input: bufString)
            
            context.eventLoop.makeSucceededFuture(())
                
                // Load relevant consent
                .flatMap({ () -> EventLoopFuture<([AccountTransactionConsent],[PaymentInitiationDomesticConsent])> in
                    return AccountTransactionConsent.load(
                        id: nil,
                        state: authData.state
                    ).and(PaymentInitiationDomesticConsent.load(
                        id: nil,
                        state: authData.state
                    ))
                })
                
                // Post authorisation code grant request
                .flatMap({(accountAccessConsentArray, paymentInitiationDomesticConsentArray) -> EventLoopFuture<OBTokenEndpointResponse> in
                    let consentArray: [ConsentProtocol] = accountAccessConsentArray + paymentInitiationDomesticConsentArray
                    
                    guard consentArray.count == 1 else {
                        fatalError()
                    }
                    consent = consentArray[0]
                    return consent.httpPostAuthCodeGrant(code: authData.code)
                })
                
                // Update consent with response
                .flatMap({ obTokenEndpointResponse -> EventLoopFuture<Void> in
                    print(obTokenEndpointResponse)
                    consent.obTokenEndpointResponse = obTokenEndpointResponse
                    return consent.update()
                })
                
                
                // Send success response
                .flatMapThrowing({_ in
                    struct ReturnType: Encodable { let message: String }
                    let returnJson = try! JSONEncoder().encode(ReturnType(message: "Success"))
                    responseCallback(.created, returnJson)
                })
                
                // Send failure response
                .whenFailure({ error in
                    struct ReturnType: Encodable { let error: String }
                    let returnJson = try! JSONEncoder().encode(ReturnType(error: "\(error)"))
                    responseCallback(.internalServerError, returnJson)
                })
            
        }
        
    default: break;
    }
    
}
