# Organisasjon — FS Systemkrav

Denne siden dokumenterer akseptansekriteriene for Organisasjon-modulen i FS.
Kravene er utledet fra [Gherkin-spesifikasjonene](.) og er ment som lesbar dokumentasjon for alle som er involvert i utvikling, forvaltning og godkjenning av systemet.

**Prioritet:** Må = systemet skal ha dette · Bør = ønsket, men ikke blokkerende · Kan = fint å ha
**Status:** Levert · Under arbeid · Planlagt · Identifisert (ikke planlagt for arbeid ennå)

---

## Innhold

- [Finn organisasjon](#finn-organisasjon)
- [Opprette organisasjon](#opprette-organisasjon)
- [Deaktivere organisasjon](#deaktivere-organisasjon)
- [Vedlikeholde organisasjon](#vedlikeholde-organisasjon)
- [Slå sammen duplikate organisasjoner](#slå-sammen-duplikate-organisasjoner)
- [Fusjonere organisasjoner](#fusjonere-organisasjoner)

---

## Finn organisasjon

> Som en studieadministrator ønsker jeg å søke etter en organisasjon slik at jeg raskt finner den organisasjonen jeg trenger, eller finner ut at jeg må opprette en ny.

**Feature-ID:** `ORG-SØK-SID-001` | **GitHub:** #XXX

### Søk på unik identifikator gir direktetreff

| ID | Akseptansekrav                                          | Prioritet | Status | GitHub |
|----|---------------------------------------------------------|-----------|--------|--------|
| ORG-SØK-SID-001-01 | Søk på organisasjonskode viser organisasjonen direkte     | Må | Identifisert | |
| ORG-SØK-SID-001-02 | Søk på organisasjonsnummer viser organisasjonen direkte | Må | Identifisert | |
| ORG-SØK-SID-001-03 | Søk på Erasmuskode viser organisasjonen direkte         | Må | Identifisert | |
| ORG-SØK-SID-001-04 | Søk på PIC-nummer viser organisasjonen direkte          | Må | Identifisert | |

### Søk på navn eller akronym gir liste med treff

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-SØK-SID-001-05 | Søk på fullt navn, akronym eller del av navn gir liste med matchende organisasjoner | Må | Identifisert | |
| ORG-SØK-SID-001-06 | Søk på navn finner også treff i navnehistorikken, og det fremgår at treffet er basert på et historisk navn | Må | Identifisert | |

### Fritekstsøk på tvers av felter

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-SØK-SID-001-07 | Søk på en verdi gir treff i navn og URL | Må | Identifisert | |
| ORG-SØK-SID-001-08 | Søk på flere ord gir kun treff der alle ord er til stede | Må | Identifisert | |
| ORG-SØK-SID-001-09 | Minustegn foran et ord ekskluderer det fra treff | Må | Identifisert | |

### Søket tolererer skrivefeil

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-SØK-SID-001-10 | Søk på feilstavet navn gir likevel relevante treff | Må | Identifisert | |

### Søk uten treff gir hjelp

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-SØK-SID-001-11 | Søk uten treff viser meldingen «Ingen organisasjoner funnet» og forslag til alternative søkeformuleringer | Må | Identifisert | |

### Søkeresultatlisten viser nøkkelinformasjon

| ID | Akseptansekrav                                                                                     | Prioritet | Status | GitHub |
|----|----------------------------------------------------------------------------------------------------|-----------|--------|--------|
| ORG-SØK-SID-001-12 | Hvert resultat viser organisasjonsID, navn, akronym, organisasjonstype og Erasmuskode              | Må | Identifisert | |
| ORG-SØK-SID-001-13 | Organisasjonstype vises slik den er registrert i Brønnøysundregistrene (for norske organisasjoner) | Må | Identifisert | |

### Åpne spørsmål

- Hvilke felter skal inngå i fritekstsøket — navn, URL, andre?
- Skal URL-søk støttes direkte eller kun som del av fritekst?
- I hvilken rekkefølge skal treff sorteres (relevans, navn, organisasjonsID)?

---

## Opprette organisasjon

> Som en systemadministrator ønsker jeg å opprette en ny organisasjon slik at nye norske læresteder eller deres samarbeidsvirksomheter i Norge eller utlandet kan registreres i systemet.

**Feature-ID:** `ORG-ADM-OPP-001` | **GitHub:** #XXX

### Norsk organisasjon henter data fra Brønnøysundregistrene

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-OPP-001-01 | Organisasjonsnummer gir automatisk utfylling av navn, adresse og organisasjonstype | Må | Identifisert | |
| ORG-ADM-OPP-001-02 | Organisasjonstype settes til verdien fra Brønnøysundregistrene | Må | Identifisert | |

### OrganisasjonsID tildeles automatisk

| ID | Akseptansekrav                                                                                             | Prioritet | Status | GitHub |
|----|------------------------------------------------------------------------------------------------------------|-----------|--------|--------|
| ORG-ADM-OPP-001-03 | Ny organisasjonsID tildeles automatisk ved opprettelse                                                     | Må | Identifisert | |
| ORG-ADM-OPP-001-04 | Norsk organsisasjon får organisasjonsID i norsk format                                                     | Må | Identifisert | |
| ORG-ADM-OPP-001-05 | Utenlandsk organsiasjonn får organisasjonsID i format landnummer + løpenummer (f.eks. 444+12345 for India) | Må | Identifisert | |

### Obligatoriske felter må fylles ut

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-OPP-001-06 | Organisasjon kan ikke lagres uten navn, organisasjonstype og URL | Må | Identifisert | |

### Valgfrie felter kan registreres

| ID | Akseptansekrav                                                 | Prioritet | Status | GitHub |
|----|----------------------------------------------------------------|-----------|--------|--------|
| ORG-ADM-OPP-001-07 | Akronym kan registreres og brukes i søk                        | Må | Identifisert | |
| ORG-ADM-OPP-001-08 | By kan registreres                                             | Må | Identifisert | |
| ORG-ADM-OPP-001-09 | NSD-kode kan registreres                                       | Må | Identifisert | |
| ORG-ADM-OPP-001-10 | PIC-nummer kan registreres                                     | Må | Identifisert | |
| ORG-ADM-OPP-001-11 | Organisasjonen kan markeres som godkjent betalingsorganisasjon | Må | Identifisert | |
| ORG-ADM-OPP-001-12 | Landkode kan registreres                                       | Må | Identifisert | |

### Erasmuskode verifiseres mot HEI-registeret

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-OPP-001-13 | Erasmuskode slås automatisk opp mot HEI-registeret ved registrering, og resultatet vises | Må | Identifisert | |
| ORG-ADM-OPP-001-14 | Ugyldig Erasmuskode gir advarsel, men kan likevel lagres | Må | Identifisert | |

### Språkkoder settes basert på nasjonalitet

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-OPP-001-15 | Norsk organisasjon får tilgjengelige språkkoder NO, NYNO, SAMISK og ENG | Må | Identifisert | |
| ORG-ADM-OPP-001-16 | Utenlandsk organisasjon får tilgjengelige språkkoder ORG og ENG | Må | Identifisert | |

### Utenlandske organisasjoner kan ha visningsnavn

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-OPP-001-17 | Utenlandsk organisasjon kan registreres med visningsnavn som brukes i grensesnittet | Må | Identifisert | |

### Akkreditering registreres av NOKUT

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-OPP-001-18 | Akkrediteringsfeltet er skrivebeskyttet for systemadministratorer — det fremgår at NOKUT registrerer dette | Må | Identifisert | |

### Organisasjonen må godkjennes før den er aktiv

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-OPP-001-19 | Ny organisasjon har status «Forslag» og er ikke søkbar før godkjenning | Må | Identifisert | |
| ORG-ADM-OPP-001-20 | Godkjent organisasjon blir aktiv og søkbar | Må | Identifisert | |

### Åpne spørsmål

- Hvem kan opprette organisasjoner — kun Sikt-ansatte, eller også lokale administratorer?
- Skal visningsnavn være et eget felt, eller brukes det kun for utenlandske organisasjoner?
- Eksakt format og regler for organisasjonsID per land?

---

## Deaktivere organisasjon

> Som en systemadministrator ønsker jeg å deaktivere en organisasjon som ikke lenger er aktiv slik at systemet gjenspeiler den faktiske tilstanden til organisasjonen.

**Feature-ID:** `ORG-ADM-DEA-001` | **GitHub:** #XXX

### En nedlagt organisasjon skal deaktiveres

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-DEA-001-01 | Nedlagt organisasjon kan deaktiveres med sluttdato og får status «Inaktiv» | Må | Identifisert | |
| ORG-ADM-DEA-001-02 | Inaktiv organisasjon vises ikke i standard søkeresultater | Må | Identifisert | |
| ORG-ADM-DEA-001-03 | Inaktiv organisasjon er synlig ved bruk av filter for historiske organisasjoner, og markeres tydelig som «Historisk» | Må | Identifisert | |
| ORG-ADM-DEA-001-04 | Årsak til deaktivering (f.eks. «Konkurs») kan registreres og lagres med tidspunkt | Må | Identifisert | |

### Deaktivering krever bekreftelse

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-DEA-001-05 | Systemet ber om bekreftelse og viser konsekvenser før deaktivering gjennomføres | Må | Identifisert | |

### Åpne spørsmål

- Hva skjer med data knyttet til en deaktivert organisasjon (studenter, ansatte, studieprogram)?
- Skal deaktivering varsle andre systemer som bruker organisasjonsdata?
- Kan en deaktivert organisasjon reaktiveres, og hvem har tilgang til dette?

---

## Vedlikeholde organisasjon

> Som en systemadministrator ønsker jeg å endre informasjon om en eksisterende organisasjon slik at dataene holdes oppdatert og korrekte.

**Feature-ID:** `ORG-ADM-VED-001` | **GitHub:** #XXX

### Navneendring registreres i historikk

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-VED-001-01 | Ved lagring av nytt navn spørres brukeren om det gamle navnet skal inn i navnehistorikken | Må | Identifisert | |
| ORG-ADM-VED-001-02 | Gammelt navn lagres med gyldighetsdato og er fortsatt søkbart | Må | Identifisert | |
| ORG-ADM-VED-001-03 | Gammelt navn kastes dersom brukeren velger det | Må | Identifisert | |

### PIC-nummer valideres mot Europakommisjonens API

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-VED-001-04 | Nytt PIC-nummer slås opp mot Europakommisjonens API, og informasjonen som returneres vises | Må | Identifisert | |
| ORG-ADM-VED-001-05 | PIC-nummer som ikke finnes i API-et gir advarsel, men kan likevel lagres | Må | Identifisert | |

### Erasmuskode har begrenset gyldighetsperiode

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-VED-001-06 | Erasmuskode registreres med fra- og til-dato, og er gyldig i inntil 4 år | Må | Identifisert | |
| ORG-ADM-VED-001-07 | Utløpt Erasmuskode markeres automatisk som historisk, med advarsel om koden fortsatt er aktiv | Må | Identifisert | |
| ORG-ADM-VED-001-08 | Endringshistorikk for Erasmuskoder er tilgjengelig med oversikt over hvilken kode som var aktiv i hvilken periode | Må | Identifisert | |

### Land som forlater Erasmus-avtalen håndteres korrekt

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-VED-001-09 | Erasmuskode for land utenfor avtalen kan settes inaktiv med sluttdato og vises med status «Historisk» | Må | Identifisert | |

### URL-en til organisasjonen bør være tilgjengelig

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-VED-001-10 | URL-feltet markeres med advarsel dersom adressen ikke svarer | Kan | Planlagt | |
| ORG-ADM-VED-001-11 | URL-feltet vises uten advarsel dersom adressen svarer | Kan | Planlagt | |

### Åpne spørsmål

- Har Europakommisjonen et API vi kan lytte på for å automatisk oppdage når land forlater eller gjenopptar Erasmus-avtalen?
- Har Europakommisjonen et API for å lytte på endringer i PIC-nummer? Se: https://ec.europa.eu/info/funding-tenders/opportunities/portal/screen/support/apis 
- Skal dato fra-til for Erasmuskode-gyldighet settes manuelt eller hentes fra HEI-registeret?
- Hvem varsles når en Erasmuskode nærmer seg utløp?
- URL-validering: Skal sjekk skje ved lagring, periodisk, eller begge deler?

---

## Slå sammen duplikate organisasjoner

> Som en systemadministrator ønsker jeg å identifisere og slå sammen duplikate organisasjoner slik at registeret ikke inneholder redundante oppføringer.

**Feature-ID:** `ORG-ADM-DUP-001` | **GitHub:** #XXX

### Navnehistorikk må sjekkes ved duplikatkontroll

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-DUP-001-01 | Navnehistorikken for begge kandidater vises under duplikatkontrollen med gyldighetsdatoer | Må | Planlagt | |

### To mulige duplikater kan sammenlignes side om side

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-DUP-001-02 | Alle felter for to potensielle duplikater vises side om side, med tydelig markering av felter med ulik verdi | Må | Planlagt | |

### Brukeren velger hvilke data som videreføres

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-DUP-001-03 | For hvert felt med ulik verdi kan brukeren velge hvilken verdi som skal videreføres | Må | Planlagt | |
| ORG-ADM-DUP-001-04 | Brukeren kan fylle inn ny informasjon i felter som mangler data i begge duplikatene | Bør | Planlagt | |

### Én organisasjon beholdes, den andre deaktiveres eller slettes

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-DUP-001-05 | Brukeren velger hvilken av organisasjonene som beholdes som gjeldende oppføring | Må | Planlagt | |
| ORG-ADM-DUP-001-06 | Norsk lærested kan ikke slettes — den andre organisasjonen kan kun markeres som inaktiv | Må | Planlagt | |

### Sammenslåing logges

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-DUP-001-07 | Det registreres hvilke to organisasjoner som ble slått sammen, tidspunkt og hvem som utførte handlingen | Må | Planlagt | |

### Åpne spørsmål

- Hva er reglene for hva som slettes versus hva som markeres som inaktivt?
- Alternativ flyt under vurdering: Ny organisasjon opprettes med felt fra begge duplikatene, og begge duplikatene slettes. Avklares før implementasjon.
- Hvem har tilgang til å slå sammen organisasjoner?

---

## Fusjonere organisasjoner

> Som en systemadministrator ønsker jeg å registrere at to eller flere organisasjoner fusjonerer slik at det historiske forholdet mellom organisasjoner bevares og den nye organisasjonen er korrekt registrert.

**Feature-ID:** `ORG-ADM-FUS-001` | **GitHub:** #XXX

### Norsk fusjonering oppretter en ny organisasjon

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-FUS-001-01 | Norske læresteders fusjonering resulterer i en ny organisasjon, de gamle markeres som inaktive, og den nye knyttes til dem | Må | Planlagt | |

### Navnehistorikken fra fusjonerte organisasjoner arves av den nye

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-FUS-001-02 | Den nye organisasjonens navnehistorikk inneholder historikk fra alle de fusjonerte organisasjonene | Må | Planlagt | |

### Utenlandsk fusjonering behandles annerledes enn norsk

| ID | Akseptansekrav | Prioritet | Status | GitHub |
|----|----------------|-----------|--------|--------|
| ORG-ADM-FUS-001-03 | Utenlandske organisasjoner som fusjonerer: én videreføres, den andre markeres som inaktiv og knyttes til den beholdte som sin etterfølger | Bør | Planlagt | |
| ORG-ADM-FUS-001-04 | Fusjonering mellom norsk og utenlandsk organisasjon: systemet gir veiledning om hvilke regler som gjelder | Bør | Planlagt | |

### Åpne spørsmål

- Hva skjer med studenter, ansatte og studieprogram knyttet til de fusjonerte organisasjonene?
- Skal fusjonering varsle andre systemer som bruker organisasjonsdata?
- Trenger fusjonering en godkjenningsprosess, eller kan det utføres direkte?
- Norsk fusjonering: Hentes data til ny organisasjon fra Brønnøysundregistrene, eller registreres manuelt?
