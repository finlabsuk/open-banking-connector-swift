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
import LocalProtocols
import OBATProtocols

public struct Transaction: TransactionProtocol {
    let bookingDateTime: Date
    let description: String
    let amount: String
    let creditDebitIndicator: String
}

extension Transaction {
    public init<T: OBAITransactionProtocol>(_ original: T) {
        self.init(
            bookingDateTime: original.bookingDateTime,
            description: String(original.transactionInformation ?? ""),
            amount: original.nestedAmount,
            creditDebitIndicator: original.creditDebitIndicator.rawValue
        )
    }
}
