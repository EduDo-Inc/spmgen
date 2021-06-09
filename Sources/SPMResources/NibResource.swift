import Foundation

public struct NibResource: CustomBundleResource, NamedType, Equatable {
  public init(name: String, bundle: Bundle? = nil) {
    self.name = name
    self.bundle = bundle
  }

  public static let extensions: [String] = ["xib"]
  public var name: String
  public var bundle: Bundle?
}
