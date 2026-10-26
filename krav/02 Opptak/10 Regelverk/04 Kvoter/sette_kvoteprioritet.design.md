# Implementasjonsdetaljer: Sette kvoteprioritet i regelverkssamlingen

**Relatert feature:** [`sette_kvoteprioritet.feature`](./sette_kvoteprioritet.feature)

## Overordnet UI-mønster

Kvoteprioriteten er en seksjon i fanen «Kvoteprioritet og plassflyt» i regelverkssamlingen (Regelverk › Regelverksamlinger › `<kode>`). Fanene i regelverkssamlingen er: Kompetanseregelverk, Rangeringsregelverk, Kvotetyper, **Kvoteprioritet og plassflyt**, Grunnlag og Mangelkoder. Fanen har to seksjoner over hverandre: «Kvoteprioritet» øverst og «Standard plassflyt» under (se [`sette_plassflyt.design.md`](./sette_plassflyt.design.md)).

Siden følger mønsteret for regelverkssamlingen i fs-admin: brødsmuler, et kort øverst med kode, navn, status og eier, fanene, og seksjoner med lese- og redigeringsmodus (`DataFieldSection`).

## Komponenter og layout

- **Seksjonen** «Kvoteprioritet» (h2), med en kort forklaring under overskriften.
- **Varsel** (`GuidePanel`, advarsel) øverst i seksjonen når kvotetyper mangler kvoteprioritet.
- **Lista «Rangerte kvotetyper»** (h3), med kolonnene Prioritet, Kode og Navn. Prioriteten er 1 til antall rangerte, i rekkefølge. I redigering er lista en `OrderList` med dra-håndtak og «Flytt opp/ned», og knappen «Fjern fra rangeringen» på hver rad.
- **Lista «Uten kvoteprioritet»** (h3), med kolonnene Kode, Navn og Status. Status er taggen «Mangler kvoteprioritet» (advarsel). I redigering har hver rad knappen «Legg til i rangeringen», som legger kvotetypen nederst i rangeringen.
- Kode og navn står i hver sin kolonne.

## Interaksjonsmønstre

### Primærhandling
«Rediger» (subtle) øverst til høyre i seksjonen. I redigering: «Avbryt» (neutral) og «Lagre» (strong). Taggen «Redigerer» vises ved overskriften.

### Sekundære handlinger
- Dra en kvotetype, eller «Flytt opp/ned», for å endre rekkefølgen. Kvotetypen som mister plassen, skyves ett trinn ned.
- «Legg til i rangeringen» og «Fjern fra rangeringen».

### Navigasjon
Fra Regelverk › Regelverksamlinger › en regelverkssamling › fanen «Kvoteprioritet og plassflyt».

### Tilgang
Bare brukere med rollen `FS_ADMIN_MODIFISERE_REGELVERK` i organisasjonen som eier regelverkssamlingen, kan redigere. Andre ser seksjonen i lesevisning: «Rediger» skjules, og taggen «Lesevisning» vises i stedet (`design-patterns-for-krav.md`).

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Laster | `Skeleton` i seksjonen |
| Feil ved henting | `LayoutMessage` (kritisk) i stedet for hele siden |
| Første gang (ingen kvoteprioritet satt) | Alle kvotetypene står i «Uten kvoteprioritet». «Rangerte kvotetyper» er tom, og varselet viser antallet |
| Noen kvotetyper mangler kvoteprioritet | Varselet øverst, og taggen på hver rad. Lagre er ikke sperret |
| Alle har kvoteprioritet | «Uten kvoteprioritet» viser at alle har kvoteprioritet. Ikke noe varsel |
| Feil ved lagring | `Alert` (kritisk) i seksjonen, med teksten under |
| Lagret | Snackbar |

## Tekster

Dette er fasiten for tekstene, også når en skisse viser noe annet.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Fanen | Alltid | «Kvoteprioritet og plassflyt» | – | – |
| Seksjonen, under overskriften | Alltid | «Søkere som konkurrerer i flere kvoter på samme utdanningstilbud, får først tilbud i kvoten med høyest prioritet. 1 er høyest.» | – | Alle kvotetypene i regelverkssamlingen rangeres |
| Varsel øverst i seksjonen | Når kvotetyper mangler kvoteprioritet | «{antall} kvotetype mangler kvoteprioritet. Kvoteprioriteten kan lagres likevel.» | Entall: «1 kvotetype mangler», flertall: «{antall} kvotetyper mangler» | Varsel om kvotetyper uten kvoteprioritet, Første gang står kvotetypene uten kvoteprioritet, Ny kvotetype i regelverkssamlingen kommer inn uten kvoteprioritet |
| Tagg på raden i «Uten kvoteprioritet» | Kvotetypen mangler kvoteprioritet | «Mangler kvoteprioritet» | – | Varsel om kvotetyper uten kvoteprioritet |
| «Rangerte kvotetyper», tom | Ingen kvotetyper har kvoteprioritet | «Ingen kvotetyper har kvoteprioritet» | I redigering i tillegg: «Legg til kvotetyper fra listen «Uten kvoteprioritet».» | Første gang står kvotetypene uten kvoteprioritet |
| «Uten kvoteprioritet», tom | Alle har kvoteprioritet | «Alle kvotetypene har kvoteprioritet» | – | Sette kvoteprioritet i regelverkssamlingen |
| Knapp på rad, redigering | «Uten kvoteprioritet» | «Legg til i rangeringen» | Skjermleser: «Legg til i rangeringen: {kode}» | Sette kvoteprioritet i regelverkssamlingen |
| Knapp på rad, redigering | «Rangerte kvotetyper» | «Fjern fra rangeringen» | Skjermleser: «Fjern fra rangeringen: {kode}» | – |
| Rangeringslisten, redigering | Dra eller «Flytt opp/ned» | Skjermleser: «Flytt {kode} opp», «Flytt {kode} ned», «{kode} flyttet til posisjon {n} av {m}.» | – | Kvotetypen som mister plassen, skyves ett trinn ned |
| Alert ved lagring | To kvotetyper har samme kvoteprioritet | «To kvotetyper kan ikke ha samme kvoteprioritet.» | – | Kvotetypen som mister plassen, skyves ett trinn ned |
| Alert ved lagring | Kvoteprioriteten er ikke et helt tall fra 1 til antall kvotetyper | «Kvoteprioriteten må være et helt tall fra 1 til antall kvotetyper i regelverkssamlingen.» | – | Ugyldig kvoteprioritet |
| Alert ved lagring | Brukeren har ikke tilgang | «Du har ikke tilgang til å endre kvoteprioriteten i denne regelverkssamlingen.» | – | – |
| Alert ved lagring | Nettverksfeil eller ukjent feil | «Kunne ikke lagre Kvoteprioritet» | – | – |
| Snackbar | Lagret | «Endringer lagret i Kvoteprioritet» | – | Sette kvoteprioritet i regelverkssamlingen |
| Tagg ved overskriften | Uten redigeringstilgang | «Lesevisning» | Forklaring: «Endringer kan kun utføres av bruker med redigeringstilgang og tilhørighet til organisasjonen som opprettet innholdet» | – |
| Feil ved henting | Siden kan ikke hentes | «Kunne ikke hente kvoteprioritet og plassflyt» | Beskrivelse: «Prøv å laste siden på nytt. Hvis feilen vedvarer, ta kontakt med brukerstøtte.» | – |

**Skisser:** tekstene er sjekket mot utkastet i fs-admin (branchen `poc-pattern-skills`, `266400461`, `src/common/messages/nb/regelverk.json` og `common.json`), som er gjeldende design, og mot Figma-skissen «Kvoteprioritet» ([`screenshot.png`](../../../../tasks/opptak/kvoter-i-opptaket/spec/krav-input/sketches/figma/kvoteprioritet/screenshot.png)).

Avvik fra utkastet, avklart 2026-10-26:
- Forklaringen under overskriften er ny. Den erstatter teksten i Figma-skissen.
- Feilteksten for ugyldig kvoteprioritet sier «antall kvotetyper i regelverkssamlingen», ikke «antall rangerte kvotetyper».

Utdatert i Figma-skissen: innstillingen på opptaket (den er i regelverkssamlingen), tall som 4 og 12 (tallene er 1 til antall kvotetyper), og varselteksten «1 av 3 kvoter mangler kvoteprioritetstall».

## Per-scenario detaljer

### Scenario: Første gang står kvotetypene uten kvoteprioritet
Alle kvotetypene står i «Uten kvoteprioritet», sortert på kode, og ingen står i tilfeldig rekkefølge i rangeringen.

### Scenario: Ny kvotetype i regelverkssamlingen kommer inn uten kvoteprioritet
En ny kvotetype får aldri kvoteprioritet når den opprettes, heller ikke via API-et. Den står i «Uten kvoteprioritet» til regelverksforvalteren har lagt den til i rangeringen.

### Scenario: Kvotetypen som mister plassen, skyves ett trinn ned
Gir seg av rangeringslisten: når en kvotetype flyttes til en plass, skyves de andre ned. Det lagres som tallene 1 til antall rangerte.

### Scenariomal: Ugyldig kvoteprioritet
Skjermbildet kan ikke lage ugyldige tall. API-et avviser tall som ikke er hele tall fra 1 til antall kvotetyper i regelverkssamlingen, og to like tall.

## Åpne designspørsmål

Ingen.
