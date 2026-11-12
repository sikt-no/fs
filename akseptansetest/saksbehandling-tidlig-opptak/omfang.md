# Omfang – Saksbehandling av tidlig opptak

- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147721786
- **Confluence**: –
- **Laget**: 2026-11-04 av fs-testplan

---

Omfanget for «Saksbehandling av tidlig opptak»: kravene og flytene som testes, og det som ikke er med. Kravene i «Omfang» er kriteriene for godkjent, og alle skillene i testflyten leser dem herfra. Testplanen: [Testplan – Saksbehandling av tidlig opptak](testplan.md).

## Omfang

Det som testes, er kravene som er `@implemented`, og de leverte delene i krav som er delvis levert. Feature-ID-ene her er kravene resten av testflyten bruker.

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Finne søknader om tidlig opptak](https://github.com/sikt-no/fs/blob/bacd06f4/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/finne_s%C3%B8knader_om_tidlig_opptak.feature) | `@OPT-BEH-BEH-009` | `@implemented` | 2 av 6 (se «Ikke med i denne testen»). Testet internt 2026-10-30 |
| [Vurdere søknad om tidlig opptak](https://github.com/sikt-no/fs/blob/bacd06f4/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vurdere_s%C3%B8knad_om_tidlig_opptak.feature) | `@OPT-BEH-BEH-013` | `@implemented` | 6 av 9 (se «Ikke med i denne testen»). Testet internt 2026-10-30. «Endre konklusjonen etter at tidligopptaket er gjennomført» venter på et opptak der tidligopptaket kan gjennomføres |
| [Gi tilbudsgaranti ved tidlig opptak](https://github.com/sikt-no/fs/blob/bacd06f4/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) | `@OPT-BEH-BEH-007` | `@in-progress` (delvis levert) | 20 av 29: Regel «Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket», og 19 scenarioer med `@implemented` i de to andre reglene |

Åpent spørsmål: `@OPT-BEH-BEH-007` «Reservert studieplass gir tilbudsgaranti uten kvalifisering»: Gir reservert studieplass (RSO eller RES) tilbudsgaranti også når søkeren ikke er kvalifisert, eller kvalifiseringen ikke er vurdert? Fagperson svarte ja 13.10.2026, men har sendt spørsmålet videre til en annen domeneekspert. Testes som det står.

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo, og som ikke er under endring. Et levert scenario med et åpent spørsmål testes som det står, og spørsmålet står under tabellen. Er kilden et scope, og kravet ble levert før, er det bare delene som er levert i scopet.

`@OPT-BEH-BEH-009` og `@OPT-BEH-BEH-013` er endret etter verifiseringen 2026-10-26 (commit `65d354a8`, 2026-11-02): behandlingsstatusen heter «Behandlet», ikke «Ferdig behandlet». Endringen er bare ordlyd, og verifiseringen er ikke kjørt på nytt.

De automatiske testene av de samme kravene: `npx playwright test --grep "@OPT-BEH-BEH-009|@OPT-BEH-BEH-013|@OPT-BEH-BEH-007"`.

### Åpne spørsmål

`@openquestion` stopper ikke testen: delen er klar til implementasjon, og testes som den står. Oversikten viser hvor mye som står åpent. Tallene regnes fra kravfilene og verify-rapporten.

| Krav | Feature-ID | Regler med åpent spørsmål | Scenarioer med åpent spørsmål | Scenarioer i testen |
|---|---|---|---|---|
| [Gi tilbudsgaranti ved tidlig opptak](https://github.com/sikt-no/fs/blob/bacd06f4/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) | `@OPT-BEH-BEH-007` | 0 av 3 | 1 av 29 | 20 |

`@OPT-BEH-BEH-009` og `@OPT-BEH-BEH-013` har ingen åpne spørsmål.

## Flyter

Flytene viser hva som skjer fra ett krav til det neste, på tvers av domener. Her testes overleveringene: at det ett krav lager, blir brukt av det neste. Kravene i fasene testes hver for seg i «Omfang».

Ingen av kravene er med i en flyt.

### Vurdering per krav (fase 3)

Den interne akseptansetesten tester flyter og avhengigheter. Per krav vurderes det hva som testes:

| Krav | Inngår i flyt | Vurdering |
|---|---|---|
| `@OPT-BEH-BEH-009` | Ingen | Ny flyt bør lages (`fs-krav`, modus E): «Tidlig opptak», fra søknaden (`@OPT-SØK-SØK-011`) via saksbehandlingen (009, 013) og gjennomføringen (007) til svaret (`@OPT-BEH-BEH-014`, `@OPT-SØK-SØK-012`) og tilbudet i hovedopptaket (`@OPT-PLA-TIL-002`). Til flyten finnes, testes kravet som oppgave uten flyt |
| `@OPT-BEH-BEH-013` | Ingen | Samme som over. Konklusjonen fra 013 er det gjennomføringen i 007 leser, og den overleveringen testes i oppgaven «Gjennomføre tidligopptaket» |
| `@OPT-BEH-BEH-007` | Ingen | Samme som over. Testes som oppgaven «Gjennomføre tidligopptaket» |

Scenarioene som tas med i fase 3, er de som inngår i flytene, ikke alle. Er en tidligere levert flyt avhengig av noe leveransen endrer, står den med som regresjon (finn dem med `grep -rn "@depends-on-<Feature-ID>" krav/_Flyter/`). Ingen flyter bygger på kravene.

### Avhengighetskart

Testleder vurderer om leveransen trenger et avhengighetskart. Teamet lister da det leveransen bygger på eller påvirker utenfor brukerens flyt, og det sjekkes underveis i flytene der det er mulig, ellers for seg.

| Avhengighet | Type | Hvordan sjekkes det |
|---|---|---|
| Konklusjonen for tidlig opptak i saksbehandlingen (`@OPT-BEH-BEH-013`) | Annen del av leveransen | I oppgaven «Gjennomføre tidligopptaket»: prøvekjøringen teller søkerne som deltar |
| Poengberegningen (`@OPT-BEH-BEH-031`, `@in-progress`) | Annen modul i FS | Gjennomføringen leser poengsummene. Mangler de, gis ingen tilbudsgaranti. Sjekkes i prøvekjøringen |
| Kvalifiseringen i saksbehandlingen | Annen modul i FS | Gjennomføringen leser kvalifiseringen per kompetanseregelverk. Sjekkes i prøvekjøringen |
| Poenggrensen og «tilbyr tidlig opptak» på utdanningstilbudet (`@OPT-OPT-UTD-004`, `@draft`) | Annen modul i FS | Settes i fanen «Tidlig opptak». Sjekkes i oppgaven |
| Kodeverket for tilbudsgarantityper i opptaket | Grunndata | Nøyaktig én aktiv type i kategorien for tidlig opptak som gir tilbud. Sjekkes i prøvekjøringen (stopper ellers) |
| Plasstildelingen i hovedopptaket (`@OPT-PLA-TIL-002`, `@draft`) | Annen modul i FS | Tilbudsgarantien skal gi tilbud. Testes ikke nå: plasstildelingen er ikke levert |
| Publisering av svaret (`@OPT-BEH-BEH-014`, `@in-progress`) | Annen del av initiativet | En gjennomføring publiserer svaret til søkerne. Testes ikke nå |
| Manuell tilbudsgaranti (`@OPT-BEH-BEH-010`, `@implemented`) | Annen modul i FS | Tidligopptakstilbud fra tilbyder (FOP) settes i saken. Sjekkes i oppgaven |

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke funnet alt ennå. De tas med i testen når de er `@implemented`. For et krav som er delvis levert, står delene som ikke er levert, her.

| Krav | Feature-ID | Status | Hva som venter |
|---|---|---|---|
| [Gi tilbudsgaranti ved tidlig opptak](https://github.com/sikt-no/fs/blob/bacd06f4/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) | `@OPT-BEH-BEH-007` | `@in-progress` | Ikke funnet: «Kvalifisering som ikke er vurdert gir ikke tilbudsgaranti» (forvalteren ser det ikke), «Se utfallet for hver søker», «Se utdanningstilbud med mangelfulle innstillinger», «Varsel når tilbudsgarantiene overskrider kvoten», «Kvotevarselet tar med tilbudsgarantier fra en tidligere gjennomføring», «Kvotevarsel ved 30 prosent når grensen ikke er angitt», «Angi grensen for kvotevarsel». Usikker: «Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum», «Prøvekjøre tidligopptaket». Gjennomføringen finnes i fs-plattform, men rapporten over utfallet mangler i fs-admin |

## Regler uten scenario

`fs-verify` rapporterer regler i koden som ikke har et scenario i kravet, for eksempel valideringer og tilgangssjekker. De er input til de agentiske testcasene (fase 2). Rapportene for 009 og 013 fra 2026-10-26 har ikke denne seksjonen.

| Krav | Regel i koden | Funnet i | Testes i fase 2 | Kravet bør få scenario |
|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Poenggrensen er 0–999,9, med én desimal | `fs-admin/src/domains/plasstildeling/features/TidligOpptak/components/TidligOpptakUtdanningstilbudList/TidligOpptakUtdanningstilbudList.tsx:25` | ja | nei |
| `@OPT-BEH-BEH-007` | Tidligopptaket kan ikke prøvekjøres eller kjøres med poenggrenser som ikke er lagret | `fs-admin/src/domains/plasstildeling/features/TidligOpptak/components/TidligOpptakResultModal/TidligOpptakResultModal.tsx:150` | ja | ja (`fs-krav`) |
| `@OPT-BEH-BEH-007` | Prøvekjøringen starter når dialogen «Kjøre tidligopptak?» åpnes, og gjennomføringen gjøres fra dialogen | `fs-admin/src/domains/plasstildeling/features/TidligOpptak/components/KjorTidligopptakButton/KjorTidligopptakButton.tsx:96` | ja | nei |
| `@OPT-BEH-BEH-007` | Dialogen kan ikke lukkes mens gjennomføringen pågår | `fs-admin/…/TidligOpptakResultModal.tsx:155` | nei: krever en ekte gjennomføring, som ikke gjøres i fase 2 | nei |
| `@OPT-BEH-BEH-007` | Hjelpeteksten sier at poenggrensen kan stå blank når medianen er OK, men uten poenggrense gis ingen garanti | `fs-admin/src/common/messages/nb/plasstildeling.json` (`TidligOpptak.informasjon1`); `fs-plattform/…/TidligopptakTilbudsgarantiService.java:725` | nei: uklart om ønsket | ja (`fs-krav`) |
| `@OPT-BEH-BEH-007` | Søkere med tidligopptakstilbud er med selv om de ikke har søkt tidlig opptak | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:501` | nei: krever søknader testene ikke kan lage | ja (`fs-krav`) |
| `@OPT-BEH-BEH-007` | Et tidligopptakstilbud (FOP) gir FOR også på et utdanningstilbud som ikke tilbyr tidlig opptak | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:627` | nei: uklart om ønsket | ja (`fs-krav`) |
| `@OPT-BEH-BEH-007` | Utdanningstilbud uten rangeringsregelverk, kompetanseregelverk eller kvote gir ingen garanti, og er avvik | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:386` | nei: avvikene vises ikke i fs-admin | ja (`fs-krav`) |
| `@OPT-BEH-BEH-007` | Mangler poengsummen, gis ingen garanti | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:754` | nei: vises ikke per søker | nei |
| `@OPT-BEH-BEH-007` | Kansellerte utdanningstilbud og trukne søknadsalternativer er ikke med | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:352` | nei: krever søknader testene ikke kan lage | nei |
| `@OPT-BEH-BEH-007` | Kvalifisert når minst ett grunnlag er kvalifisert; ellers ikke vurdert, med mindre alle er vurdert til nei | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:779` | nei: vises ikke per søker | nei |
| `@OPT-BEH-BEH-007` | Poengsummen tas bare fra aktive kvoter søkeren skal kvoteplasseres i, og fra kvotetyper tilbudet har | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:911` | nei: vises ikke per søker | nei |
| `@OPT-BEH-BEH-007` | Kvotevarselet måles mot tilbudsgarantikvoten; uten den gis aldri varsel | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:418` | nei: varselet vises ikke | ja (`fs-krav`) |
| `@OPT-BEH-BEH-007` | Kvotevarselet kommer først over grensen; nøyaktig 30 % gir ikke varsel | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:418` | nei: varselet vises ikke | nei |
| `@OPT-BEH-BEH-007` | Snackbaren «N utdanningstilbud er feilkonfigurert» teller avvik, og regner kvotevarsel som feilkonfigurering | `fs-admin/…/KjorTidligopptakButton.tsx:129` | nei: vises bare etter en ekte gjennomføring | ja (`fs-krav`) |
| `@OPT-BEH-BEH-007` | «T.O. søkere totalt» og «T.O. søkere 1. pri.» viser alltid «-» | `fs-admin/…/TidligOpptakUtdanningstilbudList.tsx:145` | ja | nei: uklart om ønsket |
| `@OPT-BEH-BEH-007` | Fristen for å fylle inn poenggrenser vises | `fs-admin/src/domains/plasstildeling/features/TidligOpptak/TidligOpptak.tsx:76` | ja | nei |
| `@OPT-BEH-BEH-007` | Poenggrensen kan bare endres på tilbud som tilbyr tidlig opptak («Ikke tidlig opptak her») | `fs-admin/src/domains/plasstildeling/features/TidligOpptak/hooks/useKanEndrePoenggrense.ts:61` | ja | nei |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Detaljtesting av filtrene i «Finne søknader om tidlig opptak» (`@OPT-BEH-BEH-009`): «Filteret for tidlig opptak er ikke i bruk som standard», «Har konklusjon» i «Filtrere på tidlig opptak», «Valgene for konklusjon kombineres med eller», «Søkt om tidlig opptak kombineres med valgene for konklusjon med og» og «Filteret for tidlig opptak kombineres med saksbehandlingsstatus» | Scopet ut av testen 2026-10-27. Alle scenarioene er funnet i koden i verifiseringen |
| «Konkludere før dokumentasjonsfristen har gått ut» i «Vurdere søknad om tidlig opptak» (`@OPT-BEH-BEH-013`) | Scopet ut av testen 2026-10-27. At konklusjonen ikke er knyttet til fristen, er funnet i koden |
| «Endre konklusjonen etter at tidligopptaket er gjennomført» (`@OPT-BEH-BEH-013`) | Krever en ekte gjennomføring. Opptak 34 får bare prøvekjøring, så scenarioet tas med i fase 3 når det er avtalt et opptak der tidligopptaket kan gjennomføres |
| De 9 scenarioene i `@OPT-BEH-BEH-007` som ikke er funnet eller er usikre | Venter på verifisering (se over) |
| En ekte gjennomføring av tidligopptaket i opptak 34 | Gjennomføringen publiserer svaret til søkerne. Bare prøvekjøring, til teamet har avtalt et opptak for det |
| Søke om tidlig opptak (`@OPT-SØK-SØK-011`) | Utenfor leveransen. Søkeren lager søknadene, og de står i testdataene |
| Publisere svar på tidlig opptak (`@OPT-BEH-BEH-014`) og søkerens svar (`@OPT-SØK-SØK-012`) | Utenfor leveransen (`@in-progress`) |
| Søknadsmangel når dokumentasjonen mangler (`@OPT-BEH-BEH-008`) | Utenfor leveransen |
| Tilbudet i hovedopptaket (`@OPT-PLA-TIL-002`) | Utenfor leveransen (`@draft`) |
