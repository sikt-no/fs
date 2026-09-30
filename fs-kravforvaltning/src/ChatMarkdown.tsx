import type { ComponentChildren, JSX } from 'preact';
import { useMemo, useState } from 'preact/hooks';
import { parseMd, resolveLink, type Block, type List, type Seg } from './markdown';
import { useCopy } from './useCopy';

interface Props {
  text: string;
  /** Finnes fila i vieweren? */
  has: (path: string) => boolean;
  onOpen: (path: string) => void;
}

/** Stier Claude skriver er relative til repoet, eller absolutte inn i klonen: `/…/repo/krav/x.feature` → `krav/x.feature` */
const repoPath = (p: string) => p.replace(/^.*?\/(krav\/)/, '$1').replace(/^\.?\//, '');

/**
 * Svarene fra Claude er markdown. De tolkes med den samme parseren som .md-filene i vieweren (`parseMd`),
 * men vises kompakt: overskriftene er små, og lenkekort blir vanlige lenker. Lenker og `kode` som peker
 * på en fil i vieweren, åpner fila.
 */
export function ChatMarkdown({ text, has, onOpen }: Props) {
  const blocks = useMemo(() => parseMd(text), [text]);
  const [copied, copy] = useCopy();
  const [copiedBlock, setCopiedBlock] = useState<number | null>(null);

  const internal = (path: string, label: ComponentChildren, key: number, code = false) => (
    <a
      key={key}
      href={'#/' + encodeURI(path)}
      class={code ? 'cmd-file' : undefined}
      title={path}
      onClick={e => {
        e.preventDefault();
        onOpen(path);
      }}
    >
      {code ? <code>{label}</code> : label}
    </a>
  );

  const segs = (ss: Seg[]): ComponentChildren[] =>
    ss.map((g, i) => {
      if (g.kind === 'code') {
        const p = repoPath(g.t);
        return has(p) ? internal(p, g.t.slice(g.t.lastIndexOf('/') + 1), i, true) : <code key={i}>{g.t}</code>;
      }
      if (g.kind === 'bold') return <strong key={i}>{segs(g.c)}</strong>;
      if (g.kind === 'em') return <em key={i}>{segs(g.c)}</em>;
      if (g.kind === 'strike') return <del key={i}>{segs(g.c)}</del>;
      if (g.kind === 'link') {
        const r = resolveLink(/^[a-z]+:/i.test(g.href) ? g.href : repoPath(g.href), '_', has);
        return r.path ? internal(r.path, g.t, i) : <a key={i} href={r.href} target="_blank" rel="noreferrer">{g.t}</a>;
      }
      return g.t;
    });

  const list = (b: List, key: number) => {
    const L = b.type;
    return (
      <L key={key} start={b.start}>
        {b.items.map((it, j) => (
          <li key={j} class={it.task !== undefined ? 'task' : undefined}>
            {it.task !== undefined && <input type="checkbox" checked={it.task} disabled />}
            {segs(it.segs)}
            {it.sub && list(it.sub, 0)}
          </li>
        ))}
      </L>
    );
  };

  const block = (b: Block, i: number): JSX.Element => {
    switch (b.type) {
      case 'h1':
      case 'h2':
      case 'h3':
        return <div key={i} class={'cmd-h ' + b.type}>{segs(b.segs)}</div>;
      case 'p':
        return <p key={i}>{segs(b.segs)}</p>;
      case 'ul':
      case 'ol':
        return list(b, i);
      case 'quote':
        return <blockquote key={i} class="cmd-quote">{b.blocks.map(block)}</blockquote>;
      case 'hr':
        return <hr key={i} class="cmd-hr" />;
      case 'card':
        return <p key={i}><a href={b.href} target="_blank" rel="noreferrer">{b.host}{b.path} ↗</a></p>;
      case 'code':
        return (
          <div key={i} class="cmd-code">
            <div class="cmd-code-head">
              <span>{b.lang}</span>
              <button
                class="linkbtn"
                onClick={() => {
                  copy(b.body.join('\n'));
                  setCopiedBlock(i);
                }}
              >
                {copied && copiedBlock === i ? 'Kopiert' : 'Kopier'}
              </button>
            </div>
            <pre>{b.body.join('\n')}</pre>
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

  return <div class="cmd">{blocks.map(block)}</div>;
}
