# Regelverk

## Metadata

- **Issue**: [sikt-no/fs#576](https://github.com/sikt-no/fs/issues/576)
- **Initiativ**: #216 Ferdigstilling av plasstildeling i opptak
- **Fase**: design
- **Prioritet**: Must
- **Type**: feature
- **Eier**: –
- **Reviewers som har sett oppgaven**: (ingen enda)
- **Lenker**:
  - design: [design.md](design.md) — begreper, oppgaver, gap-analyse mot kode
  - plan: –
  - review: –
  - PRs: –
  - Jira Epic: [TAKE-1](https://sikt.atlassian.net/browse/TAKE-1)
  - Confluence: [T3 2026 Forberede opptak og etterbehandling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4981817377)
  - HK-dir feedback: [TAKE-221](https://sikt.atlassian.net/browse/TAKE-221), [TAKE-235](https://sikt.atlassian.net/browse/TAKE-235), [TAKE-236](https://sikt.atlassian.net/browse/TAKE-236)
- **Krav (Gherkin)**: `krav/02 Opptak/` (skal utarbeides)

## Kort beskrivelse

Ferdigstille regelverksforvaltningen i opptak slik at Samordna opptak og enkeltlærsteder kan opprette, dele og forvalte regelverkssamlinger med kompetansekrav, rangeringsregelverk, kvoter og poengberegning — klar for første samordna opptak 2027.

## Oppgaver

| # | Oppgave                                                                       | MoSCoW | Status                                                                                                                                                                                             | Github-issue | Jira |
|---|-------------------------------------------------------------------------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|------|
| 1 | Etablere og forvalte en regelverkssamling                                     | Must   | Løst                                                                                                                                                                                               | | |
| 2 | Definere kompetansekrav                                                       | Must   | Løst                                                                                                                                                                                               | | |
| 3 | Definere hvordan søkere rangeres (poengberegning)                             | Must   | Løst — poengberegning fungerer. Restanse: fjerne poenglikhetsregel-feltet fra rangeringsregelverk (besluttet flyttet til opptak, men feltet er ikke fjernet ennå) | [#580](https://github.com/sikt-no/fs/issues/580) | [TAKE-324](https://sikt.atlassian.net/browse/TAKE-324) |
| 4 | Definere kvotetyper, grunnlag og mangelkoder                                  | Must   | Løst                                                                                                                                                                                               | | |
| 5 | Koble spesielle opptakskrav til kvoter                                        | Won't  | Ikke prioritert 2027                                                                                                                                                                               | | |
| 6 | Koble regelverket til opptak og utdanningstilbud                              | Must   | Løst                                                                                                                                                                                               | | |
| 7 | Regelverkssamling kan endres, deaktiveres og slettes                          | Must   | Løst — regelverk kan endres, deaktiveres og slettes.                                                                                                                                               | | |
| — | Avklare vitnemålskravkoder for fagbrev og svennebrev | Must | Gjenstår — oppfølgingsmøte 17. sept | [#581](https://github.com/sikt-no/fs/issues/581) | [TAKE-325](https://sikt.atlassian.net/browse/TAKE-325) |
| 8 | Varsling og begrensning ved endring, deaktivering eller sletting av regelverk | Should | Gjenstår - UX/UI er foreslått for sletting og deaktivering, regler for når endringer er lov å ikke er ikke gått opp, utover at sletting kun er lov når regelverkssamling ikke er koblet til opptak | [#582](https://github.com/sikt-no/fs/issues/582) | [TAKE-326](https://sikt.atlassian.net/browse/TAKE-326) |

## Workshop 2026-09-14: oppgavedeling og status

**Team:** Shiitake (restanser) | **Produksjonsfrist:** 1. nov 2026 (mindre rettelser til 15. nov)

**Løst:**
- Opprette kompetanseregler, rangeringsregler, kvotetyper, grunnlag og mangelkoder
- HK-dir akseptansetest regelverk 2026-09-14

**Gjenstår:**
- Fjerne poenglikhetsregel fra rangeringsreglene (skal settes på opptaket i stedet)
- Avklare vitnemålskravkoder på grunnlag og poengtype — oppfølgingsmøte 17. sept
- Ikke prioritert nå: UX-justeringer (filtreringer på GSK i kompetanseregelverk, fjerne unødvendig språkstøtte)

## Statuslogg

| Dato       | Hendelse                          | Av            | Lenke til review        |
|------------|-----------------------------------|---------------|-------------------------|
| 2026-09-15 | Workshop: oppgavedeling avklart   | @karensikt    | –                       |
| 2026-09-10 | Tatt inn i veikart (design)       | @karensikt    | –                       |
| 2026-09-10 | Gap-analyse verifisert mot kode   | –             | design.md               |
| 2026-09-10 | HK-dir-feedback innarbeidet       | –             | TAKE-221/235/236        |