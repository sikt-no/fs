import assert from 'node:assert/strict';
import { test } from 'node:test';
import { buildTasks, metadata, parseTask, roadmapPhases, taskLint, type RawTask } from './tasks.ts';

const oppgave = (o: { fase?: string; slug?: string; dom?: string; eier?: string; krav?: string; prs?: string } = {}) => `# Søk på fødselsnummer

## Metadata

- **Issue**: [sikt-no/fs#41](https://github.com/sikt-no/fs/issues/41)
- **Initiativ**: #31 Paraplyen
- **Domene**: ${o.dom ?? 'brukeradministrasjon-og-tilgangsstyring'} (se [\`../../README.md\`](../../README.md#domener))
- **Slug**: ${o.slug ?? 'sok'}
- **Fase**: ${o.fase ?? 'utforskning'}
- **Prioritet**: Must
- **Eier**: ${o.eier ?? '–'}
- **Lenker**:
  - design: [design.md](design.md)
  - PRs: ${o.prs ?? '–'}
- **Krav (Gherkin)**: ${o.krav ?? '[`krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/`](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/)'}

## Statuslogg

| Dato       | Hendelse                        | Av          | Lenke til review |
|------------|---------------------------------|-------------|------------------|
| 2026-08-20 | prioritert → utforskning (r01)  | @jonas      | [r01](reviews/r01-prioritert-til-utforskning.md) |
| 2026-08-01 | Tatt inn i veikart (\`prioritert\`) | @jonas      | –                |
`;

const raw = (files: string[], sources: Record<string, string> = {}, o: Parameters<typeof oppgave>[0] = {}): RawTask => ({
  dom: 'brukeradministrasjon-og-tilgangsstyring',
  slug: 'sok',
  files: ['oppgave.md', ...files].sort(),
  sources: { 'oppgave.md': oppgave(o), ...sources },
});

const rules = (r: RawTask, roadmap: Record<string, string> | null = null) => taskLint(parseTask(r), roadmap).map(l => l.rule);

test('metadata leser nøkkel/verdi-linjene og lenke-underpunktene', () => {
  const m = metadata(oppgave({ prs: '[#12](https://github.com/sikt-no/fs/pull/12)' }));
  assert.equal(m['Fase'], 'utforskning');
  assert.equal(m['Prioritet'], 'Must');
  assert.equal(m['lenke:PRs'], '[#12](https://github.com/sikt-no/fs/pull/12)');
});

test('parseTask tolker oppgave.md', () => {
  const t = parseTask(raw([]));
  assert.equal(t.title, 'Søk på fødselsnummer');
  assert.equal(t.issue, 41);
  assert.equal(t.phase, 'utforskning');
  assert.equal(t.p, 1);
  assert.equal(t.prio, 'Must');
  assert.equal(t.metaDom, 'brukeradministrasjon-og-tilgangsstyring');
  assert.equal(t.metaSlug, 'sok');
  assert.equal(t.initiativ, '#31 Paraplyen');
  assert.equal(t.prs, 0);
  assert.equal(t.updated, '2026-08-20');
  assert.deepEqual(t.log[1], { d: '2026-08-01', t: 'Tatt inn i veikart (prioritert)', who: '@jonas' });
});

test('eier «–» og plassholderen @brukernavn blir null', () => {
  assert.equal(parseTask(raw([])).owner, null);
  assert.equal(parseTask(raw([], {}, { eier: '@brukernavn' })).owner, null);
  assert.equal(parseTask(raw([], {}, { eier: '@kari' })).owner, '@kari');
});

test('Krav-lenken løses opp fra oppgavemappa, og kodespenn godtas', () => {
  assert.equal(parseTask(raw([])).kravLink, 'krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon');
  assert.equal(parseTask(raw([], {}, { krav: '`krav/02 Opptak/11 Opptak/` (skal utarbeides)' })).kravLink, 'krav/02 Opptak/11 Opptak');
  assert.equal(parseTask(raw([], {}, { krav: '(skal utarbeides)' })).kravLink, null);
});

test('PR-lenker telles', () => {
  assert.equal(parseTask(raw([], {}, { prs: '[#12](https://github.com/sikt-no/fs/pull/12), [#14](https://github.com/sikt-no/fs/pull/14)' })).prs, 2);
});

test('lag får planbokser, completion-filer og verification', () => {
  const t = parseTask(
    raw(
      ['frontend/analysis-sok.md', 'frontend/plan-sok.md', 'frontend/task-1-completion.md', 'frontend/task-2-completion.md', 'backend/analysis-sok.md', 'spec/spec-sok.md', 'reviews/r01-prioritert-til-utforskning.md'],
      { 'frontend/plan-sok.md': '# Plan\n\n- [x] Én\n- [X] To\n- [ ] Tre\n  - [ ] Fire\n\n* ikke en boks\n' },
    ),
  );
  assert.deepEqual(
    t.lag.map(l => l.k),
    ['backend', 'frontend'],
    'spec/ og reviews/ er ikke lag',
  );
  assert.deepEqual(t.lag[1], { k: 'frontend', analysis: true, plan: [2, 4], completions: 2, verification: false });
  assert.deepEqual(t.lag[0].plan, null);
  assert.equal(t.spec, true);
});

test('specKrav: kravene under ## Krav i spesifikasjonene, også fra eldre lenker til krav-input', () => {
  const ny = '# Spec: Søk\n\n## Krav\n\n- **`sok.feature`** (`@BRU-BRU-SOK-001`) — søk. ([krav/07 Bru/12 Bru/01 Søk/sok.feature](../../../../krav/07%20Bru/12%20Bru/01%20S%C3%B8k/sok.feature))\n\n### Utenfor scope (`@draft`)\n\n- **`sok.feature` — regel `Eksport`** — venter på: format\n';
  const gammel = '# Spec: Søk\n\n## Krav\n\n- **`sok.feature`** (`@BRU-BRU-SOK-001`) — søk. ([lenke](krav-input/local/krav/07%20Bru/12%20Bru/01%20S%C3%B8k/sok.feature))\n- **`detaljer.feature`** (`@BRU-BRU-SOK-002`) — detaljer. ([lenke](krav-input/local/krav/07%20Bru/12%20Bru/01%20S%C3%B8k/detaljer.feature))\n';
  const t = parseTask(raw(['spec/spec-sok.md', 'spec/spec-gammel.md'], { 'spec/spec-sok.md': ny, 'spec/spec-gammel.md': gammel }));
  assert.deepEqual(
    t.specKrav.map(k => [k.id, k.path]),
    [
      ['@BRU-BRU-SOK-001', 'krav/07 Bru/12 Bru/01 Søk/sok.feature'],
      ['@BRU-BRU-SOK-002', 'krav/07 Bru/12 Bru/01 Søk/detaljer.feature'],
    ],
    'samme Feature-ID i to spesifikasjoner gir ett krav',
  );
  assert.deepEqual(parseTask(raw([])).specKrav, []);
});

test('review-utfallet leses fra avkrysset boks i Utfall', () => {
  const r = (utfall: string) =>
    parseTask(raw(['reviews/r01-prioritert-til-utforskning.md'], { 'reviews/r01-prioritert-til-utforskning.md': `# Review\n\n- **Reviewer**: @ola\n\n## Utfall\n\n${utfall}` })).reviews[0];
  const ok = r('- [x] **Ingen verdifulle forbedringer** — videre.\n- [ ] **Forbedringer foreslått** — blir.');
  assert.deepEqual([ok.n, ok.from, ok.to, ok.who, ok.ok], [1, 'prioritert', 'utforskning', '@ola', true]);
  assert.equal(r('- [ ] **Ingen verdifulle forbedringer**\n- [x] **Forbedringer foreslått**').ok, false);
  assert.equal(r('- [ ] **Ingen verdifulle forbedringer**\n- [ ] **Forbedringer foreslått**').ok, null);
});

test('regel 1: BAT-filer i oppgave-rota', () => {
  assert.deepEqual(rules(raw(['plan-krav.md'])), ['r1']);
  assert.match(taskLint(parseTask(raw(['plan-krav.md'])), null)[0].hint, /<lag>\/plan-sok\.md/);
  assert.deepEqual(rules(raw(['analysis-sok.md'])), ['r1']);
  assert.deepEqual(rules(raw(['frontend/plan-sok.md', 'frontend/analysis-sok.md', 'frontend/verification-sok.md'])), []);
});

test('regel 2: plan for et lag i rota', () => {
  const l = taskLint(parseTask(raw(['plan-frontend.md'])), null);
  assert.deepEqual(
    l.map(x => x.rule),
    ['r2'],
  );
  assert.match(l[0].hint, /frontend\/plan-sok\.md/);
});

test('regel 3: spec-filer og krav-input utenfor spec/', () => {
  assert.deepEqual(rules(raw(['frontend/spec-sok.md'])), ['r3']);
  assert.deepEqual(rules(raw(['frontend/krav-input/a.feature', 'frontend/krav-input/b.feature'])), ['r3']);
  assert.deepEqual(rules(raw(['spec/spec-sok.md', 'spec/krav-input/local/a.feature', 'frontend/spec.log.md'])), []);
});

test('regel 4: mappe under mal/ eller domene som ikke finnes', () => {
  assert.deepEqual(rules({ ...raw([], {}, { dom: 'mal' }), dom: 'mal' }), ['r4']);
  assert.deepEqual(rules({ ...raw([], {}, { dom: 'veikart' }), dom: 'veikart' }), ['r4']);
  assert.deepEqual(rules(raw([])), []);
});

test('metadata: ugyldig fase, feil slug og feil domene', () => {
  assert.deepEqual(rules(raw([], {}, { fase: 'prioritert | utforskning | utvikling' })), ['fase'], 'malteksten');
  assert.deepEqual(rules(raw([], {}, { fase: 'utvikling (siden juli)' })), []);
  assert.deepEqual(rules(raw([], {}, { fase: 'ferdig' })), ['fase']);
  assert.deepEqual(rules(raw([], {}, { slug: 'noe-annet' })), ['slug']);
  assert.deepEqual(rules(raw([], {}, { dom: 'opptak' })), ['domene']);
  assert.deepEqual(rules({ ...raw([]), files: ['design.md'], sources: {} }), ['fase']);
});

test('roadmap: fase i Aktive oppgaver og levert for Ferdig', () => {
  const src = `# Veikart

## Aktive oppgaver

| Issue | Oppgave | Initiativ | Fase | Prioritet | Eier | Reviewere | Mappe |
|-------|---------|-----------|------|-----------|------|-----------|-------|
| [#41](x) | Søk | #31 | utforskning | Must | – | – | [sok](sok/) |

## Ferdig

| Issue | Oppgave | Ferdig | Mappe |
|-------|---------|--------|-------|
| [#32](x) | Lesevisning | 2025-11-10 | [lesevisning](lesevisning/) |
`;
  assert.deepEqual(roadmapPhases(src), { sok: 'utforskning', lesevisning: 'levert' });
  assert.deepEqual(rules(raw([]), { sok: 'utforskning' }), []);
  assert.deepEqual(rules(raw([]), { sok: 'utvikling' }), ['roadmap']);
  assert.deepEqual(rules(raw([]), {}), ['roadmap']);
});

test('buildTasks sorterer på domene og fase og legger på regelsjekk', () => {
  const a = { ...raw([], {}, { fase: 'utvikling' }), slug: 'a' };
  a.sources = { 'oppgave.md': oppgave({ fase: 'utvikling', slug: 'a' }) };
  const b = { ...raw(['plan-krav.md'], {}, { slug: 'b' }), slug: 'b' };
  b.sources = { 'oppgave.md': oppgave({ slug: 'b' }) };
  const out = buildTasks({ domains: { 'brukeradministrasjon-og-tilgangsstyring': null }, tasks: [a, b] });
  assert.deepEqual(
    out.map(t => t.slug),
    ['b', 'a'],
  );
  assert.deepEqual(
    out[0].lint.map(l => l.rule),
    ['r1'],
  );
});
