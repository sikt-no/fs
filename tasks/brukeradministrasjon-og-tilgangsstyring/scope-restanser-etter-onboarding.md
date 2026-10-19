# Scope: Restanser etter onboarding av de første brukergruppene

- **Slug**: restanser-etter-onboarding
- **Initiativ**: [#350](https://github.com/sikt-no/fs/issues/350)
- **Eier**: –
- **Siste oppdatering**: 2026-10-19

## Mål

- Rette det de første brukergruppene har meldt etter onboarding i FS Admin: akronym og søk i organisasjonsfiltrene, og tildeling av roller med forretningsroller og forhåndsvalgt hjemorganisasjon.
- Én oppgave per Jira-sak, så hver restanse kan løses og verifiseres for seg.
- Det som berører applikasjoner og løses i brukeradministrasjon (organisasjonsfiltrene), tas samtidig.

## Ikke-mål

- Endringer i leverte krav som erstatter `@deprecated`-deler (synlighet via aktiv rolle, «Gjelder for»): eget scope, [scope-synlighet-og-gjelder-for](scope-synlighet-og-gjelder-for.md).
- Oppgaver som bare gjelder applikasjonskrav: eget scope, [scope-applikasjoner-etter-design-review](scope-applikasjoner-etter-design-review.md).
- Reaktivering av personbrukere (`@BRU-PER-GRU-004`): [scope-grunnleggende-brukeradministrasjon](scope-grunnleggende-brukeradministrasjon.md).
- Organisasjonsvalget i dialogene for å tildele og fjerne tilganger til en applikasjon (`@BRU-APP-API-007`, `-008`): kravet beskriver det koden gjør i dag.
- Tilganger for personbrukere (`@BRU-PER-GRU-002`, `-009`), som er planlagt etter v1.

## Kilder

- [#743](https://github.com/sikt-no/fs/pull/743) — krav-PR-en med restansene: akronym i organisasjonsvalg, bare forretningsroller og forhåndsvalgt hjemorganisasjon
- [Verifisering 2026-10-14](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/verify-1%20-%20Grunnleggende%20brukeradministrasjon-2026-10-14-1544.md) — hva som gjenstår i fs-plattform og fs-admin per krav
- [FS-Admin – Målbilde, node 4551:5331](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) — «Brukeradministrasjon v 1.0»
- [FS-Admin – Målbilde, node 4949:50600](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4949-50600) — «Applikasjoner v2.2»

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [organisasjonsfiltre-med-akronym](organisasjonsfiltre-med-akronym/) | `@BRU-PER-GRU-001` — Scenario: Hjemorganisasjonene i filteret vises med akronym [søke_opp_bruker.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | – |  |
| [organisasjonsfiltre-med-akronym](organisasjonsfiltre-med-akronym/) | `@BRU-PER-GRU-001` — Scenario: Søke i hjemorganisasjonsfilteret [søke_opp_bruker.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | – |  |
| [organisasjonsfiltre-med-akronym](organisasjonsfiltre-med-akronym/) | `@BRU-PER-GRU-008` — Scenario: Organisasjonene i filteret vises med akronym [vise_roller.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/vise_roller.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | – |  |
| [organisasjonsfiltre-med-akronym](organisasjonsfiltre-med-akronym/) | `@BRU-PER-GRU-008` — Scenario: Søke i organisasjonsfilteret [vise_roller.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/vise_roller.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | – |  |
| [organisasjonsfiltre-med-akronym](organisasjonsfiltre-med-akronym/) | `@BRU-APP-API-001` — Scenario: Applikasjonseierne i filteret vises med akronym [listevisning_og_sok.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature) | Must | [Applikasjoner v2.2](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4949-50600) | – | Applikasjoner, tas samtidig |
| [organisasjonsfiltre-med-akronym](organisasjonsfiltre-med-akronym/) | `@BRU-APP-API-001` — Scenario: Søke i applikasjonseier-filteret [listevisning_og_sok.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature) | Must | [Applikasjoner v2.2](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4949-50600) | – | Applikasjoner, tas samtidig |
| [organisasjonsfiltre-med-akronym](organisasjonsfiltre-med-akronym/) | `@BRU-APP-API-003` — Scenario: Organisasjonene i gjelder for-filteret vises med akronym [vise_tilganger.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature) | Must | [Applikasjoner v2.2](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4949-50600) | – | Applikasjoner, tas samtidig |
| [organisasjonsfiltre-med-akronym](organisasjonsfiltre-med-akronym/) | `@BRU-APP-API-003` — Scenario: Søke i gjelder for-filteret [vise_tilganger.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature) | Must | [Applikasjoner v2.2](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4949-50600) | – | Applikasjoner, tas samtidig |
| [tildele-roller-forretningsroller](tildele-roller-forretningsroller/) | `@BRU-PER-GRU-003` [tildele_roller.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/tildele_roller.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | – | Verify 2026-10-14: 6/8, valglistene for organisasjon og rolle. Hele egenskapen er `@planned`, så hele fila er her |

## Åpne spørsmål

- [ ] Jira-sak for hver av de to oppgavene.
- [ ] `@BRU-PER-GRU-003`: scenarioet «Tildeling av en rolle som ikke er en forretningsrolle avvises» er `@draft @openquestion` (når håndhevingen skal bygges, og om direkte tildelinger av brukerflateroller må ryddes).
