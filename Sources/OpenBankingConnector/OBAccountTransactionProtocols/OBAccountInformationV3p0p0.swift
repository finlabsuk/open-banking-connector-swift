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

import OBReadWriteV3p0

typealias OBReadAccountV3p0p0Alias = OBReadAccount2
typealias OBReadAccountDataV3p0p0Alias = OBReadAccount2Data
typealias OBAccountV3p0p0Alias = OBAccount2

typealias OBReadTransactionV3p0p0Alias = OBReadTransaction3
typealias OBReadTransactionDataV3p0p0Alias = OBReadTransaction3Data
typealias OBTransactionV3p0p0Alias = OBTransaction3
typealias OBTransactionCDIndicatorV3p0p0Alias = OBTransaction3.CreditDebitIndicator
typealias OBTransactionBalanceV3p0p0Alias = OBTransactionCashBalance
typealias OBTransactionBalanceCDIndicatorV3p0p0Alias = OBTransactionCashBalance.CreditDebitIndicator

typealias OBReadDirectDebitV3p0p0Alias = OBReadDirectDebit1
typealias OBReadDirectDebitDataV3p0p0Alias = OBReadDirectDebit1Data
typealias OBDirectDebitV3p0p0Alias = OBDirectDebit1
typealias OBExternalDirectDebitStatusCodeV3p0p0Alias = OBExternalDirectDebitStatus1Code
typealias OBActiveOrHistoricCurrencyAndAmountV3p0p0Alias = OBActiveOrHistoricCurrencyAndAmount

typealias OBReadBalanceV3p0p0Alias = OBReadBalance1
typealias OBReadBalanceDataV3p0p0Alias = OBReadBalance1Data
typealias OBBalanceV3p0p0Alias = OBCashBalance1
typealias OBBalanceCDIndicatorV3p0p0Alias = OBCashBalance1.CreditDebitIndicator
typealias OBBalanceTypeCodeV3p0p0Alias = OBBalanceType1Code

typealias OBReadStandingOrderV3p0p0Alias = OBReadStandingOrder3
typealias OBReadStandingOrderDataV3p0p0Alias = OBReadStandingOrder3Data
typealias OBStandingOrderV3p0p0Alias = OBStandingOrder3
typealias OBCashAccountV3p0p0Alias = OBCashAccount3

typealias OBReadStatementV3p0p0Alias = OBReadStatement1
typealias OBReadStatementDataV3p0p0Alias = OBReadStatement1Data
typealias OBStatementV3p0p0Alias = OBStatement1
typealias OBExternalStatementTypeCodeV3p0p0Alias = OBExternalStatementType1Code
typealias OBStatementDateTimeV3p0p0Alias = OBStatementDateTime1
typealias OBStatementAmountV3p0p0Alias = OBStatementAmount1
typealias OBStatementAmountCDIndicatorV3p0p0Alias = OBStatementAmount1.CreditDebitIndicator

typealias OBReadScheduledPaymentV3p0p0Alias = OBReadScheduledPayment1
typealias OBReadScheduledPaymentDataV3p0p0Alias = OBReadScheduledPayment1Data
typealias OBScheduledPaymentV3p0p0Alias = OBScheduledPayment1
typealias OBExternalScheduleTypeCodeV3p0p0Alias = OBExternalScheduleType1Code

typealias OBReadProductV3p0p0Alias = OBReadProduct2
typealias OBReadProductDataV3p0p0Alias = OBReadProduct2Data
typealias OBProductV3p0p0Alias = OBProduct2
typealias OBExternalProductTypeCodeV3p0p0Alias = OBExternalProductType1Code

typealias OBReadOfferV3p0p0Alias = OBReadOffer1
typealias OBReadOfferDataV3p0p0Alias = OBReadOffer1Data
typealias OBOfferV3p0p0Alias = OBOffer1
typealias OBExternalOfferTypeCodeV3p0p0Alias = OBExternalOfferType1Code

typealias OBReadBeneficiaryV3p0p0Alias = OBReadBeneficiary2
typealias OBReadBeneficiaryDataV3p0p0Alias = OBReadBeneficiary2Data
typealias OBBeneficiaryV3p0p0Alias = OBBeneficiary2

typealias OBReadPartyV3p0p0Alias = OBReadParty1
typealias OBReadPartyDataV3p0p0Alias = OBReadParty1Data
typealias OBPartyV3p0p0Alias = OBParty1
typealias OBExternalPartyTypeCodeV3p0p0Alias = OBExternalPartyType1Code

// Account conformances

extension OBReadAccountV3p0p0Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadAccountDataV3p0p0Alias }
extension OBReadAccountDataV3p0p0Alias: OBAIReadAccountDataProtocol { typealias OBAIResourceType = OBAccountV3p0p0Alias }

extension OBAccountV3p0p0Alias: OBAIAccountProtocol { }

// Transaction conformances

extension OBReadTransactionV3p0p0Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadTransactionDataV3p0p0Alias }
extension OBReadTransactionDataV3p0p0Alias: OBAIReadTransactionDataProtocol { typealias OBAIResourceType = OBTransactionV3p0p0Alias }

extension OBTransactionBalanceCDIndicatorV3p0p0Alias: RawRepresentableWithStringRawValue { }
extension OBTransactionBalanceV3p0p0Alias: OBTransactionCashBalanceProtocol {
    var nestedAmount: String { return amount.amount }
}
extension OBTransactionCDIndicatorV3p0p0Alias: RawRepresentableWithStringRawValue {}
extension OBTransactionV3p0p0Alias: OBAITransactionProtocol {
    var nestedAmount: String { return amount.amount }
}

// Direct debit conformances

extension OBReadDirectDebitV3p0p0Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadDirectDebitDataV3p0p0Alias }
extension OBReadDirectDebitDataV3p0p0Alias: OBAIReadDirectDebitDataProtocol { typealias OBAIResourceType = OBDirectDebitV3p0p0Alias }

extension OBExternalDirectDebitStatusCodeV3p0p0Alias: RawRepresentableWithStringRawValue { }
extension OBActiveOrHistoricCurrencyAndAmountV3p0p0Alias: OBActiveOrHistoricCurrencyAndAmountProtocol { }
extension OBDirectDebitV3p0p0Alias: OBAIDirectDebitProtocol {
}

// Balance conformances

extension OBReadBalanceV3p0p0Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadBalanceDataV3p0p0Alias }
extension OBReadBalanceDataV3p0p0Alias: OBAIReadBalanceDataProtocol {
    typealias OBAIResourceType = OBBalanceV3p0p0Alias }

extension OBBalanceCDIndicatorV3p0p0Alias: RawRepresentableWithStringRawValue { }
extension OBBalanceTypeCodeV3p0p0Alias: RawRepresentableWithStringRawValue { }
extension OBBalanceV3p0p0Alias: OBAIBalanceProtocol {
}

// Standing order conformances

extension OBReadStandingOrderV3p0p0Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadStandingOrderDataV3p0p0Alias }
extension OBReadStandingOrderDataV3p0p0Alias: OBAIReadStandingOrderDataProtocol {
    typealias OBAIResourceType = OBStandingOrderV3p0p0Alias }

extension OBCashAccountV3p0p0Alias: OBCashAccountProtocol { }
extension OBStandingOrderV3p0p0Alias: OBAIStandingOrderProtocol {  }

// Statement conformances

extension OBReadStatementV3p0p0Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadStatementDataV3p0p0Alias }
extension OBReadStatementDataV3p0p0Alias: OBAIReadStatementDataProtocol { typealias OBAIResourceType = OBStatementV3p0p0Alias }

extension OBExternalStatementTypeCodeV3p0p0Alias: RawRepresentableWithStringRawValue { }
extension OBStatementDateTimeV3p0p0Alias: OBStatementDateTimeProtocol {}
extension OBStatementAmountV3p0p0Alias: OBStatementAmountProtocol {}
extension OBStatementAmountCDIndicatorV3p0p0Alias: RawRepresentableWithStringRawValue { }
extension OBStatementV3p0p0Alias: OBAIStatementProtocol {  }

// Scheduled payment conformances

extension OBReadScheduledPaymentV3p0p0Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadScheduledPaymentDataV3p0p0Alias }
extension OBReadScheduledPaymentDataV3p0p0Alias: OBAIReadScheduledPaymentDataProtocol { typealias OBAIResourceType = OBScheduledPaymentV3p0p0Alias }

extension OBExternalScheduleTypeCodeV3p0p0Alias: RawRepresentableWithStringRawValue { }
extension OBScheduledPaymentV3p0p0Alias: OBAIScheduledPaymentProtocol {  }

// Product conformances

extension OBReadProductV3p0p0Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType =  OBReadProductDataV3p0p0Alias }
extension OBReadProductDataV3p0p0Alias: OBAIReadProductDataProtocol { typealias OBAIResourceType = OBProductV3p0p0Alias }

extension OBExternalProductTypeCodeV3p0p0Alias: RawRepresentableWithStringRawValue { }
extension OBProductV3p0p0Alias: OBAIProductProtocol {
    var productTypeOptional: OBExternalProductTypeCodeV3p0p0Alias? { return self.productType }
}

// Offer conformances

extension OBReadOfferV3p0p0Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadOfferDataV3p0p0Alias }
extension OBReadOfferDataV3p0p0Alias: OBAIReadOfferDataProtocol { typealias OBAIResourceType = OBOfferV3p0p0Alias }

extension OBExternalOfferTypeCodeV3p0p0Alias: RawRepresentableWithStringRawValue { }
extension OBOfferV3p0p0Alias: OBAIOfferProtocol {
}

// Beneficiary conformances

extension OBReadBeneficiaryV3p0p0Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadBeneficiaryDataV3p0p0Alias }
extension OBReadBeneficiaryDataV3p0p0Alias: OBAIReadBeneficiaryDataProtocol { typealias OBAIResourceType = OBBeneficiaryV3p0p0Alias }

extension OBBeneficiaryV3p0p0Alias: OBAIBeneficiaryProtocol { }

// Party conformances

extension OBReadPartyV3p0p0Alias: OBAIReadResourceProtocol { typealias OBAIReadResourceDataType = OBReadPartyDataV3p0p0Alias }
extension OBReadPartyDataV3p0p0Alias: OBAIReadPartyDataProtocol { typealias OBAIResourceType = OBPartyV3p0p0Alias }

extension OBExternalPartyTypeCodeV3p0p0Alias: RawRepresentableWithStringRawValue { }
extension OBPartyV3p0p0Alias: OBAIPartyProtocol {
    var fullLegalName: String? { return nil }
    var beneficialOwnership: Bool? { return nil }
}

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


func returnOBAIV3p0p0ReadResourceType(typeName: OBAIReadResourceTypeName) -> OBItem.Type {
    switch typeName {
    case .OBAIReadAccount: return OBReadAccountV3p0p0Alias.self
    case .OBAIReadTransaction: return OBReadTransactionV3p0p0Alias.self
    case .OBAIReadDirectDebit: return OBReadDirectDebitV3p0p0Alias.self
    case .OBAIReadBalance: return OBReadBalanceV3p0p0Alias.self
    case .OBAIReadStandingOrder: return OBReadStandingOrderV3p0p0Alias.self
    case .OBAIReadStatement: return OBReadStatementV3p0p0Alias.self
    case .OBAIReadScheduledPayment: return OBReadScheduledPaymentV3p0p0Alias.self
    case .OBAIReadProduct: return OBReadProductV3p0p0Alias.self
    case .OBAIReadOffer: return OBReadOfferV3p0p0Alias.self
    case .OBAIReadBeneficiary: return OBReadBeneficiaryV3p0p0Alias.self
    case .OBAIReadParty: return OBReadPartyV3p0p0Alias.self
    case .OBAIReadConsent: return OBReadConsentAlias.self
    case .OBAIReadConsentResponse: return OBReadConsentResponseAlias.self
    }
}

func returnOBAIV3p0p0ResourceType(typeName: OBAIReadResourceTypeName) -> OBAIResourceProtocol0.Type {
    switch typeName {
    case .OBAIReadAccount: return OBAccountV3p0p0Alias.self
    case .OBAIReadTransaction: return OBTransactionV3p0p0Alias.self
    case .OBAIReadDirectDebit: return OBDirectDebitV3p0p0Alias.self
    case .OBAIReadBalance: return OBBalanceV3p0p0Alias.self
    case .OBAIReadStandingOrder: return OBStandingOrderV3p0p0Alias.self
    case .OBAIReadStatement: return OBStatementV3p0p0Alias.self
    case .OBAIReadScheduledPayment: return OBScheduledPaymentV3p0p0Alias.self
    case .OBAIReadProduct: return OBProductV3p0p0Alias.self
    case .OBAIReadOffer: return OBOfferV3p0p0Alias.self
    case .OBAIReadBeneficiary: return OBBeneficiaryV3p0p0Alias.self
    case .OBAIReadParty: return OBPartyV3p0p0Alias.self
    case .OBAIReadConsent: return OBReadConsentDataAlias.self
    case .OBAIReadConsentResponse: return OBReadConsentResponseDataAlias.self
    }
}


class OBATV3p0p0Types {
    
    static func obATReadConsentType() -> OBATReadConsentProtocolExposedMethods.Type {
        return OBReadConsentAlias.self
    }
    
}
