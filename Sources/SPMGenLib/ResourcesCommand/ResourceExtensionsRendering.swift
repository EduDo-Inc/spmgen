func renderStaticFactoriesForKnownResources() -> String {
  let renderers: [(key: String, render: () -> String)] = [
    ("Image", renderStaticFactoryForImageResource),
    ("Color", renderStaticFactoryForColorResource),
    ("Font", renderStaticFactoryForFontResource),
    ("Storyboard", renderStaticFactoryForStoryboardResource),
    ("Scene", renderStaticFactoryForSceneResource),
  ]
  return
    renderers
    .sorted { $0.key < $1.key }
    .map { $0.render() }
    .joined(separator: "\n\n")
}

func renderStaticFactoryForImageResource() -> String {
  """
  #if canImport(SwiftUI)
    import SwiftUI

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    extension Image {
      @inlinable
      public static func resource(
        _ resource: ImageResource
      ) -> Image {
        Image(resource.name, bundle: resource.bundle)
      }

      @inlinable
      public static func resource(
        _ resource: ImageResource,
        label: Text
      ) -> Image {
        Image(resource.name, bundle: resource.bundle)
      }

      @inlinable
      public static func resource(
        decorative resource: ImageResource
      ) -> Image {
        Image(decorative: resource.name, bundle: resource.bundle)
      }
    }
  #endif

  #if os(iOS)
    import UIKit

    extension UIImage {
      @available(iOS 13.0, *)
      @inlinable
      public static func resource(
        _ resource: ImageResource,
        configuration: Configuration?
      ) -> UIImage? {
        UIImage(named: resource.name, in: resource.bundle, with: configuration)
      }

      @inlinable
      public static func resource(
        _ resource: ImageResource,
        compatibleWith traitCollection: UITraitCollection? = nil
      ) -> UIImage? {
        return UIImage(
          named: resource.name,
          in: resource.bundle,
          compatibleWith: traitCollection
        )
      }
    }

    extension CGImage {
      @inlinable
      public static func resource(
        _ resource: ImageResource
      ) -> CGImage? {
        UIImage.resource(resource)?.cgImage
      }
    }

  #elseif os(macOS)
    import AppKit

    extension NSImage {
      @inlinable
      public static func resource(
        _ resource: ImageResource
      ) -> NSImage? {
        resource.bundle?.image(forResource: resource.name)
      }
    }

    extension CGImage {
      @inlinable
      public static func resource(
        _ resource: ImageResource
      ) -> CGImage? {
        NSImage.resource(resource).flatMap { image in
          image.cgImage(forProposedRect: nil, context: .current, hints: nil)
        }
      }
    }
  #endif

  #if os(iOS)
    extension UIImage {
      @available(iOS 13.0, *)
      @inlinable
      public static func resource(
        _ resource: ImageResource?,
        configuration: Configuration?
      ) -> UIImage? {
        return resource.flatMap { resource in
          UIImage(
            named: resource.name,
            in: resource.bundle,
            with: configuration
          )
        }
      }

      @inlinable
      public static func resource(
        _ resource: ImageResource?,
        compatibleWith traitCollection: UITraitCollection? = nil
      ) -> UIImage? {
        return resource.flatMap { resource in
          UIImage(
            named: resource.name,
            in: resource.bundle,
            compatibleWith: traitCollection
          )
        }
      }
    }

    extension CGImage {
      @inlinable
      public static func resource(
        _ resource: ImageResource?
      ) -> CGImage? {
        return UIImage.resource(resource)?.cgImage
      }
    }

  #elseif os(macOS)
    import AppKit

    extension NSImage {
      @inlinable
      public static func resource(
        _ resource: ImageResource?
      ) -> NSImage? {
        return resource.flatMap { resource in
          resource.bundle?.image(forResource: resource.name)
        }
      }
    }

    extension CGImage {
      @inlinable
      public static func resource(
        _ resource: ImageResource?
      ) -> CGImage? {
        return NSImage.resource(resource).flatMap { image in
          image.cgImage(forProposedRect: nil, context: .current, hints: nil)
        }
      }
    }
  #endif
  """
}

func renderStaticFactoryForColorResource() -> String {
  """
  #if canImport(SwiftUI)
    import SwiftUI

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    extension Color {
      @inlinable
      public static func resource(
        _ resource: ColorResource
      ) -> Color {
        Color(resource.name, bundle: resource.bundle)
      }
    }
  #endif

  #if os(iOS)
    import UIKit
    
    extension UIColor {
      @available(iOS 11.0, *)
      @inlinable
      public static func resource(
        _ resource: ColorResource,
        compatibleWith traitCollection: UITraitCollection? = nil
      ) -> UIColor? {
        UIColor(named: resource.name, in: resource.bundle, compatibleWith: traitCollection)
      }
    }

    extension CGColor {
      @available(iOS 11.0, *)
      @inlinable
      public static func resource(
        _ resource: ColorResource
      ) -> CGColor? {
        UIColor.resource(resource)?.cgColor
      }
    }

  #elseif os(macOS)
    import AppKit

    extension NSColor {
      @inlinable
      public static func resource(
        _ resource: ColorResource
      ) -> NSColor? {
        NSColor(named: resource.name, bundle: resource.bundle)
      }
    }

    extension CGColor {
      @inlinable
      public static func resource(
        _ resource: ColorResource
      ) -> CGColor? {
        NSColor.resource(resource)?.cgColor
      }
    }
  #endif
  """
}

func renderStaticFactoryForStoryboardResource() -> String {
  """
  #if os(iOS)
    import UIKit

    extension UIStoryboard {
      @inlinable
      public static func resource(
        _ resource: StoryboardResource
      ) -> UIStoryboard {
        UIStoryboard(name: resource.name, bundle: resource.bundle)
      }
    }

  #elseif os(macOS)
    import AppKit

    extension NSStoryboard {
      @inlinable
      public static func resource(
        _ resource: StoryboardResource
      ) -> NSStoryboard {
        NSStoryboard(name: resource.name, bundle: resource.bundle)
      }
    }
  #endif
  """
}

func renderStaticFactoryForFontResource() -> String {
  """
  #if canImport(SwiftUI)
    import SwiftUI

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    extension Font {
      @inlinable
      public static func resource(
        _ resource: FontResource,
        size: CGFloat
      ) -> Font {
        .custom(
          resource.name,
          size: size
        )
      }
    }

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    extension Font {
      @inlinable
      public static func resource(
        _ resource: FontResource,
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle
      ) -> Font {
        .custom(
          resource.name,
          size: size,
          relativeTo: textStyle
        )
      }

      @inlinable
      public static func resource(
        _ resource: FontResource,
        fixedSize: CGFloat
      ) -> Font {
        .custom(
          resource.name,
          fixedSize: fixedSize
        )
      }
    }
  #endif

  #if os(iOS)
    import UIKit

    extension CTFont {
      @inlinable
      public static func resource(
        _ resource: FontResource,
        ofSize size: CGFloat
      ) -> CTFont? {
        UIFont.resource(
          resource,
          ofSize: size
        ).map { $0 }
      }
    }

    extension UIFont {
      @inlinable
      public static func resource(
        _ resource: FontResource,
        ofSize size: CGFloat
      ) -> UIFont? {
        UIFont(name: resource.name, size: size)
      }

      @discardableResult
      @inlinable
      public static func registerIfNeeded(
        _ resource: FontResource
      ) -> (isRegistered: Bool, didTryToRegister: Bool) {
        registerIfNeeded([resource]).first
          .map { ($0.isRegistered, $0.didTryToRegister) }!
      }

      @discardableResult
      @inlinable
      public static func register(
        _ resource: FontResource
      ) -> Bool {
        let urls = FontResource.extensions.compactMap { ext in
          Bundle.resources.url(forResource: resource.name, withExtension: ext)
        }
        guard
          let fontURL = urls.last,
          let fontData = try? Data(contentsOf: fontURL),
          let fontDataProvider = CGDataProvider(data: fontData as CFData),
          let font = CGFont(fontDataProvider)
        else { return false }
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
        return error == nil
      }

      @discardableResult
      @inlinable
      public static func registerIfNeeded(
        _ resources: [FontResource]
      ) -> [(font: FontResource, isRegistered: Bool, didTryToRegister: Bool)] {
        let installedFonts: Set<String> = Set(installed())
        return resources.map {
          let isNotRegistered = !installedFonts.contains($0.name)
          return ($0, isNotRegistered  ? register($0) : true, isNotRegistered) }
      }

      @discardableResult
      @inlinable
      public static func register(
        _ resources: [FontResource]
      ) -> [(font: FontResource, isRegistered: Bool)] {
        resources.map { ($0, register($0)) }
      }

      @inlinable
      public static func installed() -> [(family: String, fonts: [String])] {
        familyNames.sorted()
          .map { (family: $0, fonts: fontNames(forFamilyName: $0).sorted()) }
      }

      @inlinable
      public static func installed() -> [String] {
        familyNames.flatMap { fontNames(forFamilyName: $0) }
      }
    }

  #elseif os(macOS)
    import AppKit

    extension CTFont {
      @inlinable
      public static func resource(
        _ resource: FontResource,
        ofSize size: CGFloat
      ) -> CTFont? {
        NSFont.resource(
          resource,
          ofSize: size
        ).map { $0 }
      }
    }

    extension NSFont {
      @inlinable
      public static func resource(
        _ resource: FontResource,
        ofSize size: CGFloat
      ) -> NSFont? {
        NSFont(name: resource.name, size: size)
      }

      @discardableResult
      @inlinable
      public static func registerIfNeeded(
        _ resource: FontResource
      ) -> (isRegistered: Bool, didTryToRegister: Bool) {
        registerIfNeeded([resource]).first
          .map { ($0.isRegistered, $0.didTryToRegister) }!
      }

      @discardableResult
      @inlinable
      public static func register(
        _ resource: FontResource
      ) -> Bool {
        let urls = FontResource.extensions.compactMap { ext in
          Bundle.resources.url(forResource: resource.name, withExtension: ext)
        }
        guard
          let fontURL = urls.last,
          let fontData = try? Data(contentsOf: fontURL),
          let fontDataProvider = CGDataProvider(data: fontData as CFData),
          let font = CGFont(fontDataProvider)
        else { return false }
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
        return error == nil
      }

      @discardableResult
      @inlinable
      public static func registerIfNeeded(
        _ resources: [FontResource]
      ) -> [(font: FontResource, isRegistered: Bool, didTryToRegister: Bool)] {
        let installedFonts = installedFontset()
        return resources.map {
          let isNotRegistered = !installedFonts.contains($0.name)
          return ($0, isNotRegistered  ? register($0) : true, isNotRegistered) }
      }

      @discardableResult
      @inlinable
      public static func register(
        _ resources: [FontResource]
      ) -> [(font: FontResource, isRegistered: Bool)] {
        resources.map { ($0, register($0)) }
      }

      @inlinable
      public static func installedUnsorted() -> [(family: String, fonts: [String])] {
        NSFontManager.shared.availableFontFamilies.map { family in
          NSFontManager.shared.availableMembers(ofFontFamily: family).map { memebers in
            (family, memebers.compactMap { $0.first as? String })
          } ?? (family, [String]())
        }
      }

      @inlinable
      public static func installedFontset() -> Set<String> {
        Set(
          (CTFontManagerCopyAvailableFontFamilyNames() as Array).flatMap { family -> [String] in
            if let family = family as? String {
              return NSFontManager.shared.availableMembers(ofFontFamily: family)
                .map { $0.compactMap { $0.first as? String } }
                 ?? [String]()
            } else {
              return [String]()
            }
          }
        )
      }
    }
  #endif
  """
}

func renderStaticFactoryForSceneResource() -> String {
  """
  #if canImport(SceneKit)
    import SceneKit

    extension SCNScene {
      @inlinable
      public static func resource(
        _ resource: SCNSceneResource
      ) -> SCNScene? {
        let catalog = resource.catalog.map { \"\\($0)/\" } ?? \"\"
        let fileName = \"\\(resource.name).\\(SCNSceneResource.extensions.first!)\"
        let pathComponent = catalog + fileName
        return try? SCNScene(
          url: Bundle.resources.bundleURL.appendingPathComponent(\"\\(pathComponent)\")
        )
      }
    }
  #endif
  """
}
