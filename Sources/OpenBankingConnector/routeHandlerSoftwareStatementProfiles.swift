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

func routeHandlerSoftwareStatementProfiles(
    context: ChannelHandlerContext,
    request: HTTPServerRequestPart,
    httpMethod: HTTPMethod,
    path: String,
    responseCallback: @escaping (HTTPResponseStatus, Data) -> Void,
    buffer: inout ByteBuffer
) {
    
    switch (httpMethod, path) {
    case (.POST, ""):
        
        switch request {
        case .head: break;
        case .body(buffer: var buf):
            buffer.writeBuffer(&buf)
        case .end:
            
            // Validate body data
            let softwareStatementProfiles: [SoftwareStatementProfile]
            do {
                let data = buffer.readData(length: buffer.readableBytes)!
                softwareStatementProfiles = try hcm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode([SoftwareStatementProfile].self, from: data)
                print(softwareStatementProfiles)
            } catch {
                print(error)
                responseCallback(.badRequest, try! JSONEncoder().encode("\(error)"))
                return
            }
            
            // Save software statement profiles
            var currentFuture = context.eventLoop.makeSucceededFuture(())
            for softwareStatementProfile in softwareStatementProfiles {
                currentFuture = currentFuture.flatMap({ softwareStatementProfile.insert() })
            }
            
            currentFuture
                
                // Send success response
                .flatMapThrowing({
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
