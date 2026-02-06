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

## BRIEF-rammeverket

Kilde: https://cucumber.io/blog/bdd/keep-your-scenarios-brief/

Hold scenarios **BRIEF**:

- **B**usiness language — Bruk ord fra forretningsdomenet, ikke tekniske termer
- **R**evelation of intent — Scenarioet skal avsløre *hensikten*, ikke mekanikken
- **I**ntention-revealing name — Titler skal fortelle hva scenarioet handler om
- **E**ssential — Fjern alt som ikke direkte bidrar til å illustrere regelen
- **F**ew steps — Hold de fleste scenarios til fem linjer eller færre

## Begrens Antall Steps

Hold scenarios under 10 steps. Lange scenarios er vanskelige å forstå
og indikerer ofte dårlig praksis. Bruk Background for felles forutsetninger.

## Unngå konjunktive steps

Kilde: https://github.com/andredesousa/gherkin-best-practices

Splitt sammensatte assertions i separate steps for bedre modularitet og gjenbruk:

```gherkin
# FEIL - to ting i ett step
Så ser jeg feilmelding og tilbakeknapp

# RIKTIG - ett step per assertion
Så ser jeg feilmelding
Og ser jeg tilbakeknapp
```

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

## Step-argumenter: Tabell vs Doc String vs Eksempler

Kilde: https://cucumber.io/docs/gherkin/reference/
Kilde: https://automationpanda.com/2017/01/27/bdd-101-gherkin-by-example/

Det finnes tre måter å sende strukturert data til steps. De ser like ut men har
helt forskjellige formål. Ikke forveksle dem.

### Data-tabell (step-nivå)

Sender en liste eller struktur til **ett enkelt step**. Brukes når et step
trenger flere verdier som input eller verifikasjon.

**Bruk når:** Et step trenger en liste av elementer, nøkkel-verdi-par, eller
en tabell med flere kolonner.

#### Én-kolonne (liste)
```gherkin
Så følgende filer skal vises:
  | fil                |
  | semesteroppgave    |
  | intervjuspørsmål   |
```

#### To-kolonne (nøkkel-verdi)
```gherkin
Når brukeren oppretter en student med:
  | fornavn    | Ola       |
  | etternavn  | Nordmann  |
  | epost      | ola@uio.no |
```

#### Fler-kolonne (med header)
```gherkin
Gitt følgende brukere finnes:
  | navn   | epost             | rolle          |
  | Kari   | kari@uio.no       | administrator  |
  | Per    | per@uio.no        | saksbehandler  |
```

**Escape-tegn i tabeller:** `\n` (linjeskift), `\|` (pipe), `\\` (backslash).

### Doc String (step-nivå)

Sender en **større tekstblokk** til ett enkelt step. Brukes for fritekst,
JSON, XML, markdown, e-post-innhold, eller lignende.

**Bruk når:** Innholdet er ustrukturert tekst eller et dokument-format,
ikke tabulære data.

```gherkin
Gitt et blogginnlegg med markdown-innhold:
  """
  Introduksjon til BDD
  ====================
  BDD handler om å beskrive atferd
  gjennom konkrete eksempler.
  """
```

Valgfri innholdstype kan angis etter åpnings-delimiter:
```gherkin
Gitt API-et mottar følgende JSON:
  """json
  {
    "navn": "Ola Nordmann",
    "rolle": "student"
  }
  """
```

### Eksempler-tabell (scenario-nivå)

Brukes **kun med Scenariomal**. Kjører hele scenarioet én gang per rad.
Hver rad representerer en unik kombinasjon av inputverdier.

**Bruk når:** Samme atferd skal testes med forskjellige verdier.

```gherkin
Scenariomal: Søk med ulike termer
  Når brukeren søker etter "<term>"
  Så vises resultater for "<term>"

  Eksempler:
    | term          |
    | informatikk   |
    | pedagogikk    |
    | sykepleie     |
```

### Oppsummering: Når bruke hva?

| Type | Nivå | Formål | Eksempel |
|------|------|--------|----------|
| **Data-tabell** | Step | Sende strukturert data til ett step | Liste av brukere, nøkkel-verdi-par |
| **Doc String** | Step | Sende stor tekstblokk til ett step | JSON-body, e-post-tekst, markdown |
| **Eksempler** | Scenario | Parametrisere et helt scenariomal | Variasjoner av søkeord, input-typer |

**Viktig:** Data-tabeller og Eksempler-tabeller ser like ut, men har helt
forskjellige formål. Data-tabeller gir input til *ett step*. Eksempler-tabeller
kjører *hele scenarioet* én gang per rad.
