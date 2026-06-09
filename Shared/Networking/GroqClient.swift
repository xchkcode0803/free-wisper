import Foundation

final class GroqClient {
    let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    // Quick "is this key valid" probe: GET /models.
    func testKey() async -> Bool {
        var req = URLRequest(url: URL(string: "https://api.groq.com/openai/v1/models")!)
        req.httpMethod = "GET"
        req.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        do {
            let (_, resp) = try await session.data(for: req)
            if let http = resp as? HTTPURLResponse, http.statusCode == 200 { return true }
            return false
        } catch {
            return false
        }
    }

    func transcribe(audio: URL, model: TranscriptionModel) async throws -> String {
        var req = URLRequest(url: URL(string: "https://api.groq.com/openai/v1/audio/transcriptions")!)
        req.httpMethod = "POST"
        req.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        let boundary = "Boundary-\(UUID().uuidString)"
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        req.httpBody = try makeMultipartBody(boundary: boundary, audio: audio, model: model.rawValue)

        let (data, resp) = try await session.data(for: req)
        try validate(resp, data: data)
        let parsed = try JSONDecoder().decode(TranscriptionResponse.self, from: data)
        return parsed.text
    }

    func cleanup(text: String, model: CleanupModel, style: CleanupStyle) async throws -> String {
        var req = URLRequest(url: URL(string: "https://api.groq.com/openai/v1/chat/completions")!)
        req.httpMethod = "POST"
        req.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ChatRequest(
            model: model.rawValue,
            temperature: 0.2,
            messages: [
                .init(role: "system", content: style.prompt),
                .init(role: "user",   content: text),
            ]
        )
        req.httpBody = try JSONEncoder().encode(body)

        let (data, resp) = try await session.data(for: req)
        try validate(resp, data: data)
        let parsed = try JSONDecoder().decode(ChatResponse.self, from: data)
        return parsed.choices.first?.message.content ?? text
    }

    private func validate(_ resp: URLResponse, data: Data) throws {
        guard let http = resp as? HTTPURLResponse else { throw GroqError.decoding }
        switch http.statusCode {
        case 200..<300: return
        case 401:       throw GroqError.unauthorized
        default:        throw GroqError.http(http.statusCode)
        }
    }

    private func makeMultipartBody(boundary: String, audio: URL, model: String) throws -> Data {
        var data = Data()
        let crlf = "\r\n"
        let audioData = try Data(contentsOf: audio)
        let filename = audio.lastPathComponent

        func addField(_ name: String, _ value: String) {
            data.append("--\(boundary)\(crlf)".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(name)\"\(crlf)\(crlf)".data(using: .utf8)!)
            data.append("\(value)\(crlf)".data(using: .utf8)!)
        }

        addField("model", model)
        addField("response_format", "json")

        data.append("--\(boundary)\(crlf)".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\(crlf)".data(using: .utf8)!)
        data.append("Content-Type: audio/m4a\(crlf)\(crlf)".data(using: .utf8)!)
        data.append(audioData)
        data.append("\(crlf)".data(using: .utf8)!)
        data.append("--\(boundary)--\(crlf)".data(using: .utf8)!)
        return data
    }
}

struct TranscriptionResponse: Decodable { let text: String }

struct ChatRequest: Encodable {
    let model: String
    let temperature: Double
    let messages: [Message]
    struct Message: Encodable { let role: String; let content: String }
}

struct ChatResponse: Decodable {
    let choices: [Choice]
    struct Choice: Decodable {
        let message: Message
        struct Message: Decodable { let role: String; let content: String }
    }
}
