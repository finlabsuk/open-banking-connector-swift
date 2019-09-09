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

public protocol WithValidation {
    ///  Protocol method that checks whether Open Banking type has been successfully decoded from JSON data.
    func validateDecoding() throws
}

//extension WithValidation {
//    func validateDecoding() throws { }
//}

public protocol WithConversion {
    ///  Protocol method for conversion of Open Banking types to MnyApp types.
    ///
    ///  Types valid for conversion must conform to following protocols:
    ///    - Open Banking types to OBItem protocol
    ///    - MnyApp types to DataItem protocol
    
}

public protocol OBItem: Codable, WithValidation, WithConversion {
    
    static var typeName: String { get }

}

extension OBItem {
    
    public static var typeName: String {
        get {
            return String(describing: self)
        }
    }
    
    // Helper functions for JSON conversion (Codable) of concrete types conforming to OBItem protocol. They are needed for the implementation of Codable protocol (functions init(from: Decoder) and encode(to: Encoder)) in the conforming types.

    func encode<K: CodingKey>(
        container: inout KeyedEncodingContainer<K>,
        forKey: KeyedEncodingContainer<K>.Key) throws {
        try container.encode(self, forKey: forKey)
    }
    
    static func create<K: CodingKey>(
        container: KeyedDecodingContainer<K>,
        forKey: KeyedDecodingContainer<K>.Key) throws -> Self {
        return try container.decode(
            Self.self,
            forKey: forKey
        )
    }
    
}

