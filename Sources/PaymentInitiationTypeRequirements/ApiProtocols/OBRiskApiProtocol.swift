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

public protocol OBRiskApiProtocol: Codable {
    associatedtype OBRiskDeliveryAddress: OBRiskDeliveryAddressProtocol
    associatedtype PaymentContextCode: RawRepresentable, Codable where PaymentContextCode.RawValue == String
    init(paymentContextCode: PaymentContextCode?, merchantCategoryCode: String?, merchantCustomerIdentification: String?, deliveryAddress: OBRiskDeliveryAddress?)
}

public protocol OBRiskDeliveryAddressProtocol: Codable {
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
