# Step Phrasing: Person og Tempus

## Person: Bruk tredjeperson

Kilde: https://automationpanda.com/2017/01/18/should-gherkin-steps-use-first-person-or-third-person/

Tredjeperson er anbefalt fordi det:
- Er mer generelt og fleksibelt
- Eliminerer tvetydighet om identitet og rolle
- Gir mer objektiv og formell dokumentasjon
- Forbedrer gjenbrukbarhet av steps

```gherkin
# FEIL - førsteperson
Gitt jeg er på Google-siden
Når jeg søker etter "panda"
Så ser jeg resultater

# RIKTIG - tredjeperson
Gitt nettleseren er på Google-siden
Når brukeren søker etter "panda"
Så vises resultater for "panda"
```

Vær konsekvent gjennom hele prosjektet. Ikke bland første- og tredjeperson.

## Tempus: Bruk presens

Kilde: https://automationpanda.com/2021/05/11/should-gherkin-steps-use-past-present-or-future-tense/

### Anbefalt: Presens for alle steps

```gherkin
Gitt Google-forsiden er vist
Når brukeren søker etter "panda"
Så viser resultatsiden lenker
```

Presens er enklest, minst ordrik, og gir scenarioet en aktiv følelse.

### Alternativ: Fortid-Presens-Fremtid

```gherkin
Gitt Google-forsiden ble vist          # fortid
Når brukeren søker etter "panda"       # presens
Så vil resultatsiden vise lenker       # fremtid
```

Begge tilnærminger er akseptable, men vær konsekvent innenfor prosjektet.

## Steps som subjekt-predikat

Skriv steps som fullstendige setninger med subjekt og predikat:

```gherkin
# FEIL - ufullstendig
Når søk etter "panda"

# RIKTIG - fullstendig
Når brukeren søker etter "panda"
```
