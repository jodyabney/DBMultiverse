// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DBMultiverseComicKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "DBMultiverseComicKit",
            targets: ["DBMultiverseComicKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nikolainobadi/NnSwiftUIKit.git", branch: "remove-nn-prefixes")
    ],
    targets: [
        .target(
            name: "DBMultiverseComicKit",
            dependencies: [
                "NnSwiftUIKit"
            ]
        ),
        .testTarget(
            name: "DBMultiverseComicKitTests",
            dependencies: ["DBMultiverseComicKit"]
        ),
    ]
)
