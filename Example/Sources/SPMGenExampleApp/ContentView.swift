import SPMGenExampleResources
import SwiftUI

public struct ContentView: View {
  public init() {}

  public var body: some View {
    NavigationView {
      #if os(iOS)
        List {
          systemFontsContent()
          customFontsContent()
        }
        .navigationBarTitle("SPMGenExample")
        .navigationBarItems(
          leading: NavigationLink(
            "Color",
            destination: colorContent()
          ),
          trailing: NavigationLink(
            "Image",
            destination: imageContent()
          )
        )
      #elseif os(macOS)
        List {
          NavigationLink(
            "Image",
            destination: imageContent()
          )
          NavigationLink(
            "Color",
            destination: colorContent()
          )
          NavigationLink(
            "Fonts",
            destination: List {
              systemFontsContent()
              customFontsContent()
            }
          )
        }
      #endif
    }
  }

  private func systemFontsContent() -> some View {
    let fontWeights: [Font.Weight] = [
      .ultraLight, .thin, .light,
      .regular, .medium, .semibold,
      .bold, .heavy, .black,
    ]
    return Section(header: Text("System")) {
      ForEach(fontWeights, id: \.self) { fontWeight in
        Text("SystemFont." + String(describing: fontWeight))
          .font(.system(size: 14, weight: fontWeight))
          .padding()
      }
    }
  }

  private func customFontsContent() -> some View {
    Section(header: Text("Custom")) {
      ForEach(CocoaFont.customFonts, id: \.name) { font in
        Text(font.name)
          .font(.resource(font, size: 14))
          .padding()
      }
    }
  }

  private func colorContent() -> some View {
    Color
      .resource(.colorExample)
      .overlay(DimmView())
      .edgesIgnoringSafeArea(.all)
      .overlay(CurrentColorSchemeLabel())
  }

  private func imageContent() -> some View {
    Image
      .resource(.imageExample)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .overlay(DimmView())
      .edgesIgnoringSafeArea(.all)
      .overlay(CurrentColorSchemeLabel())
  }
}

private struct DimmView: View {
  @Environment(\.colorScheme)
  private var colorScheme

  var body: some View {
    VStack {
      LinearGradient(
        gradient: Gradient(
          colors: [
            (colorScheme == .dark ? .black : .white),
            .clear,
          ]
        ),
        startPoint: .top,
        endPoint: .bottom
      )
      Spacer()
    }
  }
}

private struct CurrentColorSchemeLabel: View {
  @Environment(\.colorScheme)
  private var colorScheme

  var body: some View {
    HStack {
      Text("ColorScheme:")
        .font(
          Font(
            colorScheme == .dark
              ? CocoaFont.primary(ofSize: 18, weight: .bold)
              : CocoaFont.secondary(ofSize: 18, weight: .bold)
          )
        )
      Text("\(name(for: colorScheme))")
        .font(.system(size: 18, weight: .regular))
    }
    .padding()
    .background(
      (colorScheme == .dark ? Color.black : .white)
        .opacity(0.4)
    )
    .cornerRadius(8)
  }

  private func name(for colorSheme: ColorScheme) -> String {
    switch colorScheme {
    case .light: return "Light"
    case .dark: return "Dark"
    default: return "Unknown"
    }
  }
}
