// SettingsScreen — single-language museum aesthetic with EN/ZH switching.

const { useState: useStateS } = React;

const INK   = '#0A0A0A';
const INK3  = '#5C5C5C';
const INK4  = '#8A8A8A';
const HAIR  = 'rgba(10,10,10,0.14)';
const HAIR2 = 'rgba(10,10,10,0.06)';
const PAPER = '#F2EFE7';
const BONE  = '#FBF9F3';
const CARD  = '#FFFFFF';

// ─── Helpers ──────────────────────────────────────────────────
const labelEyebrow = (lang) => ({
  fontFamily: 'var(--serif)',
  fontSize: lang === 'zh' ? 12 : 11,
  letterSpacing: lang === 'zh' ? '0.18em' : '0.3em',
  color: INK,
  textTransform: lang === 'zh' ? 'none' : 'uppercase',
  fontWeight: 500,
});
const monoTag = (lang, size = 10) => ({
  fontFamily: 'var(--mono)', fontSize: size,
  color: INK3,
  letterSpacing: lang === 'zh' ? '0.16em' : '0.22em',
  textTransform: lang === 'zh' ? 'none' : 'uppercase',
});

// ─── Section header w/ horizontal rule ────────────────────────
function SectionHeader({ children, tag }) {
  const { lang } = window.useT();
  return (
    <div style={{
      padding: '28px 22px 10px',
      display: 'flex', alignItems: 'baseline', gap: 12,
    }}>
      <div style={labelEyebrow(lang)}>{children}</div>
      <div style={{ flex: 1, height: 1, background: HAIR }}/>
      {tag && <div style={{ ...monoTag(lang, 10), color: INK4 }}>{tag}</div>}
    </div>
  );
}

function Card({ children, style = {} }) {
  return (
    <div style={{
      background: CARD,
      border: `1px solid ${HAIR}`,
      margin: '0 22px',
      ...style,
    }}>{children}</div>
  );
}

function FootNote({ children }) {
  const { lang } = window.useT();
  return (
    <div style={{
      fontFamily: 'var(--serif)',
      fontSize: 12, color: INK3,
      padding: '10px 26px 0',
      letterSpacing: lang === 'zh' ? '0.03em' : '0.01em',
      lineHeight: 1.65,
      fontStyle: lang === 'zh' ? 'normal' : 'italic',
    }}>{children}</div>
  );
}

function Row({ children, last, style = {} }) {
  return (
    <div style={{ position: 'relative', padding: '0 16px', ...style }}>
      {children}
      {!last && (
        <div style={{
          position: 'absolute', left: 16, right: 0, bottom: 0,
          height: 1, background: HAIR2,
        }}/>
      )}
    </div>
  );
}

// ─── Setup banner ─────────────────────────────────────────────
function SetupBanner({ steps, onTapStep }) {
  const { t, lang } = window.useT();
  const done = steps.filter(s => s.done).length;
  const allDone = done === steps.length;
  return (
    <div style={{
      margin: '6px 22px 4px',
      border: `1px solid ${INK}`, background: BONE,
    }}>
      <div style={{
        padding: '16px 18px',
        borderBottom: `1px solid ${INK}`,
        display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between',
      }}>
        <div>
          <div style={{ ...monoTag(lang, 10.5), color: INK4, marginBottom: 4 }}>
            {allDone ? t('setup.eyebrow.done') : t('setup.eyebrow.todo')}
          </div>
          <div style={{
            fontFamily: 'var(--serif)',
            fontSize: 21, color: INK, fontWeight: 500,
            letterSpacing: lang === 'zh' ? '0.02em' : '0.01em',
          }}>
            {allDone ? t('setup.title.done') : t('setup.title.todo')}
          </div>
        </div>
        <div style={{
          fontFamily: 'var(--mono)', fontSize: 13,
          color: INK, letterSpacing: '0.1em',
          fontVariantNumeric: 'tabular-nums',
        }}>
          {done}/{steps.length}
        </div>
      </div>

      {steps.map((s, i) => (
        <button
          key={s.key} className="reset" onClick={() => onTapStep(s)}
          style={{
            display: 'flex', alignItems: 'center', gap: 14, width: '100%',
            padding: '14px 18px', textAlign: 'left',
            borderBottom: i < steps.length - 1 ? `1px solid ${HAIR2}` : 'none',
            background: 'transparent', cursor: 'pointer',
            WebkitTapHighlightColor: 'transparent',
            transition: 'background 0.15s ease',
          }}
          onMouseEnter={e => e.currentTarget.style.background = 'rgba(10,10,10,0.025)'}
          onMouseLeave={e => e.currentTarget.style.background = 'transparent'}
        >
          <div style={{
            width: 22, height: 22, flexShrink: 0,
            border: `1px solid ${INK}`,
            background: s.done ? INK : 'transparent',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: 'var(--mono)', fontSize: 11,
            color: s.done ? BONE : INK,
            fontVariantNumeric: 'tabular-nums',
          }}>
            {s.done ? '✓' : String(i + 1).padStart(2, '0').slice(-2)}
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{
              fontFamily: 'var(--serif)',
              fontSize: 16, color: INK,
              letterSpacing: lang === 'zh' ? '0.02em' : '0.005em',
              fontWeight: 500,
            }}>{s.label}</div>
            <div style={{
              fontFamily: 'var(--serif)',
              fontSize: 12, color: INK3,
              marginTop: 2,
              letterSpacing: lang === 'zh' ? '0.03em' : '0.02em',
              fontStyle: lang === 'zh' ? 'normal' : 'italic',
            }}>{s.done ? s.doneSub : s.cta}</div>
          </div>
          {!s.done && (
            <div style={{
              fontFamily: 'var(--mono)', fontSize: 10,
              letterSpacing: '0.2em', color: INK,
            }}>↗</div>
          )}
        </button>
      ))}
    </div>
  );
}

// ─── API Key row ──────────────────────────────────────────────
function APIKeyRow({ apiKey, setApiKey, testStatus, onTest, onPaste }) {
  const { t, lang } = window.useT();
  const [show, setShow] = useStateS(false);

  return (
    <Card>
      <div style={{ padding: '16px 18px' }}>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10,
          ...monoTag(lang, 10),
        }}>
          <window.Icon.Lock size={11} color={INK3}/>
          {t('key.stored')}
        </div>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 8,
          borderBottom: `1px solid ${INK}`, padding: '6px 0 8px',
        }}>
          <input
            value={apiKey}
            onChange={e => setApiKey(e.target.value)}
            placeholder="Groq API key"
            type={show ? 'text' : 'password'}
            style={{
              flex: 1, border: 0, background: 'transparent', outline: 'none',
              fontFamily: 'var(--mono)',
              fontSize: 14, letterSpacing: '0.02em', color: INK,
              minWidth: 0,
            }}
          />
          <button className="reset tap" onClick={() => setShow(s => !s)} aria-label="Toggle visibility">
            <window.Icon.Eye size={18} color={INK3} off={show}/>
          </button>
        </div>

        <div style={{ display: 'flex', gap: 8, marginTop: 14, alignItems: 'center', flexWrap: 'wrap' }}>
          <InkButton onClick={onPaste} variant="outline">{t('key.paste')}</InkButton>
          <InkButton
            onClick={onTest}
            variant="solid"
            disabled={!apiKey || testStatus === 'testing'}
          >
            {testStatus === 'testing' ? t('key.testing') : t('key.test')}
          </InkButton>
          {testStatus === 'ok' && (
            <div className="fade-in" style={{
              display: 'flex', alignItems: 'center', gap: 6,
              fontFamily: 'var(--serif)',
              fontSize: 13, color: INK,
              fontStyle: lang === 'zh' ? 'normal' : 'italic',
            }}>
              <div style={{
                width: 16, height: 16, border: `1px solid ${INK}`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 10, fontFamily: 'var(--mono)',
              }}>✓</div>
              {t('key.ok')}
            </div>
          )}
          {testStatus === 'fail' && (
            <div className="fade-in" style={{
              fontFamily: 'var(--serif)',
              fontSize: 13, color: INK,
              fontStyle: lang === 'zh' ? 'normal' : 'italic',
              borderBottom: `1px solid ${INK}`,
            }}>{t('key.fail')}</div>
          )}
        </div>
      </div>
      <Row last style={{
        padding: '12px 18px',
        borderTop: `1px solid ${HAIR2}`,
      }}>
        <a href="#" onClick={(e)=>e.preventDefault()} style={{
          display: 'flex', alignItems: 'center', gap: 8,
          color: INK, fontSize: 13, textDecoration: 'none',
          fontFamily: 'var(--serif)',
          fontStyle: lang === 'zh' ? 'normal' : 'italic',
          letterSpacing: lang === 'zh' ? '0.02em' : '0.02em',
        }}>
          <span style={{ borderBottom: `1px solid ${INK}` }}>{t('key.getlink')}</span>
          <window.Icon.External size={10} color={INK}/>
        </a>
      </Row>
    </Card>
  );
}

function InkButton({ children, onClick, variant = 'solid', disabled }) {
  const { lang } = window.useT();
  const solid = variant === 'solid';
  return (
    <button
      className="reset" onClick={onClick} disabled={disabled}
      style={{
        fontFamily: 'var(--sans)',
        fontSize: lang === 'zh' ? 12 : 11,
        letterSpacing: lang === 'zh' ? '0.12em' : '0.22em',
        textTransform: lang === 'zh' ? 'none' : 'uppercase',
        fontWeight: 500,
        padding: '8px 14px',
        border: `1px solid ${INK}`,
        background: solid ? INK : 'transparent',
        color: solid ? BONE : INK,
        opacity: disabled ? 0.35 : 1,
        cursor: disabled ? 'default' : 'pointer',
        transition: 'opacity 0.15s ease',
      }}
    >
      {children}
    </button>
  );
}

// ─── Models ───────────────────────────────────────────────────
// Names stay in latin (proprietary). Descriptions and badges are localized.
const TRANS_MODELS = [
  { id: 'whisper-large-v3',          name: 'Whisper Large v3',       descKey: 'trans.m1.desc', badge: 'default' },
  { id: 'whisper-large-v3-turbo',    name: 'Whisper Large v3 Turbo', descKey: 'trans.m2.desc', badge: null },
  { id: 'distil-whisper-large-v3-en',name: 'Distil Whisper v3',      descKey: 'trans.m3.desc', badge: 'fastest' },
];
const CLEANUP_MODELS = [
  { id: 'llama-3.3-70b-versatile', name: 'Llama 3.3 70B',      descKey: 'clean.m1.desc', badge: 'default' },
  { id: 'llama-3.1-8b-instant',    name: 'Llama 3.1 8B',       descKey: 'clean.m2.desc', badge: null },
  { id: 'gemma2-9b-it',            name: 'Gemma 2 9B',         descKey: 'clean.m3.desc', badge: null },
];

function RadioRow({ option, selected, onSelect, last, compact }) {
  const { t, lang } = window.useT();
  const badgeText = option.badge === 'default' ? t('badge.default')
                  : option.badge === 'fastest' ? t('badge.fastest')
                  : null;
  return (
    <Row last={last}>
      <button className="reset" onClick={() => onSelect(option.id)} style={{
        display: 'flex', alignItems: 'center', gap: 14,
        width: '100%', padding: compact ? '11px 4px' : '14px 4px',
        textAlign: 'left', WebkitTapHighlightColor: 'transparent',
      }}>
        <div style={{
          width: 18, height: 18, flexShrink: 0,
          border: `1px solid ${INK}`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          {selected && <div style={{ width: 10, height: 10, background: INK }}/>}
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{
            fontFamily: 'var(--serif)',
            fontSize: 16, color: INK,
            letterSpacing: lang === 'zh' ? '0.02em' : '0.005em',
            fontWeight: 500,
            display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap',
          }}>
            {option.name}
            {badgeText && (
              <span style={{
                fontFamily: 'var(--mono)',
                fontSize: lang === 'zh' ? 10 : 9,
                letterSpacing: lang === 'zh' ? '0.14em' : '0.22em',
                textTransform: lang === 'zh' ? 'none' : 'uppercase',
                padding: '2px 6px',
                border: `1px solid ${INK}`, color: INK,
                background: BONE,
              }}>{badgeText}</span>
            )}
          </div>
          <div style={{
            fontFamily: 'var(--serif)',
            fontSize: 12.5, color: INK3,
            marginTop: 3,
            letterSpacing: lang === 'zh' ? '0.03em' : '0.01em',
            fontStyle: lang === 'zh' ? 'normal' : 'italic',
          }}>{t(option.descKey)}</div>
        </div>
      </button>
    </Row>
  );
}

// ─── Toggle ───────────────────────────────────────────────────
function Toggle({ on, onChange }) {
  return (
    <button className="reset" onClick={() => onChange(!on)} style={{
      width: 48, height: 26, border: `1px solid ${INK}`,
      background: on ? INK : 'transparent',
      position: 'relative', transition: 'background 0.18s ease',
      WebkitTapHighlightColor: 'transparent', flexShrink: 0,
      borderRadius: 0,
    }}>
      <div style={{
        position: 'absolute', top: 2, left: on ? 24 : 2,
        width: 20, height: 20,
        background: on ? BONE : INK,
        transition: 'left 0.18s ease',
      }}/>
    </button>
  );
}

// Cleanup styles — kanji stays as visual anchor; label localized.
const CLEANUP_STYLES = [
  { id: 'light',    cn: '輕', labelKey: 'clean.style.light',  descKey: 'clean.style.light.desc' },
  { id: 'standard', cn: '常', labelKey: 'clean.style.std',    descKey: 'clean.style.std.desc' },
  { id: 'email',    cn: '文', labelKey: 'clean.style.email',  descKey: 'clean.style.email.desc' },
];

function CleanupSection({ cleanupOn, setCleanupOn, cleanupModel, setCleanupModel, cleanupStyle, setCleanupStyle }) {
  const { t, lang } = window.useT();
  const current = CLEANUP_STYLES.find(s => s.id === cleanupStyle);
  return (
    <>
      <SectionHeader tag={t('sec.clean.tag')}>{t('sec.clean.title')}</SectionHeader>
      <Card>
        <Row last={!cleanupOn} style={{ padding: '14px 18px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
            <div style={{
              width: 32, height: 32, border: `1px solid ${INK}`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontFamily: 'var(--serif)',
              fontSize: 16, color: INK, lineHeight: 1, flexShrink: 0,
              background: BONE,
            }}>推</div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{
                fontFamily: 'var(--serif)',
                fontSize: 16, color: INK,
                letterSpacing: lang === 'zh' ? '0.02em' : '0.005em',
                fontWeight: 500,
              }}>{t('clean.row.title')}</div>
              <div style={{
                fontFamily: 'var(--serif)',
                fontSize: 12, color: INK3,
                marginTop: 2,
                letterSpacing: lang === 'zh' ? '0.03em' : '0.01em',
                fontStyle: lang === 'zh' ? 'normal' : 'italic',
              }}>{t('clean.row.sub')}</div>
            </div>
            <Toggle on={cleanupOn} onChange={setCleanupOn} />
          </div>
        </Row>

        {cleanupOn && (
          <div className="fade-in">
            <div style={{ padding: '14px 18px 4px', borderTop: `1px solid ${HAIR2}` }}>
              <div style={{ ...monoTag(lang, 10), marginBottom: 10 }}>
                {t('clean.model.label')}
              </div>
              {CLEANUP_MODELS.map((m, i) => (
                <div key={m.id} style={{
                  borderBottom: i < CLEANUP_MODELS.length - 1 ? `1px solid ${HAIR2}` : 'none',
                }}>
                  <RadioRow option={m} selected={cleanupModel === m.id} onSelect={setCleanupModel} last compact />
                </div>
              ))}
            </div>

            <div style={{ padding: '16px 18px 18px', borderTop: `1px solid ${HAIR2}` }}>
              <div style={{ ...monoTag(lang, 10), marginBottom: 10 }}>
                {t('clean.style.label')}
              </div>

              <div style={{ display: 'flex', gap: 8 }}>
                {CLEANUP_STYLES.map(s => {
                  const active = cleanupStyle === s.id;
                  return (
                    <button key={s.id} className="reset" onClick={() => setCleanupStyle(s.id)} style={{
                      flex: 1,
                      border: `1px solid ${INK}`,
                      background: active ? INK : 'transparent',
                      color: active ? BONE : INK,
                      padding: '14px 8px 12px',
                      display: 'flex', flexDirection: 'column',
                      alignItems: 'center', gap: 6,
                      cursor: 'pointer', WebkitTapHighlightColor: 'transparent',
                      transition: 'all 0.15s ease',
                    }}>
                      <div style={{
                        fontFamily: 'var(--serif)',
                        fontSize: 22, lineHeight: 1, fontWeight: 600,
                      }}>{s.cn}</div>
                      <div style={{
                        fontFamily: 'var(--sans)',
                        fontSize: lang === 'zh' ? 12 : 10.5,
                        letterSpacing: lang === 'zh' ? '0.12em' : '0.22em',
                        textTransform: lang === 'zh' ? 'none' : 'uppercase',
                      }}>{t(s.labelKey)}</div>
                    </button>
                  );
                })}
              </div>
              <div style={{
                fontFamily: 'var(--serif)',
                fontSize: 12.5, color: INK3,
                lineHeight: 1.6,
                letterSpacing: lang === 'zh' ? '0.03em' : '0.01em',
                marginTop: 12,
                fontStyle: lang === 'zh' ? 'normal' : 'italic',
                paddingLeft: 12, borderLeft: `1px solid ${INK}`,
              }}>
                {current && t(current.descKey)}
              </div>
            </div>
          </div>
        )}
      </Card>
      <FootNote>{t('clean.footnote')}</FootNote>
    </>
  );
}

// ─── Footer ───────────────────────────────────────────────────
function FooterSection({ onAbout, onClearKey, hasApiKey }) {
  const { t, lang } = window.useT();
  return (
    <>
      <SectionHeader>{t('sec.about.title')}</SectionHeader>
      <Card>
        <button className="reset" onClick={onAbout} style={{
          display: 'flex', alignItems: 'center', gap: 12,
          width: '100%', padding: '14px 18px', textAlign: 'left',
          borderBottom: `1px solid ${HAIR2}`, cursor: 'pointer',
        }}>
          <div style={{ flex: 1,
            fontFamily: 'var(--serif)',
            fontSize: 16, color: INK,
            letterSpacing: lang === 'zh' ? '0.02em' : '0.005em', fontWeight: 500,
          }}>{t('about.privacy')}</div>
          <div style={{ ...monoTag(lang, 10), color: INK }}>{t('about.read')}</div>
        </button>
        <button className="reset" style={{
          display: 'flex', alignItems: 'center', gap: 12,
          width: '100%', padding: '14px 18px', textAlign: 'left', cursor: 'pointer',
        }}>
          <div style={{ flex: 1,
            fontFamily: 'var(--serif)',
            fontSize: 16, color: INK,
            letterSpacing: lang === 'zh' ? '0.02em' : '0.005em', fontWeight: 500,
          }}>{t('about.source')}</div>
          <window.Icon.External size={12} color={INK}/>
        </button>
      </Card>

      {hasApiKey && (
        <div style={{ margin: '20px 22px 0' }}>
          <button className="reset" onClick={onClearKey} style={{
            width: '100%', padding: '14px',
            border: `1px solid ${INK}`,
            background: 'transparent',
            fontFamily: 'var(--sans)',
            fontSize: lang === 'zh' ? 13 : 11,
            color: INK,
            letterSpacing: lang === 'zh' ? '0.14em' : '0.24em',
            textTransform: lang === 'zh' ? 'none' : 'uppercase',
            fontWeight: 500,
          }}>{t('about.clear')}</button>
        </div>
      )}

      <div style={{
        textAlign: 'center',
        fontFamily: 'var(--serif)',
        fontSize: 11.5, color: INK4,
        padding: '36px 24px 48px',
        letterSpacing: lang === 'zh' ? '0.06em' : '0.1em',
        lineHeight: 2,
        fontStyle: lang === 'zh' ? 'normal' : 'italic',
      }}>
        Free Wisper · v1.0.0 (1)<br/>
        {t('about.footer1')}<br/>
        {t('about.footer2')}
      </div>
    </>
  );
}

// ─── Settings root ────────────────────────────────────────────
function SettingsScreen({
  setupState, setSetupState,
  apiKey, setApiKey,
  transModel, setTransModel,
  cleanupOn, setCleanupOn,
  cleanupModel, setCleanupModel,
  cleanupStyle, setCleanupStyle,
}) {
  const { t, lang } = window.useT();
  const [testStatus, setTestStatus] = useStateS(null);
  const [aboutOpen, setAboutOpen] = useStateS(false);

  const steps = [
    { key: 'kb',  label: t('setup.kb.label'),  cta: t('setup.kb.cta'),  doneSub: t('setup.kb.done'),  done: setupState.added },
    { key: 'fa',  label: t('setup.fa.label'),  cta: t('setup.fa.cta'),  doneSub: t('setup.fa.done'),  done: setupState.fullAccess },
    { key: 'key', label: t('setup.key.label'), cta: apiKey ? t('setup.key.cta_done') : t('setup.key.cta'), doneSub: t('setup.key.done'), done: !!apiKey },
  ];

  const handleTest = () => {
    setTestStatus('testing');
    setTimeout(() => {
      if (apiKey.trim().length > 0) setTestStatus('ok');
      else setTestStatus('fail');
      setTimeout(() => setTestStatus(null), 2500);
    }, 800);
  };
  const handlePaste = () => setApiKey('preview-api-key-placeholder');

  return (
    <div style={{ background: PAPER, minHeight: '100%', paddingBottom: 30 }}>
      {/* Masthead */}
      <div style={{
        padding: '14px 22px 22px',
        borderBottom: `1px solid ${INK}`,
        position: 'relative',
      }}>
        <div style={{
          display: 'flex', justifyContent: 'space-between', alignItems: 'center',
          ...monoTag(lang, 9.5),
          marginBottom: 14,
        }}>
          <span>{t('mast.no')}</span>
          <span>{t('mast.section')}</span>
          <span>{t('mast.version')}</span>
        </div>

        <div style={{
          fontFamily: 'var(--serif)',
          fontSize: 40, color: INK,
          letterSpacing: '0.005em',
          fontWeight: 600, lineHeight: 1.02,
        }}>
          Free<br/>Wisper
        </div>
        <div style={{
          fontFamily: 'var(--serif)',
          fontSize: 12.5, color: INK3,
          marginTop: 12,
          letterSpacing: lang === 'zh' ? '0.04em' : '0.04em',
          fontStyle: lang === 'zh' ? 'normal' : 'italic',
          maxWidth: 300, lineHeight: 1.6,
        }}>
          {t('mast.subtitle')}
        </div>
      </div>

      <div style={{ paddingTop: 22 }}>
        <SetupBanner
          steps={steps}
          onTapStep={(s) => {
            if (s.key === 'kb') setSetupState({ ...setupState, added: !setupState.added });
            if (s.key === 'fa') setSetupState({ ...setupState, fullAccess: !setupState.fullAccess });
          }}
        />
      </div>

      <SectionHeader tag={t('sec.key.tag')}>{t('sec.key.title')}</SectionHeader>
      <APIKeyRow
        apiKey={apiKey} setApiKey={setApiKey}
        testStatus={testStatus} onTest={handleTest} onPaste={handlePaste}
      />
      <FootNote>{t('key.footnote')}</FootNote>

      <SectionHeader tag={t('sec.trans.tag')}>{t('sec.trans.title')}</SectionHeader>
      <Card>
        {TRANS_MODELS.map((m, i) => (
          <RadioRow
            key={m.id} option={m}
            selected={transModel === m.id}
            onSelect={setTransModel}
            last={i === TRANS_MODELS.length - 1}
          />
        ))}
      </Card>

      <CleanupSection
        cleanupOn={cleanupOn} setCleanupOn={setCleanupOn}
        cleanupModel={cleanupModel} setCleanupModel={setCleanupModel}
        cleanupStyle={cleanupStyle} setCleanupStyle={setCleanupStyle}
      />

      <FooterSection
        onAbout={() => setAboutOpen(true)}
        onClearKey={() => { setApiKey(''); setTestStatus(null); }}
        hasApiKey={!!apiKey}
      />

      {aboutOpen && <AboutSheet onClose={() => setAboutOpen(false)} />}
    </div>
  );
}

function AboutSheet({ onClose }) {
  const { t, lang } = window.useT();
  return (
    <div className="fade-in" style={{
      position: 'absolute', inset: 0, zIndex: 100,
      background: 'rgba(10,10,10,0.45)',
      display: 'flex', alignItems: 'flex-end',
    }} onClick={onClose}>
      <div onClick={e => e.stopPropagation()} style={{
        background: BONE, width: '100%',
        borderTop: `1px solid ${INK}`,
        padding: '14px 0 36px', maxHeight: '80%', overflow: 'auto',
      }}>
        <div style={{
          width: 36, height: 2, background: INK,
          margin: '0 auto 16px',
        }}/>
        <div style={{ padding: '0 26px' }}>
          <div style={{ ...monoTag(lang, 10), color: INK3, marginBottom: 6 }}>
            {t('sheet.eyebrow')}
          </div>
          <div style={{
            fontFamily: 'var(--serif)',
            fontSize: 26, fontWeight: 600, color: INK,
            letterSpacing: lang === 'zh' ? '0.02em' : '0.005em',
            marginBottom: 16, lineHeight: 1.2,
          }}>
            {t('sheet.title')}
          </div>
          <div style={{
            fontFamily: 'var(--serif)',
            fontSize: 15, lineHeight: 1.75, color: INK,
            letterSpacing: lang === 'zh' ? '0.03em' : '0.005em',
          }}>
            <p style={{ margin: '0 0 14px' }}>{t('sheet.p1')}</p>
            <p style={{ margin: '0 0 14px' }}>
              {t('sheet.p2.before')}<em style={{ fontStyle: lang === 'zh' ? 'normal' : 'italic', fontWeight: lang === 'zh' ? 700 : 400, borderBottom: lang === 'zh' ? `1px solid ${INK}` : 'none' }}>{t('sheet.p2.em')}</em>{t('sheet.p2.after')}
            </p>
            <p style={{ margin: '0 0 14px' }}>{t('sheet.p3')}</p>
            <p style={{ margin: 0, color: INK3, fontStyle: lang === 'zh' ? 'normal' : 'italic' }}>
              {t('sheet.p4')}
            </p>
          </div>
          <button className="reset" onClick={onClose} style={{
            width: '100%', marginTop: 24, padding: 14,
            border: `1px solid ${INK}`, background: INK, color: BONE,
            fontFamily: 'var(--sans)',
            fontSize: lang === 'zh' ? 13 : 11,
            letterSpacing: lang === 'zh' ? '0.16em' : '0.28em',
            textTransform: lang === 'zh' ? 'none' : 'uppercase',
            fontWeight: 500,
          }}>{t('sheet.done')}</button>
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { SettingsScreen, TRANS_MODELS, CLEANUP_MODELS, CLEANUP_STYLES });
