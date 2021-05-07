#if os(iOS)
  import UIKit
  public typealias CocoaColor = UIColor
#elseif os(macOS)
  import AppKit
  public typealias CocoaColor = NSColor
#endif

#if canImport(SwiftUI)
  import SwiftUI

  extension Color {
    public static func cocoa(_ color: CocoaColor) -> Color {
      Color(color)
    }
  }
#endif
