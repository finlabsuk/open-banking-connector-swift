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

//@propertyWrapper
public struct Mutable<V: Codable>: Codable {

    var value: V
    var modified: Date
    
    public init(wrappedValue: V) {
        value = wrappedValue
        modified = Date()
    }
    
    var wrappedValue: V {
        get { return value }
        set {
            value = newValue
            modified = Date()
        }
    }
}

/// Data Item that can be persisted in database and synced between devices.
public protocol StoredItem: Codable {
    
    // ********************************************************************************
    // MARK: Stored properties (persist to storage)
    // ********************************************************************************

    /// Unique identity of data object
    var id: String { get }
    
    // Association of data object with other data objects ("ownership")
    // Empty strings used for types where association doesn't make sense
    /// "FinTech identity"
    var softwareStatementProfileId: String { get }
    /// "Bank (ASPSP) identity"
    var issuerURL: String { get }
    /// "Open Banking client identity"
    var obClientId: String { get }
    /// "User identity"
    var userId: String { get }
    
    /// State variable; relevant for consents that need authorisation and payments
    var state: String { get }
    
    /// Data object creation date
    var created: Date { get }
    
    // Has data object been deleted?
    // (Done this way to support "undo" and merging of data objects from different DB - latest
    // value wins.)
    var isDeleted: Mutable<Bool> { get set }

    // ********************************************************************************
    // MARK: Stored properties (don't persist to storage)
    // ********************************************************************************

    // ********************************************************************************
    // MARK: Required methods
    // ********************************************************************************

    // ********************************************************************************
    // MARK: Optional methods
    // ********************************************************************************

}

