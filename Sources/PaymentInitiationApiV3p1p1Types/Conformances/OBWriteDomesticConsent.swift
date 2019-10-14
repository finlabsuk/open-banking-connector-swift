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
import BaseServices

public typealias OBWriteDomesticConsentType = OBWriteDomesticConsent2
public typealias OBWriteDomesticConsentDataType = OBWriteDataDomesticConsent2
public typealias OBWriteDomesticDataInitiationType = OBDomestic2
public typealias OBWriteDomesticDataInitiationInstructedAmountType = OBDomestic2InstructedAmount
public typealias OBWriteDomesticDataInitiationDebtorAccountType = OBCashAccountDebtor4
public typealias OBWriteDomesticDataInitiationCreditorAccountType = OBCashAccountCreditor3
public typealias OBWriteDomesticDataInitiationRemittanceInformationType = OBRemittanceInformation1

public typealias OBWriteDomesticConsentDataAuthorisationType = OBAuthorisation1

public typealias OBWriteDomesticConsentDataSCASupportDataType = Void

public typealias OBRiskApi = OBRisk1
public typealias OBRiskDeliveryAddress = OBRisk1DeliveryAddress

extension OBWriteDomesticConsentType: OBWriteDomesticConsentProtocol { }
extension OBWriteDomesticConsentDataType: OBWriteDomesticConsentDataProtocol {
    public init(initiation: OBDomestic2, authorisation: OBAuthorisation1?, sCASupportData: Void?) {
        self.init(initiation: initiation, authorisation: authorisation)
    }
    public var sCASupportData: Void? { return nil }
}
extension OBWriteDomesticDataInitiationType: OBWriteDomesticDataInitiationProtocol {
    public init(instructionIdentification: String, endToEndIdentification: String, localInstrument: String?, instructedAmount: OBWriteDomesticDataInitiationInstructedAmountType, debtorAccount: OBWriteDomesticDataInitiationDebtorAccountType?, creditorAccount: OBWriteDomesticDataInitiationCreditorAccountType, remittanceInformation: OBWriteDomesticDataInitiationRemittanceInformationType?) {
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

extension OBRiskApi: OBRiskApiProtocol { }
extension OBRiskDeliveryAddress: OBRiskDeliveryAddressProtocol { }
