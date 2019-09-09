//
// OBBranchAndFinancialInstitutionIdentification5.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** Party that manages the account on behalf of the account owner, that is manages the registration and booking of entries on the account, calculates balances on the account and provides information about the account. This is the servicer of the beneficiary account. */

public struct OBBranchAndFinancialInstitutionIdentification5: Codable {

    public var schemeName: OBExternalFinancialInstitutionIdentification4Code
    /** Unique and unambiguous identification of the servicing institution. */
    public var identification: String

    public init(schemeName: OBExternalFinancialInstitutionIdentification4Code, identification: String) {
        self.schemeName = schemeName
        self.identification = identification
    }

    public enum CodingKeys: String, CodingKey { 
        case schemeName = "SchemeName"
        case identification = "Identification"
    }


}
