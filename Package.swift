// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObservatoryPackage",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ObservatoryPackage",
            targets: ["ObservatoryCommon", "ObservatoryLogging", "ObservatoryTracing"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "ObservatoryCommon", path: "Sources/Common"),
        .target(name: "ObservatoryLogging", dependencies: ["ObservatoryCommon"], path: "Sources/Logging"),
        .target(
            name: "ObservatoryTracing",
            dependencies: ["ObservatoryCommon"], path: "Sources/Tracing"),
        .target(name: "ZipkinExpot", dependencies: ["ObservatoryTracing"], path: "Sources/Tracing/"),
        .testTarget(
            name: "ObservatoryPackageTests",
            dependencies: ["ObservatoryCommon", "ObservatoryLogging", "ObservatoryTracing"]),
    ]
)
