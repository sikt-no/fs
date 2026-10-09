import { useEffect, useRef, useState } from 'preact/hooks';
import { Terminal } from '@xterm/xterm';
import { FitAddon } from '@xterm/addon-fit';
import '@xterm/xterm/css/xterm.css';
import type { PtyEvent } from '../shared/api';
import type { TerminalSession } from './claudeChat';
import { transport } from './transport';

/** Fargene fra temaet (lyst eller mørkt), lest fra CSS-variablene når terminalen lages */
function themeOf(el: HTMLElement) {
  const css = getComputedStyle(el);
  const v = (name: string, fallback: string) => css.getPropertyValue(name).trim() || fallback;
  return {
    background: v('--surface', '#ffffff'),
    foreground: v('--ink', '#1c1c1e'),
    cursor: v('--acc', '#643ffa'),
    selectionBackground: v('--acc-soft', '#ece9ff'),
  };
}

interface Props {
  session: TerminalSession;
  /** Økten er avsluttet (eller backenden kjenner den ikke lenger: `null`) */
  onExit: (code: number | null) => void;
}

/**
 * Terminalen i Claude-panelet: interaktiv `claude` med agent teams, i en pseudo-terminal i backenden (`core/pty.ts`).
 * Tastetrykk går til `ptyWrite`, og størrelsen følger panelet (`ptyResize`). Etter en omlasting spilles det siste
 * økten skrev av igjen (`ptyBuffer`).
 */
export function TerminalView({ session, onExit }: Props) {
  const host = useRef<HTMLDivElement>(null);
  const [error, setError] = useState<string | null>(null);
  // claude har ikke skrevet noe ennå: den starter og kobler til MCP-serverne
  const [waiting, setWaiting] = useState(true);
  const { id, exited } = session;
  const exitRef = useRef(onExit);
  exitRef.current = onExit;

  useEffect(() => {
    const el = host.current;
    if (!el) return;
    const term = new Terminal({
      fontFamily: getComputedStyle(el).getPropertyValue('--mono').trim() || 'ui-monospace, monospace',
      fontSize: 12,
      cursorBlink: true,
      scrollback: 5000,
      allowProposedApi: false,
      theme: themeOf(el),
    });
    const fit = new FitAddon();
    term.loadAddon(fit);
    term.open(el);
    let alive = true;
    let ready = false;
    const queue: string[] = [];
    const resize = () => {
      try {
        fit.fit();
      } catch {
        return; // skjult panel: ingen størrelse
      }
      if (!exited) void transport.call('ptyResize', { id, cols: term.cols, rows: term.rows }).catch(() => {});
    };
    const off = transport.on('krav:pty', (ev: PtyEvent) => {
      if (ev.id !== id) return;
      if (ev.kind === 'exit') return exitRef.current(ev.code);
      setWaiting(false);
      if (ready) term.write(ev.data);
      else queue.push(ev.data);
    });
    const input = term.onData(data => void transport.call('ptyWrite', { id, data }).catch(() => {}));
    const ro = new ResizeObserver(() => resize());
    ro.observe(el);
    // Det økten har skrevet til nå, så hendelsene som kom mens bufferet ble hentet
    void (async () => {
      try {
        const [buf, active] = await Promise.all([transport.call('ptyBuffer', id), transport.call('ptyActive')]);
        if (!alive) return;
        term.write(buf);
        if (buf) setWaiting(false);
        for (const d of queue) if (!buf.endsWith(d)) term.write(d);
        ready = true;
        const info = active.find(a => a.id === id);
        if (!info) {
          if (!exited) exitRef.current(null);
        } else if (info.exited && !exited) exitRef.current(info.code);
        resize();
        if (!exited) term.focus();
      } catch (e) {
        setError((e as Error).message);
      }
    })();
    return () => {
      alive = false;
      off();
      input.dispose();
      ro.disconnect();
      term.dispose();
    };
  }, [id]);

  const starting = waiting && !exited;

  return (
    <div class="cterm">
      <div class="cterm-bar">
        {starting ? <span class="spinner" aria-hidden="true" /> : <span class={'cdot' + (exited ? (session.code === 0 ? ' ok' : ' off') : '')} />}
        <span>
          {starting
            ? 'Starter claude …'
            : exited
            ? session.code === null || session.code === undefined
              ? 'Avsluttet (appen eller dev-serveren ble startet på nytt)'
              : `Avsluttet (kode ${session.code})`
            : 'Kjører · agent teams'}
        </span>
        <span class="mono muted cterm-mode">{session.mode === 'execute' ? `utfører i ${session.repo ?? ''}` : 'verifiserer'}</span>
        {!exited && (
          <button class="smallbtn" onClick={() => void transport.call('ptyKill', id)} title="Avslutter claude i terminalen">
            Stopp
          </button>
        )}
      </div>
      {error && <div class="edwarn err" role="alert">{error}</div>}
      {/* Laget ligger ved siden av cterm-host, der xterm legger sine egne elementer */}
      <div class="cterm-body">
        <div class="cterm-host" ref={host} />
        {starting && (
          <div class="cterm-wait" role="status">
            <span class="spinner" aria-hidden="true" />
            Starter Claude Code og kobler til MCP-serverne. Det kan ta litt tid første gang.
          </div>
        )}
      </div>
      <div class="claude-send">
        <span class="muted">Svar på spørsmål og godkjenn verktøykall i terminalen. Endringene vises straks, og sendes med «Lag PR».</span>
      </div>
    </div>
  );
}
