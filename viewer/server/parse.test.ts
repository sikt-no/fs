// Tester konvensjonssjekkene i parse.ts. Hver regel har ett brudd og ett gyldig eksempel.
// Holdes i synk med reglene merket «(sjekkes i vieweren)» i krav/README.md.
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { RULE, RULES } from '../shared/rules.ts';
import { parseFeature } from './parse.ts';

const PATH = 'krav/02 Opptak/10 Regelverk/02 Krav/lage_opptak.feature';

/** Bygger en gyldig feature-fil; `tags` og `body` kan overstyres for å lage brudd. */
const feature = ({ header = '# language: no', tags = '@OPT-REG-KRA-001 @must @planned', body = '' } = {}) =>
  `${header}
${tags}
Egenskap: Lage opptak
  Som administrator
  ønsker jeg å opprette opptak
  slik at søkere kan søke

${body ||
  `  Scenario: Opprette et opptak
    Gitt jeg er innlogget
    Når jeg oppretter et opptak
    Så vises opptaket i listen`}
`;

const lint = (source: string, path = PATH) => parseFeature(source, path).lint.map(l => l.msg);
const has = (source: string, text: string, path?: string) => lint(source, path).some(m => m.includes(text));
/** Regel-ID-ene (shared/rules.ts) avvikene får */
const rules = (source: string, path = PATH) => parseFeature(source, path).lint.map(l => l.rule);
const hasRule = (source: string, rule: string, path?: string) => rules(source, path).includes(rule);

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

test('hvert avvik har regel-ID og alvorlighetsgrad fra shared/rules.ts', () => {
  const src = feature({ header: '', tags: '@must @could' });
  for (const l of parseFeature(src, 'krav/02 Opptak/10 Regelverk/Lage-opptak.feature').lint) {
    assert.ok(RULE[l.rule], `ukjent regel ${l.rule}`);
    assert.equal(l.sev, RULE[l.rule].sev);
  }
  assert.deepEqual(new Set(rules(src, 'krav/02 Opptak/10 Regelverk/Lage-opptak.feature')), new Set(['missing-language', 'wrong-level', 'not-snake-case', 'missing-id', 'multiple-priorities', 'missing-status']));
});

test('ikke # TODO: for åpne spørsmål', () => {
  const todo = `  Scenario: Opprette et opptak
    # TODO: Avklar med produkteier
    Gitt jeg er innlogget`;
  const note = `  Scenario: Opprette et opptak
    # Merk: gjelder bare lokale opptak
    Gitt jeg er innlogget`;
  assert.ok(hasRule(feature({ body: todo }), 'todo-comment'));
  assert.ok(!hasRule(feature({ body: note }), 'todo-comment'));
});

test('@levert er erstattet av @implemented', () => {
  assert.ok(hasRule(feature({ tags: '@OPT-REG-KRA-001 @must @levert' }), 'retired-levert'));
  const body = `  @levert
  Scenario: Opprette et opptak
    Gitt jeg er innlogget`;
  assert.ok(hasRule(feature({ body }), 'retired-levert'));
  assert.ok(!hasRule(feature({ tags: '@OPT-REG-KRA-001 @must @implemented' }), 'retired-levert'));
});

test('@only og @focus hører ikke hjemme i en kravfil', () => {
  assert.ok(hasRule(feature({ tags: '@OPT-REG-KRA-001 @must @planned @focus' }), 'focus-tag'));
  const only = `  @only
  Scenario: Opprette et opptak
    Gitt jeg er innlogget`;
  assert.ok(hasRule(feature({ body: only }), 'focus-tag'));
  assert.ok(!hasRule(feature(), 'focus-tag'));
});

test('sub-domener nummereres fra 10, kapabiliteter har nummer', () => {
  assert.ok(hasRule(feature(), 'folder-numbering', 'krav/07 Brukeradministrasjon/applikasjoner/01 Iterasjon 2/lage_opptak.feature'));
  assert.ok(hasRule(feature(), 'folder-numbering', 'krav/02 Opptak/05 Regelverk/02 Krav/lage_opptak.feature'));
  assert.ok(hasRule(feature(), 'folder-numbering', 'krav/02 Opptak/10 Regelverk/Krav/lage_opptak.feature'));
  assert.ok(!hasRule(feature(), 'folder-numbering'));
  // Demo og interne prosesser følger ikke nummereringen
  assert.ok(!hasRule(feature(), 'folder-numbering', 'krav/99 Demo/01 Studiekatalog/01 Søk/lage_opptak.feature'));
});

test('sub-domene og kapabilitet heter ikke det samme', () => {
  assert.ok(hasRule(feature(), 'same-name', 'krav/05 Opplysninger om person/10 Søk/01 Søk/lage_opptak.feature'));
  assert.ok(!hasRule(feature(), 'same-name', 'krav/09 Organisasjon/10 Finn organisasjon/01 Identifikatorsøk/lage_opptak.feature'));
});

test('Egenskap har en beskrivelse', () => {
  const bare = `# language: no
@OPT-REG-KRA-001 @must @planned
Egenskap: Lage opptak

  Scenario: Opprette et opptak
    Gitt jeg er innlogget
`;
  assert.ok(hasRule(bare, 'missing-description'));
  assert.ok(!hasRule(feature(), 'missing-description'));
});

test('@draft-del tagges @draft @openquestion', () => {
  const draft = `  @draft
  Scenario: Opprette et opptak
    Gitt jeg er innlogget`;
  const reviewed = `  @draft @openquestion
  Scenario: Opprette et opptak
    # ÅPNE SPØRSMÅL:
    # - Hvem kan opprette opptak?
    Gitt jeg er innlogget`;
  assert.ok(hasRule(feature({ body: draft }), 'draft-without-openquestion'));
  assert.ok(!hasRule(feature({ body: reviewed }), 'draft-without-openquestion'));
  // Under en egenskap som selv er @draft gjelder regelen om overflødig @draft i stedet
  assert.ok(!hasRule(feature({ tags: '@OPT-REG-KRA-001 @must @draft', body: draft }), 'draft-without-openquestion'));
});

test('hver regel peker på en overskrift som finnes i krav/README.md («Les regelen»)', () => {
  const readme = readFileSync(join(import.meta.dirname, '../../krav/README.md'), 'utf8');
  const heads = new Set(readme.split('\n').filter(l => /^#{2,3} /.test(l)).map(l => l.replace(/^#+ /, '').trim()));
  for (const r of RULES) assert.ok(heads.has(r.section), `${r.id}: fant ikke overskriften «${r.section}»`);
});
