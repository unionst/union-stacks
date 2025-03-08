// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "iCenteredStack",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "iCenteredStack",
            targets: ["iCenteredStack"]
        ),
    ],
    targets: [
        .target(
            name: "iCenteredStack"
        ),
    ]
)
