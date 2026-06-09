import SwiftUI

// Typography helpers for the museum / editorial aesthetic.
//
// - Serif (system "New York" via .serif design) is the body face. For EN text we
//   render it italic; for ZH the system falls back to PingFang which already reads as
//   a serif/song equivalent and italic is suppressed.
// - Monospace (system) is reserved for eyebrows, tags, numerals, and "READ"/timer
//   chips.
// - Sans (system default) is the button face — uppercase + heavily tracked in EN,
//   normal-cased + lightly tracked in ZH.

enum FWFont {
    static func serif(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
    static func mono(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
    static func sans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }
}

/// View modifier that runs italic only in EN. Apply to serif Text.
struct ItalicInEN: ViewModifier {
    let lang: AppLanguage
    func body(content: Content) -> some View {
        if lang == .en { content.italic() } else { content }
    }
}

extension View {
    func italicInEN(_ lang: AppLanguage) -> some View {
        self.modifier(ItalicInEN(lang: lang))
    }
}

extension Text {
    /// Masthead "Free / Wisper" big serif title.
    func masthead() -> some View {
        self.font(FWFont.serif(40, weight: .semibold))
            .tracking(0.005 * 40) // 0.005em
            .foregroundColor(FWColor.ink)
            .lineSpacing(0)
    }
}
