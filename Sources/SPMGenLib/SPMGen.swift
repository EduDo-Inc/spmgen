import ArgumentParser
import Files
import Foundation

// MARK: - Command

public struct SPMGen: ParsableCommand {
  public static let configuration = CommandConfiguration(
    subcommands: [Resources.self, CasePaths.self]
  )

  public init() {}

  public func run() throws {
    throw _Error("No command found. Run --help to explore available commands.")
  }
}
