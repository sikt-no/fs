import assert from 'node:assert/strict';
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { readTasks } from './tasks.ts';

test('readTasks: en oppgavemappe uten filer er ikke en oppgave', () => {
  const root = mkdtempSync(join(tmpdir(), 'tasks-'));
  try {
    mkdirSync(join(root, 'tasks/opptak/aktiv'), { recursive: true });
    writeFileSync(join(root, 'tasks/opptak/aktiv/oppgave.md'), '# Aktiv\n');
    // Rester etter oppgaver som er slettet på main: tomme mapper, også med tomme undermapper
    mkdirSync(join(root, 'tasks/opptak/slettet'), { recursive: true });
    mkdirSync(join(root, 'tasks/opptak/slettet-med-spec/spec/krav-input/sketches'), { recursive: true });
    assert.deepEqual(readTasks(root).tasks.map(t => t.slug), ['aktiv']);
  } finally {
    rmSync(root, { recursive: true, force: true });
  }
});
