//
// SPMGen.swift
// This file is generated. Do not edit!
//

@_exported import SPMResources

extension Bundle {
  public static var resources: Bundle { .module }
}

// MARK: - Rendered resources

extension ColorResource {
  public static let colorExample = ColorResource(
    name: "ColorExample",
    bundle: .module
  )
}

extension FontResource {
  public static let arimoBold = FontResource(
    name: "Arimo-Bold"
  )

  public static let arimoBoldItalic = FontResource(
    name: "Arimo-BoldItalic"
  )

  public static let arimoItalic = FontResource(
    name: "Arimo-Italic"
  )

  public static let arimoRegular = FontResource(
    name: "Arimo-Regular"
  )

  public static let montserratBlack = FontResource(
    name: "Montserrat-Black"
  )

  public static let montserratBlackItalic = FontResource(
    name: "Montserrat-BlackItalic"
  )

  public static let montserratBold = FontResource(
    name: "Montserrat-Bold"
  )

  public static let montserratBoldItalic = FontResource(
    name: "Montserrat-BoldItalic"
  )

  public static let montserratExtraBold = FontResource(
    name: "Montserrat-ExtraBold"
  )

  public static let montserratExtraBoldItalic = FontResource(
    name: "Montserrat-ExtraBoldItalic"
  )

  public static let montserratExtraLight = FontResource(
    name: "Montserrat-ExtraLight"
  )

  public static let montserratExtraLightItalic = FontResource(
    name: "Montserrat-ExtraLightItalic"
  )

  public static let montserratItalic = FontResource(
    name: "Montserrat-Italic"
  )

  public static let montserratLight = FontResource(
    name: "Montserrat-Light"
  )

  public static let montserratLightItalic = FontResource(
    name: "Montserrat-LightItalic"
  )

  public static let montserratMedium = FontResource(
    name: "Montserrat-Medium"
  )

  public static let montserratMediumItalic = FontResource(
    name: "Montserrat-MediumItalic"
  )

  public static let montserratRegular = FontResource(
    name: "Montserrat-Regular"
  )

  public static let montserratSemiBold = FontResource(
    name: "Montserrat-SemiBold"
  )

  public static let montserratSemiBoldItalic = FontResource(
    name: "Montserrat-SemiBoldItalic"
  )

  public static let montserratThin = FontResource(
    name: "Montserrat-Thin"
  )

  public static let montserratThinItalic = FontResource(
    name: "Montserrat-ThinItalic"
  )
}

extension ImageResource {
  public static let imageExample = ImageResource(
    name: "ImageExample",
    bundle: .module
  )
}

// MARK: - Rendered extensions

#if canImport(SwiftUI)
  import SwiftUI

  @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
  extension Color {
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
    public static func resource(
      _ resource: ColorResource,
      compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIColor? {
      UIColor(named: resource.name, in: resource.bundle, compatibleWith: traitCollection)
    }
  }

  extension CGColor {
    @available(iOS 11.0, *)
    public static func resource(
      _ resource: ColorResource
    ) -> CGColor? {
      UIColor.resource(resource)?.cgColor
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
      NSColor.resource(resource)?.cgColor
    }
  }
#endif

#if canImport(SwiftUI)
  import SwiftUI

  @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
  extension Font {
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
    public static func resource(
      _ resource: FontResource,
      ofSize size: CGFloat
    ) -> UIFont? {
      UIFont(name: resource.name, size: size)
    }

    @discardableResult
    public static func registerIfNeeded(
      _ resource: FontResource
    ) -> (isRegistered: Bool, didTryToRegister: Bool) {
      registerIfNeeded([resource]).first
        .map { ($0.isRegistered, $0.didTryToRegister) }!
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
    public static func registerIfNeeded(
      _ resources: [FontResource]
    ) -> [(font: FontResource, isRegistered: Bool, didTryToRegister: Bool)] {
      let installedFonts: Set<String> = Set(installed())
      return resources.map {
        let isNotRegistered = !installedFonts.contains($0.name)
        return ($0, isNotRegistered ? register($0) : true, isNotRegistered)
      }
    }

    @discardableResult
    public static func register(
      _ resources: [FontResource]
    ) -> [(font: FontResource, isRegistered: Bool)] {
      resources.map { ($0, register($0)) }
    }

    public static func installed() -> [(family: String, fonts: [String])] {
      familyNames.sorted()
        .map { (family: $0, fonts: fontNames(forFamilyName: $0).sorted()) }
    }

    public static func installed() -> [String] {
      familyNames.flatMap { fontNames(forFamilyName: $0) }
    }
  }

#elseif os(macOS)
  import AppKit

  extension CTFont {
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
    public static func resource(
      _ resource: FontResource,
      ofSize size: CGFloat
    ) -> NSFont? {
      NSFont(name: resource.name, size: size)
    }

    @discardableResult
    public static func registerIfNeeded(
      _ resource: FontResource
    ) -> (isRegistered: Bool, didTryToRegister: Bool) {
      registerIfNeeded([resource]).first
        .map { ($0.isRegistered, $0.didTryToRegister) }!
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
    public static func registerIfNeeded(
      _ resources: [FontResource]
    ) -> [(font: FontResource, isRegistered: Bool, didTryToRegister: Bool)] {
      let installedFonts = installedFontset()
      return resources.map {
        let isNotRegistered = !installedFonts.contains($0.name)
        return ($0, isNotRegistered ? register($0) : true, isNotRegistered)
      }
    }

    @discardableResult
    public static func register(
      _ resources: [FontResource]
    ) -> [(font: FontResource, isRegistered: Bool)] {
      resources.map { ($0, register($0)) }
    }

    public static func installedUnsorted() -> [(family: String, fonts: [String])] {
      NSFontManager.shared.availableFontFamilies.map { family in
        NSFontManager.shared.availableMembers(ofFontFamily: family).map { memebers in
          (family, memebers.compactMap { $0.first as? String})
        }.or((family, [String]()))
      }
    }

    public static func installedFontset() -> Set<String> {
      Set(
        (CTFontManagerCopyAvailableFontFamilyNames() as Array).flatMap { family -> [String] in
          if let family = family as? String {
            return NSFontManager.shared.availableMembers(ofFontFamily: family)
              .map { $0.compactMap { $0.first as? String
            }}
              .or([String]())
          }
          else {
            return [String]()
          }
        }
      )
    }
  }
#endif

#if canImport(SwiftUI)
  import SwiftUI

  @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
  extension Image {
    public static func resource(
      _ resource: ImageResource
    ) -> Image {
      Image(resource.name, bundle: resource.bundle)
    }

    public static func resource(
      _ resource: ImageResource,
      label: Text
    ) -> Image {
      Image(resource.name, bundle: resource.bundle)
    }

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
      UIImage.resource(resource)?.cgImage
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

#if canImport(SceneKit)
  import SceneKit

  extension SCNScene {
    public static func resource(
      _ resource: SCNSceneResource
    ) -> SCNScene? {
      let catalog = resource.catalog.map { "\($0)/" } ?? ""
      let fileName = "\(resource.name).\(SCNSceneResource.extensions.first!)"
      let pathComponent = catalog + fileName
      return try? SCNScene(
        url: Bundle.resources.bundleURL.appendingPathComponent("\(pathComponent)")
      )
    }
  }
#endif

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
