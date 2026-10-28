# Implementasjonsdetaljer: Velge vitnemål som grunnlag for poengberegningen

**Relatert feature:** [`velge_vitnemål_som_grunnlag.feature`](./velge_vitnemål_som_grunnlag.feature)

## Overordnet UI-mønster

Seksjonen «Vitnemålsbehandling» i steg 2 «Grunnlag» i saksbehandlingen i FS Admin. L2 bygger på tabellen «Vitnemål» fra L1 ([`vise_elektroniske_vitnemål.feature`](./vise_elektroniske_vitnemål.feature)), og legger til valget av vitnemål og poengene per poengvariant under tabellen («Kvalifisering og poengberegning» og «Poeng fra vitnemål»).

## Komponenter og layout

- **Tabellen «Vitnemål»:** én rad per vitnemål, med en radioknapp først i raden. Kolonnene er Vitnemålsnummer (lenke som åpner vitnemålet i ny fane), Utstedt dato, GSK, Første, KAR, REA og SPR. Den siste raden er «Legg inn manuelt» (L4).
- **Kolonnebredder:** kolonnen Vitnemålsnummer er bred nok til nummeret, lenkeikonet og taggen «Annullert» på én linje. GSK og Første er ikke bredere enn overskriften krever.
- **Advarsel:** når det er nødvendig, står en advarsel (SDS, gul, med varselikon) mellom seksjonsoverskriften «Vitnemål» og tabellen. Første setning er uthevet.
- **Tabellen «Kvalifisering og poengberegning»:** én rad per poengvariant for søknadsalternativene i saken, med KAR, REA og SPR hver for seg.

## Interaksjonsmønstre

### Primærhandling

Velge vitnemål med radioknappen i tabellen «Vitnemål», og så beregne poengene. Valget lagres først når poengene er beregnet uten feil. Fram til da står poengfeltene tomme.

### Sekundære handlinger

- Legge inn karakterpoeng, realfagspoeng eller språkpoeng selv på en poengvariant.
- Låse opp et poeng.
- Åpne et vitnemål i ny fane fra vitnemålsnummeret.

### Navigasjon

Saksbehandleren kommer hit fra steg 2 «Grunnlag» i saksbehandlingen. Går saksbehandleren fra saken med endringer som ikke er lagret, vises advarselen om endringer som ikke er lagret.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Ingen vitnemål valgt | Ingen radioknapp er valgt. Poengfeltene er tomme. |
| Vitnemål valgt, ikke beregnet | Den nye radioknappen er valgt. Poengfeltene er tomme. Endringen er ikke lagret. |
| Beregnet og lagret | Poengene vises per poengvariant. |
| Beregningen feiler | Det lagrede grunnlaget er uendret. Feilmeldingen vises ved handlingen for å beregne. |
| Annullert vitnemål, ikke valgt | Raden har ingen radioknapp. Taggen «Annullert» står etter vitnemålsnummeret. Teksten i resten av raden er grå. Poengene står fortsatt. |
| Annullert vitnemål er det valgte | Radioknappen er valgt og deaktivert. Taggen «Annullert» står etter vitnemålsnummeret. Raden er ikke grå, fordi poengene fortsatt bygger på den. Advarselen står over tabellen. |
| Annullert vitnemål er det valgte, nytt vitnemål valgt, ikke beregnet | Den nye radioknappen er valgt. Den annullerte raden beholder radioknappen til beregningen er lagret, så valget kan angres. Advarselen bytter tekst (se `## Tekster`). |
| Annullert vitnemål er byttet ut, og beregningen er lagret | Advarselen forsvinner. Den annullerte raden får tilstanden «Annullert vitnemål, ikke valgt». |
| Bare leserettighet | Alle radioknapper og avkrysningsbokser vises deaktivert, også «Legg inn manuelt». Ingen handling for å beregne, ingen felt for å legge inn poeng: de lagrede verdiene vises som tekst. Advarselen vises uten handlingsoppfordring. |
| HUP | Ingen radioknapper og ingen poengfelt. Vitnemålene vises (L1). |

## Tekster

Hjelpetekster, feilmeldinger, bekreftelser og andre tekster med variasjoner. Dette er fasiten for tekstene, også når en skisse viser noe annet.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Tabellen «Vitnemål», etter vitnemålsnummeret | Vitnemålet er annullert, og er brukt i en beregning på opptaket | «Annullert» (tag med varselikon) | Samme tag både når vitnemålet er valgt og når det ikke er det | Et annullert vitnemål kan ikke legges til grunn |
| Advarsel over tabellen «Vitnemål» | Det valgte vitnemålet er annullert. Saksbehandleren har endringsrettighet, og søkeren har minst ett vitnemål som ikke er annullert | «**Poengene bygger på et vitnemål som er annullert.** Velg et annet vitnemål og beregn poengene på nytt.» | Fra L4: «**Poengene bygger på et vitnemål som er annullert.** Velg et annet vitnemål eller legg inn fagene manuelt, og beregn poengene på nytt.» | Et annullert vitnemål kan ikke legges til grunn |
| Advarsel over tabellen «Vitnemål» | Det valgte vitnemålet er annullert, og saksbehandleren har bare leserettighet | «**Poengene bygger på et vitnemål som er annullert.**» | – | Saksbehandler med kun leserettighet ser grunnlaget |
| Advarsel over tabellen «Vitnemål» | Det valgte vitnemålet er annullert, og søkeren har ingen andre vitnemål som ikke er annullert | «**Poengene bygger på et vitnemål som er annullert.** Søkeren har ingen andre elektroniske vitnemål som kan legges til grunn.» | Fra L4: «**Poengene bygger på et vitnemål som er annullert.** Legg inn fagene manuelt og beregn poengene på nytt.» | Et annullert vitnemål kan ikke legges til grunn |
| Advarsel over tabellen «Vitnemål» | Det valgte vitnemålet er annullert, og saksbehandleren har valgt et annet vitnemål, men ikke beregnet | «**Poengene bygger fortsatt på et vitnemål som er annullert.** Beregn poengene for å lagre det nye valget.» | – | Poengene er tomme til jeg beregner dem |
| Ved handlingen for å beregne | Beregningen feiler eller poengberegningen svarer ikke | «**Poengene kunne ikke beregnes.** Endringen er ikke lagret. Prøv igjen senere.» | Er det valgte vitnemålet annullert, står advarselen over tabellen i tillegg, med teksten «Poengene bygger på et vitnemål som er annullert. Velg et annet vitnemål …», fordi det lagrede grunnlaget er uendret | Endringen avvises når poengberegningen feiler |

**Skisser:**

- Figma «FS-Admin – Gjeldende skisser», steg 2 ([node 5163-45344](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-45344)), lagret i [`tasks/opptak/vitnemalsbehandling/spec/krav-input/sketches/figma/gjeldende-skisser/`](../../../../tasks/opptak/vitnemalsbehandling/spec/krav-input/sketches/figma/gjeldende-skisser/).
- Rammene «annullert vitnemål», «annullert vitnemål lagt til grunn fra før» og «annullert vitnemål lagt til grunn fra før, saksbehandler har kun leserettighet» i samme seksjon, laget og hentet 28.10.2026.

Tekstene for annullerte vitnemål er avklart med designeren 28.10.2026. Det lages ikke egne skisser for hver variant: skissen viser hvor advarselen og taggen står, og tabellen over har alle variantene.

## Per-scenario detaljer

### Scenario: Et annullert vitnemål kan ikke legges til grunn

Kravet sier at muligheten til å legge det annullerte vitnemålet til grunn ikke vises. Er vitnemålet ikke valgt, har raden derfor ingen radioknapp. Cellen står tom, så kolonnene fortsatt står på linje.

Er det annullerte vitnemålet allerede valgt, vises radioknappen valgt og deaktivert, sammen med advarselen over tabellen (skissen «annullert vitnemål lagt til grunn fra før»). Radioknappen skal peke på advarselen med `aria-describedby`, så skjermlesere leser grunnen. Når saksbehandleren har byttet vitnemål og beregningen er lagret, forsvinner radioknappen på den annullerte raden, og vitnemålet kan ikke velges igjen.

### Scenario: Poengene er tomme til jeg beregner dem

Poengfeltene står tomme fra et nytt vitnemål er valgt til poengene er beregnet. Tomme felt brukes også når poengberegningen ikke svarer i L1, så det er teksten ved feltene eller advarselen som forteller hvorfor de er tomme.

### Scenario: Saksbehandler med kun leserettighet ser grunnlaget

Regelen gjelder hele vitnemålsbehandlingen, L1–L6 (avklart 28.10.2026, se `vitnemålsbehandling.md`):

- **Vises deaktivert:** valg som viser en tilstand, det vil si radioknapper og avkrysningsbokser. I L2 er det radioknappen per vitnemål og «Legg inn manuelt». Fra L3 og L4 gjelder det samme for radioknappen per poengvariant og avkrysningsboksene for fag og tilleggsfag.
- **Skjules:** handlinger (handlingen for å beregne, låse opp, legge til fag) og felt for å legge inn eller endre verdier. De lagrede verdiene vises som tekst.

Dette avviker bevisst fra mønsteret i `.claude/rules/design-patterns-for-krav.md` om å skjule, ikke deaktivere: valgene er informasjon, fordi de viser hva poengene bygger på, og siden ser lik ut for alle. Advarselen vises, men bare med første setning, fordi saksbehandleren ikke kan gjøre det den ber om.

## Åpne designspørsmål

- [x] **Leserettighet:** Avklart 28.10.2026. Valg vises deaktivert, handlinger og felt skjules, i hele vitnemålsbehandlingen. Scenarioet «Saksbehandler med kun leserettighet ser grunnlaget» er endret, med begrunnelse.
- [ ] **Skissen er utdatert:** «Endringer er lagret: 12:53» i steg 2 stemmer ikke med kravet. Endringer lagres først når poengene er beregnet uten feil. Skissen mangler handlingen for å beregne og advarselen om endringer som ikke er lagret.
- [ ] **Teksten på handlingen for å beregne** er ikke bestemt.
- [ ] **Advarselen om endringer som ikke er lagret** (scenario «Advarsel om endringer som ikke er lagret») er ikke skissert, og teksten er ikke bestemt. Det er heller ikke bestemt hva «går fra saken» omfatter: «Åpne neste sak», bytte steg, lukke fanen.
- [ ] **Beskjeden om ugyldig verdi** for realfagspoeng og språkpoeng (scenariomalen «Ugyldig verdi for <poengtype> stoppes») er ikke bestemt. Grensene kommer fra poengberegningen i opptak.
- [ ] **Opplåsing av poeng** (scenario «Låse opp et poeng») er ikke skissert, og teksten er ikke bestemt.
- [ ] **Poengfeltene i «Poeng fra vitnemål»:** Skissen har KAR opprinnelig, KAR med forbedring, Realfag, Språk og SUM, og feltene ser låst ut. Kravet har karakterpoeng, realfagspoeng og språkpoeng per poengvariant, som saksbehandleren kan legge inn selv. Åpent spørsmål i spesifikasjonen for L2.
- [ ] **Tilstanden der det valgte vitnemålet er annullert** har ikke et eget scenario i kravet. Den bygger på åpne spørsmål i spesifikasjonen: om poengene skal fortsette å gjelde, om en sak som er ferdig behandlet skal åpnes igjen, og om advarselen hører til L2 eller L6.
- [ ] **Annulleringsdato:** Skal det vises når vitnemålet ble annullert? I så fall i et verktøytips på taggen, ikke i advarselen.
