//
// OBWriteInternationalScheduled2DataInitiation.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** The Initiation payload is sent by the initiating party to the ASPSP. It is used to request movement of funds from the debtor account to a creditor for a single scheduled international payment. */

public struct OBWriteInternationalScheduled2DataInitiation: Codable {

    public enum InstructionPriority: String, Codable { 
        case normal = "Normal"
        case urgent = "Urgent"
    }
    /** Unique identification as assigned by an instructing party for an instructed party to unambiguously identify the instruction. Usage: the  instruction identification is a point to point reference that can be used between the instructing party and the instructed party to refer to the individual instruction. It can be included in several messages related to the instruction. */
    public var instructionIdentification: String
    /** Unique identification assigned by the initiating party to unambiguously identify the transaction. This identification is passed on, unchanged, throughout the entire end-to-end chain. Usage: The end-to-end identification can be used for reconciliation or to link tasks relating to the transaction. It can be included in several messages related to the transaction. OB: The Faster Payments Scheme can only access 31 characters for the EndToEndIdentification field. */
    public var endToEndIdentification: String?
    public var localInstrument: OBExternalLocalInstrument1Code?
    /** Indicator of the urgency or order of importance that the instructing party would like the instructed party to apply to the processing of the instruction. */
    public var instructionPriority: InstructionPriority?
    /** Specifies the external purpose code in the format of character string with a maximum length of 4 characters. The list of valid codes is an external code list published separately. External code sets can be downloaded from www.iso20022.org. */
    public var purpose: String?
    public var chargeBearer: OBChargeBearerType1Code?
    /** Date at which the initiating party requests the clearing agent to process the payment.  Usage: This is the date on which the debtor&#39;s account is to be debited.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var requestedExecutionDateTime: Date
    /** Specifies the currency of the to be transferred amount, which is different from the currency of the debtor&#39;s account. */
    public var currencyOfTransfer: String
    public var instructedAmount: OBWriteDomestic2DataInitiationInstructedAmount
    public var exchangeRateInformation: OBWriteInternational2DataInitiationExchangeRateInformation?
    public var debtorAccount: OBWriteDomestic2DataInitiationDebtorAccount?
    public var creditor: OBWriteInternational2DataInitiationCreditor?
    public var creditorAgent: OBWriteInternational2DataInitiationCreditorAgent?
    public var creditorAccount: OBWriteDomestic2DataInitiationCreditorAccount
    public var remittanceInformation: OBWriteDomestic2DataInitiationRemittanceInformation?
    public var supplementaryData: OBSupplementaryData1?

    public init(instructionIdentification: String, endToEndIdentification: String?, localInstrument: OBExternalLocalInstrument1Code?, instructionPriority: InstructionPriority?, purpose: String?, chargeBearer: OBChargeBearerType1Code?, requestedExecutionDateTime: Date, currencyOfTransfer: String, instructedAmount: OBWriteDomestic2DataInitiationInstructedAmount, exchangeRateInformation: OBWriteInternational2DataInitiationExchangeRateInformation?, debtorAccount: OBWriteDomestic2DataInitiationDebtorAccount?, creditor: OBWriteInternational2DataInitiationCreditor?, creditorAgent: OBWriteInternational2DataInitiationCreditorAgent?, creditorAccount: OBWriteDomestic2DataInitiationCreditorAccount, remittanceInformation: OBWriteDomestic2DataInitiationRemittanceInformation?, supplementaryData: OBSupplementaryData1?) {
        self.instructionIdentification = instructionIdentification
        self.endToEndIdentification = endToEndIdentification
        self.localInstrument = localInstrument
        self.instructionPriority = instructionPriority
        self.purpose = purpose
        self.chargeBearer = chargeBearer
        self.requestedExecutionDateTime = requestedExecutionDateTime
        self.currencyOfTransfer = currencyOfTransfer
        self.instructedAmount = instructedAmount
        self.exchangeRateInformation = exchangeRateInformation
        self.debtorAccount = debtorAccount
        self.creditor = creditor
        self.creditorAgent = creditorAgent
        self.creditorAccount = creditorAccount
        self.remittanceInformation = remittanceInformation
        self.supplementaryData = supplementaryData
    }

    public enum CodingKeys: String, CodingKey { 
        case instructionIdentification = "InstructionIdentification"
        case endToEndIdentification = "EndToEndIdentification"
        case localInstrument = "LocalInstrument"
        case instructionPriority = "InstructionPriority"
        case purpose = "Purpose"
        case chargeBearer = "ChargeBearer"
        case requestedExecutionDateTime = "RequestedExecutionDateTime"
        case currencyOfTransfer = "CurrencyOfTransfer"
        case instructedAmount = "InstructedAmount"
        case exchangeRateInformation = "ExchangeRateInformation"
        case debtorAccount = "DebtorAccount"
        case creditor = "Creditor"
        case creditorAgent = "CreditorAgent"
        case creditorAccount = "CreditorAccount"
        case remittanceInformation = "RemittanceInformation"
        case supplementaryData = "SupplementaryData"
    }


}
