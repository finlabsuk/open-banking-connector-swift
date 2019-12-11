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

public typealias OBWriteDomesticConsentResponseApi = OBWriteDomesticConsentResponse3
public typealias OBWriteDomesticConsentResponseDataType = OBWriteDomesticConsentResponse3Data
public typealias OBWriteDomesticConsentResponseDataCharges = OBWriteDomesticConsentResponse3DataCharges
public typealias OBActiveOrHistoricCurrencyAndAmountType = OBActiveOrHistoricCurrencyAndAmount
public typealias OBChargeBearerTypeCode = OBChargeBearerType1Code

extension OBWriteDomesticConsentResponseApi: OBWriteDomesticConsentResponseApiProtocol {
    public var linksOptional: Links? { return links }
    public var metaOptional: Meta? { return meta }
}
extension Links: LinksApiProtocol { }
extension Meta: MetaApiProtocol { }
extension OBWriteDomesticConsentResponseDataType: OBWriteDomesticConsentResponseDataApiProtocol {
    public var statusEnum: OBWritePaymentConsentResponseDataApiStatusEnum? {
        return OBWritePaymentConsentResponseDataApiStatusEnum(rawValue: status.rawValue)
    }
}
extension OBWriteDomesticConsentResponseDataCharges: OBWriteDomesticConsentResponseDataChargesApiProtocol {
    public var chargeBearerEnum: OBChargeBearerTypeCodeEnum? {
        return OBChargeBearerTypeCodeEnum(rawValue: chargeBearer.rawValue)
    }
}
extension OBActiveOrHistoricCurrencyAndAmount: OBActiveOrHistoricCurrencyAndAmountApiProtocol { }

