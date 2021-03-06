//
// OBStatementValue1.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** Set of elements used to provide details of a generic number value related to the statement resource. */

public struct OBStatementValue1: Codable {

    public var value: OBExternalStatementValueType1Code
    /** Statement value type, in a coded form. */
    public var type: String

    public init(value: OBExternalStatementValueType1Code, type: String) {
        self.value = value
        self.type = type
    }

    public enum CodingKeys: String, CodingKey { 
        case value = "Value"
        case type = "Type"
    }


}

