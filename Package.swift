// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Resolver",
    platforms: [ .macOS(.v10_14), .iOS(.v11) ],
    products: [ .library(name: "Resolver", targets: ["Resolver"]) ],
    targets: [ .target(name: "Resolver", dependencies: [], path: "Resolver") ],
    swiftLanguageVersions: [ .v5 ]
)
