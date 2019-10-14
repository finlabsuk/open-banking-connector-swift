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
import BaseServices

public protocol OBWriteDomesticConsentResponseApiProtocol: Codable {
    associatedtype OBWriteDomesticConsentResponseData: OBWriteDomesticConsentResponseDataApiProtocol
    associatedtype OBRisk: OBRiskApiProtocol
    associatedtype Links: LinksApiProtocol
    associatedtype Meta: MetaApiProtocol
    var data: OBWriteDomesticConsentResponseData { get }
    var risk: OBRisk { get }
    var linksOptional: Links? { get }
    var metaOptional: Meta? { get }
}

public protocol LinksApiProtocol: Codable {
    var _self: String { get }
    var first: String? { get }
    var prev: String? { get }
    var next: String? { get }
    var last: String? { get }
}

public protocol MetaApiProtocol: Codable {
    var totalPages: Int? { get }
    var firstAvailableDateTime: String?  { get } //ISODateTime?
    var lastAvailableDateTime: String?  { get } //ISODateTime?
}

public protocol OBWriteDomesticConsentResponseDataApiProtocol {
    associatedtype OBWriteDomesticConsentResponseDataCharges: OBWriteDomesticConsentResponseDataChargesApiProtocol
    associatedtype OBWriteDomesticDataInitiation: OBWriteDomesticDataInitiationProtocol
    associatedtype OBWriteDomesticConsentDataAuthorisation: OBWriteDomesticConsentDataAuthorisationProtocol
    associatedtype OBWriteDomesticConsentDataSCASupportData
    associatedtype Status

    /** OB: Unique identification as assigned by the ASPSP to uniquely identify the consent resource. */
    var consentId: String { get }
    /** Date and time at which the resource was created.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    var creationDateTime: Date { get }
    /** Specifies the status of consent resource in code form. */
    var status: Status { get }
    /** Date and time at which the resource status was updated.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    var statusUpdateDateTime: Date { get }
    /** Specified cut-off date and time for the payment consent.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    var cutOffDateTime: Date? { get }
    /** Expected execution date and time for the payment resource.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    var expectedExecutionDateTime: Date? { get }
    /** Expected settlement date and time for the payment resource.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    var expectedSettlementDateTime: Date? { get }
    var charges: [OBWriteDomesticConsentResponseDataCharges]? { get }
    var initiation: OBWriteDomesticDataInitiation { get }
    var authorisation: OBWriteDomesticConsentDataAuthorisation? { get }
    var sCASupportData: OBWriteDomesticConsentDataSCASupportData? { get }
}

public protocol OBWriteDomesticConsentResponseDataChargesApiProtocol: Codable {
    associatedtype OBChargeBearerTypeCode: RawRepresentable, Codable where OBChargeBearerTypeCode.RawValue == String
    associatedtype OBActiveOrHistoricCurrencyAndAmountType: OBActiveOrHistoricCurrencyAndAmountApiProtocol
    var chargeBearer: OBChargeBearerTypeCode { get }
    var type: String { get } //OBExternalPaymentChargeType1Code
    var amount: OBActiveOrHistoricCurrencyAndAmountType { get }
}

public protocol OBActiveOrHistoricCurrencyAndAmountApiProtocol: Codable {
    var amount: String { get } //OBActiveCurrencyAndAmountSimpleType
    var currency: String { get } //ActiveOrHistoricCurrencyCode
}
