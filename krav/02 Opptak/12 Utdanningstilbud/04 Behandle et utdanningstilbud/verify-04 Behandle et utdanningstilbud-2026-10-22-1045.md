# Verifisering: krav/02 Opptak/12 Utdanningstilbud/04 Behandle et utdanningstilbud

- **Dato:** 2026-10-22 10:45
- **Krav:** `krav/02 Opptak/12 Utdanningstilbud/04 Behandle et utdanningstilbud/` (19 feature-filer)
- **Kode:** `fs-plattform` (main, 4467c1c5a4, oppdatert), `fs-admin` (main, d2b004f3a, oppdatert), `min-kompetanse` (main, 62e1e71f, oppdatert)
- **Kontroll:** `fs-verify-kontroll` (uavhengig)
- **Team:** 2 finnere (`fs-verify-krav`), 14 kontrollører (`fs-verify-kontroll`), 7 feature-filer per finner
- **Skjermbilder:** nei (chrome-devtools-MCP er ikke tilgjengelig i økta)

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `UM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudMutations.java`
- `UD` = `fs-admin/src/domains/opptak/features/UtdanningstilbudDetails`
- `SG` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-016` | Angi beskrivelse av utdanningstilbudet til Min kompetanse | 1/2 | min-kompetanse | min-kompetanse må hente og vise UtdanningstilbudV2.beskrivelse på søkerens språk. |
| `@OPT-OPT-UTD-022` | Angi informasjon om studieavgift | 2/2 | ingen | Alt er funnet i kravets repoer. |
| `@OPT-OPT-UTD-017` | Angi søkeord på utdanningstilbudet | 3/4 | fs-plattform, min-kompetanse | fs-plattform: søkefilteret må matche søkeord. min-kompetanse: søket må bruke søkeordene. |
| `@OPT-OPT-UTD-013` | Flytte registrering av kvoteflyt til opptaksinnstillinger | 1/2 | fs-plattform, fs-admin | Kvoteflyt (plassflyt) i opptaksinnstillingene, i fs-plattform og fs-admin. |
| `@OPT-OPT-UTD-023` | Kvalitetssikre studiestart på utdanningstilbudet | 0/2 | fs-plattform, fs-admin | Korrigering av studiestart (felt og mutation i fs-plattform, redigering i fs-admin), og avklaring av hva «foreslått» betyr. |
| `@OPT-OPT-UTD-015` | Overstyre regler for poenglikhet på utdanningstilbudet | 4/4 | ingen | Alt er funnet i kravets repoer. |
| `@OPT-OPT-UTD-012` | Registrere planlagt antall studieplasser | 2/2 | ingen | Alt er funnet i kravets repoer. |
| `@OPT-OPT-UTD-010` | Registrere poengopplysninger for utdanningstilbudet | 2/3 | fs-plattform, fs-admin | Median poengsum for fjoråret finnes ikke i API-et (fs-plattform), og fs-admin viser «Ikke tilgjengelig» til feltet finnes. Kilden til medianen er et åpent spørsmål i kravet. |
| `@OPT-OPT-UTD-014` | Registrere påkrevde attester på utdanningstilbudet | 2/2 | ingen | Alt er funnet i kravets repoer. |
| `@OPT-OPT-UTD-011` | Registrere studienummer på utdanningstilbudet | 0/2 | fs-plattform, fs-admin | Avklaring av hva studienummer er. Først da kan det avgjøres hva som mangler i fs-plattform og fs-admin. |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet | 0/2 | fs-plattform, fs-admin | Innstilling på opptaket for tidlig frist, validering mot opptakets frist, og håndheving av dokumentasjonsfristen for søkerne (fs-plattform). fs-admin viser avkrysningen uansett. |
| `@OPT-OPT-UTD-009` | Vise URL til beskrivelse av utdanningstilbudet | 2/2 | ingen | Alt er funnet i kravets repoer. |
| `@OPT-OPT-UTD-019` | Vise endringslogg for utdanningstilbudet | 0/2 | fs-plattform, fs-admin | Endringslogg for utdanningstilbudet (felt og logg i fs-plattform, visning i fs-admin). Kravet skal samkjøres med team-bat. |
| `@OPT-OPT-UTD-021` | Vise lenke til tidligere utdanningstilbud | 0/2 | fs-plattform, fs-admin | «Tidligere utdanningstilbud» er ikke definert (åpne spørsmål i kravet). Kobling mellom tilbud og visning mangler i fs-plattform og fs-admin. |

Gjenstår: «fs-plattform, fs-admin» 7, «min-kompetanse» 1, «fs-plattform, min-kompetanse» 1, ingen 5.

## Oppsummering

- Scenarioer: 19 funnet, 9 ikke funnet, 5 usikker, av 33
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 9
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OPT-UTD-016` | Angi beskrivelse på <språk> | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:176-187` (oppdaterBeskrivelse skriver til utdanningstilbud_beskrivelse, `MIG/V433__utdanningstilbud_beskrivelse.sql`); `UM:1293-1298` mapper nb/nn/en/se til NOB/NNO/ENG/SME (alle fire eksempelradene); mutation i `SG/opptak/utdanningstilbud.graphqls:76`. `UD/components/MinKompetanse/MinKompetanse.tsx:106-121` (TextArea per språkfane), `UD/hooks/useUtdanningstilbudEndre.tsx:257-269` sender nb/nn/en/se |
| `@OPT-OPT-UTD-016` | Søker ser beskrivelsen i Min kompetanse | ikke funnet | P: funnet · A: ikke relevant · M: mangler — fs-plattform eksponerer UtdanningstilbudV2.beskrivelse (`SG/utdanningstilbudV2.graphqls:99-103`). min-kompetanse henter den ikke: `min-kompetanse/src/components/find-studier/studie/_queries/query-utdanningstilbud.ts:101-123` (Studie_Utdanningstilbud). Beskrivelsen som vises (`min-kompetanse/src/components/find-studier/studie/studie-tabs/about/use-utdanningstilbud-info.tsx:59,107`, `studie-info.tsx:32-37`) er Utdanningsinstans.beskrivelse, ikke den opptaksforvalter angir. Søkt etter «beskrivelse», «oversatteTekster», «UtdanningstilbudV2» i min-kompetanse/src |
| `@OPT-OPT-UTD-022` | Registrere informasjon om studieavgift | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:977-978` (oppdaterDetaljer setter STUDIEAVGIFT), `MIG/V437__utdanningstilbud_studieavgift.sql` (kun filnavn sett), input studieavgift i `SG/opptak/utdanningstilbud.graphqls:358-361` (0 = nei, 1 = ja); `UD/components/StudietypeOgStudieavgift/StudietypeOgStudieavgift.tsx:59-70` (ja/nei-valg), `UD/hooks/useUtdanningstilbudEndre.tsx:217-219` sender valgTilStudieavgift |
| `@OPT-OPT-UTD-022` | Se informasjon om studieavgift | funnet | P: funnet · A: funnet · M: ikke relevant — `UD/components/StudietypeOgStudieavgift/StudietypeOgStudieavgift.tsx:72-75` viser Ja/Nei fra skjema.studieavgiftValg (`UD/utils/skjema.ts:97`, hentet i `UD/UtdanningstilbudDetails.queries.ts:194`). Lesesiden i fs-plattform er bare sett som felt i schemaet, ikke lest i resolveren |
| `@OPT-OPT-UTD-017` | Legge til søkeord på utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1012-1013` (oppdaterDetaljer kaller skrivSokeord `:1193` mot utdanningstilbud_sokeord, `MIG/V436__utdanningstilbud_sokeord.sql`), input sokeord i `SG/opptak/utdanningstilbud.graphqls:356`; `UD/components/MinKompetanse/MinKompetanse.tsx` (FSCombobox multiple, ca. linje 141-170), `UD/hooks/useUtdanningstilbudEndre.tsx:216` |
| `@OPT-OPT-UTD-017` | Legge til flere søkeord på samme utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1193-1207` setter inn hele listen (maks 20 og 50 tegn, `UM:111-112,208-216`); combobox multiple (`UD/components/MinKompetanse/MinKompetanse.tsx`, `UD/types.ts:14`) |
| `@OPT-OPT-UTD-017` | Fjerne søkeord fra utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1192-1207` erstatter radene (tom liste fjerner alle); `UD/components/MinKompetanse/MinKompetanse.tsx` onChange sender ny liste, `UD/hooks/useUtdanningstilbudEndre.tsx:194-216` |
| `@OPT-OPT-UTD-017` | Søker finner utdanningstilbud via søkeord | ikke funnet | P: mangler · A: ikke relevant · M: mangler — `SG/utdanningstilbudV2.graphqls:278-282` (sok) går til `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudV2Service.java:121-140`, som matcher navn, regelverkskoder og kvotetype, ikke utdanningstilbud_sokeord. Tabellen leses bare av UtdanningstilbudSokeordService (autoutfylling og feltet UtdanningstilbudV2.sokeord). min-kompetanse: ingen treff på «sokeord», «søkeord», «keyword» i src, types og codegen.ts |
| `@OPT-OPT-UTD-013` | Registrere kvoteflyt i opptaksinnstillinger | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Koden kaller det plassflyt. Opptaksnivået har ingen plassflyt-input (`fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/opptak/opptak.graphqls`, `opptaksparametere.graphqls`); plassflyt settes bare på kvotetypen i regelverket (`.../regelverk/kvote.graphqls:154,180`). Ingen treff på «kvoteflyt», «plassflyt», «kvotetypeKodeOverstyr» i fs-admin/src. Søkt etter «kvoteflyt», «kvote_flyt», «plassflyt», «overstyr» i fs-plattform (java, sql, graphqls) og fs-admin |
| `@OPT-OPT-UTD-013` | Kvoteflyt kan ikke registreres på utdanningstilbudet | funnet | P: funnet · A: funnet · M: ikke relevant — `OpprettKvoteInput` (`SG/opptak/utdanningstilbud.graphqls:394-408`) og `OppdaterKvoteInput` (`:451-463`) har ingen flyt-felt; eneste skriving til kvote.kvotetype_kode_overstyrer_plassflyt fra API-et er nullstillingen i `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/utdanning/KvoteMutations.java:473`; ingen flyt-felt i kvoteskjemaet i fs-admin. At ingenting kan registreres er ikke en bevisst fjerning, og kolonnen ligger igjen i databasen |
| `@OPT-OPT-UTD-023` | Se foreslått studiestart for utdanningstilbudet | usikker | P: delvis · A: delvis · M: ikke relevant — `UD/components/Basisinformasjon/Basisinformasjon.tsx:146-150` viser Studiestart som utdanningsinstans.termin.fraTermin (fra UREG, `MIG/V301__ureg_replika_utdanningstilbud_filterdimensjoner.sql:177-178`). Det finnes ingen «foreslått» studiestart skilt fra en kvalitetssikret verdi, og kravet definerer ikke «foreslått» |
| `@OPT-OPT-UTD-023` | Korrigere studiestart når forslaget er feil | ikke funnet | P: mangler · A: mangler · M: ikke relevant — `OppdaterUtdanningstilbudDetaljerInput` (`SG/opptak/utdanningstilbud.graphqls:344-361`) har ikke studiestart, og `UD/components/Basisinformasjon/Basisinformasjon.tsx:146-150` er skrivebeskyttet. Søkt etter «studiestart», «startTermin», «starttermin», «fraTermin», «oppstart», «startdato» i fs-plattform (graphqls, opptak-service, migrasjoner) og fs-admin (`UD`, meldingsfiler) |
| `@OPT-OPT-UTD-015` | Se standardregel for poenglikhet | funnet | P: funnet · A: funnet · M: ikke relevant — `SG/utdanningstilbudV2.graphqls:190` via `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/regelverk/poeng/PoenglikhetService.java:137-141` (coalesce av tilbudets regel og opptakets standard); `UD/components/RegelverkFelter/RegelverkFelter.tsx:196-198,100-107` |
| `@OPT-OPT-UTD-015` | Overstyre regel for poenglikhet | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:895-925` (oppdaterPoenglikhet), mutation i `SG/opptak/utdanningstilbud.graphqls:117`; rangeringen bruker samme regel (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/plasstildeling/service/RangeringService.java:139`); `UD/components/RegelverkFelter/RegelverkFelter.tsx:184-194`, `UD/hooks/useUtdanningstilbudEndre.tsx:232-242` |
| `@OPT-OPT-UTD-015` | Kun regler tilgjengelige for opptaket kan velges | funnet | P: funnet · A: funnet · M: ikke relevant — `UD/components/RegelverkFelter/RegelverkFelter.tsx:93-107` (bare standarden og tillattePoenglikhetsregler); FK utdanningstilbud_poenglikhetsregel_tillatt_fk (`MIG/V379__tillatte_poenglikhetsregler_pa_opptak.sql:74-79`), feilmelding i `UM:917-922` |
| `@OPT-OPT-UTD-015` | Kan ikke overstyre regel for poenglikhet når opptaket ikke åpner for unntak | funnet | P: funnet · A: funnet · M: ikke relevant — fs-admin: `UD/components/RegelverkFelter/RegelverkFelter.tsx:97-99,184,196-198` viser regelen skrivebeskyttet uten valg når ingen tillatt regel avviker fra standarden. fs-plattform: standarden er eneste tillatte regel og FK-en avviser alle andre (`MIG/V379__tillatte_poenglikhetsregler_pa_opptak.sql:74-79`, `UM:917-922`), og uten egen regel gjelder standarden også i rangeringen (`PoenglikhetService.java:137-141`, `RangeringService.java:139`). Ingen test dekker nettopp dette scenarioet |
| `@OPT-OPT-UTD-012` | Registrere planlagt antall studieplasser | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:973-975` (oppdaterDetaljer skriver ANTALL_STUDIEPLASSER), validering 0-9999 i `UM:960-964`; input antallStudieplasser i `SG/opptak/utdanningstilbud.graphqls:349`; `UD/components/Kvoter/Kvoter.tsx:156-170` (min 0, max 9999), `UD/hooks/useUtdanningstilbudEndre.tsx:215`. Regelen har `@openquestion` |
| `@OPT-OPT-UTD-012` | Se planlagt antall studieplasser | funnet | P: funnet · A: funnet · M: ikke relevant — `SG/utdanningstilbudV2.graphqls:125` (antallStudieplasser); `UD/components/Kvoter/Kvoter.tsx:171-178` viser tallet i visningsmodus. Regelen har `@openquestion` |
| `@OPT-OPT-UTD-010` | Se median poengsum for fjorårets opptatte | ikke funnet | P: mangler · A: delvis · M: ikke relevant — `UD/components/TidligFristOgOpptak/TidligFristOgOpptak.tsx:122-130`: «Median i fjor» vises alltid som «Ikke tilgjengelig» (TODO SHI-660, `:124`; test `UD/UtdanningstilbudDetails.test.tsx:1534-1535`). Ingen backend-felt: søkt etter «median», «fjorår», «poengMedian» i hele fs-plattform og min-kompetanse (bare fjoraretsPoenggrense per kvote, `SG/opptak/utdanningstilbud.graphqls:402,441,457,482`, som er en annen ting) |
| `@OPT-OPT-UTD-010` | Registrere poenggrense for tidligopptak | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:303` lagrer TIDLIG_OPPTAK_POENGGRENSE (`SG/opptak/utdanningstilbud.graphqls:248`); `UD/components/TidligFristOgOpptak/TidligFristOgOpptak.tsx:131-141` (felt, vises bare når tilbudet tilbyr tidlig opptak, `:109`), `UD/hooks/useUtdanningstilbudEndre.tsx:175-190` |
| `@OPT-OPT-UTD-010` | Se registrert poenggrense for tidligopptak | funnet | P: funnet · A: funnet · M: ikke relevant — `SG/utdanningstilbudV2.graphqls:156` (tidligOpptakPoenggrense); `UD/UtdanningstilbudDetails.queries.ts:188,338`, `UD/components/TidligFristOgOpptak/TidligFristOgOpptak.tsx:143-158` |
| `@OPT-OPT-UTD-014` | Registrere krav om politiattest | funnet | P: funnet · A: funnet · M: ikke relevant — `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudAttestMutations.java:35-56,62-75,84` (oppdaterAttester erstatter settet og godtar bare aktive koder); politiattestkodene (attesttype POLICE) i `MIG/V445__utdanningstilbud_attest.sql:55-74`; mutation i `SG/opptak/attest.graphqls:37`; `UD/components/AttesterFelt/AttesterFelt.tsx:20-49` (flervalg), `UD/hooks/useUtdanningstilbudEndre.tsx:149-160` |
| `@OPT-OPT-UTD-014` | Registrere krav om medisinsk attest | funnet | P: funnet · A: funnet · M: ikke relevant — `MIG/V445__utdanningstilbud_attest.sql:55-56` (attest MEDICAL, «Medisinsk attest»), lagres av samme mutation (`UtdanningstilbudAttestMutations.java:35-56`); samme flervalg i `UD/components/AttesterFelt/AttesterFelt.tsx:26-49` |
| `@OPT-OPT-UTD-011` | Registrere studienummer på utdanningstilbud | usikker | P: delvis · A: delvis · M: ikke relevant — Ingen felt eller mutation for et «studienummer» (søkt etter «studienummer», «studienr», «studyNumber», «study_number» i alle tre kloner; null treff i fs-plattform og min-kompetanse). Nærmeste er studietypenummer fra kodeverket STUDIETYPE (`UM:980-985`, `SG/opptak/utdanningstilbud.graphqls:363`, `UD/components/StudietypeOgStudieavgift/StudietypeOgStudieavgift.tsx:45-54`), og fs-admin-testene kaller den velgeren «studienummer» (`UD/UtdanningstilbudDetails.test.tsx:2756`). Kravet sier ikke hva studienummer er (tre åpne spørsmål) |
| `@OPT-OPT-UTD-011` | Se studienummer på utdanningstilbud | usikker | P: delvis · A: delvis · M: ikke relevant — `UD/components/Basisinformasjon/Basisinformasjon.tsx:109-113` viser utdanningsmulighet.kode under etiketten «Studienummer» (`fs-admin/src/common/messages/nb/opptak.json:414`), skrivebeskyttet fra utdanningsregisteret. To ulike kandidater i koden, og kravet sier ikke hvilken som er ment |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist | usikker | P: delvis · A: delvis · M: ikke relevant — Å sette og lagre fristen er funnet: `UD/components/TidligFristOgOpptak/TidligFristOgOpptak.tsx:38-90`, `UD/hooks/useUtdanningstilbudEndre.tsx:272-316`, `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudHendelseMutations.java:30-84` (UTDANNINGSTILBUD_HENDELSE). Mangler: ingen innstilling på opptaket som åpner for frist per tilbud (avkrysningen vises uansett), og ingen kode som sjekker at fristen er tidligere enn opptakets. `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Opptaksfrister.java:44-53` bruker bare opptakets frist |
| `@OPT-OPT-UTD-025` | Sette tidlig dokumentasjonsfrist | usikker | P: delvis · A: funnet · M: ikke relevant — Kontrollen: å sette og lagre FRIST_TIDLIGOPPTAK_OPPLASTING er funnet (`UD/utils/tidligFrist.ts:9-12`, `UD/hooks/useUtdanningstilbudEndre.tsx:272-316`, `UtdanningstilbudHendelseMutations.java:63-81`, `fs-plattform/opptak/opptak-subgraph/src/test/java/no/sikt/fs/opptak/funksjonstest/OpptaksfristerFT.java:569-585`). At søkere må laste opp dokumentasjon innen fristen håndheves ikke: hendelsen brukes ikke utenom lagring og lesing (`SG/utdanningstilbudV2.graphqls:145`), `Opptaksfrister.java` har ingen sjekk mot den. min-kompetanse bruker den ikke (bare mock-data). Finneren: ikke funnet |
| `@OPT-OPT-UTD-009` | Se URL til beskrivelse av utdanningstilbudet | funnet | P: funnet · A: funnet · M: ikke relevant — `fs-plattform/utdanningsregisteret/utdanningsregisteret-graphql-spec/src/main/resources/schema/features/beta/utdanningsspesifikasjon.graphql:37` (url); `UD/UtdanningstilbudDetails.queries.ts:152`, `UD/components/Basisinformasjon/Basisinformasjon.tsx:26-28,154-163` («Lenke til utdanning», lenke i ny fane), test `UD/UtdanningstilbudDetails.test.tsx:1064` |
| `@OPT-OPT-UTD-009` | Utdanningstilbud uten beskrivelses-URL | funnet | P: funnet · A: funnet · M: ikke relevant — `UD/components/Basisinformasjon/Basisinformasjon.tsx:154-163`: ingen lenke når url mangler eller er tom, placeholder «-»; url er nullbar i `utdanningsspesifikasjon.graphql:37` |
| `@OPT-OPT-UTD-019` | Se endringslogg for registreringer på utdanningstilbudet | ikke funnet | P: mangler · A: mangler · M: ikke relevant — audit_table( brukes bare på søknad og sak (`MIG/V110__soknad_endringslogg_for_tabeller.sql:1-5`, `V265:45`, `V267:7`, `V272:6,11`, `V284:9`, `V348:148`), aldri på opptak_v2.utdanningstilbud*. Endringslogg i GraphQL finnes bare som Sak.endringsloggV2 (`sak.graphqls:141`); utdanningstilbud_hendelse (`MIG/V400:23`) er fristene, ikke en logg. fs-admin: «Endringslogg» er produktnyheter (`fs-admin/src/app/om/endringslogg`) og sakens logg; ingen treff i `UD`. min-kompetanse: ingen treff |
| `@OPT-OPT-UTD-019` | Endringslogg viser hvem som endret og når | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Hvem og når finnes bare for sak og søknad. Ingen felt på utdanningstilbudet i graphqls (søkt etter «endretAv», «endret_av», «sistEndret», «opprettetAv», «endretTidspunkt», «changelog», «revisjon», «historikk»), og ingen visning i `UD` |
| `@OPT-OPT-UTD-021` | Sette lenke til tidligere utdanningstilbud | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Ingen felt, kolonne eller mutation kobler et tilbud til et tidligere (`SG/utdanningstilbudV2.graphqls:73-185`, `SG/opptak/utdanningstilbud.graphqls`, migrasjonene). Nærmeste er erNytt og tilboedLedigeStudieplasserForrigeOpptaksrunde (`MIG/V159__utdanningstilbud_v2.sql:30`), begge booleans. Søkt etter «tidligereUtdanningstilbud», «forrigeUtdanningstilbud», «forgjenger», «predecessor», «kopiertFra», «fornyelse», «erstatter», «previous» i alle tre kloner |
| `@OPT-OPT-UTD-021` | Se lenke til tidligere utdanningstilbud | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Den eneste lenken på detaljsiden er «Lenke til utdanning» (`UD/components/Basisinformasjon/Basisinformasjon.tsx:154-158`, url fra `UD/UtdanningstilbudDetails.queries.ts:152`), URL-en fra utdanningsregisteret, ikke et tidligere tilbud. min-kompetanse bruker samme spesifikasjons-URL (`min-kompetanse/src/components/find-studier/studie/studie-tabs/about/use-utdanningstilbud-info.tsx:94-102`) |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-025` | Sette tidlig dokumentasjonsfrist | ikke funnet | usikker | `fs-admin/src/domains/opptak/features/UtdanningstilbudDetails/utils/tidligFrist.ts:9-12` — fristen kan settes og lagres, men kravet om opplasting innen fristen håndheves ikke |

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-016` | Angi beskrivelse av utdanningstilbudet til Min kompetanse | `@draft` | 1/2 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-017` | Angi søkeord på utdanningstilbudet | `@draft` | 3/4 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-013` | Flytte registrering av kvoteflyt til opptaksinnstillinger | `@draft` | 1/2 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-023` | Kvalitetssikre studiestart på utdanningstilbudet | `@draft` | 0/2 | 1 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-010` | Registrere poengopplysninger for utdanningstilbudet | `@draft` | 2/3 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-011` | Registrere studienummer på utdanningstilbudet | `@draft` | 0/2 | 0 ikke funnet, 2 usikker |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet | `@draft` | 0/2 | 0 ikke funnet, 2 usikker |
| `@OPT-OPT-UTD-019` | Vise endringslogg for utdanningstilbudet | `@draft` | 0/2 | 2 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-021` | Vise lenke til tidligere utdanningstilbud | `@draft` | 0/2 | 2 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Allerede levert:** `@OPT-OPT-UTD-022` — Angi informasjon om studieavgift (`@implemented`, 2/2 funnet): ingen endring, status står.
- **Allerede levert:** `@OPT-OPT-UTD-015` — Overstyre regler for poenglikhet på utdanningstilbudet (`@implemented`, 4/4 funnet): ingen endring, status står.
- **Allerede levert:** `@OPT-OPT-UTD-012` — Registrere planlagt antall studieplasser (`@implemented`, 2/2 funnet): ingen endring, status står.
- **Allerede levert:** `@OPT-OPT-UTD-014` — Registrere påkrevde attester på utdanningstilbudet (`@implemented`, 2/2 funnet): ingen endring, status står.
- **Allerede levert:** `@OPT-OPT-UTD-009` — Vise URL til beskrivelse av utdanningstilbudet (`@implemented`, 2/2 funnet): ingen endring, status står.
- **Åpent spørsmål:** `@OPT-OPT-UTD-012` «Planlagt antall studieplasser kan registreres (regelen)» — løsningen godtar et heltall fra 0 til 9999. Dekker det alle utdanningstilbud, eller trengs andre grenser?
- **Krav utenfor scope:** `sette_kjønnspoeng.feature` (`@draft`, skjelett uten scenarioer) — gating-settet er tomt, så det er ingenting å verifisere. Skrives med `fs-krav`.
- **Krav utenfor scope:** `velge_saksbehandlertildelingsregel.feature` (`@draft`, skjelett uten scenarioer) — gating-settet er tomt, så det er ingenting å verifisere. Skrives med `fs-krav`.
- **Krav utenfor scope:** `vise_poenggrense_og_ventelistenummer_for_søker.feature` (`@draft`, skjelett uten scenarioer) — gating-settet er tomt, så det er ingenting å verifisere. Skrives med `fs-krav`.
- **Krav utenfor scope:** `eksportere_utdanningstilbud.feature` (`@draft`, skjelett uten scenarioer) — gating-settet er tomt, så det er ingenting å verifisere. Skrives med `fs-krav`.
- **Krav utenfor scope:** `sammenligne_med_tidligere_utdanningstilbud.feature` (`@draft`, skjelett uten scenarioer) — gating-settet er tomt, så det er ingenting å verifisere. Skrives med `fs-krav`.
- **Uten test i `tester/steps/`:** ingen av kravene i mappa har step definitions.
- **Ikke lest:** UTD-022 «Se informasjon om studieavgift» er bare lest i fs-admin og i schemaet; resolveren i fs-plattform er ikke lest. Kravet er allerede `@implemented`.
