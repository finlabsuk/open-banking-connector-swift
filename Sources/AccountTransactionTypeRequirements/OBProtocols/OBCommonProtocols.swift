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

/** Indicates whether the transaction is a credit or a debit entry. */
public enum OBCreditDebitCodeEnum: String, Codable {
    case credit = "Credit"
    case debit = "Debit"
}

public protocol OBActiveOrHistoricCurrencyAndAmountProtocol {
    var amount: String {get}
    var currency: String {get}
}

public protocol OBTransactionCashBalanceProtocol {
    associatedtype OBCreditDebitCode: RawRepresentable, Codable where OBCreditDebitCode.RawValue == String
    var nestedAmount: String {get}
    var creditDebitIndicator: OBCreditDebitCode {get}
    var creditDebitIndicatorEnum: OBCreditDebitCodeEnum? {get}
}

public protocol OBStatementDateTimeProtocol {
    var dateTime: Date {get}
}

public protocol OBStatementAmountProtocol {
    associatedtype CreditDebitIndicator: RawRepresentable, Codable where CreditDebitIndicator.RawValue == String
    associatedtype OBActiveOrHistoricCurrencyAndAmountType: OBActiveOrHistoricCurrencyAndAmountProtocol
    var amount: OBActiveOrHistoricCurrencyAndAmountType {get}
    var creditDebitIndicator: CreditDebitIndicator {get}
}

// MARK:- General protocols for all OB Account Information resources (including Read, ReadData, and Base levels)

// NEW: Top-level protocols with more flexibility
public protocol OBReadResourceProtocol: Codable {
    associatedtype OBReadResourceData: OBReadResourceDataProtocol
    var data: OBReadResourceData { get set }
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


public protocol OBReadResourceDataProtocol {
    associatedtype OBResource: OBResourceProtocol
    var resource: [OBResource]? { get }
}

// Protocol below for spec-version independent OB resource (e.g OBAccount3, OBTransaction5, etc) description.
public protocol OBResourceProtocol: Codable { }

public protocol OBReadResourceTypesProtocol {
    associatedtype OBReadTransactionType: OBReadTransactionProtocol
    associatedtype OBReadAccountType: OBReadAccountProtocol
}

public protocol AccountTransactionRequestObjectApiTypesProtocol {
    associatedtype OBReadConsentType: OBReadConsentProtocol
}

// MARK:- Direct debit type protocols

public protocol OBATApiReadDirectDebitDataProtocol: OBReadResourceDataProtocol {
    var directDebit: [OBResource]? { get }
}
extension OBATApiReadDirectDebitDataProtocol {
    public var resource: [OBResource]? { return directDebit }
}

public protocol OBATApiDirectDebitProtocol: OBResourceProtocol {
    // TODO: remove version from OBExternalDirectDebitStatus1CodeType
    associatedtype OBExternalDirectDebitStatus1CodeType: RawRepresentable, Codable where OBExternalDirectDebitStatus1CodeType.RawValue == String
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

public protocol OBATApiReadBalanceDataProtocol: OBReadResourceDataProtocol {
    var balance: [OBResource] { get }
}
extension OBATApiReadBalanceDataProtocol {
    public var resource: [OBResource]? { return balance }
}

public protocol OBATApiBalanceProtocol: OBResourceProtocol {
    associatedtype CreditDebitIndicatorType: RawRepresentable, Codable where CreditDebitIndicatorType.RawValue == String
    // TODO: remove version from...
    associatedtype OBBalanceType1CodeType: RawRepresentable, Codable where OBBalanceType1CodeType.RawValue == String
    associatedtype OBActiveOrHistoricCurrencyAndAmountType: OBActiveOrHistoricCurrencyAndAmountProtocol
    var accountId: String {get}
    var creditDebitIndicator: CreditDebitIndicatorType {get}
    var type: OBBalanceType1CodeType {get}
    var amount: OBActiveOrHistoricCurrencyAndAmountType {get}
    var dateTime: Date {get}
}


// MARK:- Standing order type protocols

public protocol OBATApiReadStandingOrderDataProtocol: OBReadResourceDataProtocol {
    var standingOrder: [OBResource]? { get }
}
extension OBATApiReadStandingOrderDataProtocol {
    public var resource: [OBResource]? { return standingOrder }
}

public protocol OBATApiStandingOrderProtocol: OBResourceProtocol {
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

public protocol OBATApiReadStatementDataProtocol: OBReadResourceDataProtocol {
    var statement: [OBResource]? { get }
}
extension OBATApiReadStatementDataProtocol {
    public var resource: [OBResource]? { return statement }
}

public protocol OBATApiStatementProtocol: OBResourceProtocol {
    // TODO: remove version from...
    associatedtype OBExternalStatementType1CodeType: RawRepresentable, Codable where OBExternalStatementType1CodeType.RawValue == String
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

public protocol OBATApiReadScheduledPaymentDataProtocol: OBReadResourceDataProtocol {
    var scheduledPayment: [OBResource]? { get }
}
extension OBATApiReadScheduledPaymentDataProtocol {
    public var resource: [OBResource]? { return scheduledPayment }
}

public protocol OBATApiScheduledPaymentProtocol: OBResourceProtocol {
    // TODO: remove version from...
    associatedtype OBExternalScheduleType1CodeType: RawRepresentable, Codable where OBExternalScheduleType1CodeType.RawValue == String
    associatedtype OBActiveOrHistoricCurrencyAndAmountType: OBActiveOrHistoricCurrencyAndAmountProtocol
    var accountId: String { get }
    var scheduledPaymentId: String? { get }
    var scheduledType: OBExternalScheduleType1CodeType { get }
    var scheduledPaymentDateTime: Date { get }
    var instructedAmount: OBActiveOrHistoricCurrencyAndAmountType { get }
    var reference: String? { get }
}


// MARK:- Product type protocols

public protocol OBATApiReadProductDataProtocol: OBReadResourceDataProtocol {
    var product: [OBResource]? { get }
}
extension OBATApiReadProductDataProtocol {
    public var resource: [OBResource]? { return product }
}

public protocol OBATApiProductProtocol: OBResourceProtocol {
    // TODO: remove version from...
    associatedtype OBExternalProductType1CodeType: RawRepresentable, Codable where OBExternalProductType1CodeType.RawValue == String
    var accountId: String { get }
    var productId: String? { get }
    var secondaryProductId: String? { get }
    var marketingStateId: String? { get }
    var productName: String? { get }
    var productTypeOptional: OBExternalProductType1CodeType? { get }
}

// MARK:- Offer protocols

public protocol OBATApiReadOfferDataProtocol: OBReadResourceDataProtocol {
    var offer: [OBResource]? { get }
}
extension OBATApiReadOfferDataProtocol {
    public var resource: [OBResource]? { return offer }
}

public protocol OBATApiOfferProtocol: OBResourceProtocol {
    associatedtype OBOfferAmountType: OBActiveOrHistoricCurrencyAndAmountProtocol
    associatedtype OBOfferFeeType: OBActiveOrHistoricCurrencyAndAmountProtocol
    associatedtype OBOfferType: RawRepresentable, Codable where OBOfferType.RawValue == String
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

public protocol OBATApiReadBeneficiaryDataProtocol: OBReadResourceDataProtocol {
    var beneficiary: [OBResource]? { get }
}
extension OBATApiReadBeneficiaryDataProtocol {
    public var resource: [OBResource]? { return beneficiary }
}

public protocol OBATApiBeneficiaryProtocol: OBResourceProtocol {
    var accountId: String? { get }
    var beneficiaryId: String? { get }
    var reference: String? { get }
}

// MARK:- Party protocols

public protocol OBATApiReadPartyDataProtocol: OBReadResourceDataProtocol {
    var party: OBResource? { get }
}
extension OBATApiReadPartyDataProtocol {
    public var resource: [OBResource]? {
        return party == nil ? [] : [party!]
    }
}

public protocol OBATApiPartyProtocol: OBResourceProtocol {
    // TODO: remove version from...
    associatedtype OBExternalPartyType1CodeType: RawRepresentable, Codable where OBExternalPartyType1CodeType.RawValue == String
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
