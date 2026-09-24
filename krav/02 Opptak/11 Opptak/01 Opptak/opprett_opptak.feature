# language: no
@OPT-OPT-OPT-001 @must @draft
Egenskap: Opprette et opptak
  Som opptaksforvalter
  ønsker jeg å opprette et opptak for min organisasjon
  slik at utdanningstilbud kan knyttes til det og søkere kan søke.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget

  Regel: Opptaksforvalter kan opprette et opptak

    Scenario: Opprette et samordnet opptak
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter velger at opptaket skal være samordnet
      Og opptaksforvalter gir opptaket navnet "Samordna opptak 2027"
      Og opptaksforvalter knytter til regelverkssamlingen "UHG 2027"
      Og opptaksforvalter setter opptakstype
      Og opptaksforvalter legger til minst en organisasjon til samordningen
      Og opptaksforvalter lagrer opptaket
      Så er opptaket opprettet
      Og organisasjonen forvalter opptaket

    Scenario: Opprette et lokalt opptak
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter velger at opptaket skal være lokalt
      Og opptaksforvalter gir opptaket navnet "Lokalt opptak høst 2027"
      Og opptaksforvalter knytter til regelverkssamlingen "Lokalt regelverk"
      Og opptaksforvalter setter opptakstype
      Og opptaksforvalter lagrer opptaket
      Så er opptaket opprettet
      Og organisasjonen forvalter opptaket

  Regel: Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak

    Scenario: Lagre opptak uten navn
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter knytter til regelverkssamlingen "UHG 2027"
      Og opptaksforvalter setter opptakstype
      Men opptaksforvalter gir ikke opptaket et navn
      Så kan opptaket ikke lagres

    Scenario: Lagre opptak uten regelverkssamling
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter gir opptaket navnet "Samordna opptak 2027"
      Og opptaksforvalter setter opptakstype
      Men opptaksforvalter knytter ikke til en regelverkssamling
      Så kan opptaket ikke lagres

    Scenario: Lagre opptak uten opptakstype
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter gir opptaket navnet "Samordna opptak 2027"
      Og opptaksforvalter knytter til regelverkssamlingen "UHG 2027"
      Men opptaksforvalter setter ikke opptakstype
      Så kan opptaket ikke lagres

  Regel: Navn som eksponeres til søkere må kunne angis på flere språk

    Scenario: Angi opptaksnavn på flere språk
      Gitt at opptaksforvalter har opprettet opptaket "Samordna opptak 2027"
      Når opptaksforvalter angir navn på bokmål, nynorsk, engelsk og samisk
      Så er navnene lagret på alle fire språk

 Regel: Obligatorisk med både bokmål og nynorsk navn på opptak

    Scenario: Angi opptaksnavn på obligatoriske språk
      Gitt at opptaksforvalter har opprettet opptaket "Samordna opptak 2027"
      Når opptaksforvalter angir navn på bokmål og nynorsk
      Så er obligatoriske navn fylt ut
      

  @should
  Regel: Det skal være mulig å gjenbruke innstillinger fra et tidligere opptak

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Hva kopieres og hva kopieres ikke?
    # - Forslag: innstillinger, frister, eventuelle inviterte læresteder, opptakstype, fellestekster
    #   og utdanningsbakgrunner (med tilhørende konfigurasjon) kopieres.
    #   Utdanningstilbud og regelverkssamling kopieres ikke, men legges til eksplisitt
    Scenario: Opprette opptak basert på tidligere opptak
      Gitt at opptaket "Samordna opptak 2026" finnes med innstillinger, frister og fellestekster
      Når opptaksforvalter oppretter et nytt opptak basert på "Samordna opptak 2026"
      Så kopieres innstillinger fra det tidligere opptaket som utgangspunkt

  @wont
  Regel: Endringer på innstillinger i opptaket skal loggføres
    # Bygger på en generell revisjonsmekanisme som gjelder på tvers av FS.
    # Opptaket definerer hva som skal logges, mekanismen definerer hvordan.
    # Nedprioritert inntil videre.
   # Hvilke endringer som er viktige å få med må vi gå opp
    Scenario: Endring på opptak loggføres
      Gitt at opptaket "Samordna opptak 2027" finnes
      Når opptaksforvalter endrer en innstilling i opptaket
      Så loggføres endringen med hvem som utførte den, fra hvilken organisasjon og når
