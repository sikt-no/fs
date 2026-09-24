# Spørsmål og svar — `fs-specify` (2026-09-24)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Oppgavemappe

**Spørsmål:** Hvilken oppgavemappe skal spec-en skrives til? Ingen eksisterende oppgave i tasks/opptak/ handler om praksis.

**Alternativer:**
- Ny: opptak/praksiskalkulator (Recommended) — Oppretter tasks/opptak/praksiskalkulator/spec/. Slug-en matcher branch-navnet.
- Ny: opptak/registrere-praksis — Oppretter tasks/opptak/registrere-praksis/spec/. Slug-en matcher filnavnet.
- Eksisterende oppgave — Bruk en av de fem eksisterende (opprette-og-vedlikeholde-opptak, plasstildeling, regelverk, utdanningstilbud, vedtaksformidling).

**Svar:** Ny: opptak/registrere-praksis

---

## 2. Finnes det skisser?

**Spørsmål:** Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) for kravene i denne spec-en?

**Alternativer:**
- Ja — Jeg oppgir Figma-lenke eller lokal fil.
- Nei — Ingen skisser for praksisberegningen.

**Svar:** Ja

---

## 3. Skissetype

**Spørsmål:** Hva slags skisser er det?

**Alternativer:**
- Figma-lenke(r) — Lim inn URL(er) i «Other» eller i neste melding.
- Lokal fil (bilde/PDF) — Oppgi sti til fila.
- Begge — Både Figma og lokale filer.

**Svar:** Figma-lenke(r)

**Fritekst:** https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=19816-129026

---

## 4. Henting av Figma-skisse

**Spørsmål:** Figma-MCP er ikke innlogget. Hvordan skal jeg hente skissen?

**Alternativer:**
- Autentiser Figma nå (Recommended) — Jeg starter innloggingen. Du godkjenner i nettleseren, og så henter jeg screenshot, design-kontekst og sub-frames.
- Registrer bare URL — Skissen lenkes i spec-en uten persisterte artefakter. Valideringsstatus blir «Uavklart».
- Jeg beskriver innholdet — Du forteller hva skissen viser, og jeg validerer mot kravene ut fra det.

**Svar:** Autentiser Figma nå (Recommended)

---

## 5. Figma-scope

**Spørsmål:** Hvilke deler av Figma-siden skal kobles til kravene og valideres?

**Alternativer:**
- Seksjonen «Skisse til claude» (Recommended) — Node 20747:108803: sidelayout og en dialog. Ser ut til å være laget for dette formålet.
- praksis-v2-*-serien — Seks skjermer: oversikt, prosent, timer, validering, overlapp, kravkobling.
- Begge — «Skisse til claude» og v2-serien.
- Hele siden — Alle navngitte skjermer (inkl. åpen, underside, lesetilgang og eldre utkast).

**Svar:** Seksjonen «Skisse til claude» (Recommended)

---

## 6. Avvik 1/8 — Praksistype valgfri

**Spørsmål:** I dialogen er «Praksistype (valgfri)». Kravet sier at praksistype og startdato er obligatoriske (scenario «Praksistype og startdato er obligatorisk»). Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen er utdatert på dette punktet. Praksistype er obligatorisk.
- Skissen er riktig — Praksistype skal være valgfri. Registreres som «krav mangler» for fs-krav.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Skissen er riktig

---

## 7. Avvik 2/8 — Arbeidsgiver

**Spørsmål:** Skissen har et felt «Arbeidsgiver (valgfri)» i dialogen, og tabellen viser arbeidsgiver i første kolonne. Kravene nevner ikke arbeidsgiver (feltlisten i «Se registrerte praksisperioder» er Type, Startdato, Sluttdato, Omfang, Beregnet praksis). Hva skal vi gjøre?

**Alternativer:**
- Skissen er riktig — Arbeidsgiver skal være med som valgfritt felt. Registreres som «krav mangler».
- Kravene er riktige — Arbeidsgiver skal ikke være med. Skissen er utdatert.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Skissen er riktig

---

## 8. Avvik 3/8 — Relevansmarkering

**Spørsmål:** Skissen har en «Relevant»-avkrysning per periode, og bare én sum: «Samlet beregnet relevant praksis» (bare avkryssede perioder). Kravet har dette som @openquestion med tre alternativer. Skissen ligner mest alternativ (1), men viser ingen overlappssummer. Hva skal vi gjøre?

**Alternativer:**
- Vet ikke — Forblir åpent spørsmål. Skissen noteres som ett mulig svar (alternativ 1).
- Skissen er riktig — Relevansflagg som filtrerer summen besluttes. Registreres som «krav mangler» for fs-krav.
- Kravene er riktige — Skissen er utdatert. Relevansmarkeringen forblir uavklart i kravene.

**Svar:** Vet ikke

---

## 9. Avvik 4/8 — Overlapp

**Spørsmål:** Eksempeldataene i skissen har overlappende perioder (Oslo universitetssykehus 01.01.2020–31.12.2020 og 15.06.2019–14.06.2020). Skissen viser likevel verken varsel om overlapp eller de to summene (oppgitt og justert for overlapp) som regelen «Overlappende praksisperioder varsles og vises med to summer» krever. Hva skal vi gjøre?

**Alternativer:**
- Begge riktige, ulikt scope — Skissen viser ikke overlapp-tilstanden. Kravene gjelder, og skissen dekker ikke denne regelen.
- Kravene er riktige — Skissen er utdatert. Den mangler overlappsvarsel og to summer.
- Skissen er riktig — Overlapp skal ikke varsles eller vises med to summer. Registreres som «krav mangler/endres».
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Kravene er riktige

---

## 10. Avvik 5/8 — Påkrevd og timesum

**Spørsmål:** Summeringskortet viser «2,55 år av 3,00 år påkrevd» og «1070 t av 1700 t påkrevd». Sammenligningen mot det som er påkrevd hører til knytte_praksis_til_opptakskrav.feature, ikke til kalkulatoren. En egen sum i timer finnes ikke i kravene. Hva skal vi gjøre?

**Alternativer:**
- Begge riktige, ulikt scope — «Påkrevd» dekkes av @OPT-BEH-BEH-004, ikke av denne spec-en. Timesummen noteres som åpent spørsmål.
- Kravene er riktige — Skissen er utdatert. Ingen påkrevd-sammenligning og ingen timesum i kalkulatoren.
- Skissen er riktig — Kalkulatoren skal vise sum i timer og sammenligne mot påkrevd. Registreres som «krav mangler».
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Begge riktige, ulikt scope

---

## 11. Avvik 6/8 — Tilknyttet dokumentasjon

**Spørsmål:** Dialogen har feltet «Tilknyttet dokumentasjon (valgfri)». Scenarioet «Knytte praksisperioden til dokumentasjon på søknaden» er @could og utsatt fra første leveranse. Hva skal vi gjøre?

**Alternativer:**
- Begge riktige, ulikt scope — Skissen viser målbildet. Feltet er ikke med i første leveranse (@could).
- Skissen er riktig — Dokumentasjonskobling skal med i første leveranse. Registreres som «krav mangler» (prioritet må endres av fs-krav).
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Begge riktige, ulikt scope

---

## 12. Avvik 7/8 — Eksempeltall

**Spørsmål:** Tallene i eksempeldataene stemmer ikke med regnereglene. 01.01.2020–31.12.2020 i 100 % vises som 2,00 år, men skal være 1,00 år (scenario «Sluttdatoen regnes med i perioden»). Timeraden bruker årsverk 1700, mens standardverdien i kravet er 1 650. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Tallene i skissen er illustrasjon og ikke fasit. Regnereglene og standardverdien 1 650 i kravet gjelder.
- Skissen er riktig — Standardårsverket skal være 1 700. Registreres som «krav mangler» (1,00 → 2,00 år regnes fortsatt som feil).
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Kravene er riktige

---

## 13. Avvik 8/8 — Tilstander som ikke er skissert

**Spørsmål:** Skissen viser ikke hvem som opprettet og sist endret en praksisperiode (scenario «Se hvem som registrerte en praksisperiode»). Den viser heller ikke varselet ved lagring uten sluttdato eller feilmeldingene for datoer. Hva skal vi gjøre?

**Alternativer:**
- Begge riktige, ulikt scope — Skissen dekker hovedflyten. Kravene gjelder for historikk, varsel og validering, som ikke er skissert.
- Kravene er riktige — Skissen er utdatert og bør oppdateres med disse tilstandene.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Vet ikke

---

## 14. Videre etter spec

**Spørsmål:** Spec-en er skrevet. Vil du gå gjennom de åpne spørsmålene nå?

**Alternativer:**
- Stopp her — Avslutt med oppsummering. De to «krav mangler»-punktene tas i fs-krav.
- Gå gjennom åpne spørsmål — Ett og ett. Jeg noterer beslutning og begrunnelse i spec-en og krysser av.

**Svar:** (ikke besvart — brukeren ønsket å avklare noe først)

---
