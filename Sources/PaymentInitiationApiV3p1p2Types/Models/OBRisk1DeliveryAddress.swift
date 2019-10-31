//
// OBRisk1DeliveryAddress.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** Information that locates and identifies a specific address, as defined by postal services or in free format text. */

public struct OBRisk1DeliveryAddress: Codable {

    public var addressLine: [String]?
    public var streetName: StreetName?
    public var buildingNumber: BuildingNumber?
    public var postCode: PostCode?
    public var townName: TownName
    public var countrySubDivision: [String]?
    /** Nation with its own government, occupying a particular territory. */
    public var country: String

    public init(addressLine: [String]?, streetName: StreetName?, buildingNumber: BuildingNumber?, postCode: PostCode?, townName: TownName, countrySubDivision: [String]?, country: String) {
        self.addressLine = addressLine
        self.streetName = streetName
        self.buildingNumber = buildingNumber
        self.postCode = postCode
        self.townName = townName
        self.countrySubDivision = countrySubDivision
        self.country = country
    }

    public enum CodingKeys: String, CodingKey { 
        case addressLine = "AddressLine"
        case streetName = "StreetName"
        case buildingNumber = "BuildingNumber"
        case postCode = "PostCode"
        case townName = "TownName"
        case countrySubDivision = "CountrySubDivision"
        case country = "Country"
    }


}
