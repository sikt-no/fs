import assert from 'node:assert/strict';
import { test } from 'node:test';
import { ago, bannerShown, mainInfoText } from './mainStatus.ts';

const now = Date.parse('2026-09-30T12:00:00Z');

test('ago gir relativ tid', () => {
  assert.equal(ago('2026-09-30T11:59:40Z', now), 'nå nettopp');
  assert.equal(ago('2026-09-30T12:05:00Z', now), 'nå nettopp', 'klokka på maskinen går etter');
  assert.equal(ago('2026-09-30T11:56:00Z', now), 'for 4 min siden');
  assert.equal(ago('2026-09-30T10:00:00Z', now), 'for 2 t siden');
  assert.equal(ago('2026-09-29T11:00:00Z', now), 'for 1 dag siden');
  assert.equal(ago('2026-09-27T12:00:00Z', now), 'for 3 dager siden');
});

test('mainInfoText viser commits, krav og siste endring', () => {
  assert.equal(
    mainInfoText({ commits: 3, features: 7, author: '@kari', date: '2026-09-30T11:56:00Z' }, now),
    '3 nye commits på main · 7 .feature-filer endret · sist av @kari for 4 min siden',
  );
  assert.equal(mainInfoText({ commits: 1, features: 1, author: '@kari', date: null }, now), '1 ny commit på main · 1 .feature-fil endret · sist av @kari');
  assert.equal(mainInfoText({ commits: 2, features: 0, author: null, date: '2026-09-30T10:00:00Z' }, now), '2 nye commits på main · sist for 2 t siden');
  assert.equal(mainInfoText({ commits: 2, features: 0, author: null, date: null }, now), '2 nye commits på main');
});

test('bannerShown skjuler banneret for commiten brukeren valgte «Senere» på', () => {
  assert.equal(bannerShown(null, null), false);
  assert.equal(bannerShown({ behind: false }, null), false);
  assert.equal(bannerShown({ behind: true, remote: 'abc' }, null), true);
  assert.equal(bannerShown({ behind: true, remote: 'abc' }, 'abc'), false);
  assert.equal(bannerShown({ behind: true, remote: 'def' }, 'abc'), true, 'ny commit på main');
});
