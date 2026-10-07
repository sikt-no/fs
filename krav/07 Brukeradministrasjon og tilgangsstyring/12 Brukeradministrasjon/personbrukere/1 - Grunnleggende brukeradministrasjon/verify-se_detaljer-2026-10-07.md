# Verifisering: se_detaljer.feature (@BRU-PER-GRU-007), uansett status

- **Dato:** 2026-10-07
- **Krav:** `krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon/se_detaljer.feature`
- **Kode:** `fs-admin`, `fs-plattform`
- **Team:** ingen (én feature-fil, `fs-verify` direkte)

## Oppsummering

- Retagget `@in-progress` → `@implemented`: 1 (etter beslutning fra brukeren, se under)
- Deler i leverte krav som er levert (`@in-progress` fjernet): 0
- Fortsatt `@in-progress`: 0
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@BRU-PER-GRU-007` | Se navn | funnet | `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerDetaljer/PersonbrukerDetaljer.tsx:74` · skjermbilde i chat (ikke lagret) |
| `@BRU-PER-GRU-007` | Se Feide-ID | funnet | `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerDetaljer/PersonbrukerDetaljer.tsx:103` · skjermbilde i chat (ikke lagret) |
| `@BRU-PER-GRU-007` | Se hjemorganisasjon | funnet | `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerDetaljer/PersonbrukerDetaljer.tsx:109`, `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/hooks/useGetPersonbruker.tsx:58`, `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_brukeradmin.graphqls:248` · skjermbilde i chat (ikke lagret) |
| `@BRU-PER-GRU-007` | Hjemorganisasjonen er ukjent | funnet | `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0073-feidebruker-hjemmeorganisasjon.sql:63` (ingen rad for uregistrert domene → null); `PersonbrukerDetaljer.tsx:63` viser «-», og bruker aldri tildelingsorganisasjonene i stedet. Ingen slik bruker i test, så det finnes ikke noe skjermbilde |
| `@BRU-PER-GRU-007` | Se status | funnet | `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerDetaljer/PersonbrukerDetaljer.tsx:82` (TagStatus Aktiv/Deaktivert); test `PersonbrukerDetaljer.test.tsx:119` · skjermbilde i chat (ikke lagret; viser bare Aktiv) |
| `@BRU-PER-GRU-007` | Se sist brukt | ikke funnet | Søkte etter `sistBrukt`, `sistInnlogget`, `sist_brukt` og «Sist brukt» i fs-admin. `PersonbrukerDetaljer.tsx:44` sier at innloggingstidspunktet ikke lagres |

## Retagget til @implemented

| Feature-ID | Egenskap | Fil | Gating funnet |
| --- | --- | --- | --- |
| `@BRU-PER-GRU-007` | Se detaljer for personbruker | `se_detaljer.feature` | 5 av 6 |

Ikke hele gating-settet ble funnet. Brukeren bestemte likevel at egenskapen skulle bli `@implemented`. `Regel: Sist brukt (planlagt etter v1)` står som `@draft @openquestion`, med et åpent spørsmål om at backend ikke har støtte for det. Den er ikke levert.

## Oppfølging

- Ingen step definitions i `tester/steps/` for kravet.
- Skjermbildet ble tatt fra https://test-fsadmin.sikt.no/ (detaljsiden for `mamyh@sikt.no`), men er ikke lagret, fordi scope er en `krav/`-sti og ikke en oppgave. Scenarioet om ukjent hjemorganisasjon og status «Deaktivert» kunne ikke vises, fordi alle 71 personbrukerne i test er aktive Sikt-brukere.
