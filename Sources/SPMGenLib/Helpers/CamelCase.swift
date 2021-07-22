import Foundation

extension String {
  public enum CamelCaseFirstLetterCustomizationFlag {
    case uppercaseFirst
    case lowercaseFirst
    case keepFirst
  }

  public func uppercasedFirst() -> String {
    let underscores = String(prefix(while: { $0 == "_" }))
    guard count > underscores.count else { return underscores }
    return
      underscores + String(dropFirst(underscores.count)).prefix(1).uppercased()
      + dropFirst(underscores.count + 1)
  }

  public func lowercasedFirst() -> String {
    let underscores = String(prefix(while: { $0 == "_" }))
    guard count > underscores.count else { return underscores }
    return
      underscores + String(dropFirst(underscores.count)).prefix(1).lowercased()
      + dropFirst(underscores.count + 1)
  }

  public func camelCased(
    _ firstLetterCustomizationFlag: CamelCaseFirstLetterCustomizationFlag = .keepFirst
  ) -> String {
    let underscorePrefix = prefix(while: { $0 == "_" })

    var result = String(dropFirst(underscorePrefix.count))

    if result.isEmpty { return String(underscorePrefix) }

    var allowedSet: CharacterSet = .alphanumerics
    if rangeOfCharacter(from: .decimalDigits) != nil {
      allowedSet.insert(".")
    }
    let parts = result.components(separatedBy: allowedSet.inverted)

    let first =
      parts.first.map { character in
        switch firstLetterCustomizationFlag {
        case .keepFirst:
          return String(character)
        case .lowercaseFirst:
          return String(character).lowercasedFirst()
        case .uppercaseFirst:
          return String(character).uppercasedFirst()
        }
      } ?? ""

    let rest = parts.dropFirst()
      .map { String($0) }
      .map { $0.uppercasedFirst()
    }

    result = ([first] + rest).joined(separator: "")

    if result.hasSuffix("Id") {
      result = String(result.dropLast(2)) + "ID"
    }

    if underscorePrefix.isEmpty, result.first?.isNumber == true {
      result = "_\(result)"
    }

    return (underscorePrefix + result).replacingOccurrences(of: ".", with: "_")
  }
}
