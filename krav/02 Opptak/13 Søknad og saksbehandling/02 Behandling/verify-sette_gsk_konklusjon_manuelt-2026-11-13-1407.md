# Verifisering: Sette GSK-konklusjon manuelt

- **Dato:** 2026-11-13 14:07
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/sette_gsk_konklusjon_manuelt.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, a6a60fc203, oppdatert), `fs-admin` (main, 84200673f6, oppdatert)
- **Repoer:** P = fs-plattform, A = fs-admin · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** ingen funnet
- **Omfang:** alle krav uansett status, uten retagging (fra prompten)
- **Avhengigheter:** ingen
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei (fra prompten)

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `SERV` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/gskvedtak/GskVedtakService.java`
- `COND` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/gskvedtak/GskVedtakConditions.java`
- `AUTO` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/GskVedtakAutoService.java`
- `TIDL` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/TidligereGskKonklusjonService.java`
- `GQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/gsk.graphqls`
- `SOKN` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/soknad/soknad.graphqls`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `CARD` = `fs-admin/src/domains/soknadsbehandling/features/GSKCard/GSKCard.tsx`
- `UTIL` = `fs-admin/src/domains/soknadsbehandling/features/GSKCard/utils/gskUtils.ts`
- `HIST` = `fs-admin/src/domains/soknadsbehandling/features/GSKCard/components/GSKHistory.tsx`
- `DIALOG` = `fs-admin/src/domains/soknadsbehandling/features/GSKCard/components/GSKConfirmDialog.tsx`
- `KANS` = `fs-admin/src/domains/soknadsbehandling/hooks/useKanSaksbehandle.ts`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 9 funnet, 17 ikke funnet, 3 usikker, av 29
- Mangler: fs-plattform 18 scenarioer, fs-admin 19 (fs-plattform 8 usikker, fs-admin 2 usikker)
- Forslag: 0 kan leveres, 1 delvis levert, 0 kan slettes, 1 kan leveres når det er avklart, 1 blir stående
- Tilgang og datakonsistens: 4 stemmer, 3 avviker, 0 ikke funnet, 0 usikker, av 8 (1 ikke beskrevet)
- Regler i koden uten scenario: 10
- Åpne spørsmål: 0 regler og 0 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Delvis levert**

- `@OPT-BEH-BEH-042` — Sette GSK-konklusjon manuelt (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/sette_gsk_konklusjon_manuelt.feature`, 9/29 funnet): `@planned` → `@in-progress`, og `@implemented` på Scenario: Sette GSK-konklusjon (linje 57), Scenario: Konklusjonen viser hvem som satte den (linje 68), Scenario: Endre grunnlagskoden (linje 104), Scenario: Endre en konklusjon som er satt automatisk (linje 110), Scenario: Saksbehandleren angrer endringen (linje 123), Scenario: En konklusjon som er gjenbrukt fra et historisk opptak, endres bare i det nye opptaket (linje 135), Scenario: Konklusjonen satt av én organisasjon vises for en annen (linje 173), Scenario: Se hvem som endret konklusjonen (linje 181) `[P ✓ · A ✓]`. «Ingen negativ konklusjon når søknaden ikke har noen konklusjon» (linje 88) er funnet, men kontrollen var uenig, så den er ikke med her.

**Kan leveres når det er avklart**

- `@OPT-BEH-BEH-042` — Scenario: Ingen negativ konklusjon når søknaden ikke har noen konklusjon (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/sette_gsk_konklusjon_manuelt.feature:88`): kan få `@implemented` sammen med de andre under *Delvis levert* hvis raden bekreftes — kontrollen foreslo `ikke funnet`, men `fs-admin/…/GSKCard.tsx:331` og `:410` viser valget og knappen for avslag bare når det finnes en konklusjon `[P ✓ · A ✓]`

**Blir stående**

- `@OPT-BEH-BEH-042` — Sette GSK-konklusjon manuelt (`@planned`, 9/29 funnet): annullering finnes ikke i fs-admin, og annulleringsreglene i fs-plattform er andre enn i kravet (vilkåret om annullert vitnemål, ingen regel for hvem som kan annullere, ingen begrunnelse). Saksbehandleren kan sette negativ konklusjon ved endring. Låsen følger flagget `er_laast`, ikke statusen på opptaket. Tidligere konklusjoner tar med opptak som pågår og ikke gjenbruksbasen. Grunnlagsdatoen settes av klienten og beholdes ved endring. GSK-kortet følger ikke den nye skissen (se `## Andre funn`) · mangler i fs-plattform (18), fs-admin (19)

## Endringer

Det som er endret i kravfilene og i resultatet: i kjøringen (det sikre, når brukeren sa ja) og i gjennomgangen av rapporten.

Ingen endringer. Brukeren valgte ingen retagging i denne kjøringen.

## Oversikt per krav

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | Sette GSK-konklusjon manuelt | 9/29 | 18 (8 usikker) | 19 (2 usikker) | Annullering med nye regler og dialog, ingen negativ konklusjon ved endring, lås fra opptaksstatus, grunnlagsdato fra fs-plattform, tidligere konklusjoner fra historiske opptak og gjenbruksbasen, og GSK-kortet etter skissen |

Mangler: fs-plattform 18 scenarioer i 1 krav, fs-admin 19 i 1 krav (10 usikker). 0 av 1 krav er funnet i alle repoene.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P` og `A` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | Annullere en automatisk konklusjon når søkeren ikke har generell studiekompetanse | ikke funnet | P ~ · A ✗ — fs-plattform annullerer bare gjennom endre med KVALIFISERT_MEN_ANNULLERT, og krever at vitnemålet er annullert (`SERV:462-483`). fs-admin har ingen knapp eller dialog for annullering. Søkt etter «annuller», «annulleringsarsak» og «gskAnnuller» i fs-admin `src` |
| `@OPT-BEH-BEH-042` | Ingen negativ konklusjon når konklusjonen endres | ikke funnet | P ✗ · A ✗ — endre tillater IKKE_KVALIFISERT med mangeltype (`SERV:433-460`). fs-admin viser «Årsak til avslag» og «Ikke kvalifisert» når det finnes en konklusjon (`CARD:331-342`, `CARD:410-423`) |
| `@OPT-BEH-BEH-042` | Grunnlagsdatoen følger den siste endringen | ikke funnet | P ~ · A ✗ — fs-admin sender den gamle grunnlagsdatoen ved endring (`CARD:260`, `grunnlagsdato ?? todayAsString()`). fs-plattform lagrer datoen klienten sender (`SERV:556`) |
| `@OPT-BEH-BEH-042` | Konklusjonen kan ikke endres i et historisk opptak | ikke funnet | P ✗ · A ✗ — de manuelle mutasjonene sjekker bare `er_laast` (`SERV:445-448`). Opptaksstatus ARKIVERT sjekkes bare i automatikken (`AUTO:288`). fs-admin deaktiverer knappene ut fra `erLaast` (`CARD:197`, `CARD:326`, `CARD:444`) i stedet for å skjule dem. Søkt etter «historisk», «arkivert» og «opptaksstatus» |
| `@OPT-BEH-BEH-042` | Se konklusjonene fra det gamle opptakssystemet | ikke funnet | P ✗ · A ✗ — `kompetanse.gsk_konklusjon` og `gsk_konklusjon_annullering` (`MIG/V481__gsk_konklusjon_historikk.sql`) leses bare i `TIDL` til gjenbruk, og ingen GraphQL-felt gir dem. Søkt etter «tidligere», «gskKonklusjon», «gsk_konklusjon» og «gskHistorikk» i `*.graphqls` |
| `@OPT-BEH-BEH-042` | Annullerte konklusjoner fra tidligere opptak vises | ikke funnet | P ~ · A ✗ — `GskVedtak.annulleringsarsak` finnes (`GQL:331`), men `HIST` henter bare `annulleringsdato` og viser merket «Annullert», ikke årsaken. Annulleringene i gjenbruksbasen gis ikke ut |
| `@OPT-BEH-BEH-042` | Konklusjoner i opptak som ikke er historiske, vises ikke | ikke funnet | P ✗ · A ✗ — `Soker.alleGskVedtak` (`SOKN:229-238`) filtrerer bare på søker og vedtaktype (`COND:21`), og tar med opptak som pågår, også opptaket saken er i. `HIST` viser alle |
| `@OPT-BEH-BEH-042` | Annullere konklusjonen | ikke funnet | P ~ · A ✗ — som «Annullere en automatisk konklusjon …»: bare med annullert vitnemål (`SERV:462-483`), og ingen annullering i fs-admin |
| `@OPT-BEH-BEH-042` | Organisasjonen som endret konklusjonen sist, kan annullere den | ikke funnet | P ✗ · A ✗ — ingen sjekk mot organisasjonen på konklusjonen. Den eneste sjekken er at organisasjonen har sak på søknaden (`SERV:261-273`) |
| `@OPT-BEH-BEH-042` | HK-dir kan annullere en konklusjon satt av en annen organisasjon | ikke funnet | P ✗ · A ✗ — ingen regel for HK-dir. Søkt etter «HKDIR», «hk-dir» og «hkdir» i `opptak-service/src/main` og fs-admin |
| `@OPT-BEH-BEH-042` | En annen organisasjon kan ikke annullere konklusjonen | ikke funnet | P ✗ · A ✗ — alle med MODIFISERE_SØKNADSBEHANDLING ved en organisasjon med sak på søknaden kan endre og annullere (`SERV:261-273`) |
| `@OPT-BEH-BEH-042` | Alle saksbehandlende organisasjoner kan annullere en konklusjon som er satt automatisk | ikke funnet | P ✗ · A ✗ — annullering krever annullert vitnemål (`SERV:462-483`), og fs-plattform skiller ikke på automatisk kilde. Ingen annullering i fs-admin |
| `@OPT-BEH-BEH-042` | Annulleringen krever bekreftelse | ikke funnet | P – · A ✗ — `DIALOG` har bare «Godkjent» og «Ikke kvalifisert» |
| `@OPT-BEH-BEH-042` | Annulleringen krever en årsak | ikke funnet | P ✓ · A ✗ — fs-plattform avviser annullering uten årsak (`GskAnnullertMenIkkeAnnulleringsarsakException` i `SERV`). fs-admin har ingen årsaksvelger |
| `@OPT-BEH-BEH-042` | Annullere uten begrunnelse | ikke funnet | P ✗ · A ✗ — det finnes ikke noe begrunnelsesfelt (`SERV:548-574`, `GQL:89`), og ingen annullering i fs-admin |
| `@OPT-BEH-BEH-042` | Begrunnelsen bevares med den annullerte konklusjonen | ikke funnet | P ✗ · A ✗ — `gsk_vedtak` har bare `annulleringsarsak_kode` og `annulleringsdato`. Søkt etter «begrunnelse» og «merknad» i migrasjonene og inputtypene. `merknad_automatisk` gjelder automatikken |
| `@OPT-BEH-BEH-042` | Ny konklusjon etter annulleringen | ikke funnet | P ~ · A ✗ — fs-plattform avviser opprett når raden finnes (`SERV:400-420`), men endre kan sette KVALIFISERT over en annullert konklusjon (`SERV:433-460`). fs-admin gjør Godkjenn om til KVALIFISERT_MEN_ANNULLERT så lenge konklusjonen er annullert (`UTIL:9-10`, `CARD:196`, `CARD:226`), så en ny positiv konklusjon blir aldri satt |
| `@OPT-BEH-BEH-042` | Grunnlagsdatoen er datoen konklusjonen ble satt | usikker | P ~ · A ✓ — fs-admin sender dagens dato når konklusjonen settes (`CARD:260`). fs-plattform lagrer datoen klienten sender (`SERV:497`), så API-et tar imot en hvilken som helst dato. Finneren mente funnet, kontrollen usikker |
| `@OPT-BEH-BEH-042` | Se konklusjonene fra tidligere opptak | usikker | P ~ · A ~ — `alleGskVedtak` (`SOKN:229`, `COND:21`) gir konklusjonene fra andre opptak, men også fra opptak som pågår. `HIST` viser dem under «Historikk» med grunnlagskode, organisasjon og dato, men ikke opptaket (bare ved gjenbruk) |
| `@OPT-BEH-BEH-042` | Saksbehandleren med tilgang til å se personen ser konklusjonen | usikker | P ~ · A ~ — uten endringsrett er kortet i lesemodus (`CARD:394`), og lesing krever SE_SØKNADSBEHANDLING (`MIG/V256__RLS_for_gsk_vedtak.sql:7-16`), ikke tilgang til personen. De tidligere konklusjonene er ikke slik kravet sier (se «Se konklusjonene fra tidligere opptak») |
| `@OPT-BEH-BEH-042` | Sette GSK-konklusjon | funnet | P ✓ · A ✓ — `SERV:152-175`, `SERV:485-504`; `CARD:233-246`, `CARD:394-436` |
| `@OPT-BEH-BEH-042` | Konklusjonen viser hvem som satte den | funnet | P ✓ · A ✓ — `GQL:297-345`; `CARD:360-381` |
| `@OPT-BEH-BEH-042` | Ingen negativ konklusjon når søknaden ikke har noen konklusjon | funnet | P ✓ · A ✓ — `SERV:400-420`; `CARD:331`, `CARD:410` |
| `@OPT-BEH-BEH-042` | Endre grunnlagskoden | funnet | P ✓ · A ✓ — `SERV:548-574`; `CARD:439-450` |
| `@OPT-BEH-BEH-042` | Endre en konklusjon som er satt automatisk | funnet | P ✓ · A ✓ — `SERV:548-572`; `CARD:263` |
| `@OPT-BEH-BEH-042` | Saksbehandleren angrer endringen | funnet | P – · A ✓ — `CARD:396-409` |
| `@OPT-BEH-BEH-042` | En konklusjon som er gjenbrukt fra et historisk opptak, endres bare i det nye opptaket | funnet | P ✓ · A ✓ — `AUTO:137`, `SERV:565-570`, `MIG/V374__gsk_vedtak_opptaksnokkel.sql:52`; `CARD:371-376` |
| `@OPT-BEH-BEH-042` | Konklusjonen satt av én organisasjon vises for en annen | funnet | P ✓ · A ✓ — `COND:29-31`, `SERV:261-273`, `MIG/V256__RLS_for_gsk_vedtak.sql:7-16`; `CARD:174`, `KANS:30-40` |
| `@OPT-BEH-BEH-042` | Se hvem som endret konklusjonen | funnet | P ✓ · A ✓ — `SERV:550`, `GQL:317`; `CARD:360-381` |

## Tilgang og datakonsistens

Om koden gir rollene tilgang slik kravet sier, holder data fra andre organisasjoner utenfor, og ikke gir foreldreløse eller motstridende data ved sletting og endring. Sjekket på kodenivå, ikke testet. Radene er grunnlaget for testbrukerne i testplanen.

### Avvik

Sjekkene der koden ikke gjør det kravet sier, kravet ikke sier noe, eller tilgangssjekken ikke er funnet. Det kravet ikke beskriver, står også i `## Regler uten scenario`.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | tilgang | saksbehandler annullerer konklusjonen | avviker | kravet sier at organisasjonen som satte eller sist endret konklusjonen, og HK-dir, kan annullere, og alle når konklusjonen er automatisk (Regel: Organisasjonen som satte eller sist endret konklusjonen, og HK-dir kan annullere den). Koden lar alle med sak på søknaden annullere, og bare når vitnemålet er annullert — `SERV:261-273`, `SERV:462-483` |
| `@OPT-BEH-BEH-042` | tilgang | saksbehandler endrer konklusjonen i et historisk opptak | avviker | kravet sier at endringsmuligheten er skjult (Konklusjonen kan ikke endres i et historisk opptak). Koden sjekker bare `er_laast`, og fs-admin deaktiverer knappene — `SERV:445-448`, `CARD:326`, `CARD:444` |
| `@OPT-BEH-BEH-042` | organisasjon | saksbehandler ved en annen saksbehandlende organisasjon annullerer | avviker | kravet sier nei (En annen organisasjon kan ikke annullere konklusjonen), koden sier ja — `SERV:261-273` |
| `@OPT-BEH-BEH-042` | konsistens | sletter en konklusjon | ikke beskrevet | ingen mutasjon for å slette, men RLS har en policy for sletting — `MIG/V256__RLS_for_gsk_vedtak.sql` |

### Stemmer

Sjekkene der koden gjør det kravet sier.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | tilgang | saksbehandler med MODIFISERE_SØKNADSBEHANDLING ved organisasjon med sak oppretter konklusjonen | stemmer | `SERV:261-273`, `MIG/V256__RLS_for_gsk_vedtak.sql:18-28`, `KANS:30-40` |
| `@OPT-BEH-BEH-042` | tilgang | saksbehandler ved en saksbehandlende organisasjon endrer konklusjonen satt av en annen | stemmer | `SERV:261-273`, `SERV:548-574` |
| `@OPT-BEH-BEH-042` | tilgang | saksbehandler med SE_SØKNADSBEHANDLING leser, men endrer ikke | stemmer | `MIG/V256__RLS_for_gsk_vedtak.sql:7-16`, `CARD:394` |
| `@OPT-BEH-BEH-042` | organisasjon | organisasjon uten sak på søknaden endrer konklusjonen | stemmer | `SERV:261-273` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | Annullering krever at vitnemålet konklusjonen bygger på, er annullert, og vitnemålet kan ikke byttes samtidig | validering | `SERV:462-483` | uklart om ønsket (kravet sier at det skal fjernes) |
| `@OPT-BEH-BEH-042` | En positiv konklusjon kan erstatte en låst konklusjon. Ellers avvises opprett når konklusjonen finnes | tilstandsovergang | `SERV:400-420`, `SERV:508-535` | uklart om ønsket |
| `@OPT-BEH-BEH-042` | Endring avvises når konklusjonen er låst med `laasGskVedtak` (`er_laast`) | tilstandsovergang | `SERV:445-448`, `GQL:47` | uklart om ønsket (kravet sier at flagget skal fjernes) |
| `@OPT-BEH-BEH-042` | En positiv konklusjon krever grunnlagskode, og kan ikke ha mangeltype eller annulleringsårsak | validering | `SERV:349-371` | testes i fase 2 |
| `@OPT-BEH-BEH-042` | Grunnlagsdatoen kommer fra klienten, og API-et tar imot en hvilken som helst dato | validering | `SERV:497`, `SERV:556`, `CARD:260` | uklart om ønsket |
| `@OPT-BEH-BEH-042` | Når konklusjonen settes eller endres, går saken fra «Ikke behandlet» til «Under behandling» | tilstandsovergang | `SERV:152-180` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-042` | Endringen overskriver organisasjonen på konklusjonen, setter kilden til manuell og tømmer merknaden fra automatikken og opptaket den er gjenbrukt fra | annet | `SERV:548-572`, `CARD:263` | testes i fase 2 |
| `@OPT-BEH-BEH-042` | Etter at konklusjonen er satt eller endret, vurderes kvalifiseringen på nytt for alle søkerens saker | annet | `SERV:96-135` | testes i fase 2 |
| `@OPT-BEH-BEH-042` | En annullert konklusjon er fortsatt den gjeldende konklusjonen på saken | tilstandsovergang | `COND:12-13`, `COND:67-69` | uklart om ønsket |
| `@OPT-BEH-BEH-042` | GSK-konklusjonen kan settes fra et valgt vitnemål, også i et arkivert opptak | annet | `GQL:283`, `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/SettGskKonklusjonService.java` | uklart om ønsket |

## Åpne spørsmål

Hvor mange regler og scenarioer i hvert krav som har `@openquestion`. Spørsmålene stopper ikke leveransen, men står i testplanen til de er besvart.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | Sette GSK-konklusjon manuelt | 0 av 6 | 0 av 29 | 0 |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Kontrollen endret | `@OPT-BEH-BEH-042` | «Grunnlagsdatoen er datoen konklusjonen ble satt» | funnet → usikker: datoen kommer fra klienten, ikke fra fs-plattform (`SERV:497`, `CARD:260`) |
| Kontrollen endret | `@OPT-BEH-BEH-042` | «Saksbehandleren med tilgang til å se personen ser konklusjonen» | funnet → usikker: de tidligere konklusjonene er ikke slik kravet sier, og lesing følger søknadsbehandlingen, ikke personen |
| Kontrollen endret | `@OPT-BEH-BEH-042` | «Ingen negativ konklusjon når søknaden ikke har noen konklusjon» | kontrollen foreslo ikke funnet, men leste ikke når «Ikke kvalifisert» vises. Valget og knappen vises bare når det finnes en konklusjon (`CARD:331`, `CARD:410`), så resultatet er funnet. Ikke med under *Delvis levert* |
| Merknad | `@OPT-BEH-BEH-042` | GSK-kortet og skissen (Figma «FS-Admin – Seksjon Opptak», node 18259:99465) | fs-admin følger ikke den nye skissen: select vises alltid i stedet for lesevisning med «Endre konklusjon» og «Annuller konklusjon» (`CARD:320-361`), lagring går via bekreftelsesdialogen «Er du helt sikker?» (`DIALOG`), «Historikk» i stedet for «Vis tidligere konklusjoner» (`HIST`), ingen hjelpetekst «Lagres på søker og vil bli gjenbrukt.», intet eget merke for automatisk behandlet, og tekstene er andre («Rediger», «Godkjenn», «Sist endret av …», «Satt automatisk …»). Annulleringsdialogen (node 18280:153267) finnes ikke |
| Merknad | `@OPT-BEH-BEH-042` | Skissen mot kravet | skissen viser ikke opptaket i tidligere konklusjoner, ingen annullert konklusjon, ingen låst tilstand og ingen lagreknapp når det ikke finnes noen konklusjon. Kravet gjelder for reglene |
| Merknad | `@OPT-BEH-BEH-042` | Endringsloggen for GSK | triggerne som skrev til `gsk_endringslogg`, er fjernet (`MIG/V480__stopp_endringslogg.sql:19-29`), så endringer i konklusjonen logges ikke lenger |
| Merknad | `@OPT-BEH-BEH-042` | – | delvis levert, men ikke i en spesifikasjon. Arbeidet er i Jira-epicen STEK-702 |
