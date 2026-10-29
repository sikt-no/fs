# Utkast til Jira: Rundetyper og plasstildelingsrunder

Utkast 2026-10-28, ikke opprettet. Kravene er `@draft`, og lenkene går til `main` (kravene kommer dit når PR #850 er merget).

## Epic: Rundetyper og plasstildelingsrunder

Opptaksforvalter kan legge til plasstildelingsrundene i opptaket, med innstillingene fra rundetypene i regelverkssamlingen, og sette antall tilbud som skal gis per utdanningskvote i runden. Første leveranse i plasstildelingen: det plasstildelingen leser.

Verifisering 2026-10-28: 8 av 49 scenarioer finnes i koden.

Krav: [scope-plasstildeling-2027](https://github.com/sikt-no/fs/blob/main/tasks/opptak/scope-plasstildeling-2027.md)

---

## Story: Rundetyper med innstillinger i regelverkssamlingen

Regelverksforvalter legger til rundetypene i regelverkssamlingen, med innstillingene plasstildelingen leser. Samordna opptak får hovedtildeling, supplering og etterfylling. I dag er rundetypene et fast kodeverk uten innstillinger.

Akseptansekriterier:

- Regelverksforvalter legger til rundetyper med innstillinger (`@OPT-REG-RUN-001`)
- Regelverkssamlingene for samordna opptak har rundetypene hovedtildeling, supplering og etterfylling
- Kompensasjonstilbud ved opprykk krever bortfall og at plasstildelingsrunden bygger på forrige
- En rundetype kan ikke endres når en plasstildelingsrunde bruker den

Krav: [forvalte_rundetyper.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/10%20Regelverk/06%20Rundetyper/forvalte_rundetyper.feature)

## Story: Plasstildelingsrunder med innstillingene fra rundetypen

Opptaksforvalter legger til runder av alle rundetypene i regelverkssamlingen, ser innstillingene fra rundetypen, og kan åpne runden for ledige studieplasser. I dag kan bare hovedrunde velges i fs-admin.

Akseptansekriterier:

- Rundetypene i regelverkssamlingen avgjør hvilke plasstildelingsrunder opptaket kan ha (`@OPT-PLA-RUN-001`)
- Plasstildelingsrunden har innstillingene fra rundetypen
- En plasstildelingsrunde kan slettes så lenge den ikke er publisert til søker
- Opptaksforvalter kan åpne en plasstildelingsrunde for ledige studieplasser
- Opptaksforvalter setter tak for antall tilbud på ledige studieplasser per søker i plasstildelingsrunden
- Opptaksforvalter setter periode for når lærestedene kan endre antall tilbud som skal gis (med klokkeslett, og kan endres)

Krav: [forvalte_runder.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.feature)

## Story (TAKE-327, skrives om): Antall tilbud som skal gis per utdanningskvote i plasstildelingsrunden

Ny tittel og beskrivelse. Fordelingen i prosent er ikke med.

Lærestedene setter antall tilbud som skal gis per utdanningskvote for hver runde, innenfor perioden på runden. Opptakets forvalter kan endre tallene når som helst før runden er publisert. I dag settes ett tall for hele opptaket, og perioden håndheves ikke.

Akseptansekriterier:

- Opptaksforvalter setter antall tilbud som skal gis per utdanningskvote for plasstildelingsrunden (`@OPT-PLA-INN-001`)
- Et utdanningstilbud uten antall tilbud som skal gis, gir ingen nye tilbud i plasstildelingsrunden
- Lærestedene kan endre antall tilbud bare innenfor perioden som er satt på plasstildelingsrunden
- Antall tilbud kan ikke endres når plasstildelingsrunden er publisert
- Opptaksforvalter ser grunnlaget for å sette antall tilbud
- Opptaksforvalter kan filtrere utdanningstilbudene på om antall tilbud er satt
- Et utdanningstilbud kan gi tilbud til alle kvalifiserte
- Antall tilbud kan være negativt når rundetypen har kompensasjonstilbud ved opprykk

Krav: [antall_tilbud_som_skal_gis.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature)

## Bug: Redigering av en runde nullstiller publiseringen og perioden

Når opptaksforvalter endrer navn eller svarfrist på en runde i fs-admin, blir publiseringstidspunktet og perioden for antall tilbud satt til tomt. På en publisert runde mister søkerne svaret og kan ikke svare, og runden kan publiseres på nytt.

Forventet: Navn og svarfrist kan alltid endres (`@OPT-PLA-RUN-001`), og søkeren ser den nye svarfristen (`@OPT-PLA-SVA-001`). Publiseringen og perioden endres ikke.

Kode: `fs-admin/…/RedigerRundeForm/RedigerRundeForm.tsx:118-124` sender ikke feltene, og `fs-plattform/…/opptak/OpptaksrundeMutations.java:103-115` setter dem fra input. Gjelder også utkast-branchen. Rettet på branchen `maciek/plasstildeling-feat-runder-oversikt`.

Krav: [forvalte_runder.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.feature) · [håndtere_svar_fra_søker.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/05%20Svar/h%C3%A5ndtere_svar_fra_s%C3%B8ker.feature) · [verify-2026-10-28-1645.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/plasstildeling-2027/verify-2026-10-28-1645.md)
