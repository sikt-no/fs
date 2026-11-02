import assert from 'node:assert/strict';
import { test } from 'node:test';
import type { Snapshot } from '../shared/model.ts';
import { buildScopes, parseTask, type RawTask } from '../shared/tasks.ts';
import { buildEntry } from '../server/parse.ts';
import { kravFor, scopeLinks, scopesIn } from './scope.ts';

const DOM = 'opptak';
const krav = (id: string, tags: string, part = '') => `# language: no
${id} @must ${tags}
Egenskap: Krav ${id}
  Som saksbehandler
  ønsker jeg noe
  slik at noe

${part}  Regel: Hovedflyt
    Scenario: Første
      Gitt noe
`;
const P = (n: string) => `krav/02 Opptak/14 Plasstildeling/01 Runder/${n}.feature`;
const entries: Snapshot = Object.fromEntries(
  [
    buildEntry(P('runder'), krav('@OPT-PLA-RUN-001', '@planned @scope-plass'), 0),
    buildEntry(P('tilbud'), krav('@OPT-PLA-RUN-002', '@draft'), 0),
    buildEntry(P('ekstra'), krav('@OPT-PLA-RUN-003', '@planned @scope-plass'), 0),
    buildEntry(P('annet'), krav('@OPT-PLA-RUN-004', '@planned @scope-annet'), 0),
    buildEntry(P('endres'), krav('@OPT-PLA-RUN-005', '@implemented @scope-gammelt', '  @planned @scope-plass\n  Regel: Ny\n    Scenario: Ny\n      Gitt noe\n\n'), 0),
  ].map(e => [e.path, e]),
);
const scopeSrc = `# Scope: Plasstildeling

- **Slug**: plass
- **Jira**: [BAT-1](https://sikt.atlassian.net/browse/BAT-1), [BAT-2](https://sikt.atlassian.net/browse/BAT-2)

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| \`@OPT-PLA-RUN-001\` [runder.feature](../../../krav/02%20Opptak/14%20Plasstildeling/01%20Runder/runder.feature) | Must | – | BAT-1 | |
| \`@OPT-PLA-RUN-002\` | Should | – | BAT-1 | |
| \`@OPT-PLA-RUN-004\` \`@OPT-PLA-RUN-099\` | Could | – | BAT-2 | |
| \`@OPT-PLA-RUN-005\` | Must | – | – | Ikke tildelt en sak |
`;
const raw: RawTask = { dom: DOM, slug: 'plass', files: ['scope.md'], sources: { 'scope.md': scopeSrc } };
const scope = buildScopes({ domains: { [DOM]: null }, tasks: [raw] })[0];

test('scopesIn: scope-taggen på egenskapen og på delene', () => {
  assert.deepEqual(scopesIn(entries[P('runder')]), ['plass']);
  assert.deepEqual(scopesIn(entries[P('endres')]), ['gammelt', 'plass']);
  assert.deepEqual(scopesIn(entries[P('tilbud')]), []);
});

test('scopeLinks: kravene i tabellen, tagget men ikke i tabellen, i tabellen uten tag, og ID-er som ikke finnes', () => {
  const l = scopeLinks(scope, entries);
  assert.deepEqual(
    l.byTask.get('plass')!.map(k => k.path),
    [P('runder'), P('tilbud'), P('annet'), null, P('endres')],
    'ID og lenke til samme krav gir én rad',
  );
  assert.deepEqual(l.notInTable.map(k => k.path), [P('ekstra')]);
  assert.deepEqual(l.untagged.map(k => k.path), [P('tilbud'), P('annet')]);
  assert.deepEqual(l.missing, ['@OPT-PLA-RUN-099']);
});

test('kravFor: krav-radene i scope.md, med skjelett, MoSCoW og krav som ikke finnes', () => {
  const t = parseTask(raw);
  const k = kravFor(t, scope, entries);
  assert.equal(k.from, 'scope');
  assert.deepEqual(k.items.map(i => [i.id, i.status, i.skeleton]), [
    ['@OPT-PLA-RUN-001', 'planned', false],
    ['@OPT-PLA-RUN-002', 'draft', false],
    ['@OPT-PLA-RUN-004', 'planned', false],
    ['@OPT-PLA-RUN-005', 'implemented', false],
  ]);
  assert.deepEqual(k.missing, ['@OPT-PLA-RUN-099']);
  assert.equal(k.items[0].wont, false);
});

test('kravFor: uten krav-rader, eller uten scope.md, kommer kravene fra spesifikasjonene', () => {
  const spec = '# Spec: X\n\n## Krav\n\n- **`runder.feature`** (`@OPT-PLA-RUN-001`) — runder.\n';
  const tom = scopeSrc.replace(/\| `@OPT[^\n]*\n/g, '');
  const medSpec: RawTask = { dom: DOM, slug: 'plass', files: ['scope.md', 'spec/spec-x.md'], sources: { 'scope.md': tom, 'spec/spec-x.md': spec } };
  const sc = buildScopes({ domains: { [DOM]: null }, tasks: [medSpec] })[0];
  assert.equal(sc.rows.length, 0);
  const k = kravFor(parseTask(medSpec), sc, entries);
  assert.equal(k.from, 'spec');
  assert.deepEqual(k.items.map(i => i.id), ['@OPT-PLA-RUN-001']);
  const uten = parseTask({ dom: DOM, slug: 'x', files: ['design.md'], sources: {} });
  assert.deepEqual(kravFor(uten, null, entries), { items: [], missing: [], from: null });
});
