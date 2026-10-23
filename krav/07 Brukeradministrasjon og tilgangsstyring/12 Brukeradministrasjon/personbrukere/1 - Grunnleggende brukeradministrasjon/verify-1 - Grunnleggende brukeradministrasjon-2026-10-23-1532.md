# Verifisering: 1 - Grunnleggende brukeradministrasjon

- **Dato:** 2026-10-23 15:32
- **Krav:** `krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon` (6 feature-filer)
- **Kode:** `fs-plattform` (ikke sjekket (Claude-panelet)), `fs-admin` (ikke sjekket (Claude-panelet))
- **Omfang:** `@planned`, `@in-progress` og `@implemented`, uansett status, også `@planned`-delene i leverte krav, og `@deprecated`-delene i `@BRU-PER-GRU-001` (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** manuell (Claude-panelet)
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i `@planned`-, `@in-progress`- og `@implemented`-kravene, også `@planned`-deler og `@openquestion`, minus `@draft`, `@deprecated` og `@demo` (verifisert uansett status; `@draft` er holdt utenfor fordi brukeren ba om `@planned`, `@in-progress` og `@implemented`). `@deprecated`-delene er sjekket for at koden er borte.

Stiene er forkortet:

- `P-db` = `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog`
- `P-svc` = `fs-plattform/tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service`
- `P-schema` = `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental`
- `A-ts` = `fs-admin/src/domains/tilgangsstyring/features`
- `A-roller` = `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller`
- `A-msg` = `fs-admin/src/common/messages/nb/tilgangsstyring.json`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@BRU-PER-GRU-004` | Aktivere og deaktivere en personbrukers samlede tilganger | 3/3 | ingen | – (historikk ved reaktivering er ikke en del av kravet, se `## Oppfølging`) |
| `@BRU-PER-GRU-012` | Fjerne roller fra en personbruker | 9/9 | ingen | – |
| `@BRU-PER-GRU-007` | Se detaljer for personbruker | 5/5 | ingen | – |
| `@BRU-PER-GRU-001` | Listevisning og søk i personbrukere | 19/19 | ingen | – |
| `@BRU-PER-GRU-003` | Tildele roller til en personbruker | 11/12 | fs-plattform | Rollelista er hele katalogen når administratoren har retten i kombinasjonen. Det åpne spørsmålet om hva rettigheten består i, avgjør om det er nok. |
| `@BRU-PER-GRU-008` | Se en personbrukers roller | 7/9 | fs-admin | Organisasjonsfilteret i Roller-fanen viser ikke akronym, og man kan ikke søke i det. |

Gjenstår: fs-admin 1, fs-plattform 1, ingen 4.

## Oppsummering

- Scenarioer: 54 funnet, 2 ikke funnet, 1 usikker, av 57
- Krav levert (status satt til `@implemented`): 1
- Deler levert (status fjernet fra delen): 1
- Krav og deler som ikke er levert: 6
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 2

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |

Avhengigheter: 0 på nivå 1, 0 av dem ikke `@implemented`. Ingen av de seks kravene har `@depends-on-`.

## Scenarioer

I `Bevis` står **P** for fs-plattform og **A** for fs-admin, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@BRU-PER-GRU-004` | Deaktivere en personbruker med aktive tildelinger | funnet | P: funnet · A: funnet — `P-svc/FeideBrukerStatusService.java:119-127` (setter deaktiveringstidspunkt og hvem som deaktiverte, bruker og applikasjon), `:62-65` (tildelingene røres ikke, og `bruker_er_deaktivert` stopper tilgangen ved neste tokenutstedelse); `A-ts/PersonbrukerDetails/components/PersonbrukerTopBar/PersonbrukerStatusActions.tsx:46,54-63` → `DeaktiverPersonbrukerModal`, `A-msg:213` |
| `@BRU-PER-GRU-004` | Reaktivere en deaktivert personbruker | funnet | Avgjort av brukeren: «Ja, implemented» — historikken er ikke en del av scenarioet. P: funnet · A: funnet — `P-svc/FeideBrukerStatusService.java:128-135` setter status Aktiv (`deaktivert_tidspunkt` nulles) og lar tildelingene stå, så de gjelder igjen; `A-ts/PersonbrukerDetails/components/PersonbrukerTopBar/PersonbrukerStatusActions.tsx:47,65-76`, `A-msg:225` («Tildelinger som løp ut mens brukeren var deaktivert, blir ikke aktive igjen»). Uklart: reaktiveringen nuller også hvem som deaktiverte (`:131-133`), og ingenting lagres om reaktiveringen. Scenarioet krever ikke historikk, men brukeren sa ved verifiseringen 2026-10-14 at «Reaktivering mangler historikk» |
| `@BRU-PER-GRU-004` | Deaktivering skiller seg fra fjerning av tildelinger | funnet | P: funnet · A: funnet — `P-svc/FeideBrukerStatusService.java:62-65` (deaktiveringen endrer bare `feide_bruker`, tildelingene står), `:119-135`; `A-msg:213,225` («fjernes ikke», «ingen tildelinger må gjøres på nytt») |
| `@BRU-PER-GRU-012` | Fjerne en rolle for valgt organisasjon og miljø | funnet | P: funnet · A: funnet — `P-db/0104-samlingstildelinger-i-rollelista.sql:345-353` (lukker bare raden med samme rolle, organisasjon og miljø); `A-roller/components/PersonbrukerRollerActions/actions/FjernRolleAction/FjernRolleAction.tsx:133-139` (kandidatene for den valgte kombinasjonen) |
| `@BRU-PER-GRU-012` | Fjerne en aktiv rolle fra en personbruker | funnet | P: funnet · A: funnet — `P-svc/FeideBrukerTilgangService.java:89` → `fjern_brukertilgang` (`P-db/0104-samlingstildelinger-i-rollelista.sql:292-363`); `FjernRolleAction.tsx:271-319` |
| `@BRU-PER-GRU-012` | Fjerne flere roller samtidig | funnet | P: funnet · A: funnet — `FjernRolleAction.tsx:173-176,286` (flere rader i ett kall), `:315-318` (delvis utfall per rad); `P-svc/FeideBrukerTilgangService.java:89` |
| `@BRU-PER-GRU-012` | Fjerning er ikke tilgjengelig for roller uten rettighet | funnet | P: funnet · A: funnet — `A-roller/PersonbrukerRoller.tsx:43-47` (handlingene skjules uten rollen); `FjernRolleAction.tsx:108-119` (organisasjon og miljø bare der retten til å fjerne fra personbrukere gjelder, mottaker `PERSONBRUKER`), `A-roller/hooks/useGetMineTildelingsorganisasjonerForPersonbrukere.tsx:15`; `P-svc/TildelingskilderConditions.java:117-141`; serveren avviser uten retten (`P-db/0104-samlingstildelinger-i-rollelista.sql:312-321`) |
| `@BRU-PER-GRU-012` | Fjerning er begrenset til organisasjoner jeg administrerer | funnet | P: funnet · A: funnet — samme som raden over: `useGetMineTildelingsorganisasjonerForPersonbrukere.tsx:13-24`, `P-schema/schema_exp.graphqls:15-22,86-96`, `P-svc/TildelingskilderConditions.java:53-55,135-141` |
| `@BRU-PER-GRU-012` | Valglisten for organisasjon viser bare organisasjoner der jeg kan fjerne roller fra personbrukere | funnet | P: funnet · A: funnet — `FjernRolleAction.tsx:108-109,181-185`, `useGetMineTildelingsorganisasjonerForPersonbrukere.tsx:15` (`mottaker: PERSONBRUKER`); `P-svc/TildelingskilderConditions.java:121-124` (bare personbrukerretten teller, ikke applikasjonsretten) |
| `@BRU-PER-GRU-012` | Valglisten for miljø avhenger av valgt organisasjon | funnet | P: funnet · A: funnet — `FjernRolleAction.tsx:116-119,159-165` (miljøene hentes for den valgte organisasjonen og nullstilles når den endres), `A-roller/hooks/useGetMineTildelingsmiljoer.tsx:13-21`; `P-schema/schema_personbruker_tilgang_med_nummer.graphqls:138-152`, `P-svc/TildelingskilderConditions.java:100-106` |
| `@BRU-PER-GRU-012` | Tilganger som kom fra rollen faller bort | funnet | P: funnet · A: ikke relevant — `P-db/0104-samlingstildelinger-i-rollelista.sql:157-176` (arvede rader avledes bare fra aktive rot-rader, `:131-132`), `:345-353` |
| `@BRU-PER-GRU-012` | Tilgang som også er tildelt direkte består | funnet | P: funnet · A: ikke relevant — `P-db/0104-samlingstildelinger-i-rollelista.sql:183-202` (den direkte raden står for seg), `:345-353` (fjerningen lukker bare rollens rad) |
| `@BRU-PER-GRU-007` | Se navn | funnet | P: funnet · A: funnet — `A-ts/PersonbrukerDetails/components/PersonbrukerDetaljer/PersonbrukerDetaljer.tsx:76-77` |
| `@BRU-PER-GRU-007` | Se Feide-ID | funnet | P: funnet · A: funnet — `PersonbrukerDetaljer.tsx:105`, `A-msg:109` |
| `@BRU-PER-GRU-007` | Se hjemorganisasjon | funnet | P: funnet · A: funnet — `P-schema/schema_brukeradmin.graphqls:258-265`; `PersonbrukerDetaljer.tsx:63-66,112-115` |
| `@BRU-PER-GRU-007` | Hjemorganisasjonen er ukjent | funnet | P: funnet · A: funnet — `P-schema/schema_brukeradmin.graphqls:261-263` (null når domenet ikke er registrert, uavhengig av tildelingene); `PersonbrukerDetaljer.tsx:64-66` viser «-» (`A-msg:115`) |
| `@BRU-PER-GRU-007` | Se status | funnet | P: funnet · A: funnet — `P-schema/schema_brukeradmin.graphqls:255`; `PersonbrukerDetaljer.tsx:84-87` |
| `@BRU-PER-GRU-001` | Se liste over personbrukere | funnet | P: funnet · A: funnet — `A-ts/PersonbrukereOverview/components/PersonbrukereResultList/PersonbrukereResultList.tsx:130,138,149,162` (Navn, Feide-ID, Hjemorganisasjon, Status), `A-ts/PersonbrukereOverview/hooks/useGetPersonbrukereState.tsx:46` (navn stigende) |
| `@BRU-PER-GRU-001` | Liste viser de 50 første personbrukerne | funnet | P: funnet · A: funnet — `useGetPersonbrukereState.tsx:48` (`initFirst: 50`), `PersonbrukereResultList.tsx:103-105` |
| `@BRU-PER-GRU-001` | Laste inn 50 flere personbrukere | funnet | P: funnet · A: funnet — `PersonbrukereResultList.tsx:105-107` |
| `@BRU-PER-GRU-001` | Alle personbrukere er lastet inn | funnet | P: funnet · A: funnet — `PersonbrukereResultList.tsx:105` (`hasNextPage`) |
| `@BRU-PER-GRU-001` | Navigere til detaljside for personbruker | funnet | P: ikke relevant · A: funnet — `PersonbrukereResultList.tsx:117` |
| `@BRU-PER-GRU-001` | Fritekst-søk på navn | funnet | P: funnet · A: funnet — `A-ts/PersonbrukereOverview/hooks/useGetPersonbrukere.tsx:108`; `P-svc/FeideBrukereFilterConditions.java:87` |
| `@BRU-PER-GRU-001` | Fritekst-søk på Feide-ID | funnet | P: funnet · A: funnet — `useGetPersonbrukere.tsx:109`; `P-svc/FeideBrukereFilterConditions.java:70` |
| `@BRU-PER-GRU-001` | Tilgjengelige statuser i filter | funnet | P: ikke relevant · A: funnet — `A-msg:63-66` (Status, «Alle statuser», Aktiv, Deaktivert), som 2026-10-14 |
| `@BRU-PER-GRU-001` | Filtrere på status | funnet | P: funnet · A: funnet — `useGetPersonbrukere.tsx:112-115` |
| `@BRU-PER-GRU-001` | Tilgjengelige hjemorganisasjoner i filter | funnet | P: funnet · A: funnet — `useGetPersonbrukere.tsx:47-56` (samme `skjulInaktiveFraAndreOrganisasjoner` som lista), `P-svc/FeideBrukereFilterConditions.java:278-299`; `A-msg:59-60`. Som 2026-10-22 |
| `@BRU-PER-GRU-001` | Filtrere på hjemorganisasjon | funnet | P: funnet · A: funnet — `useGetPersonbrukere.tsx:110`; `P-svc/FeideBrukereFilterConditions.java:120` |
| `@BRU-PER-GRU-001` | Tilgjengelige roller i filter | funnet | P: funnet · A: funnet — `A-ts/PersonbrukereOverview/hooks/useGetMineSynligeBrukerroller.tsx:11-13,37-38` (bare `FORRETNING`, altså roller); `P-schema/schema_brukeradmin.graphqls:81-89`, `P-svc/FeideBrukereFilterConditions.java:240-251` (aktive tildelinger til Feide-brukere kalleren ser); `A-msg:61-62` |
| `@BRU-PER-GRU-001` | Filtrere på rolle | funnet | P: funnet · A: funnet — `useGetPersonbrukere.tsx:111`; `P-svc/FeideBrukereFilterConditions.java:149-156` |
| `@BRU-PER-GRU-001` | Kombinere søk og filtre | funnet | P: funnet · A: funnet — `useGetPersonbrukere.tsx:105-117` (ett filterobjekt, alle kriteriene gjelder) |
| `@BRU-PER-GRU-001` | Brukeradministrator ser personbrukere med hjemorganisasjon i organisasjonene jeg administrerer | funnet | P: funnet · A: funnet — `P-db/0093-personbruker-oversikt.sql:153-155` (domenegrenen, uten miljø), `P-svc/FeideBrukereFilterConditions.java:203,206` (domenegrenen uten aktivitetskrav) |
| `@BRU-PER-GRU-001` | Brukeradministrator ser personbrukere fra andre organisasjoner med aktiv rolle i organisasjonene jeg administrerer | funnet | P: funnet · A: funnet — `P-svc/FeideBrukereFilterConditions.java:207-210` (aktiv tildeling av en rolle, `erRolle` `:220-225`, i et par av miljø og organisasjon der kalleren har `BRUKERADMIN_FEIDEBRUKER_LES`), sendt fra lista (`useGetPersonbrukere.tsx:56,116`); hjemorganisasjonen er brukerens egen (`PersonbrukereResultList.tsx:149`) |
| `@BRU-PER-GRU-001` | Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer | funnet | P: funnet · A: funnet — `P-svc/FeideBrukereFilterConditions.java:169-173,206-213`: en bruker fra en annen organisasjon som bare har tilganger, eller utløpte roller, faller bort. RLS-policyen viser dem fortsatt (`P-db/0093-personbruker-oversikt.sql:150-152`), med vilje, så de kan reaktiveres |
| `@BRU-PER-GRU-001` | Personbrukere med annen hjemorganisasjon er ikke synlige når rollen gjelder i et miljø jeg ikke administrerer | funnet | P: funnet · A: funnet — `P-svc/FeideBrukereFilterConditions.java:204,208-209` (`row(miljokode, organisasjonskode).in(minePar)`) |
| `@BRU-PER-GRU-003` | Tildele en rolle for valgt organisasjon og miljø | funnet | P: funnet · A: funnet — `A-roller/components/PersonbrukerRollerActions/actions/TildelRolleAction/TildelRolleAction.tsx:317-322,365-395`; `P-svc/FeideBrukerTilgangService.java:62` → `P-db/0102-tildeling-med-fodselsnummer.sql:33-97` |
| `@BRU-PER-GRU-003` | Organisasjon er implisitt når administrator administrerer kun én organisasjon | funnet | P: funnet · A: funnet — `TildelRolleAction.tsx:133-137,193,370` (én organisasjon er forhåndsvalgt og låst) |
| `@BRU-PER-GRU-003` | Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer | funnet | P: funnet · A: funnet — `TildelRolleAction.tsx:111-112`, `useGetMineTildelingsorganisasjonerForPersonbrukere.tsx:15` (`mottaker: PERSONBRUKER`); `P-svc/TildelingskilderConditions.java:53-55,121-124`. Forrige gang usikker fordi applikasjonsretten også talte; nå teller bare personbrukerretten |
| `@BRU-PER-GRU-003` | Personbrukerens hjemorganisasjon er forhåndsvalgt | funnet | P: funnet · A: funnet — `TildelRolleAction.tsx:132-144` (hjemorganisasjonen velges når den er blant organisasjonene), `:174-180` (kan byttes) |
| `@BRU-PER-GRU-003` | Ingen organisasjon er forhåndsvalgt uten en hjemorganisasjon jeg administrerer | funnet | P: ikke relevant · A: funnet — `TildelRolleAction.tsx:138` (`find` gir ingen treff både når hjemorganisasjonen er ukjent og når den ikke er blant organisasjonene), `:139-144` |
| `@BRU-PER-GRU-003` | Tildele en rolle til en personbruker | funnet | P: funnet · A: funnet — `P-db/0102-tildeling-med-fodselsnummer.sql:92-94` (ny rad med åpen periode fra nå); `P-schema/schema_brukeradmin.graphqls:459,461` (tildelt av, tildelt tidspunkt); `TildelRolleAction.tsx:317-349` |
| `@BRU-PER-GRU-003` | Tildele flere roller samtidig | funnet | P: funnet · A: funnet — `TildelRolleAction.tsx:386-395` (flervalg), `:317-322`; hver rolle blir sin egen rad (`P-db/0102-tildeling-med-fodselsnummer.sql:92-94`) |
| `@BRU-PER-GRU-003` | Delvis suksess ved samtidig tildeling av roller | funnet | P: funnet · A: funnet — `TildelRolleAction.tsx:77-82` (ett rotfelt per rolle), `:351-354`, `:413-470` (tildelte og avviste, med årsak per rad) |
| `@BRU-PER-GRU-003` | Valglisten for rolle avhenger av valgt organisasjon og miljø | usikker | Brukeren svarte «Vet ikke». P: delvis · A: funnet — `TildelRolleAction.tsx:148-154` (lista hentes for paret), `useTildelbareBrukerTilgangskoder.tsx:57-67`; `P-svc/TildelingskilderConditions.java:57-67`: «Retten gjelder hele katalogen; modellen har ikke rett per rolle», så lista er tom uten retten i paret, og ellers hele katalogen (i fanens navneromstyper). Om det er «roller jeg har rettighet til å tildele», avhenger av det åpne spørsmålet om hva rettigheten består i (`tildele_roller.feature:110`) |
| `@BRU-PER-GRU-003` | Valglisten for rolle viser bare forretningsroller | funnet | P: funnet · A: funnet — `A-roller/hooks/useGetPersonbrukerRollerTypes.ts:65-66` (Roller-fanen = `FORRETNING`), `useTildelbareBrukerTilgangskoder.tsx:64`; `P-svc/TildelingskilderConditions.java:68-73` |
| `@BRU-PER-GRU-003` | Utgåtte roller vises ikke i valglisten for rolle | funnet | P: funnet · A: funnet — `useTildelbareBrukerTilgangskoder.tsx:65` (`skjulUtgatte: true`); `P-svc/TildelingskilderConditions.java:74-77` (`utgatt_tidspunkt` passert), `P-schema/schema_personbruker_tilgang_med_nummer.graphqls:176-180` |
| `@BRU-PER-GRU-003` | Allerede tildelt rolle vises som ikke-valgbar | funnet | P: funnet · A: funnet — `TildelRolleAction.tsx:221-249` (direkte tildelte er `disabled` og merket «allerede tildelt», `A-msg:164`) |
| `@BRU-PER-GRU-008` | Se brukerens roller med «Gjelder for» | funnet | P: funnet · A: funnet — `A-roller/components/PersonbrukerRollerResultList/PersonbrukerRollerResultList.tsx:201-206` (Navn og Beskrivelse), `:213-225` (Gjelder for), `:226`, `:229`, `:234` (Miljø, Tildelt av, Tildelt dato); `A-msg:133-140`. Forrige gang ikke funnet (kolonnen het «Organisasjon») |
| `@BRU-PER-GRU-008` | Filtrere på navn | funnet | P: funnet · A: funnet — `A-roller/hooks/useGetPersonbrukerRoller.tsx:133`, `A-msg:118` |
| `@BRU-PER-GRU-008` | Tilgjengelige organisasjoner i filter | funnet | P: funnet · A: funnet — `A-roller/hooks/useGetPersonbrukerTilgangerFilterOptions.tsx:41,69` (fanens navneromstyper sendes med), `:85-95` (sortert); `P-schema/schema_brukeradmin.graphqls:266-277` (hver organisasjon én gang); «Alle organisasjoner» (`PersonbrukerRollerOrganisasjonFilter.tsx:69`, `A-msg:122`). Forrige gang usikker fordi tilgangene talte med; nå avgrenset til roller |
| `@BRU-PER-GRU-008` | Filtrere på organisasjon | funnet | P: funnet · A: funnet — `useGetPersonbrukerRoller.tsx:135` |
| `@BRU-PER-GRU-008` | Organisasjonene i filteret vises med akronym | ikke funnet | P: funnet · A: mangler — filteret er en `Select` med bare navn eller organisasjonskode (`PersonbrukerRollerOrganisasjonFilter.tsx:56-59,66-73`), og spørringen henter ikke `forkortelse` (`useGetPersonbrukerTilgangerFilterOptions.tsx:41-47`). Akronymet finnes i API-et, og vises i Tildel-dialogen (`TildelRolleAction.tsx:196-200`) — søkt etter «forkortelse», «akronym», «FSCombobox» i `A-roller/components/PersonbrukerRollerFilter/` og i filterkilden |
| `@BRU-PER-GRU-008` | Søke i organisasjonsfilteret | ikke funnet | P: ikke relevant · A: mangler — `Select` uten søk (`PersonbrukerRollerOrganisasjonFilter.tsx:66-73`) — søkt etter «FSCombobox», «searchable», «søk» i `A-roller/components/PersonbrukerRollerFilter/` |
| `@BRU-PER-GRU-008` | Tilgjengelige miljøer i filter | funnet | P: funnet · A: funnet — `useGetPersonbrukerTilgangerFilterOptions.tsx:36,80-83` (fanens navneromstyper, sortert); `P-schema/schema_brukeradmin.graphqls:279-287`; «Alle miljøer» (`A-msg:120`) |
| `@BRU-PER-GRU-008` | Filtrere på miljø | funnet | P: funnet · A: funnet — `useGetPersonbrukerRoller.tsx:134` |
| `@BRU-PER-GRU-008` | Kombinere filtre | funnet | P: funnet · A: funnet — `useGetPersonbrukerRoller.tsx:132-135` (ett filterobjekt) |

## Kontroll

Kontrollen endret ingen resultater.

## Forslag til endringer

**Kan leveres**

- `@BRU-PER-GRU-001` — Scenario: Brukeradministrator ser personbrukere fra andre organisasjoner med aktiv rolle i organisasjonene jeg administrerer (`krav/…/søke_opp_bruker.feature:136`, `@planned` fjernes, 1/1 funnet)
- `@BRU-PER-GRU-001` — Scenario: Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer (`krav/…/søke_opp_bruker.feature:153`, `@planned` fjernes, 1/1 funnet)
- `@BRU-PER-GRU-001` — Scenario: Personbrukere med annen hjemorganisasjon er ikke synlige når rollen gjelder i et miljø jeg ikke administrerer (`krav/…/søke_opp_bruker.feature:169`, `@planned` fjernes, 1/1 funnet)
- `@BRU-PER-GRU-012` — Regel: Valglistene følger rettigheten til å fjerne roller fra personbrukere (`krav/…/fjerne_roller.feature:62`, `@planned` fjernes, 2/2 funnet)
- `@BRU-PER-GRU-004` — Aktivere og deaktivere en personbrukers samlede tilganger (`krav/…/aktivere_og_deaktivere_bruker.feature`, `@in-progress` → `@implemented`, 3/3) — bare hvis «Reaktivere en deaktivert personbruker» avgjøres som funnet
- `@BRU-PER-GRU-003` — Tildele roller til en personbruker (`krav/…/tildele_roller.feature`, `@planned` → `@implemented`, 12/12) — bare hvis «Valglisten for rolle avhenger av valgt organisasjon og miljø» avgjøres som funnet. `@draft`-scenarioet på linje 85 står urørt

**Delvis levert**

- `@BRU-PER-GRU-004` — Aktivere og deaktivere en personbrukers samlede tilganger (`krav/…/aktivere_og_deaktivere_bruker.feature`, `@in-progress` blir stående, 2/3 funnet) — `@implemented` på: Scenario: Deaktivere en personbruker med aktive tildelinger (linje 15), Regel: Skille mellom deaktivering og fjerning (linje 31). Gjelder hvis reaktiveringen avgjøres som ikke funnet
- `@BRU-PER-GRU-003` — Tildele roller til en personbruker (`krav/…/tildele_roller.feature`, `@planned` → `@in-progress`, 11/12 funnet) — `@implemented` på: Regel: En tildeling gjelder én rolle for en organisasjon og et miljø (linje 13), Regel: Tildelingen gjelder en organisasjon administratoren har rettighet for (linje 20), Regel: En eller flere roller kan tildeles i én operasjon (linje 50), Scenario: Valglisten for rolle viser bare forretningsroller (linje 78), Regel: Utgåtte roller kan ikke tildeles (linje 93), Regel: En rolle som allerede er tildelt for samme organisasjon og miljø kan ikke tildeles på nytt (linje 100). Gjelder hvis rollelista avgjøres som ikke funnet

**Kan slettes**

- `@BRU-PER-GRU-001` — Scenario: Brukeradministrator ser personbrukere med datatilgang fra egne organisasjoner (`krav/…/søke_opp_bruker.feature:126-134`, blokken) — ingen spor i lista i fs-plattform og fs-admin: lista krever nå en aktiv **rolle** fra en annen organisasjon (`P-svc/FeideBrukereFilterConditions.java:207-210,220-225`), og en tilgang alene gir ikke lenger synlighet. RLS-policyen viser fortsatt brukeren (`P-db/0093-personbruker-oversikt.sql:150-152`), med vilje, for reaktivering. Søkt etter «skjulInaktiveFraAndreOrganisasjoner», «erRolle», «FORRETNING», «feide_bruker_les» · referanser som fjernes: ingen

**Blir stående**

- `@BRU-PER-GRU-008` — Scenario: Organisasjonene i filteret vises med akronym og Scenario: Søke i organisasjonsfilteret (`@planned`, 0/2 funnet) — filteret i Roller-fanen er en vanlig nedtrekksliste uten akronym og søk
- `@BRU-PER-GRU-001` — Scenario: Personbrukere uten tilknytning til egne organisasjoner er ikke synlige (`@deprecated`, linje 145) — finnes fortsatt, som en del av de nye scenarioene
- `@BRU-PER-GRU-001` — Scenario: Personbrukere med datatilgang i et miljø jeg ikke administrerer er ikke synlige (`@deprecated`, linje 161) — finnes fortsatt, som en del av de nye scenarioene
- `@BRU-PER-GRU-007` — Se detaljer for personbruker (`@implemented`, 5/5 funnet) — allerede levert, ingen endring

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@BRU-PER-GRU-004` | Aktivere og deaktivere en personbrukers samlede tilganger | `aktivere_og_deaktivere_bruker.feature` | `@in-progress` | 3/3 |
| `@BRU-PER-GRU-012` | Regel: Valglistene følger rettigheten til å fjerne roller fra personbrukere | `fjerne_roller.feature` | `@planned` | 2/2 |

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@BRU-PER-GRU-001` | Scenario: Brukeradministrator ser personbrukere fra andre organisasjoner med aktiv rolle i organisasjonene jeg administrerer | `@planned` | 1/1 | Alt funnet. Brukeren svarte «Vet ikke» |
| `@BRU-PER-GRU-001` | Scenario: Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer | `@planned` | 1/1 | Alt funnet. Brukeren svarte «Vet ikke» |
| `@BRU-PER-GRU-001` | Scenario: Personbrukere med annen hjemorganisasjon er ikke synlige når rollen gjelder i et miljø jeg ikke administrerer | `@planned` | 1/1 | Alt funnet. Brukeren svarte «Vet ikke» |
| `@BRU-PER-GRU-003` | Tildele roller til en personbruker | `@planned` | 11/12 | 0 ikke funnet, 1 usikker. Brukeren svarte «Vet ikke» om rollelista, delvis levert er ikke gjort |
| `@BRU-PER-GRU-008` | Scenario: Organisasjonene i filteret vises med akronym | `@planned` | 0/1 | 1 ikke funnet |
| `@BRU-PER-GRU-008` | Scenario: Søke i organisasjonsfilteret | `@planned` | 0/1 | 1 ikke funnet |

## Slettet

Ingen. `@BRU-PER-GRU-001` «Brukeradministrator ser personbrukere med datatilgang fra egne organisasjoner» (`søke_opp_bruker.feature:126`) er beholdt: brukeren svarte «Vet ikke».

## @deprecated som fortsatt finnes i koden

- **`@BRU-PER-GRU-001` — Scenario: Personbrukere uten tilknytning til egne organisasjoner er ikke synlige** (`søke_opp_bruker.feature`)
  - `P-svc/FeideBrukereFilterConditions.java:206-213` — en bruker fra en annen organisasjon uten aktiv rolle hos kalleren vises ikke. Oppførselen er en del av det nye scenarioet «… ikke synlige uten aktiv rolle …», så koden blir ikke borte
- **`@BRU-PER-GRU-001` — Scenario: Personbrukere med datatilgang i et miljø jeg ikke administrerer er ikke synlige** (`søke_opp_bruker.feature`)
  - `P-svc/FeideBrukereFilterConditions.java:204,208-209` — parsjekken på miljø og organisasjon. Oppførselen er en del av det nye scenarioet «… når rollen gjelder i et miljø jeg ikke administrerer»

## Oppfølging

- **Historikk ved reaktivering:** `@BRU-PER-GRU-004` er levert etter beslutning fra brukeren. Reaktiveringen nuller hvem som deaktiverte og når (`P-svc/FeideBrukerStatusService.java:131-133`), og ingenting lagres om reaktiveringen. Skal det være sporbart, skrives det som et nytt krav eller en ny del med `fs-krav`, f.eks. i `2 - Historikk/brukerhistorikk.feature`.
- **Ikke avgjort:** de tre `@planned`-scenarioene i `@BRU-PER-GRU-001` (alt funnet), rollelista i `@BRU-PER-GRU-003` (det åpne spørsmålet om hva rettigheten består i, `tildele_roller.feature:110`), og slettingen av `@deprecated`-scenarioet på `søke_opp_bruker.feature:126`. Kan tas med en gjennomgang av denne rapporten.
- **De to `@deprecated`-scenarioene som består:** linje 145 og 161 i `søke_opp_bruker.feature` blir aldri «ingen spor funnet», fordi de nye scenarioene som erstatter dem, gjør det samme og mer. Fjern dem med `fs-krav` når de nye er levert.
- **Sortering på navn:** fs-admin sender nå sortering på navn i begge retninger (`A-ts/PersonbrukereOverview/hooks/useGetPersonbrukere.tsx:59-77`). Om sorteringskontrollen er tilbake i lista, er ikke sjekket. Det åpne spørsmålet ved «Velge sorteringsretning for navn» (`@draft`, `søke_opp_bruker.feature:25-28`) kan være utdatert.
- **Tildeling av en rolle som ikke er en forretningsrolle:** `tildel_brukertilgang` sjekker ikke navneromstypen (`P-db/0102-tildeling-med-fodselsnummer.sql:33-97`). Det gjelder `@draft`-scenarioet i `tildele_roller.feature:85`, som ikke er med i denne kjøringen.
- **Åpent spørsmål:** `@BRU-PER-GRU-001` «Velge sorteringsretning for navn» og «Sist brukt-kolonne og sortering» — `@draft @openquestion`, utenfor gating-settet.
- **Åpne spørsmål uten tag:** `aktivere_og_deaktivere_bruker.feature:39-43`, `tildele_roller.feature:108-113`, `søke_opp_bruker.feature:197-200`, `vise_roller.feature:88-90` har en `# ÅPNE SPØRSMÅL:`-blokk nederst i fila uten `@openquestion`. Spørsmål 2 i `tildele_roller.feature` (hva rettigheten består i) avgjør den usikre raden for `@BRU-PER-GRU-003`.
- **Krav utenfor scope:** `fjerne_tilganger.feature` (`@draft`), `sette_stedkoder_for_tilgang.feature` (`@draft`), `sette_tidsbegrensning_for_tilgang.feature` (`@draft`), `synkronisere_roller_fra_namespace.feature` (`@draft`), `tildele_tilganger.feature` (`@draft`), `vise_tilganger.feature` (`@draft`) — henvis til `fs-krav`.
