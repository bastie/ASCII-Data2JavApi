// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ASCII-Data²JavApi",
    platforms: [.macOS(.v13),.visionOS(.v1),.iOS(.v16),.tvOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ASCII-Data2JavApi",
            targets: ["ASCII-Data2JavApi"]),
    ],
    dependencies: [
      .package(
        url: "https://github.com/bastie/JavApi4Swift.git",
        .upToNextMajor(from: "0.4.1") // tested also agains 0.13.0
      )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ASCII-Data2JavApi",
            dependencies: [
              .product(name: "JavApi", package: "JavApi4Swift")
            ]
        ),
        .testTarget(
            name: "ASCII-Data2JavApiTests",
            dependencies: ["ASCII-Data2JavApi",
                           .product(name: "JavApi", package: "JavApi4Swift")
            ],
            resources: [.process("Resources")]
        ),
    ]
)
    
