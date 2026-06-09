// Localization — Traditional Chinese (zh-Hant) + English.
// One language displayed at a time. Brand marks ("Free Wisper", "WISPER", 囁)
// and technical terms ("API", "Groq", "iOS", model names) stay constant.

const STRINGS = {
  en: {
    // Outside chrome
    'chrome.tagline':       'A voice keyboard, by your own hand.',
    'chrome.seg.settings':  'Settings',
    'chrome.seg.keyboard':  'Keyboard',
    'chrome.cap.settings':  'Toggle the setup steps. Paste a key. Try the cleanup styles.',
    'chrome.cap.demo':      'Hold the mic. Drag away to cancel. Press without a key to see the error.',

    // Settings — masthead
    'mast.no':              'No. 001',
    'mast.section':         'SETTINGS',
    'mast.version':         'v1.0',
    'mast.subtitle':        'A voice keyboard for iOS, powered by your own Groq key. 囁 — a whisper.',

    // Setup banner
    'setup.eyebrow.todo':   'INITIAL SETUP',
    'setup.eyebrow.done':   'READY',
    'setup.title.todo':     'Finish setup',
    'setup.title.done':     'Ready to dictate',
    'setup.kb.label':       'Add keyboard in iOS Settings',
    'setup.kb.cta':         'Open Settings →',
    'setup.kb.done':        'Keyboard installed',
    'setup.fa.label':       'Allow Full Access',
    'setup.fa.cta':         'Required to reach Groq',
    'setup.fa.done':        'Network enabled',
    'setup.key.label':      'Add your Groq API key',
    'setup.key.cta':        'Paste below',
    'setup.key.cta_done':   'Key stored',
    'setup.key.done':       'Key in Keychain',

    // API key section
    'sec.key.title':        'Groq API key',
    'sec.key.tag':          'API KEY',
    'key.stored':           'Stored in Keychain',
    'key.paste':            'Paste',
    'key.test':             'Test key',
    'key.testing':          'Testing…',
    'key.ok':               'Key works',
    'key.fail':             'Invalid key',
    'key.getlink':          'Get a free Groq API key',
    'key.footnote':         'Stored in the iOS Keychain and shared with the keyboard extension via App Group. It never leaves your device except in requests to Groq.',

    // Transcription
    'sec.trans.title':      'Transcription model',
    'sec.trans.tag':        'TRANSCRIPTION',
    'trans.m1.desc':        'Best accuracy. Multilingual.',
    'trans.m2.desc':        'Faster. Slightly lower accuracy.',
    'trans.m3.desc':        'English only. Fastest.',
    'badge.default':        'Default',
    'badge.fastest':        'Fastest',

    // Cleanup
    'sec.clean.title':      'AI Cleanup',
    'sec.clean.tag':        'AI CLEANUP',
    'clean.row.title':      'Clean up with AI',
    'clean.row.sub':        'Sends transcript to a Groq LLM',
    'clean.model.label':    'CLEANUP MODEL · MODEL',
    'clean.style.label':    'CLEANUP STYLE · STYLE',
    'clean.m1.desc':        'Best quality.',
    'clean.m2.desc':        'Fastest.',
    'clean.m3.desc':        'Light. Good prose.',
    'clean.style.light':    'Light',
    'clean.style.std':      'Standard',
    'clean.style.email':    'Email',
    'clean.style.light.desc':'Fix punctuation, capitalization, filler words. Preserve voice.',
    'clean.style.std.desc': 'Light plus grammar smoothing for run-ons.',
    'clean.style.email.desc':'Rewrite as clear, email-ready prose.',
    'clean.footnote':       'Cleanup adds 1–2 seconds and uses additional Groq tokens. If it fails, the raw transcript is inserted as a fallback.',

    // About
    'sec.about.title':      'About',
    'about.privacy':        'Privacy & data',
    'about.read':           'READ',
    'about.source':         'Source on GitHub',
    'about.clear':          'Clear API key',
    'about.footer1':        'No accounts. No servers. No tracking.',
    'about.footer2':        'Audio goes straight from your device to Groq.',

    // About sheet
    'sheet.eyebrow':        'ON PRIVACY',
    'sheet.title':          'Privacy & data',
    'sheet.p1':             'Free Wisper does not collect, store, or transmit any data to its developer. There are no servers, accounts, or analytics.',
    'sheet.p2.before':      'When you hold the mic, audio is recorded to a temporary file, sent directly from your device to Groq using ',
    'sheet.p2.em':          'your',
    'sheet.p2.after':       ' API key, and deleted immediately after the transcript returns.',
    'sheet.p3':             'Transcripts live in memory only — they are inserted at your cursor and then discarded. Nothing is kept on disk, in iCloud, or anywhere else.',
    'sheet.p4':             "See Groq's policy for how they handle data you send to their API.",
    'sheet.done':           'Done',

    // Demo / notes screen
    'demo.back':            '← Notes',
    'demo.entry':           'ENTRY',
    'demo.done':            'Done',
    'demo.title':           'Try the keyboard',
    'demo.sub':             'Hold the mic below. Release to transcribe.',
    'demo.placeholder':     'Start typing or hold the mic…',
    'demo.cleanup.pill':    'AI CLEANUP',

    // Keyboard states
    'kbd.idle.eyebrow':       'VOICE INPUT',
    'kbd.idle.main':          'Hold to speak',
    'kbd.idle.hint':          'Drag off to cancel · 60s max',
    'kbd.rec.eyebrow':        'RECORDING',
    'kbd.rec.hint':           'Release to transcribe',
    'kbd.rec.left':           'LEFT',
    'kbd.trans.eyebrow':      'TRANSCRIBING',
    'kbd.trans.main':         'Transcribing…',
    'kbd.clean.eyebrow':      'REFINING',
    'kbd.clean.main':         'Cleaning up…',
    'kbd.err.eyebrow':        'ERROR',
    'kbd.err.noKey':          'Open Free Wisper to add a key',
    'kbd.err.fail':           "Couldn't transcribe — try again",
  },

  zh: {
    // Outside chrome
    'chrome.tagline':       '由你親手操作的語音鍵盤。',
    'chrome.seg.settings':  '設定',
    'chrome.seg.keyboard':  '鍵盤',
    'chrome.cap.settings':  '切換設定步驟，貼上金鑰，試試潤飾樣式。',
    'chrome.cap.demo':      '按住麥克風，滑開可取消。未設定金鑰時按下會看到錯誤。',

    // Settings — masthead
    'mast.no':              '第 001 號',
    'mast.section':         '設定',
    'mast.version':         'v1.0',
    'mast.subtitle':        'iOS 上的語音鍵盤，由你自己的 Groq 金鑰驅動。囁 — 輕語。',

    // Setup banner
    'setup.eyebrow.todo':   '初始設定',
    'setup.eyebrow.done':   '準備就緒',
    'setup.title.todo':     '完成設定',
    'setup.title.done':     '可以開始口述',
    'setup.kb.label':       '在 iOS 設定中加入鍵盤',
    'setup.kb.cta':         '開啟設定 →',
    'setup.kb.done':        '鍵盤已安裝',
    'setup.fa.label':       '允許完整存取',
    'setup.fa.cta':         '需要以連線至 Groq',
    'setup.fa.done':        '網路已啟用',
    'setup.key.label':      '加入你的 Groq 金鑰',
    'setup.key.cta':        '在下方貼上',
    'setup.key.cta_done':   '金鑰已儲存',
    'setup.key.done':       '已存於鑰匙圈',

    // API key section
    'sec.key.title':        'Groq 金鑰',
    'sec.key.tag':          'API 金鑰',
    'key.stored':           '儲存於鑰匙圈',
    'key.paste':            '貼上',
    'key.test':             '測試金鑰',
    'key.testing':          '測試中⋯',
    'key.ok':               '金鑰有效',
    'key.fail':             '金鑰無效',
    'key.getlink':          '取得免費的 Groq 金鑰',
    'key.footnote':         '儲存於 iOS 鑰匙圈，透過 App Group 與鍵盤擴充元件共用。除了傳送至 Groq 的請求外,不會離開你的裝置。',

    // Transcription
    'sec.trans.title':      '轉錄模型',
    'sec.trans.tag':        '轉錄',
    'trans.m1.desc':        '準確度最高。支援多語言。',
    'trans.m2.desc':        '較快。準確度略低。',
    'trans.m3.desc':        '僅限英文。最快。',
    'badge.default':        '預設',
    'badge.fastest':        '最快',

    // Cleanup
    'sec.clean.title':      '智能潤飾',
    'sec.clean.tag':        '智能潤飾',
    'clean.row.title':      '以 AI 潤飾文字',
    'clean.row.sub':        '將轉錄結果傳送給 Groq 語言模型',
    'clean.model.label':    '潤飾模型 · MODEL',
    'clean.style.label':    '潤飾樣式 · STYLE',
    'clean.m1.desc':        '品質最佳。',
    'clean.m2.desc':        '最快。',
    'clean.m3.desc':        '輕量。文筆優雅。',
    'clean.style.light':    '輕量',
    'clean.style.std':      '標準',
    'clean.style.email':    '書信',
    'clean.style.light.desc':'修正標點、大小寫與贅字。保留原本語氣。',
    'clean.style.std.desc': '輕量再加上文法調整,改善冗長句。',
    'clean.style.email.desc':'改寫為清晰、適合電子郵件的文字。',
    'clean.footnote':       '潤飾會增加 1–2 秒並使用額外的 Groq 用量。若失敗則會直接插入原始轉錄文字。',

    // About
    'sec.about.title':      '關於',
    'about.privacy':        '隱私與資料',
    'about.read':           '閱讀',
    'about.source':         'GitHub 原始碼',
    'about.clear':          '清除金鑰',
    'about.footer1':        '沒有帳號。沒有伺服器。沒有追蹤。',
    'about.footer2':        '音訊直接從你的裝置傳送至 Groq。',

    // About sheet
    'sheet.eyebrow':        '關於隱私',
    'sheet.title':          '隱私與資料',
    'sheet.p1':             'Free Wisper 不會收集、儲存或傳送任何資料給開發者。沒有伺服器、沒有帳號、沒有分析。',
    'sheet.p2.before':      '當你按住麥克風時,音訊會錄到臨時檔案,使用 ',
    'sheet.p2.em':          '你自己的',
    'sheet.p2.after':       ' 金鑰直接從裝置傳送至 Groq,文字返回後立即刪除。',
    'sheet.p3':             '轉錄文字僅存在於記憶體 — 插入游標處後即丟棄。不會留在磁碟、iCloud,或任何其他地方。',
    'sheet.p4':             '請參閱 Groq 的政策,了解他們如何處理你傳送至其 API 的資料。',
    'sheet.done':           '完成',

    // Demo / notes screen
    'demo.back':            '← 備忘錄',
    'demo.entry':           '筆記',
    'demo.done':            '完成',
    'demo.title':           '試試這支鍵盤',
    'demo.sub':             '按住下方麥克風,放開即轉錄。',
    'demo.placeholder':     '開始輸入,或按住麥克風⋯',
    'demo.cleanup.pill':    '智能潤飾',

    // Keyboard states
    'kbd.idle.eyebrow':       '語音輸入',
    'kbd.idle.main':          '按住說話',
    'kbd.idle.hint':          '滑開可取消 · 最長 60 秒',
    'kbd.rec.eyebrow':        '錄音中',
    'kbd.rec.hint':           '放開即轉錄',
    'kbd.rec.left':           '剩餘',
    'kbd.trans.eyebrow':      '轉錄中',
    'kbd.trans.main':         '正在轉錄⋯',
    'kbd.clean.eyebrow':      '潤飾中',
    'kbd.clean.main':         '正在潤飾⋯',
    'kbd.err.eyebrow':        '錯誤',
    'kbd.err.noKey':          '請打開 Free Wisper 設定金鑰',
    'kbd.err.fail':           '轉錄失敗,請再試一次',
  },
};

// Context — provides the current language and a t() lookup function.
const LangContext = React.createContext({
  lang: 'en',
  t: (key) => STRINGS.en[key] || key,
});

function useT() {
  return React.useContext(LangContext);
}

Object.assign(window, { STRINGS, LangContext, useT });
