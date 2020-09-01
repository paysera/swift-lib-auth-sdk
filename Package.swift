// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "PayseraAuthSDK",
    platforms: [.macOS(.v10_12), .iOS(.v10), .tvOS(.v9), .watchOS(.v2)],
    products: [
        .library(name: "PayseraAuthSDK", targets: ["PayseraAuthSDK"]),
    ],
    dependencies: [
        .package(name: "PayseraCommonSDK", url: "https://github.com/paysera/swift-lib-common-sdk", from: "3.0.0")
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
