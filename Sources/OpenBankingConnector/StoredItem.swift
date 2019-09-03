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

//@propertyWrapper
struct Mutable<V: Codable>: Codable {

    var value: V
    var modified: Date
    
    init(wrappedValue: V) {
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

/// List of conforming types to allow storage setup etc
let storedItemConformingTypes: [String: StoredItem.Type] = [
    OBClient.typeName:                      OBClient.self,
    SoftwareStatementProfile.typeName:      SoftwareStatementProfile.self
]

/// Data Item that can be persisted in database and synced between devices.
protocol StoredItem: Codable {
    
    // ********************************************************************************
    // MARK: Stored properties (persist to storage)
    // ********************************************************************************

    var id: String {get}
    var obClientOwnerId: String? {get}
    var userOwnerId: String? {get}
    var created: Date {get}
    
    var isDeleted: Mutable<Bool> {get set}

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

extension StoredItem {
    
    // ********************************************************************************
    // MARK: Default implementations of optional methods
    // ********************************************************************************
        
    // ********************************************************************************
    // MARK: Methods not exposed for customisation
    // ********************************************************************************
    
    static var typeName: String {
        get {
            return String(describing: self)
        }
    }
    
    static var tableName: String {
        get {
            return String(describing: self) + "s"
        }
    }
    
    var tableNameTmp: String { // Can remove after Swift 5.1
        get {
            return String(describing: type(of: self)) + "s"
        }
    }
    
    static func dropTable() -> EventLoopFuture<Void> {
        return sm.db.drop(table: tableName)
            .ifExists()
            .run()
            .flatMapError({error in
                print(error)
                fatalError()
            })
    }
    
    static func createTable() -> EventLoopFuture<Void> {
        return sm.db.create(table: tableName)
            .ifNotExists()
            .column("id", type: .text, .primaryKey(autoIncrement: false)) // need to add .notNull
            .column("obClientOwnerId", type: .text)
            .column("userOwnerId", type: .text)
            .column("json", type: .text, .notNull)
            .run()
            .flatMapError({error in
                print(error)
                fatalError()
            })
    }
    
    func insert() -> EventLoopFuture<Void> {
        print(tableNameTmp)
        return sm.db.insert(into: tableNameTmp)
            .columns("id", "obClientOwnerId", "userOwnerId", "json")
            .values(SQLBind(id), SQLBind(obClientOwnerId), SQLBind(userOwnerId),
                    SQLBind(self.encodeString()))
            .run()
            .flatMapError({error in
                print(error)
                fatalError()
            })
    }
    
    /// Encode JSON (gets around bug that stops direct use in other places)
    func encode() -> Data {
        return try! sm.jsonEncoder.encode(self)
    }
    
    /// Encode JSON (gets around bug that stops direct use in other places)
    func encodeString() -> String {
        let data: Data = self.encode()
        return String(data: data, encoding: .utf8)!
    }

}

