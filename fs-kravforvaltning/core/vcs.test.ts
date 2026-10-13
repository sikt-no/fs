import assert from 'node:assert/strict';
import { test } from 'node:test';
import { onlyAppChanges } from './vcs.ts';

test('onlyAppChanges: bare når alle filene er i fs-kravforvaltning/', () => {
  assert.equal(onlyAppChanges(['fs-kravforvaltning/src/main.tsx', 'fs-kravforvaltning/package.json']), true);
  assert.equal(onlyAppChanges(['fs-kravforvaltning/src/main.tsx', 'krav/02 Opptak/README.md']), false);
  assert.equal(onlyAppChanges(['.github/workflows/kravforvaltning-release.yml']), false, 'workflowen ligger utenfor appen');
  assert.equal(onlyAppChanges([]), false, 'ingen filer: GitHub sa ikke hva som er endret');
  assert.equal(onlyAppChanges(Array.from({ length: 300 }, (_, i) => `fs-kravforvaltning/f${i}`)), false, 'avkortet liste');
});
