// Tester konvensjonssjekkene i parse.ts. Hver regel har ett brudd og ett gyldig eksempel.
// Holdes i synk med reglene merket «(sjekkes i vieweren)» i krav/README.md.
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { parseFeature } from './parse.ts';

const PATH = 'krav/02 Opptak/10 Regelverk/02 Krav/lage_opptak.feature';

/** Bygger en gyldig feature-fil; `tags` og `body` kan overstyres for å lage brudd. */
const feature = ({ header = '# language: no', tags = '@OPT-REG-KRA-001 @must @planned', body = '' } = {}) =>
  `${header}
${tags}
Egenskap: Lage opptak

${body ||
  `  Scenario: Opprette et opptak
    Gitt jeg er innlogget
    Når jeg oppretter et opptak
    Så vises opptaket i listen`}
`;

const lint = (source: string, path = PATH) => parseFeature(source, path).lint.map(l => l.msg);
const has = (source: string, text: string, path?: string) => lint(source, path).some(m => m.includes(text));

test('en gyldig fil har ingen avvik', () => {
  assert.deepEqual(lint(feature()), []);
});

test('language: no', () => {
  assert.ok(has(feature({ header: '' }), '# language: no'));
});

test('kapabilitetsnivå', () => {
  assert.ok(has(feature(), 'kapabilitetsnivå', 'krav/02 Opptak/10 Regelverk/lage_opptak.feature'));
  assert.ok(has(feature(), 'kapabilitetsnivå', 'krav/02 Opptak/10 Regelverk/02 Krav/ekstra/lage_opptak.feature'));
});

test('filnavn i snake_case', () => {
  assert.ok(has(feature(), 'snake_case', 'krav/02 Opptak/10 Regelverk/02 Krav/Lage-opptak.feature'));
  assert.ok(!has(feature(), 'snake_case', 'krav/02 Opptak/10 Regelverk/02 Krav/søke_på_opptak_2.feature'));
});

test('feature-ID', () => {
  assert.ok(has(feature({ tags: '@must @planned' }), 'mangler feature-ID'));
  assert.ok(has(feature({ tags: '@OPT-REG-KRA-001 @OPT-REG-KRA-002 @must @planned' }), 'flere feature-IDer'));
  assert.ok(!has(feature({ tags: '@TEK-BRU-UI-001 @must @planned' }), 'feature-ID'));
});

test('prioritet', () => {
  assert.ok(has(feature({ tags: '@OPT-REG-KRA-001 @must @could @planned' }), 'flere prioritetstagger'));
  assert.ok(!has(feature({ tags: '@OPT-REG-KRA-001 @planned' }), 'prioritet'));
});

test('nøyaktig én statustag på Egenskap', () => {
  assert.ok(has(feature({ tags: '@OPT-REG-KRA-001 @must' }), 'mangler statustag'));
  assert.ok(has(feature({ tags: '@OPT-REG-KRA-001 @must @draft @planned' }), 'flere statustagger'));
});

test('bare @draft som statustag under Egenskap', () => {
  const body = `  @planned
  Scenario: Opprette et opptak
    Gitt jeg er innlogget`;
  assert.ok(has(feature({ body }), '@planned på Scenario'));
});

test('@draft på del er overflødig når Egenskap er @draft', () => {
  const body = `  @draft
  Regel: Opprette
    Scenario: Opprette et opptak
      Gitt jeg er innlogget`;
  assert.ok(has(feature({ tags: '@OPT-REG-KRA-001 @must @draft', body }), 'overflødig'));
  assert.ok(!has(feature({ body }), 'overflødig'));
  assert.equal(parseFeature(feature({ body }), PATH).partialDraft, true);
});

test('@openquestion på Egenskap', () => {
  assert.ok(has(feature({ tags: '@OPT-REG-KRA-001 @must @planned @openquestion' }), 'hører hjemme på Regel/Scenario'));
});

test('@openquestion krever «# ÅPNE SPØRSMÅL:»', () => {
  const without = `  @openquestion
  Scenario: Opprette et opptak
    Gitt jeg er innlogget`;
  const withQ = `  @openquestion
  Scenario: Opprette et opptak
    # ÅPNE SPØRSMÅL:
    # - Hvem kan opprette opptak?
    Gitt jeg er innlogget`;
  assert.ok(has(feature({ body: without }), 'ÅPNE SPØRSMÅL'));
  assert.ok(!has(feature({ body: withQ }), 'ÅPNE SPØRSMÅL'));
});

test('Eksempler bare med Scenariomal', () => {
  const examples = (kw: string) => `  ${kw}: Velge antall
    Når jeg velger <antall>
    Så vises <antall> rader

    Eksempler:
      | antall |
      | 50     |`;
  assert.ok(has(feature({ body: examples('Scenario') }), 'bruk Scenariomal'));
  assert.ok(!has(feature({ body: examples('Scenariomal') }), 'bruk Scenariomal'));
});

test('stegene går Gitt → Når → Så', () => {
  const wrong = `  Scenario: Opprette et opptak
    Når jeg oppretter et opptak
    Så vises opptaket
    Gitt jeg er innlogget`;
  const many = `  Scenario: Opprette et opptak
    Gitt jeg er innlogget
    Og jeg har rettigheter
    Når jeg oppretter et opptak
    Og jeg lagrer
    Så vises opptaket
    Men ikke i arkivet`;
  assert.ok(has(feature({ body: wrong }), 'Gitt → Når → Så'));
  assert.ok(!has(feature({ body: many }), 'Gitt → Når → Så'));
});
