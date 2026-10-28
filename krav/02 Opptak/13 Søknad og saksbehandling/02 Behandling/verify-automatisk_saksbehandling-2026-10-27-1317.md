# Verifisering: kravene i PR #818 (automatisk saksbehandling)

- **Dato:** 2026-10-27 13:17
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/` (`automatisk_gsk_konklusjon`, `automatisk_grunnlag`, `automatisk_kvalifisering`, `automatisk_poengberegning`, `beregne_automatisk_på_nytt`, `ferdigbehandle_sak`, `søknadsmangler`), `krav/02 Opptak/14 Plasstildeling/03 Tildeling/starte_plasstildeling.feature`, `krav/_Flyter/10 Opptaksløpet/` (`automatisk_saksbehandling`, `opptaksløpet`) (10 feature-filer)
- **Kode:** `fs-plattform` (main, 97b8a89e28, oppdatert), `fs-admin` (main, 3c24c44c8, oppdatert)
- **Åpne MR-er:** 4 MR-er i fs-admin, 0 i fs-plattform (0 med kode for kravene)
- **Omfang:** alle krav uansett status (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 8 kontrollører (`fs-verify-kontroll`), 1–3 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `OS/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/`
- `MIG/` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `SGS` = `OS/autosak/SetteGrunnlagService.java`
- `MS` = `OS/saksbehandling/SakMangelService.java`
- `MT` = `OS/regelverk/MangeltypeService.java`
- `MM` = `OS/kommunikasjon/MangelMeldingService.java`
- `MP` = `OS/saksbehandling/ManglerPresentertService.java`
- `KO` = `OS/regelverk/kvalifisering/KvalifiseringOppdateringService.java`
- `GQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/mangel.graphqls`
- `MC` = `fs-admin/src/domains/soknadsbehandling/features/SakDrawer/components/ManglerCard`
- `MK` = `fs-admin/src/domains/regelverk/features/Mangelkoder/MangelkodeDetails/MangelkodeDetails.tsx`
- `V457` = `MIG/V457__soknadsmangel_bare_publiserte.sql`, `V291` = `MIG/V291__saksbehandling_skjema.sql`

## Oppsummering

- Scenarioer: 70 funnet, 96 ikke funnet, 31 usikker, av 197
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 10
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Fremdrift for flyter

Fremdriften kommer fra statusen på delen av kravene fasene bygger på (`@depends-on-`, og ankrene innenfor reglene i «…», ellers alle ankrene, ellers reglene i «…»). Den endrer ingen tagger.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Vitnemålet med påstanden GSK avgjør om saken behandles helautomatisk | `@FLY-OPT-SAK-001` (`@planned`), `@OPT-BEH-BEH-015` (`@planned`, Regel: Opptakssystemets påstand om GSK på vitnemålet), `@OPT-BEH-BEH-025` (`@draft`, Regel: Bare saker der søkeren har ett vitnemål, med påstanden GSK, behandles helautomatisk) | nei |
| `@FLY-OPT-AUT-001` | Søknaden får grunnlag fra vitnemålet | `@FLY-OPT-SAK-001` (`@planned`), `@OPT-BEH-BEH-019` (`@draft`) | nei |
| `@FLY-OPT-AUT-001` | Poengene beregnes fra grunnlaget og rangeringsregelverket | `@FLY-OPT-SAK-001` (`@planned`), `@OPT-BEH-BEH-018` (`@draft`), `@OPT-REG-RAN-001` (`@implemented`), `@OPT-REG-RAN-002` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Kravelementene avgjør om søkeren er kvalifisert | `@FLY-OPT-SAK-001` (`@planned`), `@OPT-BEH-BEH-020` (`@draft`), `@OPT-BEH-BEH-008` (`@planned`, Regel: Saken får mangler for kravelementene søkeren ikke oppfyller) | nei |
| `@FLY-OPT-AUT-001` | Søkeren plasseres i kvote | `@FLY-OPT-SAK-001` (`@planned`), `@OPT-BEH-BEH-012` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Saken blir ferdig behandlet og er med i plasstildelingen | `@FLY-OPT-SAK-001` (`@planned`), `@OPT-BEH-BEH-025` (`@draft`, Regel: Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort), `@OPT-PLA-TIL-001` (`@draft`) | nei |
| `@FLY-OPT-AUT-001` | Søknadsalternativene beregnes på nytt når regelverket er rettet | `@FLY-OPT-SAK-001` (`@planned`), `@OPT-BEH-BEH-026` (`@draft`) | nei |
| `@FLY-OPT-OPT-001` | Opptaket klargjøres før søknadsåpning | – | mangler krav |
| `@FLY-OPT-OPT-001` | Søkeren finner studier og søker | – | mangler krav |
| `@FLY-OPT-OPT-001` | Søknadsalternativene fordeles til saksbehandlende organisasjoner | `@FLY-OPT-SAK-001` (`@planned`) | nei |
| `@FLY-OPT-OPT-001` | Søkeren får tilbudsgaranti i tidlig opptak | – | mangler krav |
| `@FLY-OPT-OPT-001` | Søknadene behandles, og studieplassene tildeles | `@FLY-OPT-AUT-001` (`@draft`) | nei |
| `@FLY-OPT-OPT-001` | Søknader og utdanningstilbud endres etter søknadsåpning | – | mangler krav |

`@FLY-OPT-AUT-001`: 0 av 7 faser levert.
`@FLY-OPT-OPT-001`: 0 av 6 faser levert.

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-019` | `@OPT-REG-GRU-001` Grunnlag og mangelkoder | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-002` Kravelement | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-001` Kompetanseregelverk | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-018` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | |
| `@FLY-OPT-AUT-001` | `@FLY-OPT-SAK-001` Saksbehandlertildeling | 1 | `@planned` | – | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-REG-RAN-001` Rangeringsregelverk | 1 | `@implemented` | – | |
| `@FLY-OPT-AUT-001` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-012` Automatisk kvoteplassering | 1 | `@implemented` | – | |
| `@FLY-OPT-OPT-001` | `@FLY-OPT-SAK-001` Saksbehandlertildeling | 1 | `@planned` | – | ikke levert, `@FLY-OPT-OPT-001` kan ikke leveres før dette |

Avhengigheter: 9 på nivå 1, 2 av dem ikke `@implemented`. Avhengighetene mellom kravene i scope (f.eks. `@OPT-BEH-BEH-018` → `@OPT-BEH-BEH-015`) er ikke med, fordi kravene er i scope.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Vitnemål som gir generell studiekompetanse | ikke funnet | Ingen egen påstand lagres på vitnemålet: `vgs_dokument` har bare `gsk_ok` fra KREG (`MIG/V176__kompetanse_vgs.sql:113`, fra `paastandOmGsk` i `OS/vgs/KregVgsParser.java:104`), og importen (`OS/vgs/HentVgsVitnemaalService.java:108-136`) beregner ingen GSK. Den automatiske behandlingen skriver `gsk_vedtak` med grunnlagstype fra `vgs_loep` og grunnlagsdato = `dato_utstedt` (`OS/autosak/gsk/GskVedtakAutoService.java:165-178`). Søkt etter «paastand», «påstand», «gsk_paastand», «gsk_beregnet», ALTER TABLE vgs_dokument |
| `@OPT-BEH-BEH-015` | Påstanden fra KREG brukes ikke | ikke funnet | `OS/autosak/gsk/GskVedtakAutoService.java:113` leser `gsk_ok`, og `OS/autosak/gsk/GskKonklusjonEvaluator.java:64-65` gir `GSK_PAASTAND_MANGLER` når den er usann |
| `@OPT-BEH-BEH-015` | Hvert vitnemål får sin egen påstand | ikke funnet | Ingen påstand per vitnemål. Automatikken stopper ved mer enn ett ikke-annullert dokument (`GskVedtakAutoService.java:81-82`, `IKKE_ETT_VGS_DOKUMENT`) |
| `@OPT-BEH-BEH-015` | Grunnlagskoder som settes automatisk | ikke funnet | Ingen påstand. Grunnlagstypen på det automatiske vedtaket kommer fra `vgs_loep` (`GskKonklusjonEvaluator.java:70-71`), og `MIG/V275__vgs_loep.sql` har KLY, RFA, KLS, AØA og TEK |
| `@OPT-BEH-BEH-015` | Påstanden er at søkeren ikke har GSK når <grunn> | ikke funnet | Ingen negativ påstand lagres. Tilsvarende årsaker bare som `IngenAutomatikk`: `GskVedtakAutoService.java:85-87`, `GskKonklusjonEvaluator.java:58-62, 67-68` |
| `@OPT-BEH-BEH-015` | Annullert vitnemål får ingen påstand | ikke funnet | Ingen påstand. Automatikken ser bort fra annullerte (`GskVedtakAutoService.java:79`) |
| `@OPT-BEH-BEH-015` | Kompetansebevis får ingen påstand | ikke funnet | Ingen påstand. Automatikken krever dokumenttype `VM` (`GskVedtakAutoService.java:81`) |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra vitnemålet | ikke funnet | Ingen konklusjon ved import (`HentVgsVitnemaalService.java:108-136`). Steg 0a i den automatiske behandlingen (`OS/autosak/AutomatiskSaksbehandlingService.java:114`) setter KVALIFISERT (`GskVedtakAutoService.java:165-178`) — det kjente bruddet i flyten |
| `@OPT-BEH-BEH-015` | Påstanden om at søkeren ikke har GSK gir ingen konklusjon | usikker | Ingen påstand finnes, men utfallet stemmer: ingen konklusjon settes når vitnemålet ikke gir GSK (`AutomatiskSaksbehandlingService.java:115-120`) |
| `@OPT-BEH-BEH-015` | Vitnemålet med senest utstedelsesdato brukes | ikke funnet | Med to vitnemål stopper automatikken (`GskVedtakAutoService.java:81-82`). Halvautomatisk vei der saksbehandleren velger (`OS/autosak/gsk/SettGskKonklusjonService.java:104-162`) |
| `@OPT-BEH-BEH-015` | Alle søknader uten konklusjon oppdateres | ikke funnet | Én sak om gangen (`GskVedtakAutoService.java:64`); importen går ikke gjennom søknadene |
| `@OPT-BEH-BEH-015` | Søknader i avsluttede opptak oppdateres ikke | ikke funnet | Ingen sjekk av opptaksstatus i `OS/autosak/gsk/` eller `OS/vgs/` |
| `@OPT-BEH-BEH-015` | Nytt vitnemål fra KREG etter at søknaden er opprettet | ikke funnet | Vitnemål hentes bare fra `SoknadshendelseJobb.java:392-394`. Ingen KREG-abonnement |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra tidligere samordna opptak | ikke funnet | Bare datamodell: `kilde_opptak_kode` (`MIG/V374__gsk_vedtak_opptaksnokkel.sql:14,17-18`), vedtakskildene `GJENBRUK`/`IMP` (`MIG/V375__gsk_vedtak_endringslogg.sql:282-288`); ingen kode skriver dem |
| `@OPT-BEH-BEH-015` | Vitnemålet går foran tidligere konklusjon | ikke funnet | Ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Bare den siste tidligere konklusjonen gjenbrukes | ikke funnet | Ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Negative konklusjoner gjenbrukes ikke | ikke funnet | Ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra lokalt opptak | ikke funnet | Ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Gjenbruke kvalitetssikret konklusjon fra FS-klienten | ikke funnet | Ingen gjenbruk, ingen oversikt over kvalitetssikrede konklusjoner |
| `@OPT-BEH-BEH-015` | Annullert konklusjon gjenbrukes ikke | ikke funnet | Ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Konklusjon som bygger på et annullert vitnemål gjenbrukes ikke | ikke funnet | Ingen gjenbruk |
| `@OPT-BEH-BEH-015` | Ingen grunnlag for generell studiekompetanse | funnet | `AutomatiskSaksbehandlingService.java:114-120`; fs-admin `src/domains/soknadsbehandling/features/GSKCard/GSKCard.tsx:308-309,322-362` |
| `@OPT-BEH-BEH-015` | Konklusjon på søknaden overskrives ikke | funnet | `GskVedtakAutoService.java:65-67,136-143`; PK `MIG/V374__gsk_vedtak_opptaksnokkel.sql:52` |
| `@OPT-BEH-BEH-015` | Systemet setter aldri en negativ konklusjon | funnet | `GskVedtakAutoService.java:169` setter alltid KVALIFISERT; `GskKonklusjonEvaluator.java:58-74`; `GskVedtakTilbakekallingService.java:106` |
| `@OPT-BEH-BEH-015` | Overskrive positiv konklusjon med negativ konklusjon | funnet | `GSKCard.tsx:322-351,234-239`; `OS/soknad/gskvedtak/GskVedtakService.java:483-510` |
| `@OPT-BEH-BEH-015` | Legge til positiv konklusjon når ingen finnes | funnet | `GSKCard.tsx:352-362,240-244`; `GskVedtakService.java:457-463` |
| `@OPT-BEH-BEH-015` | Bare positive konklusjoner kan legges til når ingen finnes | ikke funnet | `fs-admin/src/domains/soknadsbehandling/features/GSKCard/GSKCard.tsx:322-351` viser «Ikke kvalifisert» også når søknaden ikke har noen konklusjon (`!gjeldendeGskVedtak`). Backend avviser en negativ første konklusjon (`OS/soknad/gskvedtak/GskVedtakService.java:457-461`), men valget finnes på skjermen |
| `@OPT-BEH-BEH-015` | Automatisk konklusjon trekkes tilbake når vitnemålet annulleres | funnet | `HentVgsVitnemaalService.java:130-131` → `GskVedtakTilbakekallingService.java:70-79,105-116`; `GSKCard.tsx:164,301-305` |
| `@OPT-BEH-BEH-015` | Gjenbrukt konklusjon trekkes tilbake når vitnemålet annulleres | ikke funnet | Tilbakekallingen tar bare kilde `AUT` (`GskVedtakTilbakekallingService.java:76`), gjenbruk finnes ikke |
| `@OPT-BEH-BEH-015` | Konklusjon i avsluttet opptak trekkes ikke tilbake | ikke funnet | `GskVedtakTilbakekallingService.java:70-79` filtrerer ikke på opptaksstatus |
| `@OPT-BEH-BEH-015` | Annulleringen oppdages uten at søkeren endrer søknaden | ikke funnet | Bare fra `SoknadshendelseJobb.java:392-394`; ingen KREG-abonnement |
| `@OPT-BEH-BEH-015` | Se hva den automatiske konklusjonen bygger på | ikke funnet | API har `vedtakkilde`, `merknadAutomatisk` (`gsk.graphqls:323,335`), fs-admin henter dem ikke (`GSKCard.tsx:64-95`, `GSKHistory.tsx:17-49`) |
| `@OPT-BEH-BEH-015` | Se hvilket opptak en gjenbrukt konklusjon kommer fra | ikke funnet | `kilde_opptak_kode` er ikke i GraphQL-typen `GskVedtak` (`gsk.graphqls:300-341`) |
| `@OPT-BEH-BEH-019` | Grunnlag ut fra alder og førstegangsvitnemål | funnet | `SGS:131,301-344` — førstegangsvitnemål, aldersgrense med operator fra regelverket, prioritet |
| `@OPT-BEH-BEH-019` | Bare grunnlag i søknadsalternativenes regelverk kan settes | funnet | `SGS:133-152,236-253` |
| `@OPT-BEH-BEH-019` | Grunnlag uten egenskaper for automatikken settes ikke automatisk | funnet | `SGS:255-259` |
| `@OPT-BEH-BEH-019` | Førstegangsvitnemål går foran | funnet | `SGS:287-288,330-335` |
| `@OPT-BEH-BEH-019` | Flere grunnlag passer like godt | funnet | `SGS:289-298` — advarsel og lavest grunnlagskode |
| `@OPT-BEH-BEH-019` | Søker med førstegangsvitnemål får både "VOV" og "VES" | ikke funnet | `SGS:170,183-205` setter bare én vinner; søkt «flere grunnlag», «kombin», «ulovlig», «PERSONKVALGRUNNLAG» |
| `@OPT-BEH-BEH-019` | Grunnlag som ikke kan kombineres, settes ikke sammen | usikker | Automatikken setter aldri mer enn ett (`SGS:183-205`), men ingen regel for kombinasjoner, og manuelt valg sjekker det ikke (`OS/saksbehandling/LeggTilGrunnlagService.java:162-193`) |
| `@OPT-BEH-BEH-019` | Ingen grunnlag settes automatisk når <grunn> | funnet | `SGS:110-129,170-181` |
| `@OPT-BEH-BEH-019` | Grunnlag fra vitnemålet saksbehandleren har valgt | ikke funnet | `SGS:110-114` kaster alltid ved to vitnemål; `SGS:371-376`; søkt «valgtVitnem», «valgt_vgdoknr», «lagt_til_grunn» |
| `@OPT-BEH-BEH-019` | Saksbehandleren starter den automatiske behandlingen | funnet | `fs-admin/src/domains/soknadsbehandling/features/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:28-36` → `OS/autosak/AutomatiskSaksbehandlingService.java:122-124` |
| `@OPT-BEH-BEH-019` | Grunnlag fra utdanningstilbudet når søknadsalternativet opprettes | ikke funnet | «KVALGRUNNLAGKODE_AUTOMATISK» bare i `fs-plattform/sis/sis-db/src/main/resources/configuration.xml:4980` (gammel FS-database); søkt «grunnlag_automatisk», «automatiskGrunnlag», «standardgrunnlag» |
| `@OPT-BEH-BEH-019` | Grunnlag som saksbehandleren legger til, låser grunnlagene | funnet | `OS/saksbehandling/LeggTilGrunnlagService.java:113-130`; `SGS:99-105,227-234`; fs-admin `GrunnlagCard/GrunnlagCard.tsx:63,115,161` |
| `@OPT-BEH-BEH-019` | Automatikken setter ikke grunnlag på en låst sak | funnet | `SGS:99-105,227-234` |
| `@OPT-BEH-BEH-019` | Automatikken fjerner aldri grunnlag | funnet | `SGS:85-86,187-205` — bare upsert |
| `@OPT-BEH-BEH-019` | Saksbehandleren endrer grunnlag som er satt automatisk | funnet | `OS/saksbehandling/FjernGrunnlagService.java:89-106`; `GrunnlagCard.tsx:43-45,87,115` |
| `@OPT-BEH-BEH-019` | Gjøre søknaden tilgjengelig for automatikken igjen | ikke funnet | la_staa skrives bare i `LeggTilGrunnlagService.java:125,128` og `SGS:197`; inputene har ikke laStaa (`sak.graphqls:752-766`) |
| `@OPT-BEH-BEH-019` | Grunnlag utenfor aldersgrensen kan ikke velges manuelt | ikke funnet | `LeggTilGrunnlagService.java:95-130,162-193` validerer ikke alder |
| `@OPT-BEH-BEH-019` | Kvalifisering, poeng og kvoter vurderes på nytt | funnet | `LeggTilGrunnlagService.java:56-59`, `FjernGrunnlagService.java:50-53` → `OS/saksbehandling/PropageringService.java:105-119` |
| `@OPT-BEH-BEH-019` | Se at grunnlaget er satt automatisk | ikke funnet | DB har det (`SGS:198-199,349-361`), GraphQL eksponerer det ikke (`regelverk/kvalifisering.graphqls:143-153`), fs-admin viser ingen markering (`GrunnlagCard.tsx:18-39`) |
| `@OPT-BEH-BEH-019` | Endringsloggen viser at automatikken satte grunnlaget | funnet | `V291__saksbehandling_skjema.sql:1491`; `AutomatiskSaksbehandlingService.java:104-110`; `OS/saksbehandling/AuditKontekst.java:32-54`; fs-admin `AuditLogItem.tsx:70-80` |
| `@OPT-BEH-BEH-020` | Fagkrav som er oppfylt på vitnemålet | funnet | `OS/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:110-143,187-196` — slår opp vitnemålskravkoden (kode1), kjører kontrollmotoren mot vitnemålet og skriver kravet_er_oppfylt; R1M i `OS/autosak/kontrollmotor/KontrollMotor.java:90-95`, `OS/autosak/kontrollmotor/Kravelementer.java:651-653` |
| `@OPT-BEH-BEH-020` | Fagkrav som ikke er oppfylt på vitnemålet | funnet | `OS/autosak/kontrollmotor/KontrollMotor.java:188-200` oppfylt=false; `AutomatiskKravelementVurderingService.java:188` |
| `@OPT-BEH-BEH-020` | Karakteren fra vitnemålet registreres på kravelementet | funnet | `KontrollMotor.java:72-77,188-200`; `AutomatiskKravelementVurderingService.java:180,189` |
| `@OPT-BEH-BEH-020` | Kravelement som ikke er koblet til vitnemålet, vurderes ikke automatisk | funnet | `AutomatiskKravelementVurderingService.java:128-139` — rader uten kode1 hoppes over |
| `@OPT-BEH-BEH-020` | Kravelementet kobles til vitnemålet for hver reform | funnet | `Kravelementer.java:650-653` (R1M dekker også R94-fag); `OS/autosak/kontrollmotor/FagSoek.java:59-61`; kode2 ignoreres (`AutomatiskKravelementVurderingService.java:40-41`) |
| `@OPT-BEH-BEH-020` | Kravelement med ugyldig karakter må vurderes manuelt | usikker | `AutomatiskKravelementVurderingService.java:179-190` — resultat null, merknad «vurder manuelt» (`sak.graphqls:226`), men fs-admin henter ikke merknadAutomatisk (`fs-admin/src/domains/soknadsbehandling/features/KravlisteStudierCard/KravlisteStudierCard.tsx:52-77`), og kravet_er_oppfylt settes fortsatt (linje 188) |
| `@OPT-BEH-BEH-020` | Ingen automatisk vurdering når <grunn> | funnet | `OS/vgs/VgsDokumentVitnemaalService.java:43-54`; `AutomatiskKravelementVurderingService.java:102-105`; `OS/autosak/SetteGrunnlagService.java:110-114` |
| `@OPT-BEH-BEH-020` | Kvalifisert når alle kravelementene i en kravliste er oppfylt | funnet | `OS/regelverk/kvalifisering/KvalifiseringEvaluator.java:146-166`; `OS/regelverk/kvalifisering/KvalifiseringOppdateringService.java:97-117` |
| `@OPT-BEH-BEH-020` | Kvalifisert når én av kravlistene er oppfylt | funnet | `KvalifiseringEvaluator.java:159-161,297-311` |
| `@OPT-BEH-BEH-020` | Karakteren må nå karakterkravet | funnet | `KvalifiseringEvaluator.java:203-214` |
| `@OPT-BEH-BEH-020` | Søkeren kan være kvalifisert på ett grunnlag og ikke på et annet | funnet | `KvalifiseringOppdateringService.java:115-117,159-183`; `OS/regelverk/kvalifisering/KvalifiserKravelementUnntakService.java:50-61` |
| `@OPT-BEH-BEH-020` | Kvalifisert per poengvariant | usikker | Kvalifiseringen er per grunnlag, ikke per poengvariant (`OS/regelverk/kvalifisering/KvalifiseringOppdateringService.java:85-118`). Et grunnlag som krever førstegangsvitnemål, gis ikke uten førstegangsvitnemål (`OS/autosak/SetteGrunnlagService.java:131,306-307,321-333`), og kan dekke det samme. Det er det åpne spørsmålet i kravet |
| `@OPT-BEH-BEH-020` | Saksbehandleren starter den automatiske behandlingen | funnet | `fs-admin/src/domains/soknadsbehandling/features/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:28-36` → `OS/autosak/AutomatiskSaksbehandlingService.java:140,165-173` |
| `@OPT-BEH-BEH-020` | Kravene vurderes når saksbehandleren har satt sammen grunnlaget | ikke funnet | Vurderingen krever ett dokument (`AutomatiskKravelementVurderingService.java:216-225`, `VgsDokumentVitnemaalService.java:48`); `OS/saksbehandling/LagreVitnemalUtregningService.java:75-78` kjører bare poeng-propagering |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren vurderer, låses | funnet | `OS/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:207-245` |
| `@OPT-BEH-BEH-020` | Låst kravelement vurderes ikke på nytt | funnet | `AutomatiskKravelementVurderingService.java:122,195` |
| `@OPT-BEH-BEH-020` | Nullstilt kravelement kan vurderes automatisk igjen | funnet | `KvalifiserKravelementV4Service.java:42-45,231-245`; `KravlisteStudierCard.tsx:190-193,219-222` |
| `@OPT-BEH-BEH-020` | Automatikken endrer aldri unntak per grunnlag | funnet | `AutomatiskKravelementVurderingService.java:187-196` — skriver aldri `sak_kvalifisering_kravelement_unntak` |
| `@OPT-BEH-BEH-020` | Nye kravelementer på en søknad saksbehandleren har vurdert | ikke funnet | `AutomatiskKravelementVurderingService.java:110-124` vurderer alle rader med la_staa=false; ingen sak-nivå-lås |
| `@OPT-BEH-BEH-020` | Kravelementer for et grunnlag som fjernes, beholder vurderingen | funnet | `OS/regelverk/kvalifisering/KvalifiseringKravelementV2OppdateringService.java:55-74` |
| `@OPT-BEH-BEH-020` | Kravelementer for et nytt grunnlag vurderes | funnet | `KvalifiseringKravelementV2OppdateringService.java:78-86`; `OS/saksbehandling/PropageringService.java:105-119`; `AutomatiskKravelementVurderingService.java:110-124` |
| `@OPT-BEH-BEH-020` | Se at kravelementet er vurdert automatisk | ikke funnet | API (`sak.graphqls:222-230`), fs-admin henter ikke (`KravlisteStudierCard.tsx:52-77`, `KravOppsummering.tsx:39-55`) |
| `@OPT-BEH-BEH-020` | Endringsloggen viser at automatikken vurderte kravelementet | funnet | `V291__saksbehandling_skjema.sql:1492`; `AutomatiskKravelementVurderingService.java:61,150-156`; `OS/audit/AuditContext.java:104-113`; fs-admin `AuditLogCard/AuditLogItem/AuditLogItem.tsx:70-80` |
| `@OPT-BEH-BEH-020` | Finne søkere som ikke er kvalifisert | funnet | fs-admin `SakOverviewView/components/SakFilter/SakFilter.tsx:109-113` → `OS/saksbehandling/SakFilterConditions.java:423-424,452-465` |
| `@OPT-BEH-BEH-018` | Poeng beregnes fra søkerens eneste vitnemål | funnet | `OS/regelverk/poeng/AutomatiskPoengberegningService.java:116-145` — for hver aktiv, ulåst poengrad med vitnemålskravkode bygges søkerens ene vitnemål og poenget regnes ut og lagres (`PoengService.java:171-201`). Kalles fra `autosak/AutomatiskSaksbehandlingService.java:134`. Poengradene kommer fra grunnlaget via `saksbehandling/PoengRadOppdateringService.java:55-73` |
| `@OPT-BEH-BEH-018` | \<poeng\> beregnes fra vitnemålet | funnet | `OS/autosak/kontrollmotor/KontrollMotor.java:168-170` — KAR, REA og SPR er registrert som tallberegninger; poengtypen kobles via `poengtype_vitnemalskrav_kode` (`PoengService.java:226-241`) |
| `@OPT-BEH-BEH-018` | Poengtype som ikke er koblet til beregningen, beregnes ikke | funnet | `OS/regelverk/poeng/AutomatiskPoengberegningService.java:149-153` — uten vitnemålskravkode og uten poengalgoritme hoppes raden over |
| `@OPT-BEH-BEH-018` | Opplastet dokumentasjon hindrer ikke beregningen | funnet | `OS/vgs/VgsDokumentVitnemaalService.java:42-55` — bare dokumentene i `kompetanse.vgs_dokument` telles (skrives bare fra KREG, `vgs/VgsLagringService.java:71`) |
| `@OPT-BEH-BEH-018` | Ingen automatisk poengberegning når \<grunn\> | usikker | Fem av seks rader dekket (`SetteGrunnlagService.java:110-114`, `VgsDokumentVitnemaalService.java:46-52`, `PoengRadOppdateringService.java:46-48`, `AutomatiskPoengberegningService.java:83`). Raden «påstanden at søkeren ikke har GSK»: poengberegningen sjekker ikke `gsk_ok` (`AutomatiskPoengberegningService.java:64-183`), bare grunnlagsvalget (`SetteGrunnlagService.java:127-129`). Raden «saksbehandleren har ikke valgt ett av dem»: ingen kode bruker et valgt vitnemål |
| `@OPT-BEH-BEH-018` | Automatisk beregnede poeng når vitnemålet ikke lenger er entydig | usikker | `AutomatiskPoengberegningService.java:121-133`, `PoengService.java:210-215` nullstiller og skriver merknad, men i behandleSakAutomatisk kaster `SetteGrunnlagService.java:110-114` først og ruller tilbake; nullstillingen skjer bare via mutationen beregnPoengAutomatisk. fs-admin viser ikke merknadAutomatisk |
| `@OPT-BEH-BEH-018` | Søknad med elektronisk vitnemål kommer inn | ikke funnet | søkt etter kall til `AutomatiskSaksbehandlingService`, `AutomatiskPoengberegningService`, `behandleSakAutomatisk`, `beregnPoengAutomatisk`, «autosak» i fs-plattform og fs-admin: bare kalt fra mutationene (`automatisk-saksbehandling.graphqls:9-15, 52-58`) |
| `@OPT-BEH-BEH-018` | Søkeren får vitnemål innen ettersendingsfristen | ikke funnet | samme søk; ingen hendelse eller jobb starter beregningen. Søkt også etter «ettersending» |
| `@OPT-BEH-BEH-018` | Saksbehandleren har satt sammen dokumentasjonen | usikker | `OS/saksbehandling/LagreVitnemalUtregningService.java:56-79` — vitnemålskalkulatoren regner poeng fra karakterrader saksbehandleren legger inn, men ikke samme beregning |
| `@OPT-BEH-BEH-018` | Saksbehandleren starter beregningen for én søknad | funnet | `fs-admin/src/domains/soknadsbehandling/features/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:30-47` — «Start automatisk behandling» kaller behandleSakAutomatisk (bak flagget `automatisk-soknadsbehandling-trigger`); `AutomatiskSaksbehandlingService.java:134` |
| `@OPT-BEH-BEH-018` | Saksbehandleren starter beregningen for flere søknader | ikke funnet | `beregnPoengAutomatisk` tar en liste (`automatisk-saksbehandling.graphqls:9-11`), men fs-admin kaller den ikke |
| `@OPT-BEH-BEH-018` | Poeng som saksbehandleren endrer, låses | funnet | `OS/regelverk/poeng/SettPoengService.java:122, 161-162` |
| `@OPT-BEH-BEH-018` | Låst poeng beregnes ikke på nytt | funnet | `AutomatiskPoengberegningService.java:82`; `PoengService.java:52, 200` |
| `@OPT-BEH-BEH-018` | Låse opp et poeng | funnet | `SettPoengService.java:110-119, 189-215`; fs-admin `PoengberegningCardRow.tsx:160-187, 212-218` |
| `@OPT-BEH-BEH-018` | Poeng som ikke er låst, beregnes på nytt | funnet | `PoengService.java:193-201` |
| `@OPT-BEH-BEH-018` | Saksbehandlerens merknad er uendret | funnet | `PoengService.java:193-201, 45-53` — skriver bare `merknad_automatisk` |
| `@OPT-BEH-BEH-018` | Se at poenget er beregnet automatisk | ikke funnet | API har `poeng.graphqls:82, 96, 98`; fs-admin `PoengberegningCard.tsx:15-45` henter dem ikke |
| `@OPT-BEH-BEH-018` | Se hvorfor poengene ikke er beregnet | ikke funnet | `merknad_automatisk` i API (`poeng.graphqls:98`), ikke vist i fs-admin |
| `@OPT-BEH-BEH-018` | Se poengene etter at beregningen er startet | ikke funnet | `BehandleSakAutomatiskButton.tsx:32-43` — ingen refetch; `PoengberegningCard.tsx:15` oppdateres ikke |
| `@OPT-BEH-BEH-018` | Finne søknader som er behandlet automatisk | ikke funnet | ingen filter i opptak-subgraph `.graphqls` eller fs-admin |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren beregner på nytt etter en feil i <rettet> | ikke funnet | Ingen av radene i `Eksempler:` er dekket; ingen utvalg av søknadsalternativer (felles bevis) |
| `@OPT-BEH-BEH-026` | Søknadsalternativer feilen ikke gjaldt, beregnes ikke på nytt | ikke funnet | Ingen utvelgelse etter kravelement (felles bevis) |
| `@OPT-BEH-BEH-026` | Kravelementet saksbehandleren har vurdert, beregnes ikke på nytt | ikke funnet | Ingen beregning på nytt for mange saker. Vurderingen for én sak hopper over låste rader (`la_staa`, `automatisk-saksbehandling.graphqls:21`) |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren ser hvor mange søknadsalternativer som ble hoppet over | ikke funnet | Ingen opptelling (felles bevis) |
| `@OPT-BEH-BEH-026` | Saken er fortsatt ferdig behandlet etter at poengene er beregnet på nytt | ikke funnet | Felles bevis |
| `@OPT-BEH-BEH-026` | En plasstildeling som er kjørt, endres ikke | ikke funnet | Felles bevis |
| `@OPT-BEH-BEH-026` | Neste plasstildeling bruker det som er beregnet på nytt | ikke funnet | Felles bevis |
| `@OPT-BEH-BEH-025` | Saken behandles helautomatisk når søkeren har ett vitnemål, med påstanden GSK | usikker | `OS/autosak/AutomatiskSaksbehandlingService.java:114-147` kjører GSK, grunnlag, poeng, kravelementer og kvote, og grunnlaget settes bare med ett vitnemål med påstanden (`OS/autosak/SetteGrunnlagService.java:110-129`). Men helautomatisk betyr også ferdig behandlet (`ferdigbehandle_sak.feature:8-11`), og det settes aldri. Poengene og kravelementene sjekker ikke påstanden (`OS/vgs/VgsDokumentVitnemaalService.java:42-55`) |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk når ingen vitnemål har påstanden GSK | usikker | `SetteGrunnlagService.java:127-129` — uten `gsk_ok` settes ikke grunnlag, men resten kjører (`AutomatiskSaksbehandlingService.java:129-147`); poeng og kravelementer sjekker ikke GSK |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål | funnet | `SetteGrunnlagService.java:110-114` — flere dokumenter gir FlereVitnemaalException inne i transaksjonen (`AutomatiskSaksbehandlingService.java:89, 124`), alt rulles tilbake (unntak: låst grunnlag, `SetteGrunnlagService.java:99-105`) |
| `@OPT-BEH-BEH-025` | Søker med flere vitnemål der bare ett har påstanden GSK | ikke funnet | `SetteGrunnlagService.java:110-114` — flere dokumenter stopper uansett `gsk_ok`; ingen kode velger vitnemålet med påstanden |
| `@OPT-BEH-BEH-025` | Saksbehandleren velger vitnemålet saken behandles automatisk på | ikke funnet | `OS/autosak/records/BehandleSakInput.java` har bare `sakId`; `byggVitnemaal(vgdoknr)` brukes bare av GSK-vedtaket (`OS/autosak/gsk/GskVedtakAutoService.java:107`); søkt etter «valgtVitnem», «velgVitnem», `vitnemaalsnummer` |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | ikke funnet | `AutomatiskSaksbehandlingService.java:86-155` skriver aldri `sak.statustype_kode`; `FERDIG_BEHANDLET` settes bare av `OS/saksbehandling/EndreStatusService.java:46-49` |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet selv om kravelementene ga mangel | ikke funnet | Ingen status settes; `sak_mangel.er_registrert_automatisk` skrives bare `false` (`OS/saksbehandling/SakMangelService.java:126`) |
| `@OPT-BEH-BEH-025` | Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet | ikke funnet | Ingen ferdigstilling, ingen automatiske mangler; søkt etter «publiser», `STATUS_KAN_PUBLISERES` i `OS/autosak/`. min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-025` | Det som kan avgjøres, blir avgjort når \<steg\> ikke kan avgjøres | ikke funnet | To av tre rader dekket (poeng `OS/regelverk/poeng/PoengberegningService.java:160-174`, `OS/saksbehandling/PropageringService.java:183-198`; kvote `OS/autosak/KvotesporsmalAlgoritmeService.java:209-226`). Kravelementer: feilen rulles tilbake i savepoint (`AutomatiskSaksbehandlingService.java:165-173`), men kvalifisering og kvote avgjøres likevel (`:146-147` → `PropageringService.java:77-84`), mot kravet |
| `@OPT-BEH-BEH-025` | Saken blir stående under behandling når et steg ikke kan avgjøres | ikke funnet | Automatikken endrer ikke status; `UNDER_BEHANDLING` settes bare av saksbehandlerhandlinger (`OS/regelverk/poeng/SettPoengService.java:229-233`, `OS/saksbehandling/MerknadService.java:77-79`) |
| `@OPT-BEH-BEH-025` | Saksbehandleren ferdigbehandler saken etter å ha gjort resten | funnet | `fs-admin/src/domains/soknadsbehandling/features/StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:38-47` → `fs-admin/src/domains/soknadsbehandling/hooks/useEndreBehandlingsstatus.ts:12-47` → `endreSaksbehandlingsstatusV3` (`sak.graphqls:34-41`) → `OS/saksbehandling/EndreStatusService.java:46-49` |
| `@OPT-BEH-BEH-025` | Saken blir ikke ferdig behandlet av seg selv når saksbehandleren har gjort resten | funnet | `SettPoengService.java:229-233` flytter bare Ubehandlet → Under behandling; ingen annen kode setter `FERDIG_BEHANDLET` enn `EndreStatusService.java:46-49` |
| `@OPT-BEH-BEH-008` | Opprette mangelkode | usikker | `MT:30` oppretter med kode, navn, kategori, aktiv, sperrerOpptak og tekst til søker; `MK:199` sender feltene. «Kan overskrives av automatisk behandling» finnes ikke (søkt «overskriv», «kan_overskrives», «kanOverskrives») |
| `@OPT-BEH-BEH-008` | Tilgjengelige kategorier for mangelkoder | funnet | `MIG/V264__soknadsmangel_kodeverk.sql:37` har de fire kategoriene; `MK:132` henter dem |
| `@OPT-BEH-BEH-008` | Opptaksforvalteren ved <organisasjon> forvalter mangelkodene i <opptak> | usikker | RLS gir MODIFISERE_REGELVERK til eieren av regelverkssamlingen (`MIG/V264__soknadsmangel_kodeverk.sql:60`), ikke forvalteren av opptaket; `MK:268` har `canModify` hardkodet |
| `@OPT-BEH-BEH-008` | Mangel på generelle krav hindrer kvalifisering til alle søknadsalternativene i saken | ikke funnet | `sak_mangel` leses bare i MS, MP, `SakFilterConditions.java:440` og viewene; ingen kvalifiseringskode leser mangler |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav hindrer kvalifisering bare til søknadsalternativene med kompetanseregelverket | ikke funnet | Kompetanseregelverket lagres (`MS:121`), men brukes ikke i kvalifiseringen |
| `@OPT-BEH-BEH-008` | Mangel på <kategori> hindrer ikke kvalifisering | usikker | Oppfylt bare fordi ingen mangel hindrer kvalifisering |
| `@OPT-BEH-BEH-008` | Saken kan behandles ferdig selv om den har mangler | funnet | `OS/saksbehandling/EndreStatusService.java:46`; `fs-admin/src/domains/soknadsbehandling/features/StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:42` |
| `@OPT-BEH-BEH-008` | Mangel som sperrer opptak holder søkeren utenfor tilbudskjøringen | ikke funnet | `sperrer_opptak` brukes bare i MT, input-recordene og GQL |
| `@OPT-BEH-BEH-008` | Registrere mangel på spesielle krav | funnet | `MC/ManglerCard.tsx:72`; `MS:114`; `MC/Mangel/Mangel.tsx:70` |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant mangelkodene i regelverkssamlingen til opptaket | funnet | `MC/components/MangeltypeCombobox/MangeltypeCombobox.tsx:30,62` |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant kompetanseregelverkene til søknadsalternativene i saken | funnet | `MC/components/KompetanseregelverkSelect/KompetanseregelverkSelect.tsx:20,73` |
| `@OPT-BEH-BEH-008` | Registrere mangel på kvote | ikke funnet | Backend tar imot kvotespørsmål (`MS:122`, `GQL:62`), fs-admin sender det ikke (`MC/ManglerCard.tsx:72`) |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant kvotespørsmålene til søknadsalternativene i saken | ikke funnet | Ingen valg av kvotespørsmål i ManglerCard; `MS:508` |
| `@OPT-BEH-BEH-008` | En mangel i kategorien <kategori> <kobling> | usikker | Backend avviser ugyldig kobling (`MS:488`, `MS:503`); fs-admin viser regelverksvalget bare for Spesielle krav (`KompetanseregelverkSelect.tsx:66`); kvote-raden kan ikke gjøres i fs-admin |
| `@OPT-BEH-BEH-008` | Kommentaren til søkeren er valgfri | funnet | `MC/ManglerCard.tsx:72`; `MS:123` |
| `@OPT-BEH-BEH-008` | En sak kan ha flere mangler | funnet | `MS:114`; `MC/ManglerCard.tsx:46` |
| `@OPT-BEH-BEH-008` | Samme mangelkode i kategorien <kategori> kan <tillatt> registreres flere ganger i saken | usikker | `MS:563` avviser duplikat; kvote-raden kan ikke gjøres i fs-admin |
| `@OPT-BEH-BEH-008` | Slette mangel som er registrert ved en feil | funnet | `MC/Mangel/Mangel.tsx:94`; `MS:399` |
| `@OPT-BEH-BEH-008` | Saksloggen viser at saksbehandleren <hendelse> | usikker | Loggen skrives (`MS:105`, `MS:223`, `MS:391`), men utsjekking kan ikke gjøres i fs-admin |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser at søkeren har lastet opp ny dokumentasjon | funnet | `fs-admin/src/domains/soknadsbehandling/features/SakOverviewView/components/SakStatusBadge/SakStatusBadge.tsx:35`; `SakOverviewTable.tsx:178` |
| `@OPT-BEH-BEH-008` | Saksbehandleren sjekker ut mangelen | ikke funnet | Backend `MS:240`; fs-admin har ingen handling (søkt «erUtsjekket», «utsjekk», «sjekk ut») |
| `@OPT-BEH-BEH-008` | Mangel som er sjekket ut hindrer ikke kvalifisering | usikker | Oppfylt bare fordi ingen mangel hindrer kvalifisering |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser om søkeren har lest mangelen | ikke funnet | Backend `MP:69`, `GQL:160`; fs-admin henter ikke feltet (`MC/queries.ts:25`) |
| `@OPT-BEH-BEH-008` | Registrering av mangel publiserer ikke mangelen | funnet | `MS:124`, `MS:131`; `MC/ManglerCard.tsx:72`; `MIG/V457__soknadsmangel_bare_publiserte.sql:81` |
| `@OPT-BEH-BEH-008` | Saksbehandleren publiserer mangelen | usikker | API publiserer én (`MS:237`), fs-admin publiserer alle samlet (`MC/ManglerCard.tsx:96`); min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Saksbehandleren publiserer manglene i saken | usikker | `MC/ManglerCard.tsx:96`, `MS:142`, `MS:154`; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren får melding hver gang saksbehandleren publiserer manglene | funnet | `MS:162`; `MM:47` |
| `@OPT-BEH-BEH-008` | Saksbehandleren publiserer en sak som bare har automatiske mangler | ikke funnet | `publiserMangler` (`MS:349`), men fs-admin kaller den ikke; knappen bare for upubliserte registrerte (`MC/ManglerCard.tsx:66, 194`) |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser at endringene ikke er publisert når <endring> | ikke funnet | Sletting og kommentar nullstiller ikke `status_kan_publiseres` (`MS:233`, `MS:399`); `MC/Mangel/Mangel.tsx:137` dekker ingen av radene |
| `@OPT-BEH-BEH-008` | Saksbehandleren blir advart om mangler som ikke er publisert | ikke funnet | `MerkSomBehandletButton.tsx:44` uten advarsel |
| `@OPT-BEH-BEH-008` | Publisere manglene når saken settes til ferdig behandlet | ikke funnet | `EndreStatusService.java:46` endrer bare status |
| `@OPT-BEH-BEH-008` | Sette saken til ferdig behandlet uten å publisere manglene | usikker | Utfallet stemmer (`EndreStatusService.java:46`, `V457:14, 81`), men advarselen og valget finnes ikke |
| `@OPT-BEH-BEH-008` | Avbryte når saken har mangler som ikke er publisert | ikke funnet | Ingen dialog i `MerkSomBehandletButton.tsx` |
| `@OPT-BEH-BEH-008` | Søkeren får én melding om manglene som publiseres i saken | funnet | `MS:154`, `MS:359` |
| `@OPT-BEH-BEH-008` | Søkeren får melding fra hver saksbehandlende organisasjon som publiserer mangler | funnet | `MS:173`; `MM:31` |
| `@OPT-BEH-BEH-008` | Søkeren åpner meldingen om mangel | ikke funnet | `MM:17, 54` — fristen sendes som null; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Fristen for en mangel publisert <publisert> når <situasjon> | ikke funnet | `MM:54` frist null; søkt «ettersend», «dokumentasjonsfrist», «fristForOpplasting» |
| `@OPT-BEH-BEH-008` | Meldingen viser fristen for hvert søknadsalternativ med mangler | ikke funnet | `MeldingInnhold.java:23` én frist, null |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav gir frist bare for søknadsalternativene med kompetanseregelverket | ikke funnet | Samme søk |
| `@OPT-BEH-BEH-008` | Mangel på <kategori> har ettersendingsfristen | ikke funnet | Samme søk |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav vises under søknadsalternativene med kompetanseregelverket | usikker | `V457:97, 118`; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren ser kravene i kompetanseregelverket mangelen gjelder | usikker | `V457:107` (standardtekst), `V457:148` (beregnede); min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren ser kommentaren fra saksbehandleren | usikker | `V457:111`; `soknad/soknadsmangel.graphqls:39`; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Mangel på <kategori> gjelder ikke et bestemt søknadsalternativ | usikker | `V457:55, 78`; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Mangel som er sjekket ut vises ikke for søkeren | funnet | `V457:80, 130`; test `SoknadsmangelRLSIT.java` |
| `@OPT-BEH-BEH-008` | Søkeren laster opp dokumentasjon for en mangel | usikker | `OS/soknad/dokument/DokumentLagerService.java:146`, uten kobling til mangel; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Mangelen står til saksbehandleren har sjekket den ut | usikker | `MS:241`, `V457:80`; min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-008` | Saksbehandlende organisasjon ser manglene i saken hos en annen organisasjon | ikke funnet | RLS tillater lesing (`MIG/V291__saksbehandling_skjema.sql:1715`), men fs-admin viser bare én sak (`MC/ManglerCard.tsx:46`, `SakDrawer.tsx:160`) |
| `@OPT-BEH-BEH-008` | Saksbehandlende organisasjon kan ikke endre manglene i saken hos en annen organisasjon | usikker | Backend avviser (`V291:1725`, `SakMangelRLSIT.java`); `MC/Mangel/Mangel.tsx:143` slett-knapp uten organisasjonssjekk |
| `@OPT-BEH-BEH-008` | Opptaksforvalteren ved forvaltende organisasjon ser manglene i alle sakene | usikker | `V291:1715`; ingen visning på tvers |
| `@OPT-BEH-BEH-008` | Tilbyderen ser manglene når en annen organisasjon saksbehandler utdanningstilbudet | usikker | Som over |
| `@OPT-BEH-BEH-008` | Saken får mangel når <vurdert av> vurderer at et kravelement ikke er oppfylt | usikker | Beregnet mangel per kompetanseregelverk (`KO:216`, `fs-plattform/opptak/docs/soknadsmangel.md:63`, `PropageringService.java:147`); ikke én per kravelement, ingen `sak_mangel`-rad (`MS:126`) |
| `@OPT-BEH-BEH-008` | Den automatiske mangelen sjekkes ut når <vurdert av> vurderer at kravelementet er oppfylt | ikke funnet | Teksten blankes (`KO:44`, `KO:216`), mangelen forsvinner |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser <mangel> sammen med de registrerte manglene | ikke funnet | fs-admin viser bare registrerte (`MC/queries.ts:9`) |
| `@OPT-BEH-BEH-008` | Saksbehandleren kan <handling> en automatisk mangel | ikke funnet | Beregnede vises ikke; `MC/Mangel/Mangel.tsx:143` |
| `@OPT-BEH-BEH-008` | Automatisk mangel som er <handling>, <utfall> når mangelkoden <overskrivbar> | ikke funnet | Ingen «kan overskrives» på mangelkoden |
| `@OPT-BEH-BEH-008` | Saken får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår | ikke funnet | Bare `MS:114` lager rader; søkt «fullføres i vår», «kommerSenere», «DUA» |
| `@OPT-BEH-BEH-008` | Mangelen slettes når søkeren endrer søknaden før søknadsfristen | ikke funnet | Samme søk |
| `@OPT-BEH-BEH-008` | Mangelen sjekkes ut når vitnemålet behandles automatisk | ikke funnet | `autosak/` skriver ikke til `sak_mangel` |
| `@OPT-BEH-BEH-008` | Automatisk behandling overskriver manuelt satt mangel når mangelkoden <overskrivbar> | ikke funnet | Ingen «kan overskrives» |
| `@OPT-PLA-TIL-001` | Starte plasstildeling | funnet | `fs-admin/src/domains/plasstildeling/features/ParameterFeature/ParameterFeature.tsx:306-327` — «Hent resultater» kaller `opprettPlasstildeling` (`OS/plasstildeling/service/OpprettPlasstildelingService.java:39-49, 132-154`); `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/plasstildeling/PlasstildelingPoller.java:51-55` kjører den i bakgrunnen; status pollet (`ParameterFeature.tsx:116-121, 138-150`) |
| `@OPT-PLA-TIL-001` | Opptaksforvalter ved deltakende organisasjon kan ikke starte plasstildeling | ikke funnet | Backend avviser (`OpprettPlasstildelingService.java:66-76`), men fs-admin viser knappen uten rollesjekk (`ParameterFeature.tsx:374-381`) |
| `@OPT-PLA-TIL-001` | Plasstildeling fryser grunnlaget ved start | funnet | `OS/plasstildeling/service/PlasstildelingKjoringService.java:179-212, 315-334` — REPEATABLE READ og snapshot |
| `@OPT-PLA-TIL-001` | Starte plasstildeling mens perioden for antall tilbud er åpen | ikke funnet | Backend har ingen sperre (`OS/plasstildeling/service/KvoterService.java:102-104`), men fs-admin deaktiverer start til fristen har gått ut (`ParameterFeature.tsx:293-298, 376`) |
| `@OPT-PLA-TIL-001` | Bare saker som er ferdig behandlet, er med | ikke funnet | `OS/plasstildeling/service/KvotesumService.java` filtrerer ikke på status; `OS/plasstildeling/service/RangeringService.java:160-167, 278-282` lagrer bare statusen |
| `@OPT-PLA-TIL-001` | Søknadsalternativer som kan få tilbud | ikke funnet | Tre av fire rader dekket (`KvotesumService.java:294-333`); tilbudsgaranti fra tidligopptaket leses ikke (`OS/plasstildeling/service/OpptakskjoringService.java:153-163, 263-269`) |
| `@OPT-PLA-TIL-001` | Ny plasstildeling i samme plasstildelingsrunde | funnet | `OpprettPlasstildelingService.java:79-89, 132-154`; `PlasstildelingKjoringService.java:179-212, 321`; fs-admin `ResultatFeature/components/KjoringBox/KjoringBox.tsx:30-36, 90` |
| `@OPT-PLA-TIL-001` | Plasstildeling i hovedtildelingen | funnet | `OpprettPlasstildelingService.java:99-124`; `PlasstildelingKjoringService.java:191-199` |
| `@OPT-PLA-TIL-001` | Plasstildeling i en senere plasstildelingsrunde | funnet | `OpprettPlasstildelingService.java:99-124`; `PlasstildelingKjoringService.java:187-199` |
| `@OPT-PLA-TIL-001` | Senere plasstildelingsrunde uten publisert forrige plasstildelingsrunde | ikke funnet | `OpprettPlasstildelingService.java:121-123` — kjøres uten grunnlag, ingen avvisning |
| `@OPT-PLA-TIL-001` | Ingen rangerte søkere | usikker | `PlasstildelingKjoringService.java:244-249, 351-353, 412-420` — feiler etter start med teknisk melding; `ParameterFeature.tsx:145-150` |
| `@OPT-PLA-TIL-001` | Plasstildeling feiler | usikker | `PlasstildelingKjoringService.java:151-153, 351-373` setter FEILET; fs-admin viser bare snackbar mens siden poller (`ParameterFeature.tsx:145-150, 376`); `KjoringBox.tsx:90`, `PlasstildelingSection.tsx:47-53` viser bare TILDELT |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk på vitnemålet med påstanden GSK | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001` (`@planned`), og kravene i fasen er `@draft` eller `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Søknaden får grunnlag | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001` (`@planned`), og kravene i fasen er `@draft` eller `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Søknadsalternativet får poengsum | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001` (`@planned`), og kravene i fasen er `@draft` eller `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Søkeren er kvalifisert når vitnemålet oppfyller kravelementene | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001` (`@planned`), og kravene i fasen er `@draft` eller `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Den kvalifiserte søkeren plasseres i kvoten grunnlaget er koblet til | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001` (`@planned`), og kravene i fasen er `@draft` eller `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Saken er med i plasstildelingen når den automatiske behandlingen har avgjort alt | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001` (`@planned`), og kravene i fasen er `@draft` eller `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Søkeren ser mangelen fra kravelementene når saken er ferdig behandlet | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001` (`@planned`), og kravene i fasen er `@draft` eller `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Saken er ikke med i plasstildelingen når poengene ikke kan avgjøres | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001` (`@planned`), og kravene i fasen er `@draft` eller `@planned` — ikke søkt |
| `@FLY-OPT-AUT-001` | Poengene beregnes på nytt når rangeringsregelverket er rettet | ikke funnet | fasen er ikke levert: flyten bygger på `@FLY-OPT-SAK-001` (`@planned`), og kravene i fasen er `@draft` eller `@planned` — ikke søkt |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-admin` | [!3226 feat(plasstildeling): STEK-489 tidlig opptak in plasstildeling](https://gitlab.sikt.no/studieadm/fs-admin/-/merge_requests/3226) (`patsle/STEK-489-feat-tidlig-opptak-plasstildeling`) | åpen | `@OPT-PLA-TIL-001` | 0/12 | usikker kobling: gir tilbudsgaranti i tidlig opptak (OPT-BEH-BEH-007), men endrer ikke at plasstildelingen leser den |
| `fs-admin` | [!3235 feat(soknadsbehandling): vis poengtypenavn i poengsteget (STEK-635)](https://gitlab.sikt.no/studieadm/fs-admin/-/merge_requests/3235) (`solov/poengtypenavn-poengsteg`) | åpen | `@OPT-BEH-BEH-018` | 0/20 | usikker kobling: ny kolonne i poengtabellen, ikke sporbarheten kravet beskriver |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Bare positive konklusjoner kan legges til når ingen finnes | usikker | ikke funnet | `fs-admin/src/domains/soknadsbehandling/features/GSKCard/GSKCard.tsx:322-351` — «Ikke kvalifisert» vises også uten konklusjon. Backend avviser, men valget finnes på skjermen |
| `@OPT-BEH-BEH-020` | Kvalifisert per poengvariant | ikke funnet | usikker | `SGS:131,306-307,321-333` — et grunnlag som krever førstegangsvitnemål, kan dekke det samme. Det er det åpne spørsmålet i kravet |
| `@OPT-BEH-BEH-025` | Saken behandles helautomatisk når søkeren har ett vitnemål, med påstanden GSK | funnet | usikker | `OS/autosak/AutomatiskSaksbehandlingService.java:114-147` setter aldri saken til ferdig behandlet, og det er en del av «helautomatisk» i beskrivelsen (`ferdigbehandle_sak.feature:8-11`) |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

Alle kravene er `@draft` eller `@planned`, og er til review i PR #818. Forslaget følger *Delvis levert* i `fs-verify`, men å sette et krav som ikke er validert, til `@in-progress`, hopper over valideringen i `fs-krav`.

- `@OPT-BEH-BEH-015` — Automatisk GSK-konklusjon (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature`, `@planned` → `@in-progress`, 6/33 funnet) — `@implemented` på: Regel: Automatikken setter bare positive konklusjoner, og bare der ingen finnes (linje 226), Scenario: Overskrive positiv konklusjon med negativ konklusjon (linje 252), Scenario: Legge til positiv konklusjon når ingen finnes (linje 257), Scenario: Automatisk konklusjon trekkes tilbake når vitnemålet annulleres (linje 278)
- `@OPT-BEH-BEH-019` — Automatisk grunnlag (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_grunnlag.feature`, `@draft` → `@in-progress`, 13/20 funnet) — `@implemented` på: Regel: Grunnlaget velges ut fra egenskapene regelverket har gitt det (linje 88), Regel: Når grunnlaget endres, vurderes søknaden på nytt (linje 253), Scenario: Ingen grunnlag settes automatisk når <grunn> (linje 164), Scenario: Saksbehandleren starter den automatiske behandlingen (linje 199), Scenario: Grunnlag som saksbehandleren legger til, låser grunnlagene (linje 211), Scenario: Automatikken setter ikke grunnlag på en låst sak (linje 216), Scenario: Automatikken fjerner aldri grunnlag (linje 221), Scenario: Saksbehandleren endrer grunnlag som er satt automatisk (linje 227), Scenario: Endringsloggen viser at automatikken satte grunnlaget (linje 271)
- `@OPT-BEH-BEH-020` — Automatisk vurdering av spesielle opptakskrav (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvalifisering.feature`, `@draft` → `@in-progress`, 19/24 funnet) — `@implemented` på: Regel: Ingen automatisk vurdering uten ett entydig vitnemål (linje 141), Regel: Når grunnlaget endres, vurderes kravene på nytt (linje 257), og 16 scenarioer (linje 97, 104, 111, 117, 123, 161, 167, 174, 180, 212, 224, 229, 234, 240, 281, 287)
- `@OPT-BEH-BEH-018` — Automatisk poengberegning (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_poengberegning.feature`, `@draft` → `@in-progress`, 10/20 funnet) — `@implemented` på: Regel: Poeng fra søkerens eneste vitnemål (linje 83), Regel: Poeng som saksbehandleren har satt, beregnes ikke på nytt (linje 194), Scenario: Saksbehandleren starter beregningen for én søknad (linje 184)
- `@OPT-BEH-BEH-025` — Ferdigbehandle en sak (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/ferdigbehandle_sak.feature`, `@draft` → `@in-progress`, 3/12 funnet) — `@implemented` på: Regel: Saksbehandleren setter saken til ferdig behandlet når den automatiske behandlingen ikke har fullført (linje 140), Scenario: Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål (linje 54)
- `@OPT-BEH-BEH-008` — Søknadsmangler (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/søknadsmangler.feature`, `@planned` → `@in-progress`, 14/60 funnet) — `@implemented` på 14 scenarioer (linje 61, 112, 129, 137, 144, 171, 175, 192, 214, 245, 268, 331, 336, 438)
- `@OPT-PLA-TIL-001` — Starte en plasstildeling (`krav/02 Opptak/14 Plasstildeling/03 Tildeling/starte_plasstildeling.feature`, `@draft` → `@in-progress`, 5/12 funnet) — `@implemented` på: Scenario: Starte plasstildeling (linje 21), Scenario: Plasstildeling fryser grunnlaget ved start (linje 33), Scenario: Ny plasstildeling i samme plasstildelingsrunde (linje 81), Scenario: Plasstildeling i hovedtildelingen (linje 89), Scenario: Plasstildeling i en senere plasstildelingsrunde (linje 97)

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-026` — Beregne automatisk på nytt (`@draft`, 0/7 funnet) — ingen funksjon beregner på nytt for søknadsalternativene en rettet feil gjelder
- `@FLY-OPT-AUT-001` — Automatisk saksbehandling (`@draft`, 0/9 funnet) — 0 av 7 faser levert
- `@FLY-OPT-OPT-001` — Opptaksløpet (`@draft`, 0/0 funnet) — 0 av 6 faser levert, 4 faser mangler krav

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Automatisk GSK-konklusjon | `@planned` | 6/33 | 26 ikke funnet, 1 usikker. Brukeren valgte «Ikke endre noe» for delvis levert |
| `@OPT-BEH-BEH-019` | Automatisk grunnlag | `@draft` | 13/20 | 6 ikke funnet, 1 usikker. Brukeren valgte «Ikke endre noe» for delvis levert |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | `@draft` | 19/24 | 3 ikke funnet, 2 usikker. Brukeren valgte «Ikke endre noe» for delvis levert |
| `@OPT-BEH-BEH-018` | Automatisk poengberegning | `@draft` | 10/20 | 7 ikke funnet, 3 usikker. Brukeren valgte «Ikke endre noe» for delvis levert |
| `@OPT-BEH-BEH-026` | Beregne automatisk på nytt | `@draft` | 0/7 | 7 ikke funnet, 0 usikker |
| `@OPT-BEH-BEH-025` | Ferdigbehandle en sak | `@draft` | 3/12 | 7 ikke funnet, 2 usikker. Brukeren valgte «Ikke endre noe» for delvis levert |
| `@OPT-BEH-BEH-008` | Søknadsmangler | `@planned` | 14/60 | 26 ikke funnet, 20 usikker. Brukeren valgte «Ikke endre noe» for delvis levert |
| `@OPT-PLA-TIL-001` | Starte en plasstildeling | `@draft` | 5/12 | 5 ikke funnet, 2 usikker. Brukeren valgte «Ikke endre noe» for delvis levert |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling | `@draft` | 0/9 | 9 ikke funnet, 0 usikker. 0 av 7 faser levert |
| `@FLY-OPT-OPT-001` | Opptaksløpet | `@draft` | 0/0 | 0 av 6 faser levert, 4 faser mangler krav |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Den automatiske behandlingen setter ikke saken til ferdig behandlet:** `OS/autosak/AutomatiskSaksbehandlingService.java:86-155` endrer aldri statusen. Saken blir stående som «Ubehandlet», ikke «Under behandling». Det stemmer med kjent brudd i `@FLY-OPT-AUT-001`.
- **Plasstildelingen tar med saker som ikke er ferdig behandlet:** `OS/plasstildeling/service/KvotesumService.java` filtrerer ikke på status. Kjent brudd i `@FLY-OPT-AUT-001`.
- **GSK beregnes i den automatiske behandlingen, ikke ved import:** `OS/vgs/HentVgsVitnemaalService.java:108-136` beregner ingen påstand, og `OS/autosak/gsk/GskVedtakAutoService.java:113` bruker påstanden fra KREG. Kjent brudd i `@FLY-OPT-AUT-001`.
- **Poengene og kravelementene sjekker ikke påstanden om GSK:** `OS/vgs/VgsDokumentVitnemaalService.java:42-55`. Bare grunnlagsvalget gjør det (`SGS:127-129`). En sak med grunnlag fra før får poeng uten påstanden.
- **Feil i kravelementene stopper ikke kvalifiseringen og kvoten:** `OS/autosak/AutomatiskSaksbehandlingService.java:165-173` ruller tilbake kravelementene, men `OS/saksbehandling/PropageringService.java:77-85` avgjør kvalifiseringen og kvoten likevel. Det er mot `@OPT-BEH-BEH-025` «Det som kan avgjøres, blir avgjort når <steg> ikke kan avgjøres».
- **API-et har sporbarheten, fs-admin viser den ikke:** `merknadAutomatisk` og `statusAutomatiskUtregnet` finnes for poeng (`poeng.graphqls:96-98`), kravelementer (`sak.graphqls:222-230`) og GSK (`gsk.graphqls:323,335`), men fs-admin henter dem ikke. For grunnlag finnes feltene i databasen (`SGS:198-199`), men ikke i API-et.
- **Knapper som vises uten tilgang:** «Hent resultater» vises for en opptaksforvalter ved deltakende organisasjon (`fs-admin/src/domains/plasstildeling/features/ParameterFeature/ParameterFeature.tsx:374-381`), og «Ikke kvalifisert» vises uten GSK-konklusjon (`GSKCard.tsx:322-351`). Backend avviser begge.
- **Plasstildeling kan ikke startes mens perioden for antall tilbud er åpen:** `ParameterFeature.tsx:293-298` deaktiverer start til `sluttEndreOpptaksparametre` har passert, mot `@OPT-PLA-TIL-001`.
- **Kategorinavnet for kvote:** databasen har «Kvoter» (`MIG/V264__soknadsmangel_kodeverk.sql:37-40`), kravet `@OPT-BEH-BEH-008` skriver «Kvote».
- **Ikke sjekket:** min-kompetanse finnes ikke blant kodeklonene. Scenarioene i `@OPT-BEH-BEH-008` om hva søkeren ser og laster opp, er `usikker` (8 scenarioer).
- **Åpent spørsmål:** `@OPT-BEH-BEH-015` «Nytt vitnemål fra KREG etter at søknaden er opprettet» og «Annulleringen oppdages uten at søkeren endrer søknaden» — hvordan FS-opptak abonnerer på endringer i KREG, er ikke besluttet
- **Åpent spørsmål:** `@OPT-BEH-BEH-015` «Gjenbruke kvalitetssikret konklusjon fra FS-klienten» — hva heter oversikten over kvalitetssikrede GSK-konklusjoner, og hvor ligger den?
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Grunnlag ut fra alder og førstegangsvitnemål» — hvor går aldersgrensen for VOV? «Flere grunnlag passer like godt» — lavest kode, ingen eller alle? Koden velger lavest kode
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Søknaden kan få flere grunnlag» og «Når grunnlaget settes» — hvilke kombinasjoner er gyldige, og når skal grunnlaget settes automatisk?
- **Åpent spørsmål:** `@OPT-BEH-BEH-020` «Kravelementet kobles til vitnemålet for hver reform» — koden bruker én kode for begge reformene (`OS/autosak/kontrollmotor/Kravelementer.java:650-653`)
- **Åpent spørsmål:** `@OPT-BEH-BEH-020` «Kvalifisert per poengvariant», «Nye kravelementer på en søknad saksbehandleren har vurdert», «Finne søkere som ikke er kvalifisert» og «Når kravene vurderes»
- **Åpent spørsmål:** `@OPT-BEH-BEH-018` «Når poengene beregnes», «Automatisk beregnede poeng når vitnemålet ikke lenger er entydig» og «Finne søknader som er behandlet automatisk»
- **Åpent spørsmål:** `@OPT-BEH-BEH-025` «Søker med flere vitnemål der bare ett har påstanden GSK» — skal saken gå gjennom den helautomatiske flyten? Koden stopper ved mer enn ett vitnemål (`SGS:110-114`)
- **Åpent spørsmål:** `@OPT-BEH-BEH-008` «Mangel som sperrer opptak holder søkeren utenfor tilbudskjøringen» — hva gjør «Stopper for opptak»? Koden bruker ikke feltet
- **Åpent spørsmål:** `@OPT-BEH-BEH-008` publiseringen av hele saken, «Saksbehandleren ser at endringene ikke er publisert», «Mangel på <kategori> gjelder ikke et bestemt søknadsalternativ», «Søkeren laster opp dokumentasjon for manglene», «Saken får mangler for kravelementene søkeren ikke oppfyller» (koden lager én mangel per kompetanseregelverk) og «Mangelen for generell studiekompetanse som fullføres i vår»
- **Åpent spørsmål:** `@OPT-PLA-TIL-001` «En plasstildeling som feiler erstattes av en ny» — feilen vises bare mens siden som startet plasstildelingen, er åpen (`ParameterFeature.tsx:145-150`)
- **Bygger på krav som ikke er levert:** `@FLY-OPT-AUT-001` og `@FLY-OPT-OPT-001` bygger på `@FLY-OPT-SAK-001` (`@planned`)
