import Foundation

public protocol NamedType {
  static var name: String { get }
  var typeName: String { get }
}

extension NamedType {
  public static var name: String { String(describing: self) }
  public var typeName: String { Self.name }
}

public protocol BundleResource {
  static var extensions: [String] { get }
  var name: String { get }
  init(name: String)
}

public protocol CustomBundleResource: BundleResource {
  var bundle: Bundle? { get }
  init(name: String, bundle: Bundle?)
}

extension CustomBundleResource {
  public init(name: String) {
    self.init(name: name, bundle: nil)
  }
}
