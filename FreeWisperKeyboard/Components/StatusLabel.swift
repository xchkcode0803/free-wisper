import SwiftUI

struct StatusLabel: View {
    @EnvironmentObject var L: LangManager
    let state: KeyboardState
    let elapsed: Double
    let errorText: String?

    private func fmt(_ s: Double) -> String {
        let m = Int(s) / 60
        let r = Int(s) % 60
        return String(format: "%d:%02d", m, r)
    }

    var body: some View {
        VStack(spacing: 4) {
            content
        }
        .frame(minHeight: 38)
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle:
            eyebrow(L.t("kbd.idle.eyebrow"))
            main(L.t("kbd.idle.main"))
        case .recording:
            eyebrow(L.t("kbd.rec.eyebrow"))
            HStack(spacing: 10) {
                Text(fmt(elapsed))
                    .font(FWFont.mono(14))
                    .tracking(0.06 * 14)
                    .foregroundColor(FWColor.ink)
                    .monospacedDigit()
                if elapsed >= 50 {
                    Text(L.lang == .zh
                         ? "\(L.t("kbd.rec.left")) \(60 - Int(elapsed))s"
                         : "\(60 - Int(elapsed))s \(L.t("kbd.rec.left"))")
                    .font(FWFont.mono(11, weight: .medium))
                    .tracking(0.12 * 11)
                    .foregroundColor(FWColor.ink)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
                }
            }
        case .transcribing:
            eyebrow(L.t("kbd.trans.eyebrow"))
            main(L.t("kbd.trans.main"))
        case .cleaning:
            eyebrow(L.t("kbd.clean.eyebrow"))
            main(L.t("kbd.clean.main"))
        case .error:
            eyebrow(L.t("kbd.err.eyebrow"))
                .foregroundColor(FWColor.ink)
            main(errorText ?? "")
        }
    }

    private func eyebrow(_ s: String) -> some View {
        Text(s)
            .font(FWFont.serif(L.lang == .zh ? 11 : 10.5))
            .tracking(L.lang == .zh ? 0.32 * 11 : 0.4 * 10.5)
            .foregroundColor(FWColor.ink4)
            .textCase(L.lang == .en ? .uppercase : nil)
    }
    private func main(_ s: String) -> some View {
        Text(s)
            .font(FWFont.serif(17, weight: .medium))
            .italicInEN(L.lang)
            .tracking(L.lang == .zh ? 0.06 * 17 : 0.04 * 17)
            .foregroundColor(FWColor.ink)
    }
}
