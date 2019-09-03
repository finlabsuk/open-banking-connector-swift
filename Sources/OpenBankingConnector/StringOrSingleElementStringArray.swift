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

enum StringOrSingleElementStringArray: Decodable, Equatable {

    case string(String)
       
    init(from decoder: Decoder) throws {
        
        let value = try decoder.singleValueContainer()
        
        if let stringValue = try? value.decode(String.self) {
            self = .string(stringValue)
        } else {
            let stringArrayValue = try value.decode([String].self)
            if stringArrayValue.count != 1 {
                fatalError()
            }
            self = .string(stringArrayValue[0])
        }

    }

}
