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
import PaymentInitiationTypeRequirements

// Note: Local Types are spec-version-independent but in order to support conversion to API Types
// they are often generic with respect to the target spec-version-specific API Types
// for which conversions are supported (or to allow
// their nested descendents to support such conversions).
// Notwithstanding this, no data field within a Local Type should have
// any such generic dependency. This ensures the JSON serialisation is spec-version independent.

public struct LinksLocal: Codable {

    public var _self: String
    public var first: String?
    public var prev: String?
    public var next: String?
    public var last: String?

    public init(_self: String, first: String?, prev: String?, next: String?, last: String?) {
        self._self = _self
        self.first = first
        self.prev = prev
        self.next = next
        self.last = last
    }

    public enum CodingKeys: String, CodingKey {
        case _self = "Self"
        case first = "First"
        case prev = "Prev"
        case next = "Next"
        case last = "Last"
    }
}
public extension LinksApiProtocol {
    func linksLocal() -> LinksLocal {
        LinksLocal.init(
            _self: _self,
            first: first,
            prev: prev,
            next: next,
            last: last
        )
    }
}

public struct MetaLocal: Codable {

    public var totalPages: Int?
    public var firstAvailableDateTime: String? //ISODateTime?
    public var lastAvailableDateTime: String? //ISODateTime?

    public init(
        totalPages: Int?,
        firstAvailableDateTime: String?, //ISODateTime?,
        lastAvailableDateTime: String? //ISODateTime?
    ) {
        self.totalPages = totalPages
        self.firstAvailableDateTime = firstAvailableDateTime
        self.lastAvailableDateTime = lastAvailableDateTime
    }

    public enum CodingKeys: String, CodingKey {
        case totalPages = "TotalPages"
        case firstAvailableDateTime = "FirstAvailableDateTime"
        case lastAvailableDateTime = "LastAvailableDateTime"
    }

}
public extension MetaApiProtocol {
    func metaLocal() -> MetaLocal {
        MetaLocal.init(
            totalPages: totalPages,
            firstAvailableDateTime: firstAvailableDateTime,
            lastAvailableDateTime: lastAvailableDateTime
        )
    }
}

public struct OBWriteDomesticConsentResponseLocal<
    OBWriteDomesticConsentResponseApi: OBWriteDomesticConsentResponseApiProtocol
> {
    public var data: OBWriteDomesticConsentResponseDataLocal<OBWriteDomesticConsentResponseApi.OBWritePaymentConsentResponseData>
    public var risk: OBRiskLocal<OBWriteDomesticConsentResponseApi.OBRisk>
    public var links: LinksLocal?
    public var meta: MetaLocal?
    
    public init(
        data: OBWriteDomesticConsentResponseDataLocal<OBWriteDomesticConsentResponseApi.OBWritePaymentConsentResponseData>,
        risk: OBRiskLocal<OBWriteDomesticConsentResponseApi.OBRisk>,
        links: LinksLocal?,
        meta: MetaLocal?
    ) {
        self.data = data
        self.risk = risk
        self.links = links
        self.meta = meta
    }

    public enum CodingKeys: String, CodingKey {
        case data = "Data"
        case risk = "Risk"
        case links = "Links"
        case meta = "Meta"
    }
    
}
public extension OBWriteDomesticConsentResponseApiProtocol {
    func obWriteDomesticConsentResponseLocal() throws -> OBWriteDomesticConsentResponseLocal<Self> {
        try OBWriteDomesticConsentResponseLocal.init(
            data: data.obWriteDomesticConsentResponseDataLocal(),
            risk: risk.obRiskLocal(),
            links: linksOptional?.linksLocal(),
            meta: metaOptional?.metaLocal()
        )
    }
}


public struct OBWriteDomesticConsentResponseDataLocal<
    OBWriteDomesticConsentResponseDataApi: OBWriteDomesticConsentResponseDataApiProtocol>: Codable {

    /** OB: Unique identification as assigned by the ASPSP to uniquely identify the consent resource. */
    public var consentId: String
    /** Date and time at which the resource was created.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var creationDateTime: Date
    /** Specifies the status of consent resource in code form. */
    public var status: OBWritePaymentConsentResponseDataApiStatusEnum
    /** Date and time at which the resource status was updated.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var statusUpdateDateTime: Date
    /** Specified cut-off date and time for the payment consent.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var cutOffDateTime: Date?
    /** Expected execution date and time for the payment resource.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var expectedExecutionDateTime: Date?
    /** Expected settlement date and time for the payment resource.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    public var expectedSettlementDateTime: Date?
    public var charges: [OBWriteDomesticConsentResponseDataChargesLocal<OBWriteDomesticConsentResponseDataApi.OBWriteDomesticConsentResponseDataCharges>]?
    public var initiation: OBWriteDomesticDataInitiationLocal<OBWriteDomesticConsentResponseDataApi.OBWriteDomesticDataInitiation>
    public var authorisation: OBWriteDomesticConsentDataAuthorisationLocal<OBWriteDomesticConsentResponseDataApi.OBWriteDomesticConsentDataAuthorisation>?
    public var sCASupportData: OBWriteDomesticConsentDataSCASupportDataLocal<OBWriteDomesticConsentResponseDataApi.OBWriteDomesticConsentDataSCASupportData>?
    
    public init(
        consentId: String,
        creationDateTime: Date,
        status: OBWritePaymentConsentResponseDataApiStatusEnum,
        statusUpdateDateTime: Date,
        cutOffDateTime: Date?,
        expectedExecutionDateTime: Date?,
        expectedSettlementDateTime: Date?,
        charges: [OBWriteDomesticConsentResponseDataChargesLocal<OBWriteDomesticConsentResponseDataApi.OBWriteDomesticConsentResponseDataCharges>]?,
        initiation: OBWriteDomesticDataInitiationLocal<OBWriteDomesticConsentResponseDataApi.OBWriteDomesticDataInitiation>,
        authorisation: OBWriteDomesticConsentDataAuthorisationLocal<OBWriteDomesticConsentResponseDataApi.OBWriteDomesticConsentDataAuthorisation>?,
        sCASupportData: OBWriteDomesticConsentDataSCASupportDataLocal<OBWriteDomesticConsentResponseDataApi.OBWriteDomesticConsentDataSCASupportData>?
    ) {
        self.consentId = consentId
        self.creationDateTime = creationDateTime
        self.status = status
        self.statusUpdateDateTime = statusUpdateDateTime
        self.cutOffDateTime = cutOffDateTime
        self.expectedExecutionDateTime = expectedExecutionDateTime
        self.expectedSettlementDateTime = expectedSettlementDateTime
        self.charges = charges
        self.initiation = initiation
        self.authorisation = authorisation
        self.sCASupportData = sCASupportData
    }

    public enum CodingKeys: String, CodingKey {
        case consentId = "ConsentId"
        case creationDateTime = "CreationDateTime"
        case status = "Status"
        case statusUpdateDateTime = "StatusUpdateDateTime"
        case cutOffDateTime = "CutOffDateTime"
        case expectedExecutionDateTime = "ExpectedExecutionDateTime"
        case expectedSettlementDateTime = "ExpectedSettlementDateTime"
        case charges = "Charges"
        case initiation = "Initiation"
        case authorisation = "Authorisation"
        case sCASupportData = "SCASupportData"
    }

}
public extension OBWriteDomesticConsentResponseDataApiProtocol {
    func obWriteDomesticConsentResponseDataLocal() throws -> OBWriteDomesticConsentResponseDataLocal<Self> {
        guard
            let status = statusEnum
            else {
                throw "Invalid enum value received from OB API"
        }
        return try OBWriteDomesticConsentResponseDataLocal.init(
            consentId: consentId,
            creationDateTime: creationDateTime,
            status: status,
            statusUpdateDateTime: statusUpdateDateTime,
            cutOffDateTime: cutOffDateTime,
            expectedExecutionDateTime: expectedExecutionDateTime,
            expectedSettlementDateTime: expectedSettlementDateTime,
            charges: charges?.map { try $0.obWriteDomesticConsentResponseDataChargesLocal() },
            initiation: initiation.obWriteDomesticDataInitiationLocal(),
            authorisation: authorisation?.obWriteDomesticConsentDataAuthorisationLocal(),
            sCASupportData: nil
//            sCASupportData: sCASupportData?.obWriteDomesticConsentDataSCASupportDataLocal()
        )
    }
}

/** Set of elements used to provide details of a charge for the payment initiation. */
public struct OBWriteDomesticConsentResponseDataChargesLocal<OBWriteDomesticConsentResponseDataChargesApi: OBWriteDomesticConsentResponseDataChargesApiProtocol>: Codable {

    public var chargeBearer: OBChargeBearerTypeCodeEnum
    public var type: String //OBExternalPaymentChargeTypeCode
    public var amount: OBActiveOrHistoricCurrencyAndAmountLocal

    public enum CodingKeys: String, CodingKey {
        case chargeBearer = "ChargeBearer"
        case type = "Type"
        case amount = "Amount"
    }

}
public extension OBWriteDomesticConsentResponseDataChargesApiProtocol {
    func obWriteDomesticConsentResponseDataChargesLocal() throws -> OBWriteDomesticConsentResponseDataChargesLocal<Self> {
        guard
            let chargeBearer = chargeBearerEnum
            else {
                throw "Invalid enum value received from OB API"
        }
        return OBWriteDomesticConsentResponseDataChargesLocal<Self>.init(
            chargeBearer:
            chargeBearer,
            type: type,
            amount: amount.obActiveOrHistoricCurrencyAndAmountLocal()
        )
    }
}

/** Amount of money associated with the charge type. */
public struct OBActiveOrHistoricCurrencyAndAmountLocal: Codable {

    public var amount: String //OBActiveCurrencyAndAmountSimpleType
    public var currency: String //ActiveOrHistoricCurrencyCode

    public init(
        amount: String, //OBActiveCurrencyAndAmountSimpleType,
        currency: String //ActiveOrHistoricCurrencyCode
    ) {
        self.amount = amount
        self.currency = currency
    }

    public enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case currency = "Currency"
    }


}
public extension OBActiveOrHistoricCurrencyAndAmountApiProtocol {
    func obActiveOrHistoricCurrencyAndAmountLocal() -> OBActiveOrHistoricCurrencyAndAmountLocal {
        OBActiveOrHistoricCurrencyAndAmountLocal.init(
            amount: amount,
            currency: currency
        )
    }
}


