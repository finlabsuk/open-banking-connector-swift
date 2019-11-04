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
import AccountTransactionTypes

// HOWTO: To test with different OB spec version
//
// Make changes to: ASPSPSession.ts:371
//    async getData(state, token, obInfos): Promise<DataItemWrapped[]> {
//        ...
//        requestPromise(options).then(
//            result => ({
//                typeName: obInfo.type,
//                typeVer: 'V3p1p1',
//                item: result.body
//            })
//        )

// HOWTO: Add support for a new OB property to Mny App type
// NOTE: This guide is probably outdated, because since it was writted we added general protocols for all OB Account Information resources (including Read, ReadData, and Base levels)
//
// EXAMPLE:
//   struct OBStatement2 {
//       var statementDateTime: [OBStatementDateTime1]?
//   }
//
// NOTE:
//  To make debugging easier work only OBReadWriteV3p1p1.swift at first (comment out the code in OBReadWriteV3p0p0.swift)
//
// Step 1. Add to Statement (Mny App class)
//
//     In Statement.swift:
//        a. add the field to property declarations
//        b. add new field to initialiser
//        c. add new field to CodingKeys
//
// Step 2. Add to OBProtocols (interfaces to OB types)
//     In OBReadWrite.swift (protocol "types" - generic version-free interface):
//
//         // Supporting protocols
//
//         protocol OBStatementDateTimeProtocol {
//             var dateTime: Date {get}
//         }
//
//         // Statement type protocols
//
//         protocol OBStatementProtocol {
//            associatedtype OBStatementDateTimeType: OBStatementDateTimeProtocol
//            var statementDateTime: [OBStatementDateTimeType]? {get}
//         }
//
//     In OBReadWriteV3p1p1.swift (concrete types):
//
//         // Statement conformances
//
//         extension OBStatementDateTime1: OBStatementDateTimeProtocol {}
//
// Step 3. Add to conveniece initialiser
//
//     In OBExtension.swift
//
//         var dates: [Date] = []
//         if let statementDateTimeArray = obStatement.statementDateTime {
//             for statementDateTime in statementDateTimeArray {
//                 dates.append( statementDateTime.dateTime )
//             }
//         }
//
//         self.init(
//             id:              Statement.createId(statementId: obStatement.statementId,
//             accountId: obStatement.accountId,
//             institutionId: institutionId),
//             owner:           ownerId,
//             accountId:       obStatement.accountId,
//             statementId:     obStatement.statementId,
//             statementReference: obStatement.statementReference,
//             startDate:       obStatement.startDateTime,
//             endDate:         obStatement.endDateTime,
//             type:            obStatement.type.rawValue,
//             statementDate:   dates,
//             statementAmount: amounts
//         )


// MARK:- Supporting protocols

protocol RawRepresentableWithStringRawValue: RawRepresentable where RawValue == String { }

protocol OBActiveOrHistoricCurrencyAndAmountProtocol {
    var amount: String {get}
    var currency: String {get}
}

protocol OBTransactionCashBalanceProtocol {
    associatedtype CreditDebitIndicatorType: RawRepresentableWithStringRawValue
    var nestedAmount: String {get}
    var creditDebitIndicator: CreditDebitIndicatorType {get}
}

protocol OBStatementDateTimeProtocol {
    var dateTime: Date {get}
}

protocol OBStatementAmountProtocol {
    associatedtype CreditDebitIndicatorType: RawRepresentableWithStringRawValue
    associatedtype OBActiveOrHistoricCurrencyAndAmountType: OBActiveOrHistoricCurrencyAndAmountProtocol
    var amount: OBActiveOrHistoricCurrencyAndAmountType {get}
    var creditDebitIndicator: CreditDebitIndicatorType {get}
}

// MARK:- General protocols for all OB Account Information resources (including Read, ReadData, and Base levels)

// NEW: Top-level protocols with more flexibility
protocol OBAIReadResourceData2Protocol { }
protocol OBAIReadResource2Protocol: OBItem {
    associatedtype OBAIReadResourceDataType: OBAIReadResourceData2Protocol
    var data: OBAIReadResourceDataType { get set }
}
extension OBAIReadResource2Protocol { public func validateDecoding() throws {} }

protocol OBAIReadResourceProtocol: OBItem {
    associatedtype OBAIReadResourceDataType: OBAIReadResourceDataProtocol
    var data: OBAIReadResourceDataType { get }
}

extension OBAIReadResourceProtocol {
    
    public func validateDecoding() throws {
        if data.resource == nil {
            throw "ERROR: Could not decode \(Self.typeName). Check input JSON for consistency."
        }
    }
       
}

protocol OBAIReadResourceDataProtocol: OBAIReadResourceData2Protocol {
    associatedtype OBAIResourceType: OBAIResourceProtocol
    var resource: [OBAIResourceType]? { get }
}

protocol OBAIResourceProtocol0: Codable {
    func encode<K: CodingKey>(
        container: inout KeyedEncodingContainer<K>,
        forKey: KeyedEncodingContainer<K>.Key) throws
//    static func create<K: CodingKey>(
//        container: KeyedDecodingContainer<K>,
//        forKey: KeyedDecodingContainer<K>.Key) throws -> Self
}

extension OBAIResourceProtocol0 {
    func encode<K: CodingKey>(
        container: inout KeyedEncodingContainer<K>,
        forKey: KeyedEncodingContainer<K>.Key) throws {
        try container.encode(self, forKey: forKey)
    }
    static func create<K: CodingKey>(
        container: KeyedDecodingContainer<K>,
        forKey: KeyedDecodingContainer<K>.Key) throws -> Self {
        return try container.decode(
            Self.self,
            forKey: forKey
        )
    }
}

// Protocol below for spec-version independent OB resource (e.g OBAccount3, OBTransaction5, etc) description.
protocol OBAIResourceProtocol: OBAIResourceProtocol0, OBAIReadResourceData2Protocol { // needed also for ASPSP JSON
}

// MARK:- Account type protocols

protocol OBAIReadAccountDataProtocol: OBAIReadResourceDataProtocol {
    var account: [OBAIResourceType]? { get }
}
extension OBAIReadAccountDataProtocol {
    var resource: [OBAIResourceType]? { return account }
}

protocol OBAIAccountProtocol: OBAIResourceProtocol {
    var nickname: String? {get}
    var accountId: String {get}
    var currency: String {get}
}

// MARK:- Direct debit type protocols

protocol OBAIReadDirectDebitDataProtocol: OBAIReadResourceDataProtocol {
    var directDebit: [OBAIResourceType]? { get }
}
extension OBAIReadDirectDebitDataProtocol {
    var resource: [OBAIResourceType]? { return directDebit }
}

protocol OBAIDirectDebitProtocol: OBAIResourceProtocol {
    // TODO: remove version from OBExternalDirectDebitStatus1CodeType
    associatedtype OBExternalDirectDebitStatus1CodeType: RawRepresentableWithStringRawValue
    associatedtype OBActiveOrHistoricCurrencyAndAmountType: OBActiveOrHistoricCurrencyAndAmountProtocol
    var directDebitStatusCode: OBExternalDirectDebitStatus1CodeType? {get}
    var previousPaymentAmount: OBActiveOrHistoricCurrencyAndAmountType? {get}
    var previousPaymentDateTime: Date? {get}
    var directDebitId: String? {get}
    var name: String {get}
    var accountId: String {get}
    var mandateIdentification: String {get}
}

// MARK:- Balance type protocols

protocol OBAIReadBalanceDataProtocol: OBAIReadResourceDataProtocol {
    var balance: [OBAIResourceType] { get }
}
extension OBAIReadBalanceDataProtocol {
    var resource: [OBAIResourceType]? { return balance }
}

protocol OBAIBalanceProtocol: OBAIResourceProtocol {
    associatedtype CreditDebitIndicatorType: RawRepresentableWithStringRawValue
    // TODO: remove version from...
    associatedtype OBBalanceType1CodeType: RawRepresentableWithStringRawValue
    associatedtype OBActiveOrHistoricCurrencyAndAmountType: OBActiveOrHistoricCurrencyAndAmountProtocol
    var accountId: String {get}
    var creditDebitIndicator: CreditDebitIndicatorType {get}
    var type: OBBalanceType1CodeType {get}
    var amount: OBActiveOrHistoricCurrencyAndAmountType {get}
    var dateTime: Date {get}
}


// MARK:- Standing order type protocols

protocol OBAIReadStandingOrderDataProtocol: OBAIReadResourceDataProtocol {
    var standingOrder: [OBAIResourceType]? { get }
}
extension OBAIReadStandingOrderDataProtocol {
    var resource: [OBAIResourceType]? { return standingOrder }
}

protocol OBAIStandingOrderProtocol: OBAIResourceProtocol {
    associatedtype OBActiveOrHistoricCurrencyAndAmountType0: OBActiveOrHistoricCurrencyAndAmountProtocol
    associatedtype OBActiveOrHistoricCurrencyAndAmountType1: OBActiveOrHistoricCurrencyAndAmountProtocol
    associatedtype OBActiveOrHistoricCurrencyAndAmountType2: OBActiveOrHistoricCurrencyAndAmountProtocol
    // TODO: remove version from...
    associatedtype OBCashAccount5Type: OBCashAccountProtocol
    var accountId: String { get }
    var standingOrderId: String? { get }
    var frequency: String { get }
    var reference: String? { get }
    var firstPaymentDateTime: Date? { get }
    var nextPaymentDateTime: Date? { get }
    var finalPaymentDateTime: Date? { get }
    var firstPaymentAmount: OBActiveOrHistoricCurrencyAndAmountType0? {get}
    var nextPaymentAmount: OBActiveOrHistoricCurrencyAndAmountType1? {get}
    var finalPaymentAmount: OBActiveOrHistoricCurrencyAndAmountType2? {get}
    var creditorAccount: OBCashAccount5Type? {get}
}

protocol OBCashAccountProtocol {
    var schemeName: String {get}
    var identification: String {get}
}

// MARK:- Statement type protocols

protocol OBAIReadStatementDataProtocol: OBAIReadResourceDataProtocol {
    var statement: [OBAIResourceType]? { get }
}
extension OBAIReadStatementDataProtocol {
    var resource: [OBAIResourceType]? { return statement }
}

protocol OBAIStatementProtocol: OBAIResourceProtocol {
    // TODO: remove version from...
    associatedtype OBExternalStatementType1CodeType: RawRepresentableWithStringRawValue
    associatedtype OBStatementDateTimeType: OBStatementDateTimeProtocol
    associatedtype OBStatementAmountType: OBStatementAmountProtocol
    var accountId: String { get }
    var statementId: String? { get }
    var statementReference: String? { get }
    var startDateTime: Date { get }
    var endDateTime: Date { get }
    var type: OBExternalStatementType1CodeType { get }
    var statementDateTime: [OBStatementDateTimeType]? {get}
    var statementAmount: [OBStatementAmountType]? {get}
    var statementDescription: [String]? {get}
}

// MARK:- Scheduled payment type protocols

protocol OBAIReadScheduledPaymentDataProtocol: OBAIReadResourceDataProtocol {
    var scheduledPayment: [OBAIResourceType]? { get }
}
extension OBAIReadScheduledPaymentDataProtocol {
    var resource: [OBAIResourceType]? { return scheduledPayment }
}

protocol OBAIScheduledPaymentProtocol: OBAIResourceProtocol {
    // TODO: remove version from...
    associatedtype OBExternalScheduleType1CodeType: RawRepresentableWithStringRawValue
    associatedtype OBActiveOrHistoricCurrencyAndAmountType: OBActiveOrHistoricCurrencyAndAmountProtocol
    var accountId: String { get }
    var scheduledPaymentId: String? { get }
    var scheduledType: OBExternalScheduleType1CodeType { get }
    var scheduledPaymentDateTime: Date { get }
    var instructedAmount: OBActiveOrHistoricCurrencyAndAmountType { get }
    var reference: String? { get }
}


// MARK:- Product type protocols

protocol OBAIReadProductDataProtocol: OBAIReadResourceDataProtocol {
    var product: [OBAIResourceType]? { get }
}
extension OBAIReadProductDataProtocol {
    var resource: [OBAIResourceType]? { return product }
}

protocol OBAIProductProtocol: OBAIResourceProtocol {
    // TODO: remove version from...
    associatedtype OBExternalProductType1CodeType: RawRepresentableWithStringRawValue
    var accountId: String { get }
    var productId: String? { get }
    var secondaryProductId: String? { get }
    var marketingStateId: String? { get }
    var productName: String? { get }
    var productTypeOptional: OBExternalProductType1CodeType? { get }
}

// MARK:- Offer protocols

protocol OBAIReadOfferDataProtocol: OBAIReadResourceDataProtocol {
    var offer: [OBAIResourceType]? { get }
}
extension OBAIReadOfferDataProtocol {
    var resource: [OBAIResourceType]? { return offer }
}

protocol OBAIOfferProtocol: OBAIResourceProtocol {
    associatedtype OBOfferAmountType: OBActiveOrHistoricCurrencyAndAmountProtocol
    associatedtype OBOfferFeeType: OBActiveOrHistoricCurrencyAndAmountProtocol
    associatedtype OBOfferType: RawRepresentableWithStringRawValue
    var accountId: String { get }
    var offerId: String? { get }
    var offerType: OBOfferType? { get }
    var _description: String? { get }
    var startDateTime: Date? { get }
    var endDateTime: Date? { get }

    var rate: String? { get }
    var value: Int? { get }
    var term: String? { get }
    var URL: String? { get }
    
    var amount: OBOfferAmountType? {get}
    var fee: OBOfferFeeType? {get}
}

// MARK:- Beneficiary protocols

protocol OBAIReadBeneficiaryDataProtocol: OBAIReadResourceDataProtocol {
    var beneficiary: [OBAIResourceType]? { get }
}
extension OBAIReadBeneficiaryDataProtocol {
    var resource: [OBAIResourceType]? { return beneficiary }
}

protocol OBAIBeneficiaryProtocol: OBAIResourceProtocol {
    var accountId: String? { get }
    var beneficiaryId: String? { get }
    var reference: String? { get }
}

// MARK:- Party protocols

protocol OBAIReadPartyDataProtocol: OBAIReadResourceDataProtocol {
    var party: OBAIResourceType? { get }
}
extension OBAIReadPartyDataProtocol {
    var resource: [OBAIResourceType]? {
        return party == nil ? [] : [party!]
    }
}

protocol OBAIPartyProtocol: OBAIResourceProtocol {
    // TODO: remove version from...
    associatedtype OBExternalPartyType1CodeType: RawRepresentableWithStringRawValue
    var partyId: String { get }
    var partyNumber: String? { get }
    var partyType: OBExternalPartyType1CodeType? { get }
    var name: String? { get }
    var fullLegalName: String? { get }
    var beneficialOwnership: Bool? { get }
    var emailAddress: String? { get }
    var phone: String? { get }
    var mobile: String? { get }
}

// MARK:- Account access protocols


// MARK:- OBReadWrite Type Names and Protocol

func obATReadConsentType(apiVersion: AccountTransactionApiVersion) -> OBATReadConsentProtocolExposedMethods.Type {
    switch apiVersion {
    case .V3p0p0:
        return OBATV3p0p0Types.obATReadConsentType()
    case .V3p1p1:
        return OBATV3p1p1Types.obATReadConsentType()
    case .V3p1p2:
        return OBATV3p1p2Types.obATReadConsentType()
    }
}

public enum OBAIReadResourceTypeName: String {
    //case OBAIReadAccount
    //case OBAIReadTransaction
    case OBAIReadDirectDebit
    case OBAIReadBalance
    case OBAIReadStandingOrder
    case OBAIReadStatement
    case OBAIReadScheduledPayment
    case OBAIReadProduct
    case OBAIReadOffer
    case OBAIReadBeneficiary
    case OBAIReadParty
    case OBAIReadConsent
    case OBAIReadConsentResponse
}

extension AccountTransactionApiVersion {
    func returnOBAIReadResourceType(typeName: OBAIReadResourceTypeName) -> OBItem.Type {
        switch self {
        case .V3p0p0:
            return returnOBAIV3p0p0ReadResourceType(typeName: typeName)
        case .V3p1p1:
            return returnOBAIV3p1p1ReadResourceType(typeName: typeName)
        case .V3p1p2:
            return returnOBAIV3p1p2ReadResourceType(typeName: typeName)
            
        }
    }
    
    func returnOBAIResourceType(typeName: OBAIReadResourceTypeName) -> OBAIResourceProtocol0.Type {
        switch self {
        case .V3p0p0:
            return returnOBAIV3p0p0ResourceType(typeName: typeName)
        case .V3p1p1:
            return returnOBAIV3p1p1ResourceType(typeName: typeName)
        case .V3p1p2:
            return returnOBAIV3p1p2ResourceType(typeName: typeName)
            
        }
    }

}
