# Håndtering av Testdata i BDD

Kilde: https://automationpanda.com/2017/08/05/handling-test-data-in-bdd/

## Tre typer testdata

### 1. Test Case Values
Input- og forventede output-verdier. Kan spesifiseres direkte i
Gherkin eller refereres via nøkler.

### 2. Konfigurasjonsdata
URL-er, brukernavn, passord. Skal ALDRI hardkodes.
Les dynamisk ved oppstart via miljøvariabler eller konfigurasjonsfiler.

### 3. Ready State
Initialtilstand (brukerkontoer, databasetabeller) som må finnes
før tester kjører. Krev alltid opprydding etterpå.

## Strategier for testverdier

### Direkte i Gherkin
Når data er lite og beskrivende:
```gherkin
Når brukeren søker etter "informatikk"
Så vises 15 resultater
```

### Nøkkel-verdi-oppslag
For lengre data, referer med meningsfulle navn:
```gherkin
Gitt brukeren navigerer til "profil"-siden
```

### Datafiler
Lagre ekstern data i JSON/CSV. Unngå Excel.

### Eksterne kilder
Hent fra database/API kun når absolutt nødvendig. Introduserer
feilpunkter og ytelsesproblemer.

## Beste praksis

- **Minimer testdata** - Bruk ekvivalensklasser, ikke test alle variasjoner
- **Bruk beskrivende verdier** - Specification by example
- **Unngå randomisering** - Tester må være deterministiske
- **Skjul kompleksitet** - Ikke eksponér implementasjonsdetaljer i Gherkin
- **Rydd opp** - Slett midlertidige filer og tilbakestill data

## Anti-patterns

- Hardkodede miljø-verdier i automatisering
- Etterlate testdata/spor etter kjøring
- Over-avhengighet av eksterne datakilder
- Bruke After/Then-steps for opprydding (kjører ikke ved feil)
