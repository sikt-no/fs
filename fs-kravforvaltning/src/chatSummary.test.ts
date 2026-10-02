import assert from 'node:assert/strict';
import { test } from 'node:test';
import { parseSummary, summaryDraft, summaryIn, summaryMentions } from './chatSummary.ts';

const json = JSON.stringify({
  mal: 'Verifisere kravene.',
  gjort: 'Gått gjennom 8 egenskaper.',
  beslutninger: '',
  apneSporsmal: 'Holder det for GRU-008?',
  nesteSteg: 'Avklare GRU-008.',
  paths: ['krav/07 B/a.feature', '/Users/x/repo/tasks/b/spec/verify.md', 'krav/07 B/a.feature', ''],
});

test('parseSummary tolker JSON-en, rydder stiene og godtar ikke tomme eller ugyldige blokker', () => {
  const s = parseSummary(json)!;
  assert.equal(s.mal, 'Verifisere kravene.');
  assert.equal(s.beslutninger, '');
  assert.deepEqual(s.paths, ['krav/07 B/a.feature', 'tasks/b/spec/verify.md']);
  assert.equal(parseSummary('{"paths": ["krav/a.feature"]}'), null);
  assert.equal(parseSummary('ikke json'), null);
  assert.equal(parseSummary('[]'), null);
});

test('summaryDraft utelater tomme felt, og bare krav-filer legges ved med @', () => {
  const s = parseSummary(json)!;
  assert.equal(
    summaryDraft(s),
    'Fortsetter fra en tidligere samtale:\n\nMål: Verifisere kravene.\n\nGjort: Gått gjennom 8 egenskaper.\n\nÅpne spørsmål: Holder det for GRU-008?\n\nNeste steg: Avklare GRU-008.',
  );
  assert.deepEqual(summaryMentions(s), ['krav/07 B/a.feature']);
});

test('summaryIn finner blokken i et svar', () => {
  assert.equal(summaryIn('Her:\n\n```krav-oppsummering\n' + json + '\n```\n')!.nesteSteg, 'Avklare GRU-008.');
  assert.equal(summaryIn('```json\n' + json + '\n```'), null);
  assert.equal(summaryIn('Ingen blokk'), null);
});
