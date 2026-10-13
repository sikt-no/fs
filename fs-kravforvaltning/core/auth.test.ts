import assert from 'node:assert/strict';
import { test } from 'node:test';
import { createAuth, memoryStore } from './auth.ts';

/** GitHub som godtar tokenene i `valid`, og svarer 401 på resten */
const github = (valid: Record<string, string>) => {
  let calls = 0;
  const fetch = (async (_url: string, init?: RequestInit) => {
    calls++;
    const token = String((init?.headers as Record<string, string>).authorization).replace('Bearer ', '');
    return token in valid ? new Response(JSON.stringify({ login: valid[token] })) : new Response('{}', { status: 401 });
  }) as typeof globalThis.fetch;
  return { fetch, calls: () => calls };
};

test('status: et lagret token GitHub godtar, gir innlogget med brukernavn', async () => {
  const store = memoryStore();
  await store.set('gho_ok');
  const gh = github({ gho_ok: 'mats' });
  const auth = createAuth({ clientId: 'Ov23x', store, fetch: gh.fetch });
  assert.deepEqual(await auth.status(), { state: 'ok', login: 'mats', source: 'device' });
  assert.equal(await auth.token(), 'gho_ok');
  assert.equal(gh.calls(), 1); // brukernavnet huskes
});

test('status: et token GitHub avviser (401), slettes, og brukeren kan logge inn på nytt', async () => {
  const store = memoryStore();
  await store.set('gho_revoked');
  const auth = createAuth({ clientId: 'Ov23x', store, fetch: github({}).fetch });
  assert.deepEqual(await auth.status(), { state: 'none', canLogin: true, expired: true });
  assert.equal(await store.get(), null);
  assert.equal(await auth.token(), null);
});

test('token: et avvist token brukes ikke til push og PR', async () => {
  const store = memoryStore();
  await store.set('gho_revoked');
  const auth = createAuth({ clientId: 'Ov23x', store, fetch: github({}).fetch });
  assert.equal(await auth.token(), null);
  assert.equal(await store.get(), null);
});

test('status: uten svar fra GitHub regnes tokenet som gyldig, uten brukernavn', async () => {
  const store = memoryStore();
  await store.set('gho_ok');
  const offline = (async () => {
    throw new Error('offline');
  }) as typeof globalThis.fetch;
  const auth = createAuth({ clientId: 'Ov23x', store, fetch: offline });
  assert.deepEqual(await auth.status(), { state: 'ok', login: null, source: 'device' });
  assert.equal(await store.get(), 'gho_ok');
});
