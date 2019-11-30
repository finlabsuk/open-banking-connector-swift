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
import SQLKit
import BaseServices

/// Struct corresponding to payload of Open Banking Software Statement type. Fields can be added as required
struct SoftwareStatementPayload: Codable {
    static let softwareRoleToScope = [
        "AISP": "accounts",
        "PISP": "payments",
        "CBPII": "fundsconfirmations"
    ]
    
    let software_id: String
    let software_client_id: String
    let software_client_name: String
    let software_client_description: String
    let software_version: Int
    let software_client_uri: String
    let software_redirect_uris: [String]
    let software_roles: [String]
    let org_id: String
    let org_name: String
    let software_on_behalf_of_org: String
    
    /// Scope list computed from software_roles
    var scope: String {
        var mutatingSoftwareRoles = software_roles
            .compactMap { SoftwareStatementPayload.softwareRoleToScope[$0] }
        mutatingSoftwareRoles
            .insert("openid", at: 0)
        return mutatingSoftwareRoles.joined(separator: " ")
    }
}

struct SoftwareStatementProfile: StoredItem {
    
    // ********************************************************************************
    // MARK: StoredItem Template Code
    // ********************************************************************************
    
    /// ID used to uniquely identify object (cannot be changed, create new object to change)
    /// - returns: A String object.
    var id: String {
        get {
            return self.softwareStatementPayload.software_id
        }
    }
    
    // Association of data object with other data objects ("ownership")
    // Empty strings used for types where association doesn't make sense
    /// "FinTech identity"
    var softwareStatementProfileId: String {
        get {
            return self.id
        }
    }
    /// "Bank (ASPSP) identity"
    let issuerURL: String = ""
    /// "Open Banking client identity"
    let obClientId: String = ""
    /// "User identity"
    let userId: String = ""
    
    /// State variable supplied to auth endpoint (used to process redirect); only relevant for consents that need authorisation
    var state: String = ""
    
    // Timestamp for object creation as best we can determine
    var created: Date = Date()
      
    // Deletion status for object
    //@Mutable var isDeleted: Bool = false
    var isDeleted: Mutable<Bool> = Mutable<Bool>(wrappedValue: false)
    
    // ********************************************************************************
    
    /// Software statement as string, e.g. "A.B.C"
    let softwareStatement: String
    
    /// Software statement payload. This is strictly redundant as representes decoding of software statement but
    /// useful for debugging.
    let softwareStatementPayload: SoftwareStatementPayload

    // Open Banking Signing Key ID as string, e.g. "ABC"
    let obSigningKID: String
    
    // Open Banking Signing Key as string, e.g. "-----BEGIN PRIVATE KEY-----\nABCD\n-----END PRIVATE KEY-----\n"
    let obSigningKey: String
    
    // Open Banking Signing Certificate as string, e.g. "-----BEGIN CERTIFICATE-----\nABC\n-----END CERTIFICATE-----\n"
    let obSigningPem: String
    
    // Open Banking Signing Key as string, e.g. "-----BEGIN PRIVATE KEY-----\nABCD\n-----END PRIVATE KEY-----\n"
    let obTransportKey: String
    
    // Open Banking Signing Certificate as string, e.g. "-----BEGIN CERTIFICATE-----\nABC\n-----END CERTIFICATE-----\n"
    let obTransportPem: String
    
}

extension SoftwareStatementProfile {
    
    init(
        softwareStatementProfilePublic: SoftwareStatementProfilePublic
    ) throws {
        // Extract payload from software statement
        let softwareStatementComponentsBase64 = softwareStatementProfilePublic.softwareStatement.components(separatedBy: ".")
        guard softwareStatementComponentsBase64.count == 3 else {
            throw("Software statement JWT needs three parts")
        }
        var softwareStatementPayloadBase64 = softwareStatementComponentsBase64[1]
        let remainder = softwareStatementPayloadBase64.count % 4
        if remainder > 0 {
            softwareStatementPayloadBase64 = softwareStatementPayloadBase64.padding(
                toLength: softwareStatementPayloadBase64.count + 4 - remainder,
                withPad: "=",
                startingAt: 0
            )
        }
        guard let softwareStatementPayloadData = Data(base64Encoded: softwareStatementPayloadBase64, options: .ignoreUnknownCharacters)
            else {
                throw("Software statement payload not valid Base64")
        }
        let softwareStatementPayload = try hcm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(SoftwareStatementPayload.self, from: softwareStatementPayloadData)
        self.init(
            softwareStatement: softwareStatementProfilePublic.softwareStatement,
            softwareStatementPayload: softwareStatementPayload,
            obSigningKID: softwareStatementProfilePublic.obSigningKID,
            obSigningKey: softwareStatementProfilePublic.obSigningKey,
            obSigningPem: softwareStatementProfilePublic.obSigningPem,
            obTransportKey: softwareStatementProfilePublic.obTransportKey,
            obTransportPem: softwareStatementProfilePublic.obTransportPem
        )
        
    }
}
