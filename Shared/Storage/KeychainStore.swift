import Foundation
import Security

final class KeychainStore {
    static let shared = KeychainStore()

    private let service = "com.freewisper.apikey"
    private let account = "groq"

    private init() {}

    @discardableResult
    func saveAPIKey(_ key: String) -> Bool {
        let data = Data(key.utf8)
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        SecItemDelete(query as CFDictionary)

        var attrs = query
        attrs[kSecValueData as String] = data
        attrs[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock

        let status = SecItemAdd(attrs as CFDictionary, nil)
        if status == errSecSuccess {
            SharedDefaults.shared.apiKeyFallback = nil
            return true
        }

        #if DEBUG
        // Simulator fallback: unsigned local builds can fail Keychain access without entitlements.
        // Release builds keep the API key out of UserDefaults and require the shared Keychain group.
        SharedDefaults.shared.apiKeyFallback = key
        #else
        SharedDefaults.shared.apiKeyFallback = nil
        #endif
        return false
    }

    func loadAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String:  true,
            kSecMatchLimit as String:  kSecMatchLimitOne,
        ]
        var ref: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &ref)
        if status == errSecSuccess, let data = ref as? Data, let s = String(data: data, encoding: .utf8) {
            return s
        }
        #if DEBUG
        return SharedDefaults.shared.apiKeyFallback
        #else
        return nil
        #endif
    }

    @discardableResult
    func deleteAPIKey() -> Bool {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        SecItemDelete(query as CFDictionary)
        SharedDefaults.shared.apiKeyFallback = nil
        return true
    }

    var hasAPIKey: Bool {
        if let k = loadAPIKey(), !k.isEmpty { return true }
        return false
    }
}
