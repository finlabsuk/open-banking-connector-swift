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
                    ) throws -> OutputType {
                        typealias OBWritePaymentResponseApi = OBWritePaymentConsentLocal.OBWritePaymentApi.ResponseApi
                        
                        var payment: PaymentInitiationDomestic!
                        
                        // Prepare data
                        let requestObjectLocal: OBWritePaymentConsentLocal = try! hcm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(OBWritePaymentConsentLocal.self, from: input.bufferData)
                        let consentId = input.consent.obRequestObjectClaims.claims.userinfo.openbanking_intent_id.value!
                        let requestObjectApi = requestObjectLocal.obWritePaymentApi(consentId: consentId)
                        let requestObjectApiData = try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(requestObjectApi)
                        
                        // Generate URL
                        let url = URL(string: input.obClientProfile.paymentInitiationAPISettings.obBaseURL + input.regexMatch[0])!
                        return genJws(
                            softwareStatementId: input.obClientProfile.softwareStatementProfileId,
                            claims: requestObjectApi,
                            useAuthHeader: false
                        )
                            
                            // POST consent
                            .flatMap({ jws -> EventLoopFuture<OBWritePaymentResponseApi> in
                                let jwsComponents = jws.components(separatedBy: ".")
                                let jwsSignature = "\(jwsComponents[0])..\(jwsComponents[2])"
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
                                responseObject in
                                print(responseObject)
                                
                                // Create paymnet
                                payment = PaymentInitiationDomestic(
                                    softwareStatementProfileId: input.obClientProfile.softwareStatementProfileId,
                                    issuerURL: input.obClientProfile.issuerURL,
                                    obClientId: input.obClientProfile.id
                                )
                                return payment.insert()
                            })
                            
                            // Send success response
                            .flatMapThrowing({ () in
                                let response = PostConsentResponse(authURL: "", consentId: input.consent.id)
                                let returnJson = try! JSONEncoder().encode(response)
                                input.responseCallback(.created, returnJson)
                            })
                        
                    }
                }
                
                return try! ProcessingBlock.execute(
                    obClientProfile.paymentInitiationAPISettings.apiVersion,
                    requestObjectVariety,
                    (requestObjectVariety, bufferData, regexMatch, obClientProfile, consent, responseCallback)
                )
            })
            
            // Send failure response
            .whenFailure({
                error in responseCallback(.internalServerError, try! JSONEncoder().encode("\(error)"))
            })
    }
}
