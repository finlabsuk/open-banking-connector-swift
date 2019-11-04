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

public protocol OBWritePaymentResponseApiProtocol: Codable {
    associatedtype OBWritePaymentResponseDataApi: OBWritePaymentResponseDataApiProtocol
    associatedtype Links: LinksApiProtocol
    associatedtype Meta: MetaApiProtocol
    var data: OBWritePaymentResponseDataApi { get }
    var linksOptional: Links? { get }
    var metaOptional: Meta? { get }
}

public protocol OBWriteDomesticResponseApiProtocol: OBWritePaymentResponseApiProtocol where OBWritePaymentResponseDataApi: OBWriteDomesticResponseDataApiProtocol { }

public protocol OBWritePaymentResponseDataApiProtocol: Codable {
    associatedtype StatusEnum: RawRepresentable, Codable where StatusEnum.RawValue == String
    /** OB: Unique identification as assigned by the ASPSP to uniquely identify the consent resource. */
    var consentId: String { get }
    var statusEnum: StatusEnum? { get }
}

public enum OBWriteDomesticResponseDataApiStatusEnum: String, Codable {
    case acceptedCreditSettlementCompleted = "AcceptedCreditSettlementCompleted"
    case acceptedSettlementCompleted = "AcceptedSettlementCompleted"
    case acceptedSettlementInProcess = "AcceptedSettlementInProcess"
    case acceptedWithoutPosting = "AcceptedWithoutPosting"
    case pending = "Pending"
    case rejected = "Rejected"
}

public protocol OBWriteDomesticResponseDataApiProtocol: OBWritePaymentResponseDataApiProtocol where StatusEnum == OBWriteDomesticResponseDataApiStatusEnum {
    associatedtype Status: RawRepresentable, Codable where Status.RawValue == String
    associatedtype OBWriteDomesticConsentResponseDataCharges: OBWriteDomesticConsentResponseDataChargesApiProtocol
    associatedtype OBWriteDomesticDataInitiation: OBWriteDomesticDataInitiationProtocol
    associatedtype OBWriteDomesticResponseDataMultiAuthorisationApi: OBWriteDomesticResponseDataMultiAuthorisationApiProtocol

    /** OB: Unique identification as assigned by the ASPSP to uniquely identify the domestic payment resource. */
    var domesticPaymentId: String { get }
    /** OB: Unique identification as assigned by the ASPSP to uniquely identify the consent resource. */
    var consentId: String { get }
    /** Date and time at which the message was created.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    var creationDateTime: Date { get }
    /** Specifies the status of the payment information group. */
    var status: Status { get }
    var statusEnum: OBWriteDomesticResponseDataApiStatusEnum? { get }
    /** Date and time at which the resource status was updated.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    var statusUpdateDateTime: Date { get }
    /** Expected execution date and time for the payment resource.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    var expectedExecutionDateTime: Date? { get }
    /** Expected settlement date and time for the payment resource.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    var expectedSettlementDateTime: Date? { get }
    var charges: [OBWriteDomesticConsentResponseDataCharges]? { get }
    var initiation: OBWriteDomesticDataInitiation { get }
    var multiAuthorisation: OBWriteDomesticResponseDataMultiAuthorisationApi? { get }
}

public enum OBWriteDomesticResponseDataMultiAuthorisationApiStatusEnum: String, Codable {
    case authorised = "Authorised"
    case awaitingFurtherAuthorisation = "AwaitingFurtherAuthorisation"
    case rejected = "Rejected"
}

public protocol OBWriteDomesticResponseDataMultiAuthorisationApiProtocol {
    associatedtype Status: RawRepresentable, Codable where Status.RawValue == String

    /** Specifies the status of the authorisation flow in code form. */
    var status: Status { get }
    var statusEnum: OBWriteDomesticResponseDataMultiAuthorisationApiStatusEnum? { get }
    /** Number of authorisations required for payment order (total required at the start of the multi authorisation journey). */
    var numberRequired: Int? { get }
    /** Number of authorisations received. */
    var numberReceived: Int? { get }
    /** Last date and time at the authorisation flow was updated.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    var lastUpdateDateTime: Date? { get }
    /** Date and time at which the requested authorisation flow must be completed.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
    var expirationDateTime: Date? { get }
}


