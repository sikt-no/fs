import { useEffect, useRef, useState } from 'preact/hooks';
import { STATUSES, type Entry, type Status } from '../shared/model';
import { PRIORITIES, readHead, setPriority, setStatus, setTitle, type Priority } from './edit';
import { transport } from './transport';

export interface EditorFlush {
  /** Lagrer ulagrede endringer; kaster hvis lagringen feiler */
  flush: () => Promise<void>;
  dirty: () => boolean;
}

interface Props {
  path: string;
  /** Sist parsede versjon av fila; oppdateres etter hver lagring */
  entry: Entry | undefined;
  onClose: () => void;
  /** Registrerer lagringen av ulagrede endringer, som kalles før brukeren navigerer bort */
  onFlush: (f: EditorFlush | null) => void;
  /** Fila har endringer mot main (vises «Lag PR» også uten ulagret tekst) */
  changed?: boolean;
  /** «Lag PR» med denne fila; lagrer først */
  onPr?: () => void;
}

/**
 * Redigering av en krav-fil: felt for status, prioritet og tittel på `Egenskap:`, og hele teksten.
 * Lagring skriver fila til disk; parseren og avvikssjekken kjører som når fila lagres i en editor.
 * Ulagrede endringer lagres når brukeren går til en annen fil eller visning.
 */
export function Editor({ path, entry, onClose, onFlush, changed, onPr }: Props) {
  const [text, setText] = useState<string | null>(null);
  const [saved, setSaved] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [external, setExternal] = useState(false);
  const area = useRef<HTMLTextAreaElement>(null);
  const ownSave = useRef(false);
  const dirty = text !== null && text !== saved;
  const isFeature = path.endsWith('.feature');
  const head = isFeature && text !== null ? readHead(text) : null;
  // Siste tekst og fila den hører til, så lagringen ved navigering virker også etter at fila eller visningen
  // er byttet. Rendringen med ny `path` har fortsatt teksten til den forrige fila, så den oppdaterer ikke refen.
  const latest = useRef({ path, text, saved });
  if (latest.current.path === path) latest.current = { path, text, saved };
  const flush = async () => {
    const cur = latest.current;
    const { path: p, text: t, saved: s } = cur;
    if (t === null || t === s) return;
    cur.saved = t; // lagringen er i gang; ikke lagre det samme to ganger
    ownSave.current = true;
    try {
      await transport.call('save', { path: p, text: t });
    } catch (e) {
      cur.saved = s;
      ownSave.current = false;
      throw e;
    }
    if (latest.current.path === p) setSaved(t);
  };
  useEffect(() => {
    onFlush({ flush, dirty: () => latest.current.text !== null && latest.current.text !== latest.current.saved });
    return () => onFlush(null);
  }, []);

  const load = () =>
    transport.call('read', path).then(
      t => {
        setText(t);
        setSaved(t);
        setExternal(false);
      },
      e => setError(e.message),
    );
  useEffect(() => {
    latest.current = { path, text: null, saved: null };
    setText(null);
    setSaved(null);
    setError(null);
    void load();
    // Byttes fila eller lukkes editoren uten at main har lagret (f.eks. tilbake-knappen): lagre det som står
    return () => void flush().catch(e => alert(`Kunne ikke lagre ${latest.current.path}: ${(e as Error).message}`));
  }, [path]);

  // Fila er endret på disk utenfor vieweren: last inn på nytt, eller varsle hvis det finnes ulagrede endringer
  const savedAt = entry?.savedAt;
  const firstSavedAt = useRef(savedAt);
  useEffect(() => {
    if (savedAt === firstSavedAt.current) return;
    firstSavedAt.current = savedAt;
    if (ownSave.current) return void (ownSave.current = false);
    if (dirty) setExternal(true);
    else void load();
  }, [savedAt]);

  const save = async () => {
    if (text === null || saving) return;
    setSaving(true);
    setError(null);
    try {
      ownSave.current = true;
      await transport.call('save', { path, text });
      setSaved(text);
      setExternal(false);
    } catch (e) {
      ownSave.current = false;
      setError((e as Error).message);
    } finally {
      setSaving(false);
    }
  };

  // Cmd/Ctrl+S lagrer
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 's') {
        e.preventDefault();
        void save();
      }
    };
    addEventListener('keydown', onKey);
    return () => removeEventListener('keydown', onKey);
  });

  /** «Lukk» lagrer og lukker */
  const close = async () => {
    try {
      await flush();
    } catch (e) {
      return setError((e as Error).message);
    }
    onClose();
  };
  const discard = () => {
    if (confirm('Vil du forkaste endringene som ikke er lagret?')) void load();
  };
  const pr = async () => {
    try {
      await flush();
    } catch (e) {
      return setError((e as Error).message);
    }
    onPr?.();
  };

  /** Markerer linja i tekstfeltet (1-basert) */
  const goTo = (ln: number) => {
    const el = area.current;
    if (!el || text === null) return;
    const lines = text.split('\n');
    const from = lines.slice(0, ln - 1).reduce((n, l) => n + l.length + 1, 0);
    el.focus();
    el.setSelectionRange(from, from + (lines[ln - 1]?.length ?? 0));
    const lh = parseFloat(getComputedStyle(el).lineHeight) || 18;
    el.scrollTop = Math.max(0, (ln - 4) * lh);
  };

  const edit = (fn: (t: string) => string) => {
    if (text === null) return;
    try {
      setText(fn(text));
      setError(null);
    } catch (e) {
      setError((e as Error).message);
    }
  };

  const lint = entry?.model?.lint ?? [];
  const parseError = entry?.error;
  return (
    <div class="editor">
      <div class="edhead">
        <span class="mono edpath">{path.slice(path.lastIndexOf('/') + 1)}</span>
        {dirty ? <span class="eddirty">ulagret</span> : text !== null && <span class="muted">lagret</span>}
        <div class="edbtns">
          {dirty && <button class="smallbtn" onClick={discard}>Forkast</button>}
          <button class="smallbtn" onClick={close} title="Lagrer og lukker">Lukk</button>
          {onPr && (changed || dirty) && <button class="smallbtn" onClick={pr} title="Lagrer, og lager PR med fila">Lag PR</button>}
          <button class="primbtn" onClick={save} disabled={!dirty || saving} title="Lagre (⌘S / Ctrl+S)">
            {saving ? 'Lagrer…' : 'Lagre'}
          </button>
        </div>
      </div>

      {external && (
        <div class="edwarn" role="alert">
          Fila er endret utenfor FS Kravforvaltning.{' '}
          <button class="smallbtn" onClick={() => void load()}>Last inn på nytt</button>{' '}
          <button class="smallbtn" onClick={() => setExternal(false)}>Behold mine endringer</button>
        </div>
      )}
      {error && <div class="edwarn err" role="alert">{error}</div>}

      {head && (
        <div class="edfields">
          <label>
            <span>Status</span>
            <select value={head.status ?? ''} onChange={e => edit(t => setStatus(t, ((e.target as HTMLSelectElement).value || null) as Status | null))}>
              <option value="">ingen status</option>
              {STATUSES.map(s => <option key={s} value={s}>@{s}</option>)}
            </select>
          </label>
          <label>
            <span>Prioritet</span>
            <select value={head.priority ?? ''} onChange={e => edit(t => setPriority(t, ((e.target as HTMLSelectElement).value || null) as Priority | null))}>
              <option value="">ingen prioritet</option>
              {PRIORITIES.map(p => <option key={p} value={p}>@{p}</option>)}
            </select>
          </label>
          <label class="edtitle">
            <span>Egenskap</span>
            <input value={head.title} onInput={e => edit(t => setTitle(t, (e.target as HTMLInputElement).value))} />
          </label>
        </div>
      )}

      {text === null ? (
        <div class="empty">{error ? 'Kunne ikke lese fila.' : 'Leser…'}</div>
      ) : (
        <textarea
          ref={area}
          class="edtext mono"
          value={text}
          spellcheck={false}
          onInput={e => setText((e.target as HTMLTextAreaElement).value)}
          aria-label={`Innholdet i ${path}`}
        />
      )}

      {isFeature && (parseError || lint.length > 0) && (
        <div class="edlint">
          <div class="edlint-head">{parseError ? 'Parse-feil ved siste lagring' : `Avvik fra konvensjonene ved siste lagring (${lint.length})`}</div>
          {parseError
            ? <pre class="mono">{parseError.split('\n').slice(0, 4).join('\n')}</pre>
            : lint.map((l, i) => (
                <button key={i} class={'edlint-row ' + l.sev} onClick={() => goTo(l.ln)}>
                  <span class="mono">L{l.ln}</span> {l.msg}
                </button>
              ))}
        </div>
      )}
    </div>
  );
}
