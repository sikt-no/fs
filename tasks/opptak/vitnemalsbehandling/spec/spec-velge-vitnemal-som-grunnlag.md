# Spec: Velge vitnemål som grunnlag for poengberegningen

## Kilde

- **Oppgave:** `tasks/opptak/vitnemalsbehandling/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`
- **GitHub:** [#608](https://github.com/sikt-no/fs/issues/608) (leveranse L2 i initiativet [#607](https://github.com/sikt-no/fs/issues/607))
- **Hentet:** 2026-10-21 (HEAD `ccafff0`)

## Omfang

Saksbehandleren velger ett vitnemål som grunnlag for poengberegningen i hele saken, slik at søkere med flere vitnemål blir poengberegnet. Poengene beregnes av kontrollmotoren i opptak, og beregnes og lagres med en gang saksbehandleren velger et vitnemål. Saksbehandleren kan legge inn karakter-, realfags- og språkpoeng selv, og poengene låses mot automatisk reberegning. Spesifikasjonen dekker ikke fagvalg per poengvariant (L3), manuell inntasting av fag (L4), sammenligning (L5) eller varsel om nytt vitnemål (L6). Å beregne først når saksbehandleren sier at grunnlaget er klart, hører til L3.

**Endret 30.10.2026:** Poengberegningen er en del av opptak, ikke en ekstern tjeneste, og det finnes ikke noe eget endepunkt for den. «Endringen avvises når poengberegningen feiler» er fjernet fra kravet, og «Poengene er tomme til jeg beregner dem», «Beregne poengene fra det endrede grunnlaget» og «Advarsel om endringer som ikke er lagret» er flyttet til L3 (`velge_fag_per_poengvariant.feature`). Se 30.10.2026 i vitnemålsbehandling.md.

## Krav

- **`velge_vitnemål_som_grunnlag.feature`** (`@OPT-BEH-BEH-004`, `@must`) — valg og bytte av vitnemål (endringer hører til ett vitnemål og huskes), annullerte vitnemål og HUP, poeng som beregnes og lagres med en gang vitnemålet velges, visning av poengene per poengvariant for sakens søknadsalternativer, poeng lagt inn for hånd med validering, låsing og opplåsing, og endringsrettighet per person. 16 scenarioer. ([krav/…/velge_vitnemål_som_grunnlag.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/velge_vitnem%C3%A5l_som_grunnlag.feature))

Avklaringene fra gjennomgangen 21.10.2026 står som `AVKLART`-kommentarer i kravfila og i [vitnemålsbehandling.md](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vitnem%C3%A5lsbehandling.md). Kravet bygger på L1 ([spec-vise-elektroniske-vitnemal.md](spec-vise-elektroniske-vitnemal.md)).

## Skisser

### Skisse: Gjeldende skisser, steg 2

- **Type:** `figma`
- **Referanse:** [FS-Admin – Gjeldende skisser](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-45344)
- **Lagrede artefakter:**
  - [screenshot.png](krav-input/sketches/figma/gjeldende-skisser/screenshot.png)
  - [sub-frames/01-steg-2-grunnlag-vitnemalsbehandling.png](krav-input/sketches/figma/gjeldende-skisser/sub-frames/01-steg-2-grunnlag-vitnemalsbehandling.png)
- **Dekker krav:** `velge_vitnemål_som_grunnlag.feature`, reglene «Saksbehandleren velger hvilket vitnemål som legges til grunn» og «Poeng beregnes fra det valgte grunnlaget». Regelen om rettigheter er ikke skissert.
  - Stemmer: én radioknapp per vitnemål i tabellen «Vitnemål», og tabellen «Kvalifisering og poengberegning» med KAR, REA og SPR per poengvariant.
  - Ulikt scope: radioknapp per poengvariant og avkrysning per fag (L3), forbedrede karakterer og «Legg inn manuelt» (L4), «Tilleggsfag» og «Spesielle opptakskrav».
- **Valideringsstatus:** `Avvik`, med to funn:

| # | Avvik | Beslutning | Begrunnelse / konsekvens |
|---|---|---|---|
| 1 | Skissen viser «Endringer er lagret: 12:53» og ingen handling for å beregne poengene. Kravet sier at poengene beregnes når saksbehandleren velger det, at endringen lagres først når beregningen er uten feil, og at saksbehandleren advares om endringer som ikke er lagret. | **Kravene er riktige. Skissen er utdatert.** | Skissen må få en handling for å beregne og advarselen om endringer som ikke er lagret. Endret 30.10.2026: skissen stemmer med L2, der valget lagres med en gang. Beregn-handlingen og advarselen hører til L3. |
| 2 | «Poeng fra vitnemål» har feltene KAR opprinnelig, KAR med forbedring, Realfag, Språk og SUM, og de ser låst ut. Kravet sier at karakter-, realfags- og språkpoeng vises hver for seg per poengvariant, og at saksbehandleren kan legge dem inn selv. SUM og to KAR-felt står ikke i kravet. | **Vet ikke** | Åpent spørsmål. |

- **Ikke skissert:** opplåsing av poeng og beskjeden om ugyldig verdi.

## Implementasjonsdetaljer

Mangler. `velge_vitnemål_som_grunnlag.design.md` er ikke laget, og brukeren valgte å vente (se åpne spørsmål).

## Kodesjekk

Ikke sjekket: ingen kodekloner.

## Retagging

Ingen retagging i denne kjøringen. Kravet var allerede `@in-progress` (satt for hånd 21.10.2026 i commit `ccafff0`, rett fra `@draft`, etter beslutning i teamet), og telles som allerede i arbeid. Kravet har ikke vært `@planned` og er ikke validert med `fs-krav`.

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/velge_vitnemål_som_grunnlag.feature` | `@OPT-BEH-BEH-004 @must @in-progress` | uendret |

## Åpne spørsmål

- [ ] **Skisseavvik 2, poengfeltene:** Skal «Poeng fra vitnemål» ha SUM og KAR opprinnelig/med forbedring? Skal feltene kunne redigeres der, eller per poengvariant?
- [ ] **Skissen mangler opplåsing av poeng og beskjeden om ugyldig verdi.** Avvik 1 er løst 30.10.2026: beregn-handlingen og advarselen hører til L3.
- [ ] **Implementasjonsdetaljer mangler** for `velge_vitnemål_som_grunnlag.feature`: beskjeden om ugyldig verdi. Lages med `fs-implementasjonsdetaljer`.
- [ ] **Kravelementene:** Ingen scenarioer sier at kravelementene vurderes ut fra vitnemålet som er valgt, selv om L2 skal la `vurderKravelementerAutomatisk` kjøre for søkere med flere vitnemål.
- [ ] **Vitnemål som annulleres etter at det er valgt:** Poengene er låst og blir utdaterte til L6 er levert. Skal saksbehandleren varsles i L2?
- [ ] **GSK og poeng:** Må vitnemålet for GSK og vitnemålet for poengberegningen være det samme?
- [ ] **Låse opp:** Hva låses opp (ett poeng, poengvarianten eller saken), og hva skjer med valget og endringene?
- [ ] **Grensene for gyldige verdier:** skjemaet må få grensene (for eksempel taket på realfagspoeng) fra poengtypen i opptak.

## Rute

fs-plattform → fs-admin
