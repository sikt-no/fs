# Designnotat: Forvalte tilgangskatalogen

**Relaterte features:**
[`forvalte_tilgangskatalogen.feature`](./forvalte_tilgangskatalogen.feature) (BRU-TIL-KAT-001) og
[`oppdatere_tilgangsbeskrivelser.feature`](./oppdatere_tilgangsbeskrivelser.feature)
(BRU-TIL-KAT-002).

Kravene er besluttet: tilgangskatalogen skal kunne forvaltes gjennom API, med to rettighetsnivåer.
Notatet forklarer hvorfor skillet går der det går, hva som må håndheves hvor, og hvilke to hull i
dagens modell kravene forutsetter blir tettet.

## Hva katalogen er

Katalogen er listen over tilgangene som finnes: en kode som identifiserer hver tilgang, og en
beskrivelse av hva den gir. Den er referansepunktet for resten av tilgangsstyringen — en tildeling,
et delegeringstak og et nekt navngir alle en tilgang fra katalogen.

To egenskaper former kravene:

- **En rad i katalogen gir ingen noe.** Å opprette en tilgang er å innføre et begrep, ikke å dele
  ut noe. Først en tildeling gjør den til en tilgang noen har. Det er grunnen til at katalogen kan
  få en skriveflate uten at flaten i seg selv er en tilgangsutvidelse.
- **Koden er identiteten.** Alt annet peker på koden, så en kode som endres er en referanse som
  brytes. Koden settes ved opprettelse og står.

## Skillet: begrepet og forklaringen

Kravene deler katalogen i to på tvers av rader, ikke på tvers av tilganger:

| Nivå | Hva rettigheten omfatter | Hvem |
|------|--------------------------|------|
| Forvaltning | Opprette en tilgang, endre den, ta den ut av bruk | Utviklere hos Sikt |
| Dokumentasjon | Oppdatere beskrivelsen — og ingenting annet | Bidragsytere til dokumentasjonen |

Begrunnelsen for det andre nivået er at dokumentasjonen av en tilgang er den delen som eldes
raskest og som færrest har forutsetning for å skrive. Den som kan fagområdet vet hva en tilgang
faktisk gir; den som forvalter modellen vet hva raden gjør. Uten et eget nivå må all
dokumentasjonsforbedring gå gjennom dem som kan endre modellen, og da blir den ikke gjort.

Risikoen ved å utvide kretsen er lav, og det er verdt å si hvorfor presist: **en beskrivelse er
ikke lest av autorisasjonen.** Ingen får eller mister tilgang av at teksten endres, ingen tildeling
berøres, og ingen annen del av modellen peker på beskrivelsen. Det verste utfallet er en misvisende
forklaring — som er en dokumentasjonsfeil, ikke en sikkerhetsfeil.

## Kolonneskopet er et håndhevingskrav

Det viktigste å ta med videre fra dette notatet: at dokumentasjonsrettigheten bare omfatter
beskrivelsen er et krav til **håndhevingen**, ikke til hvilke felter en flate viser.

En flate som skjuler kodefeltet, over et API som tar imot hele katalograden, oppfyller ikke kravet.
Da er avgrensningen bare en presentasjon, og enhver klient som snakker med API-et direkte står
utenfor den. Kravet er at forsøket avvises der regelen bor — i API-et og i datalaget — uansett
hvilken inngang det kommer fra, og også når det følger med i den samme forespørselen som en gyldig
beskrivelsesendring. Featuren har egne scenarioer for begge formene, fordi det er nettopp de to som
skiller et håndhevet kolonneskop fra et presentert et.

Praktisk konsekvens for utformingen: dokumentasjonsnivået bør ha sin **egen operasjon** som bare
tar imot en kode og en beskrivelse, framfor å dele en generell endringsoperasjon med
forvaltningsnivået og filtrere på rettighet inne i den. Da er kolonneskopet en egenskap ved
grensesnittet i stedet for en regel noen må huske å håndheve.

## Hullet kravene forutsetter tettet, nr. 1: katalogen kan ikke listes

Ingen av dagens innganger til katalogen viser den i sin helhet. De listene som finnes er avledet av
noe annet — tilgangene en applikasjon har, tilgangene jeg selv har, tilgangene jeg har rettighet
til å tildele. En tilgang som ennå ikke er tildelt noen finnes dermed i modellen, men er usynlig i
løsningen.

Det er et hull for begge nivåene. Forvalteren kan ikke se hva katalogen inneholder før hun
oppretter noe nytt, og den som skal dokumentere kan ikke finne fram til de tilgangene som mangler
en beskrivelse — som er nøyaktig dem arbeidet handler om. Kravet er derfor en egen listespørring
over hele katalogen, paginert og forutsigbart sortert, lesbar for begge nivåene.

Paginering er tatt med i kravet framfor å overlates til utformingen, fordi katalogen er en liste
som vokser og som ingen naturlig avgrenser: den har verken organisasjon eller miljø å filtrere på.

## Hullet kravene forutsetter tettet, nr. 2: en tilgang kan ikke tas ut av bruk

Katalogen har i dag ingen livsløpsmarkør. En rad består av kode, beskrivelse og sporing av hvem som
opprettet og endret den — det finnes ingen gyldighetsperiode og ingen «utgått»-tilstand, slik de
temporale tabellene ellers i modellen har.

Å slette raden er ikke et alternativ: tildelinger, delegeringstak og nekt refererer koden, og
historikken skal bestå. «Ta ut av bruk» i kravet forutsetter derfor en liten modellutvidelse, og
semantikken bør være den samme som ellers: raden blir stående, den merkes som noe som ikke skal tas
i bruk på nytt, og det som allerede er tildelt berøres ikke av merkingen alene. Hvilken form
markøren skal ha — en gyldighetsperiode på linje med de temporale tabellene, eller et enklere flagg
— er en modellbeslutning som hører sammen med denne leveransen.

## Hvorfor et API her, når andre deler av modellen forvaltes i kildekoden

Flere av mekanismene rundt katalogen forvaltes bevisst gjennom migreringer, uten flate. Skillet
følger konsekvensen av en endring, ikke hvor krevende den er å bygge:

- Å **åpne data** eller å legge noe i **gulvet** endrer hvem som kan se hvilke data, uten at noen
  er tildelt noe. Der er fravær av en skriveflate en egenskap.
- Å **innføre en tilgang i katalogen** endrer ingens tilgang. Den blir først virksom gjennom en
  tildeling, som har sine egne rettigheter og sin egen sporing.

Katalogen er dessuten den mekanismen som har et løpende dokumentasjonsbehov, og det behovet kan
ikke dekkes av migreringer uten å gjøre hver tekstrettelse til en kodeendring.

## Åpne designspørsmål

- [ ] Skal dokumentasjonsrettigheten kunne avgrenses til et navnerom eller et fagområde, eller
      gjelder den hele katalogen?
- [ ] Skal en beskrivelsesendring kunne foreslås og godkjennes, eller er rettigheten i seg selv
      godkjenningen? Sporingen viser uansett hvem som endret hva og når.
- [ ] Skal implikasjoner mellom tilganger — hvilke tilganger en tilgang omfatter — også kunne
      forvaltes gjennom API-et? Kravene her dekker tilgangene selv, ikke hvordan de henger sammen,
      og implikasjoner er den delen som faktisk endrer rekkevidde.
- [ ] Hvilken form skal markøren for «ute av bruk» ha, og skal den hindre nye tildelinger av
      tilgangen eller bare varsle om dem?
- [ ] Skal listespørringen kunne filtrere på «mangler beskrivelse», eller er det en klientoppgave?
