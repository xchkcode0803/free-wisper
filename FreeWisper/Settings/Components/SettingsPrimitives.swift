import SwiftUI

// SectionHeader: eyebrow + hairline rule + optional mono tag on the right.
struct SectionHeader: View {
    @EnvironmentObject var L: LangManager
    let title: String           // localized
    var tag: String? = nil      // localized, optional

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(title)
                .font(FWFont.serif(L.lang == .zh ? 12 : 11, weight: .medium))
                .tracking(L.lang == .zh ? 0.18 * 12 : 0.3 * 11)
                .foregroundColor(FWColor.ink)
                .textCase(L.lang == .en ? .uppercase : nil)
            Rectangle()
                .fill(FWColor.hair)
                .frame(height: 1)
            if let tag {
                Text(tag)
                    .font(FWFont.mono(10))
                    .tracking(L.lang == .zh ? 0.16 * 10 : 0.22 * 10)
                    .foregroundColor(FWColor.ink4)
                    .textCase(L.lang == .en ? .uppercase : nil)
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 28)
        .padding(.bottom, 10)
    }
}

// Card: square corners, hairline ink border, white face.
struct Card<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var topPadding: CGFloat = 0
    var body: some View {
        VStack(spacing: 0) { content() }
            .background(FWColor.card)
            .overlay(Rectangle().stroke(FWColor.hair, lineWidth: 1))
            .padding(.horizontal, 22)
            .padding(.top, topPadding)
    }
}

// FootNote: small italic-EN serif, ink3.
struct FootNote: View {
    @EnvironmentObject var L: LangManager
    let text: String

    var body: some View {
        Text(text)
            .font(FWFont.serif(12))
            .italicInEN(L.lang)
            .tracking(L.lang == .zh ? 0.03 * 12 : 0.01 * 12)
            .foregroundColor(FWColor.ink3)
            .lineSpacing(4)
            .padding(.leading, 26)
            .padding(.trailing, 26)
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Row inner hairline divider (between rows inside a Card).
struct RowDivider: View {
    var body: some View {
        Rectangle()
            .fill(FWColor.hair2)
            .frame(height: 1)
            .padding(.leading, 16)
    }
}

// Square toggle (no rounded corners). On = solid ink + bone knob; Off = hairline + ink knob.
struct FWToggle: View {
    @Binding var isOn: Bool
    var identifier: String? = nil

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            ZStack(alignment: isOn ? .trailing : .leading) {
                Rectangle()
                    .fill(isOn ? FWColor.ink : Color.clear)
                    .frame(width: 48, height: 26)
                    .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
                Rectangle()
                    .fill(isOn ? FWColor.bone : FWColor.ink)
                    .frame(width: 20, height: 20)
                    .padding(.horizontal, 2)
                    .animation(.easeInOut(duration: 0.18), value: isOn)
            }
            .frame(width: 48, height: 26)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(identifier ?? "")
        .accessibilityLabel(identifier ?? "toggle")
        .accessibilityValue(isOn ? "On" : "Off")
    }
}

// Square radio control: 18×18 hairline box; selected = 10×10 ink square inside.
struct RadioSquare: View {
    let selected: Bool
    var size: CGFloat = 18
    var innerSize: CGFloat = 10
    var body: some View {
        ZStack {
            Rectangle().fill(Color.clear)
                .frame(width: size, height: size)
                .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
            if selected {
                Rectangle()
                    .fill(FWColor.ink)
                    .frame(width: innerSize, height: innerSize)
            }
        }
        .frame(width: size, height: size)
        .animation(.easeInOut(duration: 0.12), value: selected)
    }
}

// Hairline bordered chip badge ("DEFAULT" / "FASTEST"). Mono, on bone fill.
struct ChipBadge: View {
    @EnvironmentObject var L: LangManager
    let text: String
    var body: some View {
        Text(text)
            .font(FWFont.mono(L.lang == .zh ? 10 : 9, weight: .medium))
            .tracking(L.lang == .zh ? 0.14 * 10 : 0.22 * 9)
            .foregroundColor(FWColor.ink)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(FWColor.bone)
            .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
    }
}

// "Ink button" — uppercase / heavily tracked sans label. Two variants: solid or outline.
struct InkButton: View {
    @EnvironmentObject var L: LangManager
    enum Variant { case solid, outline }
    let title: String
    let variant: Variant
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(FWFont.sans(L.lang == .zh ? 12 : 11, weight: .medium))
                .tracking(L.lang == .zh ? 0.12 * 12 : 0.22 * 11)
                .foregroundColor(variant == .solid ? FWColor.bone : FWColor.ink)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(variant == .solid ? FWColor.ink : Color.clear)
                .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
                .opacity(disabled ? 0.35 : 1.0)
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}

// Eyebrow / mono tag helper (re-usable inline element).
struct MonoTag: View {
    @EnvironmentObject var L: LangManager
    let text: String
    var size: CGFloat = 10
    var color: Color = FWColor.ink3
    var body: some View {
        Text(text)
            .font(FWFont.mono(size))
            .tracking(L.lang == .zh ? 0.16 * size : 0.22 * size)
            .foregroundColor(color)
            .textCase(L.lang == .en ? .uppercase : nil)
    }
}

// Hairline "/" 1px box used for the masthead numeral pad ("01", "02", "03").
struct NumberCell: View {
    let label: String
    let filled: Bool
    var body: some View {
        ZStack {
            Rectangle()
                .fill(filled ? FWColor.ink : Color.clear)
                .frame(width: 22, height: 22)
                .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
            Text(label)
                .font(FWFont.mono(11))
                .foregroundColor(filled ? FWColor.bone : FWColor.ink)
        }
        .frame(width: 22, height: 22)
    }
}
