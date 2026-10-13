# language: no
@OPT-REG-KRA-001 @must @draft
Egenskap: Kompetanseregelverk
  Som opptaksforvalter
  ønsker jeg å opprette og vedlikeholde kompetanseregelverk
  slik at kravene for kvalifisering av søkere er definert.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at regelverkssamlingen "UHG2027" er opprettet

  Regel: Opptaksforvalter kan opprette et kompetanseregelverk med kode, beskrivelse og forklaring

    Scenario: Opprette kompetanseregelverk
      Når jeg oppretter et nytt kompetanseregelverk i regelverkssamlingen
      Og jeg angir kode "GSK-UHG" og beskrivelse "Generelle krav for UHG-opptak"
      Og jeg angir at regelverket er aktivt
      Så er kompetanseregelverket opprettet i regelverkssamlingen

  Regel: Kompetanseregelverk har beskrivelse og forklaring på flere språk

    Scenario: Flerspråklig beskrivelse og forklaring
      Når jeg oppretter et kompetanseregelverk
      Og jeg angir beskrivelse på bokmål, nynorsk, engelsk og samisk
      Og jeg angir forklaring (markdown) på bokmål, nynorsk, engelsk og samisk
      Så er tekstene lagret på alle fire språk

  Regel: Et kompetanseregelverk kan ha flere kompetansekrav med ulike grunnlag

    Scenario: Kompetansekrav med flere grunnlag
      Når jeg oppretter kompetanseregelverket "Ingeniør elektronikk UiT" med kode "ELUIT"
      Og jeg legger til et kompetansekrav med grunnlagene "VES" og "VOV"
      Og jeg legger til kravelementene "GENS", "FFMAT" og "FFYS1" for disse grunnlagene
      Og jeg legger til et annet kompetansekrav med grunnlaget "FOR"
      Og jeg legger til kravelementene "FORFYS" og "FORMAT" for dette grunnlaget
      Og jeg lagrer kompetanseregelverket
      Så har regelverket to kompetansekrav med ulike grunnlag

  Regel: Kompetansekrav kan kreve at alle eller ett av underkravene er oppfylt

    Scenario: Alle krav må oppfylles (OG-logikk)
      Når jeg legger til et kompetansekrav med "krever alle" satt til ja
      Og jeg legger til kravelementene "GENS", "FFMAT" og "FFYS1"
      Så må søkeren oppfylle alle tre kravelementene for å bli kvalifisert

    Scenario: Ett av kravene er tilstrekkelig (ELLER-logikk)
      Når jeg legger til et kompetansekrav med "krever alle" satt til nei
      Og jeg legger til tre alternative kravgrupper
      Så er det tilstrekkelig at søkeren oppfyller én av de tre alternativene

  Regel: Kompetansekrav kan ha tilleggskrav med kravlister og kravelementer

    Scenario: Opprette kompetanseregelverk med alternative tilleggskrav
      Når jeg oppretter kompetanseregelverket "HING" for ingeniørstudier
      Og jeg legger til kravelementet "GENS" (Generell studiekompetanse)
      Og jeg legger til tilleggskrav med tre alternativer:
        | Alternativ | Kravelementer              | Minimumskrav       |
        | 1          | Matematikk R1, Fysikk 1   | Karakter 3         |
        | 2          | Matematikk R2              | Karakter 4         |
        | 3          | Matematikk S1+S2, Fysikk 1| Karakter 4, 4, 3   |
      Og jeg definerer at søkeren må oppfylle ett av de tre alternativene
      Og jeg lagrer kompetanseregelverket
      Så har regelverket ELLER-logikk mellom tilleggskravgruppene

  Regel: Kravelementer kan ha karakterkrav med ulike kravtyper

    Scenario: Sette karakterkrav på kravelement
      Gitt at jeg redigerer et kompetansekrav
      Når jeg legger til kravelementet "FFMAT" (Matematikk R1)
      Og jeg setter følgende karakterkrav:
        | Kravtype       | Verdi | Beskrivelse                      |
        | Resultatkrav   |       | Ingen krav til totalresultat     |
        | Standpunktkrav | 3     | Krav til standpunktkarakter      |
        | Eksamenskrav   | 2     | Krav til eksamenskarakter        |
      Så vises kravelementet med de definerte karakterkravene

    Scenario: Sette gjennomsnittskrav
      Gitt at jeg redigerer et kompetansekrav
      Når jeg legger til kravelementet "NORSK" med resultatkrav 3
      Så beregnes gjennomsnittet av hovedmål, sidemål og muntlig mot kravet

  Regel: Kompetansekrav kan kreve generell studiekompetanse

    Scenario: Sette GSK-krav
      Når jeg legger til et kompetansekrav med "krever generell studiekompetanse" satt til ja
      Så må søkeren ha generell studiekompetanse for å bli kvalifisert gjennom dette kravet

  Regel: Et kompetanseregelverk kan aktiveres og deaktiveres

    Scenario: Deaktivere kompetanseregelverk
      Gitt at kompetanseregelverket "GSK-UHG" er aktivt
      Når jeg deaktiverer kompetanseregelverket
      Så er det ikke lenger tilgjengelig for nye utdanningstilbud

  Regel: Et kompetanseregelverk kan slettes når det ikke er i bruk

    Scenario: Slette kompetanseregelverk som ikke er i bruk
      Gitt at kompetanseregelverket "TestKrav" ikke er knyttet til noe utdanningstilbud
      Når jeg sletter kompetanseregelverket
      Så er det slettet

    Scenario: Kan ikke slette kompetanseregelverk som er i bruk
      Gitt at kompetanseregelverket "GSK-UHG" er knyttet til utdanningstilbud
      Når jeg forsøker å slette kompetanseregelverket
      Så får jeg beskjed om at det er i bruk og ikke kan slettes