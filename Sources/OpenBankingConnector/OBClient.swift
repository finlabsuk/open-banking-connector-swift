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
    var id: String = UUID().uuidString
    
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
        registrationClaims: OBClientRegistrationClaims,
        aspspData: OBClientASPSPData
    ) {
        self.softwareStatementProfileId = softwareStatementProfileId
        self.issuerURL = issuerURL
        self.registrationClaims = registrationClaims
        self.aspspData = aspspData
    }
    
    let registrationClaims: OBClientRegistrationClaims
    
    let aspspData: OBClientASPSPData
    
    static func load(
        id: String?,
        softwareStatementProfileId: String?,
        issuerURL: String?,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<[OBClient]> {
        
        var builder = sm.db.select()
            .column(SQLRaw("json"))
            .from(self.tableName)
        if let id = id {
            builder = builder.where(SQLColumn(SQLRaw("id")), .equal, SQLBind(id))
        }
        if let softwareStatementProfileId = softwareStatementProfileId {
            builder = builder.where(SQLColumn(SQLRaw("softwareStatementProfileId")), .equal, SQLBind(softwareStatementProfileId))
        }
        if let issuerURL = issuerURL {
            builder = builder.where(SQLColumn(SQLRaw("issuerURL")), .equal, SQLBind(issuerURL))
        }
        let futureOnDBEventLoop = builder.all()
        return futureOnDBEventLoop
            .hop(to: eventLoop)
            .flatMapThrowing({ rowArray -> [OBClient] in
                var resultArray = [OBClient]()
                for row in rowArray {
                    let dataString: String = try row.decode(column: "json", as: String.self)
                    let obClient: OBClient = try sm.jsonDecoder.decode(
                        OBClient.self,
                        from: Data(dataString.utf8)
                    )
                    resultArray.append(obClient)
                }
                return resultArray
            })
            .flatMapError({error in
                print(error)
                fatalError()
            })
        
    }
    
}
