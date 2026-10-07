import assert from 'node:assert/strict';
import { test } from 'node:test';
import { buildEntry } from '../server/parse.ts';
import { screenshotLine, verifyKravPrompt } from './verifyPrompt.ts';

const SRC = `# language: no
@BRU-TIL-ROL-001 @must @implemented
Egenskap: Tildele roller
  Som administrator
  ønsker jeg å tildele roller
  slik at brukerne får tilgang.

  Regel: Tildele en rolle
    Scenario: Tildele rolle
      Gitt jeg er innlogget
      Når jeg tildeler en rolle
      Så har brukeren rollen

  @planned
  Regel: Fjerne en rolle
    Scenario: Fjerne rolle
      Gitt jeg er innlogget
      Når jeg fjerner en rolle
      Så har brukeren ikke rollen
`;
const e = buildEntry('krav/07 Bru/11 Til/01 Rol/tildele_roller.feature', SRC, 0);

test('verifyKravPrompt: hele egenskapen, med status', () => {
  assert.equal(
    verifyKravPrompt(e, { kind: 'feature' }),
    'Verifiser egenskapen «Tildele roller» i krav/07 Bru/11 Til/01 Rol/tildele_roller.feature (@BRU-TIL-ROL-001) uansett status (se «Verifisere uansett status» i fs-verify).\nStatus på Egenskap: @implemented.',
  );
});

test('verifyKravPrompt: en regel, med regelens og egenskapens status', () => {
  const planned = verifyKravPrompt(e, { kind: 'rule', index: 1 })!;
  assert.match(planned, /^Verifiser regelen «Fjerne en rolle» \(linje 15\) i krav\/.*tildele_roller\.feature \(@BRU-TIL-ROL-001\) uansett status/);
  assert.match(planned, /Status på regelen: @planned\. Status på Egenskap: @implemented\.$/);
  assert.match(verifyKravPrompt(e, { kind: 'rule', index: 0 })!, /Status på regelen: ingen egen statustag \(arver fra egenskapen\)\./);
  assert.equal(verifyKravPrompt(e, { kind: 'rule', index: 5 }), null);
});

test('verifyKravPrompt: linja om skjermbilder bare når valget er gjort', () => {
  assert.equal(verifyKravPrompt(e, { kind: 'feature' }, true)!.split('\n').at(-1), screenshotLine(true));
  assert.equal(verifyKravPrompt(e, { kind: 'rule', index: 1 }, false)!.split('\n').at(-1), 'Ingen skjermbilder.');
  assert.ok(!/skjermbilder/i.test(verifyKravPrompt(e, { kind: 'feature' })!));
});
