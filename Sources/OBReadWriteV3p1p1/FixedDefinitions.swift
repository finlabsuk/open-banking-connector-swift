//
//  OBFixedDefinitions.swift
//
//  Created by Darima Lamazhapova on 04/01/2019.
//

import Foundation

/** A unique and immutable identifier used to identify the account resource. This identifier has no meaning to the account owner. */
public typealias AccountId = String

/** A number of monetary units specified in an active currency where the unit of currency is explicit and compliant with ISO 4217. */
public typealias OBActiveCurrencyAndAmountSimpleType = String

/** Further details of the transaction.  This is the transaction narrative, which is unstructured text. */
public typealias TransactionInformation = String

/** Name of the identification scheme, in a coded form as published in an external list. */
public typealias OBExternalFinancialInstitutionIdentification4Code = String

/** Name of the identification scheme, in a coded form as published in an external list. */
public typealias OBExternalAccountIdentification4Code = String

/** Benefit type, in a coded form. */
public typealias OBExternalStatementBenefitType1Code = String

/** Fee type, in a coded form. */
public typealias OBExternalStatementFeeType1Code = String

/** Interest amount type, in a coded form. */
public typealias OBExternalStatementInterestType1Code = String

/** Date time type, in a coded form. */
public typealias OBExternalStatementDateTimeType1Code = String

/** Statement rate type, in a coded form. */
public typealias OBExternalStatementRateType1Code = String

/** Statement value type, in a coded form. */
public typealias OBExternalStatementValueType1Code = String

/** Amount type, in a coded form. */
public typealias OBExternalStatementAmountType1Code = String

/** All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
public typealias ISODateTime = String
