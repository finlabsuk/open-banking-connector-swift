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
import PaymentInitiationLocalTypes

func endpointHandlerPostPaymentInitiationConsent(
    context: ChannelHandlerContext,
    request: HTTPServerRequestPart,
    requestObjectVariety: PaymentInitiationPaymentVariety,
    regexMatch: [String],
    obClientProfileID: String,
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

        context.eventLoop.makeSucceededFuture(())
            
            // Load OB client
            .flatMap({ OBClientProfile.load(
                id: obClientProfileID,
                softwareStatementProfileId: nil,
                issuerURL: nil
                )
            })
            
            // Post client credentials grant request
            .flatMap({obClientArray -> EventLoopFuture<OBTokenEndpointResponse> in
                guard obClientArray.count == 1 else {
                    fatalError()
                }
                obClientProfile = obClientArray[0]
                return obClientProfile.httpPostClientCredentialsGrant(scope: "payments")
            })
            
            // Post request
            .flatMap({ obTokenEndpointResponse -> EventLoopFuture<Void> in
                
                class ProcessingBlock: PaymentInitiationProcesingBlock_OBWritePaymentConsentLocal {
                    typealias InputType = (
                        context: ChannelHandlerContext,
                        requestObjectVariety: PaymentInitiationPaymentVariety,
                        bufferData: Data,
                        regexMatch: [String],
                        obClientProfile: OBClientProfile,
                        obTokenEndpointResponse: OBTokenEndpointResponse,
                        responseCallback: (HTTPResponseStatus, Data) -> Void
                    )
                    typealias OutputType = EventLoopFuture<Void>
                    static func executeInner<OBWritePaymentConsentLocal: OBWritePaymentConsentLocalProtocol>(
                        dynamicType: OBWritePaymentConsentLocal.Type,
                        input: InputType
                    ) -> OutputType {
                        typealias OBWritePaymentConsentResponseApi = OBWritePaymentConsentLocal.OBWritePaymentConsentApi.ResponseApi
                        
                        var responseAPI: OBWritePaymentConsentResponseApi!
                        var consent: PaymentInitiationDomesticConsent!
                        
                        // Validate request data
                        let requestObjectApi: OBWritePaymentConsentLocal.OBWritePaymentConsentApi
                        do {
                            if input.bufferData.isEmpty {
                                throw("No body data received in request")
                            }
                            let requestObjectPublic = try hcm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(OBWritePaymentConsentLocal.self, from: input.bufferData)
                            requestObjectApi = try requestObjectPublic.obWritePaymentConsentApi()
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
                            .flatMap({ jws -> EventLoopFuture<OBWritePaymentConsentResponseApi> in
                                let jwsComponents = jws.components(separatedBy: ".")
                                let jwsSignature = "\(jwsComponents[0])..\(jwsComponents[2])"
                                let url = URL(string: input.obClientProfile.paymentInitiationAPISettings.obBaseURL + input.regexMatch[0])!
                                let requestObjectApiData = try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(requestObjectApi)
                                //print(String(decoding: requestObjectApiData, as: UTF8.self))
                                return hcm.httpPost(
                                    url: url,
                                    headers: [
                                        "x-fapi-financial-id": input.obClientProfile.xFapiFinancialId,
                                        "Authorization": "Bearer " + input.obTokenEndpointResponse.access_token,
                                        "x-idempotency-key": UUID().uuidString.lowercased(),
                                        "x-jws-signature": jwsSignature,
                                    ],
                                    body: requestObjectApiData,
                                    httpClientMTLSConfiguration: input.obClientProfile.httpClientMTLSConfiguration
                                    ) as EventLoopFuture<OBWritePaymentConsentResponseApi>
                            })
                            
                            // Save consent
                            .flatMap({
                                
                                // Create Consent
                                responseAPI = $0
                                let obRequestObjectClaims = input.obClientProfile.getOBRequestObjectClaims(
                                    redirect_uri: input.obClientProfile.registrationClaims.redirect_uris[0],
                                    scope: .stringWithSpaces("openid payments"),
                                    intentId: responseAPI.data.consentId
                                )
                                consent = PaymentInitiationDomesticConsent(
                                    softwareStatementProfileId: input.obClientProfile.softwareStatementProfileId,
                                    issuerURL: input.obClientProfile.issuerURL,
                                    obClientId: input.obClientProfile.id,
                                    obRequestObjectClaims: obRequestObjectClaims
                                )
                                return consent.insert()
                            })

                            // Create auth URL
                            .flatMap({ () -> EventLoopFuture<String> in
                                return consent.createAuthURL(
                                    authorization_endpoint: input.obClientProfile.openIDConfiguration.authorization_endpoint
                                )
                            })
                            
                            // Send success response
                            .flatMapThrowing({ authURL in
                                let successBody = responseAPI.obWritePaymentConsentResponsePublic(
                                    authURL: authURL,
                                    consentID: consent.id
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
                    (context, requestObjectVariety, bufferData, regexMatch, obClientProfile, obTokenEndpointResponse, responseCallback)
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
