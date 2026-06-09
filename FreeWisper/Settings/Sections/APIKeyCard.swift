import SwiftUI
import UIKit

enum TestStatus { case idle, testing, ok, fail }

struct APIKeyCard: View {
    @EnvironmentObject var L: LangManager
    @Binding var apiKey: String
    @Binding var testStatus: TestStatus
    let onTest: () -> Void
    let onPaste: () -> Void
    @State private var show: Bool = false

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    // Eyebrow row
                    HStack(spacing: 8) {
                        LockGlyph(size: 11, color: FWColor.ink3)
                        MonoTag(text: L.t("key.stored"))
                    }
                    .padding(.bottom, 10)

                    // Input row with hairline bottom border
                    HStack(spacing: 8) {
                        Group {
                            if show {
                                TextField("Groq API key", text: $apiKey)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled(true)
                            } else {
                                SecureField("Groq API key", text: $apiKey)
                            }
                        }
                        .font(FWFont.mono(14))
                        .foregroundColor(FWColor.ink)

                        Button { show.toggle() } label: {
                            EyeGlyph(size: 18, color: FWColor.ink3, off: show)
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 8)
                    .overlay(
                        Rectangle().fill(FWColor.ink).frame(height: 1),
                        alignment: .bottom
                    )

                    // Button row
                    HStack(spacing: 8) {
                        InkButton(title: L.t("key.paste"), variant: .outline, action: onPaste)
                        InkButton(
                            title: testStatus == .testing ? L.t("key.testing") : L.t("key.test"),
                            variant: .solid,
                            disabled: apiKey.isEmpty || testStatus == .testing,
                            action: onTest
                        )
                        if testStatus == .ok {
                            HStack(spacing: 6) {
                                ZStack {
                                    Rectangle().fill(Color.clear)
                                        .frame(width: 16, height: 16)
                                        .overlay(Rectangle().stroke(FWColor.ink, lineWidth: 1))
                                    Text("✓").font(FWFont.mono(10)).foregroundColor(FWColor.ink)
                                }
                                Text(L.t("key.ok"))
                                    .font(FWFont.serif(13))
                                    .italicInEN(L.lang)
                                    .foregroundColor(FWColor.ink)
                            }
                            .transition(.opacity)
                        }
                        if testStatus == .fail {
                            Text(L.t("key.fail"))
                                .font(FWFont.serif(13))
                                .italicInEN(L.lang)
                                .foregroundColor(FWColor.ink)
                                .overlay(Rectangle().fill(FWColor.ink).frame(height: 1),
                                         alignment: .bottom)
                                .transition(.opacity)
                        }
                        Spacer()
                    }
                    .padding(.top, 14)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)

                // Hairline divider + "Get a free Groq API key" link
                Rectangle().fill(FWColor.hair2).frame(height: 1)
                Link(destination: URL(string: "https://console.groq.com/keys")!) {
                    HStack(spacing: 8) {
                        Text(L.t("key.getlink"))
                            .font(FWFont.serif(13))
                            .italicInEN(L.lang)
                            .foregroundColor(FWColor.ink)
                            .overlay(Rectangle().fill(FWColor.ink).frame(height: 1),
                                     alignment: .bottom)
                        ExternalGlyph(size: 10, color: FWColor.ink)
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                }
            }
        }
    }
}
