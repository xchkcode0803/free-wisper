import SwiftUI

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

// Museum / editorial palette — INK on PAPER/BONE.
// All semantic accents (success / danger / AI) collapse into ink-on-paper variations.
enum FWColor {
    static let ink              = Color(hex: 0x0A0A0A)      // primary text, all borders, all "active" fills
    static let ink3             = Color(hex: 0x5C5C5C)      // secondary text, sub-labels
    static let ink4             = Color(hex: 0x8A8A8A)      // tertiary / muted eyebrows
    static let hair             = Color(red: 10/255, green: 10/255, blue: 10/255, opacity: 0.14)
    static let hair2            = Color(red: 10/255, green: 10/255, blue: 10/255, opacity: 0.06)
    static let paper            = Color(hex: 0xF2EFE7)      // screen background
    static let bone             = Color(hex: 0xFBF9F3)      // banner / chip / sheet background, contrasting button face
    static let card             = Color.white                // card body
    static let overlay          = Color(red: 10/255, green: 10/255, blue: 10/255, opacity: 0.45)

    // Mic states still need distinct fills — but they're all ink-on-bone or bone-on-ink, not iOS colors.
    static let micOuter         = ink
    static let micInner         = bone

    // Legacy aliases (so any not-yet-touched call site doesn't break before we sweep them).
    static let accentBlue       = ink
    static let dangerRed        = ink
    static let successGreen     = ink
    static let successGreenDark = ink
    static let accentBlueDark   = ink
    static let aiPurple         = ink
    static let aiIndigo         = ink
    static let aiPurpleText     = ink
    static let groupedBackground = paper
    static let secondaryFill    = bone
    static let groupedBackgroundAlt = bone
    static let keyboardBgTop    = bone
    static let keyboardBgBottom = bone
    static let cornerButtonBg   = bone
    static let micOuterIdle     = ink
    static let micOuterActive   = ink
    static let label            = ink
    static let secondaryLabel   = ink3
    static let tertiaryLabel    = ink4
    static let placeholderLabel = ink4
    static let separator        = hair
    static let badgeOrangeBg    = bone
    static let badgeOrangeText  = ink
    static let accentBlueChip   = bone
    static let toggleOffTrack   = Color.clear
}
