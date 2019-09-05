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

struct OBClientASPSPData: Codable {
    let client_id: String
    let client_secret: String?
    let client_id_issued_at: Date?
    let client_secret_expires_at: Date?
}

struct OBClient: StoredItem {
    
    // ********************************************************************************
    // MARK: StoredItem Template Code
    // ********************************************************************************
    
    /// ID used to uniquely identify object (cannot be changed, create new object to change)
    /// - returns: A String object.
    var id: String {
        get {
            return self.issuerURL + "_" + self.aspspData.client_id
        }
    }
    
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
    
    // Timestamp for object creation as best we can determine
    let created: Date = Date()
    
    // Deletion status for object/object change
    //@Mutable var isDeleted: Bool = false
    var isDeleted: Mutable<Bool> = Mutable<Bool>(wrappedValue: false)
    
    // ********************************************************************************
    
    init( // TODO: Remove after Swift 5.1
        softwareStatementProfileId: String,
        issuerURL: String,
        requestClaims: OBClientRegistrationClaims,
        aspspData: OBClientASPSPData
    ) {
        self.softwareStatementProfileId = softwareStatementProfileId
        self.issuerURL = issuerURL
        self.requestClaims = requestClaims
        self.aspspData = aspspData
    }
    
    let requestClaims: OBClientRegistrationClaims
    
    let aspspData: OBClientASPSPData
    
}
