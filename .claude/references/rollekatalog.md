# Rollekatalogen: slå opp roller og tilganger

Rollene og hva de gir finnes bare i databasen til tilgangsstyring, ikke i koden. Skillene slår dem opp
med verktøyene i MCP-en **fs-rollekatalog**. Den kommer med pluginen `sta-development-starter-pack` fra
`sta-plugin-marketplace`, og oppsettet står i README-en ved MCP-en. Verktøyene er bare lesende, og
kontrakten står i `KONTRAKT.md` ved MCP-en.

## Rolle eller tilgang

Alle koder ligger i et navnerom, og navneromstypen avgjør hva koden er:

| navneromstype | Hva koden er | Eksempel |
|---|---|---|
| `forretning` | **forretningsrolle**, rollen krav og brukere snakker om | `OPPTAK_FORVALTER` |
| `frontend` | tilgang som FS Admin sjekker (`WithRole`, `useWithRole`) | `FS-ADMIN_OPPTAK_SØKNADSBEHANDLER` |
| `subgraf` | tilgang som API-et og radnivåsikkerheten (RLS) sjekker | `SE_SØKNADSBEHANDLING`, `MODIFISERE_OPPTAK` |
| `tilgangsstyring` | tilgang i brukeradministrasjonen | `BRUKERADMIN_WSBRUKER_LES` |

En forretningsrolle gir frontend- og subgraf-tilganger gjennom rollekatalogen, gjerne via andre
forretningsroller.

## Verktøyene

| Verktøy | Svarer på |
|---|---|
| `finn_roller` | Hvilke forretningsroller finnes, og hva heter rollen brukeren mener? |
| `sjekk_rollenavn` | Er rollenavnene i kravet ekte roller? Status per navn: `finnes`, `sannsynlig`, `tvetydig`, `feil_type` (en tilgang, ikke en rolle) eller `ukjent`, med forslag. |
| `rolle_gir` | Hva gir rollen, gruppert på `forretning`, `frontend` og `subgraf`? Virker den i FS Admin, og hvilke subgraf-tilganger har den? |
| `roller_som_gir` | Hvilke forretningsroller gir tilgangen, med kjeden (`vei`)? Den minste rollen for en testbruker. |
| `rolle_detaljer` | Ett nivå i hver retning, og om rollen er utgått. |

Verktøynavnene i Claude Code er `mcp__plugin_sta-development-starter-pack_fs-rollekatalog__<verktøy>`.
Prefikset står bare her, i `allowed-tools` i fs-krav-avvik, i `tools` i `.claude/agents/fs-verify-krav.md` og
`.claude/agents/fs-verify-kontroll.md`, og i `.claude/settings.json`. Flytter MCP-en, er det disse stedene som endres.

## Regler

- **Navn i kravet:** skriv visningsnavnet i stegene («opptaksforvalter»), ikke koden. Koden hører til testdata og kommentarer. `sjekk_rollenavn` gir koden som navnet svarer til.
- **`sannsynlig` er et forslag:** status `sannsynlig` eller `tvetydig` avklares med brukeren før navnet regnes som riktig.
- **`feil_type`:** kravet nevner en tilgang som om den var en rolle. Foreslå en av forretningsrollene i `gis_av`, som gir tilgangen.
- **`utgatte_treff`:** navnet er navnet på en utgått rolle, ofte det gamle navnet på en rolle som er erstattet. Bruk den aktive rollen i `rolle` eller `forslag`.
- **Utgåtte roller** (`utgatt` er satt) skal ikke brukes i nye krav eller testbrukere.
- **Miljø:** katalogen er den samme i alle miljøer. Bruk standardmiljøet (`production`) med mindre brukeren ber om noe annet.
- **Svarer ikke verktøyene** (MCP-en mangler, ikke innlogget): si det, og fortsett uten. Rollene som ikke er bekreftet, skrives som `[Fylles ut: …]`. Gjett aldri rollenavn eller hva en rolle gir.

## RLS og FS Admin: hva katalogen ikke vet

Katalogen sier hva en rolle **gir**, ikke hva koden **krever**. Det leses i koden og sammenlignes:

1. **FS Admin:** `rolle_gir(<rolle>).gir.frontend` mot rollene i `WithRole`, `useWithRole` og `useOrganisasjonerWithRole` (`src/common/types/generated/tilgangsroller.ts`). Mangler koden skjermen krever, virker ikke rollen i FS Admin.
2. **Subgrafene (Postgres: opptak, utdanningsregisteret, kreg):** `rolle_gir(<rolle>).gir.subgraf` mot koden policyen sjekker. Les `auth.har_orgtilgang('<KODE>', …)` / `auth.har_tilgang('<KODE>')` i `CREATE POLICY` og `ALTER POLICY` i migreringene, og `Handling.java` / `ServiceTilgangsrolle.java`. Den siste migreringen som endrer policyen gjelder.
3. **sis og kompetanse (Oracle RAS):** ACL-ene er ikke i repoet. Det som kan sjekkes, er at koden ligger i et `subgraf`-navnerom og at rollen gir den. Skriv det slik i rapporten, ikke `stemmer`.
4. **Motsatt vei:** `roller_som_gir(<kode koden krever>)` gir rollene som faktisk slipper gjennom («Koden gjør»).
