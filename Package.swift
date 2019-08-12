// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ResolverContainer",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_12),
        .watchOS(.v3),
        .tvOS(.v10)
    ],
    products: [
        .library(name: "ResolverContainer", targets: ["ResolverContainer"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "2.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.0"),
    ],
    targets: [
        .target(name: "ResolverContainer", dependencies: [], path: "Resolver"),
        .testTarget(name: "ResolverContainerTests", dependencies: ["ResolverContainer", "Quick", "Nimble"], path: "ResolverTests")
    ],
    swiftLanguageVersions: [ .v5 ]
)
