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

import PaymentInitiationTypeRequirements

public typealias OBWriteDomesticApi = OBWriteDomestic2
public typealias OBWriteDomesticDataApi = OBWriteDomestic2Data

extension OBWriteDomesticApi: OBWriteDomesticApiProtocol {
    public typealias ResponseApi = OBWriteDomesticResponseApi
}
extension OBWriteDomesticDataApi: OBWriteDomesticDataApiProtocol { }

