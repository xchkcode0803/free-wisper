// App — top-level shell. Renders an iPhone frame containing either
// the container app (SettingsScreen) or the keyboard demo (DemoScreen).
// Adds an EN/中 language toggle that swaps the entire UI.

const { useState: useStateA, useEffect: useEffectA, useMemo: useMemoA } = React;
const { IOSStatusBar } = window;

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "screen": "settings",
  "kbState": "idle",
  "cleanupOn": false,
  "setupComplete": false,
  "hasKey": false,
  "lang": "en"
}/*EDITMODE-END*/;

function App() {
  const [t, setTweak] = window.useTweaks(TWEAK_DEFAULTS);

  const screen    = t.screen;
  const cleanupOn = t.cleanupOn;
  const kbState   = t.kbState;
  const lang      = t.lang;

  // Reflect language on <html> so CSS can swap serif stack
  useEffectA(() => {
    document.documentElement.setAttribute('data-lang', lang);
  }, [lang]);

  // Provide context for strings
  const langValue = useMemoA(() => {
    const dict = window.STRINGS[lang] || window.STRINGS.en;
    return {
      lang,
      t: (key) => (dict[key] !== undefined ? dict[key] : (window.STRINGS.en[key] || key)),
    };
  }, [lang]);

  const [apiKey, setApiKey] = useStateA(t.hasKey ? 'preview-api-key-placeholder' : '');
  const [setupState, setSetupState] = useStateA({
    added: t.setupComplete, fullAccess: t.setupComplete,
  });
  const [transModel, setTransModel] = useStateA('whisper-large-v3');
  const [cleanupModel, setCleanupModel] = useStateA('llama-3.3-70b-versatile');
  const [cleanupStyle, setCleanupStyle] = useStateA('light');

  useEffectA(() => {
    if (t.hasKey && !apiKey) setApiKey('preview-api-key-placeholder');
    if (!t.hasKey && apiKey) setApiKey('');
    // eslint-disable-next-line
  }, [t.hasKey]);
  useEffectA(() => {
    setSetupState({ added: t.setupComplete, fullAccess: t.setupComplete });
    // eslint-disable-next-line
  }, [t.setupComplete]);

  const setKbState = (s) => setTweak('kbState', s);
  const setScreen = (s) => setTweak('screen', s);
  const setCleanupOn = (v) => setTweak('cleanupOn', v);
  const setLang = (l) => setTweak('lang', l);

  const hasApiKey = !!apiKey;

  return (
    <window.LangContext.Provider value={langValue}>
      <div className="stage-bg" style={{
        minHeight: '100vh',
        display: 'flex', flexDirection: 'column', alignItems: 'center',
        padding: '32px 16px 48px', gap: 18,
      }}>
        {/* Masthead + chrome controls */}
        <div style={{
          display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 14,
          marginBottom: 4,
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
            <div style={{ width: 32, height: 1, background: '#0A0A0A' }}/>
            <div style={{
              fontFamily: "var(--serif)",
              fontSize: 11, letterSpacing: '0.42em',
              color: '#0A0A0A', textTransform: 'uppercase', fontWeight: 500,
            }}>
              Free Wisper · 囁
            </div>
            <div style={{ width: 32, height: 1, background: '#0A0A0A' }}/>
          </div>
          <div style={{
            fontFamily: "var(--serif)",
            fontSize: 13, color: '#5C5C5C',
            letterSpacing: lang === 'zh' ? '0.04em' : '0.04em',
            fontStyle: lang === 'zh' ? 'normal' : 'italic',
          }}>
            {langValue.t('chrome.tagline')}
          </div>

          {/* Control row: screen segment + language toggle */}
          <div style={{
            display: 'flex', alignItems: 'center', gap: 14, marginTop: 6, flexWrap: 'wrap', justifyContent: 'center',
          }}>
            <div className="seg">
              <button className={screen === 'settings' ? 'active' : ''} onClick={() => setScreen('settings')}>
                {langValue.t('chrome.seg.settings')}
              </button>
              <button className={screen === 'demo' ? 'active' : ''} onClick={() => setScreen('demo')}>
                {langValue.t('chrome.seg.keyboard')}
              </button>
            </div>
            <LangToggle lang={lang} setLang={setLang} />
          </div>
        </div>

        {/* Phone */}
        <PhoneFrame>
          <div style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 30 }}>
            <IOSStatusBar />
          </div>
          <div style={{ height: 54, flexShrink: 0 }} />

          {screen === 'settings' && (
            <div style={{ flex: 1, overflow: 'auto' }} className="no-scrollbar">
              <window.SettingsScreen
                setupState={setupState} setSetupState={(s) => {
                  setSetupState(s);
                  if (s.added && s.fullAccess) setTweak('setupComplete', true);
                  if (!s.added && !s.fullAccess) setTweak('setupComplete', false);
                }}
                apiKey={apiKey} setApiKey={(k) => { setApiKey(k); setTweak('hasKey', !!k); }}
                transModel={transModel} setTransModel={setTransModel}
                cleanupOn={cleanupOn} setCleanupOn={setCleanupOn}
                cleanupModel={cleanupModel} setCleanupModel={setCleanupModel}
                cleanupStyle={cleanupStyle} setCleanupStyle={setCleanupStyle}
              />
            </div>
          )}

          {screen === 'demo' && (
            <div style={{ flex: 1, display: 'flex', flexDirection: 'column', minHeight: 0 }}>
              <window.DemoScreen
                kbState={kbState} setKbState={setKbState}
                cleanupOn={cleanupOn} cleanupStyle={cleanupStyle}
                hasApiKey={hasApiKey}
              />
            </div>
          )}

          <div style={{
            position: 'absolute', bottom: 0, left: 0, right: 0, zIndex: 60,
            height: 34, display: 'flex', justifyContent: 'center', alignItems: 'flex-end',
            paddingBottom: 8, pointerEvents: 'none',
          }}>
            <div style={{ width: 139, height: 5, borderRadius: 100, background: 'rgba(0,0,0,0.25)' }} />
          </div>

          <div style={{
            position: 'absolute', top: 11, left: '50%', transform: 'translateX(-50%)',
            width: 126, height: 37, borderRadius: 24, background: '#000', zIndex: 40,
          }} />
        </PhoneFrame>

        <div style={{
          fontFamily: "var(--serif)",
          fontSize: 12, color: '#5C5C5C',
          letterSpacing: '0.03em', textAlign: 'center', maxWidth: 380,
          fontStyle: lang === 'zh' ? 'normal' : 'italic', lineHeight: 1.65,
        }}>
          {screen === 'settings' ? langValue.t('chrome.cap.settings') : langValue.t('chrome.cap.demo')}
        </div>

        <Tweaks
          t={t} setTweak={setTweak}
          kbState={kbState} setKbState={setKbState}
        />
      </div>
    </window.LangContext.Provider>
  );
}

// ─── Language Toggle — two-cell pill, hairline border ─────────
function LangToggle({ lang, setLang }) {
  const cell = (active) => ({
    padding: '10px 18px',
    fontFamily: 'var(--serif)',
    fontSize: 13,
    letterSpacing: '0.08em',
    color: active ? '#FBF9F3' : '#0A0A0A',
    background: active ? '#0A0A0A' : 'transparent',
    transition: 'background 0.15s, color 0.15s',
    cursor: 'pointer',
    fontWeight: active ? 600 : 500,
    lineHeight: 1,
    display: 'flex', alignItems: 'center', gap: 6,
  });
  return (
    <div style={{
      display: 'inline-flex',
      border: '1px solid #0A0A0A',
      background: '#FBF9F3',
    }}>
      <button className="reset" onClick={() => setLang('en')} style={cell(lang === 'en')}>
        EN
      </button>
      <div style={{ width: 1, background: '#0A0A0A' }}/>
      <button className="reset" onClick={() => setLang('zh')} style={cell(lang === 'zh')}>
        中文
      </button>
    </div>
  );
}

function PhoneFrame({ children }) {
  return (
    <div style={{
      width: 390, height: 844, borderRadius: 48, overflow: 'hidden',
      position: 'relative', background: '#F2EFE7',
      boxShadow: '0 30px 60px rgba(10,10,10,0.18), 0 0 0 1px rgba(10,10,10,0.18), 0 0 0 7px #0A0A0A',
      display: 'flex', flexDirection: 'column',
    }}>
      {children}
    </div>
  );
}

// ─── Tweaks Panel ─────────────────────────────────────────────
function Tweaks({ t, setTweak, kbState, setKbState }) {
  const { TweaksPanel, TweakSection, TweakRadio, TweakToggle, TweakSelect } = window;
  return (
    <TweaksPanel title="Tweaks">
      <TweakSection label="Language">
        <TweakRadio label="Display" value={t.lang} onChange={v => setTweak('lang', v)}
          options={[
            { value: 'en', label: 'English' },
            { value: 'zh', label: '中文' },
          ]}
        />
      </TweakSection>

      <TweakSection label="Screen">
        <TweakRadio label="View" value={t.screen} onChange={v => setTweak('screen', v)}
          options={[
            { value: 'settings', label: 'Settings' },
            { value: 'demo', label: 'Keyboard' },
          ]}
        />
      </TweakSection>

      <TweakSection label="Setup state">
        <TweakToggle label="Setup complete" value={t.setupComplete} onChange={v => setTweak('setupComplete', v)} />
        <TweakToggle label="API key set" value={t.hasKey} onChange={v => setTweak('hasKey', v)} />
      </TweakSection>

      <TweakSection label="Keyboard">
        <TweakToggle label="AI cleanup" value={t.cleanupOn} onChange={v => setTweak('cleanupOn', v)} />
        <TweakSelect label="Keyboard state" value={kbState} onChange={v => setKbState(v)}
          options={[
            { value: 'idle', label: 'Idle' },
            { value: 'recording', label: 'Recording' },
            { value: 'transcribing', label: 'Transcribing' },
            { value: 'cleaning', label: 'Cleaning up' },
            { value: 'error', label: 'Error' },
          ]}
        />
      </TweakSection>
    </TweaksPanel>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);
