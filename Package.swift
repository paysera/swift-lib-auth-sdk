// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "PayseraAuthSDK",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "PayseraAuthSDK", targets: ["PayseraAuthSDK"]),
    ],
    dependencies: [
        .package(
            name: "PayseraCommonSDK",
            url: "https://github.com/paysera/swift-lib-common-sdk",
            .exact("4.2.2")
        )
    ],
    targets: [
        .target(
            name: "PayseraAuthSDK",
            dependencies: ["PayseraCommonSDK"]
        ),
        .testTarget(
            name: "PayseraAuthSDKTests",
            dependencies: ["PayseraAuthSDK"]
        ),
    ]
)
