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
import SQLiteKit

/// Class for persisting data to local storage. Uses SQLite.
final class StorageManager {
    
    var db = ThreadSpecificVariable<ConnectionPool<SQLiteConnectionSource>>()
    
    let jsonEncoderDateFormatISO8601WithMilliSeconds: JSONEncoder = JSONEncoder()
    let jsonDecoderDateFormatISO8601WithMilliSeconds: JSONDecoder = JSONDecoder()

    init(
        file: String,
        threadPool: NIOThreadPool
    ) {
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        jsonEncoderDateFormatISO8601WithMilliSeconds.dateEncodingStrategy = .custom({ (date, encoder) in
            var container = encoder.singleValueContainer()
            try container.encode(dateFormatter.string(from: date))
        })
        jsonDecoderDateFormatISO8601WithMilliSeconds.dateDecodingStrategy = .custom({decoder in
            let value = try decoder.singleValueContainer()
            let stringValue = try value.decode(String.self)
            guard let date = dateFormatter.date(from: stringValue) else {
                throw "Can't convert from String to Date"
            }
            return date
        })
        
        eventLoopGroup.makeIterator().forEach { eventLoop in
            try! eventLoop.submit({
                let source = SQLiteConnectionSource(
                    configuration: .init(storage: .connection(.file(path: file))), // creates file if missing?
                    threadPool: threadPool
                )
                let pool = ConnectionPool(configuration: .init(maxConnections: 8), source: source, on: eventLoop)
                self.db.currentValue = pool
            }).wait()
        }
        
    }
    
    deinit {
        eventLoopGroup.makeIterator().forEach { eventLoop in
            try! eventLoop.makeSucceededFuture(())
                .flatMapThrowing({_ in
                    self.db.currentValue!.shutdown()
                }).wait()
        }
    }
    
    /// Creates the tables (if they don't exist), drops the tables beforehand if dropTables is true.
    /// - returns: Void.
    func createTables(
        dropTables: Bool = false,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Void> {
        //print(MultiThreadedEventLoopGroup.currentEventLoop)
        var currentFuture = eventLoop.makeSucceededFuture(())
        for type in storedItemConformingTypes.values {
            if (dropTables) {
                currentFuture = currentFuture
                    .flatMap({
                        type.dropTable()
                    })
            }
            currentFuture = currentFuture
                .flatMap({
                    //print(self.db.currentValue!)
                    //print(self.dbThreadPool.currentValue!)
                    return type.createTable()
                })
        }
        return currentFuture
    }

}
