// DemoScreen — single-language museum manuscript page hosting the voice keyboard.

const { useState: useStateD } = React;

const INK   = '#0A0A0A';
const INK3  = '#5C5C5C';
const INK4  = '#8A8A8A';
const HAIR  = 'rgba(10,10,10,0.14)';
const BONE  = '#FBF9F3';

function DemoScreen({
  kbState, setKbState,
  cleanupOn, cleanupStyle,
  hasApiKey,
}) {
  const { t, lang } = window.useT();
  const [text, setText] = useStateD('');
  const [justInserted, setJustInserted] = useStateD(false);

  const onTranscribed = (incoming) => {
    setText((prev) => {
      const sep = !prev ? '' : (
        lang === 'zh'
          ? (/[\s。！？，；：、]$/.test(prev) ? '' : '')
          : (/[\s.!?,;:]$/.test(prev) ? '' : ' ')
      );
      const out = prev + sep + incoming;
      if (lang === 'zh') return out;
      return /[\s]$/.test(out) ? out : out + ' ';
    });
    setJustInserted(true);
    setTimeout(() => setJustInserted(false), 800);
  };

  const today = lang === 'zh'
    ? new Date().toLocaleDateString('zh-Hant-TW', { weekday: 'long', month: 'long', day: 'numeric' })
    : new Date().toLocaleDateString('en-US',     { weekday: 'long', month: 'long', day: 'numeric' });
  const time = new Date().toLocaleTimeString(lang === 'zh' ? 'zh-Hant-TW' : 'en-US', { hour: 'numeric', minute: '2-digit' });

  const styleLabel = {
    light: t('clean.style.light'),
    standard: t('clean.style.std'),
    email: t('clean.style.email'),
  }[cleanupStyle] || cleanupStyle;

  return (
    <div style={{
      display: 'flex', flexDirection: 'column', height: '100%',
      background: BONE,
    }}>
      {/* Nav bar */}
      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        padding: '10px 18px',
        borderBottom: `1px solid ${INK}`,
      }}>
        <button className="reset tap" style={{
          fontFamily: 'var(--sans)', fontSize: 10,
          color: INK, letterSpacing: lang === 'zh' ? '0.16em' : '0.28em',
          textTransform: lang === 'zh' ? 'none' : 'uppercase',
          fontWeight: 500,
        }}>
          {t('demo.back')}
        </button>
        <div style={{
          fontFamily: 'var(--mono)', fontSize: 9.5,
          color: INK3,
          letterSpacing: lang === 'zh' ? '0.18em' : '0.28em',
          textTransform: lang === 'zh' ? 'none' : 'uppercase',
        }}>
          {t('demo.entry')}
        </div>
        <button className="reset tap" style={{
          fontFamily: 'var(--sans)', fontSize: 10,
          color: INK, letterSpacing: lang === 'zh' ? '0.16em' : '0.28em',
          textTransform: lang === 'zh' ? 'none' : 'uppercase',
          fontWeight: 500,
        }}>{t('demo.done')}</button>
      </div>

      <div style={{
        display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
        padding: '12px 18px 0',
        fontFamily: 'var(--mono)', fontSize: 9.5,
        color: INK4,
        letterSpacing: lang === 'zh' ? '0.16em' : '0.24em',
        textTransform: lang === 'zh' ? 'none' : 'uppercase',
      }}>
        <span>{today}</span>
        <span>{time}</span>
      </div>

      <div style={{ padding: '8px 22px 6px' }}>
        <div style={{
          fontFamily: 'var(--serif)',
          fontSize: 30, fontWeight: 600, color: INK,
          letterSpacing: lang === 'zh' ? '0.02em' : '0.005em',
          lineHeight: 1.15,
          marginBottom: 4,
        }}>
          {t('demo.title')}
        </div>
        <div style={{
          fontFamily: 'var(--serif)',
          fontSize: 12.5, color: INK3,
          letterSpacing: '0.02em',
          fontStyle: lang === 'zh' ? 'normal' : 'italic',
        }}>
          {t('demo.sub')}
        </div>
      </div>

      <div style={{ margin: '14px 22px 0', height: 1, background: HAIR }}/>

      <div style={{
        flex: 1, padding: '18px 22px 6px', overflow: 'auto',
        position: 'relative',
      }} className="no-scrollbar">
        <div style={{
          fontFamily: 'var(--serif)',
          fontSize: 17, lineHeight: 1.75, color: INK,
          letterSpacing: lang === 'zh' ? '0.04em' : '0.01em',
          whiteSpace: 'pre-wrap', minHeight: 80,
        }}>
          {text || (
            <span style={{
              color: INK4,
              fontStyle: lang === 'zh' ? 'normal' : 'italic',
            }}>
              {t('demo.placeholder')}
            </span>
          )}
          <span className="caret" />
        </div>

        {justInserted && (
          <div style={{
            position: 'absolute', inset: 0, pointerEvents: 'none',
            background: 'linear-gradient(180deg, rgba(10,10,10,0.04), transparent 30%)',
            animation: 'fadeIn 0.18s ease-out',
          }}/>
        )}
      </div>

      {cleanupOn && kbState === 'idle' && (
        <div style={{
          display: 'flex', justifyContent: 'center',
          padding: '0 18px 8px',
        }}>
          <div style={{
            display: 'inline-flex', alignItems: 'center', gap: 8,
            padding: '4px 12px',
            border: `1px solid ${INK}`, color: INK, background: 'transparent',
            fontFamily: 'var(--mono)', fontSize: 9,
            letterSpacing: lang === 'zh' ? '0.18em' : '0.28em',
            textTransform: lang === 'zh' ? 'none' : 'uppercase',
          }}>
            {t('demo.cleanup.pill')} · {styleLabel}
          </div>
        </div>
      )}

      <window.VoiceKeyboard
        state={kbState}
        setState={setKbState}
        cleanupOn={cleanupOn}
        hasApiKey={hasApiKey}
        onTranscribed={onTranscribed}
        onSwitchKeyboard={() => {}}
        onBackspace={() => setText(t => t.slice(0, -1))}
      />
    </div>
  );
}

Object.assign(window, { DemoScreen });
