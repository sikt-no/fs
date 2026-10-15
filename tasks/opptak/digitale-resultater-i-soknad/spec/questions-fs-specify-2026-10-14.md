# Spørsmål og svar — `fs-specify` (2026-10-14)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Hvilken oppgave

**Spørsmål:** Hvilken oppgave skal spesifikasjonen lages for?

**Alternativer:**
- digitale-resultater-i-soknad — tasks/opptak/digitale-resultater-i-soknad, scope-digitale-resultater-i-soknad med @OPT-SØK-SØK-004 og Figma-skissen fra #604.
- Ny oppgave — Opprett en ny oppgavemappe.

**Svar:** digitale-resultater-i-soknad

---

## 2. Hvilken branch

**Spørsmål:** Spesifikasjonen retagger kravet @planned → @in-progress. Hvilken branch skal endringene ligge på?

**Alternativer:**
- Samme branch som PR #735 (Recommended) — Spesifikasjonen bygger på kravendringene som er til review hos Steffen, og kommer med i samme PR.
- Ny branch fra main — Egen PR. Da bygger spesifikasjonen på kravet slik det er på main, uten endringene i #735.

**Svar:** Samme branch som PR #735 (Recommended)

---

## 3. Skisseavvik: manglende tilstander

**Spørsmål:** Skissen «Konsept dokumentopplastning» mangler tilstanden der søkeren ikke har digitale resultater (eller hentingen har feilet), og «Andre resultater» når den er åpnet. Kravet har scenarioer for begge. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen dekker bare hovedtilstanden. Tekstene og tilstandene beskrives i .design.md, og det er et åpent spørsmål til design om de to tilstandene.
- Det finnes andre rammer — Tilstandene er tegnet i andre rammer i Figma. Lim inn lenkene under «Other».
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Other

**Fritekst:** https://www.figma.com/design/zYzcXLwDsgoqAhvZ8X1ron/Min-Kompetanse-2026?node-id=4274-43654 (rammen viste seg å være resultatet der bare utstederen er kjent)

---

## 4. Skisseavvik: manglende tilstander (på nytt)

**Spørsmål:** Det mangler fortsatt rammer for to tilstander kravet har scenarioer for: ingen digitale resultater (eller hentingen har feilet), og «Andre resultater» når den er åpnet. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissene dekker ikke de to tilstandene. Tekstene og tilstandene beskrives i .design.md, og det blir et åpent spørsmål til design.
- Flere rammer — Tilstandene er tegnet i andre rammer. Lim inn lenkene under «Other».
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Avvist. Brukeren viste i stedet et skjermbilde av tilstanden uten resultater («Vi fant ingen resultater knyttet til deg»), lagret som `krav-input/sketches/ingen-resultater.png`. Deretter ga brukeren lenken til rammen (`4401:18141`), som ble lagret under `krav-input/sketches/figma/konsept-dokumentopplastning-ingen-resultater/`, og bildet ble fjernet.

---

## 5. Skisseavvik: «all dokumentasjon må lastes opp»

**Spørsmål:** Skissen «Konsept dokumentopplastning, ingen resultater» avviker fra scenariomalen «Samme forklaring vises uansett årsak …»: kravet sier at søkeren får vite at ALL dokumentasjon må lastes opp manuelt. Skissen sier at søkeren KAN laste opp resultater som ikke vises, eller kontakte lærestedet. Hva skal vi gjøre?

**Alternativer:**
- Skissen er riktig — Kravet mangler: steget bør si at søkeren får vite at resultater som ikke vises, kan lastes opp eller etterlyses hos lærestedet. Åpent spørsmål for fs-krav.
- Kravet er riktig — Skissen er utdatert på dette punktet. Teksten i .design.md skal si at all dokumentasjon må lastes opp.
- Begge er riktige — Det er samme budskap med ulik ordlyd. Teksten i .design.md følger skissen.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Begge er riktige

---

## 6. «Andre resultater» åpnet

**Spørsmål:** Finnes det en ramme for «Andre resultater» når seksjonen er åpnet (scenarioet «Se andre resultater»)?

**Alternativer:**
- Nei, kravet gjelder — Skissene viser bare den lukkede tilstanden. Hvordan enkeltemnene og den øvrige dokumentasjonen vises, beskrives i .design.md, og det blir et åpent designspørsmål.
- Ja, jeg har lenke — Lim inn lenken under «Other». Merk at Figma-kvoten er brukt opp, så jeg kan bare registrere lenken, ikke hente artefaktene.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Nei, kravet gjelder

---

## 7. Oppdatere kodeklonene

**Spørsmål:** Kodeklonene er bak origin/main (fs-plattform 94 commits, min-kompetanse 4). Skal jeg hente siste main før kodesjekken?

**Alternativer:**
- Ja, pull begge (Recommended) — git pull --ff-only på main i begge klonene. De har ingen lokale endringer.
- Nei, sjekk som de er — Kodesjekken bruker koden slik den er lokalt, og det noteres i spesifikasjonen.

**Svar:** Ja, pull begge (Recommended)

---

## 8. Kodesjekk: navnet på steget

**Spørsmål:** Kravet @OPT-SØK-SØK-004 sier steget «Last opp dokumentasjon» (fra Figma), koden kaller steg 3 «Dokumentasjon» (min-kompetanse/messages/files/nb.json:99). Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig — Steget skal hete «Last opp dokumentasjon» som i skissen. Koden skal endres, og det står under Kodesjekk. Kravet hentes inn.
- Kravet må endres — Steget heter «Dokumentasjon». Kravet holdes tilbake som @planned til det er rettet med fs-krav (sju steder i fila), og spesifikasjonen er ikke klar før det.
- Vet ikke — Som «Kravet må endres»: kravet holdes tilbake til det er avklart.

**Svar:** Kravet må endres

---

## 9. Rette stegnavnet nå

**Spørsmål:** Kravet er @planned og ikke hentet inn, så navnet kan rettes der det står. Skal jeg rette «Last opp dokumentasjon» til «Dokumentasjon» i kravet nå (fs-krav), og så fortsette spesifikasjonen?

**Alternativer:**
- Ja, rett og fortsett (Recommended) — Regelen og alle Når-stegene får steget «Dokumentasjon», og kommentaren «Avklart 14.10.2026» oppdateres. Deretter hentes kravet inn som @in-progress.
- Nei, hold tilbake — Spesifikasjonen skrives med kravet holdt tilbake og navnet som åpent spørsmål. Kjør fs-specify på nytt etter at kravet er rettet.

**Svar:** Ja, rett og fortsett (Recommended)

---

## 10. Implementasjonsdetaljer: tekst i tom tilstand (fra fs-implementasjonsdetaljer)

**Spørsmål:** Hvilken tekst skal forklaringen ha når søkeren ikke har digitale resultater i steget «Dokumentasjon»?

**Alternativer:**
- Skissen, rettet (Recommended) — Skissens budskap (kan laste opp selv), med «lærested» og rettet språk.
- Skissen ordrett — Som i Figma, med «institusjonene» og «utdanningsinstitusjon». Terminologien noteres som åpent spørsmål.
- Gjenbruk Mine resultater — Samme tekster som i min-kompetanse i dag (nb.json:830-836), uten «kan du laste opp selv».

**Svar:** Skissen ordrett

---

## 11. Videre etter spesifikasjonen

**Spørsmål:** Spesifikasjonen er skrevet. Omfanget er et forslag fra meg (se spec-fila). Hva vil du gjøre nå?

**Alternativer:**
- Stopp her — Oppsummering. Ingen kravspørsmål står åpne i spesifikasjonen; designspørsmålene står i .design.md.
- Gå gjennom designspørsmålene — De fire åpne designspørsmålene i .design.md, ett om gangen.
- Justere omfanget — Endre omfangsteksten i spesifikasjonen før den sendes videre.

**Svar:** Stopp her
