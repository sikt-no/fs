// Tilstandsfila `tasks/<d>/<s>/utforing.md`: hvor hver spesifikasjon i oppgaven er på veien gjennom
// kode-repoene (rute, steg, hvem som har steget, PR, overlevering, blokkering) og en logg. Formatet står i
// tasks/README.md. Rene funksjoner, testet i utforing.test.ts.

export const STEP_STATUSES = ['venter', 'pågår', 'levert'] as const;
export type StepStatus = (typeof STEP_STATUSES)[number];

export interface StepState {
  repo: string;
  status: StepStatus;
  /** `@person` eller `agent:<rolle>`; tom når ingen har tatt steget */
  by: string;
  pr: string[];
  /** Det neste steg trenger å vite (fritekst, ofte en liste) */
  handoff: string;
  /** Grunn til blokkering, eller null */
  blocked: string | null;
  /** Datoen fs-verify sendte steget tilbake, eller null */
  back: string | null;
}

export interface LogLine {
  d: string;
  who: string;
  t: string;
}

export interface SpecRun {
  /** Stien til spesifikasjonen, relativt til oppgavemappa: `spec/spec-x.md` */
  spec: string;
  route: string[];
  steps: StepState[];
  log: LogLine[];
}

export interface Utforing {
  runs: SpecRun[];
}

const EMPTY = /^[–—-]?$/;

export const emptyStep = (repo: string): StepState => ({ repo, status: 'venter', by: '', pr: [], handoff: '', blocked: null, back: null });

/** `- **Nøkkel**: verdi` med innrykkede linjer under, i rekkefølge */
function fields(ls: string[]): { key: string; value: string; sub: string[] }[] {
  const out: { key: string; value: string; sub: string[] }[] = [];
  for (const l of ls) {
    const m = l.match(/^-\s+\*\*([^*]+?):?\*\*:?\s*(.*)$/);
    if (m) out.push({ key: m[1].trim().toLowerCase(), value: m[2].trim(), sub: [] });
    else if (out.length && /^\s{2,}\S/.test(l)) out[out.length - 1].sub.push(l.replace(/^ {2}/, ''));
  }
  return out;
}

const listItems = (sub: string[]) => sub.map(l => l.replace(/^\s*[-*]\s+/, '').trim()).filter(Boolean);

export function parseUtforing(text: string): Utforing {
  const ls = text.replace(/\r\n/g, '\n').split('\n');
  const runs: SpecRun[] = [];
  let run: SpecRun | null = null;
  let block: string[] = [];
  let repo: string | null = null;
  const flush = () => {
    if (!run) return;
    const fs = fields(block);
    if (repo === null) {
      for (const f of fs) {
        if (f.key === 'rute') run.route = f.value.split(/→|,|->/).map(s => s.replace(/`/g, '').trim()).filter(s => s && !EMPTY.test(s));
        if (f.key === 'logg') {
          for (const item of listItems(f.sub)) {
            const [d, who, ...t] = item.split(/\s+—\s+/);
            if (d && who) run.log.push({ d: d.trim(), who: who.trim(), t: t.join(' — ').trim() });
          }
        }
      }
    } else {
      const st = emptyStep(repo);
      for (const f of fs) {
        const v = f.value.replace(/`/g, '');
        if (f.key === 'status' && (STEP_STATUSES as readonly string[]).includes(v)) st.status = v as StepStatus;
        if (f.key === 'tatt av' && !EMPTY.test(v)) st.by = v;
        if (f.key === 'pr') st.pr = [...v.split(/[\s,]+/).filter(x => x && !EMPTY.test(x)), ...listItems(f.sub)];
        if (f.key === 'overlevering') st.handoff = [...(EMPTY.test(f.value) ? [] : [f.value]), ...f.sub].join('\n').trim();
        if (f.key === 'blokkert' && !EMPTY.test(f.value)) st.blocked = f.value;
        if (f.key === 'tilbake' && !EMPTY.test(f.value)) st.back = f.value;
      }
      run.steps.push(st);
    }
    block = [];
  };
  for (const l of ls) {
    const h2 = l.match(/^## (.+)$/);
    const h3 = l.match(/^### (.+)$/);
    if (h2) {
      flush();
      repo = null;
      const spec = h2[1].replace(/`/g, '').trim();
      run = /^spec\/.+\.md$/.test(spec) ? { spec, route: [], steps: [], log: [] } : null;
      if (run) runs.push(run);
    } else if (h3 && run) {
      flush();
      repo = h3[1].replace(/`/g, '').trim();
    } else block.push(l);
  }
  flush();
  // Steg som står i ruta men mangler egen seksjon, venter
  for (const r of runs) for (const repo of r.route) if (!r.steps.some(s => s.repo === repo)) r.steps.push(emptyStep(repo));
  return { runs };
}

const HEADER = [
  '# Utføring',
  '',
  'Hvor spesifikasjonene i denne oppgaven er på veien gjennom kode-repoene. Formatet og protokollen står i [tasks/README.md](../../README.md#utføring).',
  '',
];

export function serializeUtforing(u: Utforing): string {
  const out = [...HEADER];
  for (const r of u.runs) {
    out.push(`## ${r.spec}`, '', `- **Rute**: ${r.route.length ? r.route.join(' → ') : '–'}`);
    if (r.log.length) out.push('- **Logg**:', ...r.log.map(e => `  - ${e.d} — ${e.who} — ${e.t}`));
    out.push('');
    for (const repo of r.route) {
      const s = r.steps.find(x => x.repo === repo) ?? emptyStep(repo);
      out.push(`### ${repo}`, '', `- **Status**: ${s.status}`, `- **Tatt av**: ${s.by || '–'}`);
      out.push(s.pr.length ? '- **PR**:' : '- **PR**: –', ...s.pr.map(p => `  - ${p}`));
      const ho = s.handoff.trim();
      out.push(ho ? '- **Overlevering**:' : '- **Overlevering**: –', ...(ho ? ho.split('\n').map(l => (l.trim() ? '  ' + l : '')) : []));
      out.push(`- **Blokkert**: ${s.blocked ?? '–'}`);
      if (s.back) out.push(`- **Tilbake**: ${s.back}`);
      out.push('');
    }
  }
  return out.join('\n').replace(/\n{3,}/g, '\n\n').replace(/\n*$/, '\n');
}

/** Kjøringen for en spesifikasjon (ny og tom hvis den ikke finnes) */
export const runFor = (u: Utforing, spec: string): SpecRun => u.runs.find(r => r.spec === spec) ?? { spec, route: [], steps: [], log: [] };

/** Ny tilstand med `run` byttet inn (eller lagt til) */
export function withRun(u: Utforing, run: SpecRun): Utforing {
  const i = u.runs.findIndex(r => r.spec === run.spec);
  return { runs: i < 0 ? [...u.runs, run] : u.runs.map((r, j) => (j === i ? run : r)) };
}
