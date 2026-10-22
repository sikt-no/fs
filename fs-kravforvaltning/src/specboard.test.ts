import assert from 'node:assert/strict';
import { test } from 'node:test';
import type { Snapshot } from '../shared/model.ts';
import { buildScopes, buildTasks, type RawTask, type TasksSnapshot } from '../shared/tasks.ts';
import { buildEntry } from '../server/parse.ts';
import { BOARD_REPOS, buildCards, buildTaskCards, dragSpec, kravSummary, leadSpec, nextStep, taskColOf, taskFlags, taskMissing, canDrop, colOf, columns, flags, gating, handoffPrompt, isVerified, missing, moveTo, parseVerify, phaseOf, pickable, prShort, specChanged, verifyOrder, verifyPrompt } from './specboard.ts';

const feature = (tag: string, id: string, body = '') => `# language: no
${id} @must @${tag}
Egenskap: Tittel ${id}
  Beskrivelse.

  Regel: Hovedflyt
    Scenario: Første
      Gitt noe
      Så skjer noe

    @draft @openquestion
    Scenario: Uavklart
      # ÅPNE SPØRSMÅL:
      # - Hva?
      Gitt noe

    @openquestion
    Scenario: Med åpent spørsmål
      # ÅPNE SPØRSMÅL:
      # - Hvilke grenser?
      Gitt noe
${body}`;

const changed = `# language: no
@BRU-TIL-ROL-002 @must @implemented
Egenskap: Levert krav som endres
  Beskrivelse.

  Regel: Hovedflyt
    Scenario: Levert
      Gitt noe

    @deprecated
    Scenario: Gammel visning (avvikles)
      Gitt noe

    @in-progress
    Scenario: Ny visning
      Gitt noe
`;

const entries: Snapshot = Object.fromEntries(
  [
    buildEntry('krav/07 Bru/11 Til/01 Rol/tildele_rolle.feature', feature('in-progress', '@BRU-TIL-ROL-001'), 0),
    buildEntry('krav/07 Bru/11 Til/01 Rol/endre_rolle.feature', changed, 0),
    buildEntry('krav/07 Bru/11 Til/01 Rol/planlagt.feature', feature('planned', '@BRU-TIL-ROL-003'), 0),
    buildEntry('krav/07 Bru/11 Til/01 Rol/levert.feature', feature('implemented', '@BRU-TIL-ROL-004'), 0),
  ].map(e => [e.path, e]),
);

const spec = (o: { krav?: string[]; skisse?: boolean; omfang?: string; q?: string } = {}) => `# Spec: Roller

## Omfang

${o.omfang ?? 'Tildele roller.'}

## Krav

${(o.krav ?? ['tildele_rolle.feature:@BRU-TIL-ROL-001']).map(k => {
  const [f, id] = k.split(':');
  return `- **\`${f}\`** (\`${id}\`) — x.`;
}).join('\n\n')}

## Skisser

${o.skisse === false ? '' : '### Skisse: Rolletildeling\n\n- **Referanse:** <https://www.figma.com/design/abc?node-id=1-2>\n- **Valideringsstatus:** `OK`\n'}
## Åpne spørsmål

${o.q ?? 'Ingen åpne spørsmål.'}
`;

const raw = (sources: Record<string, string>, files = Object.keys(sources)): RawTask => ({ dom: 'brukeradministrasjon-og-tilgangsstyring', slug: 'roller', files, sources, mtimes: {} });
const snap = (...tasks: RawTask[]): TasksSnapshot => ({ domains: {}, tasks });
const one = (sources: Record<string, string>) => buildCards(snap(raw(sources)), entries)[0];

test('gating: alt utenom @draft, også @openquestion alene; i et levert krav bare @in-progress-delene, og @deprecated som skal fjernes', () => {
  assert.deepEqual(gating(entries['krav/07 Bru/11 Til/01 Rol/tildele_rolle.feature']), [
    { t: 'Første', remove: false },
    { t: 'Med åpent spørsmål', remove: false },
  ]);
  assert.deepEqual(gating(entries['krav/07 Bru/11 Til/01 Rol/endre_rolle.feature']), [
    { t: 'Gammel visning (avvikles)', remove: true },
    { t: 'Ny visning', remove: false },
  ]);
});

test('phaseOf og pickable', () => {
  const e = (n: string) => entries[`krav/07 Bru/11 Til/01 Rol/${n}.feature`];
  assert.equal(phaseOf(e('tildele_rolle'), false), 'ready');
  assert.equal(phaseOf(e('endre_rolle'), false), 'ready');
  assert.equal(phaseOf(e('planlagt'), false), 'planned');
  assert.equal(phaseOf(e('levert'), false), 'done');
  assert.equal(phaseOf(undefined, true), 'done');
  assert.equal(phaseOf(undefined, false), 'missing');
  assert.deepEqual(pickable(e('planlagt')), { ok: true, why: '' });
  assert.deepEqual(pickable(e('endre_rolle')), { ok: true, why: 'endres' });
  assert.deepEqual(pickable(e('levert')), { ok: false, why: 'levert' });
  assert.deepEqual(pickable(e('tildele_rolle')), { ok: false, why: '@in-progress' });
});

test('buildCards slår opp kravene på Feature-ID og leser utforing.md', () => {
  const c = one({
    'spec/spec-roller.md': spec(),
    'utforing.md': '## spec/spec-roller.md\n\n- **Rute**: fs-plattform → fs-admin\n\n### fs-plattform\n\n- **Status**: levert\n- **PR**:\n  - https://github.com/sikt-no/fs-plattform/pull/9\n',
  });
  assert.equal(c.key, 'brukeradministrasjon-og-tilgangsstyring/roller/spec-roller.md');
  assert.equal(c.path, 'tasks/brukeradministrasjon-og-tilgangsstyring/roller/spec/spec-roller.md');
  assert.equal(c.feats[0].path, 'krav/07 Bru/11 Til/01 Rol/tildele_rolle.feature');
  assert.equal(c.feats[0].title, 'Tittel @BRU-TIL-ROL-001');
  assert.deepEqual(c.run.route, ['fs-plattform', 'fs-admin']);
  assert.equal(colOf(c), 'repo:fs-admin');
});

test('colOf: Utkast med det som mangler, Klart til utvikling, Til verifisering og Verifisert', () => {
  const draft = one({ 'spec/spec-roller.md': spec({ krav: ['planlagt.feature:@BRU-TIL-ROL-003'], skisse: false, omfang: '', q: '- [ ] Hva?' }) });
  assert.equal(colOf(draft), 'spesifiseres');
  assert.deepEqual(missing(draft), ['Mangler omfang', 'Ingen skisse', '1 åpne spørsmål', 'planlagt.feature er ikke @in-progress']);
  const ready = one({ 'spec/spec-roller.md': spec() });
  assert.equal(colOf(ready), 'klar');
  const allDone = one({ 'spec/spec-roller.md': spec(), 'utforing.md': '## spec/spec-roller.md\n\n- **Rute**: fs-admin\n\n### fs-admin\n\n- **Status**: levert\n' });
  assert.equal(colOf(allDone), 'verifisering');
  const done = one({ 'spec/spec-roller.md': spec({ krav: ['levert.feature:@BRU-TIL-ROL-004'] }) });
  assert.equal(colOf(done), 'verifisert');
  // Krav som skal fjernes og er slettet, er ferdige
  const gone = one({ 'spec/spec-roller.md': spec({ krav: ['borte.feature:@BRU-TIL-ROL-099'] }).replace('## Krav\n', '## Krav\n\n### Skal fjernes (`@deprecated`)\n') });
  assert.equal(colOf(gone), 'verifisert');
});

test('verifiseringsrapporten gir resultat per scenario, og alt funnet er Verifisert', () => {
  const report = `# Verifisering\n\n- **Dato:** 2026-10-03\n- **Spec:** spec/spec-roller.md\n\n## Scenarioer\n\n| Feature-ID | Scenario | Resultat | Bevis |\n|---|---|---|---|\n| \`@BRU-TIL-ROL-001\` | Første | funnet | fs-plattform/src/A.kt:12 |\n| \`@BRU-TIL-ROL-001\` | Med åpent spørsmål | funnet | fs-plattform/src/A.kt:20 |\n`;
  assert.deepEqual(parseVerify(report, 'spec/verify-2026-10-03.md'), { file: 'spec/verify-2026-10-03.md', date: '2026-10-03', time: null, spec: 'spec-roller.md', rows: [
    { id: '@BRU-TIL-ROL-001', sc: 'Første', r: 'funnet', bevis: 'fs-plattform/src/A.kt:12' },
    { id: '@BRU-TIL-ROL-001', sc: 'Med åpent spørsmål', r: 'funnet', bevis: 'fs-plattform/src/A.kt:20' },
  ] });
  const c = one({ 'spec/spec-roller.md': spec(), 'spec/verify-2026-10-03.md': report });
  assert.equal(c.feats[0].sc[0].r, 'funnet');
  assert.equal(c.verified, '2026-10-03');
  assert.ok(isVerified(c));
});

test('verifiseringsrapporten har klokkeslett fra Dato eller filnavnet, og den nyeste rapporten gjelder', () => {
  const rapport = (dato: string, r: string) => `- **Dato:** ${dato}\n- **Spec:** spec/spec-roller.md\n\n## Scenarioer\n\n| Feature-ID | Scenario | Resultat | Bevis |\n|---|---|---|---|\n| \`@BRU-TIL-ROL-001\` | Første | ${r} | x |\n`;
  assert.equal(parseVerify(rapport('2026-10-09 14:32', 'funnet'), 'spec/verify-2026-10-09-1432.md').time, '14:32');
  assert.equal(parseVerify('# V\n', 'spec/verify-2026-10-09-0905.md').time, '09:05');
  assert.equal(parseVerify('# V\n', 'spec/verify-2026-10-09-0905.md').date, '2026-10-09');
  // `-2` er ikke et klokkeslett
  assert.equal(parseVerify('# V\n', 'spec/verify-2026-10-09-2.md').time, null);
  const filer = ['spec/verify-2026-10-09-1432.md', 'spec/verify-2026-10-09-2.md', 'spec/verify-2026-10-08.md', 'spec/verify-2026-10-09.md', 'spec/verify-2026-10-09-0905.md', 'spec/verify-2026-10-09-1432-2.md'];
  const sortert = filer.map(f => parseVerify('# V\n', f)).sort(verifyOrder).map(r => r.file);
  assert.deepEqual(sortert, ['spec/verify-2026-10-08.md', 'spec/verify-2026-10-09.md', 'spec/verify-2026-10-09-2.md', 'spec/verify-2026-10-09-0905.md', 'spec/verify-2026-10-09-1432.md', 'spec/verify-2026-10-09-1432-2.md']);
  // Den nyeste rapporten gir resultatet, også når filnavnet alene ville sortert den først
  const c = one({ 'spec/spec-roller.md': spec(), 'spec/verify-2026-10-09-0905.md': rapport('2026-10-09 09:05', 'ikke funnet'), 'spec/verify-2026-10-09-1432.md': rapport('2026-10-09 14:32', 'funnet'), 'spec/verify-2026-10-09.md': rapport('2026-10-09', 'usikker') });
  assert.equal(c.feats[0].sc[0].r, 'funnet');
  assert.equal(c.verified, '2026-10-09 14:32');
});

test('canDrop og moveTo: sende, flytte mellom repoer og tilbake', () => {
  const ready = one({ 'spec/spec-roller.md': spec() + '\n## Rute\n\nfs-plattform → fs-admin\n' });
  assert.equal(canDrop(ready, 'verifisert'), false);
  assert.equal(canDrop(ready, 'spesifiseres'), false);
  assert.equal(canDrop(ready, 'scope'), false);
  assert.equal(canDrop(ready, 'kravarbeid'), false);
  assert.equal(canDrop(ready, 'repo:fs-admin'), true);
  const m = moveTo(ready, 'repo:fs-admin', 'fs-admin');
  assert.deepEqual(m.run.route, ['fs-plattform', 'fs-admin']);
  assert.deepEqual(m.run.steps.map(s => [s.repo, s.status]), [['fs-plattform', 'levert'], ['fs-admin', 'venter']]);
  assert.deepEqual(m.rute, []);
  const back = moveTo({ ...ready, run: m.run }, 'klar', 'Klart til utvikling');
  assert.deepEqual(back.run.route, []);
  assert.deepEqual(back.rute, ['fs-plattform', 'fs-admin']);
  const all = moveTo({ ...ready, run: m.run }, 'verifisering', 'Til verifisering');
  assert.ok(all.run.steps.every(s => s.status === 'levert'));
  // Et kort som mangler noe, kan ikke flyttes
  const draft = one({ 'spec/spec-roller.md': spec({ omfang: '' }) });
  assert.equal(canDrop(draft, 'klar'), false);
});

test('flagg og «spec endret»', () => {
  const c = one({
    'spec/spec-roller.md': spec({ q: '- [ ] Hva?' }),
    'utforing.md': '## spec/spec-roller.md\n\n- **Rute**: fs-plattform\n- **Logg**:\n  - 2026-09-01 — @mats — sendte til fs-plattform\n\n### fs-plattform\n\n- **Status**: pågår\n- **Blokkert**: Venter på DBH\n',
  });
  assert.deepEqual(flags(c, true).map(f => f.t), ['blokkert', '1 åpne spørsmål', 'ikke merget']);
  assert.equal(specChanged({ ...c, mtime: new Date('2026-09-10T12:00:00').getTime() }), true);
  assert.equal(specChanged({ ...c, mtime: new Date('2026-09-01T12:00:00').getTime() }), false);
});

test('verifyPrompt: linja om skjermbilder når valget er gjort, ellers spør fs-verify', () => {
  const c = one({ 'spec/spec-roller.md': spec() });
  const uten = verifyPrompt(c);
  assert.match(uten, /^Verifiser spesifikasjonen tasks\/brukeradministrasjon-og-tilgangsstyring\/roller\/spec\/spec-roller\.md/);
  assert.ok(!/skjermbilder/i.test(uten));
  assert.equal(verifyPrompt(c, true).split('\n').at(-1), 'Ta skjermbilder av scenarioene som har en skjerm.');
  assert.equal(verifyPrompt(c, false).split('\n').at(-1), 'Ingen skjermbilder.');
});

test('handoffPrompt har spesifikasjonen, kravene, skissene og overleveringen fra forrige steg', () => {
  const c = one({
    'spec/spec-roller.md': spec(),
    'utforing.md': '## spec/spec-roller.md\n\n- **Rute**: fs-plattform → fs-admin\n\n### fs-plattform\n\n- **Status**: levert\n- **Overlevering**:\n  - Mutation tildelRolle\n',
  });
  const p = handoffPrompt(c, 'fs-admin');
  assert.match(p, /^Du jobber i fs-admin\./);
  assert.ok(p.includes('Spesifikasjon: tasks/brukeradministrasjon-og-tilgangsstyring/roller/spec/spec-roller.md'));
  assert.ok(p.includes('- krav/07 Bru/11 Til/01 Rol/tildele_rolle.feature (@BRU-TIL-ROL-001)'));
  assert.ok(p.includes('- Rolletildeling: https://www.figma.com/design/abc?node-id=1-2'));
  assert.ok(p.includes('Steg 2 av 2: fs-admin.'));
  assert.ok(p.includes('Overlevering fra fs-plattform:\n- Mutation tildelRolle'));
});

test('columns: standardrepoene og repoene i rutene, med lagret rekkefølge, navn og fjerning', () => {
  const keys = (cs: { key: string }[]) => cs.map(c => c.key);
  assert.deepEqual(keys(columns([], BOARD_REPOS, [])), ['scope', 'kravarbeid', 'spesifiseres', 'klar', 'repo:fs-plattform', 'repo:fs-admin', 'repo:min-kompetanse', 'verifisering', 'verifisert']);
  assert.deepEqual(keys(columns([], ['fs-plattform', 'fs-admin'], [['fs-integrasjon']])), ['scope', 'kravarbeid', 'spesifiseres', 'klar', 'repo:fs-plattform', 'repo:fs-admin', 'repo:fs-integrasjon', 'verifisering', 'verifisert']);
  const saved = [
    { key: 'repo:fs-admin' as const, name: 'Admin' },
    { key: 'repo:fs-plattform' as const, name: 'fs-plattform', removed: true },
    { key: 'klar' as const, name: 'Klar', hidden: true },
  ];
  const cs = columns(saved, ['fs-plattform', 'fs-admin'], []);
  assert.deepEqual(keys(cs), ['scope', 'kravarbeid', 'spesifiseres', 'klar', 'repo:fs-admin', 'verifisering', 'verifisert']);
  assert.equal(cs[3].hidden, true);
  assert.equal(cs[4].name, 'Admin');
  // Et fjernet repo som står i en rute, kommer tilbake
  assert.deepEqual(keys(columns(saved, ['fs-plattform', 'fs-admin'], [['fs-plattform']])), ['scope', 'kravarbeid', 'spesifiseres', 'klar', 'repo:fs-admin', 'repo:fs-plattform', 'verifisering', 'verifisert']);
});

test('prShort', () => {
  assert.equal(prShort('https://github.com/sikt-no/fs-plattform/pull/123'), 'fs-plattform#123');
  assert.equal(prShort('noe annet'), 'noe annet');
});

// —— Oppgavekortene ——

const DOM = 'brukeradministrasjon-og-tilgangsstyring';
const oppg = (slug: string, scope?: string) => `# Oppgave ${slug}\n\n- **Slug**: ${slug}\n- **Domene**: ${DOM}\n${scope ? `- **Scope**: [scope-${scope}](../scope-${scope}.md)\n` : ''}`;
const skjelett = (id: string, tag = '@draft') => `# language: no
${id} @must ${tag} @scope-roller
Egenskap: Skjelett ${id}
  Som administrator
  ønsker jeg noe
  slik at noe

  Regel: Kommer
`;
const scopeFile = (rows: string) => `# Scope: Roller

- **Slug**: roller

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
${rows}
`;

/** Tavla for én oppgave med scope: kravene i scope-raden, og spesifikasjonene i oppgaven */
function board(krav: Record<string, string>, row: string, specs: Record<string, string> = {}) {
  const ents: Snapshot = { ...entries };
  for (const [p, src] of Object.entries(krav)) ents[p] = buildEntry(p, src, 0);
  const t: RawTask = { dom: DOM, slug: 'roller', files: ['oppgave.md', ...Object.keys(specs)], sources: { 'oppgave.md': oppg('roller', 'roller'), ...specs }, mtimes: {} };
  const sn: TasksSnapshot = { domains: { [DOM]: null }, tasks: [t], scopes: { [`tasks/${DOM}/scope-roller.md`]: scopeFile(row) } };
  const scopes = buildScopes(sn);
  return buildTaskCards(buildTasks(sn, scopes), scopes, buildCards(sn, ents), ents)[0];
}

test('oppgavekort: I scope, Kravarbeid og Spesifiseres utledes fra kravene i scope-raden', () => {
  const a = 'krav/07 Bru/11 Til/02 Ny/ny_a.feature';
  const b = 'krav/07 Bru/11 Til/02 Ny/ny_b.feature';
  const row = '| [roller](roller/) | `@BRU-TIL-NYA-001` `@BRU-TIL-NYB-002` | Must | – | – | |';
  const sk = board({ [a]: skjelett('@BRU-TIL-NYA-001'), [b]: skjelett('@BRU-TIL-NYB-002') }, row);
  assert.equal(sk.krav.length, 2);
  assert.equal(sk.kravFrom, 'scope');
  assert.equal(taskColOf(sk), 'scope');
  assert.match(taskMissing(sk)[0], /skjeletter/);
  const kravarbeid = board({ [a]: skjelett('@BRU-TIL-NYA-001'), [b]: feature('draft', '@BRU-TIL-NYB-002') }, row);
  assert.equal(taskColOf(kravarbeid), 'kravarbeid');
  const klare = board({ [a]: feature('planned', '@BRU-TIL-NYA-001'), [b]: feature('planned', '@BRU-TIL-NYB-002') }, row);
  assert.equal(taskColOf(klare), 'spesifiseres');
  assert.deepEqual(taskMissing(klare), ['Mangler spesifikasjon · fs-specify']);
  // Krav som ikke finnes ennå, regnes som skjeletter
  assert.equal(taskColOf(board({}, '| [roller](roller/) | `@BRU-TIL-NYC-003` | Must | – | – | |')), 'scope');
  assert.equal(taskColOf(board({}, '| [annen](annen/) | `@BRU-TIL-NYC-003` | Must | – | – | |')), 'scope', 'ingen krav');
});

test('oppgavekort: tidligste aktive spesifikasjon, flagg for krav uten spesifikasjon, og verifisert', () => {
  const row = '| [roller](roller/) | `@BRU-TIL-ROL-001` `@BRU-TIL-ROL-003` | Must | – | – | |';
  const t = board({}, row, { 'spec/spec-roller.md': spec() });
  assert.equal(t.specs.length, 1);
  assert.equal(taskColOf(t), 'klar');
  assert.deepEqual(t.unspecced.map(k => k.id), ['@BRU-TIL-ROL-003']);
  assert.ok(taskFlags(t, false).some(f => f.t === '1 krav uten spesifikasjon'));
  assert.equal(dragSpec(t)?.file, 'spec-roller.md');
  // To spesifikasjoner: oppgaven står i den tidligste, og kortet kan ikke dras
  const to = board({}, row, { 'spec/spec-roller.md': spec(), 'spec/spec-utkast.md': spec({ skisse: false, krav: ['planlagt.feature:@BRU-TIL-ROL-003'] }) });
  assert.equal(taskColOf(to), 'spesifiseres');
  assert.equal(dragSpec(to), null);
  // @wont teller ikke, og levert krav uten spesifikasjon trekker ikke tilbake
  const levert = board({}, '| [roller](roller/) | `@BRU-TIL-ROL-004` | Must | – | – | |');
  assert.equal(taskColOf(levert), 'verifisert');
  const wont = board({}, '| [roller](roller/) | `@BRU-TIL-ROL-003` | Won\'t | – | – | |');
  assert.equal(wont.unspecced.length, 0);
});

test('oppgavekort uten scope: kravene fra spesifikasjonene, og uten noe står oppgaven i I scope', () => {
  const sn: TasksSnapshot = { domains: { [DOM]: null }, tasks: [{ dom: DOM, slug: 'roller', files: ['oppgave.md', 'spec/spec-roller.md'], sources: { 'oppgave.md': oppg('roller'), 'spec/spec-roller.md': spec() }, mtimes: {} }, { dom: DOM, slug: 'tom', files: ['oppgave.md'], sources: { 'oppgave.md': oppg('tom') } }] };
  const cards = buildTaskCards(buildTasks(sn), [], buildCards(sn, entries), entries);
  const roller = cards.find(c => c.slug === 'roller')!;
  assert.equal(roller.kravFrom, 'spec');
  assert.equal(taskColOf(roller), 'klar');
  assert.equal(taskColOf(cards.find(c => c.slug === 'tom')!), 'scope');
});

test('nextStep: fra kravene når oppgaven ikke har spesifikasjon', () => {
  const a = 'krav/07 Bru/11 Til/02 Ny/ny_a.feature';
  const b = 'krav/07 Bru/11 Til/02 Ny/ny_b.feature';
  const row = '| [roller](roller/) | `@BRU-TIL-NYA-001` `@BRU-TIL-NYB-002` | Must | – | – | |';
  const sk = board({ [a]: skjelett('@BRU-TIL-NYA-001'), [b]: skjelett('@BRU-TIL-NYB-002') }, row);
  const n1 = nextStep(sk, taskColOf(sk));
  assert.equal(n1.kind, 'skjelett');
  assert.equal(n1.ctx, 'scope-roller');
  assert.match(n1.lines[0].t, /^2 krav er skjeletter/);
  const ka = nextStep(board({ [a]: skjelett('@BRU-TIL-NYA-001'), [b]: feature('draft', '@BRU-TIL-NYB-002') }, row), 'kravarbeid');
  assert.equal(ka.kind, 'kravarbeid');
  assert.deepEqual(ka.lines.map(l => l.t), ['1 krav er @draft og må valideres', '1 krav er fortsatt skjelett']);
  const ms = nextStep(board({ [a]: feature('planned', '@BRU-TIL-NYA-001'), [b]: feature('planned', '@BRU-TIL-NYB-002') }, row), 'spesifiseres');
  assert.equal(ms.kind, 'mangler-spec');
  assert.deepEqual(ms.lines.map(l => [l.t, l.sub, l.mark]), [['Mangler spesifikasjon', undefined, 'err'], ['2 krav er klare til å hentes inn', 'ny_a.feature, ny_b.feature', 'planned']]);
  const tom = nextStep(board({}, '| [annen](annen/) | `@BRU-TIL-NYC-003` | Must | – | – | |'), 'scope');
  assert.equal(tom.kind, 'scope-tom');
  assert.equal(tom.spec, null);
  const levert = board({}, '| [roller](roller/) | `@BRU-TIL-ROL-004` | Must | – | – | |');
  assert.deepEqual([nextStep(levert, taskColOf(levert)).kind, nextStep(levert, taskColOf(levert)).tone], ['verifisert', 'ok']);
});

test('nextStep: den ledende spesifikasjonen, de andre i oppgaven og krav uten spesifikasjon', () => {
  const row = '| [roller](roller/) | `@BRU-TIL-ROL-001` `@BRU-TIL-ROL-003` | Must | – | – | |';
  const klar = board({}, row, { 'spec/spec-roller.md': spec() });
  const n = nextStep(klar, taskColOf(klar));
  assert.equal(n.kind, 'klar');
  assert.equal(n.spec?.file, 'spec-roller.md');
  assert.deepEqual(n.lines.at(-1), { t: '1 krav uten spesifikasjon', sub: 'planlagt.feature', mark: 'warn' });
  const to = board({}, row, { 'spec/spec-roller.md': spec(), 'spec/spec-utkast.md': spec({ skisse: false, krav: ['planlagt.feature:@BRU-TIL-ROL-003'] }) });
  const m = nextStep(to, taskColOf(to));
  assert.equal(m.kind, 'spec-mangler');
  assert.equal(m.spec?.file, 'spec-utkast.md');
  assert.equal(leadSpec(to, 'spesifiseres')?.file, 'spec-utkast.md');
  assert.ok(m.lines.some(l => l.t === 'Ingen skisse' && l.mark === 'err'));
  assert.deepEqual(m.lines.find(l => l.mark === 'col'), { t: 'Også i oppgaven: Roller', mark: 'col', col: 'klar' });
});

test('nextStep: steget i repoet, med overlevering, blokkert og sendt tilbake', () => {
  const row = '| [roller](roller/) | `@BRU-TIL-ROL-001` | Must | – | – | |';
  const utf = (admin: string) => `## spec/spec-roller.md

- **Rute**: fs-plattform → fs-admin

### fs-plattform

- **Status**: levert
- **Tatt av**: agent:subgraph
- **PR**:
  - https://github.com/sikt-no/fs-plattform/pull/9
- **Overlevering**:
  - Ny mutation tildelRolle
  - Felt Rolle.enhet

### fs-admin

${admin}
`;
  const t = board({}, row, { 'spec/spec-roller.md': spec(), 'utforing.md': utf('- **Status**: pågår\n- **Tatt av**: agent:frontend\n- **Blokkert**: Venter på API\n- **Tilbake**: 2026-10-03') });
  const n = nextStep(t, taskColOf(t));
  assert.equal(n.kind, 'repo');
  assert.equal(n.repo, 'fs-admin');
  assert.equal(n.ctx, 'Roller · steg 2/2');
  assert.equal(n.tone, 'err');
  assert.deepEqual(n.lines.map(l => [l.t, l.sub, l.mark]), [
    ['fs-admin · pågår', 'agent:frontend', 'pågår'],
    ['Overlevering fra fs-plattform', 'Ny mutation tildelRolle …', 'dot'],
    ['Blokkert: Venter på API', undefined, 'err'],
    ['Sendt tilbake av fs-verify 2026-10-03', undefined, 'err'],
  ]);
  const ver = board({}, row, { 'spec/spec-roller.md': spec(), 'utforing.md': utf('- **Status**: levert\n- **PR**:\n  - https://github.com/sikt-no/fs-admin/pull/4') });
  const v = nextStep(ver, taskColOf(ver));
  assert.equal(v.kind, 'verifisering');
  assert.equal(v.lines[0].sub, 'fs-plattform#9 · fs-admin#4');
});

test('kravSummary: opptelling per status, med skjeletter for seg', () => {
  const a = 'krav/07 Bru/11 Til/02 Ny/ny_a.feature';
  const t = board({ [a]: skjelett('@BRU-TIL-NYA-001') }, '| [roller](roller/) | `@BRU-TIL-NYA-001` `@BRU-TIL-ROL-001` `@BRU-TIL-ROL-003` `@BRU-TIL-NYZ-009` | Must | – | – | |');
  assert.deepEqual(kravSummary(t), [
    { k: 'in-progress', n: 1 },
    { k: 'planned', n: 1 },
    { k: 'skeleton', n: 1 },
  ]);
  assert.deepEqual(t.kravMissing, ['@BRU-TIL-NYZ-009'], 'krav som ikke finnes, står i kravMissing');
});
