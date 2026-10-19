# Scope: Grunnleggende brukeradministrasjon

- **Slug**: grunnleggende-brukeradministrasjon
- **Initiativ**: [#350](https://github.com/sikt-no/fs/issues/350)
- **Eier**: –
- **Siste oppdatering**: 2026-10-19

## Mål

- Fullføre det som gjenstår av v1 i `1 - Grunnleggende brukeradministrasjon`: reaktivering av deaktiverte personbrukere.

## Ikke-mål

- Restansene etter onboarding (akronym og søk i organisasjonsfiltrene, tildeling av roller): [scope-restanser-etter-onboarding](scope-restanser-etter-onboarding.md).
- Synlighet via aktiv rolle og «Gjelder for», som erstatter `@deprecated`-deler: [scope-synlighet-og-gjelder-for](scope-synlighet-og-gjelder-for.md).
- Tilganger: se, tildele og fjerne tilganger (`@BRU-PER-GRU-002`, `-009`, `-011`). Planlagt etter v1.
- Stedkoder (`@BRU-PER-GRU-005`, #483) og tidsbegrensning (`@BRU-PER-GRU-006`, #484). Utsatt til en senere versjon.
- Automatisk synkronisering av roller fra namespacet (`@BRU-PER-GRU-010`, #552). Har eget issue.
- `@draft`-delene i de leverte kravene: «Sist brukt» i listen og på detaljsiden, historikk for fjerning av roller, og de åpne scenarioene i rollevisningen.

## Kilder


- [#350](https://github.com/sikt-no/fs/issues/350) — initiativet «Brukeradministrasjon av FS Admin-brukere»
- [#504](https://github.com/sikt-no/fs/issues/504) — sub-issuet «1 - Grunnleggende brukeradministrasjon»
- [FS-Admin – Målbilde, node 4551:5331](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) — «Brukeradministrasjon v 1.0»: liste, detaljside og modalene
- [Verifisering 2026-10-14](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/verify-1%20-%20Grunnleggende%20brukeradministrasjon-2026-10-14-1544.md) — hva som gjenstår i fs-plattform og fs-admin per krav

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [grunnleggende-brukeradministrasjon](grunnleggende-brukeradministrasjon/) | `@BRU-PER-GRU-004` — Scenario: Reaktivere en deaktivert personbruker [aktivere_og_deaktivere_bruker.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/aktivere_og_deaktivere_bruker.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | – | Verify 2026-10-14: reaktiveringen nuller det som er lagret om deaktiveringen, og lagrer ikke når og av hvem den ble gjort (fs-plattform) |

## Åpne spørsmål

–
