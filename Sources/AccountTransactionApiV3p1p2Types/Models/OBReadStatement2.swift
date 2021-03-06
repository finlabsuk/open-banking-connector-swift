//
// OBReadStatement2.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct OBReadStatement2: Codable {

    public var data: OBReadDataStatement2
    public var links: Links?
    public var meta: Meta?

    public init(data: OBReadDataStatement2, links: Links?, meta: Meta?) {
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

