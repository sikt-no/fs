# Writing Good Gherkin

Kilde: https://automationpanda.com/2017/01/30/bdd-101-writing-good-gherkin/
Kilde: https://automationpanda.com/2020/02/21/4-rules-for-writing-good-gherkin/

## The Golden Gherkin Rule

> "Write Gherkin so that people who don't know the feature will understand it."

## The Cardinal Rule of BDD

> "One Scenario, One Behavior!"

Hvert scenario skal dekke nøyaktig én distinkt atferd. Flere When-Then-par
indikerer flere atferder som bør splittes i separate scenarios.

## 4 Rules for Writing Good Gherkin

1. **Golden Rule** - Skriv så alle forstår, uansett bakgrunn
2. **Cardinal Rule** - Ett scenario = én atferd
3. **Unique Example Rule** - Hvert scenario må presentere et unikt eksempel
4. **Good Grammar Rule** - Korrekt grammatikk og språkkonvensjoner

## Deklarativ vs Imperativ

Skriv HVA som skal skje, ikke HVORDAN.

```gherkin
# FEIL - imperativ (prosedyre-drevet)
Gitt jeg er på innloggingssiden
Når jeg klikker på brukernavn-feltet
Og jeg skriver "test@example.com"
Og jeg klikker på passord-feltet
Og jeg skriver "passord123"
Og jeg klikker på logg-inn-knappen
Så ser jeg dashboard

# RIKTIG - deklarativ (atferd-drevet)
Gitt jeg er på innloggingssiden
Når jeg logger inn med "test@example.com"
Så ser jeg dashboard
```

## Step Type Integritet

- **Gitt** etablerer tilstand (bruk "er", "finnes", "har")
- **Når** utfører handling (bruk aktive verb)
- **Så** verifiserer resultat (bruk "vises", "er", "skal")

Rekkefølgen Gitt-Når-Så er obligatorisk. Gitt kan ikke følge etter Når/Så.

## Begrens Antall Steps

Hold scenarios under 10 steps. Lange scenarios er vanskelige å forstå
og indikerer ofte dårlig praksis. Bruk Background for felles forutsetninger.

## Formatering

1. Én feature per feature-fil
2. Maks ~12 scenarios per feature
3. Bruk stor forbokstav på Gherkin-nøkkelord
4. Unngå punktum på slutten av steps
5. Hold steps under 80-120 tegn
6. Bruk lowercase tag-navn med bindestrek
7. Juster pipe-tegn i tabeller
8. Ikke legg til blanke linjer mellom steps i et scenario
9. Skill scenarios med blanke linjer

## Gyldig Gherkin-syntaks etter steps

Etter et step kan følgende brukes:

- **Tabeller** (`| kolonne |`)
- **Doc strings** (`"""..."""`)
- **Neste step** (Og, Men, Gitt, Når, Så)

Punktlister (`- item`) er IKKE gyldig Gherkin og gir parse error.

```gherkin
# FEIL - punktlister er ugyldig syntaks
Så varselet skal inneholde:
  - Gammel verdi
  - Ny verdi

# RIKTIG - bruk tabell
Så varselet skal inneholde:
  | innhold      |
  | Gammel verdi |
  | Ny verdi     |

# RIKTIG - bruk doc string
Så varselet skal inneholde:
  """
  Gammel verdi
  Ny verdi
  """
```
