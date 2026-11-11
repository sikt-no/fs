// Hjelpefunksjoner fra den agentiske kjøringen av «Gi tilbudsgaranti ved tidlig opptak» (2026-11-10 og 2026-11-11).
// Ikke en del av testene: testene står i cdp-tester/ og skal kunne kjøres uten dette. Fila er med så den
// som kjører neste gang, slipper å skrive hjelperne på nytt. Se overlevering-2026-11-11.md.
//
// Bruk (cdp-skillen, Chrome-profilen ~/chrome-cdp-test startet med --remote-debugging-port=9222):
//   browser-harness-js 'await session.connect({profileDir: "<hjem>/chrome-cdp-test"}); const t = (await session.Target.getTargets({})).targetInfos.find(t => t.type === "page" && t.url.includes("fsadmin")); await session.use(t.targetId); globalThis.S = "<mappa for kjøringen>"; return 1'
//   cat akseptansetest/gi-tilbudsgaranti-ved-tidlig-opptak/oppsett/cdp-hjelpere.js | browser-harness-js
// Funksjonene ligger da i globalThis i serveren til den stoppes (browser-harness-js --stop).
// S er mappa skjermbildene skrives til (bilde()).

globalThis.sleep = (ms) => new Promise(r => setTimeout(r, ms));
globalThis.ev = async (expr) => (await session.Runtime.evaluate({expression: expr, returnByValue: true, awaitPromise: true})).result.value;
globalThis.bilde = async (navn) => { const shot = await session.Page.captureScreenshot({format: 'png'}); await Bun.write(S + '/' + navn + '.png', Buffer.from(shot.data, 'base64')); return navn + '.png'; };
globalThis.gaa = async (url, ms = 6000) => { await session.Page.navigate({url}); await sleep(ms); };
globalThis.tast = async (key, code, kc) => { for (const type of ['keyDown', 'keyUp']) await session.Input.dispatchKeyEvent({type, key, code, windowsVirtualKeyCode: kc}); await sleep(250); };
globalThis.skriv = async (t) => { await session.Input.insertText({text: t}); await sleep(300); };
globalThis.klikk = async (expr) => {
  await session.Page.bringToFront();
  const box = await ev('(() => { const e = ' + expr + '; if (!e) return null; e.scrollIntoView({block:"center"}); const r = e.getBoundingClientRect(); return {x: r.x + r.width/2, y: r.y + r.height/2}; })()');
  if (!box) throw new Error('fant ikke: ' + expr);
  await session.Input.dispatchMouseEvent({type: 'mouseMoved', x: box.x, y: box.y}); await sleep(80);
  await session.Input.dispatchMouseEvent({type: 'mousePressed', x: box.x, y: box.y, button: 'left', buttons: 1, clickCount: 1}); await sleep(80);
  await session.Input.dispatchMouseEvent({type: 'mouseReleased', x: box.x, y: box.y, button: 'left', buttons: 0, clickCount: 1}); await sleep(500);
  return true;
};
globalThis.byttPersona = async (navn) => {
  await session.Page.bringToFront();
  for (let forsok = 0; forsok < 3; forsok++) {
    const naa = await ev("document.querySelector('button[role=combobox]')?.innerText.split('\\n')[0]");
    if (naa === navn) return navn;
    if (await ev("/Testpersonene kunne ikke lastes/.test(document.body.innerText)")) { await session.Page.reload({}); await sleep(7000); continue; }
    if (await ev("document.querySelector('button[role=combobox]').getAttribute('aria-expanded')") !== 'true') { await klikk("document.querySelector('button[role=combobox]')"); await sleep(1500); }
    await ev("(() => { const i = [...document.querySelectorAll('input')].find(i => i.placeholder === 'Søk …'); i.focus(); i.select(); })()");
    await tast('Backspace', 'Backspace', 8);
    await skriv(navn.split(' • ')[0]);
    let opts = [];
    for (let t = 0; t < 10; t++) { await sleep(700); opts = JSON.parse(await ev("JSON.stringify([...document.querySelectorAll('[role=option]')].map(o => o.innerText.trim()))")); if (opts.includes(navn)) break; }
    if (!opts.includes(navn)) { await tast('Escape', 'Escape', 27); await session.Page.reload({}); await sleep(7000); continue; }
    await klikk("[...document.querySelectorAll('[role=option]')].find(o => o.innerText.trim() === " + JSON.stringify(navn) + ")");
    await sleep(4000);
  }
  const etter = await ev("document.querySelector('button[role=combobox]')?.innerText.split('\\n')[0]");
  if (etter !== navn) throw new Error('personaen ble ' + etter);
  return etter;
};
globalThis.FORVALTER = 'ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR)';
globalThis.SAKSBEHANDLER = 'KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT)';
globalThis.TIDLIG = 'https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0/plasstildeling/tidlig-opptak';
globalThis.sakUrl = globalThis.sakUrl || {};
globalThis.aapneSak = async (snr, steg) => {
  if (!sakUrl[snr]) {
    await gaa('https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0/soknadsbehandling?searchText=' + snr, 6000);
    const href = await ev("[...document.querySelectorAll('a[href*=\"/sak/\"]')].find(a => a.innerText.includes(" + JSON.stringify(snr) + "))?.href ?? null");
    if (!href) throw new Error('fant ikke saken ' + snr);
    sakUrl[snr] = href.replace(/\/[a-z]+$/, '');
  }
  await gaa(sakUrl[snr] + '/' + steg, 6000);
};
globalThis.lesP = async (snr, studienr) => {
  await aapneSak(snr, 'oppsummering');
  const t = await ev("document.querySelector('main').innerText");
  const i = t.indexOf('Studienummer: ' + studienr);
  const m = t.slice(i, i + 900).match(/\nORD\n\tVES\t([0-9,.]+)/);
  return m ? m[1] : null;
};
globalThis.feltId = async (navn) => await ev("(() => { const l = [...document.querySelectorAll('label')].find(l => l.innerText.trim() === 'Poenggrense tidlig opptak for ' + " + JSON.stringify(navn) + "); return l ? l.htmlFor : null; })()");
globalThis.settGrense = async (navn, verdi) => {
  const id = await feltId(navn); if (!id) throw new Error('fant ikke feltet for ' + navn);
  const for_ = await ev("document.getElementById('" + id + "').value");
  await ev("(() => { const i = document.getElementById('" + id + "'); i.scrollIntoView({block:'center'}); i.focus(); i.select(); })()");
  await tast('Backspace', 'Backspace', 8); if (verdi !== '') await skriv(verdi);
  await ev("document.getElementById('" + id + "').blur()"); await sleep(300);
  await ev("[...document.querySelectorAll('button')].find(b => b.innerText.trim() === 'Lagre poenggrenser').click()");
  await sleep(2500);
  const melding = await ev("(document.body.innerText.match(/Poenggrensene er lagret\\.?/) || ['(ingen melding)'])[0]");
  await session.Page.reload({}); await sleep(7000);
  const etter = await ev("document.getElementById('" + (await feltId(navn)) + "').value");
  return {for: for_, etter, melding};
};
globalThis.velg = async (labelTekst, optTekst) => await ev("(() => { const s = [...document.querySelectorAll('select')].find(s => (s.labels?.[0]?.innerText||'').split('\\n')[0].trim() === " + JSON.stringify(labelTekst) + "); if (!s) return 'fant ikke feltet'; const o = [...s.options].find(o => o.text.trim() === " + JSON.stringify(optTekst) + "); if (!o) return 'fant ikke valget'; const set = Object.getOwnPropertyDescriptor(HTMLSelectElement.prototype, 'value').set; set.call(s, o.value); s.dispatchEvent(new Event('change', {bubbles: true})); return 'valgt'; })()");
globalThis.lesValg = async () => await ev("JSON.stringify([...document.querySelectorAll('select')].filter(s => /^(Konklusjon|Behandlingsstatus)/.test(s.labels?.[0]?.innerText||'')).map(s => s.labels[0].innerText.split('\\n')[0] + '=' + s.options[s.selectedIndex].text))");
// konklusjon: tekst, eller null for å hoppe over steg 4
globalThis.klargjor = async (snr, konklusjon) => {
  await aapneSak(snr, 'tidligopptak');
  let a = 'hoppet over', m1 = '';
  if (konklusjon) { a = await velg('Konklusjon', konklusjon); await sleep(2500); m1 = await ev("(document.body.innerText.match(/Konklusjonen er lagret\\.?/) || ['(ingen melding)'])[0]"); }
  const b = await velg('Behandlingsstatus', 'Behandlet'); await sleep(2500);
  await session.Page.reload({}); await sleep(6000);
  return {a, m1, b, etter: await lesValg()};
};
globalThis.gjennomfor = async (navn) => {
  await gaa(TIDLIG, 7000);
  await klikk("[...document.querySelectorAll('main button')].find(b => b.innerText.trim() === 'Kjør tidligopptak' && b.offsetParent && !b.closest('dialog'))");
  for (let t = 0; t < 30; t++) { await sleep(1500); if (await ev("[...document.querySelectorAll('dialog')].some(d => d.open && d.innerText.includes('Kjøre tidligopptak') && !/Beregner resultatet/.test(d.innerText) && /Resultat/.test(d.innerText))")) break; }
  const dialog = (await ev("[...document.querySelectorAll('dialog')].find(d => d.open && d.innerText.includes('Kjøre tidligopptak'))?.innerText ?? ''")).replace(/\s*\n\s*/g, ' / ');
  await bilde(navn + '-dialog');
  await klikk("[...[...document.querySelectorAll('dialog')].find(d => d.open && d.innerText.includes('Kjøre tidligopptak')).querySelectorAll('button')].find(b => b.innerText.trim() === 'Kjør tidligopptak')");
  let melding = '(ingen melding)';
  for (let t = 0; t < 20; t++) { await sleep(1500); const m = await ev("(document.body.innerText.match(/Tidligopptaket er kjørt[^\\n]*/) || [null])[0]"); if (m) { melding = m; break; } }
  await bilde(navn + '-kjort');
  return {dialog, melding};
};
globalThis.lesGaranti = async (snr, navn) => {
  await aapneSak(snr, 'oppsummering');
  if (!(await ev("[...document.querySelectorAll('h2, h3')].some(h => h.innerText.trim() === 'Søknadsalternativer')"))) { await klikk("[...document.querySelectorAll('button, a')].find(e => e.innerText.trim() === 'Søknadsalternativer')"); await sleep(2500); }
  const antall = await ev("(() => { const h = [...document.querySelectorAll('h2, h3')].find(h => h.innerText.trim() === 'Søknadsalternativer'); return h.parentElement.querySelectorAll('details').length; })()");
  for (let i = 0; i < antall; i++) {
    const apen = await ev("[...document.querySelectorAll('h2, h3')].find(h => h.innerText.trim() === 'Søknadsalternativer').parentElement.querySelectorAll('details')[" + i + "].open");
    if (!apen) { await klikk("[...document.querySelectorAll('h2, h3')].find(h => h.innerText.trim() === 'Søknadsalternativer').parentElement.querySelectorAll('details')[" + i + "].querySelector('summary')"); await sleep(1500); }
  }
  const r = JSON.parse(await ev("JSON.stringify([...[...document.querySelectorAll('h2, h3')].find(h => h.innerText.trim() === 'Søknadsalternativer').parentElement.querySelectorAll('details')].map(d => ({t: d.querySelector('summary').innerText.split('\\n')[0], x: d.innerText.replace(/\\n+/g, ' / ')})))"));
  if (navn) await bilde(navn + '-S');
  return r.map(a => a.t + ': ' + (a.x.match(/Tilbudsgaranti fra forvalter \/ ([^/]+)/)?.[1]?.trim() ?? '?'));
};
globalThis.TILBYDER = 'KORT DOMPAP • OPPTAK_FORVALTER (UIT)';
globalThis.apneSkuff = async () => {
  if (!(await ev("[...document.querySelectorAll('h2, h3')].some(h => h.innerText.trim() === 'Søknadsalternativer')"))) { await klikk("[...document.querySelectorAll('button, a')].find(e => e.innerText.trim() === 'Søknadsalternativer')"); await sleep(2500); }
  const antall = await ev("[...document.querySelectorAll('h2, h3')].find(h => h.innerText.trim() === 'Søknadsalternativer').parentElement.querySelectorAll('details').length");
  for (let i = 0; i < antall; i++) {
    if (!(await ev("[...document.querySelectorAll('h2, h3')].find(h => h.innerText.trim() === 'Søknadsalternativer').parentElement.querySelectorAll('details')[" + i + "].open"))) { await klikk("[...document.querySelectorAll('h2, h3')].find(h => h.innerText.trim() === 'Søknadsalternativer').parentElement.querySelectorAll('details')[" + i + "].querySelector('summary')"); await sleep(1200); }
  }
};
// alt: starten av tittelen, f.eks. 'DATATEKNIKK'; felt: 'behandler' | 'tilbyder' | 'forvalter'
globalThis.settGaranti = async (snr, alt, felt, tekst) => {
  await aapneSak(snr, 'oppsummering'); await apneSkuff();
  const r = await ev("(() => { const d = [...[...document.querySelectorAll('h2, h3')].find(h => h.innerText.trim() === 'Søknadsalternativer').parentElement.querySelectorAll('details')].find(d => d.querySelector('summary').innerText.includes(" + JSON.stringify(alt) + ")); if (!d) return 'fant ikke alternativet'; const s = [...d.querySelectorAll('select')].find(s => (s.labels?.[0]?.innerText || '').split('\\n')[0].trim() === 'Tilbudsgaranti fra " + felt + "'); if (!s) return 'fant ikke feltet (' + [...d.querySelectorAll('label')].map(l => l.innerText.split('\\n')[0]).join(', ') + ')'; if (s.disabled) return 'feltet er låst'; const o = [...s.options].find(o => o.text.trim() === " + JSON.stringify(tekst) + "); if (!o) return 'fant ikke valget (' + [...s.options].map(o => o.text).join(' ; ') + ')'; const set = Object.getOwnPropertyDescriptor(HTMLSelectElement.prototype, 'value').set; set.call(s, o.value); s.dispatchEvent(new Event('change', {bubbles: true})); return 'valgt'; })()");
  await sleep(2500);
  const m = await ev("(document.body.innerText.match(/Tilbudsgaranti lagret[^\\n]*/) || ['(ingen melding)'])[0]");
  return r + ' / ' + m;
};
globalThis.lesAlle = async (snr, navn) => {
  await aapneSak(snr, 'oppsummering'); await apneSkuff();
  const r = JSON.parse(await ev("JSON.stringify([...[...document.querySelectorAll('h2, h3')].find(h => h.innerText.trim() === 'Søknadsalternativer').parentElement.querySelectorAll('details')].map(d => d.querySelector('summary').innerText.split('\\n')[0] + ': ' + ['behandler','tilbyder','forvalter'].map(f => { const s = [...d.querySelectorAll('select')].find(s => (s.labels?.[0]?.innerText || '').split('\\n')[0].trim() === 'Tilbudsgaranti fra ' + f); const tekstvis = d.innerText.match(new RegExp('Tilbudsgaranti fra ' + f + '\\\\n([^\\\\n]+)')); return f + '=' + (s ? s.options[s.selectedIndex].text : (tekstvis ? tekstvis[1] : '?')); }).join(', ')))"));
  if (navn) await bilde(navn + '-S');
  return r;
};
globalThis.provekjor = async (navn) => {
  await gaa(TIDLIG, 7000);
  await klikk("[...document.querySelectorAll('main button')].find(b => b.innerText.trim() === 'Kjør tidligopptak' && b.offsetParent && !b.closest('dialog'))");
  for (let t = 0; t < 30; t++) { await sleep(1500); if (await ev("[...document.querySelectorAll('dialog')].some(d => d.open && d.innerText.includes('Kjøre tidligopptak') && !/Beregner resultatet/.test(d.innerText) && /Resultat/.test(d.innerText))")) break; }
  const tekst = await ev("[...document.querySelectorAll('dialog')].find(d => d.open && d.innerText.includes('Kjøre tidligopptak'))?.innerText ?? ''");
  if (navn) await bilde(navn);
  const tall = (lbl) => { const m = tekst.match(new RegExp(lbl + '\\s*\\n(?:\\s*Må behandles\\s*\\n)?\\s*(\\d+)')); return m ? parseInt(m[1]) : null; };
  await klikk("[...[...document.querySelectorAll('dialog')].find(d => d.open).querySelectorAll('button')].find(b => b.innerText.trim() === 'Avbryt')");
  await sleep(1000);
  return {tekst: tekst.replace(/\s*\n\s*/g, ' / '), ikkeBehandlet: tall('Har saker som ikke er behandlet'), deltar: tall('Deltar i tidlig opptak'), totale: tall('Totale tilbudsgarantier'), forstePri: tall('Tilbudsgarantier med første prioritet')};
};

// Lagt til underveis 2026-11-11.

// Klargjøring K med valg: konklusjon (eller null for å hoppe over steg 4) og behandlet (false hopper over steg 5).
globalThis.klargjor2 = async (snr, konklusjon, behandlet) => {
  await aapneSak(snr, 'tidligopptak');
  if (konklusjon) { await velg('Konklusjon', konklusjon); await sleep(2500); }
  if (behandlet) { await velg('Behandlingsstatus', 'Behandlet'); await sleep(2500); }
  await session.Page.reload({}); await sleep(6000);
  return await lesValg();
};

// Leser dialogen «Kjøre tidligopptak?» og lukker den med «Avbryt», uten å gjennomføre.
// Åpner ikke dialogen ved første klikk, prøv en gang til.
globalThis.lesDialog = async (navn) => {
  await gaa(TIDLIG, 9000);
  await klikk("[...document.querySelectorAll('main button')].find(b => b.innerText.trim() === 'Kjør tidligopptak' && b.offsetParent && !b.closest('dialog'))");
  const D = "[...document.querySelectorAll('dialog')].find(d => d.open && d.innerText.includes('Kjøre tidligopptak'))";
  for (let t = 0; t < 30; t++) { await sleep(1500); if (await ev("(() => { const d = " + D + "; return !!d && !/Beregner resultatet/.test(d.innerText) && /Resultat/.test(d.innerText); })()")) break; }
  const tekst = (await ev("(" + D + ")?.innerText ?? ''")).replace(/\s*\n\s*/g, ' / ');
  if (!tekst) throw new Error('dialogen åpnet ikke');
  await bilde(navn + '-dialog');
  await klikk("[...(" + D + ").querySelectorAll('button')].find(b => b.innerText.trim() === 'Avbryt')");
  await sleep(1500);
  const m = tekst.match(/Har saker som ikke er behandlet \/ Må behandles \/ (\d+)/);
  return {tall: m ? +m[1] : null, tekst};
};

// Hele «Tilbudsgaranti ut fra poenggrensen» for én søker: grenseFra(P) gir poenggrensen på «Datateknikk ingeniør».
globalThis.medGrense = async (navn, snr, grenseFra) => {
  const logg = {};
  await byttPersona(SAKSBEHANDLER);
  logg.P = await lesP(snr, 'B-DT');
  const P = parseFloat(logg.P.replace(',', '.'));
  const grense = (Math.round(grenseFra(P) * 10) / 10).toString().replace('.', ',');
  await byttPersona(FORVALTER); await gaa(TIDLIG, 7000);
  logg.grense = await settGrense('Datateknikk ingeniør', grense);
  await byttPersona(SAKSBEHANDLER);
  logg.K = (await klargjor(snr, 'Kan få tidligopptak, har godkjent grunn.')).etter;
  await byttPersona(FORVALTER);
  logg.G = await gjennomfor(navn);
  await byttPersona(SAKSBEHANDLER);
  logg.S = await lesGaranti(snr, navn);
  await byttPersona(FORVALTER); await gaa(TIDLIG, 7000);
  logg.tilbake = await settGrense('Datateknikk ingeniør', logg.grense.for);
  return logg;
};

return 'alle hjelpere lastet';
