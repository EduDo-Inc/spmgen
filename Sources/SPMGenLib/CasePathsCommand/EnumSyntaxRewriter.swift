//
//  EnumSyntaxRewriter.swift
//  SPMGenLib
//
//  Created by Maxim Krouk on 6.06.21.
//

import Foundation
import SwiftSyntax

func traverse(_ syntax: Syntax, _ callback: (Syntax) -> Void) {
  syntax.children.forEach { traverse($0, callback) }
  callback(syntax)
}

class EnumSyntaxRewriter: SyntaxRewriter {
  var generationData = GenerationData()
  var nestedTypesMap: [SyntaxIdentifier: ParentTypeData] = [:]
  var ignoreList: Set<SyntaxIdentifier> = []
  
  func reset() {
    generationData = GenerationData()
    nestedTypesMap = [:]
  }
  
  override func visit(_ node: ImportDeclSyntax) -> DeclSyntax {
    generationData.imports.append(
      node.withoutTrivia().description
        .trimmingCharacters(in: .whitespacesAndNewlines)
    )
    return super.visit(node)
  }
  
  override func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
    registerParentIfNeeded(for: node)
    
    if !ignoreList.contains(node.id) {
      var enumData = extractBaseEnumData(from: node)
      if !enumData.modifiers.contains("fileprivate") {
        enumData.parentType = collectParentType(for: node.id)
        generationData.enums.append(enumData)
      }
    }
    
    return super.visit(node)
  }
  
  func extractBaseEnumData(from node: EnumDeclSyntax) -> EnumData {
    EnumData(
      modifiers: node.modifiers.map {
        $0.compactMap {
          let modifier = $0.withoutTrivia()
            .description
            .trimmingCharacters(in: .whitespacesAndNewlines)
          
          if modifier == "indirect" { return nil }
          else { return modifier }
        }
      } ?? [],
      identifier: node.identifier.withoutTrivia()
        .description.trimmingCharacters(in: .whitespacesAndNewlines),
      associatedTypes: node.genericParameters.map { params in
        params.genericParameterList.map { param in
          AssociatedTypeData(
            identifier: param.name.withoutTrivia()
              .description.trimmingCharacters(in: .whitespacesAndNewlines),
            inheritedType: param.inheritedType?.withoutTrivia()
              .description.trimmingCharacters(in: .whitespacesAndNewlines)
          )
        }
      } ?? [],
      cases: [],
      parentType: nil
    )
  }
  
  override func visit(_ node: EnumCaseDeclSyntax) -> DeclSyntax {
    node.elements.forEach { element in
      guard !generationData.enums.isEmpty else { return }
      generationData.enums[generationData.enums.count - 1].cases.append(
        CaseData(
          identifier: element.identifier.withoutTrivia()
            .description.trimmingCharacters(in: .whitespacesAndNewlines),
          parameters: element.associatedValue?.parameterList.compactMap { parameter in
            parameter.type.map { type in
              CaseParameter(
                label: parameter.firstName?.withoutTrivia().description
                  .trimmingCharacters(in: .whitespacesAndNewlines),
                type: type.withoutTrivia().description
                  .trimmingCharacters(in: .whitespacesAndNewlines)
              )
            }
            
          } ?? []
        )
      )
    }
    return super.visit(node)
  }
  
  override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
    registerAsParentIfNeeded(node)
    return super.visit(node)
  }
  
  override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
    registerAsParentIfNeeded(node)
    return super.visit(node)
  }
  
  override func visit(_ node: ExtensionDeclSyntax) -> DeclSyntax {
    registerAsParentIfNeeded(node)
    return super.visit(node)
  }
  
  override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
    traverse(Syntax(node)) { syntax in
      if let id = syntax.as(EnumDeclSyntax.self)?.id {
        ignoreList.insert(id)
      }
    }
    return super.visit(node)
  }
  
  override func visit(_ node: ClosureExprSyntax) -> ExprSyntax {
    traverse(Syntax(node)) { syntax in
      if let id = syntax.as(EnumDeclSyntax.self)?.id {
        ignoreList.insert(id)
      }
    }
    return super.visit(node)
  }
  
  func registerParentIfNeeded(for node: EnumDeclSyntax) {
    node.members.members.forEach { subnode in
      subnode.children.map({ child in
        child.as(EnumDeclSyntax.self)?.id
          ?? child.as(ClassDeclSyntax.self)?.id
          ?? child.as(StructDeclSyntax.self)?.id
      }).forEach { id in
        guard let id = id else { return }
        nestedTypesMap[id] = ParentTypeData(
          id: node.id,
          identifier: node.identifier.withoutTrivia()
            .description.trimmingCharacters(in: .whitespacesAndNewlines),
          associatedTypes: node.genericParameters.map { params in
            params.genericParameterList.map { param in
              AssociatedTypeData(
                identifier: param.name.withoutTrivia()
                  .description.trimmingCharacters(in: .whitespacesAndNewlines),
                inheritedType: param.inheritedType?.withoutTrivia()
                  .description.trimmingCharacters(in: .whitespacesAndNewlines)
              )
            }
          } ?? []
        )
      }
    }
  }
  
  func registerAsParentIfNeeded(_ node: ClassDeclSyntax) {
    node.members.members.forEach { subnode in
      subnode.children.map({ child in
        child.as(EnumDeclSyntax.self)?.id
          ?? child.as(ClassDeclSyntax.self)?.id
          ?? child.as(StructDeclSyntax.self)?.id
      }).forEach { id in
        guard let id = id else { return }
        nestedTypesMap[id] = ParentTypeData(
          id: node.id,
          identifier: node.identifier.withoutTrivia()
            .description.trimmingCharacters(in: .whitespacesAndNewlines),
          associatedTypes: node.genericParameterClause.map { params in
            params.genericParameterList.map { param in
              AssociatedTypeData(
                identifier: param.name.withoutTrivia()
                  .description.trimmingCharacters(in: .whitespacesAndNewlines),
                inheritedType: param.inheritedType?.withoutTrivia()
                  .description.trimmingCharacters(in: .whitespacesAndNewlines)
              )
            }
          } ?? []
        )
      }
    }
  }
  
  func registerAsParentIfNeeded(_ node: StructDeclSyntax) {
    node.members.members.forEach { subnode in
      subnode.children.map({ child in
        child.as(EnumDeclSyntax.self)?.id
          ?? child.as(ClassDeclSyntax.self)?.id
          ?? child.as(StructDeclSyntax.self)?.id
      }).forEach { id in
        guard let id = id else { return }
        nestedTypesMap[id] = ParentTypeData(
          id: node.id,
          identifier: node.identifier.withoutTrivia()
            .description.trimmingCharacters(in: .whitespacesAndNewlines),
          associatedTypes: node.genericParameterClause.map { params in
            params.genericParameterList.map { param in
              AssociatedTypeData(
                identifier: param.name.withoutTrivia()
                  .description.trimmingCharacters(in: .whitespacesAndNewlines),
                inheritedType: param.inheritedType?.withoutTrivia()
                  .description.trimmingCharacters(in: .whitespacesAndNewlines)
              )
            }
          } ?? []
        )
      }
    }
  }
  
  func registerAsParentIfNeeded(_ node: ExtensionDeclSyntax) {
    node.members.members.forEach { subnode in
      subnode.children.map({ child in
        child.as(EnumDeclSyntax.self)?.id
          ?? child.as(ClassDeclSyntax.self)?.id
          ?? child.as(StructDeclSyntax.self)?.id
      }).forEach { id in
        guard let id = id else { return }
        nestedTypesMap[id] = ParentTypeData(
          id: node.id,
          identifier: node.extendedType.withoutTrivia()
            .description.trimmingCharacters(in: .whitespacesAndNewlines),
          associatedTypes: []
        )
      }
    }
  }
  
  func collectParentType(for id: SyntaxIdentifier) -> ParentTypeData? {
    guard let parent = nestedTypesMap[id] else { return nil }
    return _collectParentType(subparent: parent)
  }
  
  func _collectParentType(subparent: ParentTypeData) -> ParentTypeData {
    guard let parent = collectParentType(for: subparent.id)
    else { return subparent }
    let collectedParent = _collectParentType(subparent: parent)
    return ParentTypeData(
      id: subparent.id,
      identifier: subparent.identifier,
      associatedTypes: subparent.associatedTypes,
      parent: collectedParent
    )
  }
}
