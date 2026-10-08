import assert from 'node:assert/strict';
import { test } from 'node:test';
import { changedFile, draftPicked, prTitle, readHead, setPriority, setStatus, setTitle } from './edit.ts';

const FILE = `# language: no
@BRU-APP-API-001 @must @planned
Egenskap: Se applikasjoner
  Som administrator

  @draft @openquestion
  Regel: Noe
`;

test('readHead leser tagger, status, prioritet og tittel på Egenskap', () => {
  const h = readHead(FILE)!;
  assert.deepEqual(h.tags, ['@BRU-APP-API-001', '@must', '@planned']);
  assert.equal(h.status, 'planned');
  assert.equal(h.priority, 'must');
  assert.equal(h.title, 'Se applikasjoner');
  assert.equal(h.line, 2);
  assert.equal(readHead('bare tekst'), null);
  assert.equal(readHead('@levert\nEgenskap: X')!.status, 'implemented');
});

test('setStatus bytter statustaggen på samme plass, og rører ikke taggene på Regel', () => {
  const out = setStatus(FILE, 'in-progress');
  assert.match(out, /^@BRU-APP-API-001 @must @in-progress$/m);
  assert.match(out, /^  @draft @openquestion$/m);
  assert.equal(out.split('\n').length, FILE.split('\n').length);
});

test('setStatus erstatter @levert, fjerner status med null, og legger til der det mangler', () => {
  assert.match(setStatus('@A-B-C-001 @levert\nEgenskap: X\n', 'implemented'), /^@A-B-C-001 @implemented$/m);
  assert.match(setStatus(FILE, null), /^@BRU-APP-API-001 @must$/m);
  assert.match(setStatus('@A-B-C-001\nEgenskap: X\n', 'draft'), /^@A-B-C-001 @draft$/m);
  assert.equal(setStatus('# language: no\nEgenskap: X\n', 'draft'), '# language: no\n@draft\nEgenskap: X\n');
});

test('setStatus fjerner doble statuser og tomme tag-linjer', () => {
  const out = setStatus('@A-B-C-001 @draft\n@planned\nEgenskap: X\n', 'planned');
  assert.equal(out, '@A-B-C-001 @planned\nEgenskap: X\n');
});

test('setPriority bytter MoSCoW-taggen', () => {
  assert.match(setPriority(FILE, 'could'), /^@BRU-APP-API-001 @could @planned$/m);
  assert.match(setPriority(FILE, null), /^@BRU-APP-API-001 @planned$/m);
});

test('setTitle bytter tittelen og beholder linjeslutt', () => {
  assert.match(setTitle(FILE, ' Ny tittel\n'), /^Egenskap: Ny tittel$/m);
  const crlf = FILE.replace(/\n/g, '\r\n');
  assert.equal(setTitle(crlf, 'Y').split('\r\n').length, crlf.split('\r\n').length);
});

test('prTitle foreslår en tittel ut fra filene', () => {
  assert.equal(prTitle(['krav/a/se_ting.feature'], {}), 'Krav: se ting');
  assert.equal(prTitle(['krav/a/x.feature'], { 'krav/a/x.feature': 'Se X' }), 'Krav: Se X');
  assert.equal(prTitle(['krav/a/01 Liste/x.feature', 'krav/a/01 Liste/y.feature'], {}), 'Krav: Liste (2 filer)');
  assert.equal(prTitle(['krav/a/x.feature', 'krav/b/y.feature'], {}), 'Krav: 2 filer');
});

test('changedFile finner fila blant ucommittede og committede endringer', () => {
  const git = {
    branch: 'b',
    commits: 1,
    uncommitted: [{ path: 'krav/a.feature', code: 'M' as const, plus: 1, minus: 0 }],
    committed: [{ path: 'krav/b.feature', code: 'A' as const, plus: 3, minus: 0 }],
  };
  assert.equal(changedFile(git, 'krav/a.feature'), true);
  assert.equal(changedFile(git, 'krav/b.feature'), true);
  assert.equal(changedFile(git, 'krav/c.feature'), false);
  assert.equal(changedFile(null, 'krav/a.feature'), false);
});

test('draftPicked: uten utkast fila dialogen åpnes fra, ellers de ucommittede', () => {
  assert.deepEqual(draftPicked(null, 'krav/a.feature', ['krav/b.feature']), ['krav/a.feature']);
  assert.deepEqual(draftPicked(null, undefined, ['krav/b.feature']), ['krav/b.feature']);
});

test('draftPicked: med utkast beholdes valgene, og fila dialogen åpnes fra legges til', () => {
  assert.deepEqual(draftPicked([], undefined, ['krav/b.feature']), []);
  assert.deepEqual(draftPicked(['krav/b.feature'], 'krav/a.feature', []), ['krav/b.feature', 'krav/a.feature']);
  assert.deepEqual(draftPicked(['krav/a.feature'], 'krav/a.feature', []), ['krav/a.feature']);
});
