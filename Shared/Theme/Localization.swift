import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case en
    case zh
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .en: return "EN"
        case .zh: return "中文"
        }
    }
}

/// LangManager — observable, persisted choice. Used through `@EnvironmentObject` or
/// the simpler `@AppStorage("appLanguage")` directly on the root.
@MainActor
final class LangManager: ObservableObject {
    @AppStorage("appLanguage") private var stored: String = AppLanguage.en.rawValue

    var lang: AppLanguage {
        get { AppLanguage(rawValue: stored) ?? .en }
        set { stored = newValue.rawValue; objectWillChange.send() }
    }

    func t(_ key: String) -> String {
        Strings.lookup(key, lang: lang)
    }
}

enum Strings {
    static func lookup(_ key: String, lang: AppLanguage) -> String {
        let dict = (lang == .en) ? en : zh
        return dict[key] ?? en[key] ?? key
    }

    static let en: [String: String] = [
        // Outside chrome
        "chrome.tagline":       "A voice keyboard, by your own hand.",
        "chrome.seg.settings":  "Settings",
        "chrome.seg.keyboard":  "Keyboard",

        // Settings — masthead
        "mast.no":              "No. 001",
        "mast.section":         "SETTINGS",
        "mast.version":         "v1.0",
        "mast.subtitle":        "A voice keyboard for iOS, powered by your own Groq key.",

        // Setup banner
        "setup.eyebrow.todo":   "INITIAL SETUP",
        "setup.eyebrow.done":   "READY",
        "setup.title.todo":     "Finish setup",
        "setup.title.done":     "Ready to dictate",
        "setup.kb.label":       "Add keyboard in iOS Settings",
        "setup.kb.cta":         "Open Settings →",
        "setup.kb.done":        "Keyboard installed",
        "setup.fa.label":       "Allow Full Access",
        "setup.fa.cta":         "Required to reach Groq",
        "setup.fa.done":        "Network enabled",
        "setup.key.label":      "Add your Groq API key",
        "setup.key.cta":        "Paste below",
        "setup.key.cta_done":   "Key stored",
        "setup.key.done":       "Key in Keychain",

        // API key section
        "sec.key.title":        "Groq API key",
        "sec.key.tag":          "API KEY",
        "key.stored":           "STORED IN KEYCHAIN",
        "key.paste":            "PASTE",
        "key.test":             "TEST KEY",
        "key.testing":          "TESTING…",
        "key.ok":               "Key works",
        "key.fail":             "Invalid key",
        "key.getlink":          "Get a free Groq API key",
        "key.footnote":         "Stored in the iOS Keychain and shared with the keyboard extension via App Group. It never leaves your device except in requests to Groq.",

        // Transcription
        "sec.trans.title":      "Transcription model",
        "sec.trans.tag":        "TRANSCRIPTION",
        "trans.m1.desc":        "High accuracy speech recognition.",
        "trans.m2.desc":        "216x real-time speed.",
        "badge.default":        "DEFAULT",

        // Cleanup
        "sec.clean.title":      "AI Cleanup",
        "sec.clean.tag":        "AI CLEANUP",
        "clean.row.title":      "Clean up with AI",
        "clean.row.sub":        "Sends transcript to a Groq LLM",
        "clean.model.label":    "CLEANUP MODEL · MODEL",
        "clean.style.label":    "CLEANUP STYLE · STYLE",
        "clean.m1.desc":        "OpenAI's open-source flagship, 500 T/sec.",
        "clean.m2.desc":        "Fast open-source model, 1000 T/sec.",
        "clean.style.light":    "LIGHT",
        "clean.style.std":      "STANDARD",
        "clean.style.email":    "EMAIL",
        "clean.style.light.desc":"Fix punctuation, capitalization, filler words. Preserve voice.",
        "clean.style.std.desc": "Light plus grammar smoothing for run-ons.",
        "clean.style.email.desc":"Rewrite as clear, email-ready prose.",
        "clean.footnote":       "Cleanup adds 1–2 seconds and uses additional Groq tokens. If it fails, the raw transcript is inserted as a fallback.",

        // About
        "sec.about.title":      "About",
        "about.privacy":        "Privacy & data",
        "about.read":           "READ",
        "about.source":         "Source on GitHub",
        "about.clear":          "CLEAR API KEY",
        "about.footer1":        "Private by design. No accounts or tracking.",
        "about.footer2":        "Your voice goes only to Groq, never stored.",

        // About sheet
        "sheet.eyebrow":        "ON PRIVACY",
        "sheet.title":          "Privacy & data",
        "sheet.p1":             "Free Wisper does not collect, store, or transmit any data to its developer. There are no servers, accounts, or analytics.",
        "sheet.p2.before":      "When you hold the mic, audio is recorded to a temporary file, sent directly from your device to Groq using ",
        "sheet.p2.em":          "your",
        "sheet.p2.after":       " API key, and deleted immediately after the transcript returns.",
        "sheet.p3":             "Transcripts live in memory only — they are inserted at your cursor and then discarded. Nothing is kept on disk, in iCloud, or anywhere else.",
        "sheet.p4":             "See Groq's policy for how they handle data you send to their API.",
        "sheet.done":           "DONE",

        // Keyboard states
        "kbd.idle.eyebrow":     "VOICE INPUT",
        "kbd.idle.main":        "Hold to speak",
        "kbd.idle.hint":        "DRAG OFF TO CANCEL · 60S MAX",
        "kbd.rec.eyebrow":      "RECORDING",
        "kbd.rec.hint":         "RELEASE TO TRANSCRIBE",
        "kbd.rec.left":         "LEFT",
        "kbd.trans.eyebrow":    "TRANSCRIBING",
        "kbd.trans.main":       "Transcribing…",
        "kbd.clean.eyebrow":    "REFINING",
        "kbd.clean.main":       "Cleaning up…",
        "kbd.err.eyebrow":      "ERROR",
        "kbd.err.noKey":        "Open Free Wisper to add a key",
        "kbd.err.fail":         "Couldn't transcribe — try again",

        // Language toggle
        "lang.label":           "LANGUAGE",
    ]

    static let zh: [String: String] = [
        // Outside chrome
        "chrome.tagline":       "由你自己掌控的语音键盘。",
        "chrome.seg.settings":  "设置",
        "chrome.seg.keyboard":  "键盘",

        // Settings — masthead
        "mast.no":              "第 001 号",
        "mast.section":         "设置",
        "mast.version":         "v1.0",
        "mast.subtitle":        "iOS 语音键盘,由你自己的 Groq 密钥驱动。",

        // Setup banner
        "setup.eyebrow.todo":   "初始设置",
        "setup.eyebrow.done":   "准备就绪",
        "setup.title.todo":     "完成设置",
        "setup.title.done":     "可以开始口述",
        "setup.kb.label":       "在 iOS 设置中添加键盘",
        "setup.kb.cta":         "打开设置 →",
        "setup.kb.done":        "键盘已安装",
        "setup.fa.label":       "允许完全访问",
        "setup.fa.cta":         "连接 Groq 所需",
        "setup.fa.done":        "网络已启用",
        "setup.key.label":      "添加你的 Groq 密钥",
        "setup.key.cta":        "在下方粘贴",
        "setup.key.cta_done":   "密钥已保存",
        "setup.key.done":       "已存入钥匙串",

        // API key section
        "sec.key.title":        "Groq 密钥",
        "sec.key.tag":          "API 密钥",
        "key.stored":           "保存在钥匙串",
        "key.paste":            "粘贴",
        "key.test":             "测试密钥",
        "key.testing":          "测试中⋯",
        "key.ok":               "密钥有效",
        "key.fail":             "密钥无效",
        "key.getlink":          "获取免费的 Groq 密钥",
        "key.footnote":         "保存在 iOS 钥匙串中,通过 App Group 与键盘扩展共享。除了发送给 Groq 的请求外,不会离开你的设备。",

        // Transcription
        "sec.trans.title":      "转录模型",
        "sec.trans.tag":        "转录",
        "trans.m1.desc":        "高准确度语音识别。",
        "trans.m2.desc":        "216 倍实时速度。",
        "badge.default":        "默认",

        // Cleanup
        "sec.clean.title":      "智能润色",
        "sec.clean.tag":        "智能润色",
        "clean.row.title":      "用 AI 润色文字",
        "clean.row.sub":        "将转录结果发送给 Groq 语言模型",
        "clean.model.label":    "润色模型 · MODEL",
        "clean.style.label":    "润色风格 · STYLE",
        "clean.m1.desc":        "OpenAI 开源旗舰模型,500 T/sec。",
        "clean.m2.desc":        "快速开源模型,1000 T/sec。",
        "clean.style.light":    "轻度",
        "clean.style.std":      "标准",
        "clean.style.email":    "书信",
        "clean.style.light.desc":"修正标点、大小写和赘词,保留你的语气。",
        "clean.style.std.desc": "在轻度基础上调整语法,理顺冗长句子。",
        "clean.style.email.desc":"改写为清晰、适合邮件的文字。",
        "clean.footnote":       "润色会增加 1–2 秒,并消耗额外的 Groq 用量。若失败,则直接插入原始转录文字。",

        // About
        "sec.about.title":      "关于",
        "about.privacy":        "隐私与数据",
        "about.read":           "阅读",
        "about.source":         "GitHub 源代码",
        "about.clear":          "清除密钥",
        "about.footer1":        "注重隐私,无账号,不追踪。",
        "about.footer2":        "语音只发送给 Groq,绝不留存。",

        // About sheet
        "sheet.eyebrow":        "关于隐私",
        "sheet.title":          "隐私与数据",
        "sheet.p1":             "Free Wisper 不会收集、存储或向开发者发送任何数据。没有服务器、没有账号、没有数据分析。",
        "sheet.p2.before":      "当你按住麦克风时,音频会录入临时文件,使用 ",
        "sheet.p2.em":          "你自己的",
        "sheet.p2.after":       " 密钥直接从设备发送给 Groq,文字返回后立即删除。",
        "sheet.p3":             "转录文字仅存在于内存中——插入光标处后即丢弃。不会留在磁盘、iCloud 或任何其他地方。",
        "sheet.p4":             "请参阅 Groq 的政策,了解他们如何处理你发送至其 API 的数据。",
        "sheet.done":           "完成",

        // Keyboard states
        "kbd.idle.eyebrow":     "语音输入",
        "kbd.idle.main":        "按住说话",
        "kbd.idle.hint":        "滑开可取消 · 最长 60 秒",
        "kbd.rec.eyebrow":      "录音中",
        "kbd.rec.hint":         "松开即转录",
        "kbd.rec.left":         "剩余",
        "kbd.trans.eyebrow":    "转录中",
        "kbd.trans.main":       "正在转录⋯",
        "kbd.clean.eyebrow":    "润色中",
        "kbd.clean.main":       "正在润色⋯",
        "kbd.err.eyebrow":      "错误",
        "kbd.err.noKey":        "请打开 Free Wisper 设置密钥",
        "kbd.err.fail":         "转录失败,请重试",

        // Language toggle
        "lang.label":           "语言",
    ]
}
