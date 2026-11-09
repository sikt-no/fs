# Innlogging med ID-porten i FS Admin

## Metadata

- **Issue**: [sikt-no/fs#476](https://github.com/sikt-no/fs/issues/476)
- **Initiativ**: –
- **Domene**: brukeradministrasjon-og-tilgangsstyring
- **Slug**: idporten-fs-admin-fase1
- **Scope**: –
- **Fase**: utvikling
- **Prioritet**: Must
- **Type**: feature
- **Eier**: –
- **Reviewers som har sett oppgaven**: (ingen enda)
- **Lag/roller i bruk**: spec, backend (frontend for innloggingen i FS Admin gjenstår)
- **Lenker**:
  - design: –
  - krav: [spec/spec-idporten-fs-admin-fase1.md](spec/spec-idporten-fs-admin-fase1.md)
  - analyse: [backend/analysis-idporten-fs-admin-fase1-v3.md](backend/analysis-idporten-fs-admin-fase1-v3.md)
  - plan: [backend/plan-idporten-fs-admin-fase1-v2.md](backend/plan-idporten-fs-admin-fase1-v2.md)
  - verifisering: [backend/verification-idporten-fs-admin-fase1.md](backend/verification-idporten-fs-admin-fase1.md)
  - flyt: [flow.md](flow.md)
  - avklaring om betaling og avtaler: [sikt-no/fs#514](https://github.com/sikt-no/fs/issues/514)
  - review: –
  - PRs: –
- **Krav (Gherkin)**: [`krav/07 Brukeradministrasjon og tilgangsstyring/10 Pålogging/01 Pålogging`](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/10%20P%C3%A5logging/01%20P%C3%A5logging)

## Kort beskrivelse

Saksbehandlere ved fagskoler uten Feide-konto skal kunne logge inn i FS Admin med ID-porten.

Fase 1 gjør ID-porten til en egen utsteder i coprocessoren i `fs-plattform/tilgangsstyring` (TIL-PÅL-PÅL-003 og -004). Fase 1b er innloggingen i FS Admin, der brukeren velger mellom Feide og ID-porten (TIL-PÅL-PÅL-005, utkast).

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse                                                        | Av                | Lenke til review |
|------------|-----------------------------------------------------------------|-------------------|------------------|
| 2026-10-14 | Krav for innlogging i FS Admin (TIL-PÅL-PÅL-005) skrevet som utkast | Martin Skurtveit | –                |
| 2026-10-14 | Oppgavemappa flyttet inn i tasks/-strukturen                    | Martin Skurtveit  | –                |
