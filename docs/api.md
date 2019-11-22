# Open Banking Connector API

Open Banking Connector's API to a large extent mirrors that of the Open Banking Read/Write APIs.

# Configuration Endpoints

| Purpose     | Endpoint | Request Body | Response Body
| - | - | - | - |
| Create Software Statement Profiles | POST	/software-statement-profiles |	Array of SoftwareStatementProfile |	-
| Create OB Client Profile | POST	/register	|OBClientProfileConfiguration |	-

Before any communication with banks can begin, one or more software statements (identities) must be created via the Open Banking directory. A software statement and associated configuration information is captured in a Software Statement Profile and these may be posted using the endpoint above.

Once a Software Statement Profile has been created, an OB Client Profile can be created to configure conmunicaiton with an individual bank. An OB Client Profile configures both the OAuth 2 client used with the bank as well as communication preferences specfic to that bank.

Once a Software Statement Profile and OB Client Profile have been created, the functional (AISP/PISP/CBPII) endpoints may be used.

# AISP Endpoints



# PISP Endpoints

## Domestic Payments

| Purpose     | Endpoint | Request Body | Response Body
| - | - | - | - |
| Create Domestic Payment Consent | POST	/pisp/domestic-payment-consents |	OBWriteDomesticConsentLocal |	OBWriteDomesticConsentResponseLocal |
| Get Domestic Payment Consent |	GET	/pisp/domestic-payment-consents/{ConsentId}	|	OBWriteDomesticConsentResponseLocal|
| Get Domestic Payment Consent Funds Confirmation |	GET	/pisp/domestic-payment-consents/{ConsentId}/funds-confirmation | OBWriteFundsConfirmationResponseLocal |
| Create Domestic Payment |	POST	/pisp/domestic-payments	| OBWriteDomesticLocal| OBWriteDomesticResponseLocal |
| Get Domestic Payment |	GET	/pisp/domestic-payments/{DomesticPaymentId}	|	OBWriteDomesticConsentResponseLocal |
