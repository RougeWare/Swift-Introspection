// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Introspection",
    
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Introspection",
            targets: ["Introspection"]),
    ],
    
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "SemVer", url: "https://github.com/RougeWare/Swift-SemVer.git", from: "3.0.0-Beta.5"),
        .package(name: "StringIntegerAccess", url: "https://github.com/RougeWare/Swift-String-Integer-Access.git", from: "2.1.0"),
        .package(name: "SpecialString", url: "https://github.com/RougeWare/Swift-Special-String.git", from: "1.1.3"),
    ],
    
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Introspection",
            dependencies: [
                .product(name: "SafeStringIntegerAccess", package: "StringIntegerAccess"),
                "SemVer",
                "SpecialString",
                "StringIntegerAccess",
            ]),
        .testTarget(
            name: "IntrospectionTests",
            dependencies: ["Introspection"]),
    ]
)
