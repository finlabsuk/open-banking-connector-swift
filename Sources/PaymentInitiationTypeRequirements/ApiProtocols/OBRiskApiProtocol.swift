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

public enum OBRiskApiPaymentContextCodeEnum: String, Codable {
    case billPayment = "BillPayment"
    case ecommerceGoods = "EcommerceGoods"
    case ecommerceServices = "EcommerceServices"
    case other = "Other"
    case partyToParty = "PartyToParty"
}

public protocol OBRiskApiProtocol: Codable {
    associatedtype OBRiskDeliveryAddress: OBRiskDeliveryAddressProtocol
    associatedtype PaymentContextCode: RawRepresentable, Codable where PaymentContextCode.RawValue == String
    
    /** Specifies the payment context */
    var paymentContextCode: PaymentContextCode? { get }
    var paymentContextCodeEnum: OBRiskApiPaymentContextCodeEnum?? { get }
    /** Category code conform to ISO 18245, related to the type of services or goods the merchant provides for the transaction. */
    var merchantCategoryCode: String? { get }
    /** The unique customer identifier of the PSU with the merchant. */
    var merchantCustomerIdentification: String? { get }
    var deliveryAddress: OBRiskDeliveryAddress? { get }
    
    init(
        paymentContextCode: OBRiskApiPaymentContextCodeEnum?,
        merchantCategoryCode: String?,
        merchantCustomerIdentification: String?,
        deliveryAddress: OBRiskDeliveryAddress?
    ) throws
}

/** Information that locates and identifies a specific address, as defined by postal services or in free format text. */
public protocol OBRiskDeliveryAddressProtocol: Codable {
    
    var addressLine: [String]? {get set}
    var streetName: String? {get set} // StreetName?
    var buildingNumber: String? {get set} // BuildingNumber?
    var postCode: String? {get set} // PostCode?
    var townName: String {get set} // TownName
    var countrySubDivision: [String]? {get set}
    /** Nation with its own government, occupying a particular territory. */
    var country: String {get set}
    
    init(
        addressLine: [String]?,
        streetName: String?, //StreetName?,
        buildingNumber: String?, //BuildingNumber?,
        postCode: String?, //PostCode?,
        townName: String, //TownName,
        countrySubDivision: [String]?,
        country: String
    )
}
