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
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0-alpha.1"),
        .package(url: "https://github.com/IBM-Swift/Swift-JWT.git", from: "3.5.0"),
        .package(url: "https://github.com/vapor/sqlite-kit.git", from: "4.0.0-alpha"),
        .package(url: "https://github.com/vapor/sql-kit.git", from: "3.0.0-alpha"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "OBReadWriteV3p0",
            dependencies: []),
        .target(
            name: "OBReadWriteV3p1p1",
            dependencies: []),
        .target(
            name: "OBReadWriteV3p1p2",
            dependencies: []),
        .target(
            name: "OpenBankingConnector",
            dependencies: ["NIO", "NIOHTTP1", "NIOFoundationCompat", "AsyncHTTPClient", "SwiftJWT", "SQLiteKit", "SQLKit", "Logging", "OBReadWriteV3p0", "OBReadWriteV3p1p1", "OBReadWriteV3p1p2"]),
        .testTarget(
            name: "OpenBankingConnectorTests",
            dependencies: ["OpenBankingConnector"]),
    ],
    swiftLanguageVersions: [.v5]
)
