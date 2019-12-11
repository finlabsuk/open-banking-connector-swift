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
import PaymentInitiationTypeRequirements
import PaymentInitiationApiV3p1p1Types
import PaymentInitiationApiV3p1p2Types
import PaymentInitiationLocalTypes

public enum PaymentInitiationApiVersion: String, Codable {
    case V3p1p1
    case V3p1p2
}

public protocol PaymentInitiationProcesingBlock {
    associatedtype InputType
    associatedtype OutputType
    associatedtype DynamicTypeVariety
    static func executeIntermediate<T: PaymentInitiationRequestObjectApiTypesProtocol>(
        apiTypesType: T.Type,
        dynamicTypeVariety: DynamicTypeVariety,
        input: InputType
    ) -> OutputType
}

extension PaymentInitiationProcesingBlock {
    public static func execute(
        _ apiVersion: PaymentInitiationApiVersion,
        _ dynamicTypeVariety: DynamicTypeVariety,
        _ input: InputType
    ) -> OutputType {
        switch apiVersion {
        case .V3p1p1:
            return executeIntermediate(apiTypesType: PaymentInitiationRequestObjectApiV3p1p1Types.self, dynamicTypeVariety: dynamicTypeVariety, input: input)
        case .V3p1p2:
            return executeIntermediate(apiTypesType: PaymentInitiationRequestObjectApiV3p1p2Types.self, dynamicTypeVariety: dynamicTypeVariety, input: input)
        }
    }
}

public enum PaymentInitiationPaymentVariety: CaseIterable {
    case domesticPayment
    public func urlRegexPostPayment() -> String {
        switch self {
        case .domesticPayment:
            // POST /domestic-payments
            return #"^/domestic-payments$"#
        }
    }
    public func urlRegexPostPaymentConsent() -> String {
        switch self {
        case .domesticPayment:
            // POST /domestic-payment-consents
            return #"^/domestic-payment-consents$"#
        }
    }
}

public protocol PaymentInitiationProcesingBlock_OBWritePaymentConsentLocal: PaymentInitiationProcesingBlock where DynamicTypeVariety == PaymentInitiationPaymentVariety {
    static func executeInner<OBWritePaymentConsentLocal: OBWritePaymentConsentLocalProtocol>(
        dynamicType: OBWritePaymentConsentLocal.Type,
        input: InputType
    ) -> OutputType
}

extension PaymentInitiationProcesingBlock_OBWritePaymentConsentLocal {
    public static func executeIntermediate<T: PaymentInitiationRequestObjectApiTypesProtocol>(
        apiTypesType: T.Type,
        dynamicTypeVariety: PaymentInitiationPaymentVariety,
        input: InputType
    ) -> OutputType {
        switch dynamicTypeVariety {
        case .domesticPayment:
            return Self.executeInner(
                dynamicType: OBWriteDomesticConsentLocal<T.OBWriteDomesticConsentApiType, T.OBWriteDomesticApiType>.self,
                input: input
            )
        }
    }
}
