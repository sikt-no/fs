# Implementasjonsdetaljer: Se meldinger om egne søknader

**Relatert feature:** [`mine_meldinger.feature`](./mine_meldinger.feature)

Beskriver det som er levert i min-kompetanse (`main` per 2026-10-09), og tekstene til delene som er `@planned` og `@draft`. Tekstene i koden er fasit der koden og Figma er ulike (se *Åpne designspørsmål*).

## Overordnet UI-mønster

To sider i Min kompetanse:

- **Mine meldinger** (`/mine-meldinger`): filter til venstre, meldingene som en liste med kort til høyre. På mobil står filteret over listen.
- **Melding** (`/mine-meldinger/<id>`): detaljvisning av én melding.

I tillegg vises antall uleste meldinger i toppmenyen på alle sider, og som et kort på Min oversikt.

## Komponenter og layout

- **Meldingskort i listen** (lenkekort, nummerert liste): tittel og dato på første linje, avsender under, og merkelapper nederst. Kort uten merkelapper har en usynlig plassholder, så alle kortene er like høye. Uleste meldinger har en tykk venstrekant i advarselsfarge og fet tittel.
- **Merkelapper**: «Ulest» (advarsel, med konvoluttikon) på uleste meldinger, og «Viktig» (kritisk) på meldinger av typen MANGEL. Detaljvisningen viser bare «Viktig».
- **Filter**: avkrysningsboks for uleste, nedtrekk for periode (år) og nedtrekk for meldingstype. Filteret står i URL-en (`unreadOnly`, `year`, `type`).
- **Detaljvisning**: et kort med ikon (kvittering), «Mottatt» med dato og klokkeslett, tittel med merkelapper, innhold og avsenderens signatur. Under kortet vises studiene for kvitteringer og mangelbrev, som en nummerert prioritetsliste, med opptaksnavnet over.
- **Varselklokke** i toppmenyen, med et tall som bare vises når det er uleste meldinger.
- **Min oversikt**: et lenkekort under overskriften «Meldinger». Kortet har advarselsfarge når det er uleste meldinger.

## Interaksjonsmønstre

### Primærhandling
Søkeren velger et meldingskort og kommer til detaljvisningen. Meldingen merkes som lest når detaljvisningen åpnes, og tallet i toppmenyen går ned med én.

### Sekundære handlinger
- Filtrere på uleste, år og meldingstype. Listen oppdateres med en gang.
- Mangelbrev: knappen «Se hva som mangler» går til dokumentasjonssiden for søknaden.
- Kvittering for levert søknad: lenken «dokumentasjonssiden» går til dokumentasjonssiden for søknaden. I et lokalt opptak lenker «nettsidene til {lærested}» til nettsidene til lærestedet.

### Navigasjon
- Inn: varselklokka i toppmenyen eller kortet på Min oversikt.
- Mine meldinger har lenken «Til Min oversikt» øverst, og detaljvisningen har «Til Mine meldinger».

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Ingen meldinger | Kort med «Du har ingen meldinger.» |
| Ingen treff på filteret | Kort med «Du har ingen meldinger som samsvarer med valgt filter.» |
| Laster (detaljvisning) | Skjelett av meldingskortet |
| Feil ved henting av listen | Felles feilmelding i appen, og listen vises tom |
| Feil når meldingen merkes som lest | Ingen melding til søkeren. Feilen logges |
| Ny melding | Tallet i toppmenyen hentes hvert 30. sekund. Når det kommer en ny ulest melding, «spretter» klokka, og listen på Mine meldinger hentes på nytt. Nye kort kommer inn med animasjon, forskjøvet 100 ms per kort. Uten animasjon når brukeren har valgt redusert bevegelse |

## Tekster

Dette er fasiten for tekstene, også når en skisse viser noe annet. Datoer i krøllparentes settes inn fra opptaket. En frist vises bare hvis den var etter tidspunktet kvitteringen ble sendt, så teksten endres ikke senere.

### Datoformat

| Hvor | Format | Eksempel |
|------|--------|----------|
| Meldingskort i listen | Dag og måned. Året tas med når det ikke er i år | «12. juni», «12. juni 2024» |
| «Mottatt» i detaljvisningen og fristen i mangelbrevet | Dag, måned og klokkeslett. Året tas med når det ikke er i år | «Mottatt 14. april kl. 14:47» |
| Frister i kvitteringstekstene | Dag og måned. Året tas med når det ikke er i år | «1. juli» |

### Listen, filteret og Min oversikt

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Filter | Alltid | «Vis kun uleste meldinger», «Periode», «Type melding» | – | Vise kun uleste meldinger, Filtrere på år |
| Filter, standardvalg | Periode og type | «Alle» | – | Tilgjengelige år i filter, Tilgjengelige meldingstyper i filter |
| Filter, meldingstyper | Typene søkeren har meldinger av | «Kvittering», «Mangel», «Tidlig opptak», «Generell» | «Generell» tas ut (`@planned`) | Tilgjengelige meldingstyper i filter |
| Meldingskort, avsender | Meldingen har ingen avsender | «Min kompetanse» | Skjermleser: «Avsender» foran navnet | Melding uten avsender |
| Meldingskort, avsender | Kvittering i samordna opptak (`@planned`) | «Min kompetanse» | – | Kvitteringer i et samordna opptak har Min kompetanse som avsender |
| Merkelapp | Uleste meldinger | «Ulest» | – | Uleste meldinger er merket |
| Merkelapp | Meldinger av typen MANGEL | «Viktig» | – | Mangelbrev er merket som viktig |
| Tom liste | Søkeren har ingen meldinger | «Du har ingen meldinger.» | – | Søkeren har ingen meldinger |
| Tom liste | Filteret gir ingen treff | «Du har ingen meldinger som samsvarer med valgt filter.» | – | Ingen meldinger matcher filteret |
| Min oversikt, kort | Det er uleste meldinger | «{antall} uleste meldinger» | Entall: «1 ulest melding» | Min oversikt viser antall uleste meldinger |
| Min oversikt, kort | Ingen uleste meldinger | «Ingen uleste meldinger» | – | Min oversikt når alle meldinger er lest |
| Min oversikt, kort | Alltid | «Se og få oversikt over dine meldinger.» | – | Min oversikt viser antall uleste meldinger |
| Toppmenyen, skjermleser | Når antallet endres | «{antall} meldinger.» | «Ingen meldinger.», «1 melding.» | Antall uleste meldinger vises i toppmenyen |

### Mangelbrev

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Tittel | Alltid | «Du mangler dokumentasjon i søknaden» | – | Søkeren åpner et mangelbrev |
| Innhold | Alltid | «Du ser alle mangler på dokumentasjonssiden, og kan laste opp dokumentene der innen fristen.» | – | Søkeren åpner et mangelbrev |
| Frist | Mangelbrevet har en frist | «Frist for opplasting: {dato og klokkeslett}» | – | Søkeren åpner et mangelbrev |
| Knapp | Mangelbrevet gjelder en søknad | «Se hva som mangler» | – | Søkeren åpner et mangelbrev |
| Over studiene | Søknaden har studieønsker | «Gjelder din søknad til følgende studier:» | – | Søkeren åpner et mangelbrev |

### Kvitteringer

Tittelen velges ut fra kvitteringstypen og om saksbehandleren gjorde endringen. Er typen ukjent, brukes tittelen og innholdet backend sender.

| Kvitteringstype | Tittel, søkeren | Tittel, saksbehandleren | Innhold | Variasjoner i innholdet | Scenario |
|-----------------|-----------------|-------------------------|---------|-------------------------|----------|
| Levert eller gjenopprettet, samordna opptak | «Vi har mottatt søknaden din» | «Saksbehandler har sendt inn en søknad på dine vegne» | «Du får svar i hovedopptaket {svar publiseres}. Les om opptakskrav og hvilke dokumenter du trenger på dokumentasjonssiden.» | Uten dato: «Les om opptakskrav og hvilke dokumenter du trenger på dokumentasjonssiden.» | Søkeren får kvittering for egne endringer |
| Levert eller gjenopprettet, lokalt opptak | «{lærested} har mottatt søknaden din» | «Saksbehandler har sendt inn en søknad på dine vegne» | «{lærested} behandler søknaden din og du vil få svar {svar publiseres}. Les om opptakskrav og hvilke dokumenter du trenger på dokumentasjonssiden. Se også nettsidene til {lærested}.» | Uten dato: «{lærested} behandler søknaden din. Les om … Se også nettsidene til {lærested}.» | Kvittering fra et lokalt opptak |
| Endret søknad | «Du har endret søknaden din» | «Saksbehandler har endret søknaden din» | «Du kan legge til og fjerne studieønsker fram til {søknadsfrist}, du kan endre rekkefølgen på dem fram til {omprioriteringsfrist} og du kan laste opp flere dokumenter fram til {ettersendingsfrist}.» | Bare noen av fristene: tekstene for endrede studieønsker og «Du kan laste opp flere dokumenter fram til {ettersendingsfrist}.» etter hverandre. Ingen frister: «Vi bruker de nye opplysningene når vi behandler søknaden din.» | Søkeren får kvittering for egne endringer |
| Trukket | «Du har trukket søknaden din» | «Saksbehandler har trukket søknaden din» | «Vil du søke igjen, må du sende en ny søknad før fristen {søknadsfrist}.» | Søknadsfristen er ute: «Det er ikke mulig å angre.» Ingen søknadsfrist: «Vi behandler ikke søknaden din videre.» | Søkeren får kvittering for egne endringer |
| Endret rekkefølge | «Du har endret rekkefølgen på studieønskene dine» | «Saksbehandler har endret rekkefølgen på studieønskene dine» | «Vi bruker den nye rekkefølgen når vi behandler søknaden din. Du kan endre rekkefølgen så mange ganger du vil fram til {omprioriteringsfrist}.» | Ingen frist: «Vi bruker den nye rekkefølgen når vi behandler søknaden din.» | Søkeren får kvittering for egne endringer |
| Endrede studieønsker | «Du har endret studieønskene dine» | «Saksbehandler har endret studieønskene dine» | «Du kan legge til og fjerne studieønsker fram til {søknadsfrist} og du kan endre rekkefølgen på dem fram til {omprioriteringsfrist}.» | Bare søknadsfrist: «Du kan legge til og fjerne studieønsker fram til {søknadsfrist}.» Bare omprioriteringsfrist: «Du kan endre rekkefølgen på studieønskene dine fram til {omprioriteringsfrist}.» Ingen: «Vi bruker de nye studieønskene når vi behandler søknaden din.» | Søkeren får kvittering for egne endringer |
| Nye dokumenter | «Du har sendt inn nye dokumenter» | «Saksbehandler har sendt inn nye dokumenter på dine vegne» | «Du kan laste opp flere dokumenter fram til {ettersendingsfrist}.» | Ingen frist: «Dokumentene er lagt til søknaden din.» | Søkeren får kvittering for egne endringer |
| Tidlig opptak | Fra backend | Fra backend | Fra backend | – | Søkeren får kvittering for egne endringer |

Over studiene i en kvittering: «Du har søkt opptak til følgende studier:», med opptaksnavnet under.

### Meldinger fra backend

| Hvor | Når vises den | Tekst | Scenario |
|------|---------------|-------|----------|
| Tittel | Saksbehandleren har svart på tilbudet | «Tilbudet ditt er besvart av en saksbehandler» | Søkeren får melding når saksbehandleren svarer på tilbudet |
| Innhold | Saksbehandleren har svart på tilbudet | «En saksbehandler har svart på tilbudet eller ventelisteplassen din på dine vegne.» | Søkeren får melding når saksbehandleren svarer på tilbudet |

Meldinger av typen GENERELL og TIDLIG_OPPTAK bruker tittelen og innholdet backend sender. Innholdet er markdown.

### Ikke bygget (`@draft`)

| Hvor | Tekst i skissene | Scenario |
|------|------------------|----------|
| Kvittering for svar på tilbud, tittel | Figma: «Du har svart på søknaden din.» Confluence: «Du har svart på søknaden.» | Søkeren får kvittering for svar på tilbud |
| Kvittering for svar på tilbud, innhold | Figma: én linje per svar, «Du har takket ja til tilbud om studieplass ved {lærested, studium, studieform, sted}» og «Du har takket nei til venteliste ved {…}», og så «Svaret kan endres frem til {svarfrist}.» Confluence: «Svaret kan endres frem til svarfristen. Svarfrist: {dato og klokkeslett}.» | Søkeren får kvittering for svar på tilbud |

**Skisser:** Figma [Min Kompetanse 2026, «Mine meldinger»](https://www.figma.com/design/zYzcXLwDsgoqAhvZ8X1ron/Min-Kompetanse-2026?node-id=24-7678): innboksen (24:7679), Min oversikt (2380:8052), kvittering for innsendt søknad (24:9484), kvittering for svar (4500:8031) og seksjonen «Tekster» (3173:8320). Confluence [Kvitteringstekster Min kompetanse](https://sikt.atlassian.net/wiki/spaces/PFS/pages/5003673614/Kvitteringstekster+Min+kompetanse).

## Per-scenario detaljer

### Scenario: Hver melding viser tittel, dato og avsender
Avsenderen er organisasjonen som eier opptaket. For kvitteringer og mangelbrev lager frontenden tittelen (se *Tekster*). For andre meldinger brukes tittelen fra backend.

### Scenario: Kvitteringen viser fristene som gjaldt da den ble sendt
Fristene hentes fra hendelsene på opptaket (`SOKNADSFRIST_ORDINAER`, `FRIST_OMPRIORITERING`, `FRIST_ETTERSENDING`, `PUBLISERING_RESULTAT`), og sammenlignes med tidspunktet kvitteringen ble sendt. En frist som var ute da, vises ikke.

### Scenario: Søkeren åpner en kvittering for en levert søknad
Studiene er et øyeblikksbilde fra da kvitteringen ble laget, sortert etter prioritet. De viser studienavn, studieform og sted.

### Scenario: Søkeren åpner et mangelbrev
Studiene hentes fra søknaden slik den er nå, ikke fra et øyeblikksbilde.

## Åpne designspørsmål

- [ ] Figma er utdatert på fem tekster der koden er fasit (avklart 2026-10-13): tittelen for endret rekkefølge («… studieønskene» i Figma), tittelen for endret søknad («… og sendt inn nye dokumenter» i Figma), tittelen for dokumenter fra saksbehandleren («Saksbehandler har lastet opp dokumentasjon på dine vegne.» i Figma), innholdet i kvitteringen for lokalt opptak, og tittelen på mangelbrevet («Manglende dokumentasjon» i Figma). Figma bør oppdateres.
- [ ] Datoen på meldingskortene er ulik i Figma («12.06.2024» og «12. juni 2026»). Koden bruker «12. juni».
- [ ] Figma viser «Viktig», mens #411 og #412 sier «Handling kreves». «Handling kreves» er ikke med i første versjon.
- [ ] Figma viser sidetall under listen. Det er ikke bygget, og er ikke med i kravet.
- [ ] Kvittering for svar på tilbud: Figma og Confluence har ulik tittel og ulik tekst om svarfristen. Det avklares sammen med de åpne spørsmålene i kravet.
- [ ] Melding om svar på søknaden: designet mangler (TOT-2518).
- [ ] Kvittering for tidlig opptak bruker tittelen og teksten fra backend. Skal den ha egne tekster i frontenden, som de andre kvitteringene?
