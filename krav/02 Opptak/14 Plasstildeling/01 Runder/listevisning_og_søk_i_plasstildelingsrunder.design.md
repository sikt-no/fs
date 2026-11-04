# Implementasjonsdetaljer: Listevisning og søk i plasstildelingsrunder

**Relatert feature:** [`listevisning_og_søk_i_plasstildelingsrunder.feature`](./listevisning_og_søk_i_plasstildelingsrunder.feature)

## Overordnet UI-mønster

Listevisning etter FS Admin-mønsteret (`.claude/rules/listevisning-pattern.md`), under opptaket. Én rad per plasstildelingsrunde, med søk og filter i et filterpanel, sortering over listen og «Last inn flere» under listen.

## Komponenter og layout

Kolonnene, i denne rekkefølgen:

| Kolonne | Innhold |
|---|---|
| Runde | Navnet |
| Rundetype | Hovedtildeling, Supplering eller Etterfylling. Under står merket «Ledige studieplasser» når runden er åpnet for ledige studieplasser |
| Periode for å endre antall tilbud | Fra–til med dato og klokkeslett, eller «Ikke satt». Under står merket for perioden: «Ikke satt», «Åpner», «Åpen» eller «Utløpt» |
| Svarfrist | Dato og klokkeslett |
| Status | «Ikke publisert» eller «Publisert for søkere» |
| Oppgave | Lærestedets oppgave i runden, med merket for oppgaven. Vises for opptakets forvalter og for lærestedet |

Over listen: antall treff («{n} runder i listen»), sortering og de valgte filtrene som merker. For opptakets forvalter: «Opprett» og «Handlinger» (sletting av flere runder), og en avkrysningsboks per rad og for alle radene.

Filterpanelet har fire felt: søk på navn («Runde»), «Rundetype», «Status» og «Periode», og «Tøm filter».

## Interaksjonsmønstre

### Primærhandling
Velge en rad åpner rundesiden. For lærestedet bare når perioden er åpen (se [`forvalte_runder.design.md`](./forvalte_runder.design.md)).

### Sekundære handlinger
- «Opprett» åpner dialogen for ny runde (opptakets forvalter).
- «Handlinger» → «Slett» sletter de valgte rundene etter en bekreftelse (opptakets forvalter). Publiserte runder slettes ikke. Lærestedet ser ikke avkrysningen eller «Handlinger».
- Sortering: en nedtrekksliste med «Svarfrist», «Status» og «Periode», og en knapp for stigende eller synkende rekkefølge.

### Navigasjon
Oversikten åpnes fra opptaket. Herfra går brukeren til rundesiden.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Tom | Opptaket har ingen runder (se *Åpne designspørsmål*) |
| Ingen treff | Søket eller filtrene gir ingen runder (se *Åpne designspørsmål*) |
| Laster | Listen lastes med de 50 første rundene |
| Feil | Standard feilmelding for listevisninger i FS Admin |
| Suksess | Kvittering etter sletting (se *Tekster*) |

## Tekster

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Over listen | Alltid | «{n} runde i listen» / «{n} runder i listen» | Entall og flertall | Liste viser de 50 første plasstildelingsrunder |
| Under listen | Det finnes flere runder | «Last inn flere», med «Viser {lastet} av {totalt}» | `{lastet}`, `{totalt}` | Laste inn 50 flere plasstildelingsrunder |
| Under listen | Alle er lastet inn | «Viser alle {n}» | `{n}` | Alle plasstildelingsrunder er lastet inn |
| Sortering | Etikett | «Sortering:» | – | Velge sorteringsretning for <felt> |
| Sortering | Valgene | «Svarfrist» / «Status» / «Periode» | Standard: «Svarfrist», stigende | Listen er sortert etter svarfristen |
| Filter, rundetype | Valgene | «Alle rundetyper» / «Hovedtildeling» / «Supplering» / «Etterfylling» | – | Tilgjengelige rundetyper i filter |
| Filter, status | Valgene | «Alle statuser» / «Ikke publisert» / «Publisert for søkere» | – | Tilgjengelige statuser i filter |
| Filter, periode | Valgene | «Alle perioder» / «Ikke satt» / «Åpner» / «Åpen» / «Utløpt» | – | Tilgjengelige perioder i filter |
| Filterpanel | Fjerne alle filtre | «Tøm filter» | – | Kombinere filtre |
| Oppgave, merke | Per runde | «Venter» / «Handling kreves» / «Stengt» | Ikke satt og åpner: «Venter». Åpen: «Handling kreves». Utløpt: «Stengt» | Lærestedet ser hva det skal gjøre i plasstildelingsrunden (`forvalte_runder.feature`) |
| Avkrysning, skjermleser | Per rad og for alle | «Velg {navn}» / «Velg alle runder» | `{navn}` | Slette flere plasstildelingsrunder |
| Handlinger | Runder er valgt | «{n} valgte» | `{n}` | Slette flere plasstildelingsrunder |
| Dialog for sletting | Opptakets forvalter sletter flere runder | Tittel «Slette runder», tekst «Disse rundene og innstillingene på dem blir fjernet. Dette kan ikke angres.» med listen over rundene, knapper «Avbryt» og «Slett {n} runder» | `{n}` | Slette flere plasstildelingsrunder |
| Dialog for sletting | Noen av de valgte rundene er publisert | «{kan} av {valgte} valgte kan slettes. Publiserte runder kan ikke slettes.» | `{kan}`, `{valgte}` | Publiserte plasstildelingsrunder slettes ikke |
| Kvittering | Rundene er slettet | «{n} runder er slettet.» | Én runde: «Runden «{navn}» er slettet.» | Slette flere plasstildelingsrunder |

**Skisser:** prototypen v88 (<https://claude.ai/artifact/PtEVDPyFrsWodTZPu9mfA9>, artefakt i en annen organisasjon, ikke lagret i repoet). Tekstene er sjekket mot den 2026-11-04.

Avvik fra prototypen, der kravet gjelder:
- Statusen heter «Publisert for søkere», ikke «Publisert» (prototypen har det bare som verktøytips).
- Sorteringen har «Svarfrist», «Status» og «Periode». Prototypen har «Runde», «Rundetype», «Svarfrist» og «Status».
- Filteret og merket for perioden er lagt til. Prototypen har «Ikke åpnet ennå» som merke. Her står «Åpner», som i filteret.
- Kolonnen «Oppgave» vises også for opptakets forvalter. Prototypen viser den bare for lærestedet, og har en egen kolonne «Publisering» for lærestedet. Her er det én kolonne «Status» for begge.

## Per-scenario detaljer

### Scenario: Opptakets forvalter ser oppgaven for lærestedet
Opptakets forvalter ser den samme oppgaven som lærestedet ville sett, ut fra perioden.

### Scenario: Publiserte plasstildelingsrunder slettes ikke
Publiserte runder kan velges, men dialogen sier hvor mange av de valgte som kan slettes, og bare de slettes.

## Åpne designspørsmål

- [ ] Tekst for tom tilstand (opptaket har ingen runder) og for ingen treff. Prototypen har ingen av dem.
- [ ] Prototypen v88 må rettes for status, sortering, filter og merke for perioden, og kolonnen «Oppgave» for opptakets forvalter.
