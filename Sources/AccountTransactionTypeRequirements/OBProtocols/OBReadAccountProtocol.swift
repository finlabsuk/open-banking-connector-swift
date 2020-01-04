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

public protocol OBReadAccountProtocol: OBReadResourceProtocol where OBReadResourceData: OBReadAccountDataProtocol { }

public protocol OBReadAccountDataProtocol: OBReadResourceDataProtocol where OBResource: OBAccountProtocol {
    var account: [OBResource]? { get }
}
extension OBReadAccountDataProtocol {
    public var resource: [OBResource]? { return account }
}

public protocol OBAccountProtocol: OBResourceProtocol {
    var nickname: String? {get}
    var accountId: String {get}
    var currency: String {get}
}
