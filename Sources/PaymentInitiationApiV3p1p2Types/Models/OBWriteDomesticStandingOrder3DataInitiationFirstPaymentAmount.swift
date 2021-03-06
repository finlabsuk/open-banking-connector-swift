//
// OBWriteDomesticStandingOrder3DataInitiationFirstPaymentAmount.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** The amount of the first Standing Order */

public struct OBWriteDomesticStandingOrder3DataInitiationFirstPaymentAmount: Codable {

    public var amount: OBActiveCurrencyAndAmountSimpleType
    public var currency: ActiveOrHistoricCurrencyCode

    public init(amount: OBActiveCurrencyAndAmountSimpleType, currency: ActiveOrHistoricCurrencyCode) {
        self.amount = amount
        self.currency = currency
    }

    public enum CodingKeys: String, CodingKey { 
        case amount = "Amount"
        case currency = "Currency"
    }


}

