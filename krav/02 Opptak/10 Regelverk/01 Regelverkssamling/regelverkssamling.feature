# language: no
@OPT-REG-SAM-001 @must @draft
Egenskap: Regelverkssamling
  Som opptaksforvalter
  ønsker jeg å opprette og forvalte regelverkssamlinger
  slik at kompetansekrav, rangeringsregler, kvotetyper og grunnlag kan samles og kobles til opptak.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter

  Regel: Opptaksforvalter kan opprette en regelverkssamling

    Scenario: Opprette regelverkssamling
      Når jeg oppretter en ny regelverkssamling med kode "UHG2027"
      Og jeg angir navn på bokmål, nynorsk, engelsk og samisk
      Så er regelverkssamlingen opprettet
      Og den eies av min organisasjon

  Regel: En regelverkssamling er bundet til én organisasjon

    Scenario: Regelverkssamling eies av organisasjonen som opprettet den
      Gitt at regelverkssamlingen "UHG2027" er opprettet av HK-dir
      Så eier HK-dir regelverkssamlingen
      Og andre organisasjoner kan ikke redigere den uten å kopiere den først

  Regel: En regelverkssamling kan kopieres til en annen organisasjon

    Scenario: Kopiere regelverkssamling
      Gitt at regelverkssamlingen "UHG2027" eies av HK-dir
      Når jeg kopierer regelverkssamlingen til min organisasjon
      Så får min organisasjon en egen kopi av regelverkssamlingen med alt innhold
      Og endringer i originalen påvirker ikke kopien

  Regel: En regelverkssamling kan deaktiveres

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
      Så får jeg beskjed om at regelverkssamlingen er i bruk og ikke kan slettes

  Regel: Navn på regelverkssamling kan angis på flere språk

    Scenario: Flerspråklig navn
      Når jeg oppretter en regelverkssamling
      Og jeg angir navn på bokmål, nynorsk, engelsk og samisk
      Så er navnene lagret på alle fire språk

  Regel: Regelverkssamlingen inneholder kompetanseregelverk, rangeringsregelverk, kvotetyper, grunnlag og mangelkoder

    Scenario: Se innholdet i en regelverkssamling
      Gitt at regelverkssamlingen "UHG2027" er opprettet
      Når jeg åpner regelverkssamlingen
      Så ser jeg oversikt over kompetanseregelverk
      Og jeg ser oversikt over rangeringsregelverk
      Og jeg ser oversikt over kvotetyper
      Og jeg ser oversikt over grunnlag
      Og jeg ser oversikt over mangelkoder