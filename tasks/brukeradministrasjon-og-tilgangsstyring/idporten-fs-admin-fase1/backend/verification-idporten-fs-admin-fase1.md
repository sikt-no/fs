# Verifikasjon: ID-porten som utsteder i coprocessoren (fase 1)

- **Dato:** 2026-09-25
- **Spec:** [spec-idporten-fs-admin-fase1.md](../spec/spec-idporten-fs-admin-fase1.md), med [spec-changes-2026-09-23-idporten-personsubjekt.md](../spec/spec-changes-2026-09-23-idporten-personsubjekt.md) og [spec-changes-2026-09-24-idporten-min-kompetanse.md](../spec/spec-changes-2026-09-24-idporten-min-kompetanse.md)
- **Autoritativ krav-kilde:** `/home/skurtveito/dev/sikt/fs/krav/07 Brukeradministrasjon og tilgangsstyring` (se *Avvik*)
- **Metode:** manuell sjekkliste (v1) — bekreftet av brukeren

## Verifikasjonsstatus: FEILET

<!-- Maskinlesbart signal. Ett av: BESTÅTT | FEILET | AVBRUTT. Ikke endre ordlyden i overskriften. -->

**Krav i scope:** 3 — bestått 0, feilet 0, ikke verifiserbar 3
**Retagging:** ingen (to retagginger fra første gjennomgang er tilbakestilt, se *Avvik*)

Ingen scenarier er meldt feilet. Hindringen er at verken FS Admin eller Min Kompetanse har en ID-porten-klient, så ingen ID-porten-innlogging kunne prøves.

## Krav

| Feature-ID | Egenskap | Gating bestått | @openquestion igjen | Retagget |
| --- | --- | --- | --- | --- |
| `@TIL-PÅL-PÅL-003` | Autentisere mot FS GraphQL API med ID-porten | 0/8 (ikke verifiserbar) | 0 | ❌ |
| `@BRU-PER-GRU-013` | Opprette person uten Feide-konto | 12/13 (1 ikke verifiserbar) | 0 | ❌ |
| `@TIL-PÅL-PÅL-004` | Autentisere personer mot FS GraphQL API med ID-porten | 0/4 (ikke verifiserbar) | 0 | ❌ |

## Evidens per krav

### `@TIL-PÅL-PÅL-003` — Autentisere mot FS GraphQL API med ID-porten

Alle scenariene forutsetter at FS Admin sender en forespørsel med et ID-porten-token. FS Admin mangler ID-porten-klient.

| # | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| 01 | Gyldig ID-porten-token godtas | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — FS Admin mangler ID-porten-klient |
| 02 | Token med ugyldig signatur eller utløpt gyldighet avvises | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — FS Admin mangler ID-porten-klient |
| 03 | Token utstedt for en annen tjeneste avvises | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — FS Admin mangler ID-porten-klient |
| 04 | Autentiseringsnivå fra ID-porten bæres i det interne tokenet (3 eksempelrader) | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — FS Admin mangler ID-porten-klient |
| 05 | Innlogget med ID-porten uten tildelte roller | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — FS Admin mangler ID-porten-klient |
| 06 | Innlogget med ID-porten med tildelte roller | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — FS Admin mangler ID-porten-klient |
| 07 | Token fra ID-portens testmiljø godtas i syntetiske datamiljøer | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — FS Admin mangler ID-porten-klient |
| 08 | Token fra ID-portens testmiljø avvises mot produksjonsdata | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — FS Admin mangler ID-porten-klient |

### `@BRU-PER-GRU-013` — Opprette person uten Feide-konto

| # | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| 01 | Registrere en ansatt som ikke finnes fra før | BESTÅTT | manuell bekreftelse (2026-09-25) |
| 02 | Registrere en ansatt som allerede er registrert | BESTÅTT | manuell bekreftelse (2026-09-25) |
| 03 | Fødselsnummeret er ikke gyldig | BESTÅTT | manuell bekreftelse (2026-09-25) |
| 04 | Rettighet for Feide-brukere gir ikke tilgang til denne flyten | BESTÅTT | manuell bekreftelse (2026-09-25) |
| 05 | Rettighet for personer uten Feide gir ikke tilgang til Feide-flyten | BESTÅTT | manuell bekreftelse (2026-09-25) |
| 06 | Tilgangen gjelder ved første innlogging | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — krever ID-porten-innlogging i FS Admin, som mangler klient |
| 07 | Navnet registreres sammen med personen | BESTÅTT | manuell bekreftelse (2026-09-25) |
| 08 | Administratoren ser personen hun har gitt tilgang | BESTÅTT | manuell bekreftelse (2026-09-25) |
| 09 | Administratoren ser tilgangene hun har gitt | BESTÅTT | manuell bekreftelse (2026-09-25) |
| 10 | En administrator i en annen organisasjon ser ikke personen | BESTÅTT | manuell bekreftelse (2026-09-25) |
| 11 | En registrering i en annen organisasjon røpes ikke | BESTÅTT | manuell bekreftelse (2026-09-25) |
| 12 | Personen mister tilgangen når tildelingen fjernes | BESTÅTT | manuell bekreftelse (2026-09-25) |
| 13 | Den ansatte beholder tilganger gitt av andre | BESTÅTT | manuell bekreftelse (2026-09-25) |

### `@TIL-PÅL-PÅL-004` — Autentisere personer mot FS GraphQL API med ID-porten

| # | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| 01 | Person får grunntilgangen via Min Kompetanse | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — kunne ikke prøves |
| 02 | Samme person får ingen organisasjonstilganger via FS Admin | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — FS Admin mangler ID-porten-klient |
| 03 | Innlogging via Min Kompetanse registrerer ikke personen | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — kunne ikke prøves |
| 04 | Token utstedt til en ukjent klient | IKKE VERIFISERBAR | manuell tilbakemelding (2026-09-25) — kunne ikke prøves |

## Retag-hovedbok

Ingen retagging står igjen. Alle tre filene har `@in-progress`.

| Fil | Før | Etter |
| --- | --- | --- |
| `fs/krav/07 …/10 Pålogging/01 Pålogging/autentisere_med_idporten.feature` | `@TIL-PÅL-PÅL-003 @must @integration @in-progress` | uendret (retagget og tilbakestilt samme dag) |
| `fs/krav/07 …/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon/opprette_person_uten_feide.feature` | `@BRU-PER-GRU-013 @must @in-progress` | uendret (retagget og tilbakestilt samme dag) |
| `fs/krav/07 …/10 Pålogging/01 Pålogging/autentisere_person_med_idporten.feature` | `@TIL-PÅL-PÅL-004 @should @integration @in-progress` | uendret |

## Avvik og observasjoner

- **Rettet etter første gjennomgang.** 003 og 013 ble først bekreftet som bestått og retagget til `@implemented`. Brukeren presiserte deretter at FS Admin mangler ID-porten-klient, så ingen ID-porten-innlogging kunne prøves. Begge er satt tilbake til `@in-progress`.
- **Blokkerende forutsetning:** ID-porten-klient for FS Admin (og for Min Kompetanse for 004). Dette henger sammen med at Sikt må registreres som klient hos Digdir (fase 0), som står som `# ÅPNE SPØRSMÅL` i kravfilene.
- **`krav_path` mangler i fs-plattforms `spec.local.md`.** Feature-ID-ene ble søkt opp under `fs/krav/07 Brukeradministrasjon og tilgangsstyring/`. `krav_path` i `flow.md` (`…/10 Pålogging`) dekker ikke `@BRU-PER-GRU-013`. Hver Feature-ID ga nøyaktig ett treff.
- **Snapshots mot autoritative filer:** Kun statustaggen skiller, så specen er ikke utdatert.
- **Alle 12 tasks i plan v2 har completion-dokument** (`task-N-completion-v2.md`).
- **Krav-repoet (`sikt-no/fs`) står på `main`.** De tre `.feature`-filene er untracked.

## Neste steg

- [ ] Skaff ID-porten-klient for FS Admin i ID-portens testmiljø (og for Min Kompetanse for 004). Kjør så `bat-verify` på nytt for 003, 004 og scenario 06 i 013.
- [ ] Ingen kode er meldt feil, så det er ikke behov for `bat-execute` nå.
