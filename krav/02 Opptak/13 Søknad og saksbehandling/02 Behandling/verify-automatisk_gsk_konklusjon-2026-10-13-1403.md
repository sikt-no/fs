# Verifisering: automatisk_gsk_konklusjon.feature

- **Dato:** 2026-10-13 14:03
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature` (1 feature-filer)
- **Kode:** `fs-plattform` (da44bb30a2), `fs-admin` (882b51d7c, origin/main)
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei (chrome-devtools-MCP ikke tilgjengelig)

Gating-sett: alle scenarioene i scope, også `@draft`, `@planned` og `@openquestion`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `GVAS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/GskVedtakAutoService.java`
- `EVAL` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/GskKonklusjonEvaluator.java`
- `TBK` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/GskVedtakTilbakekallingService.java`
- `ASS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/AutomatiskSaksbehandlingService.java`
- `GVS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/gskvedtak/GskVedtakService.java`
- `COND` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/gskvedtak/GskVedtakConditions.java`
- `SHJ` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `GQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/gsk.graphqls`
- `GSKCard` = `fs-admin/src/domains/soknadsbehandling/features/GSKCard/GSKCard.tsx`
- `SAKLAYOUT` = `fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/layout.tsx`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Automatisk GSK-konklusjon | 9/24 | fs-plattform, fs-admin | fs-plattform mangler gjenbruk av konklusjoner fra tidligere opptak, en utløser ved nytt og annullert vitnemål, og sjekken av avsluttet opptak ved tilbakekalling. fs-admin tilbyr negative konklusjoner når søknaden ikke har noen, og viser verken annulleringsårsaken eller hva konklusjonen bygger på. |

Gjenstår: fs-plattform, fs-admin 1, ingen 0.

## Oppsummering

- Scenarioer: 9 funnet, 11 ikke funnet, 4 usikker, av 24
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Vitnemål som gir generell studiekompetanse | funnet | P: funnet · A: ikke relevant — `GVAS:77-89` krever ett vitnemål som ikke er annullert, med utstedelsesdato. `EVAL:58-71` krever løp med grunnlagskode, GSK på vitnemålet og bestått seksfagskontroll. `GVAS:165-176` lagrer KVALIFISERT med grunnlagskoden fra løpet og utstedelsesdatoen som grunnlagsdato. Kjøres fra `ASS:86,114` |
| `@OPT-BEH-BEH-015` | Grunnlagskoder som settes automatisk | funnet | P: funnet · A: ikke relevant — `GVAS:145-153` henter grunnlagskoden fra `vgs_loep`. `MIG/V275__vgs_loep.sql:29` og dataene der har nøyaktig AØA, RFA og TEK (R94), og KLS og KLY (KL) |
| `@OPT-BEH-BEH-015` | Ingen konklusjon fra vitnemålet når <grunn> | funnet | P: funnet · A: ikke relevant — alle seks radene: flere vitnemål og bare kompetansebevis `GVAS:81`, mangler utstedelsesdato `GVAS:85-87`, løpet gir ikke GSK `EVAL:58-63`, vitnemålet sier ikke GSK `EVAL:64-66`, seksfagskontrollen `EVAL:67-69` (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/kontrollmotor/Kravelementer.java:1263`) |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra tidligere samordna opptak | ikke funnet | P: mangler · A: ikke relevant — `GVAS:136-143` ser bare etter konklusjoner i samme opptak. Kolonnen `kilde_opptak_kode` (`MIG/V374__gsk_vedtak_opptaksnokkel.sql:14-17`) og vedtakkilden `GJENBRUK` (`MIG/V375__gsk_vedtak_endringslogg.sql:280-288`) finnes, men ingen kode bruker dem. Søkt etter «gjenbruk», «reuse», «tidligere opptak», «previous», «kilde_opptak», «kildeOpptak», «GJENBRUK» i Java, graphqls og migrasjoner |
| `@OPT-BEH-BEH-015` | Vitnemålet går foran tidligere konklusjon | ikke funnet | P: mangler · A: ikke relevant — vitnemålet er eneste kilde (`GVAS:64-89`). Det finnes ingen rekkefølge mellom vitnemål og tidligere konklusjon, fordi tidligere konklusjoner ikke leses |
| `@OPT-BEH-BEH-015` | Bare den siste tidligere konklusjonen gjenbrukes | ikke funnet | P: mangler · A: ikke relevant — gjenbruk finnes ikke (se `GVAS:136-143`), så det finnes ingen regel for hvilken tidligere konklusjon som gjelder |
| `@OPT-BEH-BEH-015` | Negative konklusjoner gjenbrukes ikke | usikker | P: delvis · A: ikke relevant — utfallet stemmer bare fordi gjenbruk ikke finnes: `GVAS:64-89` leser ingen tidligere konklusjoner. Ingen kode skiller negative fra positive ved gjenbruk |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra lokalt opptak | ikke funnet | P: mangler · A: ikke relevant — som gjenbruk fra tidligere samordna opptak (`GVAS:136-143`) |
| `@OPT-BEH-BEH-015` | Gjenbruke kvalitetssikret konklusjon fra FS-klienten | ikke funnet | P: mangler · A: ikke relevant — som gjenbruk fra tidligere samordna opptak. Søkt også etter «kvalitetssikret» i Java, graphqls og migrasjoner: ingen oversikt over kvalitetssikrede konklusjoner |
| `@OPT-BEH-BEH-015` | Konklusjon fra FS-klienten som ikke er kvalitetssikret, gjenbrukes ikke | usikker | P: delvis · A: ikke relevant — utfallet stemmer bare fordi gjenbruk ikke finnes (`GVAS:64-89`) |
| `@OPT-BEH-BEH-015` | Konklusjon som bygger på et annullert vitnemål gjenbrukes ikke | usikker | P: delvis · A: ikke relevant — utfallet stemmer bare fordi gjenbruk ikke finnes. Annullerte vitnemål filtreres bare ut av vitnemålsveien (`GVAS:79`) |
| `@OPT-BEH-BEH-015` | Ingen grunnlag for generell studiekompetanse | funnet | P: funnet · A: funnet — `GVAS:64-90` returnerer uten å lagre noe, og `ASS:114-120` går videre. `GSKCard:309` viser «ikke behandlet» når søknaden ikke har konklusjon |
| `@OPT-BEH-BEH-015` | Konklusjon på søknaden overskrives ikke | funnet | P: funnet · A: ikke relevant — `GVAS:65-67,136-143` stopper når søkeren har en konklusjon i opptaket, uansett organisasjon, for alle typene i `COND:14-15` |
| `@OPT-BEH-BEH-015` | Systemet setter aldri en negativ konklusjon | funnet | P: funnet · A: ikke relevant — `GVAS:50,169`: den eneste automatiske skrivingen bruker KVALIFISERT |
| `@OPT-BEH-BEH-015` | Overskrive positiv konklusjon med negativ konklusjon | funnet | P: funnet · A: funnet — `GVS:399-416` tillater IKKE_KVALIFISERT ved endring, og `GVS:598-619` oppdaterer konklusjonen. `GSKCard:322-375`: «Rediger», så «Ikke kvalifisert» med årsak, så `endreGskVedtak` |
| `@OPT-BEH-BEH-015` | Legge til positiv konklusjon når ingen finnes | funnet | P: funnet · A: funnet — `GVS:457-463,535-553` oppretter KVALIFISERT med grunnlag. `GSKCard:224-240,352-362`: «Godkjenn» kaller `opprettGskVedtak` med KVALIFISERT |
| `@OPT-BEH-BEH-015` | Bare positive konklusjoner kan legges til når ingen finnes | ikke funnet | P: funnet · A: mangler — `GVS:457-462` avviser IKKE_KVALIFISERT når søknaden ikke har konklusjon (`GskAvslagUtenKonklusjonException`). `GSKCard:322-351` viser likevel «Ikke kvalifisert» ved siden av «Godkjenn», og valget gir feil fra API-et |
| `@OPT-BEH-BEH-015` | Nytt vitnemål når søknaden ikke har konklusjon | ikke funnet | P: mangler · A: ikke relevant — ingen utløser ved nytt vitnemål. `SHJ:134,392` henter vitnemål fra KREG, men starter ikke automatikken. Eneste kaller av `behandleSakAutomatisk` er knappen i `SAKLAYOUT:108`. Søkt etter «behandleSakAutomatisk», «AutomatiskSaksbehandlingService», «GskVedtakAutoService» |
| `@OPT-BEH-BEH-015` | Nytt vitnemål når søknaden har konklusjon | funnet | P: funnet · A: ikke relevant — `GVAS:65-67`: en ny kjøring stopper når søknaden har konklusjon |
| `@OPT-BEH-BEH-015` | Automatisk konklusjon trekkes tilbake når vitnemålet annulleres | usikker | P: funnet · A: delvis — `TBK:70-116` trekker tilbake automatiske, ulåste KVALIFISERT-konklusjoner med vitnemålsnummeret, og setter KVALIFISERT_MEN_ANNULLERT med årsak AVM (annullert vitnemål). fs-admin sender kilde NOM ved manuell endring (`GSKCard:231`), så endrede konklusjoner røres ikke. `GSKCard:83` henter `annulleringsdato`, ikke `annulleringsarsak`: kortet viser «Annullert», men ikke at det er vitnemålet som er annullert |
| `@OPT-BEH-BEH-015` | Gjenbrukt konklusjon trekkes tilbake når vitnemålet annulleres | ikke funnet | P: mangler · A: ikke relevant — gjenbruk finnes ikke, og `TBK:76` velger bare konklusjoner med kilde AUT |
| `@OPT-BEH-BEH-015` | Konklusjon i avsluttet opptak trekkes ikke tilbake | ikke funnet | P: mangler · A: ikke relevant — `TBK:70-116` sjekker ikke om opptaket er avsluttet, og trekker tilbake også der. Søkt etter «avsluttet», «avslutt», «opptakstatus», «er_avsluttet» |
| `@OPT-BEH-BEH-015` | Annulleringen oppdages uten at søkeren endrer søknaden | ikke funnet | P: mangler · A: ikke relevant — tilbakekallingen kalles bare fra `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/HentVgsVitnemaalService.java:130-131`, via `SHJ:394` (søknadshendelse). `fs-plattform/kreg/kreg-service/src/main/java/no/sikt/nvb/batch/HentAnnullerteFraNVB2.java` merker annulleringer i KREG, kaller ikke opptak, og er av i produksjon |
| `@OPT-BEH-BEH-015` | Se hva den automatiske konklusjonen bygger på | ikke funnet | P: delvis · A: mangler — `GQL:323,329,335` har `vedtakkilde` (AUT), `vitnemaalsnummer` og `merknadAutomatisk`, men ingenting for tidligere opptak. `GSKCard:60-90` henter ingen av feltene, og `fs-admin/src/domains/soknadsbehandling/features/GSKCard/components/GSKHistory.tsx:76-106` viser verken kilde eller hva konklusjonen bygger på |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Vitnemålet går foran tidligere konklusjon | usikker | ikke funnet | `GVAS:64-89` — scenarioet beskriver et valg mellom to kilder, og den andre kilden finnes ikke. At utfallet stemmer trivielt, er ikke bevis |
| `@OPT-BEH-BEH-015` | Bare den siste tidligere konklusjonen gjenbrukes | usikker | ikke funnet | `GVAS:136-143` — scenarioet beskriver hvilken tidligere konklusjon som velges, og gjenbruk finnes ikke |

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Automatisk GSK-konklusjon | `@planned` | 9/24 | 11 ikke funnet, 4 usikker. Brukeren svarte «Kunne ikke verifisere» |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Feature-ID endret:** kravet hadde `@OPT-BEH-BEH-009` da denne rapporten ble skrevet. Samme ID sto på `finne_søknader_om_tidlig_opptak.feature:35` (`@in-progress`, oppgaven `tasks/opptak/tidlig-opptak`), så GSK-kravet har fått `@OPT-BEH-BEH-015` (PR #726), og rapporten bruker den nye ID-en.
- **Automatikken starter ikke av seg selv:** egenskapen sier at systemet ser etter grunnlag «når en søknad kommer inn». GSK-steget kjøres bare fra `Mutation.behandleSakAutomatisk` (`ASS:86,114`, `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/automatisk-saksbehandling.graphqls:52-58`), og eneste kaller er knappen «Behandle sak automatisk» i `SAKLAYOUT:108`.
- **Ny konklusjon etter annullering:** `COND:14-15` regner KVALIFISERT_MEN_ANNULLERT som gjeldende konklusjon, så automatikken stopper (`GVAS:65-67`) også når søkeren får et nytt vitnemål etter annulleringen. Kommentaren på #723 ønsker at konklusjonen da kan bli positiv igjen. Kravet sier ikke hva som skal skje. Avklares med `fs-krav`.
- **Gjenbruk er forberedt i databasen:** `kilde_opptak_kode` (`MIG/V374__gsk_vedtak_opptaksnokkel.sql:14-17`) og vedtakkilden `GJENBRUK` (`MIG/V375__gsk_vedtak_endringslogg.sql:280-288`) finnes, men ingen kode setter dem.
- **Vitnemål og kompetansebevis sammen:** `GVAS:81` krever nøyaktig ett dokument som ikke er annullert. En søker med ett vitnemål og ett kompetansebevis får ingen automatisk konklusjon. Kravet sier ikke hva som skal skje da.
- **Kilden ved manuell endring:** `GVS:596-619` tar kilden fra input og lar `merknad_automatisk` stå. fs-admin sender alltid `NOM` (`GSKCard:231`, med en kommentar om at kilden burde settes på backend). Sender en annen klient `AUT` ved endring, blir en manuelt endret konklusjon trukket tilbake som automatisk (`TBK:76`).
- **Semi-automatisk sti:** `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/SettGskKonklusjonService.java:152` bruker en dynamisk KLY/RFA-fallback for løp uten grunnlagskode (`EVAL:83-95`). Den er ikke beskrevet i kravet.
- **Issuet er utdatert:** #723 sier at konklusjoner fra FS-klienten ikke gjenbrukes, og at kravet er `@draft`. Kravet gjenbruker kvalitetssikrede konklusjoner fra FS-klienten og er `@planned`. Varsling til saksbehandlende organisasjoner når en konklusjon blir negativ, som kommentaren på issuet tar opp, står ikke i kravet.
- **Ikke sjekket:** min-kompetanse, fordi ingen scenarioer gjelder det søkeren ser eller gjør.
