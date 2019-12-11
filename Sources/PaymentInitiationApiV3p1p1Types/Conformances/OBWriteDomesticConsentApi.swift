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
import PaymentInitiationTypeRequirements
import BaseServices

public typealias OBWriteDomesticConsentApi = OBWriteDomesticConsent2
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

extension OBWriteDomesticConsentApi: OBWriteDomesticConsentApiProtocol {
    public typealias ResponseApi = OBWriteDomesticConsentResponseApi
}
extension OBWriteDomesticConsentResponse2: tmp2 { }
extension OBWriteDataDomesticConsentResponse2: tmp1 { }
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

extension OBWriteDomesticConsentDataAuthorisationType: OBWriteDomesticConsentDataAuthorisationProtocol {
    public var authorisationTypeEnum: OBWriteDomesticConsentDataAuthorisationProtocolAuthorisationTypeEnum? {
        return OBWriteDomesticConsentDataAuthorisationProtocolAuthorisationTypeEnum(rawValue: authorisationType.rawValue)
    }
    
    public init(authorisationType: OBWriteDomesticConsentDataAuthorisationProtocolAuthorisationTypeEnum, completionDateTime: Date?) throws {
        guard let authorisationType = AuthorisationType(rawValue: authorisationType.rawValue) else {
            throw "Invalid enum field for OB API version"
        }
        self.init(authorisationType: authorisationType, completionDateTime: completionDateTime)
    }
}

extension OBRiskApi: OBRiskApiProtocol {
    public var paymentContextCodeEnum: OBRiskApiPaymentContextCodeEnum?? {
        get {
            if let paymentContextCode = paymentContextCode {
                return .some(
                    OBRiskApiPaymentContextCodeEnum(rawValue: paymentContextCode.rawValue)
                )
            }
            return .none
        }
    }
    
    public init(paymentContextCode: OBRiskApiPaymentContextCodeEnum?, merchantCategoryCode: String?, merchantCustomerIdentification: String?, deliveryAddress: OBRisk1DeliveryAddress?) throws {
        let paymentContextCodeNew: PaymentContextCode?
        switch paymentContextCode {
        case .none:
            paymentContextCodeNew = .none
        case .some(let value):
            guard let newValue = PaymentContextCode(rawValue: value.rawValue)
                else {
                    throw "Invalid enum field for OB API version"
            }
            paymentContextCodeNew = .some(newValue)
        }
        self.init(paymentContextCode: paymentContextCodeNew, merchantCategoryCode: merchantCategoryCode, merchantCustomerIdentification: merchantCustomerIdentification, deliveryAddress: deliveryAddress)
    }
}
extension OBRiskDeliveryAddress: OBRiskDeliveryAddressProtocol { }
