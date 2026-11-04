# Spec: Rundetyper og plasstildelingsrunder

## Kilde

- **Scope:** `tasks/opptak/plasstildeling-2027/`
- **Kilde-mappe:** `krav/02 Opptak/10 Regelverk/06 Rundetyper/`, `krav/02 Opptak/14 Plasstildeling/01 Runder/`
- **GitHub:** [#216](https://github.com/sikt-no/fs/issues/216)
- **Hentet:** 2026-11-04 11:37

## Omfang

Opptaksforvalter legger til plasstildelingsrunder i opptaket av rundetypene hovedtildeling, supplering og etterfylling, og runden får de faste innstillingene fra rundetypen. Opptaksforvalter setter svarfrist, tak for antall tilbud per søker, ledige studieplasser og perioden for lærestedene, og ser rundene i en oversikt med søk, filter og sortering. Lærestedet ser alle rundene og oppgaven sin, og kan bare åpne runden der perioden er åpen. Antall tilbud som skal gis (`@OPT-PLA-INN-001`), forvaltning av rundetyper og selve plasstildelingen er ikke med.

## Krav

- **`bruke_rundetyper.feature`** (`@OPT-REG-RUN-001`) — rundetypene hovedtildeling, supplering og etterfylling med de faste innstillingene plasstildelingen leser, felles for alle opptak. ([krav/02 Opptak/10 Regelverk/06 Rundetyper/bruke_rundetyper.feature](../../../../krav/02%20Opptak/10%20Regelverk/06%20Rundetyper/bruke_rundetyper.feature))
- **`forvalte_runder.feature`** (`@OPT-PLA-RUN-001`) — legge til, endre og slette plasstildelingsrunder, innstillingene fra rundetypen, tak per søker, ledige studieplasser, perioden for lærestedene hvilke runder lærestedet kan åpne, og unikt navn. ([krav/02 Opptak/14 Plasstildeling/01 Runder/forvalte_runder.feature](../../../../krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.feature))
- **`listevisning_og_søk_i_plasstildelingsrunder.feature`** (`@OPT-PLA-RUN-002`) — oversikten over plasstildelingsrundene med søk, filter, sortering og paginering, og sletting av flere runder samtidig. ([krav/02 Opptak/14 Plasstildeling/01 Runder/listevisning_og_søk_i_plasstildelingsrunder.feature](../../../../krav/02%20Opptak/14%20Plasstildeling/01%20Runder/listevisning_og_s%C3%B8k_i_plasstildelingsrunder.feature))

## Skisser

### Skisse: Prototype v88

- **Type:** `annet` (HTML-prototype)
- **Referanse:** https://claude.ai/artifact/PtEVDPyFrsWodTZPu9mfA9?sk=ZdIKzCJG4Uc0TFPmwraDxQ (artefakt i en annen organisasjon)
- **Lagrede artefakter:** [plasstildeling-prototype-v88.html](krav-input/sketches/plasstildeling-prototype-v88.html)
- **Dekker krav:** `forvalte_runder.feature`, `listevisning_og_søk_i_plasstildelingsrunder.feature`
- **Valideringsstatus:** Avvik:
  - Taket for antall tilbud per søker vises bare for rundetyper der søkeren kan ha flere tilbud. Kravet sier at det vises og kan endres på alle runder.
  - Innstillingene på runden heter noe annet («Søker kan ha flere tilbud samtidig»), og «Bare én i opptaket» og «Kan åpnes for ledige studieplasser» vises ikke.
  - Varsling av lærestedene er en forutsetning for at lærestedet kan åpne runden. Kravet styrer det bare med perioden.
  - Oversikten har ikke filter eller sortering på perioden, sorterer på runde og rundetype, og viser oppgaven bare for lærestedet. Status heter «Publisert», ikke «Publisert for søkere».
  - Oversikten har avkrysning og «Handlinger» for å slette flere runder samtidig. Kravet har det ikke.
- **Beslutning ved avvik:**
  - Tak, innstillinger, varsling og filter, sortering og oppgave i oversikten: **kravene er riktige, skissen er utdatert** (produkteier 2026-11-02 og 2026-11-04). Prototypen må rettes.
  - Sletting av flere runder samtidig: **skissen er riktig, kravet mangler** (produkteier 2026-11-04). Lagt inn i `@OPT-PLA-RUN-002` med `fs-krav`.

## Kodesjekk

- **Sjekket:** fs-plattform og fs-admin, `origin/main` (arbeidskopiene sto på andre brancher)
- `@OPT-REG-RUN-001`: kravet sier at regelverkssamlingen har rundetypene. Koden har et felles kodeverk uten kobling til regelverkssamlingen og uten innstillinger (`fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V280__opptak_v2_skjema.sql:145`, `:1590-1596`). **Kravet er endret** (2026-11-04): rundetypene er felles i første leveranse. Innstillingene mangler i koden, og skal legges til.
- `@OPT-PLA-RUN-001`: koden krever at navnet på runden er unikt i opptaket, uten hensyn til store og små bokstaver, og høyst 100 tegn (`V280__opptak_v2_skjema.sql:390`, `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/opptak/opptaksrunde.graphqls:43-51`). **Kravet er endret** (2026-11-04) med regelen «Navnet på plasstildelingsrunden er unikt i opptaket».
- Kjente avvik der kravet er riktig og koden skal endres (fra verifiseringen 2026-10-28 og kodesjekken nå). De står her så kode-repoene vet om dem når kravene hentes inn:
  - Taket for antall tilbud per søker ligger på opptaket (`maks_antall_tilbud`, `V280__opptak_v2_skjema.sql:231`), ikke på runden. Ledige studieplasser og taket for dem finnes ikke på runden (`V280__opptak_v2_skjema.sql:364-371`).
  - fs-admin velger bare dato for perioden, ikke klokkeslett (`fs-admin/src/domains/plasstildeling/features/OpprettRundeForm/OpprettRundeForm.tsx:156-195`, `RedigerRundeForm/RedigerRundeForm.tsx:167`).
  - Ingen regel for bare én hovedtildeling, for at supplering og etterfylling ikke kan være første runde, eller for at svarfristen må komme etter perioden (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpptaksrundeMutations.java:130-134`).
  - Perioden avgrenser ikke hvilke runder lærestedet kan åpne. Skriving på runden krever forvaltertilgang (`V319__opptak_v2_skriving_krever_forvalter.sql:84-92`).
  - Rundene listes som et avsnitt på opptakssiden, uten søk, filter, sortering eller paginering (`fs-admin/src/domains/opptak/features/OpptakDetails/components/PlasstildelingSection/PlasstildelingSection.tsx:185-330`).
  - Status utledes fra publiseringstidspunktet. Tekstene «Ikke publisert» og «Publisert for søkere» finnes (`fs-admin/src/common/messages/nb/plasstildeling.json:19-20`).
  - En publisert runde kan ikke slettes (`OpptaksrundeMutations.java:148-149`), som kravet sier. Backend sletter én runde om gangen. Sletting av flere runder samtidig finnes ikke.

## Implementasjonsdetaljer

- **`forvalte_runder.feature`** — [forvalte_runder.design.md](../../../../krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.design.md) (1 åpent designspørsmål)
- **`listevisning_og_søk_i_plasstildelingsrunder.feature`** — [listevisning_og_søk_i_plasstildelingsrunder.design.md](../../../../krav/02%20Opptak/14%20Plasstildeling/01%20Runder/listevisning_og_s%C3%B8k_i_plasstildelingsrunder.design.md) (2 åpne designspørsmål)

`bruke_rundetyper.feature` har ikke eget skjermbilde. Innstillingene vises på runden, i implementasjonsdetaljene for `forvalte_runder.feature`.

## Retagging

Første kjøring holdt alle tre kravene tilbake. De ble rettet med `fs-krav`, og er hentet inn i denne kjøringen.

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/10 Regelverk/06 Rundetyper/bruke_rundetyper.feature` | `@OPT-REG-RUN-001 @must @planned` | `@OPT-REG-RUN-001 @must @in-progress` |
| `krav/02 Opptak/14 Plasstildeling/01 Runder/forvalte_runder.feature` | `@OPT-PLA-RUN-001 @must @planned` | `@OPT-PLA-RUN-001 @must @in-progress` |
| `krav/02 Opptak/14 Plasstildeling/01 Runder/listevisning_og_søk_i_plasstildelingsrunder.feature` | `@OPT-PLA-RUN-002 @must @planned` | `@OPT-PLA-RUN-002 @must @in-progress` |

## Åpne spørsmål

- [x] `@OPT-REG-RUN-001`: Skriv om kravet så rundetypene hovedtildeling, supplering og etterfylling er felles for alle opptak i første leveranse, ikke en del av regelverkssamlingen. Gjelder også regelen «Rundetypene i regelverkssamlingen avgjør hvilke plasstildelingsrunder opptaket kan ha» og kommentarene i `@OPT-PLA-RUN-001`.
  - **Beslutning (2026-11-04):** Skrevet om. Egenskapen heter «Rundetyper for plasstildelingsrunder», regelen «Opptakene har rundetypene hovedtildeling, supplering og etterfylling», og regelen i `@OPT-PLA-RUN-001` heter «Rundetypene avgjør hvilke plasstildelingsrunder opptaket kan ha». Begrunnelse: koden har rundetypene som et felles kodeverk, og forvaltning er ikke med nå.
- [x] `@OPT-PLA-RUN-001`: Legg til regelen om at navnet på plasstildelingsrunden er unikt i opptaket (uten hensyn til store og små bokstaver), og høyst 100 tegn.
  - **Beslutning (2026-11-04):** Ny regel «Navnet på plasstildelingsrunden er unikt i opptaket», med tre scenarioer. Begrunnelse: regelen finnes i koden, og skal stå i kravet.
- [x] `@OPT-PLA-RUN-002`: Legg til at opptaksforvalter kan velge flere plasstildelingsrunder i oversikten og slette dem samtidig (bare de som ikke er publisert).
  - **Beslutning (2026-11-04):** Ny regel «Opptakets forvalter kan slette flere plasstildelingsrunder samtidig». Publiserte runder slettes ikke, og lærestedet ser ikke muligheten. Begrunnelse: prototypen v88 har det.
- [x] Implementasjonsdetaljer mangler for `forvalte_runder.feature` og `listevisning_og_søk_i_plasstildelingsrunder.feature` (tekstene for lærestedets oppgave, statusene og hvordan en stengt runde vises). Kjøres med `fs-implementasjonsdetaljer` når kravene er rettet.
  - **Beslutning (2026-11-04):** Skrevet med `fs-implementasjonsdetaljer`. De åpne designspørsmålene (tom tilstand og rettingene i prototypen) står i implementasjonsdetaljene.

## Rute

fs-plattform → fs-admin
