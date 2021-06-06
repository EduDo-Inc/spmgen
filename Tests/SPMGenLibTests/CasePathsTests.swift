import XCTest
@testable import SPMGenLib
import SwiftSyntax

final class CasePathsTests: XCTestCase {
  func testLocalScope() {
    let source = """
    struct A {
      func a() {
        enum Ignore { case none }
      }
    }
    
    extension A {
      enum Event {
        case none
      }
    }
    """
    
    let detector = EnumSyntaxRewriter()
    _ = try! detector.visit(SyntaxParser.parse(source: source))
    let generationData = detector.generationData
    
    let syntaxID = generationData.enums.first!.parentType!.id
    
    XCTAssertEqual(
      generationData,
      GenerationData(
        imports: [],
        enums: [
          EnumData(
            modifiers: [],
            identifier: "Event",
            associatedTypes: [],
            cases: [
              CaseData(
                identifier: "none",
                parameters: []
              )
            ],
            parentType: ParentTypeData(
              id: syntaxID,
              identifier: "A",
              associatedTypes: []
            )
          )
        ]
      )
    )
  }
  
  func testDefaultGeneration() {
    let source = """
    // Comment
    
    import Foundation
    import EduDoComposableArchitecture
    
    internal enum Example {
      case a
      case t1(T1)
      case t2(Int = 1, T2, Bool, String)
    }
    """
    let detector = EnumSyntaxRewriter()
    _ = try! detector.visit(SyntaxParser.parse(source: source))
    let generationData = detector.generationData
    let casePaths = generateCasePaths(for: generationData)
    
    XCTAssertEqual(
      casePaths,
      """
      //  The file is generated using
      //  https://github.com/edudo-inc/spmgen
      //
      //  Do not modify!
      
      import Foundation
      import EduDoComposableArchitecture
      import CasePaths

      extension CasePath where Root == Example {
        internal static var a: CasePath<Root, Void> {
          .init(
            embed: { .a },
            extract: {
              guard case .a = $0 else { return nil }
              return ()
            }
          )
        }

        internal static var t1: CasePath<Root, T1> {
          .init(
            embed: { .t1($0) },
            extract: {
              guard case let .t1(t0) = $0 else { return nil }
              return t0
            }
          )
        }

        internal static var t2: CasePath<Root, (Int, T2, Bool, String)> {
          .init(
            embed: { .t2($0.0, $0.1, $0.2, $0.3) },
            extract: {
              guard case let .t2(t0, t1, t2, t3) = $0 else { return nil }
              return (t0, t1, t2, t3)
            }
          )
        }
      }
      """
    )
  }
  
  func testGenericGeneration() {
    let source = """
    import Foundation
    import EduDoComposableArchitecture
    
    public enum Action<Subaction: Equatable>: Equatable {
      case subaction(Subaction)
      case bool(Bool)
      case event(Event)
    
      public enum Event: Equatable {
        case first
        case second
      }
    }
    """
    let detector = EnumSyntaxRewriter()
    _ = try! detector.visit(SyntaxParser.parse(source: source))
    let generationData = detector.generationData
    let casePaths = generateCasePaths(for: generationData)
    
    XCTAssertEqual(
      casePaths,
      """
      //  The file is generated using
      //  https://github.com/edudo-inc/spmgen
      //
      //  Do not modify!
      
      import Foundation
      import EduDoComposableArchitecture
      import CasePaths
      
      extension CasePath {
        public static func subaction<Subaction: Equatable>() -> CasePath<Root, Subaction>
        where Root == Action<Subaction> {
          .init(
            embed: { .subaction($0) },
            extract: {
              guard case let .subaction(t0) = $0 else { return nil }
              return t0
            }
          )
        }
      
        public static func bool<Subaction: Equatable>() -> CasePath<Root, Bool>
        where Root == Action<Subaction> {
          .init(
            embed: { .bool($0) },
            extract: {
              guard case let .bool(t0) = $0 else { return nil }
              return t0
            }
          )
        }
      
        public static func event<Subaction: Equatable>() -> CasePath<Root, Event>
        where Root == Action<Subaction> {
          .init(
            embed: { .event($0) },
            extract: {
              guard case let .event(t0) = $0 else { return nil }
              return t0
            }
          )
        }
      }
      
      extension CasePath {
        public static func first<Subaction: Equatable>() -> CasePath<Root, Void>
        where Root == Action<Subaction>.Event {
          .init(
            embed: { .first },
            extract: {
              guard case .first = $0 else { return nil }
              return ()
            }
          )
        }
      
        public static func second<Subaction: Equatable>() -> CasePath<Root, Void>
        where Root == Action<Subaction>.Event {
          .init(
            embed: { .second },
            extract: {
              guard case .second = $0 else { return nil }
              return ()
            }
          )
        }
      }
      """
    )
  }
  
  func testSyntax() {
    let source = """
    import Foundation
    import EduDoComposableArchitecture
    
    public enum Example<T1, T2: Equatable & Hashable>: Equatable {
      case t1(T1)
      case t2(Int, T2)
      case a(value: Bool = false)
      case b, c, d
      case e; case f(Result<Int, Never> = .success(0 + 1))
      case event(Event)
      enum Event: Equatable {
        case none
      }
    }
    """
    let detector = EnumSyntaxRewriter()
    _ = try! detector.visit(SyntaxParser.parse(source: source))
    let generationData = detector.generationData
    
    let eventParentID = generationData.enums[1].parentType!.id
    
    XCTAssertEqual(
      generationData,
      GenerationData(
        imports: [
          "import Foundation",
          "import EduDoComposableArchitecture"
        ],
        enums: [
          EnumData(
            modifiers: ["public"],
            identifier: "Example",
            associatedTypes: [
              AssociatedTypeData(
                identifier: "T1",
                inheritedType: nil
              ),
              AssociatedTypeData(
                identifier: "T2",
                inheritedType: "Equatable & Hashable"
              )
            ],
            cases: [
              CaseData(
                identifier: "t1",
                parameters: [
                  CaseParameter(type: "T1")
                ]
              ),
              CaseData(
                identifier: "t2",
                parameters: [
                  CaseParameter(type: "Int"),
                  CaseParameter(type: "T2")
                ]
              ),
              CaseData(
                identifier: "a",
                parameters: [
                  CaseParameter(
                    label: "value",
                    type: "Bool"
                  )
                ]
              ),
              CaseData(
                identifier: "b",
                parameters: []
              ),
              CaseData(
                identifier: "c",
                parameters: []
              ),
              CaseData(
                identifier: "d",
                parameters: []
              ),
              CaseData(
                identifier: "e",
                parameters: []
              ),
              CaseData(
                identifier: "f",
                parameters: [
                  CaseParameter(type: "Result<Int, Never>")
                ]
              ),
              CaseData(
                identifier: "event",
                parameters: [
                  CaseParameter(type: "Event")
                ]
              )
            ],
            parentType: nil
          ),
          EnumData(
            modifiers: [],
            identifier: "Event",
            associatedTypes: [],
            cases: [
              CaseData(
                identifier: "none",
                parameters: []
              )
            ],
            parentType: ParentTypeData(
              id: eventParentID,
              identifier: "Example",
              associatedTypes: [
                AssociatedTypeData(
                  identifier: "T1",
                  inheritedType: nil
                ),
                AssociatedTypeData(
                  identifier: "T2",
                  inheritedType: "Equatable & Hashable"
                )
              ]
            )
          )
        ]
      )
    )
  }
  
  func testExtensionSyntax() {
    let source = """
    struct A {}
    
    extension A {
      enum Event {
        case none
      }
    }
    """
    
    let detector = EnumSyntaxRewriter()
    _ = try! detector.visit(SyntaxParser.parse(source: source))
    let generationData = detector.generationData
    
    let syntaxID = generationData.enums.first!.parentType!.id
    
    XCTAssertEqual(
      generationData,
      GenerationData(
        imports: [],
        enums: [
          EnumData(
            modifiers: [],
            identifier: "Event",
            associatedTypes: [],
            cases: [
              CaseData(
                identifier: "none",
                parameters: []
              )
            ],
            parentType: ParentTypeData(
              id: syntaxID,
              identifier: "A",
              associatedTypes: []
            )
          )
        ]
      )
    )
  }
  
  func testDeepNesting() {
    let source = """
    extension A {
      struct Ignore {
        struct Subignore {}
      }
      struct B {
        struct C {
          enum Event {
            case none
          }
        }
      }
    }
    """
    
    let detector = EnumSyntaxRewriter()
    _ = try! detector.visit(SyntaxParser.parse(source: source))
    let generationData = detector.generationData
    
    let parentC = generationData.enums.first!.parentType!
    let parentB = parentC.parent!
    let parentA = parentB.parent!
    
    XCTAssertEqual(
      generationData,
      GenerationData(
        imports: [],
        enums: [
          EnumData(
            modifiers: [],
            identifier: "Event",
            associatedTypes: [],
            cases: [
              CaseData(
                identifier: "none",
                parameters: []
              )
            ],
            parentType: ParentTypeData(
              id: parentC.id,
              identifier: "C",
              associatedTypes: [],
              parent: ParentTypeData(
                id: parentB.id,
                identifier: "B",
                associatedTypes: [],
                parent: ParentTypeData(
                  id: parentA.id,
                  identifier: "A",
                  associatedTypes: []
                )
              )
            )
          )
        ]
      )
    )
    
    let output = generateCasePaths(for: generationData)
    
    XCTAssertEqual(
      output,
      """
      //  The file is generated using
      //  https://github.com/edudo-inc/spmgen
      //
      //  Do not modify!
      
      import CasePaths
      
      extension CasePath where Root == A.B.C.Event {
         static var none: CasePath<Root, Void> {
          .init(
            embed: { .none },
            extract: {
              guard case .none = $0 else { return nil }
              return ()
            }
          )
        }
      }
      """
    )
  }
}
