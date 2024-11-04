// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MainActorPublisher",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MainActorPublisher",
            targets: ["MainActorPublisher"]
        ),
    ],
    targets: [
        .target(
            name: "MainActorPublisher",
            swiftSettings: [
            ]
        )
    ]
)
