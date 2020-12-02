// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "CompactConstraint",
    products: [
        .library(
            name: "CompactConstraint",
            targets: ["CompactConstraint"]
        )
    ],
    targets: [
        .target(name: "CompactConstraint")
    ]
)
