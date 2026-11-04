# Verifisering: Automatisk saksbehandling (`@FLY-OPT-AUT-001`), de seks leveransene og automatisk kvoteplassering

- **Dato:** 2026-11-02 15:00
- **Krav:** `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature` og kravene i de seks leveransene (scopene `automatisk-import-og-start`, `automatisk-gsk-konklusjon`, `automatisk-grunnlag-og-poeng`, `automatisk-kvalifisering-og-poengsum`, `automatisk-ferdigbehandling` og `beregne-automatisk-pa-nytt`), og `@OPT-BEH-BEH-012` (15 feature-filer). `@OPT-BEH-BEH-015` og `@OPT-BEH-BEH-027` er lest i versjonen fra PR #900 (`origin/krav/pbpby4-gir-klf`), ikke merget. Resten er lest på `krav/scopes-automatisk-saksbehandling` (origin/main + 2 lokale commits)
- **Kode:** `fs-plattform` (main, b7fb33039d, oppdatert), `fs-admin` (main, eb3e615b8, oppdatert), `min-kompetanse` (main, 9b266a83, oppdatert)
- **Åpne MR-er:** ikke sjekket (`glab` finnes ikke). 5 brancher funnet på navn: 4 i fs-plattform, 2 i fs-admin (3 med kode for kravene)
- **Omfang:** alle krav uansett status, flyter (fra prompten: «status på hva vi har og hva vi mangler på hver av delene»)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 4 finnere (`fs-verify-krav`), 16 kontrollører (`fs-verify-kontroll`), 2–6 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Teamet stoppet flere ganger på brukerens kostnadsgrense. Fra kontrollen av `@OPT-BEH-BEH-020` ble kontrollørene kjørt én om gangen. Alle filene er kontrollert.

Stiene er forkortet:

- `P` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/`
- `G` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/`
- `PM` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `A` = `fs-admin/src/domains/soknadsbehandling/features/`
- `MK` = `min-kompetanse/src/components/soknadsmangel/`
- `KE` = `P/autosak/kontrollmotor/Kravelementer.java`, `EV` = `P/autosak/gsk/GskKonklusjonEvaluator.java`, `AS` = `P/autosak/gsk/GskVedtakAutoService.java`, `ASB` = `P/autosak/AutomatiskSaksbehandlingService.java`, `HV` = `P/vgs/HentVgsVitnemaalService.java`, `TB` = `P/autosak/gsk/GskVedtakTilbakekallingService.java`, `GV` = `P/soknad/gskvedtak/GskVedtakService.java`, `MAP` = `P/vgs/VgsDokumentVitnemaalMapper.java`, `GC` = `A/GSKCard/GSKCard.tsx`
- `B1` = `origin/solov/gsk-pbpby4-klf`, `B2` = `origin/solov/gsk-annullering-trekker-ikke-tilbake` (fs-plattform)
- Filnavn uten prefiks ligger i `P/` (Java) eller `PM/` (SQL) med samme undermappe som nærmeste sti foran i samme celle.

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | Importere resultater fra KREG | 11/17 | fs-plattform | Jobb som henter nye og annullerte vitnemål for aktive søkere, ny henting når KREG ikke svarte, ikke hente på nytt når endringen ikke gir ny sak, og skolens og KREGs GSK-påstand lagret hver for seg. |
| `@OPT-BEH-BEH-032` | Starte automatisk behandling | 2/14 | fs-plattform, fs-admin | Ingenting starter behandlingen av seg selv (ny sak, første vitnemål). Valg av vitnemål ved start, statusovergangene, markering av «behandlet automatisk», innstilling per opptak og årsaken når saken ikke kunne behandles. |
| `@OPT-BEH-BEH-015` | Automatisk GSK-konklusjon | 11/47 | fs-plattform, fs-admin | Konklusjonen settes bare i den automatiske behandlingen per sak, aldri ved import. Opptakssystemets påstand lagres ikke, gjenbruk av tidligere konklusjoner og varslene mangler, og annullering trekker konklusjonen tilbake. «GSK OK» som fasit, KLF og KLY/RFA ligger i B1. |
| `@OPT-BEH-BEH-027` | Beregne GSK fra vitnemål | 23/28 | fs-plattform | Delkravene og løpet finnes i kontrollmotoren. Grunnlagskoden ved uenighet, PBPBY4 → KLF og KLY/RFA i helautomatikken ligger i B1. Beregningen krever «GSK OK» fra KREG, og fagstatus (`@draft`) mangler. |
| `@OPT-BEH-BEH-019` | Automatisk grunnlag | 17/32 | fs-plattform, fs-admin | Valgt og sammensatt vitnemål, kompetansebevis ved siden av, alle sakene i søknaden, likt passende grunnlag, fjernet grunnlag holdes borte, aldersgrense ved manuelt valg. fs-admin viser ikke automatisk-status og årsak. |
| `@OPT-BEH-BEH-018` | Automatisk beregning av vitnemålspoeng | 9/16 | fs-plattform, fs-admin | Valgt vitnemål og kompetansebevis ved siden av, skolepoeng (bare via poengformel som ikke er satt opp), og fs-admin viser ikke hvordan poenget er beregnet. |
| `@OPT-BEH-BEH-028` | Automatiske tilleggspoeng | 8/23 | fs-plattform, fs-admin | Tilleggspoeng regnes bare ut i den automatiske behandlingen, ikke når saksbehandleren velger grunnlaget. Poeng for høyere utdanning finnes ikke. fs-admin viser ikke merknadene. |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | 26/34 | fs-plattform, fs-admin | Valgt vitnemål, kompetansebevis ved siden av, endringsloggen. fs-admin mangler «la stå», visning av automatisk vurdering og merknaden, og «Nullstill» opphever ikke låsen. |
| `@OPT-BEH-BEH-031` | Beregne poengsum per kvote | 11/13 | fs-plattform, fs-admin | Hvorfor poengsummen ikke kan regnes ut (delvis i fs-plattform, på vei i `mahj/STEK-650`). |
| `@OPT-BEH-BEH-036` | Automatiske mangler | 6/25 | fs-plattform, fs-admin, min-kompetanse | Mangeltekstene lages, men vises bare når de publiseres, og ingen klient publiserer dem. Hele regelen om mangelkoden for GSK som fullføres i vår mangler. |
| `@OPT-BEH-BEH-029` | Behandlingsstatus | 5/8 | fs-plattform, fs-admin | Sperre mot Behandlet uten mangel eller grunnlag, Under behandling ved grunnlag og fra Behandlet, og saksloggen. |
| `@OPT-BEH-BEH-025` | Ferdigbehandle en sak | 4/16 | fs-plattform, fs-admin, min-kompetanse | Automatikken setter aldri status, publiserer ikke manglene og varsler ikke. Valg av vitnemål, og at steg som bygger på et steg som feiler, hoppes over. |
| `@OPT-BEH-BEH-026` | Beregne automatisk på nytt | 0/11 | fs-plattform, fs-admin, min-kompetanse | Hele funksjonen. |
| `@OPT-BEH-BEH-012` | Automatisk kvoteplassering | 13/16 | fs-plattform, fs-admin | Levert. Endringsloggen er stoppet (PM/V480), og opptaksalderen vises ikke noe sted. |

Gjenstår: fs-plattform, fs-admin 9, fs-plattform, fs-admin, min-kompetanse 3, fs-plattform 2, ingen 0. Flyten (`@FLY-OPT-AUT-001`, 0/22) er ikke vurdert per repo.

Per leveranse (scenarioer funnet av gating-settet):

| Leveranse | Krav | Funnet |
| --- | --- | --- |
| 1 Import og start | 030, 032 | 13/31 |
| 2 GSK-konklusjon | 015, 027 | 34/75 |
| 3 Grunnlag og poeng | 019, 018, 028 | 34/71 |
| 4 Kvalifisering og poengsum per kvote | 020, 031 | 37/47 |
| 5 Ferdigbehandling | 036, 029, 025 | 15/49 |
| 6 Beregne på nytt | 026 | 0/11 |
| Levert: automatisk kvoteplassering | 012 | 13/16 |

## Oppsummering

- Scenarioer: 146 funnet, 166 ikke funnet, 10 usikker, av 322
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 14
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: 15 stemmer, 8 avviker, 3 ikke funnet, 2 usikker, av 50 (22 ikke beskrevet i kravet)
- Regler i koden uten scenario: 94
- Åpne spørsmål: 6 regler og 20 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Fremdrift for flyter

Fremdriften kommer fra statusen på delen av kravene fasene bygger på (`@depends-on-`, og ankrene innenfor reglene i «…», ellers alle ankrene, ellers reglene i «…»). Den endrer ingen tagger.

Hele flyten bygger på `@FLY-OPT-SAK-001` (`@depends-on-` på `Egenskap:`), som er `@planned`. En fase er levert bare når flytene den bygger på, er `@implemented` (*Flyter* i `krav/README.md`), så ingen fase er levert. Kolonnen `Bygger på` viser statusen på kravene fasen selv bygger på.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Søkerens resultater importeres fra KREG når saken er opprettet | `@OPT-BEH-BEH-030` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen starter når søkerens resultater er importert | `@OPT-BEH-BEH-032` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen når vitnemålet importeres fra KREG | `@OPT-BEH-BEH-015` (`@planned`), `@OPT-BEH-BEH-027` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen setter GSK-konklusjonen der den mangler | `@OPT-BEH-BEH-015` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Vitnemålet som gir GSK, avgjør om saken behandles helautomatisk | `@OPT-BEH-BEH-015` (`@planned`), `@OPT-BEH-BEH-025` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | To identiske vitnemål reknes som ett vitnemål | – (`@wont`) | mangler krav |
| `@FLY-OPT-AUT-001` | Saken får grunnlag fra vitnemålet | `@OPT-BEH-BEH-019` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Poengene beregnes fra grunnlaget og rangeringsregelverket | `@OPT-BEH-BEH-018` (`@planned`), `@OPT-REG-RAN-001` (`@implemented`), `@OPT-REG-RAN-002` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoeng når grunnlaget er satt | `@OPT-BEH-BEH-028` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Søknaden dobbeltrangeres automatisk etter 23/5-regelen | – (`@wont`) | mangler krav |
| `@FLY-OPT-AUT-001` | Kravelementene vurderes mot vitnemålet når poengene er beregnet | `@OPT-BEH-BEH-020` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Kvotespørsmålene med algoritme besvares automatisk | `@OPT-BEH-BEH-012` (`@implemented`, ankeret levert), `@OPT-REG-KVO-002` (`@implemented`) | nei (`@FLY-OPT-SAK-001` er `@planned`) |
| `@FLY-OPT-AUT-001` | Kvalifiseringen oppdateres når kravelementene er vurdert | `@OPT-BEH-BEH-020` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Søkeren fordeles på kvoter når kvalifiseringen og kvotesvarene er satt | `@OPT-BEH-BEH-012` (`@implemented`, ankrene levert) | nei (`@FLY-OPT-SAK-001` er `@planned`) |
| `@FLY-OPT-AUT-001` | Søkeren får poengsum per kvote når søkeren er fordelt på kvoter | `@OPT-BEH-BEH-031` (`@planned`), `@OPT-REG-KVO-001` (`@implemented`), `@OPT-REG-RAN-002` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Saken får mangeltekster når kravelementene er vurdert | `@OPT-BEH-BEH-036` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet | `@OPT-BEH-BEH-036` (`@planned`, regelen om merking er `@draft`) | nei |
| `@FLY-OPT-AUT-001` | Saken blir ferdig behandlet og er klar til å være med i plasstildelingen | `@OPT-BEH-BEH-025` (`@planned`), `@OPT-BEH-BEH-029` (`@planned`) | nei |
| `@FLY-OPT-AUT-001` | Søknadsalternativene beregnes på nytt når regelverket er rettet | `@OPT-BEH-BEH-026` (`@planned`) | nei |

`@FLY-OPT-AUT-001`: 0 av 17 faser levert (de to `@wont`-fasene er ikke regnet med). Uten `@FLY-OPT-SAK-001` hadde 2 av 17 vært levert, og overleveringene i de to fasene finnes i koden (se `## Scenarioer`).

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-032` | `@OPT-BEH-BEH-011` Tildele saksbehandlende organisasjon | 1 | `@planned` | – | ikke levert, `@OPT-BEH-BEH-032` kan ikke leveres før dette |
| `@OPT-BEH-BEH-019` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-019` kan ikke leveres før dette |
| `@OPT-BEH-BEH-019` | `@OPT-REG-GRU-001` Grunnlag og mangelkoder | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-018` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-028` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-028` kan ikke leveres før dette |
| `@OPT-BEH-BEH-028` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-020` | `@OPT-BEH-BEH-004` Velge vitnemål som grunnlag for poengberegningen | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-020` kan ikke leveres før dette |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-001` Kompetanseregelverk | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-002` Kravelement | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-031` | `@OPT-REG-KVO-001` Kvotetype | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-031` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-036` | `@OPT-BEH-BEH-008` Søknadsmangler | 1 | `@planned` | – | ikke levert, `@OPT-BEH-BEH-036` kan ikke leveres før dette · Regel: Opptaksforvalteren forvalter mangelkodene i regelverkssamlingen, Kategorien til mangelkoden avgjør hva mangelen hindrer, Saksbehandleren sjekker ut mangelen når søkeren har dokumentert på nytt |
| `@OPT-BEH-BEH-036` | `@OPT-SØK-SØK-018` Oppgi at generell studiekompetanse fullføres i vår | 1 | `@draft` | – | ikke levert, `@OPT-BEH-BEH-036` kan ikke leveres før dette |
| `@OPT-BEH-BEH-025` | `@OPT-BEH-BEH-008` Søknadsmangler | 1 | `@planned` | – | ikke levert, `@OPT-BEH-BEH-025` kan ikke leveres før dette · Regel: Kategorien til mangelkoden avgjør hva mangelen hindrer, Søkeren ser bare manglene som er publisert, og får melding om dem |
| `@OPT-BEH-BEH-026` | `@OPT-PLA-TIL-001` Starte en plasstildeling | 1 | `@draft` | – | ikke levert, `@OPT-BEH-BEH-026` kan ikke leveres før dette |
| `@OPT-BEH-BEH-012` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | |
| `@OPT-BEH-BEH-012` | `@OPT-REG-KVO-001` Kvotetype | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-012` | `@OPT-REG-KVO-002` Kvotespørsmål | 1 | `@implemented` | – | |
| `@FLY-OPT-AUT-001` | `@FLY-OPT-SAK-001` Saksbehandlertildeling (flyt) | 1 | `@planned` | – | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-REG-RAN-001` Rangeringsregelverk | 1 | `@implemented` | – | |
| `@FLY-OPT-AUT-001` | `@OPT-REG-KVO-002` Kvotespørsmål | 1 | `@implemented` | – | |

Avhengigheter: 21 på nivå 1, 10 av dem ikke `@implemented`.

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | Resultatene hentes når søkeren sender inn søknaden | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java:953` leverSoknadskladd registrerer SOKNAD-hendelse; `opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:312-317,129-134` tildeler og henter vitnemål (:392-394) |
| `@OPT-BEH-BEH-030` | Resultatene hentes når søknaden registreres på vegne av søkeren | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `StudiekurvService.java:826-828` leverSoknadskladdPaVegneAvSoker → leverSoknadskladd (:953); `SoknadshendelseJobb.java:129-134` |
| `@OPT-BEH-BEH-030` | Resultatene hentes når en endring av søknaden gir en ny sak | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `StudiekurvService.java:1063` oppdaterSoknadFraSoknadskladd registrerer SOKNAD-hendelse; `SoknadshendelseJobb.java:312-317,134`; `vgs/VgsLagringService.java:71-103` |
| `@OPT-BEH-BEH-030` | Resultatene hentes ikke på nytt når en endring av søknaden ikke gir en ny sak | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — Koden gjør det motsatte: `StudiekurvService.java:574-579` leverPrioriteringerFraSoknadKladd registrerer SOKNAD-hendelse; `SoknadshendelseJobb.java:316-317,134` henter på nytt |
| `@OPT-BEH-BEH-030` | Resultatene hentes først når saken er opprettet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `SoknadshendelseJobb.java:298-305,319-325` utsetter uten regel; bare tildelte hentes (:126-134) |
| `@OPT-BEH-BEH-030` | Det importerte vitnemålet har opplysningene saksbehandlingen trenger | ikke funnet | P: delvis · A: ikke relevant · M: ikke relevant — `vgs/KregVgsParser.java:98-107`, `VgsLagringService.java:71-101` lagrer det meste, men bare én GSK-påstand (gsk_ok fra paastandOmGsk :104); KREG-spørringen `hent-kompetanseoppnaelse.graphql:7` henter bare paastandOmGsk |
| `@OPT-BEH-BEH-030` | Søker med flere vitnemål får alle importert | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `KregVgsParser.java:70-77`; `HentVgsVitnemaalService.java:116-117` |
| `@OPT-BEH-BEH-030` | Kompetansebevis importeres | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `KregVgsParser.java:70-77,98`; `V176__kompetanse_vgs.sql:124` |
| `@OPT-BEH-BEH-030` | Vitnemål som er importert fra før, importeres ikke på nytt | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `VgsLagringService.java:49-56` FANTES_FRA_FOER |
| `@OPT-BEH-BEH-030` | Annullert vitnemål importeres som annullert | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `KregVgsParser.java:107`; `VgsLagringService.java:84,97` |
| `@OPT-BEH-BEH-030` | Vitnemål som annulleres etter importen, blir annullert | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `VgsLagringService.java:53-63` (forutsetter ny henting etter ny SOKNAD-hendelse) |
| `@OPT-BEH-BEH-030` | Vitnemålet blir stående som annullert når KREG opphever annulleringen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `VgsLagringService.java:53-56` |
| `@OPT-BEH-BEH-030` | Søker uten fødselsnummer får ingen resultater importert | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `HentVgsVitnemaalService.java:59-72`; `SoknadshendelseJobb.java:123-134` |
| `@OPT-BEH-BEH-030` | Resultatene hentes når KREG svarer igjen | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — `SoknadshendelseJobb.java:410-411` logger feilen, ingen ny henting; `KregKlient.java:35,69` bare timeout |
| `@OPT-BEH-BEH-030` | Søkeren får vitnemålet etter at søknaden er levert | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — Ingen jobb for aktive søkere; eneste kaller av HentVgsVitnemaalService er `SoknadshendelseJobb.java:394`; søkt i @Scheduled-jobbene og branchene |
| `@OPT-BEH-BEH-030` | Vitnemålet annulleres og erstattes av et nytt etter at opptakssystemet har behandlet søknaden | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — Som over |
| `@OPT-BEH-BEH-030` | Vitnemålet annulleres uten at det kommer et nytt, etter at opptakssystemet har behandlet søknaden | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — Som over |
| `@OPT-BEH-BEH-032` | Den nye saken behandles automatisk når saksbehandlertildelingen har opprettet den | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:311-317,129-134` tildeler og henter, men kaller ikke automatisk behandling. Eneste inngang til `AutomatiskSaksbehandlingService.behandleSakAutomatisk` er mutationen `behandleSakAutomatisk` (`automatisk-saksbehandling.graphqls:51-57`) |
| `@OPT-BEH-BEH-032` | Saken behandles automatisk når jobben finner søkerens første vitnemål | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — Ingen jobb for nye vitnemål; eneste kaller av HentVgsVitnemaalService er `SoknadshendelseJobb.java:394` |
| `@OPT-BEH-BEH-032` | Saksbehandleren ser at saken har fått ny dokumentasjon | ikke funnet | P: mangler · A: delvis · M: ikke relevant — Taggen «Ny dokumentasjon» gjelder uleste saksdokumenter: `fs-admin/src/domains/soknadsbehandling/features/SakOverviewView/components/SakOverviewTable/SakOverviewTable.tsx:178-179` → `SakStatusBadge.tsx:35-36` |
| `@OPT-BEH-BEH-032` | Saken behandles ikke automatisk på nytt når det kommer et nytt vitnemål | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — Jobben for nye vitnemål finnes ikke |
| `@OPT-BEH-BEH-032` | Saken som er under behandling, behandles automatisk på vitnemålet saksbehandleren velger | ikke funnet | P: delvis · A: delvis · M: ikke relevant — `fs-admin/src/domains/soknadsbehandling/features/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:32-35` sender bare sakId; `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/records/BehandleSakInput.java:9`; `autosak/SetteGrunnlagService.java:111-114` FlereVitnemaalException |
| `@OPT-BEH-BEH-032` | Saken som er ferdig behandlet, settes til Under behandling når behandlingen startes | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — `autosak/AutomatiskSaksbehandlingService.java:83-142` endrer ikke status |
| `@OPT-BEH-BEH-032` | Saken blir ferdig behandlet igjen når automatikken avgjør alt | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Automatikken setter aldri FERDIG_BEHANDLET (`saksbehandling/EndreStatusService.java:32` er saksbehandlerens) |
| `@OPT-BEH-BEH-032` | Saksbehandleren starter bare behandlingen for saker hos organisasjonen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `AutomatiskSaksbehandlingService.java:89-97` UkjentSakException; RLS `V493__tilbyder_ser_saksbehandlingen.sql:38-45,85-96` |
| `@OPT-BEH-BEH-032` | Grunnlaget saksbehandleren har valgt, står når behandlingen startes | funnet | P: funnet · A: funnet · M: ikke relevant — `SetteGrunnlagService.java:100-105,227` harManueltGrunnlag; `BehandleSakAutomatiskButton.tsx:30-36` |
| `@OPT-BEH-BEH-032` | Saken som er ferdig behandlet automatisk, viser at den er behandlet automatisk | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Ingen ferdigbehandling, ingen markering i fs-admin |
| `@OPT-BEH-BEH-032` | Saken behandles ikke automatisk når automatikken er skrudd av | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Ingen innstilling per opptak; bare feature-flagget `automatisk-soknadsbehandling-trigger` (`BehandleSakAutomatiskButton.tsx:50-52`) |
| `@OPT-BEH-BEH-032` | Automatikken stopper på tidspunktet opptaksforvalteren har satt | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Samme |
| `@OPT-BEH-BEH-032` | Automatikken i ett opptak påvirker ikke andre opptak | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Samme |
| `@OPT-BEH-BEH-032` | Saken viser at den ikke kunne behandles automatisk fordi søkeren ikke har vitnemål | ikke funnet | P: mangler · A: mangler · M: ikke relevant — `SetteGrunnlagService.java:116-118` returnerer false uten årsak; `AutomatiskSaksbehandlingService.java:103-107` logger |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand er at søkeren har generell studiekompetanse | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — vgs_dokument har bare gsk_ok (V176__kompetanse_vgs.sql:113); seksfagskontrollen bare i autosak (EV:67) |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand beregnes uavhengig av GSK OK fra KREG | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — EV:64-67 kjøres bare når gsk_ok er sann; lagres ikke |
| `@OPT-BEH-BEH-015` | Hvert vitnemål får sin egen påstand | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen påstand lagres; AS:77-83 bare ett vitnemål |
| `@OPT-BEH-BEH-015` | Grunnlagskoder som settes automatisk | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — grunnlagskode bare på konklusjonen (AS:171), ingen KLF på main — B1 EV:60-61 |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand er at søkeren ikke har GSK når <grunn> | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen påstand; sperrer gjelder konklusjonen (AS:85-86, EV:61-62, EV:67-68) |
| `@OPT-BEH-BEH-015` | Annullert vitnemål får ingen påstand fra opptakssystemet | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen påstand; AS:79 |
| `@OPT-BEH-BEH-015` | Kompetansebevis får ingen påstand fra opptakssystemet | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen påstand; AS:81 |
| `@OPT-BEH-BEH-015` | Vitnemålet gir GSK når det har GSK OK fra KREG | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — EV:64-69 krever også seksfagskontroll — B1 EV:56-65 |
| `@OPT-BEH-BEH-015` | Vitnemålet gir ikke GSK når det ikke har GSK OK fra KREG | funnet | P: funnet · A: ikke relevant · M: ikke relevant — EV:64-65; AS:113; KregVgsParser.java:104 |
| `@OPT-BEH-BEH-015` | Uenighet med skolen stopper ikke den automatiske behandlingen | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — EV:67-68 KRYSSJEKK_FEILET; ASB:103-108 — B1 EV:59-65 |
| `@OPT-BEH-BEH-015` | Annullert vitnemål gir ikke GSK | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AS:77-80; SettGskKonklusjonService DOKUMENT_ANNULLERT |
| `@OPT-BEH-BEH-015` | Saksbehandleren ser at opptakssystemet er uenig med skolen når vitnemålet <skolen> GSK OK fra KREG | ikke funnet | P: mangler · A: mangler · M: ikke relevant — vgs-dokument.graphqls:12 bare pastandOmGsk; fs-admin VitnemalsbehandlingSection.tsx:146, VgsDokumentView.tsx:51-53; B1 bare merknad_automatisk |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra vitnemålet | ikke funnet | P: delvis · A: ikke relevant · M: ikke relevant — AS:64-89,171,172 i autosak, ikke ved import (HV:108-136) |
| `@OPT-BEH-BEH-015` | Søknaden får grunnlagskoden for løpet når opptakssystemet er uenig med skolen | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — EV:67-68 — B1 EV:59-65 |
| `@OPT-BEH-BEH-015` | Ingen automatisk konklusjon når løpet ikke finnes i opptakssystemets liste over løp | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AS:145-153; EV:58-59 |
| `@OPT-BEH-BEH-015` | Opptaksforvalteren får varsel om et løp som mangler i listen over løp | ikke funnet | P: mangler · A: mangler · M: ikke relevant — bare logg (ASB:104-107) |
| `@OPT-BEH-BEH-015` | Søknaden får grunnlagskoden <grunnlagskode> når et løp fra <reform> ikke har en grunnlagskode | ikke funnet | P: delvis · A: ikke relevant · M: ikke relevant — AS:89 tillatDynamiskFallback=false; EV:61-62,83-95 — B1 EV:63-66,74-89 |
| `@OPT-BEH-BEH-015` | Opptaksforvalteren får varsel om et løp uten grunnlagskode | ikke funnet | P: mangler · A: mangler · M: ikke relevant — intet varsel |
| `@OPT-BEH-BEH-015` | Vitnemål som ikke gir GSK, gir ingen konklusjon | funnet | P: funnet · A: ikke relevant · M: ikke relevant — EV:64-65; AS:50,169 |
| `@OPT-BEH-BEH-015` | Vitnemålet med senest utstedelsesdato brukes | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — AS:81-82 IKKE_ETT_VGS_DOKUMENT |
| `@OPT-BEH-BEH-015` | Alle søknader uten konklusjon oppdateres | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — per sak (ASB:84,102); import oppdaterer ikke |
| `@OPT-BEH-BEH-015` | Søknader i avsluttede opptak oppdateres ikke | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen sjekk på opptaksstatus |
| `@OPT-BEH-BEH-015` | Nytt vitnemål fra KREG etter at søknaden er opprettet | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — SoknadshendelseJobb.java:126-134 bare ved søknadshendelse |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra tidligere samordna opptak | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — V481__gsk_konklusjon_historikk.sql:7 tabeller leses ikke; AS:136-143 bare samme opptak |
| `@OPT-BEH-BEH-015` | Vitnemålet går foran tidligere konklusjon | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Bare den siste tidligere konklusjonen gjenbrukes | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Negative konklusjoner gjenbrukes ikke | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra lokalt opptak | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Gjenbruke kvalitetssikret konklusjon fra FS-klienten | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Annullert konklusjon gjenbrukes ikke | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Konklusjon med annullering fram i tid gjenbrukes ikke | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Konklusjon som bygger på et annullert vitnemål gjenbrukes ikke | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Ingen grunnlag for generell studiekompetanse | funnet | P: funnet · A: ikke relevant · M: ikke relevant — EV:58-69; ASB:103-108 |
| `@OPT-BEH-BEH-015` | Konklusjon på søknaden overskrives ikke | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AS:65-66,136-143 |
| `@OPT-BEH-BEH-015` | Systemet setter aldri en negativ konklusjon | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AS:50,169 |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra vitnemålet i den automatiske behandlingen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — ASB:100-102; AS:64-89,165-178 (per sak, krever ett VM og enig seksfagskontroll) Kontrollen var usikker (kjøres bare per sak, og strengere vilkår på main); lead: funnet, siden Når-steget er den automatiske behandlingen. |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra et tidligere opptak i den automatiske behandlingen | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — AS:64-89 bare vitnemål |
| `@OPT-BEH-BEH-015` | Konklusjonen overskrives ikke i den automatiske behandlingen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AS:65-66,136-143 |
| `@OPT-BEH-BEH-015` | Overskrive positiv konklusjon med negativ konklusjon | funnet | P: funnet · A: funnet · M: ikke relevant — GV:99-104,430-449,349-360; GC:365-376,338-351,234-239 |
| `@OPT-BEH-BEH-015` | Legge til positiv konklusjon når ingen finnes | funnet | P: funnet · A: funnet · M: ikke relevant — GV:68-80,396-411; GC:322,352-362,240-244 |
| `@OPT-BEH-BEH-015` | Bare positive konklusjoner kan legges til når ingen finnes | ikke funnet | P: funnet · A: mangler · M: ikke relevant — GV:407-411 avviser; GC:322-351 viser likevel «Ikke kvalifisert» |
| `@OPT-BEH-BEH-015` | Automatisk konklusjon står når vitnemålet annulleres | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — motsatt: HV:130-131 → TB:60-111,79-85; ingen tagg — B2 fjerner tilbakekallingen, ingen tagg |
| `@OPT-BEH-BEH-015` | Gjenbrukt konklusjon står når vitnemålet annulleres | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen gjenbruk/tagg; TB:71-74 |
| `@OPT-BEH-BEH-015` | Konklusjon i avsluttet opptak trekkes ikke tilbake | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — TB:66-75 uten opptaksstatus — B2 fjerner tilbakekallingen |
| `@OPT-BEH-BEH-015` | Annulleringen oppdages uten at søkeren endrer søknaden | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — SoknadshendelseJobb.java:126-134 |
| `@OPT-BEH-BEH-015` | Se hva den automatiske konklusjonen bygger på | ikke funnet | P: delvis · A: mangler · M: ikke relevant — AS:173-176; gsk.graphqls:320,326; GC:64-95, GSKHistory.tsx:17-49 henter ikke |
| `@OPT-BEH-BEH-015` | Se hvilket opptak en gjenbrukt konklusjon kommer fra | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen gjenbruk |
| `@OPT-BEH-BEH-027` | Fag som er tatt ut av kontrollene, oppfyller ikke et delkrav | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — MAP:71-73 alle fag aktive; vgs_dokument_fag_aktiv (V177) leses ikke |
| `@OPT-BEH-BEH-027` | Delkravene for <reform> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1263-1285; FagSoek.java:60-61 |
| `@OPT-BEH-BEH-027` | Vitnemål fra Kunnskapsløftet uten <delkrav> får påstanden ikke GSK | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1267-1271; EV:67 |
| `@OPT-BEH-BEH-027` | Vitnemål fra Reform 94 uten <delkrav> får påstanden ikke GSK | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1278-1285 |
| `@OPT-BEH-BEH-027` | Matematikkravet er oppfylt med <alternativ> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1112-1136,1141-1170,627-648,461-490,26-29 |
| `@OPT-BEH-BEH-027` | Påbygging med matematikk <fag> på vg1 | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1143-1169 |
| `@OPT-BEH-BEH-027` | Matematikk for yrkesfag på vg1 alene oppfyller ikke matematikkravet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1135,1170 |
| `@OPT-BEH-BEH-027` | Naturfagkravet er oppfylt med <alternativ> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1174-1184,349-360,363-374 |
| `@OPT-BEH-BEH-027` | Vg1 og vg3 fra ulike planer oppfyller ikke naturfagkravet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1179-1183 |
| `@OPT-BEH-BEH-027` | Samfunnsfagkravet er oppfylt med <fagkode> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1187-1189 |
| `@OPT-BEH-BEH-027` | Engelskkravet er oppfylt med <fagkode> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1192-1207 |
| `@OPT-BEH-BEH-027` | Standard norsk med <variant> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:869-871,823-838,213-215,845-861,218-221,864-866,224-227 |
| `@OPT-BEH-BEH-027` | Merknaden VMM25 med <fag> gir ikke standard norsk | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:845-848 |
| `@OPT-BEH-BEH-027` | NOR1049 som privatist med merknaden VMM25 erstatter norsk hovedmål | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:833-838,825 (krever i tillegg at NOR1050 mangler) |
| `@OPT-BEH-BEH-027` | Norskkravet er oppfylt med <variant> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:869-891,230-231,235,880 |
| `@OPT-BEH-BEH-027` | Standard norsk krever historie etter standard plan (<fagkode>) | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1237-1245 |
| `@OPT-BEH-BEH-027` | Standard norsk med historie etter samisk plan oppfyller ikke kravet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1237-1245,1248-1257 |
| `@OPT-BEH-BEH-027` | <variant> godtar alle historiefagene | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1222-1235,1248-1257 |
| `@OPT-BEH-BEH-027` | Delkravet for <delkrav> er oppfylt med <alternativ> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1288-1311,1314-1328,1331-1343,1349-1400,1405 |
| `@OPT-BEH-BEH-027` | Norsk for tegnspråklige alene oppfyller ikke norskkravet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KE:1402-1407 |
| `@OPT-BEH-BEH-027` | Løpet settes sammen av programområdene etter nivå | funnet | P: funnet · A: ikke relevant · M: ikke relevant — MAP:112-117,78 |
| `@OPT-BEH-BEH-027` | Påstanden er GSK med grunnlagskoden for løpet | usikker | P: delvis · A: ikke relevant · M: ikke relevant — EV:70-71 gir grunnlagskode, men bare når gsk_ok fra KREG er sann (EV:64-65); kravet sier beregningen ikke bruker KREG-påstanden |
| `@OPT-BEH-BEH-027` | Grunnlagskoden gis selv om påstanden ikke er GSK | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — EV:67-68 KRYSSJEKK_FEILET uten grunnlagskode — finnes i branch origin/solov/gsk-pbpby4-klf (fs-plattform): EV:59-65 (kontrollEnig=false), fortsatt bare når gsk_ok er sann |
| `@OPT-BEH-BEH-027` | Ukjent løp | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AS:145-153; EV:58-59 |
| `@OPT-BEH-BEH-027` | Påbyggingsruten PBPBY4 gir grunnlagskoden KLF | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — EV:44-49,70-71 aldri KLF — finnes i branch origin/solov/gsk-pbpby4-klf: EV:60-61 |
| `@OPT-BEH-BEH-027` | Påbyggingsruten PBPBY4 på et ukjent løp | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AS:146,150-152; EV:58-59 |
| `@OPT-BEH-BEH-027` | Løp fra <reform> uten grunnlagskode gir grunnlagskoden <grunnlagskode> | usikker | P: delvis · A: ikke relevant · M: ikke relevant — EV:83-95 bare med tillatDynamiskFallback (semi-automatikken); AS:89 sender false; EV:61-62 — finnes i branch origin/solov/gsk-pbpby4-klf: EV:63-66,74-89 Kontrollen: finnes på main i den semi-automatiske stien (P/autosak/gsk/SettGskKonklusjonService.java:133 → EV:83-92), bare helautomatikken mangler; samme forbehold om gsk_ok som KLS-raden. |
| `@OPT-BEH-BEH-027` | Løp og vitnemål fra ulike reformer | funnet | P: funnet · A: ikke relevant · M: ikke relevant — EV:84-85; EV:61-62 |
| `@OPT-BEH-BEH-019` | Grunnlag ut fra førstegangsvitnemål og alder | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/autosak/SetteGrunnlagService.java:301-336,287-288 |
| `@OPT-BEH-BEH-019` | Alderen regnes ut på datoen for aldersberegning | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:165-167; P/regelverk/kvoteplassering/Aldersgrense.java:55-56; P/saksbehandling/AldersberegningsdatoUtleder.java:44-49 |
| `@OPT-BEH-BEH-019` | Førstegangsvitnemål går foran | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:287-298,330-336,188-205 |
| `@OPT-BEH-BEH-019` | Sammensatt vitnemål gir ikke grunnlaget som krever førstegangsvitnemål | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:132 leser bare foerstegangsvm fra ett dokument; ingen sammensatt vitnemål |
| `@OPT-BEH-BEH-019` | Ingen grunnlag settes når flere grunnlag passer like godt | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — Motsatt: SetteGrunnlagService.java:289-298 velger lavest kode |
| `@OPT-BEH-BEH-019` | Grunnlag uten egenskaper for automatikken settes ikke | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:255-259 |
| `@OPT-BEH-BEH-019` | Bare grunnlag i regelverket til utdanningstilbudene i søknaden kan settes | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:236-253,145-153; P/saksbehandling/KvalifikasjonsgrunnlagOppdateringService.java:150-166 |
| `@OPT-BEH-BEH-019` | Grunnlag som ikke er aktivt, settes ikke | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:254 |
| `@OPT-BEH-BEH-019` | Ingen grunnlag settes automatisk når <grunn> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:116-118,120-127,128-130,171-182 |
| `@OPT-BEH-BEH-019` | Søker med flere vitnemål behandles ikke automatisk | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:110-115; P/autosak/AutomatiskSaksbehandlingService.java:86; G/saksbehandling/automatisk-saksbehandling.graphqls:230 |
| `@OPT-BEH-BEH-019` | Grunnlag fra vitnemålet saksbehandleren har valgt | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:110-115 kaster også med valgt vitnemål; vgdoknr brukes bare i P/autosak/gsk/SettGskKonklusjonService.java:75,118 |
| `@OPT-BEH-BEH-019` | Kompetansebevis ved siden av vitnemålet stopper ikke automatikken | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — Motsatt: SetteGrunnlagService.java:371-376,111-115 |
| `@OPT-BEH-BEH-019` | Annullert vitnemål teller ikke | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:374 |
| `@OPT-BEH-BEH-019` | Grunnlaget settes etter GSK-konklusjonen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AutomatiskSaksbehandlingService.java:100-112 |
| `@OPT-BEH-BEH-019` | Automatikken setter grunnlaget i alle sakene i søknaden | ikke funnet | P: mangler · A: mangler · M: ikke relevant — SetteGrunnlagService.java:193 bare sakens org; per sak (automatisk-saksbehandling.graphqls:52-58; A/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:28-32) |
| `@OPT-BEH-BEH-019` | Grunnlaget settes av den automatiske behandlingen | funnet | P: funnet · A: funnet · M: ikke relevant — AutomatiskSaksbehandlingService.java:110-112; SetteGrunnlagService.java:198; BehandleSakAutomatiskButton.tsx:28-32 |
| `@OPT-BEH-BEH-019` | Grunnlag fra utdanningstilbudet når søknadsalternativet opprettes | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen kobling grunnlag→utdanningstilbud (@draft @openquestion) |
| `@OPT-BEH-BEH-019` | Automatikken setter ikke grunnlag når saksbehandleren har lagt til et grunnlag | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:100-106,227-234 |
| `@OPT-BEH-BEH-019` | Grunnlaget saksbehandleren legger til, gjelder bare saken hos organisasjonen | funnet | P: funnet · A: funnet · M: ikke relevant — P/saksbehandling/LeggTilGrunnlagService.java:93-96; PM/V493__tilbyder_ser_saksbehandlingen.sql:89-90; A/GrunnlagCard/GrunnlagCard.tsx:119-124 |
| `@OPT-BEH-BEH-019` | Saksbehandleren velger et grunnlag som automatikken har satt | usikker | P: funnet · A: mangler · M: ikke relevant — LeggTilGrunnlagService.java:107-112; GrunnlagCard.tsx:107-115 klikk kaller fjernGrunnlag Kontrollen: backend gjør det; i fs-admin fjerner ett klikk grunnlaget, og to klikk gir samme sluttilstand. Tolkningsspørsmål. |
| `@OPT-BEH-BEH-019` | Automatikken fjerner ikke grunnlag saksbehandleren har lagt til | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:100-106,188-205 |
| `@OPT-BEH-BEH-019` | Grunnlaget blir stående når studieønsket som ga det, fjernes | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KvalifikasjonsgrunnlagOppdateringService.java:55-58,99-109 |
| `@OPT-BEH-BEH-019` | Saksbehandleren fjerner et grunnlag som er satt automatisk | funnet | P: funnet · A: funnet · M: ikke relevant — P/saksbehandling/FjernGrunnlagService.java:69-86; GrunnlagCard.tsx:107-124 |
| `@OPT-BEH-BEH-019` | Automatikken setter ikke et grunnlag som saksbehandleren har fjernet | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — FjernGrunnlagService.java:70-79 husker ikke; SetteGrunnlagService.java:227-234 |
| `@OPT-BEH-BEH-019` | Automatikken erstatter grunnlaget når søkeren passer til et annet | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:86-87,188-205 bare upsert |
| `@OPT-BEH-BEH-019` | Grunnlag utenfor aldersgrensen kan ikke velges manuelt | ikke funnet | P: mangler · A: mangler · M: ikke relevant — LeggTilGrunnlagService.java:58-123,143-171 sjekker ikke alder |
| `@OPT-BEH-BEH-019` | Opptaket mangler dato for aldersberegning | ikke funnet | P: funnet · A: delvis · M: ikke relevant — LeggTilGrunnlagService.java:40; AldersberegningsdatoUtleder.java:17-24,37-41; P/opptak/OpptakKreverAlderUtleder.java:51-57; G/saksbehandling/sak.graphqls:1070; GrunnlagCard.tsx:138-146 bare generisk feil |
| `@OPT-BEH-BEH-019` | Opptakskrav, kvoter og tilleggspoeng følger grunnlaget saksbehandleren legger til | ikke funnet | P: delvis · A: ikke relevant · M: ikke relevant — LeggTilGrunnlagService.java:44-48; P/saksbehandling/PropageringService.java:98-106,150-157; P/saksbehandling/PoengRadOppdateringService.java:104-105,115-116 tilleggspoeng regnes ikke |
| `@OPT-BEH-BEH-019` | Opptakskrav, kvoter og tilleggspoeng følger grunnlaget som er satt automatisk | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AutomatiskSaksbehandlingService.java:114-135 |
| `@OPT-BEH-BEH-019` | Se at grunnlaget er satt automatisk | ikke funnet | P: delvis · A: mangler · M: ikke relevant — SetteGrunnlagService.java:198 lagrer; G/regelverk/kvalifisering.graphqls:140-150 eksponerer ikke; GrunnlagCard.tsx:18-41 |
| `@OPT-BEH-BEH-019` | Se hvorfor grunnlaget ble valgt | ikke funnet | P: delvis · A: mangler · M: ikke relevant — SetteGrunnlagService.java:349-361 merknad lagres, ikke eksponert |
| `@OPT-BEH-BEH-019` | Endringsloggen viser at den automatiske behandlingen satte grunnlaget | ikke funnet | P: mangler · A: mangler · M: ikke relevant — PM/V480__stopp_endringslogg.sql:1-2,13-28; sak.graphqls:196 |
| `@OPT-BEH-BEH-018` | Poengtype som beregnes fra vitnemålet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/regelverk/poeng/AutomatiskPoengberegningService.java:109-146; P/autosak/kontrollmotor/KontrollMotor.java:168-170; P/regelverk/poeng/PoengService.java:171-201 |
| `@OPT-BEH-BEH-018` | Poengtype uten kobling til vitnemålet beregnes ikke | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AutomatiskPoengberegningService.java:149-153,156-162 |
| `@OPT-BEH-BEH-018` | Beregnet poeng rundes til antall desimaler poengtypen har | funnet | P: funnet · A: ikke relevant · M: ikke relevant — PoengService.java:179-186; P/regelverk/poeng/PoengAvrunder.java:30 |
| `@OPT-BEH-BEH-018` | Skolepoeng beregnet fra vitnemålspoengene | usikker | P: delvis · A: ikke relevant · M: ikke relevant — ingen kode for skolepoeng/tak 4; poengformler som data (PoengberegningService.java:24-33, PoengsumService.java:60, PoengformelParser.java:12-15 har min()); PM/V14__regelverk_grunndata.sql:18 |
| `@OPT-BEH-BEH-018` | Ingen automatiske vitnemålspoeng når <grunn> | ikke funnet | P: delvis · A: mangler · M: ikke relevant — P/vgs/VgsDokumentVitnemaalService.java:42-55; AutomatiskPoengberegningService.java:121-133; PoengService.java:210-215; rad 5 (gsk_ok) sjekkes ikke; rad 6 uten melding (P/saksbehandling/PoengRadOppdateringService.java:46-48); A/PoengberegningCard/PoengberegningCard.tsx:15-46 viser ikke merknadAutomatisk |
| `@OPT-BEH-BEH-018` | Kompetansebevis ved siden av ett vitnemål hindrer ikke beregningen | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — motsatt: VgsDokumentVitnemaalService.java:43-50 |
| `@OPT-BEH-BEH-018` | Vitnemålspoeng fra vitnemålet saksbehandleren har valgt | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — AutomatiskPoengberegningService.java:185-194 bare byggVitnemaalForPerson; P/autosak/gsk/SettGskKonklusjonService.java:75 |
| `@OPT-BEH-BEH-018` | Poeng som saksbehandleren endrer, blir stående | funnet | P: funnet · A: funnet · M: ikke relevant — P/regelverk/poeng/SettPoengService.java:104,125-153; AutomatiskPoengberegningService.java:82; PoengService.java:200; A/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:21-25,138-140 |
| `@OPT-BEH-BEH-018` | Saksbehandleren overstyrer automatisk beregnet <poeng> | funnet | P: funnet · A: funnet · M: ikke relevant — SettPoengService.java:104,133-136; AutomatiskPoengberegningService.java:82; PoengberegningCardRow.tsx:124-142 |
| `@OPT-BEH-BEH-018` | Låst poeng beregnes ikke på nytt | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AutomatiskPoengberegningService.java:82; PoengService.java:52,200 |
| `@OPT-BEH-BEH-018` | Låse opp et poeng | funnet | P: funnet · A: funnet · M: ikke relevant — SettPoengService.java:93-102,163-186; PoengberegningCardRow.tsx:162-188,217-223 |
| `@OPT-BEH-BEH-018` | Poeng som ikke er låst, beregnes på nytt | funnet | P: funnet · A: ikke relevant · M: ikke relevant — PoengService.java:193-201 |
| `@OPT-BEH-BEH-018` | Saksbehandlerens merknad på poenget er uendret | funnet | P: funnet · A: ikke relevant · M: ikke relevant — PoengService.java:193-201,45-53 |
| `@OPT-BEH-BEH-018` | Se at poenget er beregnet automatisk, og hvilket vitnemål det bygger på | ikke funnet | P: funnet · A: mangler · M: ikke relevant — PoengService.java:189-198; G/saksbehandling/poeng.graphqls:79-80,94-100; PoengberegningCard.tsx:15-46 henter ikke |
| `@OPT-BEH-BEH-018` | Se hvorfor vitnemålspoengene ikke er beregnet | ikke funnet | P: funnet · A: mangler · M: ikke relevant — PoengService.java:210-215; poeng.graphqls:96-100; vises ikke |
| `@OPT-BEH-BEH-018` | Finne saker som er behandlet automatisk | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen filter/logg; PM/V480__stopp_endringslogg.sql:1-2 (@openquestion) |
| `@OPT-BEH-BEH-028` | Alderspoeng for søkerens alder | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/regelverk/poeng/Alderspoeng.java:31-88; PoengService.java:90-101; AutomatiskPoengberegningService.java:156-160 |
| `@OPT-BEH-BEH-028` | Alderspoengene viser hvilken alder de er regnet ut for | ikke funnet | P: funnet · A: mangler · M: ikke relevant — PoengService.java:99-101; Alderspoeng.java:99-100; G/saksbehandling/poeng.graphqls:94-100; A/PoengberegningCard/PoengberegningCard.tsx:15-46 viser ikke |
| `@OPT-BEH-BEH-028` | Standarddatoen brukes når datoen for aldersberegning ikke er satt | ikke funnet | P: delvis · A: ikke relevant · M: ikke relevant — AldersberegningsdatoUtleder.java:51-55 finnes; men ved manuelt grunnlag regnes ikke alderspoeng |
| `@OPT-BEH-BEH-028` | Kjønnspoeng for søkerens kjønn | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/regelverk/poeng/KjonnspoengAlgoritme.java:11-19; Kjonnspoeng.java:28-29; PoengService.java:257-267 |
| `@OPT-BEH-BEH-028` | Kjønnspoengene viser hvilket kjønn de er regnet ut for | ikke funnet | P: funnet · A: mangler · M: ikke relevant — PoengService.java:113-115; poeng.graphqls:96-100; vises ikke |
| `@OPT-BEH-BEH-028` | Poeng for høyere utdanning | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen algoritme; PM/V170__poengalgoritme_alder_kjonn.sql:13-25 bare ALD/KJONN |
| `@OPT-BEH-BEH-028` | Bare beståtte emner teller | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — som over |
| `@OPT-BEH-BEH-028` | Fagskolepoeng teller ikke | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — som over |
| `@OPT-BEH-BEH-028` | Studiepoengene telles når poengene regnes ut | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — som over |
| `@OPT-BEH-BEH-028` | Automatikken velger grunnlaget | funnet | P: funnet · A: funnet · M: ikke relevant — AutomatiskSaksbehandlingService.java:110-123; Alderspoeng.java:41-42; BehandleSakAutomatiskButton.tsx:28-32 |
| `@OPT-BEH-BEH-028` | Saksbehandleren velger grunnlaget | ikke funnet | P: mangler · A: mangler · M: ikke relevant — LeggTilGrunnlagService.java:44-48; PoengRadOppdateringService.java:115-116; A/GrunnlagCard/GrunnlagCard.tsx:107-136 |
| `@OPT-BEH-BEH-028` | Saksbehandleren får kjønnspoengene grunnlaget gir | ikke funnet | P: mangler · A: mangler · M: ikke relevant — som over |
| `@OPT-BEH-BEH-028` | Poengene for grunnlaget som er fjernet, vises ikke lenger | funnet | P: funnet · A: funnet · M: ikke relevant — FjernGrunnlagService.java:38-42; PoengRadOppdateringService.java:94-102; sak.graphqls:96-98; PoengberegningCard.tsx:20 |
| `@OPT-BEH-BEH-028` | Poengene regnes ut på nytt når saksbehandleren endrer grunnlaget | usikker | P: delvis · A: ikke relevant · M: ikke relevant — verdien beholdes, ikke ny utregning (PoengRadOppdateringService.java:66-72,104-105) |
| `@OPT-BEH-BEH-028` | Poengene regnes ikke ut på nytt av seg selv når datoen for aldersberegning endres | funnet | P: funnet · A: ikke relevant · M: ikke relevant — eneste kaller AutomatiskPoengberegningService.java:156-160; AldersberegningsdatoDefault.java:14-53 |
| `@OPT-BEH-BEH-028` | Søker uten elektronisk vitnemål får tilleggspoeng | ikke funnet | P: delvis · A: mangler · M: ikke relevant — manuelt: ingenting regnes; omvei via automatisk behandling (SetteGrunnlagService.java:116-118; AutomatiskPoengberegningService.java:149-160) |
| `@OPT-BEH-BEH-028` | Tilleggspoengene regnes ut selv om poengene fra vitnemålet står tomme | ikke funnet | P: mangler · A: mangler · M: ikke relevant — manuelt valg regner ikke |
| `@OPT-BEH-BEH-028` | Poengene er satt av saksbehandleren og står | funnet | P: funnet · A: funnet · M: ikke relevant — SettPoengService.java:104,125-153; AutomatiskPoengberegningService.java:82; PoengberegningCardRow.tsx:124-142,162-188 |
| `@OPT-BEH-BEH-028` | Saksbehandleren overstyrer et alderspoeng som er regnet ut automatisk | funnet | P: funnet · A: funnet · M: ikke relevant — SettPoengService.java:104; PoengberegningCardRow.tsx:138-140; AutomatiskPoengberegningService.java:82 |
| `@OPT-BEH-BEH-028` | Poengene som er regnet ut automatisk, er merket som det | ikke funnet | P: delvis · A: mangler · M: ikke relevant — PoengService.java:49; poeng.graphqls:94; vises ikke |
| `@OPT-BEH-BEH-028` | Poengene er ikke merket som automatiske etter at saksbehandleren har endret dem | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SettPoengService.java:136,151 |
| `@OPT-BEH-BEH-028` | Poengtypen har en algoritme som ikke kan regnes ut | ikke funnet | P: mangler · A: mangler · M: ikke relevant — manuelt: ingen merknad (registrerUkjentAlgoritme bare fra AutomatiskPoengberegningService.java:163-164) |
| `@OPT-BEH-BEH-028` | Automatikken fortsetter med de andre poengene når en algoritme ikke kan regnes ut | ikke funnet | P: delvis · A: mangler · M: ikke relevant — AutomatiskPoengberegningService.java:163-172; men ALD_ALG4/5 (V170:18-19) kaster i AlderspoengAlgoritme.java:23-29 og ruller tilbake hele behandlingen |
| `@OPT-BEH-BEH-020` | Fagkrav som er oppfylt på vitnemålet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:116-133,169-173; P/autosak/kontrollmotor/KontrollMotor.java:90-95 |
| `@OPT-BEH-BEH-020` | Fagkrav som ikke er oppfylt på vitnemålet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KontrollMotor.java:196-199; AutomatiskKravelementVurderingService.java:170 |
| `@OPT-BEH-BEH-020` | Karakteren fra vitnemålet registreres på fagkravet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KontrollMotor.java:76-77,196-199; AutomatiskKravelementVurderingService.java:162,171 |
| `@OPT-BEH-BEH-020` | Fagkrav uten karakter oppfylles uten karakter | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/autosak/kontrollmotor/FagSoek.java:414-416; AutomatiskKravelementVurderingService.java:162 |
| `@OPT-BEH-BEH-020` | Karakterkrav får karakteren fra vitnemålet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KontrollMotor.java:161,294-300 |
| `@OPT-BEH-BEH-020` | Beste karakter gjelder for programfag matematikk | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KontrollMotor.java:84-89; FagSoek.java:381-398 |
| `@OPT-BEH-BEH-020` | Kravelement som ikke er koblet til vitnemålet, vurderes ikke | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AutomatiskKravelementVurderingService.java:119-129 |
| `@OPT-BEH-BEH-020` | Kravelementer fra en annen sak i søknaden vurderes ikke i saken | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AutomatiskKravelementVurderingService.java:111,209-213; P/regelverk/kvalifisering/KvalifiseringDescent.java:152-173,197-201 |
| `@OPT-BEH-BEH-020` | Kravelement vurderes mot vitnemål fra R94 | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/autosak/kontrollmotor/Kravelementer.java:376-400,656-664; FagSoek.java:59-61,229 |
| `@OPT-BEH-BEH-020` | Ugyldig karakter må vurderes manuelt | ikke funnet | P: funnet · A: mangler · M: ikke relevant — AutomatiskKravelementVurderingService.java:161-167 setter merknad «vurder manuelt»; opptak-subgraph sak.graphqls:247-252; A/KravlisteStudierCard/KravlisteStudierCard.tsx:31-79 henter ikke merknadAutomatisk |
| `@OPT-BEH-BEH-020` | Ingen automatisk vurdering når <grunn> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/vgs/VgsDokumentVitnemaalService.java:43-54; AutomatiskKravelementVurderingService.java:92-95 |
| `@OPT-BEH-BEH-020` | Kravelementene vurderes mot vitnemålet saksbehandleren har valgt | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — VgsDokumentVitnemaalService.java:48-50 bare nøyaktig ett dokument |
| `@OPT-BEH-BEH-020` | Kompetansebevis ved siden av vitnemålet stopper ikke vurderingen | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — VgsDokumentVitnemaalService.java:48 size != 1; P/autosak/SetteGrunnlagService.java:111-114 |
| `@OPT-BEH-BEH-020` | Kvalifisert når alle kravelementene i en kravliste er oppfylt | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/regelverk/kvalifisering/KvalifiseringEvaluator.java:156-160 |
| `@OPT-BEH-BEH-020` | Kvalifisert når én av kravlistene er oppfylt | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KvalifiseringEvaluator.java:161-163 |
| `@OPT-BEH-BEH-020` | Karakteren må nå karakterkravet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KvalifiseringEvaluator.java:205-213 |
| `@OPT-BEH-BEH-020` | Søkeren kan være kvalifisert på ett grunnlag og ikke på et annet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:115-117,167-174; KvalifiseringEvaluator.java:148-167 |
| `@OPT-BEH-BEH-020` | Kravelementet vurderes i den automatiske behandlingen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/autosak/AutomatiskSaksbehandlingService.java:122-135; A/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:28-32 |
| `@OPT-BEH-BEH-020` | Feil i vurderingen stopper ikke resten av behandlingen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AutomatiskSaksbehandlingService.java:153-160 |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer vurderingen automatikken har satt | funnet | P: funnet · A: funnet · M: ikke relevant — P/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:191-216; AutomatiskKravelementVurderingService.java:112,177; KravlisteStudierCard.tsx:212-223 |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer karakteren som automatikken har satt | funnet | P: funnet · A: funnet · M: ikke relevant — KvalifiserKravelementV4Service.java:186-188,206-216; KravlisteStudierCard.tsx:208 |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren vurderer, låses | funnet | P: funnet · A: funnet · M: ikke relevant — KvalifiserKravelementV4Service.java:202-216 |
| `@OPT-BEH-BEH-020` | Saksbehandleren velger "la stå" på kravelementet | ikke funnet | P: funnet · A: mangler · M: ikke relevant — KvalifiserKravelementV4Service.java:157-163,231-240; KravlisteStudierCard.tsx:31-79 har ingen la stå |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren bare ser på, vurderes automatisk igjen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AutomatiskKravelementVurderingService.java:112,169-178 |
| `@OPT-BEH-BEH-020` | Låst kravelement vurderes ikke på nytt | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AutomatiskKravelementVurderingService.java:112,177 |
| `@OPT-BEH-BEH-020` | Andre kravelementer vurderes selv om saksbehandleren har vurdert ett | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AutomatiskKravelementVurderingService.java:100-114,141-149 |
| `@OPT-BEH-BEH-020` | Nullstilt kravelement kan vurderes automatisk igjen | usikker | P: funnet · A: delvis · M: ikke relevant — KvalifiserKravelementV4Service.java:202-216; EffektivVerdi.java:17-25 låsen oppheves bare når begge kolonnene er null; KravlisteStudierCard.tsx:193,221 nullstiller én kolonne |
| `@OPT-BEH-BEH-020` | Unntak per grunnlag endres ikke | funnet | P: funnet · A: ikke relevant · M: ikke relevant — AutomatiskKravelementVurderingService.java:169-178 |
| `@OPT-BEH-BEH-020` | Kravelementer for et grunnlag som fjernes, beholder vurderingen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/regelverk/kvalifisering/KvalifiseringKravelementV2OppdateringService.java:25-31,141,152 |
| `@OPT-BEH-BEH-020` | Kravelementer for et nytt grunnlag vurderes | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KvalifiseringKravelementV2OppdateringService.java:27-29; AutomatiskSaksbehandlingService.java:117; AutomatiskKravelementVurderingService.java:113 |
| `@OPT-BEH-BEH-020` | Se at kravelementet er vurdert automatisk | ikke funnet | P: funnet · A: mangler · M: ikke relevant — AutomatiskKravelementVurderingService.java:167,172-173; sak.graphqls:244-252; KravlisteStudierCard.tsx:52-77 henter ikke feltene |
| `@OPT-BEH-BEH-020` | Manuell endring fjerner markeringen som automatisk vurdert | ikke funnet | P: funnet · A: mangler · M: ikke relevant — KvalifiserKravelementV4Service.java:178-181; vises ikke i fs-admin |
| `@OPT-BEH-BEH-020` | Endringsloggen viser at automatikken vurderte kravelementet | ikke funnet | P: mangler · A: delvis · M: ikke relevant — opptak-migrations V480__stopp_endringslogg.sql:1-2,13-29 audit-triggere fjernet; A/AuditLogCard/AuditLogItem/AuditLogItem.tsx:35-36,70-73 |
| `@OPT-BEH-BEH-020` | Finne søkere som ikke er kvalifisert | funnet | P: funnet · A: funnet · M: ikke relevant — P/saksbehandling/SakFilterConditions.java:51,423; sak.graphqls:532-539; A/SakOverviewView/components/SakFilter/SakFilter.tsx:108-114 |
| `@OPT-BEH-BEH-031` | Poengsum for grunnlaget kvoten er koblet til | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/regelverk/poeng/PoengsumService.java:115-124,137-183,334-376 |
| `@OPT-BEH-BEH-031` | Grunnlag kvoten ikke er koblet til, gir ingen poengsum i kvoten | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/regelverk/poeng/PoengberegningService.java:132-142 |
| `@OPT-BEH-BEH-031` | Kvote søkeren ikke er plassert i, gir ingen poengsum | funnet | P: funnet · A: ikke relevant · M: ikke relevant — PoengsumService.java:61-68 |
| `@OPT-BEH-BEH-031` | Poengsummen følger poengformelen til kvotetypen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — PoengberegningService.java:328-351,144-150 |
| `@OPT-BEH-BEH-031` | Grunnlag søkeren ikke er kvalifisert på, gir ingen poengsum | funnet | P: funnet · A: ikke relevant · M: ikke relevant — PoengsumService.java:128,163-166,293-307 |
| `@OPT-BEH-BEH-031` | Poengsummen regnes ut på nytt når <endring> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/saksbehandling/PropageringService.java:170-174; LeggTilGrunnlagService.java:48; FjernGrunnlagService.java:42; regelverk/poeng/SettPoengService.java:46; saksbehandling/LagreVitnemalUtregningService.java:61; KvalifiserKravelementV4Service.java:63; KvalifiserKravelementUnntakService.java:63; regelverk/kvoteplassering/EndreKvoteplasseringService.java:51; saksbehandling/KvotesporsmalSvarService.java:257; autosak/AutomatiskSaksbehandlingService.java:117,134-135 |
| `@OPT-BEH-BEH-031` | Uendret poengsum gir ikke nytt innslag i endringsloggen | usikker | P: funnet · A: ikke relevant · M: ikke relevant — PoengsumService.java:191-231 skriver bare endrede rader (NB: V480__stopp_endringslogg.sql fjerner audit-triggere) Lead: stemmer bare fordi endringsloggen er stoppet (PM/V480__stopp_endringslogg.sql), vurdert som i OPT-BEH-BEH-012. |
| `@OPT-BEH-BEH-031` | Poengsummen i de andre kvotene regnes ut når én kvote feiler | funnet | P: funnet · A: ikke relevant · M: ikke relevant — PoengberegningService.java:144-172; PropageringService.java:170-179 |
| `@OPT-BEH-BEH-031` | Poengtypen viser hvorfor poengsummen ikke kan regnes ut | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ikke funnet på main (PoengberegningService.java:160-172 logger) — finnes i branch mahj/STEK-650 (fs-plattform): V492__sak_poengsum_merknad.sql:3-25, PoengsumService.java:267, saksbehandling/PoengsumMerknadService.java; (fs-admin): OppsummeringCard/components/PoengsumMerknader/PoengsumMerknader.tsx, soknadsbehandling.json:395 — vises per kvote i oppsummeringen, ikke på poengtypen Kontrollen: fs-plattform har det delvis på main (P/regelverk/poeng/PoengberegningService.java:175-177,228-251 skriver merknad_automatisk på poengraden når minimum > 0, STEK-512/513); fs-admin viser den ikke. |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når søkeren ikke er plassert i noen kvote | funnet | P: funnet · A: ikke relevant · M: ikke relevant — PoengsumService.java:70-73,378-384 |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når saken ikke har noe grunnlag | funnet | P: funnet · A: ikke relevant · M: ikke relevant — PoengsumService.java:86-95; PropageringService.java:103-105 |
| `@OPT-BEH-BEH-031` | Den høyeste poengsummen i kvoten vises | funnet | P: funnet · A: funnet · M: ikke relevant — P/saksbehandling/KvotesumV2Service.java:278; A/OppsummeringCard/OppsummeringsCardNy/OppsummeringsCardNy.tsx:52,173-174,287; components/PoengTable/PoengTable.tsx:45-48 |
| `@OPT-BEH-BEH-031` | Søknadsalternativ søkeren ikke er kvalifisert til, viser ingen poengsum | funnet | P: funnet · A: funnet · M: ikke relevant — KvotesumV2Service.java:52-61,227; PoengTable.tsx:48 |
| `@OPT-BEH-BEH-036` | Saken får en automatisk mangeltekst når <vurdert av> vurderer at et kravelement ikke er oppfylt | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:97-117; autosak/AutomatiskSaksbehandlingService.java:128,134-135; KvalifiserKravelementV4Service.java:63 → PropageringService.java:71-77,135-138 |
| `@OPT-BEH-BEH-036` | Saken får ikke mangeltekst når søkeren er kvalifisert på en annen kravliste | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KvalifiseringEvaluator.java:161-163; KvalifiseringOppdateringService.java:102-113 |
| `@OPT-BEH-BEH-036` | Saken får mangeltekster i alle kravlistene når søkeren ikke er kvalifisert på noen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/regelverk/kvalifisering/ManglendeKravBeregner.java:76-90; ManglendeKravTekstService.java:25-27 |
| `@OPT-BEH-BEH-036` | De automatiske mangeltekstene slettes når <vurdert av> vurderer at søkeren er kvalifisert | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KvalifiseringOppdateringService.java:104-113,213-216 |
| `@OPT-BEH-BEH-036` | Saksbehandleren ser de automatiske mangeltekstene sammen med de registrerte manglene | ikke funnet | P: delvis · A: mangler · M: ikke relevant — A/SakDrawer/components/ManglerCard/queries.ts:3-22 henter bare Sak.mangler; soknadsmangel.graphqls:20-35,59-64 |
| `@OPT-BEH-BEH-036` | Søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet | ikke funnet | P: mangler · A: ikke relevant · M: funnet — MK/fragment-soknad-mangler.ts:10-27, use-mangel-tekster.ts:12-29; V457:170 krever kan_publiseres, ingenting setter det ved ferdigbehandling |
| `@OPT-BEH-BEH-036` | Søkeren ser ikke de automatiske mangeltekstene mens saken er under behandling | ikke funnet | P: delvis · A: ikke relevant · M: ikke relevant — aldri publisert i dag; V457:14 skiller ikke på status Kontrollen: PM/V457__soknadsmangel_bare_publiserte.sql:12-14 skiller ikke på status; bare publisering styrer. |
| `@OPT-BEH-BEH-036` | Søkeren ser mangeltekstene per søknadsalternativ | ikke funnet | P: delvis · A: ikke relevant · M: funnet — V457:31-48,137-168; MK/fragment-soknad-mangler.ts:17-26,43-52 (bare når publisert) Kontrollen: visningen per alternativ finnes, men teksten publiseres ikke når saken er ferdig behandlet. |
| `@OPT-BEH-BEH-036` | Søkeren ser ikke mangelteksten når søknadsalternativet er fjernet | funnet | P: delvis · A: ikke relevant · M: funnet — V457:38-41; at saken beholder teksten er ikke vist (PropageringService.java:103) Kontrollen: P/saksbehandling/KvalifikasjonsgrunnlagOppdateringService.java:104-122,150-166 beholder raden, PM/V457:38-41 skjuler teksten. |
| `@OPT-BEH-BEH-036` | Saksbehandleren kan ikke endre en automatisk mangeltekst | funnet | P: funnet · A: delvis · M: ikke relevant — ingen mutation for manglende_krav_*; fs-admin viser dem ikke Kontrollen: bare KvalifiseringOppdateringService.java:214-217 skriver tekstene, og ingen mutation endrer dem. |
| `@OPT-BEH-BEH-036` | Opptaksforvalteren merker mangelkoden for generell studiekompetanse som fullføres i vår | ikke funnet | P: mangler · A: mangler · M: ikke relevant — mangel.graphqls:171-192 har ingen merking |
| `@OPT-BEH-BEH-036` | Bare én mangelkode i regelverkssamlingen kan være merket for generell studiekompetanse som fullføres i vår | ikke funnet | P: mangler · A: mangler · M: ikke relevant — P/regelverk/MangeltypeService.java:48,87-88 |
| `@OPT-BEH-BEH-036` | Mangelkoden kan ikke merkes når den <avvik> | ikke funnet | P: mangler · A: mangler · M: ikke relevant — som over |
| `@OPT-BEH-BEH-036` | Alle sakene i søknaden får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — flagget finnes (PM/V482__fullforer_videregaende.sql:9-15; StudiekurvService.java:267-295; OppdaterSoknadISoknadsbehandlingService.java:75-76,218-238), ingen mangel lages |
| `@OPT-BEH-BEH-036` | Saken får ikke mangel når ingen mangelkode er merket | ikke funnet | P: mangler · A: mangler · M: ikke relevant — intet varsel |
| `@OPT-BEH-BEH-036` | Opptaksforvalteren får varselet bare første gang | ikke funnet | P: mangler · A: mangler · M: ikke relevant — som over |
| `@OPT-BEH-BEH-036` | Den automatiske mangelen hindrer kvalifisering til søknadsalternativene i saken | ikke funnet | P: mangler · A: mangler · M: ikke relevant — sperrer_opptak brukes ikke i kvalifiseringen |
| `@OPT-BEH-BEH-036` | Søkeren ser den automatiske mangelen i Min kompetanse | ikke funnet | P: mangler · A: ikke relevant · M: delvis — ingen mangel å vise |
| `@OPT-BEH-BEH-036` | Søkeren får ikke egen melding om den automatiske mangelen | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen automatisk mangel |
| `@OPT-BEH-BEH-036` | Mangelen slettes når søkeren endrer søknaden | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — OppdaterSoknadISoknadsbehandlingService.java:218-238 |
| `@OPT-BEH-BEH-036` | Mangel som er sjekket ut slettes ikke når søkeren endrer søknaden | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — som over |
| `@OPT-BEH-BEH-036` | Saksbehandleren kan sjekke ut mangelen, men ikke slette den | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen automatisk mangel |
| `@OPT-BEH-BEH-036` | Mangelen sjekkes ut når saken er behandlet helautomatisk | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — AutomatiskSaksbehandlingService.java:83-142 |
| `@OPT-BEH-BEH-036` | Mangelen sjekkes ikke ut når saken ikke er behandlet helautomatisk | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen automatisk mangel |
| `@OPT-BEH-BEH-036` | Saksbehandleren sjekker ut mangelen når søkeren har dokumentert vitnemålet | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen automatisk mangel |
| `@OPT-BEH-BEH-029` | Ny sak er Ikke behandlet | funnet | P: funnet · A: funnet · M: ikke relevant — PM/V291__saksbehandling_skjema.sql:75; P/saksbehandling/BehandlertildelingService.java:458-465; fs-admin/src/domains/soknadsbehandling/features/SakOverviewView/components/SakStatusBadge/SakStatusBadge.tsx:23-25 |
| `@OPT-BEH-BEH-029` | Endre behandlingsstatus fra <fra> til <til> | funnet | P: funnet · A: funnet · M: ikke relevant — P/saksbehandling/EndreStatusService.java:22-40; sak.graphqls:34-40; fs-admin/.../PersonaliaCard/PersonaliaCard.tsx:131-135,217-221 |
| `@OPT-BEH-BEH-029` | Sette saken til Behandlet fra <fra> når saken har <innhold> | funnet | P: funnet · A: funnet · M: ikke relevant — EndreStatusService.java:31-34; fs-admin/.../StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:42-44 |
| `@OPT-BEH-BEH-029` | Saken kan ikke bli Behandlet uten mangel eller grunnlag | ikke funnet | P: mangler · A: mangler · M: ikke relevant — EndreStatusService.java:22-40 ingen sjekk; MerkSomBehandletButton.tsx:42 |
| `@OPT-BEH-BEH-029` | Saken blir Under behandling når saksbehandleren <handling> | ikke funnet | P: delvis · A: delvis · M: ikke relevant — Bare fra Ikke behandlet: SakMangelService.java:392-397, SettSaksdokumentErLestService.java:63-67; mangler for grunnlag (LeggTilGrunnlagService) og fra Behandlet (SettPoengService.java:194-198, KvalifiserKravelementV4Service.java:77-79, EndreKvoteplasseringService.java:122-126 krever UBEHANDLET) |
| `@OPT-BEH-BEH-029` | Behandlingsstatusen endres ikke når saksbehandleren <handling> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/saksbehandling/MerknadService.java:73-77; TilordningService.java:50-51 |
| `@OPT-BEH-BEH-029` | Ny dokumentasjon endrer ikke behandlingsstatusen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — ingen skriving av STATUSTYPE_KODE i SaksdokumentSyncService eller vgs/; SoknadshendelseJobb.java:197-203 |
| `@OPT-BEH-BEH-029` | Saksloggen viser endring av behandlingsstatus når <årsak> | ikke funnet | P: mangler · A: mangler · M: ikke relevant — PM/V480__stopp_endringslogg.sql:1-2,14-29; sak.graphqls:196; fs-admin AuditLogItem.tsx:15-31,80 |
| `@OPT-BEH-BEH-025` | Saken behandles helautomatisk når søkeren har ett vitnemål, og vitnemålet gir GSK | usikker | P: delvis · A: delvis · M: ikke relevant — P/autosak/AutomatiskSaksbehandlingService.java:100-135 kjører stegene; startes bare av saksbehandler (fs-admin BehandleSakAutomatiskButton.tsx:30-36), setter ikke ferdig behandlet; GSK fra gsk_ok (SetteGrunnlagService.java:128-130) |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk når ingen vitnemål gir GSK | usikker | P: funnet · A: ikke relevant · M: ikke relevant — P/autosak/SetteGrunnlagService.java:128-130; P/autosak/gsk/GskKonklusjonEvaluator.java:64-65 Kontrollen: ingen regel stopper behandlingen (P/autosak/AutomatiskSaksbehandlingService.java:117-136 fortsetter); stemmer bare fordi helautomatisk behandling ikke finnes. |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:111-114,368-375; AutomatiskSaksbehandlingService.java:86 |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk når søkeren har flere vitnemål, og bare ett gir GSK | funnet | P: funnet · A: ikke relevant · M: ikke relevant — SetteGrunnlagService.java:111-114,368-375 |
| `@OPT-BEH-BEH-025` | Saksbehandleren velger vitnemålet saken behandles automatisk på | ikke funnet | P: mangler · A: mangler · M: ikke relevant — P/autosak/records/BehandleSakInput.java:9; BehandleSakAutomatiskButton.tsx:32-35 |
| `@OPT-BEH-BEH-025` | Saken behandles automatisk på et sammensatt vitnemål | ikke funnet | P: mangler · A: mangler · M: ikke relevant — søkt «sammensatt» m.fl. |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — AutomatiskSaksbehandlingService.java:83-142 setter ikke status; bare P/saksbehandling/EndreStatusService.java:31-34 |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet selv om kravelementene ga mangeltekst | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen ferdigbehandling; automatiske mangeltekster ikke funnet (SakMangelService.java:111) |
| `@OPT-BEH-BEH-025` | Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet | ikke funnet | P: mangler · A: ikke relevant · M: mangler — ingen publisering i autosak |
| `@OPT-BEH-BEH-025` | Det som kan avgjøres, blir avgjort når <steg> ikke kan avgjøres | ikke funnet | P: delvis · A: ikke relevant · M: ikke relevant — AutomatiskSaksbehandlingService.java:153-160 svelger kravelementfeil, men :134-135 kjører videre; regelverk/poeng/AutomatiskPoengberegningService.java:48-60 ruller tilbake; saksbehandling/PropageringService.java:142-157,170-180 Kontrollen: poeng-raden stemmer (P/regelverk/poeng/PoengberegningService.java:160), kravelement- og kvote-raden ikke (kvotefeil ruller tilbake alt). Kontrollen foreslo usikker; lead: ikke funnet, siden en scenariomal krever alle radene. |
| `@OPT-BEH-BEH-025` | Saken blir stående under behandling når et steg ikke kan avgjøres | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — ingen statusskriving i autosak |
| `@OPT-BEH-BEH-025` | Opptaksforvalteren får varsel første gang en feil i regelverket stopper et steg | ikke funnet | P: mangler · A: mangler · M: ikke relevant — bare logg (AutomatiskSaksbehandlingService.java:159) |
| `@OPT-BEH-BEH-025` | Opptaksforvalteren får varselet om feilen bare første gang | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen varsler |
| `@OPT-BEH-BEH-025` | <feil i regelverket> stopper <steg> | ikke funnet | P: mangler · A: ikke relevant · M: ikke relevant — PoengformelIkkeFunnetException, PoengberegningException finnes, ikke koblet Kontrollen: feilene i poengformelen er koblet (P/regelverk/poeng/PoengberegningEvaluator.java:82,95,103, fanges i PoengberegningService.java:160); manglende dato og ukjent kvotealgoritme ruller tilbake alt; saken settes aldri under behandling. Kontrollen foreslo usikker; lead: ikke funnet. |
| `@OPT-BEH-BEH-025` | Saksbehandleren ferdigbehandler saken etter å ha gjort resten | funnet | P: funnet · A: funnet · M: ikke relevant — EndreStatusService.java:31-34; fs-admin StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:42-44 |
| `@OPT-BEH-BEH-025` | Saken blir ikke ferdig behandlet av seg selv når saksbehandleren har gjort resten | funnet | P: funnet · A: ikke relevant · M: ikke relevant — regelverk/poeng/SettPoengService.java:194-198 |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren beregner på nytt etter en feil i <rettet> | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen beregning på nytt for et utvalg søknadsalternativer; den automatiske behandlingen kjøres bare per sak (G/saksbehandling/automatisk-saksbehandling.graphqls:51-57, ASB:83-84). Søkt etter «reberegn», «beregn på nytt», «FS158», jobber og brancher. |
| `@OPT-BEH-BEH-026` | Søknadsalternativer feilen ikke gjaldt, beregnes ikke på nytt | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen beregning på nytt for et utvalg søknadsalternativer; den automatiske behandlingen kjøres bare per sak (G/saksbehandling/automatisk-saksbehandling.graphqls:51-57, ASB:83-84). Søkt etter «reberegn», «beregn på nytt», «FS158», jobber og brancher. |
| `@OPT-BEH-BEH-026` | Kravelementet saksbehandleren har vurdert, beregnes ikke på nytt | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen beregning på nytt for et utvalg søknadsalternativer; den automatiske behandlingen kjøres bare per sak (G/saksbehandling/automatisk-saksbehandling.graphqls:51-57, ASB:83-84). Søkt etter «reberegn», «beregn på nytt», «FS158», jobber og brancher. |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren ser hvor mange søknadsalternativer som ble hoppet over | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen beregning på nytt for et utvalg søknadsalternativer; den automatiske behandlingen kjøres bare per sak (G/saksbehandling/automatisk-saksbehandling.graphqls:51-57, ASB:83-84). Søkt etter «reberegn», «beregn på nytt», «FS158», jobber og brancher. |
| `@OPT-BEH-BEH-026` | Saken er fortsatt ferdig behandlet etter at poengene er beregnet på nytt | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen beregning på nytt for et utvalg søknadsalternativer; den automatiske behandlingen kjøres bare per sak (G/saksbehandling/automatisk-saksbehandling.graphqls:51-57, ASB:83-84). Søkt etter «reberegn», «beregn på nytt», «FS158», jobber og brancher. |
| `@OPT-BEH-BEH-026` | Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet | ikke funnet | P: mangler · A: mangler · M: mangler — ingen beregning på nytt for et utvalg søknadsalternativer; den automatiske behandlingen kjøres bare per sak (G/saksbehandling/automatisk-saksbehandling.graphqls:51-57, ASB:83-84). Søkt etter «reberegn», «beregn på nytt», «FS158», jobber og brancher. |
| `@OPT-BEH-BEH-026` | Saken blir ferdig behandlet når feilen er rettet | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen beregning på nytt for et utvalg søknadsalternativer; den automatiske behandlingen kjøres bare per sak (G/saksbehandling/automatisk-saksbehandling.graphqls:51-57, ASB:83-84). Søkt etter «reberegn», «beregn på nytt», «FS158», jobber og brancher. |
| `@OPT-BEH-BEH-026` | Saken blir stående under behandling når saksbehandleren har gjort noe i den | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen beregning på nytt for et utvalg søknadsalternativer; den automatiske behandlingen kjøres bare per sak (G/saksbehandling/automatisk-saksbehandling.graphqls:51-57, ASB:83-84). Søkt etter «reberegn», «beregn på nytt», «FS158», jobber og brancher. |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren ser når beregningen er ferdig | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen beregning på nytt for et utvalg søknadsalternativer; den automatiske behandlingen kjøres bare per sak (G/saksbehandling/automatisk-saksbehandling.graphqls:51-57, ASB:83-84). Søkt etter «reberegn», «beregn på nytt», «FS158», jobber og brancher. |
| `@OPT-BEH-BEH-026` | En plasstildeling som er kjørt, endres ikke | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen beregning på nytt for et utvalg søknadsalternativer; den automatiske behandlingen kjøres bare per sak (G/saksbehandling/automatisk-saksbehandling.graphqls:51-57, ASB:83-84). Søkt etter «reberegn», «beregn på nytt», «FS158», jobber og brancher. |
| `@OPT-BEH-BEH-026` | Neste plasstildeling bruker det som er beregnet på nytt | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen beregning på nytt for et utvalg søknadsalternativer; den automatiske behandlingen kjøres bare per sak (G/saksbehandling/automatisk-saksbehandling.graphqls:51-57, ASB:83-84). Søkt etter «reberegn», «beregn på nytt», «FS158», jobber og brancher. |
| `@OPT-BEH-BEH-012` | Plassering i kvote uten kvotespørsmål | funnet | P: funnet · A: funnet · M: ikke relevant — P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:140-188,296-320; saksbehandling/KvotesumV2Service.java:278; A/OppsummeringCard/OppsummeringsCardNy/OppsummeringsCardNy.tsx:52,287; PoengTable.tsx:48 |
| `@OPT-BEH-BEH-012` | Søkeren er ikke kvalifisert på grunnlaget | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KvoteplasseringGrunnlagService.java:296-303,314-316 |
| `@OPT-BEH-BEH-012` | Kvote uten kvotespørsmål vises ikke blant kvotespørsmålene | funnet | P: funnet · A: funnet · M: ikke relevant — A/KvoteplasseringCard/KvoteplasseringCard.tsx:21-53,90-126; P/saksbehandling/SoknadKvotesporsmalSvarOppdateringService.java:17-25 |
| `@OPT-BEH-BEH-012` | Grunnlag som ikke er koblet til kvotetypen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KvoteplasseringGrunnlagService.java:257-282,314-316; saksbehandling/SoknadKvoteOppretterService.java:53-57,246-273 |
| `@OPT-BEH-BEH-012` | Alder på datoen for aldersberegning | funnet | P: funnet · A: ikke relevant · M: ikke relevant — P/saksbehandling/AldersberegningsdatoUtleder.java:12,51-55; regelverk/kvoteplassering/Aldersgrense.java:55-56 |
| `@OPT-BEH-BEH-012` | Aldersgrense på grunnlaget | funnet | P: funnet · A: ikke relevant · M: ikke relevant — Aldersgrense.java:27-44; KvoteplasseringGrunnlagService.java:257-268,320-330 |
| `@OPT-BEH-BEH-012` | Kvotespørsmål stilles ikke når aldersgrensen ikke er møtt | funnet | P: funnet · A: funnet · M: ikke relevant — SoknadKvoteOppretterService.java:40,103,164-230; KvoteplasseringCard.tsx:90-126 |
| `@OPT-BEH-BEH-012` | Alle kvotespørsmål besvart ja | funnet | P: funnet · A: funnet · M: ikke relevant — P/saksbehandling/KvotesporsmalSvarService.java:402-413,364-376; KvoteplasseringCard.tsx:144-153 |
| `@OPT-BEH-BEH-012` | Ett kvotespørsmål besvart nei | funnet | P: funnet · A: funnet · M: ikke relevant — KvotesporsmalSvarService.java:408-409 |
| `@OPT-BEH-BEH-012` | Kvotespørsmålene vises i søknadsbehandlingen | funnet | P: funnet · A: funnet · M: ikke relevant — KvoteplasseringCard.tsx:111-118 |
| `@OPT-BEH-BEH-012` | Samme kvotespørsmål på flere kvotetyper vises én gang | funnet | P: funnet · A: funnet · M: ikke relevant — KvoteplasseringCard.tsx:60,90-126,153 |
| `@OPT-BEH-BEH-012` | Automatisk besvart kvotespørsmål vises låst | funnet | P: funnet · A: funnet · M: ikke relevant — P/autosak/KvotesporsmalAlgoritmeService.java:194-195,239; KvoteplasseringCard.tsx:118-119,149-151 |
| `@OPT-BEH-BEH-012` | Svar på automatisk kvotespørsmål avvises i API-et | funnet | P: funnet · A: ikke relevant · M: ikke relevant — KvotesporsmalSvarService.java:120-135 |
| `@OPT-BEH-BEH-012` | Automatisk kvoteplassering i endringsloggen | ikke funnet | P: mangler · A: delvis · M: ikke relevant — levert, men ikke funnet: V480__stopp_endringslogg.sql:1-2,13-29 (BAT-324, 29.10.2026); A/AuditLogCard/AuditLogItem/AuditLogItem.tsx:35-36,63-73 |
| `@OPT-BEH-BEH-012` | Endringsloggen viser opptaksalderen | ikke funnet | P: delvis · A: mangler · M: ikke relevant — levert, men ikke funnet: KvoteplasseringGrunnlagService.java:170-176,193-224 skriver merknad_automatisk; logg stoppet (V480); fs-admin viser ikke sak_kvote.merknad_automatisk |
| `@OPT-BEH-BEH-012` | Ny automatisk behandling uten endring gir ikke nytt innslag | usikker | P: funnet · A: ikke relevant · M: ikke relevant — KvoteplasseringGrunnlagService.java:171-176 Kontrollen: stemmer bare fordi endringsloggen er stoppet (PM/V480__stopp_endringslogg.sql); skal_kvoteplasseres oppdateres hver gang (:169-170). |
| `@FLY-OPT-AUT-001` | Vitnemålet fra KREG er klart for behandlingen når saken er opprettet | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Saken behandles automatisk når vitnemålet er importert | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen fra vitnemålet som er importert fra KREG | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Søknaden uten GSK-konklusjon får konklusjonen i kjøringen | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk på vitnemålet som gir GSK | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Søkeren hoppes over når ingen vitnemål gir GSK | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk når søkeren har to identiske vitnemål | ikke funnet | fasen har ikke krav (`@wont @openquestion`) — ikke søkt |
| `@FLY-OPT-AUT-001` | Saken får grunnlag | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Søknadsalternativet får poengsum | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoengene for grunnlaget | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Kravelementet er vurdert mot vitnemålet | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Kvotespørsmålet er besvart automatisk | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001`, som er `@planned` — overleveringen finnes likevel i koden: lages: P/saksbehandling/SoknadKvoteOppretterService.java:58-63,77-92,156 · brukes: P/autosak/KvotesporsmalAlgoritmeService.java:68-82,93-111,131-150,243-262 (sak_kvote → sak_kvotesporsmal_svar); PropageringService.java:142-157 |
| `@FLY-OPT-AUT-001` | Søkeren er kvalifisert når vitnemålet oppfyller kravelementene | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Den kvalifiserte søkeren plasseres i kvoten grunnlaget er koblet til | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001`, som er `@planned` — overleveringen finnes likevel i koden: lages: P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:204 (er_kvalifisert) · brukes: SoknadKvoteOppretterService.java:88,256-273,156; regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:96-104,131-140,154-182; PropageringService.java:105-107 |
| `@FLY-OPT-AUT-001` | Søkeren plasseres i kvoten når kvotespørsmålet er besvart ja automatisk | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001`, som er `@planned` — overleveringen finnes likevel i koden: lages: KvotesporsmalAlgoritmeService.java:243-262 · brukes: P/saksbehandling/KvotesporsmalSvarService.java:288-291,330-355,363-377 (kalt fra KvotesporsmalAlgoritmeService.java:165) |
| `@FLY-OPT-AUT-001` | Søkeren har poengsum i kvoten | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Saken får mangeltekst for kravelementet vitnemålet ikke oppfyller | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Saken med mangelen for GSK som fullføres i vår blir ferdig behandlet | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Søkeren ser mangelteksten fra kravelementene når saken er ferdig behandlet | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Saken blir ikke ferdig behandlet når poengene ikke kan avgjøres | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Poengene beregnes på nytt når rangeringsregelverket er rettet | ikke funnet | fasen er ikke levert: kravene fasen bygger på er `@planned` — ikke søkt |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

| Feature-ID | Sjekk | Rolle og handling | Kravet sier | Koden gjør | Resultat | Bevis |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | tilgang | systemet oppretter og endrer importerte vitnemål | opptakssystemet henter og lagrer | jobben skriver med en databasebruker som omgår RLS (`bypassrls`); policyen krever systembruker | stemmer | `PM/V300__rls_over_paa_auth_claims.sql:224-226`, `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:68-69` |
| `@OPT-BEH-BEH-030` | tilgang | saksbehandler leser importerte vitnemål | ikke beskrevet | SE_ eller MODIFISERE_SØKNADSBEHANDLING ser alle vitnemål | ikke beskrevet | `PM/V179__RLS_for_kompetanse_vgs.sql:112-116` |
| `@OPT-BEH-BEH-030` | organisasjon | saksbehandler leser vitnemål for søkere i andre organisasjoners saker | ikke beskrevet | ingen organisasjonsgrense på lesing | ikke beskrevet | `PM/V179__RLS_for_kompetanse_vgs.sql:4` |
| `@OPT-BEH-BEH-030` | tilgang | saksbehandler endrer importerte vitnemål | ikke beskrevet (saksbehandleren henter ikke på nytt) | INSERT/UPDATE/DELETE bare for systembruker | ikke beskrevet | `PM/V179__RLS_for_kompetanse_vgs.sql:118-127` |
| `@OPT-BEH-BEH-030` | konsistens | systemet lagrer vitnemål | lagres på søkeren, gjelder alle søknadene | lagres på `person_id`, unikt på `vgdoknr` | stemmer | `P/vgs/VgsLagringService.java:49-51,73-74` |
| `@OPT-BEH-BEH-032` | tilgang | saksbehandler starter den automatiske behandlingen | saksbehandleren ved organisasjonen kan starte | ingen egen sjekk i mutationen; RLS på lesing og skriving | stemmer | `ASB:89-97`, `PM/V493__tilbyder_ser_saksbehandlingen.sql:85-96` |
| `@OPT-BEH-BEH-032` | organisasjon | saksbehandler ved UiO starter for sak hos UiB | kan ikke | saken er ikke lesbar → `UkjentSakException`; en tilbyder kan lese og stoppes ved skriving | stemmer | `PM/V493__tilbyder_ser_saksbehandlingen.sql:38-45` |
| `@OPT-BEH-BEH-032` | tilgang | opptaksforvalter skrur automatikken av og på, og setter stopptidspunkt | opptaksforvalteren gjør det for opptaket | ingen innstilling finnes | ikke funnet | søkt etter «automati*» med «aktiv/på/av/stopp/frist» i migrasjoner, `*.graphqls` og fs-admin messages |
| `@OPT-BEH-BEH-032` | tilgang | hvem ser knappen | ikke beskrevet | knappen vises bak feature-flagget `automatisk-soknadsbehandling-trigger` | ikke beskrevet | `A/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:50-52` |
| `@OPT-BEH-BEH-032` | tilgang | tilbyder med bare lesetilgang ser «Start automatisk behandling» | kan ikke starte | knappen vises uten tilgangssjekk, og trykket feiler i databasen | avviker | `fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/layout.tsx:112` |
| `@OPT-BEH-BEH-015` | tilgang | saksbehandler oppretter og endrer GSK-konklusjon | rolle ikke beskrevet | krever MODIFISERE_SØKNADSBEHANDLING | ikke beskrevet | `GV:262-273` |
| `@OPT-BEH-BEH-015` | organisasjon | saksbehandler ved en organisasjon i opptaket endrer konklusjonen | en hvilken som helst organisasjon i opptaket | alle organisasjoner med sak på søknaden kan endre; andre avvises | stemmer | `GV:248-273` |
| `@OPT-BEH-BEH-015` | organisasjon | saksbehandler endrer en konklusjon en annen organisasjon har satt | ikke beskrevet | organisasjonskoden byttes til den som endrer | ikke beskrevet | `GV:549` |
| `@OPT-BEH-BEH-015` | tilgang | automatisk behandling oppretter konklusjon | ikke beskrevet | med organisasjonen til saken, styrt av RLS | ikke beskrevet | `ASB:89-97`, `AS:168` |
| `@OPT-BEH-BEH-015` | konsistens | systemet annullerer vitnemål | konklusjonen står, og saken får taggen «Vitnemål annullert» | konklusjonen trekkes tilbake og grunnlaget nullstilles (rettet i B2, uten tagg) | avviker | `TB:25-30,79-85` |
| `@OPT-BEH-BEH-015` | konsistens | automatisk behandling oppretter konklusjon | ikke beskrevet | konklusjonen skrives før grunnlaget og propageringen i samme transaksjon | stemmer | `ASB:100-117` |
| `@OPT-BEH-BEH-019` | tilgang | saksbehandler legger til og fjerner grunnlag | gjelder bare saken hos organisasjonen | MODIFISERE_SØKNADSBEHANDLING på sakens organisasjon | stemmer | `PM/V493__tilbyder_ser_saksbehandlingen.sql:89-96` |
| `@OPT-BEH-BEH-019` | organisasjon | saksbehandler leser grunnlagene på en sak | ikke beskrevet | lesing er ikke avgrenset til organisasjon | ikke beskrevet | `PM/V291__saksbehandling_skjema.sql:1600-1603`, `PM/V493__tilbyder_ser_saksbehandlingen.sql:7` |
| `@OPT-BEH-BEH-019` | tilgang | saksbehandler starter automatisk behandling som setter grunnlaget | ikke beskrevet | behandlingen kjører med brukerens rettigheter | ikke beskrevet | `ASB:86-112`, `PM/V493__tilbyder_ser_saksbehandlingen.sql:89-93` |
| `@OPT-BEH-BEH-019` | konsistens | saksbehandler fjerner et grunnlag | opptakskrav, kvoter og tilleggspoeng følger grunnlagene | poengrader deaktiveres og får gammel verdi tilbake ved reaktivering, uten ny utregning | avviker | `P/saksbehandling/FjernGrunnlagService.java:38-42`, `P/saksbehandling/PoengRadOppdateringService.java:94-113` |
| `@OPT-BEH-BEH-018` | tilgang | saksbehandler endrer, låser og låser opp et poeng | gjelder bare saken hos organisasjonen | MODIFISERE_SØKNADSBEHANDLING for sakens organisasjon | stemmer | `PM/V291__saksbehandling_skjema.sql:1749-1757` |
| `@OPT-BEH-BEH-018` | organisasjon | saksbehandler leser poengene på en sak | ikke beskrevet | lesing er ikke avgrenset til organisasjon | ikke beskrevet | `PM/V291__saksbehandling_skjema.sql:1744-1747` |
| `@OPT-BEH-BEH-018` | konsistens | automatisk poengberegning kjører på nytt når søkeren har fått et vitnemål til | poengene blir stående til saksbehandleren har valgt vitnemål (avklart 30.10.2026) | `beregnPoengAutomatisk` alene nullstiller poengene; i den orkestrerte kjøringen stopper hele saken i stedet | avviker | `P/regelverk/poeng/AutomatiskPoengberegningService.java:121-125`, `P/autosak/SetteGrunnlagService.java:111-114` |
| `@OPT-BEH-BEH-028` | tilgang | saksbehandler overstyrer og låser tilleggspoeng | ikke beskrevet | MODIFISERE_SØKNADSBEHANDLING for sakens organisasjon | ikke beskrevet | `PM/V291__saksbehandling_skjema.sql:1749-1757` |
| `@OPT-BEH-BEH-028` | organisasjon | saksbehandler leser poengene på en sak | ikke beskrevet | lesing er ikke avgrenset til organisasjon | ikke beskrevet | `PM/V291__saksbehandling_skjema.sql:1744-1747` |
| `@OPT-BEH-BEH-028` | konsistens | saksbehandler endrer eller fjerner grunnlaget | poengene regnes ut likt uansett hvem som velger grunnlaget | nye rader får `poeng = null`, reaktiverte får gammel verdi; ingen ny utregning | avviker | `P/saksbehandling/PoengRadOppdateringService.java:94-120` |
| `@OPT-BEH-BEH-020` | tilgang | saksbehandler endrer vurderingen av et kravelement | rolle ikke beskrevet | RLS krever MODIFISERE_SØKNADSBEHANDLING for å skrive | ikke beskrevet | `PM/V291__saksbehandling_skjema.sql:1624-1639` |
| `@OPT-BEH-BEH-020` | organisasjon | saksbehandler endrer vurderingen for en sak ved en annen organisasjon | ikke beskrevet | WITH CHECK `har_orgtilgang` på sakens organisasjon | ikke beskrevet | `PM/V493__tilbyder_ser_saksbehandlingen.sql:98-114` |
| `@OPT-BEH-BEH-020` | tilgang | den automatiske vurderingen skriver kravelementer | ikke beskrevet | kjøres med identiteten til den som starter den (følger av RLS, ikke av skjemaet) | usikker | `G/saksbehandling/automatisk-saksbehandling.graphqls:44-58` |
| `@OPT-BEH-BEH-020` | konsistens | grunnlaget fjernes fra saken | vurderingen beholdes | hovedraden deaktiveres og kommer tilbake med vurderingen | stemmer | `P/regelverk/kvalifisering/KvalifiseringKravelementV2OppdateringService.java:15-31,138-160` |
| `@OPT-BEH-BEH-031` | tilgang | saksbehandler ser poengsummen | rolle ikke beskrevet | SE_ eller MODIFISERE_SØKNADSBEHANDLING, ikke avgrenset til organisasjon | ikke beskrevet | `PM/V291__saksbehandling_skjema.sql:1791-1807` |
| `@OPT-BEH-BEH-031` | organisasjon | utregningen skriver poengsum for en sak ved en annen organisasjon | ikke beskrevet | WITH CHECK `har_orgtilgang` på `sak_poengsum` | ikke beskrevet | `PM/V493__tilbyder_ser_saksbehandlingen.sql:134-141` |
| `@OPT-BEH-BEH-031` | konsistens | kvoteplassering eller grunnlag fjernes | poengsummene fjernes | rader som ikke gjelder lenger, slettes | stemmer | `P/regelverk/poeng/PoengsumService.java:70-73,92-95,202-207` |
| `@OPT-BEH-BEH-036` | tilgang | søkeren leser mangeltekstene | søkeren ser tekstene i Min kompetanse | viewet viser søkerens egne saker | stemmer | `PM/V457__soknadsmangel_bare_publiserte.sql:10-17` |
| `@OPT-BEH-BEH-036` | organisasjon | saksbehandler ved Universitetet i Oslo leser mangler | saksbehandleren ved organisasjonen | `har_orgtilgang` på saken; bare publiserte tekster vises | stemmer | `PM/V457__soknadsmangel_bare_publiserte.sql:15-17,82-92,170` |
| `@OPT-BEH-BEH-036` | tilgang | saksbehandler publiserer de automatiske mangeltekstene | ingen publiserer tekstene | `publiserMangler` krever skrivetilgang og publiserer registrerte og automatiske mangler; ingen klient kaller den | avviker | `P/saksbehandling/SakMangelService.java:278-330` |
| `@OPT-BEH-BEH-036` | konsistens | kvalifiseringen endrer teksten | ikke beskrevet | ny tekst nullstiller `status_kan_publiseres` og `status_lest_av_soker` | ikke beskrevet | `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:199-216` |
| `@OPT-BEH-BEH-036` | konsistens | saksbehandler publiserer manglene | ikke beskrevet | `publiserMangler` setter saken under behandling (ikke en ferdig behandlet sak) | ikke beskrevet | `P/saksbehandling/SakMangelService.java:326` |
| `@OPT-BEH-BEH-029` | tilgang | saksbehandler endrer behandlingsstatusen | saksbehandleren ved organisasjonen | UPDATE krever MODIFISERE_SØKNADSBEHANDLING for sakens organisasjon | stemmer | `PM/V291__saksbehandling_skjema.sql:1550-1558` |
| `@OPT-BEH-BEH-029` | organisasjon | saksbehandler ved UiO endrer status på sak hos en annen organisasjon | ikke beskrevet | avvises: «Den spesifiserte saken finnes ikke» | ikke beskrevet | `P/saksbehandling/EndreStatusService.java:31-38` |
| `@OPT-BEH-BEH-029` | tilgang | bruker med bare SE_SØKNADSBEHANDLING leser et dokument | ikke beskrevet | USING slipper SE inn, WITH CHECK krever MODIFISERE; om statusendringen feiler, krever kjøring | usikker | `PM/V291__saksbehandling_skjema.sql:1551-1558`, `P/saksbehandling/SettSaksdokumentErLestService.java:63-67` |
| `@OPT-BEH-BEH-025` | tilgang | saksbehandler endrer status til Behandlet | saksbehandleren setter saken til ferdig behandlet | MODIFISERE_SØKNADSBEHANDLING; knappen er deaktivert, ikke skjult, uten rollen | stemmer | `PM/V291__saksbehandling_skjema.sql:1550-1558`, `A/StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:33,41-42` |
| `@OPT-BEH-BEH-025` | tilgang | opptaksforvalter ved forvaltende organisasjon får varsel om feil i regelverket | opptaksforvalteren får varsel | ingen varsler | ikke funnet | søkt etter «varsel.*regelverk», «regelverksfeil» i opptak og fs-admin messages |
| `@OPT-BEH-BEH-025` | konsistens | automatikken endrer kravelementer, kvalifisering og kvote | steg som bygger på et steg som ikke kan avgjøres, hoppes over | kvalifisering og kvote kjøres etter en svelget kravelementfeil | avviker | `ASB:128-135,153-160` |
| `@OPT-BEH-BEH-025` | konsistens | automatikken feiler i kvote-steget | det som kan avgjøres, blir avgjort | kvotefeil fanges ikke, så grunnlag og poeng lagres heller ikke | avviker | `P/saksbehandling/PropageringService.java:142-157` |
| `@OPT-BEH-BEH-026` | tilgang | opptaksforvalter ved HK-dir starter beregning på nytt | opptaksforvalteren beregner på nytt | funksjonen finnes ikke | ikke funnet | søkt etter «reberegn», «beregn på nytt», «FS158», jobber i opptak-subgraph |
| `@OPT-BEH-BEH-012` | tilgang | saksbehandler besvarer et kvotespørsmål | rolle ikke beskrevet | fs-admin krever `FS-ADMIN_MODIFISERE_SØKNADSBEHANDLING`; feltene er deaktivert, ikke skjult | ikke beskrevet | `A/KvoteplasseringCard/KvoteplasseringCard.tsx:78-84,149` |
| `@OPT-BEH-BEH-012` | organisasjon | saksbehandler besvarer et kvotespørsmål for en sak ved en annen organisasjon | ikke beskrevet | WITH CHECK `har_orgtilgang` på `sak_kvote` og `sak_kvotesporsmal_svar` | ikke beskrevet | `PM/V493__tilbyder_ser_saksbehandlingen.sql:116-132` |
| `@OPT-BEH-BEH-012` | konsistens | grunnlaget fjernes, eller søkeren slutter å være kvalifisert | ikke beskrevet | kvoter og svar deaktiveres og aktiveres igjen med svaret og plasseringen | stemmer | `P/saksbehandling/SoknadKvoteOppretterService.java:122-141`, `P/saksbehandling/SoknadKvotesporsmalSvarOppdateringService.java:16-28` |
| `@OPT-BEH-BEH-012` | tilgang | saksbehandler setter kvoteplasseringen direkte | ikke beskrevet | den utdaterte `endreKvoteplasseringV3` finnes fortsatt, og omgår kvotespørsmålene og algoritmelåsen | ikke beskrevet | `G/regelverk/kvoteplassering.graphqls:3-8` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | Er KREG ikke konfigurert, hoppes hentingen over uten feil | annet | `HV:56-58` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | Feiler hentingen, står tildelingen likevel (feilen logges) | annet | `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:410-411` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | En avbrutt runde hentes ikke i neste runde, selv om koden sier det: hendelsene er kvittert før hentingen | tilstandsovergang | `SoknadshendelseJobb.java:129-133,361` | uklart om ønsket |
| `@OPT-BEH-BEH-030` | KREG-noder uten `reformkode` ignoreres | annet | `P/vgs/KregVgsParser.java:71-74` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | Fag uten fagkode hoppes over i kodeverket, og fagnavnet faller tilbake til fagkoden | standardverdi | `P/vgs/VgsLagringService.java:110-122` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | Annullering av et vitnemål tilbakekaller automatiske GSK-vedtak (fjernes i B2) | tilstandsovergang | `HV:127-132` | uklart om ønsket |
| `@OPT-BEH-BEH-030` | Mangler påstanden om GSK i KREG, lagres den som «nei» | standardverdi | `P/vgs/KregVgsParser.java:104` | uklart om ønsket |
| `@OPT-BEH-BEH-030` | Bare KREG-status ANNULLERT gir annullert vitnemål | annet | `P/vgs/KregVgsParser.java:107` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | Feil fra KREG (status ≠ 200, GraphQL-feil) og tidsavbrudd etter 10 og 30 s behandles som at KREG ikke svarte | grense | `P/vgs/KregKlient.java:35,69,74-82` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | En søker som ikke kan slås opp, hoppes over | annet | `HV:67-68` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | En søker hentes én gang per runde, også med flere søknader | annet | `SoknadshendelseJobb.java:316-317` | testes i fase 2 |
| `@OPT-BEH-BEH-030` | Saksbehandleren ser bare vitnemål som ikke er annullert | annet | `G/saksbehandling/sak.graphqls:120-128` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-032` | Har søkeren mer enn ett ikke-annullert vitnemål, stopper hele behandlingen med «Søkeren har N vitnemål …» | validering | `P/autosak/SetteGrunnlagService.java:111-114` | uklart om ønsket |
| `@OPT-BEH-BEH-032` | Er søkerens ene dokument et kompetansebevis, velges ikke grunnlag automatisk | annet | `P/autosak/SetteGrunnlagService.java:120-127` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-032` | Påstår vitnemålet ikke GSK (`gsk_ok`), velges ikke grunnlag automatisk | annet | `P/autosak/SetteGrunnlagService.java:128-130` | testes i fase 2 |
| `@OPT-BEH-BEH-032` | Feil i kravelementvurderingen svelges og logges; andre feil ruller tilbake | annet | `ASB:153-160` | testes i fase 2 |
| `@OPT-BEH-BEH-032` | Knappen spør om bekreftelse i en dialog før start | annet | `A/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:63-84` | testes i fase 2 |
| `@OPT-BEH-BEH-032` | Automatikken fatter ikke GSK-vedtak når søkeren har et vedtak i opptaket fra før | annet | `AS:65-66,136-143` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-032` | Automatikken kjører uansett behandlingsstatus, også Behandlet, og endrer den ikke | tilstandsovergang | `ASB:83-142` | uklart om ønsket |
| `@OPT-BEH-BEH-032` | Svaret til saksbehandleren sier aldri hvorfor noe ikke ble gjort automatisk | annet | `ASB:137-141` | uklart om ønsket |
| `@OPT-BEH-BEH-015` | Autosak krever nøyaktig ett ikke-annullert dokument, og det må være et vitnemål | grense | `AS:77-83` | uklart om ønsket |
| `@OPT-BEH-BEH-015` | Semi-automatisk konklusjon: saksbehandleren velger vitnemålet, systemet vurderer og skriver konklusjonen (KLY/RFA tillatt) | annet | `P/autosak/gsk/SettGskKonklusjonService.java:24-50` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-015` | Manuell positiv konklusjon krever grunnlagstype, negativ krever mangeltype | obligatorisk felt | `GV:285-314`, `GC:217-222` | testes i fase 2 |
| `@OPT-BEH-BEH-015` | En låst konklusjon kan ikke endres, og feltene er sperret i FS Admin | tilstandsovergang | `GV:446-449`, `GC:283,293,370` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-015` | En ny konklusjon over en låst konklusjon er bare lov når den er KVALIFISERT | tilstandsovergang | `GV:412-415` | testes i fase 2 |
| `@OPT-BEH-BEH-015` | Endring til annullert krever KVALIFISERT, annullert vitnemål og samme vitnemålsnummer | validering | `GV:451-458,465-480` | testes i fase 2 |
| `@OPT-BEH-BEH-015` | En manuell konklusjon får alltid kilden NOM | standardverdi | `GC:230-231` | uklart om ønsket |
| `@OPT-BEH-BEH-015` | Grunnlagsdatoen er dagens dato når saksbehandleren ikke oppgir dato | standardverdi | `GC:228` | uklart om ønsket |
| `@OPT-BEH-BEH-015` | PBPBY4-suffikset strippes før oppslaget i listen over løp | annet | `EV:44-48` | testes i fase 2 |
| `@OPT-BEH-BEH-027` | Den automatiske GSK-vurderingen krever «GSK OK» fra KREG før seksfagskontrollen kjøres | annet | `EV:64-65` | uklart om ønsket |
| `@OPT-BEH-BEH-027` | KL23 behandles som Kunnskapsløftet; bare R94 gir R94-delkravene | annet | `P/autosak/kontrollmotor/FagSoek.java:60-61` | testes i fase 2 |
| `@OPT-BEH-BEH-027` | NOR1049 som privatist dekker bare hovedmål når vitnemålet ikke har NOR1050 | validering | `KE:837` | testes i fase 2 |
| `@OPT-BEH-BEH-027` | KL-matematikk godtar R94-kodene for R1/R2/S1/S2 (AA65xx) direkte, uten FAM13 | annet | `KE:465,473,481,489` | testes i fase 2 |
| `@OPT-BEH-BEH-019` | Aldersgrensen kan ha operatorene `<`, `=` og `>` | grense | `P/autosak/SetteGrunnlagService.java:338-345` | testes i fase 2 |
| `@OPT-BEH-BEH-019` | Et grunnlag med aldersgrense uten operator matcher ikke | validering | `P/autosak/SetteGrunnlagService.java:309-315` | uklart om ønsket |
| `@OPT-BEH-BEH-019` | Et grunnlag uten kompetansekrav i søknadens kompetanseregelverk deltar ikke i det automatiske valget | annet | `P/autosak/SetteGrunnlagService.java:142-160` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-019` | Mangler DATO_ALDERSBEREGNING, brukes 31.12 i publiseringsåret | standardverdi | `P/saksbehandling/AldersberegningsdatoUtleder.java:51-55` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-019` | Datoen kreves bare med aldersgrense eller ALD_-poengtype, men da for alle endringer av grunnlag | validering | `P/opptak/OpptakKreverAlderUtleder.java:51-64`, `P/saksbehandling/LeggTilGrunnlagService.java:40`, `P/saksbehandling/FjernGrunnlagService.java:34` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-019` | Manuelt valg avvises med «Minst ett av grunnlagene … gir ikke mening for den aktuelle saken» | validering | `P/saksbehandling/LeggTilGrunnlagService.java:80-86,143-170` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-019` | Å fjerne et grunnlag som ikke er valgt, gir feil | validering | `P/saksbehandling/FjernGrunnlagService.java:80-86` | testes i fase 2 |
| `@OPT-BEH-BEH-019` | Det automatiske grunnlaget krever `gsk_ok` på vitnemålet, ikke GSK-vedtaket | annet | `P/autosak/SetteGrunnlagService.java:128-130` | uklart om ønsket |
| `@OPT-BEH-BEH-019` | Grunnlagssteget viser «Ingen grunnlag i regelverkene til søknadsalternativene» | annet | `A/GrunnlagCard/GrunnlagCard.tsx:154-155` | testes i fase 2 |
| `@OPT-BEH-BEH-019` | Har saken et manuelt grunnlag, stopper ikke behandlingen ved flere vitnemål | annet | `P/autosak/SetteGrunnlagService.java:100-106` | uklart om ønsket |
| `@OPT-BEH-BEH-018` | Gir kontrollmotoren ikke et tall, lagres poenget som 0 | standardverdi | `P/regelverk/poeng/PoengService.java:176-178` | uklart om ønsket |
| `@OPT-BEH-BEH-018` | Et vitnemålspoeng som ikke kan beregnes, nullstilles; vitnemålsnummeret blir stående | tilstandsovergang | `P/regelverk/poeng/AutomatiskPoengberegningService.java:121-125`, `P/regelverk/poeng/PoengService.java:210-215` | uklart om ønsket |
| `@OPT-BEH-BEH-018` | Deaktiverte poengrader regnes ikke ut, og kan ikke endres manuelt | tilstandsovergang | `P/regelverk/poeng/SettPoengService.java:106-123` | testes i fase 2 |
| `@OPT-BEH-BEH-018` | En manuell verdi valideres mot poengtypen (minimum, maksimum, poengtrinn, desimaler) | validering | `P/regelverk/poeng/SettPoengService.java:71-76` | testes i fase 2 |
| `@OPT-BEH-BEH-018` | En manuell endring låser poenget når låsen ikke sendes med | standardverdi | `P/regelverk/poeng/SettPoengService.java:104` | testes i fase 2 |
| `@OPT-BEH-BEH-018` | Skolepoeng regnes bare via en poengformel opptaksforvalteren har satt opp; ingen slik formel i seed | annet | `P/regelverk/poeng/PoengformelParser.java:12-15` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-028` | Mangler fødselsdato eller kjønn, kastes en feil, og hele behandlingen rulles tilbake | validering | `P/regelverk/poeng/PoengService.java:251-253,264-266` | uklart om ønsket |
| `@OPT-BEH-BEH-028` | Bare kjønnskoden «KVINNE» gir kvinnepoeng | annet | `P/regelverk/poeng/PoengService.java:267` | uklart om ønsket |
| `@OPT-BEH-BEH-028` | ALD_ALG1 gir 1 poeng ved 20 år og 3 ved 22 år | grense | `P/regelverk/poeng/Alderspoeng.java:40-53` | testes i fase 2 |
| `@OPT-BEH-BEH-028` | Mangler både dato for aldersberegning og publiseringsdato, avvises valg av grunnlag og automatisk poengberegning | validering | `P/saksbehandling/AldersberegningsdatoUtleder.java:17-24` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-028` | En merknad om ukjent algoritme nuller ikke en gammel poengverdi | tilstandsovergang | `P/regelverk/poeng/PoengService.java:60-68` | uklart om ønsket |
| `@OPT-BEH-BEH-020` | Bare `vitnemalskrav_kode1` brukes; `kode2` ignoreres | annet | `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:37-40,105,119` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | En karakter utenfor 0–6, eller en bokstav, er ugyldig; blank eller «-» er ingen karakter | grense | `P/autosak/kontrollmotor/FagSoek.java:413-425` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Ved snitt teller standpunkt og eksamen hver for seg | annet | `P/autosak/kontrollmotor/FagSoek.java:352-379,400-408` | uklart om ønsket |
| `@OPT-BEH-BEH-020` | En manuell vurdering setter saken fra Ikke behandlet til Under behandling | tilstandsovergang | `P/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:76-80` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Vurderingen avvises når samme kolonne både får verdi og nullstilles | validering | `P/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:136-155` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Karakteren valideres i fs-admin før lagring | validering | `A/KravlisteStudierCard/KravlisteStudierCard.tsx:196-205` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Krever kompetansekravet GSK, kvalifiserer grunnlaget bare med et gjeldende GSK-vedtak KVALIFISERT | validering | `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:126-134` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-020` | Et fagkrav som ikke er oppfylt, får ingen karakter | annet | `P/autosak/kontrollmotor/KontrollMotor.java:196-199` | testes i fase 2 |
| `@OPT-BEH-BEH-020` | Ved ugyldig karakter settes kravet likevel til oppfylt | annet | `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:161-170` | uklart om ønsket |
| `@OPT-BEH-BEH-020` | Kravelementer for et grunnlag som er fjernet, vurderes ikke automatisk og kan ikke vurderes manuelt | tilstandsovergang | `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:113`, `KvalifiserKravelementV4Service.java:224-227` | testes i fase 2 |
| `@OPT-BEH-BEH-031` | En kvotetype uten poengformel får ingen poengsum, uten melding | annet | `P/regelverk/poeng/PoengberegningService.java:351` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-031` | En kvote uten grunnlag i `kvotetype_grunnlag` får ingen poengsum; bare en advarsel i loggen | annet | `P/regelverk/poeng/PoengsumService.java:119,313-332` | uklart om ønsket |
| `@OPT-BEH-BEH-031` | Bare poengtypene i rangeringsgrunnlaget teller i formelen | annet | `P/regelverk/poeng/PoengberegningService.java:119-130` | testes i fase 2 |
| `@OPT-BEH-BEH-031` | Summen som vises, filtreres på rangeringsregelverket og kvotene til utdanningstilbudet | annet | `P/saksbehandling/KvotesumV2Service.java:98-128,231-273` | testes i fase 2 |
| `@OPT-BEH-BEH-031` | Poeng og kvoter som ikke er aktive, er ikke med | annet | `P/regelverk/poeng/PoengsumService.java:67,79` | testes i fase 2 |
| `@OPT-BEH-BEH-031` | En poengtype uten verdi teller som 0 når minimum ≤ 0, og gir feil bare når minimum > 0 | grense | `P/regelverk/poeng/PoengberegningEvaluator.java:189-199` | uklart om ønsket |
| `@OPT-BEH-BEH-031` | Poengsummen lagres bare i regelverkssamlingen den ble regnet ut i | annet | `P/regelverk/poeng/PoengsumService.java:133-155` | testes i fase 2 |
| `@OPT-BEH-BEH-036` | De automatiske tekstene vises bare når de er publisert, og en ny tekst krever ny publisering | tilstandsovergang | `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:205-212`, `PM/V457__soknadsmangel_bare_publiserte.sql:170` | uklart om ønsket |
| `@OPT-BEH-BEH-036` | Publiseringen sender søkeren en melding når det er nye automatiske tekster | annet | `P/saksbehandling/SakMangelService.java:302-330` | uklart om ønsket |
| `@OPT-BEH-BEH-036` | Én samlet tekst per kompetanseregelverk, ikke én per kravelement | annet | `P/regelverk/kvalifisering/ManglendeKravTekstService.java:23-30` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-036` | Mangler en oversettelse, blir teksten null på det språket | annet | `P/regelverk/kvalifisering/ManglendeKravTekstService.java:28-30` | testes i fase 2 |
| `@OPT-BEH-BEH-036` | Mangler søkeren GSK når kompetansekravet krever det, står det i teksten | annet | `P/regelverk/kvalifisering/ManglendeKravBeregner.java:42-45` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-036` | Søkeren ser mangler bare på aktive saker under behandling eller ferdig behandlet | tilstandsovergang | `PM/V457__soknadsmangel_bare_publiserte.sql:12-14` | testes i fase 2 |
| `@OPT-BEH-BEH-036` | `sak_mangel.er_registrert_automatisk` finnes, men settes alltid til false | annet | `PM/V242`, `P/saksbehandling/SakMangelService.java:111` | uklart om ønsket |
| `@OPT-BEH-BEH-029` | En merknad setter Ikke behandlet til Under behandling | tilstandsovergang | `P/saksbehandling/MerknadService.java:73-77` | uklart om ønsket |
| `@OPT-BEH-BEH-029` | GSK-vedtak, vitnemålsutregning og unntak i kvalifiseringen setter Ikke behandlet til Under behandling | tilstandsovergang | `GV:177-179,213-215`, `P/saksbehandling/LagreVitnemalUtregningService.java:402-406`, `P/regelverk/kvalifisering/KvalifiserKravelementUnntakService.java:208-210` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-029` | «Merk som behandlet» er deaktivert når saken er Behandlet | annet | `A/StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:42` | testes i fase 2 |
| `@OPT-BEH-BEH-029` | Dokumentasjonsstatus vises ved siden av behandlingsstatusen | annet | `A/PersonaliaCard/PersonaliaCard.tsx:137-140,225-229` | uklart om ønsket |
| `@OPT-BEH-BEH-025` | Annullerte vitnemål telles ikke når antall vitnemål sjekkes | annet | `P/autosak/SetteGrunnlagService.java:368-375` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-025` | Grunnlaget velges etter prioritet: førstegangsvitnemål, ett vitnemål, bare aldersgrense | annet | `P/autosak/SetteGrunnlagService.java:78-81` | testes i fase 2 |
| `@OPT-BEH-BEH-025` | GSK-vedtaket fattes før grunnlaget, og IngenAutomatikk stopper ikke behandlingen | annet | `ASB:98-106` | uklart om ønsket |
| `@OPT-BEH-BEH-012` | Mangler fødselsdato eller operator, regnes aldersgrensen som ikke oppfylt | grense | `P/regelverk/kvoteplassering/Aldersgrense.java:27-36,46-53` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-012` | Et ubesvart kvotespørsmål gir ingen plassering (null) | tilstandsovergang | `P/saksbehandling/KvotesporsmalSvarService.java:402-413` | testes i fase 2 |
| `@OPT-BEH-BEH-012` | En ukjent algoritmekode gir merknad og nullstiller det automatiske svaret | annet | `P/autosak/KvotesporsmalAlgoritmeService.java:209-226,291-305` | testes i fase 2 |
| `@OPT-BEH-BEH-012` | Kvoten deaktiveres i stedet for å slettes, og får svaret tilbake når den aktiveres | tilstandsovergang | `P/saksbehandling/SoknadKvoteOppretterService.java:132-141` | uklart om ønsket |
| `@OPT-BEH-BEH-012` | En kvotetype uten koblede grunnlag gir «ikke plassert» med merknad | annet | `P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:154,200-202` | testes i fase 2 |
| `@FLY-OPT-AUT-001` | Et automatisk svar på et kvotespørsmål med `la_staa = true` overskrives ikke | annet | `P/autosak/KvotesporsmalAlgoritmeService.java:262` | testes i fase 2 |
| `@FLY-OPT-AUT-001` | Tilbud uten kompetanseregelverk får kvoten uten kvalifiseringssjekk | annet | `P/saksbehandling/SoknadKvoteOppretterService.java:87-91` | uklart om ønsket |
| `@FLY-OPT-AUT-001` | Uten grunnlag deaktiveres alle sakens kvoter | tilstandsovergang | `P/saksbehandling/SoknadKvoteOppretterService.java:65-68` | testes i fase 2 |
| `@FLY-OPT-AUT-001` | I koden kommer kvalifiseringen før kvotespørsmålene, motsatt av fasene i flyten | annet | `P/saksbehandling/PropageringService.java:108-109` | legg til scenario med `fs-krav` |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`. Siden kravene er verifisert uansett status, er `@draft @openquestion`-delene med i gating-settet og talt under `Scenarioer`.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | Importere resultater fra KREG | 1 av 5 | 5 av 17 | 0 |
| `@OPT-BEH-BEH-032` | Starte automatisk behandling | 1 av 8 | 2 av 14 | 0 |
| `@OPT-BEH-BEH-015` | Automatisk GSK-konklusjon | 0 av 10 | 3 av 47 | 0 |
| `@OPT-BEH-BEH-027` | Beregne GSK fra vitnemål | 1 av 10 | 1 av 28 | 0 |
| `@OPT-BEH-BEH-019` | Automatisk grunnlag | 0 av 7 | 1 av 32 | 0 |
| `@OPT-BEH-BEH-018` | Automatisk beregning av vitnemålspoeng | 0 av 5 | 1 av 16 | 0 |
| `@OPT-BEH-BEH-028` | Automatiske tilleggspoeng | 1 av 6 | 4 av 23 | 0 |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | 0 av 7 | 1 av 34 | 0 |
| `@OPT-BEH-BEH-025` | Ferdigbehandle en sak | 0 av 5 | 1 av 16 | 0 |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling (flyt) | 2 av 19 | 1 av 22 | 0 |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. MR-ene er ikke sjekket, fordi `glab` ikke finnes. Branchene er funnet på navn.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | `solov/gsk-pbpby4-klf` (STEK-249) | branch uten MR | `@OPT-BEH-BEH-015`, `@OPT-BEH-BEH-027` | 027: 3 scenarioer, 015: 5 scenarioer delvis | 10 bak main |
| `fs-plattform` | `solov/gsk-annullering-trekker-ikke-tilbake` (STEK-440) | branch uten MR | `@OPT-BEH-BEH-015` | 1 scenario helt, 1 delvis | 6 bak main |
| `fs-plattform` | `mahj/STEK-650` | branch uten MR | `@OPT-BEH-BEH-031` | 0/1 (merknaden vises per kvote, ikke på poengtypen) | 2 bak main; `V492__sak_poengsum_merknad.sql` kolliderer med `V492` på main |
| `fs-admin` | `mahj/STEK-650` | branch uten MR | `@OPT-BEH-BEH-031` | 0/1 | 18 bak main |
| `fs-admin` | `ross/take-473-opprett-kvote-ute-poengsum` (TAKE-473) | branch uten MR | – | 0 | gjelder kvotetype uten poengformel i regelverket, usikker kobling |

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | tilgang | saksbehandler endrer importerte vitnemål | – | ikke beskrevet | tilføyd: `PM/V179__RLS_for_kompetanse_vgs.sql:118-127` |
| `@OPT-BEH-BEH-032` | tilgang | tilbyder med bare lesetilgang ser «Start automatisk behandling» | – | avviker | tilføyd: `fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/layout.tsx:112` |
| `@OPT-BEH-BEH-032` | regel | melding om ukjent sak | regel uten scenario | dekket | dekkes av «Saksbehandleren starter bare behandlingen for saker hos organisasjonen» (`ASB:95-97`) |
| `@OPT-BEH-BEH-027` | scenario | Løp fra <reform> uten grunnlagskode gir grunnlagskoden <grunnlagskode> | ikke funnet | usikker | `P/autosak/gsk/SettGskKonklusjonService.java:133` → `EV:83-92` gir KLY/RFA i den semi-automatiske stien |
| `@OPT-BEH-BEH-019` | scenario | Saksbehandleren velger et grunnlag som automatikken har satt | ikke funnet | usikker | backend gjør det (`P/saksbehandling/LeggTilGrunnlagService.java:107-111`); i fs-admin gir to klikk samme sluttilstand |
| `@OPT-BEH-BEH-031` | scenario | Uendret poengsum gir ikke nytt innslag i endringsloggen | funnet | usikker | lead: stemmer bare fordi endringsloggen er stoppet (`PM/V480__stopp_endringslogg.sql`) |
| `@OPT-BEH-BEH-031` | scenario | Poengtypen viser hvorfor poengsummen ikke kan regnes ut | ikke funnet | ikke funnet | beviset rettet: fs-plattform har det delvis på main (`P/regelverk/poeng/PoengberegningService.java:175-177,228-251`) |
| `@OPT-BEH-BEH-036` | scenario | Søkeren ser ikke de automatiske mangeltekstene mens saken er under behandling | usikker | ikke funnet | `PM/V457__soknadsmangel_bare_publiserte.sql:12-14` skiller ikke på status |
| `@OPT-BEH-BEH-036` | scenario | Søkeren ser mangeltekstene per søknadsalternativ | usikker | ikke funnet | teksten publiseres ikke |
| `@OPT-BEH-BEH-036` | scenario | Søkeren ser ikke mangelteksten når søknadsalternativet er fjernet | usikker | funnet | `P/saksbehandling/KvalifikasjonsgrunnlagOppdateringService.java:104-122,150-166`, `PM/V457:38-41` |
| `@OPT-BEH-BEH-036` | scenario | Saksbehandleren kan ikke endre en automatisk mangeltekst | usikker | funnet | bare `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:214-217` skriver tekstene |
| `@OPT-BEH-BEH-036` | tilgang | publiserMangler setter saken under behandling | – | ikke beskrevet | tilføyd: `P/saksbehandling/SakMangelService.java:326` |
| `@OPT-BEH-BEH-025` | scenario | Saken behandles ikke helautomatisk når ingen vitnemål gir GSK | funnet | usikker | ingen regel stopper behandlingen (`ASB:117-136`) |
| `@OPT-BEH-BEH-025` | scenario | Det som kan avgjøres, blir avgjort når <steg> ikke kan avgjøres | ikke funnet | ikke funnet | kontrollen foreslo usikker (1 av 3 rader stemmer); lead: ikke funnet, siden en scenariomal krever alle radene |
| `@OPT-BEH-BEH-025` | scenario | <feil i regelverket> stopper <steg> | ikke funnet | ikke funnet | kontrollen foreslo usikker; beviset rettet (`P/regelverk/poeng/PoengberegningEvaluator.java:82,95,103`) |
| `@OPT-BEH-BEH-025` | tilgang | automatikken feiler i kvote-steget | – | avviker | tilføyd: `P/saksbehandling/PropageringService.java:142-157` |
| `@OPT-BEH-BEH-028` | regel | ALD_ALG4 og ALD_ALG5 feiler og ruller tilbake behandlingen | regel uten scenario | avkreftet | kodene er fjernet i `PM/V396__fjern_ald_alg4_alg5.sql` |
| `@OPT-BEH-BEH-012` | scenario | Ny automatisk behandling uten endring gir ikke nytt innslag | funnet | usikker | stemmer bare fordi endringsloggen er stoppet (`PM/V480__stopp_endringslogg.sql`) |
| `@OPT-BEH-BEH-012` | tilgang | saksbehandler setter kvoteplasseringen direkte | – | ikke beskrevet | tilføyd: `G/regelverk/kvoteplassering.graphqls:3-8` |
| `@OPT-BEH-BEH-015` | scenario | Søknaden får konklusjonen fra vitnemålet i den automatiske behandlingen | funnet | funnet | kontrollen var usikker (bare per sak, strengere vilkår); lead: funnet |
| `@FLY-OPT-AUT-001` | scenario | Kvotespørsmålet er besvart automatisk | funnet | ikke funnet | overleveringen er bekreftet i koden, men fasen er ikke levert fordi flyten bygger på `@FLY-OPT-SAK-001` (`@planned`) |
| `@FLY-OPT-AUT-001` | scenario | Den kvalifiserte søkeren plasseres i kvoten grunnlaget er koblet til | funnet | ikke funnet | som over |
| `@FLY-OPT-AUT-001` | scenario | Søkeren plasseres i kvoten når kvotespørsmålet er besvart ja automatisk | funnet | ikke funnet | som over |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

Kravene der noe er funnet, men ikke alt, kan bli `@in-progress` med de leverte delene `@implemented` (*Delvis levert* i `krav/README.md`). Det flytter kravene på tavla «Scopes». `@OPT-BEH-BEH-015` og `@OPT-BEH-BEH-027` er lest fra PR #900, og retagges ikke i denne kjøringen.

- `@OPT-BEH-BEH-030` — Importere resultater fra KREG (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/importere_resultater_fra_kreg.feature`, `@planned` → `@in-progress`, 11/17 funnet)
- `@OPT-BEH-BEH-032` — Starte automatisk behandling (`…/starte_automatisk_behandling.feature`, `@planned` → `@in-progress`, 2/14 funnet)
- `@OPT-BEH-BEH-019` — Automatisk grunnlag (`…/automatisk_grunnlag.feature`, `@planned` → `@in-progress`, 17/32 funnet)
- `@OPT-BEH-BEH-018` — Automatisk beregning av vitnemålspoeng (`…/automatisk_poengberegning.feature`, `@planned` → `@in-progress`, 9/16 funnet)
- `@OPT-BEH-BEH-028` — Automatiske tilleggspoeng (`…/automatiske_tilleggspoeng.feature`, `@planned` → `@in-progress`, 8/23 funnet)
- `@OPT-BEH-BEH-020` — Automatisk vurdering av spesielle opptakskrav (`…/automatisk_kvalifisering.feature`, `@planned` → `@in-progress`, 26/34 funnet)
- `@OPT-BEH-BEH-031` — Beregne poengsum per kvote (`…/beregne_poengsum_per_kvote.feature`, `@planned` → `@in-progress`, 11/13 funnet)
- `@OPT-BEH-BEH-036` — Automatiske mangler (`…/automatiske_mangler.feature`, `@planned` → `@in-progress`, 6/25 funnet)
- `@OPT-BEH-BEH-029` — Behandlingsstatus (`…/behandlingsstatus.feature`, `@planned` → `@in-progress`, 5/8 funnet)
- `@OPT-BEH-BEH-025` — Ferdigbehandle en sak (`…/ferdigbehandle_sak.feature`, `@planned` → `@in-progress`, 4/16 funnet)

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-015` — Automatisk GSK-konklusjon (`@in-progress` i PR #900, 11/47 funnet) — lest fra en branch som ikke er merget
- `@OPT-BEH-BEH-027` — Beregne GSK fra vitnemål (`@in-progress` i PR #900, 23/28 funnet) — lest fra en branch som ikke er merget
- `@OPT-BEH-BEH-026` — Beregne automatisk på nytt (`@planned`, 0/11 funnet) — funksjonen finnes ikke
- `@OPT-BEH-BEH-012` — Automatisk kvoteplassering (`@implemented`, 13/16 funnet) — levert; to scenarioer om endringsloggen er ikke funnet og ett er usikkert
- `@FLY-OPT-AUT-001` — Automatisk saksbehandling (`@planned`, 0/22 funnet) — ingen fase er levert

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-030` | Importere resultater fra KREG (delvis: `@in-progress`, 9 deler `@implemented`) | `importere_resultater_fra_kreg.feature` | `@planned` | 11/17 |
| `@OPT-BEH-BEH-032` | Starte automatisk behandling (delvis: `@in-progress`, 2 deler `@implemented`) | `starte_automatisk_behandling.feature` | `@planned` | 2/14 |
| `@OPT-BEH-BEH-019` | Automatisk grunnlag (delvis: `@in-progress`, 17 deler `@implemented`) | `automatisk_grunnlag.feature` | `@planned` | 17/32 |
| `@OPT-BEH-BEH-018` | Automatisk beregning av vitnemålspoeng (delvis: `@in-progress`, 2 deler `@implemented`) | `automatisk_poengberegning.feature` | `@planned` | 9/16 |
| `@OPT-BEH-BEH-028` | Automatiske tilleggspoeng (delvis: `@in-progress`, 8 deler `@implemented`) | `automatiske_tilleggspoeng.feature` | `@planned` | 8/23 |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav (delvis: `@in-progress`, 21 deler `@implemented`) | `automatisk_kvalifisering.feature` | `@planned` | 26/34 |
| `@OPT-BEH-BEH-031` | Beregne poengsum per kvote (delvis: `@in-progress`, 8 deler `@implemented`) | `beregne_poengsum_per_kvote.feature` | `@planned` | 11/13 |
| `@OPT-BEH-BEH-036` | Automatiske mangler (delvis: `@in-progress`, 6 deler `@implemented`) | `automatiske_mangler.feature` | `@planned` | 6/25 |
| `@OPT-BEH-BEH-029` | Behandlingsstatus (delvis: `@in-progress`, 5 deler `@implemented`) | `behandlingsstatus.feature` | `@planned` | 5/8 |
| `@OPT-BEH-BEH-025` | Ferdigbehandle en sak (delvis: `@in-progress`, 3 deler `@implemented`) | `ferdigbehandle_sak.feature` | `@planned` | 4/16 |

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Automatisk GSK-konklusjon | `@in-progress` (PR #900) | 11/47 | 36 ikke funnet. Lest fra en branch som ikke er merget, og retagges ikke |
| `@OPT-BEH-BEH-027` | Beregne GSK fra vitnemål | `@in-progress` (PR #900) | 23/28 | 3 ikke funnet, 2 usikker. Lest fra en branch som ikke er merget, og retagges ikke |
| `@OPT-BEH-BEH-026` | Beregne automatisk på nytt | `@planned` | 0/11 | 11 ikke funnet |
| `@OPT-BEH-BEH-012` | Automatisk kvoteplassering | `@implemented` | 13/16 | 2 ikke funnet, 1 usikker. Levert, og settes ikke tilbake |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling (flyt) | `@planned` | 0/22 | Ingen fase er levert |
| `@OPT-BEH-BEH-030`, `@OPT-BEH-BEH-032`, `@OPT-BEH-BEH-019`, `@OPT-BEH-BEH-018`, `@OPT-BEH-BEH-028`, `@OPT-BEH-BEH-020`, `@OPT-BEH-BEH-031`, `@OPT-BEH-BEH-036`, `@OPT-BEH-BEH-029`, `@OPT-BEH-BEH-025` | resten av kravet (se `## Levert`) | `@in-progress` | – | Delene som ikke er funnet, har ingen statustag. `@draft`-delene i 019, 036 og 025 står urørt |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Ingenting starter den automatiske behandlingen av seg selv:** den startes bare med knappen i FS Admin for én sak (`G/saksbehandling/automatisk-saksbehandling.graphqls:51-57`). Gjelder 032, 015, 019, 018, 025 og flyten.
- **Den automatiske behandlingen skriver aldri behandlingsstatus:** saken står som Ikke behandlet etter kjøringen (`ASB:83-142`). Gjelder 025, 029 og 032.
- **Flere VGS-dokumenter stopper hele behandlingen:** også vitnemål + kompetansebevis, og transaksjonen rulles tilbake (`P/autosak/SetteGrunnlagService.java:111-114`). Gjelder 019, 018, 020, 025 og 015.
- **fs-admin viser ikke det fs-plattform eksponerer:** `merknadAutomatisk` og `statusAutomatiskUtregnet` for grunnlag, poeng, kravelementer og GSK-konklusjon (`A/PoengberegningCard/PoengberegningCard.tsx:15-46`, `A/KravlisteStudierCard/KravlisteStudierCard.tsx:31-83`, `A/GrunnlagCard/GrunnlagCard.tsx:18-41`, `GC:64-95`).
- **Endringsloggen er stoppet:** `PM/V480__stopp_endringslogg.sql` (BAT-324, 29.10.2026). Scenarioer om endringsloggen i 012, 019, 020, 029 og 031 kan ikke bli funnet før kravet eller koden endres.
- **Knapper og felt er deaktivert, ikke skjult, uten tilgang:** «Merk som behandlet» og kvotespørsmålene, som avviker fra `design-patterns-for-krav.md` (`A/StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:41`, `A/KvoteplasseringCard/KvoteplasseringCard.tsx:149`).
- **Åpent spørsmål:** `@OPT-BEH-BEH-030` regel «Nye og annullerte vitnemål i KREG importeres for aktive søkere» — hvordan hendelsesloggen i KREG skal virke i neste versjon.
- **Åpent spørsmål:** `@OPT-BEH-BEH-030` «Resultatene hentes når en endring av søknaden gir en ny sak» — må vitnemålene hentes på nytt, eller er jobben i FLY-OPT-VIT-001 nok?
- **Åpent spørsmål:** `@OPT-BEH-BEH-030` «Søker uten fødselsnummer får ingen resultater importert» — skal søkere med D-nummer slås opp i KREG?
- **Åpent spørsmål:** `@OPT-BEH-BEH-032` regel «Et nytt vitnemål i en sak med vitnemål er ny dokumentasjon» — er «ny dokumentasjon» en behandlingsstatus eller en egen markering, og er den den samme som «nye resultater» (OPT-BEH-BEH-035) og taggen «Vitnemål annullert»?
- **Åpent spørsmål:** `@OPT-BEH-BEH-015` «Opptaksforvalteren får varsel om et løp som mangler i listen over løp» og «… om et løp uten grunnlagskode» — hvor i FS Admin, og ett varsel per løp eller per vitnemål?
- **Åpent spørsmål:** `@OPT-BEH-BEH-015` «Annulleringen oppdages uten at søkeren endrer søknaden» — hvordan FS-opptak abonnerer på endringer i KREG for aktive søkere.
- **Åpent spørsmål:** `@OPT-BEH-BEH-027` «Fag som er tatt ut av kontrollene, oppfyller ikke et delkrav» — hva fagstatusen er, og hvem som setter den.
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Grunnlag fra utdanningstilbudet når søknadsalternativet opprettes» — skal «Aut.kvalgrunnlag» fra FS-klienten videreføres?
- **Åpent spørsmål:** `@OPT-BEH-BEH-018` «Finne saker som er behandlet automatisk» — filter i saksoversikten, logg eller begge?
- **Åpent spørsmål:** `@OPT-BEH-BEH-028` regel «Poeng for høyere utdanning regnes ut fra søkerens studiepoeng» — kravet til importen av resultater fra høyere utdanning er ikke skrevet.
- **Åpent spørsmål:** `@OPT-BEH-BEH-020` «Finne søkere som ikke er kvalifisert» — filter, rapport eller begge?
- **Åpent spørsmål:** `@OPT-BEH-BEH-025` «Saken behandles automatisk på et sammensatt vitnemål» — ingen krav beskriver hva et sammensatt vitnemål er (FLY-OPT-SAM-001).
- **Åpent spørsmål:** `@FLY-OPT-AUT-001` fasene «To identiske vitnemål reknes som ett vitnemål» og «Søknaden dobbeltrangeres automatisk etter 23/5-regelen» — hvilket krav skal eie dem, og om fasen skal hete 23/6-regelen.
- **Tilgang avviker:** `@OPT-BEH-BEH-032` tilbyder med bare lesetilgang ser «Start automatisk behandling» — kravet sier at den ikke kan starte, `fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/layout.tsx:112`
- **Tilgang avviker:** `@OPT-BEH-BEH-015` annullering — kravet sier at konklusjonen står, koden trekker den tilbake, `TB:79-85`
- **Tilgang avviker:** `@OPT-BEH-BEH-019` fjerne grunnlag — poengene regnes ikke ut på nytt, `P/saksbehandling/PoengRadOppdateringService.java:94-113`
- **Tilgang avviker:** `@OPT-BEH-BEH-018` nytt vitnemål — kravet sier at poengene blir stående, `beregnPoengAutomatisk` nullstiller dem, `P/regelverk/poeng/AutomatiskPoengberegningService.java:121-125`
- **Tilgang avviker:** `@OPT-BEH-BEH-028` endre grunnlag — tilleggspoengene regnes ikke ut, `P/saksbehandling/PoengRadOppdateringService.java:94-120`
- **Tilgang avviker:** `@OPT-BEH-BEH-036` publisering — kravet sier at ingen publiserer, koden krever publisering, `P/saksbehandling/SakMangelService.java:278-330`
- **Tilgang avviker:** `@OPT-BEH-BEH-025` kvalifisering og kvote kjøres etter en svelget kravelementfeil, `ASB:128-135,153-160`
- **Tilgang avviker:** `@OPT-BEH-BEH-025` kvotefeil ruller tilbake hele saken, `P/saksbehandling/PropageringService.java:142-157`
- **Tilgang avviker:** `@OPT-BEH-BEH-032` opptaksforvalterens innstilling for automatikken — ikke funnet
- **Tilgang avviker:** `@OPT-BEH-BEH-025` varsel til opptaksforvalteren — ikke funnet
- **Tilgang avviker:** `@OPT-BEH-BEH-026` opptaksforvalteren starter beregning på nytt — ikke funnet
- **Delvis levert, men ikke i en spesifikasjon:** 030, 032, 019, 018, 028, 020, 031, 036, 029 og 025 er nå `@in-progress` uten å være hentet inn med `fs-specify`. Hent dem inn i scopene sine (`automatisk-import-og-start`, `automatisk-grunnlag-og-poeng`, `automatisk-kvalifisering-og-poengsum`, `automatisk-ferdigbehandling`).
- **Ikke sjekket:** åpne MR-er i fs-plattform og fs-admin (`glab` finnes ikke). Branchene er funnet på navn.
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-032` bygger på `@OPT-BEH-BEH-011` (`@planned`)
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-019` og `@OPT-BEH-BEH-028` bygger på `@OPT-OVO-FRI-001` (`@in-progress`)
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-020` bygger på `@OPT-BEH-BEH-004` (`@in-progress`)
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-036` og `@OPT-BEH-BEH-025` bygger på `@OPT-BEH-BEH-008` (`@planned`), og 036 på `@OPT-SØK-SØK-018` (`@draft`)
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-026` bygger på `@OPT-PLA-TIL-001` (`@draft`)
- **Bygger på krav som ikke er levert:** `@FLY-OPT-AUT-001` bygger på `@FLY-OPT-SAK-001` (`@planned`). Brukeren mener `@FLY-OPT-SAK-001` kanskje er utdatert. Uten den hadde 2 av 17 faser vært levert.
- **Levert, men ikke funnet i koden:** `@OPT-BEH-BEH-012` «Automatisk kvoteplassering i endringsloggen» og «Endringsloggen viser opptaksalderen» — endringsloggen er stoppet i `PM/V480__stopp_endringslogg.sql`, og opptaksalderen vises ikke i fs-admin. Avklar med `fs-krav` om kravet skal endres.
- **Levert, men usikkert i koden:** `@OPT-BEH-BEH-012` «Ny automatisk behandling uten endring gir ikke nytt innslag» — stemmer bare fordi endringsloggen er stoppet.
