# language: no
@OPT-REG-KVO-002 @must @draft
Egenskap: Kvotespørsmål
  Som opptaksforvalter
  ønsker jeg å definere kvotespørsmål
  slik at det kan avgjøres om en søker tilhører en bestemt kvote.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at regelverkssamlingen "UHG2027" er opprettet
    Og at kvotetypen "SAMISK" finnes i samlingen

  Regel: Opptaksforvalter kan opprette kvotespørsmål med kode, navn og spørsmålstekst

    Scenario: Opprette kvotespørsmål
      Når jeg oppretter et kvotespørsmål med kode "SAMISK-TILH"
      Og jeg angir navn "Samisk tilhørighet" på bokmål
      Og jeg angir spørsmålstekst "Er du av samisk ætt?" på bokmål
      Så er kvotespørsmålet opprettet

  Regel: Kvotespørsmål har navn og tekst på flere språk

    Scenario: Flerspråklig kvotespørsmål
      Når jeg oppretter kvotespørsmålet "SAMISK-TILH"
      Og jeg angir navn og spørsmålstekst på bokmål, nynorsk, engelsk og samisk
      Så er tekstene lagret på alle fire språk

  Regel: Kvotespørsmål har en preutfyllingsstrategi

    Scenario: Kvotespørsmål besvares automatisk
      Når jeg oppretter kvotespørsmålet "FV-SJEKK" med preutfylling "AUTOMATISK"
      Så besvares spørsmålet automatisk basert på en algoritme

    Scenario: Kvotespørsmål besvares av saksbehandler
      Når jeg oppretter kvotespørsmålet "SPESIAL-VURD" med preutfylling "SAKSBEHANDLER"
      Så må saksbehandler besvare spørsmålet manuelt

    Scenario: Kvotespørsmål preutfylles med ja
      Når jeg oppretter kvotespørsmålet "ALLE-FV" med preutfylling "JA"
      Så preutfylles svaret med ja for alle søkere

    Scenario: Kvotespørsmål preutfylles med nei
      Når jeg oppretter kvotespørsmålet "INGEN-FV" med preutfylling "NEI"
      Så preutfylles svaret med nei for alle søkere

  Regel: Kvotespørsmål kan knyttes til en kvotetype

    Scenario: Knytte kvotespørsmål til kvotetype
      Gitt at kvotespørsmålet "SAMISK-TILH" finnes
      Når jeg knytter kvotespørsmålet til kvotetypen "SAMISK"
      Så brukes spørsmålet for å avgjøre om søkeren tilhører samisk kvote

  Regel: Et kvotespørsmål kan slettes

    Scenario: Slette kvotespørsmål
      Gitt at kvotespørsmålet "TestSporsmal" ikke er knyttet til noen kvotetype
      Når jeg sletter kvotespørsmålet
      Så er det slettet