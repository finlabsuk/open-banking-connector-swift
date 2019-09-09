//
//  OBFixedDefinitions.swift
//
//  Created by Darima Lamazhapova on 06/05/2019.
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

/** The nickname of the account, assigned by the account owner in order to provide an additional means of identification of the account. */
public typealias Nickname = String

/** Identification of the currency in which the account is held.  Usage: Currency should only be used in case one and the same account number covers several currencies and the initiating party needs to identify which currency needs to be used for settlement on the account. */
public typealias ActiveOrHistoricCurrencyCode0 = String

/** Date and time when a transaction entry is posted to an account on the account servicer&#39;s books. Usage: Booking date is the expected booking date, unless the status is booked, in which case it is the actual booking date.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
public typealias BookingDateTime = Date

/** Unique identifier for the transaction within an servicing institution. This identifier is both unique and immutable. */
public typealias TransactionId = String

/** A code allocated to a currency by a Maintenance Agency under an international identification scheme, as described in the latest edition of the international standard ISO 4217 \&quot;Codes for the representation of currencies and funds\&quot;. */
public typealias ActiveOrHistoricCurrencyCode1 = String


/** A unique and immutable identifier used to identify the standing order resource. This identifier has no meaning to the account owner. */

public typealias StandingOrderId = String

/** Individual Definitions: EvryDay - Every day EvryWorkgDay - Every working day IntrvlWkDay - An interval specified in weeks (01 to 09), and the day within the week (01 to 07) WkInMnthDay - A monthly interval, specifying the week of the month (01 to 05) and day within the week (01 to 07) IntrvlMnthDay - An interval specified in months (between 01 to 06, 12, 24), specifying the day within the month (-5 to -1, 1 to 31) QtrDay - Quarterly (either ENGLISH, SCOTTISH, or RECEIVED) ENGLISH &#x3D; Paid on the 25th March, 24th June, 29th September and 25th December.  SCOTTISH &#x3D; Paid on the 2nd February, 15th May, 1st August and 11th November. RECEIVED &#x3D; Paid on the 20th March, 19th June, 24th September and 20th December.  Individual Patterns: EvryDay (ScheduleCode) EvryWorkgDay (ScheduleCode) IntrvlWkDay:IntervalInWeeks:DayInWeek (ScheduleCode + IntervalInWeeks + DayInWeek) WkInMnthDay:WeekInMonth:DayInWeek (ScheduleCode + WeekInMonth + DayInWeek) IntrvlMnthDay:IntervalInMonths:DayInMonth (ScheduleCode + IntervalInMonths + DayInMonth) QtrDay: + either (ENGLISH, SCOTTISH or RECEIVED) ScheduleCode + QuarterDay The regular expression for this element combines five smaller versions for each permitted pattern. To aid legibility - the components are presented individually here: EvryDay EvryWorkgDay IntrvlWkDay:0[1-9]:0[1-7] WkInMnthDay:0[1-5]:0[1-7] IntrvlMnthDay:(0[1-6]|12|24):(-0[1-5]|0[1-9]|[12][0-9]|3[01]) QtrDay:(ENGLISH|SCOTTISH|RECEIVED) Full Regular Expression: ^(EvryDay)$|^(EvryWorkgDay)$|^(IntrvlWkDay:0[1-9]:0[1-7])$|^(WkInMnthDay:0[1-5]:0[1-7])$|^(IntrvlMnthDay:(0[1-6]|12|24):(-0[1-5]|0[1-9]|[12][0-9]|3[01]))$|^(QtrDay:(ENGLISH|SCOTTISH|RECEIVED))$ */

public typealias Frequency1 = String

/** Unique reference, as assigned by the creditor, to unambiguously refer to the payment transaction. Usage: If available, the initiating party should provide this reference in the structured remittance information, to enable reconciliation by the creditor upon receipt of the amount of money. If the business context requires the use of a creditor reference or a payment remit identification, and only one identifier can be passed through the end-to-end chain, the creditor&#39;s reference or payment remittance identification should be quoted in the end-to-end transaction identification. */

public typealias Reference = String

/** The date on which the first payment for a Standing Order schedule will be made.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */

public typealias FirstPaymentDateTime = Date

/** The date on which the next payment for a Standing Order schedule will be made.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */

public typealias NextPaymentDateTime = Date

/** Date and time at which the resource was created.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
public typealias CreationDateTime = Date

/** Date and time at which the resource status was updated.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */
public typealias StatusUpdateDateTime = Date

/** The date on which the final payment for a Standing Order schedule will be made.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */

public typealias FinalPaymentDateTime = Date

/** A unique and immutable identifier used to identify the customer resource. This identifier has no meaning to the account owner. */

public typealias PartyId = String

/** Number assigned by an agent to identify its customer. */

public typealias PartyNumber = String

/** Name by which a party is known and which is usually used to identify that party. */

public typealias Name1 = String

/** Specifies a character string with a maximum length of 350 characters. */

public typealias FullLegalName = String

/** Address for electronic mail (e-mail). */

public typealias EmailAddress = String

/** Collection of information that identifies a phone number, as defined by telecom services. */

public typealias PhoneNumber0 = String

/** Collection of information that identifies a mobile phone number, as defined by telecom services. */

public typealias PhoneNumber1 = String

/** A unique and immutable identifier used to identify the beneficiary resource. This identifier has no meaning to the account owner. */

public typealias BeneficiaryId = String

/** A unique and immutable identifier used to identify the scheduled payment resource. This identifier has no meaning to the account owner. */

public typealias ScheduledPaymentId = String

/** The date on which the scheduled payment will be made.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */

public typealias ScheduledPaymentDateTime = Date

/** Unique identifier for the statement resource within an servicing institution. This identifier is both unique and immutable. */

public typealias StatementId = String

/** Unique reference for the statement. This reference may be optionally populated if available. */

public typealias StatementReference = String

/** Date and time at which the statement period starts.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */

public typealias StartDateTime = Date

/** Date and time at which the statement period ends.All dates in the JSON payloads are represented in ISO 8601 date-time format.  All date-time fields in responses must include the timezone. An example is below: 2017-04-05T10:43:07+00:00 */

public typealias EndDateTime = Date

