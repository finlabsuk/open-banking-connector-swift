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
import BaseServices
import AccountTransactionTypeRequirements

public struct OBReadConsentLocal
<OBReadConsentApi: OBReadConsentProtocol>: AccountTransactionRequestObjectLocalProtocol {
    public typealias AccountTransactionRequestObjectApi = OBReadConsentApi
        
    public var data: OBReadConsentDataLocal
    <OBReadConsentApi.OBReadConsentDataApi>
    public var risk: OBRiskLocal
    <OBReadConsentApi.OBRiskApi>
    
    public init(
        data: OBReadConsentDataLocal
        <OBReadConsentApi.OBReadConsentDataApi>,
        risk: OBRiskLocal
        <OBReadConsentApi.OBRiskApi>
    ) {
        self.data = data
        self.risk = risk
    }
    
    public enum CodingKeys: String, CodingKey {
        case data = "Data"
        case risk = "Risk"
    }
    
    func apiValue() -> OBReadConsentApi {
        OBReadConsentApi.init(
            data: data.apiValue(),
            risk: risk.apiValue()
        )
    }
    
}

public struct OBReadConsentDataLocal
<OBReadConsentDataApi: OBReadConsentDataProtocol>: Codable {

    public enum Permissions: String, Codable {
        case readAccountsBasic = "ReadAccountsBasic"
        case readAccountsDetail = "ReadAccountsDetail"
        case readBalances = "ReadBalances"
        case readBeneficiariesBasic = "ReadBeneficiariesBasic"
        case readBeneficiariesDetail = "ReadBeneficiariesDetail"
        case readDirectDebits = "ReadDirectDebits"
        case readOffers = "ReadOffers"
        case readPAN = "ReadPAN"
        case readParty = "ReadParty"
        case readPartyPSU = "ReadPartyPSU"
        case readProducts = "ReadProducts"
        case readScheduledPaymentsBasic = "ReadScheduledPaymentsBasic"
        case readScheduledPaymentsDetail = "ReadScheduledPaymentsDetail"
        case readStandingOrdersBasic = "ReadStandingOrdersBasic"
        case readStandingOrdersDetail = "ReadStandingOrdersDetail"
        case readStatementsBasic = "ReadStatementsBasic"
        case readStatementsDetail = "ReadStatementsDetail"
        case readTransactionsBasic = "ReadTransactionsBasic"
        case readTransactionsCredits = "ReadTransactionsCredits"
        case readTransactionsDebits = "ReadTransactionsDebits"
        case readTransactionsDetail = "ReadTransactionsDetail"
    }
    public var permissions: [Permissions]
    /** Specified date and time the permissions will expire. If this is not populated, the permissions will be open ended.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var expirationDateTime: Date?
    /** Specified start date and time for the transaction query period. If this is not populated, the start date will be open ended, and data will be returned from the earliest available transaction.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var transactionFromDateTime: Date?
    /** Specified end date and time for the transaction query period. If this is not populated, the end date will be open ended, and data will be returned to the latest available transaction.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var transactionToDateTime: Date?

    public init(permissions: [Permissions], expirationDateTime: Date?, transactionFromDateTime: Date?, transactionToDateTime: Date?) {
        self.permissions = permissions
        self.expirationDateTime = expirationDateTime
        self.transactionFromDateTime = transactionFromDateTime
        self.transactionToDateTime = transactionToDateTime
    }

    public enum CodingKeys: String, CodingKey {
        case permissions = "Permissions"
        case expirationDateTime = "ExpirationDateTime"
        case transactionFromDateTime = "TransactionFromDateTime"
        case transactionToDateTime = "TransactionToDateTime"
    }
    
    func apiValue() -> OBReadConsentDataApi {
        let permissionsTmp: [OBReadConsentDataApi.Permissions] =
            permissions.map {OBReadConsentDataApi.Permissions(rawValue: $0.rawValue)!}
        return OBReadConsentDataApi.init(permissions: permissionsTmp, expirationDateTime: expirationDateTime, transactionFromDateTime: transactionFromDateTime, transactionToDateTime: transactionToDateTime)
    }

}


public struct OBRiskLocal
<OBRiskApi: OBRiskApiProtocol>: Codable {
    public init() { self = try! JSONDecoder().decode(Self.self , from: Data("{}".utf8))}

    func apiValue() -> OBRiskApi {
        OBRiskApi.init()
    }

}
