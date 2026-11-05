# Scope: Restanser etter onboarding av de første brukergruppene

- **Slug**: restanser-etter-onboarding (= navnet på mappa og taggen `@scope-restanser-etter-onboarding`)
- **Domene**: brukeradministrasjon-og-tilgangsstyring (se [`../../README.md`](../../README.md#domener))
- **Initiativ**: [#350](https://github.com/sikt-no/fs/issues/350)
- **Jira**: [BAT-325](https://sikt.atlassian.net/browse/BAT-325), [BAT-326](https://sikt.atlassian.net/browse/BAT-326)
- **Eier**: –
- **Siste oppdatering**: 2026-11-02

## Mål

- Rette det de første brukergruppene har meldt etter onboarding i FS Admin: akronym og søk i organisasjonsfiltrene, og tildeling av roller med forretningsroller, forhåndsvalgt hjemorganisasjon og bare roller som er i taket til en applikasjon i valgt organisasjon og miljø.
- Én oppgave per Jira-sak, så hver restanse kan løses og verifiseres for seg.
- Det som berører applikasjoner og løses i brukeradministrasjon (organisasjonsfiltrene), tas samtidig.

## Ikke-mål

- Endringer i leverte krav som erstatter `@deprecated`-deler (synlighet via aktiv rolle, «Gjelder for»): eget scope, [scope-synlighet-og-gjelder-for](../synlighet-og-gjelder-for/scope.md).
- Oppgaver som bare gjelder applikasjonskrav: eget scope, [scope-applikasjoner-etter-design-review](../applikasjoner-etter-design-review/scope.md).
- Reaktivering av personbrukere (`@BRU-PER-GRU-004`).
- Organisasjonsvalget i dialogene for å tildele og fjerne tilganger til en applikasjon (`@BRU-APP-API-007`, `-008`): kravet beskriver det koden gjør i dag.
- Tilganger for personbrukere (`@BRU-PER-GRU-002`, `-009`), som er planlagt etter v1.

## Kilder

- [#743](https://github.com/sikt-no/fs/pull/743) — krav-PR-en med restansene: akronym i organisasjonsvalg, bare forretningsroller og forhåndsvalgt hjemorganisasjon
- [Verifisering 2026-10-14](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/verify-1%20-%20Grunnleggende%20brukeradministrasjon-2026-10-14-1544.md) — hva som gjenstår i fs-plattform og fs-admin per krav
- [FS-Admin – Målbilde, node 4551:5331](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) — «Brukeradministrasjon v 1.0»
- [FS-Admin – Målbilde, node 4949:50600](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4949-50600) — «Applikasjoner v2.2»
- [#866](https://github.com/sikt-no/fs/pull/866) — krav-PR-en med regelen om at valglisten for rolle bare viser roller som er i taket til en applikasjon i valgt organisasjon og miljø

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@BRU-PER-GRU-001` — Scenario: Hjemorganisasjonene i filteret vises med akronym [søke_opp_bruker.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | [BAT-325](https://sikt.atlassian.net/browse/BAT-325) |  |
| `@BRU-PER-GRU-001` — Scenario: Søke i hjemorganisasjonsfilteret [søke_opp_bruker.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | [BAT-325](https://sikt.atlassian.net/browse/BAT-325) |  |
| `@BRU-PER-GRU-008` — Scenario: Organisasjonene i filteret vises med akronym [vise_roller.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/vise_roller.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | [BAT-325](https://sikt.atlassian.net/browse/BAT-325) |  |
| `@BRU-PER-GRU-008` — Scenario: Søke i organisasjonsfilteret [vise_roller.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/vise_roller.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | [BAT-325](https://sikt.atlassian.net/browse/BAT-325) |  |
| `@BRU-APP-API-001` — Scenario: Applikasjonseierne i filteret vises med akronym [listevisning_og_sok.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature) | Must | [Applikasjoner v2.2](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4949-50600) | [BAT-325](https://sikt.atlassian.net/browse/BAT-325) | Applikasjoner, tas samtidig |
| `@BRU-APP-API-001` — Scenario: Søke i applikasjonseier-filteret [listevisning_og_sok.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature) | Must | [Applikasjoner v2.2](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4949-50600) | [BAT-325](https://sikt.atlassian.net/browse/BAT-325) | Applikasjoner, tas samtidig |
| `@BRU-APP-API-003` — Scenario: Organisasjonene i gjelder for-filteret vises med akronym [vise_tilganger.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature) | Must | [Applikasjoner v2.2](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4949-50600) | [BAT-325](https://sikt.atlassian.net/browse/BAT-325) | Applikasjoner, tas samtidig |
| `@BRU-APP-API-003` — Scenario: Søke i gjelder for-filteret [vise_tilganger.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature) | Must | [Applikasjoner v2.2](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4949-50600) | [BAT-325](https://sikt.atlassian.net/browse/BAT-325) | Applikasjoner, tas samtidig |
| `@BRU-PER-GRU-003` [tildele_roller.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/tildele_roller.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | [BAT-326](https://sikt.atlassian.net/browse/BAT-326) | Verify 2026-10-14: 6/8, valglistene for organisasjon og rolle. Hele egenskapen er `@planned`, så hele fila er her. Regelen «Valglisten for rolle viser bare roller som er i taket til en applikasjon i valgt organisasjon og miljø» (#866) er tatt inn 2026-10-29 |

## Åpne spørsmål

- [ ] `@BRU-PER-GRU-003`: scenarioet «Tildeling av en rolle som ikke er en forretningsrolle avvises» er `@draft @openquestion` (når håndhevingen skal bygges, og om direkte tildelinger av brukerflateroller må ryddes).

## Akronym og søk i organisasjonsfiltrene (fra oppgaven organisasjonsfiltre-med-akronym)

Jira: [BAT-325](https://sikt.atlassian.net/browse/BAT-325)


Organisasjonsfiltrene i personbrukerlisten, rollevisningen, applikasjonslisten og tilgangslisten for en applikasjon viser akronymet under navnet (organisasjonskoden når akronymet mangler), og kan søkes i på navn og akronym. Meldt av de første brukergruppene etter onboarding.

## Tildele roller: forretningsroller og forhåndsvalgt hjemorganisasjon (fra oppgaven tildele-roller-forretningsroller)

Jira: [BAT-326](https://sikt.atlassian.net/browse/BAT-326)


Ved tildeling av roller til en personbruker er hjemorganisasjonen forhåndsvalgt, bare forretningsroller kan velges, og utgåtte roller vises ikke. Valglistene for organisasjon og rolle følger retten til å tildele til personbrukere. Meldt av de første brukergruppene etter onboarding.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-02 | Oppgave og scope slått sammen til scope.md (fra organisasjonsfiltre-med-akronym, tildele-roller-forretningsroller) | – | – |
| 2026-10-19 | [organisasjonsfiltre-med-akronym] Koblet til Jira-saken BAT-325 | – | – |
| 2026-10-19 | [organisasjonsfiltre-med-akronym] Opprettet i scope-restanser-etter-onboarding | – | – |
| 2026-10-19 | [tildele-roller-forretningsroller] Koblet til Jira-saken BAT-326 | – | – |
| 2026-10-19 | [tildele-roller-forretningsroller] Opprettet i scope-restanser-etter-onboarding | – | – |
