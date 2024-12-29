// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Vendors",
    defaultLocalization: "en",  // 启用本地化支持
    platforms: [
        .iOS(.v18)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Vendors",
            targets: ["Vendors"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/krzysztofzablocki/Inject.git",
            from: "1.2.4"
        ),
        .package(
            url: "https://github.com/exyte/ConcentricOnboarding",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/izyumkin/MCEmojiPicker",
            from: "1.2.3"
        ),
    ],
    targets: [
        .target(
            name: "Vendors",
            dependencies: [
                .inject,
                .onboarding,
                .emojiPicker,
            ]
        ),
        .testTarget(
            name: "VendorsTests",
            dependencies: [
                "Vendors",
                .onboarding,
                .emojiPicker,
            ]
        ),
    ]
)

@MainActor
extension Target.Dependency {
    static let inject = Self.product(
        name: "Inject",
        package: "Inject"
    )
    static let onboarding = Self.product(
        name: "ConcentricOnboarding",
        package: "ConcentricOnboarding"
    )
    static let emojiPicker = Self.product(
        name: "MCEmojiPicker",
        package: "MCEmojiPicker"
    )
}
