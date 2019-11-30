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

/// Struct that captures a software statement and associated keys and certificates
struct SoftwareStatementProfilePublic: Codable {
    
    /// Software statement as string, e.g. "A.B.C"
    let softwareStatement: String

    // Open Banking Signing Key ID as string, e.g. "ABC"
    let obSigningKID: String
    
    // Open Banking Signing Key as string, e.g. "-----BEGIN PRIVATE KEY-----\nABCD\n-----END PRIVATE KEY-----\n"
    let obSigningKey: String
    
    // Open Banking Signing Certificate as string, e.g. "-----BEGIN CERTIFICATE-----\nABC\n-----END CERTIFICATE-----\n"
    let obSigningPem: String
    
    // Open Banking Signing Key as string, e.g. "-----BEGIN PRIVATE KEY-----\nABCD\n-----END PRIVATE KEY-----\n"
    let obTransportKey: String
    
    // Open Banking Signing Certificate as string, e.g. "-----BEGIN CERTIFICATE-----\nABC\n-----END CERTIFICATE-----\n"
    let obTransportPem: String
    
}
