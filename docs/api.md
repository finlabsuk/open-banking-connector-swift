# Open Banking Connector API

Open Banking Connector's API is to a large extent based on the UK Open Banking API.

## UK Open Banking Coverage

### AISP

Open Banking Connector currently supports [these](https://github.com/finlabsuk/open-banking-connector/blob/master/docs/api.md#AISP-Functional-Endpoints) functional endpoints for the following UK Open Banking Read/Write API specs:
* [v3.1](https://openbanking.atlassian.net/wiki/spaces/DZ/pages/937820271/Account+and+Transaction+API+Specification+-+v3.1)
* [v3.1.1](https://openbanking.atlassian.net/wiki/spaces/DZ/pages/999622968/Account+and+Transaction+API+Specification+-+v3.1.1)
* [v3.1.2](https://openbanking.atlassian.net/wiki/spaces/DZ/pages/1077805296/Account+and+Transaction+API+Specification+-+v3.1.2)

### PISP

Open Banking Connector currently supports [these](https://github.com/finlabsuk/open-banking-connector/blob/master/docs/api.md#PISP-Functional-Endpoints) functional endpoints for the following UK Open Banking Read/Write API specs:
* [v3.1.1](https://openbanking.atlassian.net/wiki/spaces/DZ/pages/999426309/Payment+Initiation+API+Specification+-+v3.1.1)
* [v3.1.2](https://openbanking.atlassian.net/wiki/spaces/DZ/pages/1077805743/Payment+Initiation+API+Specification+-+v3.1.2)

## Configuration Endpoints

| Purpose     | Endpoint | Request Body | Response Body
| - | - | - | - |
| Create Software Statement Profiles | POST	/software-statement-profiles |	Array of SoftwareStatementProfile |	-
| Create OB Client Profile | POST	/register	|OBClientProfileConfiguration |	-

Before any communication with banks can begin, one or more software statements (identities) must be created via the Open Banking directory. A software statement and associated configuration information are captured in a Software Statement Profile and these may be posted using the endpoint above.

Once a Software Statement Profile has been created, an OB Client Profile can be created to configure conmunication with an individual bank. An OB Client Profile configures both the OAuth 2 client used with the bank as well as communication preferences specfic to that bank. Bank interpretations and implementations of Open Banking APIs differ and this is handled by *OBClientProfile* objects' support of options and overrides for OAuth2 client creation and API communication. Sponsors, please note that [Open Banking Test Kit](https://github.com/finlabsuk/open-banking-test-kit) contains example code for integrations with a growing list of UK banks.

Once at least one Software Statement Profile and one OB Client Profile have been created, the functional (AISP/PISP/CBPII) endpoints may be used.

## Functional Endpoints

The functional endpoints are based on the functional endpoints provided by the UK Open Banking Read/Write API specs for AISP and PISP. The specs define HTTP requests and the data models (types) used in both requests and responses.

One of the purposes of Open Banking Connector is to make these models simpler and version-independent for users. Therefore simpler, version-independent "Local Types" are used in place of the original spec types. These can be used with all supported spec versions. They can also be customised by modifying or replacing the [AccountTransactionLocalTypes](https://github.com/finlabsuk/open-banking-connector/tree/master/Sources/AccountTransactionLocalTypes) or  [PaymentInitiationLocalTypes](https://github.com/finlabsuk/open-banking-connector/tree/master/Sources/PaymentInitiationLocalTypes) blocks.

For each endpoint described below, the Local Types are listed and relevant code linked to so that this documentation is accurate even when Local Types have been modified. The Local Types conform to Codable and are JSON-serialised accordingly.

### AISP Functional Endpoints

### PISP Functional Endpoints

For PISP, the functional endpoints listed in this section are supported. They are based on the UK Open Banking Read/Write API specs.

### PISP Domestic Payments Endpoints

| Purpose     | Endpoint | Request Body | Response Body
| - | - | - | - |
| Create Domestic Payment Consent | POST	/pisp/domestic-payment-consents |	[OBWriteDomesticConsentLocal](https://github.com/finlabsuk/open-banking-connector/blob/master/Sources/PaymentInitiationLocalTypes/OBWriteDomesticConsentLocal.swift) |   [OBWriteDomesticConsentResponseLocal](https://github.com/finlabsuk/open-banking-connector/blob/master/Sources/PaymentInitiationLocalTypes/OBWriteDomesticConsentResponseLocal.swift) |
| Get Domestic Payment Consent |	GET	/pisp/domestic-payment-consents/{ConsentId}	|	|
| Get Domestic Payment Consent Funds Confirmation |	GET	/pisp/domestic-payment-consents/{ConsentId}/funds-confirmation |  |
| Create Domestic Payment |	POST	/pisp/domestic-payments	| none (payment info provided by consent) | [OBWriteDomesticResponseLocal](https://github.com/finlabsuk/open-banking-connector/blob/master/Sources/PaymentInitiationLocalTypes/OBWriteDomesticResponseLocal.swift) |
| Get Domestic Payment |	GET	/pisp/domestic-payments/{DomesticPaymentId}	|	 |

### [Advanced Material] Relationship Between Local and API Types for Functional Endpoints

Let us begin with some definitions:
* An *API Type* is a spec-version-specific Open Banking Read/Write API Type that comes directly from the Open Banking Read/Write API documentation.
* An *API Protocol* is a spec-version-independent interface which unifies an API Type across multiple specification versions.
* A *Local Type* is a simplified, spec-version-independent variant of an API Type which is customisable and used for Open Banking Connector Requests and Responses.

The relationships between these types and interfaces are as follows:
* API Types from multiple spec versions are conformed to an API protocol and in that conformance any differences are absorbed away
* An API protocol sits between its associated API Types and a Local Type. For incmoing HTTP requests, it allows the Local Type to map to request API Types. To supply HTTP responses, it allows the API Types to map to a Local Type.

In terms of symbol naming, Local Types are given the suffix "Local", API Protocols are given the suffix "APIProtocol" and within API Protocols API Types are given the suffix "API".

The contents of an API Protocol is determined by whether its associated API Types are used in HTTP requests, responses or both.

If its associated API Types are used in HTTP requests, an API Protocol will specify:
* a spec-version-independent initialiser which must be provided by each associated API Type via conformance 

If its associated API Types are used in HTTP responses, an API Protocol will specify:
* spec-version-independent fields which must be provided by each associated API Type via conformance 
