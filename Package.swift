// swift-tools-version: 5.10
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
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("IsolatedDefaultValues"),
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("DeprecateApplicationMain"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
                .enableUpcomingFeature("ImplicitOpenExistentials"),
                .enableUpcomingFeature("ImportObjcForwardDeclarations"),
                .enableUpcomingFeature("InferSendableFromCaptures"),
                .enableUpcomingFeature("GlobalConcurrency"),
                .enableUpcomingFeature("DisableOutwardActorInference"),
                .enableUpcomingFeature("RegionBasedIsolation"),
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
