// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "VaporGateWayService",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Gateway",
            targets: ["Gateway"]),
        ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc")
    ],
    targets: [
        .target(name: "Gateway", dependencies: [
            .product(name: "Vapor", package: "vapor"),
        ]),
        .target(name: "ExampleApp", dependencies: [
            .target(name: "Gateway"),
            .product(name: "Vapor", package: "vapor"),
        ]),
        .target(name: "ExampleRun", dependencies: [
            .target(name: "ExampleApp"),
        ])
    ]
)
