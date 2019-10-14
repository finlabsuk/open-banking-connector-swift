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
import AccountTransactionTypeRequirements
import AccountTransactionApiV3p0Types
import AccountTransactionApiV3p1p1Types
import AccountTransactionApiV3p1p2Types
import AccountTransactionLocalTypes

public enum OBAccountTransactionAPIVersion: String, Codable {
    case V3p0p0
    case V3p1p1
    case V3p1p2
}

public enum OBATResourceType: CaseIterable {
    case transaction
    case account
    public func urlRegexGetOBATResource() -> String {
        switch self {
        case .transaction:
            // GET /accounts/{AccountId}/statements/{StatementId}/transactions
            // GET /accounts/{AccountId}/transactions
            // GET /transactions
            return #"^(?:\/accounts\/([\w-]+)(?:\/statements\/([\w-]+))?)?\/transactions$"#
        case .account:
            // GET /accounts/{AccountId}
            // GET /accounts
            return #"^\/accounts(?:\/([\w-]+))?$"#
        }
    }
}

public protocol OBATResourceProcesingBlock {
    associatedtype InputType
    associatedtype OutputType
    static func executeInner<T1: OBATApiReadResourceProtocol, T2: OBATLocalResourceProtocol>(
        type1: T1.Type,
        type2: T2.Type,
        input: InputType
    ) throws -> OutputType where T2.OBATApiResourceType == T1.OBATApiReadResourceDataType.OBATApiResourceType
}

extension OBATResourceProcesingBlock {
    public static func execute(
        _ apiVersion: OBAccountTransactionAPIVersion,
        _ resourceType: OBATResourceType,
        _ input: InputType
    ) throws -> OutputType {
        switch apiVersion {
        case .V3p0p0:
            return try executeIntermediate(apiTypesType: OBATV3p0ReadResourceTypes.self, resourceType: resourceType, input: input)
        case .V3p1p1:
            return try executeIntermediate(apiTypesType: OBATV3p1p1ReadResourceTypes.self, resourceType: resourceType, input: input)
        case .V3p1p2:
            return try executeIntermediate(apiTypesType: OBATV3p1p2ReadResourceTypes.self, resourceType: resourceType, input: input)
        }
    }
    static func executeIntermediate<T: OBATApiReadResourceTypesProtocol>(
        apiTypesType: T.Type,
        resourceType: OBATResourceType,
        input: InputType
    ) throws -> OutputType {
        switch resourceType {
        case .transaction:
            return try Self.executeInner(
                type1: T.OBATApiReadTransactionType.self,
                type2: OBATLocalTransaction.self,
                input: input
            )
        case .account:
            return try Self.executeInner(
                type1: T.OBATApiReadAccountType.self,
                type2: OBATLocalAccount.self,
                input: input
            )
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
