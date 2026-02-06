# Anti-patterns i BDD og Gherkin

Kilde: https://automationpanda.com/bdd/

## Syntaks-feil

### Punktlister er ikke gyldig Gherkin
```gherkin
# FEIL - gir parse error
Så varselet skal inneholde:
  - Punkt 1
  - Punkt 2

# RIKTIG - bruk tabell
Så varselet skal inneholde:
  | innhold |
  | Punkt 1 |
  | Punkt 2 |

# RIKTIG - bruk doc string
Så varselet skal inneholde:
  """
  Punkt 1
  Punkt 2
  """
```

### Kondisjonell logikk i steps
```gherkin
# FEIL - "hvis" med betingelser
Og utfør handling hvis:
  - Betingelse A
  - Betingelse B

# RIKTIG - ett scenario per betingelse
Scenario: Handling når betingelse A
  Gitt betingelse A er oppfylt
  Når handlingen utføres
  Så skjer forventet resultat
```

## Struktur-feil

### Prosedyre-drevet Gherkin
Skriv IKKE step-for-step prosedyrer forkledd med BDD-nøkkelord.
```gherkin
# FEIL - imperativ prosedyre
Når jeg klikker på meny
Og jeg velger "Innstillinger"
Og jeg klikker på "Profil"
Og jeg endrer navn til "Ola"
Og jeg klikker "Lagre"

# RIKTIG - deklarativ atferd
Når brukeren endrer profilnavnet til "Ola"
Så er profilnavnet oppdatert til "Ola"
```

### Flere When-Then-par
Indikerer flere atferder som bør splittes.
```gherkin
# FEIL
Når bruker logger inn
Så ser bruker dashboard
Når bruker klikker profil
Så ser bruker profilinformasjon

# RIKTIG
Scenario: Vellykket innlogging
  Når bruker logger inn
  Så ser bruker dashboard

Scenario: Navigere til profil
  Gitt bruker er logget inn
  Når bruker klikker profil
  Så ser bruker profilinformasjon
```

### For mange steps
Hold scenarios under 10 steps. Lange scenarios er vanskelige å forstå.

### For mange scenarios per feature
Begrens til ~12 scenarios per feature-fil.

## Innholds-feil

### Implementasjonsdetaljer i Gherkin
```gherkin
# FEIL - eksponerer database og API-detaljer
Så skal NUS_ENKELTUTDANNING.STATUS_AKTIV settes til "N"
Og systemet kaller POST /api/v1/notifications

# RIKTIG - beskriv atferd
Så skal NUS-koden markeres som inaktiv
Og berørte studieplanleggere varsles
```

### Hardkodede miljøverdier
Aldri hardkod URL-er, brukernavn eller passord i feature-filer.
Bruk miljøvariabler eller konfigurasjon.

### Assertion-språk i titler
```gherkin
# FEIL
Scenario: Verifiser at bruker kan logge inn

# RIKTIG
Scenario: Vellykket innlogging med gyldig bruker
```

### "Or"-steps
"Eller" finnes ikke som Gherkin-nøkkelord. Bruk Scenariomal:
```gherkin
# FEIL
Når bruker søker med navn eller epost

# RIKTIG
Scenariomal: Søk etter bruker
  Når bruker søker med "<søkefelt>"
  Så vises matchende resultater

  Eksempler:
    | søkefelt            |
    | Ola Nordmann        |
    | ola@example.com     |
```

## Samarbeid-feil

### Skrive scenarios alene
BDD er en samarbeidsprosess. Bruk "Three Amigos" (utvikler, tester,
forretning) for å diskutere og definere scenarios sammen.

### Glemme Example Mapping
Gjennomfør Example Mapping workshops før sprint-start for å avklare
akseptansekriterier og identifisere edge cases.
