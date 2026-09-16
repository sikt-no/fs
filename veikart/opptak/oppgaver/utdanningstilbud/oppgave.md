# Utdanningstilbud i opptak

## Metadata

- **Issue**: [sikt-no/fs#398](https://github.com/sikt-no/fs/issues/398)
- **Initiativ**: #216 Ferdigstilling av plasstildeling i opptak
- **Fase**: utforskning
- **Prioritet**: Must
- **Type**: feature
- **Eier**: –
- **Reviewers som har sett oppgaven**: (ingen enda)
- **Lenker**:
  - design: [design.md](design.md) — mål, retning, konfigurasjon og åpne spørsmål
  - plan: –
  - review: –
  - PRs: –
  - Jira Epic: [TAKE-3](https://sikt.atlassian.net/browse/TAKE-3)
  - Confluence: [T3 2026 Forberede opptak og etterbehandling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4981817377)
- **Krav (Gherkin)**: `krav/02 Opptak/11 Opptak/` (skal utarbeides)

## Kort beskrivelse

Sørge for at utdanninger som skal med i samordna opptak 2027 finnes i utdanningsregisteret, at endringer flyter til opptak, og at opptaksforvalter kan opprette og konfigurere utdanningstilbud med alle nødvendige innstillinger.

## Oppgaver

### Del 1: Utdanninger inn i utdanningsregisteret

Overordnet: utdanningsregisteret får utdanninger som skal med i de samordna opptakene fra universiteter, høyskoler og fagskoler (studieprogram og studieprogramkull med campus).

| # | Oppgave | MoSCoW | Status | Github-issue | Jira |
|---|---------|--------|--------|-------------|------|
| 1a | UH-ansatte kan registrere studieprogram, studieretninger og studieprogramkull i FS-SIS og få dem overført til utdanningsregisteret | Must | Delvis løst — overføring via batchjobber fungerer (fulloverføring hvert 30. min) | | |
| 1b | Fagskoleansatte kan registrere studieprogram og studieprogramkull direkte i utdanningsregisteret | Must | Snart i produksjon | | |
| 1c | UH-læresteder har tilgang til veiledning i hvordan opprette utdanninger som skal med i samordna opptak 2027 (inkl. studieretninger som skal ha opptak) | Must | | | |
| 1d | Fagskoler har tilgang til veiledning i hvordan opprette utdanninger som skal med i samordna opptak 2027 | Must | | | |

### Del 2: Endringer flyter fra SIS → ureg → opptak

| # | Oppgave | MoSCoW | Status | Github-issue | Jira |
|---|---------|--------|--------|-------------|------|
| 2a | Fange opp navneendringer på utdanninger fra SIS til ureg og videre til opptak | Must | SIS → ureg fungerer via fulloverføring. ureg → opptak under innføring | | |
| 2b | Fange opp deaktivering og reaktivering av utdanninger fra SIS til ureg og videre til opptak | Must | SIS → ureg fungerer via fulloverføring. ureg → opptak gjenstår — opptak skal få beskjed når instans blir inaktiv | | |

### Del 3: Utdanningstilbud i opptak

| # | Oppgave | MoSCoW | Status | Github-issue | Jira |
|---|---------|--------|--------|-------------|------|
| 3a | Opptak får tak i relevante utdanninger og instanser fra utdanningsregisteret | Must | | | |
| 3b | Opptaksforvalter kan legge til utdanningstilbud i opptaket (inkl. legge til flere av gangen) | Must | | | |
| 3c | Opptaksforvalter kan trekke utdanningstilbud fra opptak (trekkfrist settes av opptakseier) | Must | | | |
| 3d | Sette antall studieplasser og antall tilbud som skal gis per utdanningstilbud | Must | | | |
| 3e | Koble regelverk per utdanningstilbud | Must | Løst | | |
| 3f | Konfigurere utdanningskvoter med relativ fordeling per utdanningstilbud | Must | Delvis — absolutte kvoter finnes, relativ fordeling gjenstår | | |
| 3g | Sette plassflyt mellom utdanningskvoter | Must | Delvis — fungerer, men mangler sirkularitetsvern (ORDF→ORD→ORDF…) | | |
| 3h | Sette default-innstillinger for flere utdanningstilbud | Should | | | |
| 3i | Hvilke utdanningstilbud mangler regelverk | Must | Løst | | |

## Workshop 2026-09-14: oppgavedeling og status

**Team:** Shinkansen | **Produksjonsfrist:** 1. nov 2026 (mindre rettelser til 15. nov)

## Statuslogg

| Dato       | Hendelse                          | Av            | Lenke til review        |
|------------|-----------------------------------|---------------|-------------------------|
| 2026-09-15 | Workshop: oppgavedeling avklart   | @karensikt    | –                       |
| 2026-09-11 | Tatt inn i veikart (design)       | @karensikt    | –                       |