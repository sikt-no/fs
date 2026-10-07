import assert from 'node:assert/strict';
import { test } from 'node:test';
import { answerFor, answersFor, parseQuestions, validAnswers, type Question } from './question.ts';

const opt = (label: string) => ({ label, description: `om ${label}` });
const q = (question: string, n = 2, multiSelect = false) => ({ question, header: 'H', multiSelect, options: ['A', 'B', 'C', 'D', 'E'].slice(0, n).map(opt) });

test('parseQuestions: formen AskUserQuestion beskriver', () => {
  const qs = parseQuestions({ questions: [q('Én?'), { ...q('To?', 3, true), options: [{ label: 'A', description: 'a', preview: 'kode' }, opt('B')] }] })!;
  assert.equal(qs.length, 2);
  assert.deepEqual(qs[0].options[0], { label: 'A', description: 'om A' });
  assert.equal(qs[1].multiSelect, true);
  assert.equal(qs[1].options[0].preview, 'kode');
  // Mangler beskrivelse eller etikett, er det greit
  assert.deepEqual(parseQuestions({ questions: [{ question: 'x', options: [{ label: 'a' }, { label: 'b' }] }] }), [
    { question: 'x', header: '', multiSelect: false, options: [{ label: 'a', description: '' }, { label: 'b', description: '' }] },
  ]);
});

test('parseQuestions: ugyldige spørsmål gir null', () => {
  for (const input of [
    null,
    {},
    { questions: [] },
    { questions: [q('1'), q('2'), q('3'), q('4'), q('5')] },
    { questions: [q('for få', 1)] },
    { questions: [q('for mange', 5)] },
    { questions: [{ ...q('x'), question: '' }] },
    { questions: [{ ...q('x'), options: [opt('A'), { description: 'uten label' }] }] },
    { questions: [q('Samme?'), q('Samme?')] },
  ])
    assert.equal(parseQuestions(input), null, JSON.stringify(input));
});

test('answerFor og answersFor: label, flervalg og «Annet»', () => {
  const one: Question = parseQuestions({ questions: [q('Én?', 3)] })![0];
  const many: Question = parseQuestions({ questions: [q('Flere?', 3, true)] })![0];
  assert.equal(answerFor(one, { labels: ['B'], other: '' }), 'B');
  assert.equal(answerFor(one, { labels: ['B'], other: ' egen tekst ' }), 'egen tekst', '«Annet» vinner ved enkeltvalg');
  assert.equal(answerFor(one, { labels: [], other: '  ' }), null);
  assert.equal(answerFor(one, undefined), null);
  assert.equal(answerFor(many, { labels: ['C', 'A'], other: '' }), 'A, C', 'i rekkefølgen valgene står');
  assert.equal(answerFor(many, { labels: ['A', 'ukjent'], other: 'mer' }), 'A, mer');
  assert.deepEqual(answersFor([one, many], { 'Én?': { labels: ['A'], other: '' }, 'Flere?': { labels: ['B'], other: '' } }), { 'Én?': 'A', 'Flere?': 'B' });
  assert.equal(answersFor([one, many], { 'Én?': { labels: ['A'], other: '' } }), null, 'alle må ha svar');
});

test('validAnswers: én tekst per spørsmål, og ikke noe annet', () => {
  const qs = parseQuestions({ questions: [q('Én?'), q('To?')] })!;
  assert.deepEqual(validAnswers(qs, { 'Én?': 'A', 'To?': 'fritt', annet: 'x' }), { 'Én?': 'A', 'To?': 'fritt' });
  assert.equal(validAnswers(qs, { 'Én?': 'A' }), null);
  assert.equal(validAnswers(qs, { 'Én?': 'A', 'To?': ' ' }), null);
  assert.equal(validAnswers(qs, { 'Én?': 'A', 'To?': 3 }), null);
  assert.equal(validAnswers(qs, null), null);
});
