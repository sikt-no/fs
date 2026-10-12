import assert from 'node:assert/strict';
import { test } from 'node:test';
import { normalizeHash, parseTavleHash, splitSel, tavleHash } from './tavleHash.ts';

test('parseTavleHash: de nye formene', () => {
  assert.deepEqual(parseTavleHash('oppgaver'), { sel: null });
  assert.deepEqual(parseTavleHash('oppgaver/opptak/plass'), { sel: 'opptak/plass' });
  assert.deepEqual(parseTavleHash('oppgaver/opptak/plass/spec-plass.md'), { sel: 'opptak/plass/spec-plass.md' });
  assert.deepEqual(parseTavleHash('oppgaver/opptak/plass/ny'), { sel: 'opptak/plass/ny' });
  assert.deepEqual(parseTavleHash('oppgaver/ny-oppgave'), { sel: 'ny-oppgave' });
  assert.equal(parseTavleHash('krav/README.md'), undefined);
  assert.equal(parseTavleHash('avvik'), undefined);
});

test('parseTavleHash og normalizeHash: de gamle formene fra Spesifikasjoner og Oppgaver', () => {
  assert.deepEqual(parseTavleHash('spesifikasjoner/opptak/plass/spec-plass.md'), { sel: 'opptak/plass/spec-plass.md' });
  assert.deepEqual(parseTavleHash('spesifikasjoner/ny'), { sel: null });
  assert.deepEqual(parseTavleHash('spesifikasjoner'), { sel: null });
  assert.deepEqual(parseTavleHash('oppgaver/tavle/opptak/plass'), { sel: 'opptak/plass' });
  assert.deepEqual(parseTavleHash('oppgaver/mappe'), { sel: null });
  assert.equal(normalizeHash('#/spesifikasjoner/opptak/plass/spec-plass.md'), '#/oppgaver/opptak/plass/spec-plass.md');
  assert.equal(normalizeHash('#/oppgaver/tavle/opptak/plass'), '#/oppgaver/opptak/plass');
  assert.equal(normalizeHash('#/oppgaver/mappe'), '#/oppgaver');
  assert.equal(normalizeHash('#/krav/02%20Opptak/x.feature'), '#/krav/02%20Opptak/x.feature');
  assert.equal(normalizeHash('#/avvik'), '#/avvik');
  assert.equal(tavleHash('opptak/vedtak og svar'), '#/oppgaver/opptak/vedtak%20og%20svar');
});

test('splitSel', () => {
  assert.deepEqual(splitSel('opptak/plass/spec-plass.md'), { task: 'opptak/plass', spec: 'spec-plass.md', newTask: false });
  assert.deepEqual(splitSel('opptak/plass'), { task: 'opptak/plass', spec: null, newTask: false });
  assert.deepEqual(splitSel('ny-oppgave'), { task: null, spec: null, newTask: true });
  assert.deepEqual(splitSel(null), { task: null, spec: null, newTask: false });
});
