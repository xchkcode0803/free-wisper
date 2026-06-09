import AVFoundation
import Foundation

final class AudioRecorder {
    private var recorder: AVAudioRecorder?

    func start() throws -> URL {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: [])
        try session.setActive(true)

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("m4a")

        let settings: [String: Any] = [
            AVFormatIDKey:            kAudioFormatMPEG4AAC,
            AVSampleRateKey:          16000,
            AVNumberOfChannelsKey:    1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue,
        ]
        let r = try AVAudioRecorder(url: url, settings: settings)
        r.record()
        self.recorder = r
        return url
    }

    func stop() -> URL? {
        let url = recorder?.url
        recorder?.stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
        recorder = nil
        return url
    }

    func cancel() {
        if let url = recorder?.url {
            try? FileManager.default.removeItem(at: url)
        }
        recorder?.stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
        recorder = nil
    }
}
