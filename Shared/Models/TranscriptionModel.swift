import Foundation

enum TranscriptionModel: String, CaseIterable, Identifiable {
    case whisperLargeV3      = "whisper-large-v3"
    case whisperLargeV3Turbo = "whisper-large-v3-turbo"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .whisperLargeV3:      return "Whisper Large v3"
        case .whisperLargeV3Turbo: return "Whisper Large v3 Turbo"
        }
    }

    var desc: String {
        switch self {
        case .whisperLargeV3:      return "High accuracy speech recognition"
        case .whisperLargeV3Turbo: return "216x real-time speed"
        }
    }

    var badge: ModelBadge? {
        switch self {
        case .whisperLargeV3:      return .defaultBadge
        case .whisperLargeV3Turbo: return nil
        }
    }
}

enum ModelBadge {
    case defaultBadge

    var text: String {
        switch self {
        case .defaultBadge: return "Default"
        }
    }
}
