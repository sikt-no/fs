# Figma design-kontekst — applikasjoner-visning

- **Kilde:** [Figma — FS-Admin - Målbilde, node 4265:6343](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4265-6343&m=dev)
- **Hentet:** 2026-06-16
- **Status:** v 2.1 – Grunnleggende administrasjon for intern support — "Klar til utvikling"

Designet dekker iterasjon 2.1 og er publisert som målbilde for grunnleggende administrasjon (rediger eksisterende, opprett nye, listevisning, deaktiver/aktiver, tildel/fjern tilganger).

## Frame-hierarki

Node 4265:6343 grupperer flere underframes som tilsammen viser hele applikasjonsadministrasjons-flyten:

- **4265:6344 — Listevisning for applikasjoner.** Rolle: Applikasjonsadministrator. Layout: header (72px) + breadcrumb/title + side-ved-side filter-panel (340px) og resultater-panel (1728px).
- **4265:7620 — Detaljside, Detaljer-tab.** Rolle: Applikasjonsadministrator for applikasjonens organisasjon. Lesemodus. Header + breadcrumb + nøkkelinformasjon + tabs + tab-innhold.
- **4286:7632 — Detaljside, Tilganger-tab.** Samme rolle. Nøkkelinformasjon øverst, deretter filter + tilgangsliste.
- Tilleggsmodaler synlig som thumbnails: "Deaktivere applikasjon?", "Aktivere applikasjon?", "Tildel tilganger", "Fjern tilganger".

## Listevisning — filter og tabell

Bekreftet fra screenshot av frame 4265:6344 (lagret som `frame-4265-6344-listevisning.png`).

**Filter-panel (venstre side):**

- Tittel "Filter" + "Tøm filter"-knapp øverst.
- Fritekst-søkefelt med label **"Navn"**.
- Dropdown **"Miljø"** — default-verdi: **"Alle miljøer"**.
- Dropdown **"Organisasjon"** — default-verdi: **"Alle organisasjoner"**.
- Dropdown **"Status"** — default-verdi: **"Alle statuser"**.
- Dropdownene er vist i lukket tilstand — to-delthet (organisasjoner jeg administrerer vs. eierorganisasjoner med tilganger til mine data) kan **ikke** verifiseres herfra.

**Resultatpanel:**

- Overskrift "Resultater" + treff-teller (eksempelinnhold: "57 applikasjoner i listen").
- Sorterings-dropdown "Navn" + søkefelt øverst til høyre.
- Tabell **uten header-rad** — kolonnene er kontekstuelle:
  - **Kolonne 1:** Applikasjonsnavn (lenke) + Beskrivelse + miljø-badges ("Prod", "Demo").
  - **Kolonne 2:** Organisasjon (eksempel: "NTNU", "Sikt").
  - **Kolonne 3:** Antall tilganger (eksempel: "13 tilganger", "4 tilganger").
  - **Kolonne 4:** Status-badge ("Aktiv" / "Deaktivert").
- Footer: "Last inn flere" + "Viser 20 av 57".
- "Opprett"-knapp øverst til høyre.

## Detaljside — Tilganger-tab

Bekreftet fra screenshot av frame 4286:7632 (lagret som `frame-4286-7632-tilganger-tab.png`).

**Header på detaljsiden:**

- Applikasjonsnavn (eksempel: "minapplikasjon").
- Nøkkelinformasjon: Status: "Aktiv", Miljø: ["Demo", "Prod"], Organisasjon: "Sikt", Antall tilganger: 14.
- "Deaktiver"-knapp.
- Tabs: "Detaljer" og "Tilganger" (Tilganger valgt).

**Filter-panel:**

- Tittel "Filter" + "Tøm filter".
- Fritekstfelt **"Tilgangskode"** (uten label-synlig placeholder).
- Dropdown **"Miljø"** — default: **"Alle miljøer"**.
- Dropdown **"Organisasjon"** — default: **"Alle organisasjoner"**.
- Dropdown **"Tilknytning"** — default: **"Alle tilknytninger"**.

**Resultat-panel:**

- "Resultater" + "14 tilganger i listen".
- Knapper: **"Tildel tilganger"** (+) og **"Fjern tilganger"** (−).
- Sorterings-/søkefelt: "Tilgangskode".
- Tabell uten header-rad:
  - **Kolonne 1:** Tilgangskode + miljø-badge ("Demo"/"Prod") + ev. **"Arvet"-badge** for arvede tilganger.
  - **Kolonne 2:** Beskrivelse (langt fritekstfelt).
  - **Kolonne 3:** Organisasjon (eksempel: "Universitetet i Oslo", "Universitetet i Tromsø").

## Detaljside — Detaljer-tab (kontekst)

Lagret som `frame-4265-7620-detaljer-tab.png`. Felter: Navn, Miljø (badges), Identitetsleverandør, Opprettet av, Sist endret av, Organisasjon, Beskrivelse, Ekstern ID, Tidspunkt for opprettelse, Tidspunkt for sist endring, Status, Intern ID. Ikke i scope for denne delta-en, men inkludert for fullstendighet.

## Synlighet / rolle-kontekst

- Designet er eksplisitt frame-merket med "Rolle = Applikasjonsadministrator" og "Rolle = Applikasjonsadministrator for applikasjonens organisasjon".
- Det er **ingen** synlig visuell separasjon eller egen seksjon for "applikasjoner i andre organisasjoner med tilganger til mine data" — antagelig integrert i samme liste med organisasjonskolonne, men ikke entydig vist i design-konteksten.
- Super-applikasjonsadministrator-frame er **ikke** identifisert blant de hentede underframes.

## Tekst-strings (verbatim hvor synlig)

- "v 2.1 - Grunnleggende administrasjon for intern support"
- "Status: Klar til utvikling"
- "Resultater"
- "67 elementer i listen"
- "Viser 10 av 67"
- "Last inn flere"
- "Deaktivere applikasjon?" / "Aktivere applikasjon?"
- "Tildel tilganger" / "Fjern tilganger"

## Bekreftet mot krav

- ✓ **Default-verdier på alle filtre** synlige i lukket tilstand:
  - Listevisning: "Alle miljøer", "Alle organisasjoner", "Alle statuser".
  - Tilgangs-tab: "Alle miljøer", "Alle organisasjoner", "Alle tilknytninger".
- ✓ **Tabell-kolonner i listevisning** matcher krav: Navn + Beskrivelse + miljø-badges, Organisasjon, Antall tilganger, Status.
- ✓ **Tabell-kolonner i tilgangs-tab** matcher krav: Tilgangskode (med arvet-merking), beskrivelse, organisasjon. Miljø vises som badge i tilgangskode-kolonnen, ikke som egen kolonne.
- ✓ **Arvet-merking** er visuelt synlig som "Arvet"-badge ved siden av miljø-badgen for de aktuelle radene.

## Avvik / mangler ved validering

- **To-delthet i miljø- og organisasjons-dropdown** (krav skiller mellom "organisasjoner jeg administrerer" + "organisasjoner som eier applikasjoner med tilganger til mine data") kan ikke verifiseres — dropdownene er vist i lukket tilstand. Trenger åpen-dropdown-skisse for å avklare om listen er gruppert/header-merket eller flat.
- **Synlighet-regel for tilganger** (admin for eierorg ser alt, admin for annen org ser kun tilganger til egne data): UI-en signaliserer ikke at listen er delvis. Krav-teksten sier ikke at den må gjøre det, men det er en typisk UX-overveielse — åpent spørsmål.
- **Super-applikasjonsadministrator-visning** er ikke i de hentede underframes — sannsynligvis dekket i en annen del av Målbildet enn node 4265:6343.
