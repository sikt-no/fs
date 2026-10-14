# Verifisering: 12 Brukeradministrasjon

- **Dato:** 2026-10-14 12:48
- **Krav:** `krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/` (31 feature-filer)
- **Kode:** `fs-plattform` (ikke sjekket (Claude-panelet)), `fs-admin` (ikke sjekket (Claude-panelet))
- **Kontroll:** manuell (Claude-panelet)
- **Skjermbilder:** nei

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`.

Stiene er forkortet:

- `changelog/` = `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/`
- `service/` = `fs-plattform/tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/`
- `PersonbrukerDetails/` = `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/`

## Oppsummering

- Scenarioer: 2 funnet, 1 ikke funnet, 0 usikker, av 3
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 4

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@BRU-PER-GRU-004` | Deaktivere en personbruker med aktive tildelinger | funnet | `service/FeideBrukerStatusService.java:119-127` — setter deaktivert_tidspunkt og hvem (bruker og applikasjon); `changelog/0033-deaktivering-feide-bruker.sql:72-84` — status DEAKTIVERT utledes; `changelog/0086-personsubjekt-inflight-migrering.sql:425` — deaktivert bruker får tomme tilganger, også med personsubjekt, og tildelingene røres ikke; `PersonbrukerDetails/components/PersonbrukerTopBar/PersonbrukerStatusActions.tsx:46-47` — Deaktiver/Aktiver i fs-admin |
| `@BRU-PER-GRU-004` | Reaktivere en deaktivert personbruker | ikke funnet | Reaktiveringen virker, og utløpte tildelinger blir ikke aktive igjen (`service/FeideBrukerStatusService.java:130-135`, `changelog/0033-deaktivering-feide-bruker.sql:11-15`). Men reaktiveringen nuller hvem og når den tidligere deaktiveringen skjedde, og endringsloggen som skal bære historikken, finnes ikke (`changelog/0033-deaktivering-feide-bruker.sql:97`). Mangler: «det lagres når reaktiveringen skjedde og hvem som gjorde den» og «det som ble lagret om den tidligere deaktiveringen, beholdes» — søkt etter «endringslogg», «historikk», «_hist», «audit», «reaktivert_tidspunkt», «statuslogg», «statushistorikk» i fs-plattform og fs-admin |
| `@BRU-PER-GRU-004` | Deaktivering skiller seg fra fjerning av tildelinger | funnet | `changelog/0033-deaktivering-feide-bruker.sql:11-15` — tildelingsradene røres ikke, og blir gjeldende igjen ved reaktivering; `service/FeideBrukerStatusService.java:62-65` |

## Kontroll

Kontrollen endret ingen resultater.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@BRU-PER-GRU-004` | Aktivere og deaktivere en personbrukers samlede tilganger | `@in-progress` | 2/3 | 1 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

- **`@BRU-PER-GRU-008` — Scenario: Se brukerens roller** (`personbrukere/1 - Grunnleggende brukeradministrasjon/vise_roller.feature`)
  - `PersonbrukerDetails/components/PersonbrukerRoller/components/PersonbrukerRollerResultList/PersonbrukerRollerResultList.tsx:202` — kolonnen heter fortsatt «Organisasjon» (`fs-admin/src/common/messages/nb/domains.json:50`), ikke «Gjelder for»
- **`@BRU-PER-GRU-001` — Scenario: Brukeradministrator ser personbrukere med datatilgang fra egne organisasjoner** (`personbrukere/1 - Grunnleggende brukeradministrasjon/søke_opp_bruker.feature`)
  - `changelog/0076-miljostyrt-tildelingsgren-feidebruker.sql:50-59` — synlighet via tildeling i (miljø, organisasjon) kalleren har BRUKERADMIN_FEIDEBRUKER_LES i
- **`@BRU-PER-GRU-001` — Scenario: Personbrukere uten tilknytning til egne organisasjoner er ikke synlige** (`personbrukere/1 - Grunnleggende brukeradministrasjon/søke_opp_bruker.feature`)
  - `changelog/0069-saksdelegering-og-se-saksbehandlere.sql:88-104` — uten tildeling, domene eller saksbehandlertildeling er brukeren ikke synlig
- **`@BRU-PER-GRU-001` — Scenario: Personbrukere med datatilgang i et miljø jeg ikke administrerer er ikke synlige** (`personbrukere/1 - Grunnleggende brukeradministrasjon/søke_opp_bruker.feature`)
  - `changelog/0076-miljostyrt-tildelingsgren-feidebruker.sql:56-58` — tildelingen må ligge i samme miljø som privilegiet

## Oppfølging

- **Historikk er utsatt:** Det eneste som mangler i `@BRU-PER-GRU-004`, er historikken ved reaktivering. Stegene om historikk kan flyttes til `2 - Historikk/brukerhistorikk.feature` (`@draft`) med `fs-krav`. Da kan `@BRU-PER-GRU-004` verifiseres på nytt og bli `@implemented`.
- **`@planned`-del passer ikke med koden:** «Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer» (`søke_opp_bruker.feature`) krever aktiv rolle, men koden gir synlighet også ved lukkede tildelinger, med vilje (`changelog/0076-miljostyrt-tildelingsgren-feidebruker.sql:70-71`). Bør avklares før `fs-specify` henter delen inn.
- **Personsubjekt er nytt siden forrige kjøring:** `changelog/0085-personsubjekt.sql` til `0094-min-personbruker.sql` innfører personsubjekt med egne lese- og tildelingsprivilegier (`BRUKERADMIN_PERSON_LES`, `changelog/0086-personsubjekt-inflight-migrering.sql:724-746`). Ingen krav i scope beskriver personsubjekt. Det bør vurderes om synlighets- og tildelingskravene må ta det med.
- **`@planned`-deler som ikke er hentet inn i en oppgave:** `vise_roller.feature` — Scenario: Se brukerens roller med «Gjelder for»; `søke_opp_bruker.feature` — de tre `@planned`-synlighetsscenarioene. Henvis til `fs-specify`.
- **Mappestruktur:** Feature-filene ligger på nivå 4 (`12 Brukeradministrasjon/personbrukere/<NN - …>/`), og `personbrukere` og undermappene er ikke nummerert etter konvensjonen. Tre mapper heter `5 - …`.
- **Ikke sjekket:** min-kompetanse (ingen scenarioer i scope gjelder søkeren). Branchene i klonene er ikke sjekket mot origin (Claude-panelet).
- **Krav utenfor scope:** `søke_opp_bruker.feature`, `se_detaljer.feature`, `vise_roller.feature`, `fjerne_roller.feature` (`@implemented`) — allerede levert, med `@draft`-, `@planned`- og `@deprecated`-deler. `tildele_roller.feature`, `synkronisere_roller_fra_namespace.feature`, `se_egen_brukerprofil.feature` (`@planned`) — henvis til `fs-specify`. De øvrige 23 (`@draft`) — henvis til `fs-krav`.
