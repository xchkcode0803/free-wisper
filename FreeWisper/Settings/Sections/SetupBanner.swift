import SwiftUI

struct SetupStep: Identifiable {
    let id: String
    let label: String
    let cta: String
    let doneSub: String
    let done: Bool
}

struct SetupBanner: View {
    @EnvironmentObject var L: LangManager
    let steps: [SetupStep]
    let onTap: (SetupStep) -> Void

    private var doneCount: Int { steps.filter { $0.done }.count }
    private var allDone: Bool { doneCount == steps.count }

    var body: some View {
        VStack(spacing: 0) {
            // Top row: eyebrow + title + count
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    MonoTag(text: allDone ? L.t("setup.eyebrow.done") : L.t("setup.eyebrow.todo"),
                            size: 10.5, color: FWColor.ink4)
                    Text(allDone ? L.t("setup.title.done") : L.t("setup.title.todo"))
                        .font(FWFont.serif(21, weight: .medium))
                        .tracking(L.lang == .zh ? 0.02 * 21 : 0.01 * 21)
                        .foregroundColor(FWColor.ink)
                }
                Spacer()
                Text("\(doneCount)/\(steps.count)")
                    .font(FWFont.mono(13))
                    .tracking(0.1 * 13)
                    .foregroundColor(FWColor.ink)
                    .monospacedDigit()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .overlay(
                Rectangle().fill(FWColor.ink).frame(height: 1),
                alignment: .bottom
            )

            // Step rows
            VStack(spacing: 0) {
                ForEach(Array(steps.enumerated()), id: \.element.id) { idx, step in
                    Button(action: { onTap(step) }) {
                        HStack(spacing: 14) {
                            NumberCell(
                                label: step.done ? "✓" : String(format: "%02d", idx + 1),
                                filled: step.done
                            )
                            VStack(alignment: .leading, spacing: 2) {
                                Text(step.label)
                                    .font(FWFont.serif(16, weight: .medium))
                                    .tracking(L.lang == .zh ? 0.02 * 16 : 0.005 * 16)
                                    .foregroundColor(FWColor.ink)
                                    .multilineTextAlignment(.leading)
                                Text(step.done ? step.doneSub : step.cta)
                                    .font(FWFont.serif(12))
                                    .italicInEN(L.lang)
                                    .tracking(L.lang == .zh ? 0.03 * 12 : 0.02 * 12)
                                    .foregroundColor(FWColor.ink3)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer(minLength: 4)
                            if !step.done {
                                Text("↗")
                                    .font(FWFont.mono(10))
                                    .tracking(0.2 * 10)
                                    .foregroundColor(FWColor.ink)
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(step.done ? "\(step.label), \(step.doneSub)" : step.label)
                    if idx < steps.count - 1 {
                        Rectangle().fill(FWColor.hair2).frame(height: 1)
                    }
                }
            }
        }
        .background(FWColor.bone)
        .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
        .padding(.horizontal, 22)
        .padding(.top, 6)
        .padding(.bottom, 4)
    }
}
