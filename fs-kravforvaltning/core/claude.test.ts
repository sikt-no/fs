import assert from 'node:assert/strict';
import { chmodSync, mkdtempSync, realpathSync, rmSync, utimesSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { after, test } from 'node:test';
import type { ClaudeEvent } from '../shared/api.ts';
import { mkdirSync } from 'node:fs';
import { allowedAlways, ClaudeRunner, codeDirs, contextPrompt, dirArgs, executeArgs, implementPrompt, mentionPaths, findClaude, nowStamp, PANEL_DENY, parseStreamLine, projectSkills, skillArgs, skillChangedAt, skillHash, skillMeta, streamImages, timeLine, toolSummary } from './claude.ts';
import { existsSync, readFileSync } from 'node:fs';

const tmp = mkdtempSync(join(tmpdir(), 'krav-claude-'));
after(() => rmSync(tmp, { recursive: true, force: true }));

test('parseStreamLine plukker ut init, tekst, verktøy og resultat', () => {
  assert.deepEqual(parseStreamLine('{"type":"system","subtype":"init","session_id":"s1","model":"m","skills":["fs-krav","x:y",3]}'), [
    { kind: 'init', sessionId: 's1', model: 'm', skills: ['fs-krav', 'x:y'], mcp: [] },
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
process.stdin.on('end', async () => {
  const args = process.argv.slice(2);
  const out = o => process.stdout.write(JSON.stringify(o) + '\\n');
  const mcpFile = args[args.indexOf('--mcp-config') + 1];
  const mcp = JSON.parse(require('node:fs').readFileSync(mcpFile, 'utf8')).mcpServers;
  out({ type: 'system', subtype: 'init', session_id: 'sess', model: 'm', skills: ['fs-krav', 'plugin:annen'],
    mcp_servers: [{ name: 'kravforvaltning', status: 'connected' }, { name: 'figma', status: 'needs-auth', source: 'dynamic' }, { name: 'planchain', status: 'needs-auth', source: 'local' }, { name: 'claude.ai Gmail', status: 'needs-auth', source: 'claudeai' }] });
  if (input === 'heng') return setTimeout(() => {}, 60000);
  if (input === 'krasj') { process.stderr.write('noe gikk galt\\n'); process.exit(3); }
  const own = mcp.kravforvaltning;
  const call = async (name, args) => {
    const r = await fetch(own.url, { method: 'POST', headers: { ...own.headers, 'content-type': 'application/json' }, body: JSON.stringify({ jsonrpc: '2.0', id: 1, method: 'tools/call', params: { name, arguments: args } }) });
    return (await r.json()).result.content[0].text;
  };
  let answers = [];
  if (input.startsWith('spør')) answers.push(await call('approve', { tool_name: 'mcp__figma__use_figma', input: { fileKey: 'F', nodeId: '1:2' }, tool_use_id: 't1' }));
  if (input === 'spør to ganger') answers.push(await call('approve', { tool_name: 'mcp__figma__use_figma', input: { fileKey: 'G' }, tool_use_id: 't2' }));
  if (input === 'skisse') {
    out({ type: 'user', message: { content: [{ type: 'tool_result', tool_use_id: 'img1', content: [{ type: 'image', source: { type: 'base64', media_type: 'image/png', data: Buffer.from('PNGDATA').toString('base64') } }] }] } });
    answers.push(await call('save_sketch', { tool_use_id: 'img1', path: 'tasks/opptak/x/spec/krav-input/sketches/figma/a/screenshot.png' }));
    answers.push(await call('save_sketch', { tool_use_id: 'img1', path: 'krav/a.png' }));
    answers.push(await call('save_sketch', { tool_use_id: 'ukjent', path: 'tasks/opptak/x/spec/krav-input/sketches/b.png' }));
    // Uten tool_use_id: det siste bildet, her et skjermbilde fra fs-verify
    out({ type: 'user', message: { content: [{ type: 'tool_result', tool_use_id: 'img2', content: [{ type: 'image', source: { type: 'base64', media_type: 'image/png', data: Buffer.from('SISTE').toString('base64') } }] }] } });
    answers.push(await call('save_sketch', { path: 'tasks/opptak/x/spec/verify-2026-10-05/01-se-liste.png' }));
  }
  out({ type: 'assistant', message: { content: [{ type: 'text', text: JSON.stringify({ input, args, cwd: process.cwd(), mcp, answers, toolTimeout: process.env.MCP_TOOL_TIMEOUT }) }] } });
  out({ type: 'result', subtype: 'success', is_error: false, session_id: 'sess', duration_ms: 1, num_turns: 1 });
});
`,
);
chmodSync(fake, 0o755);
const env = { ...process.env, KRAV_CLAUDE_PATH: fake };
// Hjemmemappa med ~/.claude.json: en server for brukeren og én for en annen mappe
const home = join(tmp, 'home');
mkdirSync(home, { recursive: true });
writeFileSync(
  join(home, '.claude.json'),
  JSON.stringify({
    mcpServers: { 'chrome-devtools': { type: 'http', url: 'https://atl/mcp', headers: { Authorization: 'Bearer hemmelig' } }, neon: { type: 'http', url: 'https://neon' } },
    projects: { '/annen/mappe': { mcpServers: { figma: { type: 'http', url: 'https://mcp.figma.com/mcp' }, 'chrome-devtools': { type: 'http', url: 'https://feil' } } } },
  }),
);
const ro = { env, home };
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
  assert.deepEqual(await new ClaudeRunner(tmp, ro).status(), { available: true, path: fake, version: '9.9.9 (Claude Code)' });
});

test('ClaudeRunner sender meldingen på stdin, med verktøy, kontekst og resume', { skip: process.platform === 'win32' }, async () => {
  const runner = new ClaudeRunner(tmp, ro);
  await assert.rejects(runner.run({ prompt: '  ' }), /melding/);
  assert.deepEqual(runner.skills().other, null, 'ingen liste før første kjøring');
  const events = await collect(runner, { prompt: '--ikke-et-flagg', sessionId: 'forrige', path: 'krav/a.feature', skill: 'fs-specify', knownSkills: ['plugin:husket', 'bad name'] });
  // Bare serverne i MCP_SERVERS vises i MCP-statusen (ikke appens egen, andre servere eller claude.ai-koblingene)
  assert.deepEqual(events[0], { kind: 'init', sessionId: 'sess', model: 'm', skills: ['fs-krav', 'plugin:annen'], mcp: [{ name: 'figma', status: 'needs-auth' }] });
  const echo = JSON.parse((events[1] as { text: string }).text);
  assert.equal(echo.input, '--ikke-et-flagg');
  assert.equal(realpathSync(echo.cwd), realpathSync(tmp));
  const args: string[] = echo.args;
  assert.deepEqual(args.slice(0, 8), ['-p', '--output-format', 'stream-json', '--verbose', '--permission-mode', 'default', '--permission-prompt-tool', 'mcp__kravforvaltning__approve']);
  assert.ok(args.includes('Edit') && !args.includes('Skill') && args.includes('mcp__kravforvaltning__save_sketch'));
  assert.ok(args.indexOf('Bash') > args.indexOf('--disallowedTools'), 'Bash avvises hardt');
  // MCP-verktøy som bare leser, tillates uten spørsmål; de som endrer noe, gjør ikke det
  const allowed = args.slice(args.indexOf('--allowedTools'), args.indexOf('--disallowedTools'));
  assert.ok(allowed.includes('mcp__figma__get_metadata') && allowed.includes('mcp__chrome-devtools__take_screenshot') && allowed.includes('mcp__claude_ai_Atlassian_Rovo__getJiraIssue'));
  assert.ok(!allowed.includes('mcp__figma__use_figma') && !allowed.includes('mcp__chrome-devtools__navigate_page'));
  // MCP-serverne i MCP_SERVERS fra ~/.claude.json (user vinner ved like navn) og appens egen, i en fil bare brukeren kan lese
  assert.deepEqual(Object.keys(echo.mcp).sort(), ['chrome-devtools', 'figma', 'kravforvaltning']);
  assert.equal(echo.mcp['chrome-devtools'].url, 'https://atl/mcp');
  assert.match(echo.mcp.kravforvaltning.url, /^http:\/\/127\.0\.0\.1:\d+\/mcp\//);
  assert.ok(!args.some(a => a.includes('hemmelig')), 'hemmeligheter står ikke på kommandolinja');
  assert.equal(echo.toolTimeout, String(30 * 60_000 + 60_000), 'claude venter på spørsmålet om lov og på svar på AskUserQuestion');
  // `done` kommer fra stdout før prosessen er avsluttet; fila slettes når den er det
  for (let i = 0; i < 50 && runner.active().length; i++) await new Promise(r => setTimeout(r, 20));
  assert.ok(!existsSync(args[args.indexOf('--mcp-config') + 1]), 'konfigfila slettes etter kjøringen');
  assert.ok(args.includes('Skill(fs-specify)'), 'den valgte skillen er tillatt');
  assert.equal(args[args.indexOf('--resume') + 1], 'forrige');
  assert.match(args[args.indexOf('--append-system-prompt') + 1], /krav\/a\.feature/);
  // Prosjektets andre skill (fra disk) og den vieweren husker, avvises; ugyldige navn hoppes over
  assert.deepEqual(args.slice(args.indexOf('--disallowedTools')), ['--disallowedTools', ...PANEL_DENY, 'Skill(fs-krav)', 'Skill(plugin:husket)']);
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
  assert.ok(!fargs.includes('mcp__chrome-devtools__navigate_page'), 'navigering spørres om uten valgt fs-verify');
  // Med fs-verify valgt navigerer, klikker og trykker Claude i chrome-devtools uten å spørre (skjermbildene)
  const vargs: string[] = JSON.parse(((await collect(runner, { prompt: 'verifiser', skill: 'fs-verify', skills: ['fs-verify', 'fs-krav'] }))[1] as { text: string }).text).args;
  const vallowed = vargs.slice(vargs.indexOf('--allowedTools'), vargs.indexOf('--disallowedTools'));
  assert.ok(['navigate_page', 'click', 'press_key'].every(t => vallowed.includes(`mcp__chrome-devtools__${t}`)));
  assert.ok(!vallowed.includes('mcp__chrome-devtools__new_page') && !vallowed.includes('mcp__chrome-devtools__evaluate_script'));
  assert.deepEqual(fargs.slice(fargs.indexOf('--add-dir'), fargs.indexOf('--add-dir') + 3), ['--add-dir', kode, '--append-system-prompt']);
  assert.ok(fargs.at(-1)!.startsWith('Edit(//') && fargs.at(-1)!.endsWith('/kode/**)'));
  assert.equal(events.at(-1)!.kind, 'done');
  // Etter kjøringen kjenner runneren skillene Claude meldte om; prosjektets egne er skilt ut
  const { project, other } = runner.skills();
  assert.deepEqual(project.map(({ name, description }) => ({ name, description })), [{ name: 'fs-krav', description: 'Krav for initiativ og mapper.' }]);
  assert.match(project[0].hash, /^[0-9a-f]{40}$/);
  assert.deepEqual(other, ['plugin:annen']);
});

test('executeArgs: cwd i kode-repoet, Edit bare der og i utforing.md, kravrepoets skills og push avvist', () => {
  const code = join(tmp, 'fs-plattform');
  mkdirSync(code, { recursive: true });
  const px = (d: string) => d.replace(/\\/g, '/').replace(/^([A-Za-z]):/, (_, x: string) => '/' + x.toLowerCase());
  const x = executeArgs(tmp, { repo: 'fs-plattform', dir: code }, ['fs-specify', 'fs-krav', 'bad name']);
  assert.equal(x.cwd, code);
  assert.deepEqual(x.add, ['--add-dir', tmp]);
  assert.ok(x.allow.includes('Skill') && !x.allow.includes('Edit') && !x.allow.includes('Bash'));
  assert.ok(x.allow.includes(`Edit(/${px(code)}/**)`));
  assert.ok(x.allow.includes(`Edit(/${px(tmp)}/tasks/*/*/utforing.md)`));
  assert.ok(x.allow.includes('Bash(git commit:*)') && x.allow.includes('Bash(npm test:*)'));
  assert.deepEqual(x.deny, ['Skill(fs-krav)', 'Skill(fs-specify)', 'Bash(git push:*)', 'Bash(gh:*)']);
  assert.throws(() => executeArgs(tmp, { repo: 'fs-admin', dir: join(tmp, 'borte') }, []), /Fant ikke kodemappa fs-admin/);
  assert.throws(() => executeArgs(tmp, { repo: 'x', dir: 'relativ' }, []), /Fant ikke/);
  assert.throws(() => executeArgs(tmp, { repo: 'x', dir: tmp }, []), /kravrepoet/);
  const p = implementPrompt({ repo: 'fs-plattform', spec: 'tasks/opptak/x/spec/spec-x.md' }, tmp);
  assert.match(p, /utførekjøring fra FS Kravforvaltning i repoet fs-plattform/);
  assert.ok(p.includes(join(tmp, 'tasks/opptak/x/spec/spec-x.md')));
  assert.ok(p.includes('«### fs-plattform»') && p.includes(join(tmp, 'tasks/opptak/x', 'utforing.md')));
  assert.ok(!implementPrompt({ repo: 'fs-plattform', spec: '../hemmelig.md' }, tmp).includes('hemmelig'));
});

test('ClaudeRunner: utførekjøring kjører i kode-repoet med egne argumenter', { skip: process.platform === 'win32' }, async () => {
  const code = join(tmp, 'fs-admin-utfor');
  mkdirSync(code, { recursive: true });
  const runner = new ClaudeRunner(tmp, ro);
  const ev = await collect(runner, { prompt: 'implementer', skill: 'fs-krav', invoke: true, target: { repo: 'fs-admin', dir: code, spec: 'tasks/opptak/x/spec/spec-x.md' } });
  const echo = JSON.parse((ev[1] as { text: string }).text);
  assert.equal(realpathSync(echo.cwd), realpathSync(code));
  assert.equal(echo.input, 'implementer', 'ingen krav-skill lastes i en utførekjøring');
  const args: string[] = echo.args;
  assert.equal(args[args.indexOf('--setting-sources') + 1], 'user,project,local');
  assert.equal(args[args.indexOf('--add-dir') + 1], tmp);
  assert.ok(args.includes('Skill(fs-krav)') && args.indexOf('Skill(fs-krav)') > args.indexOf('--disallowedTools'), 'kravrepoets skill avvises');
  assert.equal(runner.skills().other, null, 'skillene fra kode-repoet blandes ikke med kravrepoets');
  assert.deepEqual(args.slice(4, 8), ['--permission-mode', 'default', '--permission-prompt-tool', 'mcp__kravforvaltning__approve']);
  assert.ok(args.includes('--mcp-config') && 'figma' in echo.mcp && 'kravforvaltning' in echo.mcp);
  // Deny-lista er den samme som før: kravrepoets skills, git push og gh
  assert.deepEqual(args.slice(args.indexOf('--disallowedTools') + 1), ['Skill(fs-krav)', 'Bash(git push:*)', 'Bash(gh:*)']);
  const alltid = await collect(runner, { prompt: 'x', target: { repo: 'fs-admin', dir: code, spec: 'tasks/opptak/x/spec/spec-x.md' }, allowTools: ['mcp__figma__use_figma', 'Bash', 'mcp__kravforvaltning__approve'] });
  const aargs: string[] = JSON.parse((alltid[1] as { text: string }).text).args;
  assert.ok(aargs.includes('mcp__figma__use_figma') && aargs.indexOf('mcp__figma__use_figma') < aargs.indexOf('--disallowedTools'));
  assert.ok(!aargs.slice(0, aargs.indexOf('--disallowedTools')).includes('Bash'), 'allowTools tar bare mcp__* og WebFetch');
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
  const runner = new ClaudeRunner(tmp, ro);
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
  const [skill] = projectSkills(join(tmp, 'repo-hash'));
  assert.deepEqual({ ...skill, changedAt: 0 }, { name: 'fs-krav', description: 'Krav', hash: h2, changedAt: 0 });
  // Endringstiden er den nyeste filen i mappa
  const t = new Date(Date.now() + 60_000);
  utimesSync(join(dir, 'references', 'a.md'), t, t);
  assert.ok(Math.abs(skillChangedAt(dir) - t.getTime()) < 1000, 'filsystemet kan runde av tidspunktet');
});

test('allowedAlways tar bare WebFetch og verktøyene til serverne i MCP_SERVERS', () => {
  assert.deepEqual(allowedAlways(['mcp__figma__get_screenshot', 'WebFetch', 'Bash', 'mcp__kravforvaltning__approve', 'mcp__neon__run_sql', 'mcp__x', 3, 'WebFetch']), ['WebFetch', 'mcp__figma__get_screenshot']);
  assert.deepEqual(allowedAlways(null), []);
});

test('toolSummary for MCP-verktøy og WebFetch', () => {
  assert.equal(toolSummary('mcp__figma__get_screenshot', { fileKey: 'F', nodeId: '1:2', token: 'x' }), 'figma · get_screenshot (fileKey F, nodeId 1:2)');
  assert.equal(toolSummary('mcp__figma__whoami', {}), 'figma · whoami');
  assert.equal(toolSummary('mcp__kravforvaltning__save_sketch', { path: 'tasks/a/b/spec/krav-input/sketches/x.png' }), 'tasks/a/b/spec/krav-input/sketches/x.png', 'stien, så fila kommer med i «Endret i samtalen»');
  assert.equal(toolSummary('mcp__claude_ai_Atlassian_Rovo__getJiraIssue', { issueIdOrKey: 'FS-1' }), 'Atlassian Rovo · getJiraIssue (issueIdOrKey FS-1)');
  assert.equal(toolSummary('WebFetch', { url: 'https://a.no/x?token=1', prompt: 'p' }), 'https://a.no/x');
});

test('streamImages plukker ut bildene fra verktøyresultatene', () => {
  const line = JSON.stringify({ type: 'user', message: { content: [{ type: 'tool_result', tool_use_id: 't', content: [{ type: 'text', text: 'x' }, { type: 'image', source: { type: 'base64', media_type: 'image/png', data: 'QQ==' } }] }] } });
  assert.deepEqual(streamImages(line), [{ toolUseId: 't', mediaType: 'image/png', data: 'QQ==' }]);
  assert.deepEqual(streamImages('{"type":"assistant"}'), []);
  assert.deepEqual(streamImages('ikke json "image"'), []);
});

const echoOf = (events: ClaudeEvent[]) => JSON.parse((events.find(e => e.kind === 'text') as { text: string }).text);

test('ClaudeRunner: spørsmål om lov går til vieweren, og «tillat alltid» gjelder resten av kjøringen', { skip: process.platform === 'win32' }, async () => {
  const runner = new ClaudeRunner(tmp, ro);
  const asked: ClaudeEvent[] = [];
  runner.on(({ event }) => {
    if (event.kind !== 'permission') return;
    asked.push(event);
    assert.deepEqual(runner.pending().map(p => p.event.id), [event.id]);
    void runner.approve({ id: event.id, behavior: 'allow', always: true });
  });
  const events = await collect(runner, { prompt: 'spør to ganger' });
  assert.equal(asked.length, 1, 'det andre kallet til samme verktøy spørres ikke om');
  assert.deepEqual({ ...asked[0], id: '' }, { kind: 'permission', id: '', tool: 'mcp__figma__use_figma', input: { fileKey: 'F', nodeId: '1:2' }, toolUseId: 't1' });
  assert.deepEqual(echoOf(events).answers.map((a: string) => JSON.parse(a)), [
    { behavior: 'allow', updatedInput: { fileKey: 'F', nodeId: '1:2' } },
    { behavior: 'allow', updatedInput: { fileKey: 'G' } },
  ]);
  assert.ok(events.some(e => e.kind === 'permissionDone' && e.behavior === 'allow'));
  assert.deepEqual(runner.pending(), []);
  runner.close();
});

test('ClaudeRunner: avvist kall og tidsavbrudd gir deny med en melding Claude kan videreformidle', { skip: process.platform === 'win32' }, async () => {
  const runner = new ClaudeRunner(tmp, ro);
  runner.on(({ event }) => event.kind === 'permission' && void runner.approve({ id: event.id, behavior: 'deny' }));
  const denied = await collect(runner, { prompt: 'spør' });
  const [d] = echoOf(denied).answers.map((a: string) => JSON.parse(a));
  assert.equal(d.behavior, 'deny');
  assert.match(d.message, /avviste kallet/);
  assert.ok(denied.some(e => e.kind === 'permissionDone' && e.behavior === 'deny' && e.reason === 'user'));
  runner.close();

  const slow = new ClaudeRunner(tmp, { ...ro, approveTimeoutMs: 100 });
  const timeout = await collect(slow, { prompt: 'spør' });
  const [t] = echoOf(timeout).answers.map((a: string) => JSON.parse(a));
  assert.equal(t.behavior, 'deny');
  assert.match(t.message, /svarte ikke innen/);
  assert.ok(timeout.some(e => e.kind === 'permissionDone' && e.reason === 'timeout'));
  slow.close();
});

test('ClaudeRunner: save_sketch skriver bildet fra verktøyresultatet (eller det siste), bare under sketches/ og verify-<dato>/', { skip: process.platform === 'win32' }, async () => {
  const saved: string[] = [];
  let done = 0;
  const runner = new ClaudeRunner(tmp, { ...ro, onSaved: p => saved.push(p), onDone: () => done++ });
  const events = await collect(runner, { prompt: 'skisse' });
  for (let i = 0; i < 50 && !done; i++) await new Promise(r => setTimeout(r, 20));
  assert.equal(done, 1, 'onDone når kjøringen er ferdig, så «Endringer» leses på nytt');
  const [ok, utenfor, ukjent, siste] = echoOf(events).answers;
  assert.equal(ok, 'Lagret tasks/opptak/x/spec/krav-input/sketches/figma/a/screenshot.png');
  assert.equal(readFileSync(join(tmp, 'tasks/opptak/x/spec/krav-input/sketches/figma/a/screenshot.png'), 'utf8'), 'PNGDATA');
  assert.match(utenfor, /Bilder lagres under tasks/);
  assert.match(ukjent, /Fant ikke noe bilde/);
  assert.equal(siste, 'Lagret tasks/opptak/x/spec/verify-2026-10-05/01-se-liste.png');
  assert.equal(readFileSync(join(tmp, 'tasks/opptak/x/spec/verify-2026-10-05/01-se-liste.png'), 'utf8'), 'SISTE');
  assert.deepEqual(saved, ['tasks/opptak/x/spec/krav-input/sketches/figma/a/screenshot.png', 'tasks/opptak/x/spec/verify-2026-10-05/01-se-liste.png']);
  runner.close();
});

test('nowStamp og timeLine: lokal tid i systemteksten, så fs-verify kan sette tidspunkt på rapporten uten shell', () => {
  assert.equal(nowStamp(new Date(2026, 9, 9, 9, 5)), '2026-10-09 09:05');
  assert.match(timeLine(new Date(2026, 0, 2, 14, 32)), /^Tidspunktet nå er 2026-01-02 14:32 \(lokal tid\)/);
  assert.match(contextPrompt(null), /Tidspunktet nå er \d{4}-\d{2}-\d{2} \d{2}:\d{2}/);
});
