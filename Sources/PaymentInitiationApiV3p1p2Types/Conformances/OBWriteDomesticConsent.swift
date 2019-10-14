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

import PaymentInitiationTypeRequirements

public typealias OBWriteDomesticConsentType = OBWriteDomesticConsent3
public typealias OBWriteDomesticConsentDataType = OBWriteDomesticConsent3Data
public typealias OBWriteDomesticDataInitiationType = OBWriteDomestic2DataInitiation
public typealias OBWriteDomesticDataInitiationInstructedAmountType = OBWriteDomestic2DataInitiationInstructedAmount
public typealias OBWriteDomesticDataInitiationDebtorAccountType = OBWriteDomestic2DataInitiationDebtorAccount
public typealias OBWriteDomesticDataInitiationCreditorAccountType = OBWriteDomestic2DataInitiationCreditorAccount
public typealias OBWriteDomesticDataInitiationRemittanceInformationType = OBWriteDomestic2DataInitiationRemittanceInformation

public typealias OBWriteDomesticConsentDataAuthorisationType = OBWriteDomesticConsent3DataAuthorisation

public typealias OBWriteDomesticConsentDataSCASupportDataType = OBWriteDomesticConsent3DataSCASupportData

public typealias OBRiskApi = OBRisk1
public typealias OBRiskDeliveryAddress = OBRisk1DeliveryAddress

extension OBWriteDomesticConsentType: OBWriteDomesticConsentProtocol { }
extension OBWriteDomesticConsentDataType: OBWriteDomesticConsentDataProtocol { }
extension OBWriteDomesticDataInitiationType: OBWriteDomesticDataInitiationProtocol {
    public init(instructionIdentification: String, endToEndIdentification: String, localInstrument: String?, instructedAmount: OBWriteDomestic2DataInitiationInstructedAmount, debtorAccount: OBWriteDomestic2DataInitiationDebtorAccount?, creditorAccount: OBWriteDomestic2DataInitiationCreditorAccount, remittanceInformation: OBWriteDomestic2DataInitiationRemittanceInformation?) {
        self.init(instructionIdentification: instructionIdentification, endToEndIdentification: endToEndIdentification, localInstrument: localInstrument, instructedAmount: instructedAmount, debtorAccount: debtorAccount, creditorAccount: creditorAccount, creditorPostalAddress: nil, remittanceInformation: remittanceInformation, supplementaryData: nil)
    }
}
extension OBWriteDomesticDataInitiationInstructedAmountType: OBWriteDomesticDataInitiationInstructedAmountProtocol { }
extension OBWriteDomesticDataInitiationDebtorAccountType: OBWriteDomesticDataInitiationDebtorAccountProtocol {
    public init(schemeName: String, identification: String, name: String?) {
        self.init(schemeName: schemeName, identification: identification, name: name, secondaryIdentification: nil)
    }
}
extension OBWriteDomesticDataInitiationCreditorAccountType: OBWriteDomesticDataInitiationCreditorAccountProtocol {
    public init(schemeName: String, identification: String, name: String) {
        self.init(schemeName: schemeName, identification: identification, name: name, secondaryIdentification: nil)
    }
}
extension OBWriteDomesticDataInitiationRemittanceInformationType: OBWriteDomesticDataInitiationRemittanceInformationProtocol { }

extension OBWriteDomesticConsentDataAuthorisationType: OBWriteDomesticConsentDataAuthorisationProtocol { }

extension OBWriteDomesticConsentDataSCASupportDataType: OBWriteDomesticConsentDataSCASupportDataProtocol { }

extension OBRiskApi: OBRiskApiProtocol { }
extension OBRiskDeliveryAddress: OBRiskDeliveryAddressProtocol { }
