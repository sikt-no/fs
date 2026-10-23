# Verifisering: krav/02 Opptak/12 Utdanningstilbud/04 Behandle et utdanningstilbud

- **Dato:** 2026-10-22 19:15
- **Krav:** `krav/02 Opptak/12 Utdanningstilbud/04 Behandle et utdanningstilbud/` (17 feature-filer)
- **Kode:** `fs-plattform` (main, bbd797a3b9, oppdatert), `fs-admin` (main, 6a5c26a9e, oppdatert), `min-kompetanse` (main, f70409ca, oppdatert)
- **Omfang:** alle krav uansett status (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 12 kontrollører (`fs-verify-kontroll`), 2–7 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `UM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudMutations.java`
- `SVC` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`
- `SG` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `UD` = `fs-admin/src/domains/opptak/features/UtdanningstilbudDetails`
- `MSG` = `fs-admin/src/common/messages/nb/opptak.json`
- `MK` = `min-kompetanse/src`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-016` | Angi beskrivelse av utdanningstilbudet til Min kompetanse | 1/2 | min-kompetanse | min-kompetanse henter ikke `UtdanningstilbudV2.beskrivelse`, og viser beskrivelsen fra utdanningsregisteret i stedet. Hva som vises når språket mangler, er et åpent spørsmål. |
| `@OPT-OPT-UTD-022` | Angi informasjon om studieavgift | 2/2 | ingen | – |
| `@OPT-OPT-UTD-017` | Angi søkeord på utdanningstilbudet | 3/4 | fs-plattform, min-kompetanse | Søket for søkere matcher bare navnet, ikke søkeordene. Om min-kompetanse må endres, avhenger av løsningen i fs-plattform. |
| `@OPT-OPT-UTD-030` | Eksportere utdanningstilbudet | 0/0 | ingen | Skjelett uten scenarioer (`@draft`), ingenting å verifisere. |
| `@OPT-OPT-UTD-013` | Kvoteflyt registreres ikke på utdanningstilbudet | 1/1 | ingen | – |
| `@OPT-OPT-UTD-015` | Overstyre regler for poenglikhet på utdanningstilbudet | 4/4 | ingen | – |
| `@OPT-OPT-UTD-012` | Registrere planlagt antall studieplasser | 2/2 | ingen | – |
| `@OPT-OPT-UTD-010` | Registrere poengopplysninger for utdanningstilbudet | 2/3 | fs-admin | fs-admin må hente `fjoraretsMedianPoengsum` og vise den i stedet for «Ikke tilgjengelig». fs-plattform har feltet. |
| `@OPT-OPT-UTD-014` | Registrere påkrevde attester på utdanningstilbudet | 2/2 | ingen | – |
| `@OPT-OPT-UTD-011` | Registrere studietypenummer på utdanningstilbudet | 2/2 | ingen | – |
| `@OPT-OPT-UTD-031` | Sammenligne med tidligere utdanningstilbud | 0/0 | ingen | Skjelett uten scenarioer (`@draft`), ingenting å verifisere. |
| `@OPT-OPT-UTD-027` | Sette kjønnspoeng på utdanningstilbudet | 0/0 | ingen | Skjelett uten scenarioer (`@draft`), ingenting å verifisere. |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet | 2/3 | fs-plattform, fs-admin | Ingen av repoene sjekker at tidlig søknadsfrist er før søknadsfristen for opptaket. |
| `@OPT-OPT-UTD-009` | Vise URL til beskrivelse av utdanningstilbudet | 2/2 | ingen | – |
| `@OPT-OPT-UTD-019` | Vise endringslogg for utdanningstilbudet | 0/2 | fs-plattform, fs-admin | Det finnes ingen endringslogg for utdanningstilbudet: ingen logging av hvem og når i fs-plattform, og ingen visning i fs-admin. |
| `@OPT-OPT-UTD-021` | Vise lenke til tidligere utdanningstilbud | 0/2 | fs-plattform, fs-admin | Det finnes ingen kobling fra et utdanningstilbud til et tidligere. Hva «tidligere utdanningstilbud» er, er ikke avklart. |
| `@OPT-OPT-UTD-029` | Vise poenggrense og ventelistenummer for søker | 0/0 | ingen | Skjelett uten scenarioer (`@draft`), ingenting å verifisere. |

Gjenstår: fs-plattform, fs-admin 3, fs-admin 1, min-kompetanse 1, fs-plattform, min-kompetanse 1, ingen 11.

## Oppsummering

- Scenarioer: 23 funnet, 8 ikke funnet, 0 usikker, av 31
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 7
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |

Avhengigheter: 0 på nivå 1, 0 av dem ikke `@implemented`.

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OPT-UTD-016` | Angi beskrivelse på <språk> | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:178-191` lagrer beskrivelsen per språk i `utdanningstilbud_beskrivelse` (`MIG/V433__utdanningstilbud_beskrivelse.sql:9-16`), `UM:1329-1335` dekker nb/nn/en/se; `UD/components/MinKompetanse/MinKompetanse.tsx:89-121` (én fane per språk), `UD/hooks/useUtdanningstilbudEndre.tsx:244-269` |
| `@OPT-OPT-UTD-016` | Søker ser beskrivelsen i Min kompetanse | ikke funnet | P: funnet · A: ikke relevant · M: mangler — `SG/utdanningstilbudV2.graphqls:140-150` (`UtdanningstilbudV2.beskrivelse`); ingen av fragmentene på `UtdanningstilbudV2` i min-kompetanse henter feltet (`MK/components/find-studier/studie/_queries/query-utdanningstilbud.ts:103-125`), og «Om studiet» viser `Utdanningsinstans.beskrivelse` fra utdanningsregisteret (`query-utdanningstilbud.ts:29-32`, `MK/components/find-studier/studie/studie-tabs/about/use-utdanningstilbud-info.tsx:59,107`). Søkt etter «beskrivelse», «description», «UtdanningstilbudV2», «oversatte» |
| `@OPT-OPT-UTD-022` | Registrere informasjon om studieavgift | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:999-1001` lagrer `STUDIEAVGIFT` (`MIG/V437__utdanningstilbud_studieavgift.sql:6-9`); `UD/components/StudietypeOgStudieavgift/StudietypeOgStudieavgift.tsx:58-70` (ja/nei), `UD/hooks/useUtdanningstilbudEndre.tsx:196,217-219` |
| `@OPT-OPT-UTD-022` | Se informasjon om studieavgift | funnet | P: funnet · A: funnet · M: ikke relevant — `SG/utdanningstilbudV2.graphqls:225-229`; `UD/UtdanningstilbudDetails.queries.ts:194`, vises som «Ja»/«Nei» i `StudietypeOgStudieavgift.tsx:72-75` |
| `@OPT-OPT-UTD-017` | Legge til søkeord på utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1034-1036` → `skrivSokeord` (`UM:1229-1244`) i `utdanningstilbud_sokeord` (`MIG/V436__utdanningstilbud_sokeord.sql:9-14`), høyst 20 søkeord på 50 tegn (`UM:199-222`); `UD/components/MinKompetanse/MinKompetanse.tsx:140-175`, `UD/hooks/useUtdanningstilbudEndre.tsx:194-195,216` |
| `@OPT-OPT-UTD-017` | Legge til flere søkeord på samme utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — én rad per søkeord (`MIG/V436__utdanningstilbud_sokeord.sql:14`); `MinKompetanse.tsx:141` (flervalg), `:179-189` (vises som tagger) |
| `@OPT-OPT-UTD-017` | Fjerne søkeord fra utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `skrivSokeord` erstatter alle radene (`UM:1228-1244`); `MinKompetanse.tsx:148-157` |
| `@OPT-OPT-UTD-017` | Søker finner utdanningstilbud via søkeord | ikke funnet | P: mangler · A: ikke relevant · M: mangler — søkersøket (`SokerUtdanningstilbudFilterInput`, `SG/soknad/soknad.graphqls:204-240`) har bare `studieprogramNavn`, og `SVC/opptak/UtdanningstilbudV2Service.java:129-143` matcher navn, ikke søkeord; min-kompetanse sender fritekst som `studieprogramNavn` (`MK/components/find-studier/_utils/get-search-param-funcs.ts:94-108`). Søkt etter «sokeord», «søkeord», «keyword», «stikkord», «tsvector», «elastic» |
| `@OPT-OPT-UTD-013` | Kvoteflyt kan ikke registreres på utdanningstilbudet | funnet | P: funnet · A: funnet · M: ikke relevant — ingen input for utdanningstilbud eller kvote har plassflyt (`SG/opptak/utdanningstilbud.graphqls:345-361,394-460`); plassflyt settes på kvotetypen (`SG/regelverk/kvote.graphqls:153-154,179-180,211`); ingen treff på «plassflyt» eller «kvoteflyt» i fs-admin |
| `@OPT-OPT-UTD-015` | Se standardregel for poenglikhet | funnet | P: funnet · A: funnet · M: ikke relevant — `SG/opptak/opptak.graphqls:277-278`, `SVC/regelverk/poeng/PoenglikhetService.java:137-160` (tilbudets regel, ellers opptakets); `UD/components/RegelverkFelter/RegelverkFelter.tsx:93,100-108` («(standard for opptaket)», `MSG:439`), `:196-198` |
| `@OPT-OPT-UTD-015` | Overstyre regel for poenglikhet | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:910-952` setter `POENGLIKHETSREGEL_KODE`, brukt i rangeringen (`SVC/plasstildeling/service/RangeringService.java:139`); `RegelverkFelter.tsx:184-195`, `UD/hooks/useUtdanningstilbudEndre.tsx:231-243` |
| `@OPT-OPT-UTD-015` | Kun regler tilgjengelige for opptaket kan velges | funnet | P: funnet · A: funnet · M: ikke relevant — FK mot `opptak_poenglikhetsregel` (`MIG/V379__tillatte_poenglikhetsregler_pa_opptak.sql:76-79`), feilen i `UM:933-940`; valgene er standarden og `tillattePoenglikhetsregler` (`RegelverkFelter.tsx:94,100-102`) |
| `@OPT-OPT-UTD-015` | Kan ikke overstyre regel for poenglikhet når opptaket ikke åpner for unntak | funnet | P: funnet · A: funnet · M: ikke relevant — uten unntak er standarden den eneste tillatte regelen (`SG/opptak/opptak.graphqls:124-129`), FK-en avviser andre (`UM:933-940`); `RegelverkFelter.tsx:95-99` viser bare lesefeltet |
| `@OPT-OPT-UTD-012` | Registrere planlagt antall studieplasser | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:975-980` (0–9999), `UM:996-999` (`ANTALL_STUDIEPLASSER`); `UD/components/Kvoter/Kvoter.tsx:155-169`, `UD/hooks/useUtdanningstilbudEndre.tsx:193,215` |
| `@OPT-OPT-UTD-012` | Se planlagt antall studieplasser | funnet | P: funnet · A: funnet · M: ikke relevant — `SG/utdanningstilbudV2.graphqls:170-171`; `UD/UtdanningstilbudDetails.queries.ts:189`, `Kvoter.tsx:170-177` |
| `@OPT-OPT-UTD-010` | Se median poengsum for fjorårets opptatte | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `SG/utdanningstilbudV2.graphqls:203-208` (`fjoraretsMedianPoengsum`), `SVC/opptak/UtdanningstilbudV2Service.java:46-66`; fs-admin viser fast «Ikke tilgjengelig» (`UD/components/TidligFristOgOpptak/TidligFristOgOpptak.tsx:123-130`, TODO SHI-660) og henter ikke feltet (`UD/UtdanningstilbudDetails.queries.ts:183-196`). Søkt etter «median», «fjoraretsMedian», «fjoraretsStudium» |
| `@OPT-OPT-UTD-010` | Registrere poenggrense for tidligopptak | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:297-327` setter `TIDLIG_OPPTAK_POENGGRENSE`; `TidligFristOgOpptak.tsx:131-142`, `UD/hooks/useUtdanningstilbudEndre.tsx:175-186` |
| `@OPT-OPT-UTD-010` | Se registrert poenggrense for tidligopptak | funnet | P: funnet · A: funnet · M: ikke relevant — `SG/utdanningstilbudV2.graphqls:197-202`; `UD/UtdanningstilbudDetails.queries.ts:188`, `TidligFristOgOpptak.tsx:143-155` |
| `@OPT-OPT-UTD-014` | Registrere krav om politiattest | funnet | P: funnet · A: funnet · M: ikke relevant — kodeverket og `utdanningstilbud_attest` (`MIG/V445__utdanningstilbud_attest.sql:55-90`), `SVC/opptak/UtdanningstilbudAttestMutations.java:35-56,62-75,128-150`; `UD/components/AttesterFelt/AttesterFelt.tsx:23-49`, `UD/hooks/useUtdanningstilbudEndre.tsx:149-160` |
| `@OPT-OPT-UTD-014` | Registrere krav om medisinsk attest | funnet | P: funnet · A: funnet · M: ikke relevant — `MEDICAL` «Medisinsk attest» (`MIG/V445__utdanningstilbud_attest.sql:29-31,56`), samme mutation; samme flervalg (`AttesterFelt.tsx:26-49`) |
| `@OPT-OPT-UTD-011` | Registrere studietypenummer på utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1002-1008` sjekker studietypen mot kodeverket og lagrer `STUDIETYPENR`; `UD/components/StudietypeOgStudieavgift/StudietypeOgStudieavgift.tsx:43-52` («Studietypenummer»), `UD/hooks/useUtdanningstilbudEndre.tsx:199,201-222` |
| `@OPT-OPT-UTD-011` | Se studietypenummer på utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `SG/utdanningstilbudV2.graphqls:163-164`; `StudietypeOgStudieavgift.tsx:53-56` viser nummer og navn, hentet i `UD/UtdanningstilbudDetails.queries.ts:198-202` |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist | funnet | P: funnet · A: funnet · M: ikke relevant — `SVC/opptak/UtdanningstilbudHendelseMutations.java:30-84` lagrer `SOKNADSFRIST_TIDLIG_OPPTAK` per tilbud; `UD/components/TidligFristOgOpptak/TidligFristOgOpptak.tsx:38-77`, `UD/hooks/useUtdanningstilbudEndre.tsx:272-315` |
| `@OPT-OPT-UTD-025` | Tidlig søknadsfrist må være før søknadsfristen for opptaket | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen av eksempelradene avvises: `UtdanningstilbudHendelseMutations.java:30-84` og `HendelseInputValidering.java:17-39` sammenligner ikke med opptakets frist, ingen CHECK eller trigger i migrasjonene; datovelgeren (`TidligFristOgOpptak.tsx:69-77`) har ingen grense. Søkt etter «må være før», «tidligere enn», «isBefore», «isAfter», «compareTo», «minValue», «maxValue» |
| `@OPT-OPT-UTD-025` | Sette tidlig dokumentasjonsfrist | funnet | P: funnet · A: funnet · M: ikke relevant — `UtdanningstilbudHendelseMutations.java:70-82` lagrer `FRIST_TIDLIGOPPTAK_OPPLASTING`; `TidligFristOgOpptak.tsx:78-86`, `UD/hooks/useUtdanningstilbudEndre.tsx:302-305` |
| `@OPT-OPT-UTD-009` | Se URL til beskrivelse av utdanningstilbudet | funnet | P: funnet · A: funnet · M: ikke relevant — `fs-plattform/utdanningsregisteret/utdanningsregisteret-graphql-spec/src/main/resources/schema/features/beta/utdanningsspesifikasjon.graphql:36-37`; `UD/UtdanningstilbudDetails.queries.ts:147-152`, `UD/components/Basisinformasjon/Basisinformasjon.tsx:26-28,151-162` («Lenke til utdanning», `MSG:427`) |
| `@OPT-OPT-UTD-009` | Utdanningstilbud uten beskrivelses-URL | funnet | P: funnet · A: funnet · M: ikke relevant — `url` kan være null; `Basisinformasjon.tsx:154-161` viser «-» uten lenke |
| `@OPT-OPT-UTD-019` | Se endringslogg for registreringer på utdanningstilbudet | ikke funnet | P: mangler · A: mangler · M: ikke relevant — `audit_table(` brukes aldri på `opptak_v2.utdanningstilbud*` (bare søknad, saksbehandling og GSK, f.eks. `MIG/V110__soknad_endringslogg_for_tabeller.sql`); endringslogg i GraphQL bare som `Sak.endringsloggV2` (`SG/saksbehandling/sak.graphqls:140-144`); ingen visning i `UD`. Søkt etter «endringslogg», «changelog», «audit», «historikk», «endret_av», «sist_endret» |
| `@OPT-OPT-UTD-019` | Endringslogg viser hvem som endret og når | ikke funnet | P: mangler · A: mangler · M: ikke relevant — `opptak_v2.utdanningstilbud` (`MIG/V280__opptak_v2_skjema.sql:649-`) har ingen kolonner for hvem og når; ingen visning i `UD` |
| `@OPT-OPT-UTD-021` | Sette lenke til tidligere utdanningstilbud | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen kolonne, FK eller mutation kobler et tilbud til et tidligere; `fjoraretsStudium` (`SG/utdanningstilbudV2.graphqls:56-66`, `SVC/opptak/TidligereStudiumService.java:24-60`) slår bare opp fjorårets tall. Søkt etter «tidligereUtdanningstilbud», «forrigeTilbud», «forgjenger», «kopiertFra», «fjorår», «previousYear», «replacedBy» |
| `@OPT-OPT-UTD-021` | Se lenke til tidligere utdanningstilbud | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen felt å vise; den eneste lenken på detaljsiden er «Lenke til utdanning» (`UD/components/Basisinformasjon/Basisinformasjon.tsx:154-158`) |

## Kontroll

Kontrollen endret ingen resultater.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-016` | Scenario: Søker ser beskrivelsen i Min kompetanse | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-017` | Scenario: Søker finner utdanningstilbud via søkeord | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-010` | Scenario: Se median poengsum for fjorårets opptatte | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-011` | Registrere studietypenummer på utdanningstilbudet | `@planned` | 2/2 | Alt funnet. Brukeren valgte «Ikke endre noe» |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet | `@planned` | 2/3 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-019` | Vise endringslogg for utdanningstilbudet | `@draft` | 0/2 | 2 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-021` | Vise lenke til tidligere utdanningstilbud | `@draft` | 0/2 | 2 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Median i fjor på en branch som ikke er merget:** `origin/einor/shi-688-feat-median-og-poenggrenser` i fs-admin (commit `21be0e407`, 2026-10-22) henter og viser `medianPoengsum`. `@OPT-OPT-UTD-010` «Se median poengsum for fjorårets opptatte» blir funnet når den er merget til main.
- **Standardregelen merkes ikke i lesevisning:** «(standard for opptaket)» står bare i nedtrekkslista når man redigerer (`UD/components/RegelverkFelter/RegelverkFelter.tsx:100-108`), ikke i lesevisningen (`:196-198`).
- **Studieavgift lagres som beløp, men brukes som ja/nei:** kolonnen er et beløp (`MIG/V437__utdanningstilbud_studieavgift.sql:6-7`), og fs-admin sender 1 eller 0 (`UD/utils/studieavgift.ts:9`). Det stemmer med kravet slik det er avklart, men må endres hvis det skal bli et beløp.
- **Studietypen kan byttes, men ikke fjernes:** `UD/components/StudietypeOgStudieavgift/StudietypeOgStudieavgift.tsx:48-49` beholder den lagrede studietypen når feltet tømmes. Kravet sier ikke noe om å fjerne den.
- **Tidlige frister bare sammen i fs-admin:** fs-admin sender tidlig søknadsfrist og tidlig dokumentasjonsfrist bare når begge er satt (`UD/hooks/useUtdanningstilbudEndre.tsx:294-306`, påkrevd i `UD/UtdanningstilbudDetails.tsx:148-156`).
- **Overstyring av plassflyt på kvoten finnes fortsatt i databasen:** `kvotetype_kode_overstyrer_plassflyt` (`MIG/V280__opptak_v2_skjema.sql:851`) leses av plasstildelingen (`SVC/plasstildeling/service/KvoterService.java:56,88`), men kan ikke settes. Kolonnen kan vurderes fjernet.
- **Åpent spørsmål:** `@OPT-OPT-UTD-016` «Beskrivelsen framvises søkeren i Min kompetanse» — Hva ser søkeren når det ikke finnes noen beskrivelse på språket søkeren bruker: bokmål, den første av bokmål, nynorsk og engelsk som finnes, beskrivelsen fra utdanningsregisteret, eller ingen beskrivelse?
- **Åpent spørsmål:** `@OPT-OPT-UTD-025` «Opptaksforvalter kan sette tidlig søknadsfrist per utdanningstilbud» — Hva skjer med søkere som ikke har lastet opp dokumentasjon innen den tidlige dokumentasjonsfristen? Kan søkeren ikke laste opp etter fristen, eller merkes dokumentasjonen som levert for sent for saksbehandleren?
- **Skjeletter uten scenarioer:** `eksportere_utdanningstilbud.feature`, `sammenligne_med_tidligere_utdanningstilbud.feature`, `sette_kjønnspoeng.feature` og `vise_poenggrense_og_ventelistenummer_for_søker.feature` (`@draft`) har bare `Regel:`-titler. Scenarioene skrives med `fs-krav`.
