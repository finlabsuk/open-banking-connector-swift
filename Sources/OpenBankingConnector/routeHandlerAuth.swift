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
            
            var accountAccessConsent: AccountAccessConsent!
            
            // Validate body data
            let bufString = buffer.readString(length: buffer.readableBytes)!
            let authData = OBAuthData(input: bufString)
            
            context.eventLoop.makeSucceededFuture(())
                
                // Load relevant consent
                .flatMap({ () -> EventLoopFuture<[AccountAccessConsent]> in
                    return AccountAccessConsent.load(
                        id: nil,
                        authState: authData.state
                    )
                })
                
                // Post authorisation code grant request
                .flatMap({accountAccessConsentArray -> EventLoopFuture<OBTokenEndpointResponse> in
                    guard accountAccessConsentArray.count == 1 else {
                        fatalError()
                    }
                    accountAccessConsent = accountAccessConsentArray[0]
                    return accountAccessConsent.httpPostAuthCodeGrant(code: authData.code)
                })
                
                // Update consent with response
                .flatMap({ obTokenEndpointResponse -> EventLoopFuture<Void> in
                    print(obTokenEndpointResponse)
                    accountAccessConsent.obTokenEndpointResponse = obTokenEndpointResponse
                    return accountAccessConsent.update()
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
