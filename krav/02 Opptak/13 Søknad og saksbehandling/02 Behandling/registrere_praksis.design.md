# Implementasjonsdetaljer: Registrere og beregne praksis for søker

**Relatert feature:** [`registrere_praksis.feature`](./registrere_praksis.feature)

## Overordnet UI-mønster

Praksiskalkulatoren er en side i FS Admin med sidelayout-mønsteret («Sidelayout i FS Admin - Pattern»): brødsmuler, sidetittel «Praksiskalkulator», ett kort med registrerte praksisperioder og to summkort under. Registrering og redigering skjer i et skjema som åpnes som sidepanel til høyre (eller som dialog).

Praksisperiodene hører til saken (se kravet). Kalkulatoren er en egen side for én sak, og åpnes fra saksvisningen (`opptak/[id]/soknadsbehandling/sak/[sakId]` i fs-admin). Siden viser hvilken søker og sak den gjelder. Skissen viser brødsmuler til opptaket, men ikke søker eller sak (avklart 07.10.2026).

## Komponenter og layout

1. **Kort «Registrerte praksisperioder»**, med antall under tittelen.
2. **Tabell** med én rad per praksisperiode:

   | Kolonne | Innhold |
   |---|---|
   | Arbeidsgiver/praksistype | Arbeidsgiver (fet) og praksistype som «KODE – navn» under. Begge kan mangle |
   | Periode | «DD.MM.ÅÅÅÅ–DD.MM.ÅÅÅÅ», med varselikon når perioden overlapper en annen inkludert periode |
   | Omfang | Stillingsprosent eller timer, se *Tekster* |
   | Beregnet praksis | År med to desimaler, avkortet nedover |
   | Inkluder | Avkrysningsboks |
   | Handlinger | «Rediger» og «Slett» |

3. **Varsel** (advarsel, gul) under tabellen når inkluderte perioder overlapper.
4. **To summkort**: «Sum av oppgitte perioder» og «Justert for overlapp», med verdien i år.
5. **Skjema «Legg til praksisperiode»** (sidepanel/dialog), i denne rekkefølgen:
   - «Beregningsgrunnlag»: segmentert valg «Stillingsprosent» / «Timer i perioden». Stillingsprosent er valgt som standard.
   - «Startdato» og «Sluttdato»: datofelt med kalender, side om side.
   - Omfang: «Omfang (Stillingsprosent)» med «%», eller feltene for timer (se *Åpne designspørsmål*).
   - «Beregnet varighet»: viser fortløpende hva perioden gir, «= {x} år».
   - «Arbeidsgiver (valgfri)»: tekstfelt.
   - «Praksistype (valgfri)»: nedtrekksliste med alle praksistyper som gjelder for søkere.
   - Knapper: «Avbryt» og «Bekreft».

## Interaksjonsmønstre

### Primærhandling
Registrere en praksisperiode: skjemaet fylles ut og lagres med «Bekreft». Perioden legges i tabellen, er inkludert som standard, og summene oppdateres.

### Sekundære handlinger
- «Rediger» på raden åpner skjemaet med verdiene til perioden.
- «Slett» på raden sletter perioden.
- «Inkluder» slås av og på direkte i tabellen. Summene og overlappsvarselet oppdateres med en gang.
- «Avbryt» lukker skjemaet uten å lagre.

### Navigasjon
Siden åpnes fra saksvisningen, og gjelder den saken. Brødsmulene går tilbake til saken. Nøyaktig plassering av inngangen i saksvisningen er et åpent spørsmål.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Tom | Ingen perioder: se *Åpne designspørsmål* |
| Laster | Standard lasteindikator for kort og tabell |
| Feil (validering) | Feltet markeres rødt, med feilmeldingen under. Perioden lagres ikke |
| Overlapp | Varselikon på periodene som overlapper, og varsel under tabellen |
| Suksess | Perioden står i tabellen, og summene er oppdatert |

## Tekster

Hjelpetekster, feilmeldinger, bekreftelser og andre tekster med variasjoner. Dette er fasiten for tekstene, også når en skisse viser noe annet.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Kort «Registrerte praksisperioder» | Alltid | «{antall} registrerte perioder» | Entall og 0, se *Åpne designspørsmål* | Se registrerte praksisperioder |
| Tabell, Omfang | Omfang i stillingsprosent | «{prosent}%» | – | Se registrerte praksisperioder |
| Tabell, Omfang | Omfang i timer | «{timer} timer (av {timer per årsverk})» | – | Se registrerte praksisperioder, Antall timer per årsverk oppgis per praksisperiode |
| Tabell, Beregnet praksis | Alltid | «{år} år» | To desimaler, avkortet nedover | Summen avkortes til to desimaler i visningen |
| Varsel under tabellen | Inkluderte perioder overlapper, og samlet omfang er 100 % eller mindre | «Du har {antall} perioder som overlapper ({fra}–{til}).» | `{antall}` med bokstaver (to, tre …) | Overlappende praksisperioder varsles |
| Varsel under tabellen | Inkluderte perioder overlapper med samlet omfang over 100 % | «Du har {antall} perioder som overlapper med et samlet omfang >100% ({fra}–{til}). Omfang over 100% blir ikke tatt med i beregningen.» | `{antall}` med bokstaver (to, tre …) | Justert sum kan ikke overstige kalendertiden i perioden |
| Summkort | Alltid | «Sum av oppgitte perioder» / «{år} år» | – | Både oppgitt og justert sum vises ved overlapp |
| Summkort | Alltid | «Justert for overlapp» / «{år} år» | – | Både oppgitt og justert sum vises ved overlapp |
| Skjema, «Beregnet varighet» | Mens skjemaet fylles ut | «= {år} år» | Tom verdi før datoer og omfang er fylt ut | Praksis beregnes proporsjonalt med stillingsprosenten |
| Skjema, Startdato/Sluttdato | Plassholder | «DD.MM.ÅÅÅÅ» | – | – |
| Skjema, Praksistype | Plassholder | «Valg» | – | Velge praksistype for en praksisperiode |
| Skjema, Startdato | Startdato mangler | «Oppgi startdato.» | – | Startdato og sluttdato er obligatorisk |
| Skjema, Sluttdato | Sluttdato mangler | «Oppgi sluttdato.» | – | Praksisperiode uten sluttdato kan ikke lagres |
| Skjema, Sluttdato | Sluttdato før startdato | «Sluttdatoen kan ikke være før startdatoen.» | – | Sluttdato før startdato kan ikke lagres |
| Skjema, Startdato/Sluttdato | Datoen finnes ikke | «Oppgi en gyldig dato, for eksempel 01.07.2022.» | – | Ugyldig dato kan ikke lagres |
| Skjema, Omfang (stillingsprosent) | Utenfor 0–100 % | «Oppgi en stillingsprosent fra 0 til 100.» | – | Stillingsprosent utenfor 0–100 % kan ikke lagres |
| Skjema, antall timer | Timer mangler | «Oppgi antall timer i perioden.» | – | Praksisperiode med omfang i timer kan ikke lagres uten antall timer |
| Skjema, antall timer | 0 eller færre timer | «Antall timer må være mer enn 0.» | – | Antall timer på 0 eller mindre kan ikke lagres |
| Skjema, antall timer | Timene gir mer enn kalendertiden | «Antall timer kan ikke gi mer praksis enn perioden fra startdato til sluttdato.» | Gjelder også når datoene eller antall timer per årsverk endres | Timer som gir mer praksis enn kalendertiden i perioden, kan ikke lagres; Endring som gir mer praksis enn kalendertiden i perioden, kan ikke lagres |

**Skisser:** Figma «Nyeste skisser», [node 20747-108803](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20747-108803), persistert i [`tasks/opptak/registrere-praksis/spec/krav-input/sketches/figma/nyeste-skisser/`](../../../../tasks/opptak/registrere-praksis/spec/krav-input/sketches/figma/nyeste-skisser/design-context.md). Tekstene om overlapp under 100 %, summkortet, stillingsprosenten og timefeilene er avklart 07.10.2026 og står ikke i skissene. Feilmeldingen under omfangsfeltet i skisse 05 («Oppgi en gyldig dato, …») er en kopifeil i skissen.

## Per-scenario detaljer

### Scenario: Se registrerte praksisperioder
Arbeidsgiver og type står i samme kolonne, og startdato og sluttdato i kolonnen «Periode». Feltene i kravet er de samme.

### Scenario: Inkludere en praksisperiode i praksisberegningen
Avkrysningsboksen «Inkluder» står i tabellen, ikke i skjemaet. En ny periode er avkrysset.

### Scenario: Omfanget oppgis på én av måtene per praksisperiode
Det segmenterte valget «Beregningsgrunnlag» bytter mellom feltene. Bare feltene for det valgte grunnlaget vises.

### Scenario: Overlappende praksisperioder varsles
Varselikonet står ved perioden i hver rad som overlapper, og varselet under tabellen viser tidsrommet for overlappet.

### Scenario: Summen avkortes til to desimaler i visningen
Gjelder både «Beregnet praksis» i tabellen, summkortene og «Beregnet varighet» i skjemaet.

## Åpne designspørsmål

- [ ] Hvor inngangen til praksiskalkulatoren står i saksvisningen, og hvordan søker og sak vises på siden. Skissen viser ikke det.
- [ ] Timevarianten av skjemaet er ikke skissert: etiketter for antall timer i perioden og antall timer per årsverk (forhåndsutfylt 1 650), og plasseringen av dem.
- [ ] Tekst for én periode («1 registrert periode»?) og tom tilstand når saken ikke har praksisperioder.
- [ ] Skal «Slett» bekreftes før perioden slettes?
- [ ] Er «Ullevål sykehus» i arbeidsgiverfeltet en plassholder eller bare eksempelverdi i skissen?
- [ ] Skisse 05 har en kopifeil (datofeilmelding under omfangsfeltet). Skissen bør rettes i Figma.
