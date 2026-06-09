// SF-Symbol-style glyphs drawn from scratch (original, not Apple's actual SVGs).
// All accept size + color.

const Icon = {
  Mic: ({ size = 22, color = '#fff' }) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <rect x="9" y="3" width="6" height="12" rx="3" fill={color}/>
      <path d="M6 11.5a6 6 0 0012 0" stroke={color} strokeWidth="1.8" strokeLinecap="round"/>
      <path d="M12 17.5V21" stroke={color} strokeWidth="1.8" strokeLinecap="round"/>
      <path d="M8.5 21h7" stroke={color} strokeWidth="1.8" strokeLinecap="round"/>
    </svg>
  ),
  Globe: ({ size = 22, color = '#000' }) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <circle cx="12" cy="12" r="9" stroke={color} strokeWidth="1.6"/>
      <ellipse cx="12" cy="12" rx="4.5" ry="9" stroke={color} strokeWidth="1.6"/>
      <path d="M3 12h18" stroke={color} strokeWidth="1.6"/>
    </svg>
  ),
  Backspace: ({ size = 24, color = '#000' }) => (
    <svg width={size} height={size + 4} viewBox="0 0 26 22" fill="none">
      <path d="M8 1h14a3 3 0 013 3v14a3 3 0 01-3 3H8L1 11 8 1z" stroke={color} strokeWidth="1.7" strokeLinejoin="round"/>
      <path d="M12 7l8 8M20 7l-8 8" stroke={color} strokeWidth="1.7" strokeLinecap="round"/>
    </svg>
  ),
  Check: ({ size = 16, color = '#fff' }) => (
    <svg width={size} height={size} viewBox="0 0 16 16" fill="none">
      <path d="M3 8.5l3.2 3.2L13 5" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  ),
  Warn: ({ size = 16, color = '#fff' }) => (
    <svg width={size} height={size} viewBox="0 0 16 16" fill="none">
      <path d="M8 4.5v4" stroke={color} strokeWidth="2" strokeLinecap="round"/>
      <circle cx="8" cy="11.5" r="1.1" fill={color}/>
    </svg>
  ),
  Bang: ({ size = 16, color = '#fff' }) => (
    <svg width={size} height={size} viewBox="0 0 16 16" fill="none">
      <path d="M8 3.5v6" stroke={color} strokeWidth="2.2" strokeLinecap="round"/>
      <circle cx="8" cy="12" r="1.2" fill={color}/>
    </svg>
  ),
  Chevron: ({ size = 13, color = 'rgba(60,60,67,0.3)' }) => (
    <svg width={size * 0.55} height={size} viewBox="0 0 7 13" fill="none">
      <path d="M1 1l5 5.5L1 12" stroke={color} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  ),
  ChevronDown: ({ size = 12, color = 'rgba(60,60,67,0.6)' }) => (
    <svg width={size} height={size * 0.6} viewBox="0 0 12 7" fill="none">
      <path d="M1 1l5 5 5-5" stroke={color} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  ),
  Eye: ({ size = 18, color = '#8E8E93', off = false }) => (
    <svg width={size} height={size * 0.7} viewBox="0 0 20 14" fill="none">
      <path d="M1 7s3.5-6 9-6 9 6 9 6-3.5 6-9 6S1 7 1 7z" stroke={color} strokeWidth="1.4"/>
      <circle cx="10" cy="7" r="2.5" stroke={color} strokeWidth="1.4"/>
      {off && <path d="M2 1l16 12" stroke={color} strokeWidth="1.4" strokeLinecap="round"/>}
    </svg>
  ),
  External: ({ size = 12, color = '#8E8E93' }) => (
    <svg width={size} height={size} viewBox="0 0 12 12" fill="none">
      <path d="M4 1h7v7" stroke={color} strokeWidth="1.6" strokeLinecap="round"/>
      <path d="M11 1L5 7" stroke={color} strokeWidth="1.6" strokeLinecap="round"/>
      <path d="M9 7v3.5a.5.5 0 01-.5.5h-7a.5.5 0 01-.5-.5v-7a.5.5 0 01.5-.5H5" stroke={color} strokeWidth="1.6" strokeLinecap="round"/>
    </svg>
  ),
  Bolt: ({ size = 14, color = '#fff' }) => (
    <svg width={size} height={size} viewBox="0 0 14 14" fill="none">
      <path d="M8 1L2 8h4l-1 5 6-7H7l1-5z" fill={color}/>
    </svg>
  ),
  Sparkle: ({ size = 14, color = '#AF52DE' }) => (
    <svg width={size} height={size} viewBox="0 0 14 14" fill="none">
      <path d="M7 1l1.3 4.2 4.2 1.3-4.2 1.3L7 12 5.7 7.8 1.5 6.5l4.2-1.3L7 1z" fill={color}/>
    </svg>
  ),
  Key: ({ size = 16, color = '#fff' }) => (
    <svg width={size} height={size} viewBox="0 0 18 18" fill="none">
      <circle cx="6" cy="9" r="3.4" stroke={color} strokeWidth="1.6"/>
      <path d="M9.4 9H16M14 9v2.5M12 9v2" stroke={color} strokeWidth="1.6" strokeLinecap="round"/>
    </svg>
  ),
  Keyboard: ({ size = 16, color = '#fff' }) => (
    <svg width={size + 2} height={size} viewBox="0 0 20 16" fill="none">
      <rect x="1.5" y="2" width="17" height="12" rx="2.5" stroke={color} strokeWidth="1.5"/>
      <path d="M4 6h.5M7 6h.5M10 6h.5M13 6h.5M16 6h.5M4 9h.5M7 9h.5M10 9h.5M13 9h.5M16 9h.5M5 11.5h10" stroke={color} strokeWidth="1.4" strokeLinecap="round"/>
    </svg>
  ),
  Lock: ({ size = 14, color = '#fff' }) => (
    <svg width={size} height={size + 2} viewBox="0 0 14 16" fill="none">
      <rect x="2" y="6.5" width="10" height="8" rx="1.5" stroke={color} strokeWidth="1.5"/>
      <path d="M4.5 6.5V4.5a2.5 2.5 0 015 0v2" stroke={color} strokeWidth="1.5"/>
    </svg>
  ),
  Plus: ({ size = 14, color = '#007AFF' }) => (
    <svg width={size} height={size} viewBox="0 0 14 14" fill="none">
      <path d="M7 2v10M2 7h10" stroke={color} strokeWidth="2" strokeLinecap="round"/>
    </svg>
  ),
  Info: ({ size = 18, color = '#8E8E93' }) => (
    <svg width={size} height={size} viewBox="0 0 18 18" fill="none">
      <circle cx="9" cy="9" r="7.5" stroke={color} strokeWidth="1.4"/>
      <path d="M9 8v5" stroke={color} strokeWidth="1.6" strokeLinecap="round"/>
      <circle cx="9" cy="5.6" r="0.9" fill={color}/>
    </svg>
  ),
  Trash: ({ size = 16, color = '#FF3B30' }) => (
    <svg width={size} height={size} viewBox="0 0 16 16" fill="none">
      <path d="M3 4.5h10M6.5 4.5V3a1 1 0 011-1h1a1 1 0 011 1v1.5" stroke={color} strokeWidth="1.5" strokeLinecap="round"/>
      <path d="M4 4.5l.6 8.2a1 1 0 001 .9h4.8a1 1 0 001-.9L12 4.5" stroke={color} strokeWidth="1.5" strokeLinecap="round"/>
    </svg>
  ),
  Note: ({ size = 18, color = '#FFB800' }) => (
    <svg width={size} height={size} viewBox="0 0 18 18" fill="none">
      <path d="M2.5 2h10l3 3v11H2.5V2z" fill={color}/>
      <path d="M12.5 2v3h3" fill="#fff" opacity="0.55"/>
    </svg>
  ),
  Cancel: ({ size = 18, color = '#fff' }) => (
    <svg width={size} height={size} viewBox="0 0 18 18" fill="none">
      <path d="M4.5 4.5l9 9M13.5 4.5l-9 9" stroke={color} strokeWidth="2" strokeLinecap="round"/>
    </svg>
  ),
};

window.Icon = Icon;
