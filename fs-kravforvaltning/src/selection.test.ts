import assert from 'node:assert/strict';
import { test } from 'node:test';
import { appendQuote, cleanSelection, lineLabel, lineRange, quoteForChat } from './selection.ts';

test('cleanSelection fjerner harde mellomrom, mellomrom i linjeslutt og tomme linjer i endene', () => {
  assert.equal(cleanSelection('\n\n  Når jeg velger  \nSå er rollen tildelt \n\n'), 'Når jeg velger\nSå er rollen tildelt');
  assert.equal(cleanSelection(' \n \n'), '');
});

test('lineRange gir minste og største linje, og hopper over det som mangler', () => {
  assert.deepEqual(lineRange([14, null, 12, 13, undefined]), { from: 12, to: 14 });
  assert.deepEqual(lineRange([7]), { from: 7, to: 7 });
  assert.equal(lineRange([null, NaN, 0]), null);
});

test('lineLabel', () => {
  assert.equal(lineLabel(12, 12), '12');
  assert.equal(lineLabel(12, 14), '12–14');
});

test('quoteForChat har fila og linjene først, og sitatet etter', () => {
  assert.equal(
    quoteForChat('Når jeg velger\nSå er rollen tildelt', 'krav/a/b.feature', 12, 13),
    '`krav/a/b.feature:12–13`\n> Når jeg velger\n> Så er rollen tildelt',
  );
  assert.equal(quoteForChat('Gitt', 'krav/a/b.feature', 6, 6), '`krav/a/b.feature:6`\n> Gitt');
});

test('appendQuote legger sitatet etter teksten i feltet', () => {
  assert.equal(appendQuote('', 'S'), 'S\n');
  assert.equal(appendQuote('  \n', 'S'), 'S\n');
  assert.equal(appendQuote('Se på dette:\n', 'S'), 'Se på dette:\n\nS\n');
});
