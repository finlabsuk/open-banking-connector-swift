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

public protocol OBRiskApiProtocol: Codable {
    init()
}

public protocol OBReadConsentApiProtocol: AT_PI_CF_PostRequestApiProtocol where ResponseApi: OBReadConsentResponseApiProtocol {
    
    associatedtype OBReadConsentDataApi: OBReadConsentDataApiProtocol
    var data: OBReadConsentDataApi { get set }

    associatedtype OBRiskApi: OBRiskApiProtocol
    var risk: OBRiskApi { get set }

    init(data: OBReadConsentDataApi, risk: OBRiskApi)
}

public protocol OBReadConsentDataApiProtocol: OBATApiResourceProtocol {
    associatedtype Permissions: RawRepresentable, Codable where Permissions.RawValue == String
    var permissions: [Permissions] { get set }
    var expirationDateTime: Date? { get set }
    var transactionFromDateTime: Date? { get set }
    var transactionToDateTime: Date? { get set }
    init(permissions: [Permissions], expirationDateTime: Date?, transactionFromDateTime: Date?, transactionToDateTime: Date?)
}

public protocol OBReadConsentResponseApiProtocol: Codable {
    
    associatedtype OBReadConsentResponseDataApi: OBReadConsentResponseDataApiProtocol
    var data: OBReadConsentResponseDataApi { get }

    associatedtype OBRiskApi: OBRiskApiProtocol
    var riskOptional: OBRiskApi? { get } // Modified to be optional
    
    // Add links, meta, init

}

public protocol OBReadConsentResponseDataApiProtocol: OBATApiResourceProtocol {
    associatedtype Status: RawRepresentable, Codable where Status.RawValue == String
    associatedtype Permissions: RawRepresentable, Codable where Permissions.RawValue == String
    var consentId: String { get }
    var creationDateTime: Date { get }
    var status: Status { get }
    var statusUpdateDateTime: Date { get }
    var permissions: [Permissions] { get }
    var expirationDateTime: Date? { get }
    var transactionFromDateTime: Date? { get }
    var transactionToDateTime: Date? { get }
}







