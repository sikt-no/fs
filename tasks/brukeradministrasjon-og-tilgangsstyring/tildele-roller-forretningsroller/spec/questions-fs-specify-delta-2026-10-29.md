# Spørsmål og svar — `fs-specify-delta` (2026-10-29)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

Kjøringen ble gjort av en agent uten `AskUserQuestion`. Svarene merket «gitt på forhånd» er Kjetils, gitt i oppdraget før kjøringen. Svarene merket «standardvalg» er agentens konservative valg, og står som åpne spørsmål i delta-spec-en.

---

## 1. Endringskilde

**Spørsmål:** Hva er endringskilden?

**Alternativer:**
- Test-fil(er)
- Markdown-dokument(er)
- Commit(s)
- Branch — diff mot `origin/main`

**Svar:** Branch — `krav/rolleliste-begrenset-av-tak` (gitt på forhånd)

---

## 2. `@draft`-regelen

**Spørsmål:** Den eneste endringen er en `@draft`-regel, som filteret normalt holder utenfor. Skal den være med?

**Alternativer:**
- Ta den med som endringen, uten å endre statusen
- Avbryt og ferdigstill kravet med `fs-krav` først

**Svar:** Ta den med som endringen, uten å endre statusen (gitt på forhånd)

---

## 3. Oppgavemappe

**Spørsmål:** Hvilken oppgave hører delta-en til?

**Alternativer:**
- tildele-roller-forretningsroller — BAT-326, har `@BRU-PER-GRU-003` i scope-raden
- Ny oppgave

**Svar:** tildele-roller-forretningsroller (standardvalg: eksisterende oppgave med kravet i scope-raden. Om regelen skal ha egen oppgave, står som åpent spørsmål)

---

## 4. Skisser

**Spørsmål:** Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) knyttet til denne endringen?

**Alternativer:**
- Ja
- Nei

**Svar:** Ja (gitt på forhånd)

**Fritekst:** Ingen Figma-skisser. Bare et skjermbilde av dagens dialog «Tildel roller» (Universitetet i Stavanger, Produksjon), som illustrasjon av dagens tilstand, ikke et design.

---

## 5. Skjermbildet avviker fra regelen

**Spørsmål:** Skjermbildet `Dagens dialog «Tildel roller»` viser roller utenfor taket i valglisten. Hva skal vi gjøre?

**Alternativer:**
- Skissen er riktig — kravene mangler
- Kravene er riktige — skissen er utdatert
- Begge er riktige — ulikt scope
- Vet ikke

**Svar:** Kravene er riktige — skissen er utdatert (gitt på forhånd: skjermbildet viser dagens tilstand)

---

## 6. Tekst for tom valgliste

**Spørsmål:** Valglisten kan nå være tom fordi ingen applikasjon har tak. Skal det ha en egen tekst, eller gjelder dagens «Ingen roller å tildele i denne kombinasjonen.»?

**Alternativer:**
- Egen tekst
- Dagens tekst
- Vet ikke

**Svar:** Vet ikke (standardvalg: dagens tekst står i implementasjonsdetaljene, og spørsmålet er et åpent designspørsmål)

---

## 7. Perioder i taket

**Spørsmål:** Taket er temporalt. Hvilke delegeringer teller?

**Alternativer:**
- Bare de som gjelder nå
- Også de som starter senere
- Vet ikke

**Svar:** Vet ikke (standardvalg: bare de som gjelder nå, som åpent spørsmål)

---

## 8. Etter delta-spec-en

**Spørsmål:** Gå gjennom åpne spørsmål, eller stopp her?

**Alternativer:**
- Gå gjennom åpne spørsmål
- Stopp her

**Svar:** Stopp her (standardvalg)
