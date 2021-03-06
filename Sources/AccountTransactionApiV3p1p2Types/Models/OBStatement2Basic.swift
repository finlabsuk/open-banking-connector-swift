//
// OBStatement2Basic.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** Provides further details on a statement resource. */

public struct OBStatement2Basic: Codable {

    public var accountId: AccountId
    public var statementId: StatementId?
    public var statementReference: StatementReference?
    public var type: OBExternalStatementType1Code
    public var startDateTime: StartDateTime
    public var endDateTime: EndDateTime
    public var creationDateTime: CreationDateTime
    public var statementDescription: [String]?
    public var statementBenefit: [OBStatement2StatementBenefit]?
    public var statementFee: [OBStatement2StatementFee]?
    public var statementInterest: [OBStatement2StatementInterest]?
    public var statementDateTime: [OBStatement2StatementDateTime]?
    public var statementRate: [OBStatement2StatementRate]?
    public var statementValue: [OBStatement2StatementValue]?

    public init(accountId: AccountId, statementId: StatementId?, statementReference: StatementReference?, type: OBExternalStatementType1Code, startDateTime: StartDateTime, endDateTime: EndDateTime, creationDateTime: CreationDateTime, statementDescription: [String]?, statementBenefit: [OBStatement2StatementBenefit]?, statementFee: [OBStatement2StatementFee]?, statementInterest: [OBStatement2StatementInterest]?, statementDateTime: [OBStatement2StatementDateTime]?, statementRate: [OBStatement2StatementRate]?, statementValue: [OBStatement2StatementValue]?) {
        self.accountId = accountId
        self.statementId = statementId
        self.statementReference = statementReference
        self.type = type
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.creationDateTime = creationDateTime
        self.statementDescription = statementDescription
        self.statementBenefit = statementBenefit
        self.statementFee = statementFee
        self.statementInterest = statementInterest
        self.statementDateTime = statementDateTime
        self.statementRate = statementRate
        self.statementValue = statementValue
    }

    public enum CodingKeys: String, CodingKey { 
        case accountId = "AccountId"
        case statementId = "StatementId"
        case statementReference = "StatementReference"
        case type = "Type"
        case startDateTime = "StartDateTime"
        case endDateTime = "EndDateTime"
        case creationDateTime = "CreationDateTime"
        case statementDescription = "StatementDescription"
        case statementBenefit = "StatementBenefit"
        case statementFee = "StatementFee"
        case statementInterest = "StatementInterest"
        case statementDateTime = "StatementDateTime"
        case statementRate = "StatementRate"
        case statementValue = "StatementValue"
    }


}

