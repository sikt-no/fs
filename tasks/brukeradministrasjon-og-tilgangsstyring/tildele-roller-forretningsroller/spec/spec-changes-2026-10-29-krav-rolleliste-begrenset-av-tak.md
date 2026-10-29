# Delta-spec: Valglisten for rolle begrenset av taket — 2026-10-29-krav-rolleliste-begrenset-av-tak

> Eksisterende krav som ikke er nevnt i denne delta-en forblir gjeldende. Endringer her erstatter eller utvider tidligere krav på de berørte områdene.

> **Avvik fra skillen:** Regelen i denne delta-en er `@draft`. `fs-specify-delta` holder normalt `@draft`-deler utenfor. Kjetil har bestemt at den skal være med som endringen likevel, uten at statusen endres. Regelen står fortsatt som `@draft`, og ingenting er retagget. Den er ikke validert som `@planned`, så spesifikasjonen er ikke klar til utvikling før statusen er avklart.
>
> **Oppdatert 2026-10-29:** Regelen er senere validert, og har `@planned` fra egenskapen (se åpent spørsmål 1). Den er ikke retagget `@in-progress` ennå.

## Kilde

- **Oppgave:** `tasks/brukeradministrasjon-og-tilgangsstyring/tildele-roller-forretningsroller/`
- **Scope:** scope-restanser-etter-onboarding
- **Type:** `branch`
- **Branch:** `krav/rolleliste-begrenset-av-tak` ([PR #866](https://github.com/sikt-no/fs/pull/866)), branch-SHA `43564e0d6111867d7e661f8adcad18f140f8a903`, main-SHA `dad73b1d6ea10d625a36e15a312dc1e072e3a54a` ([sammenligning](https://github.com/sikt-no/fs/compare/dad73b1d6ea10d625a36e15a312dc1e072e3a54a...43564e0d6111867d7e661f8adcad18f140f8a903))
- **Lokalt:** `git diff dad73b1d6ea10d625a36e15a312dc1e072e3a54a...43564e0d6111867d7e661f8adcad18f140f8a903 -- krav/`
- **Hentet:** 2026-10-29 16:36

## Omfang

Når organisasjon og miljø er valgt i dialogen «Tildel roller», viser valglisten for rolle bare forretningsroller som er i taket til minst én applikasjon i organisasjonen og miljøet. Tak for en organisasjonssamling organisasjonen er med i teller, og det gjør også roller som en rolle i taket gir. Har ingen applikasjon tak i organisasjonen og miljøet, er listen tom. Delta-en dekker ikke tilganger, ikke tildeling til applikasjoner og ikke fjerning av roller. Den innfører heller ingen håndheving: en tildeling av en rolle utenfor taket avvises ikke.

## Krav

### Endret _(diff-status: `modified`)_

- **`tildele_roller.feature` — regel `Valglisten for rolle viser bare roller som er i taket til en applikasjon i valgt organisasjon og miljø`** (`@BRU-PER-GRU-003`, `@draft`, tatt med etter beslutning fra Kjetil) — ny regel med seks scenarioer:
  - rollen vises bare når en applikasjon har den i taket for valgt organisasjon og miljø (ikke for et annet miljø eller en annen organisasjon)
  - en rolle som ikke er i taket til noen applikasjon, vises ikke
  - tak for en organisasjonssamling gjelder organisasjonene i samlingen
  - en rolle som en rolle i taket gir, vises
  - valglisten er tom når ingen applikasjon har tak i organisasjonen og miljøet
  - en rolle som ikke er i noe tak, kan fortsatt fjernes (`@ref-BRU-PER-GRU-012`, henvisning, ikke avhengighet)

  Avklart av produkteier 29.10.2026 (AVKLART-kommentaren i regelen): gjelder bare forretningsroller som tildeles personbrukere, ikke tilganger (BRU-PER-GRU-009) og ikke tildeling til applikasjoner (BRU-APP-API-007). Gjelder når roller legges til, ikke når de fjernes. Taket begrenser bare valglisten. Resten av fila er uendret. ([før](https://github.com/sikt-no/fs/blob/dad73b1d6ea10d625a36e15a312dc1e072e3a54a/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/tildele_roller.feature)) · ([etter](https://github.com/sikt-no/fs/blob/43564e0d6111867d7e661f8adcad18f140f8a903/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/tildele_roller.feature)) ([krav/07 …/tildele_roller.feature](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/tildele_roller.feature))

### Utenfor scope (`@draft`)

- **`tildele_roller.feature` — scenario `Tildeling av en rolle som ikke er en forretningsrolle avvises`** — uendret i denne delta-en, og ikke med. Venter på: når håndhevingen skal bygges, og om direkte tildelinger av brukerflateroller fra før skal ryddes.

## Skisser

### Skisse: Dagens dialog «Tildel roller»

- **Type:** `lokal-bilde`
- **Referanse:** [`krav-input/changes/2026-10-29-krav-rolleliste-begrenset-av-tak/sketches/dagens-tildel-roller-dialog.png`](krav-input/changes/2026-10-29-krav-rolleliste-begrenset-av-tak/sketches/dagens-tildel-roller-dialog.png)
- **Lagrede artefakter:** skjermbildet over. Ingen Figma-skisser finnes.
- **Dekker krav:** `tildele_roller.feature` (regel: Valglisten for rolle viser bare roller som er i taket …), som illustrasjon av dagens tilstand: organisasjon Universitetet i Stavanger, miljø Produksjon, og valglisten for rolle viser roller som ikke får effekt der.
- **Valideringsstatus:** `Avvik: skjermbildet viser dagens valgliste, som regelen skal endre`
- **Beslutning ved avvik:** Kravene er riktige, skjermbildet viser dagens tilstand. Det er ikke en skisse av ønsket løsning, og beholdes bare som illustrasjon av problemet.

## Implementasjonsdetaljer

- **`tildele_roller.feature`** — [tildele_roller.design.md](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/tildele_roller.design.md) (ingen åpne designspørsmål)

## Kodesjekk

- **Sjekket:** fs-plattform og fs-admin, lest på `origin/main` (begge lokale kloner var bak main og ble ikke pullet).
- Ingen avvik mellom kravet og begrepene i koden:
  - Taket finnes som delegeringstaket per Feide-applikasjon, organisasjon og miljø (`fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_delegeringstak.graphqls:27`).
  - Taket har en samlingsform for organisasjonssamlinger, som gjelder hver aktiv medlemsorganisasjon i radens miljø (`fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0080-delegeringstak-organisasjonssamling.sql:4`).
  - Implikasjoner («gir») virker også i delegeringstaket (`fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_rollekatalog_forvaltning.graphqls:488`).
  - Valglisten for rolle i FS Admin henter rollene fra `mineTildelbareTilgangsroller`, som i dag har filtre for organisasjon, miljø, navneromstype og utgåtte roller, men ikke for taket (`fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_personbruker_tilgang_med_nummer.graphqls:127` og `:158`, `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/hooks/useTildelbareBrukerTilgangskoder.tsx:37`).
- **Merknader til kode-repoene** (ikke avvik):
  - Implementasjonshint fra Kjetil: trolig et nytt filter på den eksisterende spørringen etter tildelbare roller (`mineTildelbareTilgangsroller`).
  - Bare Feide-applikasjoner har tak (`schema_delegeringstak.graphqls:11`). Maskinporten- og maskinbruker-applikasjoner bidrar derfor ikke til valglisten.
  - Taket er temporalt (`gyldighetsperiode`, `erAktivNaa`). Se åpent spørsmål om hvilke perioder som teller.
  - Lesing av taket er styrt av RLS (LES i organisasjonen eller i applikasjonens eierorganisasjon, `0080-delegeringstak-organisasjonssamling.sql:21`). En brukeradministrator ser ikke nødvendigvis taket, så filteret må kunne avgjøre om en rolle er i et tak uten å vise taket.
  - Dagens tomme valgliste har teksten «Ingen roller å tildele i denne kombinasjonen.», skrevet for manglende rettighet (`fs-admin/src/common/messages/nb/tilgangsstyring.json:174`).

## Retagging

Ingen retagging. Regelen er `@draft` og står urørt, og `Egenskap:`-linja (`@BRU-PER-GRU-003 @must @planned @scope-restanser-etter-onboarding`) er ikke endret. Kjetil har ikke bestemt å endre statusen.

## Åpne spørsmål

- [x] Status: regelen er `@draft`. Skal den valideres til `@planned` (via `fs-krav`) før den bygges? Delta-en er laget med `@draft`-regelen etter beslutning fra Kjetil, men statusen er ikke endret.
  **Beslutning 2026-10-29 (Kjetil):** Regelen er validert. `@draft` er fjernet fra regelen med `fs-krav`, så den har `@planned` fra egenskapen. Den har ikke fått en egen `@planned`-tag, fordi en del under en `@planned` egenskap ikke kan ha egen implementasjonsstatus (*Delvis utkast* i `krav/README.md`). Regelen er ikke retagget `@in-progress` ennå.
- [x] Oppgave og scope: `tildele_roller.feature` står i scope-raden for denne oppgaven (BAT-326) i scope-restanser-etter-onboarding, men regelen er ikke en del av det scopet (PR #866). Delta-en er lagt i denne oppgaven som standardvalg. Skal scopet oppdateres med `fs-scope` (modus B), eller skal regelen få en egen oppgave og Jira-sak?
  **Beslutning 2026-10-29 (Kjetil):** Regelen hører til denne oppgaven (BAT-326). Scopet er oppdatert med `fs-scope` (modus B): mål, kilde (#866) og kommentaren i scope-raden for `@BRU-PER-GRU-003`. Egenskapen har `@scope-restanser-etter-onboarding` fra før, så regelen har ikke fått en egen scope-tag.
- [x] Hvilke perioder i taket teller: bare delegeringer som gjelder nå, eller også delegeringer med en periode som starter senere? Standardvalg til det er avklart: bare de som gjelder nå.
  **Beslutning 2026-10-29 (Kjetil):** Bare tak som gjelder nå, teller: gyldighetsperioden inneholder tidspunktet nå, og taket er ikke ugyldiggjort. Tak med en periode som starter senere eller er utløpt, teller ikke. Begrunnelse: regelen skal fjerne roller som ikke får effekt for personbrukeren, og et tak som ikke gjelder nå, gir ingen effekt.
- [x] Skal den tomme valglisten ha en egen tekst når ingen applikasjon har tak, så den skiller seg fra manglende rettighet? (Åpent designspørsmål i implementasjonsdetaljene.)
  **Beslutning 2026-10-29 (Kjetil):** Den nøytrale teksten «Ingen roller å tildele i denne kombinasjonen.» (`rollerIngenRettighet`, varianten for roller, i `tilgangsstyring.json`) beholdes. Begrunnelse: den følger mønsteret i tilgangsstyringsmodulen i FS Admin. Dialogen for applikasjoner bruker samme tekst («Ingen tilganger å tildele i denne kombinasjonen.»), og koden sier at den tomme listen er porten (`useTildelbareTilgangskoder`), så klienten skiller ikke på hvorfor listen er tom. En tildeling som faktisk avvises, har en egen feilmelding: «Du har ikke rettighet til å tildele i denne kombinasjonen av organisasjon og miljø.» Designspørsmålet i `tildele_roller.design.md` er lukket på samme måte.

## Rute

fs-plattform → fs-admin
