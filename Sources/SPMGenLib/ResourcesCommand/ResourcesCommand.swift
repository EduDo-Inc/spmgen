import ArgumentParser
import Files
import Foundation
import SPMResources

// MARK: - Command
extension SPMGen {
  struct Resources: ParsableCommand {
    @Argument(help: "Path to root directory for scanning.")
    public var input: String = "./"

    @Option(help: "Path to output file")
    public var output: String?

    @Option(help: "Indentation kind")
    public var indentor: String = " "

    @Option(help: "Indentation width")
    public var indentationWidth: UInt = 2

    @Flag(help: "Disables @_exported import for SPMResources")
    public var disableExports = false

    func run() throws {
      let outputPath = output ?? input.appending("/SPMGen.swift")
      createOutputIfNeeded(at: outputPath)
      let outputFile = try File(path: outputPath)

      let reducedResources = detectResources(
        [
          ColorResource.self,
          ImageResource.self,
          StoryboardResource.self,
          NibResource.self,
          SCNSceneResource.self,
          FontResource.self,
        ],
        at: try Folder(path: input)
      )
      .compactMap { $0 as? RenderableResource }
      .reduce(into: [String: [RenderableResource]](), reduceResources(into:resource:))

      try outputFile.write(
        render(
          reducedResources,
          exportEnabled: !disableExports,
          filename: outputFile.name,
          indentor: indentor,
          width: indentationWidth
        )
      )
    }
  }
}

func render(
  _ reducedResources: [String: [RenderableResource]],
  exportEnabled: Bool = true,
  filename: String,
  indentor: String,
  width: UInt
) -> String {
  let renderedResources = renderReducedResources(reducedResources)

  let renderedExtensions = renderStaticFactoriesForKnownResources()

  let output =
    """
    //
    // \(filename)
    // This file is generated. Do not edit!
    //

    \(exportEnabled ? "@_exported " : "")import SPMResources

    extension Bundle {
      public static var resources: Bundle { .module }
    }

    // MARK: - Rendered resources

    \(renderedResources)

    // MARK: - Rendered extensions

    \(renderedExtensions)

    """

  return indented(output, using: indentor, width: width)
}

// MARK: - File creation
private func createOutputIfNeeded(at outputPath: String) {
  let fileManager = FileManager.default
  if !fileManager.fileExists(atPath: outputPath) {
    fileManager.createFile(atPath: outputPath, contents: nil, attributes: nil)
  }
}

// MARK: Resource detection
private func detectResources(
  _ types: [BundleResource.Type],
  at folder: Folder,
  recoursive: Bool = true
) -> [BundleResource] {
  func extractName(from fileName: String) -> String {
    let components = fileName.components(separatedBy: ".")
    if components.count < 2 {
      return components.joined()
    }
    else {
      return components.dropLast().joined(separator: ".")
    }
  }
  return folder.flatMapContents(recoursive: recoursive) { object in
    types.first(where: { $0.extensions.contains(object.extension ?? "")})
      .map { type in
        let name = extractName(from: object.name)
        if type == SCNSceneResource.self {
          return SCNSceneResource(
            name: name,
            catalog: object.url.deletingLastPathComponent().lastPathComponent
          )
        }
        else {
          return type.init(name: name)
        }
      }
  }.compactMap { $0 }
}

// MARK: - Prepare for rendering
// MARK: Split by types
func reduceResources(
  into buffer: inout [String: [RenderableResource]],
  resource: RenderableResource
) {
  let key = resource.typeName
  let existing = buffer[key] ?? []
  buffer[key] = existing + [resource]
}

// MARK: Rendering
func renderReducedResources(_ reducedResources: [String: [RenderableResource]]) -> String {
  reducedResources.keys.sorted(by: <)
    .compactMap { key in
      reducedResources[key]?.sorted(by: sortingForResourses)
    }
    .map { resource in
      renderStaticFactories(for: resource)
    }
    .joined(separator: "\n\n")
}

// MARK: Sorting
func sortingForResourses(lhs: RenderableResource, rhs: RenderableResource) -> Bool {
  if lhs.typeName < rhs.typeName {
    return true
  }
  else if lhs.typeName > rhs.typeName {
    return false
  }
  else {
    return lhs.name < rhs.name
  }
}

// MARK: - Static factory rendering
func renderStaticFactories(for resources: [RenderableResource]) -> String {
  guard let resourceTypeName = resources.first.map({ $0.typeName})
  else { return "" }

  var output = ""
  output.append("extension \(resourceTypeName) {\n")
  if resources.isEmpty {
    output.removeLast()
  }
  else {
    output.append(
      resources.map { resource in
        resource.makeGeneratorDeclaration()
      }.joined(separator: "\n\n")
    )
  }

  output.append("\n}")
  return output
}

// MARK: - Indentation
func indented(_ input: String, using indentor: String, width: UInt) -> String {
  input.components(separatedBy: .newlines).map { line in
    let defaultIndentor = "  "
    return
      line
      .replacingOccurrences(
        of: defaultIndentor,
        with: String(repeating: indentor, count: Int(width))
      )
  }.joined(separator: "\n")
}
