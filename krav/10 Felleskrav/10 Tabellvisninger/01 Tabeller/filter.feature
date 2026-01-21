# language: no
@FEL-TAB-TAB-001 @fsadmin
Egenskap: 10 Felleskrav: Filter
  I fsadmin åpner brukere ofte opp visninger med tabeller. Dette kan være alt fra en liste over personer i personsøk eller en liste over regelverk i opptak. Dette featuren handler om å lage et sett med krav knyttet til hvordan det skal være mulig å filtrere dataen som vises i disse tabellene.

  Bakgrunn:
    Gitt at bruker er på innlogget på FS Admin og benytter en eller annen feature som viser en tabell

  Scenario: Filtrere på alle kolonner i oversikten
    Gitt at brukeren er inne på personsøk
    Og at tabellen har følgende kolonner
      | Kolonne         |
      | Navn            |
      | Fødselsnummer   |
      | Telefonnummer   |
      | Statsborgerskap |
    Når brukeren ønsker å filtrere bort noen rader
    Så skal brukeren kunne filtrere på alle datafelter/kolonner som finnes i tabellen

  Scenario: Velge hvilke av kolonnene som skal synes i tabellvisningen
    Gitt at brukeren er inne på opptak og ser på oversikten over opptak
    Og at oversikten viser følgende kolonner
      | Kolonne                 |
      | Navn                    |
      | Opptakstype             |
      | Opprettet               |
      | Antall utdanningstilbud |
    Når brukeren velger å fjerne noen kolonner fra visningen
      | Kolonne                 |
      | Opprettet               |
      | Antall utdanningstilbud |
    Så skal oversikten kun inneholde de kolonnene som brukeren har beholdt
      | Kolonne     |
      | Navn        |
      | Opptakstype |

  Scenario: Velge hvilke av kolonnene som skal kunne filtreres på
    Gitt at brukeren er inne på oversikten over søknader på et opptak
    Og at tabellen har følgende kolonner
      | Kolonne       |
      | Navn          |
      | Fødselsdato   |
      | Søknadsnummer |
      | Status        |
    Når brukeren velger å fjerne noen kolonner fra søkemulighetene
      | Kolonne       |
      | Søknadsnummer |
      | Status        |
    Så skal det kun være mulig å filtrere på de kolonnene som brukeren ikke har fjernet
      | Kolonne     |
      | Navn        |
      | Fødselsdato |

  Scenariomal: Velge hvor mange treff per side som skal vises i oversikten
    Gitt at brukeren er inne på personsøk
    Når brukeren velger <antall> visninger per side
    Så skal brukeren kun se <antall> visninger eller færre i oversikten per side

    Eksempler:
      | antall |
      | 50     |
      | 500    |
      | 1000   |

  Scenario: Bruker trykker på et element i oversikten og går videre til relevant side
    Gitt at brukeren er inne på kompetanseregelverk
    Når brukeren trykker på en rad i hovedkolonnen i oversikten
    Så skal brukeren gå inn på siden for det relevante kompetanseregelverket

  Scenario: Sortere per kolonne
    Gitt at brukeren er inne på en oversikt med flere kolonner
    Når brukeren trykker på kolonneoverskriften
    Så skal oversikten sorteres på den kolonnen
    Og brukeren skal kunne veksle mellom stigende og synkende rekkefølge
