// Melder aktiv krav-fil og markerte linjer til viewer-dev-serveren (POST /__krav/focus).
// Er en annen fil (eller ingen) i fokus, sendes `path: null` så vieweren fjerner markeringen.
const vscode = require('vscode');

const isKrav = p => p.startsWith('krav/') && (p.endsWith('.feature') || p.endsWith('.md'));
// Output-panelet, diff-visninger o.l. er også tekst-editorer; de skal ikke påvirke vieweren
const isUserFile = uri => uri.scheme === 'file' || uri.scheme === 'untitled';

function activate(context) {
  let timer;
  let last = '';

  const post = (key, body) => {
    const config = vscode.workspace.getConfiguration('kravViewer');
    if (key === last || !config.get('enabled')) return;
    last = key;
    const url = config.get('url').replace(/\/$/, '') + '/__krav/focus';
    // Vieweren kjører kanskje ikke; da skal ingenting skje
    fetch(url, { method: 'POST', body: JSON.stringify(body) }).catch(() => {});
  };

  const send = editor => {
    if (editor && !isUserFile(editor.document.uri)) return;
    const path = editor && vscode.workspace.asRelativePath(editor.document.uri, false);
    if (!path || !isKrav(path)) return post('none', { path: null });
    const { start, end } = editor.selection;
    const line = start.line + 1;
    // En markering som slutter i kolonne 0 på neste linje, tar ikke med den linjen
    const to = Math.max(line, end.line + (end.character === 0 && end.line > start.line ? 0 : 1));
    post(`${path}:${line}-${to}`, { path, line, to });
  };

  const schedule = editor => {
    clearTimeout(timer);
    timer = setTimeout(() => send(editor), 150);
  };

  context.subscriptions.push(
    vscode.window.onDidChangeActiveTextEditor(schedule),
    vscode.window.onDidChangeTextEditorSelection(e => schedule(e.textEditor)),
    { dispose: () => clearTimeout(timer) },
  );
  schedule(vscode.window.activeTextEditor);
}

module.exports = { activate, deactivate() {} };
