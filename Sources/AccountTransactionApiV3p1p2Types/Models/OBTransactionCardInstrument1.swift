//
// OBTransactionCardInstrument1.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** Set of elements to describe the card instrument used in the transaction. */

public struct OBTransactionCardInstrument1: Codable {

    public enum CardSchemeName: String, Codable { 
        case americanExpress = "AmericanExpress"
        case diners = "Diners"
        case discover = "Discover"
        case masterCard = "MasterCard"
        case visa = "VISA"
    }
    public enum AuthorisationType: String, Codable { 
        case consumerDevice = "ConsumerDevice"
        case contactless = "Contactless"
        case _none = "None"
        case pin = "PIN"
    }
    /** Name of the card scheme. */
    public var cardSchemeName: CardSchemeName
    /** The card authorisation type. */
    public var authorisationType: AuthorisationType?
    /** Name of the cardholder using the card instrument. */
    public var name: String?
    /** Identification assigned by an institution to identify the card instrument used in the transaction. This identification is known by the account owner, and may be masked. */
    public var identification: String?

    public init(cardSchemeName: CardSchemeName, authorisationType: AuthorisationType?, name: String?, identification: String?) {
        self.cardSchemeName = cardSchemeName
        self.authorisationType = authorisationType
        self.name = name
        self.identification = identification
    }

    public enum CodingKeys: String, CodingKey { 
        case cardSchemeName = "CardSchemeName"
        case authorisationType = "AuthorisationType"
        case name = "Name"
        case identification = "Identification"
    }


}

