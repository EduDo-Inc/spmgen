import SPMGenExampleCore
import SPMResources

#if os(iOS)
import UIKit
public typealias CocoaFont = UIFont
#elseif os(macOS)
import AppKit
public typealias CocoaFont = NSFont
#endif

extension CocoaFont {
  public static var customFonts: [FontResource] {
    [
      .arimoBold,
      .arimoBoldItalic,
      .arimoItalic,
      .arimoRegular,
      .montserratBlack,
      .montserratBlackItalic,
      .montserratBold,
      .montserratBoldItalic,
      .montserratExtraBold,
      .montserratExtraBoldItalic,
      .montserratExtraLight,
      .montserratExtraLightItalic,
      .montserratItalic,
      .montserratLight,
      .montserratLightItalic,
      .montserratMedium,
      .montserratMediumItalic,
      .montserratRegular,
      .montserratSemiBold,
      .montserratSemiBoldItalic,
      .montserratThin,
      .montserratThinItalic
    ]
  }
  
  @discardableResult
  public static func bootstrap() -> Bool {
    register(customFonts).allSatisfy(\.isRegistered)
  }
  
  public static func system(ofSize size: CGFloat, weight: CocoaFont.Weight) -> CocoaFont {
    .systemFont(ofSize: size, weight: weight)
  }
}

extension CocoaFont {
  public enum Style {
    case `default`
    case italic
  }
  /// Montserrat
  public static func primary(ofSize size: CGFloat, weight: Weight, style: Style = .default) -> CocoaFont {
    switch style {
    case .default:
      switch weight {
      case .ultraLight:
        return CocoaFont.resource(.montserratThin, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .thin:
        return CocoaFont.resource(.montserratExtraLight, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .light:
        return CocoaFont.resource(.montserratLight, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .regular:
        return CocoaFont.resource(.montserratRegular, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .medium:
        return CocoaFont.resource(.montserratMedium, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .semibold:
        return CocoaFont.resource(.montserratSemiBold, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .bold:
        return CocoaFont.resource(.montserratBold, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .heavy:
        return CocoaFont.resource(.montserratExtraBold, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .black:
        return CocoaFont.resource(.montserratBlack, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      default:
        return .system(ofSize: size, weight: weight)
      }
      
    case .italic:
      switch weight {
      case .ultraLight:
        return CocoaFont.resource(.montserratThinItalic, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .thin:
        return CocoaFont.resource(.montserratExtraLightItalic, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .light:
        return CocoaFont.resource(.montserratLightItalic, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .regular:
        return CocoaFont.resource(.montserratItalic, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .medium:
        return CocoaFont.resource(.montserratMediumItalic, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .semibold:
        return CocoaFont.resource(.montserratSemiBoldItalic, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .bold:
        return CocoaFont.resource(.montserratBoldItalic, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .heavy:
        return CocoaFont.resource(.montserratExtraBoldItalic, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      case .black:
        return CocoaFont.resource(.montserratBlackItalic, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
        
      default:
        return CocoaFont.system(ofSize: size, weight: weight)
      }
    }
  }
  
  /// Arimo
  public static func secondary(ofSize size: CGFloat, weight: Weight, style: Style = .default) -> CocoaFont {
    switch style {
    case .default:
      if weight == .regular {
        return CocoaFont.resource(.arimoRegular, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
      }
      
      if weight == .bold {
        return CocoaFont.resource(.arimoBold, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
      }
      
      return .system(ofSize: size, weight: weight)
      
    case .italic:
      if weight == .regular {
        return CocoaFont.resource(.arimoItalic, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
      }
      
      if weight == .bold {
        return CocoaFont.resource(.arimoBoldItalic, ofSize: size)
          .or(.system(ofSize: size, weight: weight))
      }
      
      return .system(ofSize: size, weight: weight)
    }
  }
}
