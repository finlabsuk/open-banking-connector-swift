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

struct OBRequestObjectClaimsInnerClaims: Codable {
    struct IndividualClaim: Codable {
        let essential: Bool?
        let value: String?
        let values: [String]?
    }
    struct UserInfoClaims: Codable {
        let openbanking_intent_id: IndividualClaim
        init(intentId: String) {
            self.openbanking_intent_id = IndividualClaim(essential: true, value: intentId, values: nil)
        }
    }
    struct IdTokenClaims: Codable {
        let openbanking_intent_id: IndividualClaim
        let acr: IndividualClaim
        init(intentId: String) {
            self.openbanking_intent_id = IndividualClaim(essential: true, value: intentId, values: nil)
            self.acr = IndividualClaim(essential: true, value: "urn:openbanking:psd2:ca", values: nil)
        }
    }
    let userinfo: UserInfoClaims
    let id_token: IdTokenClaims
    init(intentId: String) {
        self.userinfo = UserInfoClaims(intentId: intentId)
        self.id_token = IdTokenClaims(intentId: intentId)
    }
    
}

struct OBRequestObjectClaims: Claims {
    
    let iss: String
    let aud: String
    let jti: StringExcludedFromEquatable
//    let iat = DateExcludedFromEquatable(
//        date: Date() // TODO: change format to avoid fractional value?
//    )
//    let exp = DateExcludedFromEquatable(
//        date: Date(timeIntervalSinceNow: 3600) // TODO: change format to avoid fractional value?
//    )
    
    let response_type: String
    let client_id: String
    let redirect_uri: String
    let scope: StringWithSpacesOrStringArray
    //let response_mode: String
    
    let max_age: Int
    let claims: OBRequestObjectClaimsInnerClaims
    
    let nonce = UUID().uuidString.lowercased()
    let state = UUID().uuidString.lowercased()
    
//    func encode() throws -> String {
//        var data = try hcm.jsonEncoderDateFormatSecondsSince1970.encode(self)
//        let oldString = String(decoding: data, as: UTF8.self)
//        print(oldString)
//        let newString = oldString.replacingOccurrences(of: "\\/", with: "/")
//        print(newString)
//        data = Data(newString.utf8)
//        return data.base64urlEncodedString()
//    }
    
}

extension OBClientProfile {
    
    func getOBRequestObjectClaims(
        redirect_uri: String,
        scope: StringWithSpacesOrStringArray,
        intentId: String
    ) -> OBRequestObjectClaims {
        return OBRequestObjectClaims(
            iss: self.registrationData.client_id,
            aud: self.issuerURL,
            jti: StringExcludedFromEquatable(
                string: UUID().uuidString.lowercased()
            ),
            response_type: "code id_token",
            client_id: self.registrationData.client_id,
            redirect_uri: redirect_uri,
            scope: scope,
            //response_mode: "form_post",
            max_age: 86400,
            claims: OBRequestObjectClaimsInnerClaims(intentId: intentId)
        )
    }

}
