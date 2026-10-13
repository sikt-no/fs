import assert from 'node:assert/strict';
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { after, test } from 'node:test';
import { collectMcpServers, MCP_READONLY, MCP_SERVERS, MCP_VERIFY, readMcpServers, readonlyTools, redactServers, verifyTools } from './mcp.ts';

const tmp = mkdtempSync(join(tmpdir(), 'krav-mcp-'));
after(() => rmSync(tmp, { recursive: true, force: true }));

const http = (url: string) => ({ type: 'http', url });

test('collectMcpServers: user, local for arbeidsmappa, .mcp.json og andre mapper, slått sammen på navn', () => {
  const claudeJson = {
    mcpServers: { neon: http('https://neon/user'), delt: http('https://user') },
    projects: {
      '/b/annen': { mcpServers: { figma: http('https://figma/b'), 'chrome-devtools': http('https://atl/b') } },
      '/a/annen': { mcpServers: { figma: http('https://figma/a') } },
      '/repo': { mcpServers: { delt: http('https://local-her'), her: http('https://her') } },
    },
  };
  const mcpJsons = [{ dir: '/kode', json: { mcpServers: { 'chrome-devtools': http('https://atl/kode'), delt: http('https://kode') } } }];
  const all = ['neon', 'delt', 'her', 'chrome-devtools', 'figma'];
  assert.deepEqual(collectMcpServers(claudeJson, mcpJsons, '/repo', all), {
    neon: http('https://neon/user'),
    delt: http('https://user'), // user-scope vinner over local og .mcp.json
    her: http('https://her'),
    'chrome-devtools': http('https://atl/kode'), // .mcp.json i kodemappene foran local i andre mapper
    figma: http('https://figma/a'), // andre mapper sortert på sti
  });
  // Standard: bare serverne i MCP_SERVERS
  assert.deepEqual(MCP_SERVERS, ['figma', 'claude_ai_Atlassian_Rovo', 'chrome-devtools']);
  assert.deepEqual(Object.keys(collectMcpServers(claudeJson, mcpJsons, '/repo')), ['chrome-devtools', 'figma']);
});

test('collectMcpServers hopper over ugyldige oppføringer og appens eget navn', () => {
  const claudeJson = {
    mcpServers: { kravforvaltning: http('https://falsk'), tom: {}, liste: [], tekst: 'x', stdio: { command: 'npx', args: ['a'] } },
    projects: { '/x': 'ikke et objekt', '/y': { mcpServers: null } },
  };
  assert.deepEqual(collectMcpServers(claudeJson, [{ dir: '/d', json: null }], '', ['kravforvaltning', 'tom', 'liste', 'tekst', 'stdio']), { stdio: { command: 'npx', args: ['a'] } });
  assert.deepEqual(collectMcpServers(null), {});
  assert.deepEqual(collectMcpServers('ødelagt', [{ dir: '/d', json: 'ødelagt' }]), {});
});

test('readMcpServers leser ~/.claude.json og .mcp.json; manglende og ødelagte filer gir ingenting', () => {
  const home = join(tmp, 'home');
  const kode = join(tmp, 'kode');
  const brutt = join(tmp, 'brutt');
  mkdirSync(home, { recursive: true });
  mkdirSync(kode, { recursive: true });
  mkdirSync(brutt, { recursive: true });
  writeFileSync(join(home, '.claude.json'), JSON.stringify({ mcpServers: { 'chrome-devtools': http('https://atl'), neon: http('https://neon') } }));
  writeFileSync(join(kode, '.mcp.json'), JSON.stringify({ mcpServers: { figma: http('https://figma') } }));
  writeFileSync(join(brutt, '.mcp.json'), '{ ikke json');
  assert.deepEqual(readMcpServers(tmp, [kode, brutt, join(tmp, 'borte')], home), { 'chrome-devtools': http('https://atl'), figma: http('https://figma') }, 'neon er ikke i MCP_SERVERS');
  assert.deepEqual(readMcpServers(tmp, [], join(tmp, 'ingen-home')), {});
});

test('redactServers skjuler headers, env og query-strengen', () => {
  const servers = {
    neon: { type: 'http', url: 'https://neon/mcp?api_key=hemmelig', headers: { Authorization: 'Bearer hemmelig' } },
    lokal: { type: 'stdio', command: 'npx', env: { TOKEN: 'hemmelig' } },
  };
  const r = redactServers(servers);
  assert.deepEqual(r, {
    neon: { type: 'http', url: 'https://neon/mcp', headers: { Authorization: '•••' } },
    lokal: { type: 'stdio', command: 'npx', env: { TOKEN: '•••' } },
  });
  assert.ok(!JSON.stringify(r).includes('hemmelig'));
  assert.equal(servers.neon.headers.Authorization, 'Bearer hemmelig', 'originalen endres ikke');
});

test('readonlyTools: verktøyene som bare leser, for serverne i MCP_SERVERS', () => {
  const tools = readonlyTools();
  assert.ok(tools.includes('mcp__figma__get_metadata') && tools.includes('mcp__chrome-devtools__take_screenshot') && tools.includes('mcp__claude_ai_Atlassian_Rovo__searchJiraIssuesUsingJql'));
  for (const t of ['mcp__figma__use_figma', 'mcp__figma__create_new_file', 'mcp__figma__upload_assets', 'mcp__chrome-devtools__click', 'mcp__chrome-devtools__evaluate_script', 'mcp__chrome-devtools__navigate_page', 'mcp__claude_ai_Atlassian_Rovo__createJiraIssue'])
    assert.ok(!tools.includes(t), t);
  assert.ok(Object.keys(MCP_READONLY).every(s => MCP_SERVERS.includes(s)));
});

test('verifyTools: navigering, klikk og taster i chrome-devtools, bare for fs-verify', () => {
  assert.deepEqual(verifyTools(), ['mcp__chrome-devtools__navigate_page', 'mcp__chrome-devtools__click', 'mcp__chrome-devtools__press_key']);
  assert.ok(!verifyTools().some(t => readonlyTools().includes(t)), 'står ikke i MCP_READONLY');
  assert.ok(Object.keys(MCP_VERIFY).every(s => MCP_SERVERS.includes(s)));
});
