import Foundation

public struct ColorResource: CustomBundleResource, NamedType, Equatable {
  public init(name: String, bundle: Bundle? = nil) {
    self.name = name
    self.bundle = bundle
  }

  public static let extensions: [String] = ["colorset"]
  public var name: String
  public var bundle: Bundle?
}
