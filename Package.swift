// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FinchMCPServer",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", from: "2.3.0"),
        .package(url: "https://github.com/modelcontextprotocol/swift-sdk.git", from: "0.10.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "FinchMCPServer",
            dependencies: [
                .product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
                .product(name: "MCP", package: "swift-sdk")
            ]
        ),
    ]
)
