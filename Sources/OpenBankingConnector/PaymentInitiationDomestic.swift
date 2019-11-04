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
import PaymentInitiationTypes

struct PaymentInitiationDomestic: StoredItem {
    
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
    var state: String {
        get {
            return ""
        }
    }
    
    // Timestamp for object creation as best we can determine
    let created: Date = Date()
    
    // Deletion status for object/object change
    //@Mutable var isDeleted: Bool = false
    var isDeleted: Mutable<Bool> = Mutable<Bool>(wrappedValue: false)
    
    // ********************************************************************************
    
    let typeName = String(describing: Self.self)
    
    init(
        softwareStatementProfileId: String,
        issuerURL: String,
        obClientId: String
    ) {
        self.softwareStatementProfileId = softwareStatementProfileId
        self.issuerURL = issuerURL
        self.obClientId = obClientId
    }
    
}
