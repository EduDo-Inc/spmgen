// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "spmgen",
  products: [
    .executable(
      name: "spmgen",
      targets: [
        "SPMGen"
      ]
    ),
    .library(
      name: "SPMGenLib",
      targets: [
        "SPMGenLib"
      ]
    ),
    .library(
      name: "SPMResources",
      targets: [
        "SPMResources"
      ]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-argument-parser.git",
      from: "0.3.0"
    ),
    .package(
      url: "https://github.com/JohnSundell/Files.git",
      from: "4.0.0"
    ),
    .package(
      name: "SwiftSyntax",
      url: "https://github.com/apple/swift-syntax.git",
      .exact("0.50400.0")
    )
  ],
  targets: [
    .target(
      name: "SPMGen",
      dependencies: [
        .target(name: "SPMGenLib")
      ]
    ),
    .target(
      name: "SPMGenLib",
      dependencies: [
        .target(name: "SPMResources"),
        .product(
          name: "ArgumentParser",
          package: "swift-argument-parser"
        ),
        .product(
          name: "Files",
          package: "Files"
        ),
        .product(
          name: "SwiftSyntax",
          package: "SwiftSyntax"
        )
      ]
    ),
    .testTarget(
      name: "SPMGenLibTests",
      dependencies: [
        .target(name: "SPMGenLib"),
        .target(name: "SPMResources"),
        .product(
          name: "SwiftSyntax",
          package: "SwiftSyntax"
        )
      ]
    ),
    .target(name: "SPMResources"),
  ]
)
