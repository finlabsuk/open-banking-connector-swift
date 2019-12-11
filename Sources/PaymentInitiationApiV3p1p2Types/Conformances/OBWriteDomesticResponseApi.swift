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

public typealias OBWriteDomesticResponseApi = OBWriteDomesticResponse3
public typealias OBWriteDomesticResponseDataApi = OBWriteDomesticResponse3Data
public typealias OBWriteDomesticResponseDataMultiAuthorisationApi = OBWriteDomesticResponse3DataMultiAuthorisation

extension OBWriteDomesticResponseApi: OBWriteDomesticResponseApiProtocol {
    public var linksOptional: Links? { return links }
    public var metaOptional: Meta? { return meta }
}
extension OBWriteDomesticResponseDataApi: OBWriteDomesticResponseDataApiProtocol {
    public var statusEnum: OBWritePaymentResponseDataApiStatusEnum? {
        return OBWritePaymentResponseDataApiStatusEnum(rawValue: status.rawValue)
    }
}
extension OBWriteDomesticResponseDataMultiAuthorisationApi: OBWriteDomesticResponseDataMultiAuthorisationApiProtocol {
    public var statusEnum: OBWriteDomesticResponseDataMultiAuthorisationApiStatusEnum? {
        return OBWriteDomesticResponseDataMultiAuthorisationApiStatusEnum(rawValue: status.rawValue)
    }
}

