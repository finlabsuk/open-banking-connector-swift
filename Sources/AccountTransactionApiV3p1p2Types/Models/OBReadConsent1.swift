//
// OBReadConsent1.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct OBReadConsent1: Codable {

    public var data: OBReadConsent1Data
    public var risk: OBRisk2

    public init(data: OBReadConsent1Data, risk: OBRisk2) {
        self.data = data
        self.risk = risk
    }

    public enum CodingKeys: String, CodingKey { 
        case data = "Data"
        case risk = "Risk"
    }


}

