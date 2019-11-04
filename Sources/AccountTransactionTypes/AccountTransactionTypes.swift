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
import AccountTransactionTypeRequirements
import AccountTransactionApiV3p0Types
import AccountTransactionApiV3p1p1Types
import AccountTransactionApiV3p1p2Types
import AccountTransactionLocalTypes

public enum AccountTransactionApiVersion: String, Codable {
    case V3p0p0
    case V3p1p1
    case V3p1p2
}

public enum AccountTransactionResourceVariety: CaseIterable {
    case transaction
    case account
    public func urlRegexGetResource() -> String {
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

public protocol AccountTransactionResourceProcesingBlock {
    associatedtype InputType
    associatedtype OutputType
    static func executeInner<T1: OBATApiReadResourceProtocol, T2: OBATLocalResourceProtocol>(
        type1: T1.Type,
        type2: T2.Type,
        input: InputType
    ) throws -> OutputType where T2.OBATApiResourceType == T1.OBATApiReadResourceDataType.OBATApiResourceType
}

extension AccountTransactionResourceProcesingBlock {
    public static func execute(
        _ apiVersion: AccountTransactionApiVersion,
        _ resourceType: AccountTransactionResourceVariety,
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
        resourceType: AccountTransactionResourceVariety,
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

public enum AccountTransactionRequestObjectVariety: CaseIterable {
    case accountAccessConsent
    public func urlRegexPostObject() -> String {
        switch self {
        case .accountAccessConsent:
            // POST /account-access-consents
            return #"^/account-access-consents$"#
        }
    }
}

public protocol AccountTransactionRequestOBObjectProcesingBlock {
    associatedtype InputType
    associatedtype OutputType
    static func executeInner<T1, T2: AccountTransactionRequestObjectLocalProtocol>(
        type1: T1.Type,
        type2: T2.Type,
        input: InputType
    ) throws -> OutputType where T2.AccountTransactionRequestObjectApi == T1
}

extension AccountTransactionRequestOBObjectProcesingBlock {
    public static func execute(
        _ apiVersion: AccountTransactionApiVersion,
        _ requestOBObjectVariety: AccountTransactionRequestObjectVariety,
        _ input: InputType
    ) throws -> OutputType {
        switch apiVersion {
        case .V3p0p0:
            return try executeIntermediate(apiTypesType: AccountTransactionRequestOBObjectApiV3p0Types.self, requestOBObjectVariety: requestOBObjectVariety, input: input)
        case .V3p1p1:
            return try executeIntermediate(apiTypesType: AccountTransactionRequestOBObjectApiV3p1p1Types.self, requestOBObjectVariety: requestOBObjectVariety, input: input)
        case .V3p1p2:
            return try executeIntermediate(apiTypesType: AccountTransactionRequestOBObjectApiV3p1p2Types.self, requestOBObjectVariety: requestOBObjectVariety, input: input)
        }
    }
    static func executeIntermediate<T: AccountTransactionRequestObjectApiTypesProtocol>(
        apiTypesType: T.Type,
        requestOBObjectVariety: AccountTransactionRequestObjectVariety,
        input: InputType
    ) throws -> OutputType {
        switch requestOBObjectVariety {
        case .accountAccessConsent:
            return try Self.executeInner(
                type1: T.OBReadConsentApiType.self,
                type2: OBReadConsentLocal.self,
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
