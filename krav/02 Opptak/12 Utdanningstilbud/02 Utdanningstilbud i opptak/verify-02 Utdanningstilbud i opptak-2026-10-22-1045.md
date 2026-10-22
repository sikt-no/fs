# Verifisering: krav/02 Opptak/12 Utdanningstilbud/02 Utdanningstilbud i opptak

- **Dato:** 2026-10-22 10:45
- **Krav:** `krav/02 Opptak/12 Utdanningstilbud/02 Utdanningstilbud i opptak/` (4 feature-filer)
- **Kode:** `fs-plattform` (main, 4467c1c5a4, oppdatert), `fs-admin` (main, d2b004f3a, oppdatert), `min-kompetanse` (main, 62e1e71f, oppdatert)
- **Kontroll:** `fs-verify-kontroll` (uavhengig)
- **Team:** 2 finnere (`fs-verify-krav`), 4 kontrollører (`fs-verify-kontroll`), 2 feature-filer per finner
- **Skjermbilder:** nei (chrome-devtools-MCP er ikke tilgjengelig i økta)

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `UM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudMutations.java`
- `UD` = `fs-admin/src/domains/opptak/features/UtdanningstilbudDetails`
- `OS` = `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakSøknadsalternativer`
- `AF` = `fs-admin/src/domains/opptak/features/AddUtdanningstilbud`
- `SG` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `FA` = `fs-admin/src/domains/opptak`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-001` | Listevisning og søk i utdanningstilbud i opptaket | 6/13 | fs-plattform, fs-admin | Opptakskriterier for utdanningstype og -nivå, begrensning av lista for deltakende organisasjon (lesepolicy og/eller filter), og filtre for det som mangler (kvoteprioritet og plassflyt, tilbudsgaranti, tidlig søknadsfrist, poenggrense for tidlig opptak). |
| `@OPT-OPT-UTD-002` | Legge til utdanningstilbud i opptak | 5/14 | fs-plattform, fs-admin | Håndheving av redigeringsperioden og tilbydersjekk i fs-plattform, filter på utdanningstype og NKR 5.1/5.2, «legg til alle», åpningsdato som ikke er satt skal holde redigeringen stengt (fs-admin), og oppdatering fra utdanningsregisteret. |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud fra opptak | 2/5 | fs-plattform, fs-admin, min-kompetanse | Varsling av søkere ved trekk etter søknadsåpning (fs-plattform, og visning i min-kompetanse), trekk-knapp for deltakende organisasjon (fs-admin), og avklaring av trekk før søknadsåpning. |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud fra opptak | 4/8 | fs-plattform, fs-admin | Håndheving av redigeringsfristen og tilbydersjekk ved sletting (fs-plattform), og i fs-admin: skjul «Fjern» etter søknadsåpning (ikke etter fristen) og la eier fjerne etter redigeringsfristen. |

Gjenstår: «fs-plattform, fs-admin» 3, «fs-plattform, fs-admin, min-kompetanse» 1, ingen 0.

## Oppsummering

- Scenarioer: 17 funnet, 18 ikke funnet, 5 usikker, av 40
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 4
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OPT-UTD-001` | Se relevante utdanningstilbud | ikke funnet | P: mangler · A: mangler · M: ikke relevant — `OS/hooks/useGetUtdanningstilbud.ts:9-33` sender bare opptakIder, søk og de valgfrie filtrene, ingen kriterier for utdanningstype og -nivå. Søkt etter «kriteri», «tillatteStudie», «utdanningstype», «studietype», «nkr», «opptak_studieniva» i fs-plattform/opptak (sql, graphqls, java) og `FA`. Treffene (`MIG/V392__ureg_replika_navnekolonner.sql:1`, `MIG/V442` studietype/utdanningstype som frittstående referansetabeller, `MIG/V301` nkr_kode som filterdimensjon) kobler ikke opptaket til utdanningstype eller nivå |
| `@OPT-OPT-UTD-001` | Se grunndata om utdanning | funnet | P: funnet · A: funnet · M: ikke relevant — `UD/components/Basisinformasjon/Basisinformasjon.tsx:53` viser «Kilde: Utdanningsregisteret» (`fs-admin/src/common/messages/nb/opptak.json:368`); navn `:59-82`, nivå `:89-90`, studiested `:103-104`, studiepoeng `:124-125`. fs-plattform leverer feltene via utdanningsinstansen (`SG/utdanningstilbudV2.graphqls`, ikke lest felt for felt) |
| `@OPT-OPT-UTD-001` | Filtrere på organisasjon som opptaksforvalter ved forvaltende organisasjon | funnet | P: funnet · A: funnet · M: ikke relevant — `OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:135-150` lærested-filter i samordna opptak, sendt som larestedIder (`OS/hooks/useGetUtdanningstilbud.ts:14`); `larestedIder` i filterinputen i `SG/utdanningstilbudV2.graphqls:235`. Filteret vises for alle i samordna opptak, ikke bare forvaltende organisasjon. SQL-betingelsen bak filteret er ikke lest |
| `@OPT-OPT-UTD-001` | Deltakende organisasjon ser kun utdanningstilbudene sine | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Lesepolicyen er `USING (true)` (`MIG/V280__opptak_v2_skjema.sql:1157-1158`, `MIG/V346__kolonnevern_tilbudsgaranti.sql:25`). fs-admin filtrerer ikke på brukerens organisasjon: `OS/hooks/useGetUtdanningstilbud.ts:9-33`; `OS/OpptakSøknadsalternativer.tsx:79-89` gjør bare andres rader umulige å velge (rowIsModifiable). `UtdanningstilbudV2Service.java` har ingen organisasjonsfilter |
| `@OPT-OPT-UTD-001` | Deltakende organisasjon ser ikke utdanningstilbud en annen organisasjon tilbyr | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Samme bevis som raden over: alle ser alle tilbud i opptaket (`MIG/V280__opptak_v2_skjema.sql:1157-1158`, `OS/hooks/useGetUtdanningstilbud.ts:9-33`) |
| `@OPT-OPT-UTD-001` | Filtrere på starttermin og startår | funnet | P: funnet · A: funnet · M: ikke relevant — `OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:208-236` filtrene Oppstart og Termin, sendt som oppstartIder/termintypeIder (`OS/hooks/useGetUtdanningstilbud.ts:15-16`); input i `SG/utdanningstilbudV2.graphqls`. SQL-betingelsene er ikke lest |
| `@OPT-OPT-UTD-001` | Fritekst-søk på studieprogramnavn | funnet | P: funnet · A: funnet · M: ikke relevant — `OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:72-83` søkefelt, sendt som sok (`OS/hooks/useGetUtdanningstilbud.ts:7,12`); `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudV2Service.java:121-140` (utdanningstilbudSok matcher navn, kompetanse- og rangeringsregelverkskode og kvotetype) |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler kompetanseregelverk | funnet | P: funnet · A: funnet · M: ikke relevant — Statusfilteret «Har mangler» (`OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:152-161`, `fs-admin/src/common/messages/nb/opptak.json:571-575`) sender statuser; `MIG/V427__utdanningstilbud_status.sql:27` gir HAR_MANGLER uten kompetanseregelverk. Filteret skiller ikke hva som mangler |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler rangeringsregelverk | funnet | P: funnet · A: funnet · M: ikke relevant — `MIG/V427__utdanningstilbud_status.sql:28` (rangeringsregelverk IS NOT NULL), samme filter i fs-admin |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler kvoter, kvoteprioritering eller plassflyt | ikke funnet | P: delvis · A: delvis · M: ikke relevant — `MIG/V427__utdanningstilbud_status.sql:29-32` teller bare manglende kvoter. Kvoteprioritet og plassflyt er ikke med i er_komplett, og det finnes ikke noe annet filter. Delen har `@openquestion` |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler opplysninger om tilbudsgaranti | ikke funnet | P: mangler · A: mangler · M: ikke relevant — `er_komplett` (`MIG/V427__utdanningstilbud_status.sql:12-14,27-32`) tar ikke med tilbudsgaranti, og ingen filterinput har det (`SG/utdanningstilbudV2.graphqls:225-304`). Søkt etter «tilbudsgaranti», «manglerTilbudsgaranti», «MANGLER_», «ufullstendig» i fs-plattform/opptak og `FA` (MANGLER_TILBUDSGARANTI_KVOTE i V406 gjelder tidligopptak-resultat) |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler dato for tidlig søknadsfrist | ikke funnet | P: mangler · A: mangler · M: ikke relevant — harTidligSoknadsfrist er et felt (`SG/utdanningstilbudV2.graphqls:139`), ikke et filter; fs-admin har bare «Tilbyr tidlig opptak» (`OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:163-189`), som ikke sier at datoen mangler. Delen har `@openquestion` |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler poenggrense for tidlig opptak | ikke funnet | P: mangler · A: mangler · M: ikke relevant — tidligOpptakPoenggrense er et felt (`SG/utdanningstilbudV2.graphqls:156`), ikke et filter, og er ikke med i er_komplett. Søkt etter «poenggrense», «manglerPoeng», «MANGLER_POENGGRENSE» i `OS`: ingen filter. Delen har `@openquestion` |
| `@OPT-OPT-UTD-002` | Legge til alle utdanningstilbud fra organisasjonen opptaksforvalter er ved | usikker | P: funnet · A: delvis · M: ikke relevant — `UM:131-159` (opprettUtdanningstilbud tar en liste). Ingen «legg til alle»-handling i `AF`: `AF/components/AddUtdanningstilbudAddButton.tsx:32-48` legger bare til valgte rader, og sidestørrelsen er 50 (`AF/hooks/useGetUtdanningsinstanserState.tsx:14`), så «alle» krever filter, last inn flere og velg alle. Opptakets kriterier er bare startfilter for samordna (`FA/utils/utdanningsinstansFilterUtil.ts:7`) |
| `@OPT-OPT-UTD-002` | Legge til enkelttilbud fra organisasjonen opptaksforvalter er ved | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:131-159`, `MIG/V280__opptak_v2_skjema.sql:1160-1165` (insert-policy); `AF/components/AddUtdanningstilbudAddButton.tsx:32-49`, `FA/utils/utdanningsinstansFilterUtil.ts:55-67` |
| `@OPT-OPT-UTD-002` | Legge til flere utdanningstilbud av gangen | funnet | P: funnet · A: funnet · M: ikke relevant — `SG/opptak/utdanningstilbud.graphqls:183` (utdanningsinstanser: [..]!); `AF/components/AddUtdanningstilbudAddButton.tsx:32-48` sender alle valgte rader i ett kall |
| `@OPT-OPT-UTD-002` | Opptaksforvalter ved forvaltende organisasjon legger til utdanningstilbud for en annen organisasjon | funnet | P: funnet · A: funnet · M: ikke relevant — `MIG/V280__opptak_v2_skjema.sql:1160-1165` (har_handling_for_opptak); `FA/utils/utdanningsinstansFilterUtil.ts:63-64` (eier ser opptakets organisasjon og alle samordna organisasjoner) |
| `@OPT-OPT-UTD-002` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | usikker | P: mangler · A: funnet · M: ikke relevant — Kontrollen: `FA/utils/utdanningsinstansFilterUtil.ts:55-67` viser bare deltakernes tilbud, så det kan ikke gjøres i fs-admin. Backend sperrer ikke: `UM:131-159` sjekker ikke at tilbyderen deltar, og `MIG/V280__opptak_v2_skjema.sql:1160-1165` sjekker bare rolle på opptaket; `MIG/V319__opptak_v2_skriving_krever_forvalter.sql:11-18` sier at tilbyder-sjekken kommer som egen leveranse. Finneren: ikke funnet |
| `@OPT-OPT-UTD-002` | Filtrere på utdanningstype | ikke funnet | P: delvis · A: mangler · M: ikke relevant — Dialogen har ikke filter på utdanningstype (`AF/components/AddUtdanningstilbudFilter.tsx:28-74`: navn, kode, organisasjon, oppstart, studienivå, språk). utdanningstype finnes bare på utdanningsmulighet (`fs-plattform/utdanningsregisteret/utdanningsregisteret-graphql-spec/src/main/resources/schema/features/beta/utdanningsmulighet.graphql:160`), ikke på utdanningsinstans. Søkt etter «utdanningstype», «utdanningsinstanstype», «studieprogram», «nkrkode» i `AF` og utdanningsregisteret (graphql, `UtdanningsintansConditions`) |
| `@OPT-OPT-UTD-002` | Filtrere på NKR-nivå for UHG-opptak | ikke funnet | P: delvis · A: delvis · M: ikke relevant — Studienivåfilter: `AF/components/filter/UtdanningsinstansStudienivaFilter/UtdanningsinstansStudienivaFilter.tsx:22-29`, NKR 6.1, 6.2, 7 i `fs-plattform/utdanningsregisteret/utdanningsregisteret-service/src/main/java/no/utdanningsregisteret/conditions/UtdanningsintansConditions.java:90-110`. Utdanningstype, som scenarioet starter med, mangler |
| `@OPT-OPT-UTD-002` | Filtrere på NKR-nivå for HYU-opptak | ikke funnet | P: delvis · A: mangler · M: ikke relevant — NKR 5.1 og 5.2 er ikke i StudienivaInput (`utdanningsinstans.graphql:191-204`) eller `UtdanningsintansConditions.java:90-110`. nkrkode-filteret finnes (`utdanningsinstans.graphql:169`, NIVA_5_1 og NIVA_5_2 i `schema_beta.graphql:677-679`), men `AF` bruker det ikke. Utdanningstype mangler også |
| `@OPT-OPT-UTD-002` | Utdanninger utenfor filteret vises ikke | ikke funnet | P: delvis · A: delvis · M: ikke relevant — Bachelor utelater master (`UtdanningsintansConditions.java:99-103`), men «emner vises ikke» krever filter på utdanningstype, som ikke finnes i dialogen |
| `@OPT-OPT-UTD-002` | Kan ikke knytte utdanningstilbud til opptaket før redigering åpner | usikker | P: mangler · A: delvis · M: ikke relevant — Kontrollen: fs-admin skjuler «legg til» for ikke-eier før åpning (`FA/utils/redigeringsfase.ts:18-20`, `OS/OpptakSøknadsalternativer.tsx:74-77,138-153`, commit d2b004f3a). fs-plattform håndhever ikke: `UM` leser bare FRIST_TREKKE_UTDANNINGSTILBUD (`UM:1068-1074`), og `fs-plattform/opptak/docs/krav-11-opptak-ikke-dekket.md:19` sier at REDIGERING_STUDIER_ÅPNER/_FRIST ikke håndheves. En åpningsdato som ikke er satt gir fase apen (`FA/utils/redigeringsfase.ts:20-26`), mens regelen (AVKLART Q3) sier stengt. Finneren: ikke funnet. Delen har `@openquestion` |
| `@OPT-OPT-UTD-002` | Kan knytte til og redigere utdanningstilbud i perioden opptaket er åpent for redigering | funnet | P: funnet · A: funnet · M: ikke relevant — `OS/OpptakSøknadsalternativer.tsx:74-77` gir canModify i fase apen; `UD/UtdanningstilbudDetails.tsx:106-122` gir redigering; ingenting i API-et stenger |
| `@OPT-OPT-UTD-002` | Kan ikke knytte til eller redigere utdanningstilbud etter at redigering stenger | usikker | P: mangler · A: funnet · M: ikke relevant — Kontrollen: fs-admin gir erLåstAvFrist for ikke-eier (`OS/OpptakSøknadsalternativer.tsx:75-77`, «legg til» skjules `:138-153`) og kunAntall på detaljsiden (`UD/UtdanningstilbudDetails.tsx:107,123`, antall studieplasser er fortsatt redigerbart `:323`). fs-plattform har ingen sperre i `UM` eller policyene (`krav-11-opptak-ikke-dekket.md:19`), så et API-kall går gjennom. Finneren: ikke funnet |
| `@OPT-OPT-UTD-002` | Opptaksforvalter ved forvaltende organisasjon kan redigere utdanningstilbud etter at redigering stenger | funnet | P: funnet · A: funnet · M: ikke relevant — `UD/UtdanningstilbudDetails.tsx:103-120` (eier har canModify uavhengig av stengt), `OS/OpptakSøknadsalternativer.tsx:75`, `MIG/V307__opptak_v2_update_using_krever_modifisere.sql:62-66` |
| `@OPT-OPT-UTD-002` | Endringer fra utdanningsregisteret oppdateres etter at redigering stenger | ikke funnet | P: delvis · A: mangler · M: ikke relevant — `UM:241-251` (oppdaterUtdanningstilbud) henter på nytt fra utdanningsregisteret, men ingen jobb kaller den, og fs-admin bruker den ikke. Søkt etter «oppdaterUtdanningstilbud», «@Scheduled», «kafka», «consumer» i fs-plattform/opptak og fs-admin/src. Merket «utløpt i UREG» (fs-admin 768a71abd) oppdaterer ingenting |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved deltakende organisasjon trekker utdanningstilbud organisasjonen tilbyr | ikke funnet | P: funnet · A: mangler · M: ikke relevant — Backend tillater det (`UM:1031-1050`, `MIG/V307__opptak_v2_update_using_krever_modifisere.sql:62-66`, test `fs-plattform/opptak/opptak-service/src/test/java/no/sikt/fs/opptak/opptak/UtdanningstilbudMutationsTest.java:476-485`). Men `UD/UtdanningstilbudDetails.tsx:103-105,136-137` gir kanTrekke bare med isOpptakOwner, og `TrekkUtdanningstilbudButton` brukes bare fra `UD/components/Opptaksinnstillinger/Opptaksinnstillinger.tsx:88-90`: ingen vei i UI for en deltakende organisasjon |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved forvaltende organisasjon trekker utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1031-1050`; `UD/UtdanningstilbudDetails.tsx:136-137`, `UD/components/Opptaksinnstillinger/Opptaksinnstillinger.tsx:88-90`; `UD/components/TrekkUtdanningstilbudButton/TrekkUtdanningstilbudButton.tsx:62-111` åpner bekreftelsesmodal med konsekvensen (`fs-admin/src/common/messages/nb/opptak.json:458`). Knappen vises bare når redigeringen er stengt (`UD/utils/trekk.ts:8-10`), og backend krever publisert opptak og at trekkfristen ikke er passert (`UM:1052-1084`) |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud før søknadsåpning | usikker | P: delvis · A: delvis · M: ikke relevant — Backend avviser trekk i et upublisert opptak (`UM:1062-1066`, «skal slettes, ikke trekkes») og sletter i stedet via slettUtdanningstilbud (`UM:1086-1125`), så tilbudet forsvinner fra lista, men med fjern-handlingen og ikke trekk. Koden styres av opptaksstatus publisert, ikke «søknadsperioden har startet». Delen har `@openquestion` om dette er det samme som å fjerne |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud etter søknadsåpning | ikke funnet | P: delvis · A: delvis · M: mangler — Tilbudet blir liggende og markeres som trukket (`UD/UtdanningstilbudDetails.tsx:252`, `fs-admin/src/common/messages/nb/opptak.json:349`). Modalen har samme tekst uansett om søkere har søkt (`opptak.json:458`), og søkere varsles ikke: `UM:1031-1050` setter bare trukket_tidspunkt. Søkt etter «tilbudTrukket», «UTDANNINGSTILBUD_TRUKKET», «TILBUD_TRUKKET», «trukketTilbud» i fs-plattform, fs-admin og min-kompetanse (SOKNAD_TRUKKET i `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/KvitteringMeldingService.java:211-241` gjelder søkerens trekk av søknad; Kvitteringstype i `kommunikasjon.graphqls:249` har ingen type for trukket tilbud). Delen har `@openquestion` |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved deltakende organisasjon forsøker å trekke etter trekkfristen | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1067-1083` avviser med UtdanningstilbudTrekkfristPassertException; en deltakende organisasjon får aldri trekk-knappen (`UD/UtdanningstilbudDetails.tsx:136-137`, isOpptakOwner), så muligheten er skjult. Funnet av en annen grunn enn fristen: knappen styres av rolle og redigeringsfase (`UD/utils/trekk.ts:8-10`). Delen har `@openquestion` |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud før søknadsåpning | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1086-1126` (slettUtdanningstilbud sletter når opptaksstatus er UPUBLISERT; `SG/opptak/utdanningstilbud.graphqls:32`); `OS/components/UtdanningstilbudActions/UtdanningstilbudActions.tsx:127-137` («Fjern utdanningstilbud»), `OS/components/SlettBody/SlettBody.tsx:11-34`. Forbehold: kravet sier at publisert betyr åpnet for søknad, men koden har ingen egen søknadsåpningshendelse |
| `@OPT-OPT-UTD-026` | Fjerne flere utdanningstilbud av gangen før søknadsåpning | funnet | P: funnet · A: funnet · M: ikke relevant — `SG/opptak/utdanningstilbud.graphqls:215` (utdanningstilbudIder: [ID!]!), `UM:1086-1120` sletter alle i ett kall; `OS/components/SlettBody/SlettBody.tsx:19-27` sender alle valgte rader |
| `@OPT-OPT-UTD-026` | Muligheten til å fjerne utdanningstilbud vises ikke etter søknadsåpning | ikke funnet | P: ikke relevant · A: mangler · M: ikke relevant — `OS/components/UtdanningstilbudActions/UtdanningstilbudActions.tsx:127-137` skjuler «Fjern» bare når redigeringen er stengt (`OS/OpptakSøknadsalternativer.tsx:144`, fase stengt). Opptaksstatus brukes ikke til å skjule handlingen. Søkt etter «publisert», «opptaksstatus», «UPUBLISERT», «åpnet» i `OS` (uten tester): ingen treff. `fs-admin/.changeset/shi-743-opptak-slett-og-trekk.md:7` sier at sletting styres av redigeringsfristen. Delen har `@openquestion` |
| `@OPT-OPT-UTD-026` | Fjerning av utdanningstilbud etter søknadsåpning avvises | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `UM:1108-1116` kaster UtdanningstilbudOpptakErPublisertException før noe slettes; `UM:1099-1106` avviser arkivert opptak. Samme forbehold om publisert og åpnet for søknad. Delen har `@openquestion` |
| `@OPT-OPT-UTD-026` | Deltakende organisasjon fjerner eget utdanningstilbud før redigeringsfristen | funnet | P: funnet · A: funnet · M: ikke relevant — `MIG/V280__opptak_v2_skjema.sql:1182-1187` (delete-policy slipper deltakere inn, se `MIG/V319__opptak_v2_skriving_krever_forvalter.sql:11-18`); `FA/utils/kanEndreUtdanningstilbud.ts:15-27`, `OS/OpptakSøknadsalternativer.tsx:71-91` (canModify og rowIsModifiable i åpen fase). Delen har `@openquestion` |
| `@OPT-OPT-UTD-026` | Deltakende organisasjon kan ikke fjerne eget utdanningstilbud etter redigeringsfristen | ikke funnet | P: mangler · A: funnet · M: ikke relevant — fs-admin skjuler «Fjern» (`OS/OpptakSøknadsalternativer.tsx:75-77`, erLåstAvFrist). fs-plattform avviser ikke: `UM:1086-1126` sjekker bare opptaksstatus og tilgang, ikke redigeringsfristen (`fs-plattform/opptak/docs/krav-11-opptak-ikke-dekket.md:19`); søkt etter «REDIGERING_STUDIER», «FRIST» i `UM`: bare FRIST_TREKKE_UTDANNINGSTILBUD (`UM:1068-1074`). Scenarioet sier «avvises». Delen har `@openquestion` |
| `@OPT-OPT-UTD-026` | Deltakende organisasjon kan ikke fjerne utdanningstilbud en annen organisasjon tilbyr | ikke funnet | P: mangler · A: funnet · M: ikke relevant — fs-admin gir ikke rad-tilgang for andres tilbud (`FA/utils/kanEndreUtdanningstilbud.ts:15-27`, `OS/OpptakSøknadsalternativer.tsx:79-91`). fs-plattform avviser ikke: delete-policyen (`MIG/V280__opptak_v2_skjema.sql:1182-1187`) sjekker ikke tilbyder, og `MIG/V319__opptak_v2_skriving_krever_forvalter.sql:11-18` sier at dette gjenstår. Delen har `@openquestion` |
| `@OPT-OPT-UTD-026` | Forvaltende organisasjon fjerner utdanningstilbud etter redigeringsfristen | ikke funnet | P: funnet · A: mangler · M: ikke relevant — fs-plattform tillater det (ingen fristsjekk i `UM:1086-1126`, eier slipper inn via `MIG/V280__opptak_v2_skjema.sql:1182-1187`), men fs-admin skjuler «Fjern» for alle, også eier, når fasen er stengt (`OS/components/UtdanningstilbudActions/UtdanningstilbudActions.tsx:127-137`, `OS/OpptakSøknadsalternativer.tsx:144`, test `UtdanningstilbudActions.test.tsx:176-190`, `fs-admin/.changeset/shi-743-opptak-slett-og-trekk.md:7`). Det er det motsatte av det kravet sier |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-002` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | ikke funnet | usikker | `fs-admin/src/domains/opptak/utils/utdanningsinstansFilterUtil.ts:55-67` — UI-sperre finnes, backend sperrer ikke (`UM:131-159`) |
| `@OPT-OPT-UTD-002` | Kan ikke knytte utdanningstilbud til opptaket før redigering åpner | ikke funnet | usikker | `fs-admin/src/domains/opptak/utils/redigeringsfase.ts:18-20` — fs-admin skjuler «legg til» før åpning, backend håndhever ikke |
| `@OPT-OPT-UTD-002` | Kan ikke knytte til eller redigere utdanningstilbud etter at redigering stenger | ikke funnet | usikker | `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakSøknadsalternativer/OpptakSøknadsalternativer.tsx:75-77` — fs-admin låser for ikke-eier, backend håndhever ikke |

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-001` | Listevisning og søk i utdanningstilbud i opptaket | `@draft` | 6/13 | 7 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-002` | Legge til utdanningstilbud i opptak | `@draft` | 5/14 | 5 ikke funnet, 4 usikker |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud fra opptak | `@draft` | 2/5 | 2 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud fra opptak | `@draft` | 4/8 | 4 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Åpent spørsmål:** `@OPT-OPT-UTD-001` «Se relevante utdanningstilbud» — er det lista som kan legges til eller lista over tilbud i opptaket?
- **Åpent spørsmål:** `@OPT-OPT-UTD-001` «Filtrere på utdanningstilbud som mangler kvoter, kvoteprioritering eller plassflyt» — kvoteprioritet eller kvoteprioritering?
- **Åpent spørsmål:** `@OPT-OPT-UTD-001` «Filtrere på utdanningstilbud som mangler dato for tidlig søknadsfrist» — skal scenarioet få `@ref-OPT-OPT-UTD-004` og `@ref-OPT-OVO-FRI-001`?
- **Åpent spørsmål:** `@OPT-OPT-UTD-001` «Filtrere på utdanningstilbud som mangler poenggrense for tidlig opptak» — skal scenarioet få `@ref-OPT-BEH-BEH-014` og `@ref-OPT-OVO-FRI-001`?
- **Åpent spørsmål:** `@OPT-OPT-UTD-002` «Deltakende organisasjoner kan knytte til og redigere utdanningstilbud … (regelen)» — skal regelen få `@depends-on-OPT-OVO-FRI-001`, `@ref-OPT-OPT-UTD-007` og `@ref-OPT-OPT-UTD-003`?
- **Åpent spørsmål:** `@OPT-OPT-UTD-003` «Trekke utdanningstilbud før søknadsåpning» — er trekking før søknadsåpning det samme som å fjerne utdanningstilbudet, og hvilken formulering skal brukes?
- **Åpent spørsmål:** `@OPT-OPT-UTD-003` «Trekke utdanningstilbud etter søknadsåpning» — hva skal skje ved trekk etter publisering (Tind og Puff, SHI-685), og hvem avklarer?
- **Åpent spørsmål:** `@OPT-OPT-UTD-003` «Opptaksforvalter ved deltakende organisasjon forsøker å trekke etter trekkfristen» — skal muligheten være skjult, som i `fjerne_utdanningstilbud.feature`?
- **Åpent spørsmål:** `@OPT-OPT-UTD-026` «Fjerne utdanningstilbud etter søknadsåpning (reglene og scenarioene med `@openquestion`)» — kan ett og ett tilbud fjernes, skal «forespørselen avvises» stå i kravet, og skal reglene få `@ref-OPT-OPT-UTD-003` og `@depends-on-OPT-OVO-FRI-001`?
- **Ikke lest:** i UTD-001 er SQL-betingelsene bak organisasjons-, oppstart- og termin-filteret og søkebetingelsen i `UtdanningstilbudV2Service.java` bare delvis lest; resultatene `funnet` gjelder filternivå. Ingen av kravene her kan leveres uansett.
- **UI-sperre uten backend-sperre:** i UTD-002 er tre «kan ikke»-scenarioer satt til `usikker` fordi fs-admin skjuler handlingen mens fs-plattform ikke håndhever den (`fs-plattform/opptak/docs/krav-11-opptak-ikke-dekket.md:19`). Samme mønster i UTD-026 og UTD-003. Avgjør i kravet om en sperre i UI er nok.
