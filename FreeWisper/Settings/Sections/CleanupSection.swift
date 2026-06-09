import SwiftUI

struct CleanupSection: View {
    @EnvironmentObject var L: LangManager
    @Binding var cleanupOn: Bool
    @Binding var cleanupModel: CleanupModel
    @Binding var cleanupStyle: CleanupStyle

    private let styles: [(CleanupStyle, String, String, String)] = [
        (.light,    "轻", "clean.style.light",  "clean.style.light.desc"),
        (.standard, "常", "clean.style.std",    "clean.style.std.desc"),
        (.email,    "文", "clean.style.email",  "clean.style.email.desc"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            SectionHeader(title: L.t("sec.clean.title"), tag: L.t("sec.clean.tag"))
            Card {
                VStack(spacing: 0) {
                    // Header row: 推 kanji + label + toggle
                    HStack(spacing: 14) {
                        ZStack {
                            Rectangle().fill(FWColor.bone)
                                .frame(width: 32, height: 32)
                                .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
                            Text("推")
                                .font(FWFont.serif(16, weight: .medium))
                                .foregroundColor(FWColor.ink)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(L.t("clean.row.title"))
                                .font(FWFont.serif(16, weight: .medium))
                                .tracking(L.lang == .zh ? 0.02 * 16 : 0.005 * 16)
                                .foregroundColor(FWColor.ink)
                            Text(L.t("clean.row.sub"))
                                .font(FWFont.serif(12))
                                .italicInEN(L.lang)
                                .tracking(L.lang == .zh ? 0.03 * 12 : 0.01 * 12)
                                .foregroundColor(FWColor.ink3)
                        }
                        Spacer()
                        FWToggle(isOn: $cleanupOn, identifier: "cleanupToggle")
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)

                    if cleanupOn {
                        Rectangle().fill(FWColor.hair2).frame(height: 1)
                        cleanupModelPicker
                        Rectangle().fill(FWColor.hair2).frame(height: 1)
                        cleanupStyleChips
                    }
                }
            }
            FootNote(text: L.t("clean.footnote"))
        }
    }

    private var cleanupModelPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            MonoTag(text: L.t("clean.model.label"))
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 4)
            VStack(spacing: 0) {
                ForEach(Array(CleanupModel.allCases.enumerated()), id: \.element.id) { idx, m in
                    ModelRadioRow(
                        selected: cleanupModel == m,
                        name: m.displayName,
                        desc: L.t(cleanupDescKey(for: m)),
                        badgeText: m.badge == .defaultBadge ? L.t("badge.default") : nil,
                        onTap: { cleanupModel = m },
                        compact: true
                    )
                    if idx < CleanupModel.allCases.count - 1 {
                        Rectangle().fill(FWColor.hair2).frame(height: 1)
                    }
                }
            }
        }
    }

    private var cleanupStyleChips: some View {
        VStack(alignment: .leading, spacing: 12) {
            MonoTag(text: L.t("clean.style.label"))

            HStack(spacing: 8) {
                ForEach(styles, id: \.0) { (style, cn, labelKey, _) in
                    Button {
                        cleanupStyle = style
                    } label: {
                        VStack(spacing: 6) {
                            Text(cn)
                                .font(FWFont.serif(22, weight: .semibold))
                                .foregroundColor(cleanupStyle == style ? FWColor.bone : FWColor.ink)
                            Text(L.t(labelKey))
                                .font(FWFont.sans(L.lang == .zh ? 12 : 10.5, weight: .regular))
                                .tracking(L.lang == .zh ? 0.12 * 12 : 0.22 * 10.5)
                                .foregroundColor(cleanupStyle == style ? FWColor.bone : FWColor.ink)
                                .textCase(L.lang == .en ? .uppercase : nil)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(cleanupStyle == style ? FWColor.ink : Color.clear)
                        .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("style-\(style.rawValue)")
                }
            }

            // Description with left ink rule
            HStack {
                Rectangle().fill(FWColor.ink).frame(width: 1)
                Text(styleDesc)
                    .font(FWFont.serif(12.5))
                    .italicInEN(L.lang)
                    .tracking(L.lang == .zh ? 0.03 * 12.5 : 0.01 * 12.5)
                    .foregroundColor(FWColor.ink3)
                    .lineSpacing(4)
                    .padding(.leading, 11)
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 18)
        .padding(.top, 16)
        .padding(.bottom, 18)
    }

    private var styleDesc: String {
        switch cleanupStyle {
        case .light:    return L.t("clean.style.light.desc")
        case .standard: return L.t("clean.style.std.desc")
        case .email:    return L.t("clean.style.email.desc")
        }
    }
    private func cleanupDescKey(for m: CleanupModel) -> String {
        switch m {
        case .gptOss120b: return "clean.m1.desc"
        case .gptOss20b:  return "clean.m2.desc"
        }
    }
}
