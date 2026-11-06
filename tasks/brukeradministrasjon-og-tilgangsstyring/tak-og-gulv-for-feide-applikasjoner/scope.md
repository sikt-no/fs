# Scope: Tak og gulv for Feide-applikasjoner

- **Slug**: tak-og-gulv-for-feide-applikasjoner (= navnet på mappa og taggen `@scope-tak-og-gulv-for-feide-applikasjoner`)
- **Domene**: brukeradministrasjon-og-tilgangsstyring (se [`../../README.md`](../../README.md#domener))
- **Initiativ**: –
- **Jira**: [BAT-411](https://sikt.atlassian.net/browse/BAT-411)
- **Eier**: Team BAT (@krhoybraten-sikt)
- **Siste oppdatering**: 2026-11-04

To nye faner på applikasjonssiden for Feide-applikasjoner i FS Admin, én for taket og én for gulvet, der applikasjonsadministratoren ser, tildeler og fjerner forretningsroller.

> Utkast: tittel, mål og ikke-mål er skrevet ut fra kravene og BAT-411, og skal leses gjennom av Kjetil.

## Mål

- Applikasjonsadministratoren kan se, tildele og fjerne forretningsroller i taket til en Feide-applikasjon, per organisasjon og miljø (`@BRU-APP-API-018`).
- Applikasjonsadministratoren kan se, tildele og fjerne forretningsroller i gulvet til en Feide-applikasjon, per organisasjon og miljø (`@BRU-APP-API-019`).
- Forvaltningen krever applikasjonsadministrator-rollen både for applikasjonseieren og for organisasjonen taket eller gulvet gjelder, i samme miljø.
- Fanene viser bare tak og gulv som gjelder nå, med gyldighetstidsrommet, og tak fra organisasjonssamlinger vises med kilde.

## Ikke-mål

- Nekt.
- Endringslogg for tak og gulv.
- Å sette gyldighetsperioden. Den vises, men settes ikke, som for personbrukere og applikasjoner i dag (BRU-PER-GRU-006 er `@draft`).
- Å forvalte tak fra en organisasjonssamling. Det vises, men kan ikke tildeles eller fjernes her.
- Gulv for applikasjoner brukerne logger inn i med ID-porten.

## Kilder

- [BAT-411](https://sikt.atlassian.net/browse/BAT-411) — Jira-saken, med hovedpunktene som ble avklart 3.–4.11.2026
- [sikt-no/fs#914](https://github.com/sikt-no/fs/pull/914) — krav-PR-en, med reviewen fra Mats
- [`tilgangsstyring/docs/malarkitektur.md`](https://github.com/sikt-no/fs-plattform/blob/main/tilgangsstyring/docs/malarkitektur.md) og [`tilgangsmodell.md`](https://github.com/sikt-no/fs-plattform/blob/main/tilgangsstyring/docs/tilgangsmodell.md) i fs-plattform — tak, gulv og effektiv tilgang
- `0099-gulv-per-applikasjon.sql` i fs-plattform — gulvet per applikasjon, organisasjon og miljø (`applikasjon_brukergrunntilgang`)

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@BRU-APP-API-018` [tildele_roller_i_taket.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/03%20Iterasjon%204%20-%20Grunnleggende%20selvbetjent%20administrasjon/tildele_roller_i_taket.feature) | Must | – | [BAT-411](https://sikt.atlassian.net/browse/BAT-411) | |
| `@BRU-APP-API-019` [tildele_roller_i_gulvet.feature](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/03%20Iterasjon%204%20-%20Grunnleggende%20selvbetjent%20administrasjon/tildele_roller_i_gulvet.feature) | Must | – | [BAT-411](https://sikt.atlassian.net/browse/BAT-411) | Tilgangsstyring kan ikke skrive gulvet i dag |

## Åpne spørsmål

- [ ] Tittel, mål og ikke-mål er utkast, og skal leses gjennom av Kjetil.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-04 | Opprettet med fs-scope | @krhoybraten-sikt | [#914](https://github.com/sikt-no/fs/pull/914) |
