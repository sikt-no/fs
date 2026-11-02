import assert from 'node:assert/strict';
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { readTasks } from './tasks.ts';

test('readTasks: en scope-mappe uten filer er ikke et scope, og scope.md leses med endringstidspunkt', () => {
  const root = mkdtempSync(join(tmpdir(), 'tasks-'));
  try {
    mkdirSync(join(root, 'tasks/opptak/aktiv'), { recursive: true });
    writeFileSync(join(root, 'tasks/opptak/aktiv/scope.md'), '# Scope: Aktiv\n');
    writeFileSync(join(root, 'tasks/opptak/scope-gammel.md'), '# Scope: Gammel\n');
    // Rester etter scopes som er slettet på main: tomme mapper, også med tomme undermapper
    mkdirSync(join(root, 'tasks/opptak/slettet'), { recursive: true });
    mkdirSync(join(root, 'tasks/opptak/slettet-med-spec/spec/krav-input/sketches'), { recursive: true });
    const snap = readTasks(root);
    assert.deepEqual(snap.tasks.map(t => t.slug), ['aktiv']);
    assert.equal(snap.tasks[0].sources['scope.md'], '# Scope: Aktiv\n');
    assert.equal(typeof snap.tasks[0].mtimes?.['scope.md'], 'number');
    assert.deepEqual(Object.keys(snap), ['domains', 'tasks'], 'scope-<slug>.md på domenenivå leses ikke');
  } finally {
    rmSync(root, { recursive: true, force: true });
  }
});
