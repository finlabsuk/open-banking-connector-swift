![Alt text](./docs/OBC_Banner.png)

*[NB: this software is under active and rapid devleopment. Please contact Mark (main author) regarding feature status or to see a demo.]*
# Overview

Open Banking Connector is an interface layer that handles connections to UK Open Banking APIs. It is desiged for use as:
* an interface layer for consumption of Open Banking APIs (e.g. by FinTechs who do not want to pass data through an agent)
* an interface layer for testing functionality and live status of Open Banking APIs (e.g. by banks or FinTechs in automated regression tests) (NB: Companion product [Open Banking Test Kit](https://github.com/finlabsuk/open-banking-test-kit), available to sponsors, demonstrates such API testing for a growing list of UK banks.)
* an entire backend for an Open Banking client app (e.g. mobile phone or web app)
* reference software which all stakeholders in UK Open Banking can benefit from in the interests of promoting and improving Open Banking solutions for the benefit of consumers

The software allows:
* for each Software Statement, creation of *SoftwareStatementProfile* objects which combine a Software Statement with specified preferences 
* for each ASPSP, creation of *OBClientProfile* objects which combine a mapping to an underlying ASPSP OAuth2 client with specified ASPSP communication preferences
* for each user, creation of account access and payment consent objects which include a mapping to an underlying ASPSP consent and enable user authorisation (URL generation and redirect handling)

The functional (AISP and PISP) API provided is a simplified version of the UK Open Banking read/write data API standard which absorbs/minimises differences between different standard versions. Request types are version-independent (although some fields may have different valid options) and the significant data of response types is made version independent via protocol methods (the full ASPSP resource data is passed on by default so nothing is lost).

ASPSP interpretations and implementations of Open Banking APIs differ and this is handled by *OBClientProfile* objects' support of options and overrides for OAuth2 client creation and API communication. Sponsors, please note that [Open Banking Test Kit](https://github.com/finlabsuk/open-banking-test-kit) contains example code for integrations with a growing list of UK banks.

Sensitive data (e.g. user tokens) is not API-accessible. Such data is stored as plain-text for debugging purposes when the software is run in development mode. We are currently working on storage options for use in production mode.

The software is written using Apple's new non-blocking, multi-threaded, high-performance [SwiftNIO](https://github.com/apple/swift-nio) network application framework and uses a limited set of carefully selected Open Source dependencies (see [here](https://github.com/finlabsuk/open-banking-connector/blob/master/Package.swift)). It is designed for use on Linux and with Docker as well as standalone on a Mac for test purposes.

To use this software, you must at least be a member of the UK Open Banking Directory sandbox and able to generate software statements.

We will add two additional documents here covering (a) installation and (b) the API.