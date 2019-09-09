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
import AsyncHTTPClient

// MARK:- Account access consent protocols

protocol InitProtocol2: Codable {
        init()
}
extension InitProtocol2 {
        init() { self = try! JSONDecoder().decode(Self.self , from: Data("{}".utf8))}
}

protocol OBATReadConsentProtocolExposedMethods {
    func httpPost(
        obClient: OBClient,
        obEndpointPath: String,
        authHeader: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<AccountAccessConsent>
    init(
        permissions: [OBAccountTransactionAccountAccessConsentPermissions],
        expirationDateTime: Date,
        transactionFromDateTime: Date,
        transactionToDateTime: Date
    )
}

protocol OBATReadConsentProtocol: OBATReadConsentProtocolExposedMethods, OBAIReadResource2Protocol {
    associatedtype RiskType: InitProtocol2
    associatedtype OBAIReadResourceType: OBATReadConsentResponseProtocol
    init(data: OBAIReadResourceDataType, risk: RiskType)
}
extension OBATReadConsentProtocol where OBAIReadResourceDataType: OBAIReadConsentDataProtocol {
    init(
        permissions: [OBAccountTransactionAccountAccessConsentPermissions],
        expirationDateTime: Date,
        transactionFromDateTime: Date,
        transactionToDateTime: Date
    ) {
        let data = OBAIReadResourceDataType(
            permissions: permissions.map { OBAIReadResourceDataType.Permissions(rawValue: $0.rawValue)!
            },
            expirationDateTime: expirationDateTime,
            transactionFromDateTime: transactionFromDateTime,
            transactionToDateTime: transactionToDateTime
        )
        self.init(data: data, risk: RiskType())
    }
    func httpPost(
        obClient: OBClient,
        obEndpointPath: String,
        authHeader: String,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<AccountAccessConsent> {
        
        return eventLoop.makeSucceededFuture(())
            
            // Post claims
            .flatMap({ () -> EventLoopFuture<HTTPClient.Response> in
                
                let url = obClient.obAccountTransactionAPISettings.obBaseURL + obEndpointPath
                let xFapiFinancialId = obClient.xFapiFinancialId
                var request = hcm.postRequest(
                    url: URL(string: url)!,
                    xFapiFinancialId: xFapiFinancialId,
                    authHeader: authHeader
                )
                let bodyData = try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(self)
                // print(String(decoding: bodyData, as: UTF8.self))
                request.body = .data(bodyData)
                return hcm.executeMTLS(
                    request: request,
                    httpClientMTLSConfiguration: obClient.httpClientMTLSConfiguration
                )
            })
            
            // Decode response and create AccountAccessConsent
            .flatMapThrowing({ response -> AccountAccessConsent in
                if response.status == .created,
                    var body = response.body {
                    
                    // Decode response
                    let data = body.readData(length: body.readableBytes)!
                    print(String(decoding: data, as: UTF8.self))
                    let responseObject: OBAIReadResourceType
                    if
                        let responseObjectTmp = try? hcm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(OBAIReadResourceType.self, from: data) {
                        responseObject = responseObjectTmp
                    } else if
                        let responseObjectTmp = try? hcm.jsonDecoderDateFormatISO8601WithSeconds.decode(OBAIReadResourceType.self, from: data) {
                        responseObject = responseObjectTmp
                    }
                    else {
//                        let responseObjectTmp = try hcm.jsonDecoderDateFormatISO8601WithSeconds.decode(OBAIReadResourceType.self, from: data)
                        throw "Can't decode"
                    }
                    print(response.status.code)
                    print(responseObject)
                    
                    // Create AccountAccessConsent
                    let obRequestObjectClaims = obClient.getOBRequestObjectClaims(
                        redirect_uri: obClient.registrationClaims.redirect_uris[0],
                        scope: .stringWithSpaces("openid accounts"),
                        intentId: responseObject.data.consentId
                    )
                    return AccountAccessConsent(
                        softwareStatementProfileId: obClient.softwareStatementProfileId,
                        issuerURL: obClient.issuerURL,
                        obClientId: obClient.id,
                        obRequestObjectClaims: obRequestObjectClaims
                    )

                } else {
                    if var bodyTmp = response.body,
                        let bodyString = bodyTmp.readString(length: bodyTmp.readableBytes) {
                        print(bodyString)
                    }
                    throw "Bad response..."
                }
            })
            
            .flatMapError({error in
                print(error)
                fatalError()
            })

    }
}

// MARK:- Account access consent response protocols

protocol OBAIReadConsentDataProtocol: OBAIResourceProtocol {
    associatedtype Permissions: RawRepresentableWithStringRawValue
    var permissions: [Permissions] { get set }
    var expirationDateTime: Date? { get set }
    var transactionFromDateTime: Date? { get set }
    var transactionToDateTime: Date? { get set }
    init(permissions: [Permissions], expirationDateTime: Date?, transactionFromDateTime: Date?, transactionToDateTime: Date?)
}

protocol OBATReadConsentResponseProtocol: OBAIReadResource2Protocol where OBAIReadResourceDataType: OBAIReadConsentResponseDataProtocol { }

protocol OBAIReadConsentResponseDataProtocol: OBAIResourceProtocol {
    associatedtype Status: RawRepresentableWithStringRawValue
    associatedtype Permissions: RawRepresentableWithStringRawValue
    var consentId: String { get }
    var creationDateTime: Date { get }
    var status: Status { get }
    var statusUpdateDateTime: Date { get }
    var permissions: [Permissions] { get }
    var expirationDateTime: Date? { get }
    var transactionFromDateTime: Date? { get }
    var transactionToDateTime: Date? { get }
}
