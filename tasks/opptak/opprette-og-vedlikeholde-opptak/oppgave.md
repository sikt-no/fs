# Opprette og vedlikeholde opptak

## Metadata

- **Issue**: [sikt-no/fs#211](https://github.com/sikt-no/fs/issues/211)
- **Initiativ**: #211 Opprette og vedlikeholde opptak
- **Domene**: opptak
- **Slug**: opprette-og-vedlikeholde-opptak
- **Fase**: utforskning
- **Prioritet**: Must
- **Type**: feature
- **Eier**: –
- **Reviewers som har sett oppgaven**: (ingen enda)
- **Lag/roller i bruk**: –
- **Lenker**:
  - design: [design.md](design.md) — mål, retning, innstillinger, frister, tekster og åpne spørsmål
  - plan: –
  - review: –
  - PRs: –
  - Jira Epic: [TAKE-318](https://sikt.atlassian.net/browse/TAKE-318)
  - Confluence: [T3 2026 Forberede opptak og etterbehandling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4981817377)
  - Tekstredigering: [sikt-no/fs#214](https://github.com/sikt-no/fs/issues/214)
- **Krav (Gherkin)**: `krav/02 Opptak/11 Opptak/` utarbeidet

## Kort beskrivelse

Opptaksforvalter skal kunne opprette et opptak — samordnet eller lokalt — med alle nødvendige innstillinger, frister og fellestekster, og knytte utdanningstilbud til opptaket. Opptakstype som eget konsept utgår; egenskapene til opptaket fremgår av innstillingene.

## Oppgaver

| # | Oppgave                                                              | MoSCoW     | Status                                                                                     | Github-issue | Jira |
|---|----------------------------------------------------------------------|------------|--------------------------------------------------------------------------------------------|-------------|------|
| 1 | Opprette et opptak med navn, regelverkssamling og opptakstype        | Must       | Pågår                                                                                      | [#577](https://github.com/sikt-no/fs/issues/577) | |
| 2 | Invitere læresteder til samordnet opptak                             | Must       | Pågår — synk og replika mot ureg må fikses, nytt design, begrense til hhv. fagskoler og UH | | |
| 4 | Sette innstillinger i opptaket (inkl. startnummer, maks alternativer) | Must       | Pågår                                                                                      | [#578](https://github.com/sikt-no/fs/issues/578) | [TAKE-320](https://sikt.atlassian.net/browse/TAKE-320) |
| 6 | Sette frister og hendelser for opptaket                              | Must       | Pågår                                                                                      | [#579](https://github.com/sikt-no/fs/issues/579) | [TAKE-321](https://sikt.atlassian.net/browse/TAKE-321) |
| 7 | Sette fellestekster for opptaket som blir synlig for søkere | Won't      | Informasjon utledes fra innstillinger, tekster forvaltes i repo                            | [#214](https://github.com/sikt-no/fs/issues/214) | [TAKE-322](https://sikt.atlassian.net/browse/TAKE-322) |
| 8 | Legge til utdanningstilbud i opptak (egen oppgave)              | Must       | Løses fra legge utdanningstilbud til opptak                                                | Se [utdanningstilbud](../utdanningstilbud/) | |
| 9 | Svarmeldingsmal (juridisk kjerne + parametere + valgfritt tillegg) | Won't      | Utsatt til senere iterasjon, se i sammenheng med tekstforvaltning?                         | [#214](https://github.com/sikt-no/fs/issues/214) | [TAKE-323](https://sikt.atlassian.net/browse/TAKE-323) |
| 10 | Legg til utdanningsbakgrunner for opptaket og sette avvikende frister | Must       | Velge: innstillinger.feature, frister: frister_og_hendelser.feature                        | | |
| 11 | Legg til saksbehandlertildelingsregler for samordnet opptak          | Must       | En regeltype som legges til eksplisitt på samordnet opptak                                 | | |
| 12 | Gjenbruke innstillinger fra tidligere opptak                         | Won't      | Utsatt til senere iterasjon @draft @openquestion — hva kopieres og hva kopieres ikke?      | | |
| 13 | Deaktivere opptak                                                    | Won't      | @draft — utsatt til senere iterasjon                                                       | | |
| 14 | ~~Interne saksbehandlingsfrister~~                                   | ~~Should~~ | Fjernet — saksbehandling styres av publiseringsdatoer per opptaksrunde                     | | |
| 15 | Hendelseslogg for opptak                                             | Should     | @draft — venter på generell løsning                                                        | | |

## Workshop 2026-09-14: oppgavedeling og status

**Team:** Shiitake | **Produksjonsfrist:** 1. nov 2026 (mindre rettelser til 13. nov)

**Løst:**
- Gi navn, legge til organisasjoner for samordning, legge til regelverkssamling (mangler språkstøtte og fungerende synk for organisasjoner)

**Gjenstår:**
- Gjennomgå om alle nødvendige innstillinger for samordna opptak finnes
- Sette standard poenglikhetsregel for opptaket (flyttes fra rangeringsregelverk)
- Sette rundetyper (delvis løst, trenger logikk for de ulike rundetypene)
- Lage fellestekster (må avklare behov med HK-dir — søkere har generelt ikke et forhold til hvilket opptak de deltar i)

### Harde tidsrammer

| Dato | Hendelse |
|------|----------|
| 6. okt 2026 | Simulering av opptak |
| 16. nov 2026| Hk-dir oppretter opptak|
| 16. nov 2026 | Infomøte med fagskoler om registrering |
| 19. nov 2026 | Simulering av opptak (mer funksjonalitet) |
| 5. des 2026 | Registreringsfrist for utdanninger i samordna opptak 2027 |

## Statuslogg

| Dato       | Hendelse                          | Av            | Lenke til review        |
|------------|-----------------------------------|---------------|-------------------------|
| 2026-09-15 | Workshop: oppgavedeling avklart   | @karensikt    | –                       |
| 2026-09-11 | Tatt inn i veikart (design)       | @karensikt    | –                       |