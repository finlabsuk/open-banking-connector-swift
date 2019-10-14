// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "open-banking-connector",
    platforms: [
       .macOS(.v10_14)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(
            name: "OpenBankingConnector",
            targets: ["OpenBankingConnector"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.9.0"),
        //.package(path: "../swift-nio"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
        .package(url: "https://github.com/IBM-Swift/Swift-JWT.git", from: "3.5.0"),
        .package(url: "https://github.com/vapor/sqlite-kit.git", from: "4.0.0-alpha.1.1"),
        //.package(path: "../sqlite-kit"),
        .package(url: "https://github.com/vapor/sql-kit.git", from: "3.0.0-alpha.1.3"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        
        // Base services
        .target(
            name: "BaseServices",
            dependencies: [
        ]),
        
        // UK Open Banking Account and Transaction Types
        .target(
            name: "AccountTransactionTypeRequirements",
            dependencies: [
                "BaseServices"
        ]),
        .target(
            name: "AccountTransactionApiV3p0Types",
            dependencies: [
                "AccountTransactionTypeRequirements"
        ]),
        .target(
            name: "AccountTransactionApiV3p1p1Types",
            dependencies: [
                "AccountTransactionTypeRequirements"
        ]),
        .target(
            name: "AccountTransactionApiV3p1p2Types",
            dependencies: [
                "AccountTransactionTypeRequirements"
        ]),
        .target(
            name: "AccountTransactionLocalTypes",
            dependencies: [
                "BaseServices",
                "AccountTransactionTypeRequirements"
        ]),
        .target(
            name: "AccountTransactionTypes",
            dependencies: [
                "AccountTransactionTypeRequirements",
                "AccountTransactionApiV3p0Types",
                "AccountTransactionApiV3p1p1Types",
                "AccountTransactionApiV3p1p2Types",
                "AccountTransactionLocalTypes"
        ]),
        
        // UK Open Banking Payment Initiation Types
        .target(
            name: "PaymentInitiationTypeRequirements",
            dependencies: [
                "BaseServices"
        ]),
        .target(
            name: "PaymentInitiationApiV3p1p1Types",
            dependencies: [
                "PaymentInitiationTypeRequirements"
        ]),
        .target(
            name: "PaymentInitiationApiV3p1p2Types",
            dependencies: [
                "PaymentInitiationTypeRequirements"
        ]),
        .target(
            name: "PaymentInitiationLocalTypes",
            dependencies: [
                "BaseServices",
                "PaymentInitiationTypeRequirements"
        ]),
        .target(
            name: "PaymentInitiationTypes",
            dependencies: [
                "PaymentInitiationTypeRequirements",
                "PaymentInitiationApiV3p1p1Types",
                "PaymentInitiationApiV3p1p2Types",
                "PaymentInitiationLocalTypes"
        ]),

        // Main OBC module
        .target(
            name: "OpenBankingConnector",
            dependencies: [
                "NIO",
                "NIOHTTP1",
                "NIOFoundationCompat",
                "AsyncHTTPClient",
                "SwiftJWT",
                "SQLiteKit",
                "SQLKit",
                "Logging",
                "AccountTransactionTypeRequirements",
                "AccountTransactionTypes",
                "PaymentInitiationTypeRequirements",
                "PaymentInitiationTypes"
        ]),
        
        // Test module
        .testTarget(
            name: "OpenBankingConnectorTests",
            dependencies: ["OpenBankingConnector"]),
    ],
    swiftLanguageVersions: [.v5]
)
