# Spec: Applikasjoner — Grunnleggende selvbetjent tilgangsstyring (iterasjon 2 + 3)

## Kilde

- **Type:** `github`
- **GitHub-kilde:**
  - **Initiativ-issue:** [#31 — Grunnleggende selvbetjent tilgangsstyring for applikasjoner via FS Admin](https://github.com/sikt-no/fs/issues/31)
  - **Sub-issues i scope (alle `@must @planned`):**
    - [#434 — Iterasjon 2: Support – Oversikt og passordbytte](https://github.com/sikt-no/fs/issues/434)
    - [#435 — Iterasjon 3: Grunnleggende tilgangsstyring for intern support](https://github.com/sikt-no/fs/issues/435)
  - **Repo / branch:** `sikt-no/fs` @ `fruitbat`
  - **Branch-SHA ved henting:** [`40f04cb39b95ba833ea25f5c4dbee54d090b691b`](https://github.com/sikt-no/fs/commit/40f04cb39b95ba833ea25f5c4dbee54d090b691b)
- **Hentet:** 2026-06-01

**Scope-regel:** Kun krav med begge tags `@must` **og** `@planned` på `Egenskap:`-linjen er i scope. Krav med `@draft` (uavhengig av prioritet) og `@could`-krav er bevisst utelatt — selv om de finnes under samme krav-mappe på branchen.

## Krav

9 `Egenskap:`-blokker er i scope, fordelt på to iterasjons-mapper. Hver bullet peker på den lagrede `.feature`-filen under `krav-input/<sha>/`.

### Iterasjon 2 — Support: Oversikt og passordbytte (sub-issue #434)

- **BRU-APP-API-001 — Listevisning og søk i applikasjoner.** Paginert liste, fritekst-søk på navn, filter på organisasjon/tilgang/status. Synlighet styres av administrasjonsrettigheter. ([listevisning_og_sok.feature](krav-input/40f04cb39b95ba833ea25f5c4dbee54d090b691b/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature))
- **BRU-APP-API-002 — Se detaljer for applikasjon.** Detaljside med grunnleggende info (navn, beskrivelse), sporingsinfo og miljøer. ([se_detaljer.feature](krav-input/40f04cb39b95ba833ea25f5c4dbee54d090b691b/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/se_detaljer.feature))
- **BRU-APP-API-003 — Vise tilganger for applikasjon.** Egen tab; liste med tilgangskode + miljø, filter/sortering/paginering. ([vise_tilganger.feature](krav-input/40f04cb39b95ba833ea25f5c4dbee54d090b691b/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature))
- **BRU-APP-API-004 — Passordbytte for applikasjon.** Systemgenerert passord (basic auth, ett aktivt om gangen). Vises skjult, kan kopieres, kan ikke hentes opp igjen etter at dialogen lukkes. ([passordbytte.feature](krav-input/40f04cb39b95ba833ea25f5c4dbee54d090b691b/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/passordbytte.feature))
- **BRU-APP-API-006 — Redigere detaljer for applikasjon.** Krever administrasjonsrettighet for applikasjonens organisasjon. ([rediger_detaljer.feature](krav-input/40f04cb39b95ba833ea25f5c4dbee54d090b691b/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/rediger_detaljer.feature))

Iterasjons-overordnet kontekst: [systemkrav.md](krav-input/40f04cb39b95ba833ea25f5c4dbee54d090b691b/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/systemkrav.md)

### Iterasjon 3 — Grunnleggende tilgangsstyring for intern support (sub-issue #435)

- **BRU-APP-API-007 — Tildele tilgang til applikasjon.** Én tilgang i ett eksplisitt valgt miljø om gangen (flere kan tildeles samtidig i samme miljø). Allerede tildelte tilganger vises gråtonet. Valgliste begrenset av administrators rettigheter. ([tildele_tilgang.feature](krav-input/40f04cb39b95ba833ea25f5c4dbee54d090b691b/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/tildele_tilgang.feature))
- **BRU-APP-API-008 — Fjerne tilgang fra applikasjon.** Bekreftelsesdialog. Flere tilganger i ett miljø kan fjernes samtidig. ([fjerne_tilgang.feature](krav-input/40f04cb39b95ba833ea25f5c4dbee54d090b691b/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/fjerne_tilgang.feature))
- **BRU-APP-API-009 — Opprette applikasjon.** Identitetsleverandør Feide eller Maskinporten velges ved opprettelse (FS utfaset; eksisterende består). Ekstern ID verifiseres mot idP-en; navn hentes fra samme oppslag. Globalt unikt visningsnavn. Intern unik ID genereres. Nyopprettet applikasjon har status «Aktiv» og ingen tilganger. ([opprette_applikasjon.feature](krav-input/40f04cb39b95ba833ea25f5c4dbee54d090b691b/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature))
- **BRU-APP-API-010 — Deaktivere applikasjon (inkl. reaktivering).** Reversibel; bekreftelsesdialog både ved deaktivering og reaktivering. Tilganger beholdes mens applikasjonen er deaktivert, men gir ikke faktisk tilgang. ([deaktivere_applikasjon.feature](krav-input/40f04cb39b95ba833ea25f5c4dbee54d090b691b/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/deaktivere_applikasjon.feature))

Iterasjons-overordnet kontekst: [systemkrav.md](krav-input/40f04cb39b95ba833ea25f5c4dbee54d090b691b/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/systemkrav.md)

## Skisser

Originaler under `docs/skisser/`, kopier lagret reproduserbart under [`krav-input/sketches/`](krav-input/sketches/). Hver skisse er sammenlignet visuelt mot scenariene i den koblede `.feature`-filen.

### Skisse: Applikasjoner – oversikt med filter

- **Type:** `lokal-bilde`
- **Referanse:** [`krav-input/sketches/Applikasjoner - oversikt med filter.png`](krav-input/sketches/Applikasjoner%20-%20oversikt%20med%20filter.png)
- **Dekker krav:** BRU-APP-API-001 (`listevisning_og_sok.feature`)
- **Valideringsstatus:** `Avvik`

**Det skissen viser:**
- Side-tittel "Applikasjoner", "Opprett"-knapp øverst til høyre (relaterer til BRU-APP-API-009 — knappen lever på samme side).
- Filter-sidebar (venstre) med "Tøm filter"-lenke og fire filtre: **Navn** (fritekst-input), **Miljø** (Select, default "Alle miljøer"), **Organisasjon** (Select, default "Alle organisasjoner"), **Status** (Select, default "Alle statuser").
- Resultatliste (høyre) med header "Resultater · 87 applikasjoner i alt", sortering "Navn" øverst til høyre.
- Hver rad viser: applikasjonsnavn, statustags (Prod/Demo), beskrivelse, NTNU(?), antall tilganger, status (Aktiv/Deaktivert), chevron-/lenke-ikon.
- "Last inn flere"-knapp nederst, paginering-tekst (uleselig).

**Match mot scenario-tekstene:**
| Scenario-krav | I skissen | Kommentar |
|---|---|---|
| Felter på rad: Navn, Beskrivelse, Miljøer, Organisasjon, Antall tilganger, Status | Delvis | Navn, Beskrivelse, Antall tilganger, Status synlige. **Miljø** vises som tags ved siden av navnet (Prod/Demo) — OK. **Organisasjon** kolonnen vises som "NTNU" på flere rader — OK. |
| Sortering stigende/synkende på navn | "Navn"-velger øverst til høyre | OK |
| "Last inn flere" + totalt antall treff + antall lastet | "Last inn flere"-knapp + paginering nederst | OK (paginering-tekst antas korrekt) |
| Filter: miljø, organisasjon, status — med "Alle ..."-default | Tre Select-filtre vist med "Alle ..." labels | OK |
| Filter: fritekst på navn | "Navn"-input i filter-sidebar | OK |
| **Filter: tilgang** (`@must`-scenario "Tilgjengelige statuser i filter" finnes ikke — men "Filtrere på tilgang" er `@could`) | **Ikke i skissen** | **OK** — tilgang-filteret er `@could`-merket i krav-filen (linje 98–102), så å utelate det er konsistent med scope. |
| Navigere til detaljside ved valg av applikasjon | Chevron/lenke-ikon på høyre side av hver rad | OK |
| Visning av FS-applikasjoner på lik linje | Ikke synlig i skisse-data | Uavklart — krever ikke distinkt visuell merking. |

**Avvik:** **Ingen** skisse-avvik mot scope-krav i `.feature`-filen — alle `@must`-scenarier er reflektert. Skissen viser en "Opprett"-knapp som tilhører BRU-APP-API-009 (riktig plassering — knappen ligger over filter-listen).

**Korrigering:** Statusen oppgraderes fra `Avvik` til `OK` etter denne gjennomgangen — den var preliminært "Avvik" fordi jeg lette etter et tilgang-filter, men det er `@could` og bevisst utelatt.

- **Valideringsstatus (endelig):** `OK`

### Skisse: Applikasjon-detaljer – tab for detaljer (lese-modus)

- **Type:** `lokal-bilde`
- **Referanse:** [`krav-input/sketches/Applikasjon detaljer - tab for detaljer.png`](krav-input/sketches/Applikasjon%20detaljer%20-%20tab%20for%20detaljer.png)
- **Dekker krav:** BRU-APP-API-002 (`se_detaljer.feature`) — lese-modus + BRU-APP-API-010 (Deaktiver-knappen i topbar)
- **Valideringsstatus:** `OK`

**Det skissen viser:**
- Brødsmulesti: `Hjem / Tilgangsstyring / Applikasjoner / Applikasjon`.
- H1: "minapplikasjon".
- Topbar med statuspille (Status: Aktiv, Miljø: Demo/Prod, Organisasjon: Sikt, Antall tilganger: 14), samt "Deaktiver"-knapp helt til høyre.
- To tabs: "Detaljer" (valgt, med bok-ikon) og "Tilganger" (med nøkkel-ikon).
- Detaljer-panel med "Rediger"-knapp øverst til høyre.
- Felter i 5 kolonner: **Navn**, **Beskrivelse**, **Organisasjon**, **Opprettet av**, **Sist endret av** (rad 1). **Status**, **(tom)**, **Identitetsleverandør**, **Tidspunkt for opprettelse**, **(tom)** (rad 2). **Miljø**, **(tom)**, **(tom)**, **Tidspunkt for sist endring**, **(tom)** (rad 3).

**Match mot scenario-tekstene:**
| Scenario-krav | I skissen | Kommentar |
|---|---|---|
| Se navn og beskrivelse | Navn + Beskrivelse-felt | OK |
| Se identitetsleverandør | Identitetsleverandør: Feide | OK |
| Se organisasjon | Organisasjon: Sikt | OK (vises både i topbar og i detaljer-panel) |
| Se sporingsinfo (opprettet av/tidspunkt, endret av/tidspunkt) | 4 felter for sporing | OK |
| Se miljøer | Miljø: Demo/Prod | OK |
| Se status (Aktiv/Deaktivert) | Status: Aktiv | OK |
| Aktivere redigering | "Rediger"-knapp øverst i Detaljer-panelet | OK |

**Avvik:** Ingen.

### Skisse: Applikasjon-detaljer – tab for detaljer, modus for redigering

- **Type:** `lokal-bilde`
- **Referanse:** [`krav-input/sketches/ Applikasjon detaljer - tab for detaljer - modus for redigering.png`](krav-input/sketches/%20Applikasjon%20detaljer%20-%20tab%20for%20detaljer%20-%20modus%20for%20redigering.png)
- **Dekker krav:** BRU-APP-API-006 (`rediger_detaljer.feature`)
- **Valideringsstatus:** `OK`

**Det skissen viser:**
- Samme topbar + brødsmulesti som lese-modus.
- "Rediger"-knappen er erstattet av "Avbryt" og "Lagre".
- **Navn** og **Beskrivelse** er omgjort til inputfelter (Beskrivelse til textarea).
- Alle andre felter (Organisasjon, Identitetsleverandør, sporingsinfo, Status, Miljø) er fortsatt ren tekst — ikke redigerbare.

**Match mot scenario-tekstene:**
| Scenario-krav | I skissen | Kommentar |
|---|---|---|
| Aktivere redigering omgjør **redigerbare** felter til input | Navn + Beskrivelse → input/textarea; resten uendret | OK — konsistent med kravet om at kun navn og beskrivelse er redigerbare. |
| Oppdatere navn (rettighetsbasert) | Navn-input | OK (rettighetskontroll ikke synlig i skissen, men antatt på samme felt) |
| Oppdatere beskrivelse (rettighetsbasert) | Beskrivelse-textarea | OK |
| Lagring avvises ved tomt navn | Ikke synlig i skissen | Uavklart — feilmelding-stil for tomt navn er ikke designet i skissen. Antar standard fs-admin input-error pattern. |
| Forkast ulagrede endringer ved sidebytte/tab-bytte | Ikke synlig i skissen | Antas implementert i kode (modal eller automatisk reset). |
| Avbryt-knapp | "Avbryt" øverst | OK |
| Lagre-knapp | "Lagre" øverst | OK |

**Avvik:** Mindre — feilmelding-stilen for tomt navn er ikke vist; antas å følge standard fs-admin input-error pattern. Ikke blokkerende.

### Skisse: Applikasjon-detaljer – tab for tilganger

- **Type:** `lokal-bilde`
- **Referanse:** [`krav-input/sketches/Applikasjon detaljer - tab for tilganger.png`](krav-input/sketches/Applikasjon%20detaljer%20-%20tab%20for%20tilganger.png)
- **Dekker krav:** BRU-APP-API-003 (`vise_tilganger.feature`)
- **Valideringsstatus:** `Avvik`

**Det skissen viser:**
- Samme topbar + tabs som detalj-skissene (Tilganger-tab valgt).
- Filter-sidebar (venstre) med "Tøm filter", **Tilgangskode** (fritekst), **Miljø** (Select, "Alle miljøer"), **Organisasjon** (Select, "Alle organisasjoner"), **Tilknytning** (Select, "Alle tilknytninger").
- Topp-actionbar høyre side: "Tildel tilganger"-knapp (primær/lilla), "Fjern tilganger"-knapp (sekundær), "Tilgangskode"-sortering.
- Resultat-liste med rader som viser tilgangskode, miljø-tags (Demo/Prod), beskrivelse, organisasjon (Universitetet i Oslo / i Tromsø).

**Match mot scenario-tekstene:**
| Scenario-krav | I skissen | Kommentar |
|---|---|---|
| Hver rad viser tilgangskode, beskrivelse, organisasjon, miljø | OK | Alle fire datapunkter er synlige per rad. |
| Filter: miljø, organisasjon, tilgangskode (fritekst), tilknytning | Alle fire filtre synlige med korrekte default-verdier | OK |
| Tilknytning-filter: Alle / Direkte / Arvet | Skissen viser kun "Alle tilknytninger" som default, ikke valgalternativer i åpen liste | OK (default-state) |
| Sortering på tilgangskode | "Tilgangskode"-velger øverst | OK |
| "Last inn flere" (>50 tilganger) | **Ikke synlig** i skissen — listen viser ca. 14 rader uten paginering nederst | Avvik — "Last inn flere"-paginering må implementeres uavhengig av om skissen viser den. |
| Arvet tilgang merket med opphav (1 eller flere) | Ikke synlig i denne skissen | Uavklart — krever ekstra UI-element (badge/indikator) som ikke vises. |
| Tildel tilganger-action (BRU-APP-API-007) | "Tildel tilganger"-knapp i actionbar | OK — actionbar deles mellom vise- og tildele-kapabilitet. |
| Fjern tilganger-action (BRU-APP-API-008) | "Fjern tilganger"-knapp i actionbar | OK |

**Avvik:**
1. **"Last inn flere"-paginering ikke vist** — skissen viser <50 rader. Implementasjonen må uansett ha det (krav: "Laste flere tilganger"). Antatt designet senere.
2. **Arvet tilgang-merking ikke vist** — kravet har flere scenarier (`Arvet tilgang er merket med opphav`, `Arvet tilgang med flere opphav listes kun én gang`) som krever et eksplisitt UI-element. Skissen viser ingen slik merking. **Åpent spørsmål.**

### Skisse: Modal – tildel tilganger

- **Type:** `lokal-bilde`
- **Referanse:** [`krav-input/sketches/Modal - tildel tilganger.png`](krav-input/sketches/Modal%20-%20tildel%20tilganger.png)
- **Dekker krav:** BRU-APP-API-007 (`tildele_tilgang.feature`)
- **Valideringsstatus:** `Avvik`

**Det skissen viser:**
- Modal-tittel "Tildel tilganger", "Avbryt × " øverst til høyre.
- Tre felter, alle defaultet til "Ikke valgt":
  1. **Organisasjon** (Select)
  2. **Miljø** (Select)
  3. **Tilgangskoder** (Select — multi-velgeren foreslås av plural "tilgangskoder")
- Primærknapp "Tildel tilganger" nederst.

**Match mot scenario-tekstene:**
| Scenario-krav | I skissen | Kommentar |
|---|---|---|
| Tildele én tilgang i valgt org+miljø | OK (singular subset av multi-velgeren) | OK |
| Tildele flere tilganger samtidig i samme org+miljø | "Tilgangskoder" er pluralis — antar multi-select | OK (forutsatt multi-select) |
| Tilgangskode-liste avhenger av valgt org+miljø | Skissen viser ikke avhengighet visuelt (begge er "Ikke valgt" i default-state) | Uavklart — antas implementert i atferd (disabled inntil org+miljø er valgt? skissen viser ikke det). |
| Allerede tildelt tilgang vises som ikke-valgbar (gråtonet) | **Ikke synlig** — skissen viser default-state med tomme valg | Uavklart — antas inni dropdown-listen, vises ikke i closed-state. |
| Organisasjon implisitt når admin har én org | **Ikke synlig** — skissen viser alltid org-feltet | **Avvik** — kravet sier "Organisasjon er implisitt når administrator har tilgang til kun én organisasjon" (linje 47–50). Skissen viser org som synlig felt uansett. **Åpent spørsmål: skal feltet skjules/disable-s når admin kun har én org?** |

**Avvik:** Org-feltet synes alltid; krav sier det skal være implisitt for én-organisasjons-admin. **Åpent spørsmål.**

### Skisse: Modal – fjern tilganger

- **Type:** `lokal-bilde`
- **Referanse:** [`krav-input/sketches/ Modal - fjern tilganger.png`](krav-input/sketches/%20Modal%20-%20fjern%20tilganger.png)
- **Dekker krav:** BRU-APP-API-008 (`fjerne_tilgang.feature`)
- **Valideringsstatus:** `Avvik`

**Det skissen viser:**
- Samme layout som tildel-modalen, men med rød destruktiv-knapp "Fjern tilganger".
- Tre felter (alle "Ikke valgt"): **Organisasjon**, **Miljø**, **Tilgangskoder**.

**Match mot scenario-tekstene:**
| Scenario-krav | I skissen | Kommentar |
|---|---|---|
| Velge tilganger å fjerne (basert på valgt org+miljø) | Tre-feltsmodal | OK |
| Bekrefte fjerning av valgte tilganger | "Fjern tilganger"-knapp | OK — bekreftelse er via "press primær-knapp" (ikke separat dialog). Krav-teksten sier "Når jeg bekrefter fjerningen", som dekkes av denne primærknappen. |
| Avbryte fjerning | "Avbryt × " øverst | OK |
| Fjerning ikke tilgjengelig for tilganger uten rettighet | **Ikke synlig** | Uavklart — antas filtrert i tilgangskode-listen. |
| Arvede tilganger kan ikke fjernes direkte | **Ikke synlig** | Uavklart — antas filtrert i tilgangskode-listen. |

**Avvik:** Listen som velges fra er ikke synlig i skissen (skissen viser closed-state). Antas at filtrering på rettighet og arve-status skjer inni dropdown'en. **Mindre avvik — antas i implementasjon.**

### Skisse: Modal – deaktiver applikasjon

- **Type:** `lokal-bilde`
- **Referanse:** [`krav-input/sketches/Modal - deaktiver applikasjon.png`](krav-input/sketches/Modal%20-%20deaktiver%20applikasjon.png)
- **Dekker krav:** BRU-APP-API-010 (`deaktivere_applikasjon.feature`) — Regel "Deaktivering krever bekreftelse og hindrer autentisering"
- **Valideringsstatus:** `OK`

**Det skissen viser:**
- Modal-tittel "Deaktivere applikasjon?".
- "Avbryt × " øverst til høyre.
- Forklarende tekst: "Applikasjonen «acos_nhhh» vil ikke lenger kunne benyttes til autentisering, og kan dermed ikke brukes i integrasjoner eller datauttrekk. Tilgangene bevares, og vil gjenopprettes ved reaktivering."
- Rød destruktiv-knapp "Deaktiver applikasjon".

**Match mot scenario-tekstene:**
| Scenario-krav | I skissen | Kommentar |
|---|---|---|
| Bekreftelsesdialog vises før deaktivering | Modal med titteltekst og forklaring | OK |
| Bekrefte deaktivering → applikasjonen ikke lenger aktiv | "Deaktiver applikasjon"-knapp | OK |
| Avbryte deaktivering | "Avbryt × " øverst | OK |
| Deaktivert applikasjon beholder tilgangene | Forklart i modal-teksten ("Tilgangene bevares") | OK — eksplisitt kommunisert til bruker. |

**Avvik:** Ingen.

### Skisse: Modal – aktiver applikasjon

- **Type:** `lokal-bilde`
- **Referanse:** [`krav-input/sketches/Modal - aktiver applikasjon.png`](krav-input/sketches/Modal%20-%20aktiver%20applikasjon.png)
- **Dekker krav:** BRU-APP-API-010 (`deaktivere_applikasjon.feature`) — Regel "Reaktivering krever bekreftelse og gjenoppretter applikasjonens tilganger"
- **Valideringsstatus:** `OK`

**Det skissen viser:**
- Modal-tittel "Aktivere applikasjon?".
- "Avbryt × " øverst til høyre.
- Forklarende tekst: "Applikasjonen «acos_nhhh» vil igjen kunne benyttes til autentisering. Tilgangene som er tildelt applikasjonen vil gjenopprettes."
- Lilla primær-knapp "Aktiver applikasjon" (ikke-destruktiv, i motsetning til deaktiver).

**Match mot scenario-tekstene:**
| Scenario-krav | I skissen | Kommentar |
|---|---|---|
| Bekreftelsesdialog vises før reaktivering | Modal med titteltekst og forklaring | OK |
| Bekrefte reaktivering → applikasjonen aktiv igjen | "Aktiver applikasjon"-knapp | OK |
| Tilgangene gjelder igjen ved reaktivering | Forklart i modal-teksten ("Tilgangene ... vil gjenopprettes") | OK |
| Avbryte (implisitt — samme regel-mønster som deaktivering) | "Avbryt × " øverst | OK |

**Avvik:** Ingen.

### Krav uten skisse

To krav har ingen skisse i `docs/skisser/`. Beslutning: bygges fra krav-tekst alene; ingen åpne spørsmål registreres på skisse-grunn.

- **BRU-APP-API-004 — Passordbytte for applikasjon.** Eksisterende `MigrerPassord.tsx` (`src/domains/support/features/MaskinBruker/components/MigrerPassord/MigrerPassord.tsx`) brukes som inspirasjon for visningsmønster (skjult passord, kopier-knapp, dialog-lukking).
- **BRU-APP-API-009 — Opprette applikasjon.** Designes ut fra `Regel:`-blokkene i `.feature`-filen. Plassering: "Opprett"-knappen vises i oversiktssiden (synlig i oversikt-skissen).

### Oppsummering av valideringsstatus

| Skisse | Status | Hovedfunn |
|---|---|---|
| Applikasjoner – oversikt med filter | `OK` | Alle scope-krav reflektert; tilgang-filter bevisst utelatt (`@could`). |
| Detaljer – lese-modus | `OK` | Alle 6 dataområder vises; Rediger-knapp i posisjon. |
| Detaljer – redigeringsmodus | `OK` | Kun navn/beskrivelse redigerbare som krav sier. Feilmelding-stil for tomt navn ikke vist (mindre avvik, antas standard). |
| Detaljer – tab for tilganger | `Avvik` | "Last inn flere"-paginering og arvet-tilgang-merking ikke vist. |
| Modal – tildel tilganger | `Avvik` | Org-felt vises alltid; krav sier det skal være implisitt for én-organisasjons-admin. |
| Modal – fjern tilganger | `Avvik` (mindre) | Rettighet/arv-filtrering inni dropdown ikke synlig; antas i implementasjon. |
| Modal – deaktiver applikasjon | `OK` | Eksplisitt forklaring om at tilganger bevares. |
| Modal – aktiver applikasjon | `OK` | Eksplisitt forklaring om at tilganger gjenopprettes. |

## API-skjema (GraphQL)

Spec-en spesifiserer hva fs-admin trenger fra backend for å implementere de 9 kravene. Dette er **forbruker-siden** av kontrakten — den faktiske skjema-implementasjonen ligger på backend-agent og verifiseres/forhandles via bat-graphql-dev og cross-agent-koordinering. Konvensjonene følger eksisterende fs-admin / Graphitron-mønstre: Relay cursor-pagination, union-error envelope for mutasjoner, lokaliserte felt der relevant, og custom scalars (`LocalDate`, `UUID`, `BigDecimal`).

### Typer

```graphql
"En applikasjon (tidligere kjent som API-bruker) som kan autentisere mot FS og tildeles tilganger."
type Applikasjon implements Node {
  "Intern unik ID generert av FS — uavhengig av identitetsleverandør (BRU-APP-API-009, regel: 'Systemet tildeler hver applikasjon en intern unik ID')."
  id: ID!

  "Visningsnavn, hentet fra idP-en ved opprettelse. Globalt unikt på tvers av organisasjoner."
  navn: String!

  "Fri tekst-beskrivelse, redigerbar etter opprettelse (BRU-APP-API-006)."
  beskrivelse: String

  "ID-en applikasjonen identifiseres med eksternt hos sin identitetsleverandør."
  eksternId: String!

  "Identitetsleverandør — settes ved opprettelse og kan ikke endres."
  identitetsleverandor: Identitetsleverandor!

  "Organisasjonen applikasjonen tilhører. null for legacy FS-applikasjoner uten organisasjon (super-admin-synlige)."
  organisasjon: Organisasjon

  "Status (BRU-APP-API-010): AKTIV eller DEAKTIVERT."
  status: ApplikasjonStatus!

  "Miljøer applikasjonen er aktiv i — utledet fra tilganger. Tom hvis ingen tilganger er tildelt."
  miljoer: [Miljo!]!

  "Tilganger applikasjonen har, paginert. Filtrering, sortering og 'last inn flere' i samme query (BRU-APP-API-003)."
  tilganger(
    first: Int = 50
    after: String
    filter: ApplikasjonTilgangerFilter
    orderBy: ApplikasjonTilgangerOrderBy = TILGANGSKODE_ASC
  ): [ApplikasjonTilgang!]! @asConnection

  "Totalt antall tilganger, uavhengig av paginering."
  antallTilganger: Int!

  "Sporing — hvem og når."
  opprettetAv: Person!
  opprettetTidspunkt: LocalDateTime!
  sistEndretAv: Person
  sistEndretTidspunkt: LocalDateTime

  "Rettighet-baserte felter — forbruker-siden bruker disse for å skjule/disable handlinger (BRU-APP-API-004, -006, -007, -008, -010)."
  kanRedigeres: Boolean!         # navn + beskrivelse
  kanByttePassord: Boolean!       # passord-modal
  kanDeaktiveres: Boolean!        # deaktiver/reaktiver
  kanTildeleTilganger: Boolean!   # åpner tildel-modal
  kanFjerneTilganger: Boolean!    # åpner fjern-modal
}

enum Identitetsleverandor {
  FEIDE
  MASKINPORTEN
  MASKINBRUKER  # Legacy — tidligere "FS" på consumer-siden. Renamet per backend-sign-off #469
                # (2026-06-01) for å matche storage-tabellen `tilgangsstyring.maskinbruker_applikasjon`.
                # Visningslabel "FS-bruker" forblir frontend-konsern.
                # Kan vises i listen og forvaltes, men kan ikke velges ved nyopprettelse.
}

enum ApplikasjonStatus {
  AKTIV
  DEAKTIVERT
}

type Miljo {
  kode: String!     # f.eks. "demo", "prod"
  navn: String!     # menneskelig — lokalisert
}

"En tilgang knyttet til en applikasjon."
type ApplikasjonTilgang implements Node {
  id: ID!
  tilgangskode: String!
  beskrivelse: String           # lokalisert
  miljo: Miljo!
  organisasjon: Organisasjon!

  "Direkte eller arvet (BRU-APP-API-003, regel: 'Filtrering på tilknytning')."
  tilknytning: Tilknytning!

  "Hvis ARVET — listen over direkte tilganger som arven kommer fra. Tom for direkte tilganger."
  arvetFra: [ApplikasjonTilgang!]!

  "Rettigheter for denne tilgangen — forbruker-siden bruker disse for å skjule eller disable 'Fjern'-handlingen (BRU-APP-API-008)."
  kanFjernes: Boolean!
}

enum Tilknytning {
  DIREKTE
  ARVET
}
```

### Queries

```graphql
extend type Query {
  "Listevisning + søk + filtrering (BRU-APP-API-001). Synlighet styres serverside basert på brukerens rettigheter."
  applikasjoner(
    first: Int = 50
    after: String
    filter: ApplikasjonerFilter
    orderBy: ApplikasjonerOrderBy = NAVN_ASC
  ): [Applikasjon!]! @asConnection
  # Graphitron emitterer Connection-shape (nodes/edges{cursor,node}/pageInfo/totalCount)
  # per backend-sign-off #469. PageInfo er @shareable i schema_prod.graphqls:17.

  "Detaljside-data (BRU-APP-API-002). null hvis brukeren ikke har synlighet."
  applikasjon(id: ID!): Applikasjon

  """
  Verifisering av en ekstern ID mot valgt identitetsleverandør (BRU-APP-API-009).
  Påkalles av frontend før opprettelse, eller serverside som del av opprettApplikasjon-mutasjonen — backend velger.
  Returnerer det navnet idP-en oppgir, eller en feilkode hvis ID-en ikke finnes / allerede er registrert.
  """
  verifiserApplikasjonEksternId(
    identitetsleverandor: Identitetsleverandor!
    eksternId: String!
  ): VerifiserApplikasjonEksternIdResultat!

  "Valglister for tildel-tilgang-modalen (BRU-APP-API-007). Avhenger av valgt org+miljø + brukerens rettigheter."
  tildelbareTilgangskoder(
    applikasjonId: ID!
    organisasjonId: ID!
    miljoKode: String!
  ): [TilgangskodeValg!]!

  "Valglister for organisasjon ved opprettelse / tildeling. Brukerens administrerte organisasjoner."
  mineApplikasjonsAdminOrganisasjoner: [Organisasjon!]!
}

input ApplikasjonerFilter {
  navn: String                      # fritekst-søk
  miljoKode: String                 # kun applikasjoner aktive i miljøet
  organisasjonId: ID
  status: ApplikasjonStatus
  # tilgang: ID  -- bevisst utelatt (kravet er @could, ikke @must)
}

enum ApplikasjonerOrderBy {
  NAVN_ASC
  NAVN_DESC
}

# NB: ApplikasjonerConnection / ApplikasjonerEdge / PageInfo er IKKE hand-written.
# Graphitron emitterer dem fra @asConnection-direktivet på query-en, med shape:
#   { nodes: [Applikasjon!]!, edges: [{ cursor, node }], pageInfo: PageInfo, totalCount: Int }
# Per backend-sign-off #469 (2026-06-01).

input ApplikasjonTilgangerFilter {
  tilgangskode: String              # fritekst-søk
  miljoKode: String
  organisasjonId: ID
  tilknytning: Tilknytning
}

enum ApplikasjonTilgangerOrderBy {
  TILGANGSKODE_ASC
  TILGANGSKODE_DESC
}

# NB: ApplikasjonTilgangerConnection / ApplikasjonTilgangerEdge er IKKE hand-written.
# Graphitron emitterer dem fra @asConnection-direktivet på Applikasjon.tilganger-feltet.
# Per backend-sign-off #469 (2026-06-01).

type TilgangskodeValg {
  kode: String!
  beskrivelse: String       # lokalisert
  alleredeTildelt: Boolean! # vises som ikke-valgbar / gråtonet i UI (BRU-APP-API-007, regel: 'En tilgang som allerede er tildelt...')
}

"Resultatet av idP-verifisering. Union-pattern — én av variantene returneres."
union VerifiserApplikasjonEksternIdResultat =
    ApplikasjonEksternIdVerifisert
  | ApplikasjonEksternIdIkkeFunnet
  | ApplikasjonEksternIdAlleredeRegistrert

type ApplikasjonEksternIdVerifisert {
  eksternId: String!
  navnFraIdp: String!     # det idP-en oppgir; må enda valideres mot globalt-unik-visningsnavn ved create
}

type ApplikasjonEksternIdIkkeFunnet {
  identitetsleverandor: Identitetsleverandor!
  eksternId: String!
  feilmelding: String!    # lokalisert
}

type ApplikasjonEksternIdAlleredeRegistrert {
  eksisterendeApplikasjonId: ID!  # null hvis brukeren ikke har synlighet
  feilmelding: String!
}
```

### Mutasjoner

Alle mutasjoner følger fs-admin union-error envelope-pattern: returtypen er en union mellom suksess-typen og en eller flere navngitte feiltyper. Forbruker switch-er på `__typename`.

```graphql
extend type Mutation {
  # BRU-APP-API-009 — Opprette applikasjon
  opprettApplikasjon(input: OpprettApplikasjonInput!): OpprettApplikasjonResultat!

  # BRU-APP-API-006 — Redigere detaljer (navn + beskrivelse)
  oppdaterApplikasjonDetaljer(input: OppdaterApplikasjonDetaljerInput!): OppdaterApplikasjonDetaljerResultat!

  # BRU-APP-API-004 — Passordbytte
  genererNyttApplikasjonPassord(applikasjonId: ID!): GenererNyttApplikasjonPassordResultat!

  # BRU-APP-API-010 — Deaktiver / reaktiver
  deaktiverApplikasjon(applikasjonId: ID!): DeaktiverApplikasjonResultat!
  reaktiverApplikasjon(applikasjonId: ID!): ReaktiverApplikasjonResultat!

  # BRU-APP-API-007 — Tildele tilgang (en eller flere i samme org+miljø)
  tildelApplikasjonTilganger(input: TildelApplikasjonTilgangerInput!): TildelApplikasjonTilgangerResultat!

  # BRU-APP-API-008 — Fjerne tilgang (en eller flere i samme org+miljø)
  fjernApplikasjonTilganger(input: FjernApplikasjonTilgangerInput!): FjernApplikasjonTilgangerResultat!
}

# ---------- Opprett ----------

input OpprettApplikasjonInput {
  identitetsleverandor: Identitetsleverandor!  # FS ikke tillatt — backend må avvise
  eksternId: String!                             # verifiseres serverside
  organisasjonId: ID!                            # implisitt for én-org-admin (klient sender alltid)
  # Merk: navn hentes fra idP-en; klient sender det IKKE.
  # Visningsnavn-uniqueness valideres serverside ved opprettelse.
}

union OpprettApplikasjonResultat =
    OpprettApplikasjonSuksess
  | ApplikasjonEksternIdIkkeFunnet            # gjenbrukes fra Query-siden
  | ApplikasjonEksternIdAlleredeRegistrert
  | ApplikasjonVisningsnavnAlleredeIBruk
  | ApplikasjonOpprettelseAvvist               # generisk avvisning (rettigheter, FS-leverandør, etc.)

type OpprettApplikasjonSuksess {
  applikasjon: Applikasjon!
}

type ApplikasjonVisningsnavnAlleredeIBruk {
  visningsnavn: String!
  feilmelding: String!
}

type ApplikasjonOpprettelseAvvist {
  arsak: OpprettelseAvvistArsak!
  feilmelding: String!
}

enum OpprettelseAvvistArsak {
  MANGLER_RETTIGHET
  IDENTITETSLEVERANDOR_IKKE_TILLATT  # FS valgt
  ORGANISASJON_IKKE_TILLATT          # admin har ikke rettighet for valgt org
  UKJENT
}

# ---------- Oppdater detaljer (navn + beskrivelse) ----------

input OppdaterApplikasjonDetaljerInput {
  applikasjonId: ID!
  navn: String!         # ikke-tomt — backend validerer
  beskrivelse: String   # tom streng tillatt
}

union OppdaterApplikasjonDetaljerResultat =
    OppdaterApplikasjonDetaljerSuksess
  | ApplikasjonNavnObligatorisk
  | ApplikasjonVisningsnavnAlleredeIBruk     # gjenbrukes hvis navn endres
  | MutasjonAvvist                            # rettighet / ikke-funnet

type OppdaterApplikasjonDetaljerSuksess {
  applikasjon: Applikasjon!
}

type ApplikasjonNavnObligatorisk {
  feilmelding: String!
}

type MutasjonAvvist {
  arsak: MutasjonAvvistArsak!
  feilmelding: String!
}

enum MutasjonAvvistArsak {
  MANGLER_RETTIGHET
  RESSURS_IKKE_FUNNET
  UGYLDIG_TILSTAND     # f.eks. deaktiver allerede-deaktivert
  UKJENT
}

# ---------- Passord ----------

union GenererNyttApplikasjonPassordResultat =
    GenererNyttApplikasjonPassordSuksess
  | MutasjonAvvist

"Det genererte passordet vises kun én gang — etter at klienten har mottatt det og brukeren lukker dialogen, kan det ikke hentes opp igjen."
type GenererNyttApplikasjonPassordSuksess {
  applikasjonId: ID!
  passord: String!  # vises skjult, kopierbar, kan ikke hentes opp igjen
}

# ---------- Deaktiver / reaktiver ----------

union DeaktiverApplikasjonResultat =
    DeaktiverApplikasjonSuksess
  | MutasjonAvvist

type DeaktiverApplikasjonSuksess {
  applikasjon: Applikasjon!  # status nå DEAKTIVERT
}

union ReaktiverApplikasjonResultat =
    ReaktiverApplikasjonSuksess
  | MutasjonAvvist

type ReaktiverApplikasjonSuksess {
  applikasjon: Applikasjon!  # status nå AKTIV
}

# ---------- Tildel tilganger ----------

input TildelApplikasjonTilgangerInput {
  applikasjonId: ID!
  organisasjonId: ID!
  miljoKode: String!
  tilgangskoder: [String!]!    # én eller flere i samme org+miljø
}

union TildelApplikasjonTilgangerResultat =
    TildelApplikasjonTilgangerSuksess
  | MutasjonAvvist

type TildelApplikasjonTilgangerSuksess {
  applikasjon: Applikasjon!
  tildelteTilganger: [ApplikasjonTilgang!]!
}

# ---------- Fjern tilganger ----------

input FjernApplikasjonTilgangerInput {
  applikasjonId: ID!
  organisasjonId: ID!
  miljoKode: String!
  tilgangskoder: [String!]!
}

union FjernApplikasjonTilgangerResultat =
    FjernApplikasjonTilgangerSuksess
  | MutasjonAvvist

type FjernApplikasjonTilgangerSuksess {
  applikasjon: Applikasjon!
  fjernedeTilgangskoder: [String!]!
}
```

### Cross-agent-avhengigheter (kandidater)

Disse kreves fra backend-agent (eier av `sikt-no/fs` schema-implementasjonen). `bat-plan` filer hand-off-issues via agent-coord når planen eksisterer.

- **idP-verifisering** (`verifiserApplikasjonEksternId`-query + serverside-validering i `opprettApplikasjon`): krever Feide/Dataporten-klient (intern Sikt-API) og Maskinporten-klient (med service-account-credentials). Forbrukeren har ingen vei til disse direkte fra browser.
- **Rettighet-baserte felter på `Applikasjon` og `ApplikasjonTilgang`** (`kanRedigeres`, `kanByttePassord`, `kanDeaktiveres`, `kanTildeleTilganger`, `kanFjerneTilganger`, `kanFjernes`): backend må beregne disse basert på innlogget brukers rolle (super-admin, org-admin på applikasjonens org, etc.). Alternativet (forbrukeren forsøker handlingen og får 403) er for treig UX.
- **`tildelbareTilgangskoder`**: query som returnerer kun tilgangskoder brukeren faktisk har rettighet til å tildele for valgt org+miljø, og merker allerede-tildelte som `alleredeTildelt: true`. Krever tilgangs-rettighetsmodellen ferdig på backend.
- **`mineApplikasjonsAdminOrganisasjoner`**: brukerens administrerte organisasjoner. Kan allerede finnes; bat-analyze verifiserer.
- **Synlighet-filtrering i `applikasjoner`-query**: server håndhever at admin kun ser applikasjoner i egne org + applikasjoner med tilganger som rammer egne org. Forbrukeren stoler blindt på server-svaret.

### Designvalg som bør verifiseres mot eksisterende fs-admin-konvensjoner

`bat-analyze` + `bat-graphql-dev` validerer disse mot Graphitron-mønstre og eksisterende skjema-elementer på `sikt-no/fs` `fruitbat`-branchen:

- **Union-feilenveloppe vs. `errors`-feltet i `extensions`** — fs-admin bruker union-pattern for forretningsfeil (per `graphql-consumer`-skillen). Alle mutasjoner over følger dette.
- **`Connection`/`Edge`/`PageInfo`** — emitteres av Graphitron via `@asConnection`-direktivet (avklart 2026-06-01, [#469](https://github.com/sikt-no/fs/issues/469)). `totalCount` er ikke standard-Relay, men er nødvendig for "X av Y"-tekst i UI (eksisterende fs-admin-pattern). `PageInfo` er `@shareable` i `schema_prod.graphqls:17`.
- **`LocalDateTime` vs. `String` for sporings-tidspunkter** — fs-admin har custom scalar; verifiseres.
- **`Beskrivelse`-felter på `ApplikasjonTilgang.beskrivelse` og `Miljo.navn`** — lokalisert (norsk + engelsk) eller bare norsk? Følger eksisterende lokaliseringspraksis.
- **`Identitetsleverandor.MASKINBRUKER` for legacy FS-applikasjoner** (avklart 2026-06-01, [#469](https://github.com/sikt-no/fs/issues/469)) — enum-verdien matcher storage-tabellen `tilgangsstyring.maskinbruker_applikasjon` på backend. Visningslabel "FS-bruker" forblir frontend-konsern.
- **MaskinBruker beholdes uberørt (oppdatert beslutning 2026-06-01)** — initiativ-bodyen sier "Dagens løsning ... skal fjernes" og "ikke gjenbruke dagens graphql spørringer for maskinbruker", men per brukervedtak skal MaskinBruker-koden **ikke** fjernes som del av dette arbeidet. "Ikke gjenbruke"-direktivet respekteres ved at vi spør på nye `Applikasjon`-types; eksisterende `Maskinbruker`-types ignoreres, men slettes ikke.

## Åpne spørsmål

- [x] **Stale referanse i iterasjon 2 systemkrav:** `systemkrav.md` (iter 2) linker på linje 67 til `rediger_beskrivelse.feature`, men filen på branchen heter `rediger_detaljer.feature` (egenskap "Redigere detaljer for applikasjon"). Sannsynligvis kun en redaksjonell glipp i systemkrav-doc-en, men bekreft før `bat-analyze` slik at vi ikke er ute etter en fil som ikke finnes.
  - **Beslutning (2026-06-01):** Legacy i spec-en. `rediger_detaljer.feature` er den kanoniske filen og dekker både redigering av navn (lines 14–40) **og** redigering av beskrivelse (lines 55–72) — pluss en felles regel om at ulagrede endringer forkastes (lines 41–53). `rediger_beskrivelse.feature` eksisterer ikke og skal ignoreres. `systemkrav.md` (iter 2, linje 65–73) er stale på linkenavnet, men `Feature-ID` (`BRU-APP-API-006`) peker fortsatt riktig — implementasjonen følger `.feature`-filen, ikke systemkrav-teksten.
  - **Implementasjonskonsekvens:** Detalj-tab i redigeringsmodus må kunne oppdatere både **navn** og **beskrivelse** (i samme skjema), med tilgangskontroll per applikasjon, "tomt navn"-validering, og forkasting av ulagrede endringer ved sidebytte/tab-bytte.
- [x] **Skissevalidering mot scenario-innhold:** Skissene er kun mappet på filnavn. Dybdevalidering (felter, filter-valg, knappe-tekster) skjer i `bat-analyze` mot hver skisse + tilsvarende `Scenario:`-blokk.
  - **Beslutning (2026-06-01):** Dybdevalidering gjennomført i bat-specify. Se "Oppsummering av valideringsstatus"-tabell over. Tre skisser klassifisert som `Avvik` (1 substantielt, 2 mindre). Substantielle avvik konvertert til nye åpne spørsmål under.
- [x] **Tildel-modal: Organisasjons-felt synlig for én-organisasjons-admin** — Skissen viser "Organisasjon" som alltid synlig Select i modalen, men `tildele_tilgang.feature` (BRU-APP-API-007, linje 47–50) sier: "Organisasjon er implisitt når administrator har tilgang til kun én organisasjon". Skal feltet skjules helt, vises som disabled med org-navnet, eller vises som vanlig Select med kun ett valg? Påvirker også **fjern tilganger**-modalen som har samme layout.
  - **Beslutning (2026-06-01):** Vis feltet som **disabled med org-navnet forhåndsutfylt** når admin kun har én org. Begrunnelse: Bruker ser konteksten (hvilken org gjelder tildelingen), unngår "magiske" skjulte tilstander, og er konsistent med fs-admin-inputs-skillens regel om at disabled selects krever en forklarende verdi. Krav-teksten ("implisitt") tolkes som at brukeren ikke trenger å aktivt velge — ikke at feltet er fysisk skjult. **Gjelder begge modaler** (tildel + fjern).
- [x] **Tab for tilganger: Visning av arvede tilganger og opphav** — `vise_tilganger.feature` (BRU-APP-API-003, linje 72–80) har to scenarier som krever at arvede tilganger merkes og at opphavet vises. Skissen viser ingen slik merking. Trenger eksplisitt designbeslutning på badge/indikator-stil.
  - **Beslutning (2026-06-01):** Bruk en **"Arvet"-tag plassert ved siden av miljø-tagene** (Demo/Prod) på hver rad i tilgangs-listen — samme visuelle posisjon som de eksisterende env-tagene i skissen. Direkte tilganger har ingen ekstra tag (mangel av "Arvet"-tag indikerer direkte). Opphavet (hvilke direkte tilganger arven stammer fra) vises ved interaksjon — enten popover på taggen eller inline expand under raden. **Eksakt interaksjons-mekanisme avgjøres i bat-analyze** mot fs-admin-list-results-pattern; konseptet (tag på samme nivå som miljø-tagene) er låst.
- [x] **Tab for tilganger: "Last inn flere"-paginering** — Kravet har scenario "Laste flere tilganger" (linje 51–55), men skissen viser ikke paginering-kontrollene. Implementasjonen må uansett ha det; mest sannsynlig samme pattern som applikasjons-oversikten. Bekrefte i `bat-analyze` at fs-admin-list-results-pattern dekker dette.
  - **Beslutning (2026-06-01):** Bruk samme `fs-admin-list-results`-pattern som applikasjons-oversikten — "Last inn flere"-knapp + `loadedCount` / `totalCount`. Skjema-siden støtter dette via `ApplikasjonTilgangerConnection.totalCount` + `pageInfo.hasNextPage` (definert i schema-spesifikasjonen over).
- [x] **Identitetsleverandør-verifisering mot idP (BRU-APP-API-009):** Kravet sier «ID-en finnes hos `<identitetsleverandør>`» og «Navnet hentes fra `<identitetsleverandør>`» (Feide / Maskinporten). Er det avklart hvilken backend-tjeneste som utfører dette oppslaget, eller må `bat-analyze` flagge det som cross-agent-avhengighet?
  - **Beslutning (2026-06-01):** Designet inn i schema-spesifikasjonen over som `verifiserApplikasjonEksternId(identitetsleverandor, eksternId)`-query med union-return (`ApplikasjonEksternIdVerifisert` / `ApplikasjonEksternIdIkkeFunnet` / `ApplikasjonEksternIdAlleredeRegistrert`). Samme feiltyper gjenbrukes i `opprettApplikasjon`-mutasjonen for serverside-validering. Klassifisert som cross-agent-avhengighet — backend må implementere Feide- og Maskinporten-klientene. **Eksterne ID-er som forventes:** Feide client/entity ID (det Feide oppgir ved registrering — format ikke pinnet av krav, bekreftes av backend); Maskinporten client_id (det Maskinporten genererer ved klient-registrering). Visningsnavn hentes fra samme oppslag og må deretter valideres mot globalt-unikt-visningsnavn ved opprettelse.
- [x] **Felles tilgangs-liste-pattern på detaljside (BRU-APP-API-003) vs filter-pattern brukt på oversikt (BRU-APP-API-001):** Spec-en sier begge skal filtreres/sorteres/pagineres, men oversikten er en `ListPageLayout` mens detalj-tilgangstaben er en sub-liste i `DetailPageTabbedContent`. `fs-admin-list-filters`-skillen sier eksplisitt at samme regler gjelder begge steder — bekreft at filter-implementasjonen kan deles, eller om de skal være separate.
  - **Beslutning (2026-06-01):** Hver får sin egen implementasjon. Begrunnelse: ulike entiteter (`Applikasjon` vs `ApplikasjonTilgang`), ulike filterfelt (oversikt: navn/miljø/org/status; tilganger: tilgangskode/miljø/org/tilknytning), ulike state-hooks (`useGetApplikasjonerState` vs `useGetApplikasjonTilgangerState`). De **delte primitivene** (`FilterWrapper`, `FilterReset`, `FilterChip`) brukes uansett fra `common/`. `fs-admin-list-filters`-skillen håndhever felles **regler** (input-typer, "Alle ..."-default, chip-strip-rendering, URL-synkronisering), ikke felles **kode**.
