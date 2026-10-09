# language: no
# GitHub: #376
@OPT-REG-KVO-002 @must @draft
Egenskap: Kvotespørsmål
  Som opptaksforvalter
  ønsker jeg å definere kvotespørsmål og knytte dem til kvotetyper
  slik at det kan avgjøres om en søker skal plasseres i en bestemt kvote.

  Bakgrunn:
    Gitt at opptaksforvalteren er innlogget
    Og at regelverkssamlingen "UHG2027" er opprettet
    Og at kvotetypen "SAMISK" finnes i regelverkssamlingen

  Regel: Opptaksforvalter kan opprette kvotespørsmål med kode, navn og spørsmålstekst

    Scenario: Opprette kvotespørsmål
      Når opptaksforvalteren oppretter et kvotespørsmål med kode "SAMISK-TILH"
      Og opptaksforvalteren angir navn "Samisk tilhørighet" på bokmål
      Og opptaksforvalteren angir spørsmålstekst "Er du av samisk ætt?" på bokmål
      Så er kvotespørsmålet opprettet

  Regel: Kvotespørsmål har navn og tekst på flere språk

    Scenario: Flerspråklig kvotespørsmål
      Når opptaksforvalteren oppretter kvotespørsmålet "SAMISK-TILH"
      Og opptaksforvalteren angir navn og spørsmålstekst på bokmål, nynorsk, engelsk og samisk
      Så er tekstene lagret på alle fire språk

  Regel: Et kvotespørsmål kan kobles til en algoritme som besvarer det automatisk

    Scenario: Tilgjengelige algoritmer
      Når opptaksforvalteren skal koble kvotespørsmålet "ER-KVINNE" til en algoritme
      Så kan opptaksforvalteren velge mellom algoritmene:
        | Algoritme |
        | Er kvinne |
        | Er mann   |

    Scenario: Koble kvotespørsmål til en algoritme
      Gitt at kvotespørsmålet "ER-KVINNE" finnes
      Når opptaksforvalteren kobler kvotespørsmålet "ER-KVINNE" til algoritmen "Er kvinne"
      Så besvares kvotespørsmålet "ER-KVINNE" automatisk for hver søker ut fra algoritmen

  Regel: Kvotespørsmål kan knyttes til en kvotetype

    Scenario: Knytte kvotespørsmål til kvotetype
      Gitt at kvotespørsmålet "SAMISK-TILH" finnes
      Når opptaksforvalteren knytter kvotespørsmålet "SAMISK-TILH" til kvotetypen "SAMISK"
      Så brukes kvotespørsmålet til å avgjøre om søkeren plasseres i kvotetypen "SAMISK"

    Scenario: Knytte flere kvotespørsmål til samme kvotetype
      Gitt at kvotetypen "JENTER-HARDANGER" finnes
      Når opptaksforvalteren knytter kvotespørsmålene "ER-KVINNE" og "FRA-HARDANGER" til kvotetypen "JENTER-HARDANGER"
      Så må begge kvotespørsmålene være besvart ja før søkeren plasseres i kvotetypen "JENTER-HARDANGER"

    Scenario: Informasjon om automatisk plassering
      Gitt at kvotetypen "ORD" ikke har kvotespørsmål
      Når opptaksforvalteren ser på kvotetypen "ORD"
      Så ser opptaksforvalteren at søkere plasseres automatisk i kvotetypen "ORD"

  Regel: Et kvotespørsmål kan slettes

    Scenario: Slette kvotespørsmål
      Gitt at kvotespørsmålet "TestSporsmal" ikke er knyttet til noen kvotetype
      Når opptaksforvalteren sletter kvotespørsmålet "TestSporsmal"
      Så er kvotespørsmålet "TestSporsmal" slettet
