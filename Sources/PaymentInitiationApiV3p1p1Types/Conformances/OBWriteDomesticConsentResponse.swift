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

public typealias OBWriteDomesticConsentResponseType = OBWriteDomesticConsentResponse2
public typealias OBActiveOrHistoricCurrencyAndAmountType = OBCharge2Amount
public typealias OBChargeBearerTypeCode = OBChargeBearerType1Code

extension OBWriteDomesticConsentResponseType: OBWriteDomesticConsentResponseApiProtocol {
    public var linksOptional: Links? { return links }
    public var metaOptional: Meta? { return meta }
    public typealias OBWriteDomesticConsentResponseData = OBWriteDataDomesticConsentResponse2
    public typealias OBRisk = OBRisk1
}
extension Links: LinksApiProtocol { }
extension Meta: MetaApiProtocol { }

public typealias OBWriteDomesticConsentResponseDataType = OBWriteDataDomesticConsentResponse2
public typealias OBWriteDomesticConsentResponseDataCharges = OBCharge2
extension OBWriteDomesticConsentResponseDataType: OBWriteDomesticConsentResponseDataApiProtocol {
    public var sCASupportData: Void? { return nil }
    public typealias OBWriteDomesticDataInitiation = OBDomestic2
    public typealias OBWriteDomesticConsentDataAuthorisation = OBAuthorisation1
    public typealias OBWriteDomesticConsentDataSCASupportData = Void
    public typealias Status = OBExternalConsentStatus1Code
}
extension OBWriteDomesticConsentResponseDataCharges: OBWriteDomesticConsentResponseDataChargesApiProtocol { }
extension OBActiveOrHistoricCurrencyAndAmountType: OBActiveOrHistoricCurrencyAndAmountApiProtocol { }

