import SwiftUI

struct AboutSheet: View {
    @EnvironmentObject var L: LangManager
    let onClose: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                MonoTag(text: L.t("sheet.eyebrow"), color: FWColor.ink3)
                    .padding(.bottom, 6)

                Text(L.t("sheet.title"))
                    .font(FWFont.serif(26, weight: .semibold))
                    .tracking(L.lang == .zh ? 0.02 * 26 : 0.005 * 26)
                    .foregroundColor(FWColor.ink)
                    .padding(.bottom, 16)

                VStack(alignment: .leading, spacing: 14) {
                    Text(L.t("sheet.p1"))
                    // p2 — emphasized "your" / "你自己的" with underline/bold
                    HStack(spacing: 0) {
                        Text(L.t("sheet.p2.before"))
                            + Text(L.t("sheet.p2.em"))
                                .italic()
                                .underline(true, color: FWColor.ink)
                            + Text(L.t("sheet.p2.after"))
                    }
                    Text(L.t("sheet.p3"))
                    Text(L.t("sheet.p4"))
                        .foregroundColor(FWColor.ink3)
                        .italic()
                }
                .font(FWFont.serif(15))
                .tracking(L.lang == .zh ? 0.03 * 15 : 0.005 * 15)
                .foregroundColor(FWColor.ink)
                .lineSpacing(8)

                Button(action: onClose) {
                    Text(L.t("sheet.done"))
                        .font(FWFont.sans(L.lang == .zh ? 13 : 11, weight: .medium))
                        .tracking(L.lang == .zh ? 0.16 * 13 : 0.28 * 11)
                        .foregroundColor(FWColor.bone)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(FWColor.ink)
                        .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
                        .textCase(L.lang == .en ? .uppercase : nil)
                }
                .buttonStyle(.plain)
                .padding(.top, 24)
                .accessibilityIdentifier("aboutDone")
            }
            .padding(.horizontal, 26)
            .padding(.top, 16)
            .padding(.bottom, 36)
        }
        .background(FWColor.bone.ignoresSafeArea())
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
