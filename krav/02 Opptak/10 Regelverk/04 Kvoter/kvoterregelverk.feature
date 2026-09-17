# language: no
@OPT-REG-KVO-001 @must @draft
Egenskap: Kvotetype
  Som opptaksforvalter
  ønsker jeg å definere kvotetyper i regelverkssamlingen
  slik at plasser kan reserveres for bestemte grupper søkere.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at regelverkssamlingen "UHG2027" er opprettet

  Regel: Opptaksforvalter kan opprette en kvotetype med kode, navn og rangeringsmetode

    Scenario: Opprette ordinær kvote
      Når jeg oppretter en kvotetype med kode "ORD"
      Og jeg angir navn "Ordinær kvote" på bokmål
      Og jeg setter kvoterangering til "KP" (konkurransepoeng)
      Så er kvotetypen opprettet i regelverkssamlingen

    Scenario: Opprette førstegangsvitnemålskvote
      Når jeg oppretter en kvotetype med kode "ORDF"
      Og jeg angir navn "Førstegangsvitnemål" på bokmål
      Og jeg setter kvoterangering til "SP" (skolepoeng)
      Så er kvotetypen opprettet

  Regel: Kvotetyper har navn på flere språk

    Scenario: Flerspråklig navn på kvotetype
      Når jeg oppretter kvotetypen "ORD"
      Og jeg angir navn på bokmål, nynorsk, engelsk og samisk
      Så er navnene lagret på alle fire språk

  Regel: En kvotetype kan ha en default poengformel

    Scenario: Sette default poengformel
      Gitt at poengformelen "KONKURRANSEPOENG" finnes
      Når jeg oppretter kvotetypen "ORD" med default poengformel "KONKURRANSEPOENG"
      Så brukes denne formelen som standard for kvotetypen

  Regel: En kvotetype har en kvoteprioritet som bestemmer rekkefølgen

    Scenario: Sette kvoteprioritet
      Når jeg oppretter kvotetypen "ORDF" med kvoteprioritet 1
      Og jeg oppretter kvotetypen "ORD" med kvoteprioritet 2
      Så prøves søkere i førstegangsvitnemålskvoten før ordinær kvote

  Regel: En kvotetype kan ha plassflyt til en annen kvotetype

    # Merk: plassflyt på kvotetypenivå er default. Faktisk plassflyt settes
    # per utdanningskvote på utdanningstilbudet og kan overstyre denne.
    Scenario: Sette default plassflyt
      Gitt at kvotetypene "ORD" og "ORDF" finnes
      Når jeg setter at kvotetypen "ORDF" har plassflyt til "ORD"
      Så flyter ledige plasser i ORDF-kvoten til ORD-kvoten som default

  Regel: En kvotetype kan ha gyldige grunnlag med aldersgrenser

    Scenario: Sette grunnlag med aldersgrense på kvotetype
      Når jeg legger til grunnlaget "VES" på kvotetypen "ORD"
      Og jeg setter aldersgrense til 23 med operator "eldre enn"
      Så gjelder kvotetypen for søkere med grunnlag "VES" som er eldre enn 23

  Regel: En kvotetype kan ha fire ulike rangeringsmetoder

    Scenariomal: Kvoterangering
      Når jeg oppretter en kvotetype med kvoterangering "<metode>"
      Så rangeres søkere i kvoten etter <beskrivelse>

      Eksempler:
        | metode | beskrivelse              |
        | KP     | konkurransepoeng         |
        | SP     | skolepoeng               |
        | SPEV   | spesiell vurdering       |
        | IH     | individuell helhetsvurdering |

  Regel: En kvotetype kan slettes når den ikke er i bruk

    Scenario: Slette kvotetype
      Gitt at kvotetypen "TestKvote" ikke er knyttet til noe utdanningstilbud
      Når jeg sletter kvotetypen
      Så er den slettet

    Scenario: Kan ikke slette kvotetype som er i bruk
      Gitt at kvotetypen "ORD" er knyttet til utdanningstilbud
      Når jeg forsøker å slette kvotetypen
      Så får jeg beskjed om at den er i bruk