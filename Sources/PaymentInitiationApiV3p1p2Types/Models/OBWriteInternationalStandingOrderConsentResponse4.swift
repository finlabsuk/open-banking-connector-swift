//
// OBWriteInternationalStandingOrderConsentResponse4.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct OBWriteInternationalStandingOrderConsentResponse4: Codable {

    public var data: OBWriteInternationalStandingOrderConsentResponse4Data
    public var risk: OBRisk1
    public var links: Links?
    public var meta: Meta?

    public init(data: OBWriteInternationalStandingOrderConsentResponse4Data, risk: OBRisk1, links: Links?, meta: Meta?) {
        self.data = data
        self.risk = risk
        self.links = links
        self.meta = meta
    }

    public enum CodingKeys: String, CodingKey { 
        case data = "Data"
        case risk = "Risk"
        case links = "Links"
        case meta = "Meta"
    }


}
