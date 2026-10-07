import assert from 'node:assert/strict';
import { request } from 'node:http';
import { test } from 'node:test';
import type { ClaudeEvent } from '../shared/api.ts';
import { Approver, decide, DENY_MESSAGES, isAskable, shownInput } from './approve.ts';

/** POST til serveren, med egne headers (feil token, feil Host) */
function post(url: string, body: unknown, headers: Record<string, string>): Promise<{ status: number; json: any }> {
  return new Promise((ok, fail) => {
    const req = request(url, { method: 'POST', headers: { 'content-type': 'application/json', ...headers } }, res => {
      let data = '';
      res.on('data', c => (data += c));
      res.on('end', () => ok({ status: res.statusCode ?? 0, json: data ? JSON.parse(data) : null }));
    });
    req.on('error', fail);
    req.end(typeof body === 'string' ? body : JSON.stringify(body));
  });
}

const call = (name: string, args: unknown, id = 1) => ({ jsonrpc: '2.0', id, method: 'tools/call', params: { name, arguments: args } });

async function setup(opts: { timeoutMs?: number; questionTimeoutMs?: number; always?: string[]; sketches?: boolean } = {}) {
  const events: { runId: string; ev: ClaudeEvent }[] = [];
  const listeners: ((ev: ClaudeEvent) => void)[] = [];
  const a = new Approver({
    emit: (runId, ev) => {
      events.push({ runId, ev });
      listeners.forEach(l => l(ev));
    },
    saveSketch: async (id, path) => {
      if (id !== 'img') throw new Error('Fant ikke noe bilde');
      return path;
    },
    timeoutMs: opts.timeoutMs,
    questionTimeoutMs: opts.questionTimeoutMs,
  });
  const server = await a.register('r1', { always: opts.always, sketches: opts.sketches });
  const url = server.url as string;
  const headers = server.headers as Record<string, string>;
  const rpc = async (body: unknown) => (await post(url, body, headers)).json;
  const approve = async (tool: string, input: unknown = {}) => JSON.parse((await rpc(call('approve', { tool_name: tool, input, tool_use_id: 't' }))).result.content[0].text);
  return { a, url, headers, events, rpc, approve, onEvent: (l: (ev: ClaudeEvent) => void) => listeners.push(l) };
}

test('decide og isAskable: appens egne tillates, MCP_SERVERS og WebFetch spørres om, resten avvises', () => {
  const none = new Set<string>();
  assert.equal(decide('mcp__kravforvaltning__save_sketch', none), 'allow');
  assert.equal(decide('mcp__figma__get_screenshot', none), 'allow', 'bare lesing: ingen spørsmål');
  assert.equal(decide('mcp__figma__use_figma', none), 'ask');
  assert.equal(decide('mcp__chrome-devtools__take_screenshot', none), 'allow');
  assert.equal(decide('mcp__chrome-devtools__navigate_page', none), 'ask', 'navigering spørres om');
  assert.equal(decide('mcp__chrome-devtools__evaluate_script', none), 'ask');
  assert.equal(decide('mcp__figma__use_figma', new Set(['mcp__figma__use_figma'])), 'allow');
  assert.equal(decide('WebFetch', none), 'ask');
  assert.equal(decide('mcp__claude_ai_Atlassian_Rovo__getJiraIssue', none), 'allow');
  assert.equal(decide('mcp__claude_ai_Atlassian_Rovo__createJiraIssue', none), 'ask');
  assert.equal(decide('mcp__neon__run_sql', none), 'deny', 'servere utenfor MCP_SERVERS avvises');
  assert.equal(decide('mcp__neon__run_sql', new Set(['mcp__neon__run_sql'])), 'deny', 'også når de står i «tillat alltid»');
  for (const t of ['Bash', 'WebSearch', 'Edit', 'mcp__figma', '']) assert.equal(decide(t, none), 'deny', t);
  assert.ok(!isAskable('mcp__kravforvaltning__approve'));
  assert.equal(decide('AskUserQuestion', none), 'question');
  assert.equal(decide('AskUserQuestion', new Set(['AskUserQuestion'])), 'question', '«tillat alltid» gjelder ikke spørsmål');
});

test('shownInput forkorter og skjuler hemmeligheter', () => {
  const s = shownInput({ fileKey: 'F', nodeId: '1:2', api_key: 'x', token: 'y', lang: 'a'.repeat(300), n: 3, o: { a: 1 } });
  assert.deepEqual({ ...s, lang: s.lang.length }, { fileKey: 'F', nodeId: '1:2', api_key: '•••', token: '•••', lang: 200, n: '3', o: '{"a":1}' });
  assert.deepEqual(shownInput(null), {});
});

test('MCP-protokollen: initialize, varsler, tools/list, ukjent metode og GET', async () => {
  const { a, url, headers, rpc } = await setup();
  const init = await rpc({ jsonrpc: '2.0', id: 0, method: 'initialize', params: { protocolVersion: '2025-11-25' } });
  assert.equal(init.result.protocolVersion, '2025-11-25');
  assert.equal(init.result.serverInfo.name, 'kravforvaltning');
  assert.equal((await post(url, { jsonrpc: '2.0', method: 'notifications/initialized' }, headers)).status, 202);
  assert.deepEqual((await rpc({ jsonrpc: '2.0', id: 2, method: 'tools/list' })).result.tools.map((t: { name: string }) => t.name), ['approve', 'save_sketch']);
  assert.equal((await rpc({ jsonrpc: '2.0', id: 3, method: 'server/discover' })).error.code, -32601);
  assert.equal((await post(url, '{ ikke json', headers)).status, 400);
  const get = await new Promise<number>(ok => request(url, { headers }, res => ok(res.statusCode ?? 0)).end());
  assert.equal(get, 405);
  a.close();
});

test('feil token, ukjent kjøring og feil Host avvises', async () => {
  const { a, url, headers } = await setup();
  const body = { jsonrpc: '2.0', id: 1, method: 'tools/list' };
  assert.equal((await post(url, body, { Authorization: 'Bearer feil' })).status, 401);
  assert.equal((await post(url.replace('/r1', '/r2'), body, headers)).status, 401);
  assert.equal((await post(url, body, { ...headers, Host: 'evil.example:80' })).status, 403);
  a.close();
});

test('approve: tillat, tillat alltid, avvis og ikke-MCP', async () => {
  const { a, events, approve, onEvent } = await setup();
  // Bash og WebSearch avvises uten spørsmål
  assert.deepEqual(await approve('Bash', { command: 'ls' }), { behavior: 'deny', message: '«Bash» er ikke tillatt i FS Kravforvaltning.' });
  assert.equal(events.length, 0);
  // Tillat
  onEvent(ev => ev.kind === 'permission' && ev.input.nodeId === '1' && a.answer({ id: ev.id, behavior: 'allow' }));
  assert.deepEqual(await approve('mcp__figma__use_figma', { nodeId: '1' }), { behavior: 'allow', updatedInput: { nodeId: '1' } });
  // Tillat alltid: neste kall til samme verktøy spørres ikke om
  onEvent(ev => ev.kind === 'permission' && ev.input.nodeId === '2' && a.answer({ id: ev.id, behavior: 'allow', always: true }));
  await approve('mcp__figma__use_figma', { nodeId: '2' });
  const before = events.length;
  assert.deepEqual(await approve('mcp__figma__use_figma', { nodeId: '3' }), { behavior: 'allow', updatedInput: { nodeId: '3' } });
  assert.equal(events.length, before, 'ingen nye spørsmål');
  // Avvis
  onEvent(ev => ev.kind === 'permission' && ev.tool === 'WebFetch' && a.answer({ id: ev.id, behavior: 'deny' }));
  assert.deepEqual(await approve('WebFetch', { url: 'https://a.no' }), { behavior: 'deny', message: DENY_MESSAGES.user });
  assert.ok(events.every(e => e.runId === 'r1'));
  assert.deepEqual(
    events.filter(e => e.ev.kind === 'permissionDone').map(e => (e.ev as { behavior: string }).behavior),
    ['allow', 'allow', 'deny'],
  );
  assert.equal(a.answer({ id: 'finnes-ikke', behavior: 'allow' }), false);
  a.close();
});

test('approve: tillat alltid fra samtalen, tidsavbrudd, lukket panel og avsluttet kjøring', async () => {
  const fra = await setup({ always: ['mcp__figma__use_figma', 'Bash'] });
  assert.equal((await fra.approve('mcp__figma__use_figma')).behavior, 'allow');
  assert.equal((await fra.approve('Bash')).behavior, 'deny', 'allowTools kan ikke tillate Bash');
  fra.a.close();

  const slow = await setup({ timeoutMs: 50 });
  assert.deepEqual(await slow.approve('WebFetch'), { behavior: 'deny', message: DENY_MESSAGES.timeout });
  assert.deepEqual(slow.a.pending(), []);

  slow.onEvent(ev => ev.kind === 'permission' && ev.input.x === 'lukk' && slow.a.answer({ id: ev.id, behavior: 'deny', reason: 'closed' }));
  assert.deepEqual(await slow.approve('WebFetch', { x: 'lukk' }), { behavior: 'deny', message: DENY_MESSAGES.closed });
  slow.a.close();

  const ended = await setup();
  ended.onEvent(ev => ev.kind === 'permission' && setTimeout(() => ended.a.unregister('r1'), 10));
  assert.deepEqual(await ended.approve('WebFetch'), { behavior: 'deny', message: DENY_MESSAGES.ended });
  assert.equal(ended.events.at(-1)!.ev.kind, 'permissionDone');
  ended.a.close();
});

test('save_sketch: svaret er stien eller en feilmelding; ikke i en utførekjøring', async () => {
  const { a, rpc } = await setup();
  const ok = await rpc(call('save_sketch', { tool_use_id: 'img', path: 'tasks/a/b/spec/krav-input/sketches/x.png' }));
  assert.equal(ok.result.content[0].text, 'Lagret tasks/a/b/spec/krav-input/sketches/x.png');
  const feil = await rpc(call('save_sketch', { tool_use_id: 'annen', path: 'x.png' }));
  assert.equal(feil.result.isError, true);
  assert.match(feil.result.content[0].text, /Fant ikke/);
  a.close();
  const exec = await setup({ sketches: false });
  assert.deepEqual((await exec.rpc({ jsonrpc: '2.0', id: 1, method: 'tools/list' })).result.tools.map((t: { name: string }) => t.name), ['approve']);
  assert.ok((await exec.rpc(call('save_sketch', { tool_use_id: 'img', path: 'x' }))).error);
  exec.a.close();
});

const QUESTIONS = {
  questions: [
    { question: 'Skal jeg ta skjermbilder?', header: 'Skjermbilder', multiSelect: false, options: [{ label: 'Ja', description: 'Fra test' }, { label: 'Nei', description: '' }] },
    { question: 'Hvilke repoer?', header: 'Repo', multiSelect: true, options: [{ label: 'fs-admin', description: '' }, { label: 'fs-plattform', description: '', preview: 'x' }] },
  ],
};

test('AskUserQuestion: kortet, svaret som updatedInput, og «Hopp over»', async () => {
  const s = await setup();
  s.onEvent(ev => {
    if (ev.kind !== 'question') return;
    assert.equal(ev.questions.length, 2);
    assert.equal(ev.questions[1].options[1].preview, 'x');
    assert.equal(ev.toolUseId, 't');
    assert.equal(s.a.answer({ id: ev.id, behavior: 'allow' }), false, 'et spørsmål er ikke et spørsmål om lov');
    assert.equal(s.a.answerQuestion({ id: ev.id, answers: { 'Skal jeg ta skjermbilder?': 'Ja' } }), false, 'alle spørsmålene må ha svar');
    assert.deepEqual(s.a.pending().map(p => p.event.kind), ['question'], 'kortet kommer tilbake etter en omlasting');
    s.a.answerQuestion({ id: ev.id, answers: { 'Skal jeg ta skjermbilder?': 'Ja', 'Hvilke repoer?': 'fs-admin, fs-plattform', ukjent: 'x' } });
  });
  const d = await s.approve('AskUserQuestion', QUESTIONS);
  assert.equal(d.behavior, 'allow');
  assert.deepEqual(d.updatedInput.answers, { 'Skal jeg ta skjermbilder?': 'Ja', 'Hvilke repoer?': 'fs-admin, fs-plattform' });
  assert.equal(d.updatedInput.questions.length, 2);
  const done = s.events.at(-1)!.ev;
  assert.equal(done.kind, 'questionDone');
  assert.equal(done.kind === 'questionDone' && done.reason, 'user');
  assert.deepEqual(s.a.pending(), []);

  const skip = await setup();
  skip.onEvent(ev => ev.kind === 'question' && skip.a.answerQuestion({ id: ev.id, answers: null }));
  assert.deepEqual(await skip.approve('AskUserQuestion', QUESTIONS), { behavior: 'deny', message: DENY_MESSAGES.skipped });
  const sd = skip.events.at(-1)!.ev;
  assert.ok(sd.kind === 'questionDone' && sd.answers === null && sd.reason === 'user');
  s.a.close();
  skip.a.close();
});

test('AskUserQuestion: ugyldige spørsmål, tidsavbrudd, lukket panel og avsluttet kjøring', async () => {
  const s = await setup({ questionTimeoutMs: 50, timeoutMs: 10 });
  assert.deepEqual(await s.approve('AskUserQuestion', { questions: [] }), { behavior: 'deny', message: DENY_MESSAGES.invalid });
  assert.deepEqual(await s.approve('AskUserQuestion', { questions: [{ question: 'a', header: 'h', options: [{ label: 'x' }] }] }), { behavior: 'deny', message: DENY_MESSAGES.invalid });
  // Spørsmål har sin egen frist, ikke den for spørsmål om lov
  assert.deepEqual(await s.approve('AskUserQuestion', QUESTIONS), { behavior: 'deny', message: DENY_MESSAGES.questionTimeout });
  const t = s.events.at(-1)!.ev;
  assert.ok(t.kind === 'questionDone' && t.reason === 'timeout');
  s.a.close();

  const closed = await setup();
  closed.onEvent(ev => ev.kind === 'question' && closed.a.answerQuestion({ id: ev.id, answers: null, reason: 'closed' }));
  assert.deepEqual(await closed.approve('AskUserQuestion', QUESTIONS), { behavior: 'deny', message: DENY_MESSAGES.closed });
  closed.a.close();

  const ended = await setup();
  ended.onEvent(ev => ev.kind === 'question' && setTimeout(() => ended.a.unregister('r1'), 10));
  assert.deepEqual(await ended.approve('AskUserQuestion', QUESTIONS), { behavior: 'deny', message: DENY_MESSAGES.ended });
  ended.a.close();
});
