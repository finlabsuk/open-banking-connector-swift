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

import AccountTransactionApiV3p1p1Types

typealias OBReadAccountV3p1p1Alias = OBReadAccount3
typealias OBReadAccountDataV3p1p1Alias = OBReadAccount3Data
typealias OBAccountV3p1p1Alias = OBAccount3

typealias OBReadDirectDebitV3p1p1Alias = OBReadDirectDebit1
typealias OBReadDirectDebitDataV3p1p1Alias = OBReadDirectDebit1Data
typealias OBDirectDebitV3p1p1Alias = OBDirectDebit1
typealias OBExternalDirectDebitStatusCodeV3p1p1Alias = OBExternalDirectDebitStatus1Code
typealias OBActiveOrHistoricCurrencyAndAmountV3p1p1Alias = OBActiveOrHistoricCurrencyAndAmount

typealias OBReadBalanceV3p1p1Alias = OBReadBalance1
typealias OBReadBalanceDataV3p1p1Alias = OBReadBalance1Data
typealias OBBalanceV3p1p1Alias = OBCashBalance1
typealias OBBalanceCDIndicatorV3p1p1Alias = OBCashBalance1.CreditDebitIndicator
typealias OBBalanceTypeCodeV3p1p1Alias = OBBalanceType1Code

typealias OBReadStandingOrderV3p1p1Alias = OBReadStandingOrder5
typealias OBReadStandingOrderDataV3p1p1Alias = OBReadStandingOrder5Data
typealias OBStandingOrderV3p1p1Alias = OBStandingOrder5
typealias OBCashAccountV3p1p1Alias = OBCashAccount5

typealias OBReadStatementV3p1p1Alias = OBReadStatement2
typealias OBReadStatementDataV3p1p1Alias = OBReadStatement2Data
typealias OBStatementV3p1p1Alias = OBStatement2
typealias OBExternalStatementTypeCodeV3p1p1Alias = OBExternalStatementType1Code
typealias OBStatementDateTimeV3p1p1Alias = OBStatementDateTime1
typealias OBStatementAmountV3p1p1Alias = OBStatementAmount1
typealias OBStatementAmountCDIndicatorV3p1p1Alias = OBStatementAmount1.CreditDebitIndicator

typealias OBReadScheduledPaymentV3p1p1Alias = OBReadScheduledPayment2
typealias OBReadScheduledPaymentDataV3p1p1Alias = OBReadScheduledPayment2Data
typealias OBScheduledPaymentV3p1p1Alias = OBScheduledPayment2
typealias OBExternalScheduleTypeCodeV3p1p1Alias = OBExternalScheduleType1Code

typealias OBReadProductV3p1p1Alias = OBReadProduct2
typealias OBReadProductDataV3p1p1Alias = OBReadDataProduct1
typealias OBProductV3p1p1Alias = OBProduct1
typealias OBExternalProductTypeCodeV3p1p1Alias = OBExternalProductType1Code

typealias OBReadOfferV3p1p1Alias = OBReadOffer1
typealias OBReadOfferDataV3p1p1Alias = OBReadOffer1Data
typealias OBOfferV3p1p1Alias = OBOffer1
typealias OBExternalOfferTypeCodeV3p1p1Alias = OBExternalOfferType1Code

typealias OBReadBeneficiaryV3p1p1Alias = OBReadBeneficiary3
typealias OBReadBeneficiaryDataV3p1p1Alias = OBReadBeneficiary3Data
typealias OBBeneficiaryV3p1p1Alias = OBBeneficiary3

typealias OBReadPartyV3p1p1Alias = OBReadParty2
typealias OBReadPartyDataV3p1p1Alias = OBReadParty2Data
typealias OBPartyV3p1p1Alias = OBParty2
typealias OBExternalPartyTypeCodeV3p1p1Alias = OBExternalPartyType1Code

// Account conformances

//extension OBReadAccountV3p1p1Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadAccountDataV3p1p1Alias }
//extension OBReadAccountDataV3p1p1Alias: OBAIReadAccountDataProtocol { typealias OBAIResourceType = OBAccountV3p1p1Alias }
//
//extension OBAccountV3p1p1Alias: OBAIAccountProtocol { }

// Transaction conformances

fileprivate typealias OBReadTransactionAlias = OBReadTransaction5
fileprivate typealias OBReadTransactionDataAlias = OBReadTransaction5Data
fileprivate typealias OBTransactionAlias = OBTransaction5
fileprivate typealias OBTransactionCDIndicatorAlias = OBTransaction5.CreditDebitIndicator
fileprivate typealias OBTransactionBalanceAlias = OBTransactionCashBalance
fileprivate typealias OBTransactionBalanceCDIndicatorAlias = OBTransactionCashBalance.CreditDebitIndicator

//extension OBReadTransactionAlias: OBATReadTransactionProtocol {
//    typealias OBAIReadResourceDataType = OBReadTransaction5Data }
//extension OBReadTransactionDataAlias: OBAIReadTransactionDataProtocol { typealias OBAIResourceType = OBTransaction5 }
extension OBTransactionCDIndicatorAlias: RawRepresentableWithStringRawValue {}
//extension OBTransactionAlias: OBAITransactionProtocol {
//    var nestedAmount: String { return amount.amount }
//}
extension OBTransactionBalanceCDIndicatorAlias: RawRepresentableWithStringRawValue {}
//extension OBTransactionBalanceAlias: OBTransactionCashBalanceProtocol {
//    var nestedAmount: String { return amount.amount }
//}

// Direct debit conformances

extension OBReadDirectDebitV3p1p1Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadDirectDebitDataV3p1p1Alias }
extension OBReadDirectDebitDataV3p1p1Alias: OBAIReadDirectDebitDataProtocol { typealias OBAIResourceType = OBDirectDebitV3p1p1Alias }

extension OBExternalDirectDebitStatusCodeV3p1p1Alias: RawRepresentableWithStringRawValue { }
extension OBActiveOrHistoricCurrencyAndAmountV3p1p1Alias: OBActiveOrHistoricCurrencyAndAmountProtocol { }
extension OBDirectDebitV3p1p1Alias: OBAIDirectDebitProtocol {
}

// Balance conformances

extension OBReadBalanceV3p1p1Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadBalanceDataV3p1p1Alias }
extension OBReadBalanceDataV3p1p1Alias: OBAIReadBalanceDataProtocol {
    typealias OBAIResourceType = OBBalanceV3p1p1Alias }

extension OBBalanceCDIndicatorV3p1p1Alias: RawRepresentableWithStringRawValue { }
extension OBBalanceTypeCodeV3p1p1Alias: RawRepresentableWithStringRawValue { }
extension OBBalanceV3p1p1Alias: OBAIBalanceProtocol {
}

// Standing order conformances

extension OBReadStandingOrderV3p1p1Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadStandingOrderDataV3p1p1Alias }
extension OBReadStandingOrderDataV3p1p1Alias: OBAIReadStandingOrderDataProtocol {
    typealias OBAIResourceType = OBStandingOrderV3p1p1Alias }

extension OBCashAccountV3p1p1Alias: OBCashAccountProtocol { }
extension OBStandingOrderV3p1p1Alias: OBAIStandingOrderProtocol {  }

// Statement conformances

extension OBReadStatementV3p1p1Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadStatementDataV3p1p1Alias }
extension OBReadStatementDataV3p1p1Alias: OBAIReadStatementDataProtocol { typealias OBAIResourceType = OBStatementV3p1p1Alias }

extension OBExternalStatementTypeCodeV3p1p1Alias: RawRepresentableWithStringRawValue { }
extension OBStatementDateTimeV3p1p1Alias: OBStatementDateTimeProtocol {}
extension OBStatementAmountV3p1p1Alias: OBStatementAmountProtocol {}
extension OBStatementAmountCDIndicatorV3p1p1Alias: RawRepresentableWithStringRawValue { }
extension OBStatementV3p1p1Alias: OBAIStatementProtocol {  }

// Scheduled payment conformances

extension OBReadScheduledPaymentV3p1p1Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadScheduledPaymentDataV3p1p1Alias }
extension OBReadScheduledPaymentDataV3p1p1Alias: OBAIReadScheduledPaymentDataProtocol { typealias OBAIResourceType = OBScheduledPaymentV3p1p1Alias }

extension OBExternalScheduleTypeCodeV3p1p1Alias: RawRepresentableWithStringRawValue { }
extension OBScheduledPaymentV3p1p1Alias: OBAIScheduledPaymentProtocol {  }

// Product conformances

extension OBReadProductV3p1p1Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType =  OBReadProductDataV3p1p1Alias }
extension OBReadProductDataV3p1p1Alias: OBAIReadProductDataProtocol { typealias OBAIResourceType = OBProductV3p1p1Alias }

extension OBExternalProductTypeCodeV3p1p1Alias: RawRepresentableWithStringRawValue { }
extension OBProductV3p1p1Alias: OBAIProductProtocol {
    var productTypeOptional: OBExternalProductTypeCodeV3p1p1Alias? { return self.productType }
}

// Offer conformances

extension OBReadOfferV3p1p1Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadOfferDataV3p1p1Alias }
extension OBReadOfferDataV3p1p1Alias: OBAIReadOfferDataProtocol { typealias OBAIResourceType = OBOfferV3p1p1Alias }

extension OBExternalOfferTypeCodeV3p1p1Alias: RawRepresentableWithStringRawValue { }
extension OBOfferV3p1p1Alias: OBAIOfferProtocol {
    
}

// Beneficiary conformances

extension OBReadBeneficiaryV3p1p1Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadBeneficiaryDataV3p1p1Alias }
extension OBReadBeneficiaryDataV3p1p1Alias: OBAIReadBeneficiaryDataProtocol { typealias OBAIResourceType = OBBeneficiaryV3p1p1Alias }

extension OBBeneficiaryV3p1p1Alias: OBAIBeneficiaryProtocol {  }

// Party conformances

extension OBReadPartyV3p1p1Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadPartyDataV3p1p1Alias }
extension OBReadPartyDataV3p1p1Alias: OBAIReadPartyDataProtocol { typealias OBAIResourceType = OBPartyV3p1p1Alias }

extension OBExternalPartyTypeCodeV3p1p1Alias: RawRepresentableWithStringRawValue { }
extension OBPartyV3p1p1Alias: OBAIPartyProtocol { }

// Read consent conformances

fileprivate typealias OBReadConsentAlias = OBReadConsent1
fileprivate typealias OBReadConsentDataAlias = OBReadData1

extension OBRisk2: InitProtocol2 { }
extension OBReadConsentAlias: OBATReadConsentProtocol {
    typealias OBAIReadResourceType = OBReadConsentResponse1
}
extension OBExternalPermissions1Code: RawRepresentableWithStringRawValue { }
extension OBReadConsentDataAlias: OBAIReadConsentDataProtocol { }

fileprivate typealias OBReadConsentResponseAlias = OBReadConsentResponse1
fileprivate typealias OBReadConsentResponseDataAlias = OBReadConsentResponse1Data

extension OBReadConsentResponseAlias: OBATReadConsentResponseProtocol { }
extension OBExternalRequestStatus1Code: RawRepresentableWithStringRawValue { }
//extension OBExternalPermissions1Code: RawRepresentableWithStringRawValue { }
extension OBReadConsentResponseDataAlias: OBAIReadConsentResponseDataProtocol { }


func returnOBAIV3p1p1ReadResourceType(typeName: OBAIReadResourceTypeName) -> OBItem.Type {
    switch typeName {
    //case .OBAIReadAccount: return OBReadAccountV3p1p1Alias.self
    //case .OBAIReadTransaction: return OBReadTransactionAlias.self
    case .OBAIReadDirectDebit: return OBReadDirectDebitV3p1p1Alias.self
    case .OBAIReadBalance: return OBReadBalanceV3p1p1Alias.self
    case .OBAIReadStandingOrder: return OBReadStandingOrderV3p1p1Alias.self
    case .OBAIReadStatement: return OBReadStatementV3p1p1Alias.self
    case .OBAIReadScheduledPayment: return OBReadScheduledPaymentV3p1p1Alias.self
    case .OBAIReadProduct: return OBReadProductV3p1p1Alias.self
    case .OBAIReadOffer: return OBReadOfferV3p1p1Alias.self
    case .OBAIReadBeneficiary: return OBReadBeneficiaryV3p1p1Alias.self
    case .OBAIReadParty: return OBReadPartyV3p1p1Alias.self
    case .OBAIReadConsent: return OBReadConsentAlias.self
    case .OBAIReadConsentResponse: return OBReadConsentResponseAlias.self
    }
}

func returnOBAIV3p1p1ResourceType(typeName: OBAIReadResourceTypeName) -> OBAIResourceProtocol0.Type {
    switch typeName {
    //case .OBAIReadAccount: return OBAccountV3p1p1Alias.self
    //case .OBAIReadTransaction: return OBTransactionAlias.self
    case .OBAIReadDirectDebit: return OBDirectDebitV3p1p1Alias.self
    case .OBAIReadBalance: return OBBalanceV3p1p1Alias.self
    case .OBAIReadStandingOrder: return OBStandingOrderV3p1p1Alias.self
    case .OBAIReadStatement: return OBStatement2.self
    case .OBAIReadScheduledPayment: return OBScheduledPaymentV3p1p1Alias.self
    case .OBAIReadProduct: return OBProductV3p1p1Alias.self
    case .OBAIReadOffer: return OBOfferV3p1p1Alias.self
    case .OBAIReadBeneficiary: return OBBeneficiaryV3p1p1Alias.self
    case .OBAIReadParty: return OBPartyV3p1p1Alias.self
    case .OBAIReadConsent: return OBReadConsentDataAlias.self
    case .OBAIReadConsentResponse: return OBReadConsentResponseDataAlias.self
    }
}

class OBATV3p1p1Types {
    
    static func obATReadConsentType() -> OBATReadConsentProtocolExposedMethods.Type {
        return OBReadConsentAlias.self
    }
    
//    static func obATReadTransactionType() -> OBATReadTransactionProtocolExposedMethods.Type {
//        return OBReadTransactionAlias.self
//    }
    
}

