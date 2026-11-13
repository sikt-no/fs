# Implementasjonsdetaljer: Gi en person tilgang med fødselsnummer, D-nummer eller SNR

**Relatert feature:** [`gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.feature`](./gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.feature)

Detaljene gjelder reglene som ikke er `@draft`. Det finnes ingen skisser. Detaljene er sjekket
mot fs-admin !3046 og tilgangsstyringen på fs-plattform main 13.11.2026.

## Overordnet UI-mønster

Tilgangen gis i dialogen «Gi rollen til en person» på rollens oversiktsside. Dialogen er
beskrevet i
[`administrere_brukere_på_rolle.design.md`](../3%20-%20Rollevisning/administrere_brukere_på_rolle.design.md).
Denne fila beskriver hvordan reglene i kravet viser seg i dialogen, og tekstene som hører til
dem.

## Komponenter og layout

Ingen egne komponenter. Feilene vises i dialogen på rollens oversiktsside: ugyldig nummer,
FS-generert nummer, testperson i ekte miljø og ekte person i testmiljø som feltfeil under
nummerfeltet, andre feil i dialogens tilbakemeldingsflate (`FSModalFeedback`, som i «Tildel
roller»). Beskjeden ved suksess vises som snackbar.

## Interaksjonsmønstre

### Primærhandling
Én operasjon (`tildelPersonbrukerTilgangerMedFodselsnummer`) tar organisasjon, miljø, rolle og
nummer, og gir tildelingen. Finnes personen ikke, opprettes hen uten navn i den samme
operasjonen. Svaret er det samme uansett om personen fantes. Har personen allerede rollen
direkte for organisasjonen og miljøet, skrives ingen ny tildeling, og svaret er det samme.

### Sekundære handlinger
Ingen.

### Navigasjon
Se implementasjonsdetaljene for BRU-PER-ROL-002.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Suksess | Dialogen lukkes. Snackbar med beskjeden ved suksess. Beskjeden har ikke personens navn |
| Ugyldig nummer | Feltfeil under nummerfeltet. Ingen tildeling, ingen person opprettet |
| FS-generert nummer | Feltfeil under nummerfeltet, med en egen tekst. Ingen tildeling, ingen person opprettet |
| Testperson i ekte miljø | Feltfeil under nummerfeltet. Ingen tildeling, ingen person opprettet |
| Ekte person i testmiljø | Feltfeil under nummerfeltet. Ingen tildeling, ingen person opprettet |
| Mangler rett til å tildele i organisasjonen og miljøet | Feil i tilbakemeldingsflaten. Ingen tildeling, ingen person opprettet |
| Annen feil | Feil i tilbakemeldingsflaten |

## Tekster

Tekstene er godkjent av Kjetil 09.10.2026. Dette er fasiten for tekstene.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Snackbar | Tildelingen er gitt | «Personen har fått rollen {rollekode}.» | `{rollekode}`. Teksten er den samme uansett om personen fantes fra før eller allerede hadde rollen, og har ikke navnet | Beskjeden er den samme uansett hva som fantes fra før |
| Feltfeil under nummerfeltet | Nummeret har ugyldige kontrollsifre | «Nummeret er ikke et gyldig fødselsnummer, D-nummer eller SNR. Sjekk at det er skrevet riktig.» | Den samme teksten for alle tre nummertypene, fordi et ugyldig nummer ikke kan plasseres i en type | Nummer med ugyldige kontrollsifre avvises |
| Feltfeil under nummerfeltet | Nummeret er et FS-generert nummer | «Nummeret er et FS-generert nummer og kan ikke brukes. Bruk personens fødselsnummer, D-nummer eller SNR.» | – | FS-generert nummer avvises |
| Feltfeil under nummerfeltet | Nummeret tilhører en testperson, og miljøet er et ekte miljø | «En testperson kan ikke få tilgang i et ekte miljø. Velg et testmiljø.» | – | Testperson får ikke tilgang i et ekte miljø |
| Feltfeil under nummerfeltet | Nummeret tilhører en ekte person, og miljøet er et testmiljø | «En ekte person kan ikke få tilgang i et testmiljø. Velg et ekte miljø.» | – | Ekte person får ikke tilgang i et testmiljø |
| Tilbakemeldingsflaten | Brukeradministratoren har ikke rett til å tildele i organisasjonen og miljøet | «Du har ikke rettighet til å tildele i denne kombinasjonen av organisasjon og miljø.» (finnes i fs-admin) | – | Organisasjon og miljø brukeradministratoren ikke har rett til å tildele i |
| Tilbakemeldingsflaten | Annen feil | «Kunne ikke gi rollen. Prøv igjen senere.» | – | – |

**Skisser:** ingen skisser finnes.

## Per-scenario detaljer

### Regel: Den første tildelingen gis med fødselsnummer, D-nummer eller SNR
Svaret har den nå synlige personen, men klienten velger bare `id` og bruker ikke svaret til å
vise personen. Den henter listen på rollens oversiktsside og filtervalgene på nytt, og personen
står der. Klienten slår aldri opp på nummeret. Mutasjonen er en bulkmutasjon; dialogen sender én
rad.

### Scenario: Personen kan ikke legges til uten en rolle
På rollesiden er rollen gitt. Organisasjon og miljø må være valgt før «Gi rollen» sender noe
(feltfeilen «Velg organisasjon og miljø.» i BRU-PER-ROL-002).

### Regel: Svaret avslører ikke om personen fantes fra før
Beskjeden er den samme uansett om personen fantes fra før eller allerede hadde rollen, og har
ikke navnet. Feilene skiller heller ikke mellom en person som finnes og en som ikke finnes:
API-et avgjør alle avvisningene før personen slås opp, i rekkefølgen manglende rett, ukjent
rolle, ugyldig eller FS-generert nummer, testperson i ekte miljø og ekte person i testmiljø.

### Regel: Nummeret vises bare når navnet mangler
Nummeret slettes fra skjemaets tilstand når dialogen lukkes. Det legges ikke i URL-en, i
snackbaren eller i loggmeldinger i klienten, og mutasjonen går utenom Apollo-cachen. Når navnet
til personen mangler, viser brukeroversikten, listen på rollens oversiktsside og detaljsiden for
personen nummeret i navnets plass. Det krever at API-et gir nummeret for personer uten navn.
Når navnet er kjent, henter ingen av sidene nummeret.

**Status 13.11.2026:** API-et har ikke nummeret på personen. Feltet venter på en
personvernavklaring (fs-admin !3046, «Trenger backend» punkt 1). Til da viser FS Admin «Navn
ikke kjent» der nummeret skal stå.

### Regel: Nummeret må ha gyldige kontrollsifre
Klienten sjekker nummeret før innsending, så feilen kommer straks. Mellomrom fjernes først.
Deretter sjekkes det i denne rekkefølgen: tomt felt, 11 siffer, FS-generert serie (måned 51–62
og personnummer fra 70000), og de to kontrollsifrene (mod 11). Et FS-generert nummer får derfor
sin egen tekst også når kontrollsifrene er gyldige.

API-et sjekker det samme (`auth.er_gyldig_fodselsnummer` og `auth.er_fs_generert_serie`), men
gir én feil, `UgyldigFodselsnummer`, for både ugyldig og FS-generert nummer. Klienten velger
teksten ut fra sin egen sjekk av serien.

Regelen for det første kontrollsifferet som gjelder fra 2032 (BAT-433), er verken i klienten
eller i API-et. Begge må endres samtidig.

### Regel: En testperson kan ikke få tilgang i et ekte miljø, og en ekte person ikke i et testmiljø
Det er API-et som avgjør om nummeret tilhører en testperson (Skatteetatens syntetiske serie), og
om miljøet er ekte eller et testmiljø. Klienten viser feilen API-et gir:
`SyntetiskPersonIEktMiljo` eller `EktePersonISyntetiskMiljo`.

### Regel: Brukeradministratoren kan bare gi roller hen har rett til å tildele
Retten er retten til å tildele personer i organisasjonen og miljøet. API-et gir
`ManglerTildelingsrett` når den mangler. Med retten kan alle rollene i rollekatalogen gis.

## Åpne designspørsmål

- [ ] Skal snackbaren nevne organisasjonen og miljøet («… for {organisasjon} i {miljø}»)?
- [ ] Mellomrom i et innlimt nummer fjernes før sjekk og innsending (fs-admin !3046). Er det
      riktig?
