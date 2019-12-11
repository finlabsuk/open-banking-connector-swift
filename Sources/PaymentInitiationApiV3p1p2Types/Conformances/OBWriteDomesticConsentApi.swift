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
import PaymentInitiationTypeRequirements

public typealias OBWriteDomesticConsentApi = OBWriteDomesticConsent3
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

extension OBWriteDomesticConsentApi: OBWriteDomesticConsentApiProtocol {
    public typealias ResponseApi = OBWriteDomesticConsentResponseApi
}
extension OBWriteDomesticConsentResponse3: tmp2 { }
extension OBWriteDomesticConsentResponse3Data: tmp1 { }

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

extension OBWriteDomesticConsentDataSCASupportDataType: OBWriteDomesticConsentDataSCASupportDataProtocol {
    public init(requestedSCAExemptionType: OBWriteDomesticConsentDataSCASupportDataProtocolRequestedSCAExemptionTypeEnum?, appliedAuthenticationApproach: OBWriteDomesticConsentDataSCASupportDataProtocolAppliedAuthenticationApproachEnum?, referencePaymentOrderId: String?) throws {
        let requestedSCAExemptionTypeNew: RequestedSCAExemptionType?
        switch requestedSCAExemptionType {
        case .none:
            requestedSCAExemptionTypeNew = .none
        case .some(let value):
            guard let newValue = RequestedSCAExemptionType(rawValue: value.rawValue)
                else {
                    throw "Invalid enum field for OB API version"
            }
            requestedSCAExemptionTypeNew = .some(newValue)
        }
        let appliedAuthenticationApproachNew: AppliedAuthenticationApproach?
        switch appliedAuthenticationApproach {
        case .none:
            appliedAuthenticationApproachNew = .none
        case .some(let value):
            guard let newValue = AppliedAuthenticationApproach(rawValue: value.rawValue)
                else {
                    throw "Invalid enum field for OB API version"
            }
            appliedAuthenticationApproachNew = .some(newValue)
        }
        self.init(requestedSCAExemptionType: requestedSCAExemptionTypeNew, appliedAuthenticationApproach: appliedAuthenticationApproachNew, referencePaymentOrderId: referencePaymentOrderId)
    }
    
    public var requestedSCAExemptionTypeEnum: OBWriteDomesticConsentDataSCASupportDataProtocolRequestedSCAExemptionTypeEnum?? {
        if let requestedSCAExemptionType = requestedSCAExemptionType {
            return .some(
                OBWriteDomesticConsentDataSCASupportDataProtocolRequestedSCAExemptionTypeEnum(rawValue: requestedSCAExemptionType.rawValue)
            )
        }
        return .none
    }
    
    public var appliedAuthenticationApproachEnum: OBWriteDomesticConsentDataSCASupportDataProtocolAppliedAuthenticationApproachEnum?? {
        if let appliedAuthenticationApproach = appliedAuthenticationApproach {
            return .some(
                OBWriteDomesticConsentDataSCASupportDataProtocolAppliedAuthenticationApproachEnum(rawValue: appliedAuthenticationApproach.rawValue)
            )
        }
        return .none
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
