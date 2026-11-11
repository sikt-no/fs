# Verifisering: automatisk_saksbehandling.feature

- **Dato:** 2026-11-09 13:30
- **Krav:** `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature` (1 feature-fil, flyt)
- **Kode:** `fs-plattform` (main, 47304c92f8, oppdatert), `fs-admin` (main, 8ec4543d2, oppdatert)
- **Repoer:** P = fs-plattform, A = fs-admin · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** 3 MR-er sett gjennom (fs-plattform !6643, !6648 og fs-admin !3372), 1 med kode for flyten (!6648, fase 1)
- **Omfang:** flyter (valgt)
- **Avhengigheter:** 1 nivå, bare status (fremdriften)
- **Kontroll:** ikke kontrollert: flyten kan ikke bli levert i denne kjøringen (8 av 19 faser er levert)
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).

Stiene er forkortet:

- `P/…` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/…`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 9 funnet, 11 ikke funnet, 0 usikker, av 20
- Mangler: fs-plattform 11 scenarioer (fasene er ikke levert), fs-admin 0, min-kompetanse ikke sjekket
- Forslag: 0 kan leveres, 0 delvis levert, 0 kan slettes, 0 kan leveres når det er avklart, 1 blir stående
- Tilgang og datakonsistens: ikke relevant for en flyt
- Regler i koden uten scenario: 0
- Åpne spørsmål: 2 regler og 1 scenario i gating-settet, 0 utenfor gating (`@draft`)

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Blir stående**

- `@FLY-OPT-AUT-001` — Automatisk saksbehandling (`@planned`, 9/20 funnet): 8 av 19 faser er levert (4, 5, 7, 11, 12, 13, 14, 15), og overleveringene i alle de leverte fasene er funnet i koden. Ikke levert: 1 (D-nummer i 030, MR !6648), 2 (032), 3 (015 «Nytt vitnemål fra KREG etter at søknaden er opprettet»), 8 (018 skolepoeng og forklaring uten entydig vitnemål), 9 (028 høyere utdanning), 16 og 17 (036), 18 (025 publisering av mangler, 029), 19 (026). Mangler krav: 6 og 10 (`@wont`). Flyten bygger også på `@FLY-OPT-SAK-001` (`@planned`)

## Endringer

Det som er endret i kravfilene og i resultatet: i kjøringen (det sikre, når brukeren sa ja) og i gjennomgangen av rapporten.

Ingen endringer. Ingenting var sikkert nok til å settes i kjøringen.

## Fremdrift for flyter

Hvilke faser i flyten som er levert, ut fra statusen på delene av kravene fasen bygger på.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Søkerens resultater importeres fra KREG når saken er opprettet | OPT-BEH-BEH-030 `@in-progress`. «Resultatene hentes når saken er opprettet» (anker, ingen status på regelen) er **ikke levert**, fordi scenarioet «Resultatene hentes med D-nummer når søkeren ikke har fødselsnummer» (l. 57) ikke har `@implemented`. Koden ligger i P !6648. «Alle vitnemål og kompetansebevis … importeres» er `@implemented`, altså levert | nei |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen starter når søkerens resultater er importert | OPT-BEH-BEH-032 `@in-progress`. «Behandlingen kjører for hver ny sak saksbehandlertildelingen oppretter» og «Behandlingen kjører når importen har hentet vitnemålene til en søker uten vitnemål» har begge anker og ingen status. Ingen av dem er levert | nei |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen når vitnemålet importeres fra KREG | OPT-BEH-BEH-015 `@in-progress`: «Opptakssystemets påstand om GSK på vitnemålet» `@implemented` (levert), «Vitnemålet gir GSK når det har GSK OK fra KREG» `@implemented` (levert), «Konklusjon fra tidligere opptak» `@implemented` (levert), «Automatikken setter bare positive konklusjoner…» `@implemented` (levert). «Konklusjon på søknaden fra vitnemålet» er **ikke levert**: «Nytt vitnemål fra KREG etter at søknaden er opprettet» (l. 356) mangler `@implemented`. OPT-BEH-BEH-027 `@implemented`: hele kravet er levert, fordi det ikke har noe anker og ingen regeltittel fra 027 står i «…» | nei |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen setter GSK-konklusjonen der den mangler | 015: «GSK-konklusjonen settes også når den automatiske behandlingen kjører» `@implemented`, levert | ja |
| `@FLY-OPT-AUT-001` | Vitnemålet som gir GSK, avgjør om saken behandles helautomatisk | 015: «Vitnemålet gir GSK…» `@implemented`, levert. OPT-BEH-BEH-025 `@in-progress`: «Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk» `@implemented`, levert | ja |
| `@FLY-OPT-AUT-001` | To identiske vitnemål reknes som ett vitnemål (`@wont @openquestion`) | ingen `@depends-on-` | mangler krav |
| `@FLY-OPT-AUT-001` | Saken får grunnlag fra vitnemålet | OPT-BEH-BEH-019 `@in-progress`: alle tre reglene i «…» er `@implemented`, levert. `@draft`-scenarioet om grunnlag fra utdanningstilbudet er flyttet til en egen regel uten ankeret (review av PR #991) | ja |
| `@FLY-OPT-AUT-001` | Poengene beregnes fra grunnlaget og rangeringsregelverket | OPT-BEH-BEH-018 `@in-progress`: «Karakterpoeng, realfagspoeng og språkpoeng…» `@implemented` (levert). «Skolepoeng settes sammen…» har ingen status, så den er **ikke levert**. «Ingen automatisk beregning uten ett entydig vitnemål» er **ikke levert**: Scenariomal l. 88 mangler `@implemented`. OPT-REG-RAN-001 og OPT-REG-RAN-002 er `@implemented`, og hele kravet er levert | nei |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoeng når grunnlaget er satt | OPT-BEH-BEH-028 `@in-progress`: Alderspoeng, Kjønnspoeng og «Tilleggspoengene settes uansett…» er `@implemented` (levert). «Poeng for høyere utdanning regnes ut fra søkerens studiepoeng» har ingen status, så den er **ikke levert** | nei |
| `@FLY-OPT-AUT-001` | Søknaden dobbeltrangeres automatisk etter 23/5-regelen (`@wont @openquestion`) | ingen `@depends-on-`, ingen scenarioer | mangler krav |
| `@FLY-OPT-AUT-001` | Kravelementene vurderes mot vitnemålet når poengene er beregnet | OPT-BEH-BEH-020 `@in-progress`: alle tre reglene i «…» er `@implemented`, levert | ja |
| `@FLY-OPT-AUT-001` | Kvotespørsmålene med algoritme besvares automatisk | OPT-BEH-BEH-012 `@implemented`: «Kvotespørsmål med algoritme besvares automatisk…» er ikke `@planned`, så den er levert. OPT-REG-KVO-002 `@implemented`: ikke noe anker, så hele kravet er levert | ja |
| `@FLY-OPT-AUT-001` | Kvalifiseringen oppdateres når kravelementene er vurdert | 020: «Om søkeren er kvalifisert, avgjøres per grunnlag» `@implemented`, levert | ja |
| `@FLY-OPT-AUT-001` | Søkeren fordeles på kvoter når kvalifiseringen og kvotesvarene er satt | 012 `@implemented`: begge reglene i «…» er levert | ja |
| `@FLY-OPT-AUT-001` | Søkeren får poengsum per kvote når søkeren er fordelt på kvoter | OPT-BEH-BEH-031 `@implemented`: alle seks reglene er levert. OPT-REG-KVO-001 `@implemented`: «En kvotetype kan ha en default poengformel» er levert (`@planned` står bare på andre regler). OPT-REG-RAN-002 `@implemented` | ja |
| `@FLY-OPT-AUT-001` | Saken får mangeltekster når kravelementene er vurdert | OPT-BEH-BEH-036 `@in-progress`: «Saken får automatiske mangeltekster…» er **ikke levert**, fordi l. 70, 91 og 97 ikke har `@implemented` | nei |
| `@FLY-OPT-AUT-001` | Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet | 036: «Opptaksforvalteren merker én mangelkode…» `@implemented` (levert). «Mangelen … settes og sjekkes ut automatisk» er **ikke levert**: blant annet l. 226 og l. 278 «Mangelen sjekkes ut når saken er behandlet helautomatisk» mangler `@implemented` | nei |
| `@FLY-OPT-AUT-001` | Saken blir ferdig behandlet og er klar til å være med i plasstildelingen | 025: «Den automatiske behandlingen setter saken til ferdig behandlet…» er **ikke levert** (l. 95 «…publiserer manglene…» mangler `@implemented`). OPT-BEH-BEH-029 `@in-progress`: «Saken kan bare bli Behandlet…» er **ikke levert** (l. 73), og «Saksloggen viser endringene i behandlingsstatusen» har ingen status, så den er **ikke levert** | nei |
| `@FLY-OPT-AUT-001` | Søknadsalternativene beregnes på nytt når regelverket er rettet | OPT-BEH-BEH-026 `@in-progress`: de to første reglene er `@implemented` (levert). «Bare saker som er ferdig behandlet, beregnes på nytt» er **ikke levert** (l. 164 mangler `@implemented`) | nei |

`@FLY-OPT-AUT-001`: 8 av 19 faser levert.

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Vitnemålet fra KREG er klart for behandlingen når saken er opprettet | ikke funnet | fasen er ikke levert: OPT-BEH-BEH-030 «Resultatene hentes når saken er opprettet» har scenarioet med D-nummer uten `@implemented` (koden er i P !6648 `solov/kreg-import-dnummer`) |
| `@FLY-OPT-AUT-001` | Saken behandles automatisk når vitnemålet er importert | ikke funnet | fasen er ikke levert: begge reglene i OPT-BEH-BEH-032 som fasen bygger på, mangler `@implemented` |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen fra vitnemålet som er importert fra KREG | ikke funnet | fasen er ikke levert: OPT-BEH-BEH-015 «Konklusjon på søknaden fra vitnemålet» har «Nytt vitnemål fra KREG etter at søknaden er opprettet» uten `@implemented` |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk når søkeren har to identiske vitnemål | ikke funnet | fasen er ikke levert: den mangler krav (ingen `@depends-on-`, `@wont`) |
| `@FLY-OPT-AUT-001` | Søknadsalternativet får poengsum | ikke funnet | fasen er ikke levert: OPT-BEH-BEH-018 «Skolepoeng settes sammen…» og «Ingen automatisk beregning uten ett entydig vitnemål» er ikke `@implemented` |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoengene for grunnlaget | ikke funnet | fasen er ikke levert: OPT-BEH-BEH-028 «Poeng for høyere utdanning regnes ut fra søkerens studiepoeng» er ikke `@implemented` |
| `@FLY-OPT-AUT-001` | Saken får mangeltekst for kravelementet vitnemålet ikke oppfyller | ikke funnet | fasen er ikke levert: OPT-BEH-BEH-036 «Saken får automatiske mangeltekster…» har scenarioer uten `@implemented` (l. 70, 91, 97) |
| `@FLY-OPT-AUT-001` | Saken med mangelen for GSK som fullføres i vår blir ferdig behandlet | ikke funnet | fasen er ikke levert: OPT-BEH-BEH-036 «Mangelen … settes og sjekkes ut automatisk» er ikke levert (blant annet l. 226 og 278) |
| `@FLY-OPT-AUT-001` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | ikke funnet | fasen er ikke levert: OPT-BEH-BEH-025 «…setter saken til ferdig behandlet…» (l. 95) og OPT-BEH-BEH-029 «Saken kan bare bli Behandlet…» (l. 73) og «Saksloggen viser…» er ikke levert |
| `@FLY-OPT-AUT-001` | Søkeren ser mangelteksten fra kravelementene når saken er ferdig behandlet | ikke funnet | fasen er ikke levert: samme grunn som raden over. Bruddet er også skrevet som kjent brudd i flyten |
| `@FLY-OPT-AUT-001` | Poengene beregnes på nytt når rangeringsregelverket er rettet | ikke funnet | fasen er ikke levert: OPT-BEH-BEH-026 «Bare saker som er ferdig behandlet, beregnes på nytt» har l. 164 uten `@implemented` |
| `@FLY-OPT-AUT-001` | Søknaden uten GSK-konklusjon får konklusjonen i kjøringen | funnet | lages: `P/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/KregVgsParser.java:104` + `.../vgs/VgsLagringService.java:82,95` · brukes: `.../autosak/AutomatiskSaksbehandlingService.java:118,197` → `.../autosak/gsk/GskVedtakAutoService.java:59-61,74-79,158,213-225` — KREG sin `paastandOmGsk` lagres i `kompetanse.vgs_dokument.gsk_ok`. Steg 0a i autosak sjekker at søknaden ikke har noe `gsk_vedtak`, leser `gsk_ok` på søkerens ikke-annullerte vitnemål og gir det til `GskKonklusjonEvaluator.evaluer` (`.../autosak/gsk/GskKonklusjonEvaluator.java:61-76`). Er påstanden sann, lagres `gsk_vedtak` med `KVALIFISERT` og kilde `AUT` |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk på vitnemålet som gir GSK | funnet | lages: `P/.../vgs/VgsLagringService.java:82,95` (`vgs_dokument.gsk_ok`, `vgdoktypekode`) · brukes: `P/.../autosak/SetteGrunnlagService.java:111-131` og `P/.../autosak/FerdigbehandlingService.java:92-98` — automatikken går bare videre når det finnes nøyaktig ett gjeldende VGS-dokument, og det er `VM` med `gsk_ok = true`. Har søkeren flere, stopper `FlereVitnemaalException` resten av steget (l. 112-115). Ferdigbehandlingen sjekker det samme vilkåret |
| `@FLY-OPT-AUT-001` | Saken får grunnlag | funnet | lages: `P/.../vgs/VgsLagringService.java:82,95` (det ene vitnemålet med `gsk_ok`, `foerstegangsvm`) · brukes: `P/.../autosak/SetteGrunnlagService.java:120-133,191-206`, kalt fra `.../autosak/AutomatiskSaksbehandlingService.java:153` — for det ene vitnemålet velges et grunnlag ut fra `foerstegangsvm` og alder, og det skrives til `saksbehandling.sak_kvalifikasjonsgrunnlag` med `status_automatisk_utregnet = true` |
| `@FLY-OPT-AUT-001` | Kravelementet er vurdert mot vitnemålet | funnet | lages: `P/.../autosak/SetteGrunnlagService.java:191-206` (`sak_kvalifikasjonsgrunnlag`) · brukes: `P/.../regelverk/kvalifisering/KvalifiseringDescent.java:154-156` → `.../KvalifiseringKravelementV2OppdateringService.java:84` (rader i `sak_kvalifisering_kravelement` for kravelementene til grunnlaget) → `.../AutomatiskKravelementVurderingService.java:99-112,146,170-175` (radene vurderes mot vitnemålet med kontrollmotoren og får `kravet_er_oppfylt`) — kalt fra `AutomatiskSaksbehandlingService.java:158,169`, etter poengsteget på l. 163 |
| `@FLY-OPT-AUT-001` | Kvotespørsmålet er besvart automatisk | funnet | lages: `P/.../autosak/SetteGrunnlagService.java:191-206` (grunnlaget) → `P/.../saksbehandling/SoknadKvoteOppretterService.java:59-63,198-205` (`sak_kvote` for kvotetypen med kvotespørsmål som grunnlaget er koblet til) · brukes: `P/.../autosak/KvotesporsmalAlgoritmeService.java:68-76,131-144,228-242` — leser aktive `sak_kvote`, finner kvotespørsmål med `kvotesporsmal_algoritmekode` og skriver svaret til `sak_kvotesporsmal_svar` med automatisk merknad. Kalt fra `PropageringService.java:174`. Merk: `sak_kvote` for kvoter med spørsmål lages bare når søkeren er kvalifisert på grunnlaget (`SoknadKvoteOppretterService.java:202,261-278`). Det står ikke i `Gitt` |
| `@FLY-OPT-AUT-001` | Søkeren er kvalifisert når vitnemålet oppfyller kravelementene | funnet | lages: `P/.../regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:170-175` (`sak_kvalifisering_kravelement.kravet_er_oppfylt`) · brukes: `P/.../regelverk/kvalifisering/KvalifiseringOppdateringService.java:152-157,93-96,203-204` — leser de aktive kravelementradene, kjører `KvalifiseringEvaluator.kvalifiser` per kompetanseregelverk og setter `sak_kvalifikasjonsgrunnlag.er_kvalifisert`. Kalt fra `AutomatiskSaksbehandlingService.java:175` → `PropageringService.java:75` |
| `@FLY-OPT-AUT-001` | Den kvalifiserte søkeren plasseres i kvoten grunnlaget er koblet til | funnet | lages: `P/.../regelverk/kvalifisering/KvalifiseringOppdateringService.java:203-204` (`er_kvalifisert`) · brukes: `P/.../regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:301-307,319-337,169-170` — leser kvalifiserte grunnlag, matcher dem mot `kvotetype_grunnlag` og setter `sak_kvote.skal_kvoteplasseres` for kvoter uten spørsmål. Kalt fra `PropageringService.java:76,173`, etter kvalifiseringen |
| `@FLY-OPT-AUT-001` | Søkeren plasseres i kvoten når kvotespørsmålet er besvart ja automatisk | funnet | lages: `P/.../autosak/KvotesporsmalAlgoritmeService.java:228-242` (`sak_kvotesporsmal_svar.svar`) · brukes: `.../autosak/KvotesporsmalAlgoritmeService.java:165` → `P/.../saksbehandling/KvotesporsmalSvarService.java:329-345,365-367,377,402-413` — leser svarene. Er alle ja og grunnlagsvurderingen oppfylt, settes `sak_kvote.skal_kvoteplasseres` |
| `@FLY-OPT-AUT-001` | Søkeren har poengsum i kvoten | funnet | lages: `P/.../regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:169-170` (`sak_kvote.skal_kvoteplasseres`) og `P/.../regelverk/poeng/PoengService.java:48-51` (`sak_poeng.poeng`, via `AutomatiskPoengberegningService.java:107`) · brukes: `P/.../regelverk/poeng/PoengsumService.java:68-74,82-86,133-134,186` + `PoengberegningService.java:364-369` — leser de plasserbare kvotene og poengene, regner ut med kvotetypens `poengformel_kode_default` og skriver `sak_poengsum` per kvote og grunnlag. Kalt fra `PropageringService.java:77,190` |

## Åpne spørsmål

Hvor mange regler og scenarioer i hvert krav som har `@openquestion`. Spørsmålene stopper ikke leveransen, men står i testplanen til de er besvart.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling | 2 av 19 | 1 av 20 | 0 |

## Åpne MR-er og brancher

MR-er og brancher som ser ut til å levere kravene. Koden i disse er ikke merget, og regnes ikke som levert.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | [!6648 STEK-330: KREG-importen henter vitnemål med D-nummer når søkeren ikke har fødselsnummer](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6648) (`solov/kreg-import-dnummer`) | åpen | `@OPT-BEH-BEH-030` (fase 1) | ikke sjekket (fasen er ikke levert) | |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Kravet er bak koden | `@FLY-OPT-AUT-001` | rekkefølgen i fase 12 og 13 | I koden går overleveringen fra kravelementene til kvotespørsmålene gjennom kvalifiseringen: `sak_kvote` for kvoter med spørsmål lages først når `er_kvalifisert` er satt (`P/…/saksbehandling/SoknadKvoteOppretterService.java:202,261-278`, `PropageringService.java:153-174`). I flyten kommer kvalifiseringen (fase 13) etter kvotespørsmålene (fase 12) |
| Åpent spørsmål | `@FLY-OPT-AUT-001` | «Saken behandles helautomatisk når søkeren har to identiske vitnemål» | Ingen krav beskriver når to vitnemål er identiske, eller hvilket av dem saken behandles helautomatisk på. Hvilket krav skal eie regelen: `@OPT-BEH-BEH-025` eller et nytt krav? |
| Bygger på krav som ikke er levert | `@FLY-OPT-AUT-001` | – | bygger på `@FLY-OPT-SAK-001` (`@planned`) |
| Ikke sjekket | – | kontroll av flyten | Flyten er ikke kontrollert uavhengig: den kan ikke bli levert i denne kjøringen |
| Ikke sjekket | – | min-kompetanse | «Søkeren ser mangelteksten …» gjelder søkerens visning |
| Merknad | `@FLY-OPT-AUT-001` | `@wont` | Fase 6 har `@wont @openquestion` og står i gating-settet, fordi `@wont` er en prioritet og ikke tas ut |
