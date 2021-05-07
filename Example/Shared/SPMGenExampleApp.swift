//
//  SPMGenExampleApp.swift
//  Shared
//
//  Created by Maxim Krouk on 6.05.21.
//

import SPMGenExampleApp
import SwiftUI

#if os(iOS)
  public typealias CocoaApplicationDelegateAdaptor = UIApplicationDelegateAdaptor
#elseif os(macOS)
  public typealias CocoaApplicationDelegateAdaptor = NSApplicationDelegateAdaptor
#endif

@main
struct SPMGenExampleApp: App {
  @CocoaApplicationDelegateAdaptor
  var appDelegate: AppDelegate

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
