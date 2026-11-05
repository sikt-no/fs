import assert from 'node:assert/strict';
import { test } from 'node:test';
import { normalizeHash, parseTavleHash, splitSel, tavleHash } from './tavleHash.ts';

test('parseTavleHash: de nye formene', () => {
  assert.deepEqual(parseTavleHash('scopes'), { sel: null });
  assert.deepEqual(parseTavleHash('scopes/opptak/plass'), { sel: 'opptak/plass' });
  assert.deepEqual(parseTavleHash('scopes/opptak/plass/spec-plass.md'), { sel: 'opptak/plass/spec-plass.md' });
  assert.deepEqual(parseTavleHash('scopes/opptak/plass/ny'), { sel: 'opptak/plass/ny' });
  assert.deepEqual(parseTavleHash('scopes/nytt-scope'), { sel: 'nytt-scope' });
  assert.equal(parseTavleHash('krav/README.md'), undefined);
  assert.equal(parseTavleHash('avvik'), undefined);
});

test('parseTavleHash og normalizeHash: de gamle formene fra Spesifikasjoner og Oppgaver', () => {
  assert.deepEqual(parseTavleHash('spesifikasjoner/opptak/plass/spec-plass.md'), { sel: 'opptak/plass/spec-plass.md' });
  assert.deepEqual(parseTavleHash('spesifikasjoner/ny'), { sel: null });
  assert.deepEqual(parseTavleHash('spesifikasjoner'), { sel: null });
  assert.deepEqual(parseTavleHash('oppgaver'), { sel: null });
  assert.deepEqual(parseTavleHash('oppgaver/opptak/plass'), { sel: 'opptak/plass' });
  assert.deepEqual(parseTavleHash('oppgaver/ny-oppgave'), { sel: 'nytt-scope' });
  assert.deepEqual(parseTavleHash('oppgaver/tavle/opptak/plass'), { sel: 'opptak/plass' });
  assert.deepEqual(parseTavleHash('oppgaver/mappe'), { sel: null });
  assert.equal(normalizeHash('#/spesifikasjoner/opptak/plass/spec-plass.md'), '#/scopes/opptak/plass/spec-plass.md');
  assert.equal(normalizeHash('#/oppgaver'), '#/scopes');
  assert.equal(normalizeHash('#/oppgaver/opptak/plass/ny'), '#/scopes/opptak/plass/ny');
  assert.equal(normalizeHash('#/oppgaver/tavle/opptak/plass'), '#/scopes/opptak/plass');
  assert.equal(normalizeHash('#/oppgaver/mappe'), '#/scopes');
  assert.equal(normalizeHash('#/oppgaver/ny-oppgave'), '#/scopes/nytt-scope');
  assert.equal(normalizeHash('#/scopes/opptak/plass'), '#/scopes/opptak/plass');
  assert.equal(normalizeHash('#/krav/02%20Opptak/x.feature'), '#/krav/02%20Opptak/x.feature');
  assert.equal(normalizeHash('#/avvik'), '#/avvik');
  assert.equal(tavleHash('opptak/vedtak og svar'), '#/scopes/opptak/vedtak%20og%20svar');
});

test('normalizeHash: oppgavene som ble slått sammen til scopes, får slugen til scopet', () => {
  assert.equal(normalizeHash('#/oppgaver/opptak/opprette-og-vedlikeholde-opptak'), '#/scopes/opptak/opprette-opptak-2027');
  assert.equal(
    normalizeHash('#/oppgaver/opptak/opprette-og-vedlikeholde-opptak/spec-opprette-og-vedlikeholde-opptak.md'),
    '#/scopes/opptak/opprette-opptak-2027/spec-opprette-og-vedlikeholde-opptak.md',
  );
  assert.equal(normalizeHash('#/oppgaver/opptak/gjennomfore-plasstildeling'), '#/scopes/opptak/plasstildeling-2027');
  assert.equal(normalizeHash('#/spesifikasjoner/opptak/tilbudsgaranti/spec-tilbudsgaranti.md'), '#/scopes/opptak/tilbudsgaranti-2027/spec-tilbudsgaranti.md');
  // Oppgaver som beholdt navnet, og scopes som har samme navn som en gammel oppgave i et annet domene
  assert.equal(normalizeHash('#/oppgaver/opptak/tidlig-opptak'), '#/scopes/opptak/tidlig-opptak');
  assert.equal(normalizeHash('#/scopes/opptak/regelverk'), '#/scopes/opptak/regelverk');
});

test('splitSel', () => {
  assert.deepEqual(splitSel('opptak/plass/spec-plass.md'), { task: 'opptak/plass', spec: 'spec-plass.md', newTask: false });
  assert.deepEqual(splitSel('opptak/plass'), { task: 'opptak/plass', spec: null, newTask: false });
  assert.deepEqual(splitSel('nytt-scope'), { task: null, spec: null, newTask: true });
  assert.deepEqual(splitSel(null), { task: null, spec: null, newTask: false });
});
