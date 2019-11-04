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
import BaseServices
import PaymentInitiationTypeRequirements

public struct OBRiskLocal<OBRiskApi: OBRiskApiProtocol>: Codable {

    /** Specifies the payment context */
    public var paymentContextCode: OBRiskApi.PaymentContextCode?
    /** Category code conform to ISO 18245, related to the type of services or goods the merchant provides for the transaction. */
    public var merchantCategoryCode: String?
    /** The unique customer identifier of the PSU with the merchant. */
    public var merchantCustomerIdentification: String?
    public var deliveryAddress: OBRiskDeliveryAddressLocal<OBRiskApi.OBRiskDeliveryAddress>?

    public enum CodingKeys: String, CodingKey {
        case paymentContextCode = "PaymentContextCode"
        case merchantCategoryCode = "MerchantCategoryCode"
        case merchantCustomerIdentification = "MerchantCustomerIdentification"
        case deliveryAddress = "DeliveryAddress"
    }
    
    func obRiskApi() -> OBRiskApi {
        OBRiskApi.init(paymentContextCode: paymentContextCode, merchantCategoryCode: merchantCategoryCode, merchantCustomerIdentification: merchantCustomerIdentification, deliveryAddress: deliveryAddress?.obRiskDeliveryAddress())
    }

}

public struct OBRiskDeliveryAddressLocal<OBRiskDeliveryAddress: OBRiskDeliveryAddressProtocol>: Codable {

    public var addressLine: [String]?
    public var streetName: String? //StreetName?
    public var buildingNumber: String? //BuildingNumber?
    public var postCode: String //PostCode?
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


