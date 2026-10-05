import assert from 'node:assert/strict';
import { test } from 'node:test';
import { EMPTY_DRAFT, isEmptyDraft, parseDraft } from './claudeDraft.ts';

test('parseDraft leser et lagret utkast', () => {
  const d = { text: 'Hei', mentions: ['krav/a.feature', 'krav/b'], excluded: 'krav/c.feature', pending: 'fs-verify' };
  assert.deepEqual(parseDraft(d), d);
});

test('parseDraft tåler manglende og ødelagt innhold', () => {
  assert.deepEqual(parseDraft(null), EMPTY_DRAFT);
  assert.deepEqual(parseDraft('tekst'), EMPTY_DRAFT);
  assert.deepEqual(parseDraft({ text: 3, mentions: ['krav/a', 4, null], excluded: 1, pending: {} }), {
    text: '',
    mentions: ['krav/a'],
    excluded: null,
    pending: null,
  });
});

test('isEmptyDraft er sann bare når ingenting er fylt ut', () => {
  assert.equal(isEmptyDraft(EMPTY_DRAFT), true);
  assert.equal(isEmptyDraft({ ...EMPTY_DRAFT, text: 'x' }), false);
  assert.equal(isEmptyDraft({ ...EMPTY_DRAFT, mentions: ['krav/a'] }), false);
  assert.equal(isEmptyDraft({ ...EMPTY_DRAFT, excluded: 'krav/a.feature' }), false);
  assert.equal(isEmptyDraft({ ...EMPTY_DRAFT, pending: 'fs-krav' }), false);
});
