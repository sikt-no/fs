# language: no
@OPT-REG-KRA-002 @must @draft
Egenskap: Kravelement
  Som opptaksforvalter
  ønsker jeg å opprette og vedlikeholde kravelementer
  slik at de kan brukes som byggeklosser i kompetanseregelverk.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at regelverkssamlingen "UHG2027" er opprettet

  Regel: Opptaksforvalter kan opprette et kravelement med kode, type og navn

    Scenario: Opprette fagkrav-kravelement
      Når jeg oppretter et nytt kravelement med kode "FFMAT"
      Og jeg angir kravtype "FAG"
      Og jeg angir navn "Matematikk R1" på bokmål
      Og jeg markerer det som vitnemålsrelatert
      Så er kravelementet opprettet i regelverkssamlingen

    Scenario: Opprette annet kravelement
      Når jeg oppretter et nytt kravelement med kode "PRAKSIS"
      Og jeg angir kravtype "ANNET"
      Og jeg angir navn "Yrkeserfaring minimum 2 år" på bokmål
      Så er kravelementet opprettet i regelverkssamlingen

  Regel: Kravelementer kan markeres som kjernefag

    Scenario: Markere kravelement som kjernefag
      Når jeg oppretter kravelementet "FFMAT" med "er kjernefag" satt til ja
      Så er kravelementet markert som kjernefag

  Regel: Kravelementer kan ha vitnemålskravkoder

    Scenario: Sette vitnemålskravkoder
      Når jeg oppretter kravelementet "FFMAT"
      Og jeg setter vitnemålskravkode 1 til "KL"
      Så er vitnemålskravkoden lagret på kravelementet

  Regel: Kravelementer har navn på flere språk

    Scenario: Flerspråklig navn på kravelement
      Når jeg oppretter kravelementet "FFYS1"
      Og jeg angir navn "Fysikk 1" på bokmål, "Fysikk 1" på nynorsk, "Physics 1" på engelsk og "Fysihkka 1" på samisk
      Så er navnene lagret på alle fire språk

  Regel: Kravelementer kan gjenbrukes på tvers av kompetanseregelverk innenfor samme regelverkssamling

    Scenario: Gjenbruke kravelement i flere kompetanseregelverk
      Gitt at kravelementet "FFMAT" finnes i regelverkssamlingen
      Når jeg oppretter kompetanseregelverket "GSK-UHG" og bruker "FFMAT"
      Og jeg oppretter kompetanseregelverket "HING" og bruker "FFMAT"
      Så bruker begge regelverkene det samme kravelementet

  Regel: Et kravelement kan slettes når det ikke er i bruk

    Scenario: Slette kravelement
      Gitt at kravelementet "TestKrav" ikke er brukt i noe kompetanseregelverk
      Når jeg sletter kravelementet
      Så er det slettet