# language: no
@OPT-REG-RAN-001 @must @draft
Egenskap: Rangeringsregelverk
  Som opptaksforvalter
  ønsker jeg å opprette og vedlikeholde rangeringsregelverk
  slik at kvalifiserte søkere kan rangeres mot hverandre.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at regelverkssamlingen "UHG2027" er opprettet
    Og at det finnes grunnlag, poengklasser og poengvarianter i samlingen

  Regel: Opptaksforvalter kan opprette et rangeringsregelverk med kode og beskrivelse

    Scenario: Opprette rangeringsregelverk
      Når jeg oppretter et nytt rangeringsregelverk med kode "ORD-RANG"
      Og jeg angir beskrivelse "Ordinær rangering for UHG" på bokmål
      Og jeg angir at regelverket er aktivt
      Så er rangeringsregelverket opprettet i regelverkssamlingen

  Regel: Et rangeringsregelverk kobler grunnlag til poengtyper

    Scenario: Koble grunnlag til poengtyper
      Gitt at rangeringsregelverket "ORD-RANG" er opprettet
      Når jeg kobler grunnlaget "VES" til poengtypene "KAR-HELE" og "ALD-STD"
      Og jeg kobler grunnlaget "FOR" til poengtypene "KAR-FORKURS" og "ALD-STD"
      Så vet rangeringen hvilke poengtyper som gjelder for hvert grunnlag

  Regel: Et rangeringsregelverk har beskrivelse på flere språk

    Scenario: Flerspråklig beskrivelse
      Når jeg oppretter rangeringsregelverket "ORD-RANG"
      Og jeg angir beskrivelse på bokmål, nynorsk, engelsk og samisk
      Så er beskrivelsene lagret på alle fire språk

  Regel: Et rangeringsregelverk kan aktiveres og deaktiveres

    Scenario: Deaktivere rangeringsregelverk
      Gitt at rangeringsregelverket "ORD-RANG" er aktivt
      Når jeg deaktiverer rangeringsregelverket
      Så er det ikke lenger tilgjengelig for nye utdanningstilbud

  Regel: Et rangeringsregelverk kan slettes når det ikke er i bruk

    Scenario: Slette rangeringsregelverk
      Gitt at rangeringsregelverket "TestRang" ikke er knyttet til noe utdanningstilbud
      Når jeg sletter rangeringsregelverket
      Så er det slettet

    Scenario: Kan ikke slette rangeringsregelverk som er i bruk
      Gitt at rangeringsregelverket "ORD-RANG" er knyttet til utdanningstilbud
      Når jeg forsøker å slette rangeringsregelverket
      Så får jeg beskjed om at det er i bruk og ikke kan slettes