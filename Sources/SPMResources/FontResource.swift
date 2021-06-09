import Foundation

public struct FontResource: BundleResource, NamedType, Equatable {
  public init(name: String) {
    self.name = name
  }

  public static let extensions: [String] = ["ttf", "otf"]
  public var name: String
}
