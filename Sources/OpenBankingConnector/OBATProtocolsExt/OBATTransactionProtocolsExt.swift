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

import OBATProtocols
import LocalProtocols

extension OBATReadTransactionProtocol  {
    func obcTransaction<T: TransactionProtocol>() -> [T] {
        let transactionArray = self.data.transaction ?? [OBAIReadResourceDataType.OBAIResourceType]()
        return transactionArray.map { T($0) }
    }
    static func decode(decoder: JSONDecoder, data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}
