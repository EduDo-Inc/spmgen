import Foundation
import ArgumentParser
import Files
import SwiftSyntax

extension Location {
  var nameWithoutExtension: String {
    let components = name.components(separatedBy: ".")
    return components.filter { !$0.isEmpty } .count > 1
      ? components.dropLast().joined(separator: ".")
      : name
  }
}

let process: (URL) -> GenerationData? = {
  let enumProcessor = EnumSyntaxRewriter()
  return { url in
    guard let root = try? SyntaxParser.parse(url) else { return nil }
    _ = enumProcessor.visit(root)
    let generationData = enumProcessor.generationData
    enumProcessor.reset()
    let ignoreOutput = generationData.enums.isEmpty ||
      generationData.enums.allSatisfy(\.cases.isEmpty)
    return ignoreOutput ? nil : generationData
  }
}()

// MARK: - Command
extension SPMGen {
  struct CasePaths: ParsableCommand {
    static var _commandName: String { "casepaths" }
    
    @Argument(help: "Path to root directory for scanning.")
    public var input: String = "./"

    @Option(help: "Indentation kind")
    public var indentor: String = " "

    @Option(help: "Indentation width")
    public var indentationWidth: UInt = 2

    func run() throws {
      let folder = try Folder(path: input)
      let indent: (Int) -> String = { String(repeating: indentor, count: Int(indentationWidth) * $0) }
      try process(folder, indent: indent)
    }
  }
}

func process(_ folder: Folder, indent: (Int) -> String) throws {
  try folder.subfolders.forEach { try process($0, indent: indent) }
  try folder.files.forEach { file in
    guard
      file.extension == "swift",
      let output = process(file)
    else { return }
    let indentedOutput = output.components(separatedBy: .newlines).map { line in
      line.replacingOccurrences(of: "  ", with: indent(1))
    }.joined(separator: "\n")
    let name = file.nameWithoutExtension.trimmingCharacters(in: ["+"]) + "+CasePaths.swift"
    let outputFile = try folder.createFileIfNeeded(withName: name)
    try outputFile.write(indentedOutput, encoding: .utf8)
  }
}

func process(_ file: File) -> String? {
  guard let data = process(file.url) else { return nil }
  return generateCasePaths(for: data)
}

func generateCasePaths(for data: GenerationData) -> String {
  let fileAnnotation = """
  //  The file is generated using
  //  https://github.com/edudo-inc/spmgen
  //
  //  Do not modify!
  """
  
  var imports = data.imports
  if !imports.contains("import CasePaths") { imports.append("import CasePaths") }
  let importsString = imports.sorted().joined(separator: "\n")
  let importsSeparator = imports.isEmpty ? "" : "\n\n"
  
  let enums = data.enums
    .filter { !$0.cases.isEmpty }
    .sorted(by: { $0.identifier < $1.identifier })
    .map(generateCasePaths)
  
  return fileAnnotation + "\n\n" +
    importsString + importsSeparator +
    enums.joined(separator: "\n\n")
}

func generateCasePaths(for enumData: EnumData) -> String {
  let openExtension = enumData.allAssociatedTypes.isEmpty
    ? "extension CasePath where Root == \(enumData.fullGenericName) {"
    : "extension CasePath {"
  
  func implementation(_ caseData: CaseData) -> String {
    switch caseData.parameters.count {
    case 0:
      return """
          .init(
            embed: { .\(caseData.identifier) },
            extract: {
              guard case .\(caseData.identifier) = $0 else { return nil }
              return ()
            }
          )
      """
    case 1:
      let embedParameters = (caseData.parameters.first!.label.map { "\($0): " } ?? "") + "$0"
      return """
          .init(
            embed: { .\(caseData.identifier)(\(embedParameters)) },
            extract: {
              guard case let .\(caseData.identifier)(t0) = $0 else { return nil }
              return t0
            }
          )
      """
    default:
      func generateList(_ code: (Int, String?) -> String) -> String {
        caseData.parameters
          .map(\.label)
          .enumerated()
          .map(code)
          .joined(separator: ", ")
      }
      
      let generated = (
        embedParameters: generateList { index, label in
          (label.map { "\($0): " } ?? "") + "$0.\(index)"
        },
        matchParameters: generateList { index, label in "t\(index)" }
      )
      
      return  """
            .init(
              embed: { .\(caseData.identifier)(\(generated.embedParameters)) },
              extract: {
                guard case let .\(caseData.identifier)(\(generated.matchParameters)) = $0 else { return nil }
                return (\(generated.matchParameters))
              }
            )
        """
    }
  }
  
  let declaration: (CaseData) -> String = enumData.allAssociatedTypes.isEmpty
    ? { caseData in
      switch caseData.parameters.count {
      case 0: return
        "  \(enumData.joinedModifiers) static var \(caseData.identifier): CasePath<Root, Void> {\n"
      case 1: return
        "  \(enumData.joinedModifiers) static var \(caseData.identifier): CasePath<Root, \(caseData.parameters.first!.type)> {\n"
      default:
        let associatedTypes = caseData.parameters.map(\.type).joined(separator: ", ")
        return "  \(enumData.joinedModifiers) static var \(caseData.identifier): CasePath<Root, (\(associatedTypes))> {\n"
      }
    }
    : { caseData in
      let associatedTypesDeclaration = enumData.allAssociatedTypes.map(\.declaration).joined(separator: ", ")
      let declarationPrefix = "  \(enumData.joinedModifiers) static func \(caseData.identifier)<\(associatedTypesDeclaration)>()"
      let whereDeclaration = "  where Root == \(enumData.fullGenericName) {\n"
      
      switch caseData.parameters.count {
      case 0: return
        declarationPrefix + " -> CasePath<Root, Void>\n" + whereDeclaration
      case 1: return
        declarationPrefix + " -> CasePath<Root, \(caseData.parameters.first!.type)>\n" + whereDeclaration
      default:
        let associatedTypes = caseData.parameters.map(\.type).joined(separator: ", ")
        return declarationPrefix + " -> CasePath<Root, (\(associatedTypes)>\n" + whereDeclaration
      }
    }
  
  let staticGetters = enumData.cases
    .sorted(by: { $0.identifier < $1.identifier })
    .map { caseData in
      let decl = declaration(caseData)
      let impl = implementation(caseData)
      return decl + impl + "\n  }"
    }.joined(separator: "\n\n")
  
  return openExtension + "\n" + staticGetters + "\n}"
}
