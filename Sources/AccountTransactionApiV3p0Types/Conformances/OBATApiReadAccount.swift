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

public typealias OBApiReadAccountAlias = OBReadAccount2
public typealias OBApiReadAccountDataAlias = OBReadAccount2Data
public typealias OBApiAccountAlias = OBAccount2

extension OBApiReadAccountAlias: OBATApiReadAccountProtocol {
    public typealias OBATApiReadResourceDataType = OBApiReadAccountDataAlias
}
extension OBApiReadAccountDataAlias: OBATApiReadAccountDataProtocol {
    public typealias OBATApiResourceType = OBApiAccountAlias
}
extension OBApiAccountAlias: OBATApiAccountProtocol { }
