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

// MARK:- Base protocols.

public protocol PaymentInitiationWriteResourceProtocol: Codable {
    associatedtype PaymentInitiationWriteResourceDataType
    associatedtype OBRiskApi
    init(
        data: PaymentInitiationWriteResourceDataType,
        risk: OBRiskApi
    )
}
