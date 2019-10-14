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

public protocol OBATApiReadAccountProtocol: OBATApiReadResourceProtocol where OBATApiReadResourceDataType: OBATApiReadAccountDataProtocol { }

public protocol OBATApiReadAccountDataProtocol: OBATApiReadResourceDataProtocol where OBATApiResourceType: OBATApiAccountProtocol {
    var account: [OBATApiResourceType]? { get }
}
extension OBATApiReadAccountDataProtocol {
    public var resource: [OBATApiResourceType]? { return account }
}

public protocol OBATApiAccountProtocol: OBATApiResourceProtocol {
    var nickname: String? {get}
    var accountId: String {get}
    var currency: String {get}
}
