# Implementasjonsdetaljer: Plasstildelingsrunder i et opptak

**Relatert feature:** [`forvalte_runder.feature`](./forvalte_runder.feature)

## Overordnet UI-mønster

Plasstildelingsrundene ligger under opptaket i FS Admin. Oversikten over rundene står i [`listevisning_og_søk_i_plasstildelingsrunder.design.md`](./listevisning_og_søk_i_plasstildelingsrunder.design.md). Opptakets forvalter legger til en runde i en dialog («Opprett runde») fra oversikten, og endrer den i det samme skjemaet («Rediger runde») fra rundesiden.

## Komponenter og layout

Skjemaet for runden, i denne rekkefølgen:

1. **Navn** og **Svarfrist** på samme rad. Svarfristen er dato og klokkeslett.
2. **Rundetype**, en nedtrekksliste med Hovedtildeling, Supplering og Etterfylling, med hjelpetekst. Under listen står «Mer om rundetypen», en sammenfoldet tabell med de fem innstillingene fra rundetypen (se *Tekster*).
3. **Antall tillatte tilbud** (taket for antall tilbud per søker), et tallfelt. Det vises på alle rundetyper og er fylt ut med standardverdien for rundetypen.
4. **Åpen for ledige studieplasser**, en bryter. Den vises bare når opptaket tilbyr søknad på ledige studieplasser og rundetypen har innstillingen «Kan åpnes for ledige studieplasser».
5. **Antall tillatte tilbud på ledige studieplasser**, et tallfelt. Det vises når bryteren er slått på, og er fylt ut med 10.
6. **Periode for å endre antall tilbud**, en feltgruppe med Fra og Til (dato og klokkeslett).

Når runden er lagt til, er rundetypen låst (nedtrekkslisten er deaktivert, med hjelpeteksten for redigering).

## Interaksjonsmønstre

### Primærhandling
«Opprett» i dialogen for ny runde, «Lagre» i redigeringen. Feltene valideres når brukeren lagrer, og fokus flyttes til første felt med feil.

### Sekundære handlinger
- «Avbryt» lukker skjemaet uten å lagre.
- «Slett runde» på rundesiden, bare for runder som ikke er publisert til søker. Valget er skjult for publiserte runder. Sletting av flere runder står i oversikten.

### Navigasjon
Fra oversikten over plasstildelingsrunder til rundesiden. Lærestedet kan bare åpne runden der perioden for å endre antall tilbud er åpen. I en runde med stengt periode er navigasjonen merket med en lås, og lærestedet får en forklaring (se *Tekster*).

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Tom | Opptaket har ingen runder: oversikten viser tom tilstand, og den første runden må være hovedtildelingen |
| Laster | Skjemaet vises når runden og opptaket er lastet |
| Feil | Feilmelding under feltet, feltet markeres som ugyldig, og fokus flyttes til første felt med feil |
| Suksess | Kvittering: «Runden er opprettet.» eller «Endringene er lagret.» |

## Tekster

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Navn | Plassholder | «For eksempel suppleringsrunde» | – | Legge til første plasstildelingsrunde |
| Navn | Navn mangler | «Navn mangler.» | – | Plasstildelingsrunde mangler obligatorisk opplysning |
| Navn | Navnet er brukt i opptaket fra før | «Opptaket har allerede en runde med navnet «{navn}». Velg et annet navn.» | `{navn}` | Navnet er brukt i opptaket fra før |
| Navn | Navnet er lengre enn 100 tegn | «Navnet kan være høyst 100 tegn.» | – | Navnet er for langt |
| Svarfrist | Svarfrist mangler | «Svarfrist mangler.» | – | Plasstildelingsrunde mangler obligatorisk opplysning |
| Svarfrist | Svarfristen er før perioden er slutt | «Svarfristen må komme etter at perioden for å endre antall tilbud er slutt.» | – | Svarfristen kommer før perioden er slutt |
| Svarfrist, Fra, Til | Ugyldig dato eller klokkeslett | «Ugyldig tidspunkt. Skriv dato og klokkeslett som dd.mm.åååå tt:mm, med timer fra 00 til 23 og minutter fra 00 til 59.» | – | Sette periode for å endre antall tilbud som skal gis |
| Rundetype | Hjelpetekst, første runde i opptaket | «Den første runden i et opptak må være hovedtildelingen.» | Supplering og etterfylling kan ikke velges | Rundetype som bygger på forrige plasstildelingsrunde, kan ikke være først |
| Rundetype | Hjelpetekst, opptaket har hovedtildeling | «Opptaket har allerede en hovedtildeling. Du kan legge til supplering eller etterfylling.» | Hovedtildeling kan ikke velges | Rundetype som bare kan finnes én gang |
| Rundetype | Hjelpetekst, redigering | «Rundetypen kan ikke endres. Er den feil, må du slette runden og legge til en ny.» | – | Endre rundetype på eksisterende plasstildelingsrunde |
| Rundetype | Rundetype mangler | «Rundetype mangler.» | – | Plasstildelingsrunde mangler obligatorisk opplysning |
| Mer om rundetypen | Tabell med innstillingene | «Tilbud gir bortfall på lavere prioriteter», «Kompensasjonstilbud ved opprykk», «Bygger på forrige publiserte plasstildelingsrunde», «Bare én i opptaket», «Kan åpnes for ledige studieplasser» | Verdien «Ja» eller «Nei» per rundetype | Se innstillingene på plasstildelingsrunden |
| Antall tillatte tilbud | Hjelpetekst | «Antall tilbud søker kan motta i denne runden.» | Standardverdi 1 i hovedtildeling og supplering, 10 i etterfylling | Standardverdi for taket for antall tilbud per søker |
| Antall tillatte tilbud | Feltet er tomt | «Antall tillatte tilbud mangler.» | – | Endre taket for antall tilbud per søker |
| Antall tillatte tilbud (begge) | Ikke et helt tall på 1 eller mer | «Skriv et helt tall på 1 eller mer.» | – | Endre taket for antall tilbud per søker |
| Åpen for ledige studieplasser | Hjelpetekst | «Åpner runden for tilbud til nye studieplasser.» | – | Åpne plasstildelingsrunden for ledige studieplasser |
| Antall tillatte tilbud på ledige studieplasser | Hjelpetekst | «Antall tilbud på ledige studieplasser søker kan motta i denne runden, i tillegg til de ordinære tilbudene.» | Standardverdi 10 | Standardverdi for taket for antall tilbud på ledige studieplasser per søker |
| Antall tillatte tilbud på ledige studieplasser | Feltet er tomt | «Antall tillatte tilbud på ledige studieplasser mangler.» | – | Endre taket for antall tilbud på ledige studieplasser per søker |
| Periode for å endre antall tilbud | Hjelpetekst | «Lærestedene kan endre antall tilbud i denne perioden. Forvaltende organisasjon kan alltid endre.» | – | Sette periode for å endre antall tilbud som skal gis |
| Periode for å endre antall tilbud | Bare fra eller bare til er satt | «Sett både fra og til, eller la begge stå tomme.» | – | Sette periode for å endre antall tilbud som skal gis |
| Periode for å endre antall tilbud | Fra er etter til | «Fra-tidspunktet må komme før til-tidspunktet.» | – | Sette periode for å endre antall tilbud som skal gis |
| Skjema, redigering | Runden er publisert | «Runden er publisert. Endrer du svarfristen, gjelder den nye fristen også søkere som allerede har fått tilbud. Svarfristen brukes vanligvis til å utsette.» | – | Endre navn og svarfrist på en plasstildelingsrunde |
| Kvittering | Runden er lagt til eller endret | «Runden er opprettet.» / «Endringene er lagret.» | Ny eller endret | Legge til første plasstildelingsrunde |
| Dialog for sletting | Opptakets forvalter sletter én runde | Tittel «Slette runde», tekst «Runden «{navn}» og innstillingene på den blir fjernet. Dette kan ikke angres.», knapper «Avbryt» og «Slett runde» | `{navn}` | Slette en plasstildelingsrunde som ikke er publisert |
| Kvittering | Runden er slettet | «Runden «{navn}» er slettet.» | `{navn}` | Slette en plasstildelingsrunde som ikke er publisert |
| Status på runden | Alltid | «Ikke publisert» / «Publisert for søkere» | Etter om runden er publisert | Plasstildelingsrunde som ikke er publisert / som er publisert |
| Lærestedets oppgave | Per runde, for lærestedet | «Perioden er ikke satt ennå» / «Perioden åpner {fra}» / «Gå gjennom antall tilbud» / «Perioden for å gå gjennom antall tilbud er utløpt» | Etter perioden. `{fra}` er dato og klokkeslett | Lærestedet ser hva det skal gjøre i plasstildelingsrunden |
| Lærestedets oppgave, undertekst | Perioden er åpen | «Se gjennom antall tilbud for utdanningstilbudene dere tilbyr, og endre ved behov. Frist {til}.» | `{til}` | Lærestedet ser hva det skal gjøre i plasstildelingsrunden |
| Lærestedets oppgave, undertekst | Perioden er utløpt | «Kontakt opptakets forvalter hvis noe må endres.» | – | Lærestedet ser hva det skal gjøre i plasstildelingsrunden |
| Låst runde, forklaring | Lærestedet prøver å åpne en runde der perioden er stengt | «Perioden for å endre antall tilbud er ikke satt ennå.» / «Perioden for å endre antall tilbud er ikke åpnet ennå.» / «Perioden for å endre antall tilbud er utløpt. Du kan ikke se detaljene i runden.» | Etter perioden | Lærestedet kan ikke åpne plasstildelingsrunden der perioden er stengt |
| Låst runde, skjermleser | Navigasjonen i en stengt runde | «Runden er ikke åpen: {navn}» | `{navn}` | Lærestedet kan ikke åpne plasstildelingsrunden der perioden er stengt |

**Skisser:** prototypen v88, [`tasks/opptak/plasstildeling-2027/spec/krav-input/sketches/plasstildeling-prototype-v88.html`](../../../../tasks/opptak/plasstildeling-2027/spec/krav-input/sketches/plasstildeling-prototype-v88.html). Tekstene er sjekket mot den 2026-11-04.

Tekster som ikke står i prototypen, og som er lagt til her:
- Feilmeldingene for navnet (avklart med produkteier 2026-11-04).
- Etiketten, hjelpeteksten og feilmeldingen for taket for ledige studieplasser (avklart med produkteier 2026-11-04, laget som teksten for det ordinære taket).
- Forklaringen «Perioden for å endre antall tilbud er ikke satt ennå.», utledet fra oppgaven i kravet.
- Undertekstene til oppgaven er justert: prototypen sier «dine utdanningstilbud» og «marker som gjennomgått». Markeringen hører til `@OPT-PLA-INN-004` (Could), og er ikke med.

Tekster i prototypen som ikke er med:
- «Venter på at forvalter åpner runden» og undertekstene «Du får varsel …». Varsling av lærestedene er ikke en forutsetning for å åpne runden, og hører til `@OPT-PLA-INN-004` (Could).
- «Du har gått gjennom antall tilbud» og «Du gikk gjennom antall tilbud». Markeringen hører til `@OPT-PLA-INN-004` (Could).
- «Runden er publisert. Detaljene er ikke tilgjengelige for lærestedet.» Kravet styrer lærestedets tilgang med perioden, ikke med publiseringen.
- Feltet «Påminnelse om svarfrist sendes». Påminnelsen hører til `@OPT-PLA-SVA-002` (Should), og er ikke med.
- «Søker kan ha flere tilbud samtidig» og «Frigjort plass ved opprykk gis til neste på ventelisten» i tabellen over innstillingene. Innstillingene heter som i kravet.

## Per-scenario detaljer

### Scenario: Rundetype som bare kan finnes én gang
Hovedtildeling kan ikke velges i nedtrekkslisten når opptaket har en hovedtildeling, og hjelpeteksten sier hvorfor. Backend avviser også en ny hovedtildeling.

### Scenario: Rundetype som bygger på forrige plasstildelingsrunde, kan ikke være først
I et opptak uten runder er bare Hovedtildeling valgbar, og den er valgt.

### Scenariomal: Standardverdi for taket for antall tilbud per søker
Feltet «Antall tillatte tilbud» vises på alle rundetyper (prototypen viser det bare i etterfylling, og er utdatert). Standardverdien settes når rundetypen velges.

### Scenariomal: Se innstillingene på plasstildelingsrunden
Innstillingene vises som en tabell med «Ja»/«Nei», både i skjemaet («Mer om rundetypen») og på rundesiden. De kan ikke endres.

### Scenario: Lærestedet kan ikke åpne plasstildelingsrunden der perioden er stengt
Raden vises i oversikten, men navigasjonen er merket med en lås og er ikke aktiv (`aria-disabled`). Velger lærestedet raden, vises forklaringen som en advarsel.

## Åpne designspørsmål

- [ ] Prototypen v88 må rettes: taket for antall tilbud per søker på alle runder, feltet for taket for ledige studieplasser, innstillingene fra kravet og at varsling ikke er en forutsetning for å åpne runden.
