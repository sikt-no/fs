import assert from 'node:assert/strict';
import { test } from 'node:test';
import type { Entry, Snapshot } from '../shared/model.ts';
import { addMentions, covered, mentionList, parseMention, pushRecent, recentMentions, shortPath, stripMention } from './mention.ts';
import { makeMentionIndex, mentionItems, searchMentions } from './search.ts';

const entry = (path: string, title = ''): Entry => ({
  path,
  kind: path.endsWith('.md') ? 'md' : 'feature',
  status: null,
  savedAt: 0,
  ...(path.endsWith('.feature') ? { model: { title, tags: [], rules: [] } as unknown as Entry['model'] } : {}),
});
const snap = (...paths: string[]): Snapshot => Object.fromEntries(paths.map(p => [p, entry(p)]));

const PB = 'krav/07 Brukeradministrasjon/12 Brukeradministrasjon/personbrukere';
const entries = snap(
  `${PB}/1 - Grunnleggende/listevisning_og_sok.feature`,
  `${PB}/1 - Grunnleggende/tildele_roller.feature`,
  `${PB}/begrepsbruk.md`,
  'krav/02 Opptak/10 Regelverk/02 Krav/kompetanseregelverk.feature',
);

test('parseMention finner søket etter @ på slutten', () => {
  assert.equal(parseMention('Sammenlign med @bruker'), 'bruker');
  assert.equal(parseMention('@'), '');
  assert.equal(parseMention('se @to ord'), 'to ord');
  assert.equal(parseMention('epost@sikt.no'), null, '@ midt i et ord er ikke en omtale');
  assert.equal(parseMention('@a\nny linje'), null);
  assert.equal(parseMention('ingen'), null);
  assert.equal(stripMention('Sammenlign med @bruker'), 'Sammenlign med ');
  assert.equal(stripMention('@bruker'), '');
});

test('addMentions: en mappe dekker det som ligger under den', () => {
  const f = `${PB}/begrepsbruk.md`;
  let m = addMentions([], [f]);
  assert.deepEqual(m, [f]);
  m = addMentions(m, [PB]);
  assert.deepEqual(m, [PB], 'mappa tar over for fila under');
  assert.deepEqual(addMentions(m, [f, PB]), [PB], 'det som alt er dekket, legges ikke til');
  assert.ok(covered(m, f));
  assert.ok(!covered(m, `${PB}x/a.feature`), 'bare ekte undermapper');
});

test('mentionItems utleder mappene fra filstiene, med antall features', () => {
  const items = mentionItems(entries);
  assert.equal(items.get(PB)?.dir, true);
  assert.equal(items.get(PB)?.count, 2, '.md telles ikke');
  assert.equal(items.get('krav/07 Brukeradministrasjon')?.parent, 'krav');
  assert.ok(!items.has('krav'), 'rota er ikke med');
  assert.equal(items.get(`${PB}/begrepsbruk.md`)?.dir, false);
});

test('searchMentions bruker samme Fuse-søk som treet, og mentionList legger mappene først', () => {
  const items = mentionItems(entries);
  const hits = searchMentions(makeMentionIndex(items), items, 'bruker');
  assert.ok(hits.some(h => h.item.path === PB));
  assert.ok(hits.some(h => h.item.path === `${PB}/begrepsbruk.md`));
  assert.ok(!hits.some(h => h.item.path.includes('Opptak')));
  assert.ok(hits.find(h => h.item.path === PB)!.ranges.length, 'treffet i navnet utheves');
  const l = mentionList(hits, 'all');
  assert.ok(l.dirs.length && l.files.length);
  assert.deepEqual(l.flat, [...l.dirs, ...l.files]);
  assert.equal(mentionList(hits, 'dir').files.length, 0);
  assert.equal(mentionList(hits, 'file').dirs.length, 0);
});

test('mentionList viser 5 mapper og 7 filer med «Alle», 14 med filter', () => {
  const mk = (n: number, dir: boolean) =>
    Array.from({ length: n }, (_, i) => ({ item: { path: `krav/${dir ? 'd' : 'f'}${i}`, dir, name: '', parent: 'krav', depth: 1, count: 0 }, ranges: [] }));
  const hits = [...mk(20, true), ...mk(20, false)];
  const all = mentionList(hits, 'all');
  assert.equal(all.dirs.length, 5);
  assert.equal(all.files.length, 7);
  assert.equal(all.moreDirs, 15);
  assert.equal(all.moreFiles, 13);
  assert.equal(mentionList(hits, 'dir').dirs.length, 14);
  assert.equal(mentionList(hits, 'dir').moreFiles, 0);
});

test('nylig brukt: de sist lagt til, ellers fila brukeren ser på og mappa dens', () => {
  const items = mentionItems(entries);
  const f = `${PB}/begrepsbruk.md`;
  assert.deepEqual(recentMentions([], f, items).map(h => h.item.path), [PB, f]);
  assert.deepEqual(recentMentions(['krav/borte', f], null, items).map(h => h.item.path), [f], 'det som er borte, hoppes over');
  assert.deepEqual(recentMentions([], null, items), []);
  assert.deepEqual(pushRecent(['a', 'b'], ['c', 'a']), ['a', 'c', 'b']);
  assert.equal(pushRecent([], ['1', '2', '3', '4', '5', '6', '7']).length, 6);
});

test('shortPath fjerner krav/ og korter ned forfra', () => {
  assert.equal(shortPath('krav'), 'krav');
  assert.equal(shortPath('krav/02 Opptak'), '02 Opptak');
  assert.equal(shortPath(`${PB}/1 - Grunnleggende`), '…' + `${PB}/1 - Grunnleggende`.slice(-38));
});
