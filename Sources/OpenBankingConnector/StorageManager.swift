// ********************************************************************************
//
// This source file is part of the Open Banking Connector open source project
//
// Copyright (C) 2019 Finnovation Labs and the Open Banking Connector project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
// ********************************************************************************

import Foundation
import SQLiteKit

// Reference to singleton for convenient access
let sm = StorageManager.shared

/// Class for persisting data to local storage. Uses SQLite.
final class StorageManager {
    
    static var shared = StorageManager(file: "./db.sqlite3")
    
    var db: ConnectionPool<SQLiteConnectionSource>!
    let jsonEncoder: JSONEncoder = JSONEncoder()
    let jsonDecoder: JSONDecoder = JSONDecoder()
    init(
        file: String,
        dropTables: Bool = false
    ) {
        let threadPool = NIOThreadPool.init(numberOfThreads: 6)
        let db = SQLiteConnectionSource(
            configuration: .init(storage: .connection(.file(path: file))), // creates file if missing?
            threadPool: threadPool,
            on: storageEventLoop
        )
        self.db = ConnectionPool(config: .init(maxConnections: 8), source: db)
        
        createTables(dropTables: dropTables)

    }
    
    /// Creates the tables (if they don't exist), drops the tables beforehand if dropTables is true.
    /// - returns: Void.
    func createTables(dropTables: Bool = false) {

        var currentFuture = storageEventLoop.makeSucceededFuture(())
        
        for type in storedItemConformingTypes.values {
            
            if (dropTables) {
                currentFuture = currentFuture
                    .flatMap({
                        type.dropTable()
                    })
            }
            currentFuture = currentFuture
                .flatMap({
                    type.createTable()
                })
            
        }
        currentFuture.flatMapError({error in
            print(error)
            fatalError()
        })

    }
}
