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

func endpointHandlerPostSoftwareStatementProfile(
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
        let softwareStatementProfile: SoftwareStatementProfile
        do {
            let data = buffer.readData(length: buffer.readableBytes)!
            if data.isEmpty {
                throw("No body data received in request")
            }
            let softwareStatementProfilePublic = try hcm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(SoftwareStatementProfilePublic.self, from: data)
            softwareStatementProfile = try SoftwareStatementProfile(softwareStatementProfilePublic: softwareStatementProfilePublic)
        } catch {
            let errorBody = ErrorPublic(error: "\(error)")
            responseCallback(
                .badRequest,
                try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(errorBody)
                )
            return
        }
        
        // Save software statement profiles
        context.eventLoop.makeSucceededFuture(())
            
            // Save software statement profile
            .flatMap({ softwareStatementProfile.insert() })
            
            // Send success response
            .flatMapThrowing({
                let successBody = SoftwareStatementProfileResponsePublic(id: softwareStatementProfile.id)
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
            })
        
    }
}
