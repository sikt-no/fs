# Verifisering: krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature

- **Dato:** 2026-10-26 13:00
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature` (1 feature-filer)
- **Kode:** `fs-plattform` (main, 97fbafa9b3, oppdatert), `fs-admin` (main, 8336410e53, oppdatert)
- **Omfang:** alle krav uansett status (valgt)
- **Avhengigheter:** ingen
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 1 finnere (`fs-verify-krav`), 1 kontrollører (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `gsk/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/`
- `autosak/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/`
- `gskvedtak/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/gskvedtak/`
- `vgs/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/`
- `migr/` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `jobb/` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/`
- `GSKCard/` = `fs-admin/src/domains/soknadsbehandling/features/GSKCard/`

## Oppsummering

- Scenarioer: 5 funnet, 18 ikke funnet, 3 usikker, av 26
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Vitnemål som gir generell studiekompetanse | ikke funnet | `gsk/GskVedtakAutoService.java:77-89,165-178` og `gsk/GskKonklusjonEvaluator.java:58-72` gjør de samme sjekkene og lagrer KVALIFISERT med grunnlagskode og grunnlagsdato, men i `gsk_vedtak` per søker og opptak (på søknaden), i steg 0a i den automatiske saksbehandlingen (`autosak/AutomatiskSaksbehandlingService.java:114`), ikke på vitnemålet når søknaden kommer inn. `migr/V176__kompetanse_vgs.sql:102-118` (`vgs_dokument`) har ingen konklusjonskolonner — søkt etter «gsk_konklusjon», «gskKonklusjon», «gsk_beregnet», «beregnetTidspunkt», «gsk_grunnlag» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-015` | Tidspunktet for beregningen lagres på vitnemålet | ikke funnet | Bare `vedtak_tidspunkt` på `gsk_vedtak` (`gsk/GskVedtakAutoService.java:159,170`). `vgs_dokument` har bare `tid_registrert`/`tid_oppdatert` fra KREG-lagringen. KREG-flagget `Gsk_beregnet` er ikke et tidspunkt i opptak — søkt som raden over |
| `@OPT-BEH-BEH-015` | Hvert vitnemål får sin egen GSK-konklusjon | ikke funnet | Det motsatte: automatikken stopper når søkeren har mer enn ett dokument (`gsk/GskVedtakAutoService.java:81-83`, `IKKE_ETT_VGS_DOKUMENT`). Ved flere vitnemål velger saksbehandleren ett (`gsk/SettGskKonklusjonService.java:71-161`), men det blir én konklusjon per søker og opptak (`:180`) — søkt som raden over |
| `@OPT-BEH-BEH-015` | Grunnlagskoder som settes automatisk | ikke funnet | Kodene AØA, RFA, TEK, KLS og KLY finnes (`migr/V275__vgs_loep.sql:29`, `gsk/GskKonklusjonEvaluator.java:70-71`), men lagres på søknaden i den automatiske saksbehandlingen, ikke på vitnemålet når søknaden kommer inn — søkt som raden over |
| `@OPT-BEH-BEH-015` | Ingen positiv konklusjon fra vitnemålet når <grunn> | ikke funnet | Alle fem grunnene stopper automatikken (`gsk/GskVedtakAutoService.java:81,85`, `gsk/GskKonklusjonEvaluator.java:58-67`), men for konklusjonen på søknaden i den automatiske saksbehandlingen. Det finnes ingen konklusjon på vitnemålet — søkt som raden over |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra tidligere samordna opptak | ikke funnet | Bare kodeverdien `GJENBRUK` (`migr/V375__gsk_vedtak_endringslogg.sql:280-288`). Ingen kode skriver den, og `harGjeldendeVedtak` ser bare i samme opptak (`gsk/GskVedtakAutoService.java:136-143`) — søkt etter «GJENBRUK», «gjenbruk», «tidligere opptak», «tidligereOpptak», «forrigeOpptak», «reuse» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-015` | Vitnemålet går foran tidligere konklusjon | ikke funnet | Det finnes ingen gjenbruk — søkt som raden over |
| `@OPT-BEH-BEH-015` | Bare den siste tidligere konklusjonen gjenbrukes | ikke funnet | Ingen gjenbruk — søkt som over |
| `@OPT-BEH-BEH-015` | Negative konklusjoner gjenbrukes ikke | ikke funnet | Ingen gjenbruk. At ingenting gjenbrukes, er ikke bevis for regelen — søkt som over |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra lokalt opptak | ikke funnet | Ingen gjenbruk — søkt som over |
| `@OPT-BEH-BEH-015` | Gjenbruke kvalitetssikret konklusjon fra FS-klienten | ikke funnet | Ingen gjenbruk, og ingenting om kvalitetssikring — søkt etter «kvalitetssikr», «quality» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-015` | Konklusjon fra FS-klienten som ikke er kvalitetssikret, gjenbrukes ikke | ikke funnet | Som raden over |
| `@OPT-BEH-BEH-015` | Konklusjon som bygger på et annullert vitnemål gjenbrukes ikke | ikke funnet | Ingen gjenbruk — søkt som over |
| `@OPT-BEH-BEH-015` | Ingen grunnlag for generell studiekompetanse | usikker | `gsk/GskVedtakAutoService.java:117-127` lagrer ingenting ved `IngenAutomatikk`, og `autosak/AutomatiskSaksbehandlingService.java:115-120` går videre, så GSK vurderes manuelt. Men det skjer i den automatiske saksbehandlingen, ikke når søknaden kommer inn, og sjekken mot tidligere opptak i `Gitt` finnes ikke |
| `@OPT-BEH-BEH-015` | Konklusjon på søknaden overskrives ikke | usikker | `gsk/GskVedtakAutoService.java:65-67,136-143` gjør ingenting når det finnes en konklusjon i opptaket, satt av en hvilken som helst organisasjon (også `gsk/SettGskKonklusjonService.java:116`). Men det skjer i den automatiske saksbehandlingen eller hos saksbehandleren, ikke når søknaden kommer inn |
| `@OPT-BEH-BEH-015` | Systemet setter aldri en negativ konklusjon | funnet | `gsk/GskVedtakAutoService.java:50,169` setter alltid KVALIFISERT (også veien via `gsk/SettGskKonklusjonService.java:152`). Tilbakekallingen setter bare KVALIFISERT_MEN_ANNULLERT (`gsk/GskVedtakTilbakekallingService.java:106`). IKKE_KVALIFISERT skrives bare av saksbehandleren (`gskvedtak/GskVedtakService.java:540,564`) |
| `@OPT-BEH-BEH-015` | Overskrive positiv konklusjon med negativ konklusjon | funnet | `gskvedtak/GskVedtakService.java:219-253,483-500` lar en konklusjon som ikke er låst, endres til IKKE_KVALIFISERT. `GSKCard/GSKCard.tsx:255-262,338-351` har «Ikke kvalifisert», som kaller `endreGskVedtakV3` |
| `@OPT-BEH-BEH-015` | Legge til positiv konklusjon når ingen finnes | funnet | `gskvedtak/GskVedtakService.java:447-463` oppretter KVALIFISERT når ingen konklusjon finnes. `GSKCard/GSKCard.tsx:240-244,352-362` kaller `opprettGskVedtakV3` med «Godkjenn» |
| `@OPT-BEH-BEH-015` | Bare positive konklusjoner kan legges til når ingen finnes | usikker | API-et avviser IKKE_KVALIFISERT når ingen konklusjon finnes (`gskvedtak/GskVedtakService.java:457-462`). Men `GSKCard/GSKCard.tsx:322-351` viser «Ikke kvalifisert» også da, og saksbehandleren får en feilmelding. Kontrollen heller mot `ikke funnet`, siden saksbehandleren kan velge negativ |
| `@OPT-BEH-BEH-015` | Nytt vitnemål når søknaden ikke har konklusjon | ikke funnet | Når et nytt vitnemål lagres (`vgs/HentVgsVitnemaalService.java:116-132`), vurderes ikke GSK. Vitnemålene hentes bare etter tildelingen (`jobb/SoknadshendelseJobb.java:126-135`), og GSK vurderes bare når den automatiske saksbehandlingen startes — søkt etter kall til `GskVedtakAutoService`, `behandleAutomatisk` og `HentVgsVitnemaalService` |
| `@OPT-BEH-BEH-015` | Nytt vitnemål når søknaden har konklusjon | funnet | Et nytt vitnemål rører ikke `gsk_vedtak` (`vgs/HentVgsVitnemaalService.java:116-139`), og kjøres den automatiske saksbehandlingen igjen, stopper `harGjeldendeVedtak` overskrivingen (`gsk/GskVedtakAutoService.java:65-67`) |
| `@OPT-BEH-BEH-015` | Automatisk konklusjon trekkes tilbake når vitnemålet annulleres | funnet | `vgs/HentVgsVitnemaalService.java:130-138` kaller tilbakekallingen. `gsk/GskVedtakTilbakekallingService.java:70-116` setter automatiske, ulåste KVALIFISERT-konklusjoner på vitnemålet til KVALIFISERT_MEN_ANNULLERT med årsaken AVM (vitnemål annullert) og datoen |
| `@OPT-BEH-BEH-015` | Gjenbrukt konklusjon trekkes tilbake når vitnemålet annulleres | ikke funnet | Tilbakekallingen tar bare kilden AUT (`gsk/GskVedtakTilbakekallingService.java:76`), og gjenbrukte konklusjoner lages ikke — søkt etter «GJENBRUK» som over |
| `@OPT-BEH-BEH-015` | Konklusjon i avsluttet opptak trekkes ikke tilbake | ikke funnet | `gsk/GskVedtakTilbakekallingService.java:52-53,70-79` trekker tilbake på tvers av alle opptak, uten å se på om opptaket er avsluttet — søkt etter «avsluttet», «AVSLUTT», «opptakstatus» i `gsk/` og `vgs/` |
| `@OPT-BEH-BEH-015` | Annulleringen oppdages uten at søkeren endrer søknaden | ikke funnet | Vitnemålene hentes fra KREG bare etter tildelingen i `jobb/SoknadshendelseJobb.java:126-135`. Ingen jevnlig sjekk eller varsel fra KREG — søkt etter kall til `hentVitnemaalFraKreg` |
| `@OPT-BEH-BEH-015` | Se hva den automatiske konklusjonen bygger på | ikke funnet | API-et har `vedtakkilde`, `vitnemaalsnummer` og `merknadAutomatisk` (`fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/gsk.graphqls:323,329,335`), men `GSKCard/GSKCard.tsx:64-89` og `GSKCard/GSKHistory.tsx:17-49` henter dem ikke. `gsk_endringslogg` leses ikke av noen kode — søkt etter «vedtakkilde», «vitnemaalsnummer», «merknadAutomatisk», «gsk_endringslogg» i fs-admin og fs-plattform |

## Kontroll

Kontrollen endret ingen resultater.

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-015` — Automatisk GSK-konklusjon (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature`, `@planned` → `@in-progress`, 5/26 funnet) — `@implemented` på: Scenario: Systemet setter aldri en negativ konklusjon (linje 170), Scenario: Overskrive positiv konklusjon med negativ konklusjon (linje 179), Scenario: Legge til positiv konklusjon når ingen finnes (linje 184), Scenario: Nytt vitnemål når søknaden har konklusjon (linje 201), Scenario: Automatisk konklusjon trekkes tilbake når vitnemålet annulleres (linje 214)

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-015` — Automatisk GSK-konklusjon (`@planned`, 5/26 funnet) — GSK beregnes ikke når søknaden kommer inn og lagres ikke på vitnemålet, gjenbruk fra tidligere opptak finnes ikke, og sporbarheten vises ikke i fs-admin

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Automatisk GSK-konklusjon | `@planned` | 5/26 | 18 ikke funnet, 3 usikker. Brukeren lar kravet og de usikre scenarioene stå urørt, fordi det arbeides med dem i en annen branch |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **GSK beregnes i den automatiske saksbehandlingen:** `autosak/AutomatiskSaksbehandlingService.java:114` (steg 0a) setter GSK-konklusjonen, og den startes bare med mutasjonen `behandleSakAutomatisk`. Kravet flytter beregningen til når søknaden kommer inn (`jobb/SoknadshendelseJobb.java:126-135`, der vitnemålene hentes)
- **Halvautomatisk vei som ikke brukes i fs-admin:** mutasjonen `settGskKonklusjonFraVitnemaal` (`gsk.graphqls:286`, `gsk/SettGskKonklusjonService.java:71`) lar saksbehandleren velge vitnemål ved flere vitnemål, men fs-admin kaller den ikke
- **Åpent spørsmål:** `@OPT-BEH-BEH-015` «Konklusjon fra vitnemålet» — Får søknaden også en GSK-konklusjon fra vitnemålet, eller står konklusjonen bare på vitnemålet?
- **Åpent spørsmål:** `@OPT-BEH-BEH-015` «Gjenbruke kvalitetssikret konklusjon fra FS-klienten» — Hva heter oversikten over kvalitetssikrede GSK-konklusjoner, og hvor ligger den?
- **Åpent spørsmål:** `@OPT-BEH-BEH-015` «Annulleringen oppdages uten at søkeren endrer søknaden» — Hvordan får systemet vite at et vitnemål er annullert, når søkeren ikke sender inn eller endrer en søknad?
- **Ikke sjekket:** min-kompetanse er ikke klonet. Brukeren sa at det ikke trengs, siden søkeren ikke ser GSK-konklusjonen i kravet
