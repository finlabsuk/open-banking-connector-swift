//
// OBWriteDataDomesticScheduledConsent2.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct OBWriteDataDomesticScheduledConsent2: Codable {

    public var permission: OBExternalPermissions2Code
    public var initiation: OBDomesticScheduled2
    public var authorisation: OBAuthorisation1?

    public init(permission: OBExternalPermissions2Code, initiation: OBDomesticScheduled2, authorisation: OBAuthorisation1?) {
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

