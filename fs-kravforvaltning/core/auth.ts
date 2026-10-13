import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import type { AuthStatus } from '../shared/api.ts';

const exec = promisify(execFile);

/** Hvor tokenet fra device flow lagres. Electron krypterer det med safeStorage; dev-serveren holder det i minnet. */
export interface TokenStore {
  get(): Promise<string | null>;
  set(token: string | null): Promise<void>;
}

export function memoryStore(): TokenStore {
  let token: string | null = null;
  return { get: async () => token, set: async t => void (token = t) };
}

type Fetch = typeof fetch;

interface Pending {
  deviceCode: string;
  userCode: string;
  verificationUri: string;
  interval: number;
  expiresAt: number;
  nextPollAt: number;
}

/**
 * Innlogging mot GitHub med OAuth device flow: brukeren får en kode, åpner github.com/login/device og godkjenner.
 * Device flow krever bare `clientId` (ingen hemmelighet), så den passer i en desktop-app.
 * `useGh: true` (dev-serveren) bruker `gh auth token` når gh er innlogget, og trenger da ingen OAuth-klient.
 */
export function createAuth(opts: { clientId?: string | null; store: TokenStore; useGh?: boolean; fetch?: Fetch }) {
  const f = opts.fetch ?? fetch;
  const clientId = opts.clientId || null;
  let pending: Pending | null = null;
  // Brukernavnet til tokenene GitHub har godtatt
  const logins = new Map<string, string | null>();
  let expired = false;

  const ghToken = async () => {
    if (!opts.useGh) return null;
    try {
      return (await exec('gh', ['auth', 'token'])).stdout.trim() || null;
    } catch {
      return null;
    }
  };

  /**
   * Brukernavnet til tokenet, eller `null` når GitHub ikke svarte (f.eks. uten nett).
   * `false`: GitHub avviste tokenet (401), fordi det er trukket tilbake eller erstattet av en nyere innlogging.
   */
  const login = async (token: string): Promise<string | null | false> => {
    if (logins.has(token)) return logins.get(token)!;
    const res = await f('https://api.github.com/user', { headers: { authorization: `Bearer ${token}`, accept: 'application/vnd.github+json' } }).catch(() => null);
    if (res?.status === 401) return false;
    if (!res?.ok) return null; // prøv igjen neste gang
    const user = (await res.json()) as { login?: string };
    logins.set(token, user.login ?? null);
    return user.login ?? null;
  };

  /** Det lagrede tokenet, så lenge GitHub godtar det. Et avvist token slettes, så brukeren kan logge inn på nytt. */
  const stored = async () => {
    const token = await opts.store.get();
    if (!token) return null;
    const who = await login(token);
    if (who !== false) return { token, login: who };
    await opts.store.set(null);
    expired = true;
    return null;
  };
  const gh = async () => {
    const token = await ghToken();
    const who = token && (await login(token));
    return token && who !== false ? { token, login: who || null } : null;
  };

  const postForm = async (url: string, body: Record<string, string>) => {
    const res = await f(url, { method: 'POST', headers: { accept: 'application/json', 'content-type': 'application/json' }, body: JSON.stringify(body) });
    return (await res.json()) as Record<string, unknown>;
  };

  const pendingStatus = (p: Pending): AuthStatus => ({ state: 'pending', userCode: p.userCode, verificationUri: p.verificationUri, expiresAt: p.expiresAt });

  const auth = {
    /** Tokenet som skal brukes til push og PR, eller `null` */
    async token(): Promise<string | null> {
      return (await stored())?.token ?? (await gh())?.token ?? null;
    },

    async status(): Promise<AuthStatus> {
      const s = await stored();
      if (s) return { state: 'ok', login: s.login, source: 'device' };
      const g = await gh();
      if (g) return { state: 'ok', login: g.login, source: 'gh' };
      if (pending && pending.expiresAt > Date.now()) return pendingStatus(pending);
      return { state: 'none', canLogin: !!clientId, ...(expired ? { expired } : {}) };
    },

    async start(): Promise<AuthStatus> {
      if (!clientId) throw new Error('Innlogging er ikke satt opp: KRAV_GITHUB_CLIENT_ID mangler');
      const r = await postForm('https://github.com/login/device/code', { client_id: clientId, scope: 'repo' });
      if (typeof r.device_code !== 'string') throw new Error(`GitHub avviste innloggingen: ${r.error_description ?? r.error ?? 'ukjent feil'}`);
      const now = Date.now();
      pending = {
        deviceCode: r.device_code,
        userCode: String(r.user_code),
        verificationUri: String(r.verification_uri),
        interval: Number(r.interval ?? 5) * 1000,
        expiresAt: now + Number(r.expires_in ?? 900) * 1000,
        nextPollAt: now,
      };
      return pendingStatus(pending);
    },

    /** Klienten kaller denne jevnlig mens innloggingen venter. GitHubs intervall respekteres her. */
    async poll(): Promise<AuthStatus> {
      const p = pending;
      if (!p) return auth.status();
      if (p.expiresAt <= Date.now()) {
        pending = null;
        throw new Error('Koden gikk ut. Prøv å logge inn på nytt.');
      }
      if (Date.now() < p.nextPollAt) return pendingStatus(p);
      p.nextPollAt = Date.now() + p.interval;
      const r = await postForm('https://github.com/login/oauth/access_token', {
        client_id: clientId!,
        device_code: p.deviceCode,
        grant_type: 'urn:ietf:params:oauth:grant-type:device_code',
      });
      if (typeof r.access_token === 'string') {
        pending = null;
        expired = false;
        await opts.store.set(r.access_token);
        return auth.status();
      }
      if (r.error === 'authorization_pending') return pendingStatus(p);
      if (r.error === 'slow_down') {
        p.interval += 5000;
        return pendingStatus(p);
      }
      pending = null;
      throw new Error(r.error === 'access_denied' ? 'Innloggingen ble avbrutt på GitHub' : `Innloggingen feilet: ${r.error_description ?? r.error}`);
    },

    async logout(): Promise<AuthStatus> {
      pending = null;
      expired = false;
      await opts.store.set(null);
      return auth.status();
    },
  };
  return auth;
}
export type Auth = ReturnType<typeof createAuth>;
