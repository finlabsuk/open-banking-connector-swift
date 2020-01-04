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
import AccountTransactionTypes
import PaymentInitiationTypes

enum AccountTransactionPaymentInitiationPostedObjectVariant: Codable {
    enum CodingKeys: CodingKey {
        case variantName
        case apiVersion
    }
    enum ThisEnumWithRawValues: String, Codable {
        case accountAccessConsent
        case domesticPaymentConsent
        case domesticPayment
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let thisEnumWithRawValues = try container.decode(ThisEnumWithRawValues.self, forKey: .variantName)
        switch thisEnumWithRawValues {
        case .accountAccessConsent:
            self = .accountAccessConsent(try container.decode(AccountTransactionApiVersion.self, forKey: .apiVersion))
        case .domesticPaymentConsent:
            self = .domesticPaymentConsent(try container.decode(PaymentInitiationApiVersion.self, forKey: .apiVersion))
        case .domesticPayment:
            self = .domesticPayment(try container.decode(PaymentInitiationApiVersion.self, forKey: .apiVersion))
        }
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .accountAccessConsent(let accountTransactionApiVersion):
            try container.encode(ThisEnumWithRawValues.accountAccessConsent, forKey: .variantName)
            try container.encode(accountTransactionApiVersion, forKey: .apiVersion)
        case .domesticPaymentConsent(let paymentInitiationApiVersion):
            try container.encode(ThisEnumWithRawValues.domesticPaymentConsent, forKey: .variantName)
            try container.encode(paymentInitiationApiVersion, forKey: .apiVersion)
        case .domesticPayment(let paymentInitiationApiVersion):
            try container.encode(ThisEnumWithRawValues.domesticPayment, forKey: .variantName)
            try container.encode(paymentInitiationApiVersion, forKey: .apiVersion)
        }
    }
    case accountAccessConsent(AccountTransactionApiVersion)
    case domesticPaymentConsent(PaymentInitiationApiVersion)
    case domesticPayment(PaymentInitiationApiVersion)
}

struct AccountTransactionConsent: ConsentProtocol {
    
    // ********************************************************************************
    // MARK: StoredItem Template Code
    // ********************************************************************************
    
    /// ID used to uniquely identify object (cannot be changed, create new object to change)
    /// - returns: A String object.
    var id: String = UUID().uuidString.lowercased()
    
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
            return obRequestObjectClaims.state
        }
    }
    
    // Timestamp for object creation as best we can determine
    let created: Date = Date()
    
    // Deletion status for object/object change
    //@Mutable var isDeleted: Bool = false
    var isDeleted: Mutable<Bool> = Mutable<Bool>(wrappedValue: false)
    
    // ********************************************************************************
    
    let typeName = String(describing: Self.self)
    
    //let typeVariant: AccountTransactionPaymentInitiationPostedObjectVariant = .accountAccessConsent(.V3p1p1) // TODO: Change
    
    let obRequestObjectClaims: OBRequestObjectClaims
    
    var obTokenEndpointResponse: OBTokenEndpointResponse? = nil
    
    init(
        softwareStatementProfileId: String,
        issuerURL: String,
        obClientId: String,
        obRequestObjectClaims: OBRequestObjectClaims
    ) {
        self.softwareStatementProfileId = softwareStatementProfileId
        self.issuerURL = issuerURL
        self.obClientId = obClientId
        self.obRequestObjectClaims = obRequestObjectClaims
    }
    
}
