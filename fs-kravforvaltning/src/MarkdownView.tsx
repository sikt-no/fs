import type { ComponentChildren, JSX } from 'preact';
import { useEffect, useRef, useState } from 'preact/hooks';
import type { Entry } from '../shared/model';
import { resolveLink, type Block, type List, type Seg } from './markdown';

export type MdMode = 'pretty' | 'raw';

interface Props {
  entry: Entry;
  blocks: Block[];
  mode: MdMode;
  onMode: (m: MdMode) => void;
  has: (path: string) => boolean;
  onNavigate: (path: string) => void;
  /** Åpne fila i editoren; utelatt der redigering ikke er tilgjengelig */
  onEdit?: () => void;
}

export function MarkdownView({ entry, blocks, mode, onMode, has, onNavigate, onEdit }: Props) {
  const [copied, setCopied] = useState<number | null>(null);
  const timer = useRef<ReturnType<typeof setTimeout>>();
  useEffect(() => () => clearTimeout(timer.current), []);

  const source = entry.source ?? '';
  const lines = source.replace(/\n$/, '').split('\n');
  const name = entry.path.slice(entry.path.lastIndexOf('/') + 1);
  const label = /^readme\.md$/i.test(name) ? 'README' : 'MD';

  const copy = (i: number, text: string) => {
    try {
      navigator.clipboard.writeText(text).catch(() => {});
    } catch {
      /* utilgjengelig utklippstavle */
    }
    setCopied(i);
    clearTimeout(timer.current);
    timer.current = setTimeout(() => setCopied(null), 1500);
  };

  const segs = (ss: Seg[]): ComponentChildren[] =>
    ss.map((g, i) => {
      if (g.kind === 'code') return <code key={i}>{g.t}</code>;
      if (g.kind === 'bold') return <strong key={i}>{segs(g.c)}</strong>;
      if (g.kind === 'em') return <em key={i}>{segs(g.c)}</em>;
      if (g.kind === 'strike') return <del key={i}>{segs(g.c)}</del>;
      if (g.kind === 'link') {
        const r = resolveLink(g.href, entry.path, has);
        return r.path ? (
          <a
            key={i}
            href={r.href}
            onClick={e => {
              e.preventDefault();
              onNavigate(r.path!);
            }}
          >
            {g.t}
          </a>
        ) : (
          <a key={i} href={r.href} target="_blank" rel="noreferrer">
            {g.t}
          </a>
        );
      }
      return g.t;
    });

  const list = (b: List, key: number) => {
    const L = b.type;
    return (
      <L key={key} start={b.start} style={b.start ? { counterReset: `md ${b.start - 1}` } : undefined}>
        {b.items.map((it, j) => (
          <li key={j} class={it.task !== undefined ? 'task' : undefined}>
            {it.task !== undefined && <input type="checkbox" checked={it.task} disabled />}
            <span>
              {segs(it.segs)}
              {it.sub && list(it.sub, 0)}
            </span>
          </li>
        ))}
      </L>
    );
  };

  // Blokkene inne i et sitat får ikke data-rule, så innholdsfortegnelsen bare treffer toppnivået
  const block = (b: Block, i: number, top = true): JSX.Element => {
    const key = top ? 'md-' + i : undefined;
    switch (b.type) {
      case 'h1':
        return top ? (
          <div key={i} class="fbanner md-h1" data-rule={key}>
            <span class="kbadge inv">{label}</span>
            <h1>{segs(b.segs)}</h1>
          </div>
        ) : (
          <h2 key={i}>{segs(b.segs)}</h2>
        );
      case 'h2':
        return <h2 key={i} data-rule={key}>{segs(b.segs)}</h2>;
      case 'h3':
        return <h3 key={i} data-rule={key}>{segs(b.segs)}</h3>;
      case 'p':
        return <p key={i}>{segs(b.segs)}</p>;
      case 'ul':
      case 'ol':
        return list(b, i);
      case 'quote':
        return (
          <blockquote key={i} class="md-quote">
            {b.blocks.map((x, j) => block(x, j, false))}
          </blockquote>
        );
      case 'hr':
        return <hr key={i} class="md-hr" />;
      case 'card':
        return (
          <a key={i} class="md-card" href={b.href} target="_blank" rel="noreferrer">
            <span class="url">
              <span class="host">{b.host}</span>
              <span>{b.path}</span>
            </span>
            <span class="open">Åpne ↗</span>
          </a>
        );
      case 'code':
        return (
          <div key={i} class="md-code">
            <div class="md-code-head">
              <span>{b.lang}</span>
              <button class="smallbtn" onClick={() => copy(i, b.body.join('\n'))}>
                {copied === i ? 'Kopiert' : 'Kopier'}
              </button>
            </div>
            <div class="md-code-body">
              {b.body.map((x, j) => {
                const k = x.indexOf(' #');
                return (
                  <div key={j}>
                    {k >= 0 ? x.slice(0, k) : x || ' '}
                    {k >= 0 && <span class="cmt">{x.slice(k)}</span>}
                  </div>
                );
              })}
            </div>
          </div>
        );
      case 'table':
        return (
          <div key={i} class="md-table">
            <table>
              <thead>
                <tr>{b.head.map((c, j) => <th key={j}>{segs(c)}</th>)}</tr>
              </thead>
              <tbody>
                {b.rows.map((r, j) => (
                  <tr key={j}>{r.map((c, k) => <td key={k}>{segs(c)}</td>)}</tr>
                ))}
              </tbody>
            </table>
          </div>
        );
      default:
        return b satisfies never;
    }
  };

  let inCode = false;
  return (
    <div class="mdoc">
      <div class="md-meta">
        <span class="file">{name}</span>
        <span>{lines.length} linjer</span>
        {onEdit && <button class="smallbtn editbtn" onClick={onEdit}>Rediger</button>}
        <div class="seg" role="group" aria-label="Visning av markdown">
          <button aria-pressed={mode === 'pretty'} onClick={() => onMode('pretty')}>Visning</button>
          <button aria-pressed={mode === 'raw'} onClick={() => onMode('raw')}>Markdown</button>
        </div>
      </div>
      {mode === 'pretty' ? (
        <div class="md-body">{blocks.map((b, i) => block(b, i))}</div>
      ) : (
        <div class="md-raw">
          {lines.map((t, i) => {
            if (t.trim().startsWith('```')) inCode = !inCode;
            return (
              <div key={i}>
                <span class="ln">{i + 1}</span>
                <span class={/^#/.test(t) && !inCode ? 'h' : ''}>{t || ' '}</span>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
