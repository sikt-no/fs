# Implementasjonsdetaljer: Se søkerens elektroniske vitnemål

**Relatert feature:** [`vise_elektroniske_vitnemål.feature`](./vise_elektroniske_vitnemål.feature)

## Overordnet UI-mønster

Seksjonen «Vitnemålsbehandling» i steg 2 «Grunnlag» i saksbehandlingen i FS Admin, under «Grunnlag». Seksjonen kan åpnes og lukkes, og er lukket som standard. Et vitnemål kan åpnes i en egen side i ny fane («Visning av vitnemål»).

## Komponenter og layout

- **Seksjonsoverskrift:** «Vitnemålsbehandling», med en teller for antall vitnemål og «Vis»/«Skjul».
- **Tabellen «Vitnemål»:** én rad per vitnemål, med kolonnene Vitnemålsnummer, Utstedt dato, GSK, Første, KAR, REA og SPR. Vitnemålsnummeret er en lenke med ikon som åpner vitnemålet i ny fane.
- **Kolonnebredder:** kolonnen Vitnemålsnummer er bred nok til nummeret, lenkeikonet og taggen «Annullert» på én linje. GSK og Første er ikke bredere enn overskriften krever.
- **Sortering:** etter utstedt dato, fra eldste til nyeste. Et annullert vitnemål står der datoen tilsier, som de andre.
- **Visning av vitnemål (ny fane):** brødsmulesti (Hjem › Søknadsbehandling › opptaket › søknaden › Vitnemål {vitnemålsnummer}), tittel «Vitnemål {vitnemålsnummer} til {navn}», skolen, programområdene, fagene gruppert (fellesfag, valgfrie programfag) med omfang, kode, fag, standpunktkarakter, eksamenskarakter, eksamensform, år og merknader, oppsummering (sum omfang, orden, atferd, fravær), og om det er førstegangsvitnemål og utskriftsdato.

L1 har ingen valg. Radioknappene og raden «Legg inn manuelt» i skissene hører til L2 og L4 (se [`velge_vitnemål_som_grunnlag.design.md`](./velge_vitnemål_som_grunnlag.design.md)).

## Interaksjonsmønstre

### Primærhandling

Åpne seksjonen («Vis») og lese vitnemålene i tabellen.

### Sekundære handlinger

- Åpne et vitnemål i ny fane, fra vitnemålsnummeret eller fra knappen over fagene («Åpne i ny fane»).
- Lukke seksjonen («Skjul»).

### Navigasjon

Saksbehandleren kommer hit fra steg 2 «Grunnlag». Vitnemålet åpnes i en ny fane, og saksbehandlingen står åpen i den første fanen.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Lukket (standard) | Overskriften med telleren og «Vis». |
| Åpen | Tabellen «Vitnemål». |
| Laster | Lasteindikator i seksjonen. |
| Søkeren har ingen elektroniske vitnemål | Seksjonen vises ikke (se åpne designspørsmål). |
| Vitnemålene kan ikke hentes | Feilmelding i seksjonen i stedet for tabellen. Det skal ikke se ut som at søkeren ikke har vitnemål. |
| Poengberegningen svarer ikke | Tabellen vises med opplysningene fra vitnemålene. KAR, REA og SPR står tomme, og feilmeldingen står over tabellen. |
| Annullert vitnemål, brukt i en beregning | Taggen «Annullert» med varselikon etter vitnemålsnummeret. Teksten i resten av raden er grå. Poengene står fortsatt. |
| Annullert vitnemål, ikke brukt i en beregning | Raden vises ikke, og telles ikke (se åpne designspørsmål). |
| Uten leserettighet | Seksjonen vises ikke. |

## Tekster

Hjelpetekster, feilmeldinger, bekreftelser og andre tekster med variasjoner. Dette er fasiten for tekstene, også når en skisse viser noe annet.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Seksjonsoverskriften | Alltid når seksjonen vises | Telleren viser antall vitnemål, f.eks. «2» | `{antall}` | Se at søkeren har elektroniske vitnemål |
| Seksjonsoverskriften | Seksjonen er lukket / åpen | «Vis» / «Skjul» | Etter tilstand | Se at søkeren har elektroniske vitnemål |
| Knapp over fagene | Når et vitnemål er åpnet i seksjonen | «Åpne i ny fane» | – | Åpne et vitnemål i ny fane |
| Tabellen «Vitnemål», etter vitnemålsnummeret | Vitnemålet er annullert, og er brukt i en beregning på opptaket | «Annullert» (tag med varselikon) | – | Annullert vitnemål som er brukt i en beregning vises |
| I seksjonen, i stedet for tabellen | Vitnemålene kan ikke hentes fra NVB | «**Vitnemålene kunne ikke hentes.** Prøv igjen senere.» | – | Vitnemålene kan ikke hentes |
| Over tabellen «Vitnemål» | Poengberegningen feiler eller svarer ikke | «**Poengene kunne ikke beregnes.** Prøv igjen senere.» | – | Feilmelding når poengberegningen ikke svarer |

**Skisser:** Figma «FS-Admin – Gjeldende skisser», seksjonen «Nyeste skisser» ([node 5163-45344](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-45344)), lagret i [`tasks/opptak/vitnemalsbehandling/spec/krav-input/sketches/figma/gjeldende-skisser/`](../../../../tasks/opptak/vitnemalsbehandling/spec/krav-input/sketches/figma/gjeldende-skisser/): «Steg 2 Grunnlag - Behandle e-vitnemål», «Visning av vitnemål» og «annullert vitnemål». Hentet 28.10.2026.

Tekstene for feilmeldingene og «Åpne i ny fane» er avklart med designeren 28.10.2026. Det lages ikke egne skisser for feilmeldingene: tabellen over har tekstene og hvor de står.

## Per-scenario detaljer

### Scenario: Åpne et vitnemål i ny fane

Vitnemålsnummeret og knappen over fagene åpner samme side i ny fane. Skissen har teksten «Åpne i nytt vindu» på knappen. Teksten skal være «Åpne i ny fane», fordi det er en fane som åpnes.

### Scenario: Vitnemålene kan ikke hentes

Feilmeldingen står i seksjonen, med feilvarianten av varselet i SDS. Telleren i overskriften vises ikke, fordi antallet ikke er kjent.

### Scenario: Feilmelding når poengberegningen ikke svarer

Vitnemålene vises som vanlig. Bare KAR, REA og SPR står tomme. Feilmeldingen står mellom seksjonsoverskriften «Vitnemål» og tabellen, samme sted som advarselen om annullert vitnemål i L2.

### Scenario: Annullert vitnemål som er brukt i en beregning vises

Raden er grå, men lenken på vitnemålsnummeret virker, så vitnemålet kan åpnes. Poengene står, fordi de forklarer tallene i beregningen vitnemålet er brukt i.

## Åpne designspørsmål

- [ ] **Søker uten elektroniske vitnemål:** Målbildet fra 30.09 viste seksjonen lukket også når søkeren ikke har elektroniske vitnemål. Kravet sier at seksjonen ikke vises. Gjeldende skisser har ingen ramme for dette.
- [ ] **Telleren og annullerte vitnemål:** Skal telleren telle et annullert vitnemål som ikke vises?
- [ ] **Annullert vitnemål uten poeng:** Hva står i KAR, REA og SPR når poengberegningen ikke gir poeng for et annullert vitnemål? Forslag: «–».
- [ ] **Lastetilstanden** er ikke skissert.
- [ ] **Teksten «Åpne i nytt vindu»** i skissen er utdatert, og skal være «Åpne i ny fane».
