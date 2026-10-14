# Veikart — Brukeradministrasjon og tilgangsstyring

Siste oppdatering: 2026-10-14

Dette veikartet viser oppgaver teamet aktivt jobber med eller har levert. For overordnet prioritering på tvers av FS, se [FS Offentlig saksoversikt](https://github.com/orgs/sikt-no/projects/4/views/3).

## Initiativer vi leverer på

Initiativer er overordnede sakskomplekser teamets oppgaver bidrar til. De eier prioritering og milepæler på produktnivå; oppgavene under dem er det vi faktisk plukker og kjører gjennom fasene.

| Issue | Tittel | Milestone | Merknad |
|-------|--------|-----------|---------|
| [#31](https://github.com/sikt-no/fs/issues/31)  | Grunnleggende selvbetjent brukeradministrasjon for API-brukere via FS Admin | 2026 Robust, effektiv og sikker drift | Paraplyen for API-brukeradministrasjon |
| [#350](https://github.com/sikt-no/fs/issues/350) | Brukeradministrasjon av FS Admin-brukere | 2026 Robust, effektiv og sikker drift | Ansattbrukere i FS Admin |
| [#351](https://github.com/sikt-no/fs/issues/351) | Etablere infrastruktur for felles tilgangsstyring for alle deler av FS | 2026 Robust, effektiv og sikker drift | Felles tilgangsstyringskomponent, JWT, co-processor |

## Aktive oppgaver

| Issue | Oppgave | Initiativ | Fase | Prioritet | Eier | Reviewere | Mappe |
|-------|---------|-----------|------|-----------|------|-----------|-------|
| [#143](https://github.com/sikt-no/fs/issues/143) | Grunnleggende brukeradministrasjon i FS Admin | #350 | utvikling | Should | – | – | [grunnleggende-brukeradministrasjon](grunnleggende-brukeradministrasjon/) |

## Ferdig

API-brukerne heter applikasjoner i kravene. Oppgavemappene er fjernet, og kravene i [`applikasjoner/`](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/) er levert (`@implemented`).

| Issue | Oppgave | Ferdig | Krav |
|-------|---------|--------|------|
| [#32](https://github.com/sikt-no/fs/issues/32) | Lesevisning for API-brukere         | 2025-11-10 | [`listevisning_og_sok`](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature), [`se_detaljer`](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/se_detaljer.feature) |
| [#33](https://github.com/sikt-no/fs/issues/33) | Søk og filter for API-brukere       | 2025-11-10 | [`listevisning_og_sok`](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature) |
| [#36](https://github.com/sikt-no/fs/issues/36) | Opprette API-bruker                 | – | [`opprette_applikasjon`](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature) |
| [#35](https://github.com/sikt-no/fs/issues/35) | Redigere tilganger på API-bruker    | – | [`tildele_tilganger`](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/tildele_tilganger.feature), [`fjerne_tilganger`](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/fjerne_tilganger.feature) |
| [#34](https://github.com/sikt-no/fs/issues/34) | Aktivere/bekrefte og deaktivere API-bruker | – | [`deaktivere_applikasjon`](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/deaktivere_applikasjon.feature) |
| – | Applikasjoner — visning (delta)     | – | [`listevisning_og_sok`](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature), [`vise_tilganger`](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature) |
