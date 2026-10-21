# Verifisering: krav/02 Opptak/12 Utdanningstilbud/02 Utdanningstilbud i opptak

- **Dato:** 2026-10-21 10:14
- **Krav:** `krav/02 Opptak/12 Utdanningstilbud/02 Utdanningstilbud i opptak/` (4 feature-filer)
- **Kode:** `fs-plattform` (main, 70e70de1e9, oppdatert), `fs-admin` (main, 5fa2fe0e4, oppdatert)
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 11 kontrollører (`fs-verify-kontroll`), 2–7 feature-filer per finner
- **Skjermbilder:** nei (chrome-devtools-MCP finnes ikke i økta)

Gating-sett: alle scenarioene i scope, også `@draft`, `@planned` og `@openquestion`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `P-skj` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `P-mut` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudMutations.java`
- `P-svc` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`
- `P-mig` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `P-ureg` = `fs-plattform/utdanningsregisteret/utdanningsregisteret-graphql-spec/src/main/resources/schema/features/beta`
- `P-doc` = `fs-plattform/opptak/docs/krav-11-opptak-ikke-dekket.md`
- `A-osa` = `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakSøknadsalternativer`
- `A-add` = `fs-admin/src/domains/opptak/features/AddUtdanningstilbud`
- `A-det` = `fs-admin/src/domains/opptak/features/UtdanningstilbudDetails`
- `A-res` = `fs-admin/src/domains/opptak/components/UtdanningstilbudResultList`
- `A-msg` = `fs-admin/src/common/messages/nb`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud fra opptak | 5/8 | fs-plattform, fs-admin | Redigeringsfristen håndheves ikke, og API-et lar en deltakende organisasjon fjerne en annen organisasjons tilbud. fs-admin viser «Fjern utdanningstilbud» også etter at opptaket er publisert. |
| `@OPT-OPT-UTD-002` | Legge til utdanningstilbud i opptak | 3/14 | fs-plattform, fs-admin | Redigeringsperioden håndheves ikke. Det finnes ikke filter på utdanningstype eller NKR 5.1/5.2, ingen «legg til alle», ingen sjekk i API-et av at tilbyderen deltar, og ingen automatisk oppdatering fra utdanningsregisteret. |
| `@OPT-OPT-UTD-001` | Listevisning og søk i utdanningstilbud i opptaket | 6/13 | fs-plattform, fs-admin | Opptaket har ingen kriterier for utdanningstype og -nivå, en deltakende organisasjon ser alle organisasjoners tilbud, og flere filtre for ufullstendige opplysninger mangler. |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud fra opptak | 2/5 | fs-plattform, fs-admin | Deltakende organisasjoner har ikke trekk-knappen, trukne tilbud står umerket i lista, og søkere varsles ikke. |

Gjenstår: fs-plattform, fs-admin 4, ingen 0.

## Oppsummering

- Scenarioer: 16 funnet, 20 ikke funnet, 4 usikker, av 40
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 4
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform og **A** for fs-admin, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud før søknadsåpning | funnet | P: funnet · A: funnet — `P-mut:1086-1124` sletter når opptaket er upublisert (`slettUtdanningstilbudV3`, `P-skj/opptak/utdanningstilbud.graphqls:27-36`); «Fjern utdanningstilbud» i `A-osa/components/UtdanningstilbudActions/UtdanningstilbudActions.tsx:122-130`, `A-osa/components/SlettBody/SlettBody.tsx:11-32`, `A-osa/hooks/useUtdanningstilbudBatchActions.ts:526-560` |
| `@OPT-OPT-UTD-026` | Fjerne flere utdanningstilbud av gangen før søknadsåpning | funnet | P: funnet · A: funnet — `P-skj/opptak/utdanningstilbud.graphqls:212-216` (liste), `P-mut:1087-1091`; `A-osa/hooks/useUtdanningstilbudBatchActions.ts:535-537` sender alle radene som er valgt |
| `@OPT-OPT-UTD-026` | Muligheten til å fjerne utdanningstilbud vises ikke etter søknadsåpning | ikke funnet | P: ikke relevant · A: mangler — handlingen vises ut fra tilgang alene (`A-osa/OpptakSøknadsalternativer.tsx:134-150`). Søkt etter «UPUBLISERT», «opptaksstatus», «erPublisert», «status» i `fs-admin/src/domains/opptak`: ingenting skjuler handlingen |
| `@OPT-OPT-UTD-026` | Fjerning av utdanningstilbud etter søknadsåpning avvises | funnet | P: funnet · A: ikke relevant — `P-mut:1108-1116` kaster `UtdanningstilbudOpptakErPublisertException` før noe slettes |
| `@OPT-OPT-UTD-026` | Deltakende organisasjon fjerner eget utdanningstilbud før redigeringsfristen | funnet | P: funnet · A: funnet — slettepolicyen `P-mig/V280__opptak_v2_skjema.sql:1182-1187` slipper inn deltakere (`P-mig/V300__rls_over_paa_auth_claims.sql:52-69`); `A-osa/OpptakSøknadsalternativer.tsx:66-78`, `A-res/rowIsModifiable.ts:5-13`. Redigeringsfristen sjekkes ikke |
| `@OPT-OPT-UTD-026` | Deltakende organisasjon kan ikke fjerne eget utdanningstilbud etter redigeringsfristen | ikke funnet | P: mangler · A: mangler — `P-mut:1086-1124` sjekker bare status og tilgang. `P-doc:19` sier at `REDIGERING_STUDIER_ÅPNER` og `REDIGERING_STUDIER_FRIST` ikke håndheves. Søkt etter «redigeringsfrist», «REDIGERING_STUDIER», «REDIGERING» i begge repoene |
| `@OPT-OPT-UTD-026` | Deltakende organisasjon kan ikke fjerne utdanningstilbud en annen organisasjon tilbyr | ikke funnet | P: mangler · A: funnet — fs-admin lar ikke deltakeren velge andre organisasjoners rader (`A-res/rowIsModifiable.ts:5-13`). Slettepolicyen (`P-mig/V280__opptak_v2_skjema.sql:1182-1187`) sjekker ikke organisasjonen som tilbyr, og `ForvaltertilgangRLSIT.java:329-345` kaller det et kjent hull |
| `@OPT-OPT-UTD-026` | Forvaltende organisasjon fjerner utdanningstilbud etter redigeringsfristen | funnet | P: funnet · A: funnet — `P-mig/V300__rls_over_paa_auth_claims.sql:61-64`, `P-mut:1108-1116`; `A-osa/OpptakSøknadsalternativer.tsx:66-75` (eieren kan velge alle radene). Funnet fordi ingen redigeringsfrist håndheves |
| `@OPT-OPT-UTD-002` | Legge til alle utdanningstilbud fra organisasjonen opptaksforvalter er ved | usikker | P: funnet · A: delvis — `P-mut:131-159` tar en liste. fs-admin har ingen «legg til alle»: «Velg alle» velger bare radene som er lastet (`fs-admin/src/common/components/lists/components/HeaderSelection/HeaderSelection.tsx:36-50`, 50 per side), og opptakets kriterier er bare et standardfilter i koden (`A-add/hooks/useGetUtdanningsinstanserState.tsx:37-43`) |
| `@OPT-OPT-UTD-002` | Legge til enkelttilbud fra organisasjonen opptaksforvalter er ved | funnet | P: funnet · A: funnet — `P-mut:131-159`, `P-mig/V280__opptak_v2_skjema.sql:1160-1165`; `A-add/AddUtdanningstilbudForm.tsx:36-77`, `A-add/components/AddUtdanningstilbudAddButton.tsx:30-46`, `fs-admin/src/domains/opptak/utils/utdanningsinstansFilterUtil.ts:54-66` |
| `@OPT-OPT-UTD-002` | Legge til flere utdanningstilbud av gangen | funnet | P: funnet · A: funnet — `P-skj/opptak/utdanningstilbud.graphqls:178-184` (liste); `A-add/AddUtdanningstilbudResultList.tsx:72-75`, `A-add/components/AddUtdanningstilbudAddButton.tsx:30-41` |
| `@OPT-OPT-UTD-002` | Opptaksforvalter ved forvaltende organisasjon legger til utdanningstilbud for en annen organisasjon | funnet | P: funnet · A: funnet — `P-mig/V300__rls_over_paa_auth_claims.sql:59-63`; `fs-admin/src/domains/opptak/utils/utdanningsinstansFilterUtil.ts:60-63`, `A-add/AddUtdanningstilbudFilter.tsx:51-58` |
| `@OPT-OPT-UTD-002` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | ikke funnet | P: mangler · A: funnet — fs-admin viser bare deltakernes tilbud (`fs-admin/src/domains/opptak/utils/utdanningsinstansFilterUtil.ts:54-66`). Insert-policyen (`P-mig/V280__opptak_v2_skjema.sql:1160-1165`) sjekker ikke at organisasjonen som tilbyr, deltar, så det kan gjøres via API-et. `P-mig/V319__opptak_v2_skriving_krever_forvalter.sql:11-15` sier at sjekken kommer senere |
| `@OPT-OPT-UTD-002` | Filtrere på utdanningstype | ikke funnet | P: delvis · A: mangler — dialogen har ikke filter på utdanningstype (`A-add/AddUtdanningstilbudFilter.tsx:28-73`). Utdanningstype finnes bare på filteret for utdanningsmuligheter (`P-ureg/utdanningsmulighet.graphql:159-160`), ikke for utdanningsinstanser (`P-ureg/utdanningsinstans.graphql:155-180`) |
| `@OPT-OPT-UTD-002` | Filtrere på NKR-nivå for UHG-opptak | ikke funnet | P: delvis · A: delvis — studienivå finnes (`A-add/…/UtdanningsinstansStudienivaFilter.tsx:22-29`, NKR 6.1, 6.2 og 7 i `UtdanningsintansConditions.java:90-112`), men ikke utdanningstypen scenarioet starter med |
| `@OPT-OPT-UTD-002` | Filtrere på NKR-nivå for HYU-opptak | ikke funnet | P: delvis · A: mangler — NKR 5.1 og 5.2 mangler i studienivåfilteret (`P-ureg/utdanningsinstans.graphql:191-204`). Filteret `nkrkode` har dem (`:169`), men fs-admin bruker det ikke |
| `@OPT-OPT-UTD-002` | Utdanninger utenfor filteret vises ikke | ikke funnet | P: delvis · A: delvis — Bachelor utelater master (`UtdanningsintansConditions.java:99`), men emner kan ikke utelates uten et filter på utdanningstype |
| `@OPT-OPT-UTD-002` | Kan ikke knytte utdanningstilbud til opptaket før redigering åpner | ikke funnet | P: mangler · A: mangler — `REDIGERING_STUDIER_ÅPNER` og `REDIGERING_STUDIER_FRIST` er bare hendelsestyper (`P-skj/opptak/opptakshendelse.graphqls:255-256`) og fristkort i fs-admin. Ingen kode eller tilgangsregel leser dem (`P-doc:19`). Søkt etter «REDIGERING_STUDIER», «redigering», «kanRedigere» |
| `@OPT-OPT-UTD-002` | Kan knytte til og redigere utdanningstilbud i perioden opptaket er åpent for redigering | usikker | P: delvis · A: delvis — det virker, men bare fordi vinduet aldri leses (`A-det/UtdanningstilbudDetails.tsx:186`, `P-doc:37-39`) |
| `@OPT-OPT-UTD-002` | Kan ikke knytte til eller redigere utdanningstilbud etter at redigering stenger | ikke funnet | P: mangler · A: mangler — ingen sperre etter fristen (`P-doc:19`, `A-det/UtdanningstilbudDetails.tsx:186`) |
| `@OPT-OPT-UTD-002` | Opptaksforvalter ved forvaltende organisasjon kan redigere utdanningstilbud etter at redigering stenger | usikker | P: delvis · A: delvis — forvalteren kan redigere (`A-det/UtdanningstilbudDetails.tsx:168-170,186`, `P-mig/V307__opptak_v2_update_using_krever_modifisere.sql:62-66`), men fristen leses ikke for noen, så unntaket er ikke vist |
| `@OPT-OPT-UTD-002` | Endringer fra utdanningsregisteret oppdateres etter at redigering stenger | ikke funnet | P: delvis · A: mangler — `oppdaterUtdanningstilbudV3` (`P-mut:241-251`) henter på nytt fra utdanningsregisteret, men ingen jobb og ingen i fs-admin kaller den. Søkt etter «@Scheduled», «@Incoming», «oppdaterUtdanningstilbudV3» |
| `@OPT-OPT-UTD-001` | Se relevante utdanningstilbud | ikke funnet | P: mangler · A: delvis — opptaket har ingen kriterier for utdanningstype og -nivå. fs-admin viser aktive tilbud fra deltakerne (`A-add/hooks/useGetUtdanningsinstanser.tsx:142-150`) med et standardfilter brukeren kan endre. Søkt etter «kriterie», «tillatteStudie», «opptak_studieniva», «opptak_nkr», «utdanningstype» |
| `@OPT-OPT-UTD-001` | Se grunndata om utdanning | funnet | P: funnet · A: funnet — `P-skj/utdanningstilbudV2.graphqls:116`; `A-det/UtdanningstilbudDetails.tsx:632` («Kilde: Utdanningsregisteret»), navn `:636-662`, nivå `:668`, studiested `:692`, studiepoeng `:725` |
| `@OPT-OPT-UTD-001` | Filtrere på organisasjon som opptaksforvalter ved forvaltende organisasjon | funnet | P: funnet · A: funnet — `P-skj/utdanningstilbudV2.graphqls:234-235,329`; `A-osa/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:151-165`, `A-osa/hooks/useGetUtdanningstilbud.ts:15`. Filteret vises for alle i et samordna opptak |
| `@OPT-OPT-UTD-001` | Deltakende organisasjon ser kun utdanningstilbudene sine | ikke funnet | P: mangler · A: mangler — lesepolicyen er `USING (true)` (`P-mig/V280__opptak_v2_skjema.sql:1157-1158`), og fs-admin gjør bare andre organisasjoners rader umulige å velge (`A-res/rowIsModifiable.ts:5-13`, `A-res/UtdanningstilbudResultList.tsx:131-133`). Radene vises fortsatt |
| `@OPT-OPT-UTD-001` | Deltakende organisasjon ser ikke utdanningstilbud en annen organisasjon tilbyr | ikke funnet | P: mangler · A: mangler — samme bevis som raden over |
| `@OPT-OPT-UTD-001` | Filtrere på starttermin og startår | funnet | P: funnet · A: funnet — `P-skj/utdanningstilbudV2.graphqls:228-231,323-325`; `A-osa/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:207-233`, `A-osa/hooks/useGetUtdanningstilbud.ts:16-17` |
| `@OPT-OPT-UTD-001` | Fritekst-søk på studieprogramnavn | funnet | P: funnet · A: funnet — `P-svc/opptak/UtdanningstilbudV2Service.java:111-147`; `A-osa/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:83-93`, `A-osa/hooks/useGetUtdanningstilbud.ts:7,14` |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler kompetanseregelverk | funnet | P: funnet · A: funnet — `P-mig/V427__utdanningstilbud_status.sql:7,27` (status «Har mangler» uten kompetanseregelverk), `P-svc/opptak/UtdanningstilbudV2Service.java:65-70`; `A-osa/components/UtdanningstilbudFilter/filter/UtdanningstilbudStatusFilter/UtdanningstilbudStatusFilter.tsx:34` |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler rangeringsregelverk | funnet | P: funnet · A: funnet — `P-mig/V427__utdanningstilbud_status.sql:28`; samme filter i fs-admin |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler kvoter, kvoteprioritering eller plassflyt | ikke funnet | P: delvis · A: delvis — «Har mangler» gjelder bare tilbud uten kvoter (`P-mig/V427__utdanningstilbud_status.sql:29-32`). Kvoteprioritering og plassflyt er ikke med, og det finnes ikke noe annet filter (`P-skj/utdanningstilbudV2.graphqls:225-304`) |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler opplysninger om tilbudsgaranti | ikke funnet | P: mangler · A: mangler — ikke med i «Har mangler», og ikke noe filter. `MANGLER_TILBUDSGARANTI_KVOTE` er utgått og et avvik i rapporten fra tidlig opptak. Søkt etter «tilbudsgaranti», «manglerTilbudsgaranti», «ufullstendig» |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler dato for tidlig søknadsfrist | ikke funnet | P: mangler · A: mangler — `harTidligSoknadsfrist` og `hendelser` er felt (`P-skj/utdanningstilbudV2.graphqls:139,145`), men ikke filtre. fs-admin har bare «Tilbyr tidlig opptak» (`A-osa/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:178-188`) |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler poenggrense for tidlig opptak | ikke funnet | P: delvis · A: mangler — `MANGLER_POENGGRENSE` finnes bare i rapporten fra tidlig opptak (`P-skj/saksbehandling/tidligopptak-tilbudsgaranti-automatikk.graphqls:99`), og `tidligOpptakPoenggrense` (`P-skj/utdanningstilbudV2.graphqls:156`) er ikke et filter |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved deltakende organisasjon trekker utdanningstilbud organisasjonen tilbyr | ikke funnet | P: funnet · A: mangler — `trekkUtdanningstilbud` (`P-mut:1031-1050`) slipper inn deltakere (`P-mig/V307__opptak_v2_update_using_krever_modifisere.sql:62-66`). I fs-admin vises knappen bare for eieren av opptaket (`A-det/UtdanningstilbudDetails.tsx:201-210,867-868`) |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved forvaltende organisasjon trekker utdanningstilbud | funnet | P: funnet · A: funnet — `P-mut:1031-1050`; `A-det/…/TrekkUtdanningstilbudButton.tsx:57-111` med konsekvensen i modalen (`A-msg/opptak.json:449-463`) |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud før søknadsåpning | usikker | P: delvis · A: delvis — i et upublisert opptak slettes tilbudet (`P-mut:1086-1125`). I et publisert opptak setter trekk bare `trukket_tidspunkt` (`P-mut:1042-1047`), og lista i fs-admin bruker ikke `erTrukket` (`P-skj/utdanningstilbudV2.graphqls:268-272`), så tilbudet står umerket. Ingen av delene styres av søknadsåpningen |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud etter søknadsåpning | ikke funnet | P: delvis · A: delvis — modalen har samme tekst uansett (`A-msg/opptak.json:452`), og søkerne varsles ikke (søkt etter «tilbudTrukket», «UTDANNINGSTILBUD_TRUKKET», «TRUKKET_TIDSPUNKT»). Detaljsiden merker trukket (`A-det/UtdanningstilbudDetails.tsx:616,853-865`), lista ikke |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved deltakende organisasjon forsøker å trekke etter trekkfristen | funnet | P: funnet · A: funnet — `P-mut:1067-1083` avviser etter `FRIST_TREKKE_UTDANNINGSTILBUD`; `A-det/utils/trekk.ts:18-22` skjuler knappen, og feilteksten står i `A-msg/opptak.json:462` |

## Kontroll

Kontrollen endret ingen resultater.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud fra opptak | `@draft` | 5/8 | 3 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-002` | Legge til utdanningstilbud i opptak | `@draft` | 3/14 | 8 ikke funnet, 3 usikker |
| `@OPT-OPT-UTD-001` | Listevisning og søk i utdanningstilbud i opptaket | `@draft` | 6/13 | 7 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud fra opptak | `@draft` | 2/5 | 2 ikke funnet, 1 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Titler oppdatert:** feature-filene ble endret mens verifiseringen pågikk (2026-10-21 10:36–10:37: ordlyd og nye `@openquestion`). Scenariotitlene og egenskapstittelen i rapporten er oppdatert til den nye ordlyden. «Filtrere på utdanningstilbud som mangler kvoter, kvoteprioritering eller plassflyt» tar nå også med plassflyt, og resultatet `ikke funnet` gjelder fortsatt (plassflyt er heller ikke med i «Har mangler»).
- **Redigeringsfristen håndheves ikke:** `REDIGERING_STUDIER_ÅPNER` og `REDIGERING_STUDIER_FRIST` leses ikke av noen mutasjon eller tilgangsregel (`P-doc:19`). Det gjelder UTD-002 og UTD-026.
- **Hull i tilgangen i API-et:** en deltakende organisasjon kan endre, fjerne og trekke andre organisasjoners tilbud via API-et (`ForvaltertilgangRLSIT.java:329-345`, «kjent hull»), og legge til tilbud fra organisasjoner som ikke deltar (`P-mig/V319__opptak_v2_skriving_krever_forvalter.sql:11-15`). Bare fs-admin hindrer det.
- **Trekkfristen gjelder også forvalteren:** `P-mut:1067-1083` og `A-det/utils/trekk.ts` stopper også den forvaltende organisasjonen etter fristen, mens regelen i UTD-003 sier «for deltakende organisasjoner». Bør avklares.
- **Tilbud i bruk kan ikke fjernes:** et tilbud med kvoter eller plasstildelinger kan ikke fjernes (`UtdanningstilbudIBrukError`, `P-skj/opptak/utdanningstilbud.graphqls:954`). Det står ikke i UTD-026.
- **Åpent spørsmål besvart i koden:** UTD-026 spør om det skal være mulig å fjerne ett eller flere tilbud. Koden tillater begge.
- **Ikke sjekket:** min-kompetanse var ikke med. Det gjelder varsling av søkere i «Trekke utdanningstilbud etter søknadsåpning» (UTD-003).
