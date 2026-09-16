# Utdanningstilbud i opptak

## Metadata

- **Issue**: [sikt-no/fs#398](https://github.com/sikt-no/fs/issues/398)
- **Initiativ**: #216 Ferdigstilling av plasstildeling i opptak
- **Fase**: design
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

Opprette, konfigurere og knytte utdanningstilbud til et opptak — inkludert kapasitet, antall tilbud, antall ja-svar, regelverk, kvoter og andre innstillinger per utdanningstilbud.

## Oppgaver

| # | Oppgave | MoSCoW | Status | Github-issue | Jira |
|---|---------|--------|--------|-------------|------|
| 1 | Knytte utdanningstilbud til et opptak | Must | | | |
| 2 | Sette kapasitet, antall tilbud og antall ja-svar per utdanningstilbud | Must | | | |
| 3 | Koble regelverk per utdanningstilbud | Must | | | |
| 4 | Konfigurere utdanningskvoter med relativ fordeling per utdanningstilbud | Must | | | |
| 5 | Sette plassflyt mellom utdanningskvoter | Must | | | |
| 6 | Se utdanningstilbud fra opptakssiden | Must | | | |

## Workshop 2026-09-14: oppgavedeling og status

**Team:** Shinkansen | **Produksjonsfrist:** 1. nov 2026 (mindre rettelser til 15. nov)

**Pågår/snart i produksjon:**
- Lage utdanningsinstanser for samordna opptak 2027
- Fagskoleansatte kan registrere HYU-studieprogram i utdanningsregisteret (snart i produksjon)
- UH-ansatte registrerer i FS-SIS med overføring til utdanningsregisteret (delvis løst)

**Gjenstår:**
- Opptak får tak i relevante utdanninger og instanser fra utdanningsregisteret
- Hvilke utdanningstyper (studieprogram) og utdanningsnivåer (NKR-nivå) skal tilbys i opptaket
- Opptaksforvalter kan legge til utdanningstilbud i opptaket
- Opptaksforvalter kan trekke utdanningstilbud fra opptak (trekkfrist settes av opptakseier)
- Fange opp endringer på utdanninger i opptak (navneendringer, deaktivering/reaktivering m.m.)
- Sette opptaksspesifikke innstillinger per utdanningstilbud:
  - Kompetanseregler og rangeringsregler
  - Antall studieplasser
  - Totalt antall tilbud som skal gis
  - Antall ja-svar
  - Utdanningskvoter med relativ fordeling (standard 50/50 ORD+ORDF)
  - Plassflyt mellom utdanningskvoter (standard ORDF→ORD)
  - Unntak fra standardinnstillinger i opptak (søknadsfrist, plassflyt)

## Statuslogg

| Dato       | Hendelse                          | Av            | Lenke til review        |
|------------|-----------------------------------|---------------|-------------------------|
| 2026-09-15 | Workshop: oppgavedeling avklart   | @karensikt    | –                       |
| 2026-09-11 | Tatt inn i veikart (design)       | @karensikt    | –                       |