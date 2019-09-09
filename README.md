# Open Banking Connector

_[NB currently dropping code for 0.0.1 release expected very soon (sorry for delay). That release will be acompanied by full instructions here on how to use....]_

Open Banking Connector is Open Source software that handles connections to UK Open Banking APIs. It presents to the user a simplified version of the UK Open Banking Read/Write Data APIs and can handle various complexities on their behalf. Specifically it can handle:
* banks' support of differing versions of the UK Open Banking read/write data API standard (versions 3.0, 3.1, 3.1.1 currently supported)
* banks' different interpretation/implementation choices when implementing UK Open Banking via a flexible system of configurable "overrides"
* banks' differing formats and conventions for user data via overrides
* management and storage of Open Banking client data (sensitive information is handled as per user security and storage policies and is not API-accessible)
* management and storage of user consents including tokens (sensitive information is handled as per user security and storage policies and is not API-accessible)

The software is written using Apple's new non-blocking, multi-threaded, high-performance [SwiftNIO](https://github.com/apple/swift-nio) network application framework and uses a limited set of carefully selected Open Source dependencies (see [here](https://github.com/finlabsuk/open-banking-connector/blob/master/Package.swift)). It is designed for use on Linux and with Docker as well as standalone on a Mac (or PC?) for test purposes.

The objectives of the software are:
* to support FinTechs looking to access Open Banking APIs but not wishing to pass data through an agent and willing to share the burden of solving problems related to multi-bank API access
* to support banks wishing to test their own and competitor Open Banking APIs without needing to build their own app or platform
* to support banks willing to contribute to and support a public reference implementation for accessing their APIs to which they can refer FinTechs and others (could really help with service desk calls...)
* to provide reference software which all stakeholders in UK Open Banking can use and contribute to in the interests of promoting and improving Open Banking solutions for the benefit of consumers and the public at large

Please get in touch if you wish to contribute towards this effort!

(Much) more to come....
