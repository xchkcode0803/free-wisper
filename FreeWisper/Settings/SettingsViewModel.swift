import Foundation
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var apiKey: String = "" {
        didSet { persistKey() }
    }
    @Published var transcriptionModel: TranscriptionModel {
        didSet { SharedDefaults.shared.transcriptionModelId = transcriptionModel.rawValue }
    }
    @Published var cleanupEnabled: Bool {
        didSet { SharedDefaults.shared.cleanupEnabled = cleanupEnabled }
    }
    @Published var cleanupModel: CleanupModel {
        didSet { SharedDefaults.shared.cleanupModelId = cleanupModel.rawValue }
    }
    @Published var cleanupStyle: CleanupStyle {
        didSet { SharedDefaults.shared.cleanupStyleId = cleanupStyle.rawValue }
    }
    @Published var testStatus: TestStatus = .idle
    @Published var keyboardInstalled: Bool = false
    @Published var keyboardHasFullAccess: Bool = false
    @Published var aboutSheetOpen: Bool = false

    private var isUpdatingKey = false

    init() {
        if CommandLine.arguments.contains("-uitest-reset") {
            // Clean slate for UI testing.
            KeychainStore.shared.deleteAPIKey()
            let d = SharedDefaults.shared
            d.keyboardDidLoadAt = nil
            d.keyboardHasFullAccess = false
            d.cleanupEnabled = false
            d.transcriptionModelId = TranscriptionModel.whisperLargeV3.rawValue
            d.cleanupModelId = CleanupModel.gptOss120b.rawValue
            d.cleanupStyleId = CleanupStyle.light.rawValue
        }
        if let i = CommandLine.arguments.firstIndex(of: "-uitest-lang"),
           i + 1 < CommandLine.arguments.count {
            let v = CommandLine.arguments[i + 1]
            UserDefaults.standard.set(v, forKey: "appLanguage")
        }

        let d = SharedDefaults.shared
        self.transcriptionModel = TranscriptionModel(rawValue: d.transcriptionModelId) ?? .whisperLargeV3
        self.cleanupEnabled = d.cleanupEnabled
        self.cleanupModel = CleanupModel(rawValue: d.cleanupModelId) ?? .gptOss120b
        self.cleanupStyle = CleanupStyle(rawValue: d.cleanupStyleId) ?? .light

        // initialise apiKey without triggering persistKey() loop:
        isUpdatingKey = true
        self.apiKey = KeychainStore.shared.loadAPIKey() ?? ""
        isUpdatingKey = false

        refreshFromDefaults()
    }

    var hasApiKey: Bool { !apiKey.isEmpty }

    var setupSteps: [SetupStep] {
        [
            SetupStep(
                id: "kb",
                label: "Add keyboard in iOS Settings",
                cta: "Tap to open Settings →",
                doneSub: "Keyboard installed",
                done: keyboardInstalled
            ),
            SetupStep(
                id: "fa",
                label: "Allow Full Access",
                cta: "Required to reach Groq",
                doneSub: "Network enabled",
                done: keyboardHasFullAccess
            ),
            SetupStep(
                id: "key",
                label: "Add your Groq API key",
                cta: hasApiKey ? "Key stored" : "Paste below ↓",
                doneSub: "Key in Keychain",
                done: hasApiKey
            ),
        ]
    }

    func refreshFromDefaults() {
        let d = SharedDefaults.shared
        keyboardInstalled = d.keyboardDidLoadAt != nil
        keyboardHasFullAccess = d.keyboardHasFullAccess
    }

    // Demo affordance: tap step 1 or 2 toggles fake-install state in the simulator,
    // since real-install detection only works once the user adds the keyboard in iOS Settings.
    func toggleDemoStep(_ id: String) {
        switch id {
        case "kb":
            keyboardInstalled.toggle()
            if keyboardInstalled {
                SharedDefaults.shared.keyboardDidLoadAt = Date()
            } else {
                SharedDefaults.shared.keyboardDidLoadAt = nil
                keyboardHasFullAccess = false
                SharedDefaults.shared.keyboardHasFullAccess = false
            }
        case "fa":
            if keyboardInstalled {
                keyboardHasFullAccess.toggle()
                SharedDefaults.shared.keyboardHasFullAccess = keyboardHasFullAccess
            }
        case "key":
            break
        default: break
        }
    }

    func openKeyboardSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    func pasteFromClipboard() {
        if CommandLine.arguments.contains("-uitest-reset") {
            apiKey = "demo-api-key-for-ui-tests"
            return
        }
        if let s = UIPasteboard.general.string, !s.isEmpty {
            apiKey = s.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    func testKey() {
        guard !apiKey.isEmpty, testStatus != .testing else { return }
        testStatus = .testing
        Task {
            let client = GroqClient(apiKey: apiKey)
            let ok = await client.testKey()
            await MainActor.run {
                self.testStatus = ok ? .ok : .fail
                Task {
                    try? await Task.sleep(nanoseconds: 2_500_000_000)
                    await MainActor.run {
                        if self.testStatus == .ok || self.testStatus == .fail {
                            self.testStatus = .idle
                        }
                    }
                }
            }
        }
    }

    func clearKey() {
        apiKey = ""
        testStatus = .idle
    }

    private func persistKey() {
        guard !isUpdatingKey else { return }
        if apiKey.isEmpty {
            KeychainStore.shared.deleteAPIKey()
        } else {
            KeychainStore.shared.saveAPIKey(apiKey)
        }
    }
}
