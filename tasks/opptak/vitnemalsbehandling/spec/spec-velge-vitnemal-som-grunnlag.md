# Spec: Velge vitnemål som grunnlag for poengberegningen

## Kilde

- **Oppgave:** `tasks/opptak/vitnemalsbehandling/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`
- **GitHub:** [#608](https://github.com/sikt-no/fs/issues/608) (leveranse L2 i initiativet [#607](https://github.com/sikt-no/fs/issues/607))
- **Hentet:** 2026-10-28 (HEAD `ef68c3a`)

## Omfang

Saksbehandleren velger ett vitnemål som grunnlag for poengberegningen i hele saken, slik at søkere med flere vitnemål blir poengberegnet. Poengene beregnes når saksbehandleren velger det, og endringen lagres først når beregningen er uten feil. Saksbehandleren kan legge inn karakter-, realfags- og språkpoeng selv, og poengene låses mot automatisk reberegning. Spesifikasjonen dekker ikke fagvalg per poengvariant (L3), manuell inntasting av fag (L4), sammenligning (L5) eller varsel om nytt vitnemål (L6). Selve poengberegningen hører til poengberegningen i opptak, ikke til dette kravet.

## Krav

- **`velge_vitnemål_som_grunnlag.feature`** (`@OPT-BEH-BEH-004`, `@must`) — valg og bytte av vitnemål (endringer hører til ett vitnemål og huskes), annullerte vitnemål og HUP, beregning når saksbehandleren velger det, lagring først ved feilfri beregning, advarsel om endringer som ikke er lagret, visning av poengene per poengvariant for sakens søknadsalternativer, poeng lagt inn for hånd med validering, låsing og opplåsing, og endringsrettighet per person. 20 scenarioer. ([krav/…/velge_vitnemål_som_grunnlag.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/velge_vitnem%C3%A5l_som_grunnlag.feature))

**Endret etter henting (28.10.2026, commit `42ebab7`):** Team Puff er tatt ut av kravet. Poengberegningen er kode i opptak i fs-plattform, og regelen «Poeng beregnes fra det valgte grunnlaget» viser til den automatiske poengberegningen (`@ref-OPT-BEH-BEH-018`). Ingen steg er endret.

**Endret etter henting (28.10.2026, `fs-krav`):** Scenarioet «Saksbehandler med kun leserettighet ser grunnlaget» er endret på stedet. Valg som viser en tilstand (radioknapper og avkrysningsbokser) vises deaktivert for en saksbehandler med bare leserettighet, mens handlinger og felt for å legge inn verdier skjules. Regelen gjelder hele vitnemålsbehandlingen, L1–L6, og står i `vitnemålsbehandling.md`.

Avklaringene fra gjennomgangen 21.10.2026 står som `AVKLART`-kommentarer i kravfila og i [vitnemålsbehandling.md](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vitnem%C3%A5lsbehandling.md). Kravet bygger på L1 ([spec-vise-elektroniske-vitnemal.md](spec-vise-elektroniske-vitnemal.md)).

## Skisser

### Skisse: Gjeldende skisser, «Nyeste skisser»

- **Type:** `figma`
- **Referanse:** [FS-Admin – Gjeldende skisser, seksjonen «Nyeste skisser»](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-45344), på siden «Vitnemålsbehandler». Hentet på nytt 2026-10-28.
- **Lagrede artefakter:**
  - [screenshot.png](krav-input/sketches/figma/gjeldende-skisser/screenshot.png)
  - [sub-frames/01-steg-2-grunnlag-behandle-e-vitnemal.png](krav-input/sketches/figma/gjeldende-skisser/sub-frames/01-steg-2-grunnlag-behandle-e-vitnemal.png)
  - [sub-frames/03-annullert-vitnemal.png](krav-input/sketches/figma/gjeldende-skisser/sub-frames/03-annullert-vitnemal.png)
  - [sub-frames/04-annullert-vitnemal-lagt-til-grunn-fra-for.png](krav-input/sketches/figma/gjeldende-skisser/sub-frames/04-annullert-vitnemal-lagt-til-grunn-fra-for.png)
  - [sub-frames/05-annullert-vitnemal-lagt-til-grunn-fra-for-kun-leserettighet.png](krav-input/sketches/figma/gjeldende-skisser/sub-frames/05-annullert-vitnemal-lagt-til-grunn-fra-for-kun-leserettighet.png)
- **Dekker krav:** `velge_vitnemål_som_grunnlag.feature`, reglene «Saksbehandleren velger hvilket vitnemål som legges til grunn» og «Poeng beregnes fra det valgte grunnlaget», og scenarioet «Saksbehandler med kun leserettighet ser grunnlaget».
  - **Stemmer:** én radioknapp per vitnemål, og tabellen «Kvalifisering og poengberegning» med KAR, REA og SPR per poengvariant.
  - **Stemmer:** et annullert vitnemål har ingen radioknapp og kan ikke velges («annullert vitnemål»).
  - **Stemmer:** et annullert vitnemål som er lagt til grunn fra før, har radioknappen valgt og deaktivert, taggen «Annullert», og advarselen over tabellen med teksten fra implementasjonsdetaljene (varianten fra L4, med «legg inn fagene manuelt»).
  - **Ulikt scope:** radioknapp per poengvariant og avkrysning per fag (L3), forbedrede karakterer og «Legg inn manuelt» (L4), «Tilleggsfag», «Spesielle opptakskrav» og sammenligning av vitnemål (L5).
- **Valideringsstatus:** `Avvik`, med tre funn:

| # | Avvik | Beslutning | Begrunnelse / konsekvens |
|---|---|---|---|
| 1 | Skissen viser «Endringer er lagret: 12:53» og ingen handling for å beregne poengene. Kravet sier at poengene beregnes når saksbehandleren velger det, at endringen lagres først når beregningen er uten feil, og at saksbehandleren advares om endringer som ikke er lagret. (Fra 2026-10-21, fortsatt ikke rettet.) | **Kravene er riktige. Skissen er utdatert.** | Skissen må få en handling for å beregne og advarselen om endringer som ikke er lagret. |
| 2 | «Poeng fra vitnemål» har feltene KAR opprinnelig, KAR med forbedring, Realfag, Språk og SUM, og de ser låst ut. Kravet sier at karakter-, realfags- og språkpoeng vises hver for seg per poengvariant, og at saksbehandleren kan legge dem inn selv. (Fra 2026-10-21, uendret.) | **Vet ikke** | Åpent spørsmål. |
| 3 | «… saksbehandler har kun leserettighet» viser radioknappene deaktivert. Kravet sier «Men jeg ser ikke muligheten til å endre dem», og mønsteret er at manglende tilgang skjuler elementet. | **Skissen er riktig. Kravet må endres.** (2026-10-28) | Kravet er endret samme dag med `fs-krav`, med begrunnelse, og regelen gjelder hele vitnemålsbehandlingen (se *Endret etter henting*). |

- **Ikke skissert:** tilstanden der et nytt vitnemål er valgt, men ikke beregnet, opplåsing av poeng, beskjeden om ugyldig verdi og beskjeden når poengberegningen feiler. Tekstene for de to siste tilstandene står delvis i implementasjonsdetaljene.

## Implementasjonsdetaljer

- **`velge_vitnemål_som_grunnlag.feature`** — [velge_vitnemål_som_grunnlag.design.md](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/velge_vitnem%C3%A5l_som_grunnlag.design.md) (8 åpne designspørsmål). Laget 2026-10-28, og oppdatert samme dag etter de nye skissene: radioknappen er valgt og deaktivert (ikke invalid), og radioknappene vises deaktivert ved leserettighet.

## Kodesjekk

Ikke sjekket: ingen kodekloner.

## Retagging

Ingen retagging. Kravet er allerede `@in-progress` (satt for hånd 2026-10-21 i commit `ccafff0`, rett fra `@draft`, etter beslutning i teamet), og telles som allerede i arbeid. Kravet har ikke vært `@planned` og er ikke validert med `fs-krav`.

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/velge_vitnemål_som_grunnlag.feature` | `@OPT-BEH-BEH-004 @must @in-progress` | uendret |

## Åpne spørsmål

- [x] **Krav mangler (skisseavvik 3), leserettighet:** Scenarioet «Saksbehandler med kun leserettighet ser grunnlaget» er endret 28.10.2026 med `fs-krav`. Valg vises deaktivert, handlinger og felt skjules, i hele vitnemålsbehandlingen.
- [ ] **Skisseavvik 2, poengfeltene:** Skal «Poeng fra vitnemål» ha SUM og KAR opprinnelig/med forbedring? Skal feltene kunne redigeres der, eller per poengvariant?
- [ ] **Skissen er utdatert (skisseavvik 1):** Beregn-handlingen og advarselen om endringer som ikke er lagret må skisseres. Det samme gjelder opplåsing av poeng.
- [ ] **Implementasjonsdetaljer delvis på plass:** Teksten på handlingen for å beregne, advarselen om endringer som ikke er lagret, beskjeden om ugyldig verdi og opplåsing mangler i `velge_vitnemål_som_grunnlag.design.md`.
- [ ] **Poeng lagt inn for hånd og ny beregning (fra domeneekspertene 22.10.2026):** Skal en verdi saksbehandleren har lagt inn selv, overskrives når saksbehandleren senere velger å beregne poengene på nytt? Scenariomalen «Legge inn <poengtype> selv på en poengvariant» er tagget `@openquestion`, og den detaljen må avklares før den bygges.
- [ ] **Kravelementene:** Ingen scenarioer sier at kravelementene vurderes ut fra vitnemålet som er valgt, selv om L2 skal la `vurderKravelementerAutomatisk` kjøre for søkere med flere vitnemål.
- [ ] **Vitnemål som annulleres etter at det er valgt:** Tilstanden er skissert, men har ikke eget scenario i kravet. Skal poengene fortsette å gjelde til saksbehandleren har beregnet på nytt? Skal en sak som er ferdig behandlet, åpnes igjen? Hører advarselen til L2 eller L6?
- [ ] **GSK og poeng:** Må vitnemålet for GSK og vitnemålet for poengberegningen være det samme?
- [ ] **Låse opp:** Hva låses opp (ett poeng, poengvarianten eller saken), og hva skjer med valget og endringene?
- [ ] **Poengberegningen i opptak:** et endepunkt som beregner fra et utpekt vitnemål, og grensene for gyldige verdier.

## Rute

fs-plattform → fs-admin
