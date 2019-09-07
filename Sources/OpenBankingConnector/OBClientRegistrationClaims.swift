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
import SwiftJWT
import AsyncHTTPClient
import NIOFoundationCompat

struct DateExcludedFromEquatable: Codable, Equatable {
    let date: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        date = try container.decode(Date.self)
    }
    init(date: Date) {
        self.date = date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(date)
    }
    
    static func == (lhs: DateExcludedFromEquatable, rhs: DateExcludedFromEquatable) -> Bool {
        return true
    }
    
}

struct StringExcludedFromEquatable: Codable, Equatable {
    let string: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        string = try container.decode(String.self)
    }
    init(string: String) {
        self.string = string
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
    
    static func == (lhs: StringExcludedFromEquatable, rhs: StringExcludedFromEquatable) -> Bool {
        return true
    }
    
}






// See: https://openbanking.atlassian.net/wiki/spaces/DZ/pages/1078034771/Dynamic+Client+Registration+-+v3.2
struct OBClientRegistrationClaims: Claims, Equatable {

    let iss: String
    let iat: DateExcludedFromEquatable
    let exp: DateExcludedFromEquatable
    var aud: String
    let jti: StringExcludedFromEquatable
    let client_id: String?
    let redirect_uris: [String]
    var token_endpoint_auth_method: String
    var grant_types: [String]
    let response_types: [String]?
    let software_id: String?
    var scope: StringWithSpacesOrStringArray // NB: strictly should be string with spaces according to spec; we allow string array also
    let software_statement: String
    let application_type: String
    let id_token_signed_response_alg: String
    let request_object_signing_alg: String
    var token_endpoint_auth_signing_alg: String?
    let tls_client_auth_subject_dn: String?
    // NB subject_type removed
    
    mutating func applyOverrides(overrides: OBClientRegistrationClaimsOverrides?) {
        if let overrides = overrides {
            if let newValue = overrides.aud {
                aud = newValue
            }
            if let newValue = overrides.token_endpoint_auth_method {
                token_endpoint_auth_method = newValue
            }
            if let newValue = overrides.grant_types {
                grant_types = newValue
            }
            if let newValue = overrides.scope__useStringArray {
                scope = newValue ?
                    .stringArray(scope.asStringArray()) :
                    .stringWithSpaces(scope.asString())
            }
            if let newValue = overrides.token_endpoint_auth_signing_alg {
                token_endpoint_auth_signing_alg = newValue
            }
        }
    }
    
    static func initAsync(
        issuerURL: String,
        softwareStatementId: String,
        overrides: OBClientRegistrationClaimsOverrides?,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<OBClientRegistrationClaims> {
        return SoftwareStatementProfile.load(id: softwareStatementId, on: eventLoop)
            .flatMapThrowing({ softwareStatementProfile in
                OBClientRegistrationClaims.init(
                    issuerURL: issuerURL,
                    softwareStatementProfile: softwareStatementProfile,
                    overrides: overrides
                )
            })
    }
    
    func httpPost(
        softwareStatementProfileId: String,
        softwareStatementId: String,
        issuerURL: String,
        issuerRegistrationURL: String,
        httpClientMTLSConfigurationOverrides: HTTPClientMTLSConfigurationOverrides?,
        obClientRegistrationResponseOverrides: OBClientRegistrationResponseOverrides?,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<OBClient> {
        
        // Generate JWS from claims
        return genJws(
            softwareStatementId: softwareStatementId,
            claims: self,
            on: eventLoop
        )
            
            // Post claims
            .flatMap({ obClientRegistrationJws -> EventLoopFuture<HTTPClient.Response> in
                var request = hcm.postRequestRegistration(
                    url: URL(string: issuerRegistrationURL)!
                )
                request.body = .string(obClientRegistrationJws)
                return hcm.executeMTLS(request: request, softwareStatementId: softwareStatementId, httpClientMTLSConfigurationOverrides: httpClientMTLSConfigurationOverrides)
            })
            
            // Decode response
            .flatMapThrowing({ response -> OBClientRegistrationResponse in
                if response.status == .created,
                    var body = response.body {
                    let data = body.readData(length: body.readableBytes)!
                    var responseObject = try decoder.decode(
                        OBClientRegistrationResponse.self,
                        from: data)
                    responseObject.applyOverrides(overrides: obClientRegistrationResponseOverrides)
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
            
            // Check response and create OBClient
            .flatMapThrowing({ response -> OBClient in
                // Currently not checking these:
                // let client_id: String
                // let client_secret: String?
                // let client_id_issued_at: Date?
                // let client_secret_expires_at: Date?
                // let redirect_uris: [String]
                precondition(
                    response.token_endpoint_auth_method.asString() == self.token_endpoint_auth_method
                )
                precondition(response.grant_types == self.grant_types)
                precondition(response.response_types == self.response_types)
                // Currently not checking these:
                // let software_id: String?
                // precondition(response.software_id == self.software_id)
                if let responseScope = response.scope {
                    precondition(Set(responseScope.asStringArray()).isSuperset(of: Set(self.scope.asStringArray())))
                }
                if let response_application_type = response.application_type {
                    precondition(response_application_type == self.application_type)
                }
                precondition(response.id_token_signed_response_alg == self.id_token_signed_response_alg)
                precondition(
                    response.request_object_signing_alg.asString() == self.request_object_signing_alg
                )
               precondition(response.token_endpoint_auth_signing_alg?.asString() ==
                    self.token_endpoint_auth_signing_alg
                )
                // Currently not checking these:
                // let tls_client_auth_subject_dn: String?
                // precondition(response.tls_client_auth_subject_dn == self.tls_client_auth_subject_dn)
                
                // Convert response to OBClient
                let obClientASPSPData = OBClientASPSPData(
                    client_id: response.client_id,
                    client_secret: response.client_secret,
                    client_id_issued_at: response.client_id_issued_at,
                    client_secret_expires_at: response.client_secret_expires_at
                )
                return OBClient(
                    softwareStatementProfileId: softwareStatementProfileId,
                    issuerURL: issuerURL,
                    registrationClaims: self,
                    aspspData: obClientASPSPData
                )
            })
            
            .flatMapError({error in
                print(error)
                fatalError()
            })
    }
    
    
}

extension OBClientRegistrationClaims {
    
    init(
        issuerURL: String,
        softwareStatementProfile: SoftwareStatementProfile,
        overrides: OBClientRegistrationClaimsOverrides?
    ) {
        self.init(
            iss: softwareStatementProfile.softwareStatementId,
            iat: DateExcludedFromEquatable(
                date: Date() // TODO: change format to avoid fractional value?
            ),
            exp: DateExcludedFromEquatable(
                date: Date(timeIntervalSinceNow: 3600) // TODO: change format to avoid fractional value?
            ),
            aud: issuerURL,
            jti: StringExcludedFromEquatable(
                string: UUID().uuidString
            ),
            client_id: nil,
            redirect_uris: softwareStatementProfile.redirectURLs,
            token_endpoint_auth_method: "tls_client_auth",
            grant_types: ["client_credentials", "authorization_code", "refresh_token"],
            response_types: ["code id_token"],
            software_id: softwareStatementProfile.softwareStatementId,
            scope: .stringWithSpaces(softwareStatementProfile.scope),
            software_statement: softwareStatementProfile.softwareStatement,
            application_type: "web",
            id_token_signed_response_alg: "PS256",
            request_object_signing_alg: "PS256",
            token_endpoint_auth_signing_alg: nil,
            tls_client_auth_subject_dn: "CN=\(softwareStatementProfile.id),OU=\(softwareStatementProfile.orgId),O=OpenBanking,C=GB"
        )
        self.applyOverrides(overrides: overrides)
    }
}
