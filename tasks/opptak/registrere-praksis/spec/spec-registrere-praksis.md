# Spec: Registrere og beregne praksis for søker

## Kilde

- **Oppgave:** `tasks/opptak/registrere-praksis/`
- **Kilde:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/registrere_praksis.feature`
- **GitHub:** [#560](https://github.com/sikt-no/fs/issues/560)
- **Hentet:** 2026-09-24

## Krav

- **`registrere_praksis.feature`** (`@OPT-BEH-BEH-003`, `@must`). Opptakssaksbehandleren registrerer praksisperioder på en sak, med periode og omfang (stillingsprosent eller timer). Systemet regner ut og summerer praksis i år, med full presisjon og avkorting til to desimaler i visningen. Overlappende perioder varsles og vises med to summer. Kravet dekker også validering av datoer, oppdatering og sletting, historikk og tilgang. ([krav-input/local/…/registrere_praksis.feature](krav-input/local/krav/02%20Opptak/13%20Søknad%20og%20saksbehandling/02%20Behandling/registrere_praksis.feature))
  - Utenfor første leveranse: scenarioet «Knytte praksisperioden til dokumentasjon på søknaden» (`@could`, utsatt).
  - Fire scenarioer er `@openquestion` og kan ikke implementeres før de er avklart. De står under *Åpne spørsmål*.
  - Kobling til opptakskrav hører ikke til denne spec-en. Den dekkes av `knytte_praksis_til_opptakskrav.feature` (`@OPT-BEH-BEH-004`).

## Skisser

### Skisse: Skisse til claude

- **Type:** `figma`
- **Referanse:** [FS-Admin – Seksjon Opptak, seksjonen «Skisse til claude»](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20747-108803). Lenken som ble oppgitt, pekte på hele siden ([node 19816-129026](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=19816-129026)).
- **Lagrede artefakter:**
  - [screenshot.png](krav-input/sketches/figma/skisse-til-claude/screenshot.png)
  - [sub-frames/01-sidelayout-i-fs-admin-pattern.png](krav-input/sketches/figma/skisse-til-claude/sub-frames/01-sidelayout-i-fs-admin-pattern.png): oversiktssiden «Praksiskalkulator»
  - [sub-frames/02-dialog.png](krav-input/sketches/figma/skisse-til-claude/sub-frames/02-dialog.png): dialogen «Legg til praksisperiode»
  - [design-context.md](krav-input/sketches/figma/skisse-til-claude/design-context.md)
  - [variables.md](krav-input/sketches/figma/skisse-til-claude/variables.md)
- **Dekker krav:** `registrere_praksis.feature`, reglene «Praksisperioder registreres manuelt på saken», «Omfanget av en praksisperiode oppgis som stillingsprosent eller som antall timer», «Praksisperioder kan oppdateres og slettes» og «Systemet summerer praksisperiodene automatisk».
- **Stemmer med kravene:**
  - Omfanget oppgis enten som stillingsprosent eller som timer i perioden, med ett valg per periode.
  - Startdato er påkrevd, og sluttdato er valgfri.
  - Beregnet varighet vises allerede i dialogen.
  - Hver periode kan redigeres og slettes.
  - Tabellen viser praksistype, periode, omfang og beregnet praksis.
  - Timebasert omfang vises sammen med årsverket, for eksempel «850 timer (av 1700)», slik at beregningen kan etterprøves.
- **Valideringsstatus:** `Avvik`, med åtte funn:

| # | Avvik | Beslutning | Begrunnelse / konsekvens |
|---|---|---|---|
| 1 | Praksistype er valgfri i skissen, men obligatorisk i kravet | **Skissen er riktig. Krav mangler** | Scenarioet «Praksistype og startdato er obligatorisk» må endres av `fs-krav`: bare startdato er obligatorisk. |
| 2 | Skissen har «Arbeidsgiver (valgfri)» i dialogen og som første kolonne i tabellen. Kravet har ikke dette feltet. | **Skissen er riktig. Krav mangler** | Arbeidsgiver må legges til som valgfritt felt i registreringen og i feltlisten i «Se registrerte praksisperioder» (`fs-krav`). |
| 3 | Skissen har en «Relevant»-avkrysning per periode og bare én sum, «Samlet beregnet relevant praksis». | **Vet ikke** | Forblir `@openquestion`. Skissen viser alternativ (1), et relevansflagg som filtrerer summen, men uten overlappssummer. Ikke besluttet. |
| 4 | Skissen viser ikke overlappsvarsel eller to summer, selv om eksempeldataene har overlapp. | **Kravene er riktige. Skissen er utdatert.** | Regelen om overlapp gjelder. Skissen bør oppdateres. |
| 5 | Summeringskortet viser «av 3,00 år påkrevd» og en sum i timer («1070 t av 1700 t påkrevd»). | **Begge riktige, ulikt scope** | Sammenligningen med det som er påkrevd dekkes av `@OPT-BEH-BEH-004`. Summen i timer finnes ikke i kravene; den står som åpent spørsmål. |
| 6 | Dialogen har feltet «Tilknyttet dokumentasjon (valgfri)». | **Begge riktige, ulikt scope** | Skissen viser målbildet. Feltet er `@could` og ikke med i første leveranse. |
| 7 | Tallene i eksempeldataene stemmer ikke: 01.01.2020–31.12.2020 i 100 % vises som 2,00 år (skal være 1,00), og årsverket er 1700 (standard er 1 650). | **Kravene er riktige. Skissen er utdatert.** | Tallene er illustrasjon og ikke fasit. Regnereglene og standardverdien 1 650 gjelder. |
| 8 | Skissen viser ikke hvem som opprettet og endret en periode, varselet ved manglende sluttdato eller feilmeldingene for datoer. | **Vet ikke** | Står som åpent spørsmål: skal disse tilstandene skisseres, eller dekkes de bare av kravene? |

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/registrere_praksis.feature` | `@OPT-BEH-BEH-003 @must @planned` | `@OPT-BEH-BEH-003 @must @in-progress` |

## Åpne spørsmål

Fra kravfila (`@openquestion`):

- [ ] Kan praksisperioder kopieres eller vises (lesbart) på tvers av saker på samme søknad, eller fra tidligere søknader? Er en kopi i så fall uavhengig av originalen?
- [ ] Skal saksbehandleren kunne markere en praksisperiode som relevant, og hvordan kombineres det med de to overlappssummene? Skissen viser alternativ (1): et relevansflagg som filtrerer summen (avvik 3).
- [ ] Hvordan regnes en delvis måned: restdager delt på 31, restdager delt på månedens lengde, eller hele perioden i dager delt på 365?
- [ ] Er registrert praksis og samlet beregning synlig for saksbehandlere uten rollen opptakssaksbehandler, eller er hele praksisseksjonen skjult?

Fra skissevalideringen (krav som må endres av `fs-krav`):

- [ ] Praksistype skal være valgfri. Scenarioet «Praksistype og startdato er obligatorisk» må endres (avvik 1).
- [ ] Arbeidsgiver skal være med som valgfritt felt på praksisperioden og vises i listen (avvik 2).

Fra skissevalideringen (uavklart):

- [ ] Skal kalkulatoren vise samlet praksis i timer i tillegg til i år (avvik 5)?
- [ ] Skal historikk (opprettet og endret av), varselet ved manglende sluttdato og feilmeldingene for datoer skisseres, eller dekkes de bare av kravene (avvik 8)?
- [ ] Skissen bør oppdateres med overlappsvarsel og to summer, og med riktige eksempeltall (avvik 4 og 7). Hvem eier oppdateringen?
