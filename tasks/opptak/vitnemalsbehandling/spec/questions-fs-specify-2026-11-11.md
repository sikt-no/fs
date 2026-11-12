# Spørsmål og svar — `fs-specify` (2026-11-11)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Scope for L3

**Spørsmål:** Kravet velge_fag_per_poengvariant.feature (@OPT-BEH-BEH-022, L3) har ingen @scope-tag. Scopet vitnemalsbehandling (L1 og L2) har L3 under «Ikke-mål». Hvilket scope skal spesifikasjonen ligge i?

**Alternativer:**
- vitnemalsbehandling (Recommended) — Spec i tasks/opptak/vitnemalsbehandling/spec/. Scopet bør etterpå oppdateres med fs-scope (L3 inn i mål og krav-tabell, @scope-tag).
- Kjør fs-scope først — Avbryt nå, avgrens L3 (eget scope eller utvid vitnemalsbehandling) med fs-scope, og kjør fs-specify etterpå.
- Nytt scope — Lag en minimal scope.md for L3 her (du oppgir slug, tittel, mål og Jira).

**Svar:** vitnemalsbehandling (Recommended)

---

## 2. Branchen er bak main

**Spørsmål:** Branchen krav/vitnemalsbehandling-l3-l4-eksperter er oppdatert mot origin, men 23 commits bak main. Ingen av dem rører kravfila eller scopet vitnemalsbehandling (bare tasks/opptak/tilgang-i-opptak-2027 og tilgangskrav). Fortsette?

**Alternativer:**
- Fortsett — Fortsett på branchen som den er.
- Avbryt — Stopp, så du kan oppdatere branchen mot main først.

**Svar:** Fortsett

---

## 3. Kodeklonene er bak main

**Spørsmål:** Kodeklonene fs-admin og fs-plattform står på main, og er begge 132 commits bak origin/main (fs-admin har en lokal endring i package-lock.json, som ikke hindrer pull --ff-only så lenge den ikke kolliderer). Hente før kodesjekken?

**Alternativer:**
- Hent nå — git pull --ff-only i begge klonene, så kodesjekken leser oppdatert kode.
- Fortsett uten — Sjekk mot koden slik den er lokalt, og noter det i spec-en.
- Avbryt — Stopp kjøringen.

**Svar:** Other

**Fritekst:** Du kan rulle tilbake den lokale endringen i package-lock.json og kjøre vanlig pull for å oppdatere

---

## 4. Kodeavvik: forbedring, tillegg og valgbar lagres ikke

**Spørsmål:** Kravet @OPT-BEH-BEH-022 sier at saksbehandleren ser opprinnelig og forbedret karakter for samme fag samtidig, at tilleggsfag er utenfor beregningen til de velges, og at bare fag merket som valgbare kan velges bort. Koden har ikke grunnlaget for det: kompetanse.vgs_dokument_fag har primærnøkkel (vgdoknr, fagkode), så et fag kan bare stå én gang per vitnemål, og verken forbedring, tillegg eller valgbar lagres (fs-plattform/opptak/opptak-migrations/…/V176__kompetanse_vgs.sql:144 og V271). KREG har opplysningene (status_forbedring/status_tillegg i nvb2.vgdokfag, faginfokode på KregFag i kreg-graphql schema.graphql:553). Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig — Koden skal endres: opptak må lagre forbedring og tillegg fra KREG. Kravet retagges @in-progress, og avviket står under Kodesjekk.
- Kravet må endres — Kravet blir stående @planned, og avviket blir et åpent spørsmål for fs-krav.
- Vet ikke — Som «Kravet må endres»: kravet retagges ikke før det er avklart.

**Svar:** Kravet er riktig

---

## 5. Finnes det skisser for L3?

**Spørsmål:** Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) for L3 (velge_fag_per_poengvariant.feature)? Den lagrede skissen «Gjeldende skisser» (Figma, node 5163-45344, hentet 28.10.2026) har radioknapp per poengvariant og avkrysning per fag.

**Alternativer:**
- Ja, Gjeldende skisser (hent på nytt) — Hent «Nyeste skisser» fra Figma på nytt og valider mot L3.
- Ja, Gjeldende skisser (bruk lagret) — Valider mot skjermbildene som ble lagret 28.10.2026, uten ny henting.
- Ja, en annen skisse — Du gir lenke eller fil.
- Nei — Ingen skisse. Du får et oppfølgingsspørsmål om grunnen.

**Svar:** Ja, en annen skisse

---

## 6. Hvilken skisse gjelder for L3?

**Spørsmål:** Hvilken skisse gjelder for L3? Skriv lenken (Figma-URL med node-id) eller filstien under «Other», gjerne med en kort tittel.

**Alternativer:**
- Figma-lenke — Jeg limer inn Figma-URL-en under «Other».
- Lokal fil — Jeg skriver stien til bilde eller PDF under «Other».

**Svar:** Figma-lenke

**Fritekst:** (gitt i chat) https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-50347&m=dev

---

## 7. Skisseavvik: vitnemålet per poengvariant

**Spørsmål:** Avvik 1 av 3: kravet @OPT-BEH-BEH-022 sier i «Legge ulikt vitnemål til grunn for ulike poengvarianter»: «Og det fremgår hvilket vitnemål hver poengvariant bygger på». Skissen «Steg 2 Grunnlag – Behandle e-vitnemål» (node 5163-50347) har ingen vitnemålskolonne i tabellen «Kvalifisering og poengberegning». Den viser bare vitnemålet for poengvariantene som er valgt (radioknappen under «Vitnemål»). Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen er utdatert: tabellen må vise vitnemålet per poengvariant.
- Skissen er riktig — Kravet mangler eller må endres: åpent spørsmål for fs-krav.
- Ulikt scope — Begge er riktige. Skissen dekker ikke hele kravet.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** (avbrutt for avklaring)

**Fritekst:** I skissen er det både Vitnemål og Vitnemålsutvalg under "Poeng for vitnemålsutvalg". Dekker ikke det spørsmålet ditt om å vise vitnemål? (Registrert som OK: radioknappen og overskriften viser vitnemålet for poengvarianten som er valgt.)

---

## 8. Skisseavvik: Fagstatus og Eks.form

**Spørsmål:** Avvik 1 av 2: kravet @OPT-BEH-BEH-022 («Se fagene på vitnemålet») har feltene Fagkode, Fagnavn, Omfang, År, Standpunktkarakter, Eksamenskarakter og Fagstatus. Fagtabellen i skissen (node 5163-50584) mangler Fagstatus (elev eller privatist), og har «Eks.form», som kravet ikke har. Fagstatus avgjør også scenarioet om privatist etter fylte 21 år. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen er utdatert: Fagstatus må inn i fagtabellen. Eks.form kan stå som et ekstra felt.
- Skissen er riktig — Kravet må endres: Fagstatus ut og/eller Eks.form inn. Åpent spørsmål for fs-krav.
- Begge deler — Fagstatus må inn i skissen, og Eks.form bør inn i kravet. Åpent spørsmål for fs-krav om Eks.form.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Other

**Fritekst:** Skissen er riktig og kravet må endres: Fagstatus ut og Eks.form inn.

---

## 9. Skisseavvik: hvilken karakter inngår

**Spørsmål:** Avvik 2 av 2: kravet @OPT-BEH-BEH-022 («Se opprinnelig og forbedret karakter samtidig») sier: «Og det fremgår hvilken av dem som inngår i beregningen». Skissen viser begge karakterene i kolonnene Opprinnelig og Forbedret, men ikke hvilken som inngår. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen er utdatert: den må vise hvilken karakter som inngår i beregningen.
- Skissen er riktig — Kravet må endres: åpent spørsmål for fs-krav.
- Ulikt scope — Det framgår implisitt (forbedret karakter brukes når den finnes). Skissen dekker ikke hele kravet.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Other

**Fritekst:** Skissen er riktig, men det er først etter å ha trykket "Beregn poeng" at valget skal vises

---

## 10. Retagging og implementasjonsdetaljer

**Spørsmål 1:** Begge skisseavvikene gjør at kravteksten i @OPT-BEH-BEH-022 må endres (Fagstatus ut og Eks.form inn, og at det går fram hvilken karakter som inngår først etter «Beregn poeng»). Skal kravet retagges @planned → @in-progress nå?

**Alternativer:**
- Hold tilbake (Recommended) — Kravet blir stående @planned. Rett kravet med fs-krav først (to små endringer), og kjør fs-specify på nytt. Spec-en skrives nå, men står i «Spesifiseres» til kravet er hentet inn.
- Retagg nå — Kravet blir @in-progress. Endringene gjøres på stedet etterpå og noteres i spesifikasjonen.

**Svar:** Hold tilbake (Recommended)

**Spørsmål 2:** velge_fag_per_poengvariant.design.md finnes ikke. Skal fs-implementasjonsdetaljer kjøres nå med skissen?

**Alternativer:**
- Kjør nå — Kjør fs-implementasjonsdetaljer for feature-fila med skissen fra denne kjøringen.
- Vent — Legg «Implementasjonsdetaljer mangler» under Åpne spørsmål, og ta det senere (f.eks. etter fs-krav).

**Svar:** Vent

---

## 11. Etter spec-en

**Spørsmål:** Spec-en for L3 er skrevet (tasks/opptak/vitnemalsbehandling/spec/spec-velge-fag-per-poengvariant.md), med et forslag til «Omfang» og 6 åpne spørsmål. Hva vil du gjøre nå?

**Alternativer:**
- Stopp her — Avslutt med en oppsummering. Rett kravet med fs-krav, og kjør fs-specify på nytt etterpå.
- Gå gjennom åpne spørsmål — Ett om gangen, med beslutning og begrunnelse i spec-en.

**Svar:** Stopp her
