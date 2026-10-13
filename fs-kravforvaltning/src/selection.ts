// Markert tekst i feature-visningen: teksten som kopieres, linjeområdet den dekker, og sitatet som legges i Claude-samtalen.
// Rene funksjoner, så de kan testes med node --test. Menyen står i SelectionMenu.tsx.

/** Markert tekst slik den kopieres: harde mellomrom blir vanlige, og mellomrom og tomme linjer i endene fjernes */
export const cleanSelection = (t: string) =>
  t
    .replace(/ /g, ' ')
    .replace(/[ \t]+$/gm, '')
    .replace(/^\s*\n+|\n+\s*$/g, '')
    .trim();

/** Linjeområdet markeringen dekker, ut fra linjene til elementene den treffer; `null` uten linjer */
export function lineRange(lns: (number | null | undefined)[]): { from: number; to: number } | null {
  const ok = lns.filter((n): n is number => typeof n === 'number' && Number.isFinite(n) && n > 0);
  return ok.length ? { from: Math.min(...ok), to: Math.max(...ok) } : null;
}

/** `12` eller `12–14` */
export const lineLabel = (from: number, to: number) => (from === to ? `${from}` : `${from}–${to}`);

/** Sitatet i samtalen: fila og linjene som `kode`, så teksten med `> ` foran hver linje */
export const quoteForChat = (text: string, path: string, from: number, to: number) =>
  `\`${path}:${lineLabel(from, to)}\`\n` + text.split('\n').map(l => '> ' + l).join('\n');

/** Inputfeltet etter at sitatet er lagt til: etter teksten som står der, med en tom linje imellom */
export const appendQuote = (input: string, quote: string) =>
  input.trim() ? input.replace(/\s+$/, '') + '\n\n' + quote + '\n' : quote + '\n';
