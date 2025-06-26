// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "stat-generator",
    platforms: [
        .macOS(.v13),
        .custom("Linux", versionString: "1.0"),
        .custom("Windows", versionString: "10.0"),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/yliu-hashed/Scrap-Mechanic-EDA", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "stat-generator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SMEDAResult", package: "Scrap-Mechanic-EDA"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
