//
// OBOtherProductType1.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** This field provides extension to the ProductType enumeration. If ProductType - \&quot;Other\&quot; is chosen, this field must be populated with name, and description for ASPSP specific product type. */

public struct OBOtherProductType1: Codable {

    /** Name of \&quot;Other\&quot; product type. */
    public var name: String
    /** Description of \&quot;Other\&quot; product type. */
    public var _description: String

    public init(name: String, _description: String) {
        self.name = name
        self._description = _description
    }

    public enum CodingKeys: String, CodingKey { 
        case name = "Name"
        case _description = "Description"
    }


}
