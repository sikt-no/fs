import { readFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join, resolve } from 'node:path';

/**
 * MCP-serverne brukeren har satt opp et annet sted, så Claude-panelet kan bruke dem selv om arbeidsmappa er
 * appens egen klone. `claude mcp add` uten `--scope user` lagrer serveren for mappa den ble lagt til i
 * (`projects["<sti>"].mcpServers` i `~/.claude.json`), og `.mcp.json` i et repo gjelder bare der.
 *
 * Innloggingen (OAuth-tokenet) er knyttet til servernavnet og URL-en, ikke til mappa, så en server som kommer inn
 * med `--mcp-config` under samme navn, er logget inn. Derfor beholdes navnet, og ved like navn vinner én av dem.
 * Vi skriver aldri til `~/.claude.json`.
 */

export type McpServer = Record<string, unknown>;
export type McpServers = Record<string, McpServer>;

/** Navnet på appens egen MCP-server (core/approve.ts); en server med samme navn fra brukeren tas ikke med */
export const OWN_SERVER = 'kravforvaltning';

/**
 * MCP-serverne Claude-panelet og utførekjøringen kan bruke, etter navnet brukeren har gitt dem i Claude Code.
 * Bare disse hentes fra andre mapper, bare verktøyene deres kan godkjennes i panelet (andre `mcp__*` avvises), og
 * bare de nevnes når de må logges inn. Navnet må være det samme som i Claude Code, siden innloggingen følger navnet.
 * En claude.ai-kobling har navnet fra verktøyene (`claude.ai Atlassian Rovo` → `claude_ai_Atlassian_Rovo`).
 */
export const MCP_SERVERS = ['figma', 'claude_ai_Atlassian_Rovo', 'chrome-devtools'];

/**
 * Verktøyene i `MCP_SERVERS` som bare leser, og som tillates uten spørsmål (`--allowedTools`). Alt annet, også nye
 * verktøy som ikke står her, spørres om i panelet. Navigering i chrome-devtools (`new_page`, `navigate_page`) står ikke
 * her: den går til en vilkårlig adresse med nettleserens innlogging, og spørres om som WebFetch.
 */
export const MCP_READONLY: Record<string, string[]> = {
  figma: [
    'whoami',
    'get_metadata',
    'get_screenshot',
    'get_design_context',
    'get_variable_defs',
    'get_figjam',
    'get_libraries',
    'get_motion_context',
    'get_code_connect_map',
    'get_code_connect_suggestions',
    'get_context_for_code_connect',
    'list_file_components_for_code_connect',
    'search_design_system',
    'get_shader',
    'list_shaders',
    'list_file_shaders',
    'get_generative_plugin',
    'list_generative_plugins',
  ],
  'chrome-devtools': [
    'list_pages',
    'select_page',
    'take_screenshot',
    'take_snapshot',
    'wait_for',
    'list_console_messages',
    'get_console_message',
    'list_network_requests',
    'get_network_request',
    'get_css_styles',
  ],
  // Atlassian-koblingen på claude.ai («claude.ai Atlassian Rovo»): logges inn på claude.ai, og lastes av Claude Code
  // uansett mappe, så den står ikke i ~/.claude.json. Verktøyene heter mcp__claude_ai_Atlassian_Rovo__<verktøy>.
  claude_ai_Atlassian_Rovo: [
    'atlassianUserInfo',
    'getTeamworkGraphContext',
    'getTeamworkGraphObject',
    'getAccessibleAtlassianResources',
    'search',
    'fetch',
    'getContentFormatGuide',
    'getConfluenceSpaces',
    'getConfluencePage',
    'getConfluencePageDescendants',
    'getConfluencePageFooterComments',
    'getConfluencePageInlineComments',
    'getConfluenceCommentChildren',
    'getPagesInConfluenceSpace',
    'searchConfluenceUsingCql',
    'getVisibleJiraProjects',
    'getJiraIssue',
    'getJiraIssueRemoteIssueLinks',
    'getJiraIssueTypeMetaWithFields',
    'getJiraProjectIssueTypesMetadata',
    'getTransitionsForJiraIssue',
    'getIssueLinkTypes',
    'lookupJiraAccountId',
    'searchJiraIssuesUsingJql',
  ],
};

/**
 * Verktøyene i `MCP_SERVERS` som tillates uten spørsmål bare når fs-verify kjøres: skjermbildene fra test-fsadmin
 * krever at fs-verify navigerer, klikker og trykker taster i nettleseren. Ellers spørres de om, som i `MCP_READONLY`.
 */
export const MCP_VERIFY: Record<string, string[]> = {
  'chrome-devtools': ['navigate_page', 'click', 'press_key'],
};

const toolNames = (tools: Record<string, string[]>): string[] =>
  MCP_SERVERS.flatMap(server => (tools[server] ?? []).map(tool => `mcp__${server}__${tool}`));

/** `MCP_READONLY` som verktøynavn (`mcp__figma__get_metadata`), for serverne i `MCP_SERVERS` */
export const readonlyTools = (): string[] => toolNames(MCP_READONLY);

/** `MCP_VERIFY` som verktøynavn (`mcp__chrome-devtools__navigate_page`), for serverne i `MCP_SERVERS` */
export const verifyTools = (): string[] => toolNames(MCP_VERIFY);

/** Serveren et `mcp__<server>__<verktøy>`-navn hører til */
export const mcpServerOf = (tool: string) => tool.match(/^mcp__([\w.-]+?)__[\w.-]+$/)?.[1] ?? null;

const isObj = (x: unknown): x is Record<string, unknown> => !!x && typeof x === 'object' && !Array.isArray(x);

/** En oppføring som kan startes: `url` (http, sse) eller `command` (stdio) */
const valid = (s: unknown): s is McpServer => isObj(s) && (typeof s.url === 'string' || typeof s.command === 'string');

/**
 * Slår sammen MCP-serverne på navn, bare de i `only` (`MCP_SERVERS`). Den første som har et navn, vinner, i denne rekkefølgen: user (`mcpServers` på
 * toppnivå i `~/.claude.json`), local for arbeidsmappa (`cwd`), `.mcp.json` i kodemappene, og local for andre mapper
 * (sortert på sti, så resultatet er det samme hver gang). User-scope slår altså alltid de andre.
 */
export function collectMcpServers(claudeJson: unknown, mcpJsons: { dir: string; json: unknown }[] = [], cwd = '', only: string[] = MCP_SERVERS): McpServers {
  const out: McpServers = {};
  const add = (servers: unknown) => {
    if (!isObj(servers)) return;
    for (const [name, s] of Object.entries(servers)) if (name !== OWN_SERVER && only.includes(name) && !(name in out) && valid(s)) out[name] = s;
  };
  const cj = isObj(claudeJson) ? claudeJson : {};
  const projects = isObj(cj.projects) ? cj.projects : {};
  const local = (p: string) => (isObj(projects[p]) ? (projects[p] as Record<string, unknown>).mcpServers : undefined);
  const here = cwd ? resolve(cwd) : '';
  add(cj.mcpServers);
  if (here) for (const p of Object.keys(projects)) if (resolve(p) === here) add(local(p));
  for (const m of mcpJsons) add(isObj(m.json) ? m.json.mcpServers : undefined);
  for (const p of Object.keys(projects).sort()) if (resolve(p) !== here) add(local(p));
  return out;
}

const readJson = (file: string): unknown => {
  try {
    return JSON.parse(readFileSync(file, 'utf8'));
  } catch {
    return null; // mangler eller er ødelagt: ingen servere derfra
  }
};

/** Leser `~/.claude.json` og `.mcp.json` i kodemappene, og slår dem sammen med `collectMcpServers` */
export function readMcpServers(cwd: string, dirs: string[] = [], home = homedir()): McpServers {
  return collectMcpServers(
    readJson(join(home, '.claude.json')),
    dirs.map(dir => ({ dir, json: readJson(join(dir, '.mcp.json')) })),
    cwd,
  );
}

/** Hemmelighetene skjult: verdiene i `headers` og `env`, og query-strengen i URL-en. Til alt som logges eller vises. */
export function redactServers(servers: McpServers): McpServers {
  const hide = (o: unknown) => (isObj(o) ? Object.fromEntries(Object.keys(o).map(k => [k, '•••'])) : o);
  return Object.fromEntries(
    Object.entries(servers).map(([name, s]) => [
      name,
      {
        ...s,
        ...(s.headers ? { headers: hide(s.headers) } : {}),
        ...(s.env ? { env: hide(s.env) } : {}),
        ...(typeof s.url === 'string' ? { url: s.url.replace(/[?#].*$/, '') } : {}),
      },
    ]),
  );
}
