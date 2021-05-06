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

    extension Image {
      @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
      public static func resource(
        _ resource: ImageResource
      ) -> Image {
        Image(resource.name, bundle: resource.bundle)
      }

      @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
      public static func resource(
        _ resource: ImageResource,
        label: Text
      ) -> Image {
        Image(resource.name, bundle: resource.bundle)
      }

      @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
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
      public static func resource(
        _ resource: ImageResource,
        configuration: Configuration?
      ) -> UIImage? {
        UIImage(named: resource.name, in: resource.bundle, with: configuration)
      }

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
      public static func resource(
        _ resource: ImageResource
      ) -> CGImage? {
        UIImage.resource(resource).flatMap(\\.cgImage)
      }
    }

  #elseif os(macOS)
    import AppKit

    extension NSImage {
      public static func resource(
        _ resource: ImageResource
      ) -> NSImage? {
        resource.bundle?.image(forResource: resource.name)
      }
    }

    extension CGImage {
      public static func resource(
        _ resource: ImageResource
      ) -> CGImage? {
        NSImage.resource(resource).flatMap { image in
          image.cgImage(forProposedRect: nil, context: .current, hints: nil)
        }
      }
    }
  #endif
  """
}

func renderStaticFactoryForColorResource() -> String {
  """
  #if canImport(SwiftUI) && os(macOS)
    import SwiftUI

    extension Color {
      @available(macOS 10.15, *)
      public static func resource(
        _ resource: ColorResource
      ) -> Color? {
        NSColor.resource(resource).map(Color.init)
      }
    }

  #elseif canImport(SwiftUI) && os(iOS)
    import SwiftUI

    extension Color {
      @available(iOS 13.0, *)
      public static func resource(
        _ resource: ColorResource
      ) -> Color? {
        UIColor.resource(resource).map(Color.init)
      }
    }
  #endif

  #if os(iOS)
    import UIKit

    extension UIColor {
      @available(iOS 11.0, *)
      public static func resource(
        _ resource: ColorResource,
        compatibleWith traitCollection: UITraitCollection? = nil
      ) -> UIColor? {
        UIColor(named: resource.name, in: resource.bundle, compatibleWith: traitCollection)
      }
    }

    extension CGColor {
      public static func resource(
        _ resource: ColorResource
      ) -> CGColor? {
        UIColor.resource(resource).map(\\.cgColor)
      }
    }

  #elseif os(macOS)
    import AppKit

    extension NSColor {
      public static func resource(
        _ resource: ColorResource
      ) -> NSColor? {
        NSColor(named: resource.name, bundle: resource.bundle)
      }
    }

    extension CGColor {
      public static func resource(
        _ resource: ColorResource
      ) -> CGColor? {
        NSColor.resource(resource).map(\\.cgColor)
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
      public static func resource(
        _ resource: StoryboardResource
      ) -> UIStoryboard {
        UIStoryboard(name: resource.name, bundle: resource.bundle)
      }
    }

  #elseif os(macOS)
    import AppKit

    extension NSStoryboard {
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
  #if os(iOS)
    import UIKit

    extension UIFont {
      public static func resource(
        _ resource: FontResource,
        ofSize size: CGFloat
      ) -> UIFont? {
        UIFont(name: resource.name, size: size)
      }

      @discardableResult
      public static func register(
        _ resource: FontResource
      ) -> Bool {
        let urls = FontResource.extensions.compactMap { ext in
          Bundle.module.url(forResource: resource.name, withExtension: ext)
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
    }

  #elseif os(macOS)
    import AppKit

    extension NSFont {
      public static func resource(
        _ resource: FontResource,
        ofSize size: CGFloat
      ) -> NSFont? {
        NSFont(name: resource.name, size: size)
      }

      @discardableResult
      public static func register(
        _ resource: FontResource
      ) -> Bool {
        let urls = FontResource.extensions.compactMap { ext in
          Bundle.module.url(forResource: resource.name, withExtension: ext)
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
      public static func register(
        _ resources: [FontResource]
      ) -> (font: FontResource, isRegistered: Bool) {
        resources.map { ($0, register($0)) }
      }

      public static func installed() -> [(family: String, fonts: [String])] {
        var output = [(family: String, fonts: [String])]()
        let fontFamilies = UIFont.familyNames.sorted()
        for family in fontFamilies {
          let index = output.count
          output.append((family, []))
          for font in UIFont.fontNames(forFamilyName: family).sorted() {
              output[index].fonts.append(font)
          }
        }
        return output
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
