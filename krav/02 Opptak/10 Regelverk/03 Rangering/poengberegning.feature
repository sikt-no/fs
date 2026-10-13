# language: no
@OPT-REG-RAN-002 @must @draft
Egenskap: Poengberegning
  Som opptaksforvalter
  ønsker jeg å definere poengklasser, poengvarianter, poengtyper og poengformler
  slik at søkere kan få beregnet poengsum for rangering.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at regelverkssamlingen "UHG2027" er opprettet

  Regel: Opptaksforvalter kan opprette poengklasser

    Scenario: Opprette poengklasse
      Når jeg oppretter en poengklasse med kode "KAR"
      Og jeg angir navn "Karakterpoeng" på bokmål
      Og jeg angir default-verdi 0
      Så er poengklassen opprettet

    Scenario: Poengklasse med flerspråklig navn
      Når jeg oppretter poengklassen "ALD"
      Og jeg angir navn på bokmål, nynorsk, engelsk og samisk
      Så er navnene lagret på alle fire språk

  Regel: Opptaksforvalter kan opprette poengvarianter

    Scenario: Opprette poengvariant
      Når jeg oppretter en poengvariant med kode "HELE"
      Og jeg angir beskrivelse "Hele vitnemål" på bokmål
      Så er poengvarianten opprettet

  Regel: En poengtype er kombinasjonen av poengklasse og poengvariant

    Scenario: Opprette poengtype
      Gitt at poengklassen "KAR" og poengvarianten "HELE" finnes
      Når jeg oppretter en poengtype for "KAR" + "HELE"
      Og jeg setter minimum til 0, maksimum til 70, antall desimaler til 1 og antall sifre til 3
      Så er poengtypen "KAR-HELE" opprettet

    Scenario: Poengtype med algoritme
      Gitt at poengklassen "ALD" og poengvarianten "STD" finnes
      Når jeg oppretter en poengtype for "ALD" + "STD"
      Og jeg knytter poengalgoritmen "AlderspoengAlgoritme" til poengtypen
      Så beregnes alderspoeng automatisk

    Scenario: Poengtype med poengtrinn
      Gitt at poengklassen "KAR" og poengvarianten "HELE" finnes
      Når jeg oppretter poengtypen med poengtrinn 0.1
      Så rundes poengsummen til nærmeste 0.1

  Regel: Opptaksforvalter kan opprette poengformler med uttrykk

    Scenario: Opprette poengformel
      Når jeg oppretter en poengformel med kode "KONKURRANSEPOENG"
      Og jeg angir uttrykket som summerer poengklassene "KAR + ALD + TILLEGG"
      Og jeg angir navn "Konkurransepoeng" på bokmål
      Så er poengformelen opprettet

    Scenario: Ugyldig formeluttrykk avvises
      Når jeg forsøker å opprette en poengformel med uttrykket "KAR + + ALD"
      Så får jeg feilmelding om at uttrykket er ugyldig

  Regel: Poengklasser, poengvarianter og poengtyper kan slettes når de ikke er i bruk

    Scenario: Slette poengklasse som ikke er i bruk
      Gitt at poengklassen "TestKlasse" ikke er brukt i noen poengtype
      Når jeg sletter poengklassen
      Så er den slettet

    Scenario: Kan ikke slette poengtype som er i bruk
      Gitt at poengtypen "KAR-HELE" er brukt i et rangeringsregelverk
      Når jeg forsøker å slette poengtypen
      Så får jeg beskjed om at den er i bruk