# Verifisering: krav/02 Opptak/12 Utdanningstilbud

- **Dato:** 2026-10-30 10:24
- **Krav:** `krav/02 Opptak/12 Utdanningstilbud/` (28 feature-filer)
- **Kode:** `fs-plattform` (main, e70216d1c4), `fs-admin` (main, bd9f430d0, ikke hentet fra origin), `min-kompetanse` (main, 86a284c5)
- **Omfang:** `@in-progress` og alle krav uansett status. Avhengigheter: 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll` (agent team: 4 finnere, 12 kontrollører)
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]

## Oppsummering

- Scenarioer: 89 funnet, 44 ikke funnet, 2 usikker, av 135
- Krav levert: 2. Deler levert: 1. Delvis levert: 9 krav
- Ingen `@deprecated` i scope

## Resultat per krav

| Feature-ID | Egenskap | Funnet | Endring |
| --- | --- | --- | --- |
| `@OPT-OPT-UTD-006` | Fange opp endringer fra utdanningsregisteret | 3/6 | `@draft` → `@in-progress`, 2 deler `@implemented` |
| `@OPT-OPT-UTD-005` | Hente utdanninger fra utdanningsregisteret | 4/6 | `@draft` → `@in-progress`, 4 deler `@implemented` |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud fra opptak | 6/8 | 1 ny del `@implemented` |
| `@OPT-OPT-UTD-002` | Legge til utdanningstilbud i opptak | 11/19 | 2 nye deler `@implemented` |
| `@OPT-OPT-UTD-001` | Listevisning og søk i utdanningstilbud i opptaket | 9/13 | 2 nye deler `@implemented` |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud fra opptak | 3/8 | 1 ny del `@implemented` |
| `@OPT-OPT-UTD-004` | Opptaksinnstillinger per utdanningstilbud | 13/25 | `@draft` → `@in-progress`, 8 deler `@implemented` |
| `@OPT-OPT-UTD-032` | Sette antall studieplasser per utdanningskvote | 2/2 | `@draft` → `@implemented` |
| `@OPT-OPT-UTD-008` | Sette innstillinger for flere utdanningstilbud | 1/1 | `@draft` → `@implemented` |
| `@OPT-OPT-UTD-007` | Sette antall studieplasser per utdanningstilbud | 5/6 | `@draft` → `@in-progress`, 2 deler `@implemented` |
| `@OPT-OPT-UTD-033` | Angi alternativt visningsnavn til Min kompetanse | 8/10 | `@draft` → `@in-progress`, 4 deler `@implemented` |
| `@OPT-OPT-UTD-010` | Registrere poengopplysninger for utdanningstilbudet | 3/3 | `@in-progress` fjernet fra «Se median poengsum for fjorårets opptatte» |
| `@OPT-OPT-UTD-016` | Angi beskrivelse av utdanningstilbudet til Min kompetanse | 1/2 | ingen: søkeren ser ikke beskrivelsen i Min kompetanse |
| `@OPT-OPT-UTD-017` | Angi søkeord på utdanningstilbudet | 3/4 | ingen: søket for søkere treffer ikke søkeordene |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet | 2/3 | ingen: tidlig frist sjekkes ikke mot søknadsfristen |
| `@OPT-OPT-UTD-019` | Vise endringslogg for utdanningstilbudet | 0/2 | ingen: bare skisse i fs-admin !3037 |
| `@OPT-OPT-UTD-021` | Vise lenke til tidligere utdanningstilbud | 0/2 | ingen: bare skisse i fs-admin !3037 |

Allerede levert og funnet i koden, uten endring: `@OPT-OPT-UTD-022`, -013, -015, -012, -014, -011, -009. Skjeletter uten scenarioer: `@OPT-OPT-UTD-030`, -031, -027, -029.

## Oppfølging

- **Rollen for deltakende organisasjoner:** fs-plattform krever handlingen MEDLEM_OPPTAK for å skrive, fs-admin viser knappene ut fra rollen FS-ADMIN_MODIFISERE_OPPTAK. Om rollen gir handlingen, står ikke i koden.
- **Åpen lesetilgang:** API-et gir alle utdanningstilbud til alle organisasjoner (lesepolicy `USING (true)`). Avgrensningen for deltakende organisasjoner finnes bare i fs-admin.
- **Valg uten virkning:** «vis poenggrense» og «vis ventelistenummer» for søkeren lagres, men leses ikke.
- **Frist som ikke håndheves:** fristen for poenggrenser i tidlig opptak kan settes på opptaket, men sjekkes ikke.
- **Ikke validert:** `@OPT-OPT-UTD-006`, -005, -004, -007 og -033 er nå `@in-progress`, men er ikke validert eller i en spesifikasjon. Valider med `fs-krav`, og hent inn med `fs-specify`.
- **Utdatert åpent spørsmål:** spørsmålet i `@OPT-OPT-UTD-010` «Se median poengsum …» er besvart: branchen er merget.
- **Kode i åpne MR-er:** fs-plattform !6410 (kvoteprioritet fra regelverkssamlingen), !6465 (navn på søkerens språk) og !5972 (melding til søkerne når et tilbud trekkes).
