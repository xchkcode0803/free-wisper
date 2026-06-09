// VoiceKeyboard — Chinese/English single-language museum aesthetic.
// States: idle | recording | transcribing | cleaning | error

const { useState, useEffect, useRef, useCallback } = React;

const INK  = '#0A0A0A';
const INK3 = '#5C5C5C';
const INK4 = '#8A8A8A';
const PAPER = '#F2EFE7';
const BONE = '#FBF9F3';
const HAIR = 'rgba(10,10,10,0.14)';

function PulseRings({ active }) {
  if (!active) return null;
  return (
    <>
      <div className="pulse-ring" />
      <div className="pulse-ring r2" />
      <div className="pulse-ring r3" />
    </>
  );
}

function Spinner({ size = 28, color = '#FBF9F3', strokeWidth = 1.5 }) {
  return (
    <svg className="spin" width={size} height={size} viewBox="0 0 32 32">
      <circle cx="16" cy="16" r="13" stroke={color} strokeOpacity="0.22" strokeWidth={strokeWidth} fill="none"/>
      <path d="M16 3a13 13 0 0113 13" stroke={color} strokeWidth={strokeWidth} strokeLinecap="round" fill="none"/>
    </svg>
  );
}

function HatchCircle({ size = 60 }) {
  return (
    <div className="hatch" style={{
      width: size, height: size, borderRadius: 9999,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
    }}>
      <Spinner size={32} color={BONE} strokeWidth={1.4}/>
    </div>
  );
}

function MicGlyph({ color = BONE, size = 38 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      <rect x="12.5" y="4.5" width="7" height="15" rx="3.5"
            stroke={color} strokeWidth="1.4" fill="none"/>
      <path d="M8 14.5a8 8 0 0016 0" stroke={color} strokeWidth="1.4" strokeLinecap="round"/>
      <path d="M16 22.5V28" stroke={color} strokeWidth="1.4" strokeLinecap="round"/>
      <path d="M11.5 28h9" stroke={color} strokeWidth="1.4" strokeLinecap="round"/>
    </svg>
  );
}

function StatusLabel({ state, elapsed, errorText }) {
  const { t, lang } = window.useT();
  const fmt = (s) => {
    const m = Math.floor(s / 60), r = Math.floor(s % 60);
    return `${m}:${r.toString().padStart(2, '0')}`;
  };

  const wrap = {
    fontFamily: 'var(--serif)',
    textAlign: 'center', display: 'flex', flexDirection: 'column',
    alignItems: 'center', justifyContent: 'center', gap: 4, minHeight: 38,
  };
  // Eyebrow tracking: Chinese needs wider tracking but smaller letter-spacing relatively
  const eyebrow = {
    fontFamily: 'var(--serif)',
    fontSize: lang === 'zh' ? 11 : 10.5,
    letterSpacing: lang === 'zh' ? '0.32em' : '0.4em',
    color: INK4,
    textTransform: lang === 'zh' ? 'none' : 'uppercase',
  };
  const main = {
    fontFamily: 'var(--serif)',
    fontSize: 17, color: INK,
    letterSpacing: lang === 'zh' ? '0.06em' : '0.04em',
    fontStyle: lang === 'zh' ? 'normal' : 'italic',
    fontWeight: 500,
  };

  if (state === 'idle') {
    return (
      <div style={wrap}>
        <div style={eyebrow}>{t('kbd.idle.eyebrow')}</div>
        <div style={main}>{t('kbd.idle.main')}</div>
      </div>
    );
  }
  if (state === 'recording') {
    const warn = elapsed >= 50;
    return (
      <div style={wrap}>
        <div style={eyebrow}>{t('kbd.rec.eyebrow')}</div>
        <div style={{ ...main, display: 'flex', alignItems: 'center', gap: 10 }}>
          <span style={{ fontFamily: 'var(--mono)', fontSize: 14, letterSpacing: '0.06em', fontStyle: 'normal', fontVariantNumeric: 'tabular-nums' }}>
            {fmt(elapsed)}
          </span>
          {warn && (
            <span style={{
              fontFamily: 'var(--mono)', fontSize: 11, letterSpacing: '0.12em',
              fontStyle: 'normal', fontWeight: 500,
              padding: '3px 7px', border: `1px solid ${INK}`, color: INK,
            }}>
              {lang === 'zh'
                ? `${t('kbd.rec.left')} ${60 - Math.floor(elapsed)}s`
                : `${60 - Math.floor(elapsed)}s ${t('kbd.rec.left')}`}
            </span>
          )}
        </div>
      </div>
    );
  }
  if (state === 'transcribing') {
    return (
      <div style={wrap}>
        <div style={eyebrow}>{t('kbd.trans.eyebrow')}</div>
        <div style={main}>{t('kbd.trans.main')}</div>
      </div>
    );
  }
  if (state === 'cleaning') {
    return (
      <div style={wrap}>
        <div style={eyebrow}>{t('kbd.clean.eyebrow')}</div>
        <div style={main}>{t('kbd.clean.main')}</div>
      </div>
    );
  }
  if (state === 'error') {
    return (
      <div style={wrap} className="fade-in">
        <div style={{ ...eyebrow, color: INK }}>{t('kbd.err.eyebrow')}</div>
        <div style={main}>{errorText}</div>
      </div>
    );
  }
  return null;
}

function MicButton({
  state, size = 108, onPressStart, onPressEnd, onCancelDrag,
}) {
  const ref = useRef(null);
  const tracking = useRef(false);

  useEffect(() => {
    if (state !== 'recording') return;
    const node = ref.current;
    if (!node) return;
    const handleMove = (e) => {
      if (!tracking.current) return;
      const t = (e.touches && e.touches[0]) || e;
      const r = node.getBoundingClientRect();
      const cx = r.left + r.width / 2, cy = r.top + r.height / 2;
      const dx = t.clientX - cx, dy = t.clientY - cy;
      const dist = Math.sqrt(dx * dx + dy * dy);
      if (dist > r.width * 0.85) {
        tracking.current = false;
        onCancelDrag && onCancelDrag();
      }
    };
    const handleUp = () => { tracking.current = false; };
    window.addEventListener('mousemove', handleMove);
    window.addEventListener('touchmove', handleMove, { passive: true });
    window.addEventListener('mouseup', handleUp);
    window.addEventListener('touchend', handleUp);
    return () => {
      window.removeEventListener('mousemove', handleMove);
      window.removeEventListener('touchmove', handleMove);
      window.removeEventListener('mouseup', handleUp);
      window.removeEventListener('touchend', handleUp);
    };
  }, [state, onCancelDrag]);

  const disabled = state === 'transcribing' || state === 'cleaning';

  let outerBg = INK;
  let inner = null;

  if (state === 'idle') {
    inner = (
      <div style={{
        width: size * 0.55, height: size * 0.55, borderRadius: 9999,
        border: `1.2px solid ${BONE}`,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}><MicGlyph color={BONE} size={36}/></div>
    );
  } else if (state === 'recording') {
    inner = (
      <div style={{
        width: size * 0.5, height: size * 0.5, borderRadius: 9999,
        background: BONE,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}><MicGlyph color={INK} size={32}/></div>
    );
  } else if (state === 'transcribing') {
    inner = (
      <div style={{
        width: size * 0.55, height: size * 0.55, borderRadius: 9999,
        border: `1.2px solid ${BONE}`,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}><Spinner size={32} color={BONE} strokeWidth={1.4}/></div>
    );
  } else if (state === 'cleaning') {
    inner = <HatchCircle size={size * 0.55}/>;
  } else if (state === 'error') {
    inner = (
      <div style={{
        width: size * 0.5, height: size * 0.5, borderRadius: 9999,
        background: BONE,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontFamily: 'var(--serif)',
        fontSize: 30, color: INK, fontWeight: 700, lineHeight: 1,
        paddingBottom: 2,
      }}>!</div>
    );
  }

  const start = (e) => {
    if (disabled) return;
    e.preventDefault();
    tracking.current = true;
    onPressStart && onPressStart();
  };
  const end = (e) => {
    if (disabled) return;
    e.preventDefault();
    if (tracking.current) {
      tracking.current = false;
      onPressEnd && onPressEnd();
    }
  };

  return (
    <div style={{ position: 'relative', width: size, height: size }}>
      {state === 'recording' && (
        <div style={{ position: 'absolute', inset: -10 }}>
          <PulseRings active />
        </div>
      )}
      <button
        ref={ref}
        className={state === 'error' ? 'shake' : ''}
        onMouseDown={start} onMouseUp={end}
        onTouchStart={start} onTouchEnd={end}
        style={{
          width: size, height: size, borderRadius: 9999,
          border: 0, padding: 0, background: outerBg,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          position: 'relative', zIndex: 2,
          cursor: disabled ? 'default' : 'pointer',
          opacity: disabled ? 0.95 : 1,
          transition: 'transform 0.16s ease, background 0.2s ease',
          transform: state === 'recording' ? 'scale(0.97)' : 'scale(1)',
          WebkitTapHighlightColor: 'transparent',
          touchAction: 'manipulation',
        }}
      >
        {inner}
      </button>
    </div>
  );
}

function CornerButton({ children, onClick, ariaLabel }) {
  return (
    <button
      onClick={onClick}
      aria-label={ariaLabel}
      style={{
        width: 44, height: 44, borderRadius: 0,
        border: `1px solid ${HAIR}`,
        background: 'transparent',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        cursor: 'pointer', WebkitTapHighlightColor: 'transparent',
        transition: 'background 0.15s ease',
      }}
      onMouseEnter={e => e.currentTarget.style.background = 'rgba(10,10,10,0.04)'}
      onMouseLeave={e => e.currentTarget.style.background = 'transparent'}
    >
      {children}
    </button>
  );
}

// Hanko-style brand seal — universal across languages
function Hanko() {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
      <div className="seal" style={{
        width: 32, height: 32,
        fontFamily: 'var(--serif)',
        fontSize: 18, fontWeight: 700, lineHeight: 1, paddingBottom: 2,
      }}>囁</div>
      <div style={{
        fontFamily: 'var(--serif)',
        fontSize: 11, letterSpacing: '0.38em',
        color: INK, textTransform: 'uppercase',
      }}>Wisper</div>
    </div>
  );
}

function VoiceKeyboard({
  state, setState,
  cleanupOn, hasApiKey, errorText,
  onTranscribed, onSwitchKeyboard, onBackspace,
}) {
  const { t, lang } = window.useT();
  const [elapsed, setElapsed] = useState(0);
  const startedAt = useRef(0);
  const timerRef = useRef(null);
  const stateRef = useRef(state);
  useEffect(() => { stateRef.current = state; }, [state]);

  useEffect(() => {
    if (state === 'recording') {
      startedAt.current = Date.now();
      setElapsed(0);
      timerRef.current = setInterval(() => {
        const e = (Date.now() - startedAt.current) / 1000;
        setElapsed(e);
        if (e >= 60 && stateRef.current === 'recording') stop(true);
      }, 100);
    } else {
      clearInterval(timerRef.current);
    }
    return () => clearInterval(timerRef.current);
    // eslint-disable-next-line
  }, [state]);

  useEffect(() => {
    if (state === 'error') {
      const tt = setTimeout(() => setState('idle'), 3000);
      return () => clearTimeout(tt);
    }
  }, [state, setState]);

  const fakeTranscripts = lang === 'zh' ? [
    '幫我提醒明天早上九點要打給設計師討論修改稿',
    '記得買燕麥奶,還有今晚要回媽媽電話',
    '我們把上線時間改到星期五吧,我想再校一次新手引導文案',
    '今天的會議很順利,他們喜歡這個方向,希望週末前能給份提案',
  ] : [
    "hey just confirming we're still on for tomorrow at 2 do you want me to bring the slides or are you handling that",
    'remind me to pick up oat milk and call mom back tonight',
    "let's push the launch to friday i want one more pass on the onboarding copy before we ship",
    'the meeting went well — they liked the direction, want a proposal by end of week',
  ];

  const press = useCallback(() => {
    if (!hasApiKey) { setState('error'); return; }
    setState('recording');
  }, [hasApiKey, setState]);

  const stop = useCallback((autoMax = false) => {
    const dur = (Date.now() - startedAt.current) / 1000;
    if (dur < 0.25 && !autoMax) { setState('idle'); return; }
    setState('transcribing');
    setTimeout(() => {
      const picked = fakeTranscripts[Math.floor(Math.random() * fakeTranscripts.length)];
      if (cleanupOn) {
        setState('cleaning');
        setTimeout(() => {
          onTranscribed && onTranscribed(polish(picked, lang));
          setState('idle');
        }, 1100);
      } else {
        onTranscribed && onTranscribed(picked);
        setState('idle');
      }
    }, 900);
  }, [cleanupOn, setState, onTranscribed, lang, fakeTranscripts]);

  const cancelDrag = useCallback(() => setState('idle'), [setState]);

  let errText = errorText;
  if (state === 'error' && !errText) {
    errText = hasApiKey ? t('kbd.err.fail') : t('kbd.err.noKey');
  }

  return (
    <div style={{
      position: 'relative', width: '100%',
      background: BONE,
      borderTop: `1px solid ${INK}`,
      paddingBottom: 38,
      userSelect: 'none', WebkitUserSelect: 'none',
    }}>
      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        padding: '10px 14px 10px',
        borderBottom: `1px solid ${HAIR}`,
      }}>
        <CornerButton onClick={onSwitchKeyboard} ariaLabel="Switch keyboard">
          <window.Icon.Globe size={20} color={INK}/>
        </CornerButton>
        <Hanko />
        <CornerButton onClick={onBackspace} ariaLabel="Delete">
          <window.Icon.Backspace size={20} color={INK}/>
        </CornerButton>
      </div>

      <div style={{
        display: 'flex', flexDirection: 'column', alignItems: 'center',
        gap: 22, padding: '30px 0 16px',
      }}>
        <MicButton
          state={state}
          onPressStart={press}
          onPressEnd={() => stop(false)}
          onCancelDrag={cancelDrag}
        />
        <StatusLabel state={state} elapsed={elapsed} errorText={errText} />

        {state === 'idle' && (
          <div style={{
            fontFamily: 'var(--serif)',
            fontSize: lang === 'zh' ? 11 : 10.5, color: INK4,
            letterSpacing: lang === 'zh' ? '0.18em' : '0.22em',
            textTransform: lang === 'zh' ? 'none' : 'uppercase',
            marginTop: -8,
          }}>
            {t('kbd.idle.hint')}
          </div>
        )}
        {state === 'recording' && (
          <div style={{
            fontFamily: 'var(--serif)',
            fontSize: lang === 'zh' ? 11 : 10.5, color: INK3,
            letterSpacing: lang === 'zh' ? '0.18em' : '0.22em',
            textTransform: lang === 'zh' ? 'none' : 'uppercase',
            marginTop: -8,
          }}>
            {t('kbd.rec.hint')}
          </div>
        )}
      </div>
    </div>
  );
}

function polish(text, lang) {
  let out = text.trim();
  if (lang === 'zh') {
    // Chinese: ensure final punctuation
    if (!/[。！？]$/.test(out)) out += '。';
    return out;
  }
  out = out.replace(/\b(um|uh|like|you know)\b[, ]*/gi, '');
  out = out.replace(/\s+/g, ' ').trim();
  out = out[0].toUpperCase() + out.slice(1);
  if (!/[.!?]$/.test(out)) out += '.';
  return out;
}

Object.assign(window, { VoiceKeyboard });
