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

struct DateExcludedFromEquatable: Codable, Equatable {
    let date: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        date = try container.decode(Date.self)
    }
    init(date: Date) {
        self.date = date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(date)
    }
    
    static func == (lhs: DateExcludedFromEquatable, rhs: DateExcludedFromEquatable) -> Bool {
        return true
    }
    
}
