//
// OtherApplicationFrequency1.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** Other application frequencies not covered in the standard code list */

public struct OtherApplicationFrequency1: Codable {

    /** The four letter Mnemonic used within an XML file to identify a code */
    public var code: String?
    /** Long name associated with the code */
    public var name: String
    /** Description to describe the purpose of the code */
    public var _description: String

    public init(code: String?, name: String, _description: String) {
        self.code = code
        self.name = name
        self._description = _description
    }

    public enum CodingKeys: String, CodingKey { 
        case code = "Code"
        case name = "Name"
        case _description = "Description"
    }


}

