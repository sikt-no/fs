# Omfang – Opprette og vedlikeholde opptak v4

- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155553291
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5159125001
- **Laget**: 2026-10-30, delt ut av testplanen (versjon 4 ble laget 2026-10-29 av fs-testplan)

---

Omfanget for «Opprette og vedlikeholde opptak», versjon 4: kravene og flytene som testes, og det som ikke er med. Kravene i «Omfang» er kriteriene for godkjent, og alle skillene i testflyten leser dem herfra. Testplanen: [Testplan – Opprette og vedlikeholde opptak v4](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155553291).

## Omfang

Alle scenarioene i gating-settet i de fem kravene testes, også i kravene som ikke er levert. Det er et avvik fra teststrategien, avgjort av produkteier. Feature-ID-ene her er kravene resten av testflyten bruker.

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | `@OPT-OVO-GRU-001` | `@implemented`, én regel `@in-progress` (endres) | 9 (13 med eksemplene). 8 er levert. Regelen som endres, er funnet i koden 28.10, men ikke retagget |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | `@OPT-OVO-SAM-001` | `@in-progress` (ikke levert) | 15. 11 funnet i koden 28.10 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | `@OPT-OVO-INN-001` | `@implemented` | 21. «Startnummeret er 1 når opptaksforvalter ikke har satt det» er usikker etter verifiseringen 28.10 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | `@OPT-OVO-FRI-001` | `@in-progress` (ikke levert) | 28 (42 med eksemplene). 25 funnet i koden 28.10 |
| [Listevisning og søk i opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/07%20Oversikt%20over%20opptak/listevisning_og_sok_i_opptak.feature) | `@OPT-OVO-OVE-001` | `@implemented` | 11 (16 med eksemplene). To kan ikke kjøres før det finnes over 50 opptak i TEST |
| **Totalt** | | | **84 (107 med eksemplene)**. 76 funnet i koden, 5 ikke funnet, 3 usikre |

Åpne spørsmål (testes som det står):

- `@OPT-OVO-SAM-001` «Organisasjoner som ikke deltar, kan ikke se opptaket»: skal regelen ha `@ref-OPT-OPT-UTD-001`?
- `@OPT-OVO-SAM-001` «En deltakende organisasjon kan ikke fjernes fra opptaket så lenge den har utdanningstilbud i det»: skal regelen ha `@ref-OPT-OPT-UTD-026`?
- `@OPT-OVO-SAM-001` «Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger i opptaket»: er «forvaltende organisasjon» utvetydig nok for tilgangsstyringen?
- `@OPT-OVO-SAM-001` «Opptaksforvalter ved forvaltende organisasjon kan se og navigere til saksbehandlertildelingen i samordna opptak»: skal regelen ha `@ref-OPT-BEH-BEH-011`?
- `@OPT-OVO-INN-001` «Den siste utdanningsbakgrunnen kan ikke fjernes»: skal alle opptak ha utdanningsbakgrunn, eller bare UHG-opptak (samordna opptak)? Avklares i TOT-2586.
- `@OPT-OVO-FRI-001`: elleve regler spør om de skal ha `@ref-` til kravet der fristen brukes. «… informasjonsdato for dokumentasjon og ettersendingsfrist» spør også om ettersendingsfristen er en frist eller en informasjonsdato. Spørsmålene endrer ikke hva som testes.
- `@OPT-OVO-FRI-001` «Sette første svarfrist som informasjon til søkere» (Q19, TAKE-414): er første svarfrist svarfristen på hovedrunden, eller en egen dato på opptaket? Scenarioet vil ikke bestå som det står.

Scenarioene i testen er gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo. Et scenario med et åpent spørsmål testes som det står.

De automatiske testene av de samme kravene: `npx playwright test --grep @scope-opprette-opptak-2027`

### Åpne spørsmål

`@openquestion` stopper ikke testen: delen testes som den står. Oversikten viser hvor mye som står åpent. Tallene er regnet fra kravfilene og verify-rapporten.

| Krav | Feature-ID | Regler med åpent spørsmål | Scenarioer med åpent spørsmål | Scenarioer i testen | Utkast (`@draft @openquestion`, ikke med) |
|---|---|---|---|---|---|
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | `@OPT-OVO-GRU-001` | 0 av 4 | 0 av 9 | 9 | 2 regler (gjenbruke innstillinger, deaktivere) |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | `@OPT-OVO-SAM-001` | 4 av 9 | 8 av 15 | 15 | – |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | `@OPT-OVO-INN-001` | 0 av 9 | 1 av 21 | 21 | 1 regel (varsel når opplasting stenges) |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | `@OPT-OVO-FRI-001` | 11 av 14 | 19 av 28 | 28 | 2 regler (klokkeslett 23:59, varsel ved feil rekkefølge) |
| [Listevisning og søk i opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/07%20Oversikt%20over%20opptak/listevisning_og_sok_i_opptak.feature) | `@OPT-OVO-OVE-001` | 0 av 2 | 0 av 11 | 11 | – |
| **Totalt** | | **15 av 38** | **28 av 84** | **84** | **5 regler** |

## Flyter

Flytene viser hva som skjer fra ett krav til det neste, på tvers av domener. Her testes overleveringene: at det ett krav lager, blir brukt av det neste. Kravene i fasene testes hver for seg i «Omfang».

### Saksbehandlertildeling (`@FLY-OPT-SAK-001`, `@planned`)

- **Testes**: nei
- **Hvorfor**: 0 av 5 faser er levert (verify 28.10.2026). Kravene fasene bygger på, er `@in-progress`, `@planned` eller `@draft`. Flyten testes når fasene er levert.

| Fase | Bygger på | Fase levert | I leveransen | Scenarioer i testen |
|---|---|---|---|---|
| Tildelingsreglene settes for opptaket | `@OPT-OVO-SAM-001` (`@in-progress`), `@OPT-BEH-BEH-011` (`@planned`) | nei | ja | – |
| Utdanningstilbudet får saksbehandlertildelingsregel | `@OPT-OPT-UTD-004` (`@draft`) | nei | nei | – |
| Søknadsalternativene fordeles når søknaden sendes | `@OPT-BEH-BEH-011` (`@planned`) | nei | nei | – |
| Den saksbehandlende organisasjonen ser saken | `@OPT-BEH-BEH-011` (`@planned`), `@OPT-BEH-BEH-010` (`@implemented`) | nei | nei | – |
| Søknadsalternativene flyttes når utdanningsbakgrunnen endres | `@OPT-OVO-FRI-001` (`@in-progress`, Regel: … frist for endring av utdanningsbakgrunn, ankeret), `@OPT-BEH-BEH-011` (`@planned`) | nei | ja | – |

### Vurdering per krav (fase 3)

Den interne akseptansetesten tester flyter og avhengigheter. Per krav vurderes det hva som testes:

| Krav | Inngår i flyt | Vurdering |
|---|---|---|
| `@OPT-OVO-GRU-001` | Ingen | Testes som oppgave uten flyt. Ny flyt bør vurderes: «Opprette og klargjøre et opptak», fra opptaket opprettes til lærestedene har lagt til utdanningstilbud (`fs-krav`, modus E) |
| `@OPT-OVO-SAM-001` | Saksbehandlertildeling (fase 1) | Flyten testes ikke: ingen faser er levert. Testes som oppgave uten flyt, og kobles til den nye flyten om den lages |
| `@OPT-OVO-INN-001` | Ingen | Testes som oppgave uten flyt. Kobles til den nye flyten om den lages |
| `@OPT-OVO-FRI-001` | Saksbehandlertildeling (fase 5) | Flyten testes ikke: ingen faser er levert. Testes som oppgave uten flyt, og kobles til den nye flyten om den lages |
| `@OPT-OVO-OVE-001` | Ingen | Testes som oppgave uten flyt |

Scenarioene som tas med i fase 3, er de som inngår i flytene, ikke alle. Er en tidligere levert flyt avhengig av noe leveransen endrer, står den med som regresjon. Ingen flyter i `krav/_Flyter/` er `@implemented` og avhengige av kravene her.

### Avhengighetskart

Det leveransen bygger på eller påvirker utenfor opptaksforvalterens flyt. Det sjekkes underveis i den interne testen der det er mulig, ellers for seg.

| Avhengighet | Type | Hvordan sjekkes det |
|---|---|---|
| Utdanningsregisteret (replika av organisasjonene) | Integrasjon | I oppgaven: organisasjonene i «Inviter» kommer fra registeret, og bare aktive læresteder vises (`InviterOrganisasjonerModal.tsx:49-62`) |
| Utdanningstilbud i opptak (Shinkansen, `@OPT-OPT-UTD-002`, `@OPT-OPT-UTD-003`) | Annet teams leveranse | I oppgaven: en deltakende organisasjon legger til et utdanningstilbud, og da kan ikke opptakstype og regelverkssamling endres, og deltakeren kan ikke fjernes. Redigerings- og trekkfristen brukes av utdanningstilbudene (virkningen testes ikke her). Trekket avvises når trekkfristen ikke er satt |
| Tilgangsstyring (rollekatalogen, `MEDLEM_OPPTAK`) | Annen modul i FS | Før testen: bekreft at `OPPTAK_FORVALTER` ved NTNU gir `MEDLEM_OPPTAK` i TEST (miljøfila). Ellers kan ikke testbruker 2 legge til utdanningstilbud |
| Saksbehandlertildeling (Puff, `@OPT-BEH-BEH-011`) | Annet teams leveranse | I oppgaven: lenken til saksbehandlertildelingen i samordna opptak. API-et sperrer også fjerning av en deltaker som er sektororganisasjon i en aktiv tildelingsregel (`OpprettOpptakMutations.java:630-682`) |
| Søknad (`@OPT-SØK-SØK-017`, velge utdanningsbakgrunn) | Annen modul i FS | Testes for seg: krever en søknad der søkeren har valgt en utdanningsbakgrunn (testdata `opptak-utdanningsbakgrunn-valgt-av-soker`) |
| Plasstildeling (`@OPT-PLA-TIL-002`) | Annen modul i FS | Ikke i denne testen: taket for antall tilbud og første svarfrist flyttes til plasstildelingsrunden |
| Unleash-flaggene `opptak-opprett-samordna` og `opptak-filter-organisasjon` | Konfigurasjon | Sjekkes før testen (forutsetning 1): hvordan flaggene står i TEST |

## Venter på verifisering

Kravene og delene under er ikke levert, men testes likevel (avvik fra strategien, se over). Det som ikke er funnet, er de kjente manglene fra verifiseringen 28.10, og vil trolig ikke bestå. De tas inn som levert når `fs-verify` har satt `@implemented`.

| Krav | Feature-ID | Status | Hva som venter |
|---|---|---|---|
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | `@OPT-OVO-GRU-001` | `@in-progress` (delen) | Regelen «Utdanningsbakgrunner, poenglikhetsregel og maks antall søknadsalternativer må være satt for å lagre et opptak». Funnet i koden 28.10 (1/1, bare FS Admin sperrer utdanningsbakgrunner og maks), men brukeren avbrøt gjennomgangen før retaggingen |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | `@OPT-OVO-SAM-001` | `@in-progress` | Hele kravet (11 av 15 funnet). Ikke funnet: «Organisasjon som ikke deltar, kan ikke åpne opptaket» og «Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger». Usikker: «Organisasjon som ikke deltar, ser ikke opptaket» (flagget) og «Se og navigere til saksbehandlertildelingen for opptaket» (bare på redigeringssiden, TAKE-447) |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | `@OPT-OVO-FRI-001` | `@in-progress` | Hele kravet (25 av 28 funnet). Ikke funnet: «Opptaket kan ikke lagres uten fristen for å trekke utdanningstilbud» (TAKE-436), «Varsel når fristen for å trekke utdanningstilbud er før redigeringen stenger» og «Sette første svarfrist som informasjon til søkere» (Q19) |

## Regler uten scenario

Fra [verify-2026-10-28-1238.md](../opprette-opptak-2027/verify-2026-10-28-1238.md), som har 60 regler. Her står de som er input til fase 2 eller kravarbeidet. Reglene som bare FS Admin sperrer, og reglene som er uklare om de er ønsket, står i rapporten.

| Krav | Regel i koden | Funnet i | Testes i fase 2 | Kravet bør få scenario |
|---|---|---|---|---|
| `@OPT-OVO-GRU-001` | Navnet er høyst 100 tegn på hvert språk | `fs-admin/…/OpptakInformation/OpptakInformation.tsx:12,50,64,79,88`, `opptak.graphqls:95` | ja: 100 og 101 tegn | nei |
| `@OPT-OVO-GRU-001` | Et navn med bare mellomrom regnes som manglende | `OpptakManagementPage.tsx:190,194,198`, `KreverSprak.java:58-62` | ja | nei |
| `@OPT-OVO-GRU-001` | Opptakstypene avhenger av samordna/lokalt: samordna skjuler LOKAL, lokalt skjuler FSU og UHG | `OpptakSettings.tsx:65-69,136-140` | ja | ja (`fs-krav`) |
| `@OPT-OVO-GRU-001` | Maks antall søknadsalternativer forhåndsutfylles med 10 | `emptyObjectGenerators.ts:21` | ja | nei |
| `@OPT-OVO-SAM-001` | Invitasjonsmodalen viser bare aktive læresteder, skjuler de som er lagt til, og søker i navn, forkortelse og kode | `InviterOrganisasjonerModal.tsx:20-22,49-80` | ja | nei |
| `@OPT-OVO-SAM-001` | En deltaker som er sektororganisasjon i en tildelingsregel, kan ikke fjernes | `OpprettOpptakMutations.java:630-682` | nei: krever saksbehandlertildeling (Puff) | ja (`fs-krav`) |
| `@OPT-OVO-SAM-001` | Et samordna opptak kan ikke gjøres lokalt med deltakere eller egne tildelingsregler | `OpprettOpptakMutations.java:324-343` | nei: skjemaet tilbyr det ikke | ja (`fs-krav`) |
| `@OPT-OVO-SAM-001` | En deltaker kan bare endre utdanningstilbud mens fasen er åpen | `OpptakSøknadsalternativer.tsx:100-103` | ja | nei |
| `@OPT-OVO-SAM-001` | Tidlig opptak, dokumentopplasting og krever studierett vises alltid som påslått på oversikten | `OpptakDetails.tsx:177-204` | ja (trolig feil) | nei |
| `@OPT-OVO-INN-001` | Tidlig opptak kan ikke slås av mens et utdanningstilbud tilbyr det | `OpprettOpptakMutations.java:209-216` | ja, med `opptak-samordna-tilbud-med-tidlig-opptak` fra oppsettet | ja (`fs-krav`) |
| `@OPT-OVO-INN-001` | Bekreftelse før tidlig opptak eller ledige studieplasser slås av og frister med dato skjules | `OpptakSettings.tsx:105-124,388-400` | ja | ja (`fs-krav`) |
| `@OPT-OVO-INN-001` | En tillatt poenglikhetsregel som brukes av et utdanningstilbud, kan ikke fjernes | `OpprettOpptakMutations.java:533-546` | nei: krever et tilbud med unntak | ja (`fs-krav`) |
| `@OPT-OVO-INN-001` | Med overstyring av poenglikhet må minst én regel være valgt | `OpptakManagementPage.tsx:225-232` | ja | nei |
| `@OPT-OVO-INN-001` | Lenken til tidlig opptak må være en http- eller https-adresse | `V0__kodeverk.sql:30`, `OpprettOpptakMutations.java:699-701` | ja | nei |
| `@OPT-OVO-INN-001` | Startnummer og maks søknadsalternativer må være større enn 0, men skjemaet tillater 0, og 0 gir «En av de angitte verdiene er ugyldig» | `V0__kodeverk.sql:35`, `OpptakSettings.tsx:280,293`, `OpprettOpptakMutations.java:701` | ja: 0 og 1 (trolig feil) | ja (`fs-krav`) |
| `@OPT-OVO-INN-001` | Samme utdanningsbakgrunn kan ikke oppgis to ganger | `OpptakUtdanningsbakgrunner.java:27-30` | nei: skjemaet tilbyr det ikke | nei |
| `@OPT-OVO-FRI-001` | En delvis utfylt dato i et valgfritt felt gir «Ugyldig dato. Fyll inn hele datoen, eller la feltet stå tomt.» | `OpptakDeadlineInput.tsx:121-131`, `opptak.json:229` | ja | nei |
| `@OPT-OVO-FRI-001` | En obligatorisk frist kan ikke tømmes: den settes tilbake til forrige verdi | `OpptakDeadlineInput.tsx:133-136` | ja | nei |
| `@OPT-OVO-FRI-001` | Standarddatoen for aldersberegning settes bare når publiseringsdatoen er satt | `AldersberegningsdatoDefault.java:23-31,38-43` | ja | nei |
| `@OPT-OVO-FRI-001` | Avvikende frister kan bare settes på utdanningsbakgrunner som er valgt i opptaket | `OpptakUtdanningsbakgrunner.java:36-48` | ja | nei |
| `@OPT-OVO-FRI-001` | Kortene for tidlig opptak og ledige studieplasser vises bare når valget er på, og fristene i skjulte kort lagres ikke | `fristKort.ts:36-39`, `hendelseVisibility.ts:9-29` | ja | ja (`fs-krav`) |
| `@OPT-OVO-OVE-001` | Lista har status (kolonne, sortering, filter), selv om kravet sier at status ikke er med | `OpptakResultList.tsx:65-67`, `OpptakFilter.tsx:56-73` | nei: avklares i kravet | ja (`fs-krav`) |
| `@OPT-OVO-OVE-001` | Organisasjonsfilteret i lista er bak flagget `opptak-filter-organisasjon` | `useGetOpptak.tsx:11-18,25,31-33` | ja, når flagget er kjent | ja (`fs-krav`) |
| `@OPT-OVO-OVE-001` | Fritekst-søket er delstreng uten skille på store og små bokstaver, på alle språk | `OpptakService.java:76-85` | ja | nei |
| `@OPT-OVO-OVE-001` | Nytt søk eller filter starter lista på 50 igjen; filter og sortering står i URL-en; «Nullstill»; tom liste viser «Ingen opptak funnet» | `useDataListState.tsx:39-42,66,93-102`, `OpptakResultList.tsx:40-41` | ja | nei |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Gjenbruke innstillinger fra et tidligere opptak (Opprette et opptak) | Ikke avklart ennå: hva kopieres, og hva kopieres ikke? Utsatt til senere iterasjon |
| Deaktivere et opptak (Opprette et opptak) | Ikke avklart ennå. Utsatt til senere iterasjon |
| Tak for antall tilbud per tildelingsrunde (Innstillinger for opptak) | Skal fjernes: flyttes til plasstildelingsrunden. Borte fra FS Admin på main, men finnes i API-et |
| Varsel når opplasting av dokumentasjon stenges (Innstillinger for opptak) | Ikke avklart ennå: skal datoene for dokumentasjon fjernes eller bare skjules? |
| Krav om studierett for å søke (Innstillinger for opptak) | Ikke avklart ennå |
| Klokkeslettet for en frist er 23:59 som standard (Frister og hendelser for opptak) | Ikke avklart ennå: gjelder det alle fristene, også når noe åpner? (TAKE-454) |
| Varsel når fristene står i feil rekkefølge (Frister og hendelser for opptak) | Ikke avklart ennå: hvilke frister bør ligge før andre? (TAKE-457) |
| Hendelseslogg for opptak | Kommer senere: venter på en generell løsning |
| Fellestekster og svarmeldingsmal | Skal ikke lages nå. Utsatt til senere iterasjon (sikt-no/fs#214) |
| Opptakstyper med navn og forkortelse (`@OPT-OVO-GRU-003`) | Ikke i scopet, og ikke avklart ennå (`@draft`, TAKE-456) |
| Virkningen av innstillingene og fristene hos søkeren, i saksbehandlingen og for utdanningstilbudene | Kommer senere: står i kravene der verdiene brukes, og har ingen oppgave ennå (se «Uløst arbeid» i scope-fila) |
| Status i oversikten over opptak | Ikke med i kravet, selv om lista har status |
| Sortering på navn i oversikten over opptak | Ønsket av HK-dir, men ikke med i kravet nå |
| Flyten Saksbehandlertildeling, alle fem fasene | Fasen er ikke levert |

