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

struct OpenIDConfigurationOverrides: Codable {
    var registration_endpoint: String?
    mutating func update(with newOverrides: OpenIDConfigurationOverrides) {
        if let newValue = newOverrides.registration_endpoint {
            registration_endpoint = newValue
        }
    }
}

struct OpenIDConfiguration: Codable {
    let issuer: String
    let response_types_supported: [String]
    let scopes_supported: [String]
    let response_modes_supported: [String]?
    let token_endpoint: String
    let authorization_endpoint: String
    var registration_endpoint: String! // allows for missing value to be corrected via overrides
    
    static func httpGet(issuerURL: String, overrides: OpenIDConfigurationOverrides?) -> EventLoopFuture<OpenIDConfiguration> {
        let url = URL(string: issuerURL + "/.well-known/openid-configuration")!
        print("\(url)")
        let request = hcm.getRequestStd(
            url: url
        )
        return hcm.clientNoMTLS
            .execute(request: request)
            .flatMapThrowing({ response -> OpenIDConfiguration in
                if response.status == .ok,
                    var body = response.body {
                    let data = body.readData(length: body.readableBytes)!
                    var config = try hcm.jsonDecoderDateFormatISO8601WithMilliSeconds.decode(
                        OpenIDConfiguration.self,
                        from: data)
                    config.applyOverrides(overrides: overrides)
                    try config.checkValidity()
                    return config
                } else {
                    throw "Bad response..."
                }
            })
            .flatMapError({error in
                print(error)
                fatalError()
            })
    }
    
    mutating func applyOverrides(overrides: OpenIDConfigurationOverrides?) {
        if let overrides = overrides {
            if let newValue = overrides.registration_endpoint {
                registration_endpoint = newValue
            }
        }
    }
    
    func checkValidity() throws {
        
        guard registration_endpoint != nil else {
            throw "No registration endpoint provided by Open ID config or overrides"
        }
    }

    
}

