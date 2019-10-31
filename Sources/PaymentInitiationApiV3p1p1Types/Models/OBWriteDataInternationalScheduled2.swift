//
// OBWriteDataInternationalScheduled2.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct OBWriteDataInternationalScheduled2: Codable {

    /** OB: Unique identification as assigned by the ASPSP to uniquely identify the consent resource. */
    public var consentId: String
    public var initiation: OBInternationalScheduled2

    public init(consentId: String, initiation: OBInternationalScheduled2) {
        self.consentId = consentId
        self.initiation = initiation
    }

    public enum CodingKeys: String, CodingKey { 
        case consentId = "ConsentId"
        case initiation = "Initiation"
    }


}
