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

public protocol tmp1: Codable {
    var consentId: String { get }
}

public protocol tmp2: Codable {
    associatedtype TT1: tmp1
        var data: TT1 { get }
}

public protocol AT_PI_CF_PostRequestApiProtocol: Claims {
    associatedtype ResponseApi: tmp2
}
