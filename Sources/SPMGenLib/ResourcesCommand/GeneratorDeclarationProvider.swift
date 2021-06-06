import Foundation
import SPMResources

typealias RenderableResource = BundleResource & NamedType & GeneratorDeclarationProvider

public protocol GeneratorDeclarationProvider {
  func makeGeneratorDeclaration() -> String
}

func makeDefaultFailedResourceName() -> String {
  "_spmgen_unknown_resource_\(UUID().uuidString.camelCased())"
}

func makeDefaultGeneratorDeclaration(for resource: CustomBundleResource & NamedType) -> String {
  var output = ""
  var camelCasedResourceName = resource.name.camelCased(.lowercaseFirst)

  if camelCasedResourceName.isEmpty {
    camelCasedResourceName = makeDefaultFailedResourceName()
  }

  output.append("  public static let \(camelCasedResourceName)")
  output.append(" = ")
  output.append("\(resource.typeName)(\n")
  output.append("    name: \"\(resource.name)\",\n")
  output.append("    bundle: .module\n")
  output.append("  )")
  return output
}

extension ColorResource: GeneratorDeclarationProvider {
  public func makeGeneratorDeclaration() -> String {
    makeDefaultGeneratorDeclaration(for: self)
  }
}

extension ImageResource: GeneratorDeclarationProvider {
  public func makeGeneratorDeclaration() -> String {
    makeDefaultGeneratorDeclaration(for: self)
  }
}

extension NibResource: GeneratorDeclarationProvider {
  public func makeGeneratorDeclaration() -> String {
    makeDefaultGeneratorDeclaration(for: self)
  }
}

extension StoryboardResource: GeneratorDeclarationProvider {
  public func makeGeneratorDeclaration() -> String {
    makeDefaultGeneratorDeclaration(for: self)
  }
}

extension FontResource: GeneratorDeclarationProvider {
  public func makeGeneratorDeclaration() -> String {
    var output = ""
    var camelCasedResourceName = name.camelCased(.lowercaseFirst)

    if camelCasedResourceName.isEmpty {
      camelCasedResourceName = makeDefaultFailedResourceName()
    }

    output.append("  public static let \(camelCasedResourceName)")
    output.append(" = ")
    output.append("\(typeName)(\n")
    output.append("    name: \"\(name)\"\n")
    output.append("  )")
    return output
  }
}

extension SCNSceneResource: GeneratorDeclarationProvider {
  public func makeGeneratorDeclaration() -> String {
    var output = ""
    var camelCasedResourceName = name.camelCased(.lowercaseFirst)

    if camelCasedResourceName.isEmpty {
      camelCasedResourceName = makeDefaultFailedResourceName()
    }

    output.append("  public static let \(camelCasedResourceName)")
    output.append(" = ")
    let catalog = self.catalog.map { "\($0)" } ?? "nil"
    output.append("\(typeName)(\n")
    output.append("    name: \"\(name)\",\n")
    output.append("    catalog: \"\(catalog)\"\n")
    output.append("  )")
    return output
  }
}
