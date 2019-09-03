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
import NIOHTTP1
import NIOFoundationCompat
import AsyncHTTPClient
import SQLKit

func routeHandlerStatements(
    _ context: ChannelHandlerContext,
    _ request: HTTPServerRequestPart,
    method: HTTPMethod,
    path: String,
    softwareStatementProfiles: [SoftwareStatementProfile]
) {
    
    switch (method, path) {
    case (.POST, ""):
        
        let currentFuture = context.eventLoop.makeSucceededFuture(())
        
        for softwareStatementProfile in softwareStatementProfiles {
            currentFuture.flatMap({ softwareStatementProfile.insert() })
        }
        
    default: break;
    }
    
    
}
