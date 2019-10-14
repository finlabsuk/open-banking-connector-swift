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

public protocol OBATApiReadTransactionProtocol: OBATApiReadResourceProtocol where OBATApiReadResourceDataType: OBATApiReadTransactionDataProtocol { }

public protocol OBATApiReadTransactionDataProtocol: OBATApiReadResourceDataProtocol where OBATApiResourceType: OBATApiTransactionProtocol {
    var transaction: [OBATApiResourceType]? { get }
}
extension OBATApiReadTransactionDataProtocol {
    public var resource: [OBATApiResourceType]? { return transaction }
}

public protocol OBATApiTransactionProtocol: OBATApiResourceProtocol {
    associatedtype CreditDebitIndicatorType: RawRepresentableWithStringRawValue
    associatedtype TransactionInformationType: StringProtocol
    associatedtype OBTransactionCashBalanceType: OBTransactionCashBalanceProtocol
    var bookingDateTime: Date {get}
    var transactionId: String? {get}
    var accountId: String {get}
    var balance: OBTransactionCashBalanceType? {get}
    var nestedAmount: String {get}
    var creditDebitIndicator: CreditDebitIndicatorType {get}
    var transactionInformation: TransactionInformationType? {get}
}
