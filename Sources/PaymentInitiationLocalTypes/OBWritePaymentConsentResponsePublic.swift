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
import PaymentInitiationTypeRequirements

// Note: Local Types are spec-version-independent but in order to support conversion to API Types
// they are often generic with respect to the target spec-version-specific API Types
// for which conversions are supported (or to allow
// their nested descendents to support such conversions).
// Notwithstanding this, no data field within a Local Type should have
// any such generic dependency. This ensures the JSON serialisation is spec-version independent.

public struct OBWritePaymentConsentResponsePublic<
    OBWritePaymentConsentResponseApi: OBWritePaymentConsentResponseApiProtocol
>: Codable {
    let authURL: String
    let consentID: String
    let status: OBWritePaymentConsentResponseDataApiStatusEnum?
}
public extension OBWritePaymentConsentResponseApiProtocol {
    func obWritePaymentConsentResponsePublic(
        authURL: String,
        consentID: String
    ) -> OBWritePaymentConsentResponsePublic<Self> {
        OBWritePaymentConsentResponsePublic.init(
            authURL: authURL,
            consentID: consentID,
            status: self.data.statusEnum
        )
    }
}
