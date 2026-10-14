# language: no
@OPT-REG-SAM-001 @must @implemented @scope-regelverk-2027
Egenskap: Regelverkssamling
  Som opptaksforvalter
  ønsker jeg å opprette og forvalte regelverkssamlinger
  slik at kompetansekrav, rangeringsregler, kvotetyper og grunnlag kan samles og kobles til opptak.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter

  # Justert etter koden 2026-10-14 (retrofitting): fs-admin har navn bare på bokmål, og ved sletting av en
  # samling som er i bruk vises en generell feilmelding.
  Regel: Opptaksforvalter kan opprette en regelverkssamling

    Scenario: Opprette regelverkssamling
      Når jeg oppretter en ny regelverkssamling med kode "UHG2027"
      Og jeg angir navnet på bokmål
      Så er regelverkssamlingen opprettet
      Og den eies av organisasjonen jeg er opptaksforvalter ved

  Regel: En regelverkssamling er bundet til én organisasjon

    Scenario: Regelverkssamling eies av organisasjonen som opprettet den
      Gitt at regelverkssamlingen "UHG2027" er opprettet av HK-dir
      Så eier HK-dir regelverkssamlingen
      Og andre organisasjoner kan ikke redigere den uten å kopiere den først

  Regel: En regelverkssamling kan kopieres til en annen organisasjon

    Scenario: Kopiere regelverkssamling
      Gitt at regelverkssamlingen "UHG2027" eies av HK-dir
      Når jeg kopierer regelverkssamlingen til organisasjonen jeg er opptaksforvalter ved
      Så får organisasjonen jeg er opptaksforvalter ved en egen kopi av regelverkssamlingen med alt innhold
      Og endringer i originalen påvirker ikke kopien

  @draft @openquestion
  Regel: En regelverkssamling kan deaktiveres
    # ÅPNE SPØRSMÅL:
    # - I dag har deaktivering ingen virkning: inaktive samlinger kan fortsatt velges for nye opptak
    #   (verifisert 2026-10-14). Skal de skjules når samling velges for et nytt opptak?

    Scenario: Deaktivere regelverkssamling
      Gitt at regelverkssamlingen "UHG2027" er aktiv
      Når jeg deaktiverer regelverkssamlingen
      Så er regelverkssamlingen ikke lenger tilgjengelig for nye opptak
      Men eksisterende opptak som bruker den påvirkes ikke

  Regel: En regelverkssamling kan slettes når den ikke er knyttet til et opptak

    Scenario: Slette regelverkssamling som ikke er i bruk
      Gitt at regelverkssamlingen "TestSamling" ikke er knyttet til noe opptak
      Når jeg sletter regelverkssamlingen
      Så er regelverkssamlingen slettet

    Scenario: Kan ikke slette regelverkssamling som er i bruk
      Gitt at regelverkssamlingen "UHG2027" er knyttet til opptaket "Samordna opptak 2027"
      Når jeg forsøker å slette regelverkssamlingen
      Så blir regelverkssamlingen ikke slettet
      Og jeg får beskjed om at regelverkssamlingen ikke kunne slettes

  Regel: Regelverkssamlingen inneholder kompetanseregelverk, rangeringsregelverk, kvotetyper, grunnlag og mangelkoder

    Scenario: Se innholdet i en regelverkssamling
      Gitt at regelverkssamlingen "UHG2027" er opprettet
      Når jeg åpner regelverkssamlingen
      Så ser jeg oversikt over kompetanseregelverk
      Og jeg ser oversikt over rangeringsregelverk
      Og jeg ser oversikt over kvotetyper
      Og jeg ser oversikt over grunnlag
      Og jeg ser oversikt over mangelkoder