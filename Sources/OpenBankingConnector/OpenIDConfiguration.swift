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

struct OpenIDConfiguration: Codable {
    let issuer: String
    let response_types_supported: [String]
    let scopes_supported: [String]
    let response_modes_supported: [String]
    let token_endpoint: String
    let authorization_endpoint: String
    var registration_endpoint: String
    
    static func httpGet(issuerURL: String, overrides: OpenIDConfigurationOverrides?) -> EventLoopFuture<OpenIDConfiguration> {
        let request = hcm.getRequestStd(
            url: URL(string: issuerURL + "/.well-known/openid-configuration")!
        )
        return hcm.clientNoMTLS
            .execute(request: request)
            .flatMapThrowing({ response -> OpenIDConfiguration in
                if response.status == .ok,
                    var body = response.body {
                    let data = body.readData(length: body.readableBytes)!
                    var config = try decoder.decode(
                        OpenIDConfiguration.self,
                        from: data)
                    config.applyOverrides(overrides: overrides)
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
    
}

