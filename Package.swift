// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "UnionStacks",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "UnionStacks",
            targets: ["UnionStacks"]
        ),
    ],
    targets: [
        .target(
            name: "UnionStacks",
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
