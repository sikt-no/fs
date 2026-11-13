# Verifisering: Sette GSK-konklusjon manuelt

- **Dato:** 2026-11-13 10:13
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/sette_gsk_konklusjon_manuelt.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 9a7f7ee8b7, oppdatert), `fs-admin` (main, 36446fbf5, 2 bak main; den ene endrer bare hvilke spørringer `GSKCard.tsx` henter på nytt etter lagring)
- **Repoer:** P = fs-plattform, A = fs-admin · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** ingen funnet
- **Omfang:** alle krav uansett status, uten retagging (valgt)
- **Avhengigheter:** ingen
- **Bygger på:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/verify-sette_gsk_konklusjon_manuelt-2026-11-13-0901.md`
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei (testpersonene kunne ikke lastes i test-fsadmin, så det gikk ikke å bytte til en saksbehandler i opptaket «HÅK1 er KUL»)

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `SERV` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/gskvedtak/GskVedtakService.java`
- `COND` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/gskvedtak/GskVedtakConditions.java`
- `AUTO` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/GskVedtakAutoService.java`
- `GQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/gsk.graphqls`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `CARD` = `fs-admin/src/domains/soknadsbehandling/features/GSKCard/GSKCard.tsx`
- `UTIL` = `fs-admin/src/domains/soknadsbehandling/features/GSKCard/utils/gskUtils.ts`
- `HIST` = `fs-admin/src/domains/soknadsbehandling/features/GSKCard/components/GSKHistory.tsx`
- `DIALOG` = `fs-admin/src/domains/soknadsbehandling/features/GSKCard/components/GSKConfirmDialog.tsx`
- `KANS` = `fs-admin/src/domains/soknadsbehandling/hooks/useKanSaksbehandle.ts`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 10 funnet, 6 ikke funnet, 11 usikker, av 27
- Mangler: fs-plattform 15 scenarioer, fs-admin 15 (fs-plattform 10 usikker, fs-admin 3 usikker)
- Forslag: 0 kan leveres, 0 delvis levert, 0 kan slettes, 1 kan leveres når det er avklart, 1 blir stående
- Tilgang og datakonsistens: 3 stemmer, 2 avviker, 0 ikke funnet, 1 usikker, av 6
- Regler i koden uten scenario: 13
- Åpne spørsmål: 1 regler og 3 scenarioer i gating-settet, 0 utenfor gating (`@draft`)
- Endringer gjort: 0 krav og 0 deler fikk ny status. 3 spørsmål er avklart, og 1 resultat er endret

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Kan leveres når det er avklart**

- `@OPT-BEH-BEH-042` — Sette GSK-konklusjon manuelt (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/sette_gsk_konklusjon_manuelt.feature:26`): kan få `@in-progress`, med `@implemented` på de 10 scenarioene som er funnet, hvis teamet vil markere kravet som delvis levert. Ingen regel er funnet i sin helhet, og brukeren valgte ingen retagging i denne kjøringen · mangler i fs-plattform (15), fs-admin (15)

**Blir stående**

- `@OPT-BEH-BEH-042` — Sette GSK-konklusjon manuelt (`@planned`, 10/27 funnet): det finnes ingen annullering i fs-admin. En annullert konklusjon bevares ikke når det settes en ny konklusjon, og den skal bevares. Annulleringsreglene i fs-plattform er andre enn i kravet, og vilkåret om annullert vitnemål skal fjernes. Låsen følger ikke statusen på opptaket, og negativ konklusjon er ikke begrenset til automatiske konklusjoner. Kravet må endres med `fs-krav` (se `## Andre funn`) før det hentes inn i et scope · mangler i fs-plattform (15), fs-admin (15)

## Endringer

Det som er endret i kravfilene og i resultatet: i kjøringen (det sikre, når brukeren sa ja) og i gjennomgangen av rapporten.

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | Sette GSK-konklusjon manuelt | ingen | Gjenbruken skal være som i dag: konklusjonen settes på søknaden i opptaket, og hentes opp igjen fra tidligere opptak og gjenbruksbasen. Koden gjør det (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/TidligereGskKonklusjonService.java:24-35`, `:94-102`). Teksten «Lagres på søker og vil bli gjenbrukt.» i skissen er riktig |
| `@OPT-BEH-BEH-042` | Scenario: Se tidligere konklusjoner | `ikke funnet` → `usikker` | Brukeren sa i chat at dagens historikk trolig er riktig: konklusjonene søkeren har fått i andre opptak, ikke versjoner av konklusjonen i samme opptak. Spørsmålet ble hoppet over i dialogen, så det er ikke bekreftet. Er det riktig, finnes scenarioet i begge repoene, men kravteksten må endres |
| `@OPT-BEH-BEH-042` | Scenario: Annullere konklusjonen | ingen | En annullert konklusjon skal bevares når det settes en ny konklusjon i samme opptak. I dag overskrives den (`SERV:548-574`) |
| `@OPT-BEH-BEH-042` | Regel: Organisasjonen som satte eller sist endret konklusjonen, og HK-dir kan annullere den | ingen | Vilkåret om at vitnemålet må være annullert (`SERV:462-483`), skal fjernes. Saksbehandleren skal kunne annullere med en årsak fra kodeverket |
| `@OPT-BEH-BEH-042` | Scenario: Se tidligere konklusjoner | ingen | Skal konklusjonene i gjenbruksbasen fra det gamle systemet (`kompetanse.gsk_konklusjon`) også vises? Ikke avklart |

## Oversikt per krav

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | Sette GSK-konklusjon manuelt | 10/27 | 15 (10 usikker) | 15 (3 usikker) | Annullering i fs-admin, nye annulleringsregler uten vilkåret om vitnemål, annullert konklusjon som bevares, lås fra opptaksstatus, begrensning av negativ konklusjon, grunnlagsdato satt av fs-plattform, begrunnelse ved annullering, og kravteksten om tidligere konklusjoner |

Mangler: fs-plattform 15 scenarioer i 1 krav, fs-admin 15 i 1 krav (13 usikker). 0 av 1 krav er funnet i alle repoene.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P` og `A` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | Ingen negativ konklusjon over en konklusjon saksbehandleren har satt | ikke funnet | P ✗ · A ✗ — `SERV:433-460` sjekker ikke `vedtakkilde` før en endring til IKKE_KVALIFISERT. `CARD:400` viser «Ikke kvalifisert» over enhver konklusjon, også over en manuell (NOM). Søkt etter «vedtakkilde», «AUT» og «NOM» i endre-valideringen |
| `@OPT-BEH-BEH-042` | Den forrige konklusjonen bevares når konklusjonen endres | ikke funnet | P ✗ · A – — `SERV:548-574` gjør UPDATE på samme rad (PK søker og opptak, `MIG/V374__gsk_vedtak_opptaksnokkel.sql:52`). Triggerne som skrev til `gsk_endringslogg` (`MIG/V375`), er fjernet (`MIG/V483__endringslogg_uten_bruker.sql:5`), og endringsloggen for saken tar ikke med GSK (`MIG/V483__endringslogg_uten_bruker.sql:15-25`). Brukeren mener versjoner i samme opptak ikke trengs, bortsett fra annullerte konklusjoner (se `## Endringer`), så scenarioet bør endres med `fs-krav` |
| `@OPT-BEH-BEH-042` | Konklusjonen kan ikke endres i et historisk opptak | ikke funnet | P ✗ · A ~ — de manuelle mutasjonene sjekker ikke opptaksstatus, bare `er_laast` (`SERV:448-450`). Bare automatikken sjekker ARKIVERT (`AUTO:254-260`). `CARD:197` låser ut fra `erLaast` og deaktiverer knappen (`CARD:434`) i stedet for å skjule den. Søkt etter «opptaksstatus», «ARKIVERT», «erAvsluttet» og «historisk» |
| `@OPT-BEH-BEH-042` | En annen organisasjon kan ikke annullere konklusjonen | ikke funnet | P ✗ · A ✗ — `SERV:261-273` lar alle organisasjoner med sak på søknaden og MODIFISERE_SØKNADSBEHANDLING endre og annullere. Annullering finnes ikke i fs-admin |
| `@OPT-BEH-BEH-042` | Annulleringen krever bekreftelse | ikke funnet | P – · A ✗ — `DIALOG:19-41` har bare «Godkjent» og «Ikke kvalifisert». Søkt etter «annuller» i fs-admin `src/domains/soknadsbehandling` |
| `@OPT-BEH-BEH-042` | Begrunnelsen bevares med den annullerte konklusjonen | ikke funnet | P ✗ · A ✗ — ingen kolonne for begrunnelse på `gsk_vedtak`, og ingen i `EndreGskVedtakInputV3`. Bare `merknadAutomatisk` (`GQL:341`), som er noe annet. Søkt etter «begrunnelse» og «merknad» |
| `@OPT-BEH-BEH-042` | Se tidligere konklusjoner | usikker | P ~ · A ~ — `HIST:18-126` viser «Historikk» fra `Soker.alleGskVedtak` (`fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/soknad/soknad.graphqls:229`, `COND:20-22`): én konklusjon per opptak søkeren har vært i, med status, organisasjon og dato. Er det dette «tidligere konklusjoner» betyr (ikke bekreftet), er scenarioet funnet, men kravet sier «endret to ganger» og gjelder versjoner i samme opptak. Konklusjonene i gjenbruksbasen (`kompetanse.gsk_konklusjon`) vises ikke |
| `@OPT-BEH-BEH-042` | Grunnlagsdatoen er datoen konklusjonen ble satt | usikker | P ~ · A ✓ — `CARD:260` sender dagens dato når konklusjonen settes. `SERV:497` lagrer datoen klienten sender, så det er ikke fs-plattform som sørger for at datoen er riktig |
| `@OPT-BEH-BEH-042` | Grunnlagsdatoen følger den siste endringen | usikker | P ~ · A ✗ — `CARD:260` sender `grunnlagsdato ?? todayAsString()`, så den gamle datoen beholdes ved endring. `SERV:556` lagrer datoen klienten sender |
| `@OPT-BEH-BEH-042` | Saksbehandleren med tilgang til å se personen ser konklusjonen | usikker | P ~ · A ~ — tilgangen går på søknadsbehandling, ikke på personen: les med SE_SØKNADSBEHANDLING, endre med MODIFISERE_SØKNADSBEHANDLING (`MIG/V256__RLS_for_gsk_vedtak.sql:7-28`, `KANS:30-40`). Knappene skjules uten endringsrett (`CARD:384`). De tidligere konklusjonene finnes ikke (se «Se tidligere konklusjoner») |
| `@OPT-BEH-BEH-042` | Annullere konklusjonen | usikker | P ~ · A ✗ — fs-plattform annullerer gjennom endre med KVALIFISERT_MEN_ANNULLERT og årsak (`SERV:451-483`, `SERV:549-568`), men bare fra KVALIFISERT, og bare når vitnemålet konklusjonen bygger på, er annullert. Konklusjonen bevares ikke. fs-admin har ingen knapp eller dialog for annullering |
| `@OPT-BEH-BEH-042` | Organisasjonen som endret konklusjonen sist, kan annullere den | usikker | P ~ · A ✗ — det er mulig i fs-plattform fordi alle organisasjoner med sak kan annullere (`SERV:261-273`), ikke fordi det finnes en regel for den som endret sist. Ikke i fs-admin |
| `@OPT-BEH-BEH-042` | HK-dir kan annullere en konklusjon satt av en annen organisasjon | usikker | P ~ · A ✗ — ingen regel for HK-dir i `soknad/gskvedtak/`. HK-dir kan bare annullere med sak og MODIFISERE_SØKNADSBEHANDLING i opptaket (`SERV:261-273`). Søkt etter «HK.?dir» og «hkdir» |
| `@OPT-BEH-BEH-042` | Alle saksbehandlende organisasjoner kan annullere en konklusjon som er satt automatisk | usikker | P ~ · A ✗ — mulig i fs-plattform fordi alle kan annullere, men det krever annullert vitnemål (`SERV:462-483`). En automatisk konklusjon har ingen organisasjon (`AUTO:46-47`). Ikke i fs-admin |
| `@OPT-BEH-BEH-042` | Annulleringen krever en årsak | usikker | P ✓ · A ✗ — `SERV:367-371` (GskAnnullertMenIkkeAnnulleringsarsakException), med årsak fra kodeverket (`GQL:2`, `GQL:82`). fs-admin henter ikke annulleringsårsakene, og har ingen årsaksvelger |
| `@OPT-BEH-BEH-042` | Annullere uten begrunnelse | usikker | P ~ · A ✗ — det finnes ikke noe felt for begrunnelse, så «uten begrunnelse» er bare tilfeldig oppfylt i fs-plattform. Ikke i fs-admin |
| `@OPT-BEH-BEH-042` | Ny konklusjon etter annulleringen | usikker | P ~ · A ✗ — fs-plattform: endre tillater KVALIFISERT etter annullering (`SERV:433-460`), men opprett avvises når raden finnes (`SERV:415-417`), og automatikken regner en annullert konklusjon som gjeldende (`COND:14-15`). fs-admin: `UTIL:9-10` gjør Godkjenn om til KVALIFISERT_MEN_ANNULLERT når gjeldende konklusjon er annullert (`CARD:226`), så en ny positiv konklusjon blir aldri satt |
| `@OPT-BEH-BEH-042` | Sette GSK-konklusjon | funnet | P ✓ · A ✓ — `GQL:17`, `SERV:485-504`; `CARD:312-320`, `CARD:272` |
| `@OPT-BEH-BEH-042` | Konklusjonen viser hvem som satte den | funnet | P ✓ · A ✓ — `SERV:492`, `GQL:316-338`; `CARD:360-381` |
| `@OPT-BEH-BEH-042` | Overstyre en automatisk konklusjon med en negativ konklusjon | funnet | P ✓ · A ✓ — `SERV:349-366`, `SERV:433-460`; `CARD:400-415` |
| `@OPT-BEH-BEH-042` | Ingen negativ konklusjon når søknaden ikke har noen konklusjon | funnet | P ✓ · A ✓ — `SERV:407-412`; `CARD:321`, `CARD:400` |
| `@OPT-BEH-BEH-042` | Endre grunnlagskoden | funnet | P ✓ · A ✓ — `GQL:32`, `SERV:548-574`; `CARD:429-440` |
| `@OPT-BEH-BEH-042` | Endre en konklusjon som er satt automatisk | funnet | P ✓ · A ✓ — `SERV:551`, `SERV:570`; `CARD:263`, `UTIL:60-62` |
| `@OPT-BEH-BEH-042` | Saksbehandleren angrer endringen | funnet | P – · A ✓ — `CARD:386-399` |
| `@OPT-BEH-BEH-042` | En konklusjon som er gjenbrukt fra et historisk opptak, endres bare i det nye opptaket | funnet | P ✓ · A ✓ — `AUTO:272-292`, `MIG/V374__gsk_vedtak_opptaksnokkel.sql:52`; `CARD:266-271` |
| `@OPT-BEH-BEH-042` | Konklusjonen satt av én organisasjon vises for en annen | funnet | P ✓ · A ✓ — `COND:30-32`, `MIG/V256__RLS_for_gsk_vedtak.sql:7-16`, `SERV:261-273`; `CARD:177-195`, `KANS:30-40` |
| `@OPT-BEH-BEH-042` | Se hvem som endret konklusjonen | funnet | P ✓ · A ✓ — `SERV:551`, `GQL:317`, `GQL:337`; `CARD:360-381` |

## Tilgang og datakonsistens

Om koden gir rollene tilgang slik kravet sier, holder data fra andre organisasjoner utenfor, og ikke gir foreldreløse eller motstridende data ved sletting og endring. Sjekket på kodenivå, ikke testet. Radene er grunnlaget for testbrukerne i testplanen.

### Avvik

Sjekkene der koden ikke gjør det kravet sier, kravet ikke sier noe, eller tilgangssjekken ikke er funnet. Det kravet ikke beskriver, står også i `## Regler uten scenario`.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | tilgang | saksbehandler annullerer konklusjonen | avviker | kravet sier at bare organisasjonen som satte eller sist endret konklusjonen, og HK-dir, kan annullere (Regel: Organisasjonen som satte eller sist endret konklusjonen, og HK-dir kan annullere den). Koden lar alle organisasjoner med sak på søknaden annullere, og krever i tillegg annullert vitnemål — `SERV:261-273`, `SERV:462-483` |
| `@OPT-BEH-BEH-042` | organisasjon | saksbehandler ved en annen saksbehandlende organisasjon annullerer | avviker | kravet sier nei (En annen organisasjon kan ikke annullere konklusjonen), og koden sier ja — `SERV:261-273` |
| `@OPT-BEH-BEH-042` | tilgang | saksbehandler ved HK-dir annullerer | usikker | ingen regel for HK-dir. Det virker bare når HK-dir har sak og MODIFISERE_SØKNADSBEHANDLING i opptaket — `SERV:261-273` |

### Stemmer

Sjekkene der koden gjør det kravet sier.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | tilgang | saksbehandler med MODIFISERE_SØKNADSBEHANDLING ved organisasjon med sak oppretter og endrer konklusjonen | stemmer | `SERV:261-273`, `MIG/V256__RLS_for_gsk_vedtak.sql:18-28`, `KANS:30-40` |
| `@OPT-BEH-BEH-042` | tilgang | saksbehandler med bare SE_SØKNADSBEHANDLING leser, men endrer ikke | stemmer | `MIG/V256__RLS_for_gsk_vedtak.sql:12-14`, `CARD:384` |
| `@OPT-BEH-BEH-042` | organisasjon | alle saksbehandlende organisasjoner leser den samme konklusjonen | stemmer | `MIG/V256__RLS_for_gsk_vedtak.sql:7-16`, `COND:30-32` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | Annullering bare når vitnemålet konklusjonen bygger på, er annullert, og vitnemålsnummeret kan ikke endres samtidig | validering | `SERV:462-483` | skal fjernes i fs-plattform (avklart 2026-11-13) |
| `@OPT-BEH-BEH-042` | Annullering bare fra KVALIFISERT (ikke fra en negativ konklusjon) | tilstandsovergang | `SERV:451-457` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-042` | En låst konklusjon (`er_laast`) kan ikke endres, og en ny KVALIFISERT erstatter en låst rad | tilstandsovergang | `SERV:448-450`, `SERV:415-419` | uklart om ønsket (flagget skal fjernes ifølge kravet) |
| `@OPT-BEH-BEH-042` | Oppretting avvises når søknaden har en konklusjon | validering | `SERV:415-417` | uklart om ønsket (berører «Ny konklusjon etter annulleringen») |
| `@OPT-BEH-BEH-042` | Positiv, negativ og annullert utelukker hverandres felt (grunnlag, grunnlagsdato, mangel, annulleringsårsak) | validering | `SERV:286-380` | testes i fase 2 |
| `@OPT-BEH-BEH-042` | Negativ konklusjon krever mangelkode («Du må velge en årsak til avslag») | obligatorisk felt | `SERV:350-353`, `CARD:252-254` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-042` | Godkjenn er deaktivert uten valgt grunnlagskode | obligatorisk felt | `CARD:420` | testes i fase 2 |
| `@OPT-BEH-BEH-042` | En identisk konklusjon avvises («Identisk GSK-konklusjon finnes allerede for denne søkeren») | validering | `CARD:233-240` | testes i fase 2 |
| `@OPT-BEH-BEH-042` | Bekreftelsesdialog («Er du helt sikker?») før en positiv eller negativ konklusjon lagres | annet | `DIALOG:19-41` | uklart om ønsket (kravet har bekreftelse bare ved annullering, og skissen har ingen dialog ved lagring) |
| `@OPT-BEH-BEH-042` | Saken flyttes fra UBEHANDLET til UNDER_BEHANDLING når konklusjonen settes eller endres | tilstandsovergang | `SERV:176-180`, `SERV:212-216` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-042` | Kvalifiseringen på alle sakene til søkeren beregnes på nytt etter en endring | annet | `SERV:127-153` | uklart om ønsket (kan høre til OPT-BEH-BEH-015) |
| `@OPT-BEH-BEH-042` | En manuell endring fjerner kildeopptaket og merknaden fra automatikken | standardverdi | `SERV:561-562` | testes i fase 2 |
| `@OPT-BEH-BEH-042` | fs-admin sender alltid vedtakskilden NOM, også når en automatisk konklusjon endres (kilden settes av klienten) | standardverdi | `CARD:263`, `SERV:560` | uklart om ønsket (kommentaren i koden sier at fs-plattform bør sette den) |

## Åpne spørsmål

Hvor mange regler og scenarioer i hvert krav som har `@openquestion`. Spørsmålene stopper ikke leveransen, men står i testplanen til de er besvart.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-042` | Sette GSK-konklusjon manuelt | 1 av 5 | 3 av 27 | 0 |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Åpent spørsmål | `@OPT-BEH-BEH-042` | «Saksbehandleren setter GSK-konklusjonen med en grunnlagskode» (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/sette_gsk_konklusjon_manuelt.feature:49`) | Grunnlagskodene er en fast liste, lik for alle opptak og år. Skal saksbehandleren kunne velge alle kodene, og hvem skal forvalte lista? Koden lar saksbehandleren velge hele `grunnlagstype`-tabellen (`CARD:199-205`) |
| Åpent spørsmål | `@OPT-BEH-BEH-042` | «Se tidligere konklusjoner» (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/sette_gsk_konklusjon_manuelt.feature:129`) | Er «tidligere konklusjoner» konklusjonene fra andre opptak (som i dag), og ikke versjoner i samme opptak? Brukeren tror det, men det er ikke bekreftet |
| Åpent spørsmål | `@OPT-BEH-BEH-042` | «Se tidligere konklusjoner» (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/sette_gsk_konklusjon_manuelt.feature:129`) | Skal konklusjonene i gjenbruksbasen fra det gamle systemet (`kompetanse.gsk_konklusjon`, importert fra SODA) også vises? I dag brukes de bare i gjenbruken (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/TidligereGskKonklusjonService.java:94-102`) |
| Ikke sjekket | – | min-kompetanse | Kravet gjelder bare saksbehandleren, så klonen var ikke med |
| Ikke sjekket | – | skjermbilder | Testpersonene kunne ikke lastes i test-fsadmin, så det gikk ikke å bytte til en saksbehandler i opptaket «HÅK1 er KUL» |
| Merknad | `@OPT-BEH-BEH-042` | kommentaren i kravet om koden (linje 16–25) | Stemmer med koden. Tabellen `gsk_endringslogg` (`MIG/V375`) står, men triggerne som skrev til den, er fjernet (`MIG/V483__endringslogg_uten_bruker.sql:5`). `V481` er gjenbruksbasen med konklusjonene fra SODA |
| Merknad | `@OPT-BEH-BEH-042` | endringer i kravet med `fs-krav` | Ut fra svarene 2026-11-13: (1) «Den forrige konklusjonen bevares når konklusjonen endres» (:123) tas ut eller begrenses til annullerte konklusjoner. (2) «Se tidligere konklusjoner» (:129) skrives om til konklusjonene fra andre opptak, når det er bekreftet. Kommentaren på :130 om STEK-443 må da rettes. (3) Den annullerte konklusjonen bevares også når det settes en ny konklusjon (:246). (4) Annullering krever ikke annullert vitnemål. (5) Det åpne spørsmålet om gjenbruksbasen legges inn |
| Merknad | `@OPT-BEH-BEH-042` | skissen i Figma (node 18259:99465) mot fs-admin | Skissen har en nedtrekksliste og «Lagre endring» i stedet for knappene «Godkjenn» og «Ikke kvalifisert». Den har også «Endre konklusjon», «Annuller konklusjon», «Vis tidligere konklusjoner», en status med «Satt av <org> <dato>» eller «Automatisk behandlet <dato>», og dialogen «Annuller GSK-konklusjon?» med nåværende konklusjon, «Årsak til annullering» og «Begrunnelse». Teksten under tittelen er «Lagres på søker og vil bli gjenbrukt.». Skissen har ingen bekreftelsesdialog ved lagring og ikke noe valg for negativ konklusjon. I fs-admin finnes i dag «Rediger», «Godkjenn», «Ikke kvalifisert», «Årsak til avslag», dialogen «Er du helt sikker?» og «Historikk» på tvers av opptak (`CARD:310-440`, `DIALOG:19-41`, `HIST:89-126`) |
| Merknad | `@OPT-BEH-BEH-042` | skissen og kravet | Skissen viser ikke hvordan en negativ konklusjon settes over en automatisk konklusjon (Regel: En negativ GSK-konklusjon settes bare over en positiv konklusjon som er satt automatisk) |
