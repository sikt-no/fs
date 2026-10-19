import assert from 'node:assert/strict';
import { test } from 'node:test';
import { parseFeature } from '../server/parse.ts';
import { findGroups, findHits, findRanges, findSummary, matcher, segments, wordIndex } from './find.ts';

const pick = (text: string, q: string) => findRanges(text, q).map(([s, e]) => text.slice(s, e));

test('findRanges: ord som inneholder søket markeres hele, uten å skille store og små bokstaver', () => {
  assert.deepEqual(pick('Studierett og studieretten', 'studierett'), ['Studierett', 'studieretten']);
  assert.deepEqual(pick('søknadsfrist og fristen', 'frist'), ['søknadsfrist', 'fristen']);
  assert.deepEqual(pick('Søker får svar', 'SØK'), ['Søk']);
});

test('findRanges: Fuse tåler skrivefeil, byttede bokstaver og æøå', () => {
  assert.deepEqual(pick('Så vises studierettigheter', 'studieret'), ['studierettigheter']);
  assert.deepEqual(pick('Så vises organisasjonen', 'organsiasjon'), ['organisasjonen']);
  assert.deepEqual(pick('Når administratoren åpner', 'admnistratoren'), ['administratoren']);
  assert.deepEqual(pick('Så vises kun brukere med valgt status', 'stauts'), ['status']);
  assert.deepEqual(pick('jeg velger miljø som filter', 'miljo'), ['miljø']);
});

test("findRanges: 'ord gir bare eksakt treff", () => {
  assert.deepEqual(pick('Så vises organisasjonen', "'organsiasjon"), []);
  assert.deepEqual(pick('Så vises organisasjonen', "'organisasjon"), ['organisasjon']);
});

test('findRanges: korte ord er alltid eksakte, og ett tegn søkes ikke', () => {
  assert.deepEqual(pick('rolle og rulle', 'rul'), ['rul']);
  assert.deepEqual(pick('rolle og rulle', 'rull'), ['rolle', 'rulle']);
  assert.deepEqual(pick('abc', 'a'), []);
});

test('findRanges: flere ord, sortert og slått sammen', () => {
  assert.deepEqual(pick('Gitt at administratoren er innlogget', 'innlogget admin'), ['administratoren', 'innlogget']);
  assert.deepEqual(findRanges('abcdef', 'abcd cdef'), [[0, 6]]);
});

test('findRanges: med flere ord må alle treffe, og en innlimt tittel blir ett treff', () => {
  const title = 'Tilgjengelige organisasjoner i filter';
  assert.deepEqual(pick(title, title), [title]);
  assert.deepEqual(pick('Filtrere på organisasjon', title), []);
  // Ord som står etter hverandre, blir ett treff selv om frasen ikke står eksakt
  assert.deepEqual(pick('Og listen viser de 50 første applikasjonene', 'Liste viser de 50 første applikasjonene'), ['listen viser de 50 første applikasjonene']);
  assert.deepEqual(pick('status på bruker, og filter på status', 'status filter'), ['status', 'filter', 'status']);
});

test('matcher: ordindeksen for hele fila brukes for alle tekstene', () => {
  const m = matcher(wordIndex(['Filtrere på organisasjon', 'Tilgjengelige organisasjoner']), 'organsiasjon');
  assert.deepEqual([...m.terms[0].words].sort(), ['organisasjon', 'organisasjoner']);
  assert.equal(m.phrase, null);
  assert.deepEqual(findRanges('Tilgjengelige organisasjoner', m), [[14, 28]]);
});

const SRC = `# language: no
@BRU-APP-API-001 @must @planned
Egenskap: Listevisning og søk i brukere
  Som administrator
  ønsker jeg en oversikt over brukere

  Regel: Liste over alle brukere
    Scenario: Se liste over brukere
      Når jeg åpner brukeroversikten
      Så vises kolonnene
        | felt    |
        | Navn    |
        | Feide-ID |

    Scenario: Filtrere på status
      # ÅPNE SPØRSMÅL:
      # - Hvilke statuser finnes for brukere?
      Når jeg velger status som filter
      Så vises kun brukere med valgt status
`;

test('findHits: rekkefølge, blokker og treff per scenario', () => {
  const m = parseFeature(SRC);
  const r = findHits(m, 'brukere');
  assert.deepEqual(
    r.hits.map(h => h.loc),
    ['title', 'desc:1', 'r0', 's0-0', 't0-0-0', 's0-1n0:0', 't0-1-1'],
  );
  assert.deepEqual(r.hits.map(h => h.id), [0, 1, 2, 3, 4, 5, 6]);
  // «brukeroversikten» treffer med én skrivefeil mot starten av ordet
  assert.equal(r.hits[4].text.slice(r.hits[4].s, r.hits[4].e), 'brukeroversikten');
  assert.equal(r.perScen.get('0-0'), 2);
  assert.equal(r.perScen.get('0-1'), 2);
  assert.deepEqual(r.hits.map(h => h.scen), [null, null, null, '0-0', '0-0', '0-1', '0-1']);
  const groups = findGroups(r.hits);
  assert.deepEqual(groups.map(g => [g.kind, g.label, g.items.length]), [
    ['EGENSKAP', 'Listevisning og søk i brukere', 2],
    ['REGEL 1', 'Liste over alle brukere', 1],
    ['REGEL 1 · SCENARIO', 'Se liste over brukere', 2],
    ['REGEL 1 · SCENARIO', 'Filtrere på status', 2],
  ]);
  assert.deepEqual(groups[3].items.map(i => i.kw), ['?', 'Så']);
  assert.equal(findSummary(r.hits.length, groups.length, 2), '7 treff i 4 blokker · 3 av 7');
  assert.equal(findSummary(0, 0, 0), 'Ingen treff');
});

test('findHits: tabellceller og fortelling', () => {
  const m = parseFeature(SRC);
  assert.deepEqual(findHits(m, 'feide').hits.map(h => h.loc), ['t0-0-1:2:0']);
  assert.deepEqual(findHits(m, 'administrator').hits.map(h => h.loc), ['desc:0']);
  assert.equal(findHits(m, '  ').hits.length, 0);
});

test('findGroups: utdrag rundt treffet', () => {
  const text = 'Så vises kun brukere med valgt status og som er aktive i organisasjonen og ikke slettet';
  const s = text.indexOf('organisasjonen');
  const [g] = findGroups([{ id: 0, loc: 'x', scen: null, ctx: { g: 'a', kind: 'K', label: 'L', kw: 'Så' }, text, s, e: s + 14 }]);
  assert.equal(g.items[0].hl, 'organisasjonen');
  assert.ok(g.items[0].pre.startsWith('…'));
  assert.equal(g.items[0].pre.length, 27);
  assert.ok(g.items[0].post.endsWith('…') === false);
});

test('segments: parametere og treff', () => {
  const PARAM = /(<[^>]+>)/;
  assert.deepEqual(segments('velger <verdi> nå', PARAM), [
    { t: 'velger ', mark: false },
    { t: '<verdi>', mark: true },
    { t: ' nå', mark: false },
  ]);
  // Treffet går over grensen til parameteren
  assert.deepEqual(segments('velger <verdi> nå', PARAM, [{ s: 3, e: 10, id: 7 }]), [
    { t: 'vel', mark: false },
    { t: 'ger ', mark: false, hit: 7 },
    { t: '<ve', mark: true, hit: 7 },
    { t: 'rdi>', mark: true },
    { t: ' nå', mark: false },
  ]);
  assert.deepEqual(segments('<a>', PARAM), [{ t: '<a>', mark: true }]);
  assert.deepEqual(segments('abc', null, [{ s: 0, e: 3, id: 0 }]), [{ t: 'abc', mark: false, hit: 0 }]);
});
