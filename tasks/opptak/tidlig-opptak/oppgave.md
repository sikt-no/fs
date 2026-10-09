# Behandle søknader om tidlig opptak

## Metadata

- **Issue**: [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456)
- **Initiativ**: #456
- **Domene**: opptak (se [`../../README.md`](../../README.md#domener))
- **Slug**: tidlig-opptak (= navnet på denne mappa)
- **Fase**: utforskning
- **Prioritet**: Must
- **Type**: feature
- **Eier**: @sondre-i-sikt, @JensPeterThomassen
- **Reviewers som har sett oppgaven**: (ingen enda)
- **Lag/roller i bruk**: spec
- **Lenker**:
  - design: [design.md](design.md)
  - krav: [spec/](spec/) ([spec-tidlig-opptak.md](spec/spec-tidlig-opptak.md))
  - plan: –
  - review: –
  - PRs: –
- **Krav (Gherkin)**:
  - [`søke_om_tidlig_opptak.feature`](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature) (`@OPT-SØK-SØK-011`)
  - [`finne_søknader_om_tidlig_opptak.feature`](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/finne_s%C3%B8knader_om_tidlig_opptak.feature) (`@OPT-BEH-BEH-009`)
  - [`vurdere_søknad_om_tidlig_opptak.feature`](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vurdere_s%C3%B8knad_om_tidlig_opptak.feature) (`@OPT-BEH-BEH-013`)
  - [`gi_tilbudsgaranti_ved_tidlig_opptak.feature`](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) (`@OPT-BEH-BEH-007`)
  - [`publisere_svar_på_tidlig_opptak.feature`](../../../krav/02%20Opptak/11%20Opptak/06%20Tidlig%20opptak/publisere_svar_p%C3%A5_tidlig_opptak.feature) (`@OPT-OPT-TID-001`)
  - [`se_svar_på_tidlig_opptak.feature`](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/se_svar_p%C3%A5_tidlig_opptak.feature) (`@OPT-SØK-SØK-012`)
- **Jira**: [STEK-188](https://sikt.atlassian.net/browse/STEK-188) «Forvalte og behandle tidligopptak»

## Kort beskrivelse

Søkere kan be om tidlig opptak med en dokumentert begrunnelse, saksbehandlerne vurderer søknadene, og opptaksforvalteren gjennomfører tidligopptaket, slik at søkere med nok poeng får tilbudsgaranti før hovedopptaket. Oppgaven dekker også publisering av svaret og meldingen til søkerne, og at tilbudsgarantien gjelder i hovedopptaket.

## Statuslogg

Append-only. Ny linje på toppen ved hver faseovergang eller review.

| Dato       | Hendelse                                            | Av                                      | Lenke til review |
|------------|-----------------------------------------------------|-----------------------------------------|------------------|
| 2026-10-08 | prioritert → utforskning (uten review). `fs-specify` er kjørt, og kravene er `@in-progress` | @sondre-i-sikt | – |
| 2026-10-08 | Tatt inn i veikart (prioritert)                     | @sondre-i-sikt, @JensPeterThomassen     | –                |
