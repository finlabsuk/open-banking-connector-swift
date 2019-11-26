![Alt text](./docs/OBC_Banner.png)

*[NB: Need to resolve this upstream issue to allow running with Swift-JWT: https://github.com/IBM-Swift/Swift-JWT/issues/80 .]*
# Overview

Open Banking Connector is an interface layer that handles connections to UK Open Banking APIs. It is desiged for use as:
* an interface layer for consumption of Open Banking APIs (e.g. by FinTechs who do not want to pass data through an agent)
* an interface layer for testing functionality and live status of Open Banking APIs (e.g. by banks or FinTechs in automated regression tests) (NB: Companion product [Open Banking Test Kit](https://github.com/finlabsuk/open-banking-test-kit), available to sponsors, provides example test scripts covering a growing list of UK banks.)
* an entire backend for an Open Banking client app (e.g. mobile phone or web app)
* reference software which all stakeholders in UK Open Banking can benefit from in the interests of promoting and improving Open Banking solutions for the benefit of consumers

An important question is: what does Open Banking Connector provide compared to simply making direct connections to UK Open Banking APIs?

The answer is:
* Management and hiding of software statements, bank OAuth clients, tokens, consents, and other sensitive data
* Flexible *OBClientProfile* configuration objects which combine a link to an underlying bank OAuth2 client with specified bank communication preferences. Preferences available are constantly being updated to ensure they include those suitable for interactions with UK banks including workarounds for bugs and spec interpretation issues. Multiple OBClientProfiles may be simultaneously configured even if the link to the same bank OAuth2 client. This allows easy testing of different communication configurations even when a bank only allows a single OAuth2 client.
* Functional (AISP, PISP) endpoints which use Local Types for requests and responses. Local Types are simplified, spec-version-independent variants of the types defined in the UK Open Baning Read/Write specs. This means the downstream software can connect to multiple banks using multiple spec versions without needing to use different request and response data types. Local Types are also stored in their own modules to support customisation.
* Logging of consent creation and payment requests

A second question is: what is the scope of Open Banking Connector and what does it not do?

The answer is:
* It does not store data beyond necessary configuration data and consents and payments logging. For example transaction data pulled via AISP is not stored
* It will happily operate with multiple downstream clients and share software statement and OB client use. However, from a client perspective communications with OBC are independent per client. Thus if OBC is used as an app backend and a user has multiple devices which need to be aware of each other or share requested data via a cache system an additional backend component may be necessary.

The software is written using Apple's new non-blocking, multi-threaded, high-performance [SwiftNIO](https://github.com/apple/swift-nio) network application framework and uses a limited set of carefully selected Open Source dependencies (see [here](https://github.com/finlabsuk/open-banking-connector/blob/master/Package.swift)). It is designed for use on Linux and with Docker as well as standalone on a Mac for test purposes.

To use this software, you must at least be a member of the UK Open Banking Directory sandbox and be able to generate software statements.

## Documentation

Instructions on how to install and use Open Banking Connector are given [here](https://github.com/finlabsuk/open-banking-connector/blob/master/docs/installation-and-use.md).

The API of Open Banking Connector is described [here](https://github.com/finlabsuk/open-banking-connector/blob/master/docs/api.md).

The block architecture (code structure) of Open Banking Connector is described [here](https://github.com/finlabsuk/open-banking-connector/blob/master/docs/block-architecture.md) as well as in README docs at the root of each block (module).

Options for data storage and user (e.g. PSU) authentication are described [here](https://github.com/finlabsuk/open-banking-connector/blob/master/docs/data-storage-and-user-authentication.md). 

## Sponsorship

Open Banking Connector is provided with a hybrid model. Open Banking Connector itself is open source and free but sponsors get access to additional repos including:
* an actively maintainted Open Banking Connector Issues repo where you can raise and discuss issues relating to Open Banking Connector
* Open Banking Test Kit, a tool containing templates for testing endpoints provided by UK banks. The tool is written using TypeScript and contains example tests for accessing UK bank endpoints via Open Banking Connector that work out of the box. The tool is written in TypeScript/Node-JS and uses best in-class libraries (Jest for unit tests, Puppeteer for automated user authorisation).

For more information, please click the "Sponsor" icon at the top of this page.
