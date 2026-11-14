# Verifisering: OPT-BEH-BEH-007 Gi tilbudsgaranti ved tidlig opptak

- **Dato:** 2026-11-02 15:13
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, b7fb33039d, oppdatert), `fs-admin` (main, eb3e615b8, oppdatert)
- **Åpne MR-er:** 1 MR i fs-admin, 0 i fs-plattform (1 med kode for kravet)
- **Omfang:** alle krav uansett status (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Et scenario der opptaksforvalteren gjennomfører, prøvekjører eller ser noe, er `funnet` bare når både fs-plattform og fs-admin har det på main. fs-admin på main har ingen måte for opptaksforvalteren å gjennomføre eller prøvekjøre tidligopptaket på. Det finnes bare i MR !3226, som ikke er merget.

Stiene er forkortet:

- `SVC` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java`
- `SKJ` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/tidligopptak-tilbudsgaranti-automatikk.graphqls`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `TGS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SettTilbudsgarantitypeService.java`
- `ALG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/plasstildeling/algoritme/Opptakskjoringsalgoritme.java`
- `TGSEL` = `fs-admin/src/domains/soknadsbehandling/features/SakDrawer/components/SoknadsalternativerList/components/TilbudsgarantitypeSelect/TilbudsgarantitypeSelect.tsx`
- `MRBTN` = `fs-admin/src/domains/plasstildeling/features/TidligOpptak/components/KjorTidligopptakButton/KjorTidligopptakButton.tsx` (bare i MR !3226)
- `MRMOD` = `fs-admin/src/domains/plasstildeling/features/TidligOpptak/components/TidligOpptakResultModal/TidligOpptakResultModal.tsx` (bare i MR !3226)

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Gi tilbudsgaranti ved tidlig opptak | 2/29 | fs-admin | fs-plattform har hele gjennomføringen. fs-admin mangler prøvekjøringen og gjennomføringen på main (MR !3226), og utfallet, avvikene, kvotevarselet og grensen for kvotevarsel mangler også i MR-en. |

Gjenstår: fs-admin 1, ingen 0.

## Oppsummering

- Scenarioer: 2 funnet, 27 ikke funnet, 0 usikker, av 29
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1 (delvis levert: 2 deler fikk `@implemented`)
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: 5 stemmer, 0 avviker, 0 ikke funnet, 0 usikker, av 6 (1 ikke beskrevet)
- Regler i koden uten scenario: 14
- Åpne spørsmål: 0 regler og 1 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | `@OPT-BEH-BEH-013` Vurdere søknad om tidlig opptak | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-007` | `@OPT-OPT-UTD-004` Opptaksinnstillinger for utdanningstilbud | 1 | `@draft` | – | ikke levert, `@OPT-BEH-BEH-007` kan ikke leveres før dette |
| `@OPT-BEH-BEH-007` | `@OPT-BEH-BEH-010` Gi tilbudsgaranti | 1 | `@implemented` | – | |

Avhengigheter: 3 på nivå 1, 1 av dem ikke `@implemented`.

## Scenarioer

I `Bevis` står **P** for fs-plattform og **A** for fs-admin, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti ut fra poenggrensen | ikke funnet | P: funnet · A: mangler — `SVC:765-775` (poengsum under grensen gir nei, så lik grense gir garanti). Ikke funnet på main i fs-admin — finnes i MR !3226 (åpen, fs-admin, patsle/STEK-489-feat-tidlig-opptak-plasstildeling): `MRBTN:25-43,110` — kaller gjennomføringen |
| `@OPT-BEH-BEH-007` | Søkere som ikke deltar får ikke tilbudsgaranti | ikke funnet | P: funnet · A: mangler — `SVC:667-675`. Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Søknader uten konklusjon er ikke med i tidligopptaket | ikke funnet | P: funnet · A: mangler — `SVC:644-665`. Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Søkere som ikke er kvalifisert får ikke tilbudsgaranti | ikke funnet | P: funnet · A: mangler — `SVC:707-715`. Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Kvalifisering som ikke er vurdert gir ikke tilbudsgaranti | ikke funnet | P: funnet · A: mangler — `SVC:698-704`, `SVC:716-723` (KVALIFISERING_IKKE_VURDERT i detaljene). Opptaksforvalteren ser ikke utfallet, heller ikke i MR !3226 (`MRMOD:28-38` henter bare totaler) |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti på det høyest prioriterte søknadsalternativet | ikke funnet | P: funnet · A: mangler — `SVC:859` (sortert på prioritet), `SVC:590-608`, `SVC:765-775`. Begge eksempelradene stemmer. Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Bare ferdig behandlede saker er med i tidligopptaket | ikke funnet | P: funnet · A: mangler — `SVC:644-652`, antallet `SVC:169-173`. MR !3226 viser antall søkere, ikke saken (`MRMOD:81-97`) |
| `@OPT-BEH-BEH-007` | Reservert studieplass gir tilbudsgaranti uten poenggrense | ikke funnet | P: funnet · A: mangler — `SVC:681-684`, før poengsjekken. Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Reservert studieplass gir tilbudsgaranti uten kvalifisering | ikke funnet | P: funnet · A: mangler — `SVC:681-684` står før kvalifiseringen `SVC:688-724`. Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Den høyeste poengsummen til søknadsalternativet gjelder | ikke funnet | P: funnet · A: mangler — `SVC:888-918`, `max()` over kvotene søkeren skal kvoteplasseres i og som tilbudet har. Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet | ikke funnet | P: funnet · A: mangler — `SVC:1074-1079`, `SVC:1017-1019` (SATT_OVERSKREV_NEGATIV). Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet | ikke funnet | P: funnet · A: mangler — `SVC:1014-1016` (SATT_OVERSKREV_POSITIV), `SVC:1074-1079`. Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket | ikke funnet | P: funnet · A: mangler — `SVC:614-642`, bare egen kode eller kategori «Tidlig opptak» avgjør (`SVC:1082-1087`). Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Tidligopptakstilbud fra tilbyder går foran poengsummen | ikke funnet | P: funnet · A: mangler — `SVC:627-631`, `SVC:595-608`. Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum | ikke funnet | P: funnet · A: mangler — `SVC:509-534` (kandidat via tilbudet), `SVC:627-631` (før statussjekkene), `SVC:1021-1023`. Opptaksforvalteren ser det ikke, heller ikke i MR !3226 |
| `@OPT-BEH-BEH-007` | Prøvekjøre tidligopptaket | ikke funnet | P: funnet · A: mangler — `SVC:111-115`, `SVC:147-149` (rulles tilbake). MR !3226 prøvekjører (`MRBTN:99`), men viser bare totaler, ikke søkeren (`MRMOD:28-38`) |
| `@OPT-BEH-BEH-007` | En ny gjennomføring fjerner ikke tilbudsgarantien | ikke funnet | P: funnet · A: mangler — `SVC:616-626`, før poenggrensen. Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Ny gjennomføring tar med en sak som er blitt ferdig behandlet | ikke funnet | P: funnet · A: mangler — `SVC:529-536`, `SVC:644`, `SVC:821-873` (status leses ved hver kjøring). Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Tilbudsgarantien flyttes til et høyere prioritert søknadsalternativ ved ny gjennomføring | ikke funnet | P: funnet · A: mangler — `SVC:591-593`, `SVC:1037-1067`. Gjennomføringen finnes i MR !3226 |
| `@OPT-BEH-BEH-007` | Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak | funnet | P: funnet · A: ikke relevant — `ALG:200-211` (kvalifiserte søknader er med i plasstildelingen uansett tilbudsgaranti). Plasstildelingen har ikke noe filter på tidlig opptak |
| `@OPT-BEH-BEH-007` | Se utfallet for hver søker | ikke funnet | P: funnet · A: mangler — `SKJ:113-151`, `SVC:1210-1238`. Utfallet finnes ikke i fs-admin, heller ikke i MR !3226 (`MRMOD:28-38`, tre totaler) |
| `@OPT-BEH-BEH-007` | Se antall saker som ikke er ferdig behandlet eller mangler konklusjon | ikke funnet | P: funnet · A: mangler — `SVC:169-173`, `SVC:213-222`. MR !3226 viser antall søkere, ikke saker (`MRMOD:81-97`) |
| `@OPT-BEH-BEH-007` | Se utdanningstilbud med mangelfulle innstillinger | ikke funnet | P: funnet · A: mangler — `SVC:378-385`. MR !3226 viser bare antallet avvik i en snackbar etter en ekte kjøring (`MRBTN:125-130`), ikke i prøvekjøringen, og ikke hvilket tilbud |
| `@OPT-BEH-BEH-007` | Varsel når tilbudsgarantiene overskrider kvoten | ikke funnet | P: funnet · A: mangler — `SVC:410-426` (KVOTEANDEL_OVERSKREDET, ingen sperre). MR !3226 teller varselet med i «feilkonfigurert» (`MRBTN:125-130`) |
| `@OPT-BEH-BEH-007` | Kvotevarselet tar med tilbudsgarantier fra en tidligere gjennomføring | ikke funnet | P: funnet · A: mangler — `SVC:1195-1200`, `SVC:617` (STEK-623, e3d57129e8). Mangler i fs-admin, også i MR !3226 |
| `@OPT-BEH-BEH-007` | Kvotevarsel ved 30 prosent når grensen ikke er angitt | ikke funnet | P: funnet · A: mangler — `SVC:94-95`, `SKJ:71`. Mangler i fs-admin, også i MR !3226 |
| `@OPT-BEH-BEH-007` | Angi grensen for kvotevarsel | ikke funnet | P: funnet · A: mangler — `SKJ:66-71` (`kvotevarselProsent`). MR !3226 sender den ikke (`MRBTN:99,110`) |
| `@OPT-BEH-BEH-007` | Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak | ikke funnet | P: funnet · A: mangler — `SVC:279-291`. MR !3226 viser feilmeldingen (`MRMOD:177-186`) |
| `@OPT-BEH-BEH-007` | Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket | funnet | P: funnet · A: funnet — `TGS:55-103` (ingen betingelse om tidlig opptak), `TGSEL:235-238`, `TGSEL:297`, `TGSEL:321-330` |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

| Feature-ID | Sjekk | Rolle og handling | Kravet sier | Koden gjør | Resultat | Bevis |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | tilgang | opptaksforvalter endrer tilbudsgarantier (gjennomfører og prøvekjører tidligopptaket) | opptaksforvalter (brukerhistorien og Når-stegene) | krever SE_SØKNADSBEHANDLING og MODIFISERE_OPPTAK for forvaltende organisasjon, og OPPTAK_TILBGARANTI_GI_VIA_OPPTAK for å skrive. Prøvekjøringen krever det samme | stemmer | `SVC:102-106`, `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/auth/AuthRoutines.java:117-121`, `MIG/V346:104-105,153-158`, `MIG/V406:155-172` |
| `@OPT-BEH-BEH-007` | organisasjon | opptaksforvalter endrer tilbudsgarantier i hele opptaket | ikke beskrevet | uten forvaltertilgang avvises kjøringen før RLS kan skjule saker hos andre organisasjoner, og en avvist skriving ruller tilbake alt | stemmer | `SVC:100-106`, `SVC:994-1001` |
| `@OPT-BEH-BEH-007` | tilgang | tilbyder endrer tilbudsgaranti manuelt | tilbyder (Regel: Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket) | typen må kunne brukes av tilbyder, og tilgangen er OPPTAK_TILBGARANTI_GI_VIA_UTDTILBUD for tilbyderorganisasjonen | stemmer | `TGS:68-77`, `MIG/V346:106-108,161-167`, `TGSEL:235-238` |
| `@OPT-BEH-BEH-007` | konsistens | opptaksforvalter endrer tilbudsgarantier (gjennomføring) | ikke beskrevet | én transaksjon. En skrivefeil ruller tilbake hele kjøringen, og utfallstabellen tømmes og skrives på nytt i samme transaksjon | stemmer | `SVC:108-115`, `SVC:538-545`, `SVC:994-1001` |
| `@OPT-BEH-BEH-007` | konsistens | opptaksforvalter endrer tilbudsgarantier (overskriver annen kode) | kommentar i kravet (avklart 08.10 og 20.10): en annen kode går tapt, og det er akseptert | overskriver alle andre verdier i forvalterkolonnen, også reservert studieplass og andre tilbudsgivende | stemmer | `SVC:1074-1079`, `SVC:1008-1020` |
| `@OPT-BEH-BEH-007` | tilgang | opptaksforvalter, behandler og tilbyder leser utfallet | ikke beskrevet | SELECT på `tidligopptak_resultat` for SE_SØKNADSBEHANDLING hos behandler, opptaksforvalter eller tilbyder. Søkerens innsyn stopper etter publisering av resultatet | ikke beskrevet | `MIG/V406:138-152` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Kansellerte utdanningstilbud er ikke med, og gir verken tilbudsgaranti eller avvik | annet | `SVC:349-352` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Søknadsalternativer søkeren har trukket, er ikke med | annet | `SVC:523`, `SVC:858` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Bare aktive saker er med | annet | `SVC:215`, `SVC:533`, `SVC:857` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Avvik også når utdanningstilbudet mangler kompetanseregelverk, rangeringsregelverk eller kvote, ikke bare poenggrense | validering | `SVC:386-409` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-007` | Mangler poengsum (poengberegningen er ikke kjørt), gir utfallet MANGLER_POENGSUM og ingen tilbudsgaranti | validering | `SVC:754-763` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Søkere med tidligopptakstilbud er med selv om de ikke har søkt tidlig opptak | annet | `SVC:500-536` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Poengsummen tas bare fra kvoter søkeren kvoteplasseres i, kvotetyper tilbudet har og grunnlag rangeringsregelverket åpner for | grense | `SVC:888-949` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Kvalifisering: ett kvalifisert grunnlag holder. Ikke kvalifisert bare når alle grunnlagene er nei, og ingen grunnlag gir «ikke vurdert» | annet | `SVC:779-802` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti over reservert studieplass (RSO/RES) gir SATT_OVERSKREV_RESERVASJON, og markeringen av reservasjonen forsvinner | tilstandsovergang | `SVC:1011-1013`, `SKJ:222-226` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Et tidligopptakstilbud fra tilbyder på et lavere prioritert søknadsalternativ blir stående, men gir ikke en ny innvilgelse | tilstandsovergang | `SVC:595-608`, `SKJ:240-243` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-007` | Kvotevarselet gis bare når kvoten tilbudsgarantiene tas fra har ønsket antall deltakere, og grensen valideres ikke (negativ eller over 100 godtas) | grense | `SVC:94-95`, `SVC:418-419`, `SKJ:71` | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Poengsum under grensen får det samme utfallet som manglende kvalifisering (IKKE_KVALIFISERT), og bare begrunnelsen skiller dem | annet | `SVC:707-713`, `SVC:765-771` | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Detaljlista kappes ved 200 rader, og oppsummeringen teller alt | grense | `SKJ:57-65`, `SVC:1098-1101` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Detaljlista utelater søknadsalternativer under det avgjorte (IKKE_VURDERT_LAVERE_PRIORITET), men oppsummeringen teller dem | annet | `SKJ:119-121`, `SVC:595-608` | testes i fase 2 |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Gi tilbudsgaranti ved tidlig opptak | 0 av 3 | 1 av 29 | 0 |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-admin` | [!3226 feat(plasstildeling): STEK-489 tidlig opptak in plasstildeling](https://gitlab.sikt.no/studieadm/fs-admin/-/merge_requests/3226) (`patsle/STEK-489-feat-tidlig-opptak-plasstildeling`) | åpen | `@OPT-BEH-BEH-007` | 16/27 | bak main (51 commits). Gjennomføringen og prøvekjøringen er der, og feilmeldingen om tilbudsgarantitypen. Utfallet per søknadsalternativ, antallet per utfall, organisasjon og utdanningstilbud, avvikene i prøvekjøringen, kvotevarselet og grensen for kvotevarsel mangler |

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | scenario | Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket | funnet | funnet | Resultatet står, men fs-admin-beviset pekte på feil linjer. Rettet til `TGSEL:235-238`, `TGSEL:297`, `TGSEL:321-330` |
| `@OPT-BEH-BEH-007` | scenario | Se utdanningstilbud med mangelfulle innstillinger | ikke funnet | ikke funnet | Resultatet står. MR !3226 viser antallet avvik etter en ekte kjøring (`MRBTN:125-130`), og det står nå i beviset |
| `@OPT-BEH-BEH-007` | tilgang | opptaksforvalter endrer tilbudsgarantier (gjennomfører og prøvekjører) | stemmer | stemmer | Resultatet står, men beviset manglet OPPTAK_TILBGARANTI_GI_VIA_OPPTAK (`MIG/V346:104-105,153-158`, `MIG/V406:155-172`) |
| `@OPT-BEH-BEH-007` | tilgang | tilbyder endrer tilbudsgaranti manuelt | stemmer | stemmer | Resultatet står, men `TGS:68-77` sjekker bare typen. Tilgangen er OPPTAK_TILBGARANTI_GI_VIA_UTDTILBUD (`MIG/V346:106-108,161-167`) |
| `@OPT-BEH-BEH-007` | tilgang | opptaksforvalter, behandler og tilbyder leser utfallet | – | ikke beskrevet | Lagt til av kontrollen: `MIG/V406:138-152` |
| `@OPT-BEH-BEH-007` | regel | Bare aktive saker er med | – | testes i fase 2 | Lagt til av kontrollen: `SVC:215`, `SVC:533`, `SVC:857` |
| `@OPT-BEH-BEH-007` | regel | Kvalifisering: ett kvalifisert grunnlag holder | – | testes i fase 2 | Lagt til av kontrollen: `SVC:779-802` |
| `@OPT-BEH-BEH-007` | regel | Tidligopptakstilbud på lavere prioritet blir stående | – | legg til scenario med `fs-krav` | Lagt til av kontrollen: `SVC:595-608` |
| `@OPT-BEH-BEH-007` | regel | Kvotevarselet krever ønsket antall deltakere, grensen valideres ikke | – | uklart om ønsket | Lagt til av kontrollen: `SVC:94-95`, `SVC:418-419` |
| `@OPT-BEH-BEH-007` | regel | Poengsum under grensen og ikke kvalifisert har samme utfall | – | uklart om ønsket | Lagt til av kontrollen: `SVC:707-713`, `SVC:765-771` |
| `@OPT-BEH-BEH-007` | regel | Detaljlista utelater alternativer under det avgjorte | – | testes i fase 2 | Lagt til av kontrollen: `SKJ:119-121` |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-007` — Gi tilbudsgaranti ved tidlig opptak (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature`, `@in-progress` → `@in-progress`, 2/29 funnet) — `@implemented` på: Scenario: Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak (linje 344), Regel: Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket (linje 418) — bygger på `@OPT-OPT-UTD-004`, som er `@draft`

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-007` — Gi tilbudsgaranti ved tidlig opptak (`@in-progress`, 2/29 funnet) — gjennomføringen, prøvekjøringen og utfallet mangler i fs-admin på main (delvis i MR !3226)

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Gi tilbudsgaranti ved tidlig opptak (delvis: `@in-progress`, 2 deler `@implemented`) | `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature` | `@in-progress` | 2/29 |

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Gi tilbudsgaranti ved tidlig opptak | `@in-progress` | 2/29 | 27 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **fs-admin mangler gjennomføringen:** fs-admin på main har ingen måte for opptaksforvalteren å prøvekjøre eller gjennomføre tidligopptaket på. MR !3226 har det, men mangler utfallet per søknadsalternativ, antallet per utfall, organisasjon og utdanningstilbud, avvikene i prøvekjøringen, kvotevarselet per utdanningstilbud og grensen for kvotevarsel (`MRMOD:28-38`, `MRBTN:99,110,125-130`).
- **Saker eller søkere:** kravet sier at opptaksforvalteren ser antall *saker* som ikke er ferdig behandlet eller mangler konklusjon. MR !3226 viser antall *søkere* (`MRMOD:81-97`). Enten endres MR-en, eller så endres kravet med `fs-krav`.
- **Utdatert kommentar i kravet:** kommentaren over «Kvotevarselet tar med tilbudsgarantier fra en tidligere gjennomføring» (linje 383–384) sier at koden må endres (STEK-623). Det er gjort i e3d57129e8 (merget 29.10.2026). Rett kommentaren med `fs-krav`.
- **Utdatert javadoc i koden:** `SVC:879` sier at poengsummen er fra «den kvoten tilbudets tilbudsgarantikvote peker på», men spørringen tar den høyeste poengsummen på tvers av kvotene (`SVC:888-918`).
- **Åpent spørsmål:** `@OPT-BEH-BEH-007` «Reservert studieplass gir tilbudsgaranti uten kvalifisering» — Gir reservert studieplass (RSO eller RES) tilbudsgaranti også når søkeren ikke er kvalifisert, eller kvalifiseringen ikke er vurdert? Fagperson svarte ja 13.10.2026, men har sendt spørsmålet videre til en annen domeneekspert, så svaret er foreløpig. Koden gjør det (`SVC:681-684`).
- **Ikke sjekket:** min-kompetanse er ikke med. Ingen scenarioer i kravet gjelder det søkeren ser.
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-007` bygger på `@OPT-OPT-UTD-004` (`@draft`). Kravet har også et åpent spørsmål om det skal ha `@depends-on-OPT-BEH-BEH-007` (`opptaksinnstillinger_utdanningstilbud.feature:192-194`).
