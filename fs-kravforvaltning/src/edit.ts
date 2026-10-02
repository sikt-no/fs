import { STATUSES, type GitInfo, type Status } from '../shared/model.ts';

export const PRIORITIES = ['must', 'should', 'could', 'wont'] as const;
export type Priority = (typeof PRIORITIES)[number];

/** Statustagger som byttes ut når statusen settes; `@levert` er den gamle formen av `@implemented` */
const STATUS_TAGS = [...STATUSES.map(s => '@' + s), '@levert'];
const PRIORITY_TAGS = PRIORITIES.map(p => '@' + p);

const EGENSKAP = /^(\s*)Egenskap:\s?(.*)$/;
const eol = (text: string) => (text.includes('\r\n') ? '\r\n' : '\n');

/** Hodet i en .feature-fil: linja med `Egenskap:` og tag-linjene rett over den */
export interface FeatureHead {
  line: number; // 0-basert indeks for Egenskap-linja
  tagLines: number[]; // 0-baserte indekser, øverst først
  tags: string[];
  title: string;
  status: Status | null;
  priority: Priority | null;
}

export function readHead(text: string): FeatureHead | null {
  const lines = text.split(/\r?\n/);
  const line = lines.findIndex(l => EGENSKAP.test(l));
  if (line < 0) return null;
  const tagLines: number[] = [];
  for (let i = line - 1; i >= 0; i--) {
    const t = lines[i].trim();
    if (t.startsWith('@')) tagLines.unshift(i);
    else if (t.startsWith('#') || t === '') continue; // kommentarer og tomme linjer kan stå mellom
    else break;
  }
  const tags = tagLines.flatMap(i => lines[i].trim().split(/\s+/).filter(t => t.startsWith('@')));
  const status = tags.map(t => (t === '@levert' ? 'implemented' : t.slice(1))).find(t => (STATUSES as readonly string[]).includes(t)) as Status | undefined;
  const priority = tags.map(t => t.slice(1)).find(t => (PRIORITIES as readonly string[]).includes(t)) as Priority | undefined;
  return { line, tagLines, tags, title: lines[line].match(EGENSKAP)![2].trim(), status: status ?? null, priority: priority ?? null };
}

/**
 * Bytter ut taggene i `group` på Egenskap-linja med `next` (eller fjerner dem med `null`).
 * Står det en av dem der fra før, settes den nye på samme plass; ellers legges den til sist på første tag-linje.
 * Finnes ingen tag-linje, lages en rett over `Egenskap:`.
 */
function setTag(text: string, group: string[], next: string | null): string {
  const head = readHead(text);
  if (!head) throw new Error('Fant ikke Egenskap: i fila');
  const nl = eol(text);
  const lines = text.split(/\r?\n/);
  let placed = false;
  for (const i of head.tagLines) {
    const indent = lines[i].match(/^\s*/)![0];
    const words = lines[i].trim().split(/\s+/);
    const out: string[] = [];
    for (const w of words) {
      if (!group.includes(w)) out.push(w);
      else if (next && !placed) {
        out.push(next);
        placed = true;
      }
    }
    lines[i] = out.length ? indent + out.join(' ') : '';
  }
  if (next && !placed) {
    if (head.tagLines.length) {
      const i = head.tagLines.find(i => lines[i] !== '') ?? head.tagLines[0];
      lines[i] = lines[i] ? lines[i] + ' ' + next : lines[head.line].match(/^\s*/)![0] + next;
    } else {
      lines.splice(head.line, 0, lines[head.line].match(/^\s*/)![0] + next);
    }
  }
  // Tag-linjer som ble tomme, fjernes
  const emptied = new Set(head.tagLines.filter(i => lines[i] === ''));
  return lines.filter((_, i) => !emptied.has(i)).join(nl);
}

export const setStatus = (text: string, status: Status | null) => setTag(text, STATUS_TAGS, status && '@' + status);
export const setPriority = (text: string, priority: Priority | null) => setTag(text, PRIORITY_TAGS, priority && '@' + priority);

export function setTitle(text: string, title: string): string {
  const head = readHead(text);
  if (!head) throw new Error('Fant ikke Egenskap: i fila');
  const lines = text.split(/\r?\n/);
  const indent = lines[head.line].match(EGENSKAP)![1];
  lines[head.line] = `${indent}Egenskap: ${title.replace(/[\r\n]+/g, ' ').trim()}`;
  return lines.join(eol(text));
}

/** Forslag til PR-tittel ut fra filene som er med */
export function prTitle(paths: string[], titles: Record<string, string | undefined>): string {
  if (paths.length === 1) {
    const p = paths[0];
    return `Krav: ${titles[p] || p.slice(p.lastIndexOf('/') + 1).replace(/\.(feature|md)$/, '').replace(/_/g, ' ')}`;
  }
  const dirs = new Set(paths.map(p => p.split('/').slice(0, -1).pop()));
  return dirs.size === 1 ? `Krav: ${[...dirs][0]!.replace(/^\d+\s+/, '')} (${paths.length} filer)` : `Krav: ${paths.length} filer`;
}

/** Fila har endringer under krav/: ucommittet, eller committet i branchen siden main */
export const changedFile = (git: GitInfo | null, path: string) =>
  !!git && [...git.uncommitted, ...git.committed].some(c => c.path === path);

/**
 * Filene som er valgt når «Lag PR» åpnes. Uten utkast: fila dialogen åpnes fra, ellers alle ucommittede.
 * Med utkast: filene i utkastet, og fila dialogen åpnes fra hvis den ikke er med.
 */
export function draftPicked(draft: string[] | null, preselect: string | undefined, uncommitted: string[]): string[] {
  if (!draft) return preselect ? [preselect] : uncommitted;
  return preselect && !draft.includes(preselect) ? [...draft, preselect] : draft;
}
