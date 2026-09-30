import { useEffect, useMemo, useRef, useState } from 'preact/hooks';
import type { AuthStatus, PublishResult } from '../shared/api';
import type { GitInfo, Snapshot } from '../shared/model';
import { draftPicked, prTitle } from './edit';
import { transport } from './transport';

interface Props {
  git: GitInfo;
  entries: Snapshot;
  /** Fila «Lag PR» ble åpnet fra; krysses av i tillegg til det som er valgt i utkastet */
  preselect?: string;
  onClose: () => void;
}

/** PR-en brukeren holder på med: valgte filer, tittel, branch og beskrivelse, til PR-en er opprettet */
interface Draft {
  picked: string[];
  title: string | null;
  branch: string | null;
  body: string;
}
const DRAFT_KEY = 'kravforvaltning:prDraft';
function readDraft(): Draft | null {
  try {
    return JSON.parse(localStorage.getItem(DRAFT_KEY) ?? 'null');
  } catch {
    return null;
  }
}
function writeDraft(d: Draft | null) {
  try {
    if (d) localStorage.setItem(DRAFT_KEY, JSON.stringify(d));
    else localStorage.removeItem(DRAFT_KEY);
  } catch {
    /* ignorer */
  }
}

const CODE_LABEL = { M: 'endret', A: 'ny', U: 'ny', D: 'slettet' } as const;

/**
 * «Lag PR», vist i detaljvinduet: velg krav-filer med endringer, gi PR-en tittel og beskrivelse, og send den.
 * Backenden lager en ny branch fra origin/main med filene slik de er på disk, pusher og oppretter PR-en.
 * Mangler innlogging, logges brukeren inn mot GitHub her (device flow), eller får beskjed om `gh auth login`.
 * Valgene og tekstene lagres som utkast, så brukeren kan lukke visningen, gå andre steder og fortsette senere.
 */
export function PrDialog({ git, entries, preselect, onClose }: Props) {
  // Ucommittede endringer først; filer som bare er committet i branchen kan også tas med
  const changes = useMemo(() => {
    const seen = new Set<string>();
    return [...git.uncommitted, ...git.committed].filter(c => !seen.has(c.path) && seen.add(c.path));
  }, [git]);
  const [draft] = useState(readDraft);
  const [hasDraft, setHasDraft] = useState(!!draft);
  const [picked, setPicked] = useState<Set<string>>(() => new Set(draftPicked(draft?.picked ?? null, preselect, git.uncommitted.map(c => c.path))));
  const titles = useMemo(() => Object.fromEntries(Object.values(entries).map(e => [e.path, e.model?.title])), [entries]);
  const paths = changes.map(c => c.path).filter(p => picked.has(p));
  const suggested = prTitle(paths.length ? paths : changes.map(c => c.path), titles);
  const [title, setTitle] = useState<string | null>(draft?.title ?? null);
  const [branch, setBranch] = useState<string | null>(draft?.branch ?? null);
  const [body, setBody] = useState(draft?.body ?? '');
  const [auth, setAuth] = useState<AuthStatus | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [done, setDone] = useState<PublishResult | null>(null);
  const shownTitle = title ?? suggested;
  const shownBranch = branch ?? shownTitle.replace(/^Krav:\s*/, '');

  // Lagre utkastet når brukeren endrer noe (ikke bare ved å åpne visningen)
  const touched = useRef(false);
  useEffect(() => {
    if (!touched.current) return void (touched.current = true);
    if (done) return;
    writeDraft({ picked: [...picked], title, branch, body });
    setHasDraft(true);
  }, [picked, title, branch, body]);
  const clearDraft = () => {
    writeDraft(null);
    setHasDraft(false);
    touched.current = false;
    setPicked(new Set(draftPicked(null, preselect, git.uncommitted.map(c => c.path))));
    setTitle(null);
    setBranch(null);
    setBody('');
  };

  useEffect(() => {
    // Åpnet fra en fil som ikke er med i utkastet: fila er lagt til, og blir stående i utkastet
    if (draft && preselect && !draft.picked.includes(preselect)) writeDraft({ ...draft, picked: [...picked] });
    transport.call('authStatus').then(setAuth, e => setError(e.message));
  }, []);

  // Venter på at brukeren godkjenner på github.com/login/device
  useEffect(() => {
    if (auth?.state !== 'pending') return;
    const t = setInterval(() => {
      transport.call('authPoll').then(setAuth, e => {
        setError(e.message);
        setAuth({ state: 'none', canLogin: true });
      });
    }, 2000);
    return () => clearInterval(t);
  }, [auth?.state]);

  const login = () => {
    setError(null);
    transport.call('authStart').then(setAuth, e => setError(e.message));
  };

  const publish = async () => {
    setBusy(true);
    setError(null);
    try {
      setDone(await transport.call('publish', { paths, branch: shownBranch, title: shownTitle, body }));
      writeDraft(null);
    } catch (e) {
      setError((e as Error).message);
    } finally {
      setBusy(false);
    }
  };

  const toggle = (p: string) =>
    setPicked(s => {
      const n = new Set(s);
      if (n.has(p)) n.delete(p);
      else n.add(p);
      return n;
    });

  return (
    <div class="prdialog">
      <div class="prhead">
        <h2>Lag PR</h2>
        <button class="smallbtn" onClick={onClose} title="Utkastet blir stående">Lukk</button>
      </div>

      {done ? (
        <div class="prdone">
          <p>PR-en er opprettet fra <span class="mono">{done.branch}</span>.</p>
          <p><a href={done.url} target="_blank" rel="noreferrer">{done.url} ↗</a></p>
          <p class="muted">Endringene ligger fortsatt i filene dine lokalt til PR-en er merget.</p>
        </div>
      ) : (
        <>
          <fieldset class="prfiles">
            <legend>Filer ({paths.length} av {changes.length})</legend>
            {changes.length === 0 && <div class="muted">Ingen endrede krav-filer.</div>}
            {changes.map(c => (
              <label key={c.path}>
                <input type="checkbox" checked={picked.has(c.path)} onChange={() => toggle(c.path)} />
                <span class="mono prpath" title={c.path}>{c.path.replace(/^krav\//, '')}</span>
                <span class={'prcode ' + c.code}>{CODE_LABEL[c.code]}</span>
                <span class="mono muted">+{c.plus} −{c.minus}</span>
              </label>
            ))}
          </fieldset>

          <label class="prfield">
            <span>Tittel</span>
            <input value={shownTitle} onInput={e => setTitle((e.target as HTMLInputElement).value)} />
          </label>
          <label class="prfield">
            <span>Branch</span>
            <div class="prbranch">
              <span class="mono muted">krav/</span>
              <input class="mono" value={shownBranch} onInput={e => setBranch((e.target as HTMLInputElement).value)} />
            </div>
          </label>
          <label class="prfield">
            <span>Beskrivelse</span>
            <textarea rows={4} value={body} onInput={e => setBody((e.target as HTMLTextAreaElement).value)} placeholder="Hva er endret, og hvorfor?" />
          </label>

          <div class="prauth">
            {!auth ? (
              <span class="muted">Sjekker innlogging…</span>
            ) : auth.state === 'ok' ? (
              <span>
                Innlogget på GitHub{auth.login ? <> som <b>{auth.login}</b></> : ''}
                {auth.source === 'gh' ? ' (via gh)' : ''}
                {auth.source === 'device' && (
                  <button class="linkbtn" onClick={() => transport.call('authLogout').then(setAuth)}>Logg ut</button>
                )}
              </span>
            ) : auth.state === 'pending' ? (
              <span>
                Åpne <a href={auth.verificationUri} target="_blank" rel="noreferrer">{auth.verificationUri} ↗</a> og skriv inn koden{' '}
                <b class="mono prcode-big">{auth.userCode}</b>
                <span class="muted"> · venter på godkjenning…</span>
              </span>
            ) : auth.canLogin ? (
              <span>
                {auth.expired && <span class="muted">GitHub godtar ikke lenger innloggingen din. </span>}
                <button class="smallbtn" onClick={login}>Logg inn med GitHub</button>
              </span>
            ) : transport.kind === 'electron' ? (
              <span class="muted">Innlogging mot GitHub er ikke satt opp i denne versjonen av appen (mangler OAuth-klient).</span>
            ) : (
              <span class="muted">
                Ikke innlogget. Kjør <span class="mono">gh auth login</span> i en terminal, eller start FS Kravforvaltning med{' '}
                <span class="mono">KRAV_GITHUB_CLIENT_ID</span> satt.
              </span>
            )}
          </div>

          {error && <div class="edwarn err" role="alert">{error}</div>}

          <div class="prfoot">
            <span class="muted">
              Ny branch fra origin/main med filene slik de er på disk. Lokale filer og branch endres ikke.
              {hasDraft && (
                <>
                  {' '}Utkastet er lagret.{' '}
                  <button class="linkbtn" onClick={clearDraft}>Tøm utkast</button>
                </>
              )}
            </span>
            <button class="primbtn" disabled={busy || !paths.length || auth?.state !== 'ok' || !shownTitle.trim()} onClick={publish}>
              {busy ? 'Lager PR…' : 'Lag PR'}
            </button>
          </div>
        </>
      )}
    </div>
  );
}
