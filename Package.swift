// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Henny",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Henny",
            targets: ["Henny"]),
    ],
    dependencies: [
        .package(url: "https://github.com/phoqe/Ogge.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "Henny",
            dependencies: ["Ogge"]),
        .testTarget(
            name: "HennyTests",
            dependencies: ["Henny"]),
    ]
)
