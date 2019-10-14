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

import AccountTransactionTypes

struct OBAccountTransactionAPISettingsOverrides: Codable {
    var accountAccessConsentPermissions: [OBAccountTransactionAccountAccessConsentPermissions]?
    mutating func update(with newOverrides: OBAccountTransactionAPISettingsOverrides) {
        if let newValue = newOverrides.accountAccessConsentPermissions {
            accountAccessConsentPermissions = newValue
        }
    }
}

struct OBAccountTransactionAPISettings: Codable {
    var apiVersion: OBAccountTransactionAPIVersion
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
            if let newValue = overrides.accountAccessConsentPermissions {
                accountAccessConsentPermissions = newValue
            }
        }
    }
}

extension OBAccountTransactionAPISettings {

    init(
        apiVersion: OBAccountTransactionAPIVersion,
        obBaseURL: String,
        overrides: OBAccountTransactionAPISettingsOverrides?
    ) {
        self.apiVersion = apiVersion
        self.obBaseURL = obBaseURL
        self.applyOverrides(overrides: overrides)
    }
}
