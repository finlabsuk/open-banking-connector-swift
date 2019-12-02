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
import SwiftJWT

func genJws<ClaimsType: Claims>(
    softwareStatementId: String,
    claims: ClaimsType,
    on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!,
    useAuthHeader: Bool = true
) -> EventLoopFuture<String> {
    return SoftwareStatementProfile.load(id: softwareStatementId, on: eventLoop)
        .flatMapThrowing({ softwareStatement in
            let header: Header
            if useAuthHeader {
                header = Header(
                    // additional to default alg and typ = "JWT"
                    kid: softwareStatement.obSigningKID
                )
            } else {
//                header = Header(
//                    // additional to default alg
//                    typ: "JOSE",
//                    kid: softwareStatement.obSigningKID,
//                    crit: ["b64", "http://openbanking.org.uk/iat", "http://openbanking.org.uk/iss", "http://openbanking.org.uk/tan"],
//                    b64: false,
//                    obIat: Date(),
//                    obIss: "\(softwareStatement.softwareStatementPayload.org_id)/\(softwareStatement.softwareStatementPayload.software_id)",
//                    obTan: "openbanking.org.uk"
//                )
                header = Header(
                    // additional to default alg
                    typ: "JOSE",
                    kid: softwareStatement.obSigningKID
                )
            }
            var newJwt = JWT(header: header, claims: claims)
            let jwtSigner = JWTSigner.ps256(privateKey: Data(softwareStatement.obSigningKey.utf8))
            let signedJWT = try! newJwt.sign(using: jwtSigner)
            return signedJWT
        })
}
