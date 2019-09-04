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
    responseCallback: @escaping (HTTPResponseStatus, String) -> Void,
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
                softwareStatementProfiles = try JSONDecoder().decode([SoftwareStatementProfile].self, from: data)
                print(softwareStatementProfiles)
            } catch {
                print(error)
                responseCallback(.badRequest, "Bad input...")
                return
            }
            
            // Save software statement profiles
            let currentFuture = context.eventLoop.makeSucceededFuture(())
            for softwareStatementProfile in softwareStatementProfiles {
                currentFuture.flatMap({ softwareStatementProfile.insert() })
            }
            
            currentFuture
                
                // Send success response
                .flatMapThrowing { responseCallback(.created, "Success text") }
                
                // Send failure response
                .whenFailure { error in responseCallback(.internalServerError, "\(error)") }

            
        }
        
    default: break;
    }
    
}
