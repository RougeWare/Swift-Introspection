// swift-tools-version:6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Introspection",
    
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Introspection",
            targets: ["Introspection"]),
    ],
    
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/RougeWare/Swift-Collection-Tools.git", from: "3.2.0"),
        .package(url: "https://github.com/RougeWare/Swift-SemVer.git", from: "3.0.0-Beta.6"),
        .package(url: "https://github.com/RougeWare/Swift-String-Integer-Access.git", from: "2.1.0"),
        .package(url: "https://github.com/RougeWare/Swift-Special-String.git", from: "1.1.3"),
    ],
    
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Introspection",
            dependencies: [
                .product(name: "SafeStringIntegerAccess", package: "Swift-String-Integer-Access"),
                .product(name: "CollectionTools", package: "Swift-Collection-Tools"),
                .product(name: "SemVer", package: "Swift-SemVer"),
                .product(name: "StringIntegerAccess", package: "Swift-String-Integer-Access"),
                .product(name: "SpecialString", package: "Swift-Special-String"),
            ],
            swiftSettings: [.swiftLanguageMode(.v5)],
        ),
        .testTarget(
            name: "IntrospectionTests",
            dependencies: ["Introspection"]),
    ]
)
