import { useEffect, useMemo, useRef, useState } from 'preact/hooks';
import { displayStatus, type Snapshot } from '../shared/model';
import { addMentions, covered, mentionList, parseMention, pushRecent, recentMentions, shortPath, stripMention, type MentionFilter, type MentionList } from './mention';
import { makeMentionIndex, mentionItems, searchMentions, type MentionHit } from './search';
import { highlight, StatusIcon } from './Sidebar';

// De sist brukte omtalene, vist før brukeren har skrevet noe etter @
const RECENT_KEY = 'kravforvaltning:claudeMentions';
const readRecent = (): string[] => {
  try {
    const v = JSON.parse(localStorage.getItem(RECENT_KEY) ?? '[]');
    return Array.isArray(v) ? v.filter((p): p is string => typeof p === 'string') : [];
  } catch {
    return [];
  }
};
const saveRecent = (paths: string[]) => {
  try {
    localStorage.setItem(RECENT_KEY, JSON.stringify(pushRecent(readRecent(), paths)));
  } catch {
    /* utilgjengelig lagring: da vises bare fila brukeren ser på */
  }
};

/**
 * Tilstanden til @-omtalen i Claude-feltet: hva som er lagt ved, søket etter `@`, og tastene i popoveren.
 * Søket er det samme som i treet (Fuse, `src/search.ts`), over både filer og mapper.
 */
export function useMentions(entries: Snapshot, current: string | null, input: string, setInput: (v: string) => void) {
  const items = useMemo(() => mentionItems(entries), [entries]);
  const index = useMemo(() => makeMentionIndex(items), [items]);
  const [mentions, setMentions] = useState<string[]>([]);
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState(0);
  const [marked, setMarked] = useState<string[]>([]);
  const [filter, setFilter] = useState<MentionFilter>('all');
  const q = parseMention(input);
  const shown = open && q !== null;
  const query = (q ?? '').trim();
  const hits = useMemo(
    () => (!shown ? [] : query ? searchMentions(index, items, query) : recentMentions(readRecent(), current, items)),
    [shown, query, index, items, current],
  );
  const list = mentionList(hits, filter);

  const commit = (paths: string[]) => {
    setMentions(m => addMentions(m, paths));
    saveRecent(paths);
    setInput(stripMention(input));
    setOpen(false);
    setMarked([]);
  };
  const toggle = (path: string) => setMarked(m => (m.includes(path) ? m.filter(x => x !== path) : [...m, path]));

  return {
    items,
    /** Det som er lagt ved og fortsatt finnes i treet */
    mentions: mentions.filter(p => items.has(p)),
    remove: (path: string) => setMentions(m => m.filter(x => x !== path)),
    clear: () => setMentions([]),
    picker: shown ? { query, list, active, marked, filter, mentions } : null,
    onInput: (text: string) => {
      setOpen(parseMention(text) !== null);
      setActive(0);
    },
    close: () => setOpen(false),
    setActive,
    setFilter: (f: MentionFilter) => {
      setFilter(f);
      setActive(0);
    },
    toggle,
    commit,
    /** Tastene mens popoveren er åpen; `true` når tasten er brukt */
    onKeyDown: (e: KeyboardEvent): boolean => {
      if (!shown) return false;
      const n = list.flat.length;
      const cur = list.flat[active]?.item.path;
      if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
        if (n) setActive(a => (a + (e.key === 'ArrowDown' ? 1 : n - 1)) % n);
      } else if (e.key === 'Escape') setOpen(false);
      else if (e.key === 'Tab' && cur) toggle(cur);
      else if (e.key === 'Enter' && !e.shiftKey && (marked.length || cur)) commit(marked.length ? marked : [cur!]);
      else return false;
      e.preventDefault();
      return true;
    },
  };
}

interface Props {
  query: string;
  list: MentionList;
  active: number;
  marked: string[];
  filter: MentionFilter;
  mentions: string[];
  onActive: (i: number) => void;
  onFilter: (f: MentionFilter) => void;
  onToggle: (path: string) => void;
  onCommit: (paths: string[]) => void;
}

const FILTERS: [string, MentionFilter][] = [['Alle', 'all'], ['Mapper', 'dir'], ['Filer', 'file']];

export const MENTION_LIST_ID = 'claude-mentions';

/** Popoveren over Claude-feltet: treff i mapper og filer, med merking av flere */
export function MentionPicker({ query, list, active, marked, filter, mentions, onActive, onFilter, onToggle, onCommit }: Props) {
  const box = useRef<HTMLDivElement>(null);
  useEffect(() => {
    box.current?.querySelector('.cmrow.act')?.scrollIntoView({ block: 'nearest' });
  }, [active, list.flat.length]);

  let n = 0;
  const row = ({ item, ranges }: MentionHit) => {
    const i = n++;
    const mk = marked.includes(item.path);
    const e = item.entry;
    return (
      <div
        key={item.path}
        id={`${MENTION_LIST_ID}-${i}`}
        role="option"
        aria-selected={i === active}
        class={'cmrow' + (i === active ? ' act' : '')}
        title={item.path}
        onMouseEnter={() => i !== active && onActive(i)}
        onClick={() => onCommit([...new Set([...marked, item.path])])}
      >
        <span
          class={'cmchk' + (mk ? ' on' : '')}
          onClick={ev => {
            ev.stopPropagation();
            onToggle(item.path);
          }}
          aria-label={mk ? 'Fjern merkingen' : 'Merk'}
        >
          {mk ? '✓' : ''}
        </span>
        {item.dir ? <span class="cm-dir" aria-hidden="true" /> : e?.kind === 'feature' ? <StatusIcon s={displayStatus(e)} /> : <span class="md">md</span>}
        <span class="cmname">
          {highlight(item.name, ranges)}
          {item.dir && '/'}
        </span>
        <span class="cmsub mono">{shortPath(item.parent)}</span>
        <span class="cmmeta mono">{covered(mentions, item.path) ? 'lagt til' : item.dir ? item.count : ''}</span>
      </div>
    );
  };
  const section = (label: string, rows: MentionList['dirs'], more: number, what: string) =>
    rows.length > 0 && (
      <>
        <div class="cmsec mono">{query ? label : `Nylig brukt · ${label.toLowerCase()}`}</div>
        {rows.map(row)}
        {more > 0 && <div class="cmmore">+ {more} flere {what}</div>}
      </>
    );

  return (
    // mousedown skal ikke ta fokus fra feltet
    <div class="cmention" onMouseDown={e => e.preventDefault()}>
      <div class="cmhead">
        <span class="mono muted">@{query}</span>
        <div class="cmfilter">
          {FILTERS.map(([label, f]) => (
            <button key={f} aria-pressed={filter === f} onClick={() => onFilter(f)}>
              {label}
            </button>
          ))}
        </div>
      </div>
      <div class="cmlist" ref={box} role="listbox" id={MENTION_LIST_ID} aria-label="Filer og mapper">
        {!list.flat.length && <div class="cmempty">{query ? `Ingen treff for «${query}»` : 'Skriv for å søke i hele treet'}</div>}
        {section('Mapper', list.dirs, list.moreDirs, 'mapper')}
        {section('Filer', list.files, list.moreFiles, 'filer')}
      </div>
      <div class="cmfoot">
        <span class={marked.length ? 'acc' : ''}>
          {marked.length ? `${marked.length} merket · ↵ legger til alle` : query ? `${list.flat.length} treff` : 'Skriv for å søke i hele treet'}
        </span>
        <span class="mono">↑↓ · Tab merk · ↵ legg til · Esc</span>
      </div>
    </div>
  );
}
