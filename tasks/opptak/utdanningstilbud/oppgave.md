# Utdanningstilbud i opptak

## Metadata

- **Issue**: [sikt-no/fs#398](https://github.com/sikt-no/fs/issues/398)
- **Initiativ**: #216 Ferdigstilling av plasstildeling i opptak
- **Domene**: opptak
- **Slug**: utdanningstilbud
- **Fase**: utforskning
- **Prioritet**: Must
- **Type**: feature
- **Eier**: –
- **Reviewers som har sett oppgaven**: (ingen enda)
- **Lag/roller i bruk**: –
- **Lenker**:
  - design: [design.md](design.md) — mål, retning, konfigurasjon og åpne spørsmål
  - plan: –
  - review: –
  - PRs: –
  - Jira Epic: [SHI-630](https://sikt.atlassian.net/browse/SHI-630) (utdanningstilbud), [SHI-629](https://sikt.atlassian.net/browse/SHI-629) (utdanninger inn i ureg)
  - Confluence: [T3 2026 Forberede opptak og etterbehandling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4981817377)
- **Krav (Gherkin)**: `krav/02 Opptak/11 Opptak/` (skal utarbeides)

## Kort beskrivelse

Sørge for at utdanninger som skal med i samordna opptak 2027 finnes i utdanningsregisteret, at endringer flyter til opptak, og at opptaksforvalter kan opprette og konfigurere utdanningstilbud med alle nødvendige innstillinger.

## Oppgaver

### Del 1: Utdanninger inn i utdanningsregisteret

Overordnet: utdanningsregisteret får utdanninger som skal med i de samordna opptakene fra universiteter, høyskoler og fagskoler (studieprogram og studieprogramkull med campus).

| # | Oppgave | MoSCoW | Status | Github-issue | Jira |
|---|---------|--------|--------|-------------|------|
| 1 | UH-ansatte kan registrere studieprogram, studieretninger og studieprogramkull i FS-SIS og få dem overført til utdanningsregisteret | Must | Løst — overføring via batchjobber fungerer (fulloverføring hvert 30. min) | | |
| 2 | Fagskoleansatte kan registrere studieprogram og studieprogramkull direkte i utdanningsregisteret | Must | Snart i produksjon | [#588](https://github.com/sikt-no/fs/issues/588) | [SHI-631](https://sikt.atlassian.net/browse/SHI-631) |
| 3 | UH-læresteder har tilgang til veiledning i hvordan opprette utdanninger som skal med i samordna opptak 2027 (inkl. studieretninger som skal ha opptak) | Must | | [#589](https://github.com/sikt-no/fs/issues/589) | [SHI-632](https://sikt.atlassian.net/browse/SHI-632) |
| 4 | Fagskoler har tilgang til veiledning i hvordan opprette utdanninger som skal med i samordna opptak 2027 | Must | | [#590](https://github.com/sikt-no/fs/issues/590) | [SHI-633](https://sikt.atlassian.net/browse/SHI-633) |

### Del 2: Endringer flyter fra SIS → ureg → opptak

| # | Oppgave | MoSCoW | Status | Github-issue | Jira |
|---|---------|--------|--------|-------------|------|
| 5 | Fange opp navneendringer på utdanninger fra ureg til opptak | Should | SIS → ureg fungerer via fulloverføring. ureg → opptak under innføring | [#591](https://github.com/sikt-no/fs/issues/591) | [SHI-634](https://sikt.atlassian.net/browse/SHI-634) |
| 6 | Fange opp deaktivering og reaktivering av utdanninger fra ureg til opptak | Should | SIS → ureg fungerer via fulloverføring. ureg → opptak gjenstår | [#592](https://github.com/sikt-no/fs/issues/592) | [SHI-635](https://sikt.atlassian.net/browse/SHI-635) |

### Del 3: Utdanningstilbud i opptak

| # | Oppgave | MoSCoW | Status | Github-issue | Jira |
|---|---------|--------|--------|-------------|------|
| 7 | Opptak får tak i relevante utdanninger og instanser fra utdanningsregisteret | Must | | [#593](https://github.com/sikt-no/fs/issues/593) | [SHI-636](https://sikt.atlassian.net/browse/SHI-636) |
| 8 | Opptaksforvalter kan legge til utdanningstilbud i opptaket (inkl. legge til flere av gangen) | Must | | [#594](https://github.com/sikt-no/fs/issues/594) | [SHI-637](https://sikt.atlassian.net/browse/SHI-637) |
| 9 | Opptaksforvalter kan trekke utdanningstilbud fra opptak (trekkfrist settes av opptakseier) | Must | | [#595](https://github.com/sikt-no/fs/issues/595) | [SHI-638](https://sikt.atlassian.net/browse/SHI-638) |
| 10 | Sette antall studieplasser og antall tilbud som skal gis per utdanningstilbud | Must | | [#596](https://github.com/sikt-no/fs/issues/596) | [SHI-639](https://sikt.atlassian.net/browse/SHI-639) |
| 11 | Koble regelverk per utdanningstilbud | Must | Løst | | |
| 12 | Konfigurere utdanningskvoter med relativ fordeling per utdanningstilbud | Must | Delvis — absolutte kvoter finnes, relativ fordeling gjenstår | [#597](https://github.com/sikt-no/fs/issues/597) | [SHI-640](https://sikt.atlassian.net/browse/SHI-640) |
| 13 | Sette plassflyt mellom utdanningskvoter | Must | Delvis — fungerer, men mangler sirkularitetsvern (ORDF→ORD→ORDF…) | [#598](https://github.com/sikt-no/fs/issues/598) | [SHI-641](https://sikt.atlassian.net/browse/SHI-641) |
| 14 | Sette default-innstillinger for flere utdanningstilbud | Should | | [#599](https://github.com/sikt-no/fs/issues/599) | [SHI-642](https://sikt.atlassian.net/browse/SHI-642) |
| 15 | Hvilke utdanningstilbud mangler regelverk | Must | Løst | | |

## Workshop 2026-09-14: oppgavedeling og status

**Team:** Shinkansen | **Produksjonsfrist:** 1. nov 2026 (mindre rettelser til 15. nov)

## Statuslogg

| Dato       | Hendelse                          | Av            | Lenke til review        |
|------------|-----------------------------------|---------------|-------------------------|
| 2026-09-15 | Workshop: oppgavedeling avklart   | @karensikt    | –                       |
| 2026-09-11 | Tatt inn i veikart (design)       | @karensikt    | –                       |