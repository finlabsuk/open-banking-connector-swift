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
import AccountTransactionTypes
import BaseServices

// MARK:- Account access consent protocols
extension AT_PI_CF_PostRequestApiProtocol {
    func httpPost(
        obClient: OBClientProfile,
        url: URL,
        authHeader: String,
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup.currentEventLoop!
    ) -> EventLoopFuture<ResponseApi> {
        
        return eventLoop.makeSucceededFuture(())
            
            .flatMap({
                hcm.httpPost(
                    url: url,
                    headers: [
                        "x-fapi-financial-id": obClient.xFapiFinancialId,
                        "Authorization": authHeader
                    ],
                    body: try! hcm.jsonEncoderDateFormatISO8601WithMilliSeconds.encode(self),
                    httpClientMTLSConfiguration: obClient.httpClientMTLSConfiguration
                )
            })
            
            .flatMapError({error in
                print(error)
                fatalError()
            })
        
    }
}

