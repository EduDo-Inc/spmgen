//
//  Models.swift
//  SPMGenLib
//
//  Created by Maxim Krouk on 6.06.21.
//

import Foundation
import SwiftSyntax

struct GenerationData: Equatable {
  var imports: [String] = []
  var enums: [EnumData] = []
}

struct EnumData: Equatable {
  var modifiers: [String] = []
  var identifier: String
  var associatedTypes: [AssociatedTypeData] = []
  var cases: [CaseData] = []
  var parentType: ParentTypeData? = nil
  var allAssociatedTypes: [AssociatedTypeData] {
    (parentType?.allAssociatedTypes ?? []) + associatedTypes
  }
  
  var fullName: String {
    (parentType.map { "\($0.genericName)." } ?? "") + identifier
  }
  
  var genericName: String {
    if associatedTypes.isEmpty {
      return identifier
    } else {
      return "\(identifier)<" +
        associatedTypes.map(\.identifier).joined(separator: ", ") +
        ">"
    }
  }
  
  var fullGenericName: String {
    (parentType.map { "\($0.flattenGenericName)." } ?? "") + genericName
  }
  
  var joinedModifiers: String {
    modifiers.joined(separator: " ")
  }
}

struct CaseData: Equatable {
  var identifier: String
  var parameters: [CaseParameter]
}

struct CaseParameter: Equatable {
  var label: String? = .none
  var type: String
}

struct ParentTypeData: Equatable {
  var id: SyntaxIdentifier
  var identifier: String
  var associatedTypes: [AssociatedTypeData]
  
  @Indirect
  var parent: ParentTypeData? = nil
  
  var genericName: String {
    if associatedTypes.isEmpty {
      return identifier
    } else {
      return "\(identifier)<" +
        associatedTypes.map(\.identifier).joined(separator: ", ") +
        ">"
    }
  }
  
  func flatten() -> [ParentTypeData] {
    (parent?.flatten() ?? []) + [self]
  }
  
  var allAssociatedTypes: [AssociatedTypeData] {
    flatten().flatMap(\.associatedTypes)
  }
  
  var flattenGenericName: String {
    flatten().map(\.genericName).joined(separator: ".")
  }
}

struct AssociatedTypeData: Equatable {
  var identifier: String
  var inheritedType: String?
  
  var declaration: String {
    identifier + (inheritedType.map { ": \($0)" } ?? "")
  }
}
