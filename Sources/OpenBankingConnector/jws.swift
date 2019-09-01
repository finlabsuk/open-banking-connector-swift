// ********************************************************************************
//
// This source file is part of the Open Banking Connector open source project
//
// Copyright (C) 2019 Finnovation Labs and the Open Banking Connector project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
// ********************************************************************************

import Foundation
import NIO
import SwiftJWT

func genJws<ClaimsType: Claims>(
    softwareStatementId: String,
    claims: ClaimsType,
    on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
) -> EventLoopFuture<String> {
    return SoftwareStatementProfile.load(id: softwareStatementId, on: eventLoop)
        .flatMapThrowing({ softwareStatement in
            let header = Header(
                // additional to default alg and typ = "JWT"
                kid: softwareStatement.obSigningKID
            )
            
            var newJwt = JWT(header: header, claims: claims)
            
            let jwtSigner = JWTSigner.ps256(privateKey: Data(softwareStatement.obSigningKey.utf8))
            
            let signedJWT = try! newJwt.sign(using: jwtSigner)
            
            
            return signedJWT
        })
}
