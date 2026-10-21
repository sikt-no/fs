# Verifisering: krav/02 Opptak/12 Utdanningstilbud/04 Behandle et utdanningstilbud

- **Dato:** 2026-10-21 10:14
- **Krav:** `krav/02 Opptak/12 Utdanningstilbud/04 Behandle et utdanningstilbud/` (19 feature-filer)
- **Kode:** `fs-plattform` (main, 70e70de1e9, oppdatert), `fs-admin` (main, 5fa2fe0e4, oppdatert)
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 11 kontrollører (`fs-verify-kontroll`), 2–7 feature-filer per finner
- **Skjermbilder:** nei (chrome-devtools-MCP finnes ikke i økta)

Gating-sett: alle scenarioene i scope, også `@draft`, `@planned` og `@openquestion`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `P-skj` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `P-svc` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`
- `P-mig` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `P-ureg` = `fs-plattform/utdanningsregisteret/utdanningsregisteret-graphql-spec/src/main/resources/schema/features/beta`
- `A-det` = `fs-admin/src/domains/opptak/features/UtdanningstilbudDetails`
- `A-msg` = `fs-admin/src/common/messages/nb`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-016` | Angi beskrivelse av utdanningstilbudet til Min kompetanse | 1/2 | min-kompetanse | Beskrivelsen per språk er i API-et. Om søkeren ser den i Min kompetanse, er ikke sjekket (repoet var ikke med). |
| `@OPT-OPT-UTD-022` | Angi informasjon om studieavgift | 2/2 | ingen | Begge scenarioene er funnet. fs-admin har bare ja/nei, mens fortellingen sier «om og hvor mye». |
| `@OPT-OPT-UTD-017` | Angi søkeord på utdanningstilbudet | 3/4 | fs-plattform, min-kompetanse | Søkeord kan legges til og fjernes. Søket for søkere treffer ikke på søkeord. |
| `@OPT-OPT-UTD-013` | Flytte registrering av kvoteflyt til opptaksinnstillinger | 0/2 | fs-plattform, fs-admin | Kvoteflyt (plassflyt) kan ikke settes i opptaksinnstillingene. Den står fortsatt på kvotetypen i regelverksamlingen. |
| `@OPT-OPT-UTD-023` | Kvalitetssikre studiestart på utdanningstilbudet | 0/2 | fs-plattform, fs-admin | Studiestart vises som termin fra utdanningsregisteret, og kan ikke korrigeres. Designet sier at den ikke kan overstyres. |
| `@OPT-OPT-UTD-015` | Overstyre regler for poenglikhet på utdanningstilbudet | 4/4 | ingen | Alt er funnet, også `@draft`-regelen. |
| `@OPT-OPT-UTD-012` | Registrere planlagt antall studieplasser | 2/2 | ingen | Begge scenarioene er funnet. |
| `@OPT-OPT-UTD-010` | Registrere poengopplysninger for utdanningstilbudet | 2/3 | fs-plattform, fs-admin | Median poengsum for fjoråret mangler i API-et, og fs-admin viser «Ikke tilgjengelig». |
| `@OPT-OPT-UTD-014` | Registrere påkrevde attester på utdanningstilbudet | 2/2 | ingen | Begge scenarioene er funnet. |
| `@OPT-OPT-UTD-011` | Registrere studienummer på utdanningstilbudet | 0/2 | fs-plattform, fs-admin | Uklart hva studienummer er: SHI-689 er bygget som studietypenummer, og «Studienummer» i fs-admin er koden fra utdanningsregisteret. |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet | 0/2 | fs-plattform, fs-admin | Fristene lagres, men brukes ikke for søkerne, og opptaket har ingen innstilling som åpner for frist per tilbud. |
| `@OPT-OPT-UTD-009` | Vise URL til beskrivelse av utdanningstilbudet | 2/2 | ingen | Begge scenarioene er funnet. |
| `@OPT-OPT-UTD-019` | Vise endringslogg for utdanningstilbudet | 0/2 | fs-plattform, fs-admin | Endringslogg for utdanningstilbud finnes ikke. |
| `@OPT-OPT-UTD-021` | Vise lenke til tidligere utdanningstilbud | 0/2 | fs-plattform, fs-admin | Kobling til et tidligere utdanningstilbud finnes ikke. |

Gjenstår: fs-plattform, fs-admin 7, fs-plattform, min-kompetanse 1, min-kompetanse 1, ingen 5.

## Oppsummering

- Scenarioer: 18 funnet, 9 ikke funnet, 6 usikker, av 33
- Krav levert (status satt til `@implemented`): 4
- Deler levert (status fjernet fra delen): 1
- Krav og deler som ikke er levert: 9
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform og **A** for fs-admin, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OPT-UTD-016` | Angi beskrivelse på <språk> | funnet | P: funnet · A: funnet — `P-skj/opptak/utdanningstilbud.graphqls:75` (`oppdaterUtdanningstilbudBeskrivelse`, språkene nb/nn/en/se i `P-skj/regelverk/regelverk.graphqls:40-49`), `P-svc/opptak/UtdanningstilbudMutations.java:176-189,1155-1169`; `A-det/types.ts:10`, `A-det/UtdanningstilbudDetails.tsx:893-944` (én fane per språk), `A-det/hooks/useUtdanningstilbudEndre.tsx:285-309` |
| `@OPT-OPT-UTD-016` | Søker ser beskrivelsen i Min kompetanse | usikker | P: funnet · A: ikke relevant — min-kompetanse ikke sjekket. `P-skj/utdanningstilbudV2.graphqls:94-104` (`beskrivelse`), `P-svc/…/OversatteTeksterService.java:198`. min-kompetanse var ikke med i kjøringen |
| `@OPT-OPT-UTD-022` | Registrere informasjon om studieavgift | funnet | P: funnet · A: funnet — `P-skj/opptak/utdanningstilbud.graphqls:357-361` (`studieavgift`), `P-svc/opptak/UtdanningstilbudMutations.java:977-979`; `A-det/UtdanningstilbudDetails.tsx:808-820` (Ja/Nei), `A-det/hooks/useUtdanningstilbudEndre.tsx:233-235,259-260`. Bare ja/nei, ikke beløp, i fs-admin |
| `@OPT-OPT-UTD-022` | Se informasjon om studieavgift | funnet | P: funnet · A: funnet — `P-skj/utdanningstilbudV2.graphqls:173-177`; `A-det/UtdanningstilbudDetails.tsx:821-825`, `A-det/UtdanningstilbudDetails.queries.ts:191` |
| `@OPT-OPT-UTD-017` | Legge til søkeord på utdanningstilbud | funnet | P: funnet · A: funnet — `P-skj/opptak/utdanningstilbud.graphqls:350-356` (`sokeord`), `P-svc/opptak/UtdanningstilbudMutations.java:1012-1014,1192-1208`, `P-mig/V436__utdanningstilbud_sokeord.sql:9`; `A-det/UtdanningstilbudDetails.tsx:948-987` («Tags», `A-msg/opptak.json:398`), `A-det/hooks/useUtdanningstilbudEndre.tsx:231,258` |
| `@OPT-OPT-UTD-017` | Legge til flere søkeord på samme utdanningstilbud | funnet | P: funnet · A: funnet — `P-skj/opptak/utdanningstilbud.graphqls:356` (liste, høyst 20), `P-svc/opptak/UtdanningstilbudMutations.java:1199`; `A-det/UtdanningstilbudDetails.tsx:949,997-1007` |
| `@OPT-OPT-UTD-017` | Fjerne søkeord fra utdanningstilbud | funnet | P: funnet · A: funnet — `P-svc/opptak/UtdanningstilbudMutations.java:1192-1208` (erstatter lista); `A-det/UtdanningstilbudDetails.tsx:956-964`, `A-det/hooks/useUtdanningstilbudEndre.tsx:231,258` |
| `@OPT-OPT-UTD-017` | Søker finner utdanningstilbud via søkeord | ikke funnet | P: mangler · A: ikke relevant — min-kompetanse ikke sjekket. fritekstsøket `utdanningstilbudSok` (`P-svc/opptak/UtdanningstilbudV2Service.java:128-147`) treffer navn, regelverkskoder og kvotetype, ikke søkeord. Søkeordene leses bare av forslagslista (`P-svc/…/UtdanningstilbudSokeordService.java:46`). Søkt etter «sokeord», «søkeord», «soekeord», «keyword» i hele fs-plattform |
| `@OPT-OPT-UTD-013` | Registrere kvoteflyt i opptaksinnstillinger | ikke funnet | P: mangler · A: mangler — kvoteflyt heter plassflyt i koden, og settes på kvotetypen i regelverksamlingen (`P-skj/regelverk/kvote.graphqls:154,180,211`). Ingenting på opptaket. Søkt etter «kvoteflyt», «kvote_flyt», «plassflyt», «overstyrer», «flyt», «quota flow» i begge repoene, også meldingsfilene |
| `@OPT-OPT-UTD-013` | Kvoteflyt kan ikke registreres på utdanningstilbudet | usikker | P: funnet · A: funnet — ingen input setter plassflyt per kvote (`P-skj/opptak/utdanningstilbud.graphqls:394-408,435-445,451-463`), og kvotelista i `A-det/UtdanningstilbudDetails.tsx:1352-1421` har ingen flyt. Sant bare fordi feltet mangler, siden flyttingen i scenarioet over ikke er gjort |
| `@OPT-OPT-UTD-023` | Se foreslått studiestart for utdanningstilbudet | usikker | P: delvis · A: delvis — `A-det/UtdanningstilbudDetails.tsx:752-763` viser «Studiestart» som termin og år fra utdanningsregisteret, skrivebeskyttet (`P-skj/utdanningstilbudV2.graphqls:115-116`). Ikke en dato, og ikke merket som et forslag |
| `@OPT-OPT-UTD-023` | Korrigere studiestart når forslaget er feil | ikke funnet | P: mangler · A: mangler — ingen mutasjon eller felt for å korrigere. Oppstart skrives bare av synken fra utdanningsregisteret (`P-svc/…/UregStudieprogramService.java:192,229`). Søkt etter «studiestart», «oppstartsdato», «startdato», «oppstart», «semesterstart», «foreslått». `tasks/opptak/utdanningstilbud/design.md:182` sier at oppstartstermin ikke kan overstyres |
| `@OPT-OPT-UTD-015` | Se standardregel for poenglikhet | funnet | P: funnet · A: funnet — `P-skj/opptak/opptak.graphqls:277-278`, `P-skj/utdanningstilbudV2.graphqls:186-195`, `P-svc/regelverk/poeng/PoenglikhetService.java:137-141` (tilbudets regel, ellers opptakets standard); `A-det/UtdanningstilbudDetails.tsx:1104-1107`, `:394-403` («(standard for opptaket)») |
| `@OPT-OPT-UTD-015` | Overstyre regel for poenglikhet | funnet | P: funnet · A: funnet — `P-skj/opptak/utdanningstilbud.graphqls:114-117`, `P-svc/opptak/UtdanningstilbudMutations.java:895-937`; `A-det/UtdanningstilbudDetails.tsx:1093-1103`, `A-det/hooks/useUtdanningstilbudEndre.tsx:271-283` |
| `@OPT-OPT-UTD-015` | Kun regler tilgjengelige for opptaket kan velges | funnet | P: funnet · A: funnet — `P-mig/V379__tillatte_poenglikhetsregler_pa_opptak.sql:73-77` (fremmednøkkel til opptakets tillatte regler), `P-svc/opptak/UtdanningstilbudMutations.java:917-923`; `A-det/UtdanningstilbudDetails.tsx:387-403` |
| `@OPT-OPT-UTD-015` | Kan ikke overstyre regel for poenglikhet når opptaket ikke åpner for unntak | funnet | P: funnet · A: funnet — `P-mig/V379__tillatte_poenglikhetsregler_pa_opptak.sql:13,73-77` (bare standarden i lista betyr at tilbudene ikke kan overstyre), `P-svc/…/OpprettOpptakMutations.java:507-533`; `A-det/UtdanningstilbudDetails.tsx:389-393,1093-1107` (`kanOverstyrePoenglikhet` er false, og feltet vises bare som tekst) |
| `@OPT-OPT-UTD-012` | Registrere planlagt antall studieplasser | funnet | P: funnet · A: funnet — `P-skj/opptak/utdanningstilbud.graphqls:348-349` (`antallStudieplasser`, 0–9999), `P-svc/opptak/UtdanningstilbudMutations.java:962-966,973-976`; `A-det/UtdanningstilbudDetails.tsx:1303-1316`, `A-det/hooks/useUtdanningstilbudEndre.tsx:228-257` |
| `@OPT-OPT-UTD-012` | Se planlagt antall studieplasser | funnet | P: funnet · A: funnet — `P-skj/utdanningstilbudV2.graphqls:125`; `A-det/UtdanningstilbudDetails.queries.ts:186`, `A-det/UtdanningstilbudDetails.tsx:1317-1324` |
| `@OPT-OPT-UTD-010` | Se median poengsum for fjorårets opptatte | ikke funnet | P: mangler · A: delvis — `A-det/UtdanningstilbudDetails.tsx:1249-1258` «Median i fjor» viser alltid «Ikke tilgjengelig» (TODO SHI-660). Ingen median i fs-plattform på main. Søkt etter «median», «fjorår», «fjorar», «lastyear», «poengsnitt». `KvoteV2.fjoraretsPoenggrense` er poenggrense per kvote, ikke median |
| `@OPT-OPT-UTD-010` | Registrere poenggrense for tidligopptak | funnet | P: funnet · A: funnet — `P-skj/opptak/utdanningstilbud.graphqls:52,246-251`, `P-svc/opptak/UtdanningstilbudMutations.java:294-305`; `A-det/UtdanningstilbudDetails.tsx:1259-1267`, `A-det/hooks/useUtdanningstilbudEndre.tsx:210-224` |
| `@OPT-OPT-UTD-010` | Se registrert poenggrense for tidligopptak | funnet | P: funnet · A: funnet — `P-skj/utdanningstilbudV2.graphqls:156`; `A-det/UtdanningstilbudDetails.queries.ts:185`, `A-det/UtdanningstilbudDetails.tsx:1268-1275` |
| `@OPT-OPT-UTD-014` | Registrere krav om politiattest | funnet | P: funnet · A: funnet — `P-mig/V445__utdanningstilbud_attest.sql:29-31,55-74` (attesttypen POLICE og politiattestkodene), `P-skj/opptak/attest.graphqls:3,37`, `P-svc/opptak/UtdanningstilbudAttestMutations.java:35-55,121-140`; `A-det/UtdanningstilbudDetails.tsx:324-338,1110-1119` («Attester»), `A-det/hooks/useUtdanningstilbudEndre.tsx:191-200` |
| `@OPT-OPT-UTD-014` | Registrere krav om medisinsk attest | funnet | P: funnet · A: funnet — `P-mig/V445__utdanningstilbud_attest.sql:29-30,55-56` (attesten MEDICAL), samme mutasjon; samme flervalg i `A-det/UtdanningstilbudDetails.tsx:1110-1119` |
| `@OPT-OPT-UTD-011` | Registrere studienummer på utdanningstilbud | usikker | P: delvis · A: delvis — finneren: ikke funnet, ingen felt for studienummer. Kontrollen: SHI-689 (Jira-saken i kravet) er bygget som studietypenummer: `P-skj/opptak/utdanningstilbud.graphqls:362-363` (`studietypeId`), `P-svc/opptak/UtdanningstilbudMutations.java:980-986`; `A-det/UtdanningstilbudDetails.tsx:789-797` («Studietypenummer»). Kravet spør selv hva studienummer er |
| `@OPT-OPT-UTD-011` | Se studienummer på utdanningstilbud | usikker | P: delvis · A: delvis — to felt: «Studienummer» i `A-det/UtdanningstilbudDetails.tsx:700-709` er koden for utdanningsmuligheten fra utdanningsregisteret (`P-ureg/utdanningsmulighet.graphql:24`), og «Studietypenummer» i `:799-806` er det SHI-689 bygde (`P-skj/utdanningstilbudV2.graphqls:118`). Avhenger av hva studienummer er |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist | usikker | P: delvis · A: delvis — fristen kan settes og lagres som hendelse på tilbudet (`A-det/UtdanningstilbudDetails.tsx:1166-1204`, `A-det/hooks/useUtdanningstilbudEndre.tsx:312-354`; `P-skj/opptak/opptakshendelse.graphqls:27-35`, `P-svc/opptak/UtdanningstilbudHendelseMutations.java:30-83`). Opptaket har ingen innstilling som åpner for frist per tilbud, ingen kode sjekker at fristen er tidligere enn opptakets, og søknadsvalideringen leser bare opptakets frister (`P-svc/…/Opptaksfrister.java:44-53,191-199`) |
| `@OPT-OPT-UTD-025` | Sette tidlig dokumentasjonsfrist | ikke funnet | P: mangler · A: funnet — fristen settes og lagres (`A-det/UtdanningstilbudDetails.tsx:1205-1217`, som `FRIST_TIDLIGOPPTAK_OPPLASTING`), men ingen kode sørger for at søkerne laster opp innen den. Søkt etter `FRIST_TIDLIGOPPTAK_OPPLASTING`, `UTDANNINGSTILBUD_HENDELSE`, `OPPLASTING` i fs-plattform |
| `@OPT-OPT-UTD-009` | Se URL til beskrivelse av utdanningstilbudet | funnet | P: funnet · A: funnet — `P-ureg/utdanningsspesifikasjon.graphql:37` (`url`); `A-det/UtdanningstilbudDetails.queries.ts:150-154`, `A-det/UtdanningstilbudDetails.tsx:764-779` («Lenke til utdanning», lenke i ny fane) |
| `@OPT-OPT-UTD-009` | Utdanningstilbud uten beskrivelses-URL | funnet | P: funnet · A: funnet — `A-det/UtdanningstilbudDetails.tsx:766-777` viser «-» når URL-en mangler; `url` er nullbar (`P-ureg/utdanningsspesifikasjon.graphql:37`) |
| `@OPT-OPT-UTD-019` | Se endringslogg for registreringer på utdanningstilbudet | ikke funnet | P: mangler · A: mangler — utdanningstilbudet logges ikke: `audit_table(` brukes bare på søknad og sak (`P-mig/V110__soknad_endringslogg_for_tabeller.sql`, `P-mig/V265__sak_mangel.sql:45`). Søkt etter «endringslogg», «historikk», «audit», «endret_av», «endretAv», «sistEndret», «changelog» i begge repoene |
| `@OPT-OPT-UTD-019` | Endringslogg viser hvem som endret og når | ikke funnet | P: mangler · A: mangler — samme søk. Utdanningstilbudet har verken hvem som endret eller når |
| `@OPT-OPT-UTD-021` | Sette lenke til tidligere utdanningstilbud | ikke funnet | P: mangler · A: mangler — ingen kolonne, felt eller mutasjon kobler et utdanningstilbud til et tidligere. Søkt etter «tidligereUtdanningstilbud», «forrigeUtdanningstilbud», «previous», «predecessor», «forgjenger», «kopiertFra», «erstatter» i begge repoene. `erNytt` og `tilboedLedigeStudieplasserForrigeOpptaksrunde` er sant/usant-felt |
| `@OPT-OPT-UTD-021` | Se lenke til tidligere utdanningstilbud | ikke funnet | P: mangler · A: mangler — den eneste lenken på detaljsiden er «Lenke til utdanning» (`A-det/UtdanningstilbudDetails.tsx:764-780`), URL-en fra utdanningsregisteret |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-017` | Søker finner utdanningstilbud via søkeord | usikker | ikke funnet | `P-svc/opptak/UtdanningstilbudV2Service.java:128-147`: fritekstsøket bruker ikke søkeord, så fs-plattform mangler det, uansett hva min-kompetanse gjør |
| `@OPT-OPT-UTD-011` | Registrere studienummer på utdanningstilbud | ikke funnet | usikker | Kontrollen fant studietypenummer fra SHI-689 (`P-svc/opptak/UtdanningstilbudMutations.java:980-986`, `A-det/UtdanningstilbudDetails.tsx:789-797`) og foreslo `funnet`. Lead: usikker, fordi kravet ikke sier at studienummer er studietypenummer |
| `@OPT-OPT-UTD-011` | Se studienummer på utdanningstilbud | usikker | usikker | Kontrollen foreslo `funnet` (`A-det/UtdanningstilbudDetails.tsx:799-806`). Lead: usikker, av samme grunn |

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-022` | Angi informasjon om studieavgift | `angi_studieavgift.feature` | `@draft` | 2/2 |
| `@OPT-OPT-UTD-015` | Regel: Utdanningstilbudet kan ikke overstyre poenglikhetsregelen når opptaket ikke åpner for unntak | `overstyre_regler_for_poenglikhet.feature` | `@draft` | 1/1 |
| `@OPT-OPT-UTD-012` | Registrere planlagt antall studieplasser | `registrere_planlagte_studieplasser.feature` | `@draft` | 2/2 |
| `@OPT-OPT-UTD-014` | Registrere påkrevde attester på utdanningstilbudet | `registrere_påkrevde_attester.feature` | `@draft` | 2/2 |
| `@OPT-OPT-UTD-009` | Vise URL til beskrivelse av utdanningstilbudet | `vise_beskrivelses_url.feature` | `@draft` | 2/2 |

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-016` | Angi beskrivelse av utdanningstilbudet til Min kompetanse | `@draft` | 1/2 | 0 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-017` | Angi søkeord på utdanningstilbudet | `@draft` | 3/4 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-013` | Flytte registrering av kvoteflyt til opptaksinnstillinger | `@draft` | 0/2 | 1 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-023` | Kvalitetssikre studiestart på utdanningstilbudet | `@draft` | 0/2 | 1 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-010` | Registrere poengopplysninger for utdanningstilbudet | `@draft` | 2/3 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-011` | Registrere studienummer på utdanningstilbudet | `@draft` | 0/2 | 0 ikke funnet, 2 usikker |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet | `@draft` | 0/2 | 1 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-019` | Vise endringslogg for utdanningstilbudet | `@draft` | 0/2 | 2 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-021` | Vise lenke til tidligere utdanningstilbud | `@draft` | 0/2 | 2 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Åpne spørsmål i leverte krav:** UTD-009, UTD-012, UTD-014 og UTD-022 er levert med `# ÅPNE SPØRSMÅL:` som fortsatt står i fila. Brukeren valgte å levere dem og gå gjennom spørsmålene etterpå.
- **Åpne spørsmål uten `@openquestion`:** UTD-009, UTD-010, UTD-011, UTD-012, UTD-014, UTD-016, UTD-017, UTD-022 og UTD-023 har `# ÅPNE SPØRSMÅL:` på egenskapen. Flere er besvart i koden (UTD-009: lenke i ny fane; UTD-012: heltall 0–9999; UTD-014: én kode for medisinsk attest, og flere attester per tilbud; UTD-017: fritekst med forslag, høyst 20 ord à 50 tegn). Lukk dem med `fs-krav`.
- **Studieavgift er bare ja/nei:** `P-skj/opptak/utdanningstilbud.graphqls:359` sier at fs-admin bruker feltet som ja/nei (1 = ja). Fortellingen i UTD-022 sier «om og hvor mye».
- **Studienummer eller studietypenummer:** SHI-689 er bygget som studietypenummer, og fs-admin har i tillegg feltet «Studienummer» med koden fra utdanningsregisteret (`A-det/UtdanningstilbudDetails.tsx:700-709`). Begrepet må avklares i UTD-011.
- **Median poengsum på en branch:** `origin/opptak/SHI-688-median-poengsum-og-poenggrenser` i fs-plattform har `median_poengsum` i en migrasjon (`V446__studietypenr_poenggrense.sql`), ikke merget og ikke i GraphQL.
- **Tidlig søknadsfrist bruker tidlig opptak-koden:** fs-admin lagrer `SØKNADSFRIST_TIDLIG_OPPTAK` (`A-det/utils/tidligFrist.ts:7-10`), mens `TIDLIG_SØKNADSFRIST` er i kategorien «Ikke i bruk» (`P-mig/V444__opptakshendelse_kategorier_og_rekkefolge.sql:61`). Kolonnen `har_tidlig_soknadsfrist` skrives ikke av noen mutasjon.
- **Studiestart mot designet:** UTD-023 vil korrigere studiestart, men `tasks/opptak/utdanningstilbud/design.md:182` sier at oppstartstermin arves og ikke kan overstyres.
- **Lesevisningen av poenglikhet:** `A-det/UtdanningstilbudDetails.tsx:1104-1107` sier ikke at regelen er opptakets standard. Det vises bare i redigeringen.
- **Ikke sjekket:** min-kompetanse var ikke med. Det gjelder «Søker ser beskrivelsen i Min kompetanse» (UTD-016) og «Søker finner utdanningstilbud via søkeord» (UTD-017). En kontrollør så kort i den lokale klonen (`~/Dev/Sikt/min-kompetanse`, e6f5ddc4, 9. oktober): spørringen `src/components/find-studier/studie/_queries/query-utdanningstilbud.ts:57-86` henter ikke `beskrivelse`, og ingen treff på søkeord.
- **Krav utenfor scope:** skjeletter uten scenarioer, som ikke kan verifiseres: `eksportere_utdanningstilbud.feature` (UTD-030), `sammenligne_med_tidligere_utdanningstilbud.feature` (UTD-031), `sette_kjønnspoeng.feature` (UTD-027), `velge_saksbehandlertildelingsregel.feature` (UTD-028) og `vise_poenggrense_og_ventelistenummer_for_søker.feature` (UTD-029), alle `@draft` — `fs-krav`.
