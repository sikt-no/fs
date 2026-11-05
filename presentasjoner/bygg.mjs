// Bygger én statisk HTML-side per presentasjon fra slide-filene i artefaktene.
// Bruk: node bygg.mjs <eksport-mappe> <ut-mappe>
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

const [, , inn, ut] = process.argv;

const DECKS = [
  { dir: 'kort', file: 'slik-jobber-vi-med-krav.html', nav: 'Slik jobber vi med krav', url: 'https://claude.ai/artifact/FLUQtvcNBjdeP6i7JG9CqF' },
  { dir: 'detaljert', file: 'krav-detaljert.html', nav: 'Detaljert', url: 'https://claude.ai/artifact/Sx4D8zmmWp8kz86Mqq88WY' },
  { dir: 'testfaser', file: 'testfasene.html', nav: 'Testfasene', url: 'https://claude.ai/artifact/X1axGMe6f2jTn8vpcrh4jk' },
];

const ICONS = {
  GraduationCap: '<path d="M22 10 12 5 2 10l10 5 10-5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/>',
  Star: '<polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>',
  Code: '<polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/>',
  CheckCircle: '<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>',
};

function icons(html) {
  return html.replace(/<x-icon name="(\w+)" style="([^"]*)"><\/x-icon>/g, (m, name, style) => {
    if (!ICONS[name]) throw new Error('Ukjent ikon: ' + name);
    return `<svg class="xi" style="${style}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${ICONS[name]}</svg>`;
  });
}

const esc = (s) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

const CSS = `
*{box-sizing:border-box}
html,body{margin:0;height:100%;background:#0E1628;color:#F7F6F2;font-family:'IBM Plex Sans',Arial,sans-serif}
.viewport{position:fixed;inset:0 0 56px 0;display:flex;align-items:center;justify-content:center;overflow:hidden}
.stage{width:1920px;height:1080px;flex:none;transform-origin:center center;box-shadow:0 8px 40px rgba(0,0,0,.5)}
.slide{display:none;width:1920px;height:1080px}
.slide.active{display:block}
.slide section{width:1920px;height:1080px;position:relative;overflow:hidden;font-family:'IBM Plex Sans',Arial,sans-serif}
/* Uten display i stilen er en section eller div en kolonne, som i artefaktet. Med display:flex er retningen rad, som i CSS */
.slide section:not([style*="display"]),.slide div:not([style*="display"]){display:flex;flex-direction:column}
.slide div{min-width:0}
.slide h1,.slide h2,.slide h3,.slide p,.slide ul,.slide table{margin:0}
.slide h1{line-height:1.1}.slide h2{line-height:1.15}.slide h3{line-height:1.2}.slide p,.slide li{line-height:1.4}
.slide ul{padding-left:1.1em}
.slide a{color:inherit}
.slide aside{display:none}
.slide table{width:100%;border-collapse:collapse}
.slide th,.slide td{padding:.35em .6em;text-align:left;vertical-align:top;border-bottom:1px solid rgba(20,33,61,.15)}
.slide th{font-weight:600}
.slide x-shape{display:block;flex:none}
.slide x-shape[kind="arrow-right"]{clip-path:polygon(0 30%,60% 30%,60% 0,100% 50%,60% 100%,60% 70%,0 70%)}
.slide svg.xi{display:block;flex:none}
.bar{position:fixed;left:0;right:0;bottom:0;height:56px;display:flex;align-items:center;gap:16px;padding:0 16px;background:#14213D;border-top:1px solid #24345A;font-size:15px}
.bar a{color:#C9D3E3;text-decoration:none}.bar a:hover,.bar a[aria-current]{color:#F0A070}
.bar .decks{display:flex;gap:16px;flex:1;min-width:0;overflow-x:auto;white-space:nowrap}
.bar button{background:#24345A;color:#F7F6F2;border:0;border-radius:6px;height:34px;min-width:34px;padding:0 10px;font:inherit;cursor:pointer}
.bar button:hover{background:#2F4470}
.bar .count{font-variant-numeric:tabular-nums;color:#C9D3E3;min-width:64px;text-align:center}
.notes{position:fixed;left:0;right:0;bottom:56px;max-height:40vh;overflow:auto;padding:16px 24px;background:#F7F6F2;color:#1F2A44;font-size:17px;line-height:1.5;border-top:3px solid #B4481A;display:none}
.notes.open{display:block}
@media (max-width:700px){.bar .decks{display:none}}
@media print{
  @page{size:1920px 1080px;margin:0}
  html,body{background:#fff;height:auto}
  .viewport{position:static;display:block}
  .stage{transform:none!important;box-shadow:none;height:auto}
  .slide{display:block;break-after:page}
  .bar,.notes{display:none!important}
}`;

const JS = `
const slides=[...document.querySelectorAll('.slide')];
const stage=document.querySelector('.stage');
const notes=document.querySelector('.notes');
const count=document.querySelector('.count');
let i=0;
function fit(){const vw=innerWidth,vh=innerHeight-56;stage.style.transform='scale('+Math.min(vw/1920,vh/1080)+')'}
function show(n){i=Math.max(0,Math.min(slides.length-1,n));slides.forEach((s,k)=>s.classList.toggle('active',k===i));
  count.textContent=(i+1)+' / '+slides.length;const a=slides[i].querySelector('aside');notes.innerHTML=a?a.innerHTML:'<i>Ingen notater</i>';
  history.replaceState(null,'','#slide-'+(i+1))}
function fromHash(){const m=location.hash.match(/^#slide-(\\d+)$/);return m?+m[1]-1:0}
document.querySelector('.prev').onclick=()=>show(i-1);
document.querySelector('.next').onclick=()=>show(i+1);
document.querySelector('.tnotes').onclick=()=>notes.classList.toggle('open');
document.querySelector('.full').onclick=()=>document.fullscreenElement?document.exitFullscreen():document.documentElement.requestFullscreen();
addEventListener('keydown',e=>{if(e.metaKey||e.ctrlKey||e.altKey)return;const k=e.key;
  if(k==='ArrowRight'||k==='PageDown'||k===' '){e.preventDefault();show(i+1)}
  else if(k==='ArrowLeft'||k==='PageUp'){e.preventDefault();show(i-1)}
  else if(k==='Home')show(0);else if(k==='End')show(slides.length-1);
  else if(k==='n'||k==='N')notes.classList.toggle('open');
  else if(k==='f'||k==='F')document.querySelector('.full').click()});
addEventListener('hashchange',()=>show(fromHash()));
addEventListener('resize',fit);fit();show(fromHash());`;

mkdirSync(ut, { recursive: true });
for (const d of DECKS) {
  const base = join(inn, d.dir, 'project');
  const deck = JSON.parse(readFileSync(join(base, 'deck.json'), 'utf8'));
  const fonts = Object.values(deck.faces).map((f) => f.href.split('?')[1].split('&').filter((p) => p.startsWith('family=')).join('&')).join('&');
  const slides = deck.order.map((id) => {
    const html = readFileSync(join(base, 'slides', id + '.html'), 'utf8').trim();
    if (!html.startsWith(`<section id="${id}"`)) throw new Error('Uventet slide: ' + id);
    return `<div class="slide">\n${icons(html)}\n</div>`;
  });
  const nav = DECKS.map((o) => `<a href="${o.file}"${o === d ? ' aria-current="page"' : ''}>${esc(o.nav)}</a>`).join('');
  const page = `<!doctype html>
<!-- Eksportert fra ${d.url} med presentasjoner/bygg.mjs. Endre artefaktet og eksporter på nytt, ikke rediger denne fila. -->
<html lang="nb">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(deck.title)}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?${fonts}&display=swap">
<style>${CSS}</style>
</head>
<body>
<main class="viewport"><div class="stage">
${slides.join('\n')}
</div></main>
<div class="notes" aria-live="polite"></div>
<nav class="bar" aria-label="Presentasjonen">
<div class="decks"><a href="../">FS Kravforvaltning</a>${nav}<a href="../kom-i-gang.html">Kom i gang</a></div>
<button class="prev" aria-label="Forrige">‹</button><span class="count"></span><button class="next" aria-label="Neste">›</button>
<button class="tnotes" title="Notater (N)">Notater</button><button class="full" title="Fullskjerm (F)">Fullskjerm</button>
</nav>
<script>${JS}</script>
</body>
</html>
`;
  writeFileSync(join(ut, d.file), page);
  console.log(d.file, deck.order.length, 'slides');
}
