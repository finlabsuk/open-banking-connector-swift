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

struct AccountAccessConsent: StoredItem {
    
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
    var obClientId: String
    /// "User identity"
    var userId: String = ""
    
    /// State variable supplied to auth endpoint (used to process redirect); only relevant for consents that need authorisation
    var authState: String {
        get {
            return obRequestObjectClaims.state
        }
    }
    
    // Timestamp for object creation as best we can determine
    let created: Date = Date()
    
    // Deletion status for object/object change
    //@Mutable var isDeleted: Bool = false
    var isDeleted: Mutable<Bool> = Mutable<Bool>(wrappedValue: false)
    
    // ********************************************************************************
    
    let obRequestObjectClaims: OBRequestObjectClaims
    
    var obTokenEndpointResponse: OBTokenEndpointResponse? = nil
    
    init(
        softwareStatementProfileId: String,
        issuerURL: String,
        obClientId: String,
        obRequestObjectClaims: OBRequestObjectClaims
    ) {
        self.softwareStatementProfileId = softwareStatementProfileId
        self.issuerURL = issuerURL
        self.obClientId = obClientId
        self.obRequestObjectClaims = obRequestObjectClaims
    }

    static func load(
        id: String?,
        authState: String?,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<[AccountAccessConsent]> {
        
        var builder = sm.db.currentValue!.select()
            .column(SQLRaw("json"))
            .from(self.tableName)
        if let id = id {
            builder = builder.where(SQLColumn(SQLRaw("id")), .equal, SQLBind(id))
        }
        if let authState = authState {
            builder = builder.where(SQLColumn(SQLRaw("authState")), .equal, SQLBind(authState))
        }
        let futureOnDBEventLoop = builder.all()
        return futureOnDBEventLoop
            .hop(to: eventLoop)
            .flatMapThrowing({ rowArray -> [AccountAccessConsent] in
                var resultArray = [AccountAccessConsent]()
                for row in rowArray {
                    let dataString: String = try row.decode(column: "json", as: String.self)
                    let accountAccessConsent: AccountAccessConsent = try sm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(
                        AccountAccessConsent.self,
                        from: Data(dataString.utf8)
                    )
                    resultArray.append(accountAccessConsent)
                }
                return resultArray
            })
            .flatMapError({error in
                print(error)
                fatalError()
            })
        
    }
    
    func httpPostAuthCodeGrant(
        code: String,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<OBTokenEndpointResponse> {
        
        return eventLoop.makeSucceededFuture(())
            
            // Load OB client
            .flatMap({ OBClientProfile.load(
                id: self.obClientId,
                    softwareStatementProfileId: nil,
                    issuerURL: nil
                )
            })
            
            // Post claims
            .flatMap({ obClientArray -> EventLoopFuture<HTTPClient.Response> in
                guard obClientArray.count == 1 else {
                    fatalError()
                }
                let obClient = obClientArray[0]
                var authHeader: String? = nil // none by default
                var params = ["grant_type": "authorization_code",
                              "redirect_uri": self.obRequestObjectClaims.redirect_uri,
                              "code": code]
                if obClient.registrationClaims.token_endpoint_auth_method == "tls_client_auth" {
                    params["client_id"] = obClient.registrationData.client_id
                } else if obClient.registrationClaims.token_endpoint_auth_method == "client_secret_basic" {
                    let tmpString: String = obClient.registrationData.client_id + ":" + obClient.registrationData.client_secret!
                    authHeader = "Basic " + Data(tmpString.utf8).base64EncodedString()
                } else {
                    fatalError() // Don't support other token endpoint auth options atm
                }
                var request = hcm.postRequest(
                    url: URL(string: obClient.openIDConfiguration.token_endpoint)!,
                    xFapiFinancialId: obClient.xFapiFinancialId,
                    authHeader: authHeader,
                    isFormUrlencoded: true
                )
                request.body = .string(tmpEncode(parameters: params))
                return hcm.executeMTLS(
                    request: request,
                    httpClientMTLSConfiguration: obClient.httpClientMTLSConfiguration
                )
            })
            
            // Decode response
            .flatMapThrowing({ response -> OBTokenEndpointResponse in
                if response.status == .ok,
                    var body = response.body {
                    let data = body.readData(length: body.readableBytes)!
                    let responseObject = try decoder.decode(
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
    
    func createAuthURL(
        authorization_endpoint: String,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<String> {
        
        // Generate JWS from claims
        return genJws(
            softwareStatementId: self.softwareStatementProfileId,
            claims: obRequestObjectClaims,
            on: eventLoop
        )
        
        // Post claims
        .flatMapThrowing({ requestObjectJws -> String in
            let params = ["response_type": self.obRequestObjectClaims.response_type,
                          "client_id": self.obRequestObjectClaims.client_id,
                          "redirect_uri": self.obRequestObjectClaims.redirect_uri,
                          "scope": self.obRequestObjectClaims.scope.asString(),
                          //"response_mode": obRequestObjectClaims.response_mode,
                          "request": requestObjectJws,
                          "nonce": self.obRequestObjectClaims.nonce,
                          "state": self.obRequestObjectClaims.state
            ]
            let authURI = authorization_endpoint + "?" + tmpEncode(parameters: params)
            print(authURI)
            return authURI
        })
    }

    
    
    
}
