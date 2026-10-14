# language: no
@OPT-REG-GRU-001 @must @implemented @scope-regelverk-2027
Egenskap: Grunnlag og mangelkoder
  Som opptaksforvalter
  ønsker jeg å definere grunnlag og mangelkoder
  slik at søkeres dokumentasjonsgrunnlag og mangler kan registreres.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at regelverkssamlingen "UHG2027" er opprettet

  # Justert etter koden 2026-10-14 (retrofitting): fs-admin har navn bare på bokmål, ingen beskrivelse,
  # og én avkrysning for kvalifisering og rangering.
  Regel: Opptaksforvalter kan opprette et grunnlag med kode og navn

    Scenario: Opprette grunnlag for generell studiekompetanse
      Når jeg oppretter et grunnlag med kode "VES"
      Og jeg angir navnet "Videregående med studiekompetanse" på bokmål
      Og jeg angir at det brukes i generell studiekompetanse
      Og jeg angir at det brukes i kvalifisering og rangering
      Så er grunnlaget opprettet i regelverkssamlingen

    Scenario: Opprette grunnlag for forkurs
      Når jeg oppretter et grunnlag med kode "FOR"
      Og jeg angir navnet "Forkurs for ingeniørutdanning" på bokmål
      Og jeg angir at det brukes i kvalifisering og rangering
      Men det brukes ikke i generell studiekompetanse
      Så er grunnlaget opprettet

    Scenario: Opprette grunnlag for realkompetanse
      Når jeg oppretter et grunnlag med kode "REAL"
      Og jeg angir navnet "Realkompetanse" på bokmål
      Og jeg angir at det brukes i kvalifisering og rangering
      Og jeg angir at poeng skal skjules for søker
      Så er grunnlaget opprettet med skjulte poeng

  Regel: Et grunnlag har flagg som styrer hvor det brukes

    Scenario: Grunnlag som brukes i kvalifisering og rangering
      Når jeg angir at grunnlaget "REAL" brukes i kvalifisering og rangering
      Så kan grunnlaget brukes både i kompetansekrav og i rangeringsregelverk

  Regel: Grunnlag brukes i både kompetansekrav, rangeringsregelverk og kvotetyper

    Scenario: Grunnlag brukt på tvers
      Gitt at grunnlaget "VES" finnes
      Når jeg bruker "VES" i et kompetansekrav
      Og jeg bruker "VES" i et rangeringsregelverk
      Og jeg bruker "VES" på en kvotetype
      Så refererer alle tre til det samme grunnlaget

  Regel: Et grunnlag kan slettes når det ikke er i bruk

    Scenario: Slette grunnlag som ikke er i bruk
      Gitt at grunnlaget "TestGrunnlag" ikke er brukt i noe regelverk
      Når jeg sletter grunnlaget
      Så er det slettet

  Regel: Mangelkoder (GSK) definerer hva som mangler for kvalifisering

    Scenario: Se tilgjengelige mangelkoder
      Når jeg åpner oversikten over mangelkoder i regelverkssamlingen
      Så ser jeg hvilke typer mangler som kan registreres på søkere