# Implementasjonsdetaljer: Gi en person tilgang med fødselsnummer, D-nummer eller SNR

**Relatert feature:** [`gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.feature`](./gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.feature)

Detaljene gjelder reglene som ikke er `@draft`. Det finnes ingen skisser.

## Overordnet UI-mønster

Tilgangen gis i dialogen «Gi rollen til en person» på rollens oversiktsside. Dialogen er
beskrevet i
[`administrere_brukere_på_rolle.design.md`](../3%20-%20Rollevisning/administrere_brukere_på_rolle.design.md).
Denne fila beskriver hvordan reglene i kravet viser seg i dialogen, og tekstene som hører til
dem.

## Komponenter og layout

Ingen egne komponenter. Feilene vises i dialogen på rollens oversiktsside: ugyldig nummer og
testperson som feltfeil under nummerfeltet, andre feil i dialogens tilbakemeldingsflate
(`FSModalFeedback`, som i «Tildel roller»). Beskjeden ved suksess vises som snackbar.

## Interaksjonsmønstre

### Primærhandling
Én operasjon tar organisasjon, miljø, rolle og nummer, og gir tildelingen. Finnes personen
ikke, opprettes hen i den samme operasjonen. Svaret er det samme uansett om personen fantes.

### Sekundære handlinger
Ingen.

### Navigasjon
Se implementasjonsdetaljene for BRU-PER-ROL-002.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Suksess | Dialogen lukkes. Snackbar med beskjeden ved suksess. Beskjeden har ikke personens navn |
| Ugyldig nummer | Feltfeil under nummerfeltet. Ingen tildeling, ingen person opprettet |
| Testperson i ekte miljø | Feltfeil under nummerfeltet. Ingen tildeling |
| Mangler rett til å tildele rollen | Feil i tilbakemeldingsflaten. Ingen tildeling, ingen person opprettet |
| Annen feil | Feil i tilbakemeldingsflaten |

## Tekster

Alle tekstene er forslag og må godkjennes av Kjetil. Dette er fasiten for tekstene.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Snackbar | Tildelingen er gitt | «Personen har fått rollen {rollekode}.» | `{rollekode}`. Teksten er den samme uansett om personen fantes fra før, og har ikke navnet | Svaret er det samme uansett hva som fantes fra før |
| Feltfeil under nummerfeltet | Nummeret har ugyldige kontrollsifre | «Nummeret er ikke et gyldig fødselsnummer, D-nummer eller SNR. Sjekk at det er skrevet riktig.» | Den samme teksten for alle tre nummertypene, fordi et ugyldig nummer ikke kan plasseres i en type | Nummer med ugyldige kontrollsifre avvises |
| Feltfeil under nummerfeltet | Nummeret tilhører en testperson, og miljøet er et ekte miljø | «En testperson kan ikke få tilgang i et ekte miljø. Velg et testmiljø.» | – | Testperson får ikke tilgang i et ekte miljø |
| Feltfeil under nummerfeltet | Nummeret tilhører en ekte person, og miljøet er et testmiljø | «En ekte person kan ikke få tilgang i et testmiljø. Velg et ekte miljø.» (foreslått tekst) | – | Ekte person får ikke tilgang i et testmiljø |
| Tilbakemeldingsflaten | Brukeradministratoren har ikke rett til å tildele rollen for organisasjonen og miljøet | «Du har ikke rettighet til å tildele i denne kombinasjonen av organisasjon og miljø.» (finnes i fs-admin) | – | Rolle brukeradministratoren ikke har rett til å tildele |
| Tilbakemeldingsflaten | Annen feil | «Kunne ikke gi rollen. Prøv igjen senere.» | – | – |

**Skisser:** ingen skisser finnes.

## Per-scenario detaljer

### Regel: Den første tildelingen gis med fødselsnummer, D-nummer eller SNR
Svaret har den nå synlige personen. Klienten finner personen igjen ut fra svaret, ikke ved å
slå opp på nummeret.

### Scenario: Personen kan ikke legges til uten en rolle
På rollesiden er rollen gitt. Organisasjon og miljø må være valgt før «Gi rollen» sender noe
(feltfeilen «Velg organisasjon og miljø.» i BRU-PER-ROL-002).

### Regel: Svaret avslører ikke om personen fantes fra før
Beskjeden er den samme i alle utgangspunktene i scenariomalen, og har ikke navnet. Feilene
skiller heller ikke mellom en person som finnes og en som ikke finnes: et ugyldig nummer avvises
før det slås opp, og manglende rett avvises før personen slås opp.

### Regel: Nummeret vises ikke etterpå
Nummeret slettes fra skjemaets tilstand når dialogen lukkes. Det legges ikke i URL-en, i
snackbaren eller i loggmeldinger i klienten. Listen på rollens oversiktsside, brukeroversikten
og detaljsiden henter ikke nummeret.

### Regel: Nummeret må ha gyldige kontrollsifre
Klienten sjekker kontrollsifrene før innsending, så feilen kommer straks. API-et sjekker det
samme og gir den samme feilen.

### Regel: En testperson kan ikke få tilgang i et ekte miljø
Det er API-et som avgjør om nummeret tilhører en testperson, og om miljøet er ekte. Klienten
viser feilen API-et gir.

## Åpne designspørsmål

- [ ] Godkjenn tekstene i tabellen over.
- [ ] Skal snackbaren nevne organisasjonen og miljøet («… for {organisasjon} i {miljø}»)?
