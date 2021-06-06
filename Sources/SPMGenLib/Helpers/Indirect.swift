//
//  Indirect.swift
//  SPMGenLib
//
//  Created by Maxim Krouk on 6.06.21.
//

import Foundation

/// Allows to wrap structs recoursively
///
/// Usage:
/// ```
/// public struct User {
///     internal init(id: UUID, favoriteFollower: User?) {
///         self.id = id
///         self._favoriteFollower = Indirect(favoriteFollower)
///     }
///     public var id: UUID
///
///     @Indirect
///     public var favoriteFollower: User?
/// }
///
/// var user = User(id: UUID(), favoriteFollower: User(id: UUID()))
/// user.favoriteFollower?.id
/// ```
/// Note: Codable stuff behaviour is not tested for propertyWrapper style, maybe u should consider
/// using `var favoriteFollower: Indirect<User?>`.
///
@propertyWrapper
@dynamicMemberLookup
public struct Indirect<Value> {
  private var storage: [Value]
  
  public init(wrappedValue value: Value) {
    self.init(value)
  }
  
  public init(_ value: Value) {
    storage = [value]
  }
  
  public var wrappedValue: Value {
    get { storage[0] }
    set { storage[0] = newValue }
  }
  
  public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
    wrappedValue[keyPath: keyPath]
  }
  
  public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
    get { wrappedValue[keyPath: keyPath] }
    set { wrappedValue[keyPath: keyPath] = newValue }
  }
}

extension Indirect: Comparable where Value: Comparable {
  public static func < (lhs: Indirect<Value>, rhs: Indirect<Value>) -> Bool {
    lhs.wrappedValue < rhs.wrappedValue
  }
}
extension Indirect: Equatable where Value: Equatable {}
extension Indirect: Hashable where Value: Hashable {
  public func hash(into hasher: inout Hasher) {
    wrappedValue.hash(into: &hasher)
  }
}

extension Indirect: Codable where Value: Codable {
  public init(from decoder: Decoder) throws {
    try self.init(.init(from: decoder))
  }
  
  public func encode(to encoder: Encoder) throws {
    try wrappedValue.encode(to: encoder)
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Indirect: Identifiable where Value: Identifiable {
  public var id: Value.ID { wrappedValue.id }
}
