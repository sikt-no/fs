# Verifisering: Automatisk saksbehandling (`@FLY-OPT-AUT-001`) og kravene flyten bygger på

- **Dato:** 2026-10-30 11:15
- **Krav:** `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature` og de 13 kravene fasene bygger på med `@depends-on-` som ikke er levert (14 feature-filer), slik de står på main etter PR #875 (f68bf49)
- **Kode:** `fs-plattform` (origin/main, 311bbdbb4d, lest uten å bytte branch), `fs-admin` (origin/main, dd1ad9c14, lest uten å bytte branch), `min-kompetanse` (finnes ikke lokalt, ikke sjekket)
- **Åpne MR-er:** 6 MR-er i fs-plattform og 2 i fs-admin sjekket; 1 med kode for kravene (!6080, ikke levert)
- **Omfang:** flyten og kravene den bygger på, alle uansett status (valgt: «Flyten og kravene uansett status»)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 4 finnere (`fs-verify-krav`), 14 kontrollører (`fs-verify-kontroll`), 2–5 feature-filer per finner
- **Skjermbilder:** nei
- **Forrige kjøring:** `verify-automatisk_saksbehandling-2026-10-30-0955.md` (før PR #875, ikke sjekket inn)

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status). I flyten er de to `@wont`-fasene holdt utenfor.

Stiene er forkortet:

- `O/` og `…/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/`
- `ASS` = `O/autosak/AutomatiskSaksbehandlingService.java`
- `SG` = `O/autosak/SetteGrunnlagService.java`
- `E` = `O/autosak/gsk/GskKonklusjonEvaluator.java`
- `A` = `O/autosak/gsk/GskVedtakAutoService.java`
- `T` = `O/autosak/gsk/GskVedtakTilbakekallingService.java`
- `K` = `O/autosak/kontrollmotor/Kravelementer.java`
- `GV` = `O/soknad/gskvedtak/GskVedtakService.java`
- `SB/` = `O/saksbehandling/`
- `RP/` = `O/regelverk/poeng/`
- `V/` = `O/vgs/`
- `PS` = `O/saksbehandling/PropageringService.java`
- `PRO` = `O/saksbehandling/PoengRadOppdateringService.java`
- `MS` = `O/saksbehandling/SakMangelService.java`
- `MT` = `O/regelverk/MangeltypeService.java`
- `AKV` = `O/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java`
- `KO` og `KOS` = `O/regelverk/kvalifisering/KvalifiseringOppdateringService.java`
- `SKS` = `O/soknad/StudiekurvService.java`
- `SHJ` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java`
- `GQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/automatisk-saksbehandling.graphqls`
- `MIG/` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `GC` = `fs-admin/src/domains/soknadsbehandling/features/GrunnlagCard/GrunnlagCard.tsx`
- `GSKC` = `fs-admin/src/domains/soknadsbehandling/features/GSKCard/GSKCard.tsx`
- `KS` = `fs-admin/src/domains/soknadsbehandling/features/KravlisteStudierCard/KravlisteStudierCard.tsx`
- `PCR` = `fs-admin/src/domains/soknadsbehandling/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx`
- `MC/` = `fs-admin/src/domains/soknadsbehandling/features/SakDrawer/components/ManglerCard/`
- `BTN` = `fs-admin/src/domains/soknadsbehandling/features/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx`

## Oppsummering

- Scenarioer: 146 funnet, 154 ikke funnet, 38 usikker, av 338
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 14
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: 20 stemmer, 9 avviker, 3 ikke funnet, 4 usikker, av 53 (17 ikke beskrevet i kravet)
- Regler i koden uten scenario: 135
- Åpne spørsmål: 8 regler og 48 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

Per krav (funnet / ikke funnet / usikker av gating-settet):

| Feature-ID | Egenskap | Status | Funnet | Ikke funnet | Usikker | Av |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | Importere resultater fra KREG | `@draft` | 11 | 6 | 0 | 17 |
| `@OPT-BEH-BEH-032` | Starte automatisk behandling | `@draft` | 2 | 14 | 1 | 17 |
| `@OPT-BEH-BEH-027` | Beregne GSK fra vitnemål | `@draft` | 22 | 2 | 3 | 27 |
| `@OPT-BEH-BEH-015` | Automatisk GSK-konklusjon | `@planned` | 6 | 29 | 6 | 41 |
| `@OPT-BEH-BEH-025` | Ferdigbehandle en sak | `@draft` | 4 | 8 | 1 | 13 |
| `@OPT-BEH-BEH-019` | Automatisk grunnlag | `@draft` | 16 | 11 | 3 | 30 |
| `@OPT-BEH-BEH-018` | Automatisk beregning av vitnemålspoeng | `@draft` | 9 | 6 | 2 | 17 |
| `@OPT-BEH-BEH-028` | Automatiske tilleggspoeng | `@draft` | 7 | 10 | 4 | 21 |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | `@draft` | 27 | 7 | 0 | 34 |
| `@OPT-BEH-BEH-031` | Beregne poengsum per kvote | `@draft` | 12 | 1 | 0 | 13 |
| `@OPT-BEH-BEH-008` | Søknadsmangler | `@planned` | 14 | 43 | 15 | 72 |
| `@OPT-BEH-BEH-029` | Behandlingsstatus | `@draft` | 5 | 3 | 0 | 8 |
| `@OPT-BEH-BEH-026` | Beregne automatisk på nytt | `@draft` | 0 | 7 | 0 | 7 |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling (flyt) | `@draft` | 11 | 7 | 3 | 21 |

## Fremdrift for flyter

Fremdriften kommer fra statusen på delen av kravene fasene bygger på (`@depends-on-`, og ankrene innenfor reglene i «…», ellers alle ankrene, ellers reglene i «…»). Den endrer ingen tagger.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Søkerens resultater importeres fra KREG når søknaden kommer inn | `@OPT-BEH-BEH-030` (`@draft`) | nei |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen starter når søkerens resultater er importert | `@OPT-BEH-BEH-032` (`@draft`) | nei |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen når vitnemålet importeres fra KREG | `@OPT-BEH-BEH-015` (`@planned`), `@OPT-BEH-BEH-027` (`@draft`) | nei |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen setter GSK-konklusjonen der den mangler | `@OPT-BEH-BEH-015` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Vitnemålet som gir GSK, avgjør om saken behandles helautomatisk | `@OPT-BEH-BEH-015` (`@planned`), `@OPT-BEH-BEH-025` (`@draft`) | nei |
| `@FLY-OPT-AUT-001` | To identiske vitnemål reknes som ett vitnemål (`@wont`) | – | mangler krav |
| `@FLY-OPT-AUT-001` | Søknaden får grunnlag fra vitnemålet | `@OPT-BEH-BEH-019` (`@draft`) | nei |
| `@FLY-OPT-AUT-001` | Poengene beregnes fra grunnlaget og rangeringsregelverket | `@OPT-BEH-BEH-018` (`@draft`), `@OPT-REG-RAN-001` (`@implemented`), `@OPT-REG-RAN-002` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoeng når grunnlaget er satt | `@OPT-BEH-BEH-028` (`@draft`) | nei |
| `@FLY-OPT-AUT-001` | Søknaden dobbeltrangeres automatisk etter 23/5-regelen (`@wont`) | – | mangler krav |
| `@FLY-OPT-AUT-001` | Kravelementene vurderes mot vitnemålet når poengene er beregnet | `@OPT-BEH-BEH-020` (`@draft`) | nei |
| `@FLY-OPT-AUT-001` | Kvotespørsmålene med algoritme besvares automatisk | `@OPT-BEH-BEH-012` (`@implemented`, Regel: Kvotespørsmål med algoritme besvares automatisk og kan ikke endres av saksbehandleren levert), `@OPT-REG-KVO-002` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Kvalifiseringen oppdateres når kravelementene er vurdert | `@OPT-BEH-BEH-020` (`@draft`) | nei |
| `@FLY-OPT-AUT-001` | Søkeren fordeles på kvoter når kvalifiseringen og kvotesvarene er satt | `@OPT-BEH-BEH-012` (`@implemented`, Regel: Søkeren plasseres automatisk i en kvote uten kvotespørsmål og Regel: Søkeren plasseres i en kvote med kvotespørsmål når alle kvotespørsmålene er besvart ja levert) | ja |
| `@FLY-OPT-AUT-001` | Søkeren får poengsum per kvote når søkeren er fordelt på kvoter | `@OPT-BEH-BEH-031` (`@draft`), `@OPT-REG-KVO-001` (`@implemented`, Regel: En kvotetype kan ha en default poengformel levert), `@OPT-REG-RAN-002` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Saken får mangler når kravelementene er vurdert | `@OPT-BEH-BEH-008` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet | `@OPT-BEH-BEH-008` (`@planned`; regelen med ankeret er `@draft`) | nei |
| `@FLY-OPT-AUT-001` | Saken blir ferdig behandlet og er klar til å være med i plasstildelingen | `@OPT-BEH-BEH-025` (`@draft`), `@OPT-BEH-BEH-029` (`@draft`) | nei |
| `@FLY-OPT-AUT-001` | Søknadsalternativene beregnes på nytt når regelverket er rettet | `@OPT-BEH-BEH-026` (`@draft`) | nei |

`@FLY-OPT-AUT-001`: 2 av 17 faser levert (de to `@wont`-fasene er ikke regnet med). Hele flyten bygger i tillegg på `@FLY-OPT-SAK-001`, som er `@planned`.

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-008` | `@OPT-SØK-SØK-018` Oppgi at generell studiekompetanse fullføres i vår | 1 | `@draft` | – | ikke levert, `@OPT-BEH-BEH-008` kan ikke leveres før dette |
| `@OPT-BEH-BEH-018` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-019` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-019` kan ikke leveres før dette |
| `@OPT-BEH-BEH-019` | `@OPT-REG-GRU-001` Grunnlag og mangelkoder | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-020` | `@OPT-BEH-BEH-004` Velge vitnemål som grunnlag for poengberegningen | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-020` kan ikke leveres før dette |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-001` Kompetanseregelverk | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-002` Kravelement | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-026` | `@OPT-PLA-TIL-001` Starte en plasstildeling | 1 | `@draft` | – | ikke levert, `@OPT-BEH-BEH-026` kan ikke leveres før dette |
| `@OPT-BEH-BEH-028` | `@OPT-BEH-BEH-012` Automatisk kvoteplassering | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-028` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-028` kan ikke leveres før dette |
| `@OPT-BEH-BEH-028` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-031` | `@OPT-REG-KVO-001` Kvotetype | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-031` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-032` | `@OPT-BEH-BEH-011` Tildele saksbehandlende organisasjon | 1 | `@planned` | – | ikke levert, `@OPT-BEH-BEH-032` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@FLY-OPT-SAK-001` Saksbehandlertildeling (flyt) | 1 | `@planned` | – | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-012` Automatisk kvoteplassering | 1 | `@implemented` | – | |
| `@FLY-OPT-AUT-001` | `@OPT-REG-KVO-001` Kvotetype | 1 | `@implemented` | – | Regel: En kvotetype kan ha en default poengformel |
| `@FLY-OPT-AUT-001` | `@OPT-REG-KVO-002` Kvotespørsmål | 1 | `@implemented` | – | |
| `@FLY-OPT-AUT-001` | `@OPT-REG-RAN-001` Rangeringsregelverk | 1 | `@implemented` | – | |
| `@FLY-OPT-AUT-001` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | |

Avhengigheter: 20 på nivå 1 (14 krav), 6 av dem ikke `@implemented`. `@depends-on-` mellom kravene i scope er ikke tatt med.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | Resultatene hentes når søkeren sender inn søknaden | funnet | `SKS:947` — leverSoknadskladdSoker (:811) legger SOKNAD-hendelse i køen; `SHJ:312` tildeler, søkeren i tildelte (:316–317), KREG hentes etter commit (:126–135, :394) |
| `@OPT-BEH-BEH-030` | Resultatene hentes når søknaden registreres på vegne av søkeren | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/opprettsoknad/OpprettSoknadISoknadsbehandlingService.java:489` → `SKS:820` → `SKS:947`, `SHJ:126–135` |
| `@OPT-BEH-BEH-030` | Resultatene hentes når en endring av søknaden gir en ny sak | funnet | `SKS:1057` — oppdaterSoknadFraSoknadskladd (:969) legger SOKNAD-hendelse; jobben tildeler (`BehandlertildelingService.java:458`) og henter KREG (`SHJ:126–135`); nytt dokumentnummer settes inn (`V/VgsLagringService.java:71–98`) |
| `@OPT-BEH-BEH-030` | Resultatene hentes ikke på nytt når en endring av søknaden ikke gir en ny sak | ikke funnet | `SKS:570` — leverPrioriteringerFraSoknadKladd (:499) legger alltid SOKNAD-hendelse, jobben henter KREG for hver tildelt søker (`SHJ:316–317`, :134), uansett ny sak. Likt i MR !6080: `opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/saksbehandling/Soknadshendelser.java:94` |
| `@OPT-BEH-BEH-030` | Resultatene hentes først når saken er opprettet | funnet | `SHJ:298–305` — uten regel utsettes hendelsen, søkeren ikke i tildelte; KREG bare etter tildelBehandler (:312, :316–317, :126–135) |
| `@OPT-BEH-BEH-030` | Det importerte vitnemålet har opplysningene saksbehandlingen trenger | ikke funnet | `V/VgsLagringService.java:71–101` lagrer alt unntatt KREGs egen påstand: bare `paastandOmGsk` → gsk_ok (`V/KregVgsParser.java:104`), som er skolens påstand (`fs-plattform/kreg/kreg-migrations/src/main/resources/db/migration/V1_027__kompetanse_skjema.sql:452`, `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/vgs-dokument.graphqls:11`). Spørringen `fs-plattform/opptak/opptak-service/src/main/resources/graphql/hent-kompetanseoppnaelse.graphql:7` har bare paastandOmGsk; KREG-skjemaet har ikke annet GSK-felt (`fs-plattform/kreg/kreg-graphql/src/main/resources/schema/features/experimental/schema.graphql:409`) |
| `@OPT-BEH-BEH-030` | Søker med flere vitnemål får alle importert | funnet | `V/KregVgsParser.java:70–77`; `V/HentVgsVitnemaalService.java:116–117` |
| `@OPT-BEH-BEH-030` | Kompetansebevis importeres | funnet | `V/KregVgsParser.java:72` filtrerer bare på reformkode; typen lagres (:98, `V/VgsLagringService.java:75`), kolonne VM/KB (`V176__kompetanse_vgs.sql:106`). Ikke sjekket mot KREG |
| `@OPT-BEH-BEH-030` | Vitnemål som er importert fra før, importeres ikke på nytt | funnet | `V/VgsLagringService.java:49–56` — FANTES_FRA_FOER |
| `@OPT-BEH-BEH-030` | Annullert vitnemål importeres som annullert | funnet | `V/KregVgsParser.java:107`; `V/VgsLagringService.java:84`, :97 |
| `@OPT-BEH-BEH-030` | Vitnemål som annulleres etter importen, blir annullert | funnet | `V/VgsLagringService.java:53–63` |
| `@OPT-BEH-BEH-030` | Vitnemålet blir stående som annullert når KREG opphever annulleringen | funnet | `V/VgsLagringService.java:53–56` (bevisst, :38–39) |
| `@OPT-BEH-BEH-030` | Søker uten fødselsnummer får ingen resultater importert | funnet | `V/HentVgsVitnemaalService.java:70–72` (:64); tildelt fra før (`SHJ:312–317`) |
| `@OPT-BEH-BEH-030` | Resultatene hentes når KREG svarer igjen | ikke funnet | ikke funnet på origin/main: `SHJ:410–411` logger, hendelsen er kvittert (:315, :361) — finnes i MR !6080 (utkast, fs-plattform, feature/soknadshendelser-utboks): `opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/vgs/VitnemaalJobb.java:53–56` (doblende ventetid 1–15 min, `opptak/opptak-jobb/src/main/java/no/sikt/fs/opptak/jobb/JobbHandler.java:34–35`, gir aldri opp; ingen grense i applikasjonsinnstillingene) |
| `@OPT-BEH-BEH-030` | Søkeren får vitnemålet etter at søknaden er levert | ikke funnet | KREG hentes bare fra `SHJ:394`; søkt «abonn», «hendelseslogg», «kreg.*hendelse/endring/subscri», «nyeVitnem», «vitnemaal.?endret» i opptak og MR !6080, !6456; «kreg» i fs-admin |
| `@OPT-BEH-BEH-030` | Vitnemålet annulleres og erstattes av et nytt etter at opptakssystemet har behandlet søknaden | ikke funnet | samme søk; tas bare inn ved neste søknadshendelse (`V/VgsLagringService.java:53–63`, :71–98) |
| `@OPT-BEH-BEH-030` | Vitnemålet annulleres uten at det kommer et nytt, etter at opptakssystemet har behandlet søknaden | ikke funnet | samme søk |
| `@OPT-BEH-BEH-032` | Den nye saken behandles automatisk når saksbehandlertildelingen har opprettet den | ikke funnet | `SHJ:312-317` tildeler, :126-135 henter KREG, men ingenting kaller den automatiske behandlingen; bare mutation (`GQL:52-58`). Heller ikke i MR !6080 (`Soknadshendelser.java:81-100` legger vitnemålsjobb i kø, starter ikke behandlingen) |
| `@OPT-BEH-BEH-032` | Saken behandles automatisk når jobben finner søkerens første vitnemål | ikke funnet | ingen jobb for nye vitnemål; søkt «abonnement», «nye_vitnem», «nyttVitnem», «første vitnemål». !6080 `VitnemaalJobb.java:59-80` henter bare for tildelte søknader, starter ikke behandlingen |
| `@OPT-BEH-BEH-032` | Saksbehandleren ser at saken har fått ny dokumentasjon | ikke funnet | «Ny dokumentasjon» (`fs-admin/src/domains/soknadsbehandling/features/SakOverviewView/components/SakStatusBadge/SakStatusBadge.tsx:35-37`, `SakOverviewTable.tsx:178-180`) bare for uleste saksdokumenter, som kommer fra søknadsdokumentene (`SaksdokumentSyncService.java:15-18,31-51`), ikke KREG |
| `@OPT-BEH-BEH-032` | Saken behandles ikke automatisk på nytt når det kommer et nytt vitnemål | ikke funnet | stemmer bare fordi ingenting starter behandlingen; jobben i Når finnes ikke |
| `@OPT-BEH-BEH-032` | Saken som er under behandling, behandles automatisk på vitnemålet saksbehandleren velger | ikke funnet | knappen (`BTN:30-36`) sender bare sakId; BehandleSakInput bare sakId (`GQL:188-194`); flere vitnemål kaster FlereVitnemaalException (`SetteGrunnlagService.java:110-114`) |
| `@OPT-BEH-BEH-032` | Saken som er ferdig behandlet, settes til Under behandling når behandlingen startes | ikke funnet | `ASS:83-143` endrer ikke statustype_kode |
| `@OPT-BEH-BEH-032` | Saken blir ferdig behandlet igjen når automatikken avgjør alt | ikke funnet | ingen kode setter FERDIG_BEHANDLET fra autosak |
| `@OPT-BEH-BEH-032` | Saksbehandleren starter bare behandlingen for saker hos organisasjonen | funnet | `ASS:89-97` kaster UkjentSakException når saken ikke er synlig; RLS på sak `V454__forvalter_ser_saker_krever_modifisere_opptak.sql:35-40` |
| `@OPT-BEH-BEH-032` | Grunnlaget saksbehandleren har valgt, står når behandlingen startes | funnet | `LeggTilGrunnlagService.java:105-109` la_staa/status_automatisk_utregnet=false; `SetteGrunnlagService.java:99-105,227-234` hopper over grunnlagsvalget (!6438 samme virkning) |
| `@OPT-BEH-BEH-032` | Saken som er ferdig behandlet automatisk, viser at den er behandlet automatisk | ikke funnet | aldri FERDIG_BEHANDLET fra autosak; ingen markering på saksnivå; statusAutomatiskUtregnet bare per rad (`sak.graphqls:244-252,291`) |
| `@OPT-BEH-BEH-032` | Saken behandles ikke automatisk når automatikken er skrudd av | ikke funnet | ingen innstilling per opptak; bare globalt Unleash-flagg automatisk-soknadsbehandling-trigger som skjuler knappen (`BTN:50-53`) |
| `@OPT-BEH-BEH-032` | Automatikken stopper på tidspunktet opptaksforvalteren har satt | ikke funnet | ingen stopptidspunkt |
| `@OPT-BEH-BEH-032` | Automatikken i ett opptak påvirker ikke andre opptak | ikke funnet | ingen bryter per opptak |
| `@OPT-BEH-BEH-032` | Saken viser at den ikke kunne behandles automatisk fordi søkeren ikke har vitnemål | ikke funnet | `SetteGrunnlagService.java:115-117` returnerer bare false; ingenting skrives på saken |
| `@OPT-BEH-BEH-032` | Behandlingen prøves på nytt når KREG ikke svarer | ikke funnet | ikke funnet på origin/main: `SHJ:410-411` logger bare — finnes delvis i MR !6080 (utkast, feature/soknadshendelser-utboks): `opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/vgs/VitnemaalJobb.java:49-56` prøver KREG-hentingen igjen, men starter ikke behandlingen |
| `@OPT-BEH-BEH-032` | Saksbehandleren ser ikke tekniske feil på saken | usikker | `SHJ:410-411` logger uten å skrive på saken; men Gitt kan ikke oppstå (behandlingen kaller ikke KREG og starter ikke av seg selv) |
| `@OPT-BEH-BEH-032` | Sikt varsles om en teknisk feil | ikke funnet | bare Log.errorf (`SHJ:410-411`); ingen alarmer for opptak |
| `@OPT-BEH-BEH-027` | Fag som er tatt ut av kontrollene, oppfyller ikke et delkrav | ikke funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/VgsDokumentVitnemaalMapper.java:71–73` — alle KREG-fag aktive; FagSoek bruker bare aktive (`FagSoek.java:47`); ingenting lar saksbehandleren ta ut. Søkt «status_aktiv», «statusAktiv(», «tattUt», «uten_kontroll», «fagstatus» |
| `@OPT-BEH-BEH-027` | Delkravene for <reform> | funnet | `K:1263–1271`, R94 `K:1278–1284`, KL `K:1267–1271` |
| `@OPT-BEH-BEH-027` | Vitnemål fra Kunnskapsløftet uten <delkrav> får påstanden ikke GSK | funnet | `K:1267–1271` OG; `E:67–68` KRYSSJEKK_FEILET. Påstanden lagres ikke |
| `@OPT-BEH-BEH-027` | Vitnemål fra Reform 94 uten <delkrav> får påstanden ikke GSK | funnet | `K:1278–1284`; `E:67–68` |
| `@OPT-BEH-BEH-027` | Matematikkravet er oppfylt med <alternativ> | funnet | `K:1112–1132` (:1114, :1115, :1134–1136, :1121, :646–648, :627–628, :1126, :1141–1170, :1131, :460–490) |
| `@OPT-BEH-BEH-027` | Påbygging med matematikk <fag> på vg1 | funnet | `K:1143–1170`, :1169 |
| `@OPT-BEH-BEH-027` | Matematikk for yrkesfag på vg1 alene oppfyller ikke matematikkravet | funnet | `K:1112–1132`, :1135, :1169–1170 |
| `@OPT-BEH-BEH-027` | Naturfagkravet er oppfylt med <alternativ> | funnet | `K:1174–1184`, :349–360, :363–374 |
| `@OPT-BEH-BEH-027` | Vg1 og vg3 fra ulike planer oppfyller ikke naturfagkravet | funnet | `K:1179–1183` |
| `@OPT-BEH-BEH-027` | Samfunnsfagkravet er oppfylt med <fagkode> | funnet | `K:1187–1189` |
| `@OPT-BEH-BEH-027` | Engelskkravet er oppfylt med <fagkode> | funnet | `K:1192–1208` |
| `@OPT-BEH-BEH-027` | Standard norsk med <variant> | funnet | `K:869–871`, :824–826, :213–215, :845–861, :218–221, :864–866, :224–227 |
| `@OPT-BEH-BEH-027` | Merknaden VMM25 med <fag> gir ikke standard norsk | funnet | `K:846–848`, :837 |
| `@OPT-BEH-BEH-027` | NOR1049 som privatist med merknaden VMM25 erstatter norsk hovedmål | funnet | `K:833–838`, :825 — krever i tillegg at NOR1050 ikke finnes (kravet sier det ikke) |
| `@OPT-BEH-BEH-027` | Norskkravet er oppfylt med <variant> | funnet | `K:869–871`, :884–886, :874–876, :230–231, :889–891, :879–881, :235 |
| `@OPT-BEH-BEH-027` | Standard norsk krever historie etter standard plan (<fagkode>) | funnet | `K:1237–1245` |
| `@OPT-BEH-BEH-027` | Standard norsk med historie etter samisk plan oppfyller ikke kravet | funnet | `K:1237–1245`, :1248–1257 |
| `@OPT-BEH-BEH-027` | <variant> godtar alle historiefagene | funnet | `K:1222–1235`, :1250, :1256 |
| `@OPT-BEH-BEH-027` | Delkravet for <delkrav> er oppfylt med <alternativ> | funnet | `K:1288–1311`, :1314–1328, :1331–1333, :1336–1338, :1341–1343, :1350–1405 |
| `@OPT-BEH-BEH-027` | Norsk for tegnspråklige alene oppfyller ikke norskkravet | funnet | `K:1402–1409` |
| `@OPT-BEH-BEH-027` | Løpet settes sammen av programområdene etter nivå | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/VgsDokumentVitnemaalMapper.java:112–118`, :77–78 |
| `@OPT-BEH-BEH-027` | Påstanden er GSK med grunnlagskoden for løpet | usikker | `E:70–71` (oppslag `GskVedtakAutoService.java:145–153`), men bare når skolens påstand er ja (`E:64–66`) |
| `@OPT-BEH-BEH-027` | Grunnlagskoden gis selv om påstanden ikke er GSK | ikke funnet | `E:67–68` — ingen grunnlagskode uten bestått seksfagskontroll; ingen grunnlagskode lagres på vitnemålet (`V176__kompetanse_vgs.sql:104–119`) |
| `@OPT-BEH-BEH-027` | Ukjent løp | funnet | `E:58–59` |
| `@OPT-BEH-BEH-027` | Påbyggingsruten PBPBY4 gir grunnlagskoden for løpet | usikker | `E:44–49`, `GskVedtakAutoService.java:146`, `E:70–71`, men krever skolens påstand (`E:64–66`) |
| `@OPT-BEH-BEH-027` | Yrkesfaglig løp fra <reform> gir grunnlagskoden <grunnlagskode> | usikker | `E:83–92` bare semi-automatisk (`SettGskKonklusjonService.java:133` true); automatisk sti false (`GskVedtakAutoService.java:89`) → LOEP_UTEN_GSK_GRUNNLAG (`E:61–62`); krever skolens påstand. Kravet sier ved import |
| `@OPT-BEH-BEH-027` | Løp og vitnemål fra ulike reformer | funnet | `E:84–85` REFORMKODE_AVVIK; automatisk sti stopper før (`E:61–62`), samme utfall |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand er at søkeren har generell studiekompetanse | ikke funnet | ingenting lagres på vitnemålet ved import (`VgsLagringService.java:71–98`); nærmeste er konklusjonen i automatisk behandling (`A:165–178`). Søkt «paastand», «gsk_beregnet», «beregnet», «grunnlagstype_kode» |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand beregnes uavhengig av skolens og KREGs påstand | ikke funnet | motsatt: seksfagskontrollen kjøres bare når skolens påstand er ja (`E:64–68`) |
| `@OPT-BEH-BEH-015` | Hvert vitnemål får sin egen påstand | ikke funnet | ingen påstand per vitnemål; stopper ved >1 dokument (`A:81–82`) |
| `@OPT-BEH-BEH-015` | Grunnlagskoder som settes automatisk | ikke funnet | ingen kode på vitnemålet; konklusjonen får kode fra vgs_loep (`E:70–71`) eller KLY/RFA semi-automatisk (`E:87–92`) |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand er at søkeren ikke har GSK når <grunn> | ikke funnet | ingen negativ påstand; bare «ingen automatikk» (`A:85–86`, `E:58–62`, `E:67–68`) |
| `@OPT-BEH-BEH-015` | Annullert vitnemål får ingen påstand fra opptakssystemet | ikke funnet | ingen påstand; annullerte holdes utenfor (`A:79`) |
| `@OPT-BEH-BEH-015` | Kompetansebevis får ingen påstand fra opptakssystemet | ikke funnet | ingen påstand; KB gir IKKE_ETT_VGS_DOKUMENT (`A:81–82`) |
| `@OPT-BEH-BEH-015` | Vitnemålet gir GSK når <påstand> er ja | ikke funnet | skolens påstand alene gir ikke GSK, seksfagskontrollen må også bestå (`E:64–69`); KREGs og opptakssystemets påstand finnes ikke |
| `@OPT-BEH-BEH-015` | Vitnemålet gir ikke GSK når alle tre påstandene er nei | usikker | `E:64–65` — skolens påstand nei gir ingen konklusjon; men bare én av tre påstander finnes, og i kjøringen |
| `@OPT-BEH-BEH-015` | Annullert vitnemål gir ikke GSK | usikker | `A:79`, `SettGskKonklusjonService.java:126–127`; i kjøringen, og KREGs påstand i Gitt finnes ikke |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra vitnemålet | ikke funnet | importen setter ingen (`SoknadshendelseJobb.java:394`, `HentVgsVitnemaalService.java:108–135`); settes i kjøringen (`A:117–118`, :165–178, :171–172) |
| `@OPT-BEH-BEH-015` | Søknaden får grunnlagskoden for løpet når bare KREG sier at søkeren har GSK | ikke funnet | KREGs påstand hentes ikke; skolens ja + seksfag nei gir ingen konklusjon (`E:67–68`) |
| `@OPT-BEH-BEH-015` | Vitnemål som ikke gir GSK, gir ingen konklusjon | usikker | `A:117–127` lagrer bare ved AutomatiskKonklusjon, i kjøringen; Så holder fordi importen aldri setter konklusjon |
| `@OPT-BEH-BEH-015` | Vitnemålet med senest utstedelsesdato brukes | ikke funnet | `A:81–82` stopper ved to vitnemål |
| `@OPT-BEH-BEH-015` | Alle søknader uten konklusjon oppdateres | ikke funnet | importen setter ingen; per sak (`ASS:83–102`) |
| `@OPT-BEH-BEH-015` | Søknader i avsluttede opptak oppdateres ikke | usikker | importen setter aldri konklusjon (Så holder), men automatisk behandling sjekker ikke avsluttet opptak (`A:64–90`, `ASS:89–102`) |
| `@OPT-BEH-BEH-015` | Nytt vitnemål fra KREG etter at søknaden er opprettet | ikke funnet | ingen abonnement; bare ved søknadshendelser (`SoknadshendelseJobb.java:126–135`) |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra tidligere samordna opptak | ikke funnet | tabellene finnes (`fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V481__gsk_konklusjon_historikk.sql:7`, :71), ingen kode leser dem |
| `@OPT-BEH-BEH-015` | Vitnemålet går foran tidligere konklusjon | ikke funnet | ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Bare den siste tidligere konklusjonen gjenbrukes | ikke funnet | ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Negative konklusjoner gjenbrukes ikke | ikke funnet | ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra lokalt opptak | ikke funnet | gsk_vedtak per (søker, opptak) (`A:136–143`) |
| `@OPT-BEH-BEH-015` | Gjenbruke kvalitetssikret konklusjon fra FS-klienten | ikke funnet | ingen gjenbruk; søkt «kvalitetssikr», «gsk_konklusjon» |
| `@OPT-BEH-BEH-015` | Annullert konklusjon gjenbrukes ikke | ikke funnet | annulleringstabellen (`V481…:71`) brukes ikke |
| `@OPT-BEH-BEH-015` | Konklusjon med annullering fram i tid gjenbrukes ikke | ikke funnet | ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Konklusjon som bygger på et annullert vitnemål gjenbrukes ikke | ikke funnet | ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Ingen grunnlag for generell studiekompetanse | funnet | ingen konklusjon ved opprettelse (`SoknadshendelseJobb.java:312–317`, :394); kjøringen gir ingen automatikk (`A:127`); GSK-kortet «Ikke behandlet» og manuell vurdering (`GSKC:308–309`, :322–362) |
| `@OPT-BEH-BEH-015` | Konklusjon på søknaden overskrives ikke | funnet | `A:65–66`, :136–143; `SettGskKonklusjonService.java:105–106`; import rører den ikke (unntatt tilbakekalling, `HentVgsVitnemaalService.java:130–132`) |
| `@OPT-BEH-BEH-015` | Systemet setter aldri en negativ konklusjon | funnet | `A:169` bare KVALIFISERT; merk tilbakekalling setter KVALIFISERT_MEN_ANNULLERT (`T:80`) |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra vitnemålet i den automatiske behandlingen | usikker | `ASS:100–102` første steg, men per sak (`fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/layout.tsx:112`), beregner på nytt (`E:67`), krever skolens påstand og ett vitnemål |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra et tidligere opptak i den automatiske behandlingen | ikke funnet | ingen gjenbruk (`ASS:100–108`, `A:64–90`) |
| `@OPT-BEH-BEH-015` | Konklusjonen overskrives ikke i den automatiske behandlingen | funnet | `A:65–66`, :136–143, fra `ASS:102` |
| `@OPT-BEH-BEH-015` | Overskrive positiv konklusjon med negativ konklusjon | funnet | `GV:99–105`, :183–217, :447–449, :348–352; `GSKC:234–239`, :338–351 |
| `@OPT-BEH-BEH-015` | Legge til positiv konklusjon når ingen finnes | funnet | `GV:406–412`; `GSKC:240–244`, :352–361 |
| `@OPT-BEH-BEH-015` | Bare positive konklusjoner kan legges til når ingen finnes | usikker | backend avviser (`GV:407–410`), men fs-admin viser «Ikke kvalifisert» også uten konklusjon (`GSKC:322`, :338–351) |
| `@OPT-BEH-BEH-015` | Automatisk konklusjon står når vitnemålet annulleres | ikke funnet | motsatt: `T:66–90` setter KVALIFISERT_MEN_ANNULLERT, fra `HentVgsVitnemaalService.java:130–132`; ingen tagg «Vitnemål annullert» (fs-admin !3274 merker bare vitnemålet, `EvaluatedBadge.tsx:14–15`) |
| `@OPT-BEH-BEH-015` | Gjenbrukt konklusjon står når vitnemålet annulleres | ikke funnet | ingen gjenbruk, ingen tagg; tilbakekalling bare AUT (`T:72`) |
| `@OPT-BEH-BEH-015` | Konklusjon i avsluttet opptak trekkes ikke tilbake | ikke funnet | `T:66–75` alle opptak |
| `@OPT-BEH-BEH-015` | Annulleringen oppdages uten at søkeren endrer søknaden | ikke funnet | ingen abonnement (`SoknadshendelseJobb.java:126–135`, `VgsLagringService.java:53–63`) |
| `@OPT-BEH-BEH-015` | Se hva den automatiske konklusjonen bygger på | ikke funnet | API har vedtakkilde, vitnemålsnummer, merknad (`fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/gsk.graphqls:320`, :326, :332); fs-admin henter ikke (`GSKC:64–89`) |
| `@OPT-BEH-BEH-015` | Se hvilket opptak en gjenbrukt konklusjon kommer fra | ikke funnet | ingen gjenbruk |
| `@OPT-BEH-BEH-025` | Saken behandles helautomatisk når søkeren har ett vitnemål som gir GSK | usikker | `O/autosak/SetteGrunnlagService.java:109-129` — ett ikke-annullert VM med gsk_ok=true gir grunnlag; `O/autosak/AutomatiskSaksbehandlingService.java:102-135` kjører GSK, poeng, kravelementer, kvote. Men gsk_ok er én påstand (`O/vgs/KregVgsParser.java:104`, «Skolens påstand» `vgs-dokument.graphqls:11`); vitnemål som gir GSK bare via opptakssystemets påstand får ikke grunnlag (:127-129), og opptakssystemets påstand lagres ikke. Ferdig behandlet settes ikke |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk når ingen vitnemål gir GSK | funnet | `O/autosak/SetteGrunnlagService.java:127-129`; `O/autosak/gsk/GskKonklusjonEvaluator.java:64-66` (logges `AutomatiskSaksbehandlingService.java:103-108`) |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål | funnet | `O/autosak/SetteGrunnlagService.java:109-114` FlereVitnemaalException, rull tilbake (`AutomatiskSaksbehandlingService.java:86`), AutomatiskSaksbehandlingFeil (`automatisk-saksbehandling.graphqls:222-231`) |
| `@OPT-BEH-BEH-025` | Søker med flere vitnemål der bare ett gir GSK | ikke funnet | `SetteGrunnlagService.java:110-114` stopper for alle med >1 dokument; `O/autosak/gsk/GskVedtakAutoService.java:81-83`, `O/vgs/VgsDokumentVitnemaalService.java:48-50` likeså |
| `@OPT-BEH-BEH-025` | Saksbehandleren velger vitnemålet saken behandles automatisk på | ikke funnet | BehandleSakInput bare sakId (`automatisk-saksbehandling.graphqls:188-194`); bare GSK på valgt vitnemål (`gsk.graphqls:283-294`); grunnlag/poeng/kravelementer stopper ved flere dokumenter |
| `@OPT-BEH-BEH-025` | Saken behandles automatisk på et sammensatt vitnemål | ikke funnet | søkt «sammensatt», «sammensett», «composite» — bare løpskoder/PK (`V275__vgs_loep.sql:27`, `KontrollMotor.java:145`) |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | ikke funnet | `AutomatiskSaksbehandlingService.java:83-143` endrer ikke statustype_kode; bare `O/saksbehandling/EndreStatusService.java:31-34` |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet selv om kravelementene ga mangel | ikke funnet | mangelen finnes: `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvalifisering/KvalifiseringOppdateringService.java:102-117` skriver manglende_krav på grunnlaget; viewet soknadsmangel viser den som kilde AUTOMATIKK (`fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V457__soknadsmangel_bare_publiserte.sql:148-183,185`). Men saken settes ikke ferdig behandlet (`O/autosak/AutomatiskSaksbehandlingService.java:83-143`) |
| `@OPT-BEH-BEH-025` | Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet | ikke funnet | bare saksbehandlerens publiserMangler publiserer (`O/saksbehandling/SakMangelService.java:283-330`); autosak kaller den ikke; viewet viser bare publiserte mangler på saker under/ferdig behandlet (`V457…:185`), og saken står UBEHANDLET etter automatisk behandling. min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-025` | Det som kan avgjøres, blir avgjort når <steg> ikke kan avgjøres | ikke funnet | poengene dekket (`O/regelverk/poeng/PoengberegningService.java:144-177`, `AutomatiskPoengberegningService.java:163-172`); kvoten dekket (`O/autosak/KvotesporsmalAlgoritmeService.java:209-226`); kravelementene avviker: feilen fanges (`AutomatiskSaksbehandlingService.java:153-160`), men kvalifisering og kvote kjøres likevel (:134-135, `O/saksbehandling/PropageringService.java:71-78`, `KvalifiseringEvaluator.java:205-216`) |
| `@OPT-BEH-BEH-025` | Saken blir stående under behandling når et steg ikke kan avgjøres | ikke funnet | kontrollen: autosak endrer aldri status; en ny sak står som UBEHANDLET (`V291__saksbehandling_skjema.sql:75`), ikke under behandling. Kontrollen avkreftet usikker |
| `@OPT-BEH-BEH-025` | Saksbehandleren ferdigbehandler saken etter å ha gjort resten | funnet | `O/saksbehandling/EndreStatusService.java:22-36`; `fs-admin/src/domains/soknadsbehandling/features/PersonaliaCard/PersonaliaCard.tsx:132-134,213-222` |
| `@OPT-BEH-BEH-025` | Saken blir ikke ferdig behandlet av seg selv når saksbehandleren har gjort resten | funnet | `O/regelverk/poeng/SettPoengService.java:192-199` bare UNDER_BEHANDLING; `PropageringService.java:61-64` rører ikke status |
| `@OPT-BEH-BEH-019` | Grunnlag ut fra førstegangsvitnemål og alder | funnet | `SG:301-328`, 306-308, 309-319, 338-345, prioritet `SG:287-288,330-336` |
| `@OPT-BEH-BEH-019` | Alderen regnes ut på datoen for aldersberegning | funnet | `SG:164-166`; `SB/AldersberegningsdatoUtleder.java:43-50` |
| `@OPT-BEH-BEH-019` | Førstegangsvitnemål går foran | funnet | `SG:287-298,330-336`, rader `SG:183-205` |
| `@OPT-BEH-BEH-019` | Sammensatt vitnemål gir ikke grunnlaget som krever førstegangsvitnemål | ikke funnet | leser bare foerstegangsvm (`SG:131`, `KregVgsParser.java:101`); søkt «sammensatt», «sammensett» inkl. MR-ene |
| `@OPT-BEH-BEH-019` | Flere grunnlag passer like godt | funnet | `SG:289-298` advarsel, lavest kode |
| `@OPT-BEH-BEH-019` | Grunnlag uten egenskaper for automatikken settes ikke | funnet | `SG:255-259` |
| `@OPT-BEH-BEH-019` | Bare grunnlag i regelverket til utdanningstilbudene i søknaden kan settes | funnet | `SG:133-134,236-253`, `SG:141-152` |
| `@OPT-BEH-BEH-019` | Grunnlag som ikke er aktivt, settes ikke | funnet | `SG:254` |
| `@OPT-BEH-BEH-019` | Ingen grunnlag settes automatisk når <grunn> | funnet | `SG:115-117`, 119-126, 127-129, 170-181 |
| `@OPT-BEH-BEH-019` | Søker med flere vitnemål behandles ikke automatisk | funnet | `SG:110-114` FlereVitnemaalException; rulles tilbake (`ASS:86,111-112`) |
| `@OPT-BEH-BEH-019` | Grunnlag fra vitnemålet saksbehandleren har valgt | ikke funnet | BehandleSakInput bare sakId (`automatisk-saksbehandling.graphqls:188-194`); to dokumenter gir unntak |
| `@OPT-BEH-BEH-019` | Kompetansebevis ved siden av vitnemålet stopper ikke automatikken | ikke funnet | motsatt: VM og KB i vgs_dokument (`V176__kompetanse_vgs.sql:106,124`), `SG:371-375` teller begge → `SG:110-114`; GSK-steget også (`GskVedtakAutoService.java:81-83`) |
| `@OPT-BEH-BEH-019` | Annullert vitnemål teller ikke | funnet | `SG:371-375` |
| `@OPT-BEH-BEH-019` | Grunnlaget settes etter GSK-konklusjonen | funnet | `ASS:100-112` (GSK steg 0a før grunnlag). Merk: grunnlaget bygger på gsk_ok (skolens påstand, `SG:127`), ikke vedtaket |
| `@OPT-BEH-BEH-019` | Grunnlaget settes av den automatiske behandlingen | funnet | `ASS:110-112`; knappen `fs-admin/src/domains/soknadsbehandling/features/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:30-36` |
| `@OPT-BEH-BEH-019` | Grunnlag fra utdanningstilbudet når søknadsalternativet opprettes | ikke funnet | søkt «kvalgrunnlag», «standardgrunnlag», «automatisk_grunnlag», «aut_grunnlag»; bare SG og LeggTilGrunnlagService setter grunnlag |
| `@OPT-BEH-BEH-019` | Automatikken setter ikke grunnlag når saksbehandleren har lagt til et grunnlag | funnet | `SB/LeggTilGrunnlagService.java:105-109`; `SG:99-105,227-234` (!6438 samme virkning) |
| `@OPT-BEH-BEH-019` | Saksbehandleren velger et grunnlag som automatikken har satt | usikker | API gjør det (`SB/LeggTilGrunnlagService.java:107-111`), men i fs-admin kaller klikk på avkrysset grunnlag fjernGrunnlag (`GC:107-115`) |
| `@OPT-BEH-BEH-019` | Automatikken fjerner ikke grunnlag | funnet | `SG:170-181`, 187-205; `SB/KvalifikasjonsgrunnlagOppdateringService.java:99-109` |
| `@OPT-BEH-BEH-019` | Saksbehandleren fjerner et grunnlag som er satt automatisk | funnet | `SB/FjernGrunnlagService.java:69-86`; `GC:107-115` |
| `@OPT-BEH-BEH-019` | Automatikken setter ikke et grunnlag som saksbehandleren har fjernet | ikke funnet | sletting etterlater ingen lås (`SB/FjernGrunnlagService.java:69-86`), `SG:99,227-234` setter det igjen; samme i !6438 |
| `@OPT-BEH-BEH-019` | Automatikken erstatter grunnlaget når søkeren passer til et annet | ikke funnet | `SG:187-205` skriver bare det nye (javadoc `SG:85-86`) |
| `@OPT-BEH-BEH-019` | Gjøre søknaden tilgjengelig for automatikken igjen | ikke funnet | la_staa bare true (`SB/LeggTilGrunnlagService.java:105,108`), ikke eksponert (`kvalifisering.graphqls:140-150`); søkt «laasOpp», «lasOpp», «låse opp», «frigi» |
| `@OPT-BEH-BEH-019` | Grunnlag utenfor aldersgrensen kan ikke velges manuelt | ikke funnet | `SB/LeggTilGrunnlagService.java:142-170`, :80-86 sjekker ikke alder |
| `@OPT-BEH-BEH-019` | Opptaket mangler dato for aldersberegning | usikker | API stopper (`SB/LeggTilGrunnlagService.java:40` → `SB/AldersberegningsdatoUtleder.java:20-22,37-40`, ManglerAldersberegningsdatoFeil `sak.graphqls:1069`), men fs-admin viser bare «Kunne ikke endre grunnlag» (`GC:138-146`, `soknadsbehandling.json:523`); gjelder også grunnlag uten aldersgrense |
| `@OPT-BEH-BEH-019` | Opptakskrav, kvoter og tilleggspoeng følger grunnlaget saksbehandleren legger til | usikker | opptakskrav og kvoter følger (`SB/LeggTilGrunnlagService.java:44-48` → `SB/PropageringService.java:98-111`), men tilleggspoengene regnes ikke ut: poeng = null (`SB/PoengRadOppdateringService.java:115-133`) |
| `@OPT-BEH-BEH-019` | Opptakskrav, kvoter og tilleggspoeng følger grunnlaget som er satt automatisk | funnet | `ASS:117`, 119-123, 134-135 |
| `@OPT-BEH-BEH-019` | Se at grunnlaget er satt automatisk | ikke funnet | status_automatisk_utregnet lagres (`SG:198`), ikke eksponert (`kvalifisering.graphqls:140-150`), `GC:18-41` viser ikke |
| `@OPT-BEH-BEH-019` | Se hvorfor grunnlaget ble valgt | ikke funnet | merknad_automatisk lagres (`SG:349-361`), ikke eksponert |
| `@OPT-BEH-BEH-019` | Endringsloggen viser at den automatiske behandlingen satte grunnlaget | ikke funnet | audit-triggerne droppet (`V480__stopp_endringslogg.sql:1-2,14-29`), bruker_id fjernet (`V483__endringslogg_uten_bruker.sql:11`) |
| `@OPT-BEH-BEH-018` | Poengtype som beregnes fra vitnemålet | funnet | `RP/AutomatiskPoengberegningService.java:110` — vitnemålskravkode slås opp, regnes fra vitnemålet (116-138); KAR/REA/SPR i `KontrollMotor.java:168-170` |
| `@OPT-BEH-BEH-018` | Poengtype uten kobling til vitnemålet beregnes ikke | funnet | `RP/AutomatiskPoengberegningService.java:149` — hoppes over (149-153) |
| `@OPT-BEH-BEH-018` | Beregnet poeng rundes til antall desimaler poengtypen har | funnet | `RP/PoengService.java:179` — PoengAvrunder.avrund (179-186) |
| `@OPT-BEH-BEH-018` | Skolepoeng beregnet fra vitnemålspoengene | usikker | `RP/PoengformelParser.java:12` — summen fra poengformel i regelverket (`PoengberegningEvaluator.java:78-110`), «REA + SPR høyst 4» kan uttrykkes, men regelen finnes ikke i koden; søkt «skolepoeng». Avhenger av oppsettet |
| `@OPT-BEH-BEH-018` | Ingen automatiske vitnemålspoeng når <grunn> | ikke funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/VgsDokumentVitnemaalService.java:42` — flere vitnemål/KB/annullert/ingen dekket (46-54), nullstilles med merknad (`RP/AutomatiskPoengberegningService.java:121-133`, `RP/PoengService.java:210-215`). Men «ikke GSK» sjekkes ikke, og «ingen grunnlag» gir ingen poengrader/merknad (`PoengRadOppdateringService.java:46-48`) |
| `@OPT-BEH-BEH-018` | Kompetansebevis ved siden av ett vitnemål hindrer ikke beregningen | ikke funnet | `VgsDokumentVitnemaalService.java:48` — motsatt: VM og KB telles sammen |
| `@OPT-BEH-BEH-018` | Automatisk beregnede vitnemålspoeng fjernes når søkeren har to vitnemål | usikker | `RP/AutomatiskPoengberegningService.java:125` — mutation beregnPoengAutomatisk nullstiller; men via automatisk behandling kaster `SetteGrunnlagService.java:110-114` FlereVitnemaalException før poengsteget og ruller tilbake, så gamle poeng blir stående |
| `@OPT-BEH-BEH-018` | Vitnemålspoeng fra vitnemålet saksbehandleren har valgt | ikke funnet | `RP/AutomatiskPoengberegningService.java:193` — bare byggVitnemaalForPerson (krever ett dokument); byggVitnemaal(vgdoknr) brukes ikke her |
| `@OPT-BEH-BEH-018` | Poeng som saksbehandleren endrer, blir stående | funnet | `RP/SettPoengService.java:104` — la_staa=true, status_automatisk_utregnet=false (133-136); automatikken leser la_staa=false (`RP/AutomatiskPoengberegningService.java:82`) |
| `@OPT-BEH-BEH-018` | Saksbehandleren overstyrer automatisk beregnet <poeng> | funnet | `RP/SettPoengService.java:125` — upsert la_staa=true (148-151); automatiske skrivinger har la_staa=false-vakt (`RP/PoengService.java:52,200`) |
| `@OPT-BEH-BEH-018` | Låst poeng beregnes ikke på nytt | funnet | `RP/AutomatiskPoengberegningService.java:82`; `RP/PoengService.java:200` |
| `@OPT-BEH-BEH-018` | Låse opp et poeng | funnet | `RP/SettPoengService.java:93` — laStaa alene (93-101, 163-183); fs-admin avkrysning `PCR:162-169,217-225` |
| `@OPT-BEH-BEH-018` | Poeng som ikke er låst, beregnes på nytt | funnet | `RP/PoengService.java:193` |
| `@OPT-BEH-BEH-018` | Saksbehandlerens merknad på poenget er uendret | funnet | `RP/PoengService.java:193` — skriver merknad_automatisk, aldri merknad (193-201, 45-53, 210-215) |
| `@OPT-BEH-BEH-018` | Se at poenget er beregnet automatisk, og hvilket vitnemål det bygger på | ikke funnet | API har statusAutomatiskUtregnet, vitnemaalsnummer, merknadAutomatisk (`fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/poeng.graphqls:79-101`), men fs-admin henter/viser ikke (`PoengberegningCard.tsx:20-44`, `PCR:192-237`) |
| `@OPT-BEH-BEH-018` | Se hvorfor vitnemålspoengene ikke er beregnet | ikke funnet | merknad lagres (`RP/PoengService.java:210-215`) og eksponeres (`poeng.graphqls:96-101`), vises ikke i fs-admin |
| `@OPT-BEH-BEH-018` | Finne søknader som er behandlet automatisk | ikke funnet | søkt «automatisk», «behandletAutomatisk», «behandlet_automatisk» i SakFilterV2Input (`sak.graphqls`), opptak, fs-admin |
| `@OPT-BEH-BEH-028` | Alderspoeng for søkerens alder | funnet | `RP/Alderspoeng.java:31` — ALD_ALG1 (40-54), ALG2 (57-71), ALG3 (74-88), alle åtte radene; alder på dato for aldersberegning (`RP/PoengService.java:90-101`) |
| `@OPT-BEH-BEH-028` | Alderspoengene viser hvilken alder de er regnet ut for | ikke funnet | merknad lagres (`RP/PoengService.java:99-101`), eksponert (`poeng.graphqls:96-101`), fs-admin viser ikke (`PoengberegningCard.tsx:20-44`, `PoengberegningCardRow.tsx:192-237`) |
| `@OPT-BEH-BEH-028` | Standarddatoen brukes når datoen for aldersberegning ikke er satt | ikke funnet | standarddato finnes (`AldersberegningsdatoUtleder.java:51-55`, `AldersberegningsdatoDefault.java:19-21`), men regnes ikke ut når saksbehandleren velger grunnlaget |
| `@OPT-BEH-BEH-028` | Kjønnspoeng for søkerens kjønn | funnet | `RP/KjonnspoengAlgoritme.java:11` — KJONN_ALG1–5 (11-19), alle sju radene; `RP/Kjonnspoeng.java:28-30`, `RP/PoengService.java:108-117` |
| `@OPT-BEH-BEH-028` | Kjønnspoengene viser hvilket kjønn de er regnet ut for | ikke funnet | merknad lagres (`RP/PoengService.java:113-115`), vises ikke i fs-admin |
| `@OPT-BEH-BEH-028` | Poeng for høyere utdanning | ikke funnet | søkt «studiepoeng», «høyere utdanning», «hoyere_utd», «HU_ALG», «HØY»; bare ALD_/KJONN_ (`V170__poengalgoritme_alder_kjonn.sql:13-24`, `RP/AutomatiskPoengberegningService.java:156-173`) |
| `@OPT-BEH-BEH-028` | Automatikken velger grunnlaget | funnet | `AutomatiskSaksbehandlingService.java:111` — grunnlag (111-112), poengrader (117), alderspoeng steg 1 (122-123) |
| `@OPT-BEH-BEH-028` | Saksbehandleren velger grunnlaget | ikke funnet | `LeggTilGrunnlagService.java:45` bare propagerFraGrunnlag; tom poengrad (`PRO:115-137`) |
| `@OPT-BEH-BEH-028` | Saksbehandleren får kjønnspoengene grunnlaget gir | ikke funnet | som over |
| `@OPT-BEH-BEH-028` | Poengene for grunnlaget som er fjernet, vises ikke lenger | funnet | `PRO:94` — deaktiveres (94-102); `Sak.poengListe` bare aktive (`sak.graphqls:96-98`) |
| `@OPT-BEH-BEH-028` | Poengene regnes ut på nytt når saksbehandleren endrer grunnlaget | usikker | `PRO:104` — rad per poengtype og samling, ikke per grunnlag; står med gammel verdi (104-113), regnes ikke ut på nytt |
| `@OPT-BEH-BEH-028` | Poengene regnes ikke ut på nytt av seg selv når datoen for aldersberegning endres | funnet | `AldersberegningsdatoDefault.java:23` — bare opptakshendelse; søkt propagerFra/AutomatiskPoengberegning/beregnOgLagreAlderspoeng i opptak/opptak/ |
| `@OPT-BEH-BEH-028` | Søker uten elektronisk vitnemål får tilleggspoeng | ikke funnet | når saksbehandleren velger grunnlag regnes ingenting ut |
| `@OPT-BEH-BEH-028` | Tilleggspoengene er låst for automatikken når saksbehandleren har behandlet saken | usikker | `RP/AutomatiskPoengberegningService.java:82` — lås per poeng (la_staa), ikke per sak (`RP/SettPoengService.java:104`) |
| `@OPT-BEH-BEH-028` | Tilleggspoengene regnes ut selv om poengene fra vitnemålet står tomme | ikke funnet | når saksbehandleren velger grunnlag regnes ingenting ut |
| `@OPT-BEH-BEH-028` | Poengene er satt av saksbehandleren og står | funnet | `RP/AutomatiskPoengberegningService.java:82`; `RP/PoengService.java:52` |
| `@OPT-BEH-BEH-028` | Saksbehandleren overstyrer et alderspoeng som er regnet ut automatisk | funnet | `RP/SettPoengService.java:104`, 125-153 |
| `@OPT-BEH-BEH-028` | Poengene som er regnet ut automatisk, er merket som det | ikke funnet | status_automatisk_utregnet=true (`RP/PoengService.java:49`), i API (`poeng.graphqls:93-94`), men ikke vist i fs-admin, og ikke regnet ut ved manuelt grunnlag |
| `@OPT-BEH-BEH-028` | Poengene er ikke merket som automatiske etter at saksbehandleren har endret dem | usikker | `RP/SettPoengService.java:136,151` setter status_automatisk_utregnet = false, men fs-admin viser ingen merking, verken før eller etter |
| `@OPT-BEH-BEH-028` | Poengtypen har en algoritme som ikke kan regnes ut | ikke funnet | merknad «Ukjent algoritmekode» bare i automatisk behandling (`RP/PoengService.java:124-127`), ikke vist i fs-admin |
| `@OPT-BEH-BEH-028` | Automatikken fortsetter med de andre poengene når en algoritme ikke kan regnes ut | usikker | ukjent prefiks får merknad, løkka fortsetter (`RP/AutomatiskPoengberegningService.java:163-172`); men ALD_ALG4/5 finnes i DB (`V170…:18-19`) og `AlderspoengAlgoritme.fraKode` kaster uhåndtert IllegalArgumentException (`AlderspoengAlgoritme.java:23-29`) → hele den automatiske behandlingen rulles tilbake |
| `@OPT-BEH-BEH-020` | Fagkrav som er oppfylt på vitnemålet | funnet | `O/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:161-178`; `O/autosak/kontrollmotor/KontrollMotor.java:92-95,196-198` |
| `@OPT-BEH-BEH-020` | Fagkrav som ikke er oppfylt på vitnemålet | funnet | `O/autosak/kontrollmotor/KontrollMotor.java:196-198`; `AutomatiskKravelementVurderingService.java:170` |
| `@OPT-BEH-BEH-020` | Karakteren fra vitnemålet registreres på fagkravet | funnet | `O/autosak/kontrollmotor/KontrollMotor.java:72-77,196-198`; `AutomatiskKravelementVurderingService.java:162,171` |
| `@OPT-BEH-BEH-020` | Fagkrav uten karakter oppfylles uten karakter | funnet | `O/autosak/kontrollmotor/FagSoek.java:417-418,375-378`; NB bokstavkarakter gir Ugyldig (`FagSoek.java:423-424`) |
| `@OPT-BEH-BEH-020` | Karakterkrav får karakteren fra vitnemålet | funnet | `O/autosak/kontrollmotor/KontrollMotor.java:161,293-300` |
| `@OPT-BEH-BEH-020` | Beste karakter gjelder for programfag matematikk | funnet | `O/autosak/kontrollmotor/KontrollMotor.java:84-89`; `FagSoek.java:382-398` |
| `@OPT-BEH-BEH-020` | Kravelement som ikke er koblet til vitnemålet, vurderes ikke | funnet | `O/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:116-129` |
| `@OPT-BEH-BEH-020` | Kravelement vurderes mot vitnemål fra R94 | funnet | `O/autosak/kontrollmotor/FagSoek.java:59-61`; `Kravelementer.java:656-664`, :1263-1266 |
| `@OPT-BEH-BEH-020` | Ugyldig karakter må vurderes manuelt | ikke funnet | backend setter merknad «vurder manuelt» (`AutomatiskKravelementVurderingService.java:161-167`), eksponert (`sak.graphqls:247-253`), men KS spør ikke etter merknadAutomatisk (søkt i KS og messages, !3274, !3179) |
| `@OPT-BEH-BEH-020` | Ingen automatisk vurdering når <grunn> | funnet | `O/vgs/VgsDokumentVitnemaalService.java:42-56`; `AutomatiskKravelementVurderingService.java:92-95` |
| `@OPT-BEH-BEH-020` | Kravelementene vurderes mot vitnemålet saksbehandleren har valgt | ikke funnet | `O/vgs/VgsDokumentVitnemaalService.java:48`; `AutomatiskKravelementVurderingService.java:198-207`; søkt «valgtVitnemaal», «vgdoknr» |
| `@OPT-BEH-BEH-020` | Kompetansebevis ved siden av vitnemålet stopper ikke vurderingen | ikke funnet | `O/vgs/VgsDokumentVitnemaalService.java:48` — VM + KB gir ingen vurdering |
| `@OPT-BEH-BEH-020` | Kvalifisert når alle kravelementene i en kravliste er oppfylt | funnet | `O/regelverk/kvalifisering/KvalifiseringEvaluator.java:156-160`; `KvalifiseringOppdateringService.java:97-117` |
| `@OPT-BEH-BEH-020` | Kvalifisert når én av kravlistene er oppfylt | funnet | `O/regelverk/kvalifisering/KvalifiseringEvaluator.java:161-162` |
| `@OPT-BEH-BEH-020` | Karakteren må nå karakterkravet | funnet | `O/regelverk/kvalifisering/KvalifiseringEvaluator.java:205-213` |
| `@OPT-BEH-BEH-020` | Søkeren kan være kvalifisert på ett grunnlag og ikke på et annet | funnet | `O/regelverk/kvalifisering/KvalifiseringOppdateringService.java:167-175`, :115-117 |
| `@OPT-BEH-BEH-020` | Kvalifisert per poengvariant | ikke funnet | er_kvalifisert bare på sak_kvalifikasjonsgrunnlag (`V291__saksbehandling_skjema.sql:211`) |
| `@OPT-BEH-BEH-020` | Kravelementet vurderes i den automatiske behandlingen | funnet | `O/autosak/AutomatiskSaksbehandlingService.java:119-135` |
| `@OPT-BEH-BEH-020` | Feil i vurderingen stopper ikke resten av behandlingen | funnet | `O/autosak/AutomatiskSaksbehandlingService.java:153-160`, :134-135 |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer vurderingen automatikken har satt | funnet | `O/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:180,191-192,206-216`; `KS:212-223` |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer karakteren som automatikken har satt | funnet | `KvalifiserKravelementV4Service.java:186-187,206-216`; `KS:209` |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren vurderer, låses | funnet | `KvalifiserKravelementV4Service.java:202-216` |
| `@OPT-BEH-BEH-020` | Saksbehandleren velger "la stå" på kravelementet | ikke funnet | API-et har det (`KvalifiserKravelementV4Service.java:157-164,231-241`), men fs-admin sender aldri laStaa for kravelementer (`KS:193,209,219-223`); «La stå» bare i poengkortet (`PoengberegningCardRow.tsx:162-169`) |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren bare ser på, vurderes automatisk igjen | funnet | `AutomatiskKravelementVurderingService.java:112,177` |
| `@OPT-BEH-BEH-020` | Låst kravelement vurderes ikke på nytt | funnet | `AutomatiskKravelementVurderingService.java:112,177` |
| `@OPT-BEH-BEH-020` | Andre kravelementer vurderes selv om saksbehandleren har vurdert ett | funnet | `AutomatiskKravelementVurderingService.java:100-114,169-178` |
| `@OPT-BEH-BEH-020` | Nullstilt kravelement kan vurderes automatisk igjen | funnet | `KvalifiserKravelementV4Service.java:184-193,206-216`; `KS:190-193,219-222` |
| `@OPT-BEH-BEH-020` | Unntak per grunnlag endres ikke | funnet | `AutomatiskKravelementVurderingService.java:169-178` |
| `@OPT-BEH-BEH-020` | Kravelementer for et grunnlag som fjernes, beholder vurderingen | funnet | `O/regelverk/kvalifisering/KvalifiseringKravelementV2OppdateringService.java:55-76` |
| `@OPT-BEH-BEH-020` | Kravelementer for et nytt grunnlag vurderes | funnet | `KvalifiseringKravelementV2OppdateringService.java:78-87`; `AutomatiskKravelementVurderingService.java:100-114` |
| `@OPT-BEH-BEH-020` | Se at kravelementet er vurdert automatisk | ikke funnet | API har det (`sak.graphqls:244-253`), fs-admin viser ikke (søkt i KS og messages, !3274, !3179) |
| `@OPT-BEH-BEH-020` | Manuell endring fjerner markeringen som automatisk vurdert | funnet | `KvalifiserKravelementV4Service.java:178-181` |
| `@OPT-BEH-BEH-020` | Endringsloggen viser at automatikken vurderte kravelementet | ikke funnet | kontroll: usikker → ikke funnet. Endringslogg (`V291…:1492`), fs-admin merker `fs-opptak-automatikk` (`AuditLogItem.tsx:35-36,70-73`), men autosak kjøres med saksbehandlerens ident; SYSTEM_IDENT bare i `PlasstildelingKjoringService.java:58` |
| `@OPT-BEH-BEH-020` | Finne søkere som ikke er kvalifisert | funnet | `O/saksbehandling/SakFilterConditions.java:423-424,436-438,452-460`; fs-admin `SakFilter.tsx:108-113` («Ikke kvalifiserte») |
| `@OPT-BEH-BEH-031` | Poengsum for grunnlaget kvoten er koblet til | funnet | `RP/PoengsumService.java:115` — par fra kvotetype_grunnlag, per par (123-124), lagres i sak_poengsum (168-183) |
| `@OPT-BEH-BEH-031` | Grunnlag kvoten ikke er koblet til, gir ingen poengsum i kvoten | funnet | `RP/PoengberegningService.java:139-142` |
| `@OPT-BEH-BEH-031` | Kvote søkeren ikke er plassert i, gir ingen poengsum | funnet | `RP/PoengsumService.java:61-68` — skal_kvoteplasseres og er_aktiv |
| `@OPT-BEH-BEH-031` | Poengsummen følger poengformelen til kvotetypen | funnet | `RP/PoengberegningService.java:328-360`, 132-159; `RP/PoengformelParser.java:12-20` |
| `@OPT-BEH-BEH-031` | Grunnlag søkeren ikke er kvalifisert på, gir ingen poengsum | funnet | `RP/PoengsumService.java:128`, 158-166 |
| `@OPT-BEH-BEH-031` | Poengsummen regnes ut på nytt når <endring> | funnet | `SB/PropageringService.java:52` — grunnlag (`LeggTilGrunnlagService.java:45`/`FjernGrunnlagService.java:39` → 98-115), poeng (`SettPoengService.java:43-46` → 61-64), kravelement (`KvalifiserKravelementV4Service.java:63` → 71-78), kvoteplassering (`EndreKvoteplasseringService.java:51`, `KvotesporsmalSvarService.java:257` → 52-55); alle kaller oppdaterPoengsumIsolert |
| `@OPT-BEH-BEH-031` | Uendret poengsum gir ikke nytt innslag i endringsloggen | funnet | `RP/PoengsumService.java:186-200` skrivDiff; audit-trigger `V291__saksbehandling_skjema.sql:1498`, `V388__endringslogg_hopp_over_uendrede_oppdateringer.sql:67-70` |
| `@OPT-BEH-BEH-031` | Poengsummen i de andre kvotene regnes ut når én kvote feiler | funnet | `RP/PoengberegningService.java:160` — fanges per kombinasjon |
| `@OPT-BEH-BEH-031` | Poengtypen viser hvorfor poengsummen ikke kan regnes ut | ikke funnet | årsak i merknad_automatisk (`RP/PoengberegningService.java:175-176`, `RP/PoengService.java:141-156`), i API (`poeng.graphqls:96-101`), fs-admin viser ikke (`PoengberegningCard.tsx:20-44`); formelfeil gir ingen merknad (`RP/PoengberegningService.java:191-195`) |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når søkeren ikke er plassert i noen kvote | funnet | `RP/PoengsumService.java:70` |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når søknaden ikke har noe grunnlag | funnet | `RP/PoengsumService.java:92`; `SB/PropageringService.java:105` |
| `@OPT-BEH-BEH-031` | Den høyeste poengsummen i kvoten vises | funnet | `SB/KvotesumV2Service.java:277-281`; fs-admin `OppsummeringsCardNy.tsx:52-58`, `PoengTable.tsx:63-65` |
| `@OPT-BEH-BEH-031` | Søknadsalternativ søkeren ikke er kvalifisert til, viser ingen poengsum | funnet | `SB/KvotesumV2Service.java:227`, 52-62 |
| `@OPT-BEH-BEH-008` | Opprette mangelkode | ikke funnet | `O/regelverk/MangeltypeService.java:41-58` lagrer kode, navn, kategori, aktiv, sperrerOpptak og tekst, men feltet «Kan overskrives av automatisk behandling» finnes ikke (`mangel.graphqls:100-116`, `fs-admin/src/common/messages/nb/regelverk.json:235-252`, ingen migrasjon). Kontrollen: usikker → ikke funnet |
| `@OPT-BEH-BEH-008` | Tilgjengelige kategorier for mangelkoder | funnet | `MIG/V264__soknadsmangel_kodeverk.sql:37-40` (navnet er «Kvoter», ikke «Kvote»); `MangelkodeDetails.tsx:132-137` |
| `@OPT-BEH-BEH-008` | Opptaksforvalteren ved <organisasjon> forvalter mangelkodene i <opptak> | usikker | MODIFISERE_REGELVERK for eieren av regelverkssamlingen (`MIG/V264…:61-86`), ikke opptakets forvalter; `MangelkodeDetails.tsx:268` canModify hardkodet |
| `@OPT-BEH-BEH-008` | Opptaksforvalteren merker mangelkoden for generell studiekompetanse som fullføres i vår | ikke funnet | intet merke (`mangel.graphqls:100-133`); søkt «fullføres i vår», «fullfores», «i_vaar», «vaar», «kommer senere», «DUA», «vitnemal_senere» |
| `@OPT-BEH-BEH-008` | Bare én mangelkode i regelverkssamlingen kan være merket for generell studiekompetanse som fullføres i vår | ikke funnet | merket finnes ikke |
| `@OPT-BEH-BEH-008` | Mangelkoden kan ikke merkes når den <avvik> | ikke funnet | merket finnes ikke |
| `@OPT-BEH-BEH-008` | Mangel på generelle krav hindrer kvalifisering til alle søknadsalternativene i saken | ikke funnet | kvalifiseringen leser ikke sak_mangel (SAK_MANGEL bare i MS, `ManglerPresentertService.java:61`, `SakFilterConditions.java:441`) |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav hindrer kvalifisering bare til søknadsalternativene med kompetanseregelverket | ikke funnet | regelverk lagres (`MS:106`), leses ikke av kvalifiseringen |
| `@OPT-BEH-BEH-008` | Mangel på <kategori> hindrer ikke kvalifisering | usikker | holder bare fordi ingen mangel hindrer kvalifisering |
| `@OPT-BEH-BEH-008` | Saken kan behandles ferdig selv om den har mangler | funnet | `EndreStatusService.java:31-34`; `MerkSomBehandletButton.tsx:44` |
| `@OPT-BEH-BEH-008` | Mangel som sperrer opptak holder søkeren utenfor tilbudskjøringen | ikke funnet | sperrer_opptak bare i CRUD og farge (`MC/Mangel/Mangel.tsx:115`); søkt «sperrer_opptak», «sperrerOpptak», «SPERRER_OPPTAK» |
| `@OPT-BEH-BEH-008` | Registrere mangel på spesielle krav | funnet | `MC/ManglerCard.tsx:72-78`; `MS:99-113`; kommentar etterpå (`MC/Mangel/Mangel.tsx:70-81`) |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant mangelkodene i regelverkssamlingen til opptaket | funnet | `MC/components/MangeltypeCombobox/MangeltypeCombobox.tsx:30,62` |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant kompetanseregelverkene til søknadsalternativene i saken | funnet | `MC/components/KompetanseregelverkSelect/KompetanseregelverkSelect.tsx:20-86`; backend sjekker bare samling (`MS:424-429`) |
| `@OPT-BEH-BEH-008` | Registrere mangel på kvote | ikke funnet | backend lagrer kvotespørsmål (`MS:433-445`, :107), fs-admin har ikke valg (`MC/ManglerCard.tsx:72-78`) |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant kvotespørsmålene til søknadsalternativene i saken | ikke funnet | ikke valg i fs-admin; backend bare samling (`MS:439-444`) |
| `@OPT-BEH-BEH-008` | En mangel i kategorien <kategori> <kobling> | ikke funnet | Generelle/Poeng/Spesielle dekket (`MS:419-438`, `MIG/V264…:18-19`, `KompetanseregelverkSelect.tsx:66,89`); Kvote-raden ikke |
| `@OPT-BEH-BEH-008` | Kommentaren til søkeren er valgfri | funnet | `MS:108`; `MC/ManglerCard.tsx:72-78` |
| `@OPT-BEH-BEH-008` | En sak kan ha flere mangler | funnet | `MS:99-113`; `MC/ManglerCard.tsx:178-189` |
| `@OPT-BEH-BEH-008` | Samme mangelkode i kategorien <kategori> kan <tillatt> registreres flere ganger i saken | ikke funnet | `MS:494-518` dekker GSK/STEMPEL/KAR; BOS på annet kvotespørsmål kan ikke registreres i fs-admin |
| `@OPT-BEH-BEH-008` | Slette mangel som er registrert ved en feil | funnet | `MS:351-366`; `MC/Mangel/Mangel.tsx:94-99,143-195` |
| `@OPT-BEH-BEH-008` | Saksloggen viser at saksbehandleren <hendelse> | ikke funnet | `MIG/V480__stopp_endringslogg.sql:14-29` dropper audit-triggerne; BAT-324 (`MIG/V483__endringslogg_uten_bruker.sql:9-25`) fjerner bare bruker_id, skriver ingenting nytt; utsjekking finnes ikke i fs-admin |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser at søkeren har lastet opp ny dokumentasjon | funnet | søkerens opplasting er en DOKUMENT-hendelse (`O/soknad/…/SoknadsvedleggService.java:443-448`) som `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:197-202` sender til `O/saksbehandling/SaksdokumentSyncService.java:23-31`; uleste dokumenter vises i `fs-admin/src/domains/soknadsbehandling/features/SakOverviewView/components/SakOverviewTable/SakOverviewTable.tsx:178-180` og `fs-admin/src/domains/soknadsbehandling/features/DokumenterCard/DocumentItem/DocumentItem.tsx:35,44`. Beviset rettet av kontrollen |
| `@OPT-BEH-BEH-008` | Saksbehandleren sjekker ut mangelen | ikke funnet | backend `MS:217-218`; fs-admin har ingen handling (`MC/Mangel/Mangel.tsx`; erUtsjekket bare i `PersonaliaCard.tsx:139`) |
| `@OPT-BEH-BEH-008` | Mangel som er sjekket ut hindrer ikke kvalifisering | usikker | holder bare fordi ingen mangel hindrer kvalifisering |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser om søkeren har lest mangelen | ikke funnet | backend setter status_lest_av_soker (`ManglerPresentertService.java:62-70`), fs-admin henter ikke erLestAvSoker (`MC/queries.ts:25-51`) |
| `@OPT-BEH-BEH-008` | Registrering av mangel publiserer ikke mangelen | usikker | API-et holder mangelen unna søkeren (`MS:109,116-118`; `MIG/V457__soknadsmangel_bare_publiserte.sql:81,131`), men Så gjelder Min kompetanse (min-kompetanse ikke sjekket) |
| `@OPT-BEH-BEH-008` | Saksbehandleren publiserer mangelen | usikker | backend `MS:214-215`, `V457:81`; fs-admin publiserer bare alle (`MC/ManglerCard.tsx:96-103`); min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Saksbehandleren publiserer manglene i saken | usikker | `MC/ManglerCard.tsx:96-103,194-208`, én melding (`MS:139-141`); min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren får melding hver gang saksbehandleren publiserer manglene | funnet | `MS:147-164`, :139-141 |
| `@OPT-BEH-BEH-008` | Saksbehandleren publiserer en sak som bare har automatiske mangler | ikke funnet | backend publiserMangler (`MS:306-329`) kalles ikke; knappen bare ved upubliserte registrerte (`MC/ManglerCard.tsx:66,194`) |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser at endringene ikke er publisert når <endring> | ikke funnet | «Ikke publisert» bare for !kanPubliseres (`MC/Mangel/Mangel.tsx:137-141`); endring/sletting setter ikke tilbake (`MS:210-213`) |
| `@OPT-BEH-BEH-008` | Saksbehandleren blir advart om mangler som ikke er publisert | ikke funnet | `MerkSomBehandletButton.tsx:43-45`, `PersonaliaCard.tsx:213-222` uten advarsel |
| `@OPT-BEH-BEH-008` | Publisere manglene når saken settes til ferdig behandlet | ikke funnet | ingen advarsel/valg; `EndreStatusService.java:31-34` publiserer ikke |
| `@OPT-BEH-BEH-008` | Sette saken til ferdig behandlet uten å publisere manglene | ikke funnet | ingen advarsel å velge fra |
| `@OPT-BEH-BEH-008` | Avbryte når saken har mangler som ikke er publisert | ikke funnet | ingen advarsel |
| `@OPT-BEH-BEH-008` | Søkeren får én melding om manglene som publiseres i saken | funnet | `MS:139-141`; `MC/ManglerCard.tsx:98-101` |
| `@OPT-BEH-BEH-008` | Søkeren får melding fra hver saksbehandlende organisasjon som publiserer mangler | funnet | `MS:166-168`; `MangelMeldingService.java:31,52` |
| `@OPT-BEH-BEH-008` | Søkeren åpner meldingen om mangel | ikke funnet | ingen frist: `MangelMeldingService.java:54` fristForOpplasting = null, tekst :17-19 |
| `@OPT-BEH-BEH-008` | Fristen for en mangel publisert <publisert> når <situasjon> | ikke funnet | ingen fristberegning (`MangelMeldingService.java:54`) |
| `@OPT-BEH-BEH-008` | Meldingen viser fristen for hvert søknadsalternativ med mangler | ikke funnet | som over |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav gir frist bare for søknadsalternativene med kompetanseregelverket | ikke funnet | som over |
| `@OPT-BEH-BEH-008` | Mangel på <kategori> har ettersendingsfristen | ikke funnet | som over |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav vises under søknadsalternativene med kompetanseregelverket | usikker | `V457:97-131`, `sak.graphqls:880-882`; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren ser kravene i kompetanseregelverket mangelen gjelder | usikker | standardtekst (`V457:59-64`), ikke kravelementene; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren ser kommentaren fra saksbehandleren | usikker | `V457:65,111`; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Mangel på <kategori> gjelder ikke et bestemt søknadsalternativ | usikker | tabellref SOKNAD (`V457:51-81`); min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Mangel som er sjekket ut vises ikke for søkeren | usikker | API-et holder utsjekkede mangler unna (`MIG/V457__soknadsmangel_bare_publiserte.sql:80,130`); min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren laster opp dokumentasjon for en mangel | usikker | `SoknadsvedleggService.java:438-449`; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Mangelen står til saksbehandleren har sjekket den ut | usikker | `SoknadsvedleggService.java:450-456`; `V457:80`; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Saksbehandlende organisasjon ser manglene i saken hos en annen organisasjon | ikke funnet | fs-admin viser bare åpen sak (`MC/queries.ts:3-23`); annen sak skjult av sak-RLS (`MIG/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:35-40`) |
| `@OPT-BEH-BEH-008` | Saksbehandlende organisasjon kan ikke endre manglene i saken hos en annen organisasjon | usikker | backend avviser (`MS:379-389`, `MIG/V291__saksbehandling_skjema.sql:1720-1738`); fs-admin skjuler ikke handlinger etter rolle (`MC/Mangel/Mangel.tsx:143-218`) |
| `@OPT-BEH-BEH-008` | Opptaksforvalteren ved forvaltende organisasjon ser manglene i alle sakene | usikker | ser alle saker (`V454:35-40`), leser sak_mangel (`V291:1715-1718`); ingen visning av søknaden med alle sakene |
| `@OPT-BEH-BEH-008` | Tilbyderen ser manglene når en annen organisasjon saksbehandler utdanningstilbudet | ikke funnet | sak-select uten tilbydergren (`V454:35-40`), bare sak_soknadsalternativ (:50-51) |
| `@OPT-BEH-BEH-008` | Tilgjengelige mangelkoder i filter | ikke funnet | bare filter «MANGLER» (`SakFilterConditions.java:440-448`, `sak.graphqls:523-524`) |
| `@OPT-BEH-BEH-008` | Filtrere på mangelkode | ikke funnet | som over |
| `@OPT-BEH-BEH-008` | Saken får mangel når <vurdert av> vurderer at et kravelement ikke er oppfylt | funnet | `KO:102-113`; fra `AutomatiskSaksbehandlingService.java:117` og `KvalifiserKravelementV4Service.java:63` → `PropageringService.java:135-137`; én tekst per kompetanseregelverk; søker `V457:135-183` |
| `@OPT-BEH-BEH-008` | Saken får ikke mangel når søkeren er kvalifisert på en annen kravliste | funnet | `KO:102-104,113`; `KvalifiseringEvaluator.java:47-48` |
| `@OPT-BEH-BEH-008` | Den automatiske mangelen sjekkes ut når <vurdert av> vurderer at kravelementet er oppfylt | ikke funnet | teksten settes null (`KO:113,213-216`), mangelen forsvinner, sjekkes ikke ut |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser <mangel> sammen med de registrerte manglene | ikke funnet | ManglerCard viser bare sak_mangel (`MC/queries.ts:9`); søkt «manglendeKrav», «soknadsmangel» i fs-admin |
| `@OPT-BEH-BEH-008` | Saksbehandleren kan <handling> en automatisk mangel | ikke funnet | beregnede mangler er ikke rader i sak_mangel; er_registrert_automatisk aldri true (`MS:111`); sletting skjult (`MC/Mangel/Mangel.tsx:143`) |
| `@OPT-BEH-BEH-008` | Automatisk mangel som er <handling>, <utfall> når mangelkoden <overskrivbar> | ikke funnet | ikke flagg (`mangel.graphqls:100-133`) |
| `@OPT-BEH-BEH-008` | Alle sakene i søknaden får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår | ikke funnet | søkerens svar lagres nå (`MIG/V482__fullforer_videregaende.sql:8-12`; `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java:291,895`), men ingen kode leser soknad.fullforer_videregaende for å lage mangel, og mangelkoden kan ikke merkes; søkt «fullforer_videregaende», «DUA», «fullføres i vår», «i_vaar» |
| `@OPT-BEH-BEH-008` | Saken får ikke mangel når ingen mangelkode er merket | ikke funnet | som over |
| `@OPT-BEH-BEH-008` | Den automatiske mangelen hindrer kvalifisering til søknadsalternativene i saken | ikke funnet | som over |
| `@OPT-BEH-BEH-008` | Søkeren ser den automatiske mangelen i Min kompetanse | ikke funnet | som over |
| `@OPT-BEH-BEH-008` | Søkeren får ikke egen melding om den automatiske mangelen | ikke funnet | som over |
| `@OPT-BEH-BEH-008` | Mangelen slettes når søkeren endrer søknaden | ikke funnet | endringen av svaret lagres (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/oppdatersoknad/OppdaterSoknadISoknadsbehandlingService.java:217-240`; `StudiekurvService.java:1035-1043`), men rører ikke sak_mangel |
| `@OPT-BEH-BEH-008` | Mangel som er sjekket ut slettes ikke når søkeren endrer søknaden | ikke funnet | som over |
| `@OPT-BEH-BEH-008` | Mangelen sjekkes ut når saken er behandlet helautomatisk | ikke funnet | som over; autosak rører ikke sak_mangel |
| `@OPT-BEH-BEH-008` | Mangelen sjekkes ikke ut når saken ikke er behandlet helautomatisk | ikke funnet | som over |
| `@OPT-BEH-BEH-008` | Saksbehandleren sjekker ut mangelen når søkeren har dokumentert vitnemålet | ikke funnet | DUA-mangelen lages ikke; fs-admin kan ikke sjekke ut |
| `@OPT-BEH-BEH-029` | Ny sak er Ikke behandlet | funnet | `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V291__saksbehandling_skjema.sql:75` — `sak.statustype_kode` DEFAULT 'UBEHANDLET'; saken opprettes uten status i `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/BehandlertildelingService.java:458-465`; fs-admin viser «Ikke behandlet» (`fs-admin/src/domains/soknadsbehandling/features/PersonaliaCard/PersonaliaCard.tsx:132`) |
| `@OPT-BEH-BEH-029` | Endre behandlingsstatus fra <fra> til <til> | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/EndreStatusService.java:22-36` — setter valgt status uten å sjekke fra-status; nedtrekket «Behandlingsstatus» i `fs-admin/src/domains/soknadsbehandling/features/PersonaliaCard/PersonaliaCard.tsx:131-135,213-223` |
| `@OPT-BEH-BEH-029` | Sette saken til Ferdig behandlet fra <fra> når saken har <innhold> | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/EndreStatusService.java:31-34` — FERDIG_BEHANDLET fra hvilken som helst status; «Merk som behandlet» i `fs-admin/src/domains/soknadsbehandling/features/StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:42-44`. Funnet fordi det ikke finnes noen sperre |
| `@OPT-BEH-BEH-029` | Saken kan ikke bli Ferdig behandlet uten mangel eller grunnlag | ikke funnet | `EndreStatusService.java:22-36` sjekker verken mangler eller grunnlag; knappen `MerkSomBehandletButton.tsx:42` sjekker bare status og rolle. Søkt «minst én mangel», «ett grunnlag», «ferdig behandlet», «FERDIG_BEHANDLET», «ManglerGrunnlag» i fs-plattform, fs-admin og MR-ene |
| `@OPT-BEH-BEH-029` | Saken blir Under behandling når saksbehandleren <handling> | ikke funnet | overgangen til UNDER_BEHANDLING skjer bare fra UBEHANDLET: `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng/SettPoengService.java:194-198`, `.../regelverk/kvalifisering/KvalifiserKravelementV4Service.java:77-79`, `.../regelverk/kvoteplassering/EndreKvoteplasseringService.java:122-126`, `.../saksbehandling/SettSaksdokumentErLestService.java:63-66`, `.../saksbehandling/SakMangelService.java:394-396`. Radene «registrerer en mangel» og «leser et dokument» fra Ikke behandlet er dekket; de fire fra Ferdig behandlet er ikke; «registrerer et grunnlag»: `.../saksbehandling/LeggTilGrunnlagService.java:58-121` endrer ikke status |
| `@OPT-BEH-BEH-029` | Behandlingsstatusen endres ikke når saksbehandleren <handling> | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/MerknadService.java:73-77` — bare fra UBEHANDLET; `.../saksbehandling/TilordningService.java:51` setter bare saksbehandler |
| `@OPT-BEH-BEH-029` | Ny dokumentasjon endrer ikke behandlingsstatusen | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/dokument/vedlegg/SoknadsvedleggService.java:437-456`; `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:197-202` (SaksdokumentSyncService rører ikke status) |
| `@OPT-BEH-BEH-029` | Saksloggen viser endring av behandlingsstatus når <årsak> | ikke funnet | `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V480__stopp_endringslogg.sql:14-29` dropper audit-triggerne; BAT-324 (`V483__endringslogg_uten_bruker.sql:9-25`) fjerner bare bruker_id. Ingen kode lagrer årsaken; den automatiske behandlingen setter aldri FERDIG_BEHANDLET |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren beregner på nytt etter en feil i <rettet> | ikke funnet | felles søk; nærmest behandleSakAutomatisk (én sak) og beregnPoengAutomatisk/vurderKravelementerAutomatisk med liste sak-id-er (`fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/automatisk-saksbehandling.graphqls:9-29`), uten utvalg og uten kall fra fs-admin |
| `@OPT-BEH-BEH-026` | Søknadsalternativer feilen ikke gjaldt, beregnes ikke på nytt | ikke funnet | felles søk |
| `@OPT-BEH-BEH-026` | Kravelementet saksbehandleren har vurdert, beregnes ikke på nytt | ikke funnet | felles søk. Ligner: `O/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:112` (én sak) |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren ser hvor mange søknadsalternativer som ble hoppet over | ikke funnet | felles søk |
| `@OPT-BEH-BEH-026` | Saken er fortsatt ferdig behandlet etter at poengene er beregnet på nytt | ikke funnet | felles søk. Ligner: `O/regelverk/poeng/AutomatiskPoengberegningService.java:64-183` endrer ikke status |
| `@OPT-BEH-BEH-026` | En plasstildeling som er kjørt, endres ikke | ikke funnet | felles søk. Ligner: snapshot (`O/plasstildeling/service/RangeringService.java:44-46`) |
| `@OPT-BEH-BEH-026` | Neste plasstildeling bruker det som er beregnet på nytt | ikke funnet | felles søk. Ligner: `O/plasstildeling/service/KvotesumService.java:241-255` leser gjeldende sak_poengsum |
| `@FLY-OPT-AUT-001` | Vitnemålet fra KREG er klart for behandlingen når saken er opprettet | funnet | lages: `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:311-317,126-135` → `O/vgs/HentVgsVitnemaalService.java:108-117` → `O/vgs/VgsLagringService.java:71-100` · brukes: `O/autosak/gsk/GskVedtakAutoService.java:77-89,107-115` |
| `@FLY-OPT-AUT-001` | Saken behandles automatisk når vitnemålet er importert | ikke funnet | lages: `SoknadshendelseJobb.java:126-135` · brukes: ingen; eneste kall er knappen `fs-admin/src/domains/soknadsbehandling/features/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:28-36` |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen fra vitnemålet som er importert fra KREG | ikke funnet | `O/vgs/HentVgsVitnemaalService.java:108-135` beregner ikke opptakssystemets påstand; `vgs_dokument` har bare `gsk_ok` (`V176__kompetanse_vgs.sql:113`); konklusjonen settes bare i `ASS:102` |
| `@FLY-OPT-AUT-001` | Søknaden uten GSK-konklusjon får konklusjonen i kjøringen | usikker | lages: `O/vgs/KregVgsParser.java:104`, `O/vgs/VgsLagringService.java:82,95` · brukes: `O/autosak/gsk/GskVedtakAutoService.java:64-89,113-118,165-178`; men krever `gsk_ok` OG seksfagskontroll OG grunnlagstype (`O/autosak/gsk/GskKonklusjonEvaluator.java:58-71`), ikke én av tre påstander |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk på vitnemålet som gir GSK | usikker | `O/autosak/SetteGrunnlagService.java:109-129`; «gir GSK» er bare én påstand, opptakssystemets påstand finnes ikke |
| `@FLY-OPT-AUT-001` | Søkeren hoppes over når ingen vitnemål gir GSK | funnet | `O/vgs/KregVgsParser.java:104` · `O/autosak/SetteGrunnlagService.java:127-129`, `O/autosak/gsk/GskKonklusjonEvaluator.java:64-66` |
| `@FLY-OPT-AUT-001` | Søknaden får grunnlag | funnet | lages: `O/vgs/VgsLagringService.java:71-98` · brukes: `O/autosak/SetteGrunnlagService.java:109-133,170,187-200` |
| `@FLY-OPT-AUT-001` | Søknadsalternativet får poengsum | funnet | lages: `O/autosak/SetteGrunnlagService.java:187-200` → `PS:103-106` → `O/saksbehandling/PoengRadOppdateringService.java:38-43` · brukes: `O/regelverk/poeng/AutomatiskPoengberegningService.java:72-84,116-146`, `O/regelverk/poeng/PoengsumService.java:75-95,123-124` |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoengene for grunnlaget | usikker | `O/regelverk/poeng/AutomatiskPoengberegningService.java:149-172`: bare ALD_/KJONN_ (`:36-37`); poeng for høyere utdanning finnes ikke |
| `@FLY-OPT-AUT-001` | Kravelementet er vurdert mot vitnemålet | funnet | lages: `PS:104` → `O/regelverk/kvalifisering/KvalifiseringKravelementV2OppdateringService.java:78-87` · brukes: `AKV:100-114,169-178`; rekkefølge `ASS:119-128` |
| `@FLY-OPT-AUT-001` | Kvotespørsmålet er besvart automatisk | funnet | lages: `PS:153-154` · brukes: `O/autosak/KvotesporsmalAlgoritmeService.java:68-81,144-150,228-262` |
| `@FLY-OPT-AUT-001` | Søkeren er kvalifisert når vitnemålet oppfyller kravelementene | funnet | lages: `AKV:169-178` · brukes: `ASS:134-135` → `PS:74` → `KOS:149-157,97-117` |
| `@FLY-OPT-AUT-001` | Den kvalifiserte søkeren plasseres i kvoten grunnlaget er koblet til | funnet | lages: `KOS:115-122` · brukes: `PS:75,148-157` → `O/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:301-308,169-170` |
| `@FLY-OPT-AUT-001` | Søkeren plasseres i kvoten når kvotespørsmålet er besvart ja automatisk | funnet | lages: `O/autosak/KvotesporsmalAlgoritmeService.java:228-262` · brukes: `:165` → `O/saksbehandling/KvotesporsmalSvarService.java:288,328-340` |
| `@FLY-OPT-AUT-001` | Søkeren har poengsum i kvoten | funnet | lages: `O/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:169-170`, `O/regelverk/poeng/AutomatiskPoengberegningService.java:135-146` · brukes: `PS:76,170-174` → `O/regelverk/poeng/PoengsumService.java:61-68,75-84,123-124`, `O/regelverk/poeng/PoengberegningService.java:328-361` |
| `@FLY-OPT-AUT-001` | Saken får mangel for kravelementet vitnemålet ikke oppfyller | funnet | lages: `KOS:104-117,199-206` (`manglende_krav_*` på `sak_kvalifikasjonsgrunnlag`) · brukes: viewet `soknadsmangel`, kilde AUTOMATIKK (`MIG/V457__soknadsmangel_bare_publiserte.sql:142-183`), eksponert som `mangler` på søknadsalternativet (`sak.graphqls:881`). Vises bare når publisert og saken er under eller ferdig behandlet |
| `@FLY-OPT-AUT-001` | Saken med mangelen for GSK som fullføres i vår blir ferdig behandlet | ikke funnet | lages: `soknad.fullforer_videregaende` (`O/soknad/StudiekurvService.java:895`, `V482__fullforer_videregaende.sql:15`) · brukes: ingen; utsjekking bare manuelt (`O/saksbehandling/SakMangelService.java:217-219`) |
| `@FLY-OPT-AUT-001` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | ikke funnet | `ASS:83-143` setter ikke status; bare `O/saksbehandling/EndreStatusService.java:31-34` |
| `@FLY-OPT-AUT-001` | Søkeren ser mangelen fra kravelementene når saken er ferdig behandlet | ikke funnet | viewet krever publisering og status (`V457…:168-170,185`); bare `publiserMangler` (`O/saksbehandling/SakMangelService.java:283-330`); min-kompetanse ikke sjekket |
| `@FLY-OPT-AUT-001` | Saken blir ikke ferdig behandlet når poengene ikke kan avgjøres | ikke funnet | poengfeilen fanges per kombinasjon (`O/regelverk/poeng/PoengberegningService.java:144-177`), men `ASS:83-143` rører ikke statusen, og saken står med standardverdien UBEHANDLET (`MIG/V291__saksbehandling_skjema.sql:75`), ikke under behandling. Kontrollen: usikker → ikke funnet |
| `@FLY-OPT-AUT-001` | Poengene beregnes på nytt når rangeringsregelverket er rettet | ikke funnet | ingen funksjon for ny beregning; `O/plasstildeling/service/KvotesumService.java:241-255` leser gjeldende `sak_poengsum` |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

| Feature-ID | Sjekk | Rolle og handling | Kravet sier | Koden gjør | Resultat | Bevis |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | tilgang | saksbehandler registrerer søknaden på vegne av søkeren | kan registrere | krever MODIFISERE_SØKNADSBEHANDLING i opptakets org | stemmer | `OpprettSoknadISoknadsbehandlingService.java:123–128` |
| `@OPT-BEH-BEH-030` | tilgang | systemet oppretter/oppdaterer importerte vitnemål | opptakssystemet henter og lagrer | bare systembruker/jobbtilkobling | ikke beskrevet | `V179__RLS_for_kompetanse_vgs.sql:118–121`; `V300__rls_over_paa_auth_claims.sql:246–265`; `SHJ:387–390` |
| `@OPT-BEH-BEH-030` | organisasjon | saksbehandler leser importerte vitnemål | ikke beskrevet | SELECT uten org-filter | ikke beskrevet | `V179__RLS_for_kompetanse_vgs.sql:112–116` |
| `@OPT-BEH-BEH-030` | konsistens | importert vitnemål annulleres | annullert, ikke slettet; konklusjonen står (015) | flagget settes, men automatiske GSK-vedtak trekkes tilbake | avviker | `V/VgsLagringService.java:58–62`; `V/HentVgsVitnemaalService.java:130–132` |
| `@OPT-BEH-BEH-030` | konsistens | vitnemålet lagres på søkeren | gjelder alle søknadene | FK til person | stemmer | `V176__kompetanse_vgs.sql:118`; `V/HentVgsVitnemaalService.java:59–73` |
| `@OPT-BEH-BEH-032` | tilgang | saksbehandler starter automatisk behandling | saksbehandleren ved organisasjonen | ingen tilgangsdirektiv; bare synlighet (SE_ holder); skriving styres av RLS per tabell; knappen bare feature-flagg | ikke beskrevet | `GQL:52-58`; `ASS:89-97`; `V454…:36-38`; `BTN:50-53` |
| `@OPT-BEH-BEH-032` | organisasjon | saksbehandler ved UiO starter for sak hos UiB | kan ikke | sak usynlig, UkjentSakException | stemmer | `V454…:35-40`; `ASS:89-97` |
| `@OPT-BEH-BEH-032` | organisasjon | opptaksforvalter starter for sak hos deltakende org | ikke beskrevet | ser alle saker, kommer forbi sjekken; skriving avhenger av RLS | usikker | `V454…:39-40`; `ASS:89-97` |
| `@OPT-BEH-BEH-032` | tilgang | opptaksforvalter skrur automatikken av/på | forvaltende org | ingen innstilling | ikke funnet | søkt «automatisk_saksbehandling», «automatikk», «stopptidspunkt» |
| `@OPT-BEH-BEH-032` | konsistens | automatikken endrer grunnlag saksbehandleren har valgt | endres ikke | låsen hindrer det | stemmer | `LeggTilGrunnlagService.java:105-109`; `SetteGrunnlagService.java:99-105` |
| `@OPT-BEH-BEH-015` | tilgang | saksbehandler oppretter/endrer GSK-konklusjon | saksbehandleren legger til og endrer | MODIFISERE hos org med sak på søknaden | stemmer | `GV:260–272` |
| `@OPT-BEH-BEH-015` | tilgang | saksbehandler starter automatisk behandling | ikke beskrevet | ingen egen sjekk; RLS på gsk_vedtak | ikke beskrevet | `ASS:89–97`; `V256__RLS_for_gsk_vedtak.sql:18–28` |
| `@OPT-BEH-BEH-015` | organisasjon | leser/endrer konklusjon satt av annen org | gjelder søknaden | én per søker og opptak | stemmer | `A:136–143`; `GV:191–194` |
| `@OPT-BEH-BEH-015` | konsistens | vitnemålet annulleres i KREG | konklusjonen står, saken tagges og settes under behandling, avsluttede opptak røres ikke | automatiske konklusjoner trekkes tilbake i alle opptak, uten tagg; kvalifisering regnes ikke på nytt | avviker | `T:66–90`, :25–30 |
| `@OPT-BEH-BEH-015` | konsistens | saksbehandler endrer låst konklusjon | ikke beskrevet | låst kan ikke endres; ny KVALIFISERT kan erstatte | ikke beskrevet | `GV:447–449`, :414–417 |
| `@OPT-BEH-BEH-025` | tilgang | saksbehandler setter ferdig behandlet | saksbehandleren ved UiO | RLS MODIFISERE for sakens org; fs-admin deaktiverer uten rolle | stemmer | `V291__saksbehandling_skjema.sql:1550-1558`; `PersonaliaCard.tsx:115,216` |
| `@OPT-BEH-BEH-025` | tilgang | saksbehandler starter automatisk behandling | ikke beskrevet | ingen sjekk i tjenesten, bare RLS; knappen bare feature-flagg | ikke beskrevet | `AutomatiskSaksbehandlingService.java:83-97`; `BehandleSakAutomatiskButton.tsx:50-62` |
| `@OPT-BEH-BEH-025` | organisasjon | behandler sak hos annen org automatisk | saken hos UiO | RLS-oppslag, UkjentSakException; GSK-vedtak sjekkes på tvers av org i opptaket | stemmer | `AutomatiskSaksbehandlingService.java:89-97`; `V291…:1538-1543`; `GskVedtakAutoService.java:136-143` |
| `@OPT-BEH-BEH-025` | konsistens | endrer status | ferdig når alt er avgjort | EndreStatusService godtar enhver overgang uten å sjekke | ikke beskrevet | `EndreStatusService.java:22-36` |
| `@OPT-BEH-BEH-019` | tilgang | saksbehandler legger til og fjerner grunnlag | ikke beskrevet | les SE_/MODIFISERE, skriv MODIFISERE (hvilken som helst org); GC uten rollesjekk | ikke beskrevet | `V291__saksbehandling_skjema.sql:1600-1618` |
| `@OPT-BEH-BEH-019` | tilgang | saksbehandler kjører automatisk behandling | ikke beskrevet | ingen egen sjekk | ikke beskrevet | `automatisk-saksbehandling.graphqls:52-58`; `ASS:89-97` |
| `@OPT-BEH-BEH-019` | organisasjon | saksbehandler endrer grunnlag på sak hos annen org | ikke beskrevet | policy uten org; grensen er sak-RLS der SE_ holder; SE i A + MODIFISERE i B kan trolig endre A | usikker | `SB/LeggTilGrunnlagService.java:62-69`; `V291…:1605-1607`; `V454…:35-40` |
| `@OPT-BEH-BEH-019` | konsistens | saksbehandler fjerner grunnlag | søknaden vurderes på nytt | sletting committes, propagering frikoblet | stemmer | `SB/FjernGrunnlagService.java:36-42` |
| `@OPT-BEH-BEH-019` | konsistens | saksbehandler legger til grunnlag | tilleggspoengene følger | poeng = null til automatisk behandling | avviker | `SB/PoengRadOppdateringService.java:115-133` |
| `@OPT-BEH-BEH-018` | tilgang | saksbehandler endrer og låser poeng | ikke beskrevet | les SE_/MODIFISERE, skriv MODIFISERE for sakens org | ikke beskrevet | `V291__saksbehandling_skjema.sql:1744-1762`; `PCR:213,221,231` |
| `@OPT-BEH-BEH-018` | organisasjon | saksbehandler endrer poeng på sak i annen org | ikke beskrevet | krever handling for sak_poeng.organisasjonskode; sak leses under RLS | stemmer | `RP/SettPoengService.java:78-86`; `V291…:1749-1758` |
| `@OPT-BEH-BEH-018` | konsistens | grunnlaget fjernes | ikke beskrevet | poengrad deaktiveres (er_aktiv=false), reaktiveres med bevart verdi | ikke beskrevet | `PoengRadOppdateringService.java:24-28`; `RP/SettPoengService.java:106-123` |
| `@OPT-BEH-BEH-018` | tilgang | saksbehandler starter automatisk poengberegning | ikke beskrevet | mutationen har ingen egen sjekk, bare RLS på sak_poeng | ikke beskrevet | `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/automatisk-saksbehandling.graphqls:9-15`; `RP/AutomatiskPoengberegningService.java:49-62` (tilføyd av kontrollen) |
| `@OPT-BEH-BEH-028` | tilgang | saksbehandler endrer og låser tilleggspoeng | ikke beskrevet | les SE_/MODIFISERE, skriv MODIFISERE for sakens org | ikke beskrevet | `V291__saksbehandling_skjema.sql:1744-1762` |
| `@OPT-BEH-BEH-028` | organisasjon | saksbehandler endrer poeng på sak i annen org | ikke beskrevet | handling for sak_poeng.organisasjonskode; sak via RLS | stemmer | `RP/SettPoengService.java:78-86` |
| `@OPT-BEH-BEH-028` | konsistens | fjerner grunnlaget poengtypen gjelder for | poengene vises ikke lenger | deaktiveres, kommer tilbake med gammel verdi | stemmer | `PRO:94-102`, 104-113 |
| `@OPT-BEH-BEH-028` | konsistens | saksbehandler legger til grunnlag | tilleggspoengene regnes ut på samme måte uansett hvem som velger grunnlaget | poengradene lages med poeng = null til automatikken kjører | avviker | `PRO:115-133`; `SB/LeggTilGrunnlagService.java:44-48` |
| `@OPT-BEH-BEH-020` | tilgang | saksbehandler endrer vurdering av kravelement | saksbehandleren vurderer | RLS UPDATE krever MODIFISERE_SØKNADSBEHANDLING | stemmer | `V291__saksbehandling_skjema.sql:1632-1636` |
| `@OPT-BEH-BEH-020` | organisasjon | saksbehandler endrer kravelement på sak hos annen org | ikke beskrevet | tabell-RLS uten org; grensen fra saksoppslag under org-filtrert RLS | ikke beskrevet | `KvalifiserKravelementV4Service.java:71-74`; `V291…:1624-1636` |
| `@OPT-BEH-BEH-020` | tilgang | saksbehandler endrer kravelement i fs-admin | ikke beskrevet | ingen rollesjekk i KS; backend avviser | ikke beskrevet | `KS:148` |
| `@OPT-BEH-BEH-020` | konsistens | grunnlag fjernes | vurderingen beholdes | deaktiveres, unntak bevares | stemmer | `KvalifiseringKravelementV2OppdateringService.java:25-31,55-76` |
| `@OPT-BEH-BEH-031` | tilgang | saksbehandler leser poengsum per kvote | ikke beskrevet | via sak_soknadsalternativ under RLS | ikke beskrevet | `V454__forvalter_ser_saker_krever_modifisere_opptak.sql:41-49` |
| `@OPT-BEH-BEH-031` | konsistens | grunnlag/kvote/poeng endres | regnes ut på nytt | egen transaksjon etter commit; feiler den, står gammel poengsum | stemmer | `SB/PropageringService.java:170`, `PropageringRunner.java:19-28` |
| `@OPT-BEH-BEH-031` | konsistens | opptaksforvalter endrer poengformel eller kobling kvotetype–grunnlag i regelverket | ikke beskrevet | ingen regelverksendring kaller propageringen, så poengsummen regnes ikke ut på nytt | ikke beskrevet | `SB/PropageringService.java:173` (tilføyd av kontrollen) |
| `@OPT-BEH-BEH-008` | tilgang | opptaksforvalter oppretter/endrer mangelkode | forvalteren av opptaket | MODIFISERE_REGELVERK for eier av samlingen | usikker | `MIG/V264…:61-86` |
| `@OPT-BEH-BEH-008` | tilgang | opptaksforvalter endrer mangelkode i fs-admin | ikke beskrevet | knappene vises for alle (canModify hardkodet), RLS avviser ved lagring (`MT:91-96`) | avviker | `MangelkodeDetails.tsx:268` |
| `@OPT-BEH-BEH-008` | tilgang | saksbehandler registrerer/endrer/sletter mangel | saksbehandlende org i saken sin | WITH CHECK MODIFISERE for sakens org; sak via RLS | stemmer | `MIG/V291…:1720-1738`; `MS:68,191,353` |
| `@OPT-BEH-BEH-008` | tilgang | saksbehandler uten skrivetilgang ser mangelkortet | skjul | ManglerCard/Mangel sjekker ikke rolle | avviker | `MC/ManglerCard.tsx:137-209`; `MC/Mangel/Mangel.tsx:143-218` |
| `@OPT-BEH-BEH-008` | tilgang | saksbehandler publiserer mangler | saksbehandlende org | publiserMangler krever MODIFISERE i sakens org | stemmer | `MS:340-349` |
| `@OPT-BEH-BEH-008` | organisasjon | saksbehandler leser mangler | orgene som behandler søknaden | select-policy uten org-filter | avviker | `MIG/V291…:1715-1718` |
| `@OPT-BEH-BEH-008` | organisasjon | registrerer mangel med kode fra annen samling | velger i opptakets samling | backend sjekker ikke samling eller aktiv | avviker | `MS:65-113`; `MangeltypeCombobox.tsx:30` |
| `@OPT-BEH-BEH-008` | konsistens | fjerner mangelkode i bruk | ikke beskrevet | bare deaktivering; FK uten cascade | stemmer | `MIG/V291…:518-519`; `MangelkodeDetails.tsx:270-272` |
| `@OPT-BEH-BEH-008` | konsistens | org behandler ikke lenger søknaden | ikke beskrevet | manglene skjules for søkeren | stemmer | `MIG/V457…:82-93` |
| `@OPT-BEH-BEH-008` | konsistens | opptaksforvalter endrer kategorien på en mangelkode som er i bruk | ikke beskrevet | kategorien endres uten å sjekke manglene som bruker koden; koblingssjekken gjelder bare ny eller endret kobling | avviker | `MT:80-83`; `MS:418-438` (tilføyd av kontrollen) |
| `@OPT-BEH-BEH-029` | tilgang | saksbehandler endrer behandlingsstatus | saksbehandleren ved saksbehandlende org | UPDATE WITH CHECK krever MODIFISERE_SØKNADSBEHANDLING for sakens org; fs-admin slår av uten rolle | stemmer | `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V300__rls_over_paa_auth_claims.sql` (auth.har_orgtilgang(MODIFISERE_SØKNADSBEHANDLING, sakens organisasjon)); `PersonaliaCard.tsx:115,216`; `MerkSomBehandletButton.tsx:33,42` — fs-admin deaktiverer i stedet for å skjule |
| `@OPT-BEH-BEH-029` | organisasjon | opptaksforvalter endrer status på sak hos annen org | ikke beskrevet | update gir 0 rader, saken returneres uendret uten feil | usikker | `EndreStatusService.java:31-36`; `V454__forvalter_ser_saker_krever_modifisere_opptak.sql:35-40` |
| `@OPT-BEH-BEH-026` | tilgang | opptaksforvalter ved HK-dir beregner på nytt | opptaksforvalteren ved HK-dir | finnes ikke | ikke funnet | felles søk |
| `@OPT-BEH-BEH-026` | organisasjon | opptaksforvalter beregner for saker hos andre org | ikke beskrevet | finnes ikke; sak-RLS per org | ikke funnet | `V291__saksbehandling_skjema.sql:1538-1558` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | Uten KREG-konfigurasjon hentes ingenting, søknaden tildeles likevel | annet | `SHJ:126`; `V/HentVgsVitnemaalService.java:56–57` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | Søker som ikke kan leses hoppes over | annet | `V/HentVgsVitnemaalService.java:67–69` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | KREG-kall 10 s / 30 s; feil logges | grense | `V/KregKlient.java:35`, :69, :74–82; `SHJ:410–411` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | Bare noder med reformkode importeres | annet | `V/KregVgsParser.java:71–73` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | Manglende førstegangsvitnemål/GSK-påstand blir false; J/N godtas | standardverdi | `V/KregVgsParser.java:101`, :104, :370–379 | uklart om ønsket |
| `@OPT-BEH-BEH-030` | Fagnavn faller tilbake til fagkoden; lagret fagnavn oppdateres aldri | standardverdi | `V/VgsLagringService.java:122`, :126 | testes i fase 2 |
| `@OPT-BEH-BEH-030` | KREG hentes én gang per søker per runde | annet | `SHJ:316–317` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | KREG hentes også ved overstyring av utdanningsbakgrunn og søknad om tidlig opptak | annet | `UtdanningsbakgrunnOverstyringService.java:186–191`; `SokTidligOpptakService.java:78–83` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-030` | Avbrutt henting tas ikke igjen i neste runde selv om loggen sier det | annet | `SHJ:130–132`, :315, :361, :117 | uklart om ønsket (sannsynligvis feil) |
| `@OPT-BEH-BEH-030` | Annullert vitnemål trekker tilbake automatiske GSK-vedtak ved hver henting | tilstandsovergang | `V/HentVgsVitnemaalService.java:127–132` | uklart om ønsket (015 sier konklusjonen står) |
| `@OPT-BEH-BEH-030` | Saksbehandlerens nye rekkefølge på studieønskene henter også fra KREG | annet | `StudiekurvService.java:1082–1146` (:1142) | testes i fase 2 |
| `@OPT-BEH-BEH-030` | Kompetanseoppnåelser med status REGISTRERT og IMPORTERT importeres begge som ikke annullert | annet | `KregVgsParser.java:107`; `schema.graphql:420–421` | testes i fase 2 |
| `@OPT-BEH-BEH-032` | Knappen vises bare med Unleash-flagget automatisk-soknadsbehandling-trigger | annet | `BTN:50-53` | uklart om ønsket |
| `@OPT-BEH-BEH-032` | Starten bekreftes i dialog, snackbar ved suksess/feil | annet | `BTN:42-45,63-84`; `soknadsbehandling.json:687-693` | testes i fase 2 |
| `@OPT-BEH-BEH-032` | Flere vitnemål: «Søkeren har N vitnemål og saken kan derfor ikke behandles automatisk», hele transaksjonen rulles tilbake | validering | `SetteGrunnlagService.java:110-114`; `ASS:86` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-032` | Feil i kravelementvurdering eller poengsum svelges, resten lagres; andre feil ruller tilbake alt | annet | `ASS:125-128,153-161`, :23-33 | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-032` | Usynlig sak gir «Kunne ikke finne saken som skulle behandles automatisk» | tilgangssjekk | `ASS:95-97` | testes i fase 2 |
| `@OPT-BEH-BEH-032` | Eneste VGS-dokument av annen type enn VM gir ikke automatisk grunnlag, ingenting skrives på saken | annet | `SetteGrunnlagService.java:118-125` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-032` | Autosak setter GSK-vedtak før grunnlaget; IngenAutomatikk bare logges | annet | `AutomatiskSaksbehandlingService.java:100-108` | testes i fase 2 |
| `@OPT-BEH-BEH-027` | GSK gis bare når skolens påstand er ja; seksfagskontrollen bare kryssjekk | annet | `E:64–68`; `GskVedtakAutoService.java:113` | uklart om ønsket |
| `@OPT-BEH-BEH-027` | NOR1049 som privatist dekker hovedmål bare uten NOR1050 | validering | `K:837` | testes i fase 2 |
| `@OPT-BEH-BEH-027` | R94-koder (AA65xx) godtas som R1/R2/S1/S2 på KL-vitnemål | annet | `K:465`, :473, :481, :489 | testes i fase 2 |
| `@OPT-BEH-BEH-027` | Muntlig-kodene alene gir ikke påbyggingsmatematikk | annet | `K:1138–1140` | testes i fase 2 |
| `@OPT-BEH-BEH-027` | Programområde uten kode hoppes over; uten nivåkode sorteres først | standardverdi | `VgsDokumentVitnemaalMapper.java:114–115` | testes i fase 2 |
| `@OPT-BEH-BEH-027` | Bare én merknad per fag går inn i kontrollmotoren | annet | `VgsDokumentVitnemaalMapper.java:95–106` | uklart om ønsket |
| `@OPT-BEH-BEH-027` | Ukjent reformkode gir ingen KLY/RFA | annet | `E:93–94` | testes i fase 2 |
| `@OPT-BEH-BEH-027` | FAM13-filter: KL-koden for R1/R2/S1/S2 teller bare når den erstatter et R94-fag som gir det samme | annet | `Kravelementer.java:462,470,478,486`, `FagSoek.java:235-243` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-027` | Reformkoden KL23 regnes som Kunnskapsløftet i seksfagskontrollen, men gir ikke KLY | annet | `FagSoek.java:60-62`, `GskKonklusjonEvaluator.java:84-94` | uklart om ønsket |
| `@OPT-BEH-BEH-027` | Bare fag med statusAktiv er med, men alle lagrede fag regnes som aktive; vgs_dokument_fag_aktiv brukes ikke | annet | `Vitnemaal.java:26`, `VgsDokumentVitnemaalMapper.java:71-73` | uklart om ønsket |
| `@OPT-BEH-BEH-015` | Semi-automatisk konklusjon på valgt vitnemål (eier, ikke annullert, utstedelsesdato); KLY/RFA bare her; mutationen brukes ikke av fs-admin | annet | `SettGskKonklusjonService.java:117–133`; `gsk.graphqls:283` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-015` | Semi-automatisk krever dato for aldersberegning | validering | `SettGskKonklusjonService.java:69` | uklart om ønsket |
| `@OPT-BEH-BEH-015` | Kvalifiseringen regnes på nytt etter manuell konklusjon | annet | `GV:81`, :102, :126–152 | testes i fase 2 |
| `@OPT-BEH-BEH-015` | Positiv krever grunnlagskode, negativ mangeltype | obligatorisk felt | `GV:279–307`, :328–365; `GSKC:217–222` | testes i fase 2 |
| `@OPT-BEH-BEH-015` | Låst konklusjon kan ikke endres; låsing setter dagens dato | tilstandsovergang | `GV:228–233`, :447–449 | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-015` | Manuell annullering krever annullert vitnemål | validering | `GV:450–480` | uklart om ønsket |
| `@OPT-BEH-BEH-015` | Automatisk konklusjon får merknad, kilde AUT og vitnemålsnummer | standardverdi | `A:160–176` | testes i fase 2 |
| `@OPT-BEH-BEH-015` | Manuell fra fs-admin får kilde NOM og dagens dato | standardverdi | `GSKC:228`, :231 | uklart om ønsket |
| `@OPT-BEH-BEH-015` | Løpskoden normaliseres; ukjent løp gir ingen automatikk | annet | `E:44–49`, :58–59 | testes i fase 2 |
| `@OPT-BEH-BEH-015` | Automatisk sti krever fast grunnlagskode på løpet (ingen KLY/RFA) | annet | `E:61–62`; `A:89` | testes i fase 2 |
| `@OPT-BEH-BEH-015` | Manuell konklusjon setter saken til under behandling | tilstandsovergang | `GV:175–179`, :211–215 | testes i fase 2 |
| `@OPT-BEH-BEH-015` | Tilbakekallingen nullstiller grunnlagskode og grunnlagsdato og setter annulleringsårsak AVM | tilstandsovergang | `GskVedtakTilbakekallingService.java:81-84` | uklart om ønsket (kravet sier konklusjonen står urørt) |
| `@OPT-BEH-BEH-015` | Endring krever at en konklusjon finnes | validering | `GskVedtakService.java:195-197` | testes i fase 2 |
| `@OPT-BEH-BEH-025` | Ensomt KB gir ikke automatisk grunnlag eller GSK-vedtak | validering | `SetteGrunnlagService.java:119-126`; `GskVedtakAutoService.java:81-83` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-025` | VM + KB gir FlereVitnemaalException | validering | `SetteGrunnlagService.java:109-114` | uklart om ønsket (kravene sier KB ikke stopper) |
| `@OPT-BEH-BEH-025` | Flere vitnemål ruller tilbake hele behandlingen, også GSK-vedtaket fra steg 0a | tilstandsovergang | `AutomatiskSaksbehandlingService.java:86,102,111-112` | uklart om ønsket |
| `@OPT-BEH-BEH-025` | Låst grunnlag (la_staa) → ikke automatisk grunnlag | tilstandsovergang | `SetteGrunnlagService.java:99-105` | testes i fase 2 |
| `@OPT-BEH-BEH-025` | Manuelle handlinger flipper UBEHANDLET → UNDER_BEHANDLING | tilstandsovergang | `SettPoengService.java:192-199`; `SakMangelService.java:392-397`; `KvalifiserKravelementV4Service.java:77-79` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-025` | Automatisk behandling startes bare fra knapp bak feature-flagg | annet | `BehandleSakAutomatiskButton.tsx:50-62` | uklart om ønsket (-032) |
| `@OPT-BEH-BEH-025` | Grunnlag uten gyldige par deltar ikke i automatisk valg; saken kan bli stående uten grunnlag | annet | `SetteGrunnlagService.java:140-160` | testes i fase 2 |
| `@OPT-BEH-BEH-025` | API-dokumentasjonen lover at alle steg rulles tilbake når ett feiler, men poeng og kravelementer er isolert | annet | `automatisk-saksbehandling.graphqls:44-51` mot `AutomatiskSaksbehandlingService.java:153-160`, `PoengberegningService.java:161-178` | uklart om ønsket (dokumentasjonen er utdatert) |
| `@OPT-BEH-BEH-019` | Manuelt grunnlag må være aktivt, i samlingen og ha gyldig par | validering | `SB/LeggTilGrunnlagService.java:80-86,142-170` | testes i fase 2 |
| `@OPT-BEH-BEH-019` | Fjerne grunnlag som ikke er valgt gir feil | validering | `SB/FjernGrunnlagService.java:80-86` | testes i fase 2 |
| `@OPT-BEH-BEH-019` | Manglende dato stopper legg til og fjern for alle grunnlag | grense | `SB/AldersberegningsdatoUtleder.java:37-41`; `SB/FjernGrunnlagService.java:34` | uklart om ønsket |
| `@OPT-BEH-BEH-019` | Uten DATO_ALDERSBEREGNING brukes PUBLISERING_RESULTAT | standardverdi | `SB/AldersberegningsdatoUtleder.java:51-55` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-019` | Aldersgrense uten operator matcher aldri | validering | `SG:309-315,338-344` | testes i fase 2 |
| `@OPT-BEH-BEH-019` | Grunnlag uten gyldig par deltar ikke | annet | `SG:141-159` | testes i fase 2 |
| `@OPT-BEH-BEH-019` | Bare aldersgrense = lavest prioritet (3) | annet | `SG:327,330-336` | testes i fase 2 |
| `@OPT-BEH-BEH-019` | Manuelt valg nullstiller merknad_automatisk | annet | `SB/LeggTilGrunnlagService.java:107-111` | testes i fase 2 |
| `@OPT-BEH-BEH-019` | Grunnlaget bygger på skolens gsk_ok, ikke på GSK-konklusjonen fra steg 0a | annet | `SetteGrunnlagService.java:127`, `AutomatiskSaksbehandlingService.java:102` | uklart om ønsket (etter #875) |
| `@OPT-BEH-BEH-019` | «Krever et vitnemål» er alltid oppfylt når automatikken kjører | annet | `SetteGrunnlagService.java:302-305` | testes i fase 2 |
| `@OPT-BEH-BEH-018` | Ikke-tall fra kontrollmotoren lagres som 0 | standardverdi | `RP/PoengService.java:176` | uklart om ønsket |
| `@OPT-BEH-BEH-018` | Ukjent poengalgoritme gir merknad, ingen verdi | annet | `RP/AutomatiskPoengberegningService.java:163` | testes i fase 2 |
| `@OPT-BEH-BEH-018` | Feil i poengsumberegning skrives i merknad_automatisk | annet | `RP/PoengService.java:141` | testes i fase 2 |
| `@OPT-BEH-BEH-018` | Manuelt poeng valideres mot min/maks/desimaler/poengtrinn | validering | `RP/SettPoengService.java:71` | testes i fase 2 |
| `@OPT-BEH-BEH-018` | Lagres poeng uten merknad, slettes saksbehandlerens merknad | annet | `RP/SettPoengService.java:134`, 149 | uklart om ønsket |
| `@OPT-BEH-BEH-018` | Poengrad for poengtype som ikke lenger gjelder deaktiveres og kan ikke endres | tilstandsovergang | `RP/SettPoengService.java:109` | testes i fase 2 |
| `@OPT-BEH-BEH-018` | Å endre merknaden låser også poenget | tilstandsovergang | `PoengberegningCardRow.tsx:154-160`, `SettPoengService.java:104` | uklart om ønsket |
| `@OPT-BEH-BEH-018` | Automatisk behandling stopper ved flere vitnemål, unntatt når grunnlaget er låst (da nullstilles vitnemålspoengene) | annet | `SetteGrunnlagService.java:99-114` | uklart om ønsket |
| `@OPT-BEH-BEH-018` | Automatisk grunnlag settes bare når vitnemålet gir GSK (gsk_ok); poengberegningen sjekker ikke GSK | annet | `SetteGrunnlagService.java:127-129` | testes i fase 2 |
| `@OPT-BEH-BEH-028` | ALD_ALG4/5 finnes i DB, koden kjenner bare 1–3 og kaster | annet | `V170__poengalgoritme_alder_kjonn.sql:18`, `AlderspoengAlgoritme.java:9-16` | uklart om ønsket |
| `@OPT-BEH-BEH-028` | ALD_ALG1 gir 1 poeng ved 20 år og 3 ved 22 år | grense | `RP/Alderspoeng.java:44` | testes i fase 2 |
| `@OPT-BEH-BEH-028` | Alder = hele år (Period.between) | annet | `Aldersgrense.java:55` | testes i fase 2 |
| `@OPT-BEH-BEH-028` | Mangler både dato for aldersberegning og publisering → ManglerDatoForAldersberegningException | validering | `AldersberegningsdatoUtleder.java:17` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-028` | Mangler fødselsdato → IllegalStateException | validering | `RP/PoengService.java:251` | uklart om ønsket |
| `@OPT-BEH-BEH-028` | Settes poeng uten laStaa, låses poenget for automatikken (standard true) | standardverdi | `SettPoengService.java:104` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-028` | Poeng som saksbehandleren setter, valideres mot poengtypen | validering | `SettPoengService.java:71-76` | testes i fase 2 |
| `@OPT-BEH-BEH-028` | Saken går fra ubehandlet til under behandling når saksbehandleren setter poeng | tilstandsovergang | `SettPoengService.java:192-199` | testes i fase 2 |
| `@OPT-BEH-BEH-028` | Poeng på en deaktivert rad kan ikke settes | validering | `SettPoengService.java:106-123` | testes i fase 2 |
| `@OPT-BEH-BEH-028` | Kun laStaa sendt: bare låsen oppdateres | annet | `SettPoengService.java:88-102` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Bare vitnemalskrav_kode1 brukes, kode2 ignoreres | annet | `AutomatiskKravelementVurderingService.java:37-40,105` | uklart om ønsket |
| `@OPT-BEH-BEH-020` | Fagkrav bruker snitt av standpunkt og eksamen; bare PFMAT beste | grense | `KontrollMotor.java:65-143`, `FagSoek.java:353-378` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-020` | Karakter utenfor 0–6 eller ikke tall er ugyldig | validering | `FagSoek.java:416-425` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Fagkrav ikke oppfylt får ingen karakter | annet | `KontrollMotor.java:196-198` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Karakterkrav med 0 regnes ikke oppfylt | grense | `KontrollMotor.java:294-300` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Resultatkrav uten resultat gir ikke kvalifisert | annet | `KvalifiseringEvaluator.java:207-208` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Kompetansekrav som krever GSK kvalifiserer bare med gjeldende KVALIFISERT GSK-vedtak | annet | `KvalifiseringEvaluator.java:366-369`, `KvalifiseringOppdateringService.java:126-134` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-020` | Ikke kvalifisert gir automatisk mangeltekst; ny tekst nullstiller publisering og lest | tilstandsovergang | `KvalifiseringOppdateringService.java:102-113,204-212` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-020` | Manuell vurdering flytter ubehandlet sak til under behandling | tilstandsovergang | `KvalifiserKravelementV4Service.java:76-80` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Merknad alene rører ikke låsen; maks 4000 tegn; minst én operasjon | validering | `kvalifisering.graphqls:56-58,72-73`; `KvalifiserKravelementV4Service.java:149-155` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Unntak krever valgt grunnlag og kan ikke stå uten vurdering | validering | `kvalifisering.graphqls:19-21,86-89` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Ugyldig karakter gir likevel kravet_er_oppfylt=true når faget finnes | annet | `AutomatiskKravelementVurderingService.java:161-170`, `KontrollMotor.java:197-198` | uklart om ønsket |
| `@OPT-BEH-BEH-020` | Bare kravkoder kontrollmotoren kjenner, vurderes; ukjent kode1 hoppes over uten melding | annet | `AutomatiskKravelementVurderingService.java:120`, `KontrollMotor.java:62-171` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Bare aktive kravelementrader vurderes | annet | `AutomatiskKravelementVurderingService.java:113` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Flere vitnemål stopper hele den automatiske behandlingen, ikke bare kravelementene | tilstandsovergang | `AutomatiskSaksbehandlingService.java:62-64,111-112` | uklart om ønsket |
| `@OPT-BEH-BEH-031` | Kvotetype uten standard poengformel gir ingen poengsum, uten melding | annet | `RP/PoengberegningService.java:351` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-031` | Kvoter uten gyldig grunnlag gir logg-advarsel | annet | `RP/PoengsumService.java:119` | testes i fase 2 |
| `@OPT-BEH-BEH-031` | Poeng over maks/under min → kombinasjonen regnes ikke ut, årsak på poengraden | validering | `RP/PoengberegningService.java:196` | testes i fase 2 |
| `@OPT-BEH-BEH-031` | Feil i poengformelen gir ingen merknad, bare logg | annet | `RP/PoengberegningService.java:191` | uklart om ønsket |
| `@OPT-BEH-BEH-031` | Visningen tar bare poengsummer for grunnlag i tilbudets rangeringsregelverk | annet | `SB/KvotesumV2Service.java:266-275` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-031` | Poengtype med minimum ≤ 0 som søkeren mangler poeng i, teller som 0 | standardverdi | `PoengberegningEvaluator.java:193-200` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Søkeren ser mangler bare når saken er Under behandling eller Ferdig behandlet | tilstandsovergang | `MIG/V457…:14` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-008` | Registrere/endre/slette/publisere mangel setter Ikke behandlet → Under behandling | tilstandsovergang | `MS:115,275,327,365,392-397` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-008` | Endret kommentar/kobling eller gjenåpnet mangel → ulest for søkeren | tilstandsovergang | `MS:209-268` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Ny tekst i beregnet mangel nullstiller publisert og lest | tilstandsovergang | `KO:205-212` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-008` | Kompetanseregelverk og kvotespørsmål må være i samme samling som mangeltypen | validering | `MS:450-459` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Kommentar maks 4000 tegn, Markdown-sanert | grense | `mangel.graphqls:60,75`; `MS:53-55` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Mangelkode unik i samlingen; navn maks 100 tegn | validering | `mangel.graphqls:104-107,238-245` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Ny mangelkode aktiv og stopper ikke for opptak som standard | standardverdi | `MT:47-48` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Batch-endring krever samme sak | validering | `MS:176-186` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Sakslisten kan filtreres på «MANGLER» | annet | `SakFilterConditions.java:440-448` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-008` | Saksbildet viser «Mangler dokumentasjon» | annet | `PersonaliaCard.tsx:137-140,229-231` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | Mangler grupperes etter kategori; stopper-for-opptak i rødt | annet | `MC/ManglerCard.tsx:48-64`; `MC/Mangel/Mangel.tsx:113-117` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Sletting skjult for erRegistrertAutomatisk | tilgangssjekk | `MC/Mangel/Mangel.tsx:143` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | Kompetanseregelverket er valgfritt for en mangel i kategorien Spesielle krav | validering | `KompetanseregelverkSelect.tsx:82`, `SakMangelService.java:417-431` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | Saksbehandleren kan bare velge aktive mangelkoder (bare i fs-admin) | validering | `MangeltypeCombobox.tsx:30` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Koden på en mangelkode kan ikke endres etter at den er opprettet | validering | `MangelkodeDetails.tsx:159-160`, `mangel.graphqls:119-133` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-008` | Kategorien på en mangelkode kan endres også når den er i bruk | annet | `MangeltypeService.java:80-83` | uklart om ønsket |
| `@OPT-BEH-BEH-029` | Merknad setter Ikke behandlet → Under behandling | tilstandsovergang | `MerknadService.java:73-77` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-029` | GSK-vedtak og vitnemålsutregning setter Ikke behandlet → Under behandling | tilstandsovergang | `GskVedtakService.java:176-178,212-214`; `LagreVitnemalUtregningService.java:402-406` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-029` | Unntak fra kravelement setter Ikke behandlet → Under behandling | tilstandsovergang | `KvalifiserKravelementUnntakService.java:208-210` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-029` | Markere dokument som ulest setter også Under behandling | tilstandsovergang | `SettSaksdokumentErLestService.java:37,63-66` | uklart om ønsket |
| `@OPT-BEH-BEH-029` | «Merk som behandlet» av når saken alt er ferdig behandlet | annet | `MerkSomBehandletButton.tsx:42` | testes i fase 2 |
| `@OPT-BEH-BEH-029` | Statusen heter «Behandlet» i nedtrekket, ikke «Ferdig behandlet» | annet | `fs-admin/src/common/messages/nb/soknadsbehandling.json:406`; `PersonaliaCard.tsx:134` | uklart om ønsket |
| `@OPT-BEH-BEH-029` | Saksbildet viser fortsatt dokumentasjonsstatus | annet | `PersonaliaCard.tsx:137-140,225-232` | uklart om ønsket |
| `@OPT-BEH-BEH-029` | Mangler presenteres for søkeren bare når saken er Under/Ferdig behandlet | tilstandsovergang | `ManglerPresentertService.java:44-46` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-029` | Tilbudsgarantien i tidligopptaket plukker saker som ikke er ferdig behandlet | annet | `TidligopptakTilbudsgarantiService.java:176` | uklart om ønsket |
| `@OPT-BEH-BEH-029` | Poeng, kvalifisering og kvoteplassering setter Ikke behandlet → Under behandling | tilstandsovergang | `SettPoengService.java:193-199`, `KvalifiserKravelementV4Service.java:76-80`, `EndreKvoteplasseringService.java:121-127` | legg til scenario med fs-krav |
| `@OPT-BEH-BEH-029` | Endre, publisere og fjerne mangel setter også Ikke behandlet → Under behandling | tilstandsovergang | `SakMangelService.java:275`, :327, :365 | testes i fase 2 |
| `@OPT-BEH-BEH-029` | Statusendring uten skrivetilgang gir uendret sak og ingen feil | annet | `EndreStatusService.java:31-36` | uklart om ønsket |
| `@FLY-OPT-AUT-001` | Feiler vurderingen av kravelementene, kjøres kvalifiseringen og kvotene likevel | tilstandsovergang | `ASS:134-135` | uklart om ønsket |
| `@FLY-OPT-AUT-001` | Har søkeren mer enn ett vitnemål, rulles hele kjøringen tilbake, også GSK-konklusjonen fra steg 0a | tilstandsovergang | `SG:110-114`, `ASS:86` | uklart om ønsket |
| `@FLY-OPT-AUT-001` | Grunnlaget velges ikke automatisk når saksbehandleren har låst et grunnlag (la_staa) | tilstandsovergang | `SG:99-105` | testes i fase 2 |
| `@FLY-OPT-AUT-001` | Kompetansebevis (ikke VM) gir verken konklusjon eller grunnlag | annet | `A:81-83`, `SG:119-126` | testes i fase 2 |
| `@FLY-OPT-AUT-001` | GSK-konklusjonen settes ikke uten utstedelsesdato på vitnemålet | validering | `A:85-87` | testes i fase 2 |
| `@FLY-OPT-AUT-001` | Annullerte vitnemål telles ikke | annet | `A:79`, `SG:374` | testes i fase 2 |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`. I denne kjøringen er alt verifisert uansett status, så `@draft @openquestion`-delene er med i gating-settet.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | Importere resultater fra KREG | 1 av 5 | 4 av 17 | 0 |
| `@OPT-BEH-BEH-027` | Beregne GSK fra vitnemål | 2 av 10 | 3 av 27 | 0 |
| `@OPT-BEH-BEH-015` | Automatisk GSK-konklusjon | 0 av 9 | 1 av 41 | 0 |
| `@OPT-BEH-BEH-025` | Ferdigbehandle en sak | 0 av 5 | 2 av 13 | 0 |
| `@OPT-BEH-BEH-019` | Automatisk grunnlag | 0 av 7 | 7 av 30 | 0 |
| `@OPT-BEH-BEH-018` | Automatisk beregning av vitnemålspoeng | 0 av 5 | 1 av 17 | 0 |
| `@OPT-BEH-BEH-028` | Automatiske tilleggspoeng | 1 av 6 | 1 av 21 | 0 |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | 0 av 7 | 2 av 34 | 0 |
| `@OPT-BEH-BEH-008` | Søknadsmangler | 4 av 13 | 27 av 72 | 0 |

`@OPT-BEH-BEH-032`, `-031`, `-029`, `-026` og flyten har ingen `@openquestion` i gating-settet. De to `@wont`-fasene i flyten har `@openquestion`, men er utenfor.

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | !6080 TAKE-398: Jobbkø i opptak for søknadshendelsene (`feature/soknadshendelser-utboks`) | utkast | `@OPT-BEH-BEH-030` | 1/17 | vitnemålsjobb som prøver igjen etter 1–15 min, hardkodet («Resultatene hentes når KREG svarer igjen»). Starter ikke den automatiske behandlingen (`@OPT-BEH-BEH-032`) |
| `fs-plattform` | !6438 STEK-632: grunnlagslåsen avledes av status_automatisk_utregnet (`mahj/STEK-632`) | åpen | `@OPT-BEH-BEH-019` | 0/30 | bytter kolonnen for låsen, samme virkning |
| `fs-plattform` | !6456 STEK-551: annullerte vitnemål brukt i en beregning vises på saken (`opptak/vgs-annullert-brukt-i-beregning`) | åpen | `@OPT-BEH-BEH-015` | 0/41 | visning, ingen scenarioer |
| `fs-plattform` | !6410 TAKE-452/453: kvoteoppsett fra regelverket (`feature/take-452-453-kvoteoppsett-fra-regelverk`) | åpen | – | 0 | usikker kobling |
| `fs-plattform` | !5452 STEK-452: varsle når utdanningstilbud mangler kvote (`solov/stek-452-kvotesignal`) | åpen | – | 0 | usikker kobling |
| `fs-plattform` | !6423 KREG-113: IOP-vurderingsspesifikasjon (`KREG-113-iop-vurderingsspesifikasjon`) | åpen | – | 0 | usikker kobling |
| `fs-admin` | !3274 STEK-550: vis at et vitnemål brukt i beregningen er annullert (`opptak/vitnemal-annullert-status`) | utkast | `@OPT-BEH-BEH-015` | 0/41 | merker vitnemålet, ingen tagg på saken |
| `fs-admin` | !3179 TAKE-422: send bare endrede kvotefelt (`maada/TAKE-422`) | åpen | – | 0 | usikker kobling |

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-025` | scenario | Saken blir stående under behandling når et steg ikke kan avgjøres | usikker | ikke funnet | den automatiske behandlingen endrer aldri status; en ny sak står som UBEHANDLET (`MIG/V291__saksbehandling_skjema.sql:75`) |
| `@OPT-BEH-BEH-020` | scenario | Endringsloggen viser at automatikken vurderte kravelementet | usikker | ikke funnet | behandlingen startes fra knappen med saksbehandlerens ident, og fs-admin merker bare `fs-opptak-automatikk` som automatikk (`AuditLogItem.tsx:36,70-75`) |
| `@OPT-BEH-BEH-008` | scenario | Opprette mangelkode | usikker | ikke funnet | feltet «Kan overskrives av automatisk behandling» finnes ikke i API-et, fs-admin eller migrasjonene |
| `@OPT-BEH-BEH-008` | scenario | Saksbehandleren ser at søkeren har lastet opp ny dokumentasjon | funnet | funnet | beviset rettet: søkerens opplasting går via `SHJ:197-202` og `SB/SaksdokumentSyncService.java:23-31` |
| `@OPT-BEH-BEH-008` | tilgang | opptaksforvalter endrer kategorien på en mangelkode som er i bruk | – | avviker | tilføyd: `MT:80-83` endrer kategori uten å sjekke manglene som bruker koden |
| `@OPT-BEH-BEH-018` | tilgang | saksbehandler starter automatisk poengberegning | – | ikke beskrevet | tilføyd: mutationen har ingen egen sjekk |
| `@OPT-BEH-BEH-018` | regel | Manuelt lagret poeng låses automatisk | regel uten scenario | dekket av scenario | dekket av «Poeng som saksbehandleren endrer, blir stående» |
| `@OPT-BEH-BEH-026` | regel | Poeng og grunnlag som er låst (la_staa), beregnes ikke automatisk (to regler) | regel uten scenario | dekket av scenario | dekket av `@OPT-BEH-BEH-018` og `@OPT-BEH-BEH-019`, som `-026` bygger på |
| `@OPT-BEH-BEH-029` | tilgang | saksbehandler endrer behandlingsstatus | stemmer | stemmer | beviset rettet til `MIG/V300__rls_over_paa_auth_claims.sql`; fs-admin deaktiverer i stedet for å skjule |
| `@OPT-BEH-BEH-031` | scenario | Poengsummen regnes ut på nytt når <endring> (og fire andre) | funnet | funnet | linjenumrene rettet: `RP/PoengsumService.java:191-231`, `SB/LeggTilGrunnlagService.java:48`, `SB/FjernGrunnlagService.java:42` |
| `@OPT-BEH-BEH-031` | tilgang | opptaksforvalter endrer poengformel eller kobling kvotetype–grunnlag | – | ikke beskrevet | tilføyd: ingen regelverksendring regner poengsummen ut på nytt |
| `@FLY-OPT-AUT-001` | scenario | Saken blir ikke ferdig behandlet når poengene ikke kan avgjøres | usikker | ikke funnet | saken står som UBEHANDLET, ikke under behandling; den automatiske behandlingen rører ikke statusen |
| `@FLY-OPT-AUT-001` | scenario | Saken får mangel for kravelementet vitnemålet ikke oppfyller | funnet | funnet | beviset rettet: `sak.graphqls:881` er `mangler` på søknadsalternativet, ikke `Sak.mangler` |
| `@FLY-OPT-AUT-001` | kjent brudd | «koden krever at KREG sier GSK, og bruker ikke skolens påstand» | – | feil i flyten | kontrolløren av flyten mente bruddet stemmer, kontrolløren av `@OPT-BEH-BEH-015` og `-030` det motsatte. Lead har lest koden: `paastand_om_gsk` er «skolens påstand» (`fs-plattform/kreg/kreg-migrations/src/main/resources/db/migration/V1_027__kompetanse_skjema.sql:452`), fylt fra `nvb2.vgdok.gsk_ok` (`V1_034__schema_nvb2migrering.sql:527`); KREGs egen `gsk_beregnet` ble ikke migrert. Koden bruker skolens påstand |

Kontrollen avkreftet ingen `funnet`. I alt la kontrollørene til 38 regler uten scenario og 3 tilgangsrader.

## Forslag til endringer

Ingen av kravene har hele gating-settet funnet, så ingen kan bli `@implemented`. `@planned` er validering og settes med `fs-krav`, ikke av verifiseringen. Det verifiseringen kan gjøre, er *Delvis levert*: egenskapen blir `@in-progress`, og de leverte delene `@implemented`. `@draft`-deler i `@OPT-BEH-BEH-008` står urørt.

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-030` — Importere resultater fra KREG (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/importere_resultater_fra_kreg.feature`, `@draft` → `@in-progress`, 11/17 funnet) — `@implemented` på: Scenario: Resultatene hentes når søkeren sender inn søknaden (linje 28); Scenario: Resultatene hentes når søknaden registreres på vegne av søkeren (linje 33); Scenario: Resultatene hentes når en endring av søknaden gir en ny sak (linje 38); Scenario: Resultatene hentes først når saken er opprettet (linje 52); Scenario: Søker med flere vitnemål får alle importert (linje 77); Scenario: Kompetansebevis importeres (linje 82); Scenario: Vitnemål som er importert fra før, importeres ikke på nytt (linje 87); Regel: Et vitnemål som er annullert i KREG, er annullert i opptakssystemet (linje 94); Scenario: Søker uten fødselsnummer får ingen resultater importert (linje 120)
- `@OPT-BEH-BEH-032` — Starte automatisk behandling (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/starte_automatisk_behandling.feature`, `@draft` → `@in-progress`, 2/17 funnet) — `@implemented` på: Scenario: Saksbehandleren starter bare behandlingen for saker hos organisasjonen (linje 112); Regel: Det saksbehandleren har gjort, endres ikke av automatikken (linje 118)
- `@OPT-BEH-BEH-027` — Beregne GSK fra vitnemål (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/beregne_gsk_fra_vitnemål.feature`, `@draft` → `@in-progress`, 22/27 funnet) — `@implemented` på: Regel: Reformen på vitnemålet avgjør hvilke delkrav som gjelder (linje 48); Regel: Matematikk for Kunnskapsløftet (linje 89); Regel: Naturfag for Kunnskapsløftet (linje 126); Regel: Samfunnsfag for Kunnskapsløftet (linje 153); Regel: Engelsk for Kunnskapsløftet (linje 168); Regel: Norsk og historie for Kunnskapsløftet (linje 192); Regel: Delkravene for Reform 94 (linje 295); Scenario: Løpet settes sammen av programområdene etter nivå (linje 338); Scenario: Ukjent løp (linje 360); Scenario: Løp og vitnemål fra ulike reformer (linje 397)
- `@OPT-BEH-BEH-015` — Automatisk GSK-konklusjon (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature`, `@planned` → `@in-progress`, 6/41 funnet) — `@implemented` på: Regel: Automatikken setter bare positive konklusjoner, og bare der ingen finnes (linje 285); Scenario: Konklusjonen overskrives ikke i den automatiske behandlingen (linje 326); Scenario: Overskrive positiv konklusjon med negativ konklusjon (linje 337); Scenario: Legge til positiv konklusjon når ingen finnes (linje 342)
- `@OPT-BEH-BEH-025` — Ferdigbehandle en sak (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/ferdigbehandle_sak.feature`, `@draft` → `@in-progress`, 4/13 funnet) — `@implemented` på: Scenario: Saken behandles ikke helautomatisk når ingen vitnemål gir GSK (linje 52); Scenario: Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål (linje 57); Regel: Saksbehandleren setter saken til ferdig behandlet når den automatiske behandlingen ikke har fullført (linje 155)
- `@OPT-BEH-BEH-019` — Automatisk grunnlag (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_grunnlag.feature`, `@draft` → `@in-progress`, 16/30 funnet) — `@implemented` på: Scenario: Grunnlag ut fra førstegangsvitnemål og alder (linje 59); Scenario: Alderen regnes ut på datoen for aldersberegning (linje 74); Scenario: Førstegangsvitnemål går foran (linje 82); Scenario: Flere grunnlag passer like godt (linje 101); Scenario: Grunnlag uten egenskaper for automatikken settes ikke (linje 109); Scenario: Bare grunnlag i regelverket til utdanningstilbudene i søknaden kan settes (linje 114); Scenario: Grunnlag som ikke er aktivt, settes ikke (linje 119); Scenario: Ingen grunnlag settes automatisk når <grunn> (linje 131); Scenario: Søker med flere vitnemål behandles ikke automatisk (linje 143); Scenario: Annullert vitnemål teller ikke (linje 163); Scenario: Grunnlaget settes etter GSK-konklusjonen (linje 170); Scenario: Grunnlaget settes av den automatiske behandlingen (linje 180); Scenario: Automatikken setter ikke grunnlag når saksbehandleren har lagt til et grunnlag (linje 197); Scenario: Automatikken fjerner ikke grunnlag (linje 209); Scenario: Saksbehandleren fjerner et grunnlag som er satt automatisk (linje 215); Scenario: Opptakskrav, kvoter og tilleggspoeng følger grunnlaget som er satt automatisk (linje 295)
- `@OPT-BEH-BEH-018` — Automatisk beregning av vitnemålspoeng (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_poengberegning.feature`, `@draft` → `@in-progress`, 9/17 funnet) — `@implemented` på: Regel: Karakterpoeng, realfagspoeng og språkpoeng beregnes fra søkerens eneste vitnemål (linje 33); Regel: Poeng som saksbehandleren har låst, beregnes ikke på nytt (linje 116)
- `@OPT-BEH-BEH-028` — Automatiske tilleggspoeng (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_tilleggspoeng.feature`, `@draft` → `@in-progress`, 7/21 funnet) — `@implemented` på: Scenario: Alderspoeng for søkerens alder (linje 20); Scenario: Kjønnspoeng for søkerens kjønn (linje 56); Scenario: Automatikken velger grunnlaget (linje 104); Scenario: Poengene for grunnlaget som er fjernet, vises ikke lenger (linje 122); Scenario: Poengene regnes ikke ut på nytt av seg selv når datoen for aldersberegning endres (linje 136); Scenario: Poengene er satt av saksbehandleren og står (linje 166); Scenario: Saksbehandleren overstyrer et alderspoeng som er regnet ut automatisk (linje 171)
- `@OPT-BEH-BEH-020` — Automatisk vurdering av spesielle opptakskrav (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvalifisering.feature`, `@draft` → `@in-progress`, 27/34 funnet) — `@implemented` på: Scenario: Fagkrav som er oppfylt på vitnemålet (linje 100); Scenario: Fagkrav som ikke er oppfylt på vitnemålet (linje 107); Scenario: Karakteren fra vitnemålet registreres på fagkravet (linje 114); Scenario: Fagkrav uten karakter oppfylles uten karakter (linje 121); Scenario: Karakterkrav får karakteren fra vitnemålet (linje 129); Scenario: Beste karakter gjelder for programfag matematikk (linje 135); Scenario: Kravelement som ikke er koblet til vitnemålet, vurderes ikke (linje 141); Scenario: Kravelement vurderes mot vitnemål fra R94 (linje 147); Scenario: Ingen automatisk vurdering når <grunn> (linje 164); Scenario: Kvalifisert når alle kravelementene i en kravliste er oppfylt (linje 199); Scenario: Kvalifisert når én av kravlistene er oppfylt (linje 205); Scenario: Karakteren må nå karakterkravet (linje 212); Scenario: Søkeren kan være kvalifisert på ett grunnlag og ikke på et annet (linje 218); Regel: Kravelementene vurderes i den automatiske behandlingen (linje 238); Scenario: Saksbehandleren overstyrer vurderingen automatikken har satt (linje 260); Scenario: Saksbehandleren overstyrer karakteren som automatikken har satt (linje 266); Scenario: Kravelement som saksbehandleren vurderer, låses (linje 272); Scenario: Kravelement som saksbehandleren bare ser på, vurderes automatisk igjen (linje 283); Scenario: Låst kravelement vurderes ikke på nytt (linje 289); Scenario: Andre kravelementer vurderes selv om saksbehandleren har vurdert ett (linje 294); Scenario: Nullstilt kravelement kan vurderes automatisk igjen (linje 301); Scenario: Unntak per grunnlag endres ikke (linje 307); Regel: Når grunnlaget endres, vurderes kravene på nytt (linje 312); Scenario: Manuell endring fjerner markeringen som automatisk vurdert (linje 334); Scenario: Finne søkere som ikke er kvalifisert (linje 345)
- `@OPT-BEH-BEH-031` — Beregne poengsum per kvote (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/beregne_poengsum_per_kvote.feature`, `@draft` → `@in-progress`, 12/13 funnet) — `@implemented` på: Regel: Søkeren får en poengsum for hver kvote og hvert grunnlag kvoten er koblet til (linje 22); Regel: Poengsummen regnes ut med poengformelen til kvotetypen (linje 45); Regel: Bare grunnlag søkeren er kvalifisert på, gir poengsum (linje 57); Regel: Poengsummen regnes ut på nytt når det den bygger på, endres (linje 68); Scenario: Poengsummen i de andre kvotene regnes ut når én kvote feiler (linje 91); Scenario: Poengsummene fjernes når søkeren ikke er plassert i noen kvote (linje 103); Scenario: Poengsummene fjernes når søknaden ikke har noe grunnlag (linje 108); Regel: Saksbehandleren ser den høyeste poengsummen per kvote for hvert søknadsalternativ (linje 114)
- `@OPT-BEH-BEH-008` — Søknadsmangler (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/søknadsmangler.feature`, `@planned` → `@in-progress`, 14/72 funnet) — `@implemented` på: Scenario: Tilgjengelige kategorier for mangelkoder (linje 63); Scenario: Saken kan behandles ferdig selv om den har mangler (linje 144); Scenario: Registrere mangel på spesielle krav (linje 161); Scenario: Saksbehandleren velger blant mangelkodene i regelverkssamlingen til opptaket (linje 169); Scenario: Saksbehandleren velger blant kompetanseregelverkene til søknadsalternativene i saken (linje 176); Scenario: Kommentaren til søkeren er valgfri (linje 203); Scenario: En sak kan ha flere mangler (linje 207); Scenario: Slette mangel som er registrert ved en feil (linje 224); Scenario: Saksbehandleren ser at søkeren har lastet opp ny dokumentasjon (linje 246); Scenario: Søkeren får én melding om manglene som publiseres i saken (linje 363); Scenario: Søkeren får melding fra hver saksbehandlende organisasjon som publiserer mangler (linje 368)
- `@OPT-BEH-BEH-029` — Behandlingsstatus (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/behandlingsstatus.feature`, `@draft` → `@in-progress`, 5/8 funnet) — `@implemented` på: Regel: En ny sak er Ikke behandlet (linje 37); Regel: Saksbehandleren kan sette behandlingsstatusen (linje 44); Scenario: Sette saken til Ferdig behandlet fra <fra> når saken har <innhold> (linje 61); Scenario: Behandlingsstatusen endres ikke når saksbehandleren <handling> (linje 98); Scenario: Ny dokumentasjon endrer ikke behandlingsstatusen (linje 108)

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-026` — Beregne automatisk på nytt (`@draft`, 0/7 funnet) — funksjonen for å beregne på nytt finnes ikke
- `@FLY-OPT-AUT-001` — Automatisk saksbehandling (`@draft`, 11/21 funnet) — 2 av 17 faser levert, og bruddene står i `## Oppfølging`. En flyt får ikke delvis levert

## Levert

Venter på svar.

## Ikke levert

Venter på svar.

## Slettet

Venter på svar.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Tre påstander om GSK (PR #875) er ikke bygget:** koden har bare én påstand, `vgs_dokument.gsk_ok`, og det er skolens påstand (`V/KregVgsParser.java:104` fra `paastandOmGsk`, kolonnekommentaren «skolens påstand» i `fs-plattform/kreg/kreg-migrations/src/main/resources/db/migration/V1_027__kompetanse_skjema.sql:452`). KREGs egen påstand finnes bare i den gamle `nvb2.vgdok.gsk_beregnet`, ble ikke migrert, og er ikke i KREG-API-et. Opptakssystemets påstand lagres ikke. Koden krever skolens påstand OG at seksfagskontrollen består (`E:64-69`), mens kravene sier at minst én av de tre påstandene holder. Gjelder `@OPT-BEH-BEH-015`, `-027`, `-025`, `-019` og flyten.
- **Kommentarene om påstanden er feil:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature:123-124` og `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature:28` sier at koden krever at KREG sier GSK, og ikke bruker skolens påstand. Det er omvendt: koden bruker skolens påstand, og KREGs påstand finnes ikke. Rettes med `fs-krav`.
- **Ingenting starter den automatiske behandlingen av seg selv:** bare knappen i fs-admin, én sak om gangen, bak feature-flagget `automatisk-soknadsbehandling-trigger` (`BTN:50-62`), som bare er på i test, review og dev. Ingen innstilling per opptak. Heller ikke !6080 starter den. Gjelder `@OPT-BEH-BEH-032` og flyten.
- **Saken blir aldri ferdig behandlet, og manglene publiseres ikke:** `ASS:83-143` endrer ikke status, og bare saksbehandlerens `publiserMangler` publiserer (`MS:283-330`). Den beregnede mangelen fra kravelementene vises bare når den er publisert og saken er under eller ferdig behandlet (`MIG/V457__soknadsmangel_bare_publiserte.sql:148-185`), så ingen ser den. Gjelder `@OPT-BEH-BEH-025`, `-008` og flyten.
- **Mangelen for GSK som fullføres i vår:** søkerens svar lagres (`MIG/V482__fullforer_videregaende.sql`), men ingen kode lager eller sjekker ut mangelen, og mangelkoden kan ikke merkes. Gjelder `@OPT-BEH-BEH-008` og flyten.
- **Tilleggspoeng når saksbehandleren velger grunnlaget:** alders- og kjønnspoeng regnes bare ut i den automatiske behandlingen (`RP/AutomatiskPoengberegningService.java:157,162`). Legger saksbehandleren til grunnlaget, står poengene tomme (`PRO:115-137`). Poeng for høyere utdanning finnes ikke. Gjelder `@OPT-BEH-BEH-028` og `-019`.
- **Hele den automatiske behandlingen rulles tilbake:** ALD_ALG4 og ALD_ALG5 finnes i databasen (`MIG/V170__poengalgoritme_alder_kjonn.sql:18-19`), men koden kjenner dem ikke og kaster (`RP/AlderspoengAlgoritme.java:23-29`). Det samme skjer med en ukjent KJONN_-kode, med søkere uten fødselsdato eller kjønn, og når søkeren har vitnemål og kompetansebevis (`SG:109-114`).
- **API-dokumentasjonen er utdatert:** `GQL:44-51` lover at alle steg rulles tilbake når ett feiler, men poeng og kravelementer er isolert (`ASS:153-160`). Når kravelementene feiler, regnes kvalifisering og kvoter likevel (`ASS:134-135`), mens `@OPT-BEH-BEH-025` sier at stegene som bygger på det, skal hoppes over.
- **Rekkefølgen i flyten:** koden besvarer kvotespørsmålene før poengene (`ASS:117`, og igjen i steg 3), mens flyten har dem etter kravelementene. Påstanden beregnes også på nytt i kjøringen (`E:67`), mot kommentaren i fasen «Den automatiske behandlingen setter GSK-konklusjonen der den mangler». Semiautomatisk GSK-konklusjon (`O/autosak/gsk/SettGskKonklusjonService.java`) beregner den også, så kjent brudd 2 («bare i den automatiske behandlingen») er litt for snevert.
- **KREG-henting som avbrytes, tas ikke igjen på main:** hendelsene er kvittert før hentingen (`SHJ:315,361`). !6080 har en jobb som prøver igjen.
- **Annullert vitnemål:** den automatiske konklusjonen trekkes tilbake i alle opptak, også avsluttede, og grunnlagskoden nullstilles (`T:66-90`). `@OPT-BEH-BEH-015` sier at konklusjonen skal stå.
- **Kompetansebevis ved siden av vitnemålet:** `@OPT-BEH-BEH-018`, `-019` og `-020` sier at et kompetansebevis ikke skal stoppe automatikken, men koden teller dem sammen og stopper (`V/VgsDokumentVitnemaalService.java:48`, `SG:109-114`).
- **Endringsloggen er av:** `MIG/V480__stopp_endringslogg.sql` dropper audit-triggerne i saksbehandling. V483 (BAT-324) legger dem ikke tilbake. Gjelder `@OPT-BEH-BEH-008`, `-019`, `-029`.
- **Merkingen av det automatiske vises ikke:** `statusAutomatiskUtregnet` og `merknadAutomatisk` ligger i API-et for poeng, kravelementer og GSK, men fs-admin henter dem ikke. Gjelder `@OPT-BEH-BEH-015`, `-018`, `-019`, `-020`, `-028`, `-031`.
- **Endret poengformel regner ikke poengsummen ut på nytt:** ingen regelverksendring kaller propageringen (`PS:173`). Gjelder `@OPT-BEH-BEH-031` og `-026`.
- **Tilgang avviker:** `@OPT-BEH-BEH-015` vitnemålet annulleres i KREG — konklusjonen trekkes tilbake i alle opptak, uten tagg, `T:66-90`
- **Tilgang avviker:** `@OPT-BEH-BEH-030` importert vitnemål annulleres — de automatiske GSK-vedtakene trekkes tilbake
- **Tilgang avviker:** `@OPT-BEH-BEH-019` og `@OPT-BEH-BEH-028` saksbehandler legger til grunnlag — tilleggspoengene følger ikke, `PRO:115-133`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` opptaksforvalter endrer mangelkode i fs-admin — redigeringen vises for alle (`canModify` hardkodet), `fs-admin/src/domains/regelverk/features/Mangelkoder/MangelkodeDetails/MangelkodeDetails.tsx:268`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` saksbehandler uten skrivetilgang ser handlingene i mangelkortet, `MC/ManglerCard.tsx:137-209`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` saksbehandler leser mangler — ingen filter på organisasjon i policyen, `MIG/V291__saksbehandling_skjema.sql:1713-1718`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` mangelkode fra en annen regelverkssamling — backend sjekker ikke samlingen, `MS:65-113`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` kategorien på en mangelkode i bruk kan endres, `MT:80-83`
- **Tilgang usikker:** `@OPT-BEH-BEH-019` endrer grunnlag på sak hos annen organisasjon, `@OPT-BEH-BEH-029` endrer status på sak hos annen organisasjon (gir uendret sak uten feil), `@OPT-BEH-BEH-032` opptaksforvalter starter behandlingen for sak hos deltakende organisasjon, `@OPT-BEH-BEH-008` hvem som forvalter mangelkodene
- **Åpent spørsmål:** 56 regler og scenarioer i gating-settet har `@openquestion` (se `## Åpne spørsmål`). Spørsmålene står i `# ÅPNE SPØRSMÅL:` i kravfilene, og er ikke kopiert hit, fordi de er så mange.
- **Ikke sjekket:** min-kompetanse finnes ikke lokalt. Scenarioene om hva søkeren ser i Min kompetanse er `usikker` når API-et finnes; de fleste usikre radene i `@OPT-BEH-BEH-008` skyldes dette.
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-008` bygger på `@OPT-SØK-SØK-018` (`@draft`)
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-019` og `@OPT-BEH-BEH-028` bygger på `@OPT-OVO-FRI-001` (`@in-progress`)
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-020` bygger på `@OPT-BEH-BEH-004` (`@in-progress`)
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-026` bygger på `@OPT-PLA-TIL-001` (`@draft`)
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-032` bygger på `@OPT-BEH-BEH-011` (`@planned`)
- **Bygger på krav som ikke er levert:** `@FLY-OPT-AUT-001` bygger på `@FLY-OPT-SAK-001` (`@planned`)
- **Neste steg:** det finnes ingen testplan ennå, så neste steg er `fs-testplan`, som bygger på denne rapporten.
