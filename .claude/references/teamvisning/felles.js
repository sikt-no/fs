// Felles hjelpefunksjoner i nettleseren for teamvisningene. Lastes inn i malene som __FELLES__.
var TV = (function () {
  function esc(s) { return String(s == null ? '' : s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); }
  // Tekst i en linje: `kode`, **fet**, *kursiv*, [lenke](url), nakne url-er og <br>.
  function inl(s) {
    return String(s == null ? '' : s).split(/<br\s*\/?>/i).map(function (part) {
      return esc(part)
        .replace(/`([^`]+)`/g, '<code>$1</code>')
        .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
        .replace(/(^|[\s(])\*([^*\s][^*]*)\*(?=[\s).,:;]|$)/g, '$1<em>$2</em>')
        .replace(/\[([^\]]+)\]\((https?:[^)\s]+)\)/g, '<a href="$2" target="_blank" rel="noopener">$1</a>')
        .replace(/\[([^\]]+)\]\(([^)\s]+)\)/g, '<span title="$2">$1</span>')
        .replace(/(^|[\s(·])(https?:\/\/[^\s)<]+)/g, '$1<a href="$2" target="_blank" rel="noopener">$2</a>');
    }).join('<br>');
  }
  // Stegene i en celle («1. … <br>2. …») som nummerert liste.
  function steps(s) {
    var parts = String(s || '').split(/<br\s*\/?>/i).map(function (x) { return x.trim(); }).filter(Boolean);
    if (parts.length > 1 && parts.every(function (p) { return /^\d+\.\s/.test(p); })) {
      return '<ol class="steps" start="' + parseInt(parts[0], 10) + '">' + parts.map(function (p) { return '<li>' + inl(p.replace(/^\d+\.\s*/, '')) + '</li>'; }).join('') + '</ol>';
    }
    return '<div class="prose">' + inl(s) + '</div>';
  }
  function table(b) {
    return '<div class="scroll"><table class="gtable"><thead><tr>' + b.head.map(function (h) { return '<th>' + inl(h) + '</th>'; }).join('') + '</tr></thead><tbody>' +
      b.rows.map(function (r) { return '<tr>' + b.head.map(function (_, i) { return '<td>' + inl(r[i]) + '</td>'; }).join('') + '</tr>'; }).join('') + '</tbody></table></div>';
  }
  function blocks(arr) {
    return (arr || []).map(function (b) {
      if (b.t === 'p') return '<p>' + inl(b.text) + '</p>';
      if (b.t === 'ul' || b.t === 'ol') return '<' + b.t + '>' + b.items.map(function (x) { return '<li>' + inl(x) + '</li>'; }).join('') + '</' + b.t + '>';
      if (b.t === 'table') return table(b);
      return '';
    }).join('');
  }
  // Kolonnen i en tabell som matcher et av navnene (regex), eller -1.
  function col(head, re) { for (var i = 0; i < head.length; i++) if (re.test(head[i].replace(/[*`]/g, '').trim())) return i; return -1; }
  function cell(row, i) { return i < 0 ? '' : (row[i] || '').trim(); }
  function emptyRow(r) { return r.every(function (c) { return !String(c).trim(); }); }
  function cap(s) { return s ? s.charAt(0).toUpperCase() + s.slice(1) : s; }
  // Status fra testsiden: Bestått / Ikke bestått / Ikke testet / tom
  function status(s) {
    var x = String(s || '').toLowerCase().replace(/[*_]/g, '').trim();
    if (!x) return { k: 'tom', label: 'ikke fylt ut', cls: 'na' };
    if (/^ikke best/.test(x)) return { k: 'ikke', label: 'ikke bestått', cls: 'miss' };
    if (/^ikke test/.test(x)) return { k: 'ikketestet', label: 'ikke testet', cls: 'part' };
    if (/^best[aå]tt$/.test(x)) return { k: 'ok', label: 'bestått', cls: 'ok' };
    return { k: 'uklar', label: s, cls: 'part' };
  }
  function chip(cls, text) { return '<span class="chip ' + cls + '">' + esc(text) + '</span>'; }
  function group(cls, title, text, items, row) {
    if (!items.length) return '';
    return '<div class="rgroup ' + cls + '"><div class="rghead"><h3>' + esc(title) + ' <span class="rgn">' + items.length + '</span></h3>' + (text ? '<p>' + text + '</p>' : '') + '</div><ol class="rlist">' + items.map(row).join('') + '</ol></div>';
  }
  function stats(list) {
    return list.map(function (x) { return '<div class="stat ' + (x[2] || '') + '"><span class="n">' + x[1] + '</span><span class="l">' + esc(x[0]) + '</span></div>'; }).join('');
  }
  function meta(keys, m, extra) {
    return keys.filter(function (k) { return m[k]; }).map(function (k) {
      var v = m[k];
      return '<dt>' + esc(k) + '</dt><dd>' + (/\[Fylles ut/.test(v) ? '<span class="warnbox">Ikke fylt ut ennå.</span>' : inl(v)) + '</dd>';
    }).join('') + (extra || []).map(function (x) { return '<dt>' + esc(x[0]) + '</dt><dd>' + x[1] + '</dd>'; }).join('');
  }
  // Seksjonene ligger flatt (level 2–4). Henter en seksjon og alt under den.
  function section(D, re) {
    var i = D.sections.findIndex(function (s) { return s.level === 2 && re.test(s.title); });
    if (i < 0) i = D.sections.findIndex(function (s) { return s.level > 2 && re.test(s.title); });
    if (i < 0) return null;
    var lvl = D.sections[i].level;
    var out = { title: D.sections[i].title, blocks: D.sections[i].blocks, children: [] };
    for (var j = i + 1; j < D.sections.length && D.sections[j].level > lvl; j++) out.children.push(D.sections[j]);
    return out;
  }
  function tables(sec) { return sec ? sec.blocks.filter(function (b) { return b.t === 'table'; }) : []; }
  function texts(sec) { return sec ? sec.blocks.filter(function (b) { return b.t !== 'table'; }) : []; }
  function nav(items) {
    return items.map(function (x) { return '<a href="#' + x[0] + '">' + esc(x[1]) + '</a>'; }).join('');
  }
  function store(key, val) {
    try { if (val === undefined) return JSON.parse(localStorage.getItem(key) || '{}'); localStorage.setItem(key, JSON.stringify(val)); } catch (e) { return {}; }
  }
  return { esc: esc, inl: inl, steps: steps, table: table, blocks: blocks, col: col, cell: cell, emptyRow: emptyRow, cap: cap, status: status, chip: chip, group: group, stats: stats, meta: meta, section: section, tables: tables, texts: texts, nav: nav, store: store };
})();
