//
// OBReadProduct2Data.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** Aligning with the read write specs structure. */

public struct OBReadProduct2Data: Codable {

    public var product: [OBReadProduct2DataProduct]?

    public init(product: [OBReadProduct2DataProduct]?) {
        self.product = product
    }

    public enum CodingKeys: String, CodingKey { 
        case product = "Product"
    }


}
