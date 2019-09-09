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

import OBATProtocols

// Transaction conformances

public typealias OBReadTransactionAlias1 = OBReadTransaction3
public typealias OBReadTransactionDataAlias = OBReadTransaction3Data
public typealias OBTransactionAlias = OBTransaction3
public typealias OBTransactionCDIndicatorAlias = OBTransaction3.CreditDebitIndicator
public typealias OBTransactionBalanceAlias = OBTransactionCashBalance
public typealias OBTransactionBalanceCDIndicatorAlias = OBTransactionCashBalance.CreditDebitIndicator

extension OBReadTransactionAlias1: OBATReadTransactionProtocol {
    public typealias OBAIReadResourceDataType = OBReadTransaction3Data
}
extension OBReadTransactionDataAlias: OBAIReadTransactionDataProtocol {
    public typealias OBAIResourceType = OBTransaction3
}
extension OBTransactionCDIndicatorAlias: RawRepresentableWithStringRawValue {}
extension OBTransactionAlias: OBAITransactionProtocol {
    public var nestedAmount: String { return amount.amount }
}
extension OBTransactionBalanceCDIndicatorAlias: RawRepresentableWithStringRawValue {}
extension OBTransactionBalanceAlias: OBTransactionCashBalanceProtocol {
    public var nestedAmount: String { return amount.amount }
}

public class OBATV3p0ReadResourceTypes: OBATReadResourceTypesProtocol {
    public typealias OBATReadTransactionType = OBReadTransactionAlias1
}
