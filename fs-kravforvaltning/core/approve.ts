import { randomBytes } from 'node:crypto';
import { createServer, type IncomingMessage, type Server, type ServerResponse } from 'node:http';
import type { AddressInfo } from 'node:net';
import type { ClaudeApproveRequest, ClaudeEvent, ClaudePermission } from '../shared/api.ts';
import { MCP_SERVERS, mcpServerOf, OWN_SERVER, readonlyTools, type McpServer } from './mcp.ts';

/**
 * Appens egen MCP-server (`kravforvaltning`), som `claude` får med `--mcp-config`. Den har to verktøy:
 *
 * - `approve` er `--permission-prompt-tool`: Claude Code spør den om lov til alt som ikke står i `--allowedTools`
 *   eller `--disallowedTools`. `mcp__*`-verktøy (unntatt appens egne) og WebFetch går til brukeren som et kort i
 *   Claude-panelet (hendelsen `permission`), og alt annet avvises. Svaret er `{"behavior":"allow","updatedInput":…}`
 *   eller `{"behavior":"deny","message":…}`.
 * - `save_sketch` skriver et bilde fra et tidligere verktøykall (f.eks. `get_screenshot` i Figma) som binærfil under
 *   `tasks/<d>/<s>/spec/krav-input/…/sketches/`, siden Write bare kan skrive tekst.
 *
 * Serveren er streamable HTTP uten SSE (svarene er `application/json`) på 127.0.0.1, med én sti og ett hemmelig
 * token per kjøring, så kjøringer ikke blandes og andre prosesser ikke kan svare. Den virker likt i dev-serveren og
 * i desktop-appen, og startes første gang en kjøring trenger den.
 */

export const APPROVE_TOOL = `mcp__${OWN_SERVER}__approve`;
export const SAVE_SKETCH_TOOL = `mcp__${OWN_SERVER}__save_sketch`;
/** Hvor lenge et spørsmål venter på brukeren før kallet avvises */
export const APPROVE_TIMEOUT_MS = 5 * 60_000;

/** Verktøy brukeren kan godkjenne: WebFetch, og verktøyene til serverne i `MCP_SERVERS` */
export const isAskable = (tool: unknown): tool is string => {
  if (typeof tool !== 'string') return false;
  const server = mcpServerOf(tool);
  return tool === 'WebFetch' || (!!server && MCP_SERVERS.includes(server));
};

/**
 * Hva `approve` gjør med et kall: appens egne verktøy tillates, verktøy som bare leser (`MCP_READONLY`) og det
 * brukeren har tillatt alltid i samtalen, tillates, verktøyene til serverne i `MCP_SERVERS` og WebFetch spørres om, og alt annet avvises (også andre
 * MCP-servere Claude Code laster selv, f.eks. fra user scope). Alt som er tillatt eller avvist med
 * `--allowedTools`/`--disallowedTools`, kommer aldri hit.
 */
export function decide(tool: string, always: ReadonlySet<string>): 'allow' | 'ask' | 'deny' {
  if (tool.startsWith(`mcp__${OWN_SERVER}__`)) return 'allow';
  if (!isAskable(tool)) return 'deny';
  // Verktøy som bare leser, står i --allowedTools og kommer ikke hit; tillates også her, i tilfelle
  return always.has(tool) || readonlyTools().includes(tool) ? 'allow' : 'ask';
}

export const SECRET_KEY = /token|secret|password|passord|authorization|api[-_]?key|^key$|cookie/i;

/** Parametrene som vises på kortet: høyst 8, forkortet, og uten verdier for nøkler som ligner hemmeligheter */
export function shownInput(input: unknown): Record<string, string> {
  if (!input || typeof input !== 'object') return {};
  const out: Record<string, string> = {};
  for (const [k, v] of Object.entries(input as Record<string, unknown>).slice(0, 8)) {
    if (SECRET_KEY.test(k)) out[k] = '•••';
    else {
      const s = typeof v === 'string' ? v : JSON.stringify(v) ?? String(v);
      out[k] = s.length > 200 ? s.slice(0, 199) + '…' : s;
    }
  }
  return out;
}

export const DENY_MESSAGES = {
  user: 'Brukeren avviste kallet i FS Kravforvaltning. Ikke prøv igjen uten å spørre brukeren.',
  timeout: `Brukeren svarte ikke innen ${APPROVE_TIMEOUT_MS / 60_000} minutter, så kallet ble avvist. Spør brukeren om du skal prøve igjen.`,
  closed: 'Brukeren lukket Claude-panelet, så kallet ble avvist. Spør brukeren om du skal prøve igjen.',
  ended: 'Kjøringen ble avsluttet før brukeren svarte, så kallet ble avvist.',
} as const;
type DenyReason = keyof typeof DENY_MESSAGES;

type Decision = { behavior: 'allow'; updatedInput: unknown } | { behavior: 'deny'; message: string };

interface Pending {
  req: ClaudePermission;
  runId: string;
  input: unknown;
  done: (d: Decision) => void;
}

interface RunState {
  token: string;
  /** Panelet kan lagre skisser; en utførekjøring har bare `approve` */
  sketches: boolean;
  always: Set<string>;
}

export interface ApproverOpts {
  /** Sender en hendelse til vieweren, som `krav:claude` for kjøringen */
  emit: (runId: string, ev: ClaudeEvent) => void;
  /** Skriver bildet fra verktøykallet `toolUseId` til `path`; kaster med en melding Claude kan videreformidle */
  saveSketch?: (toolUseId: string, path: string) => Promise<string>;
  timeoutMs?: number;
}

const TOOLS = {
  approve: {
    name: 'approve',
    description: 'Intern: spør brukeren i FS Kravforvaltning om lov til et verktøykall.',
    inputSchema: {
      type: 'object',
      properties: { tool_name: { type: 'string' }, input: { type: 'object' }, tool_use_id: { type: 'string' } },
      required: ['tool_name', 'input'],
    },
  },
  save_sketch: {
    name: 'save_sketch',
    description:
      'Lagrer et bilde fra et tidligere verktøykall (f.eks. get_screenshot i Figma-MCP, take_screenshot i chrome-devtools, eller Read av et bilde) som fil i repoet. ' +
      'Bruk dette i stedet for Write for PNG og andre bilder. Uten tool_use_id lagres det siste bildet; kall derfor save_sketch rett etter verktøykallet som ga bildet. ' +
      'path er relativ til repoet, og må ligge under tasks/<domene>/<slug>/spec/krav-input/sketches/ eller tasks/<domene>/<slug>/spec/krav-input/changes/<dato>-<ref>/sketches/ ' +
      '(skisser), eller tasks/<domene>/<slug>/spec/verify-<dato>/ (skjermbilder fra fs-verify), med .png, .jpg eller .webp.',
    inputSchema: {
      type: 'object',
      properties: {
        tool_use_id: { type: 'string', description: 'ID-en til verktøykallet som ga bildet. Utelatt: det siste bildet' },
        path: { type: 'string', description: 'Fila som skal skrives, relativ til repoet' },
      },
      required: ['path'],
    },
  },
};

export class Approver {
  private server: Server | null = null;
  private port: Promise<number> | null = null;
  private readonly runs = new Map<string, RunState>();
  private readonly waiting = new Map<string, Pending>();
  private seq = 0;
  private readonly opts: ApproverOpts;

  constructor(opts: ApproverOpts) {
    this.opts = opts;
  }

  private start(): Promise<number> {
    this.port ??= new Promise((ok, fail) => {
      const server = createServer((req, res) => void this.handle(req, res));
      server.on('error', fail);
      server.listen(0, '127.0.0.1', () => ok((server.address() as AddressInfo).port));
      // Serveren skal ikke holde prosessen i live alene (tester, og når dev-serveren eller appen avsluttes)
      server.unref();
      this.server = server;
    });
    return this.port;
  }

  /**
   * Melder på en kjøring, og gir oppføringen til `--mcp-config`. `always`: verktøyene brukeren har tillatt alltid
   * i samtalen.
   */
  async register(runId: string, opts: { always?: string[]; sketches?: boolean } = {}): Promise<McpServer> {
    const port = await this.start();
    const token = randomBytes(24).toString('hex');
    this.runs.set(runId, { token, sketches: opts.sketches ?? true, always: new Set((opts.always ?? []).filter(isAskable)) });
    return { type: 'http', url: `http://127.0.0.1:${port}/mcp/${encodeURIComponent(runId)}`, headers: { Authorization: `Bearer ${token}` } };
  }

  /** Kjøringen er ferdig eller avbrutt: spørsmål som venter, avvises */
  unregister(runId: string, reason: DenyReason = 'ended') {
    this.runs.delete(runId);
    for (const p of [...this.waiting.values()]) if (p.runId === runId) this.finish(p, { behavior: 'deny', message: DENY_MESSAGES[reason] }, reason);
  }

  /** Spørsmålene som venter på brukeren, så kortene kommer tilbake etter en omlasting */
  pending(): { runId: string; event: ClaudePermission }[] {
    return [...this.waiting.values()].map(p => ({ runId: p.runId, event: p.req }));
  }

  /** Brukerens svar fra kortet. `always`: verktøyet tillates resten av kjøringen, uten å spørre */
  answer(a: ClaudeApproveRequest) {
    const p = a && typeof a.id === 'string' ? this.waiting.get(a.id) : undefined;
    if (!p) return false;
    if (a.behavior === 'allow') {
      if (a.always) {
        this.runs.get(p.runId)?.always.add(p.req.tool);
        // Andre spørsmål om samme verktøy i kjøringen gjelder også
        for (const o of [...this.waiting.values()]) if (o !== p && o.runId === p.runId && o.req.tool === p.req.tool) this.finish(o, { behavior: 'allow', updatedInput: o.input }, 'user');
      }
      this.finish(p, { behavior: 'allow', updatedInput: p.input }, 'user');
    } else {
      const reason: DenyReason = a.reason === 'closed' ? 'closed' : 'user';
      this.finish(p, { behavior: 'deny', message: DENY_MESSAGES[reason] }, reason);
    }
    return true;
  }

  private finish(p: Pending, d: Decision, reason: DenyReason) {
    if (!this.waiting.delete(p.req.id)) return;
    p.done(d);
    this.opts.emit(p.runId, { kind: 'permissionDone', id: p.req.id, behavior: d.behavior, reason: d.behavior === 'deny' ? reason : 'user' });
  }

  /** Svaret på et kall til `approve` */
  async approve(runId: string, args: Record<string, unknown>): Promise<Decision> {
    const run = this.runs.get(runId);
    const tool = typeof args.tool_name === 'string' ? args.tool_name : '';
    const input = args.input ?? {};
    const d = run ? decide(tool, run.always) : 'deny';
    if (d === 'allow') return { behavior: 'allow', updatedInput: input };
    if (d === 'deny') return { behavior: 'deny', message: `«${tool || 'ukjent verktøy'}» er ikke tillatt i FS Kravforvaltning.` };
    const req: ClaudePermission = {
      kind: 'permission',
      id: `${runId}:${++this.seq}`,
      tool,
      input: shownInput(input),
      toolUseId: typeof args.tool_use_id === 'string' ? args.tool_use_id : null,
    };
    return new Promise<Decision>(ok => {
      const timer = setTimeout(() => this.finish(p, { behavior: 'deny', message: DENY_MESSAGES.timeout }, 'timeout'), this.opts.timeoutMs ?? APPROVE_TIMEOUT_MS);
      const p: Pending = {
        req,
        runId,
        input,
        done: d => {
          clearTimeout(timer);
          ok(d);
        },
      };
      this.waiting.set(req.id, p);
      this.opts.emit(runId, req);
    });
  }

  private async call(runId: string, run: RunState, name: unknown, args: Record<string, unknown>) {
    const text = (t: string, isError = false) => ({ content: [{ type: 'text', text: t }], ...(isError ? { isError } : {}) });
    if (name === 'approve') return text(JSON.stringify(await this.approve(runId, args)));
    if (name === 'save_sketch' && run.sketches && this.opts.saveSketch) {
      try {
        const path = await this.opts.saveSketch(String(args.tool_use_id ?? ''), String(args.path ?? ''));
        return text(`Lagret ${path}`);
      } catch (e) {
        return text(e instanceof Error ? e.message : String(e), true);
      }
    }
    throw Object.assign(new Error(`Ukjent verktøy: ${String(name)}`), { code: -32602 });
  }

  private async rpc(runId: string, run: RunState, m: any): Promise<object | null> {
    if (!m || typeof m !== 'object' || m.id === undefined || m.id === null) return null; // varsel: ingen svar
    const ok = (result: unknown) => ({ jsonrpc: '2.0', id: m.id, result });
    try {
      switch (m.method) {
        case 'initialize':
          return ok({
            protocolVersion: typeof m.params?.protocolVersion === 'string' ? m.params.protocolVersion : '2025-06-18',
            capabilities: { tools: {} },
            serverInfo: { name: OWN_SERVER, version: '1' },
          });
        case 'ping':
          return ok({});
        case 'tools/list':
          return ok({ tools: run.sketches && this.opts.saveSketch ? [TOOLS.approve, TOOLS.save_sketch] : [TOOLS.approve] });
        case 'tools/call':
          return ok(await this.call(runId, run, m.params?.name, m.params?.arguments ?? {}));
        default:
          return { jsonrpc: '2.0', id: m.id, error: { code: -32601, message: `Ukjent metode: ${m.method}` } };
      }
    } catch (e) {
      return { jsonrpc: '2.0', id: m.id, error: { code: (e as { code?: number }).code ?? -32603, message: e instanceof Error ? e.message : String(e) } };
    }
  }

  private async handle(req: IncomingMessage, res: ServerResponse) {
    const end = (code: number, body?: unknown) => {
      res.statusCode = code;
      if (body === undefined) return res.end();
      res.setHeader('content-type', 'application/json');
      res.end(JSON.stringify(body));
    };
    const port = (this.server?.address() as AddressInfo | null)?.port;
    // Bare til 127.0.0.1 med riktig port (ikke en nettside som har fått et annet navn til å peke hit)
    if (req.headers.host !== `127.0.0.1:${port}` && req.headers.host !== `localhost:${port}`) return end(403);
    const m = (req.url ?? '').match(/^\/mcp\/([^/?#]+)$/);
    const runId = m ? decodeURIComponent(m[1]) : '';
    const run = this.runs.get(runId);
    if (!run || req.headers.authorization !== `Bearer ${run.token}`) return end(401);
    if (req.method !== 'POST') return end(405); // ingen SSE-strøm og ingen sesjoner å avslutte
    let body = '';
    for await (const chunk of req) {
      body += chunk;
      if (body.length > 1_000_000) return end(413);
    }
    let msg: unknown;
    try {
      msg = JSON.parse(body);
    } catch {
      return end(400, { jsonrpc: '2.0', id: null, error: { code: -32700, message: 'Ugyldig JSON' } });
    }
    const list = Array.isArray(msg) ? msg : [msg];
    const out = (await Promise.all(list.map(x => this.rpc(runId, run, x)))).filter(Boolean);
    if (!out.length) return end(202);
    end(200, Array.isArray(msg) ? out : out[0]);
  }

  close() {
    for (const id of [...this.runs.keys()]) this.unregister(id, 'ended');
    this.server?.close();
    this.server = null;
    this.port = null;
  }
}
