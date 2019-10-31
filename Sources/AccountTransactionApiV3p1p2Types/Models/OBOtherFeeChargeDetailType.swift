//
// OBOtherFeeChargeDetailType.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** Other Fee/charge type which is not available in the standard code set */

public struct OBOtherFeeChargeDetailType: Codable {

    public var code: OBCodeMnemonic?
    public var feeCategory: OBFeeCategory1Code
    public var name: Name3
    public var _description: Description3

    public init(code: OBCodeMnemonic?, feeCategory: OBFeeCategory1Code, name: Name3, _description: Description3) {
        self.code = code
        self.feeCategory = feeCategory
        self.name = name
        self._description = _description
    }

    public enum CodingKeys: String, CodingKey { 
        case code = "Code"
        case feeCategory = "FeeCategory"
        case name = "Name"
        case _description = "Description"
    }


}
