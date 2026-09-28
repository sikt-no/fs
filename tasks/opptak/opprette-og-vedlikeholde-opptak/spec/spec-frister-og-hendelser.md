# Spec: Frister og hendelser for opptak

## Kilde

- **Oppgave:** `tasks/opptak/opprette-og-vedlikeholde-opptak/`
- **Kilde-mappe:** `krav/02 Opptak/11 Opptak/04 Frister`
- **GitHub:** ingen `# GitHub:`-linjer i kravfila. `oppgave.md` knytter «Sette frister og hendelser for opptaket» til [#579](https://github.com/sikt-no/fs/issues/579).
- **Hentet:** 2026-09-28 14:50

## Krav

- **`frister_og_hendelser.feature`** (`@OPT-OPT-FRI-001`) — opptaksforvalter ved forvaltende organisasjon setter de generelle fristene og informasjonsdatoene for opptaket. Det gjelder:
  - åpning og stenging av redigering av utdanningstilbud. Stengingen er også trekkfristen: etter den kan bare opptaksforvalter trekke utdanningstilbud.
  - når søknaden åpner, og ordinær søknadsfrist
  - omprioriteringsfrist og frist for sletting av søknadsalternativer
  - ordinær dokumentasjonsfrist og ettersendingsfrist
  - datoer for ledige studieplasser
  - frister for tidlig opptak (søknadsfrist og dokumentasjonsfrist)
  - datoer for opptaksresultat: når hovedopptaket publiseres (det er også datoen søkere kan forvente svar), og første svarfrist
  - frist for saksbehandlers endring av søkers utdanningsbakgrunn

  ([krav-input/local/krav/02 Opptak/11 Opptak/04 Frister/frister_og_hendelser.feature](krav-input/local/krav/02%20Opptak/11%20Opptak/04%20Frister/frister_og_hendelser.feature))

Kravfila har ingen `@openquestion` og ingen `@draft`-deler.

**Relaterte krav som ikke er med** (de er `@draft` og må gjennom `fs-krav` før de kan hentes inn):

- `hendelseslogg.feature` (`@OPT-OPT-LOG-001`)
- `opprette_plasstildelingsrunde.feature` (`@OPT-PLA-RUN-001`, [#216](https://github.com/sikt-no/fs/issues/216)), i `krav/02 Opptak/14 Plasstildeling/01 Runder/`. Her står nå kravet om at første plasstildelingsrunde opprettes fra publiseringsdatoen og første svarfrist. Det ble flyttet ut av `frister_og_hendelser.feature`.
- Tidlig søknadsfrist og tidlig dokumentasjonsfrist settes på utdanningstilbud og utdanningsbakgrunn, ikke blant de generelle fristene. De står i `opptaksinnstillinger_utdanningstilbud.feature` (`@OPT-OPT-UTD-004`) og `utdanningsbakgrunn.feature` (`@OPT-OPT-UBG-001`).

## Skisser

### Skisse: Opprett opptak — frister og hendelser

- **Type:** `figma`
- **Referanse:** <https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20606-117530&m=dev> (`fileKey` `LmoNQlmAuE2FlE0fUo5GoO`, `nodeId` `20606:117530`, siden «Opprett nytt Samordna opptak»). Nyeste versjon av siden, og den erstatter `18929:96690`.
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/screenshot.png), [sub-frames/](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/sub-frames/) (seksjonen som dekker kravet er [04-frister-section.png](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/sub-frames/04-frister-section.png)), [design-context.md](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/design-context.md), [variables.md](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/variables.md), [assets/](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/assets/)
- **Dekker krav:** `frister_og_hendelser.feature` (seksjonen «Generelle frister», node `20606:117632`). Resten av siden hører til andre krav.
- **Valideringsstatus:** `OK`. Skissen samsvarer med kravene for redigering av studier, søkeperiode, endre søknad, dokumentasjon, tidlig opptak, ledige studieplasser, saksbehandlers endring av utdanningsbakgrunn og opptaksresultat. Gruppen «Hovedopptak» har «Publiseringsdato» og «Svarfrist», som er de to datoene kravet har for opptaksresultat. Avviket fra forrige kjøring (manglende datoer under «Opptaksresultat») er løst i designet.
  - To forskjeller i ordlyd, som ikke er avvik: skissen sier «Svarfrist» der kravet sier «første svarfrist». Hjelpeteksten for «Publiseringsdato» sier ikke at søkere kan forvente svar denne datoen, men det er informasjon til søker og ikke et felt i skjemaet.
- **Beslutning ved avvik:** ingen avvik gjenstår. Beslutningene fra valideringene tidligere samme dag står fortsatt, og er skrevet inn i kravfila:
  - Scenarioet «tidlig dokumentasjonsfrist for søkere med tidlig søknadsfrist» er flyttet til utdanningstilbud og utdanningsbakgrunn.
  - Regelen for tidlig opptak står som generelle frister, slik skissen viser.
  - Trekkfristen er det samme som «Redigering stenger». Den egne regelen er fjernet.
  - Interne saksbehandlingsfrister er ikke et krav og er fjernet.
  - «Endre utdanningsbakgrunn» gjelder saksbehandler.
  - «Forventet svar» er slått sammen med publiseringsdatoen for hovedopptaket.
  - Kravet om at datoene oppretter første plasstildelingsrunde er flyttet til `opprette_plasstildelingsrunde.feature` (`@draft`).

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/11 Opptak/04 Frister/frister_og_hendelser.feature` | `@OPT-OPT-FRI-001 @must @planned` | `@OPT-OPT-FRI-001 @must @in-progress` |

Retagget i første kjøring 2026-09-28. Senere kjøringer hoppet over fila fordi den allerede var `@in-progress`.

## Åpne spørsmål

- [x] **Hva utløser opprettelsen av første plasstildelingsrunde?** Scenarioet «Opprette første plasstildelingsrunde fra publiseringsdato og første svarfrist» har ikke noe `Når`-steg: «Og første plasstildelingsrunde opprettes i opptaket» står i `Gitt`-delen. Opprettes runden når begge datoene er satt, eller når opptaket lagres eller publiseres? Hva skjer med runden hvis datoene endres etterpå? Dette må være klart før `lage-steps` kan teste scenarioet.
  - **Beslutning (2026-09-28):** Runden opprettes ikke automatisk. Når opptaket er laget, oppretter opptaksforvalter første opptaksrunde som en egen oppgave. Publiseringsdatoen og første svarfrist brukes da som publiseringstidspunkt og svarfrist for runden.
  - **Begrunnelse:** Det er brukerens avklaring. Å opprette plasstildelingsrunder er en egen handling etter at opptaket er laget, ikke en del av å sette frister.
  - **Oppfølging:** Scenarioet er flyttet til `opprette_plasstildelingsrunde.feature` (`@OPT-PLA-RUN-001`, `@draft`) og er ikke lenger en del av denne spec-en. Beslutningen føres inn der med `fs-krav`, og scenarioet får et `Når`-steg for at opptaksforvalter oppretter runden.

Ingen åpne spørsmål gjenstår for `frister_og_hendelser.feature`.
