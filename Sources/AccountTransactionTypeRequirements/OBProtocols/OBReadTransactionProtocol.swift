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

public protocol OBReadTransactionProtocol: OBReadResourceProtocol where OBReadResourceData: OBReadTransactionDataProtocol { }

public protocol OBReadTransactionDataProtocol: OBReadResourceDataProtocol where OBResource: OBTransactionProtocol {
    var transaction: [OBResource]? { get }
}
extension OBReadTransactionDataProtocol {
    public var resource: [OBResource]? { return transaction }
}

public protocol OBTransactionProtocol: OBResourceProtocol {
    associatedtype OBCreditDebitCode: RawRepresentable, Codable where OBCreditDebitCode.RawValue == String
    associatedtype TransactionInformation: StringProtocol
    associatedtype OBTransactionCashBalance: OBTransactionCashBalanceProtocol
    var bookingDateTime: Date {get}
    var transactionId: String? {get}
    var accountId: String {get}
    var balance: OBTransactionCashBalance? {get}
    var nestedAmount: String {get}
    var creditDebitIndicator: OBCreditDebitCode {get}
    var creditDebitIndicatorEnum: OBCreditDebitCodeEnum? {get}
    var transactionInformation: TransactionInformation? {get}
}
