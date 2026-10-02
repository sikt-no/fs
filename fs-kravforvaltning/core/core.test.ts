import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { after, test } from 'node:test';
import { deleteFile, kravPath, saveFile } from './save.ts';
import { cliVcs } from './vcs-cli.ts';
import { branchName, checkPaths, githubRepo } from './vcs.ts';

const tmp = mkdtempSync(join(tmpdir(), 'krav-core-'));
after(() => rmSync(tmp, { recursive: true, force: true }));

test('branchName lager krav/<slug> uten æøå og spesialtegn', () => {
  assert.equal(branchName('Status på «Se ting»'), 'krav/status-pa-se-ting');
  assert.equal(branchName('Ærlig søknad / Øvre grense'), 'krav/aerlig-soknad-ovre-grense');
  assert.equal(branchName('krav/allerede'), 'krav/krav-allerede');
  assert.throws(() => branchName('«»'), /tomt/);
  assert.ok(branchName('x'.repeat(100)).length <= 65);
});

test('githubRepo leser eier og repo fra https- og ssh-URL-er', () => {
  assert.deepEqual(githubRepo('https://github.com/sikt-no/fs.git'), { owner: 'sikt-no', repo: 'fs' });
  assert.deepEqual(githubRepo('git@github.com:sikt-no/fs.git'), { owner: 'sikt-no', repo: 'fs' });
  assert.deepEqual(githubRepo('https://github.com/sikt-no/fs'), { owner: 'sikt-no', repo: 'fs' });
  assert.equal(githubRepo('https://gitlab.com/sikt/fs.git'), null);
});

test('checkPaths godtar bare krav-filer under krav/', () => {
  checkPaths(['krav/a/b.feature', 'krav/README.md']);
  assert.throws(() => checkPaths([]), /minst én/);
  for (const bad of ['tester/x.ts', 'krav/../x.feature', 'krav//x.feature', 'krav/x.txt']) assert.throws(() => checkPaths([bad]), /Ugyldig/, bad);
});

test('kravPath avviser stier utenfor krav/ og andre filtyper', () => {
  const root = join(tmp, 'repo');
  assert.equal(kravPath(root, 'krav/01 A/x.feature'), join(root, 'krav/01 A/x.feature'));
  for (const bad of ['../krav/x.feature', 'krav/../tester/x.feature', '/etc/x.feature', 'tester/x.feature', 'krav/x.ts', 'krav\\x.feature', 'krav/./x.feature', '']) {
    assert.throws(() => kravPath(root, bad), Error, bad);
  }
});

test('saveFile skriver fila og lager mapper', async () => {
  const root = join(tmp, 'save');
  await saveFile(root, 'krav/01 A/10 B/ny.feature', 'Egenskap: Ny\n');
  assert.equal(readFileSync(join(root, 'krav/01 A/10 B/ny.feature'), 'utf8'), 'Egenskap: Ny\n');
  await assert.rejects(saveFile(root, 'krav/x.feature', undefined as unknown as string), /tekst/);
});

test('deleteFile sletter fila, og bare krav-filer under krav/', async () => {
  const root = join(tmp, 'delete');
  await saveFile(root, 'krav/01 A/10 B/borte.feature', 'Egenskap: Borte\n');
  await deleteFile(root, 'krav/01 A/10 B/borte.feature');
  assert.equal(existsSync(join(root, 'krav/01 A/10 B/borte.feature')), false);
  await assert.rejects(deleteFile(root, 'krav/01 A/10 B/borte.feature'), /ENOENT/);
  await assert.rejects(deleteFile(root, 'krav/../package.json'), /Ugyldig/);
});

test('cliVcs.publish lager branch fra origin/main i en worktree og lar arbeidskatalogen være', async () => {
  const git = (cwd: string, ...args: string[]) => execFileSync('git', ['-C', cwd, ...args], { encoding: 'utf8' }).trim();
  const id = ['-c', 'user.name=Test', '-c', 'user.email=t@example.com'];
  const seed = join(tmp, 'cli-seed');
  mkdirSync(join(seed, 'krav'), { recursive: true });
  writeFileSync(join(seed, 'krav/a.feature'), 'Egenskap: A\n');
  writeFileSync(join(seed, 'krav/b.feature'), 'Egenskap: B\n');
  git(tmp, 'init', '-q', '-b', 'main', seed);
  git(seed, 'add', '.');
  git(seed, ...id, 'commit', '-q', '-m', 'start');
  const origin = join(tmp, 'cli-origin.git');
  git(tmp, 'clone', '-q', '--bare', seed, origin);
  const repo = join(tmp, 'cli-repo');
  git(tmp, 'clone', '-q', origin, repo);
  git(repo, 'config', 'user.name', 'Redaktør');
  git(repo, 'config', 'user.email', 'r@example.com');

  // Brukeren står på en egen branch med ucommittede endringer
  git(repo, 'switch', '-q', '-c', 'mitt-arbeid');
  writeFileSync(join(repo, 'krav/a.feature'), 'Egenskap: A endret\n');
  writeFileSync(join(repo, 'krav/c.feature'), 'Egenskap: C\n');
  writeFileSync(join(repo, 'krav/b.feature'), 'Egenskap: B endret, men ikke med\n');

  const prs: unknown[] = [];
  const vcs = cliVcs(repo, { openPr: async (_u, _t, pr) => (prs.push(pr), 'https://example.com/pr/2') });
  await assert.rejects(vcs.publish({ paths: ['krav/a.feature'], branch: 'x', title: 't', body: '' }, null), /innlogget/);
  const res = await vcs.publish({ paths: ['krav/a.feature', 'krav/c.feature'], branch: 'Endre A', title: 'Endre A', body: '' }, 'tok');
  assert.deepEqual(res, { url: 'https://example.com/pr/2', branch: 'krav/endre-a' });
  assert.deepEqual(prs, [{ head: 'krav/endre-a', base: 'main', title: 'Endre A', body: '' }]);

  assert.equal(git(origin, 'show', 'krav/endre-a:krav/a.feature'), 'Egenskap: A endret');
  assert.equal(git(origin, 'show', 'krav/endre-a:krav/c.feature'), 'Egenskap: C');
  assert.equal(git(origin, 'show', 'krav/endre-a:krav/b.feature'), 'Egenskap: B');
  assert.equal(git(origin, 'log', '-1', '--format=%an', 'krav/endre-a'), 'Redaktør');

  // Arbeidskatalogen er urørt, og verken worktree eller lokal branch er igjen
  assert.equal(git(repo, 'rev-parse', '--abbrev-ref', 'HEAD'), 'mitt-arbeid');
  assert.equal(readFileSync(join(repo, 'krav/b.feature'), 'utf8'), 'Egenskap: B endret, men ikke med\n');
  assert.equal(git(repo, 'worktree', 'list').split('\n').length, 1);
  assert.equal(git(repo, 'branch', '--list', 'krav/*'), '');

  await assert.rejects(vcs.publish({ paths: ['krav/a.feature'], branch: 'endre-a', title: 't', body: '' }, 'tok'), /finnes allerede/);
});
