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
import PaymentInitiationTypes
import PaymentInitiationTypeRequirements

func endpointHandlerPostPaymentInitiationPayment(
    context: ChannelHandlerContext,
    request: HTTPServerRequestPart,
    requestObjectVariety: PaymentInitiationPaymentVariety,
    regexMatch: [String],
    paymentInitiationConsentID: String,
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
        //print(String(decoding: bufferData, as: UTF8.self))
        
        var obClientProfile: OBClientProfile!
        var consent: PaymentInitiationDomesticConsent!
        
        context.eventLoop.makeSucceededFuture(())
            
            // Load consent
            .flatMap({ PaymentInitiationDomesticConsent.load(
                id: paymentInitiationConsentID,
                state: nil
                )
            })
            
            // Store consent in memory
            .flatMapThrowing({paymentInitiationConsentArray in
                guard paymentInitiationConsentArray.count == 1 else {
                    fatalError()
                }
                consent = paymentInitiationConsentArray[0]
            })
            
            // Load OB client profile
            .flatMap({ OBClientProfile.load(
                id: consent.obClientId,
                softwareStatementProfileId: nil,
                issuerURL: nil
                )
            })
            
            // Store OB client profile in memory
            .flatMapThrowing({obClientArray in
                guard obClientArray.count == 1 else {
                    fatalError()
                }
                obClientProfile = obClientArray[0]
            })
            
            // Post request
            .flatMap({ obClientArray -> EventLoopFuture<Void> in
                
                class ProcessingBlock: PaymentInitiationProcesingBlock_OBWritePaymentConsentLocal {
                    typealias InputType = (
                        context: ChannelHandlerContext,
                        requestObjectVariety: PaymentInitiationPaymentVariety,
                        bufferData: Data,
                        regexMatch: [String],
                        obClientProfile: OBClientProfile,
                        consent: PaymentInitiationDomesticConsent,
                        responseCallback: (HTTPResponseStatus, Data) -> Void
                    )
                    typealias OutputType = EventLoopFuture<Void>
                    static func executeInner<OBWritePaymentConsentLocal: OBWritePaymentConsentLocalProtocol>(
                        dynamicType: OBWritePaymentConsentLocal.Type,
                        input: InputType
                    ) -> OutputType {
                        typealias OBWritePaymentResponseApi = OBWritePaymentConsentLocal.OBWritePaymentApi.ResponseApi
                        
                        var responseAPI: OBWritePaymentResponseApi!
                        var payment: PaymentInitiationDomestic!
                        
                        // Validate request data
                        let requestObjectApi: OBWritePaymentConsentLocal.OBWritePaymentApi
                        do {
                            if input.bufferData.isEmpty {
                                throw("No body data received in request")
                            }
                            let requestObjectPublic = try hcm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(OBWritePaymentConsentLocal.self, from: input.bufferData)
                            let consentID = input.consent.obRequestObjectClaims.claims.userinfo.openbanking_intent_id.value!
                            requestObjectApi = try requestObjectPublic.obWritePaymentApi(consentId: consentID)
                        } catch {
                            let errorBody = ErrorPublic(error: "\(error)")
                            input.responseCallback(
                                .badRequest,
                                try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(errorBody)
                            )
                            return input.context.eventLoop.makeSucceededFuture(())
                        }
                        
                        // Generate JWS
                        return genJws(
                            softwareStatementId: input.obClientProfile.softwareStatementProfileId,
                            claims: requestObjectApi,
                            useAuthHeader: false
                        )
                            
                            // POST consent
                            .flatMap({ jws -> EventLoopFuture<OBWritePaymentResponseApi> in
                                let jwsComponents = jws.components(separatedBy: ".")
                                let jwsSignature = "\(jwsComponents[0])..\(jwsComponents[2])"
                                let url = URL(string: input.obClientProfile.paymentInitiationAPISettings.obBaseURL + input.regexMatch[0])!
                                let requestObjectApiData = try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(requestObjectApi)
                                return hcm.httpPost(
                                    url: url,
                                    headers: [
                                        "x-fapi-financial-id": input.obClientProfile.xFapiFinancialId,
                                        "Authorization": "Bearer " + input.consent.obTokenEndpointResponse!.access_token,
                                        "x-idempotency-key": UUID().uuidString,
                                        "x-jws-signature": jwsSignature,
                                    ],
                                    body: requestObjectApiData,
                                    httpClientMTLSConfiguration: input.obClientProfile.httpClientMTLSConfiguration
                                    ) as EventLoopFuture<OBWritePaymentResponseApi>
                            })
                            
                            // Save payment
                            .flatMap({
                                
                                // Create paymnet
                                responseAPI = $0
                                payment = PaymentInitiationDomestic(
                                    softwareStatementProfileId: input.obClientProfile.softwareStatementProfileId,
                                    issuerURL: input.obClientProfile.issuerURL,
                                    obClientId: input.obClientProfile.id
                                )
                                return payment.insert()
                            })
                            
                            // Send success response
                            .flatMapThrowing({ () in
                                let successBody = responseAPI.obWritePaymentResponsePublic(
                                    paymentID: payment.id
                                )
                                input.responseCallback(
                                    .created,
                                    try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(successBody)
                                )
                            })
                        
                    }
                }
                
                return ProcessingBlock.execute(
                    obClientProfile.paymentInitiationAPISettings.apiVersion,
                    requestObjectVariety,
                    (context, requestObjectVariety, bufferData, regexMatch, obClientProfile, consent, responseCallback)
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
