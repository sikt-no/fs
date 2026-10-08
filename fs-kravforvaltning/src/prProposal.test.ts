import assert from 'node:assert/strict';
import { test } from 'node:test';
import { parseMd } from './markdown.ts';
import { parsePrProposal, PR_LANG, splitGenerated, withTaskState } from './prProposal.ts';

test('parsePrProposal tolker et gyldig forslag', () => {
  const p = parsePrProposal('{"title": " Krav: ny regel ", "branch": "ny-regel", "body": "Hvorfor", "paths": ["krav/a.feature", "./krav/b.feature", "krav/a.feature"]}');
  assert.deepEqual(p, { title: 'Krav: ny regel', branch: 'ny-regel', body: 'Hvorfor', paths: ['krav/a.feature', 'krav/b.feature'], skipped: [] });
});

test('parsePrProposal: branch og body er valgfrie', () => {
  assert.deepEqual(parsePrProposal('{"title": "T", "paths": ["krav/a.feature"]}'), { title: 'T', branch: null, body: '', paths: ['krav/a.feature'], skipped: [] });
});

test('parsePrProposal avviser forslag uten tittel eller filer', () => {
  assert.equal(parsePrProposal('{"paths": ["krav/a.feature"]}'), null);
  assert.equal(parsePrProposal('{"title": " ", "paths": ["krav/a.feature"]}'), null);
  assert.equal(parsePrProposal('{"title": "T", "paths": []}'), null);
  assert.equal(parsePrProposal('{"title": "T"}'), null);
});

test('parsePrProposal: filer som ikke kan sendes med «Lag PR», legges i skipped', () => {
  const p = parsePrProposal('{"title": "T", "paths": ["krav/a.feature", "tasks/x/spec/verify-2026-09-29.md", "krav/b.txt", "krav/../c.md"]}');
  assert.deepEqual(p?.paths, ['krav/a.feature']);
  assert.deepEqual(p?.skipped, ['tasks/x/spec/verify-2026-09-29.md', 'krav/b.txt', 'krav/../c.md']);
});

test('parsePrProposal avviser forslag uten filer som kan sendes', () => {
  assert.equal(parsePrProposal('{"title": "T", "paths": ["tasks/x.md"]}'), null);
  // Det fs-specify skriver i oppgavemappa, kan sendes; oppgave.md kan ikke
  const spec = parsePrProposal(
    '{"title": "T", "paths": ["tasks/opptak/x/spec/spec-x.md", "tasks/opptak/x/spec/spec.log.md", "tasks/opptak/x/spec/krav-input/local/krav/a.feature", "tasks/opptak/x/spec/krav-input/sketches/figma/a/screenshot.png", "tasks/opptak/x/oppgave.md"]}',
  );
  assert.deepEqual(spec?.paths, ['tasks/opptak/x/spec/spec-x.md', 'tasks/opptak/x/spec/spec.log.md', 'tasks/opptak/x/spec/krav-input/local/krav/a.feature', 'tasks/opptak/x/spec/krav-input/sketches/figma/a/screenshot.png']);
  assert.deepEqual(spec?.skipped, ['tasks/opptak/x/oppgave.md']);
  assert.equal(parsePrProposal('{"title": "T", "paths": ["krav/../package.json"]}'), null);
  assert.equal(parsePrProposal('{"title": "T", "paths": [3]}'), null);
});

test('parsePrProposal avviser ødelagt JSON', () => {
  assert.equal(parsePrProposal('{"title": "T",'), null);
  assert.equal(parsePrProposal('[1]'), null);
  assert.equal(parsePrProposal('null'), null);
});

test('parsePrProposal: en krav-pr-blokk i et svar fra Claude, med JSON over flere linjer', () => {
  const text = 'Jeg har endret kravet.\n\n  ```krav-pr\n  {\n    "title": "Krav: X",\n    "paths": ["krav/a.feature"]\n  }\n  ```\n';
  const b = parseMd(text).find(b => b.type === 'code');
  assert.ok(b?.type === 'code' && b.lang === PR_LANG);
  assert.deepEqual(parsePrProposal(b.body.join('\n')), { title: 'Krav: X', branch: null, body: '', paths: ['krav/a.feature'], skipped: [] });
});

test('splitGenerated tar «Generated with Claude Code»-linja ut av beskrivelsen', () => {
  assert.deepEqual(splitGenerated('Legger til to scenarioer.\n\n🤖 Generated with [Claude Code](https://claude.com/claude-code)'), { text: 'Legger til to scenarioer.', generated: true });
  assert.deepEqual(splitGenerated('Generert med Claude Code\nTekst'), { text: 'Tekst', generated: true });
  assert.deepEqual(splitGenerated('Bare tekst om Claude Code.'), { text: 'Bare tekst om Claude Code.', generated: false });
});

test('withTaskState legger til utforing.md for oppgavemappene i forslaget når den er endret', () => {
  const pr = parsePrProposal('{"title": "T", "paths": ["krav/a.feature", "tasks/opptak/x/spec/spec-x.md", "tasks/opptak/x/spec/spec.log.md"]}')!;
  const changed = (p: string) => p === 'tasks/opptak/x/utforing.md' || p === 'tasks/opptak/y/utforing.md';
  assert.deepEqual(withTaskState(pr, changed).paths, ['krav/a.feature', 'tasks/opptak/x/spec/spec-x.md', 'tasks/opptak/x/spec/spec.log.md', 'tasks/opptak/x/utforing.md']);
  assert.equal(withTaskState(pr, () => false), pr, 'uten endring: ingenting legges til');
  const med = parsePrProposal('{"title": "T", "paths": ["tasks/opptak/x/utforing.md", "tasks/opptak/x/spec/spec-x.md"]}')!;
  assert.deepEqual(withTaskState(med, changed).paths, ['tasks/opptak/x/utforing.md', 'tasks/opptak/x/spec/spec-x.md'], 'ikke to ganger');
  const krav = parsePrProposal('{"title": "T", "paths": ["krav/a.feature"]}')!;
  assert.equal(withTaskState(krav, changed), krav, 'bare oppgavemapper forslaget har filer fra');
});
