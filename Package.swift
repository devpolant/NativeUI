// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "NativeUI",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "NativeUI",
            targets: ["NativeUI"]
        )
    ],
    targets: [
        .target(name: "NativeUI", path: "NativeUI/Sources")
    ]
)
