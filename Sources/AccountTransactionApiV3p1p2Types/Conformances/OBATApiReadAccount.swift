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

import AccountTransactionTypeRequirements

public typealias OBApiReadAccountAlias = OBReadAccount4
public typealias OBApiReadAccountDataAlias = OBReadAccount4Data
public typealias OBApiAccountAlias = OBAccount4

extension OBApiReadAccountAlias: OBReadAccountProtocol {
    public typealias OBReadResourceData = OBApiReadAccountDataAlias
}
extension OBApiReadAccountDataAlias: OBReadAccountDataProtocol {
    public typealias OBResource = OBApiAccountAlias
}
extension OBApiAccountAlias: OBAccountProtocol { }
