//
// OBTierBandSet1.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** The group of tiers or bands for which credit interest can be applied. */

public struct OBTierBandSet1: Codable {

    public var tierBandMethod: OBTierBandType1Code
    public var calculationMethod: OBInterestCalculationMethod1Code?
    public var destination: OBInterestDestination1Code
    /** Optional additional notes to supplement the Tier Band Set details */
    public var notes: [String]?
    public var otherCalculationMethod: OBOtherCodeType1?
    public var otherDestination: OBOtherCodeType1?
    /** Tier Band Details */
    public var tierBand: [OBTierBand1]

    public init(tierBandMethod: OBTierBandType1Code, calculationMethod: OBInterestCalculationMethod1Code?, destination: OBInterestDestination1Code, notes: [String]?, otherCalculationMethod: OBOtherCodeType1?, otherDestination: OBOtherCodeType1?, tierBand: [OBTierBand1]) {
        self.tierBandMethod = tierBandMethod
        self.calculationMethod = calculationMethod
        self.destination = destination
        self.notes = notes
        self.otherCalculationMethod = otherCalculationMethod
        self.otherDestination = otherDestination
        self.tierBand = tierBand
    }

    public enum CodingKeys: String, CodingKey { 
        case tierBandMethod = "TierBandMethod"
        case calculationMethod = "CalculationMethod"
        case destination = "Destination"
        case notes = "Notes"
        case otherCalculationMethod = "OtherCalculationMethod"
        case otherDestination = "OtherDestination"
        case tierBand = "TierBand"
    }


}

