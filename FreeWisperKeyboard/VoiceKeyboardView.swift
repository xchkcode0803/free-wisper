import SwiftUI

struct VoiceKeyboardView: View {
    @ObservedObject var vm: VoiceKeyboardViewModel
    @EnvironmentObject var L: LangManager

    var body: some View {
        VStack(spacing: 0) {
            // Top row: globe / Hanko brand / backspace, with a hairline bottom border.
            HStack {
                CornerButton(action: { vm.switchKeyboard() },
                             longPress: { vm.longPressGlobe() }) {
                    GlobeGlyph(size: 20, color: FWColor.ink)
                }
                Spacer()
                Hanko()
                Spacer()
                CornerButton(action: { vm.backspace() }) {
                    BackspaceGlyph(size: 20, color: FWColor.ink)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .overlay(
                Rectangle().fill(FWColor.hair).frame(height: 1),
                alignment: .bottom
            )

            VStack(spacing: 22) {
                MicButton(
                    state: vm.state,
                    size: 108,
                    onPressStart: { vm.pressStart() },
                    onPressEnd:   { vm.pressEnd() },
                    onCancelDrag: { vm.cancelDrag() }
                )
                StatusLabel(state: vm.state, elapsed: vm.elapsed, errorText: vm.errorText)
                if let hint = hint {
                    Text(hint)
                        .font(FWFont.serif(L.lang == .zh ? 11 : 10.5))
                        .tracking(L.lang == .zh ? 0.18 * 11 : 0.22 * 10.5)
                        .foregroundColor(vm.state == .idle ? FWColor.ink4 : FWColor.ink3)
                        .textCase(L.lang == .en ? .uppercase : nil)
                        .padding(.top, -8)
                }
            }
            .padding(.top, 30)
            .padding(.bottom, 16)

            Spacer(minLength: 0)
        }
        .background(FWColor.bone)
        .overlay(
            Rectangle().fill(FWColor.ink).frame(height: 1),
            alignment: .top
        )
    }

    private var hint: String? {
        switch vm.state {
        case .idle:      return L.t("kbd.idle.hint")
        case .recording: return L.t("kbd.rec.hint")
        default:         return nil
        }
    }
}

// "Hanko" seal — universal brand mark, identical in both languages.
struct Hanko: View {
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Rectangle().fill(FWColor.ink).frame(width: 32, height: 32)
                Text("嗫")
                    .font(FWFont.serif(18, weight: .bold))
                    .foregroundColor(FWColor.bone)
            }
            Text("Wisper")
                .font(FWFont.serif(11))
                .tracking(0.38 * 11)
                .foregroundColor(FWColor.ink)
                .textCase(.uppercase)
        }
    }
}
