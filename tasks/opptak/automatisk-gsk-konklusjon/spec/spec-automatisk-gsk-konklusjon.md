# Spec: Automatisk GSK-konklusjon

## Kilde

- **Oppgave:** `tasks/opptak/automatisk-gsk-konklusjon/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`
- **GitHub:** [#723](https://github.com/sikt-no/fs/issues/723)
- **Hentet:** `2026-10-13 15:54`

## Omfang

Spesifikasjonen dekker automatisk GSK-konklusjon på søknaden: positiv konklusjon fra vitnemålet eller gjenbrukt fra et tidligere opptak, at automatikken bare setter positive konklusjoner der ingen finnes, saksbehandlerens endringer, ny vurdering ved nytt vitnemål, tilbakekalling når vitnemålet annulleres, og at saksbehandleren ser hva konklusjonen bygger på. Vitnemålsveien og manuell endring finnes; gjenbruk, ny vurdering ved nytt vitnemål, sjekken av arkiverte opptak og visningen i fs-admin mangler. Gjenbruk fra FS-klienten og oppdagelse av annullering uten søknadshendelse venter på åpne spørsmål. Det søkeren ser, er ikke med.

## Krav

- **`automatisk_gsk_konklusjon.feature`** (`@OPT-BEH-BEH-015`). Positiv GSK-konklusjon fra vitnemålet eller fra et tidligere opptak, at automatikken aldri setter negative konklusjoner eller overskriver en konklusjon, saksbehandlerens endringer, ny vurdering ved nytt vitnemål, tilbakekalling ved annullert vitnemål, og sporbarhet for saksbehandleren. To scenarioer er `@openquestion` (se _Åpne spørsmål_). ([krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_gsk_konklusjon.feature))

Hva som finnes og mangler per scenario, står i verify-rapporten fra i dag: 9 funnet, 11 ikke funnet og 4 usikker av 24 ([verify-automatisk_gsk_konklusjon-2026-10-13-1403.md](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-automatisk_gsk_konklusjon-2026-10-13-1403.md)).

## Skisser

### Skisse: Saksbehandling sekvens V2

- **Type:** `figma`
- **Referanse:** https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=9840-220112 (rammen som var markert i fila; lenken brukeren ga, hadde ingen `node-id`)
- **Lagrede artefakter:** ingen. Figma-MCP stoppet på grensen for kall på View-setet, og WebFetch fikk 403 (se [manifest.md](krav-input/manifest.md)).
- **Dekker krav:** `automatisk_gsk_konklusjon.feature`
- **Valideringsstatus:** `Uavklart: rammen kunne ikke hentes, så det er ikke sjekket at den viser GSK-konklusjonen eller hva den viser`
- **Beslutning ved avvik:** –

## Kodesjekk

- **Sjekket:** fs-plattform (`da44bb30a2`, main), fs-admin (`882b51d7c`, origin/main). min-kompetanse er ikke sjekket: ingen scenarioer gjelder det søkeren ser.

Stiene er forkortet: `autosak/` og `soknad/` er `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/` og `.../opptak/soknad/`, og `migration/` er `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`.

Avvik:

- `@OPT-BEH-BEH-015`, «Vitnemål som gir generell studiekompetanse»: kravet sier at ett vitnemål som ikke er annullert, gir konklusjon. Koden krever nøyaktig ett VGS-dokument som ikke er annullert, og at det er et vitnemål (`autosak/gsk/GskVedtakAutoService.java:77-83`), så en søker med vitnemål og kompetansebevis får ingen konklusjon. Koden skal endres.
- `@OPT-BEH-BEH-015`, «avsluttet opptak» (regelen «Annullert vitnemål» og «Konklusjon som bygger på et annullert vitnemål gjenbrukes ikke»): koden har ikke begrepet. Avklart: et avsluttet opptak er et opptak med opptaksstatus `ARKIVERT` (`migration/V280__opptak_v2_skjema.sql:1583-1586`). Tilbakekallingen sjekker ikke status i dag (`autosak/gsk/GskVedtakTilbakekallingService.java:64-116`).

Ikke avvik, men noe kode-repoene bør vite:

- **Når automatikken kjøres:** GSK-automatikken er steg 0a i den automatiske saksbehandlingen (`autosak/AutomatiskSaksbehandlingService.java:112-114`), som bare startes av `behandleSakAutomatisk` (`fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/automatisk-saksbehandling.graphqls:52`), fra knappen «Behandle sak automatisk» i fs-admin. Avklart: når den automatiske saksbehandlingen starter, er utenfor kravet, og «når en søknad kommer inn» i beskrivelsen er ikke et avvik. Regelen «Ny vurdering når søkeren får et nytt vitnemål» krever likevel at vurderingen startes når søkeren får et nytt vitnemål, og ingenting gjør det i dag.
- **Konklusjonen per søker og opptak:** `gsk_vedtak` har nøkkelen `(soker_id, opptak_kode)` og deles av alle organisasjonene i opptaket (`migration/V374__gsk_vedtak_opptaksnokkel.sql:1-3`, `autosak/gsk/GskVedtakAutoService.java:131-143`). Det stemmer med at konklusjonen «gjelder hos alle organisasjonene søkeren søker hos i opptaket».
- **Samordna og lokalt opptak:** `opptak.er_samordnet` (`migration/V280__opptak_v2_skjema.sql:222`).
- **Kilden til konklusjonen:** vedtakkildene `AUT` (`migration/V277__vedtakkilde_automatisk.sql:6-12`) og `GJENBRUK` (`migration/V375__gsk_vedtak_endringslogg.sql:282-291`), og kolonnen `kilde_opptak_kode` (`migration/V374__gsk_vedtak_opptaksnokkel.sql:14-18`). `GJENBRUK` og `kilde_opptak_kode` brukes ikke av koden ennå.
- **Konklusjoner fra FS-klienten:** vedtakkildene `IMM`, `NOM` og `LOK` (`migration/V48__gsk-databasen.sql:439-448`) og `IMP` (`migration/V375__gsk_vedtak_endringslogg.sql:282-291`). `NOM` betyr i kodeverket «Fra SO-Behandling-tabeller f.o.m. 1997», men fs-admin sender `NOM` når saksbehandleren setter eller endrer en konklusjon (`fs-admin/src/domains/soknadsbehandling/features/GSKCard/GSKCard.tsx:231`). Kravet skiller konklusjoner satt i FS Admin fra konklusjoner satt i FS-klienten i lokale opptak.
- **Annullering:** tilbakekallingen setter `KVALIFISERT_MEN_ANNULLERT` med årsak `AVM` (annullert vitnemål) (`autosak/gsk/GskVedtakTilbakekallingService.java:40-42,64-116`). En annullert konklusjon regnes som gjeldende (`soknad/gskvedtak/GskVedtakConditions.java:14-15`), så automatikken stopper (`autosak/gsk/GskVedtakAutoService.java:65-67`). Se _Åpne spørsmål_.
- **Negativ konklusjon uten konklusjon fra før:** `soknad/gskvedtak/GskVedtakService.java:457-462` avviser `IKKE_KVALIFISERT` når søknaden ikke har konklusjon. Det stemmer med «Bare positive konklusjoner kan legges til når ingen finnes». fs-admin tilbyr valget likevel (verify-rapporten).
- **Fagskoleopptak:** `GskVedtakAutoService` skiller ikke på opptakstype. Det stemmer med kravet.
- **Semi-automatikken** (`autosak/gsk/SettGskKonklusjonService.java`) har en reserve som gir KLY eller RFA for løp uten grunnlagskode (`autosak/gsk/GskKonklusjonEvaluator.java:83-94`). Hel-automatikken bruker den ikke, og kravet beskriver ikke semi-automatikken.

## Retagging

Feature-ID-en er byttet fra `@OPT-BEH-BEH-009` til `@OPT-BEH-BEH-015` (PR #726), fordi `finne_søknader_om_tidlig_opptak.feature` (oppgaven `tidlig-opptak`) har 009. Verify-rapporten fra i dag bruker den nye ID-en.

| Fil | Før | Etter |
|---|---|---|
| `krav/02 …/02 Behandling/automatisk_gsk_konklusjon.feature` | `@OPT-BEH-BEH-015 @must @planned` | `@OPT-BEH-BEH-015 @must @in-progress` |

## Åpne spørsmål

- [ ] `@OPT-BEH-BEH-015`, «Gjenbruke kvalitetssikret konklusjon fra FS-klienten» (`@openquestion`): hva heter oversikten over kvalitetssikrede GSK-konklusjoner, og hvor ligger den? Det er en egen sak. Ikke bygg den delen før det er avklart.
- [ ] `@OPT-BEH-BEH-015`, «Annulleringen oppdages uten at søkeren endrer søknaden» (`@openquestion`): skal systemet få vite om annulleringen ved et varsel fra KREG, eller ved en jevnlig sjekk? I dag hentes vitnemålene bare når en søknadshendelse behandles. Ikke bygg den delen før det er avklart.
- [ ] `@OPT-BEH-BEH-015`, ny konklusjon etter annullering: «Nytt vitnemål når søknaden har konklusjon» sier at konklusjonen er uendret, og koden regner en annullert konklusjon som gjeldende (`GskVedtakConditions.java:14-15`). Kommentaren på #723 ønsker at søkeren kan få en positiv konklusjon igjen når det kommer et nytt vitnemål etter annulleringen. Gjelder regelen også en annullert konklusjon? Avklares med `fs-krav`.
- [ ] Skissen «Saksbehandling sekvens V2» er ikke hentet eller validert. Kjør skissesteget på nytt når Figma-MCP-kallene er tilbake, og sjekk at rammen er den riktige.
- [ ] Implementasjonsdetaljer mangler for `automatisk_gsk_konklusjon.feature`. Tekstene for GSK-kortet (bare positive valg, annullert vitnemål, automatisk eller gjenbrukt konklusjon) må inn i `automatisk_gsk_konklusjon.design.md` med `fs-implementasjonsdetaljer`, sammen med skissesteget.
- [ ] Issuet #723 er utdatert: det sier at konklusjoner fra FS-klienten ikke gjenbrukes, og at kravet er `@draft`.

## Rute

fs-plattform → fs-admin
