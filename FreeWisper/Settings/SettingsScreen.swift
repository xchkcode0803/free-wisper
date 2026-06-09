import SwiftUI

struct SettingsScreen: View {
    @StateObject private var vm = SettingsViewModel()
    @EnvironmentObject var L: LangManager
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            FWColor.paper.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Masthead()
                        .accessibilityIdentifier("masthead")

                    SetupBanner(steps: setupSteps()) { step in
                        if step.id == "kb" || step.id == "fa" {
                            vm.toggleDemoStep(step.id)
                        }
                    }
                    .accessibilityIdentifier("setupBanner")
                    .padding(.top, 22)

                    SectionHeader(title: L.t("sec.key.title"), tag: L.t("sec.key.tag"))
                    APIKeyCard(
                        apiKey: $vm.apiKey,
                        testStatus: $vm.testStatus,
                        onTest:  { vm.testKey() },
                        onPaste: { vm.pasteFromClipboard() }
                    )
                    .accessibilityIdentifier("apiKeyCard")
                    FootNote(text: L.t("key.footnote"))

                    SectionHeader(title: L.t("sec.trans.title"), tag: L.t("sec.trans.tag"))
                    TranscriptionModelCard(selected: $vm.transcriptionModel)
                        .accessibilityIdentifier("transcriptionCard")

                    CleanupSection(
                        cleanupOn:   $vm.cleanupEnabled,
                        cleanupModel: $vm.cleanupModel,
                        cleanupStyle: $vm.cleanupStyle
                    )
                    .accessibilityIdentifier("cleanupSection")

                    FooterSection(
                        onAbout:    { vm.aboutSheetOpen = true },
                        onClearKey: { vm.clearKey() },
                        hasApiKey:  vm.hasApiKey
                    )
                    .accessibilityIdentifier("footerSection")
                }
            }
        }
        .sheet(isPresented: $vm.aboutSheetOpen) {
            AboutSheet(onClose: { vm.aboutSheetOpen = false })
                .environmentObject(L)
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { vm.refreshFromDefaults() }
        }
    }

    private func setupSteps() -> [SetupStep] {
        [
            SetupStep(id: "kb",
                      label: L.t("setup.kb.label"),
                      cta: L.t("setup.kb.cta"),
                      doneSub: L.t("setup.kb.done"),
                      done: vm.keyboardInstalled),
            SetupStep(id: "fa",
                      label: L.t("setup.fa.label"),
                      cta: L.t("setup.fa.cta"),
                      doneSub: L.t("setup.fa.done"),
                      done: vm.keyboardHasFullAccess),
            SetupStep(id: "key",
                      label: L.t("setup.key.label"),
                      cta: vm.hasApiKey ? L.t("setup.key.cta_done") : L.t("setup.key.cta"),
                      doneSub: L.t("setup.key.done"),
                      done: vm.hasApiKey),
        ]
    }
}

// Masthead: vintage editorial — "No.001 · SETTINGS · v1.0" eyebrow row, large
// stacked "Free / Wisper" serif title, italic subtitle, lang toggle on the right.
struct Masthead: View {
    @EnvironmentObject var L: LangManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Eyebrow row: No.001 · SECTION · v1.0 + lang toggle
            HStack(alignment: .center) {
                MonoTag(text: L.t("mast.no"), size: 9.5)
                Spacer()
                MonoTag(text: L.t("mast.section"), size: 9.5)
                Spacer()
                MonoTag(text: L.t("mast.version"), size: 9.5)
            }
            .padding(.bottom, 2)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Free")
                    Text("Wisper")
                }
                .font(FWFont.serif(40, weight: .semibold))
                .tracking(0.005 * 40)
                .foregroundColor(FWColor.ink)
                .lineSpacing(0)
                Spacer()
                LangToggle()
            }

            Text(L.t("mast.subtitle"))
                .font(FWFont.serif(12.5))
                .italicInEN(L.lang)
                .tracking(0.04 * 12.5)
                .foregroundColor(FWColor.ink3)
                .lineSpacing(4)
                .frame(maxWidth: 300, alignment: .leading)
        }
        .padding(.horizontal, 22)
        .padding(.top, 14)
        .padding(.bottom, 22)
        .overlay(
            Rectangle().fill(FWColor.ink).frame(height: 1),
            alignment: .bottom
        )
    }
}

// Bilingual toggle: two cells separated by an ink hairline. Active = ink fill / bone text.
struct LangToggle: View {
    @EnvironmentObject var L: LangManager

    var body: some View {
        HStack(spacing: 0) {
            cell("EN", active: L.lang == .en, action: { L.lang = .en })
                .accessibilityIdentifier("lang-en")
            Rectangle().fill(FWColor.ink).frame(width: 1)
            cell("中文", active: L.lang == .zh, action: { L.lang = .zh })
                .accessibilityIdentifier("lang-zh")
        }
        .background(FWColor.bone)
        .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
    }

    private func cell(_ text: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .font(FWFont.serif(13, weight: active ? .semibold : .medium))
                .tracking(0.08 * 13)
                .foregroundColor(active ? FWColor.bone : FWColor.ink)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(active ? FWColor.ink : Color.clear)
        }
        .buttonStyle(.plain)
    }
}
