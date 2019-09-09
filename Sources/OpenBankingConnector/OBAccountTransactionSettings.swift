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

enum OBAccountTransactionAPIVersion: String, Codable {
    case V3p0p0
    case V3p1p1
    case V3p1p2
    func returnOBAIReadResourceType(typeName: OBAIReadResourceTypeName) -> OBItem.Type {
        switch self {
        case .V3p0p0:
            return returnOBAIV3p0p0ReadResourceType(typeName: typeName)
        case .V3p1p1:
            return returnOBAIV3p1p1ReadResourceType(typeName: typeName)
        case .V3p1p2:
            return returnOBAIV3p1p2ReadResourceType(typeName: typeName)
            
        }
    }
    
    // SOME THEORY...
    // func returnOBAIResourceType(typeName: OBAIReadResourceTypeName) -> OBAIResourceProtocol.Type // <---- existential
    // func returnOBAIResourceType<OBAIResourceType: OBAIResourceProtocol>(typeName: OBAIReadResourceTypeName) -> OBAIResourceType.Type // <---- generic
    //
    // Where:
    // * generic (not existential): multiple returnOBAIResourceType functions created at compile time (for each type it is called with)
    // * existential: single returnOBAIResourceType function is created at compile time
    //
    // Protocol usage:
    // 1. can be used as interface, restriction on generic type (and classes satisfy these interfaces)
    // 2. and can be used as type (as existential)
    
    func returnOBAIResourceType(typeName: OBAIReadResourceTypeName) -> OBAIResourceProtocol0.Type {
        switch self {
        case .V3p0p0:
            return returnOBAIV3p0p0ResourceType(typeName: typeName)
        case .V3p1p1:
            return returnOBAIV3p1p1ResourceType(typeName: typeName)
        case .V3p1p2:
            return returnOBAIV3p1p2ResourceType(typeName: typeName)
            
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

struct OBAccountTransactionAPISettings: Codable {
    var apiVersion: OBAccountTransactionAPIVersion = .V3p1p1
    var accountAccessConsentPermissions: [OBAccountTransactionAccountAccessConsentPermissions] = [
        .readAccountsBasic,
        .readAccountsDetail,
        .readBalances,
        .readBeneficiariesBasic,
        .readBeneficiariesDetail,
        .readDirectDebits,
        .readOffers,
        .readPAN,
        .readParty,
        .readPartyPSU,
        .readProducts,
        .readScheduledPaymentsBasic,
        .readScheduledPaymentsDetail,
        .readStandingOrdersBasic,
        .readStandingOrdersDetail,
        .readStatementsBasic,
        .readStatementsDetail,
        .readTransactionsBasic,
        .readTransactionsCredits,
        .readTransactionsDebits,
        .readTransactionsDetail,
    ]
    let obBaseURL: String
    mutating func applyOverrides(overrides: OBAccountTransactionAPISettingsOverrides?) {
        if let overrides = overrides {
            if let newValue = overrides.apiVersion {
                apiVersion = newValue
            }
            if let newValue = overrides.accountAccessConsentPermissions {
                accountAccessConsentPermissions = newValue
            }
        }
    }
}

extension OBAccountTransactionAPISettings {

    init(
        obBaseURL: String,
        overrides: OBAccountTransactionAPISettingsOverrides?
    ) {
        self.obBaseURL = obBaseURL
        self.applyOverrides(overrides: overrides)
    }
}

