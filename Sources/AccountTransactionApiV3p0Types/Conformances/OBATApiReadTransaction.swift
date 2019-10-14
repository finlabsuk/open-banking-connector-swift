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

public typealias OBReadTransactionAlias = OBReadTransaction3
public typealias OBReadTransactionDataAlias = OBReadTransaction3Data
public typealias OBTransactionAlias = OBTransaction3
public typealias OBTransactionCDIndicatorAlias = OBTransaction3.CreditDebitIndicator
public typealias OBTransactionBalanceAlias = OBTransactionCashBalance
public typealias OBTransactionBalanceCDIndicatorAlias = OBTransactionCashBalance.CreditDebitIndicator

extension OBReadTransactionAlias: OBATApiReadTransactionProtocol {
    public typealias OBATApiReadResourceDataType = OBReadTransaction3Data
}
extension OBReadTransactionDataAlias: OBATApiReadTransactionDataProtocol {
    public typealias OBATApiResourceType = OBTransaction3
}
extension OBTransactionCDIndicatorAlias: RawRepresentableWithStringRawValue {}
extension OBTransactionAlias: OBATApiTransactionProtocol {
    public var nestedAmount: String { return amount.amount }
}
extension OBTransactionBalanceCDIndicatorAlias: RawRepresentableWithStringRawValue {}
extension OBTransactionBalanceAlias: OBTransactionCashBalanceProtocol {
    public var nestedAmount: String { return amount.amount }
}
