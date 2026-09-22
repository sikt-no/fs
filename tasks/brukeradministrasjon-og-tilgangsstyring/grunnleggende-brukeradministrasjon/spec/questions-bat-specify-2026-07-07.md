# Spørsmål og svar — `bat-specify` (2026-07-07)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Finnes det skisser for kravene?

**Spørsmål:** Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) for kravene i denne spec-en?

**Alternativer:**
- Ja — Det finnes en eller flere skisser jeg kan peke på (Figma-lenke, bilde eller PDF).
- Nei — Ingen skisser — hopp over koblingen. Spec-en skrives kun mot .feature-kravene.

**Svar:** Ja

---

## 2. Hva slags skisser?

**Spørsmål:** Hva slags skisser dreier det seg om?

**Alternativer:**
- Figma-lenke(r) — Én eller flere URL-er til Figma-rammer eller -prosjekter. Jeg henter screenshot, design-kontekst, tokens og assets via Figma MCP.
- Lokal fil (bilde/PDF) — Én eller flere stier på disk til bilder eller PDF.
- Begge — Både Figma-lenker og lokale filer.

**Svar:** Figma-lenke(r)

---

## 3. Avvik: søk i personbruker-listen (BRU-PER-GRU-001)

**Spørsmål:** Skissen «Personbrukere-liste» avviker fra kravet: kravet har ett fritekst-søk (navn ELLER Feide-ID), mens skissen har to separate filterfelt (Navn og Feide-ID, kombinert med OG). Hva skal gjelde?

**Alternativer:**
- Skissen er riktig — kravene mangler — To separate filterfelt (Navn + Feide-ID) er ønsket.
- Kravene er riktige — skissen er utdatert — Ett fritekst-søk (navn ELLER Feide-ID) er ønsket.
- Begge riktige — ulikt scope
- Vet ikke — åpent spørsmål

**Svar (Other/fritekst):** «Jeg har oppdatert kravene knyttet til søk» — Batman oppdaterte `søke_opp_bruker.feature` til å ha to separate søkefelt (`Fritekst-søk på navn` + `Fritekst-søk på Feide-ID`) + `Kombinere søk og filtre`. Skissen og kravet er nå i samsvar. Den lagrede kopien i krav-input/local er oppdatert.

---

## 4. Avvik/krav-gap: Miljø-felt (BRU-PER-GRU-001 / BRU-PER-GRU-003)

**Kontekst:** Tildele/fjerne-modalene (05–08) har et «Miljø»-felt som ikke sto i kravene. Batman avklarte at miljø er et reelt begrep, og at listen i tillegg skal ha et Miljø-filter på linje med det eksisterende Rolle-filteret.

**Spørsmål:** Miljø-filteret skal legges til i søke_opp_bruker.feature (speilet på rolle-filteret). Hvordan vil du legge det til?

**Alternativer:**
- Jeg legger det til selv — Batman redigerer .feature-fila selv, bat-specify re-kopierer etterpå.
- Bruk skrive-krav nå — bat-specify overlater til skrive-krav-skillen for å legge inn de to miljø-scenarioene.
- Bare noter som krav-gap — registreres som åpent spørsmål, ingen .feature-endring nå.

**Svar:** Bruk skrive-krav nå (etter én omvalg — Batman valgte først feil og bekreftet så skrive-krav)

---

## 5. Åpent spørsmål #3 — tildele/fjerne-dialogen (BRU-PER-GRU-003)

**Spørsmål:** Hvordan skal tildele/fjerne-dialogen støtte «flere samtidig»? (Organisasjon/Miljø/Navn-velgere i skissen)

**Alternativer:**
- «Navn» er fler-valg — Organisasjon + Miljø avgrenser utvalget, «Navn» lar deg velge flere i én operasjon.
- Én om gangen (krav-gap gjenstår)
- La stå åpent (design)

**Svar:** «Navn» er fler-valg

---

## 6. Åpent spørsmål #4 — «miljø»-begrepet

**Spørsmål:** Er «miljø» her samme konsept som i applikasjoner-domenet, og hvor hentes de lovlige miljø-verdiene fra?

**Alternativer:**
- Samme som applikasjoner (demo/prod) — samme begrep/verdisett og kilde.
- Eget begrep her
- La stå åpent (analyse/subgraph)

**Svar:** Samme som applikasjoner (demo/prod)

---

## 7. Åpent spørsmål #5 — sidestørrelse

**Spørsmål:** Skissen viser «Viser 10 av 67», mens kravet fastsetter 50 per side. Hva gjelder?

**Alternativer:**
- Kravets 50 gjelder — skissens «10» er illustrativt.
- Endre til 10
- La stå åpent

**Svar:** Kravets 50 gjelder

---

## 8. Åpent spørsmål #6 — presentasjon av tilganger (direkte vs. via rolle)

**Spørsmål:** På detaljsiden: skal direkte tildelte tilganger skilles fra tilganger som kommer via en rolle?

**Alternativer:**
- Skille med kilde-merking
- Samlet uten skille (v1)
- La stå åpent (design)

**Svar:** La stå åpent (design) — bevisst utsatt til designfasen.

---

## 9. Åpent spørsmål #7 — autorisasjonsregel for tildeling (BRU-PER-GRU-003)

**Spørsmål:** Hvilken regel styrer hva en brukeradministrator kan tildele? (forslaget i feature-fila: (a) org de administrerer + (b) tilgang de selv har/kan administrere)

**Alternativer:**
- Bekreft (a)+(b)
- Kun (a) org-scope — uten (b)-betingelsen.
- La stå åpent (rolledefinisjon)

**Svar:** Kun (a) org-scope

---

## 10. Åpent spørsmål #8 — rolle-navn

**Spørsmål:** Rolle-navnene «brukeradministrator» / «super-brukeradministrator»: kan de bekreftes, eller må de sjekkes mot rolledefinisjonene i «4 - Opprette og administrere roller»?

**Alternativer:**
- Bekreftet — bruk disse
- Må sjekkes mot rolle-krav

**Svar:** Bekreftet — bruk disse

---
