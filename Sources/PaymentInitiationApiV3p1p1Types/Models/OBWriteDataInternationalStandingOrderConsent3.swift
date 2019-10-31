//
// OBWriteDataInternationalStandingOrderConsent3.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct OBWriteDataInternationalStandingOrderConsent3: Codable {

    public var permission: OBExternalPermissions2Code
    public var initiation: OBInternationalStandingOrder3
    public var authorisation: OBAuthorisation1?

    public init(permission: OBExternalPermissions2Code, initiation: OBInternationalStandingOrder3, authorisation: OBAuthorisation1?) {
        self.permission = permission
        self.initiation = initiation
        self.authorisation = authorisation
    }

    public enum CodingKeys: String, CodingKey { 
        case permission = "Permission"
        case initiation = "Initiation"
        case authorisation = "Authorisation"
    }


}
