import assert from 'node:assert/strict';
import { execFileSync, spawn } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync, writeFileSync, mkdirSync } from 'node:fs';
import { createServer, type Server } from 'node:http';
import type { AddressInfo } from 'node:net';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { after, before, test } from 'node:test';
import { ensureClone, isoVcs, lineStats } from './vcs-isogit.ts';

// isomorphic-git snakker bare HTTP(S), så testene bruker en lokal server foran `git http-backend`.
// Git trengs bare for å sette opp testen; backenden under test bruker det ikke.
const hasGit = (() => {
  try {
    execFileSync('git', ['--version']);
    return true;
  } catch {
    return false;
  }
})();

let root: string;
let server: Server;
let url: string;
const git = (cwd: string, ...args: string[]) => execFileSync('git', ['-C', cwd, ...args], { encoding: 'utf8' }).trim();

before(async () => {
  if (!hasGit) return;
  root = mkdtempSync(join(tmpdir(), 'krav-isogit-'));
  // Opphav med én commit på main
  const seed = join(root, 'seed');
  mkdirSync(join(seed, 'krav/01 A/10 B/01 C'), { recursive: true });
  writeFileSync(join(seed, 'krav/README.md'), '# Krav\n');
  writeFileSync(join(seed, 'krav/01 A/10 B/01 C/se_ting.feature'), '# language: no\nEgenskap: Se ting\n');
  writeFileSync(join(seed, 'annet.txt'), 'ikke krav\n');
  git(root, 'init', '-q', '-b', 'main', seed);
  git(seed, 'add', '.');
  git(seed, '-c', 'user.name=Test', '-c', 'user.email=t@example.com', 'commit', '-q', '-m', 'start');
  git(root, 'clone', '-q', '--bare', seed, join(root, 'origin.git'));
  git(join(root, 'origin.git'), 'config', 'http.receivepack', 'true');

  server = createServer((req, res) => {
    const [path, query = ''] = (req.url ?? '').split('?');
    const cgi = spawn('git', ['http-backend'], {
      env: {
        ...process.env,
        GIT_PROJECT_ROOT: root,
        GIT_HTTP_EXPORT_ALL: '1',
        PATH_INFO: path,
        QUERY_STRING: query,
        REQUEST_METHOD: req.method,
        CONTENT_TYPE: req.headers['content-type'] ?? '',
        REMOTE_USER: 'test',
      },
    });
    req.pipe(cgi.stdin);
    let head = Buffer.alloc(0);
    let done = false;
    cgi.stdout.on('data', (chunk: Buffer) => {
      if (done) return void res.write(chunk);
      head = Buffer.concat([head, chunk]);
      const end = head.indexOf('\r\n\r\n');
      if (end < 0) return;
      done = true;
      for (const line of head.subarray(0, end).toString().split('\r\n')) {
        const [k, ...v] = line.split(':');
        if (k.toLowerCase() === 'status') res.statusCode = parseInt(v.join(':'), 10);
        else res.setHeader(k, v.join(':').trim());
      }
      res.write(head.subarray(end + 4));
    });
    cgi.on('close', () => res.end());
  });
  await new Promise<void>(ok => server.listen(0, '127.0.0.1', ok));
  url = `http://127.0.0.1:${(server.address() as AddressInfo).port}/origin.git`;
});

after(() => {
  server?.close();
  if (root) rmSync(root, { recursive: true, force: true });
});

test('lineStats teller linjer lagt til og fjernet', () => {
  assert.deepEqual(lineStats('a\nb\nc\n', 'a\nc\nd\ne\n'), [2, 1]);
  assert.deepEqual(lineStats('', 'a\n'), [1, 0]);
  assert.deepEqual(lineStats('a\n', ''), [0, 1]);
});

test('klone, se endringer, publisere som branch og hente main', { skip: !hasGit && 'git mangler' }, async () => {
  const dir = join(root, 'app');
  assert.equal(await ensureClone(dir, url, null), true);
  assert.equal(await ensureClone(dir, url, null), false, 'klones bare én gang');
  git(dir, 'config', 'user.name', 'Redaktør');
  git(dir, 'config', 'user.email', 'r@example.com');

  const prs: { head: string; title: string }[] = [];
  const vcs = isoVcs(dir, { openPr: async (_u, _t, pr) => (prs.push(pr), 'https://example.com/pr/1') });

  const feature = 'krav/01 A/10 B/01 C/se_ting.feature';
  const fresh = 'krav/01 A/10 B/01 C/ny_ting.feature';
  writeFileSync(join(dir, feature), '# language: no\n@draft\nEgenskap: Se ting\n');
  writeFileSync(join(dir, fresh), '# language: no\nEgenskap: Ny\n');
  writeFileSync(join(dir, 'annet.txt'), 'endret, men ikke krav\n');

  const info = await vcs.info();
  assert.equal(info?.branch, 'main');
  assert.deepEqual(
    info?.uncommitted.map(c => [c.path, c.code, c.plus, c.minus]),
    [
      [fresh, 'U', 2, 0],
      [feature, 'M', 1, 0],
    ],
  );

  await assert.rejects(vcs.publish({ paths: [feature], branch: 'x', title: 't', body: '' }, null), /innlogget/);
  await assert.rejects(vcs.publish({ paths: ['annet.txt'], branch: 'x', title: 't', body: '' }, 'tok'), /Ugyldig sti/);

  const res = await vcs.publish({ paths: [feature, fresh], branch: 'Status på «Se ting»', title: 'Sett Se ting til draft', body: 'Fra vieweren' }, 'tok');
  assert.equal(res.branch, 'krav/status-pa-se-ting');
  assert.equal(res.url, 'https://example.com/pr/1');
  assert.deepEqual(prs, [{ head: 'krav/status-pa-se-ting', base: 'main', title: 'Sett Se ting til draft', body: 'Fra vieweren' }]);

  // Branchen på opphavet har begge krav-filene, men ikke den andre endringen
  const origin = join(root, 'origin.git');
  const show = (p: string) => git(origin, 'show', `krav/status-pa-se-ting:${p}`);
  assert.match(show(feature), /@draft/);
  assert.match(show(fresh), /Egenskap: Ny/);
  assert.equal(show('annet.txt'), 'ikke krav');
  assert.equal(git(origin, 'log', '-1', '--format=%an|%s', 'krav/status-pa-se-ting'), 'Redaktør|Sett Se ting til draft');

  // Arbeidskatalogen og HEAD er urørt, og den lokale branchen er ryddet bort
  assert.match(readFileSync(join(dir, feature), 'utf8'), /@draft/);
  assert.equal(git(dir, 'rev-parse', '--abbrev-ref', 'HEAD'), 'main');
  assert.equal(git(dir, 'branch', '--list', 'krav/*'), '');

  await assert.rejects(vcs.publish({ paths: [feature], branch: 'status-pa-se-ting', title: 't', body: '' }, 'tok'), /finnes allerede/);

  // Noen merger PR-en og endrer README på main; pull tar README, og lokale endringer blir stående
  const other = join(root, 'other');
  git(root, 'clone', '-q', join(root, 'origin.git'), other);
  git(other, 'merge', '-q', '--ff-only', 'origin/krav/status-pa-se-ting');
  writeFileSync(join(other, 'krav/README.md'), '# Krav\n\nOppdatert\n');
  git(other, '-c', 'user.name=A', '-c', 'user.email=a@example.com', 'commit', '-q', '-am', 'readme');
  git(other, 'push', '-q', 'origin', 'main');

  assert.equal(await vcs.behind!(null), true, 'main på GitHub er nyere');
  await vcs.pull!(null);
  assert.equal(await vcs.behind!(null), false, 'hentet');
  assert.match(readFileSync(join(dir, 'krav/README.md'), 'utf8'), /Oppdatert/);
  const afterPull = await vcs.info();
  assert.deepEqual(afterPull?.uncommitted, [], 'endringene er nå på main');
});
