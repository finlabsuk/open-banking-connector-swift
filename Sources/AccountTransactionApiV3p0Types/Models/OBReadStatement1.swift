//
// OBReadStatement1.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct OBReadStatement1: Codable {

    public var data: OBReadStatement1Data
    public var links: Links
    public var meta: Meta

    public init(data: OBReadStatement1Data, links: Links, meta: Meta) {
        self.data = data
        self.links = links
        self.meta = meta
    }

    public enum CodingKeys: String, CodingKey { 
        case data = "Data"
        case links = "Links"
        case meta = "Meta"
    }


}

