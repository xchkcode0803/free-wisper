import SwiftUI

struct FooterSection: View {
    @EnvironmentObject var L: LangManager
    let onAbout: () -> Void
    let onClearKey: () -> Void
    let hasApiKey: Bool

    var body: some View {
        VStack(spacing: 0) {
            SectionHeader(title: L.t("sec.about.title"))
            Card {
                Button(action: onAbout) {
                    HStack(spacing: 12) {
                        Text(L.t("about.privacy"))
                            .font(FWFont.serif(16, weight: .medium))
                            .tracking(L.lang == .zh ? 0.02 * 16 : 0.005 * 16)
                            .foregroundColor(FWColor.ink)
                        Spacer()
                        MonoTag(text: L.t("about.read"), color: FWColor.ink)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("privacyRow")
                .accessibilityLabel(L.t("about.privacy"))

                Rectangle().fill(FWColor.hair2).frame(height: 1)

                Link(destination: URL(string: "https://github.com/xchkcode0803/free-wisper")!) {
                    HStack(spacing: 12) {
                        Text(L.t("about.source"))
                            .font(FWFont.serif(16, weight: .medium))
                            .tracking(L.lang == .zh ? 0.02 * 16 : 0.005 * 16)
                            .foregroundColor(FWColor.ink)
                        Spacer()
                        ExternalGlyph(size: 12, color: FWColor.ink)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .contentShape(Rectangle())
                }
            }

            if hasApiKey {
                Button(action: onClearKey) {
                    Text(L.t("about.clear"))
                        .font(FWFont.sans(L.lang == .zh ? 13 : 11, weight: .medium))
                        .tracking(L.lang == .zh ? 0.14 * 13 : 0.24 * 11)
                        .foregroundColor(FWColor.ink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.clear)
                        .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
                        .textCase(L.lang == .en ? .uppercase : nil)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 22)
                .padding(.top, 20)
                .accessibilityIdentifier("clearKeyButton")
            }

            VStack(spacing: 0) {
                Text("Free Wisper · v1.0.0 (1)")
                Text(L.t("about.footer1"))
                Text(L.t("about.footer2"))
            }
            .multilineTextAlignment(.center)
            .font(FWFont.serif(11.5))
            .italicInEN(L.lang)
            .tracking(L.lang == .zh ? 0.06 * 11.5 : 0.1 * 11.5)
            .foregroundColor(FWColor.ink4)
            .lineSpacing(11.5) // generous 2.0 leading
            .padding(.horizontal, 24)
            .padding(.top, 36)
            .padding(.bottom, 48)
            .frame(maxWidth: .infinity)
        }
    }
}
