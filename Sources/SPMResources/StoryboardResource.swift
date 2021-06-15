import Foundation

public struct StoryboardResource: CustomBundleResource, NamedType, Equatable {
  public init(name: String, bundle: Bundle? = nil) {
    self.name = name
    self.bundle = bundle
  }

  public static let extensions: [String] = ["storyboard"]
  public var name: String
  public var bundle: Bundle?
}
