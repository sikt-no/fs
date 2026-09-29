# Spørsmål og svar — `fs-specify` (2026-09-28)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

Tredje kjøring samme dag (fjerde totalt): oppfrisking etter at «hovedopptaket kjøres» ble til «hovedopptaket publiseres» og slått sammen med «forventet svar».

---

## 1. Avvik — Opptaksresultat: «kjøres» vs. «publiseres»

**Spørsmål:** Skissen «Opprett opptak — frister og hendelser» ser ut til å avvike fra kravene: feltet under «Opptaksresultat» heter «Hovedopptaket kjøres» (hjelpetekst «Tilbud og ventelisteplasser tildeles.»), mens kravet nå sier «dato for når hovedopptaket publiseres», og at søkere kan forvente svar denne datoen. Hva skal vi gjøre?

**Alternativer:**
- Kravene er riktige — Skissen er utdatert. Design endrer etiketten til «publiseres» og nevner forventet svar i hjelpeteksten.
- Skissen er riktig — Kravene mangler eller bruker feil begrep. Registreres som åpent spørsmål for fs-krav.
- Ulikt scope — Begge er riktige: «kjøres» og «publiseres» er samme dato med ulik formulering. Noteres, ingen endring.
- Vet ikke — Åpent spørsmål uten beslutning.

**Svar:** Other

**Fritekst:** Did you find the newest figma skisse?

**Oppfølging:** Brukeren ga lenken til den nyeste versjonen (node `20606:117530`). I den heter gruppen «Hovedopptak» og har «Publiseringsdato» og «Svarfrist». Avviket falt bort, og spørsmålet ble ikke stilt på nytt.

---

## 2. Etter spec-en — neste steg

**Spørsmål:** Spec-en er oppdatert. Ett åpent spørsmål gjenstår: hva som utløser opprettelsen av første plasstildelingsrunde. Scenarioet har ikke noe Når-steg. Vil du gå gjennom det nå?

**Alternativer:**
- Gå gjennom åpne spørsmål — Vi tar spørsmålet nå, og beslutningen skrives inn i spec-en.
- Stopp her — Avslutt med en oppsummering.

**Svar:** Gå gjennom åpne spørsmål

---

## 3. Åpent spørsmål — utløser for første plasstildelingsrunde

**Spørsmål:** Hva utløser opprettelsen av første plasstildelingsrunde fra publiseringsdatoen og første svarfrist?

**Alternativer:**
- Når begge datoene er satt — Runden opprettes så snart opptaksforvalter har satt publiseringsdato og første svarfrist, og følger med hvis datoene endres.
- Når opptaket lagres/opprettes — Runden opprettes når opptaksforvalter lagrer opptaket med begge datoene satt.
- Når opptaket publiseres — Runden opprettes når opptaket publiseres for søkere.
- Vet ikke — Spørsmålet blir stående åpent for fs-krav.

**Svar:** Other

**Fritekst:** Når opptaket er laget og opptaksforvalter lager første opptaksrunde. Altså egen oppgave etter at opptak er laget

---
