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
import PaymentInitiationTypes

struct OBClientProfilePublic: Codable {
    
    /// ID of software statement profile
    let softwareStatementProfileID: String
    
    /// Issuer URL (add /.well-known/openid-configuration to obtain Open ID Connect Discovery endpiont)
    let issuerURL: String
    
    /// This unique Id is issued by UK OBIE and corresponds to the Organization Id of the ASPSP in the Open Banking Directory.
    let xFapiFinancialID: String
    
    let accountTransactionAPIVersion: AccountTransactionApiVersion
    let accountTransactionAPIBaseURL: String
    
    /// UK Open Banking Payment Initiation API version
    let paymentInitiationAPIVersion: PaymentInitiationApiVersion
    
    /// UK Open Banking Payment Initiation base URL
    let paymentInitiationAPIBaseURL: String
    
    // Overrides
    let openIDConfigurationOverrides: OpenIDConfigurationOverrides?
    let httpClientMTLSConfigurationOverrides: HTTPClientMTLSConfigurationOverrides?
    let obClientRegistrationClaimsOverrides: OBClientRegistrationClaimsOverrides?
    let obClientRegistrationResponseOverrides: OBClientRegistrationResponseOverrides?
    let obAccountTransactionAPISettingsOverrides: OBAccountTransactionAPISettingsOverrides?

}
