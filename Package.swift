// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "UnionStacks",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10)
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
