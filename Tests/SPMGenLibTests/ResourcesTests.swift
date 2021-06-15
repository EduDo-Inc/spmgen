import SPMResources
import XCTest

@testable import SPMGenLib

final class ResourcesTests: XCTestCase {
  func testCamelCase() {
    XCTAssertEqual("u".camelCased(), "u")
    XCTAssertEqual("lowercase".camelCased(), "lowercase")
    XCTAssertEqual("UPPERCASE".camelCased(.lowercaseFirst), "uPPERCASE")
    XCTAssertEqual("Almost.Correct.Case".camelCased(), "AlmostCorrectCase")
    XCTAssertEqual("normalCamelCase".camelCased(.uppercaseFirst), "NormalCamelCase")
    XCTAssertEqual("_normalCamelCase".camelCased(), "_normalCamelCase")
    XCTAssertEqual("1numbered".camelCased(), "_1numbered")
    XCTAssertEqual("_unknown.symbols_found".camelCased(.uppercaseFirst), "_UnknownSymbolsFound")
    XCTAssertEqual("trailingSymbol$".camelCased(), "trailingSymbol")
    XCTAssertEqual("testImage.1".camelCased(), "testImage_1")
    XCTAssertEqual("testImage.1.2.3".camelCased(), "testImage_1_2_3")
  }

  func testResourceReducing() {
    let resources: [RenderableResource] = [
      ColorResource(name: "Black", bundle: .none),
      ColorResource(name: "White", bundle: .none),
      ImageResource(name: "Logo", bundle: nil),
    ]

    let reduced = resources.reduce(into: [:], reduceResources)
    let expectation: [String: [RenderableResource]] = [
      "ColorResource": [
        ColorResource(name: "Black", bundle: .none),
        ColorResource(name: "White", bundle: .none),
      ],
      "ImageResource": [
        ImageResource(name: "Logo", bundle: nil)
      ],
    ]

    XCTAssertEqual(reduced.keys, expectation.keys)
    XCTAssertEqual(
      reduced.values.flatMap { $0 }.sorted(by: sortingForResourses).map(\.name),
      expectation.values.flatMap { $0 }.sorted(by: sortingForResourses).map(\.name)
    )
  }

  func testResourceRendering() {
    let resources: [String: [RenderableResource]] = [
      "ColorResource": [
        ColorResource(name: "Black", bundle: .none),
        ColorResource(name: "White", bundle: .none),
      ],
      "ImageResource": [
        ImageResource(name: "Logo", bundle: nil)
      ],
    ]

    XCTAssertEqual(
      renderReducedResources(resources),
      """
      extension ColorResource {
        public static let black = ColorResource(
          name: "Black",
          bundle: .module
        )

        public static let white = ColorResource(
          name: "White",
          bundle: .module
        )
      }

      extension ImageResource {
        public static let logo = ImageResource(
          name: "Logo",
          bundle: .module
        )
      }
      """
    )
  }

  func testResourceRendering2() {
    let resources: [String: [RenderableResource]] = [
      "ColorResource": [
        ColorResource(name: "Black", bundle: .none),
        ColorResource(name: "White", bundle: .none),
      ],
      "ImageResource": [
        ImageResource(name: "Logo", bundle: nil)
      ],
    ]

    print(render(resources, filename: "SPMGen.swift", indentor: " ", width: 2))
  }
}
