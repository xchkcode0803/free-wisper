import Foundation

enum GroqError: Error, LocalizedError {
    case missingKey
    case unauthorized
    case http(Int)
    case decoding
    case network(Error)

    var errorDescription: String? {
        switch self {
        case .missingKey:   return "No API key set — open Free Wisper app"
        case .unauthorized: return "Invalid key"
        case .http(let s):  return "HTTP \(s)"
        case .decoding:     return "Could not parse response"
        case .network(let e): return e.localizedDescription
        }
    }
}
