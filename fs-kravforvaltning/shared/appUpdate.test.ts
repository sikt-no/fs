import assert from 'node:assert/strict';
import { test } from 'node:test';
import { compareVersions, latestReleaseTag, updateToastShown } from './appUpdate.ts';

const rel = (tag_name: string, draft = false, prerelease = false) => ({ tag_name, draft, prerelease });

test('compareVersions: tallene sammenlignes, ikke teksten', () => {
  assert.ok(compareVersions('1.10.0', '1.9.0') > 0);
  assert.ok(compareVersions('1.1.0', '1.1.1') < 0);
  assert.equal(compareVersions('2.0.0', '2.0.0'), 0);
});

test('latestReleaseTag: nyeste publiserte release av appen', () => {
  assert.equal(
    latestReleaseTag([rel('fs-kravforvaltning-v1.1.0'), rel('fs-kravforvaltning-v1.10.0'), rel('fs-kravforvaltning-v1.9.0')]),
    'fs-kravforvaltning-v1.10.0',
  );
});

test('latestReleaseTag: hopper over drafts, prereleaser og andre releaser i repoet', () => {
  assert.equal(
    latestReleaseTag([
      rel('fs-kravforvaltning-v2.0.0', true),
      rel('fs-kravforvaltning-v1.3.0', false, true),
      rel('v9.0.0'),
      rel('fs-kravforvaltning-v1.2.0-beta'),
      rel('fs-kravforvaltning-v1.2.0'),
    ]),
    'fs-kravforvaltning-v1.2.0',
  );
  assert.equal(latestReleaseTag([rel('v1.0.0')]), null);
  assert.equal(latestReleaseTag([]), null);
});

test('updateToastShown: skjules med «Senere» bare for den versjonen', () => {
  assert.equal(updateToastShown(null, null), false);
  assert.equal(updateToastShown('1.2.0', null), true);
  // «Senere»: kortet er skjult, og knappen i toppfeltet står i stedet
  assert.equal(updateToastShown('1.2.0', '1.2.0'), false);
  // En nyere versjon gir kortet igjen
  assert.equal(updateToastShown('1.3.0', '1.2.0'), true);
});
