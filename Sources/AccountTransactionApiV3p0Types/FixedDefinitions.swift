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

/** All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
public typealias ISODateTime = String

/** Further details of the transaction.  This is the transaction narrative, which is unstructured text. */
public typealias TransactionInformation = String
