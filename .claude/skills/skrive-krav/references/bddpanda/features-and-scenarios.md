# Features og Scenarios

## Hva er en Feature?

Kilde: https://automationpanda.com/2017/10/19/in-bdd-what-should-be-a-feature/

En feature representerer ønsket produktfunksjonalitet som ofte
involverer flere atferder. Features skal:

- Være drevet av kundebehov og løse reelle problemer
- Organisere relaterte atferder logisk sammen
- Navngis etter kundevendt funksjonalitet

**Ikke overtenk det.** Gjør det som er naturlig for prosjektet.

## Feature-struktur

```gherkin
# language: no

Egenskap: Beskrivende navn
  Som en [aktør]
  ønsker jeg å [handling]
  slik at [verdi]

  Bakgrunn:
    Gitt felles forutsetning

  Regel: Forretningsregel som grupperer scenarios

    Scenario: En spesifikk atferd
      Gitt forutsetning
      Når handling
      Så forventet resultat
```

## One Scenario, One Behavior

Kilde: https://automationpanda.com/2018/02/03/are-gherkin-scenarios-with-multiple-when-then-pairs-okay/

Hvert scenario skal teste én spesifikk atferd. Flere When-Then-par
indikerer at scenarioet bør splittes.

### Pragmatiske unntak

Multiple When-Then kan aksepteres i:

1. **Ende-til-ende scenarios** - Når man tester fullstendige
   systemflyter der individuelle atferder allerede har egne scenarios
2. **Revisjon/audit** - Regulerte bransjer som krever ende-til-ende
   verifisering med identiske testdata
3. **Service-kall testing** - API-tester der ett kalls respons
   brukes i neste kall

### Betingelseslogikk i steps

Unngå betingelser/kondisjonaler i steps. Splitt i separate scenarios:

```gherkin
# FEIL - kondisjonell logikk i step
Og varsle administrator hvis:
  - API nede > 48 timer
  - Siste synk > 7 dager

# RIKTIG - ett scenario per betingelse
Scenario: Varsle når API har vært nede over 48 timer
  Gitt API har vært utilgjengelig i 3 dager
  Når scheduled job kjører
  Så skal systemet opprette varsel for administrator

Scenario: Varsle når siste synkronisering er over 7 dager gammel
  Gitt siste synkronisering var for 8 dager siden
  Når scheduled job kjører
  Så skal systemet opprette varsel for administrator
```

## Scenario Outline / Scenariomal

Bruk for variasjoner av samme atferd:

```gherkin
Scenariomal: Validering av input
  Når brukeren skriver "<input>"
  Så vises "<resultat>"

  Eksempler:
    | input    | resultat    |
    | gyldig   | Suksess     |
    | ugyldig  | Feilmelding |
```

Hver rad i Eksempler-tabellen skal representere en meningsfull
ekvivalensklasse. Unngå unødvendige kombinasjoner.

## Background / Bakgrunn

Bruk for felles forutsetninger som gjelder alle scenarios i en feature:

```gherkin
Bakgrunn:
  Gitt brukeren er logget inn
  Og brukeren er på dashboard

Scenario: Se statistikk
  Når brukeren klikker statistikk
  Så vises statistikkoversikt
```

Begrens Background til Gitt-steps.
