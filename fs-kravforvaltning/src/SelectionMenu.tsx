import { useEffect, useRef, useState } from 'preact/hooks';
import type { RefObject } from 'preact';
import { useClaudeTarget } from './claudeBridge';
import { cleanSelection, lineLabel, lineRange, quoteForChat } from './selection';
import { useCopy } from './useCopy';

interface Menu {
  text: string;
  from: number;
  to: number;
  /** Posisjonen i dokumentet: midt under der markeringen slutter */
  x: number;
  y: number;
}

/** Hvor lenge «✓ Kopiert» / «✓ Lagt i samtalen» står */
const FEEDBACK_MS = 1400;
/** Halve bredden menyen trenger, så den ikke går utenfor dokumentet */
const HALF = 130;

const elOf = (n: Node) => (n.nodeType === 1 ? (n as Element) : n.parentElement);
/** Det nærmeste elementet med linje, eller ellers nærmeste blokk */
const rowOf = (el: Element | null) => el?.closest('[data-ln]') ?? el?.closest('div, li, pre, h1, h2');
/** Cellene i en tabellrad har hver sitt element, men samme linje */
const rowKey = (el: Element | null | undefined) => (el?.matches('.table > span') ? el.getAttribute('data-ln') : el);

/**
 * Teksten i markeringen, slik den skal kopieres. `selection.toString()` setter linjeskift mellom cellene i griddet
 * (nøkkelordet og stegteksten står i hver sin), og tar med det som ikke kan markeres. Her går vi gjennom tekstnodene,
 * hopper over `user-select: none`, og setter linjeskift mellom linjer, ` | ` mellom tabellceller, mellomrom etter nøkkelordet,
 * og `data-sep` mellom elementer som står side om side (taggene, metalinja, meldingen og forklaringen i et avvik).
 */
function selectedText(range: Range, doc: HTMLElement) {
  const walker = document.createTreeWalker(range.commonAncestorContainer, NodeFilter.SHOW_TEXT);
  let out = '';
  let prev: Element | null = null;
  for (let n = walker.currentNode.nodeType === 3 ? walker.currentNode : walker.nextNode(); n; n = walker.nextNode()) {
    if (!range.intersectsNode(n) || !doc.contains(n)) continue;
    const el = elOf(n);
    if (!el || getComputedStyle(el).userSelect === 'none') continue;
    let t = n.textContent ?? '';
    if (n === range.endContainer) t = t.slice(0, range.endOffset);
    if (n === range.startContainer) t = t.slice(range.startOffset);
    if (!t) continue;
    if (prev) {
      const a = rowOf(prev), b = rowOf(el);
      const cellA = prev.closest('.table > span'), cellB = el.closest('.table > span');
      const sepA = prev.closest('[data-sep]'), sepB = el.closest('[data-sep]');
      // Taggene, metalinja og avvikene står på samme rad: skilletegnet står i `data-sep`
      if (sepA && sepB && sepA !== sepB && sepA.parentElement === sepB.parentElement) out += sepB.getAttribute('data-sep');
      else if (rowKey(a) !== rowKey(b)) out += '\n';
      else if (cellA !== cellB) out += ' | ';
      else if (prev.closest('.kw') && !el.closest('.kw')) out += ' ';
    }
    out += t;
    prev = el;
  }
  return cleanSelection(out);
}

const lnOf = (n: Node | null, doc: HTMLElement) => {
  const el = n && (n.nodeType === 1 ? (n as Element) : n.parentElement);
  const x = el?.closest('[data-ln]');
  return x && doc.contains(x) ? Number(x.getAttribute('data-ln')) : null;
};

/**
 * Menyen ved markert tekst i feature-visningen, portet fra designet «Marker tekst» (variant c, Claude Design):
 * linjene markeringen dekker, «Kopier» og «Legg i samtalen». Den legger seg under der markeringen slutter,
 * og linjene som blir med i sitatet, markeres i margen (`.insel` på elementene med `data-ln`).
 * «Legg i samtalen» legger teksten som sitat i inputfeltet i Claude-panelet, og er deaktivert når panelet er lukket.
 */
export function SelectionMenu({ docRef, path }: { docRef: RefObject<HTMLElement>; path: string }) {
  const claude = useClaudeTarget();
  const [, copy] = useCopy();
  const [menu, setMenu] = useState<Menu | null>(null);
  const [fb, setFb] = useState<'copy' | 'insert' | null>(null);
  const fbRef = useRef(fb);
  fbRef.current = fb;
  const menuRef = useRef(menu);
  menuRef.current = menu;
  const timer = useRef<ReturnType<typeof setTimeout>>();
  useEffect(() => () => clearTimeout(timer.current), []);

  const compute = () => {
    const doc = docRef.current;
    const sel = window.getSelection();
    if (!doc || !sel || !sel.rangeCount || sel.isCollapsed || !doc.contains(sel.anchorNode) || !doc.contains(sel.focusNode)) return fbRef.current ? undefined : setMenu(null);
    const range = sel.getRangeAt(0);
    const text = selectedText(range, doc);
    // Mens tilbakemeldingen står, blir menyen stående (feltet i panelet tar fokus); en ny markering avbryter den
    if (fbRef.current && (!text || text === menuRef.current?.text)) return;
    if (fbRef.current) {
      clearTimeout(timer.current);
      fbRef.current = null;
      setFb(null);
    }
    if (!text) return setMenu(null);
    const lns = [lnOf(sel.anchorNode, doc), lnOf(sel.focusNode, doc)];
    doc.querySelectorAll('[data-ln]').forEach(el => range.intersectsNode(el) && lns.push(Number(el.getAttribute('data-ln'))));
    const r = lineRange(lns);
    if (!r) return setMenu(null);
    const rects = [...range.getClientRects()].filter(c => c.width > 0);
    const last = rects[rects.length - 1] ?? range.getBoundingClientRect();
    const d = doc.getBoundingClientRect();
    const x = Math.round(Math.max(HALF, Math.min(doc.offsetWidth - HALF, last.right - d.left)));
    const y = Math.round(last.bottom - d.top + 8);
    setMenu(m => (m && m.text === text && m.from === r.from && m.to === r.to && m.x === x && m.y === y ? m : { text, ...r, x, y }));
  };

  // Markeringen endres med mus og tastatur; vent til den har satt seg
  useEffect(() => {
    let t: ReturnType<typeof setTimeout>;
    const q = () => {
      clearTimeout(t);
      t = setTimeout(compute, 90);
    };
    const onKey = (e: KeyboardEvent) => {
      if (e.key !== 'Escape' || !menuRef.current) return;
      window.getSelection()?.removeAllRanges();
      setMenu(null);
    };
    // Cmd/Ctrl+C gir den samme teksten som «Kopier»
    const onCopy = (e: ClipboardEvent) => {
      const doc = docRef.current;
      const sel = window.getSelection();
      if (!doc || !sel?.rangeCount || sel.isCollapsed || !doc.contains(sel.anchorNode) || !doc.contains(sel.focusNode) || !e.clipboardData) return;
      const text = selectedText(sel.getRangeAt(0), doc);
      if (!text) return;
      e.clipboardData.setData('text/plain', text);
      e.preventDefault();
    };
    document.addEventListener('selectionchange', q);
    document.addEventListener('mouseup', q);
    document.addEventListener('copy', onCopy);
    window.addEventListener('keydown', onKey);
    return () => {
      clearTimeout(t);
      document.removeEventListener('copy', onCopy);
      document.removeEventListener('selectionchange', q);
      document.removeEventListener('mouseup', q);
      window.removeEventListener('keydown', onKey);
    };
  }, []);
  // Ny fil: ingen meny
  useEffect(() => setMenu(null), [path]);

  // Linjene som blir med i sitatet, markeres i margen
  useEffect(() => {
    const doc = docRef.current;
    if (!doc || !menu) return;
    const els = [...doc.querySelectorAll<HTMLElement>('[data-ln]')].filter(el => {
      const n = Number(el.dataset.ln);
      return n >= menu.from && n <= menu.to;
    });
    els.forEach(el => el.classList.add('insel'));
    return () => els.forEach(el => el.classList.remove('insel'));
  }, [menu?.from, menu?.to, !!menu]);

  // Tilbakemeldingen står en stund; så beregnes menyen på nytt (markeringen kan være borte)
  const feedback = (kind: 'copy' | 'insert') => {
    setFb(kind);
    fbRef.current = kind;
    clearTimeout(timer.current);
    timer.current = setTimeout(() => {
      fbRef.current = null;
      setFb(null);
      compute();
    }, FEEDBACK_MS);
  };

  if (!menu) return null;
  const lines = lineLabel(menu.from, menu.to);
  return (
    <div class="selmenu" style={{ left: menu.x, top: menu.y }} onMouseDown={e => e.preventDefault()}>
      <span class="selmenu-ln mono">L{lines}</span>
      <button
        class="selmenu-copy"
        title="Kopier markert tekst"
        onClick={() => {
          copy(menu.text);
          feedback('copy');
        }}
      >
        {fb === 'copy' ? '✓ Kopiert' : 'Kopier'}
      </button>
      <button
        class="selmenu-insert"
        disabled={!claude.ready}
        title={claude.ready ? 'Legg teksten som sitat i inputfeltet' : 'Åpne Claude-panelet for å legge teksten i samtalen'}
        onClick={() => {
          claude.insert(quoteForChat(menu.text, path, menu.from, menu.to));
          feedback('insert');
        }}
      >
        {fb === 'insert' ? '✓ Lagt i samtalen' : 'Legg i samtalen'}
      </button>
    </div>
  );
}
