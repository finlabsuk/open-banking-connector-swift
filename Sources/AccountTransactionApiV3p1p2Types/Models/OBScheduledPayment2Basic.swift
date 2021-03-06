//
// OBScheduledPayment2Basic.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct OBScheduledPayment2Basic: Codable {

    public var accountId: AccountId
    public var scheduledPaymentId: ScheduledPaymentId?
    public var scheduledPaymentDateTime: ScheduledPaymentDateTime
    public var scheduledType: OBExternalScheduleType1Code
    public var reference: Reference?
    public var instructedAmount: OBActiveOrHistoricCurrencyAndAmount9

    public init(accountId: AccountId, scheduledPaymentId: ScheduledPaymentId?, scheduledPaymentDateTime: ScheduledPaymentDateTime, scheduledType: OBExternalScheduleType1Code, reference: Reference?, instructedAmount: OBActiveOrHistoricCurrencyAndAmount9) {
        self.accountId = accountId
        self.scheduledPaymentId = scheduledPaymentId
        self.scheduledPaymentDateTime = scheduledPaymentDateTime
        self.scheduledType = scheduledType
        self.reference = reference
        self.instructedAmount = instructedAmount
    }

    public enum CodingKeys: String, CodingKey { 
        case accountId = "AccountId"
        case scheduledPaymentId = "ScheduledPaymentId"
        case scheduledPaymentDateTime = "ScheduledPaymentDateTime"
        case scheduledType = "ScheduledType"
        case reference = "Reference"
        case instructedAmount = "InstructedAmount"
    }


}

