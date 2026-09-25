# language: no
@OPT-REG-UBG-001 @must @draft
Egenskap: Utdanningsbakgrunnstyper i regelverk
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å definere utdanningsbakgrunnstyper i regelverket
  slik at de kan gjenbrukes på tvers av opptak.

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget

  Regel: Opptaksforvalter kan opprette utdanningsbakgrunnstyper i regelverket

    Scenario: Opprette utdanningsbakgrunnstype
      Når opptaksforvalter oppretter utdanningsbakgrunnstypen "Realkompetanse" i regelverket
      Så finnes utdanningsbakgrunnstypen "Realkompetanse" tilgjengelig for bruk i opptak

    Scenario: Opprette utdanningsbakgrunnstype for utenlandsk utdanning
      Når opptaksforvalter oppretter utdanningsbakgrunnstypen "Utenlandsk utdanning" i regelverket
      Så finnes utdanningsbakgrunnstypen "Utenlandsk utdanning" tilgjengelig for bruk i opptak

    Scenario: Opprette utdanningsbakgrunnstype for steinerskole
      Når opptaksforvalter oppretter utdanningsbakgrunnstypen "Steinerskole" i regelverket
      Så finnes utdanningsbakgrunnstypen "Steinerskole" tilgjengelig for bruk i opptak

  Regel: Utdanningsbakgrunnstyper er ikke hardkodet — opptaksforvalter kan opprette nye

    Scenario: Opprette en ny utdanningsbakgrunnstype
      Når opptaksforvalter oppretter en ny utdanningsbakgrunnstype med navn "23/5-regelen" i regelverket
      Så finnes den nye utdanningsbakgrunnstypen tilgjengelig for bruk i opptak