# Implementasjonsdetaljer: Sette kvoteprioritet i regelverkssamlingen

**Relatert feature:** [`sette_kvoteprioritet.feature`](./sette_kvoteprioritet.feature)

## Overordnet UI-mønster

Kvoteprioriteten vises i kvotetypelista (Regelverk › Regelverksamlinger › en regelverkssamling › fanen «Kvotetyper»), og settes i modalen «Ranger kvotetypene». Modalen åpnes med knappen «Kvoteprioritet» i headeren til kvotetypelista, ved siden av «Plassflyt» (se [`sette_plassflyt.design.md`](./sette_plassflyt.design.md)) og «Ny kvote». Modalen er `FSModal` (medium, kan minimeres).

Modalen henter alle kvotetypene i regelverkssamlingen, fordi en rangering må ha med alle.

## Komponenter og layout

- **Kolonnen «Kvoteprioritet»** i kvotetypelista: kvoteprioriteten som tall, eller taggen «Mangler kvoteprioritet» (advarsel). Kolonnen vises for alle som ser lista.
- **Modalen:**
  - **Forklaring** øverst.
  - **Varsel** (`GuidePanel`, advarsel) når kvotetyper mangler kvoteprioritet.
  - **Lista «Rangerte kvotetyper»** (`OrderList`, h2), med kolonnene Prioritet, Kode, Navn og Handling. Prioriteten er 1 til antall rangerte, i rekkefølge. Rekkefølgen endres med dra-håndtak eller «Flytt opp/ned». Hver rad har knappen «Fjern fra rangeringen».
  - **Lista «Uten kvoteprioritet»** (`ActionList`, h2), med kolonnene Kode, Navn, Status og Handling, sortert på kode. Status er taggen «Mangler kvoteprioritet» (advarsel). Hver rad har knappen «Legg til i rangeringen», som legger kvotetypen nederst i rangeringen.
  - Når en kvotetype flyttes mellom listene, flyttes fokus til knappen på samme kvotetype i den andre lista.

## Interaksjonsmønstre

### Primærhandling
«Lagre» (strong) i bunnen av modalen, ved siden av «Avbryt» (subtle). Lagre er av mens kvotetypene hentes og mens det lagres. Modalen kan ikke lukkes mens det lagres. Lagring sender alle kvotetypene: de rangerte med 1 til antall rangerte, de andre uten kvoteprioritet.

### Sekundære handlinger
- Dra en kvotetype, eller «Flytt opp/ned», for å endre rekkefølgen. Kvotetypen som mister plassen, skyves ett trinn ned.
- «Legg til i rangeringen» og «Fjern fra rangeringen».

### Navigasjon
Fra Regelverk › Regelverksamlinger › en regelverkssamling › fanen «Kvotetyper» › «Kvoteprioritet».

### Tilgang
Bare rollen `FS_ADMIN_MODIFISERE_REGELVERK` i organisasjonen som eier regelverkssamlingen, ser knappen «Kvoteprioritet». Har brukeren ikke rollen i det hele tatt, viser headeren «Du har ikke tilgang til å opprette» i stedet for knappene. Andre ser kvoteprioriteten i kolonnen i kvotetypelista, men ikke rangeringen i modalen.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Laster | `Skeleton` i modalen, og Lagre er av |
| Feil ved henting | `Alert` (kritisk) i modalen |
| Første gang (ingen kvoteprioritet satt) | Alle kvotetypene står i «Uten kvoteprioritet». «Rangerte kvotetyper» er tom, og varselet viser antallet |
| Noen kvotetyper mangler kvoteprioritet | Varselet i modalen, taggen på raden i modalen, og taggen i kolonnen i kvotetypelista. Lagre er ikke sperret |
| Alle har kvoteprioritet | «Uten kvoteprioritet» viser at alle har kvoteprioritet. Ikke noe varsel |
| Feil ved lagring | `Alert` (kritisk) i bunnen av modalen |
| Lagret | Snackbar, og modalen lukkes |

## Tekster

Dette er fasiten for tekstene, også når en skisse viser noe annet. Feilmeldinger fra API-et vises med tekstene her, ikke med meldingen fra serveren. Tekstene står i fs-admin, `src/common/messages/nb/regelverk.json` (`KvoteinnstillingerButtons`, `KvoteprioritetModal` og `KvotetyperResultList`) og `common.json`.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Knapp i headeren til kvotetypelista | Med redigeringstilgang | «Kvoteprioritet» | – | Alle kvotetypene i regelverkssamlingen rangeres |
| Kolonne i kvotetypelista | Alltid | «Kvoteprioritet» | Verdien er kvoteprioriteten som tall | Sette kvoteprioritet i regelverkssamlingen |
| Tagg i kolonnen i kvotetypelista | Kvotetypen mangler kvoteprioritet | «Mangler kvoteprioritet» | – | Varsel om kvotetyper uten kvoteprioritet |
| Overskrift i modalen | Alltid | «Ranger kvotetypene» | – | Alle kvotetypene i regelverkssamlingen rangeres |
| Forklaring øverst i modalen | Alltid | «Søkere som konkurrerer i flere kvoter på samme utdanningstilbud, får først tilbud i kvoten med høyest prioritet. 1 er høyest.» | – | Alle kvotetypene i regelverkssamlingen rangeres |
| Varsel øverst i modalen | Kvotetyper mangler kvoteprioritet | «{antall} kvotetype mangler kvoteprioritet. Kvoteprioriteten kan lagres likevel.» | Entall: «1 kvotetype mangler», flertall: «{antall} kvotetyper mangler» | Varsel om kvotetyper uten kvoteprioritet, Første gang står kvotetypene uten kvoteprioritet, Ny kvotetype i regelverkssamlingen kommer inn uten kvoteprioritet |
| Tagg på raden i «Uten kvoteprioritet» | Kvotetypen mangler kvoteprioritet | «Mangler kvoteprioritet» | – | Varsel om kvotetyper uten kvoteprioritet |
| «Rangerte kvotetyper», tom | Ingen kvotetyper har kvoteprioritet | «Ingen kvotetyper har kvoteprioritet» | Forslag under: «Legg til kvotetyper fra listen «Uten kvoteprioritet».» | Første gang står kvotetypene uten kvoteprioritet |
| «Uten kvoteprioritet», tom | Alle har kvoteprioritet | «Alle kvotetypene har kvoteprioritet» | – | Sette kvoteprioritet i regelverkssamlingen |
| Knapp på rad | «Uten kvoteprioritet» | «Legg til i rangeringen» | Skjermleser: «Legg til i rangeringen: {kode}» | Sette kvoteprioritet i regelverkssamlingen |
| Knapp på rad | «Rangerte kvotetyper» | «Fjern fra rangeringen» | Skjermleser: «Fjern fra rangeringen: {kode}» | – |
| Rangeringslisten | Dra eller «Flytt opp/ned» | Standardtekstene i `OrderList` | Radene har koden som navn for skjermleseren | Kvotetypen som mister plassen, skyves ett trinn ned |
| Alert | Henting feiler | «Kunne ikke hente kvotetypene. Lukk og prøv igjen.» | – | – |
| Alert i bunnen av modalen | API-et avviser uten tilgang | «Du har ikke tilgang til å endre kvoteprioriteten i denne regelverkssamlingen.» | – | – |
| Alert i bunnen av modalen | Ugyldig kvoteprioritet, nettverksfeil eller ukjent feil | «Kunne ikke lagre Kvoteprioritet» | – | Ugyldig kvoteprioritet |
| Snackbar | Lagret | «Endringer lagret i Kvoteprioritet» | – | Sette kvoteprioritet i regelverkssamlingen |

**Skisser:** tekstene og oppsettet er skrevet etter koden i fs-admin (branchen `maada/TAKE-468-feat-kvoteflyt`, 2026-11-11), som teamet har bestemt er fasit for designet. Figma-skissen «Kvoteprioritet» ([`screenshot.png`](../../../../tasks/opptak/kvoter-i-opptaket-2027/spec/krav-input/sketches/figma/kvoteprioritet/screenshot.png)) er utdatert: den viser innstillingen på opptaket, tall som 4 og 12, og varselteksten «1 av 3 kvoter mangler kvoteprioritetstall».

Endret 2026-11-11 (teamet): kvoteprioriteten er i en modal fra kvotetypelista og en kolonne i lista, ikke en seksjon i fanen «Kvoteprioritet og plassflyt». Det er ingen lesevisning av rangeringen, og ingen egne feiltekster for to like tall eller ugyldige tall.

## Per-scenario detaljer

### Scenario: Første gang står kvotetypene uten kvoteprioritet
Alle kvotetypene står i «Uten kvoteprioritet», sortert på kode, og ingen står i tilfeldig rekkefølge i rangeringen.

### Scenario: Ny kvotetype i regelverkssamlingen kommer inn uten kvoteprioritet
En ny kvotetype får aldri kvoteprioritet når den opprettes. Den står med taggen i kvotetypelista, og i «Uten kvoteprioritet» i modalen, til den er lagt til i rangeringen.

### Scenario: Kvotetypen som mister plassen, skyves ett trinn ned
Gir seg av rangeringslisten: når en kvotetype flyttes til en plass, skyves de andre ned. Det lagres som tallene 1 til antall rangerte.

### Scenariomal: Ugyldig kvoteprioritet
Skjermbildet kan ikke lage ugyldige tall. Avviser API-et kvoteprioriteten, vises den generelle feilteksten.

## Åpne designspørsmål

Ingen.

Avklart 2026-11-11 (produkteier): knappen, kolonnen og taggen i kvotetypelista heter «Kvoteprioritet», som i kravet og begrepslista. Kvoterangering er rangeringsmetoden i kvoten (se `kvoterregelverk.feature`), som i lista heter «Rangering av søkere i kvote».
