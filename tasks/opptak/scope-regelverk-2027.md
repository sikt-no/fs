# Scope: Regelverk 2027

- **Slug**: regelverk-2027
- **Initiativ**: [#576](https://github.com/sikt-no/fs/issues/576)
- **Eier**: –
- **Siste oppdatering**: 2026-10-14

## Mål

- Samordna opptak og enkeltlæresteder kan opprette, dele og forvalte regelverkssamlinger med kompetansekrav, rangeringsregelverk, kvoter og poengberegning.
- Klar for første samordna opptak 2027. Produksjonsfrist 1. november 2026, med mindre rettelser til 15. november.
- Levert. Kravene retrofittes: de verifiseres mot koden og blir `@implemented`, og det som mangler, står som `@draft`-deler.

## Ikke-mål

- Koble spesielle opptakskrav til kvoter (oppgave 5, Won't 2027).
- UX-justeringer som ikke er prioritert: filtrering på GSK i kompetanseregelverket og fjerning av unødvendig språkstøtte.
- Å koble regelverkssamlingen til opptaket (oppgave 6). Det står i `@OPT-OVO-INN-001` (innstillinger for opptak), i scope-opprette-opptak-2027.

## Kilder

- [GitHub #576](https://github.com/sikt-no/fs/issues/576) — initiativet «Ferdigstilling av regelverk for de samordna opptakene».
- [oppgave.md](regelverk/oppgave.md) — workshop 2026-09-14. Oppgavetabellen er flyttet hit.
- [design.md](regelverk/design.md) — begreper, oppgaver og gap-analyse mot koden.
- [Jira TAKE-1](https://sikt.atlassian.net/browse/TAKE-1) — epic. HK-dir-tilbakemeldinger i [TAKE-221](https://sikt.atlassian.net/browse/TAKE-221), [TAKE-235](https://sikt.atlassian.net/browse/TAKE-235) og [TAKE-236](https://sikt.atlassian.net/browse/TAKE-236).
- [Confluence: T3 2026 Forberede opptak og etterbehandling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4981817377) — bakgrunn.

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [regelverk](regelverk/) | `@OPT-REG-SAM-001` [regelverkssamling.feature](../../krav/02%20Opptak/10%20Regelverk/01%20Regelverkssamling/regelverkssamling.feature) | Must | – | [#576](https://github.com/sikt-no/fs/issues/576) | Oppgave 1 og 7: etablere og forvalte en regelverkssamling, og endre, deaktivere og slette den. Kode: løst. Restanse oppgave 8 (Should): varsling og begrensning ved endring, deaktivering eller sletting, [#582](https://github.com/sikt-no/fs/issues/582) |
| [regelverk](regelverk/) | `@OPT-REG-KRA-001` [kompetanseregelverk.feature](../../krav/02%20Opptak/10%20Regelverk/02%20Krav/kompetanseregelverk.feature) | Must | – | [#576](https://github.com/sikt-no/fs/issues/576) | Oppgave 2: definere kompetansekrav. Kode: løst |
| [regelverk](regelverk/) | `@OPT-REG-KRA-002` [kravelement.feature](../../krav/02%20Opptak/10%20Regelverk/02%20Krav/kravelement.feature) | Must | – | [#576](https://github.com/sikt-no/fs/issues/576) | Oppgave 2: definere kompetansekrav. Kode: løst |
| [regelverk](regelverk/) | `@OPT-REG-RAN-001` [rangeringsregelverk.feature](../../krav/02%20Opptak/10%20Regelverk/03%20Rangering/rangeringsregelverk.feature) | Must | – | [#576](https://github.com/sikt-no/fs/issues/576) | Oppgave 3: definere hvordan søkere rangeres. Kode: løst. Restanse: fjerne poenglikhetsregelen fra rangeringsregelverket, [#580](https://github.com/sikt-no/fs/issues/580), Jira [TAKE-324](https://sikt.atlassian.net/browse/TAKE-324) |
| [regelverk](regelverk/) | `@OPT-REG-RAN-002` [poengberegning.feature](../../krav/02%20Opptak/10%20Regelverk/03%20Rangering/poengberegning.feature) | Must | – | [#576](https://github.com/sikt-no/fs/issues/576) | Oppgave 3: poengberegning. Kode: løst |
| [regelverk](regelverk/) | `@OPT-REG-RAN-003` [poenglikhet.feature](../../krav/02%20Opptak/10%20Regelverk/03%20Rangering/poenglikhet.feature) | Must | – | [#580](https://github.com/sikt-no/fs/issues/580) | Oppgave 3: poenglikhet. Poenglikhetsregelen skal settes på opptaket, ikke i rangeringsregelverket (restanse #580) |
| [regelverk](regelverk/) | `@OPT-REG-KVO-001` [kvoterregelverk.feature](../../krav/02%20Opptak/10%20Regelverk/04%20Kvoter/kvoterregelverk.feature) | Must | – | [#576](https://github.com/sikt-no/fs/issues/576) | Oppgave 4: kvotetyper. Kode: løst. Verifisert 2026-10-09 (verify-kvoterregelverk-2026-10-09.md) |
| [regelverk](regelverk/) | `@OPT-REG-KVO-002` [kvotesporsmal.feature](../../krav/02%20Opptak/10%20Regelverk/04%20Kvoter/kvotesporsmal.feature) | Must | – | [#576](https://github.com/sikt-no/fs/issues/576) | Oppgave 4: kvotespørsmål. Kode: løst. Verifisert 2026-10-09 (verify-kvotesporsmal-2026-10-09.md) |
| [regelverk](regelverk/) | `@OPT-REG-GRU-001` [grunnlag.feature](../../krav/02%20Opptak/10%20Regelverk/05%20Grunnlag/grunnlag.feature) | Must | – | [#576](https://github.com/sikt-no/fs/issues/576) | Oppgave 4: grunnlag og mangelkoder. Kode: løst. Restanse: avklare vitnemålskravkoder for fagbrev og svennebrev, [#581](https://github.com/sikt-no/fs/issues/581), Jira [TAKE-325](https://sikt.atlassian.net/browse/TAKE-325) |

## Åpne spørsmål

- [ ] Restansene #580, #581 og #582: skal de bli `@draft`-deler i kravene når kravene retrofittes, eller lukkes som egne issues?
