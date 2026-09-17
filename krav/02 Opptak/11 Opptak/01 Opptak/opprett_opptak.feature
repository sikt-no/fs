# language: no
@OPT-OPT-OPT-001 @must @draft
Egenskap: Opprette et opptak
  Som opptaksforvalter
  ønsker jeg å opprette et opptak for min organisasjon
  slik at utdanningstilbud kan knyttes til det og søkere kan søke.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter

  Regel: Opptaksforvalter kan opprette et samordnet eller lokalt opptak

    Scenario: Opprette et samordnet opptak
      Når jeg oppretter et nytt opptak
      Og jeg velger at opptaket skal være samordnet
      Og jeg gir opptaket navnet "Samordna opptak 2027"
      Og jeg knytter til regelverkssamlingen "UHG 2027"
      Og jeg lagrer opptaket
      Så er opptaket opprettet
      Og organisasjonen min eier opptaket

    Scenario: Opprette et lokalt opptak
      Når jeg oppretter et nytt opptak
      Og jeg velger at opptaket skal være lokalt
      Og jeg gir opptaket navnet "Lokalt opptak høst 2027"
      Og jeg knytter til regelverkssamlingen "Lokalt regelverk"
      Og jeg lagrer opptaket
      Så er opptaket opprettet
      Og organisasjonen min eier opptaket

  Regel: Navn er obligatorisk for å lagre et opptak

    Scenario: Lagre opptak uten navn
      Når jeg oppretter et nytt opptak
      Og jeg knytter til regelverkssamlingen "UHG 2027"
      Men jeg gir ikke opptaket et navn
      Så kan jeg ikke lagre opptaket

  Regel: Navn som eksponeres til søkere må kunne angis på flere språk

    Scenario: Angi opptaksnavn på flere språk
      Gitt at jeg har opprettet opptaket "Samordna opptak 2027"
      Når jeg angir navn på bokmål, nynorsk, engelsk og samisk
      Så er navnene lagret på alle fire språk

  Regel: Et opptak må ha en regelverkssamling

    Scenario: Knytte regelverkssamling til opptak
      Gitt at jeg har opprettet opptaket "Samordna opptak 2027"
      Når jeg knytter til regelverkssamlingen "UHG 2027"
      Så er reglene i regelverkssamlingen tilgjengelige for utdanningstilbud i opptaket

  @should
  Regel: Det skal være mulig å gjenbruke innstillinger fra et tidligere opptak

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Hva kopieres og hva kopieres ikke?
    # - Forslag: innstillinger, frister og fellestekster kopieres.
    #   Utdanningstilbud, inviterte læresteder og opptaksrunder kopieres ikke.
    Scenario: Opprette opptak basert på tidligere opptak
      Gitt at opptaket "Samordna opptak 2026" finnes med innstillinger, frister og fellestekster
      Når jeg oppretter et nytt opptak basert på "Samordna opptak 2026"
      Så kopieres innstillinger fra det tidligere opptaket som utgangspunkt

  @should
  Regel: Endringer på innstillinger i opptaket skal loggføres

    # Bygger på en generell revisjonsmekanisme som gjelder på tvers av FS.
    # Opptaket definerer hva som skal logges, mekanismen definerer hvordan.
    Scenario: Endring på opptak loggføres
      Gitt at opptaket "Samordna opptak 2027" finnes
      Når jeg endrer en innstilling i opptaket
      Så loggføres endringen med hvem som utførte den, fra hvilken organisasjon og når
