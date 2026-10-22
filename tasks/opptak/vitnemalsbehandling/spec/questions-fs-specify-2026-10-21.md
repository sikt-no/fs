# Spørsmål og svar — `fs-specify` (2026-10-21)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

Brukeren oppga kravfilene og oppgavemappa i invokasjonen, så spørsmålene om kildemappe og oppgave ble ikke stilt.

---

## 1. Kodekloner, skisser og implementasjonsdetaljer

**Spørsmål 1:** Finnes det lokale kloner av fs-admin og fs-plattform som kravene kan sjekkes mot? Jeg fant ingen på de vanlige stedene.

**Alternativer:**
- Ingen kloner — Hopp over kodesjekken og skriv «Ikke sjekket: ingen kodekloner» i spec-ene.
- Jeg oppgir stien — Skriv stien til klonene under «Other».

**Svar:** Ingen kloner

**Spørsmål 2:** Skal Figma-målbildet for steg 2 (allerede hentet 30.09) brukes som skisse for både L1 og L2?

**Alternativer:**
- Ja, bruk målbildet (Recommended) — Gjenbruk de lagrede rammene og valider dem mot L1 og L2. Ingen ny henting fra Figma.
- Finnes nyere skisser — Oppgi Figma-lenke eller fil under «Other».

**Svar:** Finnes nyere skisser

**Spørsmål 3:** Implementasjonsdetaljene (design.md) mangler for både L1 og L2. Skal de lages med fs-implementasjonsdetaljer nå?

**Alternativer:**
- Senere — Legg det som åpent spørsmål i spec-ene og gå videre.
- Nå — Kjør fs-implementasjonsdetaljer for L1 og L2 før spec-ene skrives. Tar en stund og stiller egne spørsmål.

**Svar:** Senere

---

## 2. Nye skisser

**Spørsmål:** Hvor finner jeg de nyere skissene? Lim inn Figma-lenken (gjerne med node-id) eller stien til fila under «Other».

**Alternativer:**
- Samme Figma-side — Hent «Vitnemålsbehandleren» på nytt fra samme Figma-fil, siden den er oppdatert etter 30.09.
- Bruk målbildet likevel — Fortsett med rammene fra 30.09, og noter at nyere skisser finnes.

**Svar (Other):** https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-45344

---

## 3. Skisseavvik L1

**Spørsmål:** Skissen «Gjeldende skisser – steg 2» stemmer med L1 for kolonnene, rekkefølgen og ny fane. Men den viser ikke tre tilstander L1 krever: et annullert vitnemål som er brukt i en beregning, feilmeldingen når vitnemålene ikke kan hentes, og tomme poeng når Puff ikke svarer. Hva skal vi gjøre?

**Alternativer:**
- Skissen er ufullstendig — Kravene er riktige. De tre tilstandene må skisseres, og det noteres som åpent spørsmål.
- Holder med design.md — Tilstandene beskrives i implementasjonsdetaljene i stedet for i skissen.
- Vet ikke — Registreres som åpent spørsmål uten beslutning.

**Svar:** Skissen er ufullstendig

---

## 4. Skisseavvik L2: beregning og lagring

**Spørsmål:** Skissen viser «Endringer er lagret: 12:53» og ingen handling for å beregne poengene. L2 sier at poengene beregnes når saksbehandleren velger det, at endringen lagres først når beregningen er uten feil, og at saksbehandleren advares om endringer som ikke er lagret. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen er utdatert på dette punktet: den må få en beregn-handling og advarselen.
- Skissen er riktig — Krav mangler eller er feil. Registreres som åpent spørsmål for fs-krav.
- Vet ikke — Registreres som åpent spørsmål uten beslutning.

**Svar:** Kravene er riktige

---

## 5. Skisseavvik L2: poengfeltene

**Spørsmål:** «Poeng fra vitnemål» i skissen har feltene KAR opprinnelig, KAR med forbedring, Realfag, Språk og SUM, og de ser ut til å være låst for redigering. L2 sier at karakterpoeng, realfagspoeng og språkpoeng vises hver for seg per poengvariant, og at saksbehandleren kan legge dem inn selv. SUM og to KAR-felt står ikke i kravet. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen er utdatert: feltene må kunne redigeres, og SUM og KAR med forbedring hører ikke til L2.
- Skissen er riktig — SUM og KAR opprinnelig/med forbedring skal med. Registreres som krav som mangler, for fs-krav.
- Ulikt scope — KAR med forbedring hører til L3/L4. Skissen dekker mer enn L2.
- Vet ikke — Registreres som åpent spørsmål uten beslutning.

**Svar:** Vet ikke
