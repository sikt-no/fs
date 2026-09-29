import { useEffect, useState } from 'preact/hooks';
import type { CodeDir } from '../shared/api';
import { transport } from './transport';

// Stiene brukeren har valgt, per kodeklone. Uten valg bruker backenden KRAV_FS_ADMIN / KRAV_FS_PLATTFORM,
// ellers mappa ved siden av repoet (dev-serveren). Desktop-appen har ingen standardsti: mappa velges her.
const KEY = 'kravforvaltning:claudeDirs';
const read = (): Record<string, string> => {
  try {
    const v = JSON.parse(localStorage.getItem(KEY) ?? 'null');
    return v && typeof v === 'object' ? v : {};
  } catch {
    return {};
  }
};
let overrides = read();
const write = (next: Record<string, string>) => {
  overrides = next;
  try {
    localStorage.setItem(KEY, JSON.stringify(next));
  } catch {
    /* utilgjengelig lagring: gjelder til vieweren lastes på nytt */
  }
};

// Mappene med status, delt mellom «Kodemapper» og panelet (som gråtoner fs-verify uten kode i desktop-appen)
let dirs: CodeDir[] | null = null;
const listeners = new Set<() => void>();
const refresh = () =>
  transport.call('claudeDirs', overrides).then(
    d => {
      dirs = d;
      listeners.forEach(l => l());
      return d;
    },
    () => [] as CodeDir[],
  );

/** Kodeklonene som finnes, til `claudeRun`. Backenden sjekker dem igjen før de får `--add-dir`. */
export async function codeDirPaths(): Promise<string[]> {
  return (await refresh()).filter(d => d.exists).map(d => d.path);
}

/** Mappene med status; `null` til backenden har svart */
export function useCodeDirs(): CodeDir[] | null {
  const [, force] = useState(0);
  useEffect(() => {
    const l = () => force(n => n + 1);
    listeners.add(l);
    if (!dirs) void refresh();
    return () => void listeners.delete(l);
  }, []);
  return dirs;
}

const set = (name: string, value: string | null) => {
  const next = { ...overrides };
  if (value?.trim()) next[name] = value.trim();
  else delete next[name];
  write(next);
  void refresh();
};

/**
 * Kodeklonene Claude kan lese (fs-admin, fs-plattform), sammenfoldet over inputfeltet. Viser stien og om
 * mappa finnes. I desktop-appen velges mappa med mappevelgeren; i nettleseren kan stien skrives inn, og
 * en tom sti går tilbake til standardstien.
 */
export function CodeDirs() {
  const list = useCodeDirs();
  if (!list?.length) return null;
  const electron = transport.kind === 'electron';
  const found = list.filter(d => d.exists).length;
  const pick = (name: string) =>
    transport.call('pickDir').then(
      p => p && set(name, p),
      e => alert((e as Error).message),
    );
  return (
    <details class="cdirs" open={electron && found === 0 ? true : undefined}>
      <summary title="Lokale kopier av kode-repoene som Claude kan lese koden i (bare lesing), f.eks. for fs-verify">
        Kodemapper <span class={found < list.length ? 'cdirs-miss' : 'muted'}>{found} av {list.length}</span>
      </summary>
      {electron && found === 0 && <div class="muted cdirs-note">Velg de lokale kopiene dine av kode-repoene for å bruke fs-verify.</div>}
      {list.map(d =>
        electron ? (
          <div key={d.name} class="cdir">
            <span class="mono">{d.name}</span>
            <span class="mono cdir-path" title={d.path}>{d.path || <span class="muted">ikke valgt</span>}</span>
            <span class="cdir-btns">
              <button class="smallbtn" onClick={() => void pick(d.name)} aria-label={`Velg mappe for ${d.name}`}>
                Velg mappe …
              </button>
              {overrides[d.name] && (
                <button class="smallbtn" onClick={() => set(d.name, null)} aria-label={`Fjern mappa for ${d.name}`}>
                  Fjern
                </button>
              )}
            </span>
            {d.path && !d.exists && <span class="cdirs-miss cdir-full">Mappa finnes ikke</span>}
          </div>
        ) : (
          <label key={d.name} class="cdir">
            <span class="mono">{d.name}</span>
            <input
              class="mono"
              value={overrides[d.name] ?? ''}
              placeholder={d.path}
              onChange={e => set(d.name, (e.target as HTMLInputElement).value)}
              aria-label={`Sti til ${d.name}`}
            />
            <span class={d.exists ? 'muted' : 'cdirs-miss'}>{d.exists ? 'finnes' : 'mangler'}</span>
          </label>
        ),
      )}
    </details>
  );
}
