# Verifisering: automatisk_kvalifisering.feature

- **Dato:** 2026-11-03 15:19
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvalifisering.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (origin/main, c0b792ff84, lest fra origin/main; utsjekket branch `mahj/autopuff/kravelementer` er bak main), `fs-admin` (origin/main, 0d1b75762, lest fra origin/main; utsjekket branch `mahj/autopuff/kravelementer` er bak main)
- **Åpne MR-er:** 2 MR-er i fs-plattform, 2 i fs-admin (0 med kode for kravene)
- **Omfang:** `@in-progress` (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll` (kontrolløren har også selv lett etter de 26 scenarioene som var `@implemented` fra før)
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).

Stiene er forkortet:

- `P-kval` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvalifisering`
- `P-km` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/kontrollmotor`
- `P-auto` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/AutomatiskSaksbehandlingService.java`
- `P-vgs` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/VgsDokumentVitnemaalService.java`
- `P-mig` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `A-krav` = `fs-admin/src/domains/soknadsbehandling/features/KravlisteStudierCard`

## Oppsummering

- Scenarioer: 29 funnet, 4 ikke funnet, 1 usikker, av 34
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: 3 stemmer, 0 avviker, 0 ikke funnet, 2 usikker, av 5
- Regler i koden uten scenario: 17
- Åpne spørsmål: 0 regler og 1 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-002` | 1 | `@implemented` | – | Regel: Kravelementer som er koblet til vitnemålet, vurderes automatisk |
| `@OPT-BEH-BEH-020` | `@OPT-BEH-BEH-004` Velge vitnemål som grunnlag | 1 | `@in-progress` | – | ikke levert. Regel: Kravelementene vurderes bare mot ett entydig vitnemål |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-001` | 1 | `@implemented` | – | Regel: Om søkeren er kvalifisert, avgjøres per grunnlag |

Avhengigheter: 3 på nivå 1, 1 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | Fagkrav som er oppfylt på vitnemålet | funnet | `P-km/KontrollMotor.java:90-95, 188-199` — fagkravet vurderes; skrevet i `P-kval/AutomatiskKravelementVurderingService.java:170-179` |
| `@OPT-BEH-BEH-020` | Fagkrav som ikke er oppfylt på vitnemålet | funnet | `P-km/KontrollMotor.java:197` — `oppfylt` er false når faget mangler |
| `@OPT-BEH-BEH-020` | Karakteren fra vitnemålet registreres på fagkravet | funnet | `P-km/KontrollMotor.java:198`, `P-km/FagSoek.java:353-378`, `P-kval/AutomatiskKravelementVurderingService.java:162, 172` |
| `@OPT-BEH-BEH-020` | Fagkrav uten karakter oppfylles uten karakter | funnet | `P-km/Karakter.java:25-26`, `P-kval/AutomatiskKravelementVurderingService.java:162` — resultatet blir null |
| `@OPT-BEH-BEH-020` | Karakterkrav får karakteren fra vitnemålet | funnet | `P-km/KontrollMotor.java:161, 294-300` |
| `@OPT-BEH-BEH-020` | Beste karakter gjelder for programfag matematikk | funnet | `P-km/KontrollMotor.java:84-89` (PFMAT, BESTE), `P-km/FagSoek.java:381-399` |
| `@OPT-BEH-BEH-020` | Kravelement som ikke er koblet til vitnemålet, vurderes ikke | funnet | `P-kval/AutomatiskKravelementVurderingService.java:118-128` — uten vitnemålskravkode hoppes raden over |
| `@OPT-BEH-BEH-020` | Kravelementer fra en annen sak i søknaden vurderes ikke i saken | funnet | `P-kval/KvalifiseringDescent.java:157-158` (`tildeltBehandler`), `KvalifikasjonsgrunnlagOppdateringService.java:154-163` — radene lages bare fra søknadsalternativene saken behandler (STEK-593, !6499); vurderingen leser bare sakens rader (`P-kval/AutomatiskKravelementVurderingService.java:210-214`) |
| `@OPT-BEH-BEH-020` | Kravelement vurderes mot vitnemål fra R94 | funnet | `P-km/Kravelementer.java:27-30, 392-399, 460-490` — R94-kodene; `P-vgs:42-56` filtrerer ikke på reform |
| `@OPT-BEH-BEH-020` | Ugyldig karakter må vurderes manuelt | funnet | `P-kval/AutomatiskKravelementVurderingService.java:161-179` — ugyldig karakter gir ingen karakter og ingen vurdering, merknaden «Ugyldig karakter for X — vurder manuelt»; `A-krav/utils/kravelementerUtils.ts:129` og `A-krav/components/AutomatiskVurdering.tsx:24-25` viser «Må vurderes manuelt» |
| `@OPT-BEH-BEH-020` | Ingen automatisk vurdering når <grunn> | funnet | `P-vgs:48-54` — flere dokumenter, ingen, eller ett som ikke er vitnemål gir tomt resultat; `P-kval/AutomatiskKravelementVurderingService.java:92-95` vurderer da ikke |
| `@OPT-BEH-BEH-020` | Kravelementene vurderes mot vitnemålet saksbehandleren har valgt | ikke funnet | `P-vgs:42-56` krever nøyaktig ett ikke-annullert vitnemål; valgt vitnemål brukes ikke. Ligner: `GskVedtakAutoService.java:96-98` tar et bestemt dokument, men bare for GSK — søkt etter «valgt_vitnem», «valgtVitnem», «gjeldende_vitnem», «velgVitnem», `byggVitnemaal(` i fs-plattform og i åpne MR-er |
| `@OPT-BEH-BEH-020` | Kompetansebevis ved siden av vitnemålet stopper ikke vurderingen | ikke funnet | `P-vgs:48-50` — mer enn ett dokument gir tomt resultat — søkt i fs-plattform og åpne MR-er |
| `@OPT-BEH-BEH-020` | Kvalifisert når alle kravelementene i en kravliste er oppfylt | funnet | `P-kval/KvalifiseringEvaluator.java:20-26, 156-160` |
| `@OPT-BEH-BEH-020` | Kvalifisert når én av kravlistene er oppfylt | funnet | `P-kval/KvalifiseringEvaluator.java:161-162` |
| `@OPT-BEH-BEH-020` | Karakteren må nå karakterkravet | funnet | `P-kval/KvalifiseringEvaluator.java:205-212` |
| `@OPT-BEH-BEH-020` | Søkeren kan være kvalifisert på ett grunnlag og ikke på et annet | funnet | `P-kval/KvalifiseringEvaluator.java:148-166`, `KvalifiseringOppdateringService.java:137-173` |
| `@OPT-BEH-BEH-020` | Kravelementet vurderes i den automatiske behandlingen | funnet | `P-auto:125-128, 153-157` |
| `@OPT-BEH-BEH-020` | Feil i vurderingen stopper ikke resten av behandlingen | funnet | `P-auto:146-160` — `KravelementVurderingException` fanges, savepoint rulles tilbake |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer vurderingen automatikken har satt | funnet | `P-kval/KvalifiserKravelementV4Service.java:189-193, 202-216`; `A-krav/KravlisteStudierCard.tsx:218-229` |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer karakteren som automatikken har satt | funnet | `P-kval/KvalifiserKravelementV4Service.java:186-187, 202-216`; `A-krav/KravlisteStudierCard.tsx:213-215` |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren vurderer, låses | funnet | `P-kval/KvalifiserKravelementV4Service.java:202-216` |
| `@OPT-BEH-BEH-020` | Saksbehandleren velger "la stå" på kravelementet | ikke funnet | fs-plattform støtter det: `P-kval/KvalifiserKravelementV4Service.java:157-163, 205, 231-241` (bare låsen endres), og automatikken hopper over låste rader (`P-kval/AutomatiskKravelementVurderingService.java:112, 178`). fs-admin har ingen «la stå» for kravelementer: `laStaa` finnes ikke i `A-krav`, bare i `PoengberegningCard` — søkt etter «laStaa», «la stå», «headerLaStaa» i fs-admin og åpne MR-er |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren bare ser på, vurderes automatisk igjen | funnet | `P-kval/AutomatiskKravelementVurderingService.java:112, 178` — å se på skriver ingenting, og rader med `la_staa = false` vurderes |
| `@OPT-BEH-BEH-020` | Låst kravelement vurderes ikke på nytt | funnet | `P-kval/AutomatiskKravelementVurderingService.java:112, 178` |
| `@OPT-BEH-BEH-020` | Andre kravelementer vurderes selv om saksbehandleren har vurdert ett | funnet | `P-kval/AutomatiskKravelementVurderingService.java:216-220` — låsen gjelder én rad |
| `@OPT-BEH-BEH-020` | Nullstilt kravelement kan vurderes automatisk igjen | usikker | `P-kval/KvalifiserKravelementV4Service.java:197-216` — låsen oppheves bare når både karakter og vurdering er tomme etterpå. Et fagkrav der automatikken har satt karakter (`P-km/KontrollMotor.java:196-198`), men regelverket bare har Ja/Nei, viser ikke karakterfeltet i fs-admin (`A-krav/components/KravlisteStudierTableRowBestatt.tsx:102-125`), og nullstillingen sender bare `nullstillVurdering` (`A-krav/KravlisteStudierCard.tsx:225-228`). Da blir kravelementet stående låst. Virker for andre kravelementer. Avgjort av brukeren: vet ikke |
| `@OPT-BEH-BEH-020` | Unntak per grunnlag endres ikke | funnet | `P-kval/AutomatiskKravelementVurderingService.java:170-179` — skriver aldri til unntakstabellen |
| `@OPT-BEH-BEH-020` | Kravelementer for et grunnlag som fjernes, beholder vurderingen | funnet | `P-kval/KvalifiseringKravelementV2OppdateringService.java:25-31, 55-76` — raden deaktiveres og aktiveres igjen med vurderingen |
| `@OPT-BEH-BEH-020` | Kravelementer for et nytt grunnlag vurderes | funnet | `P-kval/KvalifiseringKravelementV2OppdateringService.java:78-87, 118-135`, `P-auto:117, 128` |
| `@OPT-BEH-BEH-020` | Se at kravelementet er vurdert automatisk | funnet | `A-krav/components/AutomatiskVurdering.tsx:12-36` — «Vurdert automatisk fra vitnemål {vitnemal}»; `A-krav/utils/kravelementerUtils.ts:76-81`; `P-kval/AutomatiskKravelementVurderingService.java:167` (vitnemålsnummeret i merknaden) |
| `@OPT-BEH-BEH-020` | Manuell endring fjerner markeringen som automatisk vurdert | funnet | `P-kval/KvalifiserKravelementV4Service.java:178-181` (`status_automatisk_utregnet = false`); `A-krav/hooks/useKvalifiserKravelementMutation.ts:120`, `A-krav/components/AutomatiskVurdering.tsx:19` |
| `@OPT-BEH-BEH-020` | Endringsloggen viser at automatikken vurderte kravelementet | ikke funnet | `P-mig/V480__stopp_endringslogg.sql:13-28` fjernet audit-triggerne i `saksbehandling`, så endringsloggen fylles ikke lenger (også `V483__endringslogg_uten_bruker.sql:1-5`). Ingen erstatning funnet — søkt etter «sporingslogg», «hendelseslogg», `endringsloggV2`, `utfortAv` i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-020` | Finne søkere som ikke er kvalifisert | funnet | `fs-admin/…/SakFilter.tsx:108-114` (filteret «Ikke kvalifiserte»), `SakFilterConditions.java:51, 423`. Filteret skiller ikke spesielle opptakskrav fra andre krav |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

| Feature-ID | Sjekk | Rolle og handling | Kravet sier | Koden gjør | Resultat | Bevis |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | tilgang | saksbehandler endrer vurderingen av et kravelement | «Saksbehandlerens vurdering …» | RLS på UPDATE krever `MODIFISERE_SØKNADSBEHANDLING` i sakens organisasjon; uten treff `FinnesIkkeException` | stemmer | `P-mig/V493__tilbyder_ser_saksbehandlingen.sql:101-102`, `P-kval/KvalifiserKravelementV4Service.java:219-228` |
| `@OPT-BEH-BEH-020` | organisasjon | saksbehandler endrer et kravelement i en annen organisasjons sak | ikke beskrevet | avvises av samme RLS; kravelementet må høre til sakens egne søknadsalternativer | stemmer | `P-mig/V493__tilbyder_ser_saksbehandlingen.sql:101-102`, `P-kval/KvalifiserKravelementV4Service.java:129` |
| `@OPT-BEH-BEH-020` | organisasjon | saksbehandler leser vurderingen av kravelementene | ikke beskrevet | lesepolicyen bruker `har_tilgang` uten organisasjon; i fs-admin leses radene via `Sak`, som trolig avgrenser i praksis | usikker | `P-mig/V291__saksbehandling_skjema.sql:1624-1627`, `P-mig/V300__rls_over_paa_auth_claims.sql:~181` |
| `@OPT-BEH-BEH-020` | organisasjon | automatikken vurderer kravelementer i en annen organisasjons sak | «Kravelementer fra en annen sak i søknaden vurderes ikke i saken» | radene lages bare for søknadsalternativene saken behandler, og vurderingen leser og skriver bare sakens rader | stemmer | `P-kval/KvalifiseringDescent.java:157-158`, `P-kval/AutomatiskKravelementVurderingService.java:111, 176, 210-214` |
| `@OPT-BEH-BEH-020` | konsistens | kravelementrader fra andre saker som ble laget før STEK-593 | ikke beskrevet | ingen migrering rydder dem; de deaktiveres først når saken propageres på nytt | usikker | `P-kval/KvalifiseringKravelementV2OppdateringService.java:55-63` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | Merknaden fra automatikken er «<kode> regnet ut til JA/NEI» | annet | `P-kval/AutomatiskKravelementVurderingService.java:164-166` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Kravelementer med en vitnemålskravkode kontrollmotoren ikke kjenner, og inaktive rader, hoppes over | annet | `P-kval/AutomatiskKravelementVurderingService.java:113, 118-128` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | En manuell endring av ett felt låser raden bare når den fortsatt har en verdi etterpå | tilstandsovergang | `P-kval/KvalifiserKravelementV4Service.java:197-216` | uklart om ønsket |
| `@OPT-BEH-BEH-020` | Verdi og nullstilling av samme felt i samme operasjon avvises | validering | `P-kval/KvalifiserKravelementV4Service.java:134-145` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Manuell vurdering flytter saken fra ubehandlet til under behandling | tilstandsovergang | `P-kval/KvalifiserKravelementV4Service.java:76-80` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-020` | Tom endring, eller endring uten noen operasjon, avvises | validering | `P-kval/KvalifiserKravelementV4Service.java:93-97, 147-155` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Alle endringene i én lagring må gjelde samme sak | validering | `P-kval/KvalifiserKravelementV4Service.java:99-112` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Kravelementet må høre til sakens regelverk og egne søknadsalternativer | tilgangssjekk | `P-kval/KvalifiserKravelementV4Service.java:129` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Manuell vurdering av et inaktivt eller ikke-eksisterende kravelement gir «finnes ikke» | validering | `P-kval/KvalifiserKravelementV4Service.java:219-228` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Manuell vurdering kan stoppes av manglende aldersberegningsdato | validering | `P-kval/KvalifiserKravelementV4Service.java:59` | uklart om ønsket |
| `@OPT-BEH-BEH-020` | Gyldig karakter er 0–6; tom, blank og «-» betyr ingen karakter; alt annet er ugyldig | grense | `P-km/FagSoek.java:411-425` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Karakteren er snittet av standpunkt og eksamen over fagene som dekker kravet (beste bare for programfag matematikk) | annet | `P-km/Karakterstrategi.java:9-18`, `P-km/FagSoek.java:353-405` | uklart om ønsket |
| `@OPT-BEH-BEH-020` | Fagkrav som ikke er oppfylt, får ingen karakter, og tallkrav med 0 er ikke oppfylt | annet | `P-km/KontrollMotor.java:196-198, 294-300` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Karakterfeltet i fs-admin godtar tall fra 0 til under 1000, og tomt felt nullstiller | grense | `fs-admin/…/validateKarakter.ts:8-20`, `A-krav/KravlisteStudierCard.tsx:194-200` | uklart om ønsket |
| `@OPT-BEH-BEH-020` | Merknaden kan være høyst 4000 tegn | grense | `fs-plattform/…/kvalifisering.graphqls:72` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Endrer saksbehandleren bare merknaden, forsvinner markeringen «vurdert automatisk», men raden låses ikke, så neste automatiske kjøring setter den på igjen | tilstandsovergang | `P-kval/KvalifiserKravelementV4Service.java:178-181, 202-217` | uklart om ønsket |
| `@OPT-BEH-BEH-020` | Bare forventede feil i vurderingen isoleres; andre feil ruller tilbake hele den automatiske behandlingen | annet | `P-auto:146-160` | uklart om ønsket |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | 0 av 6 | 1 av 34 | 0 |

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | scenario | Saksbehandleren velger "la stå" på kravelementet | usikker | ikke funnet | `A-krav` har ingen «la stå»; bare `PoengberegningCard` har det |
| `@OPT-BEH-BEH-020` | scenario | Nullstilt kravelement kan vurderes automatisk igjen | funnet | usikker | `P-kval/KvalifiserKravelementV4Service.java:197-216` — fagkrav med karakter blir stående låst når fs-admin bare nullstiller vurderingen |
| `@OPT-BEH-BEH-020` | scenario | Endringsloggen viser at automatikken vurderte kravelementet | usikker | ikke funnet | `P-mig/V480__stopp_endringslogg.sql:13-28` — endringsloggen i `saksbehandling` fylles ikke lenger |
| `@OPT-BEH-BEH-020` | regel | En manuell endring av ett felt låser … | `:38-46` | `:197-216` | linjene pekte på dokumentasjonen, ikke koden |
| `@OPT-BEH-BEH-020` | tilgang | alle 5 radene | – | lagt til | kontrolløren la til tilgangsradene |
| `@OPT-BEH-BEH-020` | regel | 13 regler | – | lagt til | kontrolløren fant regler som manglet |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-020` — Automatisk vurdering av spesielle opptakskrav (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvalifisering.feature`, `@in-progress` → `@in-progress`, 29/34 funnet) — `@implemented` på: Regel: Kravelementer som er koblet til vitnemålet, vurderes automatisk (linje 97, og `@implemented` fjernes fra de ni scenarioene under), Scenario: Se at kravelementet er vurdert automatisk (linje 346), Scenario: Manuell endring fjerner markeringen som automatisk vurdert (linje 352)

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-020` — Automatisk vurdering av spesielle opptakskrav (`@in-progress`, 29/34 funnet) — 4 ikke funnet (valgt vitnemål, kompetansebevis ved siden av, «la stå» i fs-admin, endringsloggen), 1 usikker (nullstilling av fagkrav med karakter)

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav (delvis: `@in-progress`, 3 deler `@implemented`: Scenario: Ugyldig karakter må vurderes manuelt, Scenario: Se at kravelementet er vurdert automatisk, Scenario: Manuell endring fjerner markeringen som automatisk vurdert) | `automatisk_kvalifisering.feature` | `@in-progress` | 29/34 |

Brukeren valgte å sette `@implemented` bare på de tre scenarioene som ble levert nå, ikke på regelen «Kravelementer som er koblet til vitnemålet, vurderes automatisk».

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | `@in-progress` | 29/34 | 4 ikke funnet, 1 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Endringsloggen er stoppet:** `P-mig/V480__stopp_endringslogg.sql:13-28` fjernet audit-triggerne i `saksbehandling` og `generell_studiekompetanse`. Scenarioer som bygger på endringsloggen, kan ikke leveres før det finnes en erstatning (sporingsloggen). Gjelder også andre krav med endringslogg-scenarioer.
- **Nullstilling av fagkrav med karakter:** fs-admin sender bare `nullstillVurdering` når karakterfeltet ikke vises (`A-krav/KravlisteStudierCard.tsx:225-228`), men karakteren fra automatikken blir stående, så kravelementet forblir låst (`P-kval/KvalifiserKravelementV4Service.java:197-216`).
- **«La stå» mangler i fs-admin:** fs-plattform støtter det for kravelementer, men fs-admin har ingen kontroll for det i «Spesielle opptakskrav».
- **Åpent spørsmål:** `@OPT-BEH-BEH-020` «Finne søkere som ikke er kvalifisert» — FS-klienten har rapporten FS102.004 og brevet FS120.002. Hva trengs i ny stack: et filter i saksoversikten, en rapport eller begge?
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-020` (Regel: Kravelementene vurderes bare mot ett entydig vitnemål) bygger på `@OPT-BEH-BEH-004` (`@in-progress`).
- **Ikke sjekket:** min-kompetanse finnes ikke lokalt (ingen scenarioer gjelder søkeren).
