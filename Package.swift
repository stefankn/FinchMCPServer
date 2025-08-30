// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FinchMCPServer",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/Cocoanetics/SwiftMCP.git", branch: "main"),
        .package(url: "https://github.com/stefankn/FinchProtocol.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "FinchMCPServer",
            dependencies: [
                .product(name: "SwiftMCP", package: "SwiftMCP"),
                .product(name: "FinchProtocol", package: "FinchProtocol")
            ]
        ),
    ]
)
