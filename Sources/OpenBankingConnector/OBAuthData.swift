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

struct OBAuthData {

    let code: String
    let id_token: String
    let state: String

    init(input: String) {
        let componentDict = tmpDecode(input: input)
        self.code = componentDict["code"]!
        self.id_token = componentDict["id_token"]!
        self.state = componentDict["state"]!
    }
    
}
