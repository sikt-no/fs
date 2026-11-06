# Verifisering: vise_elektroniske_vitnemål.feature

- **Dato:** 2026-11-05 12:42
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vise_elektroniske_vitnemål.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, e2ed43b3ce, oppdatert), `fs-admin` (main, f1d15446a, oppdatert)
- **Repoer:** P = fs-plattform, A = fs-admin · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** 100 MR-er i fs-plattform, 60 i fs-admin (0 med kode for scenarioene som mangler; 1 retter et tilgangsavvik i fs-admin)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `SEC` = `fs-admin/src/domains/soknadsbehandling/features/VitnemalsbehandlingSection/VitnemalsbehandlingSection.tsx`
- `SCH` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `VGS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs`
- `JOBB` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 8 funnet, 1 ikke funnet, 2 usikker, av 11
- Mangler: fs-plattform 2 scenarioer, fs-admin 2 (2 usikker)
- Forslag: 0 kan leveres, 1 delvis levert, 0 kan slettes, 1 kan leveres når det er avklart, 1 blir stående
- Tilgang og datakonsistens: 3 stemmer, 1 avviker, 1 ikke beskrevet, 0 ikke funnet, 0 usikker, av 5
- Regler i koden uten scenario: 12
- Åpne spørsmål: 0 regler og 1 scenarioer i gating-settet, 0 utenfor gating (`@draft`)
- Endringer gjort: 0 krav og 1 deler fikk ny status, 0 filer og 0 blokker slettet

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Delvis levert**

- `@OPT-BEH-BEH-005` — Se søkerens elektroniske vitnemål (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vise_elektroniske_vitnemål.feature`, 8/11 funnet): `@implemented` på Scenario: Annullert vitnemål som er brukt i en beregning vises (linje 187) `[P ✓ · A ✓]`

**Kan leveres når det er avklart**

- `@OPT-BEH-BEH-005` — Scenario: Åpne vitnemålsoversikten (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vise_elektroniske_vitnemål.feature:89`): kan få `@implemented` hvis det avklares at uenighetsteksten og «!» dekker «Opptakssystemets påstand om GSK» — «Åpne vitnemålsoversikten» (`krav/…:89`) er `usikker` `[P ✓ · A ~]`: `SCH/vgs-dokument.graphqls:36-55` har påstanden, men `SEC:24-48` henter bare `uenigMedSkolen`, og `SEC:173-177` viser den bare som tekst ved uenighet · mangler i fs-admin (1)

**Blir stående**

- `@OPT-BEH-BEH-005` — Se søkerens elektroniske vitnemål (`@in-progress`, 8/11 funnet): 1 ikke funnet: «Vitnemålene kan ikke hentes», 2 usikker: «Åpne vitnemålsoversikten», «Bruker uten lesetilgang ser ikke vitnemålsoversikten» · mangler i fs-plattform (2), fs-admin (2)

## Endringer

Det som er endret i kravfilene og i resultatet: i kjøringen (det sikre, når brukeren sa ja) og i gjennomgangen av rapporten.

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | Scenario: Annullert vitnemål som er brukt i en beregning vises | `@implemented` på delen | ja i kjøringen |

## Oversikt per krav

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Mangler i M | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | Se søkerens elektroniske vitnemål | 8/11 | 2 (1 usikker) | 2 (1 usikker) | – | En feilet henting fra KREG lagres ikke, opptakssystemets påstand om GSK vises bare ved uenighet, og det er uavklart om opptaksforvalteren skal se vitnemålene. |

Mangler: fs-plattform 2 scenarioer i 1 krav, fs-admin 2 i 1 krav (2 usikker). 0 av 1 krav er funnet i alle repoene.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P`, `A` og `M` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | Åpne vitnemålsoversikten | usikker | P ✓ · A ~ — `SEC:24-48,128-196` viser 7 av 8 opplysninger, sortert etter `SCH/sak.graphqls:129`. Opptakssystemets påstand finnes i API-et (`SCH/vgs-dokument.graphqls:36-55`, `VGS/VgsDokumentGskKontrollService.java:29-59`), men fs-admin henter bare `uenigMedSkolen` og viser påstanden bare indirekte: tekst under vitnemålsnummeret (`SEC:173-177`) og «!» (`SEC:108-114`) når den er uenig med skolen. Det åpne spørsmålet i scenarioet overlater visningen til designeren |
| `@OPT-BEH-BEH-005` | Vitnemålene kan ikke hentes | ikke funnet | P ✗ · A ~ — `JOBB:395-417` logger bare feilen, og ingenting lagres, så en feilet henting gir tom liste, og `SEC:83-85` skjuler seksjonen. `SEC:68-79` viser feil bare når GraphQL-spørringen feiler; søkt etter «hentingFeil», «henting_feilet», «kreg_feil», «siste_feil», «kregHenting», «vitnemaal_hentet», «kreg_status», «vgs_status» i fs-plattform. MR !6080 (utkast) lagrer feilen i jobbkøen, men den kan ikke leses av appen og er ikke i GraphQL |
| `@OPT-BEH-BEH-005` | Bruker uten lesetilgang ser ikke vitnemålsoversikten | usikker | P ~ · A ✓ — `MIG/V501__tilbyderoppslag_per_sak.sql:37-40` og `SEC:66,81-85` skjuler oversikten for en bruker uten tilknytning til saken. Men opptaksforvalteren (`MIG/V501__tilbyderoppslag_per_sak.sql:41-42`) og tilbyderen (`MIG/V501__tilbyderoppslag_per_sak.sql:43-52`) ser saken og vitnemålene uten lesetilgang for organisasjonen som behandler saken. Avklart 2026-11-03: tilbyderen skal se vitnemålene; uavklart for opptaksforvalteren |
| `@OPT-BEH-BEH-005` | Se at søkeren har elektroniske vitnemål | funnet | P ✓ · A ✓ — `SEC:97-107`, `SCH/sak.graphqls:124` |
| `@OPT-BEH-BEH-005` | Søker uten elektroniske vitnemål | funnet | P ✓ · A ✓ — `SEC:81-85`, `SCH/sak.graphqls:122` |
| `@OPT-BEH-BEH-005` | Poeng som ikke kan beregnes, vises tomme | funnet | P ✓ · A ✓ — `VGS/VgsDokumentPoengService.java:36,52-55`, `SEC:93-94,188-196` |
| `@OPT-BEH-BEH-005` | Åpne et vitnemål i ny fane | funnet | P – · A ✓ — `SEC:157-168`, `fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(vgsdokument)/vgsdokument/[vgsDokumentId]/page.tsx:1-9` |
| `@OPT-BEH-BEH-005` | Annullert vitnemål som er brukt i en beregning vises | funnet | P ✓ · A ✓ — `VGS/VgsDokumentConditions.java:28,41-47`, `SCH/vgs-dokument.graphqls:16`, `SEC:38,169-171` |
| `@OPT-BEH-BEH-005` | Annullert vitnemål som ikke er brukt i en beregning vises ikke | funnet | P ✓ · A – — `VGS/VgsDokumentConditions.java:28,41-64` |
| `@OPT-BEH-BEH-005` | Saksbehandler med leserettighet ser søkerens vitnemål | funnet | P ✓ · A ✓ — `MIG/V501__tilbyderoppslag_per_sak.sql:37-40`, `MIG/V179__RLS_for_kompetanse_vgs.sql:112-116` |
| `@OPT-BEH-BEH-005` | Saken er tilordnet en annen saksbehandler | funnet | P ✓ · A – — `MIG/V501__tilbyderoppslag_per_sak.sql:37-52` |

## Tilgang og datakonsistens

Om koden gir rollene tilgang slik kravet sier, holder data fra andre organisasjoner utenfor, og ikke gir foreldreløse eller motstridende data ved sletting og endring. Sjekket på kodenivå, ikke testet. Radene er grunnlaget for testbrukerne i testplanen.

### Avvik

Sjekkene der koden ikke gjør det kravet sier, kravet ikke sier noe, eller tilgangssjekken ikke er funnet. Det kravet ikke beskriver, står også i `## Regler uten scenario`.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | organisasjon | saksbehandler i én organisasjon leser vitnemål fra en sak i en annen organisasjon | avviker | kravet sier innsyn for «organisasjonen som behandler saken» (Regel: Innsyn styres av rettighet …), koden krever bare handlingen i en hvilken som helst organisasjon for `vgs_dokument`, og `VgsDokument` kan hentes som `node(id)` uten sak — `MIG/V179__RLS_for_kompetanse_vgs.sql:112-116`, `SCH/vgs-dokument.graphqls:2-3`, `fs-admin/src/domains/soknadsbehandling/features/VgsDokumentView/VgsDokumentView.tsx:16-17`. MR !3337 retter fs-admin, men ikke API-et |
| `@OPT-BEH-BEH-005` | tilgang | opptaksforvalter og tilbyder leser vitnemål | ikke beskrevet | kravet sier ikke noe om dem, koden slipper begge inn — `MIG/V501__tilbyderoppslag_per_sak.sql:41-52`, `MIG/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:31` |

### Stemmer

Sjekkene der koden gjør det kravet sier.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | tilgang | saksbehandler med SE/MODIFISERE_SØKNADSBEHANDLING for sakens organisasjon leser vitnemål | stemmer | `MIG/V501__tilbyderoppslag_per_sak.sql:37-40` |
| `@OPT-BEH-BEH-005` | tilgang | bruker uten tilknytning til saken leser vitnemål | stemmer | `MIG/V501__tilbyderoppslag_per_sak.sql:37-52`, `SEC:66,81-85` |
| `@OPT-BEH-BEH-005` | tilgang | saksbehandler leser vitnemål på sak tilordnet en annen | stemmer | `MIG/V501__tilbyderoppslag_per_sak.sql:37-52` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | «Brukt i en beregning» omfatter også kravelement-vurdering og GSK-konklusjon, ikke bare poeng (kommentaren i kravet sier poeng) | annet | `VGS/VgsDokumentConditions.java:41-64` | uklart om ønsket |
| `@OPT-BEH-BEH-005` | Vitnemål med samme utstedelsesdato sorteres på vitnemålsnummer | annet | `SCH/sak.graphqls:129` | testes i fase 2 |
| `@OPT-BEH-BEH-005` | Vitnemål uten utstedelsesdato sorteres sist | annet | `SCH/sak.graphqls:129` | testes i fase 2 |
| `@OPT-BEH-BEH-005` | Poengene rundes til én desimal (HALF_UP) | annet | `VGS/VgsDokumentPoengService.java:54`, `SEC:94` | testes i fase 2 |
| `@OPT-BEH-BEH-005` | Feilmeldingen er «Kunne ikke hente søkerens elektroniske vitnemål» / «Prøv å laste inn siden på nytt.», ikke teksten i design.md («Vitnemålene kunne ikke hentes.» / «Prøv igjen senere.») | validering | `fs-admin/src/common/messages/nb/soknadsbehandling.json:544-545` | uklart om ønsket |
| `@OPT-BEH-BEH-005` | Ukjent GSK, førstegangsvitnemål eller utstedt dato vises som «-» | standardverdi | `SEC:90-91,180-182` | testes i fase 2 |
| `@OPT-BEH-BEH-005` | Telleren teller også annullerte vitnemål som er brukt i en beregning | annet | `SEC:105` | uklart om ønsket |
| `@OPT-BEH-BEH-005` | Feiler bare poengene eller GSK-kontrollen, vises «-» uten melding | annet | `SEC:63,70` | testes i fase 2 |
| `@OPT-BEH-BEH-005` | Poeng beregnes også for annullerte vitnemål | annet | `VGS/VgsDokumentPoengService.java:35-46` | uklart om ønsket |
| `@OPT-BEH-BEH-005` | Varselet «Poengene bygger på et vitnemål som er annullert.» står over tabellen når et annullert vitnemål vises, med handlingsteksten bare for MODIFISERE_SØKNADSBEHANDLING (kravet sier at varselet ikke er med i L1) | annet | `SEC:59,88,122-127` | uklart om ønsket |
| `@OPT-BEH-BEH-005` | Opptakssystemets påstand er null for annullerte vitnemål og kompetansebevis, så uenighet vises ikke for dem | annet | `SCH/vgs-dokument.graphqls:31-35` | testes i fase 2 |
| `@OPT-BEH-BEH-005` | Når et vitnemål som er brukt i en sak, blir annullert i KREG, får saken en tagg og settes tilbake til under behandling | tilstandsovergang | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/AnnullertVitnemaalService.java:44-56`, `JOBB:398` | uklart om ønsket |

## Åpne spørsmål

Hvor mange regler og scenarioer i hvert krav som har `@openquestion`. Spørsmålene stopper ikke leveransen, men står i testplanen til de er besvart.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | Se søkerens elektroniske vitnemål | 0 av 2 | 1 av 11 | 0 |

## Åpne MR-er og brancher

MR-er og brancher som ser ut til å levere kravene. Koden i disse er ikke merget, og regnes ikke som levert.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-admin` | [!3337 fix(soknadsbehandling): hent vgsdokument via saken og krev SE-rollen](https://gitlab.sikt.no/studieadm/fs-admin/-/merge_requests/3337) (`fix/authz-on-vgsdocumentview`) | åpen | `@OPT-BEH-BEH-005` | 0/3 | retter tilgangsavviket i fs-admin, ikke i API-et |
| `fs-plattform` | [!6080 TAKE-398: Jobbkø i opptak for søknadshendelsene](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6080) (`feature/soknadshendelser-utboks`) | utkast | `@OPT-BEH-BEH-005` | 0/3 | usikker kobling: lagrer feilet henting i jobbkøen, men eksponerer den ikke |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Kontrollen endret | `@OPT-BEH-BEH-005` | «Når et vitnemål som er brukt, blir annullert, får saken en tagg» | – → lagt til i `## Regler uten scenario` |
| Kontrollen endret | `@OPT-BEH-BEH-005` | «Vitnemål uten utstedelsesdato sorteres sist» | – → lagt til i `## Regler uten scenario` |
| Åpent spørsmål | `@OPT-BEH-BEH-005` | «Åpne vitnemålsoversikten» (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vise_elektroniske_vitnemål.feature:89`) | Hvordan skal opptakssystemets påstand om GSK vises? Designeren avgjør. Er de uenige, vises en tekst under vitnemålsnummeret og et «!» ved delen «Vitnemålsbehandling» (OPT-BEH-BEH-015). |
| Ikke sjekket | – | min-kompetanse | ikke blant kodeklonene, men ikke relevant: kravet gjelder bare saksbehandleren |
| Merknad | `@OPT-BEH-BEH-005` | Regel: Innsyn styres av rettighet, ikke av hvem som har tatt saken (`krav/…:232`) | Regelen er `@implemented`, men «Bruker uten lesetilgang …» er usikker. Avklar opptaksforvalteren, og beskriv tilbyderen i kravet med `fs-krav` |
| Merknad | `@OPT-BEH-BEH-005` | `vise_elektroniske_vitnemål.design.md` | beskriver fortsatt «Feilmelding når poengberegningen ikke svarer» (linje 43, 59, 75), som er tatt ut av kravet. Rett med `fs-implementasjonsdetaljer` |
