/**
 * Lenke som åpner en mappe eller fil i VS Code (`vscode://file/<absolutt sti>[:linje]`), som `code <sti>`.
 * Windows-stier får `/` som skilletegn og en `/` foran stasjonsbokstaven.
 * Med `newWindow` får lenken `?windowId=_blank`, så VS Code åpner et nytt vindu i stedet for å bytte mappe i det som er åpent.
 */
export function vscodeUrl(path: string, opts: { line?: number; newWindow?: boolean } = {}): string {
  const posix = path.replace(/\\/g, '/');
  const abs = posix.startsWith('/') ? posix : '/' + posix;
  const enc = abs.split('/').map(encodeURIComponent).join('/').replace(/^\/([A-Za-z])%3A/, '/$1:');
  return 'vscode://file' + enc + (opts.line ? `:${opts.line}` : '') + (opts.newWindow ? '?windowId=_blank' : '');
}
