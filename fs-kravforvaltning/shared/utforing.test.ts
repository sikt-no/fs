import assert from 'node:assert/strict';
import { test } from 'node:test';
import { emptyStep, parseUtforing, serializeUtforing, withRun, type Utforing } from './utforing.ts';

const TEXT = `# Utføring

Hvor spesifikasjonene i denne oppgaven er på veien gjennom kode-repoene.

## spec/spec-opprette-og-vedlikeholde-opptak.md

- **Rute**: fs-plattform → fs-admin
- **Logg**:
  - 2026-09-28 — @mats — sendte til fs-plattform
  - 2026-10-01 — agent:subgraph — levert i fs-plattform (#123)

### fs-plattform

- **Status**: levert
- **Tatt av**: agent:subgraph
- **PR**:
  - https://github.com/sikt-no/fs-plattform/pull/123
- **Overlevering**:
  - Ny mutation \`opprettOpptak(input: OpprettOpptakInput!)\`
  - Felt \`Opptak.frister\`
- **Blokkert**: –

### fs-admin

- **Status**: pågår
- **Tatt av**: agent:frontend
- **PR**: –
- **Overlevering**: –
- **Blokkert**: Venter på skjema
- **Tilbake**: 2026-10-03
`;

test('parseUtforing leser rute, steg og logg', () => {
  const u = parseUtforing(TEXT);
  assert.equal(u.runs.length, 1);
  const r = u.runs[0];
  assert.equal(r.spec, 'spec/spec-opprette-og-vedlikeholde-opptak.md');
  assert.deepEqual(r.route, ['fs-plattform', 'fs-admin']);
  assert.deepEqual(r.log, [
    { d: '2026-09-28', who: '@mats', t: 'sendte til fs-plattform' },
    { d: '2026-10-01', who: 'agent:subgraph', t: 'levert i fs-plattform (#123)' },
  ]);
  assert.deepEqual(r.steps[0], {
    repo: 'fs-plattform',
    status: 'levert',
    by: 'agent:subgraph',
    pr: ['https://github.com/sikt-no/fs-plattform/pull/123'],
    handoff: '- Ny mutation `opprettOpptak(input: OpprettOpptakInput!)`\n- Felt `Opptak.frister`',
    blocked: null,
    back: null,
  });
  assert.deepEqual(r.steps[1], { repo: 'fs-admin', status: 'pågår', by: 'agent:frontend', pr: [], handoff: '', blocked: 'Venter på skjema', back: '2026-10-03' });
});

test('serializeUtforing og parseUtforing går tur-retur', () => {
  const u = parseUtforing(TEXT);
  const again = parseUtforing(serializeUtforing(u));
  assert.deepEqual(again, u);
  assert.equal(serializeUtforing(again), serializeUtforing(u));
});

test('et steg i ruta uten egen seksjon venter, og en seksjon uten rute har ingen steg', () => {
  const u = parseUtforing('## spec/spec-a.md\n\n- **Rute**: fs-plattform\n\n## spec/spec-b.md\n\n- **Rute**: –\n- **Logg**:\n  - 2026-10-04 — @mats — opprettet spesifikasjonen\n');
  assert.deepEqual(u.runs[0].steps, [emptyStep('fs-plattform')]);
  assert.deepEqual(u.runs[1].route, []);
  assert.equal(u.runs[1].log.length, 1);
});

test('withRun bytter inn eller legger til', () => {
  const u: Utforing = { runs: [{ spec: 'spec/spec-a.md', route: [], steps: [], log: [] }] };
  const b = { spec: 'spec/spec-b.md', route: ['fs-admin'], steps: [emptyStep('fs-admin')], log: [] };
  assert.deepEqual(withRun(u, b).runs.map(r => r.spec), ['spec/spec-a.md', 'spec/spec-b.md']);
  assert.deepEqual(withRun(withRun(u, b), { ...b, route: [] }).runs[1].route, []);
});
