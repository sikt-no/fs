import assert from 'node:assert/strict';
import { test } from 'node:test';
import { buildScopes, buildTasks, metadata, newScopeText, parseIssue, parseIssues, parseScope, parseTask, taskLint, type RawTask, type TasksSnapshot } from './tasks.ts';

const DOM = 'brukeradministrasjon-og-tilgangsstyring';

const scope = (o: { fase?: string; slug?: string; dom?: string; eier?: string; prs?: string; jira?: string; rows?: string } = {}) => `# Scope: Søk på fødselsnummer

- **Slug**: ${o.slug ?? 'sok'} (= navnet på mappa og taggen \`@scope-sok\`)
- **Domene**: ${o.dom ?? DOM} (se [\`../../README.md\`](../../README.md#domener))
- **Initiativ**: #31 Paraplyen
- **Jira**: ${o.jira ?? '[sikt-no/fs#41](https://github.com/sikt-no/fs/issues/41)'}
- **Eier**: ${o.eier ?? '–'}
- **Fase**: ${o.fase ?? 'utforskning'}
- **Prioritet**: Must
- **PRs**: ${o.prs ?? '–'}
- **Siste oppdatering**: 2026-10-01

## Mål

Finne brukere raskt.

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
${o.rows ?? `| \`@BRU-BRU-SOK-001\` [sok.feature](../../../krav/07%20Bru/12%20Bru/01%20S%C3%B8k/sok.feature), \`@BRU-BRU-SOK-002\` | Must | [Søk](https://www.figma.com/design/abc/x?node-id=1-2) | BAT-41 | |
| \`@BRU-BRU-SOK-003\` | Could | – | – | senere |`}

## Åpne spørsmål

## Statuslogg

| Dato       | Hendelse                        | Av          | Lenke til review |
|------------|---------------------------------|-------------|------------------|
| 2026-08-20 | prioritert → utforskning (r01)  | @jonas      | [r01](reviews/r01-prioritert-til-utforskning.md) |
| 2026-08-01 | Tatt inn i veikart (\`prioritert\`) | @jonas      | –                |
`;

const raw = (files: string[], sources: Record<string, string> = {}, o: Parameters<typeof scope>[0] = {}): RawTask => ({
  dom: DOM,
  slug: 'sok',
  files: ['scope.md', ...files].sort(),
  sources: { 'scope.md': scope(o), ...sources },
});

const rules = (r: RawTask) => taskLint(parseTask(r)).map(l => l.rule);

test('metadata leser nøkkel/verdi-linjene', () => {
  const m = metadata(scope({ prs: '[#12](https://github.com/sikt-no/fs/pull/12)' }));
  assert.equal(m['Fase'], 'utforskning');
  assert.equal(m['Prioritet'], 'Must');
  assert.equal(m['PRs'], '[#12](https://github.com/sikt-no/fs/pull/12)');
});

test('parseTask tolker scope.md', () => {
  const t = parseTask(raw([]));
  assert.equal(t.title, 'Søk på fødselsnummer', 'uten «Scope:» foran');
  assert.equal(t.hasScope, true);
  assert.deepEqual(t.issue, { key: '#41', url: 'https://github.com/sikt-no/fs/issues/41' });
  assert.deepEqual(t.issues, [t.issue]);
  assert.equal(t.scope, 'sok', 'scopet er mappa');
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

test('regel 1: BAT-filer i scope-rota', () => {
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

test('metadata: scope.md mangler, feil slug og feil domene; Fase leses ikke', () => {
  assert.deepEqual(rules(raw([], {}, { fase: 'prioritert | utforskning | utvikling' })), []);
  assert.deepEqual(rules(raw([], {}, { fase: 'ferdig' })), []);
  assert.deepEqual(rules(raw([], {}, { slug: 'noe-annet' })), ['slug']);
  assert.deepEqual(rules(raw([], {}, { dom: 'opptak' })), ['domene']);
  assert.deepEqual(rules({ ...raw([]), files: ['design.md'], sources: {} }), ['scopefil']);
  assert.match(taskLint(parseTask({ ...raw([]), files: ['design.md'], sources: {} }))[0].title, /scope\.md mangler/);
  assert.match(taskLint(parseTask({ ...raw([]), files: ['design.md'], sources: {} }))[0].hint, /fs-scope/);
  // En mappe med bare oppgave.md (fra før scope og oppgave ble slått sammen) har ikke scope
  assert.equal(parseTask({ ...raw([]), files: ['oppgave.md'], sources: { 'oppgave.md': '# X\n' } }).scope, null);
});

test('parseScope leser metadata og tabellen Krav i scope.md', () => {
  const sc = parseScope(`tasks/${DOM}/sok/scope.md`, scope({ jira: '[BAT-41](https://sikt.atlassian.net/browse/BAT-41), [BAT-42](https://sikt.atlassian.net/browse/BAT-42)' }))!;
  assert.equal(sc.slug, 'sok');
  assert.equal(sc.dom, DOM);
  assert.equal(sc.title, 'Søk på fødselsnummer');
  assert.equal(sc.updated, '2026-10-01');
  assert.deepEqual(sc.issues.map(i => i.key), ['BAT-41', 'BAT-42']);
  assert.equal(sc.rows.length, 2);
  assert.deepEqual(sc.rows[0].ids, ['@BRU-BRU-SOK-001', '@BRU-BRU-SOK-002']);
  assert.deepEqual(sc.rows[0].paths, ['krav/07 Bru/12 Bru/01 Søk/sok.feature'], 'lenken løses opp fra scope-mappa');
  assert.equal(sc.rows[0].task, 'sok', 'alle radene hører til mappa');
  assert.equal(sc.rows[0].moscow, 'Must');
  assert.deepEqual(sc.rows[0].sketches, [{ name: 'Søk', url: 'https://www.figma.com/design/abc/x?node-id=1-2' }]);
  assert.equal(sc.rows[0].issue?.key, 'BAT-41', 'kolonnen Jira sier hvilken sak kravet hører til');
  assert.equal(sc.rows[1].issue, null);
  assert.equal(sc.rows[1].comment, 'senere');
  assert.equal(parseScope(`tasks/${DOM}/scope-sok.md`, scope()), null, 'scope-<slug>.md på domenenivå leses ikke lenger');
});

const snap = (tasks: RawTask[]): TasksSnapshot => ({ domains: { [DOM]: null, opptak: null }, tasks });

test('scope: buildScopes leser scope.md i mappene, og slugen er unik på tvers av domener', () => {
  const lint = (tasks: RawTask[]) => buildScopes(snap(tasks)).flatMap(s => s.lint.map(l => l.title));
  assert.deepEqual(
    buildScopes(snap([raw([]), { ...raw([]), slug: 'uten', files: ['design.md'], sources: {} }])).map(s => s.path),
    [`tasks/${DOM}/sok/scope.md`],
  );
  assert.deepEqual(lint([raw([])]), []);
  const twice = lint([raw([]), { ...raw([], {}, { dom: 'opptak' }), dom: 'opptak' }]);
  assert.equal(twice.filter(t => /finnes også i/.test(t)).length, 2);
  assert.deepEqual(buildScopes(snap([{ ...raw([]), dom: 'mal' }])), [], 'mal/ er ikke et scope');
});

test('scope.md: slugen må være navnet på mappa', () => {
  const t = buildTasks(snap([raw([], {}, { slug: 'annet' })]))[0];
  assert.deepEqual(t.lint.map(l => l.rule + ':' + l.title), ['slug:Slug er annet, men mappa heter sok']);
  assert.equal(t.lint[0].file, 'scope.md');
});

test('buildTasks sorterer på domene og tittel og legger på regelsjekk', () => {
  const a = { ...raw([], {}, { fase: 'utvikling' }), slug: 'a' };
  a.sources = { 'scope.md': scope({ fase: 'utvikling', slug: 'a' }).replace('# Scope: Søk på fødselsnummer', '# Scope: Vis brukere') };
  const b = { ...raw(['plan-krav.md'], {}, { slug: 'b' }), slug: 'b' };
  b.sources = { 'scope.md': scope({ slug: 'b' }) };
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

test('newScopeText: minimal scope.md som leses tilbake uten avvik', () => {
  const src = newScopeText({ title: 'Søk på fødselsnummer', dom: DOM, slug: 'sok', jira: parseIssues('BAT-268, BAT-269'), owner: '@kari', mal: 'Finne brukere raskt.', date: '2026-10-12', via: 'Opprettet i FS Kravforvaltning' });
  assert.match(src, /- \*\*Jira\*\*: \[BAT-268\]\(https:\/\/sikt\.atlassian\.net\/browse\/BAT-268\), \[BAT-269\]/);
  const r: RawTask = { dom: DOM, slug: 'sok', files: ['scope.md'], sources: { 'scope.md': src } };
  const t = parseTask(r);
  assert.deepEqual(
    [t.title, t.issues.map(i => i.key), t.metaDom, t.metaSlug, t.owner, t.scope],
    ['Søk på fødselsnummer', ['BAT-268', 'BAT-269'], DOM, 'sok', '@kari', 'sok'],
  );
  assert.deepEqual(t.log, [{ d: '2026-10-12', t: 'Opprettet i FS Kravforvaltning', who: '@kari' }]);
  assert.deepEqual(taskLint(t), []);
  const sc = buildScopes(snap([r]))[0];
  assert.deepEqual([sc.rows, sc.lint], [[], []]);
  assert.match(src, /## Mål\n\nFinne brukere raskt\./);
  const uten = newScopeText({ title: 'X', dom: DOM, slug: 'x', date: '2026-10-12', via: 'Opprettet' });
  assert.match(uten, /Scopet har ikke en Jira-sak ennå/);
  assert.deepEqual(parseTask({ dom: DOM, slug: 'x', files: ['scope.md'], sources: { 'scope.md': uten } }).issues, []);
});

test('parseIssues: én eller flere saker, i rekkefølge, uten dubletter', () => {
  assert.deepEqual(parseIssues('[BAT-1](https://sikt.atlassian.net/browse/BAT-1), [#143](https://github.com/sikt-no/fs/issues/143)').map(i => i.key), ['BAT-1', '#143']);
  assert.deepEqual(parseIssues('BAT-1 og BAT-2, BAT-1').map(i => i.key), ['BAT-1', 'BAT-2']);
  for (const v of [undefined, '', '–']) assert.deepEqual(parseIssues(v), [], String(v));
});

test('parseIssue: Jira-sak, eller GitHub issue i scopes fra før', () => {
  const jira = { key: 'BAT-268', url: 'https://sikt.atlassian.net/browse/BAT-268' };
  assert.deepEqual(parseIssue('BAT-268'), jira);
  assert.deepEqual(parseIssue('[BAT-268](https://sikt.atlassian.net/browse/BAT-268)'), jira);
  assert.deepEqual(parseIssue('https://sikt.atlassian.net/browse/BAT-268'), jira);
  assert.deepEqual(parseIssue('[sikt-no/fs#143](https://github.com/sikt-no/fs/issues/143)'), { key: '#143', url: 'https://github.com/sikt-no/fs/issues/143' });
  assert.deepEqual(parseIssue('#143'), { key: '#143', url: 'https://github.com/sikt-no/fs/issues/143' });
  for (const v of [undefined, '', '–', '1234', 'bat-1']) assert.equal(parseIssue(v), null, String(v));
});
