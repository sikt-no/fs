# Spec: Registrere og beregne praksis for søker

## Kilde

- **Oppgave:** `tasks/opptak/registrere-praksis/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`
- **GitHub:** [#560](https://github.com/sikt-no/fs/issues/560)
- **Hentet:** `2026-10-07 09:29`

## Omfang

Spesifikasjonen dekker praksiskalkulatoren i FS Admin. Søknadsbehandleren registrerer, endrer og sletter praksisperioder på en sak, med periode, omfang i stillingsprosent eller timer, arbeidsgiver og praksistype. Systemet beregner hver periode og summerer dem, med en sum av oppgitte perioder og en sum justert for overlapp. Kobling til opptakskrav (`knytte_praksis_til_opptakskrav.feature`) og kobling til dokumentasjon på søknaden (`@wont`) er ikke med. Det er heller ikke henting av praksis fra andre saker.

## Krav

- **`registrere_praksis.feature`** (`@OPT-BEH-BEH-003`). Registrere, endre og slette praksisperioder på saken. Beregning per periode (stillingsprosent eller timer mot årsverk) og summering med to summer ved overlapp. Validering av datoer og omfang, og tilgang for søknadsbehandler. ([krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/registrere_praksis.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/registrere_praksis.feature))

### Utenfor scope (`@wont`)

- **`registrere_praksis.feature`, scenario `Knytte praksisperioden til dokumentasjon på søknaden`**: prioritert `@wont` 02.10.2026. Praksiskalkulatoren skal ikke ha noen tilknytning til dokumentasjon.

## Skisser

### Skisse: Nyeste skisser

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20747-108803
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/nyeste-skisser/screenshot.png), [sub-frames/](krav-input/sketches/figma/nyeste-skisser/sub-frames/), [design-context.md](krav-input/sketches/figma/nyeste-skisser/design-context.md), [variables.md](krav-input/sketches/figma/nyeste-skisser/variables.md)
- **Dekker krav:** `registrere_praksis.feature`
  - 01 sidevisning: *Se registrerte praksisperioder*, *Inkludere en praksisperiode i praksisberegningen*, *Overlappende praksisperioder varsles*, *Både oppgitt og justert sum vises ved overlapp*, *Justert sum kan ikke overstige kalendertiden i perioden*, *Oppdatere en praksisperiode*, *Slette en praksisperiode*
  - 02 dialog: *Registrere en praksisperiode*, *Velge praksistype for en praksisperiode*, *Oppgi arbeidsgiver for en praksisperiode*, *Omfanget oppgis på én av måtene per praksisperiode*
  - 03–05 feil: *Sluttdato før startdato kan ikke lagres*, *Startdato og sluttdato er obligatorisk*, *Praksisperiode uten sluttdato kan ikke lagres*, *Ugyldig dato kan ikke lagres*
- **Valideringsstatus:** `Avvik`. Regnestykkene i skissen stemmer med kravet: inkluderte perioder gir 3,00 år, og overlappet 07–12.2022 på 125 % gir 2,875 år, som vises som 2,87 år. Datofeilmeldingene stemmer. Fire avvik:
  1. Omfangsfeltet i 05 viser datofeilmeldingen «Oppgi en gyldig dato, for eksempel 01.07.2022.», mens kravet krever en feilmelding om stillingsprosent 0–100 %.
  2. Timevarianten («Timer i perioden») er ikke skissert.
  3. Summkortet heter «Oppgitt relevant praksis», mens kravet bruker «sum av oppgitte perioder», og markeringen heter «Inkluder».
  4. Kalkulatoren er vist som en egen side med brødsmuler til opptaket, uten søker eller sak. Kravet sier at praksisperiodene hører til saken.
- **Beslutning ved avvik:**
  1. *Skissen er riktig, kravene mangler.* Avklart 07.10.2026: kopifeil i skissen. Kravet gjelder, og feilmeldingen er «Oppgi en stillingsprosent fra 0 til 100.» (implementasjonsdetaljene).
  2. *Kravene er riktige.* Skissen er ufullstendig. Timevarianten bygges fra kravet og implementasjonsdetaljene.
  3. *Kravene er riktige.* Kortet heter «Sum av oppgitte perioder» (avklart i implementasjonsdetaljene).
  4. *Skissen er riktig, kravene mangler.* Avklart 07.10.2026: kalkulatoren er en egen side for én sak, og åpnes fra saksvisningen. Siden viser hvilken søker og sak den gjelder. Kravet trenger ingen endring.

## Implementasjonsdetaljer

- **`registrere_praksis.feature`**: [registrere_praksis.design.md](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/registrere_praksis.design.md) (6 åpne designspørsmål)

## Kodesjekk

- **Sjekket:** fs-admin (`main` @ `9a14a8da1`), fs-plattform (`main` @ `05e6a32c0e`). Andre brancher er ikke sjekket.
- Ingen avvik.
- Rettet før denne kjøringen: kravet sa «opptakssaksbehandler», som ikke finnes i koden. Kravet er endret med `fs-krav` (07.10.2026) til «søknadsbehandler», som stemmer med `SØKNADSBEHANDLER` (`fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V12__tilgangskontroll_grunndata.sql:65`) og `FS-ADMIN_OPPTAK_SØKNADSBEHANDLER` (`fs-admin/src/common/types/generated/tilgangsroller.ts:67`).
- Til orientering:
  - Praksistypekodeverket med `STATUS_GJELDER_SOKER` finnes som `FSKODER.PRAKSISTYPE` (`fs-plattform/fskode/fskode-jooq/src/main/java/no/sikt/fs/fskode/generated/jooq/tables/Praksistype.java:100`). Det er ikke eksponert i opptak-subgrafen. `Praksistype` i SIS-skjemaet (`fs-plattform/sis/sis-graphql-spec/src/main/resources/schema/features/experimental/schema_exp.graphql:6068`) er undervisningspraksistyper, et annet kodeverk.
  - Saken finnes i fs-admin som `opptak/[id]/soknadsbehandling/sak/[sakId]` (`fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/layout.tsx`).
  - Ingen eksisterende praksisperioder, praksiskalkulator eller `PERSONPRAKSIS` i noen av repoene.

## Retagging

Kravet er hentet inn. Det ble satt tilbake fra `@in-progress` til `@planned` i forrige kjøring (07.10.2026), mens rollenavnet ble rettet.

| Fil | Før | Etter |
|---|---|---|
| `krav/02 …/registrere_praksis.feature` | `@OPT-BEH-BEH-003 @must @planned` | `@OPT-BEH-BEH-003 @must @in-progress` |

## Åpne spørsmål

- [x] Rollenavnet: kravet bruker «opptakssaksbehandler», koden har «Søknadsbehandler» (`SØKNADSBEHANDLER`). Kravet må endres med `fs-krav` før det kan hentes inn. Dette gjelder også `behandle_søknad.feature`, jf. «Oppfølging utenfor denne featuren» nederst i kravfila.
  - **Beslutning (07.10.2026):** rollen heter «søknadsbehandler» i kravet, som i koden.
  - **Begrunnelse:** rollen finnes i opptak og fs-admin. Rettet i kravet med `fs-krav` 07.10.2026. Brukerhistorien («Som saksbehandler i opptak») er beholdt.
- [x] Skisseavvik 1: Hva skal feilmeldingen under omfangsfeltet si, og når vises den? Skissen viser datofeilmeldingen der. Kravet krever en melding om stillingsprosent 0–100 %, og den teksten står åpen i implementasjonsdetaljene.
  - **Beslutning (07.10.2026):** kopifeil i skissen. Kravet gjelder, og feilmeldingen er «Oppgi en stillingsprosent fra 0 til 100.»
  - **Begrunnelse:** feltet er omfang, ikke dato. Teksten står i implementasjonsdetaljene.
- [x] Skisseavvik 4: Er praksiskalkulatoren en egen side, og hvordan henger den da sammen med at praksisperiodene hører til saken? Skissen viser en side med brødsmuler til opptaket, uten søker eller sak.
  - **Beslutning (07.10.2026):** egen side for én sak, åpnes fra saksvisningen, og viser hvilken søker og sak den gjelder.
  - **Begrunnelse:** kravet om at praksis hører til saken står. Plasseringen av inngangen står som åpent designspørsmål i implementasjonsdetaljene.

## Rute

fs-plattform → fs-admin
