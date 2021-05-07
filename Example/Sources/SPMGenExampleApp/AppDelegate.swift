import SPMGenExampleResources

#if os(iOS)
  import UIKit
  public typealias CocoaApplication = UIApplication
  public typealias CocoaApplicationDelegate = UIApplicationDelegate

  public final class AppDelegate: NSObject, CocoaApplicationDelegate {
    public func application(
      _ application: CocoaApplication,
      didFinishLaunchingWithOptions launchOptions: [CocoaApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
      CocoaFont.bootstrap()
      return true
    }
  }
#elseif os(macOS)
  import AppKit
  public typealias CocoaApplication = NSApplication
  public typealias CocoaApplicationDelegate = NSApplicationDelegate

  public final class AppDelegate: NSObject, CocoaApplicationDelegate {
    public func applicationDidFinishLaunching(_ notification: Notification) {
      CocoaFont.bootstrap()
    }
  }
#endif
