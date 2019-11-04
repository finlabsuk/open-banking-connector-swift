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
import NIO
import AsyncHTTPClient
import AccountTransactionTypes
import BaseServices

// MARK:- Account access consent protocols

protocol InitProtocol2: Codable {
        init()
}

protocol OBATReadConsentProtocolExposedMethods {
    init(
        permissions: [OBAccountTransactionAccountAccessConsentPermissions],
        expirationDateTime: Date,
        transactionFromDateTime: Date,
        transactionToDateTime: Date
    )
}

protocol OBATReadConsentProtocol: OBATReadConsentProtocolExposedMethods, OBAIReadResource2Protocol {
    associatedtype RiskType: InitProtocol2
    associatedtype OBAIReadResourceType: OBATReadConsentResponseProtocol
    init(data: OBAIReadResourceDataType, risk: RiskType)
}
extension OBATReadConsentProtocol where OBAIReadResourceDataType: OBAIReadConsentDataProtocol {
    init(
        permissions: [OBAccountTransactionAccountAccessConsentPermissions],
        expirationDateTime: Date,
        transactionFromDateTime: Date,
        transactionToDateTime: Date
    ) {
        let data = OBAIReadResourceDataType(
            permissions: permissions.map { OBAIReadResourceDataType.Permissions(rawValue: $0.rawValue)!
            },
            expirationDateTime: expirationDateTime,
            transactionFromDateTime: transactionFromDateTime,
            transactionToDateTime: transactionToDateTime
        )
        self.init(data: data, risk: RiskType())
    }
}

protocol OBAIReadConsentDataProtocol: OBAIResourceProtocol {
    associatedtype Permissions: RawRepresentableWithStringRawValue
    var permissions: [Permissions] { get set }
    var expirationDateTime: Date? { get set }
    var transactionFromDateTime: Date? { get set }
    var transactionToDateTime: Date? { get set }
    init(permissions: [Permissions], expirationDateTime: Date?, transactionFromDateTime: Date?, transactionToDateTime: Date?)
}

// MARK:- Account access consent response protocols

protocol OBATReadConsentResponseProtocol: OBAIReadResource2Protocol where OBAIReadResourceDataType: OBAIReadConsentResponseDataProtocol { }

protocol OBAIReadConsentResponseDataProtocol: OBAIResourceProtocol {
    associatedtype Status: RawRepresentableWithStringRawValue
    associatedtype Permissions: RawRepresentableWithStringRawValue
    var consentId: String { get }
    var creationDateTime: Date { get }
    var status: Status { get }
    var statusUpdateDateTime: Date { get }
    var permissions: [Permissions] { get }
    var expirationDateTime: Date? { get }
    var transactionFromDateTime: Date? { get }
    var transactionToDateTime: Date? { get }
}
