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
import SwiftJWT

public protocol OBWritePaymentApiProtocol: Claims {
    associatedtype OBWritePaymentData
    associatedtype OBRiskApi: OBRiskApiProtocol
    associatedtype ResponseApi: OBWritePaymentResponseApiProtocol
    init(
        data: OBWritePaymentData,
        risk: OBRiskApi
    )
}

public protocol OBWriteDomesticApiProtocol: OBWritePaymentApiProtocol where OBWritePaymentData: OBWriteDomesticDataApiProtocol { }

public protocol OBWriteDomesticDataApiProtocol {
    associatedtype OBWriteDomesticDataInitiationApi: OBWriteDomesticDataInitiationProtocol
    
    /** OB: Unique identification as assigned by the ASPSP to uniquely identify the consent resource. */
    var consentId: String { get }
    var initiation: OBWriteDomesticDataInitiationApi { get }

    init(
        consentId: String,
        initiation: OBWriteDomesticDataInitiationApi
    )
}

