import Foundation

final class SharedDefaults {
    static let appGroupID = "group.com.freewisper.shared"

    static let shared = SharedDefaults()

    let defaults: UserDefaults

    private init() {
        self.defaults = UserDefaults(suiteName: SharedDefaults.appGroupID) ?? .standard
    }

    private enum Key {
        static let transcriptionModelId   = "transcriptionModelId"
        static let cleanupEnabled         = "cleanupEnabled"
        static let cleanupModelId         = "cleanupModelId"
        static let cleanupStyleId         = "cleanupStyleId"
        static let keyboardDidLoadAt      = "keyboardDidLoadAt"
        static let keyboardHasFullAccess  = "keyboardHasFullAccess"
        static let apiKeyFallback         = "apiKeyFallback" // used in simulator when keychain unavailable
    }

    var transcriptionModelId: String {
        get { defaults.string(forKey: Key.transcriptionModelId) ?? TranscriptionModel.whisperLargeV3.rawValue }
        set { defaults.set(newValue, forKey: Key.transcriptionModelId) }
    }

    var cleanupEnabled: Bool {
        get { defaults.bool(forKey: Key.cleanupEnabled) }
        set { defaults.set(newValue, forKey: Key.cleanupEnabled) }
    }

    var cleanupModelId: String {
        get { defaults.string(forKey: Key.cleanupModelId) ?? CleanupModel.gptOss120b.rawValue }
        set { defaults.set(newValue, forKey: Key.cleanupModelId) }
    }

    var cleanupStyleId: String {
        get { defaults.string(forKey: Key.cleanupStyleId) ?? CleanupStyle.light.rawValue }
        set { defaults.set(newValue, forKey: Key.cleanupStyleId) }
    }

    var keyboardDidLoadAt: Date? {
        get { defaults.object(forKey: Key.keyboardDidLoadAt) as? Date }
        set { defaults.set(newValue, forKey: Key.keyboardDidLoadAt) }
    }

    var keyboardHasFullAccess: Bool {
        get { defaults.bool(forKey: Key.keyboardHasFullAccess) }
        set { defaults.set(newValue, forKey: Key.keyboardHasFullAccess) }
    }

    var apiKeyFallback: String? {
        get { defaults.string(forKey: Key.apiKeyFallback) }
        set { defaults.set(newValue, forKey: Key.apiKeyFallback) }
    }
}
