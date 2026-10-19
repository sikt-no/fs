# Scope: Synlighet og «Gjelder for» for personbrukere

- **Slug**: synlighet-og-gjelder-for
- **Initiativ**: [#350](https://github.com/sikt-no/fs/issues/350)
- **Eier**: –
- **Siste oppdatering**: 2026-10-19

## Mål

- Bygge endringene i de leverte personbrukerkravene der en `@planned`-del erstatter en `@deprecated`-del, og fjerne koden for det som erstattes.
- Synlighet for personbrukere fra andre organisasjoner bygger på aktive roller, ikke datatilgang.
- Rollevisningen viser «Gjelder for».

## Ikke-mål

- Restansene etter onboarding: [scope-restanser-etter-onboarding](scope-restanser-etter-onboarding.md).
- Filtrene for organisasjon og miljø i rollevisningen, som tar med organisasjoner og miljøer der personbrukeren bare har tilganger (verify 2026-10-14). Det er ikke en endring i kravet.

## Kilder

- [#659](https://github.com/sikt-no/fs/pull/659) — synlighet for personbrukere fra andre organisasjoner bygger på roller
- [#667](https://github.com/sikt-no/fs/pull/667) — «Gjelder for» i stedet for «Organisasjon» på roller
- [Verifisering 2026-10-14](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/verify-1%20-%20Grunnleggende%20brukeradministrasjon-2026-10-14-1544.md) — hva som gjenstår i fs-plattform og fs-admin per krav

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [synlighet-via-aktiv-rolle](synlighet-via-aktiv-rolle/) | `@BRU-PER-GRU-001` — Scenario: Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer [søke_opp_bruker.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | – | – | Erstatter de fire `@deprecated`-scenarioene under. Verify 2026-10-14: synligheten teller også tilganger |
| [synlighet-via-aktiv-rolle](synlighet-via-aktiv-rolle/) | `@BRU-PER-GRU-001` — Scenario: Brukeradministrator ser personbrukere med datatilgang fra egne organisasjoner [søke_opp_bruker.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | – | – | `@deprecated`: koden fjernes |
| [synlighet-via-aktiv-rolle](synlighet-via-aktiv-rolle/) | `@BRU-PER-GRU-001` — Scenario: Personbrukere uten tilknytning til egne organisasjoner er ikke synlige [søke_opp_bruker.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | – | – | `@deprecated`: koden fjernes |
| [synlighet-via-aktiv-rolle](synlighet-via-aktiv-rolle/) | `@BRU-PER-GRU-001` — Scenario: Personbrukere med kun inaktiv datatilgang fra egne organisasjoner er ikke synlige [søke_opp_bruker.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | – | – | `@deprecated`: koden fjernes |
| [synlighet-via-aktiv-rolle](synlighet-via-aktiv-rolle/) | `@BRU-PER-GRU-001` — Scenario: Personbrukere med datatilgang i et miljø jeg ikke administrerer er ikke synlige [søke_opp_bruker.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | Must | – | – | `@deprecated`: koden fjernes |
| [roller-gjelder-for](roller-gjelder-for/) | `@BRU-PER-GRU-008` — Scenario: Se brukerens roller med «Gjelder for» [vise_roller.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/vise_roller.feature) | Must | [Brukeradministrasjon v 1.0](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) | – | Erstatter «Se brukerens roller» |
| [roller-gjelder-for](roller-gjelder-for/) | `@BRU-PER-GRU-008` — Scenario: Se brukerens roller [vise_roller.feature](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/vise_roller.feature) | Must | – | – | `@deprecated`: kolonnen «Organisasjon» blir «Gjelder for» |

## Åpne spørsmål

- [ ] Jira-sak for hver av de to oppgavene.
