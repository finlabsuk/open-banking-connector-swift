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

func endpointHandlerPostAuthFragmentRedirectDelegate(
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
        let authData: OBAuthData
        do {
            let data = buffer.readData(length: buffer.readableBytes)!
            if data.isEmpty {
                throw("No body data received in request")
            }
            let receivedString = String(decoding: data, as: UTF8.self)
            let componentDict = tmpDecode(input: receivedString)
            if
                let code = componentDict["code"],
                let id_token = componentDict["id_token"],
                let state = componentDict["state"]
            {
                authData = OBAuthData(code: code, id_token: id_token, state: state)
            } else {
                let error = componentDict["error"]
                throw "Auth attempt produced error: \(error ?? "None provided")"
            }
        } catch {
            print("\(error)")
            let errorBody = ErrorPublic(error: "\(error)")
            responseCallback(
                .badRequest,
                try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(errorBody)
            )
            return
        }
        
        var consent: ConsentProtocol!
        
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
            .flatMapThrowing({
                struct ReturnType: Codable { let message: String }
                let successBody = ReturnType(message: "Success")
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
