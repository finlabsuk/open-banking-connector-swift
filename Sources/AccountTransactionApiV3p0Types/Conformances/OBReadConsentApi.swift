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

import AccountTransactionTypeRequirements
import BaseServices

public typealias OBReadConsentApi = OBReadConsent1
extension OBReadConsentApi: OBReadConsentProtocol {
    public typealias ResponseApi = OBReadConsentResponseApi
}
extension OBReadConsentResponse1: tmp2 { }
extension OBReadConsentResponse1Data: tmp1 { }

public typealias OBReadConsentDataApi = OBReadData1
extension OBReadConsentDataApi: OBReadConsentDataProtocol { }

public typealias OBRiskApi = OBRisk2
extension OBRiskApi: OBRiskApiProtocol { }

public typealias OBReadConsentResponseApi = OBReadConsentResponse1
extension OBReadConsentResponseApi: OBReadConsentResponseProtocol {
    public var riskOptional: OBRiskApi? { return risk}
}

public typealias OBReadConsentResponseDataApi = OBReadConsentResponse1Data
extension OBReadConsentResponseDataApi: OBReadConsentResponseDataProtocol { }
