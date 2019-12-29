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
import SQLKit
import BaseServices

func escape(_ value: String) -> String? {
    return value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
}
func encode(key: String, value: String) -> String? {
    return escape("\(key)=\(value)")
}
func tmpEncode(parameters: [String: String]) -> String {
    return parameters.compactMap(encode).joined(separator: "&")
}

func tmpDecode(input: String) -> [String: String] {
    let components = input.components(separatedBy: "&")
    return components.reduce(into: [String: String]()) { result, next in
        let tmpComponents = next.removingPercentEncoding!
        let newComponents = tmpComponents.components(separatedBy: "=")
        result[newComponents[0]] = newComponents[1]
    }
}

struct OBClientRegistrationData: Codable {
    let client_id: String
    let client_secret: String?
    let client_id_issued_at: Date?
    let client_secret_expires_at: Date?
}

struct OBClientProfile: StoredItem {
    
    // ********************************************************************************
    // MARK: StoredItem Template Code
    // ********************************************************************************
    
    /// ID used to uniquely identify object (cannot be changed, create new object to change)
    /// - returns: A String object.
    var id: String = UUID().uuidString
    
    // Association of data object with other data objects ("ownership")
    // Empty strings used for types where association doesn't make sense
    /// "FinTech identity"
    let softwareStatementProfileId: String
    /// "Bank (ASPSP) identity"
    let issuerURL: String
    /// "Open Banking client identity"
    var obClientId: String {
        get {
            return self.id
        }
    }
    /// "User identity"
    var userId: String = ""

    /// State variable supplied to auth endpoint (used to process redirect); only relevant for consents that need authorisation
    var state: String = ""
    
    // Timestamp for object creation as best we can determine
    let created: Date = Date()
    
    // Deletion status for object/object change
    //@Mutable var isDeleted: Bool = false
    var isDeleted: Mutable<Bool> = Mutable<Bool>(wrappedValue: false)
    
    // ********************************************************************************
    
    /// FAPI financial ID
    let xFapiFinancialId: String?

    /// Data from Open ID config
    let openIDConfiguration: OpenIDConfiguration

    /// Claims used to create OB client
    let registrationClaims: OBClientRegistrationClaims
    
    /// OB client data supplied by ASPSP at time of creation
    let registrationData: OBClientRegistrationData
    
    /// MTLS configuration
    let httpClientMTLSConfiguration: HTTPClientMTLSConfiguration
    
    /// Settings to use for interactions with Open Banking Account and Transaction API
    let accountTransactionAPISettings: AccountTransactionApiSettings

    /// Settings to use for interactions with Open Banking Payment Initiation API
    let paymentInitiationAPISettings: PaymentInitiationApiSettings

    init( // TODO: Remove after Swift 5.1
        softwareStatementProfileId: String,
        issuerURL: String,
        xFapiFinancialId: String?,
        openIDConfiguration: OpenIDConfiguration,
        httpClientMTLSConfiguration: HTTPClientMTLSConfiguration,
        registrationClaims: OBClientRegistrationClaims,
        registrationData: OBClientRegistrationData,
        accountTransactionAPISettings: AccountTransactionApiSettings,
        paymentInitiationAPISettings: PaymentInitiationApiSettings
    ) {
        self.softwareStatementProfileId = softwareStatementProfileId
        self.issuerURL = issuerURL
        self.xFapiFinancialId = xFapiFinancialId
        self.openIDConfiguration = openIDConfiguration
        self.httpClientMTLSConfiguration = httpClientMTLSConfiguration
        self.registrationClaims = registrationClaims
        self.registrationData = registrationData
        self.accountTransactionAPISettings = accountTransactionAPISettings
        self.paymentInitiationAPISettings = paymentInitiationAPISettings
    }

    static func load(
        id: String?,
        softwareStatementProfileId: String?,
        issuerURL: String?,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<[OBClientProfile]> {
        
        let futureOnDBEventLoop = sm.pool.withConnection { conn -> EventLoopFuture<[SQLRow]> in
            var builder = conn.sql().select()
                .column(SQLRaw("json"))
                .from(self.tableName)
            if let id = id {
                builder = builder.where(SQLColumn(SQLRaw("id")), .equal, SQLBind(id))
            }
            if let softwareStatementProfileId = softwareStatementProfileId {
                builder = builder.where(SQLColumn(SQLRaw("softwareStatementProfileId")), .equal, SQLBind(softwareStatementProfileId))
            }
            if let issuerURL = issuerURL {
                builder = builder.where(SQLColumn(SQLRaw("issuerURL")), .equal, SQLBind(issuerURL))
            }
            return builder.all()
        }
        return futureOnDBEventLoop
            .hop(to: eventLoop)
            .flatMapThrowing({ rowArray -> [OBClientProfile] in
                var resultArray = [OBClientProfile]()
                for row in rowArray {
                    let dataString: String = try row.decode(column: "json", as: String.self)
                    let obClient: OBClientProfile = try sm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(
                        OBClientProfile.self,
                        from: Data(dataString.utf8)
                    )
                    resultArray.append(obClient)
                }
                return resultArray
            })
            .flatMapError({error in
                print(error)
                fatalError()
            })
        
    }
    
    func httpPostClientCredentialsGrant(
        scope: String,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<OBTokenEndpointResponse> {
        
        return eventLoop.makeSucceededFuture(())
            
            // Post claims
            .flatMap({ () -> EventLoopFuture<HTTPClient.Response> in
                var authHeader: String? = nil // none by default
                var params = ["grant_type": "client_credentials",
                              "scope": scope]
                if self.registrationClaims.token_endpoint_auth_method == "tls_client_auth" {
                    params["client_id"] = self.registrationData.client_id
                } else if self.registrationClaims.token_endpoint_auth_method == "client_secret_basic" {
                    let tmpString: String = self.registrationData.client_id + ":" + self.registrationData.client_secret!
                    authHeader = "Basic " + Data(tmpString.utf8).base64EncodedString()
                } else {
                    fatalError() // Don't support other token endpoint auth options atm
                }
                var request = hcm.postRequest(
                    url: URL(string: self.openIDConfiguration.token_endpoint)!,
                    xFapiFinancialId: self.xFapiFinancialId,
                    authHeader: authHeader,
                    isFormUrlencoded: true
                )
                request.body = .string(tmpEncode(parameters: params))
                return hcm.executeMTLS(
                    request: request,
                    httpClientMTLSConfiguration: self.httpClientMTLSConfiguration
                )
            })
            
            // Decode response
            .flatMapThrowing({ response -> OBTokenEndpointResponse in
                if response.status == .ok,
                    var body = response.body {
                    let data = body.readData(length: body.readableBytes)!
                    let responseObject = try hcm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(
                        OBTokenEndpointResponse.self,
                        from: data)
                    print(response.status.code)
                    print(responseObject)
                    return responseObject
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
