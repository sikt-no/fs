# Verifisering: legge_til_runde.feature

- **Dato:** 2026-10-09
- **Krav:** `krav/02 Opptak/14 Plasstildeling/01 Runder/legge_til_runde.feature` (`@OPT-PLA-RUN-001`, `@draft`)
- **Kode:** `fs-admin` (665c3b41a), `fs-plattform` (4f59594077)

Kravet er `@draft`. Verifisert uansett status, bare som rapport: ingen tagger er endret. Ingen skjermbilder: verken chrome-devtools eller Claude in Chrome var koblet til økta.

Stier under er forkortet. `fs-admin/…/plasstildeling/` = `fs-admin/src/domains/plasstildeling/features/`, `PlasstildelingSection.tsx` = `fs-admin/src/domains/opptak/features/OpptakDetails/components/PlasstildelingSection/PlasstildelingSection.tsx`, `OpptaksrundeMutations.java` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpptaksrundeMutations.java`, `V280` = `fs-plattform/opptak/opptak-migrations/…/V280__opptak_v2_skjema.sql`.

## Oppsummering

- Funnet: 10 av 25 scenarioer
- Ikke funnet: 11
- Usikker: 4
- Retagget: 0 (kravet er `@draft`)

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-PLA-RUN-001` | Legge til første runde | funnet | `fs-admin/…/plasstildeling/OpprettRundeForm/OpprettRundeForm.tsx:141-169` (navn, rundetype, svarfrist), mutation `opprettOpptaksrunderV2` (`OpprettRundeForm.tsx:27`), `OpptaksrundeMutations.java:44-62` |
| `@OPT-PLA-RUN-001` | Legge til en etterfølgende runde | ikke funnet | Bare rundetypen HOVED kan velges: `fs-admin/…/plasstildeling/OpprettRundeForm/components/OpptaksrundeSelect/OpptaksrundeSelect.tsx:42`. Backend tar imot alle typer |
| `@OPT-PLA-RUN-001` | Runde mangler obligatorisk opplysning | usikker | Navn: «Navn er påkrevd» (`OpprettRundeForm/utils/getFieldError.ts:16-17`). Rundetype: ingen melding, bare lagre-knappen er deaktivert (`OpprettRundeForm.tsx:132`). Svarfrist: «Svarfrist er påkrevd.» bare ved blur (`getFieldError.ts:22-23`, `OpprettRundeForm.tsx:167-169`). Svarfrist er ikke med i `isSaveDisabled`, så skjemaet kan sendes uten svarfrist hvis feltet aldri er rørt. Backend krever `svarfrist: DateTime!` (`opptaksrunde.graphqls:44-48`) |
| `@OPT-PLA-RUN-001` | Sette påminnelse om svarfrist | ikke funnet | Søkt etter påminnelse, paminnelse, reminder i begge repoene. Ingen kolonne i `opptaksrunde` (`V280:365-377`) |
| `@OPT-PLA-RUN-001` | Tilgjengelige rundetyper | ikke funnet | UI viser bare HOVED (`OpptaksrundeSelect.tsx:42`). Kodeverket har TEST, TIDLIG, HOVED, SUPPLERING, ETTERFYLLING og LEDIGE_STUDIEPLASSER (`V280:1590-1596`), ikke Hovedtildeling, Supplering, Etterfylling som i kravet |
| `@OPT-PLA-RUN-001` | Hovedtildeling kan bare finnes én gang | ikke funnet | Ingen sjekk i frontend eller backend. Løpenummer er maks + 1 per opptak (`OpptaksrundeMutations.java:34-49`), så en ny HOVED-runde stoppes ikke. I praksis er HOVED eneste type i UI-et, så alle runder blir HOVED |
| `@OPT-PLA-RUN-001` | Flere runder av samme type etter hovedtildelingen | funnet | Tillatt i backend: «Det kan vaere flere runder av samme type innenfor et opptak» (`V280:380`), test `OpptaksrundeIT.java:160`. I UI-et bare for HOVED |
| `@OPT-PLA-RUN-001` | Kjøre plasstildeling flere ganger i samme runde | usikker | Ikke sjekket i denne kjøringen. «Plasstildelingsløpet i Opptak» sier at `opprettPlasstildeling` kan kjøres flere ganger per runde |
| `@OPT-PLA-RUN-001` | Hovedtildeling er første runde i opptaket | ikke funnet | Ingen regel for rekkefølge i frontend eller backend |
| `@OPT-PLA-RUN-001` | Valgfri rekkefølge på rundetyper etter hovedtildelingen | ikke funnet | Bare HOVED kan velges i UI-et (`OpptaksrundeSelect.tsx:42`) |
| `@OPT-PLA-RUN-001` | Endre navn og svarfrist på en runde | funnet | «Rediger runde» (`PlasstildelingSection.tsx:233-238`), skjema `fs-admin/…/plasstildeling/RedigerRundeForm/RedigerRundeForm.tsx:155-167`, sender `{opptaksrundeId, navn, frist}` (`:118-124`), `OpptaksrundeMutations.java:88-114`. Se *Mulig feil* under |
| `@OPT-PLA-RUN-001` | Endre rundetype på eksisterende runde | funnet | Rundetype vises deaktivert i redigeringsskjemaet (`RedigerRundeForm.tsx:166`). `RedigerOpptaksrundeInput` har ikke rundetype (`opptaksrunde.graphqls:56-70`) |
| `@OPT-PLA-RUN-001` | Slette en runde som ikke er publisert | funnet | «Slett runde» (`PlasstildelingSection.tsx:240-246`, mutation `:59`), `OpptaksrundeMutations.java:116-137` |
| `@OPT-PLA-RUN-001` | Kan ikke slette en runde som er publisert til søker | funnet | `OpptaksrundeMutations.java:126-128` kaster «Kan ikke slette opptaksrunde som er publisert», vist i snackbar (`PlasstildelingSection.tsx:202-209`), test `OpptaksrundeIT.java:288-312`. Valget «Slett runde» vises likevel for publiserte runder |
| `@OPT-PLA-RUN-001` | Runde som ikke er publisert | funnet | Status «Ikke publisert» (`PlasstildelingSection.tsx:271-283`, `fs-admin/src/common/messages/nb/plasstildeling.json:20`) |
| `@OPT-PLA-RUN-001` | Runde som er publisert | funnet | Status «Publisert for søkere» (`plasstildeling.json:19`) når runden har publiseringstidspunkt og en publisert plasstildeling (`PlasstildelingSection.tsx:84-87`). Teksten er «Publisert for søkere», ikke «Publisert» |
| `@OPT-PLA-RUN-001` | Regler som følger av rundetypen | ikke funnet | Ingen logikk skiller på rundetype (se også gapet som står i kravet, og «Plasstildelingsløpet i Opptak», kap. 2) |
| `@OPT-PLA-RUN-001` | Åpne runden for ledige studieplasser | ikke funnet | Ingen egenskap for ledige studieplasser på runden (`V280:365-377`, `type Opptaksrunde` i `opptaksrunde.graphqls:79-98`) |
| `@OPT-PLA-RUN-001` | Opptaket tilbyr ikke søknad på ledige studieplasser | ikke funnet | Innstillingen finnes på opptaket (`OpptakSettings.tsx:226-231`, `opptak.graphqls:193`), men er ikke koblet til runder |
| `@OPT-PLA-RUN-001` | Sette periode for å endre antall tilbud som skal gis | usikker | Kan settes når runden opprettes (`OpprettRundeForm.tsx:174-215`), og vises i listen (`PlasstildelingSection.tsx:297-323`). Kan ikke endres i redigeringsskjemaet, og blir nullstilt når runden redigeres (se *Mulig feil*) |
| `@OPT-PLA-RUN-001` | Lærested kan ikke endre antall tilbud utenfor perioden | ikke funnet | Verken `upsertOpptaksparametere` eller tilgangsreglene i databasen leser perioden (`V280:1466-1490`, `V307:74-78`). Perioden brukes bare til å holde «Hent resultater» deaktivert (`fs-admin/…/plasstildeling/ParameterFeature/ParameterFeature.tsx:292-297`) |
| `@OPT-PLA-RUN-001` | Opptakseier kan endre antall tilbud utenfor perioden | usikker | Alle med MODIFISERE_OPPTAK kan endre uansett periode. Opptakseier kan altså endre, men det er ingen forskjell fra lærestedet |
| `@OPT-PLA-RUN-001` | Siste lagrede tall er korrekt uavhengig av hvem som satte det | ikke funnet | Tallet i UI-et lagres som `onsketAntallDeltakere` på kvoten, ikke per runde (`fs-admin/…/plasstildeling/ParameterFeature/components/ParameterDialog/ParameterDialog.tsx:40-47, 79-91`). `upsertOpptaksparametere` (per runde) finnes i backend, men kalles ikke fra frontend |
| `@OPT-PLA-RUN-001` | Runden har ingen eksplisitt publiseringsdato | funnet | Publiseringstidspunktet settes av `publiserRundeV2` når opptaksforvalter publiserer (`PubliserPlasstildelingService.java:108-110`). UI-et har ikke noe felt for det |
| `@OPT-PLA-RUN-001` | Opptak uten runder | funnet | Antall tilbud kan bare settes per runde: siden nås bare fra en runde, og `upsertOpptaksparametere` krever runde (`OpptaksparametereMutations.java:48-50`). «Ingen runder knyttet til opptaket.» vises når det ikke er runder (`PlasstildelingSection.tsx:330`) |

## Mulig feil

- **Redigering nullstiller periode og publiseringstidspunkt.** `redigerOpptaksrunde` setter alltid perioden for å endre antall tilbud og publiseringstidspunktet fra input (`OpptaksrundeMutations.java:98-102`). Frontend sender bare navn og svarfrist (`RedigerRundeForm.tsx:118-124`). Lagres redigeringsskjemaet, blir perioden ubegrenset og publiseringstidspunktet null, også på en publisert runde. Funnet ved å lese koden, ikke testet.
- **Svarfrist kan mangle.** Skjemaet for ny runde kan sendes uten svarfrist hvis feltet aldri er rørt (`OpprettRundeForm.tsx:132`).

## Oppfølging

- `fs-admin/src/…/RunderOverviewPage.tsx` importeres ikke noe sted (død kode).
- Kravet er `@draft`. Neste steg er validering med `fs-krav`, og deretter `fs-specify`.
