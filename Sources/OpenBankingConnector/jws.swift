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

public struct HeaderOB: HeaderProtocol {
    
    public enum CodingKeys: String, CodingKey {
        case typ = "typ"
        case alg = "alg"
        case kid = "kid"
        case crit = "crit"
        case b64 = "b64"
        case obIat = "http://openbanking.org.uk/iat"
        case obIss = "http://openbanking.org.uk/iss"
        case obTan = "http://openbanking.org.uk/tan"
    }

    public var typ: String
    public var alg: String? // set by Swift-JWT
    public var kid: String
    public var crit: [String]
    public var b64: Bool
    public var obIat: Date
    public var obIss: String
    public var obTan: String
    
    public init(
        typ: String = "JWT",
        kid: String,
        crit: [String],
        b64: Bool,
        obIat: Date,
        obIss: String,
        obTan: String
    ) {
        self.typ = typ
        self.kid = kid
        self.crit = crit
        self.b64 = b64
        self.obIat = obIat
        self.obIss = obIss
        self.obTan = obTan
    }
    
    func encode() throws -> String {
        let data = try hcm.jsonEncoderDateFormatSecondsSince1970.encode(self)
        return JWTEncoder.base64urlEncodedString(data: data)
    }
    
}

func genJws<ClaimsType: Claims>(
    softwareStatementId: String,
    claims: ClaimsType,
    on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!,
    useAuthHeader: Bool = true
) -> EventLoopFuture<String> {
    return SoftwareStatementProfile.load(id: softwareStatementId, on: eventLoop)
        .flatMapThrowing({ softwareStatement in
            if useAuthHeader {
                let header = Header(
                    // additional to default alg and typ = "JWT"
                    kid: softwareStatement.obSigningKID
                )
                var newJwt = JWT(header: header, claims: claims)
                let jwtSigner = JWTSigner.ps256(privateKey: Data(softwareStatement.obSigningKey.utf8))
                return try! newJwt.sign(using: jwtSigner)
            } else {
                let header = HeaderOB(
                    // additional to default alg
                    typ: "JOSE",
                    kid: softwareStatement.obSigningKID,
                    crit: ["b64", "http://openbanking.org.uk/iat", "http://openbanking.org.uk/iss", "http://openbanking.org.uk/tan"],
                    b64: false,
                    obIat: Date(),
                    obIss: "\(softwareStatement.softwareStatementPayload.org_id)/\(softwareStatement.softwareStatementPayload.software_id)",
                    obTan: "openbanking.org.uk"
                )
                var newJwt = JWT(header: header, claims: claims)
                let jwtSigner = JWTSigner.ps256(privateKey: Data(softwareStatement.obSigningKey.utf8))
                return try! newJwt.sign(using: jwtSigner)
            }
        })
}
