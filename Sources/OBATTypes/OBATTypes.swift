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
import OBATProtocols
import OBReadWriteV3p0
import OBReadWriteV3p1p1
import OBReadWriteV3p1p2

public enum OBAccountTransactionAPIVersion: String, Codable {
    case V3p0p0
    case V3p1p1
    case V3p1p2
}

public protocol OBATProcessingBlock {
    associatedtype InputType
    associatedtype OutputType
    typealias TypesProtocol = OBATReadResourceTypesProtocol
    static func executeInner<T: TypesProtocol>(type: T.Type, input: InputType) throws -> OutputType
}
extension OBATProcessingBlock {
    public static func execute(
        _ apiVersion: OBAccountTransactionAPIVersion,
        _ input: InputType
       ) throws -> OutputType {
        switch apiVersion {
        case .V3p0p0:
            return try Self.executeInner(type: OBATV3p0ReadResourceTypes.self, input: input)
        case .V3p1p1:
            return try Self.executeInner(type: OBATV3p1p1ReadResourceTypes.self, input: input)
        case .V3p1p2:
            return try Self.executeInner(type: OBATV3p1p2ReadResourceTypes.self, input: input)
            
        }
    }
}

// Match 3.1.2 spec
public enum OBAccountTransactionAccountAccessConsentPermissions: String, Codable {
    case readAccountsBasic = "ReadAccountsBasic"
    case readAccountsDetail = "ReadAccountsDetail"
    case readBalances = "ReadBalances"
    case readBeneficiariesBasic = "ReadBeneficiariesBasic"
    case readBeneficiariesDetail = "ReadBeneficiariesDetail"
    case readDirectDebits = "ReadDirectDebits"
    case readOffers = "ReadOffers"
    case readPAN = "ReadPAN"
    case readParty = "ReadParty"
    case readPartyPSU = "ReadPartyPSU"
    case readProducts = "ReadProducts"
    case readScheduledPaymentsBasic = "ReadScheduledPaymentsBasic"
    case readScheduledPaymentsDetail = "ReadScheduledPaymentsDetail"
    case readStandingOrdersBasic = "ReadStandingOrdersBasic"
    case readStandingOrdersDetail = "ReadStandingOrdersDetail"
    case readStatementsBasic = "ReadStatementsBasic"
    case readStatementsDetail = "ReadStatementsDetail"
    case readTransactionsBasic = "ReadTransactionsBasic"
    case readTransactionsCredits = "ReadTransactionsCredits"
    case readTransactionsDebits = "ReadTransactionsDebits"
    case readTransactionsDetail = "ReadTransactionsDetail"
}
