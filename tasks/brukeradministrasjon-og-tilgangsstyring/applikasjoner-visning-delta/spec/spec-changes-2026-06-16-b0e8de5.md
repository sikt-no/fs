# Delta-spec: Presisert filtervalg og synlighet i applikasjoner-listevisning og tilgangsfane — 2026-06-16-b0e8de5

> Eksisterende krav som ikke er nevnt i denne delta-en forblir gjeldende. Endringer her erstatter eller utvider tidligere krav på de berørte områdene.

## Kilde

- **Type:** `commit`
- **Repo:** `sikt-no/fs`
- **Commit:** [`b0e8de5`](https://github.com/sikt-no/fs/commit/b0e8de588100a493abd1db8d9a74a31b6eae3daf) — "presisert filtervalg og visning i applikasjoner oversikt og tilganger"
- **Parent:** `e1fbcfcebb3a2154b727eee48723eb734a7ca1b6`
- **Hentet:** 2026-06-16

## Krav

### Endret _(diff-status: `modified`)_

- **`listevisning_og_sok.feature` — scenario `Tilgjengelige miljøer i filter`** — innholdet i miljøfilteret er presisert: filteret omfatter nå to grupper — (a) miljøer der applikasjoner i organisasjonene jeg administrerer kan tilordnes tilganger, og (b) miljøer der applikasjoner i andre organisasjoner kan tilordnes tilganger som gjelder data i organisasjonene jeg administrerer. Tidligere generell formulering "alle miljøer ... på tvers av organisasjonene brukeren har rettighet til" er erstattet.
  - Før: [krav-input/changes/2026-06-16-b0e8de5/before/krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/01 Iterasjon 2 - Support – Oversikt og passordbytte/listevisning_og_sok.feature](krav-input/changes/2026-06-16-b0e8de5/before/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature)
  - Etter: [krav-input/changes/2026-06-16-b0e8de5/krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/01 Iterasjon 2 - Support – Oversikt og passordbytte/listevisning_og_sok.feature](krav-input/changes/2026-06-16-b0e8de5/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature)

- **`listevisning_og_sok.feature` — scenario `Tilgjengelige organisasjoner i filter`** — innholdet i organisasjonsfilteret er presisert: filteret omfatter nå (a) organisasjoner jeg har applikasjonsadministrator-rollen for og (b) organisasjoner som eier applikasjoner med tilganger til data i organisasjonene jeg administrerer. Rolle-tilknytningen er gjort eksplisitt der den før var "alle organisasjoner brukeren har rettighet til".
  - Før / Etter: samme `listevisning_og_sok.feature`-filer som over.

- **`vise_tilganger.feature` — scenario `Se tilganger for en applikasjon`** — formuleringen "liste over alle tilganger applikasjonen har" er erstattet av "liste over tilganger". Endringen gjør plass for at listen kan være rolle-filtrert (se ny `Regel: Synlighet for tilganger` nedenfor) uten å være selvmotsigende.
  - Før: [krav-input/changes/2026-06-16-b0e8de5/before/krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/01 Iterasjon 2 - Support – Oversikt og passordbytte/vise_tilganger.feature](krav-input/changes/2026-06-16-b0e8de5/before/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature)
  - Etter: [krav-input/changes/2026-06-16-b0e8de5/krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/01 Iterasjon 2 - Support – Oversikt og passordbytte/vise_tilganger.feature](krav-input/changes/2026-06-16-b0e8de5/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature)

- **`vise_tilganger.feature` — scenario `Tilgjengelige miljøer i filter`** — innholdet i miljøfilteret på tilgangsfanen speiler nå "ufiltrerte tilgangsliste" i stedet for "miljøer applikasjonen kan tilordnes tilganger i". Konsekvens: filteret viser kun miljøer som faktisk er representert i listen brukeren ser, etter rolle-filtrering.
  - Før / Etter: samme `vise_tilganger.feature`-filer som over.

- **`vise_tilganger.feature` — scenario `Tilgjengelige organisasjoner i filter`** — samme prinsipp som over: organisasjonsfilteret viser organisasjoner representert i den ufiltrerte (men rolle-filtrerte) tilgangslisten, i stedet for "alle organisasjoner som kan gi applikasjonen en tilgang".
  - Før / Etter: samme `vise_tilganger.feature`-filer som over.

- **`vise_tilganger.feature` — ny `Regel: Synlighet for tilganger`** med to scenarier:
  - `Applikasjonsadministrator for organisasjonen som eier applikasjonen ser alle tilganger` — administrator for eierorganisasjonen ser hele tilgangslisten.
  - `Applikasjonsadministrator i annen organisasjon ser kun tilganger til egne data` — administrator i en annen organisasjon ser kun tilgangene som gir tilgang til data i organisasjoner vedkommende administrerer. Forklarer det nye "kontekst-avhengig liste"-prinsippet som de presiserte filtrene bygger på.
  - Før / Etter: samme `vise_tilganger.feature`-filer som over.

## Skisser

### Skisse: Applikasjoner v 2.1 — Grunnleggende administrasjon (målbilde)

- **Type:** `figma`
- **Referanse:** [Figma — FS-Admin - Målbilde, node 4265:6343](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4265-6343&m=dev)
- **Lagrede artefakter:**
  - [`sketches/figma/applikasjoner-visning/screenshot.png`](krav-input/changes/2026-06-16-b0e8de5/sketches/figma/applikasjoner-visning/screenshot.png) — oversiktsbilde av hele node 4265:6343
  - [`sketches/figma/applikasjoner-visning/frame-4265-6344-listevisning.png`](krav-input/changes/2026-06-16-b0e8de5/sketches/figma/applikasjoner-visning/frame-4265-6344-listevisning.png) — listevisning for applikasjoner
  - [`sketches/figma/applikasjoner-visning/frame-4265-7620-detaljer-tab.png`](krav-input/changes/2026-06-16-b0e8de5/sketches/figma/applikasjoner-visning/frame-4265-7620-detaljer-tab.png) — detaljside, Detaljer-tab (kontekst)
  - [`sketches/figma/applikasjoner-visning/frame-4286-7632-tilganger-tab.png`](krav-input/changes/2026-06-16-b0e8de5/sketches/figma/applikasjoner-visning/frame-4286-7632-tilganger-tab.png) — detaljside, Tilganger-tab
  - [`sketches/figma/applikasjoner-visning/design-context.md`](krav-input/changes/2026-06-16-b0e8de5/sketches/figma/applikasjoner-visning/design-context.md)
  - [`sketches/figma/applikasjoner-visning/variables.md`](krav-input/changes/2026-06-16-b0e8de5/sketches/figma/applikasjoner-visning/variables.md)
- **Dekker krav:** Alle `Endret`-bulletene over (listevisning-filtre, tilgangsfane-filtre, synlighet for tilganger).
- **Valideringsstatus:**
  - ✓ Default-verdier på alle dropdowns bekreftet ("Alle miljøer" / "Alle organisasjoner" / "Alle statuser" / "Alle tilknytninger").
  - ✓ Tabell-kolonner i listevisning og tilgangsliste samsvarer med krav.
  - ✓ "Arvet"-badge på tilgang-rader er visuelt synlig.
  - `Uavklart`: to-delthet i miljø-/organisasjons-dropdown er ikke verifiserbar — dropdowns er vist i lukket tilstand. Krever åpen-dropdown-skisse for å avklare om listen er gruppert med overskrifter eller flat.
  - `Uavklart`: synlighet-regel for tilganger (rolle-filtrert liste) gir ingen synlig UI-tilbakemelding i designet.

## Åpne spørsmål

- [x] ~~**Default-verdier i filtrene:** krav-en forutsetter "Alle miljøer", "Alle organisasjoner", "Alle statuser", "Alle tilknytninger" som standardvalg.~~ **Bekreftet** mot sub-frame-screenshots av 4265:6344 (listevisning) og 4286:7632 (tilganger-tab) — alle fire defaults synlige i lukket dropdown.
- [x] ~~**To-delthet i organisasjons- og miljøfilteret:** UI-en lister nå to grupper i krav-teksten. Skal listen i dropdown-en være visuelt gruppert eller flat?~~ **Beslutning:** flat liste, sortert alfabetisk. Brukeren ser ikke hvilken gruppe en organisasjon/miljø kommer fra. Begrunnelse: krav-teksten beskriver _hvilke_ organisasjoner/miljøer som inkluderes (kildene), ikke at de skal vises separert. Krav-scenariene sier også eksplisitt "Og organisasjonene er sortert alfabetisk" / "Og miljøene er sortert alfabetisk" — én flat alfabetisk liste er den naturlige tolkningen.
- [x] ~~**Rolle-filtrert tilgangsliste — UI-signal:** skal UI-en kommunisere at listen er filtrert pga. rolle?~~ **Beslutning:** ingen markering. Listen vises som den er. Begrunnelse: krav-teksten sier ikke at UI-en må forklare scope, og synlighet-regelen er et stille filter på serversiden. Hvis behov dukker opp under brukertest, kan markering legges til som en senere endring uten å endre kjerne-kravet.
- [x] ~~**Super-applikasjonsadministrator-visning:** finnes det en egen frame?~~ **Beslutning:** samme frame som applikasjonsadministrator (4265:6344). Forskjellen er kun hvilke applikasjoner som vises (bredere scope: alle applikasjoner uavhengig av organisasjon, inkludert de uten organisasjonstilknytning). UI-layout, filtre og kolonner er identiske.
- [x] ~~**Listevisning vs. tilgangsfane — konsistens i filter-kilde:** intendert at de bruker forskjellige prinsipper?~~ **Beslutning:** ja, intendert. To forskjellige prinsipper:
  - **Listevisning** (`listevisning_og_sok.feature`): filter-innholdet er **rolle-utledet** — miljøer og organisasjoner kommer fra hvilke applikasjoner brukerens rolle gir rett til å se (egne adm.-organisasjoner + andre organisasjoner med tilganger til brukerens data).
  - **Tilgangsfanen** (`vise_tilganger.feature`): filter-innholdet er **innhold-utledet** — miljøer og organisasjoner kommer fra _den ufiltrerte tilgangslisten_ for den aktuelle applikasjonen (som allerede er rolle-filtrert via `Regel: Synlighet for tilganger`).
  - Begge prinsippene står på egne ben og brukes på riktig nivå. Downstream må forstå skillet — dette skal noteres eksplisitt i analyse/plan.
