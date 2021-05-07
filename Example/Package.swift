// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "SPMGenExample",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "SPMGenExampleApp",
      targets: [
        "SPMGenExampleApp"
      ]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/edudo-inc/spmgen.git", .branch("main"))
  ],
  targets: [
    .target(
      name: "SPMGenExampleApp",
      dependencies: [
        .target(name: "SPMGenExampleResources")
      ]
    ),
    .target(
      name: "SPMGenExampleResources",
      dependencies: [
        .target(name: "SPMGenExampleCore"),
        .product(
          name: "SPMResources",
          package: "spmgen"
        ),
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(name: "SPMGenExampleCore"),
  ]
)
