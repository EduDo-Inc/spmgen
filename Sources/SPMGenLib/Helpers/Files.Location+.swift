import Files
import Foundation

protocol _Location {
  static var kind: LocationKind { get }
  var description: String { get }
  var path: String { get }
  var url: URL { get }
  var name: String { get }
  var nameExcludingExtension: String { get }
  var `extension`: String? { get }
  var parent: Folder? { get }
  var creationDate: Date? { get }
  var modificationDate: Date? { get }
  func path(relativeTo folder: Folder) -> String
  func rename(to newName: String, keepExtension: Bool) throws
  func move(to newParent: Folder) throws
  func delete() throws
}

extension File: _Location {}
extension Folder: _Location {}
