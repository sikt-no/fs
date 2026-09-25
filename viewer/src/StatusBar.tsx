interface Props {
  connected: boolean;
  live: boolean;
  fileName: string;
  savedAt?: number;
  updated: boolean;
  lineNumbers: boolean;
  onLineNumbers: () => void;
  avvik: boolean;
  /** Varsel om avvik som ble rettet ved siste lagring */
  fixMsg: string | null;
}

const time = (ms: number) => new Date(ms).toTimeString().slice(0, 8);

export function StatusBar({ connected, live, fileName, savedAt, updated, lineNumbers, onLineNumbers, avvik, fixMsg }: Props) {
  if (avvik)
    return (
      <footer class="statusbar">
        {live && (
          <span style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
            <span class="dot" style={{ width: '6px', height: '6px', background: connected ? 'var(--st-implemented)' : 'var(--err)' }} />
            {connected ? 'ws tilkoblet' : 'ws frakoblet'}
          </span>
        )}
        <span class="muted">{live ? `vite · ${location.host}` : 'GitHub Pages · statisk bygg fra main'}</span>
        {fixMsg && <span class="updated">↻ {fixMsg}</span>}
      </footer>
    );
  return (
    <footer class="statusbar">
      <span style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
        <span class="dot" style={{ width: '6px', height: '6px', background: !live ? 'var(--muted)' : connected ? 'var(--st-implemented)' : 'var(--err)' }} />
        {!live ? 'statisk bygg' : connected ? 'ws tilkoblet' : 'ws frakoblet'}
      </span>
      {live && <span class="muted">vite · {location.host}</span>}
      <span>{fileName}</span>
      {live && savedAt && <span class="muted">lagret {time(savedAt)}</span>}
      {updated && <span class="updated">↻ oppdatert</span>}
      <div style={{ marginLeft: 'auto' }}>
        <button class="smallbtn mono" style={{ fontSize: '11px' }} onClick={onLineNumbers} aria-pressed={lineNumbers}>
          Linjenumre {lineNumbers ? 'på' : 'av'}
        </button>
      </div>
    </footer>
  );
}
