import assert from 'node:assert/strict';
import { test } from 'node:test';
import { buildScopes, buildTasks, metadata, newOppgaveText, parseIssue, parseScope, parseTask, taskLint, type RawTask, type TasksSnapshot } from './tasks.ts';

const oppgave = (o: { fase?: string; slug?: string; dom?: string; eier?: string; krav?: string; prs?: string; scope?: string } = {}) => `# Søk på fødselsnummer

## Metadata

- **Issue**: [sikt-no/fs#41](https://github.com/sikt-no/fs/issues/41)
- **Initiativ**: #31 Paraplyen
- **Domene**: ${o.dom ?? 'brukeradministrasjon-og-tilgangsstyring'} (se [\`../../README.md\`](../../README.md#domener))
- **Slug**: ${o.slug ?? 'sok'}
- **Fase**: ${o.fase ?? 'utforskning'}
- **Prioritet**: Must
${o.scope ? `- **Scope**: ${o.scope}\n` : ''}- **Eier**: ${o.eier ?? '–'}
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

const rules = (r: RawTask) => taskLint(parseTask(r)).map(l => l.rule);

test('metadata leser nøkkel/verdi-linjene og lenke-underpunktene', () => {
  const m = metadata(oppgave({ prs: '[#12](https://github.com/sikt-no/fs/pull/12)' }));
  assert.equal(m['Fase'], 'utforskning');
  assert.equal(m['Prioritet'], 'Must');
  assert.equal(m['lenke:PRs'], '[#12](https://github.com/sikt-no/fs/pull/12)');
});

test('parseTask tolker oppgave.md', () => {
  const t = parseTask(raw([]));
  assert.equal(t.title, 'Søk på fødselsnummer');
  assert.deepEqual(t.issue, { key: '#41', url: 'https://github.com/sikt-no/fs/issues/41' });
  assert.equal(t.scope, null);
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

test('regel 1: BAT-filer i oppgave-rota', () => {
  assert.deepEqual(rules(raw(['plan-krav.md'])), ['r1']);
  assert.match(taskLint(parseTask(raw(['plan-krav.md'])))[0].hint, /<lag>\/plan-sok\.md/);
  assert.deepEqual(rules(raw(['analysis-sok.md'])), ['r1']);
  assert.deepEqual(rules(raw(['frontend/plan-sok.md', 'frontend/analysis-sok.md', 'frontend/verification-sok.md'])), []);
});

test('regel 2: plan for et lag i rota', () => {
  const l = taskLint(parseTask(raw(['plan-frontend.md'])));
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

test('metadata: oppgave.md mangler, feil slug og feil domene; Fase leses ikke', () => {
  assert.deepEqual(rules(raw([], {}, { fase: 'prioritert | utforskning | utvikling' })), []);
  assert.deepEqual(rules(raw([], {}, { fase: 'ferdig' })), []);
  assert.deepEqual(rules(raw([], {}, { slug: 'noe-annet' })), ['slug']);
  assert.deepEqual(rules(raw([], {}, { dom: 'opptak' })), ['domene']);
  assert.deepEqual(rules({ ...raw([]), files: ['design.md'], sources: {} }), ['oppgave']);
  assert.match(taskLint(parseTask({ ...raw([]), files: ['design.md'], sources: {} }))[0].hint, /fs-scope/);
});

const DOM = 'brukeradministrasjon-og-tilgangsstyring';
const scopeSrc = (o: { slug?: string; rows?: string } = {}) => `# Scope: Søk og filter

- **Slug**: ${o.slug ?? 'sok-iterasjon-2'}
- **Initiativ**: [#31](https://github.com/sikt-no/fs/issues/31)
- **Eier**: @kari
- **Siste oppdatering**: 2026-10-01

## Mål

Finne brukere raskt.

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
${o.rows ?? `| [sok](sok/) | \`@BRU-BRU-SOK-001\` [sok.feature](../../krav/07%20Bru/12%20Bru/01%20S%C3%B8k/sok.feature), \`@BRU-BRU-SOK-002\` | Must | [Søk](https://www.figma.com/design/abc/x?node-id=1-2) | #41 | |
| (ikke tildelt) | \`@BRU-BRU-SOK-003\` | Could | – | – | senere |`}

## Åpne spørsmål
`;

test('parseScope leser metadata og tabellen Oppgaver', () => {
  const sc = parseScope(`tasks/${DOM}/scope-sok-iterasjon-2.md`, scopeSrc())!;
  assert.equal(sc.slug, 'sok-iterasjon-2');
  assert.equal(sc.title, 'Søk og filter');
  assert.equal(sc.metaSlug, 'sok-iterasjon-2');
  assert.equal(sc.owner, '@kari');
  assert.equal(sc.updated, '2026-10-01');
  assert.equal(sc.rows.length, 2);
  assert.deepEqual(sc.rows[0].ids, ['@BRU-BRU-SOK-001', '@BRU-BRU-SOK-002']);
  assert.deepEqual(sc.rows[0].paths, ['krav/07 Bru/12 Bru/01 Søk/sok.feature']);
  assert.equal(sc.rows[0].task, 'sok');
  assert.equal(sc.rows[0].moscow, 'Must');
  assert.deepEqual(sc.rows[0].sketches, [{ name: 'Søk', url: 'https://www.figma.com/design/abc/x?node-id=1-2' }]);
  assert.equal(sc.rows[0].issue?.key, '#41');
  assert.equal(sc.rows[1].task, null, '(ikke tildelt)');
  assert.equal(sc.rows[1].comment, 'senere');
  assert.equal(parseScope(`tasks/${DOM}/sok/scope-x.md`, scopeSrc()), null);
});

const snapWith = (scopes: Record<string, string>, tasks: RawTask[] = [raw([])]): TasksSnapshot => ({ domains: { [DOM]: null }, tasks, scopes });

test('scope: slugen i fila er lik filnavnet, unik på tvers av domener, og oppgavene finnes i domenet', () => {
  const lint = (scopes: Record<string, string>) => buildScopes(snapWith(scopes)).flatMap(s => s.lint.map(l => l.title));
  assert.deepEqual(lint({ [`tasks/${DOM}/scope-sok-iterasjon-2.md`]: scopeSrc() }), []);
  assert.match(lint({ [`tasks/${DOM}/scope-sok-iterasjon-2.md`]: scopeSrc({ slug: 'annet' }) })[0], /Slug er annet/);
  assert.match(lint({ [`tasks/${DOM}/scope-sok-iterasjon-2.md`]: scopeSrc({ rows: '| [finnes-ikke](finnes-ikke/) | `@BRU-BRU-SOK-001` | Must | – | – | |' }) })[0], /finnes-ikke finnes ikke/);
  const twice = lint({ [`tasks/${DOM}/scope-sok-iterasjon-2.md`]: scopeSrc(), 'tasks/opptak/scope-sok-iterasjon-2.md': scopeSrc({ rows: '' }) });
  assert.equal(twice.filter(t => /finnes også i/.test(t)).length, 2);
});

test('Scope i oppgave.md: scopet finnes, og oppgaven står i tabellen', () => {
  const lint = (scope: string, scopes: Record<string, string>) => {
    const r = raw([], {}, { scope });
    return buildTasks(snapWith(scopes, [r]))[0].lint.map(l => l.rule + ':' + l.title);
  };
  const ok = { [`tasks/${DOM}/scope-sok-iterasjon-2.md`]: scopeSrc() };
  assert.equal(parseTask(raw([], {}, { scope: '[scope-sok-iterasjon-2](../scope-sok-iterasjon-2.md)' })).scope, 'sok-iterasjon-2');
  assert.deepEqual(lint('[scope-sok-iterasjon-2](../scope-sok-iterasjon-2.md)', ok), []);
  assert.match(lint('[scope-borte](../scope-borte.md)', ok)[0], /^scope:scope-borte finnes ikke/);
  const without = { [`tasks/${DOM}/scope-sok-iterasjon-2.md`]: scopeSrc({ rows: '| [annen](annen/) | `@BRU-BRU-SOK-001` | Must | – | – | |' }) };
  assert.ok(lint('[scope-sok-iterasjon-2](../scope-sok-iterasjon-2.md)', without).some(l => /Står ikke i scope-sok-iterasjon-2/.test(l)));
  assert.equal(parseTask(raw([], {}, { scope: '–' })).scope, null);
});

test('buildTasks sorterer på domene og tittel og legger på regelsjekk', () => {
  const a = { ...raw([], {}, { fase: 'utvikling' }), slug: 'a' };
  a.sources = { 'oppgave.md': oppgave({ fase: 'utvikling', slug: 'a' }).replace('# Søk på fødselsnummer', '# Vis brukere') };
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

test('newOppgaveText: minimal oppgave.md som leses tilbake uten avvik', () => {
  const src = newOppgaveText({ title: 'Søk på fødselsnummer', dom: DOM, slug: 'sok', issue: parseIssue('BAT-268'), owner: '@kari', date: '2026-10-12', via: 'Opprettet i FS Kravforvaltning' });
  assert.match(src, /- \*\*Issue\*\*: \[BAT-268\]\(https:\/\/sikt\.atlassian\.net\/browse\/BAT-268\)/);
  const t = parseTask({ dom: DOM, slug: 'sok', files: ['oppgave.md'], sources: { 'oppgave.md': src } });
  assert.deepEqual([t.title, t.issue, t.metaDom, t.metaSlug, t.owner, t.scope], ['Søk på fødselsnummer', { key: 'BAT-268', url: 'https://sikt.atlassian.net/browse/BAT-268' }, DOM, 'sok', '@kari', null]);
  assert.deepEqual(t.log, [{ d: '2026-10-12', t: 'Opprettet i FS Kravforvaltning', who: '@kari' }]);
  assert.deepEqual(taskLint(t), []);
  const uten = newOppgaveText({ title: 'X', dom: DOM, slug: 'x', scope: 'sok-iterasjon-2', date: '2026-10-12', via: 'Opprettet' });
  assert.match(uten, /Oppgaven har ikke en Jira-sak ennå/);
  assert.equal(parseTask({ dom: DOM, slug: 'x', files: ['oppgave.md'], sources: { 'oppgave.md': uten } }).scope, 'sok-iterasjon-2');
});

test('parseIssue: Jira-sak, eller GitHub issue i oppgaver fra før', () => {
  const jira = { key: 'BAT-268', url: 'https://sikt.atlassian.net/browse/BAT-268' };
  assert.deepEqual(parseIssue('BAT-268'), jira);
  assert.deepEqual(parseIssue('[BAT-268](https://sikt.atlassian.net/browse/BAT-268)'), jira);
  assert.deepEqual(parseIssue('https://sikt.atlassian.net/browse/BAT-268'), jira);
  assert.deepEqual(parseIssue('[sikt-no/fs#143](https://github.com/sikt-no/fs/issues/143)'), { key: '#143', url: 'https://github.com/sikt-no/fs/issues/143' });
  assert.deepEqual(parseIssue('#143'), { key: '#143', url: 'https://github.com/sikt-no/fs/issues/143' });
  for (const v of [undefined, '', '–', '1234', 'bat-1']) assert.equal(parseIssue(v), null, String(v));
});
