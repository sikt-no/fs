# Spec: Appadmin etter design review

## Kilde

- **Oppgave:** `tasks/brukeradministrasjon-og-tilgangsstyring/appadmin-etter-design-review/`
- **Kilde-mappe:** `krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/` (`01 Iterasjon 2 - Support – Oversikt og passordbytte/` og `02 Iterasjon 3 - Grunnleggende tilgangsstyring for intern support/`)
- **GitHub:** [#438](https://github.com/sikt-no/fs/issues/438), [#439](https://github.com/sikt-no/fs/issues/439), [#440](https://github.com/sikt-no/fs/issues/440), [#441](https://github.com/sikt-no/fs/issues/441), [#446](https://github.com/sikt-no/fs/issues/446), [#448](https://github.com/sikt-no/fs/issues/448), [#449](https://github.com/sikt-no/fs/issues/449)
- **Opprettet:** 2026-10-05 i FS Kravforvaltning
- **Hentet:** 2026-10-05

## Omfang

Spesifikasjonen dekker endringene i applikasjonsadministrasjonen etter design review (v2.2, innsyn for eksterne i sektoren). Dette gjelder nye begreper (Applikasjonseier, Gjelder for, Tjeneste-ID, FS (Maskinbruker)), filter på identitetsleverandør, opprettelse av FS-applikasjoner med brukernavn, «ukjent» som virksomhetsidentifikator for Maskinporten (feltet vises ikke) og passord per miljø. Sortering på navn og tildeling og fjerning av tilganger er ikke med.

## Krav

Alle fem kravene er levert (`@implemented`) og endres. Bare delene under er med; resten av filene er levert og utenfor scope.

- **`listevisning_og_sok.feature` — scenario `Se liste over applikasjoner`** (`@BRU-APP-API-001`, endring av levert krav) — kolonnene Applikasjonseier og Identitetsleverandør i stedet for Organisasjon, og ingen fast sortering. Erstatter `Se liste over applikasjoner` (`@deprecated`). ([krav-input/local/…/listevisning_og_sok.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature))
- **`listevisning_og_sok.feature` — scenario `Tilgjengelige identitetsleverandører i filter`** (`@BRU-APP-API-001`, tillegg) — filter med «Alle identitetsleverandører», Feide, Maskinporten og FS (Maskinbruker). ([krav-input/local/…/listevisning_og_sok.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature))
- **`listevisning_og_sok.feature` — scenario `Filtrere på identitetsleverandør`** (`@BRU-APP-API-001`, tillegg) — listen viser bare applikasjoner med valgt identitetsleverandør. ([krav-input/local/…/listevisning_og_sok.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature))
- **`se_detaljer.feature` — scenarioene `Se Tjeneste-ID for Feide-applikasjon`, `Se Client-ID for Maskinporten-applikasjon` og `Se brukernavn for FS-applikasjon`** (`@BRU-APP-API-002`, endring av levert krav) — identifikatoren vises med navnet identitetsleverandøren bruker. Scenarioet `Se konsument sin virksomhetsidentifikator for Maskinporten-applikasjon` ble slettet 2026-10-05, fordi virksomhetsidentifikatoren ikke skal vises. Erstatter `Se ekstern ID fra identitetsleverandør` (`@deprecated`). ([krav-input/local/…/se_detaljer.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/se_detaljer.feature))
- **`vise_tilganger.feature` — scenario `Se tilganger for en applikasjon`** (`@BRU-APP-API-003`, endring av levert krav) — kolonnene Tilgangskode, Beskrivelse, Gjelder for og Miljø. Erstatter `Se tilganger for en applikasjon` (`@deprecated`). ([krav-input/local/…/vise_tilganger.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature))
- **`vise_tilganger.feature` — scenario `Tilgjengelige verdier i gjelder for-filter`** (`@BRU-APP-API-003`, endring av levert krav) — organisasjonsfilteret heter «gjelder for». Erstatter `Tilgjengelige organisasjoner i filter` (`@deprecated`). ([krav-input/local/…/vise_tilganger.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature))
- **`vise_tilganger.feature` — scenario `Filtrere tilgangsliste på gjelder for`** (`@BRU-APP-API-003`, endring av levert krav) — viser tilgangene som gjelder data i valgt organisasjon. Erstatter `Filtrere tilgangsliste på organisasjon` (`@deprecated`). ([krav-input/local/…/vise_tilganger.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature))
- **`passordbytte.feature` — regel `Nytt passord genereres av systemet for ett valgt miljø`** (`@BRU-APP-API-004`, endring av levert krav) — passord genereres per miljø, påvirker ikke andre miljøer, og kan settes i et miljø uten tilganger. Erstatter `Nytt passord genereres av systemet` (`@deprecated`). ([krav-input/local/…/passordbytte.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/passordbytte.feature))
- **`passordbytte.feature` — regel `Kun ett passord er aktivt per miljø om gangen`** (`@BRU-APP-API-004`, endring av levert krav) — nytt passord erstatter det gamle i samme miljø. Erstatter `Kun ett passord er aktivt om gangen` (`@deprecated`). ([krav-input/local/…/passordbytte.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/passordbytte.feature))
- **`opprette_applikasjon.feature` — scenario `Velge identitetsleverandør ved opprettelse, inkludert FS`** (`@BRU-APP-API-009`, endring av levert krav) — FS kan velges ved opprettelse. Erstatter `Velge identitetsleverandør ved opprettelse` og `FS er ikke en valgbar identitetsleverandør` (begge `@deprecated`). ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature))
- **`opprette_applikasjon.feature` — scenariomal `Opprette applikasjon med ekstern identitet og oppgitt navn`** (`@BRU-APP-API-009`, endring av levert krav) — navnet oppgis av brukeren, ikke hentet fra identitetsleverandøren. Erstatter `Opprette applikasjon med ekstern identitet` (`@deprecated`). ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature))
- **`opprette_applikasjon.feature` — regel `Konsument sin virksomhetsidentifikator oppgis ikke ved opprettelse`** (`@BRU-APP-API-009`, tillegg) — virksomhetsidentifikatoren oppgis ikke ved opprettelse, og en Maskinporten-applikasjon får «ukjent». Endret 2026-10-05 (het `Maskinporten-applikasjoner har i tillegg konsument sin virksomhetsidentifikator`, der virksomhetsidentifikatoren ble oppgitt og formatsjekket etter ISO 6523, slik råkopien viser). ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature))
- **`opprette_applikasjon.feature` — regel `FS-applikasjoner identifiseres av et brukernavn som ikke verifiseres mot en ekstern kilde`** (`@BRU-APP-API-009`, tillegg) — FS-applikasjonen opprettes med et brukernavn, som må være unikt og skiller mellom store og små bokstaver, og har samme identitet i alle miljøer. Scenarioet `FS-brukernavnet skiller mellom store og små bokstaver` er lagt til 2026-10-05, og finnes ikke i råkopien. Hentet inn 2026-10-05 etter avklaring (var `@draft @openquestion`). Hjelpeteksten for feltet står under Skisser. ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature))
- **`opprette_applikasjon.feature` — regel `Beskrivelse kan angis ved opprettelse`** (`@BRU-APP-API-009`, tillegg) — valgfri beskrivelse ved opprettelse. ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature))
- **`opprette_applikasjon.feature` — scenarioene `Opprettelse avvises når visningsnavnet er i bruk hos samme identitetsleverandør` og `… hos en annen identitetsleverandør`** (`@BRU-APP-API-009`, endring av levert krav) — unikhet sjekkes på oppgitt navn, på tvers av identitetsleverandører. Erstatter `Opprettelse avvises når visningsnavn allerede er i bruk` (`@deprecated`). ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature))
- **`opprette_applikasjon.feature` — scenarioene `Nyopprettet Feide- eller Maskinporten-applikasjon kan autentisere umiddelbart` og `Nyopprettet FS-applikasjon kan først autentisere når passord er satt`** (`@BRU-APP-API-009`, endring av levert krav) — skiller mellom ekstern identitet og FS-passord per miljø. Erstatter `Nyopprettet applikasjon kan autentisere umiddelbart` (`@deprecated`). ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature))

### Utenfor scope (`@draft`)

- **`listevisning_og_sok.feature` — scenario `Liste er sortert etter navn som standard`** — venter på: Når kan fs-plattform sortere applikasjonene på navn på tvers av Feide-, Maskinporten- og FS-applikasjoner? (Jira: BAT-268)
- **`listevisning_og_sok.feature` — scenariomal `Velge sorteringsretning for navn`** — venter på: samme spørsmål (Jira: BAT-268)

### Skal fjernes (`@deprecated`)

- **`listevisning_og_sok.feature` — scenario `Se liste over applikasjoner`** (med kolonnen Organisasjon og fast sortering på navn) ([krav-input/local/…/listevisning_og_sok.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature)). Erstattes av `Se liste over applikasjoner` (`@in-progress`).
- **`listevisning_og_sok.feature` — scenario `Listen inkluderer eksisterende FS-applikasjoner`** ([krav-input/local/…/listevisning_og_sok.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature)).
- **`se_detaljer.feature` — scenario `Se ekstern ID fra identitetsleverandør`** ([krav-input/local/…/se_detaljer.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/se_detaljer.feature)). Erstattes av `Se Tjeneste-ID for Feide-applikasjon`, `Se Client-ID for Maskinporten-applikasjon` og `Se brukernavn for FS-applikasjon`.
- **`se_detaljer.feature` — scenario `Se intern ID`** ([krav-input/local/…/se_detaljer.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/se_detaljer.feature)).
- **`vise_tilganger.feature` — scenario `Se tilganger for en applikasjon`** (med organisasjon) ([krav-input/local/…/vise_tilganger.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature)). Erstattes av `Se tilganger for en applikasjon` (`@in-progress`).
- **`vise_tilganger.feature` — scenario `Tilgjengelige organisasjoner i filter`** ([krav-input/local/…/vise_tilganger.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature)). Erstattes av `Tilgjengelige verdier i gjelder for-filter`.
- **`vise_tilganger.feature` — scenario `Filtrere tilgangsliste på organisasjon`** ([krav-input/local/…/vise_tilganger.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature)). Erstattes av `Filtrere tilgangsliste på gjelder for`.
- **`passordbytte.feature` — regel `Nytt passord genereres av systemet`** ([krav-input/local/…/passordbytte.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/passordbytte.feature)). Erstattes av `Nytt passord genereres av systemet for ett valgt miljø`.
- **`passordbytte.feature` — regel `Kun ett passord er aktivt om gangen`** ([krav-input/local/…/passordbytte.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/passordbytte.feature)). Erstattes av `Kun ett passord er aktivt per miljø om gangen`.
- **`opprette_applikasjon.feature` — scenario `Velge identitetsleverandør ved opprettelse`** ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature)). Erstattes av `Velge identitetsleverandør ved opprettelse, inkludert FS`.
- **`opprette_applikasjon.feature` — scenario `FS er ikke en valgbar identitetsleverandør`** ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature)). Erstattes av `Velge identitetsleverandør ved opprettelse, inkludert FS`.
- **`opprette_applikasjon.feature` — scenariomal `Opprette applikasjon med ekstern identitet`** (navn hentet fra identitetsleverandøren) ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature)). Erstattes av `Opprette applikasjon med ekstern identitet og oppgitt navn`.
- **`opprette_applikasjon.feature` — scenariomal `Opprettelse avvises når visningsnavn allerede er i bruk`** ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature)). Erstattes av `Opprettelse avvises når visningsnavnet er i bruk hos samme identitetsleverandør` og `… hos en annen identitetsleverandør`.
- **`opprette_applikasjon.feature` — scenario `Nyopprettet applikasjon kan autentisere umiddelbart`** ([krav-input/local/…/opprette_applikasjon.feature](krav-input/local/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature)). Erstattes av `Nyopprettet Feide- eller Maskinporten-applikasjon kan autentisere umiddelbart` og `Nyopprettet FS-applikasjon kan først autentisere når passord er satt`.

## Skisser

### Skisse: Applikasjoner v2.2

- **Type:** `figma`
- **Referanse:** <https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4949-50600&t=WkOSyNR8oxBXz5wo-1> (section «Applikasjoner v2.2», `4949:50600`)
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/applikasjoner-v2-2/screenshot.png), [sub-frames/](krav-input/sketches/figma/applikasjoner-v2-2/sub-frames/) (11 rammer), [design-context.md](krav-input/sketches/figma/applikasjoner-v2-2/design-context.md)
- **Dekker krav:** `listevisning_og_sok.feature`, `opprette_applikasjon.feature`, `se_detaljer.feature`, `passordbytte.feature`, `vise_tilganger.feature`
  - Listevisning (01) → `listevisning_og_sok.feature`
  - Legg til applikasjon, Feide / Maskinporten / FS (02–05) → `opprette_applikasjon.feature`
  - Detaljside Feide / Maskinporten / FS (06–08) → `se_detaljer.feature`; knappen «Generer nytt passord» (08) → `passordbytte.feature`
  - Tilgangsliste (09) → `vise_tilganger.feature`
  - Tildel / Fjern tilganger (10–11) → `tildele_tilganger.feature` og `fjerne_tilganger.feature`, som ikke er med i denne spesifikasjonen
- **Valideringsstatus:** `Avvik` (se under). Ellers OK: kolonnene og filtrene i listevisningen, Applikasjonseier, Beskrivelse og Client-ID ved opprettelse, identifikatorene på detaljsiden og at intern ID er borte, og kolonnene og filtrene (Gjelder for, Tilknytning) i tilgangslisten.
  1. **Feide-identifikatoren:** skissen kaller den «Tjeneste-ID» (modal og detaljside), kravet kalte den «Service-ID». *Løst 2026-10-05: skissen er riktig, kravet er rettet til «Tjeneste-ID».*
  2. **Navnet på FS:** skissen bruker «FS (Maskinbruker)» i listen, filteret, modalen og detaljsiden. Kravene brukte «FS», også i verditabellen i `Tilgjengelige identitetsleverandører i filter`. *Løst 2026-10-05: skissen er riktig. Verdiene som vises, er rettet til «FS (Maskinbruker)», og stegene skriver fortsatt FS.*
  3. **FS-brukernavn ved opprettelse:** modalen for FS har feltet «Brukernavn» og infoteksten om samme identitet i alle miljøer. Det var regelen `FS-applikasjoner identifiseres av et brukernavn …`, som var `@draft` og utenfor scope. *Løst 2026-10-05: skissen er riktig, og regelen er hentet inn (`@in-progress`). Brukernavnet valideres i FS Admin, og er case-sensitivt. Hjelpeteksten under «Brukernavn» skal være: «Brukernavnet applikasjonen bruker til å autentisere seg mot FS. Brukernavnet må være unikt, og er case-sensitivt.» (skissen har bare første setning). Hjelpeteksten står ikke i kravet.*
  4. **Sortering i listevisningen:** skissen har sorteringsvelger, mens sortering på navn er `@draft` (BAT-268). *Avklart 2026-10-05: ulikt scope. Sortering på navn blir stående som `@draft`, og sorteringsvelgeren i skissen bygges ikke i denne spesifikasjonen.*
  5. **Passord per miljø (uavklart):** detaljsiden for FS har «Generer nytt passord», men ingen ramme viser valget av miljø eller visningen av passordet. Kan ikke vurderes mot `Nytt passord genereres av systemet for ett valgt miljø`. *Avklart 2026-10-05: det skisseres ikke. Valg av miljø og visning av passordet bygges ut fra kravene alene.*
  6. **Konsument sin virksomhetsidentifikator:** skissen viser feltet i modalen for Maskinporten (04) og på detaljsiden for Maskinporten (07). *Endret 2026-10-05: kravet er riktig, og skissen er utdatert her. Feltet oppgis ikke ved opprettelse, vises ikke på detaljsiden, og Maskinporten-applikasjonen får «ukjent» (fra merknaden i BAT-270).*
- **Beslutning ved avvik:** alle avklart 2026-10-05 (se Åpne spørsmål). 1–3: skissen er riktig, og kravene er oppdatert. 4: ulikt scope, sorteringen er fortsatt `@draft`. 5: skisseres ikke, og bygges ut fra kravene. 6: skissen er utdatert, feltet for virksomhetsidentifikator vises ikke.

## Retagging

Egenskapene står urørt som `@implemented`. 20 deler er retagget `@planned` → `@in-progress` i `krav/`, og 1 `@draft`-del fikk `@in-progress` etter avklaring. `@deprecated`- og `@draft`-delene er ikke rørt.

| Fil | Del | Før | Etter |
|---|---|---|---|
| `krav/07 …/01 …/listevisning_og_sok.feature` | Scenario: Se liste over applikasjoner | `@planned` | `@in-progress` |
| `krav/07 …/01 …/listevisning_og_sok.feature` | Scenario: Tilgjengelige identitetsleverandører i filter | `@planned` | `@in-progress` |
| `krav/07 …/01 …/listevisning_og_sok.feature` | Scenario: Filtrere på identitetsleverandør | `@planned` | `@in-progress` |
| `krav/07 …/01 …/se_detaljer.feature` | Scenario: Se Tjeneste-ID for Feide-applikasjon (het «Se Service-ID …» ved henting) | `@planned` | `@in-progress` |
| `krav/07 …/01 …/se_detaljer.feature` | Scenario: Se Client-ID for Maskinporten-applikasjon | `@planned` | `@in-progress` |
| `krav/07 …/01 …/se_detaljer.feature` | Scenario: Se konsument sin virksomhetsidentifikator for Maskinporten-applikasjon | `@planned` | `@in-progress`, slettet 2026-10-05 (ikke levert) |
| `krav/07 …/01 …/se_detaljer.feature` | Scenario: Se brukernavn for FS-applikasjon | `@planned` | `@in-progress` |
| `krav/07 …/01 …/vise_tilganger.feature` | Scenario: Se tilganger for en applikasjon | `@planned` | `@in-progress` |
| `krav/07 …/01 …/vise_tilganger.feature` | Scenario: Tilgjengelige verdier i gjelder for-filter | `@planned` | `@in-progress` |
| `krav/07 …/01 …/vise_tilganger.feature` | Scenario: Filtrere tilgangsliste på gjelder for | `@planned` | `@in-progress` |
| `krav/07 …/01 …/passordbytte.feature` | Regel: Nytt passord genereres av systemet for ett valgt miljø | `@planned` | `@in-progress` |
| `krav/07 …/01 …/passordbytte.feature` | Regel: Kun ett passord er aktivt per miljø om gangen | `@planned` | `@in-progress` |
| `krav/07 …/02 …/opprette_applikasjon.feature` | Scenario: Velge identitetsleverandør ved opprettelse, inkludert FS | `@planned` | `@in-progress` |
| `krav/07 …/02 …/opprette_applikasjon.feature` | Scenariomal: Opprette applikasjon med ekstern identitet og oppgitt navn | `@planned` | `@in-progress` |
| `krav/07 …/02 …/opprette_applikasjon.feature` | Regel: Konsument sin virksomhetsidentifikator oppgis ikke ved opprettelse (het «Maskinporten-applikasjoner har i tillegg konsument sin virksomhetsidentifikator» ved henting, endret 2026-10-05) | `@planned` | `@in-progress` |
| `krav/07 …/02 …/opprette_applikasjon.feature` | Regel: FS-applikasjoner identifiseres av et brukernavn som ikke verifiseres mot en ekstern kilde | `@draft @openquestion` | `@in-progress` (etter avklaring 2026-10-05, `# ÅPNE SPØRSMÅL:` fjernet) |
| `krav/07 …/02 …/opprette_applikasjon.feature` | Regel: Beskrivelse kan angis ved opprettelse | `@planned` | `@in-progress` |
| `krav/07 …/02 …/opprette_applikasjon.feature` | Scenario: Opprettelse avvises når visningsnavnet er i bruk hos samme identitetsleverandør | `@planned` | `@in-progress` |
| `krav/07 …/02 …/opprette_applikasjon.feature` | Scenario: Opprettelse avvises når visningsnavnet er i bruk hos en annen identitetsleverandør | `@planned` | `@in-progress` |
| `krav/07 …/02 …/opprette_applikasjon.feature` | Scenario: Nyopprettet Feide- eller Maskinporten-applikasjon kan autentisere umiddelbart | `@planned` | `@in-progress` |
| `krav/07 …/02 …/opprette_applikasjon.feature` | Scenario: Nyopprettet FS-applikasjon kan først autentisere når passord er satt | `@planned` | `@in-progress` |

## Åpne spørsmål

- [x] Skisseavvik 1: Feide-identifikatoren heter «Tjeneste-ID» i skissen og «Service-ID» i kravet. Hvilken er riktig?
  - **Beslutning:** Skissen er riktig. Scenarioet i `se_detaljer.feature` heter nå `Se Tjeneste-ID for Feide-applikasjon`, og steget sier «Tjeneste-ID».
  - **Begrunnelse:** Valgt av brukeren 2026-10-05 («skissen er riktig»). Skissen bruker «Tjeneste-ID» både ved opprettelse og på detaljsiden.
- [x] Skisseavvik 2: FS heter «FS (Maskinbruker)» i skissen og «FS» i kravene. Hvilken er riktig?
  - **Beslutning:** Skissen er riktig. I `listevisning_og_sok.feature` er verdien i tabellen i `Tilgjengelige identitetsleverandører i filter` nå «FS (Maskinbruker)». I `opprette_applikasjon.feature` sier `Velge identitetsleverandør ved opprettelse, inkludert FS` nå «Feide, Maskinporten og FS (Maskinbruker)». Beskrivelsen av egenskapen sier at FS vises som «FS (Maskinbruker)» i løsningen, og at stegene skriver FS.
  - **Begrunnelse:** Valgt av brukeren 2026-10-05 («oppdater kravene slik at det matcher med skissene»). De leverte delene som sier FS, er ikke endret, fordi de beskriver koden som finnes.
- [x] Skisseavvik 3: Skissen viser FS-brukernavn ved opprettelse, men regelen om FS-brukernavn er `@draft`. Skal den med i denne spesifikasjonen (avklares i `fs-krav` først), eller bygges FS-opprettelse uten den?
  - **Beslutning:** Skissen er riktig. Regelen `FS-applikasjoner identifiseres av et brukernavn som ikke verifiseres mot en ekstern kilde` er tatt inn i spesifikasjonen som `@in-progress`. Det åpne spørsmålet om oppslag mot FS er lukket: brukernavnet valideres i FS Admin, og er case-sensitivt. Hjelpeteksten under «Brukernavn»: «Brukernavnet applikasjonen bruker til å autentisere seg mot FS. Brukernavnet må være unikt, og er case-sensitivt.»
  - **Begrunnelse:** Valgt av brukeren 2026-10-05. Hjelpeteksten står i spesifikasjonen og ikke i kravet, etter ønske fra brukeren.
- [x] Skisseavvik 4: Skissen har sorteringsvelger i listevisningen, men sortering på navn er `@draft` (BAT-268). Er skissen målbildet etter BAT-268, eller skal sorteringen bygges nå?
  - **Beslutning:** Sortering på navn skal være `@draft`. `Liste er sortert etter navn som standard` og `Velge sorteringsretning for navn` står fortsatt under «Utenfor scope», og sorteringsvelgeren i listevisningen bygges ikke nå.
  - **Begrunnelse:** Valgt av brukeren 2026-10-05.
- [x] Uavklart skisse: Ingen ramme viser valg av miljø og visning av passordet ved «Generer nytt passord». Finnes det en skisse for det?
  - **Beslutning:** Nei, det skisseres ikke. Valg av miljø og visning av passordet bygges ut fra `passordbytte.feature` alene.
  - **Begrunnelse:** Valgt av brukeren 2026-10-05.
- [x] Skal visningsnavnet være unikt på tvers av identitetsleverandører, eller bare blant applikasjoner med samme identitetsleverandør? (Dagens løsning tillater samme navn på en Feide- og en Maskinporten-applikasjon.)
  - **Beslutning:** På tvers av identitetsleverandører, slik kravet sier. `Opprettelse avvises når visningsnavnet er i bruk hos en annen identitetsleverandør` gjelder, og løsningen må endres.
  - **Begrunnelse:** Valgt av brukeren 2026-10-05, etter en gjennomgang av fs-plattform og fs-admin.
- [x] Skal konsument sin virksomhetsidentifikator oppgis ved opprettelse? (BAT-270: «Vurder å send in “ukjent” fra frontend i konsument-ID og skjul fra dialogen.»)
  - **Beslutning:** Nei. Regelen heter nå `Konsument sin virksomhetsidentifikator oppgis ikke ved opprettelse`: feltet er ikke en del av opprettelsen, og en Maskinporten-applikasjon får «ukjent». Scenarioene om ISO 6523-format, organisasjonsregister og applikasjonseier er fjernet, og `Se konsument sin virksomhetsidentifikator for Maskinporten-applikasjon` er slettet fra `se_detaljer.feature`. Skissen er utdatert på dette punktet (avvik 6).
  - **Begrunnelse:** Valgt av brukeren 2026-10-05. Delene var `@in-progress` og ikke levert, så de er endret der de står.

## Gjennomgang av koden (2026-10-05)

Det som finnes og det som mangler i lokale kloner av fs-plattform og fs-admin, lest uten å kjøre noe. Dette er ikke en verifisering (det gjør `fs-verify`), og ikke et forslag til løsning.

### fs-plattform (subgrafen `tilgangsstyring`)

Finnes:

- Opprettelse for alle tre identitetsleverandørene: `opprettFeideApplikasjoner`, `opprettMaskinportenApplikasjoner` og `opprettMaskinbrukerApplikasjoner`, alle med valgfri `beskrivelse` (`applikasjon_forvaltning.graphqls`, `mutasjoner.graphqls`).
- Konsument sin virksomhetsidentifikator: `konsumentId` på `MaskinportenApplikasjon`, påkrevd ved opprettelse, med formatsjekk etter ISO 6523 og uten oppslag i et organisasjonsregister.
- Brukernavn for FS: `verifiserMaskinbrukerApplikasjonEksternId` sjekker formatet `[A-Za-z0-9._-]{1,50}` og at brukernavnet ikke er i bruk, uten ekstern kilde.
- Passord per miljø: `genererNyttMaskinbrukerApplikasjonPassord(applikasjonId, miljoId)`. Passordet utleveres bare i svaret.
- Identifikatoren per type som `eksternId` (`SERVICE_ID`, `CLIENT_ID`, `BRUKERNAVN`), `organisasjon` (applikasjonseier), `miljoer` og `tilgangerOrganisasjoner` (kilde for gjelder for-filteret).
- Ingen sortering på navn (`orderBy` har ingen virkning). Det stemmer med at sorteringen er `@draft`.

Mangler eller avviker:

- **Filter på identitetsleverandør:** `ApplikasjonerFilterInput` har `organisasjoner`, `navnContains`, `miljoer` og `status`, men ikke identitetsleverandør. Gjelder `Filtrere på identitetsleverandør`.
- **Visningsnavn på tvers av identitetsleverandører:** `ApplikasjonVisningsnavnAlleredeIBruk` (`feil.graphqls`) sier at navnet bare er unikt blant applikasjoner av samme type. Kravet sier at samme navn skal avvises også hos en annen identitetsleverandør (`Opprettelse avvises når visningsnavnet er i bruk hos en annen identitetsleverandør`, besluttet 2026-10-05). Koden må endres.
- **«Ukjent» som virksomhetsidentifikator:** `konsumentId` er påkrevd ved opprettelse av en Maskinporten-applikasjon, og verifiseringen sjekker formatet `\d{4}:[0-9A-Za-z]+`. Det er ikke bekreftet at «ukjent» godtas ved opprettelse. Gjelder `Maskinporten-applikasjon får ukjent virksomhetsidentifikator`.
- **Store og små bokstaver i FS-brukernavnet:** formatet tillater store bokstaver, men det er ikke bekreftet at sjekken av om brukernavnet er i bruk, skiller mellom store og små. Gjelder `FS-brukernavnet skiller mellom store og små bokstaver`.

### fs-admin (`src/domains/tilgangsstyring/`)

Finnes:

- Modalen for opprettelse (`OpprettApplikasjonModal`) har alle tre identitetsleverandørene, beskrivelse, applikasjonseier, Client-ID, konsument-ID og brukernavn, og den samme infoteksten for FS som skissen.
- Dialogen for passord (`ApplikasjonPassord`) har valg av miljø, vis og skjul, kopier, og viser passordet én gang.
- Tilgangslisten har filter på tilknytning og merking av arvede tilganger.
- Intern ID er fjernet fra detaljsiden.

Mangler eller avviker (mest tekster og visning, `src/common/messages/nb/domains.json`):

- Navn på felt og verdier som ikke stemmer med kravene og skissen:

  | I koden | Skal være |
  |---|---|
  | «FS-bruker» | «FS (Maskinbruker)» |
  | «Service-ID» | «Tjeneste-ID» |
  | «Organisasjon» i liste, filter, detaljside og modal | «Applikasjonseier» |
  | «Organisasjon» i tilgangslisten (kolonne og filter) | «Gjelder for» |

- Detaljsiden (`ApplikasjonDetaljer`) viser «Ekstern ID» for alle identitetsleverandørene. Kravene vil ha Tjeneste-ID, Client-ID eller Brukernavn, etter identitetsleverandør. Konsument sin virksomhetsidentifikator skal ikke vises.
- Modalen for opprettelse har feltet «Konsument-ID» for Maskinporten. Feltet skal bort, og applikasjonen skal få «ukjent».
- Listevisningen har kolonnene Navn, Organisasjon, Antall tilganger og Status. Kolonnen og filteret for identitetsleverandør mangler.
- Hjelpetekster:
  - Navn: koden sier «unikt blant applikasjoner av samme type», som ikke stemmer med beslutningen om unikhet på tvers.
  - Brukernavn: koden har «Brukernavnet applikasjonen autentiserer med mot FS.» Den nye teksten er «Brukernavnet applikasjonen bruker til å autentisere seg mot FS. Brukernavnet må være unikt, og er case-sensitivt.»
  - Formatmeldingen for brukernavn sier «bokstaver (a–z) … høyst 64 tegn», mens fs-plattform tillater store bokstaver og høyst 50 tegn. Sjekker fs-admin det meldingen sier, avvises «App1», og da kan ikke `FS-brukernavnet skiller mellom store og små bokstaver` oppfylles.

### Åpent fra BAT-270

- [BAT-270](https://sikt.atlassian.net/browse/BAT-270) har merknaden «Vurder å send in “ukjent” fra frontend i konsument-ID og skjul fra dialogen.» *Løst 2026-10-05: kravet er endret med `fs-krav`, se det siste spørsmålet under Åpne spørsmål.*

## Rute

fs-plattform → fs-admin
