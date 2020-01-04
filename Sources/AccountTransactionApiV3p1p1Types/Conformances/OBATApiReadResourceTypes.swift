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

public class OBATV3p1p1ReadResourceTypes: OBReadResourceTypesProtocol {
    public typealias OBReadTransactionType = OBReadTransactionAlias
    public typealias OBReadAccountType = OBApiReadAccountAlias
}

public class AccountTransactionRequestOBObjectApiV3p1p1Types: AccountTransactionRequestObjectApiTypesProtocol {
    public typealias OBReadConsentType = OBReadConsentApi
    
}
