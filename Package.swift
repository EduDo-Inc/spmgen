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
      from: "1.0.1"
    ),
    .package(
      url: "https://github.com/JohnSundell/Files.git",
      from: "4.0.0"
    ),
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
      ]
    ),
    .testTarget(
      name: "SPMGenLibTests",
      dependencies: [
        .target(name: "SPMGenLib"),
        .target(name: "SPMResources"),
      ]
    ),
    .target(name: "SPMResources"),
  ]
)
