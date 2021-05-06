public struct SCNSceneResource: BundleResource, NamedType {
  public static let extensions: [String] = ["scn"]

  public var name: String
  public var catalog: String? = nil

  public init(name: String) {
    self.name = name
  }

  public init(name: String, catalog: String?) {
    self.name = name
    self.catalog = catalog
  }
}
