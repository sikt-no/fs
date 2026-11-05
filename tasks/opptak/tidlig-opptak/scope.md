# Scope: Behandle søknader om tidlig opptak

- **Slug**: tidlig-opptak (= navnet på mappa og taggen `@scope-tidlig-opptak`)
- **Domene**: opptak (se [`../../README.md`](../../README.md#domener))
- **Initiativ**: #456
- **Jira**: [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456)
- **Eier**: @sondre-i-sikt, @JensPeterThomassen
- **Fase**: utforskning
- **Prioritet**: Must
- **Type**: feature
- **Siste oppdatering**: 2026-11-05

## Mål

Søkere kan be om tidlig opptak med en dokumentert begrunnelse, saksbehandlerne vurderer søknadene, og opptaksforvalteren gjennomfører tidligopptaket, slik at søkere med nok poeng får tilbudsgaranti før hovedopptaket. Oppgaven dekker også publisering av svaret og meldingen til søkerne.

## Ikke-mål

–

## Kilder

–

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-SØK-SØK-011` [søke_om_tidlig_opptak.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature) | Must | – | [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456) | Fra spesifikasjonen |
| `@OPT-BEH-BEH-009` [finne_søknader_om_tidlig_opptak.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/finne_s%C3%B8knader_om_tidlig_opptak.feature) | Must | – | [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456) | Fra spesifikasjonen |
| `@OPT-BEH-BEH-013` [vurdere_søknad_om_tidlig_opptak.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vurdere_s%C3%B8knad_om_tidlig_opptak.feature) | Must | – | [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456) | Fra spesifikasjonen |
| `@OPT-BEH-BEH-007` [gi_tilbudsgaranti_ved_tidlig_opptak.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) | Must | – | [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456) | Fra spesifikasjonen |
| `@OPT-BEH-BEH-014` [publisere_svar_på_tidlig_opptak.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/publisere_svar_p%C3%A5_tidlig_opptak.feature) | Must | – | [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456) | Fra spesifikasjonen |
| `@OPT-SØK-SØK-012` [se_svar_på_tidlig_opptak.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/se_svar_p%C3%A5_tidlig_opptak.feature) | Must | – | [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456) | Fra spesifikasjonen |

## Åpne spørsmål

–

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-05 | Ny regel i `@OPT-BEH-BEH-007`: fjorårets median poengsum brukes når poenggrensen ikke er satt (avklart i møte 04.11.2026). Notert i spesifikasjonen, koden må endres | Daniel Sachse, @JensPeterThomassen | – |
| 2026-11-02 | Oppgave og scope slått sammen til scope.md | – | – |
| 2026-10-08 | prioritert → utforskning (uten review). `fs-specify` er kjørt, og kravene er `@in-progress` | @sondre-i-sikt | – |
| 2026-10-08 | Tatt inn i veikart (prioritert) | @sondre-i-sikt, @JensPeterThomassen | – |
