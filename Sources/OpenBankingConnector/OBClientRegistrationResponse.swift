// ********************************************************************************
//
// This source file is part of the Open Banking Connector project.
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

// See: https://openbanking.atlassian.net/wiki/spaces/DZ/pages/1078034771/Dynamic+Client+Registration+-+v3.2
struct OBClientRegistrationResponse: Decodable {
    let client_id: String
    let client_secret: String?
    let client_id_issued_at: Date?
    let client_secret_expires_at: Date?
    let redirect_uris: [String]
    let token_endpoint_auth_method: StringOrSingleElementStringArray // NB: should be String according to spec
    var grant_types: [String]
    let response_types: [String]?
    let software_id: String?
    let scope: StringWithSpacesOrStringArray? // TODO: should be non-optional String according to spec
    //let software_statement: String // TODO: should be included and flattened according to spec....
    let application_type: String? // TODO should be non-optional String according to spec
    let id_token_signed_response_alg: String
    let request_object_signing_alg: StringOrSingleElementStringArray // NB: should be String according to spec
    let token_endpoint_auth_signing_alg: StringOrSingleElementStringArray? // NB: should be String? according to spec
    let tls_client_auth_subject_dn: String?
    
    mutating func applyOverrides(overrides: OBClientRegistrationResponseOverrides?) {
        if let overrides = overrides {
            if let newValue = overrides.grant_types {
                grant_types = newValue
            }
        }
    }
    
}
