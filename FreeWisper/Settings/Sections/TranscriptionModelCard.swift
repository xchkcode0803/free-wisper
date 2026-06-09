import SwiftUI

struct TranscriptionModelCard: View {
    @EnvironmentObject var L: LangManager
    @Binding var selected: TranscriptionModel

    var body: some View {
        Card {
            ForEach(Array(TranscriptionModel.allCases.enumerated()), id: \.element.id) { idx, model in
                ModelRadioRow(
                    selected: selected == model,
                    name: model.displayName,
                    desc: L.t(descKey(for: model)),
                    badgeText: badgeText(for: model),
                    onTap: { selected = model }
                )
                if idx < TranscriptionModel.allCases.count - 1 {
                    RowDivider()
                }
            }
        }
    }

    private func descKey(for m: TranscriptionModel) -> String {
        switch m {
        case .whisperLargeV3:      return "trans.m1.desc"
        case .whisperLargeV3Turbo: return "trans.m2.desc"
        }
    }
    private func badgeText(for m: TranscriptionModel) -> String? {
        switch m.badge {
        case .defaultBadge: return L.t("badge.default")
        case nil:           return nil
        }
    }
}

// Shared row for both transcription + cleanup model selection.
struct ModelRadioRow: View {
    @EnvironmentObject var L: LangManager
    let selected: Bool
    let name: String
    let desc: String
    let badgeText: String?
    let onTap: () -> Void
    var compact: Bool = false

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 14) {
                RadioSquare(selected: selected)
                    .padding(.top, 2)
                VStack(alignment: .leading, spacing: 3) {
                    HStack(alignment: .center, spacing: 10) {
                        Text(name)
                            .font(FWFont.serif(16, weight: .medium))
                            .tracking(L.lang == .zh ? 0.02 * 16 : 0.005 * 16)
                            .foregroundColor(FWColor.ink)
                        if let bt = badgeText {
                            ChipBadge(text: bt)
                        }
                    }
                    Text(desc)
                        .font(FWFont.serif(12.5))
                        .italicInEN(L.lang)
                        .tracking(L.lang == .zh ? 0.03 * 12.5 : 0.01 * 12.5)
                        .foregroundColor(FWColor.ink3)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, compact ? 11 : 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
