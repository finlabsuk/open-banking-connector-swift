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
import AccountTransactionTypeRequirements
import BaseServices

public struct OBATLocalAccount<OBATApiResourceType: OBAccountProtocol>: OBATLocalResourceProtocol {
    
    // ********************************************************************************
    // MARK: OBATLocalResourceProtocol Template Code
    // ********************************************************************************
    
    public init(
        softwareStatementProfileId: String,
        issuerURL: String,
        obClientId: String,
        userId: String,
        aspspData: OBATApiResourceType
    ) {
        self.softwareStatementProfileId = softwareStatementProfileId
        self.issuerURL = issuerURL
        self.obClientId = obClientId
        self.userId = userId
        self.aspspData = aspspData
    }
    
    /// ID used to uniquely identify object (cannot be changed, create new object to change)
    /// - returns: A String object.
    public let id: String = UUID().uuidString.lowercased()
    
    // Association of data object with other data objects ("ownership")
    // Empty strings used for types where association doesn't make sense
    /// "FinTech identity"
    public let softwareStatementProfileId: String

    /// "Bank (ASPSP) identity"
    public let issuerURL: String
    /// "Open Banking client identity"
    public let obClientId: String
    /// "User identity"
    public let userId: String
    
    /// State variable supplied to auth endpoint (used to process redirect); only relevant for consents that need authorisation
    public let state: String = ""
    
    // Timestamp for object creation as best we can determine
    public let created: Date = Date()
      
    // Deletion status for object
    //@Mutable var isDeleted: Bool = false
    public var isDeleted: Mutable<Bool> = Mutable<Bool>(wrappedValue: false)
    
    public var aspspData: OBATApiResourceType
    
    // ********************************************************************************

    public var uiName: String? = nil
    public var currency = "GBP"
}
