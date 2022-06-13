// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DesignSystem",
            dependencies: [],
            resources: [
                .copy("Resources/Fonts/Raleway-Black.ttf"),
                .copy("Resources/Fonts/Raleway-BlackItalic.ttf"),
                .copy("Resources/Fonts/Raleway-Bold.ttf"),
                .copy("Resources/Fonts/Raleway-BoldItalic.ttf"),
                .copy("Resources/Fonts/Raleway-ExtraBold.ttf"),
                .copy("Resources/Fonts/Raleway-ExtraBoldItalic.ttf"),
                .copy("Resources/Fonts/Raleway-ExtraLight.ttf"),
                .copy("Resources/Fonts/Raleway-ExtraLightItalic.ttf"),
                .copy("Resources/Fonts/Raleway-Italic.ttf"),
                .copy("Resources/Fonts/Raleway-Light.ttf"),
                .copy("Resources/Fonts/Raleway-LightItalic.ttf"),
                .copy("Resources/Fonts/Raleway-Medium.ttf"),
                .copy("Resources/Fonts/Raleway-MediumItalic.ttf"),
                .copy("Resources/Fonts/Raleway-Regular.ttf"),
                .copy("Resources/Fonts/Raleway-SemiBold.ttf"),
                .copy("Resources/Fonts/Raleway-SemiBoldItalic.ttf"),
                .copy("Resources/Fonts/Raleway-Thin.ttf"),
                .copy("Resources/Fonts/Raleway-ThinItalic.ttf"),
            ]),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"]),
    ]
)
