// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MacCafe",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "MacCafe",
            targets: ["MacCafe"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MacCafe",
            dependencies: [],
            path: ".",
            exclude: ["Info.plist", "README.md", "build.sh", "generate_xcode.sh"],
            sources: [
                "MacCafeApp.swift",
                "ContentView.swift",
                "CaffeineManager.swift",
                "CatAnimationView.swift"
            ]
        )
    ]
)
