import assert from 'node:assert/strict';
import { test } from 'node:test';
import { apply, chooseSkill, contextLabel, effectiveSkill, EMPTY_CHAT, send, started } from './claudeChat.ts';

test('en kjøring bygger samtalen: melding, verktøy, svar og ferdig', () => {
  let c = started(send(EMPTY_CHAT, 'Sett status', 'krav/a.feature').chat, 'r1');
  c = apply(c, 'r1', { kind: 'init', sessionId: 's1', model: null, skills: [] });
  c = apply(c, 'r1', { kind: 'tool', id: 't1', name: 'Edit', summary: 'krav/a.feature' });
  c = apply(c, 'r1', { kind: 'toolResult', id: 't1', isError: false });
  c = apply(c, 'r1', { kind: 'text', text: 'Gjort.' });
  c = apply(c, 'r1', { kind: 'done', ok: true, sessionId: 's1', durationMs: 2500, turns: 3, error: null });
  assert.equal(c.sessionId, 's1');
  assert.equal(c.runId, null);
  assert.deepEqual(c.touched, ['krav/a.feature']);
  assert.deepEqual(c.items.map(i => i.kind), ['user', 'tool', 'assistant', 'done']);
  assert.deepEqual(c.items[1], { kind: 'tool', id: 't1', name: 'Edit', summary: 'krav/a.feature', state: 'ok' });
  assert.deepEqual(c.items[3], { kind: 'done', ok: true, text: 'Ferdig · 3 steg · 2.5 s' });
});

test('hendelser fra andre kjøringer ignoreres, og avbrutte verktøy markeres som feil', () => {
  let c = started(EMPTY_CHAT, 'r2');
  assert.equal(apply(c, 'r1', { kind: 'text', text: 'gammel' }), c);
  c = apply(c, 'r2', { kind: 'tool', id: 't', name: 'Read', summary: 'krav/x.md' });
  c = apply(c, 'r2', { kind: 'done', ok: false, sessionId: null, durationMs: null, turns: null, error: 'Avbrutt' });
  assert.equal((c.items[0] as { state: string }).state, 'error');
  assert.deepEqual(c.items[1], { kind: 'done', ok: false, text: 'Avbrutt' });
  assert.deepEqual(c.touched, [], 'Read endrer ikke filer');
});

import { applyEvent, createConversation, currentChat, NO_CONVERSATIONS, removeConversation, restoreConversations, selectConversation, titleOf, updateConversation } from './claudeChat.ts';

test('flere samtaler: ny, tittel fra første melding, bytte og slette', () => {
  let cs = createConversation(NO_CONVERSATIONS, 'a', 1);
  assert.equal(createConversation(cs, 'x', 2).list.length, 1, 'tom samtale gjenbrukes');
  cs = updateConversation(cs, 'a', c => started(send(c, 'Rett avvikene\ni fila', null).chat, 'r1'), 2);
  assert.equal(cs.list[0].title, 'Rett avvikene');
  cs = createConversation(cs, 'b', 3);
  assert.deepEqual(cs.list.map(c => c.id), ['b', 'a']);
  assert.equal(cs.current, 'b');
  // Hendelser havner i samtalen som eier kjøringen, selv om en annen er åpen
  cs = applyEvent(cs, 'r1', { kind: 'text', text: 'Ok' }, 4) as typeof cs;
  assert.equal(cs.list.find(c => c.id === 'a')!.chat.items.at(-1)!.kind, 'assistant');
  assert.equal(applyEvent(cs, 'ukjent', { kind: 'text', text: 'x' }, 5), false);
  cs = selectConversation(cs, 'a');
  assert.equal(currentChat(cs)!.id, 'a');
  cs = removeConversation(cs, 'a');
  assert.deepEqual([cs.list.map(c => c.id), cs.current], [['b'], 'b']);
  assert.deepEqual(removeConversation(cs, 'b'), { list: [], current: null });
});

test('ny melding flytter samtalen øverst', () => {
  let cs = createConversation(NO_CONVERSATIONS, 'a', 1);
  cs = updateConversation(cs, 'a', c => send(c, 'første', null).chat, 1);
  cs = createConversation(cs, 'b', 2);
  cs = updateConversation(cs, 'b', c => send(c, 'andre', null).chat, 2);
  cs = updateConversation(cs, 'a', c => send(c, 'tredje', null).chat, 3);
  assert.deepEqual(cs.list.map(c => c.id), ['a', 'b']);
});

test('titleOf korter ned lange meldinger', () => {
  assert.equal(titleOf('  hei  der  '), 'hei der');
  assert.equal(titleOf('x'.repeat(80)).length, 58);
  assert.equal(titleOf('   '), 'Ny samtale');
});

test('restoreConversations beholder pågående kjøringer og avslutter de som er borte', () => {
  const stored = {
    current: 'b',
    list: [
      { id: 'a', title: 'A', createdAt: 1, updatedAt: 1, chat: { ...EMPTY_CHAT, runId: 'lever', items: [{ kind: 'user', text: 'x', path: null }] } },
      { id: 'b', title: 'B', createdAt: 1, updatedAt: 1, chat: { ...EMPTY_CHAT, runId: 'borte', items: [{ kind: 'tool', id: 't', name: 'Read', summary: 's', state: 'running' }] } },
      { id: 3 },
    ],
  };
  const cs = restoreConversations(JSON.parse(JSON.stringify(stored)), ['lever']);
  assert.equal(cs.list.length, 2);
  assert.equal(cs.list[0].chat.runId, 'lever');
  assert.equal(cs.list[1].chat.runId, null);
  assert.deepEqual(cs.list[1].chat.items.map(i => i.kind), ['tool', 'done']);
  assert.equal(cs.current, 'b');
  assert.deepEqual(restoreConversations('tull', []), NO_CONVERSATIONS);
});

test('valgt skill lastes med første melding, og på nytt når den byttes', () => {
  let c = chooseSkill(EMPTY_CHAT, 'fs-krav');
  let r = send(c, 'a', null);
  assert.equal(r.invoke, true);
  assert.equal(r.chat.items[0].kind === 'user' && r.chat.items[0].skill, 'fs-krav');
  r = send(r.chat, 'b', null);
  assert.equal(r.invoke, false, 'allerede lastet');
  r = send(chooseSkill(r.chat, 'fs-specify'), 'c', null);
  assert.equal(r.invoke, true);
  assert.equal(send(chooseSkill(r.chat, null), 'd', null).invoke, false, 'ingen skill');
  assert.equal(chooseSkill(c, 'fs-krav'), c);
  assert.equal(createConversation(NO_CONVERSATIONS, 'n', 1, 'fs-specify').list[0].chat.skill, 'fs-specify');
});

test('effectiveSkill: bare tillatte skills gjelder, ellers den første tillatte', () => {
  assert.equal(effectiveSkill('fs-specify', ['fs-krav']), 'fs-krav');
  assert.equal(effectiveSkill(null, ['fs-krav']), 'fs-krav');
  assert.equal(effectiveSkill('fs-specify', ['fs-krav', 'fs-specify']), 'fs-specify');
  assert.equal(effectiveSkill('fs-krav', []), null);
  // Oppgaver: ingen forhåndsvalgt
  assert.equal(effectiveSkill(null, ['fs-krav', 'fs-verify'], false), null);
  assert.equal(effectiveSkill('fs-specify', ['fs-krav'], false), null);
  assert.equal(effectiveSkill('fs-verify', ['fs-krav', 'fs-verify'], false), 'fs-verify');
});

test('kontekstbruk og lastede skills følges gjennom samtalen', () => {
  let c = started(send(chooseSkill(EMPTY_CHAT, 'fs-krav'), 'a', null).chat, 'r');
  assert.deepEqual(c.loadedSkills, ['fs-krav'], 'lastet med /fs-krav');
  c = apply(c, 'r', { kind: 'usage', tokens: 40000 });
  c = apply(c, 'r', { kind: 'tool', id: 's1', name: 'Skill', summary: 'fs-oppgave' });
  c = apply(c, 'r', { kind: 'toolResult', id: 's1', isError: true });
  c = apply(c, 'r', { kind: 'tool', id: 's2', name: 'Skill', summary: 'fs-specify' });
  c = apply(c, 'r', { kind: 'toolResult', id: 's2', isError: false });
  c = apply(c, 'r', { kind: 'usage', tokens: 59000 });
  c = apply(c, 'r', { kind: 'done', ok: true, sessionId: 's', durationMs: 1, turns: 1, error: null, contextWindow: 1000000 });
  assert.deepEqual(c.loadedSkills, ['fs-krav', 'fs-specify'], 'stoppede kall teller ikke');
  assert.deepEqual(c.context, { used: 59000, window: 1000000 });
  assert.equal(contextLabel(c.context!), '59k av 1M · 6 %');
  assert.equal(contextLabel({ used: 150000, window: 200000 }), '150k av 200k · 75 %');
  assert.equal(contextLabel({ used: 800, window: null }), '800');
});
