import Foundation
import SwiftUI

enum KeyboardState: Equatable {
    case idle
    case recording(startedAt: Date)
    case transcribing
    case cleaning
    case error(message: String)
}

@MainActor
final class VoiceKeyboardViewModel: ObservableObject {
    @Published var state: KeyboardState = .idle
    @Published var elapsed: Double = 0

    weak var inputViewController: KeyboardViewController?

    private let recorder = AudioRecorder()
    private var timer: Timer?
    private var errorTimer: Timer?

    var hasAPIKey: Bool { KeychainStore.shared.hasAPIKey }

    var transcriptionModel: TranscriptionModel {
        TranscriptionModel(rawValue: SharedDefaults.shared.transcriptionModelId) ?? .whisperLargeV3
    }
    var cleanupEnabled: Bool { SharedDefaults.shared.cleanupEnabled }
    var cleanupModel: CleanupModel {
        CleanupModel(rawValue: SharedDefaults.shared.cleanupModelId) ?? .gptOss120b
    }
    var cleanupStyle: CleanupStyle {
        CleanupStyle(rawValue: SharedDefaults.shared.cleanupStyleId) ?? .light
    }

    // MARK: - Gesture entry points

    func pressStart() {
        guard hasAPIKey else {
            setError("No API key set — open Free Wisper app")
            return
        }
        do {
            _ = try recorder.start()
            startTimer()
            state = .recording(startedAt: Date())
        } catch {
            setError("Mic unavailable — check Full Access")
        }
    }

    func pressEnd() {
        guard case .recording(let started) = state else { return }
        stopTimer()
        let dur = Date().timeIntervalSince(started)
        if dur < 0.25 {
            recorder.cancel()
            state = .idle
            return
        }
        finishRecording()
    }

    func cancelDrag() {
        guard case .recording = state else { return }
        stopTimer()
        recorder.cancel()
        state = .idle
    }

    // MARK: - Internals

    private func finishRecording() {
        guard let audioURL = recorder.stop() else {
            setError("Recording failed")
            return
        }
        state = .transcribing

        Task { [weak self] in
            guard let self else { return }
            await self.performTranscription(url: audioURL)
        }
    }

    private func performTranscription(url audioURL: URL) async {
        guard let key = KeychainStore.shared.loadAPIKey() else {
            await MainActor.run { self.setError("No API key set — open Free Wisper app") }
            return
        }
        let client = GroqClient(apiKey: key)
        do {
            let raw = try await client.transcribe(audio: audioURL, model: transcriptionModel)
            try? FileManager.default.removeItem(at: audioURL)

            if cleanupEnabled {
                await MainActor.run { self.state = .cleaning }
                let final: String
                do {
                    final = try await client.cleanup(text: raw, model: cleanupModel, style: cleanupStyle)
                } catch {
                    final = raw
                }
                await MainActor.run {
                    self.insert(final)
                    self.state = .idle
                }
            } else {
                await MainActor.run {
                    self.insert(raw)
                    self.state = .idle
                }
            }
        } catch GroqError.unauthorized {
            try? FileManager.default.removeItem(at: audioURL)
            await MainActor.run { self.setError("Invalid API key") }
        } catch {
            try? FileManager.default.removeItem(at: audioURL)
            await MainActor.run { self.setError("Couldn't transcribe — try again") }
        }
    }

    private func insert(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let proxy = inputViewController?.textDocumentProxy
        let before = proxy?.documentContextBeforeInput ?? ""

        var insert = trimmed
        if let last = before.last, !last.isWhitespace && !".!?,;:".contains(last) {
            insert = " " + insert
        }
        if !insert.hasSuffix(" ") { insert += " " }
        proxy?.insertText(insert)
    }

    private func setError(_ msg: String) {
        state = .error(message: msg)
        errorTimer?.invalidate()
        errorTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self else { return }
                if case .error = self.state { self.state = .idle }
            }
        }
    }

    // MARK: - Timer

    private func startTimer() {
        elapsed = 0
        timer?.invalidate()
        let started = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self else { return }
                self.elapsed = Date().timeIntervalSince(started)
                if self.elapsed >= 60 {
                    if case .recording = self.state {
                        self.stopTimer()
                        self.finishRecording()
                    }
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Keyboard buttons

    func switchKeyboard() {
        inputViewController?.advanceToNextInputMode()
    }

    func longPressGlobe() {
        inputViewController?.handleInputModeList(from: UIView(), with: UIEvent())
    }

    func backspace() {
        inputViewController?.textDocumentProxy.deleteBackward()
    }

    var errorText: String? {
        if case .error(let m) = state { return m }
        return nil
    }

    var helperHint: String? {
        switch state {
        case .idle:      return "Drag off the mic to cancel · 60s max"
        case .recording: return "Release to transcribe"
        default:         return nil
        }
    }
}
