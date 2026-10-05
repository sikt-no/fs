import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { applySpec, newSpecText, parseSpec, relativeTo, setKrav, setSection, slugify, type SpecDoc } from './spec.ts';

const SPEC = `# Spec: Tildele roller

## Kilde

- **Oppgave:** \`tasks/brukeradministrasjon-og-tilgangsstyring/roller/\`
- **Hentet:** 2026-10-01 10:00

## Krav

- **\`tildele_rolle.feature\`** (\`@BRU-TIL-ROL-001\`) — tildele rolle. ([krav-input/local/krav/07 Bru/11 Til/tildele_rolle.feature](krav-input/local/krav/07%20Bru/11%20Til/tildele_rolle.feature))

- **\`fjerne_rolle.feature\`** (\`@BRU-TIL-ROL-002\`) — fjerne rolle. ([lenke](krav-input/local/krav/07%20Bru/11%20Til/fjerne_rolle.feature))

### Skal fjernes (\`@deprecated\`)

- **\`gammel_rolle.feature\`** (\`@BRU-TIL-ROL-009\`) — gammel visning.

### Utenfor scope (\`@draft\`)

- **\`varsling.feature\`** — Regel: Varsel — utkast.

## Skisser

### Skisse: Rolletildeling

- **Type:** \`figma\`
- **Referanse:** <https://www.figma.com/design/abc/Brukeradmin?node-id=88-301> (\`fileKey\` \`abc\`)
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/rolletildeling/screenshot.png)
- **Dekker krav:** \`tildele_rolle.feature\`
- **Valideringsstatus:** \`Avvik\`: skissen mangler gyldighetsperiode

## Retagging

| Fil | Før | Etter |
|---|---|---|
| \`krav/x.feature\` | \`@planned\` | \`@in-progress\` |

## Åpne spørsmål

- [ ] Skal rollen arves?
- [x] Gjelder det EVU? Ja.
`;

test('parseSpec leser tittel, krav (med Skal fjernes, uten Utenfor scope), skisser og spørsmål', () => {
  const d = parseSpec(SPEC, 'spec-roller.md');
  assert.equal(d.title, 'Tildele roller');
  assert.equal(d.delta, false);
  assert.equal(d.omfang, '');
  assert.deepEqual(
    d.krav.map(k => [k.file, k.id, k.path, k.remove]),
    [
      ['tildele_rolle.feature', '@BRU-TIL-ROL-001', 'krav/07 Bru/11 Til/tildele_rolle.feature', false],
      ['fjerne_rolle.feature', '@BRU-TIL-ROL-002', 'krav/07 Bru/11 Til/fjerne_rolle.feature', false],
      ['gammel_rolle.feature', '@BRU-TIL-ROL-009', null, true],
    ],
  );
  assert.equal(d.skisser.length, 1);
  const k = d.skisser[0];
  assert.deepEqual([k.name, k.url, k.kind, k.note, k.dekker], ['Rolletildeling', 'https://www.figma.com/design/abc/Brukeradmin?node-id=88-301', 'Avvik', 'skissen mangler gyldighetsperiode', 'tildele_rolle.feature']);
  assert.deepEqual(d.sporsmal, [
    { t: 'Skal rollen arves?', done: false },
    { t: 'Gjelder det EVU? Ja.', done: true },
  ]);
  assert.deepEqual(d.rute, []);
});

test('parseSpec: delta, Omfang, Rute og «Ingen skisse»', () => {
  const d = parseSpec('# Delta-spec: Karakterkrav — 2026-10-02-abc\n\n## Omfang\n\nKrav per program.\nIkke EVU.\n\n## Skisser\n\nIngen skisse: bare API\n\n## Rute\n\nfs-plattform → fs-admin\n', 'spec-changes-2026-10-02-abc.md');
  assert.equal(d.delta, true);
  assert.equal(d.omfang, 'Krav per program.\nIkke EVU.');
  assert.equal(d.ingenSkisse, 'bare API');
  assert.deepEqual(d.rute, ['fs-plattform', 'fs-admin']);
});

test('parseSpec leser spesifikasjonen til opptaksoppgaven', () => {
  const text = readFileSync(new URL('../../tasks/opptak/opprette-og-vedlikeholde-opptak/spec/spec-opprette-og-vedlikeholde-opptak.md', import.meta.url), 'utf8');
  const d = parseSpec(text, 'spec-opprette-og-vedlikeholde-opptak.md');
  assert.equal(d.title, 'Opprette og vedlikeholde opptak');
  assert.deepEqual(d.krav.map(k => k.id), ['@OPT-OVO-GRU-001', '@OPT-OVO-SAM-001', '@OPT-OVO-INN-001', '@OPT-OVO-FRI-001']);
  assert.equal(d.skisser.length, 1);
  assert.equal(d.skisser[0].kind, 'OK');
  assert.match(d.skisser[0].url, /^https:\/\/www\.figma\.com\/design\/LmoNQlmAuE2FlE0fUo5GoO/);
  assert.deepEqual(d.sporsmal, []);
});

const edit = (fn: (d: SpecDoc) => void, text = SPEC) => {
  const prev = parseSpec(text);
  const next: SpecDoc = structuredClone(prev);
  fn(next);
  return applySpec(text, prev, next, { '@BRU-TIL-ROL-003': 'Se roller' }, 'tasks/brukeradministrasjon-og-tilgangsstyring/roller/spec');
};

test('applySpec skriver bare om seksjonene som er endret', () => {
  const out = edit(d => {
    d.title = 'Tildele og fjerne roller';
    d.omfang = 'Tildeling med periode.';
  });
  assert.match(out, /^# Spec: Tildele og fjerne roller$/m);
  assert.match(out, /## Kilde\n\n- \*\*Oppgave:\*\*[^\n]*\n- \*\*Hentet:\*\*[^\n]*\n\n## Omfang\n\nTildeling med periode\.\n\n## Krav/);
  // Resten står som før
  assert.ok(out.includes('| `krav/x.feature` | `@planned` | `@in-progress` |'));
  assert.ok(out.includes('- **Lagrede artefakter:** [screenshot.png]'));
  assert.deepEqual(parseSpec(out).krav, parseSpec(SPEC).krav);
});

test('applySpec: krav fjernes og legges til, og punktene som står røres ikke', () => {
  const out = edit(d => {
    d.krav = d.krav.filter(k => k.id !== '@BRU-TIL-ROL-002');
    d.krav.push({ file: 'se_roller.feature', id: '@BRU-TIL-ROL-003', path: 'krav/07 Bru/11 Til/se_roller.feature', remove: false });
  });
  const d = parseSpec(out);
  assert.deepEqual(d.krav.map(k => k.id), ['@BRU-TIL-ROL-001', '@BRU-TIL-ROL-003', '@BRU-TIL-ROL-009']);
  assert.ok(out.includes('— tildele rolle. ([krav-input/local/krav/07 Bru/11 Til/tildele_rolle.feature]'));
  assert.ok(out.includes('- **`se_roller.feature`** (`@BRU-TIL-ROL-003`) — Se roller. ([krav/07 Bru/11 Til/se_roller.feature](../../../../krav/07%20Bru/11%20Til/se_roller.feature))'));
  assert.ok(!out.includes('fjerne_rolle.feature'));
  // Underseksjonene står etter hovedlista
  assert.ok(out.indexOf('se_roller.feature') < out.indexOf('### Skal fjernes'));
});

test('applySpec: skisse endres med feltene som ikke vises, beholdt', () => {
  const out = edit(d => {
    d.skisser[0].kind = 'OK';
    d.skisser[0].note = '';
    d.skisser.push({ name: 'Rolleoversikt', url: 'https://www.figma.com/design/abc/B?node-id=40-2', kind: 'Uavklart', note: '', dekker: '', fields: [] });
  });
  const d = parseSpec(out);
  assert.deepEqual(d.skisser.map(k => [k.name, k.kind, k.url]), [
    ['Rolletildeling', 'OK', 'https://www.figma.com/design/abc/Brukeradmin?node-id=88-301'],
    ['Rolleoversikt', 'Uavklart', 'https://www.figma.com/design/abc/B?node-id=40-2'],
  ]);
  assert.ok(out.includes('- **Lagrede artefakter:** [screenshot.png]'));
  assert.ok(out.includes('- **Valideringsstatus:** `OK`'));
  assert.ok(out.includes('### Skisse: Rolleoversikt\n\n- **Type:** `figma`'));
});

test('applySpec: spørsmål, ingen skisse og rute', () => {
  const out = edit(d => {
    d.sporsmal = [];
    d.skisser = [];
    d.ingenSkisse = 'bare API';
    d.rute = ['fs-plattform', 'fs-admin'];
  });
  assert.match(out, /## Åpne spørsmål\n\nIngen åpne spørsmål\.\n/);
  assert.match(out, /## Skisser\n\nIngen skisse: bare API\n/);
  assert.match(out, /## Rute\n\nfs-plattform → fs-admin\n/);
  const d = parseSpec(out);
  assert.equal(d.ingenSkisse, 'bare API');
  assert.deepEqual(d.rute, ['fs-plattform', 'fs-admin']);
});

test('applySpec fjerner Rute når ruta er tom (sendt)', () => {
  const text = '# Spec: X\n\n## Krav\n\n- a\n\n## Rute\n\nfs-admin\n';
  const prev = parseSpec(text);
  assert.equal(applySpec(text, prev, { ...prev, rute: [] }, {}, 'tasks/a/b/spec'), '# Spec: X\n\n## Krav\n\n- a\n');
});

test('setSection legger en manglende seksjon på riktig plass', () => {
  const out = setSection('# Spec: X\n\n## Kilde\n\n- a\n\n## Krav\n\n- b\n', 'Omfang', ['Tekst']);
  assert.equal(out, '# Spec: X\n\n## Kilde\n\n- a\n\n## Omfang\n\nTekst\n\n## Krav\n\n- b\n');
});

test('setKrav i en tom spesifikasjon', () => {
  const text = newSpecText('Ny', 'tasks/opptak/ny', '2026-10-04');
  const out = setKrav(text, [{ file: 'a.feature', id: '@OPT-OVO-AAA-001', path: 'krav/02 Opptak/a.feature', remove: false }], { '@OPT-OVO-AAA-001': 'A' }, 'tasks/opptak/ny/spec');
  assert.deepEqual(parseSpec(out).krav.map(k => k.id), ['@OPT-OVO-AAA-001']);
  assert.match(out, /## Krav\n\n- \*\*`a\.feature`\*\*/);
});

test('relativeTo og slugify', () => {
  assert.equal(relativeTo('tasks/a/b/spec', 'krav/x/y.feature'), '../../../../krav/x/y.feature');
  assert.equal(slugify('Opprette og vedlikeholde opptak'), 'opprette-og-vedlikeholde-opptak');
  assert.equal(slugify('Søk på fødselsnummer'), 'sok-pa-fodselsnummer');
});
