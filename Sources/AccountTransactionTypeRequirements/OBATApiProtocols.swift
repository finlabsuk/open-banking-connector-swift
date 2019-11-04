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

// MARK:- Supporting protocols

public protocol RawRepresentableWithStringRawValue: RawRepresentable where RawValue == String { }

public protocol OBActiveOrHistoricCurrencyAndAmountProtocol {
    var amount: String {get}
    var currency: String {get}
}

public protocol OBTransactionCashBalanceProtocol {
    associatedtype CreditDebitIndicatorType: RawRepresentableWithStringRawValue
    var nestedAmount: String {get}
    var creditDebitIndicator: CreditDebitIndicatorType {get}
}

public protocol OBStatementDateTimeProtocol {
    var dateTime: Date {get}
}

public protocol OBStatementAmountProtocol {
    associatedtype CreditDebitIndicatorType: RawRepresentableWithStringRawValue
    associatedtype OBActiveOrHistoricCurrencyAndAmountType: OBActiveOrHistoricCurrencyAndAmountProtocol
    var amount: OBActiveOrHistoricCurrencyAndAmountType {get}
    var creditDebitIndicator: CreditDebitIndicatorType {get}
}

// MARK:- General protocols for all OB Account Information resources (including Read, ReadData, and Base levels)

// NEW: Top-level protocols with more flexibility
public protocol OBATApiReadResourceProtocol: Codable {
    associatedtype OBATApiReadResourceDataType: OBATApiReadResourceDataProtocol
    var data: OBATApiReadResourceDataType { get set }
}

//extension NewOBAIReadResourceProtocol {
//
//    public func validateDecoding() throws {
//        if data.resource == nil {
//            throw "ERROR: Could not decode \(Self.typeName). Check input JSON for consistency."
//        }
//    }
//
//}


public protocol OBATApiReadResourceDataProtocol {
    associatedtype OBATApiResourceType: OBATApiResourceProtocol
    var resource: [OBATApiResourceType]? { get }
}

// Protocol below for spec-version independent OB resource (e.g OBAccount3, OBTransaction5, etc) description.
public protocol OBATApiResourceProtocol: Codable { }

public protocol OBATApiReadResourceTypesProtocol {
    associatedtype OBATApiReadTransactionType: OBATApiReadTransactionProtocol
    associatedtype OBATApiReadAccountType: OBATApiReadAccountProtocol
}

public protocol AccountTransactionRequestObjectApiTypesProtocol {
    associatedtype OBReadConsentApiType: OBReadConsentApiProtocol
}

// MARK:- Direct debit type protocols

public protocol OBATApiReadDirectDebitDataProtocol: OBATApiReadResourceDataProtocol {
    var directDebit: [OBATApiResourceType]? { get }
}
extension OBATApiReadDirectDebitDataProtocol {
    public var resource: [OBATApiResourceType]? { return directDebit }
}

public protocol OBATApiDirectDebitProtocol: OBATApiResourceProtocol {
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

public protocol OBATApiReadBalanceDataProtocol: OBATApiReadResourceDataProtocol {
    var balance: [OBATApiResourceType] { get }
}
extension OBATApiReadBalanceDataProtocol {
    public var resource: [OBATApiResourceType]? { return balance }
}

public protocol OBATApiBalanceProtocol: OBATApiResourceProtocol {
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

public protocol OBATApiReadStandingOrderDataProtocol: OBATApiReadResourceDataProtocol {
    var standingOrder: [OBATApiResourceType]? { get }
}
extension OBATApiReadStandingOrderDataProtocol {
    public var resource: [OBATApiResourceType]? { return standingOrder }
}

public protocol OBATApiStandingOrderProtocol: OBATApiResourceProtocol {
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

public protocol OBCashAccountProtocol {
    var schemeName: String {get}
    var identification: String {get}
}

// MARK:- Statement type protocols

public protocol OBATApiReadStatementDataProtocol: OBATApiReadResourceDataProtocol {
    var statement: [OBATApiResourceType]? { get }
}
extension OBATApiReadStatementDataProtocol {
    public var resource: [OBATApiResourceType]? { return statement }
}

public protocol OBATApiStatementProtocol: OBATApiResourceProtocol {
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

public protocol OBATApiReadScheduledPaymentDataProtocol: OBATApiReadResourceDataProtocol {
    var scheduledPayment: [OBATApiResourceType]? { get }
}
extension OBATApiReadScheduledPaymentDataProtocol {
    public var resource: [OBATApiResourceType]? { return scheduledPayment }
}

public protocol OBATApiScheduledPaymentProtocol: OBATApiResourceProtocol {
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

public protocol OBATApiReadProductDataProtocol: OBATApiReadResourceDataProtocol {
    var product: [OBATApiResourceType]? { get }
}
extension OBATApiReadProductDataProtocol {
    public var resource: [OBATApiResourceType]? { return product }
}

public protocol OBATApiProductProtocol: OBATApiResourceProtocol {
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

public protocol OBATApiReadOfferDataProtocol: OBATApiReadResourceDataProtocol {
    var offer: [OBATApiResourceType]? { get }
}
extension OBATApiReadOfferDataProtocol {
    public var resource: [OBATApiResourceType]? { return offer }
}

public protocol OBATApiOfferProtocol: OBATApiResourceProtocol {
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

public protocol OBATApiReadBeneficiaryDataProtocol: OBATApiReadResourceDataProtocol {
    var beneficiary: [OBATApiResourceType]? { get }
}
extension OBATApiReadBeneficiaryDataProtocol {
    public var resource: [OBATApiResourceType]? { return beneficiary }
}

public protocol OBATApiBeneficiaryProtocol: OBATApiResourceProtocol {
    var accountId: String? { get }
    var beneficiaryId: String? { get }
    var reference: String? { get }
}

// MARK:- Party protocols

public protocol OBATApiReadPartyDataProtocol: OBATApiReadResourceDataProtocol {
    var party: OBATApiResourceType? { get }
}
extension OBATApiReadPartyDataProtocol {
    public var resource: [OBATApiResourceType]? {
        return party == nil ? [] : [party!]
    }
}

public protocol OBATApiPartyProtocol: OBATApiResourceProtocol {
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
