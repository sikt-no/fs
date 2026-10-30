import assert from 'node:assert/strict';
import { test } from 'node:test';
import type { Entry, Snapshot } from '../shared/model.ts';
import { idQuery, kravId, makeIndex, search } from './search.ts';

const feature = (path: string, tags: string[], title = '', scens: string[] = []): Entry => ({
  path,
  kind: 'feature',
  status: null,
  savedAt: 0,
  model: { title, tags, rules: [{ name: null, scenarios: scens.map((name, i) => ({ name, tags: [], ln: 10 + i })) }] } as unknown as Entry['model'],
});

const GRU = 'krav/02 Opptak/11 Opprette og vedlikeholde opptak/01 Grunnoppsett';
const KRA = 'krav/02 Opptak/10 Regelverk/02 Krav';
const entries: Snapshot = Object.fromEntries(
  [
    feature(`${GRU}/opptaksstatus.feature`, ['@OPT-OVO-GRU-004', '@must', '@implemented'], 'Status på opptaket'),
    feature(`${GRU}/opprett_opptak.feature`, ['@OPT-OVO-GRU-001', '@must', '@implemented'], 'Opprette et opptak', ['Opprette et lokalt opptak']),
    feature(`${GRU}/forvalte_opptakstyper.feature`, ['@OPT-OVO-GRU-003', '@could', '@draft'], 'Opptakstyper med navn og forkortelse'),
    feature(`${KRA}/kravelement.feature`, ['@OPT-REG-KRA-002', '@must', '@implemented'], 'Kravelement', ['Opprette fagkrav-kravelement']),
    feature(`${KRA}/uten_id.feature`, ['@draft'], 'Uten ID'),
    { path: 'krav/README.md', kind: 'md', status: null, savedAt: 0 } as Entry,
  ].map(e => [e.path, e]),
);
const index = makeIndex(entries);
const ids = (q: string) => search(index, entries, q).map(h => kravId(h.entry));

test('kravId gir Feature-ID-en uten @, og null uten ID', () => {
  assert.equal(kravId(entries[`${GRU}/opprett_opptak.feature`]), 'OPT-OVO-GRU-001');
  assert.equal(kravId(entries[`${KRA}/uten_id.feature`]), null);
  assert.equal(kravId(entries['krav/README.md']), null);
});

test('idQuery kjenner igjen en del av en Feature-ID', () => {
  assert.equal(idQuery(entries, 'GRU-00'), 'GRU-00');
  assert.equal(idQuery(entries, 'gru-00'), 'GRU-00', 'store og små bokstaver er det samme');
  assert.equal(idQuery(entries, '@OPT-OVO-GRU-001'), 'OPT-OVO-GRU-001');
  assert.equal(idQuery(entries, 'OPT-OVO'), 'OPT-OVO');
  assert.equal(idQuery(entries, 'kra'), null, 'uten bindestrek eller tall er det et vanlig søk');
  assert.equal(idQuery(entries, 'fagkrav-kravelement'), null, 'finnes ikke i noen ID');
  assert.equal(idQuery(entries, 'GRU-00 opptak'), null, 'mellomrom gir vanlig søk');
});

test('søk på ID gir bare kravene med ID-en, sortert på ID, med treffet markert', () => {
  const hits = search(index, entries, 'gru-00');
  assert.deepEqual(hits.map(h => kravId(h.entry)), ['OPT-OVO-GRU-001', 'OPT-OVO-GRU-003', 'OPT-OVO-GRU-004']);
  assert.deepEqual(hits[0].idRanges, [[8, 13]]);
  assert.deepEqual(hits[0].scens, [], 'scenarioene er ikke med');
  assert.deepEqual(ids('OPT-REG-KRA-002'), ['OPT-REG-KRA-002']);
});

test('søk på filnavn, tittel og scenarioer virker som før', () => {
  const hits = search(index, entries, 'opprett');
  const opprett = hits.find(h => kravId(h.entry) === 'OPT-OVO-GRU-001');
  assert.ok(opprett, 'filnavnet treffer');
  assert.ok(opprett.nameRanges.length > 0);
  assert.ok(hits.some(h => h.scens.some(s => s.name === 'Opprette fagkrav-kravelement')), 'scenarioene treffer');
  assert.ok(ids('Status på opptaket').includes('OPT-OVO-GRU-004'), 'tittelen treffer');
  assert.ok(ids('uten_id').includes(null), 'krav uten ID finnes på filnavnet');
});
