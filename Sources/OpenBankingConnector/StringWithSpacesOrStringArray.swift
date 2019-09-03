// ********************************************************************************
//
// This source file is part of the Open Banking Connector project.
//
// Copyright (C) 2019 Finnovation Labs and the Open Banking Connector project authors.
//
// Licensed under Apache License v2.0. See LICENSE.txt for licence information.
// SPDX-License-Identifier: Apache-2.0
//
// ********************************************************************************

import Foundation

enum StringWithSpacesOrStringArray: Decodable, Equatable {
    case stringArray([String])
     
    init(from decoder: Decoder) throws {
        
        let value = try decoder.singleValueContainer()
        
        if let stringValue = try? value.decode(String.self) {
            self = .stringArray(stringValue.components(separatedBy: " "))
        } else {
            let stringArrayValue = try value.decode([String].self)
            self = .stringArray(stringArrayValue)
        }

    }
    
    func isSuperset(of subset: Set<String>) -> Bool {
        if case .stringArray(let array) = self {
            return Set(array).isSuperset(of: subset)
        } else {
            fatalError()
        }
        
    }
    
}
