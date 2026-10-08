import { useEffect, useRef } from 'preact/hooks';
import type { FeatureModel, Note, Rule } from '../shared/model';
import { findSummary, type FindGroup } from './find';
import type { Heading } from './markdown';

const qCount = (notes: Note[]) => notes.filter(n => n.kind === 'question').reduce((n, q) => n + q.items.length, 0);
/** Åpne spørsmål i regelen og scenarioene under den */
const ruleQ = (r: Rule) => qCount(r.notes) + r.scenarios.reduce((n, s) => n + qCount(s.notes), 0);

/** Søket i fila, øverst i panelet for .feature-filer */
export interface FindProps {
  q: string;
  onQ: (q: string) => void;
  groups: FindGroup[];
  total: number;
  cur: number;
  onCur: (id: number) => void;
  /** Neste (1) eller forrige (-1) treff */
  onStep: (d: 1 | -1) => void;
  onClear: () => void;
}

const MAC = typeof navigator !== 'undefined' && /Mac|iPhone|iPad/.test(navigator.platform);

function FindBox({ q, onQ, groups, total, cur, onCur, onStep, onClear }: FindProps) {
  const active = !!q.trim();
  return (
    <div class="find">
      <div class="findbox">
        <input
          data-find
          type="text"
          value={q}
          placeholder="Søk i fila…"
          aria-label="Søk i fila"
          spellcheck={false}
          onInput={e => onQ((e.target as HTMLInputElement).value)}
          onKeyDown={e => {
            if (e.key === 'Enter') {
              e.preventDefault();
              onStep(e.shiftKey ? -1 : 1);
            } else if (e.key === 'Escape') {
              e.preventDefault();
              onClear();
              (e.target as HTMLInputElement).blur();
            }
          }}
        />
        {!q && <span class="kbd">{MAC ? '⌘F' : 'Ctrl+F'}</span>}
        {q && <button class="findclear" title="Tøm (Esc)" aria-label="Tøm søket" onClick={onClear}>✕</button>}
      </div>
      {active && (
        <div class="findsum">
          <span class={total ? '' : 'none'} role="status">{findSummary(total, groups.length, cur)}</span>
          <div class="findnav">
            <button title="Forrige (Shift+Enter)" aria-label="Forrige treff" onClick={() => onStep(-1)} disabled={!total}>↑</button>
            <button title="Neste (Enter)" aria-label="Neste treff" onClick={() => onStep(1)} disabled={!total}>↓</button>
          </div>
        </div>
      )}
    </div>
  );
}

function FindList({ groups, cur, onCur }: Pick<FindProps, 'groups' | 'cur' | 'onCur'>) {
  // Gjeldende treff holdes synlig i lista når man går med Enter
  const ref = useRef<HTMLDivElement>(null);
  useEffect(() => ref.current?.querySelector('.fitem.cur')?.scrollIntoView({ block: 'nearest' }), [cur, groups]);
  return (
    <div class="findlist" ref={ref}>
      {groups.map(g => (
        <div key={g.g} class="fgroup">
          <div class="fghead"><span class="mono">{g.kind}</span><span>{g.label}</span></div>
          {g.items.map(it => (
            <button key={it.id} class={'fitem' + (it.id === cur ? ' cur' : '')} onClick={() => onCur(it.id)}>
              <span class="mono">{it.kw}</span>
              <span>{it.pre}<mark>{it.hl}</mark>{it.post}</span>
            </button>
          ))}
        </div>
      ))}
    </div>
  );
}

interface Props {
  model?: FeatureModel;
  /** Overskriftene i en .md-fil; erstatter reglene når de er satt */
  headings?: Heading[];
  onJump: (key: string) => void;
  onFoldAll: () => void;
  onOpenAll: () => void;
  /** Søket i fila; utelatt for .md-filer */
  find?: FindProps;
}

export function Outline({ model, headings, onJump, onFoldAll, onOpenAll, find }: Props) {
  let num = 0;
  if (headings)
    return (
      <aside class="outline">
        <div class="outline-head">
          <span class="mono">INNHOLD</span>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '2px' }}>
          {headings.map(h => (
            <button key={h.key} class="orow" onClick={() => onJump(h.key)}>
              <span class="num">{h.num}</span>
              <span class="txt">
                <span>{h.name}</span>
                {h.sub && <span class="mono">{h.sub}</span>}
              </span>
            </button>
          ))}
        </div>
      </aside>
    );
  const finding = !!find?.q.trim();
  const toc = (
    <>
      <div class="outline-head">
        <span class="mono">INNHOLD</span>
        <div>
          <button class="smallbtn" onClick={onFoldAll}>Fold alle</button>
          <button class="smallbtn" onClick={onOpenAll}>Utvid</button>
        </div>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '2px' }}>
        {model?.rules.map((r, ri) => {
          if (r.name === null) return null;
          num++;
          const n = r.scenarios.filter(s => s.kind !== 'Bakgrunn').length;
          const q = ruleQ(r);
          const draft = r.tags.includes('@draft');
          return (
            <button key={ri} class={'orow' + (draft ? ' draft' : '')} onClick={() => onJump(String(ri))}>
              <span class="num">{num}</span>
              <span class="txt">
                <span>{r.name}</span>
                <span class="mono">
                  {n} {n === 1 ? 'scenario' : 'scenarioer'}
                  {draft && ' · utkast'}
                  {r.tags.includes('@planned') && ' · planlagt'}
                  {r.tags.includes('@in-progress') && ' · under arbeid'}
                  {r.tags.includes('@deprecated') && ' · avviklet'}
                  {q > 0 && <span class="oq"> · ? {q}</span>}
                </span>
              </span>
            </button>
          );
        })}
        {model && model.questions.length > 0 && (
          <button class="orow" onClick={() => onJump('q')}>
            <span class="num">?</span>
            <span class="txt"><span>Åpne spørsmål</span><span class="mono">{model.questions.length} punkter</span></span>
          </button>
        )}
      </div>
    </>
  );
  if (!find) return <aside class="outline">{toc}</aside>;
  // Med søk: feltet øverst, trefflista i stedet for innholdet mens det står et søk, og tastene nederst
  return (
    <aside class={'outline withfind' + (finding ? ' finding' : '')}>
      <FindBox {...find} />
      <div class="outline-body">
        {finding ? <FindList groups={find.groups} cur={find.cur} onCur={find.onCur} /> : toc}
      </div>
      <div class="findkeys mono">↵ neste · ⇧↵ forrige · Esc · 'ord eksakt</div>
    </aside>
  );
}
