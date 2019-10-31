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

public struct OBWriteDomesticConsentLocal<OBWriteDomesticConsentApi: OBWriteDomesticConsentProtocol>: Codable {

    public var data: OBWriteDomesticConsentDataLocal<OBWriteDomesticConsentApi.PaymentInitiationWriteResourceDataType>
    public var risk: OBRiskLocal<OBWriteDomesticConsentApi.OBRiskApi>

    public init(data: OBWriteDomesticConsentDataLocal<OBWriteDomesticConsentApi.PaymentInitiationWriteResourceDataType>, risk: OBRiskLocal<OBWriteDomesticConsentApi.OBRiskApi>) {
        self.data = data
        self.risk = risk
    }

    public enum CodingKeys: String, CodingKey {
        case data = "Data"
        case risk = "Risk"
    }
    
    func apiValue() -> OBWriteDomesticConsentApi {
        OBWriteDomesticConsentApi.init(
            data: data.apiValue(),
            risk: risk.apiValue()
        )
    }

}

public struct OBWriteDomesticConsentDataLocal<OBWriteDomesticConsentDataApi: OBWriteDomesticConsentDataProtocol>: Codable {

    public var initiation: OBWriteDomesticDataInitiationLocal<OBWriteDomesticConsentDataApi.OBWriteDomesticDataInitiationType>
    public var authorisation: OBWriteDomesticConsentDataAuthorisationLocal<OBWriteDomesticConsentDataApi.OBWriteDomesticConsentDataAuthorisationType>?
    public var sCASupportData: OBWriteDomesticConsentDataSCASupportDataLocal<OBWriteDomesticConsentDataApi.OBWriteDomesticConsentDataSCASupportDataType>?

    public init(initiation: OBWriteDomesticDataInitiationLocal<OBWriteDomesticConsentDataApi.OBWriteDomesticDataInitiationType>, authorisation: OBWriteDomesticConsentDataAuthorisationLocal<OBWriteDomesticConsentDataApi.OBWriteDomesticConsentDataAuthorisationType>?, sCASupportData: OBWriteDomesticConsentDataSCASupportDataLocal<OBWriteDomesticConsentDataApi.OBWriteDomesticConsentDataSCASupportDataType>?) {
        self.initiation = initiation
        self.authorisation = authorisation
        self.sCASupportData = sCASupportData
    }

    public enum CodingKeys: String, CodingKey {
        case initiation = "Initiation"
        case authorisation = "Authorisation"
        case sCASupportData = "SCASupportData"
    }

    func apiValue() -> OBWriteDomesticConsentDataApi {
        OBWriteDomesticConsentDataApi.init(
            initiation: initiation.apiValue(),
            authorisation: authorisation?.apiValue(),
            sCASupportData: sCASupportData?.apiValue()
        )
    }

}



public struct OBWriteDomesticDataInitiationLocal<OBWriteDomesticDataInitiationApi: OBWriteDomesticDataInitiationProtocol>: Codable {
    public var instructionIdentification: String
    public var endToEndIdentification: String
    public var localInstrument: String // OBExternalLocalInstrument1Code?
    public var instructedAmount: OBWriteDomesticDataInitiationInstructedAmountLocal<OBWriteDomesticDataInitiationApi.OBWriteDomesticDataInitiationInstructedAmountType>
    public var debtorAccount: OBWriteDomesticDataInitiationDebtorAccountLocal<OBWriteDomesticDataInitiationApi.OBWriteDomesticDataInitiationDebtorAccountType>?
    public var creditorAccount: OBWriteDomesticDataInitiationCreditorAccountLocal<OBWriteDomesticDataInitiationApi.OBWriteDomesticDataInitiationCreditorAccountType>
    //public var creditorPostalAddress: OBPostalAddress6?
    public var remittanceInformation: OBWriteDomesticDataInitiationRemittanceInformationLocal<OBWriteDomesticDataInitiationApi.OBWriteDomesticDataInitiationRemittanceInformationType>?
    //public var supplementaryData: OBSupplementaryData1?

    public init(instructionIdentification: String, endToEndIdentification: String, localInstrument: String /* OBExternalLocalInstrument1Code?*/, instructedAmount: OBWriteDomesticDataInitiationInstructedAmountLocal<OBWriteDomesticDataInitiationApi.OBWriteDomesticDataInitiationInstructedAmountType>, debtorAccount: OBWriteDomesticDataInitiationDebtorAccountLocal<OBWriteDomesticDataInitiationApi.OBWriteDomesticDataInitiationDebtorAccountType>?, creditorAccount: OBWriteDomesticDataInitiationCreditorAccountLocal<OBWriteDomesticDataInitiationApi.OBWriteDomesticDataInitiationCreditorAccountType>, /*creditorPostalAddress: OBPostalAddress6?,*/ remittanceInformation: OBWriteDomesticDataInitiationRemittanceInformationLocal<OBWriteDomesticDataInitiationApi.OBWriteDomesticDataInitiationRemittanceInformationType>? /*supplementaryData: OBSupplementaryData1?*/) {
        self.instructionIdentification = instructionIdentification
        self.endToEndIdentification = endToEndIdentification
        self.localInstrument = localInstrument
        self.instructedAmount = instructedAmount
        self.debtorAccount = debtorAccount
        self.creditorAccount = creditorAccount
        //self.creditorPostalAddress = creditorPostalAddress
        self.remittanceInformation = remittanceInformation
        //self.supplementaryData = supplementaryData
    }

    public enum CodingKeys: String, CodingKey {
        case instructionIdentification = "InstructionIdentification"
        case endToEndIdentification = "EndToEndIdentification"
        case localInstrument = "LocalInstrument"
        case instructedAmount = "InstructedAmount"
        case debtorAccount = "DebtorAccount"
        case creditorAccount = "CreditorAccount"
        //case creditorPostalAddress = "CreditorPostalAddress"
        case remittanceInformation = "RemittanceInformation"
        //case supplementaryData = "SupplementaryData"
    }
    
    func apiValue() -> OBWriteDomesticDataInitiationApi {
        OBWriteDomesticDataInitiationApi.init(
            instructionIdentification: instructionIdentification,
            endToEndIdentification: endToEndIdentification,
            localInstrument: localInstrument,
            instructedAmount: instructedAmount.apiValue(),
            debtorAccount: debtorAccount?.apiValue(),
            creditorAccount: creditorAccount.apiValue(),
            remittanceInformation: remittanceInformation?.apiValue()
        )
    }
    
}

public struct OBWriteDomesticDataInitiationInstructedAmountLocal<OBWriteDomesticDataInitiationInstructedAmountType: OBWriteDomesticDataInitiationInstructedAmountProtocol>: Codable {

    public var amount: String //OBActiveCurrencyAndAmountSimpleType
    public var currency: String //ActiveOrHistoricCurrencyCode

    public init(amount: String /*OBActiveCurrencyAndAmountSimpleType*/, currency: String /*ActiveOrHistoricCurrencyCode*/) {
        self.amount = amount
        self.currency = currency
    }

    public enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case currency = "Currency"
    }
    
    func apiValue() -> OBWriteDomesticDataInitiationInstructedAmountType {
        OBWriteDomesticDataInitiationInstructedAmountType.init(amount: amount, currency: currency)
    }

}

public struct OBWriteDomesticDataInitiationDebtorAccountLocal<OBWriteDomesticDataInitiationDebtorAccountType: OBWriteDomesticDataInitiationDebtorAccountProtocol>: Codable {

    public var schemeName: String //OBExternalAccountIdentification4Code
    public var identification: String //Identification
    /** The account name is the name or names of the account owner(s) represented at an account level, as displayed by the ASPSP&#39;s online channels. Note, the account name is not the product name or the nickname of the account. */
    public var name: String?
    //public var secondaryIdentification: SecondaryIdentification?

    public init(schemeName: String /*OBExternalAccountIdentification4Code*/, identification: String /*Identification*/, name: String? /*secondaryIdentification: SecondaryIdentification?*/) {
        self.schemeName = schemeName
        self.identification = identification
        self.name = name
        //self.secondaryIdentification = secondaryIdentification
    }

    public enum CodingKeys: String, CodingKey {
        case schemeName = "SchemeName"
        case identification = "Identification"
        case name = "Name"
        //case secondaryIdentification = "SecondaryIdentification"
    }
    
    func apiValue() -> OBWriteDomesticDataInitiationDebtorAccountType {
        OBWriteDomesticDataInitiationDebtorAccountType.init(schemeName: schemeName, identification: identification, name: name)
    }

}

public struct OBWriteDomesticDataInitiationCreditorAccountLocal<OBWriteDomesticDataInitiationCreditorAccountType: OBWriteDomesticDataInitiationCreditorAccountProtocol>: Codable {

    public var schemeName: String //OBExternalAccountIdentification4Code
    public var identification: String //Identification
    /** The account name is the name or names of the account owner(s) represented at an account level. Note, the account name is not the product name or the nickname of the account. OB: ASPSPs may carry out name validation for Confirmation of Payee, but it is not mandatory. */
    public var name: String
    //public var secondaryIdentification: SecondaryIdentification?

    public init(
        schemeName: String, //OBExternalAccountIdentification4Code,
        identification: String, //Identification,
        name: String
        //secondaryIdentification: SecondaryIdentification?
    ) {
        self.schemeName = schemeName
        self.identification = identification
        self.name = name
        //self.secondaryIdentification = secondaryIdentification
    }

    public enum CodingKeys: String, CodingKey {
        case schemeName = "SchemeName"
        case identification = "Identification"
        case name = "Name"
        //case secondaryIdentification = "SecondaryIdentification"
    }
    
    func apiValue() -> OBWriteDomesticDataInitiationCreditorAccountType {
        OBWriteDomesticDataInitiationCreditorAccountType.init(schemeName: schemeName, identification: identification, name: name)
    }

}

public struct OBWriteDomesticDataInitiationRemittanceInformationLocal<OBWriteDomesticDataInitiationRemittanceInformationType: OBWriteDomesticDataInitiationRemittanceInformationProtocol>: Codable {

    /** Information supplied to enable the matching/reconciliation of an entry with the items that the payment is intended to settle, such as commercial invoices in an accounts&#39; receivable system, in an unstructured form. */
    public var unstructured: String?
    /** Unique reference, as assigned by the creditor, to unambiguously refer to the payment transaction. Usage: If available, the initiating party should provide this reference in the structured remittance information, to enable reconciliation by the creditor upon receipt of the amount of money. If the business context requires the use of a creditor reference or a payment remit identification, and only one identifier can be passed through the end-to-end chain, the creditor&#39;s reference or payment remittance identification should be quoted in the end-to-end transaction identification. OB: The Faster Payments Scheme can only accept 18 characters for the ReferenceInformation field - which is where this ISO field will be mapped. */
    public var reference: String?

    public init(unstructured: String?, reference: String?) {
        self.unstructured = unstructured
        self.reference = reference
    }

    public enum CodingKeys: String, CodingKey {
        case unstructured = "Unstructured"
        case reference = "Reference"
    }

    func apiValue() -> OBWriteDomesticDataInitiationRemittanceInformationType {
        OBWriteDomesticDataInitiationRemittanceInformationType.init(unstructured: unstructured, reference: reference)
    }

}

public struct OBWriteDomesticConsentDataAuthorisationLocal<OBWriteDomesticConsentDataAuthorisationType: OBWriteDomesticConsentDataAuthorisationProtocol>: Codable {

    /** Type of authorisation flow requested. */
    public var authorisationType: OBWriteDomesticConsentDataAuthorisationType.AuthorisationType
    /** Date and time at which the requested authorisation flow must be completed.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var completionDateTime: Date?

    public init(authorisationType: OBWriteDomesticConsentDataAuthorisationType.AuthorisationType, completionDateTime: Date?) {
        self.authorisationType = authorisationType
        self.completionDateTime = completionDateTime
    }

    public enum CodingKeys: String, CodingKey {
        case authorisationType = "AuthorisationType"
        case completionDateTime = "CompletionDateTime"
    }
    
    func apiValue() -> OBWriteDomesticConsentDataAuthorisationType {
        OBWriteDomesticConsentDataAuthorisationType.init(authorisationType: authorisationType, completionDateTime: completionDateTime)
    }

}

public struct OBWriteDomesticConsentDataSCASupportDataLocal<OBWriteDomesticConsentDataSCASupportDataType>: Codable {

    public enum RequestedSCAExemptionType: String, Codable {
        case billPayment = "BillPayment"
        case contactlessTravel = "ContactlessTravel"
        case ecommerceGoods = "EcommerceGoods"
        case ecommerceServices = "EcommerceServices"
        case kiosk = "Kiosk"
        case parking = "Parking"
        case partyToParty = "PartyToParty"
    }
    public enum AppliedAuthenticationApproach: String, Codable {
        case ca = "CA"
        case sca = "SCA"
    }

    /** This field allows a PISP to request specific SCA Exemption for a Payment Initiation */
    public var requestedSCAExemptionType: RequestedSCAExemptionType?
    /** Specifies a character string with a maximum length of 40 characters. Usage: This field indicates whether the PSU was subject to SCA performed by the TPP */
    public var appliedAuthenticationApproach: AppliedAuthenticationApproach?
    /** Specifies a character string with a maximum length of 140 characters. Usage: If the payment is recurring then the transaction identifier of the previous payment occurrence so that the ASPSP can verify that the PISP, amount and the payee are the same as the previous occurrence. */
    public var referencePaymentOrderId: String?

    public init(requestedSCAExemptionType: RequestedSCAExemptionType?, appliedAuthenticationApproach: AppliedAuthenticationApproach?, referencePaymentOrderId: String?) {
        self.requestedSCAExemptionType = requestedSCAExemptionType
        self.appliedAuthenticationApproach = appliedAuthenticationApproach
        self.referencePaymentOrderId = referencePaymentOrderId
    }

    public enum CodingKeys: String, CodingKey {
        case requestedSCAExemptionType = "RequestedSCAExemptionType"
        case appliedAuthenticationApproach = "AppliedAuthenticationApproach"
        case referencePaymentOrderId = "ReferencePaymentOrderId"
    }
    

}

// This extension is ugly but necessary since Swift does not support OR operator in generic WHERE clause to constrain OBWriteDomesticConsentDataSCASupportDataType
// The two extensions after this one are the valid cases.
extension OBWriteDomesticConsentDataSCASupportDataLocal {
    func apiValue() -> OBWriteDomesticConsentDataSCASupportDataType { fatalError("OBWriteDomesticConsentDataSCASupportDataType must either be Void or conform to OBWriteDomesticConsentDataSCASupportDataProtocol") }
}
extension OBWriteDomesticConsentDataSCASupportDataLocal where OBWriteDomesticConsentDataSCASupportDataType: OBWriteDomesticConsentDataSCASupportDataProtocol {
    func apiValue() -> OBWriteDomesticConsentDataSCASupportDataType {
        let requestedSCAExemptionTypeTmp: OBWriteDomesticConsentDataSCASupportDataType.RequestedSCAExemptionType? = (requestedSCAExemptionType != nil) ?
            OBWriteDomesticConsentDataSCASupportDataType.RequestedSCAExemptionType(rawValue: requestedSCAExemptionType!.rawValue) : nil
        let appliedAuthenticationApproachTmp: OBWriteDomesticConsentDataSCASupportDataType.AppliedAuthenticationApproach? = (appliedAuthenticationApproach != nil) ?
            OBWriteDomesticConsentDataSCASupportDataType.AppliedAuthenticationApproach(rawValue: appliedAuthenticationApproach!.rawValue) : nil
        return OBWriteDomesticConsentDataSCASupportDataType.init(
            requestedSCAExemptionType: requestedSCAExemptionTypeTmp,
            appliedAuthenticationApproach: appliedAuthenticationApproachTmp,
            referencePaymentOrderId: referencePaymentOrderId)
    }
}
extension OBWriteDomesticConsentDataSCASupportDataLocal where OBWriteDomesticConsentDataSCASupportDataType == Void {
    func apiValue() -> OBWriteDomesticConsentDataSCASupportDataType { }
}