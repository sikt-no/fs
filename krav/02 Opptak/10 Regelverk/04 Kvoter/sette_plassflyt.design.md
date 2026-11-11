# Implementasjonsdetaljer: Sette standard plassflyt i regelverkssamlingen

**Relatert feature:** [`sette_plassflyt.feature`](./sette_plassflyt.feature)

## Overordnet UI-mønster

Plassflyten settes i modalen «Rediger plassflyt», som åpnes med knappen «Plassflyt» i headeren til kvotetypelista (Regelverk › Regelverksamlinger › en regelverkssamling › fanen «Kvotetyper»). Knappen står ved siden av «Kvoteprioritet» (se [`sette_kvoteprioritet.design.md`](./sette_kvoteprioritet.design.md)) og «Ny kvote». Modalen er `FSModal` (medium, kan minimeres).

Modalen henter alle kvotetypene i regelverkssamlingen, fordi API-et krever hele plassflyten ved lagring.

## Komponenter og layout

- **Forklaring** øverst i modalen.
- **Varsel** (`Alert`, kritisk) øverst i innholdet når plassflyten ikke har nøyaktig én hovedkvote, etter at brukeren har prøvd å lagre.
- **Varsel** (`GuidePanel`, advarsel) når kvotetyper ikke er koblet til plassflyten, med kodene.
- **Lista «Kvotetyper»** (`ActionList`, h2), med kolonnene Kode, Navn, Mottaker og Status.
  - Mottaker: ett nedtrekk per kvotetype, med «Ikke valgt» som første valg. Valgene viser bare koden. Hovedkvoten har også nedtrekk, med «Ikke valgt».
  - Status: høyst én tagg per rad: «Ikke med i plassflyten» (nøytral) for en kvotetype uten plasser, «Hovedkvote» (info) for kvoten en kjede ender i, eller «Ikke koblet til plassflyten» (advarsel).
  - Rekkefølgen følger den lagrede kjeden ovenfra og ned til kvoten den ender i (f.eks. SAMF → ORDF → ORD). Så kommer kvotetyper som ikke er koblet, og kvotetyper i en ring. Kvotetyper uten plasser står nederst. Radene flytter seg ikke mens brukeren velger.
- **Kvotetyper uten plasser** (som ventekvoten): «–» i Mottaker, uten nedtrekk. De står ikke blant valgene i mottakerfeltet til andre kvoter.

## Hovedkvoten

Hovedkvoten velges ikke i et eget felt. Den er kvoten kjedene ender i: den tar imot ledige plasser og sender dem ikke videre. Den vises med taggen «Hovedkvote» i Status. Plassflyten kan bare lagres med nøyaktig én hovedkvote: minst én kvote må sende til en annen, og alle kjedene må ende i samme kvote. API-et regner ut hovedkvoten på samme måte.

## Interaksjonsmønstre

### Primærhandling
«Lagre» (strong) i bunnen av modalen, ved siden av «Avbryt» (subtle). Lagre er av mens kvotetypene hentes og mens det lagres. Modalen kan ikke lukkes mens det lagres.

### Sekundære handlinger
Velge mottaker for hver kvotetype med plasser. Nedtrekket tilbyr ikke kvoter som allerede sender til kvotetypen (direkte eller via en kjede), så brukeren ikke kan lage en ring. Den lagrede mottakeren står alltid blant valgene, så en ring i lagrede data vises og stoppes ved lagring.

Er en lagret mottaker ikke lovlig lenger (en kvotetype uten plasser, eller en kvotetype som ikke er i regelverkssamlingen), eller sender en kvotetype uten plasser til en annen, starter feltet på «Ikke valgt», og verdien sendes som tom ved lagring.

### Navigasjon
Fra Regelverk › Regelverksamlinger › en regelverkssamling › fanen «Kvotetyper» › «Plassflyt».

### Tilgang
Bare rollen `FS_ADMIN_MODIFISERE_REGELVERK` i organisasjonen som eier regelverkssamlingen, ser knappen «Plassflyt». Har brukeren ikke rollen i det hele tatt, viser headeren «Du har ikke tilgang til å opprette» i stedet for knappene. Det finnes ingen lesevisning av plassflyten for andre i regelverkssamlingen. Lærestedene ser plassflyten på utdanningstilbudet (se `opptaksinnstillinger_utdanningstilbud.feature`).

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Laster | `Skeleton` i modalen, og Lagre er av |
| Feil ved henting | `Alert` (kritisk) i modalen |
| Ingen kvotetyper | Tom liste med «Ingen kvotetyper funnet» |
| Kvotetyper ikke koblet | Varselet og taggen på raden. Lagre er ikke sperret |
| Ingen hovedkvote | `Alert` øverst i innholdet. Lagring stoppes |
| Flere hovedkvoter | `Alert` øverst i innholdet, med kodene. Lagring stoppes |
| Plassflyten går i ring | `Alert` i bunnen av modalen med kjeden, og feiltekst på hver rad i ringen. Lagring stoppes. Ved ring vises ikke feilen om hovedkvoten i tillegg |
| Feil ved lagring | `Alert` (kritisk) i bunnen av modalen |
| Lagret | Snackbar, og modalen lukkes |

## Tekster

Dette er fasiten for tekstene, også når en skisse viser noe annet. Feilmeldinger fra API-et vises med tekstene her, ikke med meldingen fra serveren. Tekstene står i fs-admin, `src/common/messages/nb/regelverk.json` (`KvoteinnstillingerButtons` og `PlassflytModal`).

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Knapp i headeren til kvotetypelista | Med redigeringstilgang | «Plassflyt» | – | Sette standard plassflyt i regelverkssamlingen |
| Overskrift i modalen | Alltid | «Rediger plassflyt» | – | Sette standard plassflyt i regelverkssamlingen |
| Forklaring øverst i modalen | Alltid | «Bestem hvor ledige plasser går når en kvote ikke blir fylt. Hver kvote kan sende til én annen kvote, og flere kvoter kan sende til samme kvote. Kvoten en kjede ender i, er hovedkvoten. En kvote uten plasser er ikke med i plassflyten.» | – | Sette standard plassflyt i regelverkssamlingen |
| Mottakerfeltet | Ingen mottaker | «Ikke valgt» | – | Varsel om kvotetyper som ikke er koblet til plassflyten |
| Mottakerfeltet, skjermleser | Alltid | «Mottaker for {kode}» | – | – |
| Mottaker for en kvotetype uten plasser | Alltid | «–» | – | En kvotetype uten plasser sender ikke ledige plasser videre |
| Tagg i Status | Kvoten en kjede ender i | «Hovedkvote» | – | Velge hovedkvote i regelverkssamlingen |
| Tagg i Status | Kvotetypen er uten plasser | «Ikke med i plassflyten» | – | Ingen varsel om plassflyt for en kvotetype uten plasser |
| Tagg i Status | Kvotetypen verken sender eller tar imot ledige plasser | «Ikke koblet til plassflyten» | – | Varsel om kvotetyper som ikke er koblet til plassflyten |
| Varsel øverst i lista | Kvotetyper er ikke koblet | «Disse kvotetypene er ikke koblet til plassflyten: {kvotetyper}.» | `{kvotetyper}` = kodene, skilt med komma. Kvotetyper uten plasser er ikke med | Varsel om kvotetyper som ikke er koblet til plassflyten |
| Alert øverst i innholdet | Lagring uten hovedkvote | «Regelverkssamlingen må ha en hovedkvote. Koble minst én kvote til kvoten som skal være hovedkvote.» | – | Plassflyten kan ikke lagres uten hovedkvote |
| Alert øverst i innholdet | Lagring med flere hovedkvoter | «Plassflyten kan bare ha én hovedkvote, men kjedene ender i {kvotetyper}. Koble kvotene slik at alle kjedene ender i samme kvote.» | `{kvotetyper}` = kodene, skilt med komma | Velge hovedkvote i regelverkssamlingen |
| Alert i bunnen av modalen | Plassflyten går i ring | «Plassflyten kan ikke gå i ring: {kvotetyper}.» | `{kvotetyper}` = kjeden, f.eks. «SAM → NN → SAM» | Sirkulær plassflyt |
| Feltfeil på hver rad i ringen | Plassflyten går i ring | «Inngår i en ring.» | – | Sirkulær plassflyt |
| Tom liste | Ingen kvotetyper | «Ingen kvotetyper funnet» | – | – |
| Alert | Henting feiler | «Kunne ikke hente kvotetypene. Lukk og prøv igjen.» | – | – |
| Alert i bunnen av modalen | API-et avviser uten tilgang | «Du har ikke tilgang til å endre plassflyten i denne regelverkssamlingen.» | – | – |
| Alert i bunnen av modalen | Ugyldig input, nettverksfeil eller ukjent feil | «Standard plassflyt ble ikke lagret.» | – | – |
| Snackbar | Lagret | «Standard plassflyt er lagret.» | – | Sette standard plassflyt i regelverkssamlingen |

**Skisser:** tekstene og oppsettet er skrevet etter koden i fs-admin (branchen `maada/TAKE-468-feat-kvoteflyt`, 2026-11-11), som teamet har bestemt er fasit for designet. Figma-skissene «Kvoter» ([`screenshot.png`](../../../../tasks/opptak/kvoter-i-opptaket-2027/spec/krav-input/sketches/figma/kvoter-gjeldende/screenshot.png)) er utdatert: de viser plassflyten på opptaket, et eget felt for hovedkvoten og en fane for kvoteprioritet og plassflyt.

Endret 2026-11-11 (teamet): plassflyten er i en modal fra kvotetypelista, ikke en seksjon i fanen «Kvoteprioritet og plassflyt». Hovedkvoten er utledet og vises som tagg, ikke valgt i et eget felt. Det er ingen lesevisning.

## Per-scenario detaljer

### Scenario: Velge hovedkvote i regelverkssamlingen
Brukeren gjør en kvote til hovedkvote ved å la de andre kvotene sende ledige plasser til den, og la den selv stå på «Ikke valgt». Kvoten får taggen «Hovedkvote».

### Scenario: Plassflyten kan ikke lagres uten hovedkvote
Er ingen kvoter koblet, stoppes lagringen med feilen om hovedkvoten. Det gjelder også en regelverkssamling med bare én kvotetype.

### Scenario: Sirkulær plassflyt
Nedtrekket tilbyr ikke valg som lager en ring, så ringen kan bare komme fra lagrede data. Den oppdages før lagring, og API-et avviser den også.

### Regel: En kvotetype uten plasser er ikke med i plassflyten
Kvotetypen har ikke noe mottakerfelt, står ikke blant mottakerne til andre kvoter, kan ikke bli hovedkvote og telles ikke i varselet om kvotetyper som ikke er koblet.

## Åpne designspørsmål

- [ ] En regelverkssamling med bare én kvotetype kan ikke lagre plassflyten, fordi den ikke har noe å koble. Kravet sier ikke hva som skal skje da.
