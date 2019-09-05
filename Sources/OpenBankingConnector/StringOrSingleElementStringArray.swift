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

enum StringOrSingleElementStringArray: Codable {

    case string(String)
    case stringArray([String])
       
    init(from decoder: Decoder) throws {

        let value = try decoder.singleValueContainer()
        if
            let stringValue = try? value.decode(String.self)
        {
            self = .string(stringValue)
        } else if
            let stringArrayValue = try? value.decode([String].self),
            stringArrayValue.count == 1
        {
            self = .stringArray(stringArrayValue)
        } else
        {
            throw "Cannot decode into either case."
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let aValue):
            try container.encode(aValue)
        case .stringArray(let aValue):
            try container.encode(aValue)
        }
    }
    
    func asString() -> String {
        switch self {
        case .string(let value):
            return value
        case .stringArray(let value):
            return value[0]
        }
    }

}
