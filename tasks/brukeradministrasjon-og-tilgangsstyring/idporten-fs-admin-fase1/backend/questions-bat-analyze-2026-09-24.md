# Spørsmål og svar — `bat-analyze` (2026-09-24)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Post-analysis flow

**Spørsmål:** Analysen er skrevet med 11 funn og 5 åpne spørsmål. Vil du gå gjennom de åpne spørsmålene nå?

**Alternativer:**
- Gå gjennom åpne spørsmål — Ett og ett, med anbefaling der det er alternativer.
- Stopp her — Avslutt. Spørsmålene står åpne i analysen.

**Svar:** Gå gjennom åpne spørsmål

---

## 2. Åpent spørsmål 1/5 — deaktivert ID-porten-app

**Spørsmål:** Hva skal en person få når client_id peker på en registrert, men deaktivert ID-porten-app? Jeg anbefaler (a). Det er samme veto som for Feide-apper i dag (0061: deaktivert app gir tomt), og det krever bare at den nye tabellen legges inn i applikasjon_er_deaktivert. Deaktivering er et bevisst stengsignal og er sterkere enn «ukjent».

**Alternativer:**
- (a) Tomt resultat (Anbefalt) — Samme som for Feide-apper. Ingen organisasjonstilganger og ingen åpne roller. Forutsetter at applikasjon_er_deaktivert får den nye apptabellen.
- (b) Bare åpne roller — Behandles som en ukjent klient (004 regel 3). Mildere, men avviker fra Feide-vetoet.
- (c) Avvis som uautentisert — Forespørselen stoppes i coprocessoren. Ny oppførsel, og ingen annen utsteder gjør det i dag.

**Svar:** (a) Tomt resultat (Anbefalt)

---

## 3. Åpent spørsmål 2/5 — scenario for registrert person via Min Kompetanse

**Spørsmål:** Beslutning 2 (registrert person via Min Kompetanse får rollene sine begrenset av taket, pluss gulvet) finnes ikke som scenario i 004. Jeg anbefaler (a). Da blir kravet kilden, bat-verify kan sjekke det, og scenariet er det eneste som skiller en riktig implementasjon fra en som ignorerer tildelingene på Min Kompetanse-stien.

**Alternativer:**
- (a) Inn i 004 via bat-krav (Anbefalt) — Scenariet skrives inn i 004 før planen oppdateres, sammen med ordlyden fra beslutning 1 og 3.
- (b) Bare i plan og tester — Planen og testene dekker det, og kravet skrives senere. Raskere, men bat-verify har ikke noe å sjekke mot.

**Svar:** (b) Bare i plan og tester

---

## 4. Åpent spørsmål 3/5 — tak og gulv i deployerte miljø

**Spørsmål:** Min Kompetanses tak og gulvradene finnes bare i eksempeldata. I deployerte miljø forvaltes de utenfor repoet. Hvordan skal analysen regne med dem? Jeg anbefaler (a), fordi koden ikke kan garantere data som forvaltes utenfor repoet.

**Alternativer:**
- (a) Forutsetning for utrulling (Anbefalt) — Planen får en eksplisitt forutsetning: før 004 kan verifiseres i test eller prod, må taket og gulvet for Min Kompetanse finnes der. Kode og tester bruker eksempeldata.
- (b) Regn med at de finnes — Gulv og tak finnes allerede i test og prod for Feide-appen og kopieres. Ingen egen forutsetning.
- (c) Legg dem i migrering — Planen legger prod- og testrader i en migrering utenfor @eksempeldata, slik 0043/0059 gjorde for FS Admins tak.

**Svar:** (b) Regn med at de finnes

---

## 5. Åpent spørsmål 4/5 — «gulv»-begrepet i koden

**Spørsmål:** Tre kommentarer kaller de åpne rollene for «gulvet»: CoprocessorService.java:744-747, javadoc-en på tilgangerForApneRoller og headeren i 0077. Jeg anbefaler (a). Task #7 skriver om akkurat den grenen, og 0077 er kjørt, så bare Java-kommentarene kan rettes. Headeren i SQL-fila kan ikke endres uten å bryte checksummen, men det gjør ingenting fordi den bare er en kommentar.

**Alternativer:**
- (a) Rett i denne tasken (Anbefalt) — Java-kommentarene rettes når ID-porten-grenen skrives om (Task #7). 0077-headeren står, og docs/tilgangsmodell.md er fasit.
- (b) Egen opprydning — Noteres og tas i en egen endring etter fase 1.

**Svar:** (a) Rett i denne tasken (Anbefalt)

---

## 6. Åpent spørsmål 5/5 — sudo for ID-porten-brukere

**Spørsmål:** Sudo med sudoUsername gir tomt resultat for en ID-porten-bruker. Coprocessoren bygger et resultat med issuer = null, og ID-porten-grenen treffes ikke. Ingen av kravene omtaler dette. Jeg anbefaler (a): ingen krav ber om det, sudo-brukernavnet er en Feide-identitet, og (b) ville utvidet scope uten krav.

**Alternativer:**
- (a) Noter, utenfor scope (Anbefalt) — Står som kjent begrensning i planen. Tomt resultat feiler lukket.
- (b) Innenfor scope — Planen tar stilling til sudo for ID-porten-brukere i fase 1.

**Svar:** (a) Noter, utenfor scope (Anbefalt)

---
