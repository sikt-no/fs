import assert from 'node:assert/strict';
import { test } from 'node:test';
import { inline, parseMd } from './markdown.ts';

test('inline: ~~tekst~~ blir gjennomstreket', () => {
  assert.deepEqual(inline('før ~~borte~~ etter'), [
    { kind: 'plain', t: 'før ' },
    { kind: 'strike', t: 'borte', c: [{ kind: 'plain', t: 'borte' }] },
    { kind: 'plain', t: ' etter' },
  ]);
});

test('inline: ~ alene er vanlig tekst', () => {
  assert.deepEqual(inline('ca. ~50 og ~ 3'), [{ kind: 'plain', t: 'ca. ~50 og ~ 3' }]);
});

test('inline: *kursiv* og _kursiv_, men ikke snake_case eller 2 * 3', () => {
  assert.deepEqual(inline('*(sjekkes automatisk)*'), [{ kind: 'em', t: '(sjekkes automatisk)', c: [{ kind: 'plain', t: '(sjekkes automatisk)' }] }]);
  assert.deepEqual(inline('a _b_ c'), [{ kind: 'plain', t: 'a ' }, { kind: 'em', t: 'b', c: [{ kind: 'plain', t: 'b' }] }, { kind: 'plain', t: ' c' }]);
  assert.deepEqual(inline('se_søknad.feature og 2 * 3 * 4'), [{ kind: 'plain', t: 'se_søknad.feature og 2 * 3 * 4' }]);
  assert.deepEqual(inline('**fet** *kursiv*'), [
    { kind: 'bold', t: 'fet', c: [{ kind: 'plain', t: 'fet' }] },
    { kind: 'plain', t: ' ' },
    { kind: 'em', t: 'kursiv', c: [{ kind: 'plain', t: 'kursiv' }] },
  ]);
});

test('inline: fet og kursiv kan inneholde `kode` med * i', () => {
  const [b] = inline('**Aldri `spec-*.md` i rota**');
  assert.ok(b.kind === 'bold');
  assert.equal(b.t, 'Aldri spec-*.md i rota');
  assert.deepEqual(b.c.map(g => g.kind), ['plain', 'code', 'plain']);
  const [e] = inline('*(`plan-<lag>.md` sjekkes automatisk)*');
  assert.ok(e.kind === 'em' && e.c[1].kind === 'code' && e.c[1].t === 'plan-<lag>.md');
});

test('parseMd: overskrift med `kode` har segmenter og ren tekst', () => {
  const [h] = parseMd('## Filen `a.md` er **viktig**');
  assert.equal(h.type, 'h2');
  assert.ok(h.type === 'h2' && h.text === 'Filen a.md er viktig');
  assert.deepEqual(h.type === 'h2' && h.segs.map(g => g.kind), ['plain', 'code', 'plain', 'bold']);
});

test('parseMd: nestede lister, også med blank linje og nummerering', () => {
  const b = parseMd('- a\n  - b\n    fortsatt\n  - c\n\n- d\n\n3. tre\n4. fire');
  assert.equal(b.length, 2);
  const [ul, ol] = b;
  assert.ok(ul.type === 'ul');
  assert.equal(ul.items.length, 2);
  assert.deepEqual(ul.items[0].sub?.items.map(it => it.segs[0].t), ['b fortsatt', 'c']);
  assert.equal(ul.items[1].segs[0].t, 'd');
  assert.ok(ol.type === 'ol' && ol.start === 3 && ol.items.length === 2);
});

test('parseMd: sjekklister', () => {
  const [ul] = parseMd('- [ ] åpen\n- [x] ferdig\n- vanlig');
  assert.ok(ul.type === 'ul');
  assert.deepEqual(ul.items.map(it => it.task), [false, true, undefined]);
  assert.equal(ul.items[1].segs[0].t, 'ferdig');
});

test('parseMd: sitat, skillelinje og frontmatter', () => {
  const b = parseMd('---\nissue: 1\n---\n> **Status:** utkast\n> linje to\n\n---\n\netter');
  assert.deepEqual(b.map(x => x.type), ['code', 'quote', 'hr', 'p']);
  assert.ok(b[0].type === 'code' && b[0].lang === 'frontmatter' && b[0].body[0] === 'issue: 1');
  assert.ok(b[1].type === 'quote' && b[1].blocks.length === 1 && b[1].blocks[0].type === 'p');
});
