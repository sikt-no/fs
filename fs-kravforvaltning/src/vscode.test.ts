import assert from 'node:assert/strict';
import { test } from 'node:test';
import { vscodeUrl } from './vscode.ts';

test('vscodeUrl: mappe på macOS og Linux', () => {
  assert.equal(vscodeUrl('/Users/kari/Dev/sikt-no-fs'), 'vscode://file/Users/kari/Dev/sikt-no-fs');
});

test('vscodeUrl: mellomrom og æøå kodes', () => {
  assert.equal(vscodeUrl('/Users/kari/Mine krav/sø'), 'vscode://file/Users/kari/Mine%20krav/s%C3%B8');
});

test('vscodeUrl: Windows-sti', () => {
  assert.equal(vscodeUrl('C:\\Users\\kari\\fs'), 'vscode://file/C:/Users/kari/fs');
});

test('vscodeUrl: fil med linje', () => {
  assert.equal(vscodeUrl('/r/krav/a.feature', { line: 12 }), 'vscode://file/r/krav/a.feature:12');
});

test('vscodeUrl: nytt vindu', () => {
  assert.equal(vscodeUrl('/Users/kari/fs', { newWindow: true }), 'vscode://file/Users/kari/fs?windowId=_blank');
});
