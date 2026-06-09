import Foundation

enum CleanupModel: String, CaseIterable, Identifiable {
    case gptOss120b = "openai/gpt-oss-120b"
    case gptOss20b  = "openai/gpt-oss-20b"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .gptOss120b: return "GPT-OSS 120B"
        case .gptOss20b:  return "GPT-OSS 20B"
        }
    }

    var desc: String {
        switch self {
        case .gptOss120b: return "OpenAI's open-source flagship, 500 T/sec"
        case .gptOss20b:  return "Fast open-source model, 1000 T/sec"
        }
    }

    var badge: ModelBadge? {
        switch self {
        case .gptOss120b: return .defaultBadge
        case .gptOss20b:  return nil
        }
    }
}
