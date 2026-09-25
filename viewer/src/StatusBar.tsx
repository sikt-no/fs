interface Props {
  connected: boolean;
  live: boolean;
  fileName: string;
  savedAt?: number;
  updated: boolean;
  lineNumbers: boolean;
  onLineNumbers: () => void;
}

const time = (ms: number) => new Date(ms).toTimeString().slice(0, 8);

export function StatusBar({ connected, live, fileName, savedAt, updated, lineNumbers, onLineNumbers }: Props) {
  return (
    <footer class="statusbar">
      <span style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
        <span class="dot" style={{ width: '6px', height: '6px', background: connected ? 'var(--st-implemented)' : 'var(--err)' }} />
        {!live ? 'statisk bygg' : connected ? 'ws tilkoblet' : 'ws frakoblet'}
      </span>
      <span class="muted">vite · {location.host}</span>
      <span>{fileName}</span>
      {savedAt && <span class="muted">lagret {time(savedAt)}</span>}
      {updated && <span class="updated">↻ oppdatert</span>}
      <div style={{ marginLeft: 'auto' }}>
        <button class="smallbtn mono" style={{ fontSize: '11px' }} onClick={onLineNumbers} aria-pressed={lineNumbers}>
          Linjenumre {lineNumbers ? 'på' : 'av'}
        </button>
      </div>
    </footer>
  );
}
