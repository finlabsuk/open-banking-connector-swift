//
// OBWriteDomesticStandingOrderConsentResponse4Data.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct OBWriteDomesticStandingOrderConsentResponse4Data: Codable {

    public enum Status: String, Codable { 
        case authorised = "Authorised"
        case awaitingAuthorisation = "AwaitingAuthorisation"
        case consumed = "Consumed"
        case rejected = "Rejected"
    }
    public enum Permission: String, Codable { 
        case create = "Create"
    }
    /** OB: Unique identification as assigned by the ASPSP to uniquely identify the consent resource. */
    public var consentId: String
    /** Date and time at which the resource was created.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var creationDateTime: Date
    /** Specifies the status of consent resource in code form. */
    public var status: Status
    /** Date and time at which the resource status was updated.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var statusUpdateDateTime: Date
    /** Specifies the Open Banking service request types. */
    public var permission: Permission
    /** Specified cut-off date and time for the payment consent.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var cutOffDateTime: Date?
    public var charges: [OBWriteDomesticConsentResponse3DataCharges]?
    public var initiation: OBWriteDomesticStandingOrder3DataInitiation
    public var authorisation: OBWriteDomesticConsent3DataAuthorisation?
    public var sCASupportData: OBWriteDomesticConsent3DataSCASupportData?

    public init(consentId: String, creationDateTime: Date, status: Status, statusUpdateDateTime: Date, permission: Permission, cutOffDateTime: Date?, charges: [OBWriteDomesticConsentResponse3DataCharges]?, initiation: OBWriteDomesticStandingOrder3DataInitiation, authorisation: OBWriteDomesticConsent3DataAuthorisation?, sCASupportData: OBWriteDomesticConsent3DataSCASupportData?) {
        self.consentId = consentId
        self.creationDateTime = creationDateTime
        self.status = status
        self.statusUpdateDateTime = statusUpdateDateTime
        self.permission = permission
        self.cutOffDateTime = cutOffDateTime
        self.charges = charges
        self.initiation = initiation
        self.authorisation = authorisation
        self.sCASupportData = sCASupportData
    }

    public enum CodingKeys: String, CodingKey { 
        case consentId = "ConsentId"
        case creationDateTime = "CreationDateTime"
        case status = "Status"
        case statusUpdateDateTime = "StatusUpdateDateTime"
        case permission = "Permission"
        case cutOffDateTime = "CutOffDateTime"
        case charges = "Charges"
        case initiation = "Initiation"
        case authorisation = "Authorisation"
        case sCASupportData = "SCASupportData"
    }


}
