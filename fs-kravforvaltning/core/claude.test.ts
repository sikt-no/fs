import assert from 'node:assert/strict';
import { chmodSync, mkdtempSync, realpathSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { after, test } from 'node:test';
import type { ClaudeEvent } from '../shared/api.ts';
import { mkdirSync } from 'node:fs';
import { ClaudeRunner, codeDirs, contextPrompt, dirArgs, mentionPaths, findClaude, parseStreamLine, projectSkills, skillArgs, skillHash, skillMeta, toolSummary } from './claude.ts';

const tmp = mkdtempSync(join(tmpdir(), 'krav-claude-'));
after(() => rmSync(tmp, { recursive: true, force: true }));

test('parseStreamLine plukker ut init, tekst, verktøy og resultat', () => {
  assert.deepEqual(parseStreamLine('{"type":"system","subtype":"init","session_id":"s1","model":"m","skills":["fs-krav","x:y",3]}'), [
    { kind: 'init', sessionId: 's1', model: 'm', skills: ['fs-krav', 'x:y'] },
  ]);
  assert.deepEqual(parseStreamLine('{"type":"system","subtype":"hook_started"}'), []);
  assert.deepEqual(
    parseStreamLine(JSON.stringify({ type: 'assistant', message: { content: [{ type: 'text', text: 'Hei' }, { type: 'tool_use', id: 't1', name: 'Read', input: { file_path: '/x/repo/krav/a.feature' } }] } })),
    [
      { kind: 'text', text: 'Hei' },
      { kind: 'tool', id: 't1', name: 'Read', summary: 'krav/a.feature' },
    ],
  );
  // Meldinger fra underagenter vises ikke
  assert.deepEqual(parseStreamLine(JSON.stringify({ type: 'assistant', parent_tool_use_id: 'p', message: { content: [{ type: 'text', text: 'x' }] } })), []);
  assert.deepEqual(parseStreamLine(JSON.stringify({ type: 'user', message: { content: [{ type: 'tool_result', tool_use_id: 't1', is_error: true }] } })), [
    { kind: 'toolResult', id: 't1', isError: true },
  ]);
  assert.deepEqual(parseStreamLine('{"type":"result","subtype":"success","is_error":false,"session_id":"s1","duration_ms":10,"num_turns":2,"result":"ok"}'), [
    { kind: 'done', ok: true, sessionId: 's1', durationMs: 10, turns: 2, error: null, contextWindow: null },
  ]);
  const withUsage = { type: 'result', subtype: 'success', is_error: false, modelUsage: { 'claude-opus[1m]': { contextWindow: 1000000 }, 'claude-haiku': { contextWindow: 200000 } } };
  assert.equal((parseStreamLine(JSON.stringify(withUsage))[0] as { contextWindow: number }).contextWindow, 1000000);
  // Kontekstbruk fra svaret: input + cache-skriving + cache-lesing + output
  assert.deepEqual(
    parseStreamLine(JSON.stringify({ type: 'assistant', message: { content: [], usage: { input_tokens: 2, cache_creation_input_tokens: 100, cache_read_input_tokens: 1000, output_tokens: 8 } } })),
    [{ kind: 'usage', tokens: 1110 }],
  );
  assert.equal((parseStreamLine('{"type":"result","subtype":"error_max_turns","is_error":true}')[0] as { error: string }).error, 'error_max_turns');
  assert.deepEqual(parseStreamLine('ikke json'), []);
});

test('toolSummary viser fil, mønster eller skill', () => {
  assert.equal(toolSummary('Edit', { file_path: '/a/b/krav/01 X/y.feature' }), 'krav/01 X/y.feature');
  assert.equal(toolSummary('Grep', { pattern: '@draft', path: '/r/krav/02' }), '@draft i krav/02');
  assert.equal(toolSummary('Skill', { skill: 'fs-krav' }), 'fs-krav');
  assert.equal(toolSummary('Annet', {}), 'Annet');
});

test('contextPrompt tar med fila brukeren ser på', () => {
  assert.match(contextPrompt('krav/a.feature'), /ser nå på fila krav\/a\.feature/);
  assert.doesNotMatch(contextPrompt(null), /ser nå på/);
});

test('contextPrompt ber Claude foreslå PR med en krav-pr-blokk i stedet for å lage den', () => {
  assert.match(contextPrompt(null), /kan ikke committe, pushe eller lage PR selv/);
  assert.match(contextPrompt(null), /Ber brukeren om en PR.*kodeblokk med språket krav-pr/);
  assert.match(contextPrompt(null), /Si ikke at du ikke kan lage PR/);
});

test('contextPrompt tar med filene og mappene lagt ved med @, og bare stier under krav/', () => {
  assert.match(contextPrompt(null, null, [], [], ['krav/02 Opptak', 'krav/a.feature']), /lagt ved .*: krav\/02 Opptak, krav\/a\.feature/);
  assert.doesNotMatch(contextPrompt(null), /lagt ved/);
  assert.deepEqual(mentionPaths(['krav/a', 'krav/a', '/etc/passwd', 'krav/../x', 'krav/b\nc', 3]), ['krav/a']);
  assert.deepEqual(mentionPaths('krav/a'), []);
});

test('contextPrompt: uten valgt skill listes de tilgjengelige, og fs-verify får beskjed om kodeklonene', () => {
  assert.match(contextPrompt(null, null, ['fs-krav', 'fs-verify']), /ikke valgt noen skill\. Du kan bruke disse .*: fs-krav, fs-verify/);
  assert.match(contextPrompt(null, null, []), /ingen skills er tilgjengelige/);
  const verify = contextPrompt(null, 'fs-verify', [], ['/kode/fs-admin']);
  assert.match(verify, /lese kodeklonene \/kode\/fs-admin, men ikke endre dem/);
  assert.match(verify, /kan ikke slette filer/);
  assert.doesNotMatch(verify, /Ingen kodekloner/);
  assert.match(contextPrompt(null, 'fs-verify'), /Ingen kodekloner er tilgjengelige/);
  assert.doesNotMatch(contextPrompt(null, 'fs-krav'), /slette filer/);
  const valgt = contextPrompt(null, 'fs-verify', ['fs-krav', 'fs-verify']);
  assert.match(valgt, /valgt skillen fs-verify .*lastet\. Trenger oppgaven en annen skill, .*Skill-verktøyet: fs-krav\./);
  assert.doesNotMatch(contextPrompt(null, 'fs-krav'), /Trenger oppgaven en annen skill/);
  assert.match(contextPrompt(null, 'fs-krav', ['fs-krav', 'fs-verify']), /kan ikke slette filer/, 'fs-verify kan brukes, så beskjeden kommer med');
});

test('codeDirs: overstyring, så env, så mappa ved siden av repoet', () => {
  const repo = join(tmp, 'kodedir', 'fs');
  mkdirSync(repo, { recursive: true });
  mkdirSync(join(tmp, 'kodedir', 'fs-admin'));
  const annen = join(tmp, 'kodedir', 'annen');
  mkdirSync(annen);
  assert.deepEqual(codeDirs(repo, {}), [
    { name: 'fs-admin', path: join(tmp, 'kodedir', 'fs-admin'), exists: true },
    { name: 'fs-plattform', path: join(tmp, 'kodedir', 'fs-plattform'), exists: false },
  ]);
  assert.equal(codeDirs(repo, { KRAV_FS_PLATTFORM: annen })[1].path, annen);
  assert.deepEqual(codeDirs(repo, {}, {}, false), [
    { name: 'fs-admin', path: '', exists: false },
    { name: 'fs-plattform', path: '', exists: false },
  ], 'desktop-appen: ingen standardsti ved siden av repoet');
  assert.equal(codeDirs(repo, { KRAV_FS_PLATTFORM: annen }, {}, false)[1].exists, true, 'env gjelder fortsatt');
  assert.deepEqual(codeDirs(repo, { KRAV_FS_PLATTFORM: annen }, { 'fs-plattform': ' relativ ', 'fs-admin': 7 }), [
    { name: 'fs-admin', path: join(tmp, 'kodedir', 'fs-admin'), exists: true },
    { name: 'fs-plattform', path: 'relativ', exists: false },
  ], 'en relativ sti godtas ikke, og ugyldige verdier ignoreres');
});

test('dirArgs: --add-dir og Edit-avvisning for absolutte mapper som finnes', () => {
  const d = join(tmp, 'kodedir2');
  mkdirSync(d, { recursive: true });
  writeFileSync(join(tmp, 'enfil'), '');
  const posix = d.replace(/\\/g, '/').replace(/^([A-Za-z]):/, (_, x: string) => '/' + x.toLowerCase());
  assert.deepEqual(dirArgs([d, d + '/', 'relativ', join(tmp, 'finnes-ikke'), join(tmp, 'enfil'), 3]), {
    paths: [d],
    add: ['--add-dir', d],
    deny: [`Edit(/${posix}/**)`],
  });
  assert.deepEqual(dirArgs(undefined), { paths: [], add: [], deny: [] });
});

// En falsk claude: skriver argumentene og stdin tilbake som tekst, og avslutter som stream-json gjør
const fake = join(tmp, 'claude');
writeFileSync(
  fake,
  `#!/usr/bin/env node
if (process.argv[2] === '--version') { console.log('9.9.9 (Claude Code)'); process.exit(0); }
let input = '';
process.stdin.on('data', d => (input += d));
process.stdin.on('end', () => {
  const args = process.argv.slice(2);
  const out = o => process.stdout.write(JSON.stringify(o) + '\\n');
  out({ type: 'system', subtype: 'init', session_id: 'sess', model: 'm', skills: ['fs-krav', 'plugin:annen'] });
  if (input === 'heng') return setTimeout(() => {}, 60000);
  if (input === 'krasj') { process.stderr.write('noe gikk galt\\n'); process.exit(3); }
  out({ type: 'assistant', message: { content: [{ type: 'text', text: JSON.stringify({ input, args, cwd: process.cwd() }) }] } });
  out({ type: 'result', subtype: 'success', is_error: false, session_id: 'sess', duration_ms: 1, num_turns: 1 });
});
`,
);
chmodSync(fake, 0o755);
const env = { ...process.env, KRAV_CLAUDE_PATH: fake };
mkdirSync(join(tmp, '.claude', 'skills', 'fs-krav'), { recursive: true });
writeFileSync(join(tmp, '.claude', 'skills', 'fs-krav', 'SKILL.md'), '---\nname: fs-krav\ndescription: >\n  Krav for initiativ\n  og mapper.\n---\n');

/** Kjører og samler hendelsene til `done` */
async function collect(runner: ClaudeRunner, req: Parameters<ClaudeRunner['run']>[0], onStart?: (runId: string) => void) {
  const events: ClaudeEvent[] = [];
  let runId = '';
  const done = new Promise<void>(ok =>
    runner.on(d => {
      if (d.runId !== runId) return;
      events.push(d.event);
      if (d.event.kind === 'done') ok();
    }),
  );
  ({ runId } = await runner.run(req));
  onStart?.(runId);
  await done;
  return events;
}

test('findClaude bruker KRAV_CLAUDE_PATH, og status viser versjonen', { skip: process.platform === 'win32' }, async () => {
  assert.equal(await findClaude(env), fake);
  assert.equal(await findClaude({ KRAV_CLAUDE_PATH: join(tmp, 'finnes-ikke') }), null);
  assert.deepEqual(await new ClaudeRunner(tmp, { env }).status(), { available: true, path: fake, version: '9.9.9 (Claude Code)' });
});

test('ClaudeRunner sender meldingen på stdin, med verktøy, kontekst og resume', { skip: process.platform === 'win32' }, async () => {
  const runner = new ClaudeRunner(tmp, { env });
  await assert.rejects(runner.run({ prompt: '  ' }), /melding/);
  assert.deepEqual(runner.skills().other, null, 'ingen liste før første kjøring');
  const events = await collect(runner, { prompt: '--ikke-et-flagg', sessionId: 'forrige', path: 'krav/a.feature', skill: 'fs-specify', knownSkills: ['plugin:husket', 'bad name'] });
  assert.deepEqual(events[0], { kind: 'init', sessionId: 'sess', model: 'm', skills: ['fs-krav', 'plugin:annen'] });
  const echo = JSON.parse((events[1] as { text: string }).text);
  assert.equal(echo.input, '--ikke-et-flagg');
  assert.equal(realpathSync(echo.cwd), realpathSync(tmp));
  const args: string[] = echo.args;
  assert.deepEqual(args.slice(0, 6), ['-p', '--output-format', 'stream-json', '--verbose', '--permission-mode', 'dontAsk']);
  assert.ok(args.includes('Edit') && !args.includes('Bash') && !args.includes('Skill'));
  assert.ok(args.includes('Skill(fs-specify)'), 'den valgte skillen er tillatt');
  assert.equal(args[args.indexOf('--resume') + 1], 'forrige');
  assert.match(args[args.indexOf('--append-system-prompt') + 1], /krav\/a\.feature/);
  // Prosjektets andre skill (fra disk) og den vieweren husker, avvises; ugyldige navn hoppes over
  assert.deepEqual(args.slice(args.indexOf('--disallowedTools')), ['--disallowedTools', 'Skill(fs-krav)', 'Skill(plugin:husket)']);
  assert.match(args[args.indexOf('--append-system-prompt') + 1], /valgt skillen fs-specify/);
  assert.equal(echo.input, '--ikke-et-flagg', 'uten invoke lastes ikke skillen på nytt');
  const invoked = await collect(runner, { prompt: 'lag krav', skill: 'fs-krav', invoke: true });
  assert.equal(JSON.parse((invoked[1] as { text: string }).text).input, '/fs-krav lag krav');
  const ukjent = await collect(runner, { prompt: 'x', skill: 'lage-steps', invoke: true });
  assert.equal(JSON.parse((ukjent[1] as { text: string }).text).input, 'x', 'bare CLAUDE_SKILLS kan velges');
  // Uten valgt skill: poolen er tillatt, og kodeklonene kan leses, men ikke endres
  const kode = join(tmp, 'kode');
  mkdirSync(kode, { recursive: true });
  const fri = await collect(runner, { prompt: 'verifiser', skills: ['fs-verify', 'fs-krav'], dirs: [kode, join(tmp, 'borte')], invoke: true });
  const fecho = JSON.parse((fri[1] as { text: string }).text);
  assert.equal(fecho.input, 'verifiser', 'ingen skill å laste');
  const fargs: string[] = fecho.args;
  assert.ok(fargs.includes('Skill(fs-krav)') && fargs.includes('Skill(fs-verify)'));
  assert.deepEqual(fargs.slice(fargs.indexOf('--add-dir'), fargs.indexOf('--add-dir') + 3), ['--add-dir', kode, '--append-system-prompt']);
  assert.ok(fargs.at(-1)!.startsWith('Edit(//') && fargs.at(-1)!.endsWith('/kode/**)'));
  assert.equal(events.at(-1)!.kind, 'done');
  // Etter kjøringen kjenner runneren skillene Claude meldte om; prosjektets egne er skilt ut
  const { project, other } = runner.skills();
  assert.deepEqual(project.map(({ name, description }) => ({ name, description })), [{ name: 'fs-krav', description: 'Krav for initiativ og mapper.' }]);
  assert.match(project[0].hash, /^[0-9a-f]{40}$/);
  assert.deepEqual(other, ['plugin:annen']);
});

test('skillMeta leser navn og beskrivelse, også foldet YAML', () => {
  assert.deepEqual(skillMeta('---\nname: a\ndescription: >\n  Første linje\n  andre linje.\nother: x\n---\n# A'), { name: 'a', description: 'Første linje andre linje.' });
  assert.deepEqual(skillMeta('---\nname: b\ndescription: "Sitert"\n---'), { name: 'b', description: 'Sitert' });
  assert.deepEqual(skillMeta('ingen frontmatter'), { name: null, description: '' });
});

test('skillArgs tillater den valgte skillen og poolen, og avviser alle andre', () => {
  assert.deepEqual(skillArgs('fs-krav', ['fs-krav', 'fs-specify', 'plugin:b', 'x) Bash(', 7, 'plugin:b']), {
    allow: ['Skill(fs-krav)'],
    deny: ['Skill(fs-specify)', 'Skill(plugin:b)'],
  });
  assert.deepEqual(skillArgs(null, ['fs-krav']), { allow: [], deny: ['Skill(fs-krav)'] });
  assert.deepEqual(skillArgs('lage-steps', ['lage-steps']), { allow: [], deny: ['Skill(lage-steps)'] }, 'bare CLAUDE_SKILLS kan velges');
  // Uten valgt skill (Oppgaver): alle i poolen som kan velges, er tillatt
  assert.deepEqual(skillArgs(null, ['fs-krav', 'fs-verify', 'lage-steps'], ['fs-verify', 'lage-steps', 'fs-krav']), {
    allow: ['Skill(fs-krav)', 'Skill(fs-verify)'],
    deny: ['Skill(lage-steps)'],
  });
  assert.deepEqual(
    skillArgs('fs-verify', ['fs-krav', 'fs-verify', 'fs-specify'], ['fs-krav']),
    { allow: ['Skill(fs-krav)', 'Skill(fs-verify)'], deny: ['Skill(fs-specify)'] },
    'en valgt skill er et forslag: poolen er fortsatt tillatt',
  );
  assert.deepEqual(projectSkills(join(tmp, 'finnes-ikke')), []);
});

test('ClaudeRunner melder feil fra stderr og kan avbrytes', { skip: process.platform === 'win32' }, async () => {
  const runner = new ClaudeRunner(tmp, { env });
  const crash = await collect(runner, { prompt: 'krasj' });
  assert.deepEqual(crash.at(-1), { kind: 'done', ok: false, sessionId: null, durationMs: null, turns: null, error: 'noe gikk galt' });
  const hang = await collect(runner, { prompt: 'heng' }, id => {
    assert.deepEqual(runner.active(), [id]);
    setTimeout(() => void runner.cancel(id), 200);
  });
  assert.deepEqual(runner.active(), []);
  assert.equal((hang.at(-1) as { error: string }).error, 'Avbrutt');
});

test('skillHash endres når en fil i skillmappa endres, også i undermapper', () => {
  const dir = join(tmp, 'repo-hash', '.claude', 'skills', 'fs-krav');
  mkdirSync(join(dir, 'references'), { recursive: true });
  writeFileSync(join(dir, 'SKILL.md'), '---\nname: fs-krav\ndescription: Krav\n---\n');
  writeFileSync(join(dir, 'references', 'a.md'), 'A');
  const h1 = skillHash(dir);
  assert.match(h1, /^[0-9a-f]{40}$/);
  assert.equal(skillHash(dir), h1, 'samme filer gir samme hash');
  writeFileSync(join(dir, 'references', 'a.md'), 'B');
  const h2 = skillHash(dir);
  assert.notEqual(h2, h1);
  assert.deepEqual(projectSkills(join(tmp, 'repo-hash')), [{ name: 'fs-krav', description: 'Krav', hash: h2 }]);
});
