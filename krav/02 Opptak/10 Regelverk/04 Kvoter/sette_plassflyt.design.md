# Implementasjonsdetaljer: Sette standard plassflyt i regelverkssamlingen

**Relatert feature:** [`sette_plassflyt.feature`](./sette_plassflyt.feature)

## Overordnet UI-mønster

Standard plassflyt er den andre seksjonen i fanen «Kvoteprioritet og plassflyt» i regelverkssamlingen, under «Kvoteprioritet» (se [`sette_kvoteprioritet.design.md`](./sette_kvoteprioritet.design.md)). Seksjonen har lese- og redigeringsmodus (`DataFieldSection`), som resten av regelverkssamlingen.

## Komponenter og layout

- **Seksjonen** «Standard plassflyt» (h2), med en kort forklaring under overskriften.
- **Feltet «Hovedkvote»**: nedtrekk i redigering (påkrevd), tekst i lesevisning. Hjelpetekst under feltet.
- **Varsel** (`GuidePanel`, advarsel) når kvotetyper ikke er koblet til plassflyten, med kodene.
- **Lista «Kvotetyper»** (h3), med kolonnene Kode, Navn og Mottaker.
  - Lesevisning: Mottaker er «Hovedkvote» for hovedkvoten, «Sender ledige plasser til {kvotetype}» for en koblet kvote, eller taggen «Ikke koblet til plassflyten» (advarsel).
  - Redigering: ett nedtrekk per kvotetype, med «Ikke valgt» som første valg. Hovedkvoten har ikke noe nedtrekk. Taggen «Ikke koblet til plassflyten» vises også i redigering når mottaker ikke er valgt.
- **SPEV-kvoter** (kvotetyper med rangeringsmetoden SPEV):
  - Nedtrekket har bare hovedkvoten som valg, med hjelpeteksten under. Er hovedkvoten ikke valgt, er nedtrekket deaktivert.
  - En SPEV-kvote står ikke blant valgene i «Hovedkvote», og ikke blant mottakerne til andre kvoter.

## Interaksjonsmønstre

### Primærhandling
«Rediger» (subtle) øverst til høyre i seksjonen. I redigering: «Avbryt» (neutral) og «Lagre» (strong). Taggen «Redigerer» vises ved overskriften.

### Sekundære handlinger
Velge hovedkvote, og velge mottaker for hver kvotetype.

### Navigasjon
Fra Regelverk › Regelverksamlinger › en regelverkssamling › fanen «Kvoteprioritet og plassflyt».

### Tilgang
Som kvoteprioriteten: bare rollen `FS_ADMIN_MODIFISERE_REGELVERK` i organisasjonen som eier regelverkssamlingen, kan redigere. Andre får lesevisning med taggen «Lesevisning», og «Rediger» skjules.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Laster | `Skeleton` i seksjonen |
| Ingen kvotetyper | Tom liste med «Ingen kvotetyper funnet» |
| Hovedkvote ikke valgt | «Ikke valgt» i feltet. Lagring stoppes med feiltekst på feltet |
| Kvotetyper ikke koblet | Varselet og taggen på raden. Lagre er ikke sperret |
| Plassflyten går i ring | `Alert` med kjeden, og feiltekst på hver rad i ringen. Lagring stoppes |
| Feil ved lagring | `Alert` (kritisk) i seksjonen |
| Lagret | Snackbar |

## Tekster

Dette er fasiten for tekstene, også når en skisse viser noe annet. Feilmeldinger fra API-et vises med tekstene her, ikke med meldingen fra serveren.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Seksjonen, under overskriften | Alltid | «Bestem hvor ledige plasser går når en kvote ikke blir fylt. Hver kvote har én mottaker, men flere kvoter kan ha samme mottaker.» | – | Sette standard plassflyt i regelverkssamlingen |
| Under feltet «Hovedkvote» | Alltid | «Kvoten ledige plasser til slutt havner i.» | – | Velge hovedkvote i regelverkssamlingen |
| Feltet «Hovedkvote» og mottakerfeltet | Ikke valgt | «Ikke valgt» | – | Plassflyten kan ikke lagres uten hovedkvote |
| Feltfeil på «Hovedkvote» | Lagring uten hovedkvote | «Regelverkssamlingen må ha en hovedkvote.» | – | Plassflyten kan ikke lagres uten hovedkvote |
| Mottaker, lesevisning | Hovedkvoten | «Hovedkvote» | – | Velge hovedkvote i regelverkssamlingen |
| Mottaker, lesevisning | Koblet kvote | «Sender ledige plasser til {kvotetype}» | `{kvotetype}` = «KODE – navn» | Sette standard plassflyt i regelverkssamlingen |
| Tagg på raden | Kvotetypen er ikke koblet, i lese- og redigeringsmodus | «Ikke koblet til plassflyten» | – | Varsel om kvotetyper som ikke er koblet til plassflyten |
| Varsel øverst i seksjonen | Kvotetyper er ikke koblet | «Disse kvotetypene er ikke koblet til plassflyten: {kvotetyper}.» | `{kvotetyper}` = kodene, skilt med komma | Varsel om kvotetyper som ikke er koblet til plassflyten |
| Mottakerfeltet, skjermleser | Redigering | «Mottaker for {kode}» | – | – |
| Under mottakerfeltet for en SPEV-kvote | Redigering | «Kan bare kobles til hovedkvoten.» | – | Koble en SPEV-kvote til hovedkvoten, En SPEV-kvote kan ikke kobles til en annen kvote enn hovedkvoten |
| Alert og feltfeil på raden | API-et avviser en SPEV-kvote med en annen mottaker enn hovedkvoten | «En kvote med spesiell vurdering kan bare sende ledige plasser til hovedkvoten.» | – | En SPEV-kvote kan ikke kobles til en annen kvote enn hovedkvoten |
| Alert | Plassflyten går i ring | «Plassflyten kan ikke gå i ring: {kvotetyper}.» | `{kvotetyper}` = kjeden, f.eks. «SAM → NN → SAM». Uten kjede: «Plassflyten kan ikke gå i ring.» | Sirkulær plassflyt |
| Feltfeil på hver rad i ringen | Plassflyten går i ring | «Inngår i en ring.» | – | Sirkulær plassflyt |
| Tom liste | Ingen kvotetyper | «Ingen kvotetyper funnet» | – | – |
| Alert | Nettverksfeil eller ukjent feil | «Standard plassflyt ble ikke lagret.» | – | – |
| Snackbar | Lagret | «Standard plassflyt er lagret.» | – | Sette standard plassflyt i regelverkssamlingen |

Felles med kvoteprioriteten: taggen «Lesevisning» og feilen ved henting, se [`sette_kvoteprioritet.design.md`](./sette_kvoteprioritet.design.md).

**Skisser:** tekstene er sjekket mot utkastet i fs-admin (branchen `poc-pattern-skills`, `266400461`, `src/common/messages/nb/regelverk.json`), som er gjeldende design, og mot Figma-skissen «Kvoter» ([`screenshot.png`](../../../../tasks/opptak/kvoter-i-opptaket/spec/krav-input/sketches/figma/kvoter-gjeldende/screenshot.png)).

Avvik fra utkastet, avklart 2026-10-26:
- Forklaringen under overskriften og hjelpeteksten under «Hovedkvote» er nye, med ordene fra Figma-skissen tilpasset kravet («mottaker», ikke «mål»).
- Taggen «Ikke koblet til plassflyten» vises også i redigering.
- En SPEV-kvote kan ikke velges som hovedkvote eller som mottaker for andre kvoter.
- Feilene vises med tekstene her, ikke med meldingen fra serveren (utkastet viser `error.message` først, `PlassflytSection.tsx:173-181`).

Utdatert i Figma-skissen: innstillingen på opptaket (den er i regelverkssamlingen), og teksten «Ledige plasser i disse kvotene flyttes ikke til andre kvoter.» (feil, avklart 2026-10-19).

## Per-scenario detaljer

### Scenario: Velge hovedkvote i regelverkssamlingen
Hovedkvoten har ikke noe mottakerfelt i lista, og vises med «Hovedkvote» i mottakerkolonnen.

### Scenario: Sirkulær plassflyt
Siden hovedkvoten ikke har mottaker, kan en ring bare oppstå mellom kvoter som ikke er hovedkvote. Ringen oppdages før lagring, og API-et avviser den også.

### Regel: En SPEV-kvote kan ikke være hovedkvote eller mottaker for andre kvoter
SPEV-kvoter filtreres bort fra valgene i «Hovedkvote» og i mottakerfeltet til andre kvoter. API-et avviser det også.

## Åpne designspørsmål

Ingen.
