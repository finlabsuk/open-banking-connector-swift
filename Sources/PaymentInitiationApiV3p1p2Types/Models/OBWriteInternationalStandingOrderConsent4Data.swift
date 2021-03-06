//
// OBWriteInternationalStandingOrderConsent4Data.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct OBWriteInternationalStandingOrderConsent4Data: Codable {

    public enum Permission: String, Codable { 
        case create = "Create"
    }
    /** Specifies the Open Banking service request types. */
    public var permission: Permission
    public var initiation: OBWriteInternationalStandingOrder3DataInitiation
    public var authorisation: OBWriteDomesticConsent3DataAuthorisation?
    public var sCASupportData: OBWriteDomesticConsent3DataSCASupportData?

    public init(permission: Permission, initiation: OBWriteInternationalStandingOrder3DataInitiation, authorisation: OBWriteDomesticConsent3DataAuthorisation?, sCASupportData: OBWriteDomesticConsent3DataSCASupportData?) {
        self.permission = permission
        self.initiation = initiation
        self.authorisation = authorisation
        self.sCASupportData = sCASupportData
    }

    public enum CodingKeys: String, CodingKey { 
        case permission = "Permission"
        case initiation = "Initiation"
        case authorisation = "Authorisation"
        case sCASupportData = "SCASupportData"
    }


}

