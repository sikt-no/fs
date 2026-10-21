# Verifisering: Registrere og beregne praksis for søker

- **Dato:** 2026-10-13 10:17
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/registrere_praksis.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (`main` @ `7860426b6c`), `fs-admin` (`stek-549-feat-registrere-praksis` @ `81efd6960`, ikke merget til `main`)
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei (frontend er ikke merget, og ligger bak Unleash-flagget `soknadsbehandling-praksiskalkulator`)

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`.

Stiene er forkortet:

- `PS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/praksis`
- `PM` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `PG` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/praksis.graphqls`
- `AP` = `fs-admin/src/domains/soknadsbehandling/features/Praksiskalkulator`
- `AM` = `fs-admin/src/common/messages/nb/soknadsbehandling.json`

## Oppsummering

- Scenarioer: 42 funnet, 0 ikke funnet, 3 usikker, av 45
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-003` | Registrere en praksisperiode | funnet | `PS/PraksisperiodeService.java:68` — validerer og lagrer perioden på saken, og svaret har ny beregning (`AP/opprettPraksisperiode.operation.ts:24`) |
| `@OPT-BEH-BEH-003` | Praksisperioder hører til saken de er registrert på | funnet | `PM/V404__sak_praksisperiode.sql:21` — nøkkelen er saken. `PS/PraksisberegningService.java:68` henter per sak |
| `@OPT-BEH-BEH-003` | Praksis fra andre saker vises ikke | funnet | `PS/PraksisberegningService.java:68` · `AP/praksiskalkulatorSak.operation.ts:18` — bare praksisberegningen for saken. Ingenting viser praksis på andre saker |
| `@OPT-BEH-BEH-003` | Registrert praksis ligger fast på saken | funnet | `PM/V404__sak_praksisperiode.sql:4` — periodene og «Inkluder» (`relevant`) lagres. Summene regnes fra lagrede rader (`PS/PraksisberegningService.java:89`) |
| `@OPT-BEH-BEH-003` | Se registrerte praksisperioder | funnet | `AP/components/PraksisperioderTable/PraksisperioderTable.tsx:95` — arbeidsgiver/type, periode (`:120`), omfang og beregnet praksis (`:146`) |
| `@OPT-BEH-BEH-003` | Velge praksistype for en praksisperiode | funnet | `PM/V403__arbeidserfaringstype.sql:22` — 37 praksistyper fra FSKODER som gjelder søker («foreløpig liste»). Valglisten: `PG:3`, `AP/components/PraksisperiodeForm/PraksisperiodeForm.tsx:313` |
| `@OPT-BEH-BEH-003` | Inkludere en praksisperiode i praksisberegningen | funnet | `PS/PraksisperiodeService.java:136` · `AP/components/InkluderCheckbox/InkluderCheckbox.tsx:84` — egen mutasjon for «Inkluder». Beregningen filtrerer i `PS/Praksisberegner.java:149` |
| `@OPT-BEH-BEH-003` | Praksisperioder som ikke er inkludert, telles ikke med | funnet | `PS/Praksisberegner.java:149` — bare inkluderte perioder summeres (1,00 år i eksempelet) |
| `@OPT-BEH-BEH-003` | Overlapp beregnes bare mellom inkluderte praksisperioder | funnet | `PS/Praksisberegner.java:155` — overlappsintervallene bygges bare fra inkluderte perioder (0,50 / 0,50) |
| `@OPT-BEH-BEH-003` | En ny praksisperiode er inkludert som standard | funnet | `AP/utils/praksisperiodeFormState.ts:150` — ny periode sendes med `relevant: true` |
| `@OPT-BEH-BEH-003` | Startdato og sluttdato er obligatorisk | funnet | `PS/PraksisperiodeRegler.java:117` · `PG:149` · `AP/utils/validatePraksisperiode.ts:49` — praksistype er valgfri (`PM/V404__sak_praksisperiode.sql:10`, «Praksistype (valgfri)» i `AM`) |
| `@OPT-BEH-BEH-003` | Oppgi arbeidsgiver for en praksisperiode | funnet | `AP/components/PraksisperiodeForm/PraksisperiodeForm.tsx:302` — «Arbeidsgiver (valgfri)», kolonnen kan være tom (`PM/V404__sak_praksisperiode.sql:9`) |
| `@OPT-BEH-BEH-003` | Praksisperiode uten sluttdato kan ikke lagres | funnet | `PS/PraksisperiodeRegler.java:117` (`SLUTTDATO_MANGLER`) · `AP/utils/validatePraksisperiode.ts:56` — «Oppgi sluttdato.» |
| `@OPT-BEH-BEH-003` | Sluttdato før startdato kan ikke lagres | funnet | `PS/PraksisperiodeRegler.java:120` · `AP/utils/validatePraksisperiode.ts:60` — «Sluttdatoen kan ikke være før startdatoen.» |
| `@OPT-BEH-BEH-003` | Ugyldig dato kan ikke lagres | funnet | `AP/utils/validatePraksisperiode.ts:39` — «Oppgi en gyldig dato …». Backend avviser ugyldig `LocalDate` i skalaren. Kontrollen: usikker, fordi datovelgeren trolig ikke slipper gjennom en dato som 31.02. Brukeren bekreftet at ugyldig dato håndteres i både backend og frontend |
| `@OPT-BEH-BEH-003` | Sluttdato fram i tid regnes som oppgitt | funnet | `PS/PraksisperiodeRegler.java:113` · `AP/utils/validatePraksisperiode.ts:54` — ingen sjekk mot dagens dato |
| `@OPT-BEH-BEH-003` | Praksis beregnes proporsjonalt med stillingsprosenten | funnet | `PS/Praksisberegner.java:118` — kalendermåneder / 12 × stillingsprosent. Alle fire eksempelradene stemmer |
| `@OPT-BEH-BEH-003` | Timebasert praksis beregnes mot oppgitt årsverk | funnet | `PS/Praksisberegner.java:108` — timer / timer per årsverk. Alle tre eksempelradene stemmer |
| `@OPT-BEH-BEH-003` | Antall timer per årsverk har en standardverdi | funnet | `PS/Praksisberegner.java:26` (1650) · `PS/PraksisperiodeRegler.java:237` · forhåndsutfylt i `AP/utils/praksisperiodeFormState.ts:87` |
| `@OPT-BEH-BEH-003` | Saksbehandleren kan justere antall timer per årsverk | funnet | `AP/components/PraksisperiodeForm/PraksisperiodeForm.tsx:260` — feltet kan endres, og verdien brukes i `PS/Praksisberegner.java:109` |
| `@OPT-BEH-BEH-003` | Antall timer per årsverk oppgis per praksisperiode | funnet | `PM/V404__sak_praksisperiode.sql:16` — `timer_per_arsverk` lagres på perioden |
| `@OPT-BEH-BEH-003` | Omfanget oppgis på én av måtene per praksisperiode | funnet | `AP/components/PraksisperiodeForm/PraksisperiodeForm.tsx:185` — valg av beregningsgrunnlag. Det andre feltet nulles (`PS/PraksisperiodeRegler.java:233`), og databasen har en sjekk (`PM/V404__sak_praksisperiode.sql:38`) |
| `@OPT-BEH-BEH-003` | Praksisperiode med omfang i timer kan ikke lagres uten antall timer | funnet | `PS/PraksisperiodeRegler.java:142` (`TIMER_MANGLER`) · `AP/utils/validatePraksisperiode.ts:74` — «Oppgi antall timer i perioden.» |
| `@OPT-BEH-BEH-003` | Stillingsprosent utenfor 0–100 % kan ikke lagres | funnet | `PS/PraksisperiodeRegler.java:132` · `AP/utils/validatePraksisperiode.ts:67` — «Oppgi en stillingsprosent fra 0 til 100.» (−10 og 101 avvises) |
| `@OPT-BEH-BEH-003` | Timer som gir mer praksis enn kalendertiden i perioden, kan ikke lagres | funnet | `PS/PraksisperiodeRegler.java:166` · `PS/Praksisberegner.java:92` — inklusiv grense (1651 og 826 avvises). Teksten via `AP/utils/mapPraksisperiodeErrors.ts:46` |
| `@OPT-BEH-BEH-003` | Endring som gir mer praksis enn kalendertiden i perioden, kan ikke lagres | funnet | `PS/PraksisperiodeService.java:102` — endringen valideres med samme regel (begge eksempelradene avvises) |
| `@OPT-BEH-BEH-003` | Antall timer på 0 eller mindre kan ikke lagres | funnet | `PS/PraksisperiodeRegler.java:145` · `AP/utils/validatePraksisperiode.ts:75` — «Antall timer må være mer enn 0.» |
| `@OPT-BEH-BEH-003` | Timebasert omfang overskrives ikke når datoene endres | funnet | `PM/V404__sak_praksisperiode.sql:13` — grunnlaget er et eget felt. For timer bruker `PS/Praksisberegner.java:108` bare timer og årsverk |
| `@OPT-BEH-BEH-003` | Oppdatere en praksisperiode | funnet | `PS/PraksisperiodeService.java:99` · `AP/endrePraksisperiode.operation.ts:20` — erstatter feltene og returnerer ny beregning |
| `@OPT-BEH-BEH-003` | Slette en praksisperiode | funnet | `PS/PraksisperiodeService.java:119` · `AP/slettPraksisperiode.operation.ts:23` |
| `@OPT-BEH-BEH-003` | Samlet praksis summeres på tvers av perioder | funnet | `PS/Praksisberegner.java:151` · `AP/components/PraksisSummer/PraksisSummer.tsx:34` — 2,00 + 1,00 + 0,50 = 3,50 |
| `@OPT-BEH-BEH-003` | Samlet praksis justeres når en praksisperiode legges til | funnet | `AP/opprettPraksisperiode.operation.ts:24` — svaret har ny sum |
| `@OPT-BEH-BEH-003` | Samlet praksis justeres når en praksisperiode slettes | funnet | `AP/slettPraksisperiode.operation.ts:23` — svaret har ny sum |
| `@OPT-BEH-BEH-003` | Sluttdatoen regnes med i perioden | funnet | `PS/Praksisberegner.java:74` — sluttdato + 1 dag |
| `@OPT-BEH-BEH-003` | Summen avkortes til to desimaler i visningen | funnet | `fs-admin/src/common/utils/decimalUtil/decimalUtil.ts:51` — avkorter (1,996 vises som 1,99). Brukes i `AP/components/PraksisSummer/PraksisSummer.tsx:47` |
| `@OPT-BEH-BEH-003` | Praksis beregnes med full presisjon | funnet | `PS/Praksisberegner.java:28` — DECIMAL128, ingen avrunding per periode |
| `@OPT-BEH-BEH-003` | En delvis måned regnes med 30 dager | funnet | `PS/Praksisberegner.java:82` — restdager / 30 (0,04 og 0,12 år) |
| `@OPT-BEH-BEH-003` | Overlappende praksisperioder varsles | funnet | `PS/Praksisberegner.java:180` · `AP/components/OverlappVarsler/OverlappVarsler.tsx:53` · `AP/components/PraksisperioderTable/PraksisperioderTable.tsx:126` — varsel med fra–til og ikon i raden. Bare overlapp over 100 % varsles. Kontrollen: usikker. Brukeren bekreftet at det er riktig at overlapp på 100 % eller mindre ikke varsles |
| `@OPT-BEH-BEH-003` | Både oppgitt og justert sum vises ved overlapp | funnet | `PS/Praksisberegner.java:200` · `AP/components/PraksisSummer/PraksisSummer.tsx:34` — 1,10 og 1,00 |
| `@OPT-BEH-BEH-003` | Justert sum kan ikke overstige kalendertiden i perioden | funnet | `PS/Praksisberegner.java:186` — det som er over 100 %, trekkes fra. Varselet om over 100 % står i `AP/components/OverlappVarsler/OverlappVarsler.tsx:54` |
| `@OPT-BEH-BEH-003` | Overlappssummene beregnes kun på inkluderte praksisperioder | funnet | `PS/Praksisberegner.java:149` — perioden på 40 % holdes ute (1,10 og 1,00) |
| `@OPT-BEH-BEH-003` | Søknadsbehandler kan registrere praksis | funnet | `PM/V12__tilgangskontroll_grunndata.sql:109` · `PS/PraksisperiodeRegler.java:91` · `AP/Praksiskalkulator.tsx:67` |
| `@OPT-BEH-BEH-003` | Bruker uten søknadsbehandler-rollen ser ikke praksisregistreringen | usikker | `AP/Praksiskalkulator.tsx:67` — styres av handlingen MODIFISERE_SØKNADSBEHANDLING, ikke av rollen. ADMINISTRATOR og SUPERBRUKER har den også (`PM/V12__tilgangskontroll_grunndata.sql:84`, `:96`). BRUKERSTØTTE ser «Inkluder» som deaktivert (`AP/components/InkluderCheckbox/InkluderCheckbox.tsx:56`) |
| `@OPT-BEH-BEH-003` | Bruker uten søknadsbehandler-rollen ser ikke registrert praksis | usikker | `fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(praksis)/praksiskalkulator/page.tsx:25` og `PM/V404__sak_praksisperiode.sql:71` — styres av SE_SØKNADSBEHANDLING. BRUKERSTØTTE har den (`PM/V12__tilgangskontroll_grunndata.sql:116`) og ser praksisen. Det strider mot avklaringen «hele praksisdelen er skjult» |
| `@OPT-BEH-BEH-003` | Saksbehandlere i andre opptak ser ikke praksisen | usikker | `PM/V404__sak_praksisperiode.sql:71` — tilgangen gjelder per organisasjon, ikke per opptak. Praksis er knyttet til saken (`:21`), men en søknadsbehandler i samme organisasjon kan åpne saken i det andre opptaket og se praksisen |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-003` | Ugyldig dato kan ikke lagres | funnet | funnet | Kontrollen foreslo usikker: `AP/components/PraksisperiodeForm/PraksisperiodeForm.tsx:205` sier at datovelgeren bare gir en hel dato eller null. Brukeren bekreftet at ugyldig dato håndteres i både backend og frontend |
| `@OPT-BEH-BEH-003` | Overlappende praksisperioder varsles | funnet | funnet | Kontrollen foreslo usikker: `PS/Praksisberegner.java:180` hopper over overlapp på 100 % eller mindre. Brukeren bekreftet at det er riktig oppførsel |
| `@OPT-BEH-BEH-003` | Saksbehandlere i andre opptak ser ikke praksisen | funnet | usikker | Tilgangen gjelder per organisasjon (`PM/V292__auth_skjema.sql:35`, `PM/V404__sak_praksisperiode.sql:71`). Ingen policy på opptaksnivå |

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-003` | Registrere og beregne praksis for søker | `@in-progress` | 42/45 | 0 ikke funnet, 3 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Frontend er ikke merget:** fs-admin er verifisert på branchen `stek-549-feat-registrere-praksis` (`81efd6960`). Kalkulatoren ligger bak Unleash-flagget `soknadsbehandling-praksiskalkulator`, som er på i review, dev og test (`AP/praksiskalkulatorFlag.ts:9`), og styres av flagget i produksjon. Kravet kan ikke bli `@implemented` før koden er merget, og bør verifiseres på nytt da.
- **Tilgang per rolle eller per handling:** de tre usikre scenarioene trenger en faglig avklaring. Er det greit at ADMINISTRATOR, SUPERBRUKER og BRUKERSTØTTE (bare lese) har tilgang, og at tilgangen gjelder per organisasjon og ikke per opptak? Er svaret ja, må kravet endres med `fs-krav`. Er svaret nei, må koden endres i fs-plattform (`PM/V404__sak_praksisperiode.sql:71`) og fs-admin (`AP/Praksiskalkulator.tsx:67`, `page.tsx:25`).
- **Overlapp på 100 % eller mindre:** brukeren bekreftet at dette ikke skal varsles. Scenarioet «Overlappende praksisperioder varsles» og `registrere_praksis.design.md:70` sier ikke at bare overlapp over 100 % varsles. Teksten `OverlappVarsler.overlapp` (`AM`) vises derfor aldri. Kravet og implementasjonsdetaljene kan presiseres med `fs-krav`.
- **Praksistyper:** `PM/V403__arbeidserfaringstype.sql:22` kaller lista «foreløpig». At den er komplett mot `status_gjelder_soker = J`, kan ikke sjekkes i koden.
- **`@wont` i gating-settet:** «Knytte praksisperioden til dokumentasjon på søknaden» er `@wont`, og er holdt utenfor denne verifiseringen. `gating` i `fs-kravforvaltning/src/specboard.ts:110` holder ikke `@wont` utenfor, så kortet i FS Kravforvaltning kan telle scenarioet med.
