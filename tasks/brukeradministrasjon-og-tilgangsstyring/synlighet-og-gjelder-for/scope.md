# Scope: Synlighet og «Gjelder for» for personbrukere

- **Slug**: synlighet-og-gjelder-for (= navnet på mappa og taggen `@scope-synlighet-og-gjelder-for`)
- **Domene**: brukeradministrasjon-og-tilgangsstyring (se [`../../README.md`](../../README.md#domener))
- **Initiativ**: [#350](https://github.com/sikt-no/fs/issues/350)
- **Jira**: [BAT-298](https://sikt.atlassian.net/browse/BAT-298), [BAT-299](https://sikt.atlassian.net/browse/BAT-299)
- **Eier**: –
- **Siste oppdatering**: 2026-11-02

## Mål

- Bygge endringene i de leverte personbrukerkravene der en `@planned`-del erstatter en `@deprecated`-del, og fjerne koden for det som erstattes.
- Synlighet for personbrukere fra andre organisasjoner bygger på aktive roller, ikke datatilgang.
- Rollevisningen viser «Gjelder for».

## Ikke-mål

- Restansene etter onboarding: [scope-restanser-etter-onboarding](../restanser-etter-onboarding/scope.md).
- Filtrene for organisasjon og miljø i rollevisningen, som tar med organisasjoner og miljøer der personbrukeren bare har tilganger (verify 2026-10-14). Det er ikke en endring i kravet.

## Kilder

- [#659](https://github.com/sikt-no/fs/pull/659) — synlighet for personbrukere fra andre organisasjoner bygger på roller
- [#667](https://github.com/sikt-no/fs/pull/667) — «Gjelder for» i stedet for «Organisasjon» på roller
- [Verifisering 2026-10-14](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/verify-1%20-%20Grunnleggende%20brukeradministrasjon-2026-10-14-1544.md) — hva som gjenstår i fs-plattform og fs-admin per krav

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@BRU-PER-GRU-001` — Scenario: Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer [søke_opp_bruker.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | – | [BAT-298](https://sikt.atlassian.net/browse/BAT-298) | Erstatter de fire `@deprecated`-scenarioene under. Verify 2026-10-14: synligheten teller også tilganger |
| `@BRU-PER-GRU-001` — Scenario: Brukeradministrator ser personbrukere med datatilgang fra egne organisasjoner [søke_opp_bruker.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | – | [BAT-298](https://sikt.atlassian.net/browse/BAT-298) | `@deprecated`: koden fjernes |
| `@BRU-PER-GRU-001` — Scenario: Personbrukere uten tilknytning til egne organisasjoner er ikke synlige [søke_opp_bruker.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | – | [BAT-298](https://sikt.atlassian.net/browse/BAT-298) | `@deprecated`: koden fjernes |
| `@BRU-PER-GRU-001` — Scenario: Personbrukere med kun inaktiv datatilgang fra egne organisasjoner er ikke synlige [søke_opp_bruker.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | – | [BAT-298](https://sikt.atlassian.net/browse/BAT-298) | `@deprecated`: koden fjernes |
| `@BRU-PER-GRU-001` — Scenario: Personbrukere med datatilgang i et miljø jeg ikke administrerer er ikke synlige [søke_opp_bruker.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | – | [BAT-298](https://sikt.atlassian.net/browse/BAT-298) | `@deprecated`: koden fjernes |
| `@BRU-PER-GRU-008` — Scenario: Se brukerens roller med «Gjelder for» [vise_roller.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/vise_roller.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | [BAT-299](https://sikt.atlassian.net/browse/BAT-299) | Erstattet «Se brukerens roller», som er slettet etter verify 2026-10-19 |

## Åpne spørsmål

–

## Synlighet for personbrukere via aktiv rolle (fra oppgaven synlighet-via-aktiv-rolle)

Jira: [BAT-298](https://sikt.atlassian.net/browse/BAT-298)


Brukeradministratoren ser personbrukere med annen hjemorganisasjon bare når de har en aktiv rolle i organisasjonene administratoren administrerer, ikke ut fra datatilgang. Koden for de fire scenarioene som erstattes (`@deprecated`), fjernes.

## «Gjelder for» i rollevisningen (fra oppgaven roller-gjelder-for)

Jira: [BAT-299](https://sikt.atlassian.net/browse/BAT-299)


Rollene til en personbruker vises med «Gjelder for» i stedet for «Organisasjon». Koden for scenarioet som erstattes (`@deprecated`), fjernes.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-02 | Oppgave og scope slått sammen til scope.md (fra synlighet-via-aktiv-rolle, roller-gjelder-for) | – | – |
| 2026-10-19 | [synlighet-via-aktiv-rolle] Koblet til Jira-saken BAT-298 | – | – |
| 2026-10-19 | [synlighet-via-aktiv-rolle] Opprettet i scope-synlighet-og-gjelder-for | – | – |
| 2026-10-19 | [roller-gjelder-for] Verifisert med fs-verify: «Gjelder for» levert, «Se brukerens roller» slettet ([verify-2026-10-19-0839.md](spec/verify-2026-10-19-0839.md)) | – | – |
| 2026-10-19 | [roller-gjelder-for] Koblet til Jira-saken BAT-299 | – | – |
| 2026-10-19 | [roller-gjelder-for] Opprettet i scope-synlighet-og-gjelder-for | – | – |
