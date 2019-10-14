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

import AccountTransactionApiV3p1p2Types

typealias OBReadAccountV3p1p2Alias = OBReadAccount4
typealias OBReadAccountDataV3p1p2Alias = OBReadAccount4Data
typealias OBAccountV3p1p2Alias = OBAccount4

typealias OBReadDirectDebitV3p1p2Alias = OBReadDirectDebit1
typealias OBReadDirectDebitDataV3p1p2Alias = OBReadDirectDebit1Data
typealias OBDirectDebitV3p1p2Alias = OBReadDirectDebit1DataDirectDebit
typealias OBExternalDirectDebitStatusCodeV3p1p2Alias = OBReadDirectDebit1DataDirectDebit.DirectDebitStatusCode
typealias OBDirectDebitPreviousPaymentAmountV3p1p2Alias = OBReadDirectDebit1DataPreviousPaymentAmount

typealias OBReadBalanceV3p1p2Alias = OBReadBalance1
typealias OBReadBalanceDataV3p1p2Alias = OBReadBalance1Data
typealias OBBalanceV3p1p2Alias = OBReadBalance1DataBalance
typealias OBBalanceAmountV3p1p2Alias = OBReadBalance1DataAmount
typealias OBBalanceTypeCodeV3p1p2Alias = OBBalanceType1Code

typealias OBReadStandingOrderV3p1p2Alias = OBReadStandingOrder5
typealias OBReadStandingOrderDataV3p1p2Alias = OBReadStandingOrder5Data
typealias OBStandingOrderV3p1p2Alias = OBStandingOrder5
typealias OBCashAccountV3p1p2Alias = OBCashAccount50
typealias OBAOHCurrencyAndAmount0V3p1p2Alias = OBActiveOrHistoricCurrencyAndAmount0
typealias OBAOHCurrencyAndAmount1V3p1p2Alias = OBActiveOrHistoricCurrencyAndAmount1
typealias OBAOHCurrencyAndAmount2V3p1p2Alias = OBActiveOrHistoricCurrencyAndAmount2

typealias OBReadStatementV3p1p2Alias = OBReadStatement2
typealias OBReadStatementDataV3p1p2Alias = OBReadDataStatement2
typealias OBStatementV3p1p2Alias = OBStatement2
typealias OBExternalStatementTypeCodeV3p1p2Alias = OBExternalStatementType1Code
typealias OBStatementDateTimeV3p1p2Alias = OBStatement2StatementDateTime
typealias OBStatementAmountV3p1p2Alias = OBStatement2StatementAmount
typealias OBCreditDebitCode0V3p1p2Alias = OBCreditDebitCode0
typealias OBAOHCurrencyAndAmount6V3p1p2Alias = OBActiveOrHistoricCurrencyAndAmount6

typealias OBReadScheduledPaymentV3p1p2Alias = OBReadScheduledPayment2
typealias OBReadScheduledPaymentDataV3p1p2Alias = OBReadScheduledPayment2Data
typealias OBScheduledPaymentV3p1p2Alias = OBScheduledPayment2
typealias OBExternalScheduleTypeCodeV3p1p2Alias = OBExternalScheduleType1Code
typealias OBAOHCurrencyAndAmount9V3p1p2Alias = OBActiveOrHistoricCurrencyAndAmount9

typealias OBReadProductV3p1p2Alias = OBReadProduct2
typealias OBReadProductDataV3p1p2Alias = OBReadProduct2Data
typealias OBProductV3p1p2Alias = OBReadProduct2DataProduct
typealias OBExternalProductTypeCodeV3p1p2Alias = OBReadProduct2DataProduct.ProductType

typealias OBReadOfferV3p1p2Alias = OBReadOffer1
typealias OBReadOfferDataV3p1p2Alias = OBReadOffer1Data
typealias OBOfferV3p1p2Alias = OBReadOffer1DataOffer
typealias OBExternalOfferTypeCodeV3p1p2Alias = OBReadOffer1DataOffer.OfferType
typealias OBOfferAmountV3p1p2Alias = OBReadOffer1DataAmount
typealias OBOfferFeeV3p1p2Alias = OBReadOffer1DataFee

typealias OBReadBeneficiaryV3p1p2Alias = OBReadBeneficiary3
typealias OBReadBeneficiaryDataV3p1p2Alias = OBReadBeneficiary3Data
typealias OBBeneficiaryV3p1p2Alias = OBBeneficiary3

typealias OBReadPartyV3p1p2Alias = OBReadParty2
typealias OBReadPartyDataV3p1p2Alias = OBReadParty2Data
typealias OBPartyV3p1p2Alias = OBParty2
typealias OBExternalPartyTypeCodeV3p1p2Alias = OBExternalPartyType1Code

// Account conformances

//extension OBReadAccountV3p1p2Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadAccountDataV3p1p2Alias }
//extension OBReadAccountDataV3p1p2Alias: OBAIReadAccountDataProtocol { typealias OBAIResourceType = OBAccountV3p1p2Alias }
//
//extension OBAccountV3p1p2Alias: OBAIAccountProtocol {  }

// Transaction conformances

fileprivate typealias OBReadTransactionAlias = OBReadTransaction5
fileprivate typealias OBReadTransactionDataAlias = OBReadDataTransaction5
fileprivate typealias OBTransactionAlias = OBTransaction5
fileprivate typealias OBTransactionBalanceAlias = OBTransactionCashBalance
fileprivate typealias OBCreditDebitCode1Alias = OBCreditDebitCode1
fileprivate typealias OBCreditDebitCode2Alias = OBCreditDebitCode2

//extension OBReadTransactionAlias: OBATReadTransactionProtocol {
//    typealias OBAIReadResourceDataType = OBReadDataTransaction5 }
//extension OBReadTransactionDataAlias: OBAIReadTransactionDataProtocol { typealias OBAIResourceType = OBTransaction5 }
extension OBCreditDebitCode1Alias: RawRepresentableWithStringRawValue {}
extension OBCreditDebitCode2Alias: RawRepresentableWithStringRawValue {}
//extension OBTransactionBalanceAlias: OBTransactionCashBalanceProtocol {
//    var nestedAmount: String { return amount.amount }
//}
//extension OBTransactionAlias: OBAITransactionProtocol {
//    var nestedAmount: String { return amount.amount }
//}

// Direct debit conformances

extension OBReadDirectDebitV3p1p2Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadDirectDebitDataV3p1p2Alias }
extension OBReadDirectDebitDataV3p1p2Alias: OBAIReadDirectDebitDataProtocol { typealias OBAIResourceType = OBDirectDebitV3p1p2Alias }

extension OBExternalDirectDebitStatusCodeV3p1p2Alias: RawRepresentableWithStringRawValue { }
extension OBDirectDebitPreviousPaymentAmountV3p1p2Alias: OBActiveOrHistoricCurrencyAndAmountProtocol { }

extension OBDirectDebitV3p1p2Alias: OBAIDirectDebitProtocol {
}

// Balance conformances

extension OBReadBalanceV3p1p2Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadBalanceDataV3p1p2Alias }
extension OBReadBalanceDataV3p1p2Alias: OBAIReadBalanceDataProtocol {
    typealias OBAIResourceType = OBBalanceV3p1p2Alias }

extension OBBalanceTypeCodeV3p1p2Alias: RawRepresentableWithStringRawValue { }
extension OBBalanceAmountV3p1p2Alias: OBActiveOrHistoricCurrencyAndAmountProtocol {}

extension OBBalanceV3p1p2Alias: OBAIBalanceProtocol {
}

// Standing order conformances

extension OBReadStandingOrderV3p1p2Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadStandingOrderDataV3p1p2Alias }
extension OBReadStandingOrderDataV3p1p2Alias: OBAIReadStandingOrderDataProtocol {
    typealias OBAIResourceType = OBStandingOrderV3p1p2Alias }

extension OBCashAccountV3p1p2Alias: OBCashAccountProtocol { }
extension OBActiveOrHistoricCurrencyAndAmount0: OBActiveOrHistoricCurrencyAndAmountProtocol {}
extension OBActiveOrHistoricCurrencyAndAmount1: OBActiveOrHistoricCurrencyAndAmountProtocol {}
extension OBActiveOrHistoricCurrencyAndAmount2: OBActiveOrHistoricCurrencyAndAmountProtocol {}

extension OBStandingOrderV3p1p2Alias: OBAIStandingOrderProtocol {  }

// Statement conformances

extension OBReadStatementV3p1p2Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadStatementDataV3p1p2Alias }
extension OBReadStatementDataV3p1p2Alias: OBAIReadStatementDataProtocol { typealias OBAIResourceType = OBStatementV3p1p2Alias }

extension OBExternalStatementTypeCodeV3p1p2Alias: RawRepresentableWithStringRawValue { }
extension OBStatementDateTimeV3p1p2Alias: OBStatementDateTimeProtocol {}
extension OBStatementAmountV3p1p2Alias: OBStatementAmountProtocol {}
extension OBCreditDebitCode0V3p1p2Alias: RawRepresentableWithStringRawValue { }
extension OBAOHCurrencyAndAmount6V3p1p2Alias: OBActiveOrHistoricCurrencyAndAmountProtocol {}

extension OBStatementV3p1p2Alias: OBAIStatementProtocol { }

// Scheduled payment conformances

extension OBReadScheduledPaymentV3p1p2Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadScheduledPaymentDataV3p1p2Alias }
extension OBReadScheduledPaymentDataV3p1p2Alias: OBAIReadScheduledPaymentDataProtocol { typealias OBAIResourceType = OBScheduledPaymentV3p1p2Alias }

extension OBExternalScheduleTypeCodeV3p1p2Alias: RawRepresentableWithStringRawValue { }
extension OBAOHCurrencyAndAmount9V3p1p2Alias: OBActiveOrHistoricCurrencyAndAmountProtocol {}

extension OBScheduledPaymentV3p1p2Alias: OBAIScheduledPaymentProtocol {  }

// Product conformances

extension OBReadProductV3p1p2Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType =  OBReadProductDataV3p1p2Alias }
extension OBReadProductDataV3p1p2Alias: OBAIReadProductDataProtocol { typealias OBAIResourceType = OBProductV3p1p2Alias }

extension OBExternalProductTypeCodeV3p1p2Alias: RawRepresentableWithStringRawValue { }
extension OBProductV3p1p2Alias: OBAIProductProtocol {
    var productTypeOptional: OBExternalProductTypeCodeV3p1p2Alias? { return self.productType }
}

// Offer conformances

extension OBReadOfferV3p1p2Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadOfferDataV3p1p2Alias }
extension OBReadOfferDataV3p1p2Alias: OBAIReadOfferDataProtocol { typealias OBAIResourceType = OBOfferV3p1p2Alias }

extension OBExternalOfferTypeCodeV3p1p2Alias: RawRepresentableWithStringRawValue { }
extension OBOfferAmountV3p1p2Alias: OBActiveOrHistoricCurrencyAndAmountProtocol {}
extension OBOfferFeeV3p1p2Alias: OBActiveOrHistoricCurrencyAndAmountProtocol {}

extension OBOfferV3p1p2Alias: OBAIOfferProtocol {
}

// Beneficiary conformances

extension OBReadBeneficiaryV3p1p2Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadBeneficiaryDataV3p1p2Alias }
extension OBReadBeneficiaryDataV3p1p2Alias: OBAIReadBeneficiaryDataProtocol { typealias OBAIResourceType = OBBeneficiaryV3p1p2Alias }

extension OBBeneficiaryV3p1p2Alias: OBAIBeneficiaryProtocol {  }

// Party conformances

extension OBReadPartyV3p1p2Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadPartyDataV3p1p2Alias }
extension OBReadPartyDataV3p1p2Alias: OBAIReadPartyDataProtocol { typealias OBAIResourceType = OBPartyV3p1p2Alias }

extension OBExternalPartyTypeCodeV3p1p2Alias: RawRepresentableWithStringRawValue { }
extension OBPartyV3p1p2Alias: OBAIPartyProtocol { }

// Read consent conformances

fileprivate typealias OBReadConsentAlias = OBReadConsent1
fileprivate typealias OBReadConsentDataAlias = OBReadConsent1Data

extension OBRisk2: InitProtocol2 { }
extension OBReadConsentAlias: OBATReadConsentProtocol {
    typealias OBAIReadResourceType = OBReadConsentResponse1
}
extension OBReadConsentDataAlias.Permissions: RawRepresentableWithStringRawValue { }
extension OBReadConsentDataAlias: OBAIReadConsentDataProtocol { }

fileprivate typealias OBReadConsentResponseAlias = OBReadConsentResponse1
fileprivate typealias OBReadConsentResponseDataAlias = OBReadConsentResponse1Data

extension OBReadConsentResponseAlias: OBATReadConsentResponseProtocol { }
extension OBReadConsentResponseDataAlias.Status: RawRepresentableWithStringRawValue { }
extension OBReadConsentResponseDataAlias.Permissions: RawRepresentableWithStringRawValue { }
extension OBReadConsentResponseDataAlias: OBAIReadConsentResponseDataProtocol { }


func returnOBAIV3p1p2ReadResourceType(typeName: OBAIReadResourceTypeName) -> OBItem.Type {
    switch typeName {
    //case .OBAIReadAccount: return OBReadAccountV3p1p2Alias.self
    //case .OBAIReadTransaction: return OBReadTransactionAlias.self
    case .OBAIReadDirectDebit: return OBReadDirectDebitV3p1p2Alias.self
    case .OBAIReadBalance: return OBReadBalanceV3p1p2Alias.self
    case .OBAIReadStandingOrder: return OBReadStandingOrderV3p1p2Alias.self
    case .OBAIReadStatement: return OBReadStatementV3p1p2Alias.self
    case .OBAIReadScheduledPayment: return OBReadScheduledPaymentV3p1p2Alias.self
    case .OBAIReadProduct: return OBReadProductV3p1p2Alias.self
    case .OBAIReadOffer: return OBReadOfferV3p1p2Alias.self
    case .OBAIReadBeneficiary: return OBReadBeneficiaryV3p1p2Alias.self
    case .OBAIReadParty: return OBReadPartyV3p1p2Alias.self
    case .OBAIReadConsent: return OBReadConsentAlias.self
    case .OBAIReadConsentResponse: return OBReadConsentResponseAlias.self
    }
}

func returnOBAIV3p1p2ResourceType(typeName: OBAIReadResourceTypeName) -> OBAIResourceProtocol0.Type {
    switch typeName {
    //case .OBAIReadAccount: return OBAccountV3p1p2Alias.self
    //case .OBAIReadTransaction: return OBTransactionAlias.self
    case .OBAIReadDirectDebit: return OBDirectDebitV3p1p2Alias.self
    case .OBAIReadBalance: return OBBalanceV3p1p2Alias.self
    case .OBAIReadStandingOrder: return OBStandingOrderV3p1p2Alias.self
    case .OBAIReadStatement: return OBStatement2.self
    case .OBAIReadScheduledPayment: return OBScheduledPaymentV3p1p2Alias.self
    case .OBAIReadProduct: return OBProductV3p1p2Alias.self
    case .OBAIReadOffer: return OBOfferV3p1p2Alias.self
    case .OBAIReadBeneficiary: return OBBeneficiaryV3p1p2Alias.self
    case .OBAIReadParty: return OBPartyV3p1p2Alias.self
    case .OBAIReadConsent: return OBReadConsentDataAlias.self
    case .OBAIReadConsentResponse: return OBReadConsentResponseDataAlias.self
    }
}

class OBATV3p1p2Types {
    
    static func obATReadConsentType() -> OBATReadConsentProtocolExposedMethods.Type {
        return OBReadConsentAlias.self
    }
    
//    static func obATReadTransactionType() -> OBATReadTransactionProtocolExposedMethods.Type {
//        return OBReadTransactionAlias.self
//    }
    
}
