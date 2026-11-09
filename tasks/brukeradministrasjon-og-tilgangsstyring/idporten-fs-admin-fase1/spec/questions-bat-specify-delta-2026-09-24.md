# Spørsmål og svar — `bat-specify-delta` (2026-09-24)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Valg av endringskilde

**Spørsmål:** Hvilken endringskilde skal delta-spec-en bygge på?

**Alternativer:**
- Test-fil: TIL-PÅL-PÅL-004 (Anbefalt) — Den nye krav-fila autentisere_person_med_idporten.feature (@should @planned, endret i dag 22:22), altså Min Kompetanse-kravet som planen forutsetter. Retagges til @in-progress lokalt.
- Test-filer: 004 + 003 — Ta med autentisere_med_idporten.feature (@TIL-PÅL-PÅL-003, allerede @in-progress, uendret siden 23.09) også.
- Commit eller branch — Diff fra en commit eller branch. Merk at krav-filene i sikt-no/fs er ucommittet.

**Svar:** Test-filer: 004 + 003

---

## 2. Ref-slug

**Spørsmål:** Hvilken kort ref skal delta-en ha (brukes i filnavn og krav-input-mappe)?

**Alternativer:**
- idporten-min-kompetanse (Anbefalt) — Gir spec-changes-2026-09-24-idporten-min-kompetanse.md. Den nye flaten er Min Kompetanse via ID-porten, og applikasjonsstyrte tak.
- idporten-apptak — Vektlegger at tilgangene følger applikasjonen (taket) mer enn Min Kompetanse.

**Svar:** idporten-min-kompetanse (Anbefalt)

---

## 3. Skisser

**Spørsmål:** Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) knyttet til denne endringen?

**Alternativer:**
- Nei — Ingen skisser. Kravene gjelder autentisering og tokeninnhold uten brukerflate.
- Ja — Jeg oppgir skissene.

**Svar:** Nei

---

## 4. Post-spec flow

**Spørsmål:** Delta-spec-en er skrevet med 5 åpne spørsmål. Hva vil du gjøre nå?

**Alternativer:**
- Gå gjennom åpne spørsmål — Ett og ett. Beslutning og begrunnelse skrives inn i delta-dokumentet.
- Fortsett til bat-analyze — Analyser koden mot denne delta-fila.
- Stopp her — Avslutt.

**Svar:** Gå gjennom åpne spørsmål

---

## 5. Åpent spørsmål 1/5 — grunntilgang mot åpne roller

**Spørsmål:** Kravet 004 sier «grunntilgangen alle brukere har» for Min Kompetanse. For FS Admin og ukjent klient står det «kun det som er åpent for alle innloggede brukere». Er det to ulike tilgangssett?

**Alternativer:**
- Ja, gulv mot åpne roller — «Grunntilgang» betyr gulvrollene (for eksempel egne data), og «åpent for alle innloggede» betyr de åpne rollene. Min Kompetanse får altså mer enn FS Admin. Kravteksten bør si det tydelig.
- Nei, samme sett — Begge formuleringene betyr det samme tilgangssettet. Da skiller ikke 004-scenariene seg i tilgang, bare i ordlyd. Formuleringene bør gjøres like.
- Usikker, avklares senere — Spørsmålet står åpent, og vi tar det med til bat-krav eller bat-analyze.

**Svar:** Ja, gulv mot åpne roller

---

## 6. Åpent spørsmål 2/5 — registrert person via Min Kompetanse

**Spørsmål:** Bakgrunnen i 004 forutsetter en uregistrert person. Hva skal skje når en registrert person med tildelte roller logger inn via Min Kompetanse?

**Alternativer:**
- Rollene, begrenset av taket — Personen får de tildelte rollene sine, men bare så langt Min Kompetanse sitt tak tillater. Pluss gulvet. Samme mønster som Feide-stien.
- Bare gulvet — Min Kompetanse gir alltid bare grunntilgangen, uansett tildelinger. Tildelte roller gjelder kun via FS Admin.
- Utenfor scope nå — 004 dekker bare uregistrerte personer. Spesifiseres senere via bat-krav.

**Svar:** Rollene, begrenset av taket

---

## 7. Åpent spørsmål 3/5 — 003-reglene for alle klienter

**Spørsmål:** 004 gjentar ikke reglene fra 003 om signatur og utløp, audiens, acr og testmiljø. Gjelder de for alle ID-porten-klienter, også Min Kompetanse?

**Alternativer:**
- Ja, for alle klienter — Reglene gjelder utstederen, ikke applikasjonen. De gjelder alle ID-porten-klienter, også Min Kompetanse og ukjente klienter. 003 kan eventuelt formuleres mer generelt.
- Ja, men acr skal håndheves — Signatur, audiens og testmiljø gjelder alle. Min Kompetanse krever likevel et minste autentiseringsnivå (for eksempel substantial), som må spesifiseres.
- Usikker, avklares senere — Spørsmålet står åpent.

**Svar:** Ja, for alle klienter

---

## 8. Åpent spørsmål 4/5 — GitHub-issue for 004

**Spørsmål:** 004 har ikke noe GitHub-issue. Kravfila sier at det opprettes når Min Kompetanse-integrasjonen planlegges. Hvordan vil du håndtere det?

**Alternativer:**
- Opprett via bat-krav nå — Planen forutsetter allerede Min Kompetanse, så issuet bør opprettes i sikt-no/fs (som sub-issue under #476) sammen med ordlydsendringene fra spørsmål 1 til 3.
- Vent — Behold det som åpen oppfølging. Det opprettes når Min Kompetanse-integrasjonen planlegges formelt.

**Svar:** Vent

---

## 9. Åpent spørsmål 5/5 — forutsetninger hos Digdir

**Spørsmål:** Både Min Kompetanse (004) og Sikt (003, fase 0) må være registrerte klienter hos Digdir. Sikt-registreringen var ikke bestilt per 18.09. Hvordan skal dette stå i delta-en?

**Alternativer:**
- Ekstern forutsetning — Noter som forutsetning utenfor kravene. Den blokkerer produksjonssetting, men ikke analyse, plan eller utvikling mot testmiljøet. Spørsmålet lukkes her.
- Status er endret — Bestillingen er gjort eller statusen er ny. Jeg oppgir den.
- La stå åpent — Spørsmålet står åpent til registreringene er bekreftet.

**Svar:** Ekstern forutsetning

---
