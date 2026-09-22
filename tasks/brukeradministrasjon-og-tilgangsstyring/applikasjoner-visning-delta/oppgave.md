# Applikasjoner — visning (delta-iterasjon)

## Metadata

- **Issue**: – (se åpent punkt under)
- **Initiativ**: [#31 Grunnleggende selvbetjent brukeradministrasjon for API-brukere via FS Admin](https://github.com/sikt-no/fs/issues/31)
- **Domene**: brukeradministrasjon-og-tilgangsstyring
- **Slug**: applikasjoner-visning-delta
- **Fase**: utvikling
- **Prioritet**: Should
- **Type**: feature
- **Eier**: –
- **Reviewers som har sett oppgaven**: (ingen enda)
- **Lag/roller i bruk**: spec, frontend (subgraph planlagt)
- **Lenker**:
  - design: –
  - krav: [spec/spec-changes-2026-06-16-b0e8de5.md](spec/spec-changes-2026-06-16-b0e8de5.md)
  - analyse: [frontend/analysis-applikasjoner-visning-delta.md](frontend/analysis-applikasjoner-visning-delta.md) · [frontend/analysis-graphql-schema-diff.md](frontend/analysis-graphql-schema-diff.md)
  - plan: [frontend/plan-applikasjoner-visning-delta.md](frontend/plan-applikasjoner-visning-delta.md)
  - flyt: [flow.md](flow.md)
  - review: –
  - PRs: –
- **Krav (Gherkin)**: [`krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner`](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner)

## Kort beskrivelse

Delta-iterasjon på applikasjonsvisningen i FS Admin: filterkilder hentet fra egne queries i stedet for hardkodede verdier, rolle-filter på tilgangslisten, og nye avledede felter på `Applikasjon` for organisasjoner og miljøer.

## Statuslogg

| Dato       | Hendelse                                                              | Av | Lenke til review |
|------------|-----------------------------------------------------------------------|----|------------------|
| 2026-09-22 | Flyttet inn i felles oppgavestruktur under `tasks/<domene>/`           | –  | –                |
| 2026-08-25 | Verifikasjon forsøkt, avbrutt — ingen browser-MCP tilkoblet            | –  | –                |
| 2026-07-06 | Schema-diff mock vs. supergraf analysert; blokkert av Lag A-utvidelser | –  | –                |
| 2026-06-19 | 6 av 6 planlagte tasks implementert                                   | –  | –                |
| 2026-06-16 | Delta-spec skrevet fra commit b0e8de5                                 | –  | –                |

## Åpne punkter

- **Oppgaven mangler et eget GitHub-issue.** Den peker i dag bare på initiativet #31. Regelen er «én oppgave ≙ én issue» — enten finnes det et oppgave-issue som skal settes inn over, eller så må ett opprettes. Avklares før neste faseovergang.
- Task #6 produserte et hand-off-utkast til fs-plattform (`frontend/task-6-handoff-issue-draft.md`) som ikke er sendt inn som issue enda.
