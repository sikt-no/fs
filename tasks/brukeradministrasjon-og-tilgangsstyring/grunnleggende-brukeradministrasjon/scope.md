# Scope: Grunnleggende brukeradministrasjon

- **Slug**: grunnleggende-brukeradministrasjon (= navnet på mappa og taggen `@scope-grunnleggende-brukeradministrasjon`)
- **Domene**: brukeradministrasjon-og-tilgangsstyring (se [`../../README.md`](../../README.md#domener))
- **Initiativ**: [#350](https://github.com/sikt-no/fs/issues/350)
- **Jira**: [sikt-no/fs#143](https://github.com/sikt-no/fs/issues/143)
- **Eier**: –
- **Fase**: utvikling
- **Prioritet**: Should
- **Type**: feature
- **Siste oppdatering**: 2026-11-02

Som systemeier har jeg behov for å tildele personer tilgang til FS Admin, slik at de som brukere kan utføre studieadministrative oppgaver for et lærested eller en opptaksinstans, eller utføre brukerstøtte og support til andre, på bakgrunn av tjenstelig behov.

Oppgaven dekker grunnleggende administrasjon av personbrukere: liste, detaljvisning, oppretting, redigering og tildeling av roller på organisasjons-scope.

## Mål

- Fullføre det som gjenstår av v1 i `1 - Grunnleggende brukeradministrasjon`: reaktivering av deaktiverte personbrukere.

## Ikke-mål

- Restansene etter onboarding (akronym og søk i organisasjonsfiltrene, tildeling av roller): [scope-restanser-etter-onboarding](../restanser-etter-onboarding/scope.md).
- Synlighet via aktiv rolle og «Gjelder for», som erstatter `@deprecated`-deler: [scope-synlighet-og-gjelder-for](../synlighet-og-gjelder-for/scope.md).
- Tilganger: se, tildele og fjerne tilganger (`@BRU-PER-GRU-002`, `-009`, `-011`). Planlagt etter v1.
- Stedkoder (`@BRU-PER-GRU-005`, #483) og tidsbegrensning (`@BRU-PER-GRU-006`, #484). Utsatt til en senere versjon.
- Automatisk synkronisering av roller fra namespacet (`@BRU-PER-GRU-010`, #552). Har eget issue.
- `@draft`-delene i de leverte kravene: «Sist brukt» i listen og på detaljsiden, historikk for fjerning av roller, og de åpne scenarioene i rollevisningen.

## Kilder

- [#350](https://github.com/sikt-no/fs/issues/350) — initiativet «Brukeradministrasjon av FS Admin-brukere»
- [#504](https://github.com/sikt-no/fs/issues/504) — sub-issuet «1 - Grunnleggende brukeradministrasjon»
- [FS-Admin – Målbilde, node 4551:5331](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) — «Brukeradministrasjon v 1.0»: liste, detaljside og modalene
- [Verifisering 2026-10-14](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/verify-1%20-%20Grunnleggende%20brukeradministrasjon-2026-10-14-1544.md) — hva som gjenstår i fs-plattform og fs-admin per krav

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@BRU-PER-GRU-004` — Scenario: Reaktivere en deaktivert personbruker [aktivere_og_deaktivere_bruker.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/aktivere_og_deaktivere_bruker.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | – | Verify 2026-10-14: reaktiveringen nuller det som er lagret om deaktiveringen, og lagrer ikke når og av hvem den ble gjort (fs-plattform) |

## Åpne spørsmål

–

## Merknader

- Issuet #143 hadde tidligere labelen `Trenger innhold`. Kravene er siden skrevet som Gherkin under `krav_path` over, og spec-en peker på dem.
- Denne mappa het tidligere to steder: `veikart/tilgangsstyring/oppgaver/brukeradministrasjon-fs-admin/` (menneskesiden, #143) og `tasks/grunnleggende-brukeradministrasjon/` (BAT-artefaktene, som pekte på initiativet #350). Etter sammenslåingen er #143 oppgavens issue og #350 initiativet — i tråd med regelen «én oppgave ≙ én issue».
- Subgraph-arbeidet i fs-plattform (`flow.md`, halespor) er ikke startet. Frontend er bygget mot mock-API.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-02 | Oppgave og scope slått sammen til scope.md (fra grunnleggende-brukeradministrasjon) | – | – |
| 2026-10-16 | Lagt i scope-grunnleggende-brukeradministrasjon | – | – |
| 2026-09-22 | Slått sammen med BAT-mappa `tasks/grunnleggende-brukeradministrasjon` ved overgang til felles oppgavestruktur | – | – |
| 2026-07-08 | 10 av 10 planlagte tasks implementert (`frontend/task-*-completion.md`) | – | – |
| 2026-07-08 | Analyse og plan ferdig (fs-admin) | – | – |
| 2026-07-07 | Krav hentet og spec skrevet (5 av 7 `.feature`-filer i scope) | – | – |
| 2026-04-21 | Tatt inn i veikart (prioritert) | – | – |
