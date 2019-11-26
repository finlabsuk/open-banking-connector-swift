// ********************************************************************************
//
// This source file is part of the Open Banking Connector project
// ( https://github.com/finlabsuk/open-banking-connector ).
//
// Copyright (C) 2019 Finnovation Labs and the Open Banking Connector project authors.
//
// Licensed under Apache License v2.0. See LICENSE.txt for licence information.
// SPDX-License-Identifier: Apache-2.0
//
// ********************************************************************************

import Foundation
import PaymentInitiationTypeRequirements

// Note: Local Types are spec-version-independent but in order to support conversion to API Types
// they are often generic with respect to the target spec-version-specific API Types
// for which conversions are supported (or to allow
// their nested descendents to support such conversions).
// Notwithstanding this, no data field within a Local Type should have
// any such generic dependency. This ensures the JSON serialisation is spec-version independent.

/** The Risk section is sent by the initiating party to the ASPSP. It is used to specify additional details for risk scoring for Payments. */
public struct OBRiskLocal<OBRiskApi: OBRiskApiProtocol>: Codable {
    
    public enum PaymentContextCode: String, Codable {
        case billPayment = "BillPayment"
        case ecommerceGoods = "EcommerceGoods"
        case ecommerceServices = "EcommerceServices"
        case other = "Other"
        case partyToParty = "PartyToParty"
    }

    /** Specifies the payment context */
    public var paymentContextCode: PaymentContextCode?
    /** Category code conform to ISO 18245, related to the type of services or goods the merchant provides for the transaction. */
    public var merchantCategoryCode: String?
    /** The unique customer identifier of the PSU with the merchant. */
    public var merchantCustomerIdentification: String?
    public var deliveryAddress: OBRiskDeliveryAddressLocal<OBRiskApi.OBRiskDeliveryAddress>?
    
    public init(
        paymentContextCode: PaymentContextCode?,
        merchantCategoryCode: String?,
        merchantCustomerIdentification: String?,
        deliveryAddress: OBRiskDeliveryAddressLocal<OBRiskApi.OBRiskDeliveryAddress>?
    ) {
        self.paymentContextCode = paymentContextCode
        self.merchantCategoryCode = merchantCategoryCode
        self.merchantCustomerIdentification = merchantCustomerIdentification
        self.deliveryAddress = deliveryAddress
    }

    public enum CodingKeys: String, CodingKey {
        case paymentContextCode = "PaymentContextCode"
        case merchantCategoryCode = "MerchantCategoryCode"
        case merchantCustomerIdentification = "MerchantCustomerIdentification"
        case deliveryAddress = "DeliveryAddress"
    }
    
    func obRiskApi() -> OBRiskApi {
        OBRiskApi.init(
            paymentContextCode: OBRiskApi.PaymentContextCode(rawValue: paymentContextCode!.rawValue),
            merchantCategoryCode: merchantCategoryCode,
            merchantCustomerIdentification: merchantCustomerIdentification,
            deliveryAddress: deliveryAddress?.obRiskDeliveryAddress()
        )
    }

}
public extension OBRiskApiProtocol {
    func obRiskLocal() -> OBRiskLocal<Self> {
        OBRiskLocal.init(
            paymentContextCode: OBRiskLocal.PaymentContextCode(rawValue: paymentContextCode!.rawValue)!,
            merchantCategoryCode: merchantCategoryCode,
            merchantCustomerIdentification: merchantCustomerIdentification,
            deliveryAddress: deliveryAddress?.obRiskDeliveryAddressLocal()

        )
    }
}


public struct OBRiskDeliveryAddressLocal<OBRiskDeliveryAddress: OBRiskDeliveryAddressProtocol>: Codable {

    public var addressLine: [String]?
    public var streetName: String? //StreetName?
    public var buildingNumber: String? //BuildingNumber?
    public var postCode: String? //PostCode?
    public var townName: String //TownName
    public var countrySubDivision: [String]?
    /** Nation with its own government, occupying a particular territory. */
    public var country: String

    public enum CodingKeys: String, CodingKey {
        case addressLine = "AddressLine"
        case streetName = "StreetName"
        case buildingNumber = "BuildingNumber"
        case postCode = "PostCode"
        case townName = "TownName"
        case countrySubDivision = "CountrySubDivision"
        case country = "Country"
    }
    
    func obRiskDeliveryAddress() -> OBRiskDeliveryAddress {
        OBRiskDeliveryAddress.init(addressLine: addressLine, streetName: streetName, buildingNumber: buildingNumber, postCode: postCode, townName: townName, countrySubDivision: countrySubDivision, country: country)
    }

}
public extension OBRiskDeliveryAddressProtocol {
    func obRiskDeliveryAddressLocal() -> OBRiskDeliveryAddressLocal<Self> {
        OBRiskDeliveryAddressLocal(
            addressLine: addressLine,
            streetName: streetName,
            buildingNumber: buildingNumber,
            postCode: postCode,
            townName: townName,
            countrySubDivision: countrySubDivision,
            country: country
        )
    }
}



