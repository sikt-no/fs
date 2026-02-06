# Good Gherkin Scenario Titles

Kilde: https://automationpanda.com/2018/01/31/good-gherkin-scenario-titles/

## Regler

### 1. Hold titler konsise (én-linjere)

Bruk enkle utsagn som fanger atferden. Lange titler tyder på uklart
fokus eller for mange atferder i ett scenario.

```gherkin
# FEIL
Scenario: Brukeren kan logge inn, navigere til profil og se navn, adresse og epost

# RIKTIG
Scenario: Profilsiden viser brukerens personlige informasjon
```

### 2. Unngå konjunksjoner

"og", "eller", "men" i titler indikerer flere atferder.
"fordi", "siden", "slik at" forklarer hvorfor i stedet for hva.

```gherkin
# FEIL - "eller" indikerer to atferder
Scenario: Bruker ber om tilbud fra forsiden eller forsikringssiden

# RIKTIG - splitt i to scenarios eller bruk Scenariomal
Scenario: Bruker ber om tilbud fra forsiden
Scenario: Bruker ber om tilbud fra forsikringssiden
```

### 3. Unngå assertion-språk

Fjern "verifiser", "sjekk", "assert", "skal" fra titler.
BDD fokuserer på spesifikasjon av atferd, ikke testing.

```gherkin
# FEIL
Scenario: Verifiser at bruker kan endre adresse

# RIKTIG
Scenario: Bruker endrer adresse på profilsiden
```

## Tommelfingerregel

Hvis det er vanskelig å lage en god tittel, er scenarioet sannsynligvis
for komplekst og bør revideres.
