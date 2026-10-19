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

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [runder](runder/) | \`@OPT-PLA-RUN-001\` [runder.feature](../../krav/02%20Opptak/14%20Plasstildeling/01%20Runder/runder.feature) | Must | – | – | |
| [runder](runder/) | \`@OPT-PLA-RUN-002\` | Should | – | – | |
| [tilbud](tilbud/) | \`@OPT-PLA-RUN-004\` \`@OPT-PLA-RUN-099\` | Could | – | – | |
| (ikke tildelt) | \`@OPT-PLA-RUN-005\` | Must | – | – | |
`;
const snap = { domains: { [DOM]: null }, tasks: [] as RawTask[], scopes: { [`tasks/${DOM}/scope-plass.md`]: scopeSrc } };
const scope = buildScopes(snap)[0];

test('scopesIn: scope-taggen på egenskapen og på delene', () => {
  assert.deepEqual(scopesIn(entries[P('runder')]), ['plass']);
  assert.deepEqual(scopesIn(entries[P('endres')]), ['gammelt', 'plass']);
  assert.deepEqual(scopesIn(entries[P('tilbud')]), []);
});

test('scopeLinks: krav per oppgave, tagget men ikke i tabellen, i tabellen uten tag, og ID-er som ikke finnes', () => {
  const l = scopeLinks(scope, entries);
  assert.deepEqual(l.byTask.get('runder')!.map(k => k.path), [P('runder'), P('tilbud')], 'ID og lenke til samme krav gir én rad');
  assert.deepEqual(l.notInTable.map(k => k.path), [P('ekstra')]);
  assert.deepEqual(l.untagged.map(k => k.path), [P('tilbud'), P('annet')]);
  assert.deepEqual(l.missing, ['@OPT-PLA-RUN-099']);
  assert.equal(l.byTask.get(null)![0].path, P('endres'), 'del i et levert krav hører til scopet');
});

test('kravFor: scope-raden når oppgaven har scope, med skjelett og MoSCoW', () => {
  const t = parseTask({ dom: DOM, slug: 'runder', files: ['oppgave.md'], sources: { 'oppgave.md': '# Runder\n\n- **Scope**: [scope-plass](../scope-plass.md)\n' } });
  const k = kravFor(t, scope, entries);
  assert.equal(k.from, 'scope');
  assert.deepEqual(k.items.map(i => [i.id, i.status, i.skeleton]), [
    ['@OPT-PLA-RUN-001', 'planned', false],
    ['@OPT-PLA-RUN-002', 'draft', false],
  ]);
  const tilbud = parseTask({ dom: DOM, slug: 'tilbud', files: ['oppgave.md'], sources: { 'oppgave.md': '# Tilbud\n\n- **Scope**: [scope-plass](../scope-plass.md)\n' } });
  const kt = kravFor(tilbud, scope, entries);
  assert.deepEqual(kt.missing, ['@OPT-PLA-RUN-099']);
  assert.equal(kt.items[0].wont, false);
  // Uten scope: krav-lenken i oppgave.md
  const uten = parseTask({ dom: DOM, slug: 'x', files: ['oppgave.md'], sources: { 'oppgave.md': '# X\n\n- **Krav (Gherkin)**: `krav/02 Opptak/14 Plasstildeling/01 Runder/`\n' } });
  const ku = kravFor(uten, null, entries);
  assert.equal(ku.from, 'lenke');
  assert.equal(ku.items.length, 5);
  const domene = parseTask({ dom: DOM, slug: 'x', files: ['oppgave.md'], sources: { 'oppgave.md': '# X\n\n- **Krav (Gherkin)**: `krav/02 Opptak/`\n' } });
  assert.deepEqual(kravFor(domene, null, entries), { items: [], missing: [], from: null }, 'en lenke til hele domenet');
});
