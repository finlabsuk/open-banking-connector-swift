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
import NIO
import AsyncHTTPClient

// MARK:- Transaction protocols
public protocol OBATReadTransactionProtocol: NewOBAIReadResource2Protocol where OBAIReadResourceDataType: OBAIReadTransactionDataProtocol { }

public protocol OBAIReadTransactionDataProtocol: NewOBAIReadResourceDataProtocol where OBAIResourceType: OBAITransactionProtocol {
    var transaction: [OBAIResourceType]? { get }
}
extension OBAIReadTransactionDataProtocol {
    public var resource: [OBAIResourceType]? { return transaction }
}

public protocol OBAITransactionProtocol: NewOBAIResourceProtocol {
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


//public class OBATReadResourceTypes<OBATReadTransactionType: OBATReadTransactionProtocol> {
//    public init(obATReadTransactionType: OBATReadTransactionType.Type) { }
//    public func getOBATReadTransactionType() -> OBATReadTransactionType.Type {
//        return OBATReadTransactionType.self
//    }
//}

public protocol OBATReadResourceTypesProtocol {
    associatedtype OBATReadTransactionType: OBATReadTransactionProtocol
}

//extension OBATReadResourceTypesProtocol {
//    public static func execute<ResultType>(_ fcn: () throws -> ResultType) rethrows -> ResultType {
//        return try fcn()
//    }
//}

extension OBATReadResourceTypesProtocol {
    public static func execute<ResultType>(_ fcn: () throws -> ResultType) rethrows -> ResultType {
        return try fcn()
    }
}
