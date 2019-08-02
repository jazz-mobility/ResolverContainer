// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Resolver",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "Resolver", targets: ["Resolver"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "2.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.0"),
    ],
    targets: [
        .target(name: "Resolver", dependencies: [], path: "Resolver"),
        .testTarget(name: "ResolverTests", dependencies: ["Quick", "Nimble"], path: "ResolverTests")
    ],
    swiftLanguageVersions: [ .v5 ]
)
