// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RxRelayed",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "RxRelayed",
            targets: ["RxRelayed"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", branch: "main"),
        .package(url: "https://github.com/CombineCommunity/RxCombine.git", branch: "main")
    ],
    targets: [
        .target(
            name: "RxRelayed",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxCombine", package: "RxCombine")
            ]
        ),
        .testTarget(
            name: "RxRelayedTests",
            dependencies: ["RxRelayed"]
        ),
    ]
)
