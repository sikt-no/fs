# Verifisering: Automatisk saksbehandling – fire flyter

- **Dato:** 2026-11-13 08:15
- **Krav:** `krav/_Flyter/10 Opptaksløpet/`: `@FLY-OPT-AUT-001`, `@FLY-OPT-VIT-001`, `@FLY-OPT-VAL-001`, `@FLY-OPT-SAM-001` (4 feature-filer)
- **Kode:** `fs-plattform` (origin/main, 65d2f2211a, oppdatert; lest fra et øyeblikksbilde av origin/main, den utsjekkede branchen er bak main), `fs-admin` (origin/main, e76a4e3fc, oppdatert; lest fra et øyeblikksbilde av 6c58a7f80, og etterpå MR !3415 og !3421, som ble merget kl. 08:54 og 09:11 som 36446fbf5 og e76a4e3fc, de eneste nye commitene). fs-plattform har fått commits etter 65d2f2211a bare i batch, sis og tilgangsstyring, ikke i opptak
- **Repoer:** P = fs-plattform, A = fs-admin · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** 1 MR i fs-plattform, 0 i fs-admin, fra solov og mahj (1 med kode for kravene). fs-admin !3415 og !3421 er merget etter kjøringen, og regnet som levert
- **Omfang:** flyter: `@FLY-OPT-AUT-001` og `@FLY-OPT-VIT-001`, og `@FLY-OPT-VAL-001` og `@FLY-OPT-SAM-001` uansett status (valgt)
- **Avhengigheter:** 1 nivå, verifisert i koden (bare delene flyten bygger på, ankrene, i OPT-BEH-BEH-kravene; regelverkskravene og `@FLY-OPT-SAK-001` med status fra taggene)
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 4 finnere (`fs-verify-krav`), 4 kontrollører (`fs-verify-kontroll`)
- **Skjermbilder:** nei

Gating-sett: alle scenarioene, minus `@demo`, for `@FLY-OPT-VAL-001` og `@FLY-OPT-SAM-001` (verifisert uansett status), og de som ikke er tagget `@draft`, `@deprecated` eller `@demo` for resten. Fasen med `@wont` i `@FLY-OPT-AUT-001` er holdt utenfor.

Stiene er forkortet:

- `P/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/`
- `P-app/` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/`
- `P-skjema/` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/`
- `P-mig/` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `A/` = `fs-admin/src/domains/soknadsbehandling/features/`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 26 funnet, 11 ikke funnet, 0 usikker, av 37
- Mangler: fs-plattform 6 scenarioer, fs-admin 4, min-kompetanse ikke med i kjøringen
- Forslag: 0 kan leveres, 0 delvis levert, 2 kan slettes, 5 kan leveres når det er avklart, 4 blir stående
- Tilgang og datakonsistens: ingen rader (bare flyter og avhengigheter i omfanget)
- Regler i koden uten scenario: 0
- Endringer gjort: 3 krav fikk ny status (039 `@in-progress`, 029 og 032 `@implemented`), 10 deler fikk `@implemented` og 2 `@deprecated` (031, 029), og 6 krav ble rettet (019, 020, 025, 026, 028 og AUT-001)
- Åpne spørsmål: 1 regel og 3 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Kan leveres når det er avklart**

- `@FLY-OPT-AUT-001` — Automatisk saksbehandling (`krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature`): kan få `@implemented` når de seks fasene som ikke er levert, er levert. Alle overleveringene i de leverte fasene er funnet (12/12) `[P ✓ · A –]`. Det som holder fasene igjen, står i kravene under.
- `@OPT-BEH-BEH-015` — Regel: Automatikken setter bare positive konklusjoner, og bare der ingen finnes (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature:435`): kan få `@implemented` når «Automatikken kan sette en ny konklusjon etter annulleringen» (`:462`) er bygget `[P ✗]`: `P/autosak/gsk/GskVedtakAutoService.java:69-71` og `P/soknad/gskvedtak/GskVedtakConditions.java:14-15` regner `KVALIFISERT_MEN_ANNULLERT` som gjeldende konklusjon, så automatikken setter ingen ny · mangler i fs-plattform (1). Holder igjen AUT-fasen «Søknaden får GSK-konklusjonen når vitnemålet importeres fra KREG».
- `@OPT-BEH-BEH-036` — Automatiske mangler, de tre reglene AUT bygger på (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_mangler.feature:22`, `:136`, `:203`): kan få `@implemented` på reglene når disse er bygget eller avklart (17/28 funnet) `[P ~ · A ✗]`: «Mangelteksten viser kravelementene som ikke er oppfylt, ordnet etter kravlistene» (`:71`, usikker: navnet på kravlisten skrives ikke, `P/regelverk/kvalifisering/ManglendeKravTekstService.java:22-31`; fs-admin viser teksten som den er), «Saken får ikke mangel når ingen mangelkode er merket» (`:234`) og «Opptaksforvalteren får varselet bare første gang» (`:240`) (varselet finnes ikke), og saksloggen i «Alle sakene i søknaden får mangel …» (`:227`), «Mangelen slettes når søkeren endrer søknaden» (`:257`) og «Mangelen sjekkes ut når saken er behandlet helautomatisk» (`:279`) (V480). «Saksbehandleren ser de automatiske mangeltekstene …» (`:92`) og «Søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet» (`:98`) fikk `@implemented` i denne kjøringen. Min kompetanse er sjekket i GitLab: to scenarioer er fortsatt usikre, «Søkeren ser ikke mangelteksten når søknadsalternativet er fjernet» (`:120`, teksten kan slettes) og «Søkeren ser den automatiske mangelen i Min kompetanse» (`:246`, vises ikke før saken er Under behandling) · mangler i fs-plattform (6), fs-admin (2). Holder igjen AUT-fasene «Saken får mangeltekster …» og «Mangelen for GSK som fullføres i vår …».
- `@OPT-BEH-BEH-033` — Regel: Jobbplanleggeren starter jobbene i opptaket (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/kjøre_jobbene_i_opptak.feature:28`): kan få `@implemented` når raden «importen av resultater fra høyere utdanning» i «Jobbplanleggeren starter <jobb>» (`:30`) er bygget `[P ~]`: ingen planlagt jobb, og `P/vitnemalsportalen/VitnemalsportalenService.java:38,57` har ingen kallere · mangler i fs-plattform (1). Holder igjen VIT-fasen «Jobbplanleggeren starter importen av VGS-vitnemål fra KREG», selv om KREG-jobben finnes (se `## Andre funn`).
- `@OPT-BEH-BEH-039` — Regel: Grunnlaget, poengene og kravelementene avgjøres på vitnemålet saksbehandleren har valgt (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/behandle_automatisk_på_valgt_vitnemål.feature:66`): kan få `@implemented` når «Sammensatt vitnemål gir ikke grunnlaget som krever førstegangsvitnemål» (`:93`) er bygget eller tatt ut av regelen `[P ✗ · A ✗]`. De tre andre scenarioene i regelen fikk `@implemented` i denne kjøringen (se `## Endringer`) · mangler i fs-plattform (1), fs-admin (1). Holder igjen VAL-fasen «Resten av saken …» sammen med `@FLY-OPT-AUT-001`, og to faser i SAM.

**Kan slettes**

- `@OPT-BEH-BEH-031` — Scenario: Uendret poengsum gir ikke nytt innslag i endringsloggen (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/beregne_poengsum_per_kvote.feature:82`, blokken): fikk `@deprecated` i denne kjøringen, fordi teamet ikke ønsker atferden. Endringsloggen fylles ikke lenger (`P-mig/V480__stopp_endringslogg.sql`), og ingen kode skriver til den. `P/regelverk/poeng/PoengsumService.java:394-421` skriver fortsatt bare poengsummer som er endret, men det er ikke denne atferden. Ingen referanser peker på scenarioet (`@ref-OPT-BEH-BEH-016` står på scenarioet selv). Slettes i gjennomgangen av rapporten

- `@OPT-BEH-BEH-029` — Regel: Saksloggen viser endringene i behandlingsstatusen (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/behandlingsstatus.feature:138`, blokken): fikk `@deprecated` i denne kjøringen, fordi teamet ikke ønsker saksloggen. Ingen kode skriver saksloggen (`P-mig/V480__stopp_endringslogg.sql`). Ingen `@depends-on-` peker på regelen, og ankeret `@ref-FLY-OPT-AUT-001` er flyttet bort fra den. Slettes i gjennomgangen av rapporten

**Blir stående**

- `@FLY-OPT-AUT-001` — Automatisk saksbehandling (`@planned`, 17/20 funnet): 15 av 18 faser levert. 3 scenarioer er ikke funnet fordi fasen ikke er levert: «Søknaden får GSK-konklusjonen …», «Saken får mangeltekster …» og «Mangelen for GSK som fullføres i vår …».
- `@FLY-OPT-VIT-001` — Importere VGS-vitnemål fra KREG (`@planned`, 8/9 funnet): 6 av 7 faser levert. «Importen starter når jobbplanleggeren kjører jobben» er ikke funnet: fasen er ikke levert, fordi `@OPT-BEH-BEH-033` er `@planned`.
- `@FLY-OPT-VAL-001` — Automatisk saksbehandling på vitnemålet saksbehandleren velger (`@draft`, 1/2 funnet): 1 av 2 faser levert. «Saken er ferdig behandlet på det valgte vitnemålet» venter på `@FLY-OPT-AUT-001` og regelen om grunnlag, poeng og kravelementer i `@OPT-BEH-BEH-039`. Flyten er `@draft`, og må valideres med `fs-krav` før den kan få ny status.
- `@FLY-OPT-SAM-001` — Automatisk saksbehandling på sammensatt vitnemål (`@draft`, 0/6 funnet): 0 av 4 faser levert, og én fase mangler krav. Sammensatt vitnemål finnes ikke i koden · mangler i fs-plattform (5), fs-admin (4).

## Endringer

Det som er endret i kravfilene og i resultatet: i kjøringen (det sikre, når brukeren sa ja) og i gjennomgangen av rapporten.

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-025` | Regel: Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort | `@implemented` på regelen (fra scenarioene) | Brukeren spurte om «Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet» er løst. Hele kjeden er funnet: fs-plattform publiserer (`P/autosak/FerdigbehandlingService.java:78` → `P/saksbehandling/ManglerPublisering.java:28-54`, én melding), viewet `soknadsmangel` viser teksten (`P-mig/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:139-189`), og min-kompetanse (fs/min-kompetanse, main 066f8d6a, lest i GitLab): `src/components/soknadsmangel/fragment-soknad-mangler.ts` henter `Soknad.mangler` og `soknadsalternativer.mangler` med `standardTekst`, og `src/components/soknadsmangel/mangel-list.tsx` viser teksten. Det kom med fs-plattform !6728 (12.11), ikke med en merge i dag. `usikker` → `funnet`. Ikke kontrollert av `fs-verify-kontroll` |
| `@OPT-BEH-BEH-026` | Scenario: Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet | ingen | Samme: vent til Min kompetanse er sjekket |
| `@OPT-BEH-BEH-039` | Behandle automatisk på vitnemålet saksbehandleren velger | `@planned` → `@in-progress` (delvis levert) | Brukeren: tagg den leverte regelen, slik at VAL-fasen blir levert. Sammensatt vitnemål røres ikke |
| `@OPT-BEH-BEH-039` | Regel: Har søkeren flere vitnemål, behandles saken automatisk på vitnemålet saksbehandleren velger | `@implemented` på delen | Begge scenarioene funnet i fs-plattform og fs-admin (!3415) og bekreftet av kontrollen. `@draft`-scenarioet om sammensatt vitnemål under regelen står urørt |
| `@OPT-BEH-BEH-039` | Scenario: Grunnlag fra vitnemålet saksbehandleren har valgt; Scenario: Vitnemålspoeng fra vitnemålet saksbehandleren har valgt; Scenario: Kravelementene vurderes mot vitnemålet saksbehandleren har valgt | `@implemented` på delene | Brukeren: det samme for den andre VAL-fasen. Funnet i fs-plattform og bekreftet av kontrollen. «Sammensatt vitnemål …» står urørt, så regelen og VAL-fasen er fortsatt ikke levert, og fasen venter også på `@FLY-OPT-AUT-001` |
| `@FLY-OPT-VAL-001` | Scenario: Saken behandles automatisk på vitnemålet saksbehandleren velger | `ikke funnet` → `funnet` | Fasen er levert etter taggingen over, og overleveringen er funnet i begge repoene |
| `@OPT-BEH-BEH-026` | Scenario: Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet; Scenario: Den automatiske mangelteksten slettes når søkeren blir kvalifisert etter beregningen | `Gitt` presisert til «den automatiske behandlingen har satt saken til ferdig behandlet», og `@implemented` på regelen «Bare saker som er ferdig behandlet, beregnes på nytt» | Brukeren: presiser `Gitt`. Koden vurderer kravelementene på nytt bare i saker med `status_automatisk_behandlet`, som betyr at automatikken satte saken til ferdig behandlet (`P-mig/V522__sak_status_automatisk_behandlet_betyr_ferdig.sql:8`). `usikker` → `funnet`. AUT-fasen «Søknadsalternativene beregnes på nytt …» er dermed levert |
| `@OPT-BEH-BEH-032` | Starte automatisk behandling | `@in-progress` → `@implemented`, og `@implemented` fjernet fra delene | Brukeren: krav som er `@in-progress`, men der alt er levert, settes til `@implemented`. 032 er det eneste i `krav/` der alle scenarioene i gating-settet er `@implemented` (7 av 7). Regelen som er `@draft`, står urørt |
| `@OPT-BEH-BEH-029` | Regel: Saksloggen viser endringene i behandlingsstatusen | `@deprecated`; ankeret `@ref-FLY-OPT-AUT-001` flyttet bort fra regelen, og regeltittelen tatt ut av «…» i AUT-fasen | Brukeren: «Den ønsker vi ikke». Andre krav med `@depends-on-OPT-BEH-BEH-029` (039, 025, 032, 034) bygger på behandlingsstatusen, ikke saksloggen |
| `@OPT-BEH-BEH-029` | Behandlingsstatus | `@in-progress` → `@implemented`, og `@implemented` fjernet fra de fire reglene | Alle de andre reglene var `@implemented`, så resten av kravet er levert |
| `@OPT-BEH-BEH-036` | Scenario: Saksbehandleren ser de automatiske mangeltekstene sammen med de registrerte manglene; Scenario: Søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet | `@implemented` på delene | Brukeren ba om å sjekke Min kompetanse. Funnet i fs-plattform, fs-admin (!3421) og min-kompetanse |
| `@FLY-OPT-AUT-001` | Regel: Saken blir ferdig behandlet og er klar til å være med i plasstildelingen | `ikke funnet` → `funnet` på begge scenarioene | Fasen er levert når 025 er levert og saksloggen er avviklet. Overleveringene er funnet |
| `@OPT-BEH-BEH-031` | Scenario: Uendret poengsum gir ikke nytt innslag i endringsloggen | `@deprecated` | Brukeren: «Denne ønsker vi faktisk ikke». Delen er levert (egenskapen er `@implemented`), så den får `@deprecated` i stedet for å slettes, og står under *Kan slettes* |
| `@OPT-BEH-BEH-020` | Scenariomal: Ingen automatisk vurdering når <grunn> | rettet på stedet: «flere ulike elektroniske vitnemål» i `Eksempler`, og kommentaren under regelen | Brukeren: raden var usikker fordi to identiske vitnemål regnes som ett (!6741). Rettet som 019. `usikker` → `funnet` |
| `@OPT-BEH-BEH-028` | Regel: Poeng for høyere utdanning regnes ut fra søkerens studiepoeng | `@implemented` på regelen (fra scenarioene), og avklaring på «Bare beståtte emner teller» | Brukeren: tjenesten for resultater fra høyere utdanning gir bare gyldige resultater, så backenden trenger ikke å filtrere. Scenarioet er levert. `ikke funnet` → `funnet`. AUT-fasen «Søknaden får tilleggspoeng …» er dermed levert, og overleveringen er funnet |
| `@OPT-BEH-BEH-019` | Scenario: Søker med flere ulike vitnemål behandles ikke automatisk | rettet på stedet (tittel, `Gitt` og kommentaren under regelen) | Brukeren: «to ulike vitnemål». Koden (!6741) regner identiske vitnemål som ett, og det er levert. Rettet på stedet fordi koden allerede gjør det teksten nå sier. `usikker` → `funnet` |
| `@OPT-BEH-BEH-025` | Scenario: Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål; Scenario: To identiske vitnemål regnes som ett vitnemål (nytt) | «to ulike vitnemål» i `Gitt`, og nytt scenario under den leverte regelen (ingen statustag) | Brukeren: 025 eier regelen om identiske vitnemål, og den er levert |
| `@FLY-OPT-AUT-001` | Regel: To identiske vitnemål reknes som ett vitnemål | `@wont` og `@openquestion` fjernet, `@depends-on-OPT-BEH-BEH-025` lagt til; kommentaren om `@wont`-fasene rettet | Brukeren: fasen er levert. Fasen er levert, og overleveringen er funnet i koden |
| `@OPT-BEH-BEH-036` | Scenario: Saksbehandleren ser de automatiske mangeltekstene sammen med de registrerte manglene | `ikke funnet` → `funnet` | fs-admin !3421 ble merget 09:11 (e76a4e3fc, det samme som ble kontrollert på branchen). Kravfila er ikke endret |
| `@OPT-BEH-BEH-036` | Scenario: Saksbehandleren kan ikke endre en automatisk mangeltekst | `usikker` → `funnet` | Samme: teksten vises nå, skrivebeskyttet. Kravfila er ikke endret |
| `@OPT-BEH-BEH-029` | Scenario: Saksloggen viser endring av behandlingsstatus når <årsak> | ingen | Brukeren spurte om !3421 løser saksloggen. Den gjør ikke det: ingen kode skriver saksloggen etter V480 |

Ellers var det ingenting som var sikkert levert og manglet tagg: alt som er funnet og bekreftet av kontrollen, er allerede `@implemented` i kravfilene.

## Oversikt per krav

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Mangler i M | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling | 17/20 | 0 | – | – | 3 faser venter på kravene de bygger på (3 scenarioer, «fasen er ikke levert») |
| `@FLY-OPT-VIT-001` | Importere VGS-vitnemål fra KREG | 8/9 | 0 | – | – | Fasen om jobbplanleggeren venter på `@OPT-BEH-BEH-033` |
| `@FLY-OPT-VAL-001` | Automatisk saksbehandling på vitnemålet saksbehandleren velger | 1/2 | 0 | 0 | – | Fasen «Resten av saken …» venter på `@FLY-OPT-AUT-001` og regelen om grunnlag, poeng og kravelementer i `@OPT-BEH-BEH-039` |
| `@FLY-OPT-SAM-001` | Automatisk saksbehandling på sammensatt vitnemål | 0/6 | 6 | 4 | – | Sammensatt vitnemål finnes ikke, og én fase mangler krav |

Mangler: fs-plattform 6 scenarioer i 1 krav, fs-admin 4 i 1 krav. Min-kompetanse er ikke med i kjøringen. 0 av 4 krav er funnet i alle repoene. Scenarioene med «fasen er ikke levert» er ikke søkt etter, og telles ikke som mangler i et repo.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P`, `A` og `M` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Fremdrift for flyter

Hvilke faser i flyten som er levert, ut fra statusen på delene av kravene fasen bygger på.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Søkerens resultater importeres fra KREG når saken er opprettet | `@OPT-BEH-BEH-030` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen starter når søkerens resultater er importert | `@OPT-BEH-BEH-032` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen når vitnemålet importeres fra KREG | `@OPT-BEH-BEH-015` (`@in-progress`, Regel: Automatikken setter bare positive konklusjoner … ikke levert: «Automatikken kan sette en ny konklusjon etter annulleringen»), `@OPT-BEH-BEH-027` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen setter GSK-konklusjonen der den mangler | `@OPT-BEH-BEH-015` (`@in-progress`, Regel: GSK-konklusjonen settes også når den automatiske behandlingen kjører levert) | ja |
| `@FLY-OPT-AUT-001` | Vitnemålet som gir GSK, avgjør om saken behandles helautomatisk | `@OPT-BEH-BEH-015` (`@in-progress`, Regel: Vitnemålet gir GSK når det har GSK OK fra KREG levert), `@OPT-BEH-BEH-025` (`@in-progress`, Regel: Bare saker der søkeren har ett vitnemål … levert) | ja |
| `@FLY-OPT-AUT-001` | To identiske vitnemål reknes som ett vitnemål | `@OPT-BEH-BEH-025` (`@in-progress`, Regel: Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk levert; scenarioet «To identiske vitnemål regnes som ett vitnemål» lagt til i denne kjøringen) | ja |
| `@FLY-OPT-AUT-001` | Saken får grunnlag fra vitnemålet | `@OPT-BEH-BEH-019` (`@in-progress`, tre regler levert) | ja |
| `@FLY-OPT-AUT-001` | Poengene beregnes fra grunnlaget og rangeringsregelverket | `@OPT-BEH-BEH-018` (`@in-progress`, tre regler levert), `@OPT-REG-RAN-001` (`@implemented`), `@OPT-REG-RAN-002` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoeng når grunnlaget er satt | `@OPT-BEH-BEH-028` (`@in-progress`, fire regler levert; Regel: Poeng for høyere utdanning … levert etter avklaringen 13.11.2026) | ja |
| `@FLY-OPT-AUT-001` | Søknaden dobbeltrangeres automatisk etter 23/5-regelen (`@wont`) | – | mangler krav |
| `@FLY-OPT-AUT-001` | Kravelementene vurderes mot vitnemålet når poengene er beregnet | `@OPT-BEH-BEH-020` (`@in-progress`, tre regler levert) | ja |
| `@FLY-OPT-AUT-001` | Kvotespørsmålene med algoritme besvares automatisk | `@OPT-BEH-BEH-012` (`@implemented`), `@OPT-REG-KVO-002` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Kvalifiseringen oppdateres når kravelementene er vurdert | `@OPT-BEH-BEH-020` (`@in-progress`, Regel: Om søkeren er kvalifisert, avgjøres per grunnlag levert) | ja |
| `@FLY-OPT-AUT-001` | Søkeren fordeles på kvoter når kvalifiseringen og kvotesvarene er satt | `@OPT-BEH-BEH-012` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Søkeren får poengsum per kvote når søkeren er fordelt på kvoter | `@OPT-BEH-BEH-031` (`@implemented`), `@OPT-REG-KVO-001` (`@implemented`), `@OPT-REG-RAN-002` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Saken får mangeltekster når kravelementene er vurdert | `@OPT-BEH-BEH-036` (`@in-progress`, Regel: Saken får automatiske mangeltekster … ikke levert: «Mangelteksten viser kravelementene som ikke er oppfylt, ordnet etter kravlistene», «Saksbehandleren ser de automatiske mangeltekstene sammen med de registrerte manglene», «Søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet») | nei |
| `@FLY-OPT-AUT-001` | Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet | `@OPT-BEH-BEH-036` (`@in-progress`, Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk ikke levert: 6 scenarioer) | nei |
| `@FLY-OPT-AUT-001` | Saken blir ferdig behandlet og er klar til å være med i plasstildelingen | `@OPT-BEH-BEH-025` (`@in-progress`, Regel: Den automatiske behandlingen setter saken til ferdig behandlet … levert), `@OPT-BEH-BEH-029` (`@implemented`; regelen om saksloggen er `@deprecated` og ikke lenger en del av fasen) | ja |
| `@FLY-OPT-AUT-001` | Søknadsalternativene beregnes på nytt når regelverket er rettet | `@OPT-BEH-BEH-026` (`@in-progress`, de tre reglene levert; `Gitt` presisert 13.11.2026) | ja |
| `@FLY-OPT-VIT-001` | Jobbplanleggeren starter importen av VGS-vitnemål fra KREG | `@OPT-BEH-BEH-033` (`@planned`) | nei |
| `@FLY-OPT-VIT-001` | Vitnemålene hentes fra KREG for alle aktive søkere | `@OPT-BEH-BEH-030` (`@implemented`) | ja |
| `@FLY-OPT-VIT-001` | Vitnemål som ikke finnes fra før, importeres | `@OPT-BEH-BEH-030` (`@implemented`) | ja |
| `@FLY-OPT-VIT-001` | GSK-vitnemålsberegningen kjører når det nye vitnemålet er importert | `@OPT-BEH-BEH-015` (`@in-progress`, Regel: Opptakssystemets påstand om GSK på vitnemålet levert) | ja |
| `@FLY-OPT-VIT-001` | Den automatiske GSK-konklusjonen startes for hvert opptak der søkeren har en sak | `@OPT-BEH-BEH-015` (`@in-progress`, Regel: Konklusjon på søknaden fra vitnemålet levert) | ja |
| `@FLY-OPT-VIT-001` | Den automatiske behandlingen starter når importen har hentet vitnemålene til en søker uten vitnemål | `@OPT-BEH-BEH-032` (`@implemented`) | ja |
| `@FLY-OPT-VIT-001` | Annullerte vitnemål håndteres | `@OPT-BEH-BEH-030` (`@implemented`), `@OPT-BEH-BEH-015` (`@in-progress`, Regel: Annullert vitnemål levert), `@OPT-BEH-BEH-034` (`@implemented`) | ja |
| `@FLY-OPT-VAL-001` | Saksbehandleren starter den automatiske behandlingen på vitnemålet saksbehandleren velger | `@OPT-BEH-BEH-039` (`@in-progress`, Regel: Har søkeren flere vitnemål, behandles saken automatisk på vitnemålet saksbehandleren velger levert, satt i denne kjøringen) | ja |
| `@FLY-OPT-VAL-001` | Resten av saken behandles som i den automatiske saksbehandlingen | `@OPT-BEH-BEH-039` (`@in-progress`, Regel: Grunnlaget, poengene og kravelementene avgjøres på vitnemålet saksbehandleren har valgt ikke levert: 3 av 4 scenarioer `@implemented`, «Sammensatt vitnemål gir ikke grunnlaget …» mangler), `@FLY-OPT-AUT-001` (`@planned`) | nei |
| `@FLY-OPT-SAM-001` | Saksbehandleren setter sammen et vitnemål i vitnemålsbehandleren | – | mangler krav |
| `@FLY-OPT-SAM-001` | Saksbehandleren starter den automatiske behandlingen på det sammensatte vitnemålet | `@OPT-BEH-BEH-039` (`@planned`; ankeret står på et `@draft`-scenario) | nei |
| `@FLY-OPT-SAM-001` | Søknaden får ikke grunnlaget for førstegangsvitnemål på det sammensatte vitnemålet | `@OPT-BEH-BEH-019` (`@in-progress`, Regel: Grunnlaget velges ut fra egenskapene … levert), `@OPT-BEH-BEH-039` (`@planned`) | nei |
| `@FLY-OPT-SAM-001` | Resten av saken behandles som i den automatiske saksbehandlingen | `@FLY-OPT-AUT-001` (`@planned`) | nei |

`@FLY-OPT-AUT-001`: 15 av 18 faser levert (fasen med `@wont` er ikke telt med).
`@FLY-OPT-VIT-001`: 6 av 7 faser levert.
`@FLY-OPT-VAL-001`: 1 av 2 faser levert.
`@FLY-OPT-SAM-001`: 0 av 4 faser levert.

## Avhengigheter

Kravene som kravene i scope bygger på (`@depends-on-`), med statusen deres. Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | `@FLY-OPT-SAK-001` Saksbehandlertildeling | 1 | `@planned` | – | ikke levert; bare status (handler ikke om automatikken) |
| `@FLY-OPT-AUT-001`, `@FLY-OPT-VIT-001` | `@OPT-BEH-BEH-030` Importere resultater fra KREG | 1 | `@implemented` | 16/16 | ankrene: fire regler |
| `@FLY-OPT-AUT-001`, `@FLY-OPT-VIT-001` | `@OPT-BEH-BEH-032` Starte automatisk behandling | 1 | `@implemented` (var `@in-progress`) | 2/2 | ankrene: to regler |
| `@FLY-OPT-AUT-001`, `@FLY-OPT-VIT-001` | `@OPT-BEH-BEH-015` Automatisk GSK-konklusjon | 1 | `@in-progress` | 40/41 | ankrene: sju regler |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-027` Beregne GSK fra vitnemål | 1 | `@implemented` | 27/27 | hele kravet |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-025` Ferdigbehandle en sak | 1 | `@in-progress` | 7/8 | ankrene: to regler; 1 usikker (Min kompetanse) |
| `@FLY-OPT-AUT-001`, `@FLY-OPT-SAM-001` | `@OPT-BEH-BEH-019` Automatisk grunnlag | 1 | `@in-progress` | 14/14 | ankrene: tre regler |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-018` Automatisk beregning av vitnemålspoeng | 1 | `@in-progress` | 5/5 | ankrene: tre regler |
| `@FLY-OPT-AUT-001` | `@OPT-REG-RAN-001` Rangeringsregelverk | 1 | `@implemented` | – | bare status |
| `@FLY-OPT-AUT-001` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | bare status |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-028` Automatiske tilleggspoeng | 1 | `@in-progress` | 20/20 | ankrene: fire regler; «Bare beståtte emner teller» avklart 13.11.2026 |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-020` Automatisk vurdering av spesielle opptakskrav | 1 | `@in-progress` | 18/18 | ankrene: fire regler |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-012` Automatisk kvoteplassering | 1 | `@implemented` | 8/8 | ankrene: tre regler |
| `@FLY-OPT-AUT-001` | `@OPT-REG-KVO-002` Kvotespørsmål | 1 | `@implemented` | – | bare status |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-031` Beregne poengsum per kvote | 1 | `@implemented` | 12/12 | hele kravet; «Uendret poengsum gir ikke nytt innslag i endringsloggen» fikk `@deprecated` |
| `@FLY-OPT-AUT-001` | `@OPT-REG-KVO-001` Kvotetype | 1 | `@implemented` | – | bare status |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-036` Automatiske mangler | 1 | `@in-progress` | 20/28 | ankrene: tre regler; 5 ikke funnet, 3 usikker |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-029` Behandlingsstatus | 1 | `@implemented` (var `@in-progress`) | 2/2 | ankeret: én regel; regelen om saksloggen fikk `@deprecated` |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-026` Beregne automatisk på nytt | 1 | `@in-progress` | 12/12 | ankrene: tre regler |
| `@FLY-OPT-VIT-001` | `@OPT-BEH-BEH-033` Kjøre jobbene i opptak | 1 | `@planned` | 0/1 | ankeret: én regel |
| `@FLY-OPT-VIT-001` | `@OPT-BEH-BEH-034` Håndtere annullert vitnemål | 1 | `@implemented` | 7/7 | ankrene: to regler |
| `@FLY-OPT-VAL-001`, `@FLY-OPT-SAM-001` | `@OPT-BEH-BEH-039` Behandle automatisk på vitnemålet saksbehandleren velger | 1 | `@in-progress` (var `@planned`) | 5/6 | hele kravet; fs-admin fra !3415, merget 08:54 |
| `@FLY-OPT-VAL-001`, `@FLY-OPT-SAM-001` | `@FLY-OPT-AUT-001` Automatisk saksbehandling | 1 | `@planned` | – | i scope, se over |

### Scenarioer i avhengighetene

Resultatet for scenarioene i avhengighetene, verifisert i koden. De teller ikke i `## Oppsummering`.

Stiforkortelser i tabellen som ikke står over: `SYNC` = `P/saksbehandling/GskFullforesIVarMangelSync.java`, `KOS` = `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java`, `AKV` = `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java`, `KE` = `P/regelverk/kvalifisering/KvalifiseringEvaluator.java`, `K` = `P/autosak/kontrollmotor/Kravelementer.java`, `E` = `P/autosak/gsk/GskKonklusjonEvaluator.java`, `RKS` = `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringKjoringService.java`, `PCR` = `A/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx`, `V514` = `P-mig/V514__behandlingsstatus_fjern_ferdig_behandlet.sql`. Filnavn uten sti ligger under `P/`.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | Resultatene hentes når søkeren sender inn søknaden | funnet | P ✓ · A – — fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java:578; fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:330-340,135-141 |
| `@OPT-BEH-BEH-030` | Resultatene hentes når søknaden registreres på vegne av søkeren | funnet | P ✓ · A – — StudiekurvService.java:962; SoknadshendelseJobb.java:140 |
| `@OPT-BEH-BEH-030` | Resultatene hentes når en endring av søknaden gir en ny sak | funnet | P ✓ · A – — StudiekurvService.java:1072; BehandlertildelingService.java:82-135; VgsLagringService.java:42-103 |
| `@OPT-BEH-BEH-030` | Resultatene hentes først når saken er opprettet | funnet | P ✓ · A – — SoknadshendelseJobb.java:317-324, L132-141 |
| `@OPT-BEH-BEH-030` | Resultatene hentes med D-nummer når søkeren ikke har fødselsnummer | funnet | P ✓ · A – — fs-plattform/opptak/vgs/HentVgsVitnemaalService.java:108-124 |
| `@OPT-BEH-BEH-030` | Det importerte vitnemålet har opplysningene saksbehandlingen trenger | funnet | P ✓ · A – — fs-plattform/opptak/vgs/KregVgsParser.java:96-107; VgsLagringService.java:71-101 |
| `@OPT-BEH-BEH-030` | Søker med flere vitnemål får alle importert | funnet | P ✓ · A – — KregVgsParser.java:69-76; HentVgsVitnemaalService.java:190-211 |
| `@OPT-BEH-BEH-030` | Vitnemål som er importert fra før, importeres ikke på nytt | funnet | P ✓ · A – — VgsLagringService.java:49-57 |
| `@OPT-BEH-BEH-030` | Annullert vitnemål importeres som annullert | funnet | P ✓ · A – — KregVgsParser.java:107; VgsLagringService.java:84,97 |
| `@OPT-BEH-BEH-030` | Vitnemål som annulleres etter importen, blir annullert | funnet | P ✓ · A – — VgsLagringService.java:53-63 |
| `@OPT-BEH-BEH-030` | Vitnemålet blir stående som annullert når KREG opphever annulleringen | funnet | P ✓ · A – — VgsLagringService.java:38-39,53-56 |
| `@OPT-BEH-BEH-030` | Søkeren får vitnemålet etter at søknaden er levert | funnet | P ✓ · A – — fs-plattform/opptak/opptak-subgraph/.../app/KregImportJobb.java:84-92,159-174; NB application.properties:110-111 cron=off som standard, på bare i application-platon-test.properties:20-21 |
| `@OPT-BEH-BEH-030` | Vitnemålene hentes én gang for søkeren med søknader i flere opptak | funnet | P ✓ · A – — fs-plattform/opptak/saksbehandling/KregImportKjoringService.java:83-88; KregImportJobb.java:162-167 |
| `@OPT-BEH-BEH-030` | Vitnemålene hentes ikke for søkeren som ikke er aktiv | funnet | P ✓ · A – — KregImportKjoringService.java:87-88 |
| `@OPT-BEH-BEH-030` | Vitnemålet annulleres og erstattes av et nytt etter at opptakssystemet har behandlet søknaden | funnet | P ✓ · A – — HentVgsVitnemaalService.java:190-208; KregImportJobb.java:163 |
| `@OPT-BEH-BEH-030` | Vitnemålet annulleres uten at det kommer et nytt, etter at opptakssystemet har behandlet søknaden | funnet | P ✓ · A – — VgsLagringService.java:53-63 |
| `@OPT-BEH-BEH-032` | Den nye saken behandles automatisk når saksbehandlertildelingen har opprettet den | funnet | P ✓ · A – — fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:135-141,411; fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/KregImportService.java:110 → AutomatiskBehandlingEtterImportService.startForSoker (L70-93); opptak/Opptaksfrister.java:145-157 |
| `@OPT-BEH-BEH-032` | Saken behandles automatisk når importen har hentet søkerens vitnemål | funnet | P ✓ · A – — fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/KregImportJobb.java:162-170; KregImportService.java:93-110; AutomatiskBehandlingEtterImportService.java:124-131. NB: daglig import av som standard (application.properties:110-111) |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand er at søkeren har generell studiekompetanse | funnet | P ✓ · A – — autosak/gsk/GskKonklusjonEvaluator.java:93-98; GskPaastandService.java:36-42; vgs/HentVgsVitnemaalService.java:210 |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand beregnes uavhengig av GSK OK fra KREG | funnet | P ✓ · A – — GskKonklusjonEvaluator.java:93-98 |
| `@OPT-BEH-BEH-015` | Hvert vitnemål får sin egen påstand | funnet | P ✓ · A – — vgs/HentVgsVitnemaalService.java:190-211 |
| `@OPT-BEH-BEH-015` | Grunnlagskoder som settes automatisk | funnet | P ✓ · A – — GskKonklusjonEvaluator.java:116-134; V275__vgs_loep.sql |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand er at søkeren ikke har GSK når <grunn> | funnet | P ✓ · A – — GskKonklusjonEvaluator.java:96-97 |
| `@OPT-BEH-BEH-015` | Annullert vitnemål får ingen påstand fra opptakssystemet | funnet | P ✓ · A – — GskPaastandService.java:66-67, 36-41 |
| `@OPT-BEH-BEH-015` | Vitnemålet gir GSK når det har GSK OK fra KREG | funnet | P ✓ · A – — GskKonklusjonEvaluator.java:55-76; GskVedtakAutoService.java:268 |
| `@OPT-BEH-BEH-015` | Vitnemålet gir ikke GSK når det ikke har GSK OK fra KREG | funnet | P ✓ · A – — GskKonklusjonEvaluator.java:61-63 |
| `@OPT-BEH-BEH-015` | Uenighet med skolen stopper ikke den automatiske behandlingen | funnet | P ✓ · A – — GskKonklusjonEvaluator.java:64-76; GskVedtakAutoService.java:327; AutomatiskSaksbehandlingService.java:136-150 |
| `@OPT-BEH-BEH-015` | Annullert vitnemål gir ikke GSK | funnet | P ✓ · A – — GskVedtakAutoService.java:168-173 |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra vitnemålet | funnet | P ✓ · A – — GskVedtakAutoService.java:343-351; GskKonklusjonEtterImportService.java:97-99 |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra vitnemålet når saken er <status> | funnet | P ✓ · A – — GskVedtakAutoService.java:104-107; GskKonklusjonEtterImportService.java:113-137 |
| `@OPT-BEH-BEH-015` | Søknaden får grunnlagskoden for løpet når opptakssystemet er uenig med skolen | funnet | P ✓ · A – — GskKonklusjonEvaluator.java:72-76 |
| `@OPT-BEH-BEH-015` | Søknaden får grunnlagskoden <grunnlagskode> når et løp fra <reform> ikke finnes i opptakssystemets liste over løp | funnet | P ✓ · A – — GskKonklusjonEvaluator.java:65-71,79-84 |
| `@OPT-BEH-BEH-015` | Et vitnemål med et løp i listen brukes før et nyere vitnemål med et ukjent løp | funnet | P ✓ · A – — GskVedtakAutoService.java:184-197 |
| `@OPT-BEH-BEH-015` | Det nyeste vitnemålet brukes når ingen av løpene finnes i listen | funnet | P ✓ · A – — GskVedtakAutoService.java:172,188-197 |
| `@OPT-BEH-BEH-015` | Søknaden får grunnlagskoden <grunnlagskode> når et løp fra <reform> ikke har en grunnlagskode | funnet | P ✓ · A – — GskKonklusjonEvaluator.java:123-131 |
| `@OPT-BEH-BEH-015` | Vitnemål som ikke gir GSK, gir ingen konklusjon | funnet | P ✓ · A – — GskVedtakAutoService.java:80-92 |
| `@OPT-BEH-BEH-015` | Vitnemålet med senest utstedelsesdato brukes | funnet | P ✓ · A – — GskVedtakAutoService.java:172 |
| `@OPT-BEH-BEH-015` | Alle søknader uten konklusjon oppdateres | funnet | P ✓ · A – — GskKonklusjonEtterImportService.java:53-73; GskVedtakAutoService.java:69-71 |
| `@OPT-BEH-BEH-015` | Søknader i avsluttede opptak oppdateres ikke | funnet | P ✓ · A – — GskKonklusjonEtterImportService.java:57-59; GskVedtakAutoService.java:72-74 |
| `@OPT-BEH-BEH-015` | Nytt vitnemål fra KREG etter at søknaden er opprettet | funnet | P ✓ · A – — opptak-subgraph/.../app/KregImportJobb.java:37-46 (NB av som standard, bare på i platon-test) |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra tidligere samordna opptak | funnet | P ✓ · A – — autosak/gsk/TidligereGskKonklusjonService.java:139-188; GskVedtakAutoService.java:279-292 |
| `@OPT-BEH-BEH-015` | Vitnemålet går foran tidligere konklusjon | funnet | P ✓ · A – — GskVedtakAutoService.java:80-91 |
| `@OPT-BEH-BEH-015` | Bare den siste tidligere konklusjonen gjenbrukes | funnet | P ✓ · A – — TidligereGskKonklusjonService.java:80-96 |
| `@OPT-BEH-BEH-015` | Negative konklusjoner gjenbrukes ikke | funnet | P ✓ · A – — TidligereGskKonklusjonService.java:82,119-120,171-172 |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra lokalt opptak | funnet | P ✓ · A – — TidligereGskKonklusjonService.java:98-137 |
| `@OPT-BEH-BEH-015` | Annullert konklusjon gjenbrukes ikke | funnet | P ✓ · A – — TidligereGskKonklusjonService.java:115-116,167-168 |
| `@OPT-BEH-BEH-015` | Konklusjon med annullering fram i tid gjenbrukes ikke | funnet | P ✓ · A – — TidligereGskKonklusjonService.java:115,167 |
| `@OPT-BEH-BEH-015` | Konklusjon som bygger på et annullert vitnemål gjenbrukes ikke | funnet | P ✓ · A – — TidligereGskKonklusjonService.java:118,191-197 |
| `@OPT-BEH-BEH-015` | Ingen grunnlag for generell studiekompetanse | funnet | P ✓ · A – — GskVedtakAutoService.java:92 |
| `@OPT-BEH-BEH-015` | Konklusjon på søknaden overskrives ikke | funnet | P ✓ · A – — GskVedtakAutoService.java:245-252 |
| `@OPT-BEH-BEH-015` | Systemet setter aldri en negativ konklusjon | funnet | P ✓ · A – — GskVedtakAutoService.java:54,343 |
| `@OPT-BEH-BEH-015` | Automatikken kan sette en ny konklusjon etter annulleringen | ikke funnet | P ✗ · A – — GskVedtakAutoService.java:69-71 + soknad/gskvedtak/GskVedtakConditions.java:14-15,84-86: KVALIFISERT_MEN_ANNULLERT regnes som gjeldende og stopper automatikken; behandleEtterImport (L108-113) erstatter bare GJENBRUK/KVALIFISERT. Søkt «KVALIFISERT_MEN_ANNULLERT», «annuller» i autosak/gsk og i !6714 |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra vitnemålet i den automatiske behandlingen | funnet | P ✓ · A – — AutomatiskSaksbehandlingService.java:136,240-247 |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra et tidligere opptak i den automatiske behandlingen | funnet | P ✓ · A – — GskVedtakAutoService.java:86-91 |
| `@OPT-BEH-BEH-015` | Konklusjonen overskrives ikke i den automatiske behandlingen | funnet | P ✓ · A – — GskVedtakAutoService.java:69-71 |
| `@OPT-BEH-BEH-015` | Automatisk konklusjon står når vitnemålet annulleres | funnet | P ✓ · A – — saksbehandling/AnnullertVitnemaalService.java:49-81, 24-30 |
| `@OPT-BEH-BEH-015` | Gjenbrukt konklusjon står når vitnemålet annulleres | funnet | P ✓ · A – — GskVedtakAutoService.java:288; AnnullertVitnemaalService.java:156-163 |
| `@OPT-BEH-BEH-015` | Konklusjon i avsluttet opptak trekkes ikke tilbake | funnet | P ✓ · A – — AnnullertVitnemaalService.java:24-30 (NB: tagger også saker i avsluttede opptak) |
| `@OPT-BEH-BEH-015` | Annulleringen oppdages uten at søkeren endrer søknaden | funnet | P ✓ · A – — KregImportJobb.java:37-46; KregImportService.java:74-76,131-141 |
| `@OPT-BEH-BEH-027` | Delkravene for <reform> | funnet | P ✓ · A – — K:1263-1285 |
| `@OPT-BEH-BEH-027` | Vitnemål fra Kunnskapsløftet uten <delkrav> får påstanden ikke GSK | funnet | P ✓ · A – — K:1267-1271 |
| `@OPT-BEH-BEH-027` | Vitnemål fra Reform 94 uten <delkrav> får påstanden ikke GSK | funnet | P ✓ · A – — K:1278-1285 |
| `@OPT-BEH-BEH-027` | Matematikkravet er oppfylt med <alternativ> | funnet | P ✓ · A – — K:1112-1136, K:647, K:1141-1170, K:461-490 |
| `@OPT-BEH-BEH-027` | Påbygging med matematikk <fag> på vg1 | funnet | P ✓ · A – — K:1143-1169 |
| `@OPT-BEH-BEH-027` | Matematikk for yrkesfag på vg1 alene oppfyller ikke matematikkravet | funnet | P ✓ · A – — K:1170, K:1135 |
| `@OPT-BEH-BEH-027` | Naturfagkravet er oppfylt med <alternativ> | funnet | P ✓ · A – — K:1176, K:1181, K:1182 |
| `@OPT-BEH-BEH-027` | Vg1 og vg3 fra ulike planer oppfyller ikke naturfagkravet | funnet | P ✓ · A – — K:1179-1183 |
| `@OPT-BEH-BEH-027` | Samfunnsfagkravet er oppfylt med <fagkode> | funnet | P ✓ · A – — K:1188 |
| `@OPT-BEH-BEH-027` | Engelskkravet er oppfylt med <fagkode> | funnet | P ✓ · A – — K:1193-1207 |
| `@OPT-BEH-BEH-027` | Standard norsk med <variant> | funnet | P ✓ · A – — K:869-871, 213-215, 852-856, 828-845, 224-227, 848-850 |
| `@OPT-BEH-BEH-027` | Merknaden VMM25 med <fag> gir ikke standard norsk | funnet | P ✓ · A – — K:829-831 |
| `@OPT-BEH-BEH-027` | NOR1049 som privatist med merknaden VMM25 erstatter norsk hovedmål | funnet | P ✓ · A – — K:816-821 |
| `@OPT-BEH-BEH-027` | Norskkravet er oppfylt med <variant> | funnet | P ✓ · A – — K:1213, K:884-891, K:230-231, K:235 |
| `@OPT-BEH-BEH-027` | Standard norsk krever historie etter standard plan (<fagkode>) | funnet | P ✓ · A – — K:1237-1244 |
| `@OPT-BEH-BEH-027` | Standard norsk med historie etter samisk plan oppfyller ikke kravet | funnet | P ✓ · A – — K:1238-1243 |
| `@OPT-BEH-BEH-027` | <variant> godtar alle historiefagene | funnet | P ✓ · A – — K:1222-1235, K:1250, K:1256 |
| `@OPT-BEH-BEH-027` | Delkravet for <delkrav> er oppfylt med <alternativ> | funnet | P ✓ · A – — K:1288-1310, 1314-1328, 1331-1343, 1349-1406 |
| `@OPT-BEH-BEH-027` | Norsk for tegnspråklige alene oppfyller ikke norskkravet | funnet | P ✓ · A – — K:1402-1407 |
| `@OPT-BEH-BEH-027` | Løpet settes sammen av programområdene etter nivå | funnet | P ✓ · A – — fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/VgsDokumentVitnemaalMapper.java:77-78,112-117 |
| `@OPT-BEH-BEH-027` | Påstanden er GSK med grunnlagskoden for løpet | funnet | P ✓ · A – — E:93-98, E:120-121 |
| `@OPT-BEH-BEH-027` | Grunnlagskoden gis selv om påstanden ikke er GSK | funnet | P ✓ · A – — E:96-98; GskPaastandService.java:38 |
| `@OPT-BEH-BEH-027` | Ukjent løp | funnet | P ✓ · A – — E:96-97; GskLoep.java:16-24 |
| `@OPT-BEH-BEH-027` | Påbyggingsruten PBPBY4 gir grunnlagskoden KLF | funnet | P ✓ · A – — E:116-118, E:44-49 |
| `@OPT-BEH-BEH-027` | Påbyggingsruten PBPBY4 på et ukjent løp | funnet | P ✓ · A – — E:96 |
| `@OPT-BEH-BEH-027` | Løp fra <reform> uten grunnlagskode gir grunnlagskoden <grunnlagskode> | funnet | P ✓ · A – — E:123-131 |
| `@OPT-BEH-BEH-027` | Løp og vitnemål fra ulike reformer | funnet | P ✓ · A – — E:123-125, E:97 |
| `@OPT-BEH-BEH-025` | Saken behandles helautomatisk når søkeren har ett vitnemål, og vitnemålet gir GSK | funnet | P ✓ · A – — P/autosak/FerdigbehandlingService.java:89-104; AutomatikkensVitnemaal.java:108-114; AutomatiskSaksbehandlingService.java:170-204 |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk når ingen vitnemål gir GSK | funnet | P ✓ · A – — FerdigbehandlingService.java:99-103, L64-67 |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål | funnet | P ✓ · A – — P/autosak/AutomatiskBehandlingEtterImportService.java:134-143; SetteGrunnlagService.java:111-117. NB: to identiske vitnemål regnes som ett (AutomatikkensVitnemaal.java:168-197) — scenarioet sier ikke «ulike» |
| `@OPT-BEH-BEH-025` | To identiske vitnemål regnes som ett vitnemål | funnet | P ✓ · A – — scenarioet er lagt til i denne kjøringen; P/autosak/AutomatikkensVitnemaal.java:108-116,168-197 (velgBlantIdentiske), P/autosak/FerdigbehandlingService.java:89-104 (bekreftet av kontrollen for 025 og AUT) |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk når søkeren har flere vitnemål, og bare ett gir GSK | funnet | P ✓ · A – — AutomatikkensVitnemaal.java:58-61,175-179; AutomatiskBehandlingEtterImportService.java:141-143; FerdigbehandlingService.java:99 |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | funnet | P ✓ · A – — FerdigbehandlingService.java:63-80, L106-118; AutomatiskSaksbehandlingService.java:204,312-314 |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet selv om kravelementene ga mangeltekst | funnet | P ✓ · A – — P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:203-217; FerdigbehandlingService.java:133-138 |
| `@OPT-BEH-BEH-025` | Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet | funnet | P ✓ · A – · M ✓ — P/autosak/FerdigbehandlingService.java:78 → P/saksbehandling/ManglerPublisering.java:28-54 (publiserer og sender én melding); P-mig/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:139-189 (viewet viser mangelteksten på en ferdig behandlet sak); min-kompetanse (fs/min-kompetanse, main 066f8d6a, lest i GitLab): `src/components/soknadsmangel/fragment-soknad-mangler.ts` henter `Soknad.mangler` og `soknadsalternativer.mangler` med `standardTekst`, og `src/components/soknadsmangel/mangel-list.tsx` viser teksten |
| `@OPT-BEH-BEH-019` | Grunnlag ut fra førstegangsvitnemål og alder | funnet | P ✓ · A – — fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/SetteGrunnlagService.java:303 |
| `@OPT-BEH-BEH-019` | Søkeren som er akkurat 22 år, får grunnlaget som krever et vitnemål | funnet | P ✓ · A – — P/autosak/SetteGrunnlagService.java:340 |
| `@OPT-BEH-BEH-019` | Alderen regnes ut på datoen for aldersberegning | funnet | P ✓ · A – — P/autosak/SetteGrunnlagService.java:169 |
| `@OPT-BEH-BEH-019` | Førstegangsvitnemål går foran | funnet | P ✓ · A – — P/autosak/SetteGrunnlagService.java:289 |
| `@OPT-BEH-BEH-019` | Grunnlag uten egenskaper for automatikken settes ikke | funnet | P ✓ · A – — P/autosak/SetteGrunnlagService.java:258 |
| `@OPT-BEH-BEH-019` | Bare grunnlag i regelverket til utdanningstilbudene i søknaden kan settes | funnet | P ✓ · A – — P/autosak/SetteGrunnlagService.java:136 |
| `@OPT-BEH-BEH-019` | Grunnlag som ikke er aktivt, settes ikke | funnet | P ✓ · A – — P/autosak/SetteGrunnlagService.java:256 |
| `@OPT-BEH-BEH-019` | Ingen grunnlag settes automatisk når <grunn> | funnet | P ✓ · A – — P/autosak/SetteGrunnlagService.java:112 (L119, L130, L174–183) |
| `@OPT-BEH-BEH-019` | Søker med flere ulike vitnemål behandles ikke automatisk | funnet | P ✓ · A – — scenarioet er rettet til «ulike» i denne kjøringen. P/autosak/SetteGrunnlagService.java:113 FlereVitnemaalException; men etter !6741 velger AutomatikkensVitnemaal.java:115 (velgBlantIdentiske L182) ett vitnemål når alle er identiske — kravet sier ikke noe om identiske vitnemål |
| `@OPT-BEH-BEH-019` | Opplastet kompetansebevis stopper ikke automatikken | funnet | P ✓ · A – — P/autosak/AutomatikkensVitnemaal.java:102 |
| `@OPT-BEH-BEH-019` | Annullert vitnemål teller ikke | funnet | P ✓ · A – — P/vgs/VgsDokumentConditions.java:28 |
| `@OPT-BEH-BEH-019` | Grunnlaget settes etter GSK-konklusjonen | funnet | P ✓ · A – — P/autosak/AutomatiskSaksbehandlingService.java:136 |
| `@OPT-BEH-BEH-019` | Hver sak i søknaden får grunnlaget når den automatiske behandlingen kjører for saken | funnet | P ✓ · A – — P/autosak/SetteGrunnlagService.java:192 |
| `@OPT-BEH-BEH-019` | Grunnlaget settes av den automatiske behandlingen | funnet | P ✓ · A – — P/autosak/AutomatiskSaksbehandlingService.java:174 |
| `@OPT-BEH-BEH-018` | Poengtype som beregnes fra vitnemålet | funnet | P ✓ · A – — P/regelverk/poeng/AutomatiskPoengberegningService.java:85; PoengService.java:250,212; KontrollMotor.java:168-170 |
| `@OPT-BEH-BEH-018` | Poengtype uten kobling til vitnemålet beregnes ikke | funnet | P ✓ · A – — P/regelverk/poeng/AlgoritmepoengService.java:79 |
| `@OPT-BEH-BEH-018` | Beregnet poeng rundes til antall desimaler poengtypen har | funnet | P ✓ · A – — P/regelverk/poeng/PoengService.java:204; PoengAvrunder.java:30 |
| `@OPT-BEH-BEH-018` | Skolepoeng beregnet fra vitnemålspoengene | funnet | P ✓ · A – — P/saksbehandling/PropageringService.java:204; PoengformelParser.java:95 (taket på 4 i regelverkets formel); regelverk/kvalifisering/Skolepoeng.java:50 |
| `@OPT-BEH-BEH-018` | Opplastet kompetansebevis hindrer ikke beregningen | funnet | P ✓ · A – — P/autosak/AutomatikkensVitnemaal.java:96; AutomatiskPoengberegningService.java:125 |
| `@OPT-BEH-BEH-028` | Alderspoeng for søkerens alder | funnet | P ✓ · A – — P/regelverk/poeng/Alderspoeng.java:31; PoengService.java:99 |
| `@OPT-BEH-BEH-028` | Alderspoengene viser hvilken alder de er regnet ut for | funnet | P ✓ · A ✓ — P/regelverk/poeng/PoengService.java:102; Alderspoeng.java:99; PCR:199 |
| `@OPT-BEH-BEH-028` | Standarddatoen brukes når datoen for aldersberegning ikke er satt | funnet | P ✓ · A – — P/saksbehandling/AldersberegningsdatoUtleder.java:56; opptak/AldersberegningsdatoDefault.java:20; LeggTilGrunnlagService.java:50 → PropageringService.java:111 |
| `@OPT-BEH-BEH-028` | Kjønnspoeng for søkerens kjønn | funnet | P ✓ · A – — P/regelverk/poeng/KjonnspoengAlgoritme.java:11; PoengService.java:290 |
| `@OPT-BEH-BEH-028` | Kjønnspoengene viser hvilket kjønn de er regnet ut for | funnet | P ✓ · A ✓ — PoengService.java:117; PCR:228 |
| `@OPT-BEH-BEH-028` | Poeng for høyere utdanning | funnet | P ✓ · A – — P/regelverk/poeng/HoyereUtdanningspoeng.java:12; HoyereUtdanningspoengAlgoritme.java:9 |
| `@OPT-BEH-BEH-028` | Poengene for høyere utdanning viser hvor mange studiepoeng de er regnet ut for | funnet | P ✓ · A ✓ — PoengService.java:131; PCR:228 |
| `@OPT-BEH-BEH-028` | Søker uten resultater fra høyere utdanning får 0 poeng | funnet | P ✓ · A – — PoengService.java:279 |
| `@OPT-BEH-BEH-028` | Bare beståtte emner teller | funnet | P ✓ · A – — avklart 13.11.2026: tjenesten for resultater fra høyere utdanning gir bare gyldige resultater, så opptakssystemet filtrerer ikke selv. Summen er P/regelverk/poeng/PoengService.java:278-288 |
| `@OPT-BEH-BEH-028` | Fagskolepoeng teller ikke | funnet | P ✓ · A – — PoengService.java:285 |
| `@OPT-BEH-BEH-028` | Innpassede emner telles bare én gang | funnet | P ✓ · A – — PoengService.java:286 |
| `@OPT-BEH-BEH-028` | Innpassede emner telles med studiepoengene fra lærestedet der de ble tatt | funnet | P ✓ · A – — PoengService.java:286 |
| `@OPT-BEH-BEH-028` | Studiepoengene telles når poengene regnes ut | funnet | P ✓ · A – — PoengService.java:278 |
| `@OPT-BEH-BEH-028` | Automatikken velger grunnlaget | funnet | P ✓ · A – — P/autosak/AutomatiskSaksbehandlingService.java:179; PropageringService.java:111 → AlgoritmepoengService.java:36; AutomatiskPoengberegningService.java:118 |
| `@OPT-BEH-BEH-028` | Saksbehandleren velger grunnlaget | funnet | P ✓ · A – — P/saksbehandling/LeggTilGrunnlagService.java:50; PropageringService.java:109-111 |
| `@OPT-BEH-BEH-028` | Saksbehandleren får kjønnspoengene grunnlaget gir | funnet | P ✓ · A – — P/regelverk/poeng/AlgoritmepoengService.java:85 |
| `@OPT-BEH-BEH-028` | Poengene for grunnlaget som er fjernet, vises ikke lenger | funnet | P ✓ · A ✓ — P/saksbehandling/FjernGrunnlagService.java:39; PoengRadOppdateringService.java:142-153; opptak-subgraph/.../saksbehandling/sak.graphqls:100; fs-admin/src/domains/soknadsbehandling/features/PoengberegningCard/PoengberegningCard.tsx:20 |
| `@OPT-BEH-BEH-028` | Poengene regnes ut på nytt når saksbehandleren endrer grunnlaget | funnet | P ✓ · A – — PropageringService.java:109,111 |
| `@OPT-BEH-BEH-028` | Poengene regnes ikke ut på nytt av seg selv når datoen for aldersberegning endres | funnet | P ✓ · A – — P/opptak/OpprettOpptakMutations.java:176 |
| `@OPT-BEH-BEH-028` | Søker uten elektronisk vitnemål får tilleggspoeng | funnet | P ✓ · A – — AlgoritmepoengService.java:36; LeggTilGrunnlagService.java:38-55 |
| `@OPT-BEH-BEH-020` | Fagkrav som er oppfylt på vitnemålet | funnet | P ✓ · A – — AKV:123, L185; KontrollMotor.java:87 |
| `@OPT-BEH-BEH-020` | Fagkrav som ikke er oppfylt på vitnemålet | funnet | P ✓ · A – — AKV:187 |
| `@OPT-BEH-BEH-020` | Karakteren fra vitnemålet registreres på fagkravet | funnet | P ✓ · A – — AKV:190; KontrollMotor.java:73 |
| `@OPT-BEH-BEH-020` | Fagkrav uten karakter oppfylles uten karakter | funnet | P ✓ · A – — AKV:172; FagSoek.java:378 |
| `@OPT-BEH-BEH-020` | Karakterkrav får karakteren fra vitnemålet | funnet | P ✓ · A – — P/autosak/kontrollmotor/KontrollMotor.java:163, 290-297; AKV:190 |
| `@OPT-BEH-BEH-020` | Beste karakter gjelder for programfag matematikk | funnet | P ✓ · A – — KontrollMotor.java:79; Kravelementer.java:89; FagSoek.java:382 |
| `@OPT-BEH-BEH-020` | Kravelement som ikke er koblet til vitnemålet, vurderes ikke | funnet | P ✓ · A – — AKV:123 |
| `@OPT-BEH-BEH-020` | Kravelementer fra en annen sak i søknaden vurderes ikke i saken | funnet | P ✓ · A – — P/saksbehandling/KvalifikasjonsgrunnlagOppdateringService.java:172; KvalifiseringKravelementV2OppdateringService.java:90; AKV:113 |
| `@OPT-BEH-BEH-020` | Kravelement vurderes mot vitnemål fra R94 | funnet | P ✓ · A – — P/autosak/kontrollmotor/Kravelementer.java:393, L64 |
| `@OPT-BEH-BEH-020` | Ugyldig karakter må vurderes manuelt | funnet | P ✓ · A ✓ — AKV:171, L222; fs-admin/src/domains/soknadsbehandling/features/KravlisteStudierCard/components/AutomatiskVurdering.tsx:24 |
| `@OPT-BEH-BEH-020` | Ingen automatisk vurdering når <grunn> | funnet | P ✓ · A – — raden om flere vitnemål er rettet til «flere ulike elektroniske vitnemål» i denne kjøringen. Ulike vitnemål og ingen valgt gir ikke noe vitnemål: P/autosak/AutomatikkensVitnemaal.java:185-186 (velgBlantIdentiske) → AKV:92-94; ingen vitnemål: AutomatikkensVitnemaal.java:71-73 → AKV:92-94 |
| `@OPT-BEH-BEH-020` | Opplastet kompetansebevis stopper ikke vurderingen | funnet | P ✓ · A – — P/autosak/AutomatikkensVitnemaal.java:102; AKV:250 |
| `@OPT-BEH-BEH-020` | Kvalifisert når alle kravelementene i en kravliste er oppfylt | funnet | P ✓ · A – — KE:157, L150 |
| `@OPT-BEH-BEH-020` | Kvalifisert når én av kravlistene er oppfylt | funnet | P ✓ · A – — KE:162, L312 |
| `@OPT-BEH-BEH-020` | Karakteren må nå karakterkravet | funnet | P ✓ · A – — KE:206 |
| `@OPT-BEH-BEH-020` | Søkeren kan være kvalifisert på ett grunnlag og ikke på et annet | funnet | P ✓ · A – — P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:159, L171-173; KE:150 |
| `@OPT-BEH-BEH-020` | Kravelementet vurderes i den automatiske behandlingen | funnet | P ✓ · A – — P/autosak/AutomatiskSaksbehandlingService.java:190, L184, L199 |
| `@OPT-BEH-BEH-020` | Feil i vurderingen stopper ikke resten av behandlingen | funnet | P ✓ · A – — AutomatiskSaksbehandlingService.java:302, L307-308 |
| `@OPT-BEH-BEH-012` | Plassering i kvote uten kvotespørsmål | funnet | P ✓ · A ✓ — P: saksbehandling/SoknadKvoteOppretterService.java:58-94,251-278; regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:142-170; saksbehandling/PropageringService.java:101-115,179-189. A: OppsummeringCard/OppsummeringsCardNy/OppsummeringsCardNy.tsx:96-102,231-238,381 |
| `@OPT-BEH-BEH-012` | Søkeren er ikke kvalifisert på grunnlaget | funnet | P ✓ · A – — SoknadKvoteOppretterService.java:90-94,261-278 |
| `@OPT-BEH-BEH-012` | Kvote uten kvotespørsmål vises ikke blant kvotespørsmålene | funnet | P ✓ · A ✓ — PropageringService.java:185; A: KvoteplasseringCard/KvoteplasseringCard.tsx:90-118,144-153 |
| `@OPT-BEH-BEH-012` | Grunnlag som ikke er koblet til kvotetypen | funnet | P ✓ · A – — SoknadKvoteOppretterService.java:251-258; regelverk/poeng/PoengsumService.java:119-125 |
| `@OPT-BEH-BEH-012` | Alle kvotespørsmål besvart ja | funnet | P ✓ · A ✓ — saksbehandling/KvotesporsmalSvarService.java:51-74,229-241,364-384,409-419; A: KvoteplasseringCard.tsx:145-153 → KvoteplasseringCard/hooks/useLagreKvotesporsmalSvarMutation.ts |
| `@OPT-BEH-BEH-012` | Ett kvotespørsmål besvart nei | funnet | P ✓ · A ✓ — KvotesporsmalSvarService.java:409-416, 372-384 |
| `@OPT-BEH-BEH-012` | Automatisk besvart kvotespørsmål vises låst | funnet | P ✓ · A ✓ — autosak/KvotesporsmalAlgoritmeService.java:209-254; A: KvoteplasseringCard.tsx:118,149-151; KvoteplasseringCard/components/KvotesporsmalRow/KvotesporsmalRow.tsx:52-63,77-78 |
| `@OPT-BEH-BEH-012` | Svar på automatisk kvotespørsmål avvises i API-et | funnet | P ✓ · A – — KvotesporsmalSvarService.java:123-138 |
| `@OPT-BEH-BEH-031` | Poengsum for grunnlaget kvoten er koblet til | funnet | P ✓ · A – — regelverk/poeng/PoengsumService.java:67-75,96-134,146-184; regelverk/poeng/PoengberegningService.java:133-157 |
| `@OPT-BEH-BEH-031` | Grunnlag kvoten ikke er koblet til, gir ingen poengsum i kvoten | funnet | P ✓ · A – — PoengberegningService.java:139-143; PoengsumService.java:119-125 |
| `@OPT-BEH-BEH-031` | Kvote søkeren ikke er plassert i, gir ingen poengsum | funnet | P ✓ · A – — PoengsumService.java:67-75 |
| `@OPT-BEH-BEH-031` | Poengsummen følger poengformelen til kvotetypen | funnet | P ✓ · A – — PoengberegningService.java:103-104,146-151, :67 |
| `@OPT-BEH-BEH-031` | Grunnlag søkeren ikke er kvalifisert på, gir ingen poengsum | funnet | P ✓ · A – — PoengsumService.java:136-138,166-168,258-268 |
| `@OPT-BEH-BEH-031` | Poengsummen regnes ut på nytt når <endring> | funnet | P ✓ · A – — saksbehandling/LeggTilGrunnlagService.java:53; FjernGrunnlagService.java:42; regelverk/poeng/SettPoengService.java:46; saksbehandling/LagreVitnemalUtregningService.java:72; regelverk/kvalifisering/KvalifiserKravelementV4Service.java:58; KvalifiserKravelementUnntakService.java:62; regelverk/kvoteplassering/EndreKvoteplasseringService.java:51; saksbehandling/KvotesporsmalSvarService.java:264 → saksbehandling/PropageringService.java:201-205 |
| `@OPT-BEH-BEH-031` | Uendret poengsum gir ikke nytt innslag i endringsloggen | usikker | `@deprecated` i denne kjøringen (teamet ønsker ikke atferden). P ~ · A – — usikker etter kontrollen: diffen finnes (PoengsumService.java:394-421), men P-mig/V480__stopp_endringslogg.sql fjernet audit-triggerne, så ingenting logges. PoengsumService.java:405-421 oppdaterer bare ved endring; audit-trigger i fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V291__saksbehandling_skjema.sql:25-26,1205-1212 |
| `@OPT-BEH-BEH-031` | Poengsummen i de andre kvotene regnes ut når én kvote feiler | funnet | P ✓ · A – — PoengberegningService.java:145-188 |
| `@OPT-BEH-BEH-031` | Saksbehandleren ser hvorfor poengsummen ikke kan regnes ut | funnet | P ✓ · A ✓ — PoengberegningService.java:181-201 → PoengsumService.java:188-189,272-305; A: fs-admin/src/domains/soknadsbehandling/features/OppsummeringCard/OppsummeringsCardNy/OppsummeringsCardNy.tsx:104-105,242-250,385 → OppsummeringCard/components/PoengsumMerknader/PoengsumMerknader.tsx |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når søkeren ikke er plassert i noen kvote | funnet | P ✓ · A – — PoengsumService.java:77-80 |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når saken ikke har noe grunnlag | funnet | P ✓ · A – — PoengsumService.java:96-105 |
| `@OPT-BEH-BEH-031` | Den høyeste poengsummen i kvoten vises | funnet | P ✓ · A ✓ — saksbehandling/KvotesumV2Service.java:139-185; A: OppsummeringsCardNy.tsx:96-102,231-238,381 |
| `@OPT-BEH-BEH-031` | Søknadsalternativ søkeren ikke er kvalifisert til, viser ingen poengsum | funnet | P ✓ · A ✓ — KvotesumV2Service.java:149-158; A: OppsummeringsCardNy.tsx:286 |
| `@OPT-BEH-BEH-036` | Saken får en automatisk mangeltekst når <vurdert av> vurderer at et kravelement ikke er oppfylt | funnet | P ✓ · A – — KOS:97-113,195-215; regelverk/kvalifisering/KvalifiserKravelementV4Service.java:58 |
| `@OPT-BEH-BEH-036` | Saken får ikke mangeltekst når søkeren er kvalifisert på en annen kravliste | funnet | P ✓ · A – — KOS:102-113; regelverk/kvalifisering/ManglendeKravBeregner.java:13-20 |
| `@OPT-BEH-BEH-036` | Saken får mangeltekster i alle kravlistene når søkeren ikke er kvalifisert på noen | funnet | P ✓ · A – — ManglendeKravBeregner.java:24-55; KOS:104-111 |
| `@OPT-BEH-BEH-036` | Mangelteksten viser kravelementene som ikke er oppfylt, ordnet etter kravlistene | usikker | P ~ · A ✓ — P/regelverk/kvalifisering/ManglendeKravTekstService.java:22-31,80-136 skriver OG/ELLER-strukturen, men ikke navnet på kravlisten som «Så» krever; fs-admin viser teksten som den er (A/SakDrawer/components/ManglerCard/AutomatiskMangel/AutomatiskMangel.tsx, !3421) |
| `@OPT-BEH-BEH-036` | De automatiske mangeltekstene slettes når <vurdert av> vurderer at søkeren er kvalifisert | funnet | P ✓ · A – — KOS:102-113,195-215; V368__soknadsmangel_view_og_manglende_krav.sql:29-34 |
| `@OPT-BEH-BEH-036` | Saksbehandleren ser de automatiske mangeltekstene sammen med de registrerte manglene | funnet | P ✓ · A ✓ — P-skjema/regelverk/kvalifisering.graphqls:143-149 → P/saksbehandling/KvalifikasjonsgrunnlagService.java:25-69; A/SakDrawer/components/ManglerCard/ManglerCard.tsx:74,217 viser AutomatiskMangel sammen med de registrerte manglene (!3421, merget 09:11 som e76a4e3fc) |
| `@OPT-BEH-BEH-036` | Søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet | funnet | P ✓ · A – · M ✓ (min-kompetanse main 066f8d6a, lest i GitLab: `src/components/soknadsmangel/fragment-soknad-mangler.ts` henter `Soknad.mangler` og `soknadsalternativer.mangler`, og `src/components/soknadsmangel/mangel-list.tsx` viser teksten) — P/autosak/FerdigbehandlingService.java:78 og P/saksbehandling/EndreStatusService.java:51-54 publiserer; V514:139-189 |
| `@OPT-BEH-BEH-036` | Søkeren ser ikke de automatiske mangeltekstene mens saken er under behandling | funnet | P ✓ · A – · M ✓ (min-kompetanse main 066f8d6a, lest i GitLab: `src/components/soknadsmangel/fragment-soknad-mangler.ts` henter `Soknad.mangler` og `soknadsalternativer.mangler`, og `src/components/soknadsmangel/mangel-list.tsx` viser teksten) — en ny tekst får status_kan_publiseres = false (KOS:205-208), og viewet tar bare med publiserte tekster (V514:176), så Min kompetanse får den ikke |
| `@OPT-BEH-BEH-036` | Søkeren ser mangeltekstene per søknadsalternativ | funnet | P ✓ · A – · M ✓ — viewet gir én rad per søknadsalternativ (V514:37-58,140-160), og min-kompetanse viser dem per utdanningstilbud (`src/components/soknad-dokumentasjon/_fragments/fragment-soknadskladd-kompetanseregelverk.ts:46-53`, `manglerByUtdanningstilbudId`) |
| `@OPT-BEH-BEH-036` | Søkeren ser ikke mangelteksten når søknadsalternativet er fjernet | usikker | P ~ · A – · M ✓ — søkeren ser den ikke: viewet tar bare med søknadsalternativer som ikke er slettet (V514:46-51). Men «saken har fortsatt den automatiske mangelteksten» holder ikke alltid: P/saksbehandling/KvalifikasjonsgrunnlagOppdateringService.java:103-122 sletter grunnlagsraden med teksten når kompetanseregelverket ikke brukes av saken lenger og grunnlaget har andre ønskede rader |
| `@OPT-BEH-BEH-036` | Saksbehandleren kan ikke endre en automatisk mangeltekst | funnet | P ✓ · A ✓ — ingen mutasjon skriver manglende_krav_* (bare KOS); A/SakDrawer/components/ManglerCard/AutomatiskMangel/AutomatiskMangel.tsx er skrivebeskyttet, uten knapper (!3421) |
| `@OPT-BEH-BEH-036` | Opptaksforvalteren merker mangelkoden for generell studiekompetanse som fullføres i vår | funnet | P ✓ · A ✓ — regelverk/MangeltypeService.java:52-53,95-98; fs-admin/src/domains/regelverk/features/Mangelkoder/MangelkodeDetails/MangelkodeDetails.tsx:413-423,212,226 |
| `@OPT-BEH-BEH-036` | Bare én mangelkode i regelverkssamlingen kan være merket for generell studiekompetanse som fullføres i vår | funnet | P ✓ · A ✓ — MangeltypeService.java:128-139; V503__soknadsmangeltype_gsk_fullfores_i_var.sql:14-16; MangelkodeDetails.tsx:233-236 |
| `@OPT-BEH-BEH-036` | Mangelkoden kan ikke merkes når den <avvik> | funnet | P ✓ · A ✓ — MangeltypeService.java:119-127 |
| `@OPT-BEH-BEH-036` | Opptaksforvalteren ser en advarsel på mangelkodene når ingen mangelkode er merket | funnet | P ✓ · A ✓ — fs-admin/src/domains/regelverk/features/Mangelkoder/MangelkoderOverview.tsx:30-38,53-56; mangel.graphqls:188-189 |
| `@OPT-BEH-BEH-036` | Sakene i søknadene som finnes fra før, får ikke mangelen når mangelkoden merkes | funnet | P ✓ · A – — MangeltypeService.java:52-53,95-98; SYNC:24-91; app/SoknadshendelseJobb.java:330-334 |
| `@OPT-BEH-BEH-036` | Saken får mangelen når søkeren endrer søknaden etter at mangelkoden er merket | funnet | P ✓ · A – — SoknadshendelseJobb.java:330-334; SYNC:45-91 |
| `@OPT-BEH-BEH-036` | Manglene som finnes fra før, blir stående når merkingen fjernes | funnet | P ✓ · A – — SYNC:25-40 |
| `@OPT-BEH-BEH-036` | Alle sakene i søknaden får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår | ikke funnet | P ~ · A – — ikke funnet etter kontrollen: mangelen settes (SYNC:62-91), men saksloggen viser ikke grunnen: P-mig/V480__stopp_endringslogg.sql fjernet audit-triggerne, og ingen kode skriver loggen. Finneren: SYNC:62-91 setter mangelen; finneren viste til audit-trigger V291 for saksloggen, men ingen grunn logges |
| `@OPT-BEH-BEH-036` | Saken får ikke mangel når ingen mangelkode er merket | ikke funnet | P ~ · A ✗ — SYNC:38-40 ✓, men varselet til opptaksforvalteren finnes ikke (søkt «varsel», «varsling», «notifikasjon», «ingen mangelkode», «ikke merket» i main, !6714, !3421) |
| `@OPT-BEH-BEH-036` | Opptaksforvalteren får varselet bare første gang | ikke funnet | P ✗ · A ✗ — ingen varsel finnes |
| `@OPT-BEH-BEH-036` | Søkeren ser den automatiske mangelen i Min kompetanse | usikker | P ~ · A – · M ✓ — mangelen settes med status_kan_publiseres = true (SYNC:82), og min-kompetanse viser manglene fra viewet. Men viewet tar bare med saker som er Under behandling eller Behandlet (V514:12-17), så søkeren ser ikke mangelen mens saken er Ikke behandlet. Kravet sier ikke når søkeren skal se den |
| `@OPT-BEH-BEH-036` | Søkeren får ikke egen melding om den automatiske mangelen | funnet | P ✓ · A – — SYNC:62-91; ManglerPublisering.java:28-54 |
| `@OPT-BEH-BEH-036` | Mangelen slettes når søkeren endrer søknaden | ikke funnet | P ~ · A – — ikke funnet etter kontrollen: SYNC:93-101 sletter mangelen, men saksloggen viser det ikke (V480). Finneren: SYNC:92-101; ingen grunn i saksloggen |
| `@OPT-BEH-BEH-036` | Mangel som er sjekket ut slettes ikke når søkeren endrer søknaden | funnet | P ✓ · A – — SYNC:100 |
| `@OPT-BEH-BEH-036` | Saksbehandleren kan ikke slette den automatiske mangelen | funnet | P – · A ✓ — fs-admin/src/domains/soknadsbehandling/features/SakDrawer/components/ManglerCard/Mangel/Mangel.tsx:146 (API avviser ikke: SakMangelService.java:56-58) |
| `@OPT-BEH-BEH-036` | Mangelen sjekkes ut når saken er behandlet helautomatisk | ikke funnet | P ~ · A – — ikke funnet etter kontrollen: utsjekkingen finnes (P/autosak/FerdigbehandlingService.java:69,222-236), men saksloggen viser det ikke (V480). Finneren: autosak/FerdigbehandlingService.java:63-70,222-235; saksloggen ikke sjekket |
| `@OPT-BEH-BEH-036` | Mangelen sjekkes ikke ut når saken ikke er behandlet helautomatisk | funnet | P ✓ · A – — FerdigbehandlingService.java:63-68 |
| `@OPT-BEH-BEH-029` | Sette saken til Behandlet fra <fra> når saken har <innhold> | funnet | P ✓ · A ✓ — fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/EndreStatusService.java:34-46,60-70; opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/sak.graphqls:34-40; fs-admin/src/domains/soknadsbehandling/hooks/useEndreBehandlingsstatus.ts:47-77 |
| `@OPT-BEH-BEH-029` | Saken kan ikke bli Behandlet uten mangel eller grunnlag | funnet | P ✓ · A ✓ — EndreStatusService.java:34-37; sak.graphqls:1117-1123; fs-admin/src/domains/soknadsbehandling/hooks/useEndreBehandlingsstatus.ts:57-58; fs-admin/src/common/messages/nb/soknadsbehandling.json:227 |
| `@OPT-BEH-BEH-029` | Saksloggen viser endring av behandlingsstatus når <årsak> | ikke funnet | `@deprecated` i denne kjøringen (teamet ønsker ikke saksloggen). P ✗ · A ~ — P-mig/V480__stopp_endringslogg.sql fjernet audit-triggerne, og ingen kode skriver saksloggen |
| `@OPT-BEH-BEH-026` | Kravelementene og poengene beregnes på nytt i en sak den automatiske behandlingen har behandlet | funnet | P ✓ · A ✓ — RKS:247-249 → P/autosak/AutomatiskSaksbehandlingService.java:282-292. NB status_automatisk_behandlet nullstilles når saksbehandleren endrer status (EndreStatusService.java:41-44) |
| `@OPT-BEH-BEH-026` | Kravelementet saksbehandleren har vurdert, beregnes ikke på nytt | funnet | P ✓ · A ✓ — P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:97-115; KvalifiseringKravelementV2OppdateringService.java:27-31,65-66 |
| `@OPT-BEH-BEH-026` | Poengene saksbehandleren har satt, beregnes ikke på nytt | funnet | P ✓ · A ✓ — P/regelverk/poeng/PoengService.java:47-55,62-71; AlgoritmepoengService.java:58-62 |
| `@OPT-BEH-BEH-026` | Poengsummen regnes ut på nytt i en sak saksbehandleren har behandlet | funnet | P ✓ · A ✓ — RKS:250-252; P/saksbehandling/PropageringService.java:101-116 |
| `@OPT-BEH-BEH-026` | Kravelementet saksbehandleren har vurdert, er uendret | funnet | P ✓ · A ✓ — RKS:250-252; KvalifiseringKravelementV2OppdateringService.java:65-66 |
| `@OPT-BEH-BEH-026` | Saken saksbehandleren har behandlet, får taggen "Regelverk endret" | funnet | P ✓ · A ✓ — RKS:252 → RegelverkEndretTagger.java:15,23-27 |
| `@OPT-BEH-BEH-026` | Saken den automatiske behandlingen har behandlet, får ikke taggen "Regelverk endret" | funnet | P ✓ · A ✓ — RKS:247-249 |
| `@OPT-BEH-BEH-026` | Saksbehandleren finner sakene med taggen "Regelverk endret" | funnet | P ✓ · A ✓ — fs-admin/src/domains/soknadsbehandling/features/SakOverviewView/components/filter/SakTaggFilter/SakTaggFilter.tsx:20-29 |
| `@OPT-BEH-BEH-026` | Saken er fortsatt ferdig behandlet etter at poengene er beregnet på nytt | funnet | P ✓ · A ✓ — RKS:233-259; AutomatiskSaksbehandlingService.java:291 |
| `@OPT-BEH-BEH-026` | En sak med behandlingsstatusen "<status>" beregnes ikke på nytt | funnet | P ✓ · A ✓ — RegelverksoppdateringUtvalg.java:38; RKS:243-245 |
| `@OPT-BEH-BEH-026` | Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet | funnet | P ✓ · A – · M ✓ — `Gitt` presisert til «den automatiske behandlingen har satt saken til ferdig behandlet». RKS:247-249 vurderer kravelementene på nytt i disse sakene; RKS:257 → ManglerPublisering.java:41-45 publiserer; V514:139-189; min-kompetanse viser teksten (fragment-soknad-mangler.ts, mangel-list.tsx) |
| `@OPT-BEH-BEH-026` | Den automatiske mangelteksten slettes når søkeren blir kvalifisert etter beregningen | funnet | P ✓ · A – · M ✓ — `Gitt` presisert som over. KvalifiseringOppdateringService.java:102-104,213-216 gir ingen tekst når søkeren er kvalifisert, og viewet tar ikke med rader uten tekst (V514:175) |
| `@OPT-BEH-BEH-033` | Jobbplanleggeren starter <jobb> | ikke funnet | P ~ · A – — Rad 1 saksbehandlertildelingen ✓ fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:96 (application.properties:92 = 30s). Rad 2 importen fra KREG ✓ KregImportJobb.java:84,89, men application.properties:110-111 = off som standard, på bare i application-platon-test.properties:20-21. Rad 3 importen av resultater fra høyere utdanning ✗ — ingen planlagt jobb; opptak-service/.../vitnemalsportalen/VitnemalsportalenService.java:38,57 har ingen kallere. Søkt etter «@Scheduled», «hoyere utdanning», «HuImport», «VitnemalsportalenService», personkompetanse, og i MR !6714. |
| `@OPT-BEH-BEH-034` | Vitnemålet er brukt i <bruk> | funnet | P ✓ · A – — P/saksbehandling/AnnullertVitnemaalService.java:55-69 (L133-141, L143-153, L156-163) |
| `@OPT-BEH-BEH-034` | Vitnemål som ikke er i bruk, endrer ikke saken | funnet | P ✓ · A – — AnnullertVitnemaalService.java:58-61 |
| `@OPT-BEH-BEH-034` | Alle sakene som bruker vitnemålet, blir merket | funnet | P ✓ · A – — AnnullertVitnemaalService.java:55-80, L165-171 |
| `@OPT-BEH-BEH-034` | Saken får taggen også når søkeren er med i en publisert plasstildelingsrunde | funnet | P ✓ · A ✓ — AnnullertVitnemaalService.java:68-69; fs-admin/src/domains/soknadsbehandling/features/SakOverviewView/components/SakOverviewTable/SakOverviewTable.tsx:186-191 |
| `@OPT-BEH-BEH-034` | Ferdig behandlet sak settes tilbake til Under behandling | funnet | P ✓ · A – — AnnullertVitnemaalService.java:178-196 |
| `@OPT-BEH-BEH-034` | Saken beholder statusen når søkeren er med i en publisert plasstildelingsrunde | funnet | P ✓ · A – — AnnullertVitnemaalService.java:186-195 |
| `@OPT-BEH-BEH-034` | Sak under behandling beholder statusen | funnet | P ✓ · A – — AnnullertVitnemaalService.java:185 |
| `@OPT-BEH-BEH-039` | Saksbehandleren velger vitnemålet saken behandles automatisk på | funnet | P ✓ · A ✓ — P/autosak/AutomatiskSaksbehandlingService.java:214-238; fs-admin/src/domains/soknadsbehandling/features/VitnemalsbehandlingSection/components/BehandleAutomatiskMedVitnemaalButton/BehandleAutomatiskMedVitnemaalButton.tsx:69-71 (!3415, merget 08:54 som 36446fbf5) |
| `@OPT-BEH-BEH-039` | Saken som er under behandling, behandles automatisk på vitnemålet saksbehandleren velger | funnet | P ✓ · A ✓ — P/autosak/AutomatiskSaksbehandlingService.java:214-238; fs-admin/src/domains/soknadsbehandling/features/VitnemalsbehandlingSection/components/BehandleAutomatiskMedVitnemaalButton/BehandleAutomatiskMedVitnemaalButton.tsx:69-71 (!3415, merget 08:54 som 36446fbf5) |
| `@OPT-BEH-BEH-039` | Grunnlag fra vitnemålet saksbehandleren har valgt | funnet | P ✓ · A – — P/autosak/SetteGrunnlagService.java:111,121-173; AutomatikkensVitnemaal.java:75-87 |
| `@OPT-BEH-BEH-039` | Vitnemålspoeng fra vitnemålet saksbehandleren har valgt | funnet | P ✓ · A – — P/regelverk/poeng/AutomatiskPoengberegningService.java:125; AutomatikkensVitnemaal.java:96-100 |
| `@OPT-BEH-BEH-039` | Kravelementene vurderes mot vitnemålet saksbehandleren har valgt | funnet | P ✓ · A – — P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:250 (kommentaren «Ikke bygget i dag» i kravet er utdatert) |
| `@OPT-BEH-BEH-039` | Sammensatt vitnemål gir ikke grunnlaget som krever førstegangsvitnemål | ikke funnet | P ✗ · A ✗ — Ingen sammensatt vitnemål i koden; SetteGrunnlagService.java:134,173 bruker foerstegangsvm. Søkt «sammensatt», «VPL», «23/5», SAM/KOMB i main, !3415, !6714 |

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen fra vitnemålet som er importert fra KREG | ikke funnet | P – · A – — fasen er ikke levert. Ikke levert: `@OPT-BEH-BEH-015` «Automatikken kan sette en ny konklusjon etter annulleringen» (automatisk_gsk_konklusjon.feature:462), ikke funnet i koden: `P/autosak/gsk/GskVedtakAutoService.java:69-71` stopper på en annullert konklusjon (`KVALIFISERT_MEN_ANNULLERT`). Overleveringen selv finnes: `P/autosak/KregImportService.java:98` → `GskKonklusjonEtterImportService` |
| `@FLY-OPT-AUT-001` | Saken får mangeltekst for kravelementet vitnemålet ikke oppfyller | ikke funnet | P – · A – — fasen er ikke levert. Ikke levert: `@OPT-BEH-BEH-036` «Mangelteksten viser kravelementene som ikke er oppfylt, ordnet etter kravlistene» (automatiske_mangler.feature:71), usikker: navnet på kravlisten skrives ikke (`P/regelverk/kvalifisering/ManglendeKravTekstService.java:22-31`); «Saksbehandleren ser de automatiske mangeltekstene sammen med de registrerte manglene» (:92), funnet etter at !3421 ble merget 09:11 (`A/SakDrawer/components/ManglerCard/ManglerCard.tsx:217`), men uten statustag; «Søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet» (:98), usikker: fs-plattform publiserer, Min kompetanse ikke sjekket |
| `@FLY-OPT-AUT-001` | Saken med mangelen for GSK som fullføres i vår blir ferdig behandlet | ikke funnet | P – · A – — fasen er ikke levert. Ikke levert: `@OPT-BEH-BEH-036` «Alle sakene i søknaden får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår» (automatiske_mangler.feature:227), ikke funnet: saksloggen viser ikke grunnen (V480); «Saken får ikke mangel når ingen mangelkode er merket» (:234), ikke funnet: varselet til opptaksforvalteren finnes ikke; «Opptaksforvalteren får varselet bare første gang» (:240), ikke funnet; «Søkeren ser den automatiske mangelen i Min kompetanse» (:246), usikker: vises ikke mens saken er ubehandlet (`P-mig/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:16-20`); «Mangelen slettes når søkeren endrer søknaden» (:257), ikke funnet: saksloggen (V480); «Mangelen sjekkes ut når saken er behandlet helautomatisk» (:279), ikke funnet: utsjekkingen finnes (`P/autosak/FerdigbehandlingService.java:69,222-236`), men ikke saksloggen |
| `@FLY-OPT-VIT-001` | Importen starter når jobbplanleggeren kjører jobben | ikke funnet | P – · A – — fasen er ikke levert. Ikke levert: `@OPT-BEH-BEH-033` er `@planned`, og «Jobbplanleggeren starter <jobb>» (kjøre_jobbene_i_opptak.feature:30) er ikke funnet: raden «importen av resultater fra høyere utdanning» har ingen jobb. KREG-jobben finnes (`P-app/KregImportJobb.java:84,89`), men er av i produksjon |
| `@FLY-OPT-VAL-001` | Saken er ferdig behandlet på det valgte vitnemålet | ikke funnet | P ✓ · A – — fasen er ikke levert. Ikke levert: `@FLY-OPT-AUT-001` er `@planned` (6 av 17 faser mangler), og regelen «Grunnlaget, poengene og kravelementene avgjøres på vitnemålet saksbehandleren har valgt» i `@OPT-BEH-BEH-039` er ikke levert fordi «Sammensatt vitnemål gir ikke grunnlaget som krever førstegangsvitnemål» (:93) ikke er funnet. De tre andre scenarioene i regelen er levert (`@implemented`). Overleveringen finnes i koden: lages: `P/autosak/AutomatiskSaksbehandlingService.java:214-238` (valget lagres) · brukes: `P/autosak/AutomatikkensVitnemaal.java:70-88` (valget tas først) → `P/autosak/SetteGrunnlagService.java:111-131`, `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:249-250`, `P/autosak/FerdigbehandlingService.java:89-103` |
| `@FLY-OPT-SAM-001` | Saksbehandleren setter sammen et vitnemål av fag fra flere dokumenter | ikke funnet | P ✗ · A ✗ — mangler krav. Sammensatt vitnemål finnes ikke i koden: søkt etter «sammensatt», «sammensett», «VPL» i fs-plattform/opptak og fs-admin/src, og i MR !3415 |
| `@FLY-OPT-SAM-001` | Det sammensatte vitnemålet er ikke et førstegangsvitnemål | ikke funnet | P ✗ · A ✗ — mangler krav. Sammensatt vitnemål finnes ikke i koden |
| `@FLY-OPT-SAM-001` | Det sammensatte vitnemålet har bare resultater søkeren har | ikke funnet | P ✗ · A ✗ — mangler krav. Sammensatt vitnemål finnes ikke i koden |
| `@FLY-OPT-SAM-001` | Saken behandles automatisk på det sammensatte vitnemålet | ikke funnet | P ✗ · A ✗ — fasen er ikke levert. Ikke levert: `@OPT-BEH-BEH-039` «Saken behandles automatisk på et sammensatt vitnemål» (:54) er `@draft @openquestion`. I koden må vitnemålet være et VM fra KREG: `P/autosak/AutomatiskSaksbehandlingService.java:225-238` |
| `@FLY-OPT-SAM-001` | Søknaden på det sammensatte vitnemålet får ikke grunnlaget som krever førstegangsvitnemål | ikke funnet | P ✗ · A – — fasen er ikke levert. Ikke levert: `@OPT-BEH-BEH-039` «Sammensatt vitnemål gir ikke grunnlaget som krever førstegangsvitnemål» (:93), ikke funnet. Grunnlaget leser `foerstegangsvm` (`P/autosak/SetteGrunnlagService.java:133,176`), men det finnes ikke noe sammensatt vitnemål |
| `@FLY-OPT-SAM-001` | Saken er ferdig behandlet på det sammensatte vitnemålet | ikke funnet | P ✗ · A – — fasen er ikke levert. Ikke levert: `@FLY-OPT-AUT-001` er `@planned`. Ferdigbehandlingen krever VM med `gsk_ok` fra KREG (`P/autosak/FerdigbehandlingService.java:99-103`) |
| `@FLY-OPT-AUT-001` | Vitnemålet fra KREG er klart for behandlingen når saken er opprettet | funnet | P ✓ · A – — lages: `P-app/SoknadshendelseJobb.java:330-339` · brukes: `P-app/SoknadshendelseJobb.java:132-140,409-411` → `P/vgs/HentVgsVitnemaalService.java:103-124,218-228` |
| `@FLY-OPT-AUT-001` | Saken behandles automatisk når vitnemålet er importert | funnet | P ✓ · A – — lages: `P/autosak/KregImportService.java:74-76` · brukes: `P/autosak/KregImportService.java:93,109-110` → `P/autosak/AutomatiskBehandlingEtterImportService.java:70-93,108-111` |
| `@FLY-OPT-AUT-001` | Søknaden uten GSK-konklusjon får konklusjonen i kjøringen | funnet | P ✓ · A – — lages: `P/vgs/KregVgsParser.java:104` · brukes: `P/autosak/AutomatiskSaksbehandlingService.java:135-136,240-247` → `P/autosak/gsk/GskVedtakAutoService.java:68-84,268-269,302-306` |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk på vitnemålet som gir GSK | funnet | P ✓ · A – — lages: `P/autosak/AutomatiskSaksbehandlingService.java:170,214-223` · brukes: `P/autosak/SetteGrunnlagService.java:111-131`, `P/autosak/FerdigbehandlingService.java:89-103` |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk når søkeren har to identiske vitnemål | funnet | P ✓ · A – — lages: `P/vgs/HentVgsVitnemaalService.java:190-211` (begge vitnemålene importeres) · brukes: `P/autosak/AutomatikkensVitnemaal.java:108-116,168-197` (`velgBlantIdentiske` velger ett) → `P/autosak/FerdigbehandlingService.java:89-103` |
| `@FLY-OPT-AUT-001` | Saken får grunnlag | funnet | P ✓ · A – — lages: `P/autosak/AutomatiskSaksbehandlingService.java:170,214-223` · brukes: `P/autosak/SetteGrunnlagService.java:111-133,186-204` |
| `@FLY-OPT-AUT-001` | Søknadsalternativet får poengsum | funnet | P ✓ · A – — lages: `P/autosak/SetteGrunnlagService.java:186-204` · brukes: `P/saksbehandling/PropageringService.java:105-108` → `P/regelverk/poeng/AutomatiskPoengberegningService.java:41-115` |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoengene for grunnlaget | funnet | P ✓ · A – — lages: `P/autosak/SetteGrunnlagService.java:186-204` (grunnlaget, kalt i `P/autosak/AutomatiskSaksbehandlingService.java:173-174`) · brukes: `P/autosak/AutomatiskSaksbehandlingService.java:179` → `P/saksbehandling/PropageringService.java:107-110` (poengradene fra grunnlaget, og `beregnAlgoritmepoengIsolert`) → `P/regelverk/poeng/AlgoritmepoengService.java:34-46`. Lest av lead-en etter avklaringen, ikke kontrollert av `fs-verify-kontroll` |
| `@FLY-OPT-AUT-001` | Kravelementet er vurdert mot vitnemålet | funnet | P ✓ · A – — lages: `P/regelverk/kvalifisering/KvalifiseringKravelementV2OppdateringService.java:41-90` · brukes: `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:100-116,180-198` |
| `@FLY-OPT-AUT-001` | Kvotespørsmålet er besvart automatisk | funnet | P ✓ · A – — lages: `P/saksbehandling/SoknadKvoteOppretterService.java:58-64` · brukes: `P/autosak/KvotesporsmalAlgoritmeService.java:64-76,131-165,228-254` |
| `@FLY-OPT-AUT-001` | Søkeren er kvalifisert når vitnemålet oppfyller kravelementene | funnet | P ✓ · A – — lages: `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:180-190` · brukes: `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:152-156,194-205` |
| `@FLY-OPT-AUT-001` | Den kvalifiserte søkeren plasseres i kvoten grunnlaget er koblet til | funnet | P ✓ · A – — lages: `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:204` · brukes: `P/saksbehandling/SoknadKvoteOppretterService.java:270-278`, `P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:142-170` |
| `@FLY-OPT-AUT-001` | Søkeren plasseres i kvoten når kvotespørsmålet er besvart ja automatisk | funnet | P ✓ · A – — lages: `P/autosak/KvotesporsmalAlgoritmeService.java:228-254` · brukes: `P/saksbehandling/KvotesporsmalSvarService.java:355-384` |
| `@FLY-OPT-AUT-001` | Søkeren har poengsum i kvoten | funnet | P ✓ · A – — lages: `P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:162-165` · brukes: `P/regelverk/poeng/PoengsumService.java:66-87` |
| `@FLY-OPT-AUT-001` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | funnet | P ✓ · A – — lages: `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:204` (kvalifiseringen), `P/regelverk/poeng/PoengsumService.java:66-87` (poengsummen) og `P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:142-170` (kvoten) · brukes: `P/autosak/FerdigbehandlingService.java:63-80,106-118` (alt avgjort gir `BEHANDLET`), kalt fra `P/autosak/AutomatiskSaksbehandlingService.java:204`. Lest av lead-en, ikke kontrollert av `fs-verify-kontroll` |
| `@FLY-OPT-AUT-001` | Søkeren ser mangelteksten fra kravelementene når saken er ferdig behandlet | funnet | P ✓ · A – — lages: `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:195-215` (mangelteksten på grunnlaget) · brukes: `P/autosak/FerdigbehandlingService.java:78` → `P/saksbehandling/ManglerPublisering.java:28-54` (publiserer) → `P-mig/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:139-189` (viewet `soknadsmangel`) → min-kompetanse `src/components/soknadsmangel/mangel-list.tsx`. Lest av lead-en, ikke kontrollert av `fs-verify-kontroll` |
| `@FLY-OPT-AUT-001` | Poengene beregnes på nytt når rangeringsregelverket er rettet | funnet | P ✓ · A ✓ — lages: `A/RegelverksoppdateringButton/RegelverksoppdateringButton.tsx` (opptaksforvalteren starter beregningen for regelverket som er rettet) · brukes: `P-app/RegelverksoppdateringPoller.java:49` → `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringKjoringService.java:132-188,233-259` → `P/autosak/AutomatiskSaksbehandlingService.java:282-292` (poengene og poengsummen på nytt), og statusen endres ikke. Bekreftet av kontrollen for 026, ikke kontrollert som overlevering |
| `@FLY-OPT-VIT-001` | Vitnemålene hentes for den aktive søkeren | funnet | P ✓ · A – — lages: `P/saksbehandling/KregImportKjoringService.java:70-89` · brukes: `P-app/KregImportJobb.java:129-136,159-166` → `P/vgs/HentVgsVitnemaalService.java:147-153,186-207` |
| `@FLY-OPT-VIT-001` | Nytt vitnemål i KREG importeres | funnet | P ✓ · A – — lages: `P/vgs/KregVgsParser.java:104` · brukes: `P/vgs/VgsLagringService.java:42-53,103` |
| `@FLY-OPT-VIT-001` | Det nye vitnemålet får opptakssystemets påstand om GSK | funnet | P ✓ · A – — lages: `P/vgs/VgsLagringService.java:103` · brukes: `P/vgs/HentVgsVitnemaalService.java:207,218-228` → `P/autosak/gsk/GskPaastandService.java:29-42` |
| `@FLY-OPT-VIT-001` | Hver søknad med sak får GSK-konklusjonen | funnet | P ✓ · A – — lages: `P/autosak/KregImportService.java:74-76` · brukes: `P/autosak/KregImportService.java:93-98` → `P/autosak/gsk/GskKonklusjonEtterImportService.java:50-64,97-99` |
| `@FLY-OPT-VIT-001` | Søknaden uten sak får ingen GSK-konklusjon fra importen | funnet | P ✓ · A – — lages: `P/autosak/KregImportService.java:74-76` · brukes: `P/autosak/gsk/GskKonklusjonEtterImportService.java:53,77-86` |
| `@FLY-OPT-VIT-001` | Saken importen har hentet vitnemålet til, blir behandlet automatisk | funnet | P ✓ · A – — lages: `P/autosak/KregImportService.java:66-67,74-76` · brukes: `P/autosak/KregImportService.java:109-110` → `P/autosak/AutomatiskBehandlingEtterImportService.java:70-93,134-144` |
| `@FLY-OPT-VIT-001` | Vitnemålet som er annullert etter importen, blir annullert | funnet | P ✓ · A – — lages: `P/vgs/VgsLagringService.java:52-63` · brukes: `P/autosak/KregImportService.java:76,131-134` → `P/saksbehandling/AnnullertVitnemaalService.java:24-29,49-70` |
| `@FLY-OPT-VIT-001` | Den ferdig behandlede saken settes tilbake når vitnemålet blir annullert | funnet | P ✓ · A – — lages: `P/vgs/VgsLagringService.java:52-63` · brukes: `P/saksbehandling/AnnullertVitnemaalService.java:66-70,178-196` |
| `@FLY-OPT-VAL-001` | Saken behandles automatisk på vitnemålet saksbehandleren velger | funnet | P ✓ · A ✓ — lages: `fs-admin/src/domains/soknadsbehandling/features/VitnemalsbehandlingSection/components/BehandleAutomatiskMedVitnemaalButton/BehandleAutomatiskMedVitnemaalButton.tsx:69-71` · brukes: `P-skjema/saksbehandling/automatisk-saksbehandling.graphqls:54,205`, `P/autosak/AutomatiskSaksbehandlingService.java:214-238` |

## Åpne spørsmål

Hvor mange regler og scenarioer i hvert krav som har `@openquestion`. Spørsmålene stopper ikke leveransen, men står i testplanen til de er besvart.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling | 0 av 18 | 0 av 20 | 0 |
| `@FLY-OPT-VIT-001` | Importere VGS-vitnemål fra KREG | 0 av 7 | 0 av 9 | 0 |
| `@FLY-OPT-VAL-001` | Automatisk saksbehandling på vitnemålet saksbehandleren velger | 0 av 2 | 0 av 2 | 0 |
| `@FLY-OPT-SAM-001` | Automatisk saksbehandling på sammensatt vitnemål | 1 av 4 | 3 av 6 | 0 |

Fasen med `@wont` i `@FLY-OPT-AUT-001` (dobbeltrangering etter 23/5-regelen) har `@openquestion`, men er holdt utenfor gating-settet og ikke telt med.

## Åpne MR-er og brancher

MR-er og brancher som ser ut til å levere kravene. Koden i disse er ikke merget, og regnes ikke som levert.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | [!6714 Hent vitnemål fra KREG via supergrafen](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6714) (`solov/kreg-via-supergraf`) | utkast | `@OPT-BEH-BEH-030`, `@FLY-OPT-VIT-001` | 0 (endrer bare hvordan KREG kalles) | 71 commits bak main |

Merget nylig, og regnet som levert (på main): fs-admin !3421 (vis automatiske mangeltekster og advar før Behandlet, merget 2026-11-13 09:11; skriver ingen sakslogg), fs-admin !3415 (behandle automatisk med valgt vitnemål, merget 2026-11-13 08:54, etter starten på kjøringen; innholdet er det samme som ble kontrollert på branchen); fs-plattform !6741 (automatisk saksbehandling på valgt eller identiske vitnemål), !6728 (publiser manglene når saken blir behandlet), !6718, !6691, !6690, !6678, !6663, !6654; fs-admin !3405, !3395, !3375, !3373, !3372.

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Kravet er bak koden | `@FLY-OPT-AUT-001` | «Kjent brudd» i beskrivelsen (`krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature:29-35`) | Alle fire kjente brudd er rettet på main: manglene publiseres når saken blir ferdig behandlet (`P/autosak/FerdigbehandlingService.java:78`), påstanden om GSK beregnes og lagres på vitnemålet ved import (`P/vgs/HentVgsVitnemaalService.java:218-228` → `P/autosak/gsk/GskPaastandService.java:29-40`), uenighet stopper ikke og vises som varsel (`P/autosak/gsk/GskKonklusjonEvaluator.java:58-76`, `A/VitnemalsbehandlingSection/VitnemalsbehandlingSection.tsx:86,111,172-174`), og behandlingen starter etter importen (`P/autosak/KregImportService.java:109-110`). Fjern kommentarene med `fs-krav` |
| Kravet er bak koden | `@OPT-BEH-BEH-027` | Kommentaren under «Løp uten grunnlagskode i listen over løp» (`beregne_gsk_fra_vitnemål.feature:385-387`) | «Kode i dag: bare når saksbehandleren starter kontrollen» er utdatert: påstanden beregnes ved import (`P/vgs/HentVgsVitnemaalService.java:210,221-234`) |
| Kravet er bak koden | `@OPT-BEH-BEH-039` | Kommentaren «Ikke bygget i dag» (`behandle_automatisk_på_valgt_vitnemål.feature:86`) | Utdatert etter !6741: `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:249-251` |
| Kontrollen endret | `@OPT-BEH-BEH-025` | «Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet» | funnet → usikker: fs-plattform publiserer (`P/autosak/FerdigbehandlingService.java:78`), men `Så` sier at søkeren ser manglene i Min kompetanse, og min-kompetanse er ikke med i kjøringen |
| Kontrollen endret | `@OPT-BEH-BEH-026` | «Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet» | funnet → usikker: Min kompetanse er ikke sjekket, og scenarioet stemmer bare for saker den automatiske behandlingen har behandlet |
| Kontrollen endret | `@OPT-BEH-BEH-026` | «Den automatiske mangelteksten slettes når søkeren blir kvalifisert etter beregningen» | funnet → usikker: samme grunn |
| Kontrollen endret | `@OPT-BEH-BEH-031` | «Uendret poengsum gir ikke nytt innslag i endringsloggen» | funnet → usikker: beviset viste til audit-triggerne i V291, men `P-mig/V480__stopp_endringslogg.sql` fjernet dem. Scenarioet stemmer bare fordi ingenting logges |
| Kontrollen endret | `@OPT-BEH-BEH-036` | «Alle sakene i søknaden får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår» | usikker → ikke funnet: finneren viste til audit-triggeren i V291 for saksloggen, men `P-mig/V480__stopp_endringslogg.sql` fjernet den, og ingen kode skriver loggen |
| Kontrollen endret | `@OPT-BEH-BEH-036` | «Mangelen slettes når søkeren endrer søknaden» | usikker → ikke funnet: samme grunn |
| Kontrollen endret | `@OPT-BEH-BEH-036` | «Mangelen sjekkes ut når saken er behandlet helautomatisk» | usikker → ikke funnet: samme grunn |
| Kontrollen endret | `@OPT-BEH-BEH-030` | «Resultatene hentes når søkeren sender inn søknaden» | beviset rettet: innsendingen går gjennom `P/soknad/StudiekurvService.java:824` → `:962`, ikke `:578`. Resultatet er det samme |
| Åpent spørsmål | `@FLY-OPT-SAM-001` | «Saksbehandleren setter sammen et vitnemål i vitnemålsbehandleren» (`automatisk_saksbehandling_på_sammensatt_vitnemål.feature:16`) | Kravet mangler. Hvordan settes et sammensatt vitnemål sammen? Må OPT-BEH-BEH-022 endres? Får det sammensatte vitnemålet påstanden om GSK? |
| Bygger på krav som ikke er levert | `@FLY-OPT-AUT-001` | – | bygger på `@FLY-OPT-SAK-001` (`@planned`) |
| Bygger på krav som ikke er levert | `@FLY-OPT-VAL-001` | – | bygger på `@OPT-BEH-BEH-039` (`@in-progress`) og `@FLY-OPT-AUT-001` (`@planned`) |
| Bygger på krav som ikke er levert | `@FLY-OPT-SAM-001` | – | bygger på `@OPT-BEH-BEH-039` (`@in-progress`) og `@FLY-OPT-AUT-001` (`@planned`) |
| Ikke sjekket | – | min-kompetanse | Klonen finnes ikke lokalt. Scenarioene der søkeren ser noe i Min kompetanse (025, 026 og 036), er sjekket i GitLab etterpå (fs/min-kompetanse, main 066f8d6a). Delen i min-kompetanse finnes for alle. Det som fortsatt er usikkert, gjelder fs-plattform eller kravteksten |
| Merknad | `@OPT-BEH-BEH-039` | – | Delvis levert, men ikke i en spesifikasjon — hent det inn med `fs-specify`. Scenarioet «Saken som er under behandling, behandles automatisk …» har `@depends-on-OPT-BEH-BEH-029`, som er `@in-progress` |
| Merknad | `@FLY-OPT-VIT-001` | Fasen «Jobbplanleggeren starter importen av VGS-vitnemål fra KREG» | Ankeret peker på hele regelen i `@OPT-BEH-BEH-033` (`kjøre_jobbene_i_opptak.feature:27`), også raden «importen av resultater fra høyere utdanning», som ikke angår KREG. KREG-jobben finnes (`P-app/KregImportJobb.java:84,89`). Vurder med `fs-krav` om fasen bare skal bygge på KREG-raden |
| Merknad | `@FLY-OPT-VIT-001` | Den daglige importen fra KREG | Av som standard: `fs-plattform/opptak/opptak-subgraph/src/main/resources/application.properties:110-111` (cron=off), og bare på i `application-platon-test.properties:20-21`. Koden finnes, men importen kjører ikke i produksjon. Gjelder også `@OPT-BEH-BEH-015`, `-030`, `-032` og `-033` |
| Merknad | `@FLY-OPT-VIT-001` | «Vitnemålene hentes for den aktive søkeren» | Koden regner en søker som aktiv når søkeren har en aktiv sak i et publisert opptak (`P/saksbehandling/KregImportKjoringService.java:70-89`), ikke «en søknad som ikke er trukket». En søknad uten sak får vitnemålet når tildelingen oppretter saken |
| Merknad | `@FLY-OPT-SAM-001` | Fasen «Saksbehandleren starter den automatiske behandlingen på det sammensatte vitnemålet» | Ankeret står på et `@draft @openquestion`-scenario i `@OPT-BEH-BEH-039` (`:54`), så fasen kan ikke bli levert før scenarioet er avklart |
| Merknad | `@OPT-BEH-BEH-015` | «Konklusjon i avsluttet opptak trekkes ikke tilbake» | Sakene i avsluttede opptak får likevel taggen «Vitnemål annullert» (`P/saksbehandling/AnnullertVitnemaalService.java:55-62`), mot regelkommentaren «står saken urørt» |
| Merknad | `@OPT-BEH-BEH-026` | Kommentaren under «I saker den automatiske behandlingen har behandlet …» (`beregne_automatisk_på_nytt.feature:80-82`) | Kravet regner saken som automatisk behandlet når automatikken har kjørt på den. Koden bruker `status_automatisk_behandlet`, som bare betyr at automatikken satte saken til ferdig behandlet (`P-mig/V522__sak_status_automatisk_behandlet_betyr_ferdig.sql:8`), og som nullstilles når saksbehandleren endrer statusen (`P/saksbehandling/EndreStatusService.java:41-44`). Kravet eller koden bør rettes |
| Merknad | `@OPT-BEH-BEH-029` | Saksloggen etter !3421 | fs-admin !3421 (merget 09:11) henter endringsloggen på nytt etter en statusendring (`A/.../useEndreBehandlingsstatus.ts`), men ingen kode skriver nye rader etter V480, så «Saksloggen viser endring av behandlingsstatus når <årsak>» er fortsatt ikke funnet |
| Merknad | `@OPT-BEH-BEH-031` | Endringsloggen i saksbehandling | `P-mig/V480__stopp_endringslogg.sql` (BAT-324) stoppet endringsloggen. Det gjelder alle krav som viser til den (f.eks. `@OPT-BEH-BEH-012`, `-016`, `-029`, `-036`), og kommentarene i `P/regelverk/poeng/PoengsumService.java:65,392` er utdatert |
| Merknad | `@FLY-OPT-VIT-001` | Kommentaren under «Den automatiske GSK-konklusjonen startes for hvert opptak der søkeren har en sak» (`importere_vgs_vitnemål_fra_kreg.feature:75-76`) | «Behandlingsstatusen på saken spiller ingen rolle» er utdatert: `@OPT-BEH-BEH-015` ble avklart 11.11.2026, og importen setter ingen konklusjon når en av søkerens saker i opptaket er ferdig behandlet (`P/autosak/gsk/GskVedtakAutoService.java:104-106`). Rett kommentaren med `fs-krav` |
| Merknad | `@FLY-OPT-VAL-001` | Mutationen med `vitnemaalId` og knappen | Mutationen ligger i experimental-skjemaet (`P-skjema/saksbehandling/automatisk-saksbehandling.graphqls:205`), ikke i produksjonskontrakten, og knappen i fs-admin er bak flagget `automatisk-soknadsbehandling-trigger` (på i test, review og utvikling) |
| Merknad | `@OPT-BEH-BEH-036` | «Saksbehandleren kan ikke slette den automatiske mangelen» | fs-admin skjuler knappen (`A/SakDrawer/components/ManglerCard/Mangel/Mangel.tsx:146`), men API-et avviser ikke slettingen (`P/saksbehandling/SakMangelService.java:56-58`), mot felleskravet om at regelen også gjelder i API-et |
| Merknad | `@OPT-BEH-BEH-036` | «Søkeren ser ikke mangelteksten når søknadsalternativet er fjernet» | `P/saksbehandling/KvalifikasjonsgrunnlagOppdateringService.java:104-122` kan slette grunnlagsraden med teksten, mot «saken har fortsatt den automatiske mangelteksten» |
| Merknad | `@FLY-OPT-AUT-001` | Fasen med `@wont` | «Søknaden dobbeltrangeres automatisk etter 23/5-regelen» er holdt utenfor gating-settet (MoSCoW Won't, utenfor scope i første fase) |
