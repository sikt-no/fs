# Spørsmål og svar — `bat-analyze` (2026-07-08)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Gå gjennom åpne spørsmål?

**Spørsmål:** Analysen er skrevet med 7 åpne tekniske spørsmål. Vil du gå gjennom dem nå, ett om gangen?

**Alternativer:**
- Gå gjennom spørsmålene — Vi tar de 7 spørsmålene ett om gangen; beslutninger føres inn i analysedokumentet.
- Stopp her — Avslutt økten; spørsmålene står åpne i analysis-dokumentet til senere.

**Svar:** Gå gjennom spørsmålene

---

## 2. Mock-first-utvikling

**Spørsmål:** Spørsmål 1/7 — Skal frontenden bygges mock-first (lokal mock-SDL + MSW i src/mocks/personbrukere/), slik applikasjoner gjorde, så fs-admin-arbeidet ikke blokkeres av subgraf-stegene?

**Alternativer:**
- Ja — mock-first (Anbefalt) — Egen src/mocks/personbrukere/ med schema, fixtures, handlers, store og teardown-plan — samme mekanikk og codegen-eksklusjon som applikasjoner.
- Nei — vent på subgraf — Bygg først når ekte skjema finnes og typer kan genereres — frontend-arbeidet blokkeres av pipeline-steg 4/6.
- Delvis — kun UI-skall først — Bygg layout/navigasjon uten data nå, utsett all datahenting til ekte skjema — mindre mock å rydde, men lite testbart.

**Svar:** Ja — mock-first (Anbefalt)

---

## 3. Delvis suksess-konvolutt

**Spørsmål:** Spørsmål 2/7 — Hvordan skal delvis suksess modelleres i tildel/fjern-mutasjonenes resultat-konvolutt?

**Alternativer:**
- Per-element-resultat (Anbefalt) — Suksess-varianten får både `tildelte` og `avviste` lister med årsak per element — oppfyller kravet direkte; MutasjonAvvist beholdes for totalfeil.
- Alt-eller-ingenting — Behold dagens konvolutt uendret; backend avviser hele operasjonen ved én feil — avviker fra kravets delvis-suksess-scenario.
- Utsett til subgraph-plan — Mock-en modellerer per-element-resultat som arbeidshypotese, men endelig konvolutt avgjøres i subgraph-plan-steget.

**Svar:** Per-element-resultat (Anbefalt)

---

## 4. Feature flag

**Spørsmål:** Spørsmål 3/7 — Hvordan skal personbruker-featuren gates?

**Alternativer:**
- Nytt flagg `personbrukere` (Anbefalt) — Eget flagg via generate:unleash — uavhengig utrulling fra applikasjoner og menyen; meny-underpunkt + indeks-kort gates av samme flagg.
- Gjenbruk `tilgangsstyring-meny` — Featuren følger menyens synlighet — én bryter mindre, men kan ikke rulles ut/av uavhengig av applikasjoner.
- Ingen gating — Featuren er synlig så snart den er merget — enklest, men eksponerer halvferdig funksjonalitet i test/prod.

**Svar:** Nytt flagg `personbrukere` (Anbefalt)

---

## 5. Historikk-tolkning

**Spørsmål:** Spørsmål 4/7 — Er det riktig at «sporbar i historikk» i v1 kun betyr backend-persistens + «Tildelt av»/«Tildelt dato» i UI, uten egen historikk-visning?

**Alternativer:**
- Ja — kun backend-persistens (Anbefalt) — UI viser Tildelt av/dato; historikk-visning kommer med BRU-PER-HIS-kravene senere. Skjemaet må likevel designes så historikk kan hentes ut.
- Nei — v1 trenger historikk-UI — Scope-utvidelse: egen historikk-fane/panel på detaljsiden må designes og bygges nå — krever ny kravavklaring med produkteier.
- Avklar med produkteier — Tolkningen løftes til produkteier før plan-fasen; spørsmålet står åpent i analysen så lenge.

**Svar:** Ja — kun backend-persistens (Anbefalt)

---

## 6. Filterkilder

**Spørsmål:** Spørsmål 5/7 — Skal mock/skjema tilby dedikerte filter-options-queries for rolle/miljø/organisasjon-filtrene, eller statiske kilder i v1?

**Alternativer:**
- Filter-options-queries (Anbefalt) — Dedikerte queries à la applikasjonTilgangerFilterOptions + mineBrukerAdminOrganisasjoner — oppfyller kravets «representert i listen»-semantikk; miljø kan fortsatt være demo/prod-konstanter bak samme query.
- Statiske kilder i v1 — Hardkod miljø (demo/prod) og hent roller fra en statisk liste — raskere, men avviker fra kravets semantikk og må gjøres om senere.
- Utsett til subgraph-plan — Mock-en bruker statiske verdier nå; endelig kilde avgjøres i subgraph-plan-steget.

**Svar:** Filter-options-queries (Anbefalt)

---

## 7. Rute-navn

**Spørsmål:** Spørsmål 6/7 — Hvilket rutenavn skal personbruker-featuren ha?

**Alternativer:**
- /tilgangsstyring/personbrukere (Anbefalt) — Matcher skissens brødsmulesti og applikasjoner-strukturen; detaljside på /tilgangsstyring/personbrukere/[id].
- /tilgangsstyring/brukere/personer — Ekstra nivå som åpner for maskinbrukere under /brukere/ senere — men avviker fra brødsmulestien og gir et tomt mellomnivå.

**Svar:** /tilgangsstyring/personbrukere (Anbefalt)

---

## 8. Rollekode-verdier

**Spørsmål:** Spørsmål 7/7 — Hvordan håndterer vi at de konkrete rollekode-verdiene for brukeradministrator/super-brukeradministrator ikke er definert ennå?

**Alternativer:**
- Arbeidsverdier i mock (Anbefalt) — Mock-personas bruker arbeidsverdiene `brukeradministrator` og `super_brukeradministrator`; endelige koder bekreftes mot rolledefinisjonsarbeidet før teardown av mocken.
- Jeg vet verdiene — oppgir dem — Du kjenner de reelle rollekodene og oppgir dem nå (bruk gjerne Other-feltet).
- Blokker på avklaring — Spørsmålet holdes åpent og eskaleres til rolledefinisjonsarbeidet før plan-fasen — kan forsinke mock-design.

**Svar:** Arbeidsverdier i mock (Anbefalt)

---
