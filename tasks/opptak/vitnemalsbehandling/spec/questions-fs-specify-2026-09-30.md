# Spørsmål og svar — `fs-specify` (2026-09-30)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

Brukeren oppga kravfilene og skissen (Figma-lenke) i invokasjonen, så spørsmålene om kildemappe, om det finnes skisser og hvilken type ble ikke stilt.

---

## 1. Oppgavemappe

**Spørsmål:** Hvilken oppgavemappe skal spec-en for vitnemålsvisningen skrives til? Ingen eksisterende oppgave i tasks/opptak/ handler om vitnemål.

**Alternativer:**
- Ny: opptak/vitnemalsbehandling (Recommended) — Oppretter tasks/opptak/vitnemalsbehandling/spec/. Dekker hele initiativet #607, og L2–L6 kan legges til når de blir @planned.
- Ny: opptak/vise-elektroniske-vitnemal — Oppretter tasks/opptak/vise-elektroniske-vitnemal/spec/. Slug-en matcher filnavnet og bare leveranse L1 (#613).
- Eksisterende oppgave — Bruk en av de eksisterende: opprette-og-vedlikeholde-opptak, plasstildeling, regelverk, registrere-praksis, utdanningstilbud, vedtaksformidling.

**Svar:** Ny: opptak/vitnemalsbehandling (Recommended)

---

## 2. Figma-scope

**Spørsmål:** Hvilke deler av Figma-siden «Vitnemålsbehandleren» (seksjonen MÅLBILDE) skal kobles til kravet vise_elektroniske_vitnemål.feature (@OPT-BEH-BEH-005) og valideres?

**Alternativer:**
- Steg 2-skjermene (Recommended) — Fem rammer: «Steg 2 Grunnlag – Ingen e-vitnemål», «– Vitnemål åpen – Auto tabellrad», «– Behandle e-vitnemål», «– Legg inn vitnemål manuelt» og «Steg 2 – 1240px». Det som gjelder L2–L6 (valg, fagvalg, manuell inntasting), registreres som utenfor scope.
- Bare visningsskjermene — «Steg 2 Grunnlag – Ingen e-vitnemål» og «– Vitnemål åpen – Auto tabellrad». De to som mest ligner L1.
- Hele målbildet — Alle 24 elementene, også steg 1, poengberegning, kvoter, spesielle opptakskrav, oppsummering og iPad-varianter. Det meste blir «ulikt scope».

**Svar:** Steg 2-skjermene (Recommended)

---

## 3. Avvik 1/3 — Seksjonen vises uten e-vitnemål

**Spørsmål:** Avvik 1/3: I skissen «Steg 2 Grunnlag – Ingen e-vitnemål» vises seksjonen «Vitnemålsbehandling» (lukket, med «Vis») selv om søkeren ikke har elektroniske vitnemål. Kravet («Søker uten elektroniske vitnemål») sier at vitnemålsoversikten da ikke vises. Kravet noterer også at skjemaet for manuell utfylling da alltid skal vises, men at det kommer i L4. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen er utdatert. Uten e-vitnemål skal vitnemålsoversikten ikke vises i L1.
- Begge riktige, ulikt scope — Skissen viser målbildet med manuell utfylling (L4). I L1 gjelder kravet, og seksjonen skjules.
- Skissen er riktig — Seksjonen skal vises også uten e-vitnemål. Registreres som «krav mangler» for fs-krav.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Skissen er riktig

---

## 4. Avvik 2/3 — Feltene i vitnemålstabellen

**Spørsmål:** Avvik 2/3: Kravet («Åpne vitnemålsoversikten») sier at hvert vitnemål vises med Utstedelsesdato, Dokumenttype, Status, Førstegangsvitnemål, Reform, Dispensasjon og Påstand om GSK. Tabellen i skissen viser Vitnemålsnummer, Utstedt dato, GSK, Første, KAR, REA og SPR. Dokumenttype, Status, Reform og Dispensasjon mangler, mens Vitnemålsnummer og poengene (KAR/REA/SPR) er med i skissen, men ikke i kravet. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen er utdatert. Tabellen får de sju feltene fra kravet.
- Skissen er riktig — Feltlisten i kravet endres til skissens kolonner. Registreres som «krav mangler» for fs-krav.
- Begge delvis — Feltene fra kravet skal med, og skissens ekstra kolonner (vitnemålsnummer, poeng) legges til i kravet. Registreres som «krav mangler» for fs-krav.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Vet ikke

---

## 5. Avvik 3/3 — Annullert vitnemål

**Spørsmål:** Avvik 3/3: Kravet («Annullert vitnemål som er brukt i en beregning vises») sier at et annullert vitnemål som er brukt i en beregning på opptaket, skal vises tydelig markert som annullert. Ingen av steg 2-skjermene viser et annullert vitnemål. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen er ufullstendig. Tilstanden med annullert vitnemål må skisseres.
- Begge riktige, ulikt scope — Skissen dekker hovedflyten. Kravet gjelder for annullert vitnemål, uten at det må skisseres.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Kravene er riktige

---

## 6. Videre etter spec

**Spørsmål:** Spec-en er skrevet, med tre åpne spørsmål: at seksjonen skal vises uten e-vitnemål (krav mangler), feltene i vitnemålstabellen (vet ikke), og at et annullert vitnemål må skisseres. Vil du gå gjennom dem nå?

**Alternativer:**
- Gå gjennom åpne spørsmål — Ett om gangen. Jeg noterer beslutning og begrunnelse i spec-en og krysser av.
- Stopp her — Avslutt med oppsummering. Kravendringene tas i fs-krav, skissen oppdateres av den som eier den.

**Svar:** Stopp her

---
