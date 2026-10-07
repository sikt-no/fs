import assert from 'node:assert/strict';
import { existsSync, mkdirSync, mkdtempSync, realpathSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import type { PtyEvent } from '../shared/api.ts';
import { BUFFER_MAX, PtyRunner, TEAM_TOOLS, TERMINAL_SETTINGS, terminalArgs, type PtyProcess, type PtySpawn } from './pty.ts';

const tmp = realpathSync(mkdtempSync(join(tmpdir(), 'krav-pty-')));
const code = join(tmp, 'fs-admin');
mkdirSync(code, { recursive: true });
mkdirSync(join(tmp, '.claude', 'skills', 'fs-krav'), { recursive: true });
writeFileSync(join(tmp, '.claude', 'skills', 'fs-krav', 'SKILL.md'), '---\nname: fs-krav\ndescription: x\n---\n');
const home = join(tmp, 'home');
mkdirSync(home);
const px = (d: string) => d.replace(/\\/g, '/').replace(/^([A-Za-z]):/, (_, x: string) => '/' + x.toLowerCase());
const after = (args: string[], flag: string) => args.slice(args.indexOf(flag) + 1);
const ctx = { repoRoot: tmp, mcpFile: '/tmp/mcp.json', kravSkills: ['fs-krav', 'fs-verify', 'fs-verify-agent-teams', 'fs-specify'] };

test('terminalArgs: interaktiv claude (ingen -p), prompten først, agent teams og push avvist', () => {
  for (const req of [
    { mode: 'execute' as const, prompt: 'Utfør', target: { repo: 'fs-admin', dir: code, spec: 'tasks/opptak/x/spec/spec-x.md' } },
    { mode: 'verify' as const, prompt: '/fs-verify-agent-teams Verifiser', dirs: [code] },
  ]) {
    const { args } = terminalArgs(req, ctx);
    assert.equal(args[0], req.prompt, 'prompten står først, før flaggene som tar flere verdier');
    assert.ok(!args.includes('-p') && !args.includes('--print') && !args.includes('--output-format'));
    assert.ok(!args.includes('--permission-prompt-tool'), 'tillatelser spørres om i terminalen');
    assert.deepEqual(after(args, '--permission-mode').slice(0, 1), ['default']);
    assert.equal(after(args, '--settings')[0], TERMINAL_SETTINGS);
    assert.deepEqual(JSON.parse(TERMINAL_SETTINGS), { teammateMode: 'in-process', permissions: { deny: ['Bash(git push:*)', 'Bash(gh:*)'] } });
    assert.equal(after(args, '--mcp-config')[0], '/tmp/mcp.json');
    const allow = after(args, '--allowedTools');
    for (const t of TEAM_TOOLS) assert.ok(allow.includes(t), t);
    assert.ok(!allow.includes('Bash') && !allow.includes('Edit'));
    const deny = after(args, '--disallowedTools');
    assert.ok(deny.includes('Bash(git push:*)') && deny.includes('Bash(gh:*)'));
    assert.equal(args.at(-1) === req.prompt, false);
  }
});

test('terminalArgs: execute kjører i kode-repoet med repoets innstillinger', () => {
  const { cwd, args } = terminalArgs({ mode: 'execute', prompt: 'Utfør', target: { repo: 'fs-admin', dir: code, spec: 'tasks/opptak/x/spec/spec-x.md' } }, ctx);
  assert.equal(cwd, code);
  assert.deepEqual(after(args, '--setting-sources').slice(0, 1), ['user,project,local']);
  assert.deepEqual(after(args, '--add-dir').slice(0, 1), [tmp]);
  assert.ok(after(args, '--allowedTools').includes(`Edit(/${px(code)}/**)`));
  assert.ok(after(args, '--disallowedTools').includes('Skill(fs-krav)'), 'kravrepoets skills brukes ikke i kode-repoet');
  const sys = after(args, '--append-system-prompt')[0];
  assert.match(sys, /terminalen i FS Kravforvaltning/);
  assert.match(sys, /agent team/);
  assert.ok(sys.includes(join(tmp, 'tasks/opptak/x', 'utforing.md')));
  assert.throws(() => terminalArgs({ mode: 'execute', prompt: 'x', target: { repo: 'fs-admin', dir: tmp, spec: '' } }, ctx), /kravrepoet/);
});

test('terminalArgs: verify kjører i kravrepoet, kan lese kodemappene og bare bruke fs-verify-skillene', () => {
  const { cwd, args } = terminalArgs({ mode: 'verify', prompt: 'Verifiser', dirs: [code, join(tmp, 'borte'), 'relativ', tmp] }, ctx);
  assert.equal(cwd, tmp);
  assert.deepEqual(args.filter((a, i) => args[i - 1] === '--add-dir'), [code], 'bare mapper som finnes, og ikke kravrepoet');
  const allow = after(args, '--allowedTools');
  assert.ok(allow.includes('Skill(fs-verify)') && allow.includes('Skill(fs-verify-agent-teams)'));
  assert.ok(allow.includes(`Edit(/${px(tmp)}/krav/**)`) && allow.includes(`Edit(/${px(tmp)}/tasks/*/*/spec/**)`));
  assert.ok(allow.includes('Bash(git log:*)') && !allow.some(a => a.startsWith('Bash(rm')));
  const deny = after(args, '--disallowedTools');
  assert.ok(deny.includes(`Edit(/${px(code)}/**)`), 'koden kan leses, ikke endres');
  assert.ok(deny.includes('Skill(fs-krav)') && deny.includes('Skill(fs-specify)') && !deny.includes('Skill(fs-verify)'));
  assert.match(after(args, '--append-system-prompt')[0], new RegExp(`Kodeklonene er ${code.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}`));
});

test('terminalArgs: tom prompt, prompt som ser ut som et flagg og ukjent modus avvises', () => {
  assert.throws(() => terminalArgs({ mode: 'verify', prompt: '  ' }, ctx), /Skriv en melding/);
  assert.throws(() => terminalArgs({ mode: 'verify', prompt: '--dangerously-skip-permissions' }, ctx), /begynne med «-»/);
  assert.throws(() => terminalArgs({ mode: 'annet' as 'verify', prompt: 'x' }, ctx), /Ukjent modus/);
});

/** En falsk pty: husker kallet, og lar testen sende utdata og avslutte */
function fakeSpawn() {
  const calls: { file: string; args: string[]; opts: Parameters<PtySpawn>[2]; written: string[]; sizes: [number, number][]; killed: boolean; data?: (d: string) => void; exit?: (e: { exitCode: number }) => void }[] = [];
  const spawn: PtySpawn = (file, args, opts) => {
    const c: (typeof calls)[number] = { file, args, opts, written: [], sizes: [], killed: false };
    calls.push(c);
    const p: PtyProcess = {
      onData: cb => (c.data = cb),
      onExit: cb => (c.exit = cb),
      write: d => void c.written.push(d),
      resize: (cols, rows) => void c.sizes.push([cols, rows]),
      kill: () => {
        c.killed = true;
        c.exit?.({ exitCode: 143 });
      },
    };
    return p;
  };
  return { spawn, calls };
}

test('PtyRunner: starter claude i pty med agent teams, sender utdata, skriv, størrelse, stopp og buffer', async () => {
  const { spawn, calls } = fakeSpawn();
  const events: PtyEvent[] = [];
  const r = new PtyRunner(tmp, { bin: async () => '/usr/local/bin/claude', spawn, env: { PATH: '/usr/bin', HOME: home, CLAUDECODE: '1', CLAUDE_CODE_MESSAGING_TOKEN: 'x', CLAUDE_CODE_USE_BEDROCK: '1' }, home });
  r.on(e => events.push(e));
  const { id } = await r.start({ mode: 'verify', prompt: 'Verifiser', dirs: [code], cols: 120, rows: 40 });
  const c = calls[0];
  assert.equal(c.file, '/usr/local/bin/claude');
  assert.equal(c.args[0], 'Verifiser');
  assert.equal(c.opts.cwd, tmp);
  assert.equal(c.opts.cols, 120);
  assert.equal(c.opts.env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS, '1');
  assert.equal(c.opts.env.TERM, 'xterm-256color');
  assert.ok(!('CLAUDECODE' in c.opts.env) && !('CLAUDE_CODE_MESSAGING_TOKEN' in c.opts.env), 'ikke en underøkt av økten som startet appen');
  assert.equal(c.opts.env.CLAUDE_CODE_USE_BEDROCK, '1', 'brukerens egne innstillinger beholdes');
  assert.ok(c.opts.env.PATH.startsWith('/usr/local/bin'), 'mappa claude ligger i, først på PATH');
  const mcp = after(c.args, '--mcp-config')[0];
  assert.ok(existsSync(mcp), 'MCP-konfigen finnes mens økten kjører');

  c.data!('hei ');
  c.data!('fra claude');
  assert.equal(r.buffer(id), 'hei fra claude');
  assert.deepEqual(events.slice(0, 2), [{ id, kind: 'data', data: 'hei ' }, { id, kind: 'data', data: 'fra claude' }]);
  assert.ok(r.write(id, 'j\r'));
  assert.deepEqual(c.written, ['j\r']);
  assert.ok(r.resize(id, 80, 24));
  assert.deepEqual(c.sizes, [[80, 24]]);
  assert.equal(r.write('ukjent', 'x'), false);
  assert.deepEqual(r.active(), [{ id, exited: false, code: null }]);

  c.data!('x'.repeat(BUFFER_MAX + 10));
  assert.equal(r.buffer(id).length, BUFFER_MAX, 'bufferet kappes i starten');

  assert.ok(r.kill(id));
  assert.deepEqual(events.at(-1), { id, kind: 'exit', code: 143 });
  assert.deepEqual(r.active(), [{ id, exited: true, code: 143 }], 'avsluttede økter huskes for omlasting');
  assert.ok(!existsSync(mcp), 'MCP-konfigen slettes når økten er ferdig');
  assert.equal(r.write(id, 'x'), false);
  assert.equal(r.kill(id), false);
});

test('PtyRunner: uten claude, med ugyldig forespørsel, og close stopper alle økter', async () => {
  const { spawn, calls } = fakeSpawn();
  await assert.rejects(new PtyRunner(tmp, { bin: async () => null, spawn }).start({ mode: 'verify', prompt: 'x' }), /Fant ikke Claude Code/);
  const r = new PtyRunner(tmp, { bin: async () => '/usr/local/bin/claude', spawn, env: { PATH: '' }, home });
  await assert.rejects(r.start({ mode: 'verify', prompt: '-x' }), /begynne med «-»/);
  assert.equal(calls.length, 0);
  await r.start({ mode: 'verify', prompt: 'a' });
  await r.start({ mode: 'execute', prompt: 'b', target: { repo: 'fs-admin', dir: code, spec: '' } });
  assert.equal(calls[1].opts.cwd, code);
  r.close();
  assert.ok(calls.every(c => c.killed));
  assert.deepEqual(r.active(), []);
});
