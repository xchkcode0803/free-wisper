import SwiftUI

@main
struct FreeWisperApp: App {
    @StateObject private var L = LangManager()

    var body: some Scene {
        WindowGroup {
            SettingsScreen()
                .environmentObject(L)
        }
    }
}
