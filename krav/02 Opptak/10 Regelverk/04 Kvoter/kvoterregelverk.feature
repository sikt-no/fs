# language: no
# GitHub: #376
@OPT-REG-KVO-001 @must @draft
Egenskap: Kvotetype
  Som opptaksforvalter
  ønsker jeg å definere kvotetyper i regelverkssamlingen
  slik at plasser kan reserveres for bestemte grupper søkere.

  Bakgrunn:
    Gitt at opptaksforvalteren er innlogget
    Og at regelverkssamlingen "UHG2027" er opprettet

  Regel: Opptaksforvalter kan opprette en kvotetype med kode, navn og rangeringsmetode

    Scenario: Opprette ordinær kvote
      Når opptaksforvalteren oppretter en kvotetype med kode "ORD"
      Og opptaksforvalteren angir navn "Ordinær kvote" på bokmål
      Og opptaksforvalteren setter kvoterangering til "KP" (konkurransepoeng)
      Så er kvotetypen "ORD" opprettet i regelverkssamlingen

    Scenario: Opprette førstegangsvitnemålskvote
      Når opptaksforvalteren oppretter en kvotetype med kode "ORDF"
      Og opptaksforvalteren angir navn "Førstegangsvitnemål" på bokmål
      Og opptaksforvalteren setter kvoterangering til "SP" (skolepoeng)
      Så er kvotetypen "ORDF" opprettet i regelverkssamlingen

  Regel: Kvotetyper har navn på flere språk

    Scenario: Flerspråklig navn på kvotetype
      Når opptaksforvalteren oppretter kvotetypen "ORD"
      Og opptaksforvalteren angir navn på bokmål, nynorsk, engelsk og samisk
      Så er navnene på kvotetypen "ORD" lagret på alle fire språk

  Regel: En kvotetype kan ha en default poengformel

    Scenario: Sette default poengformel
      Gitt at poengformelen "KONKURRANSEPOENG" finnes
      Når opptaksforvalteren oppretter kvotetypen "ORD" med default poengformel "KONKURRANSEPOENG"
      Så brukes poengformelen "KONKURRANSEPOENG" som standard for kvotetypen "ORD"

  Regel: En kvotetype har en kvoteprioritet som bestemmer rekkefølgen

    Scenario: Sette kvoteprioritet
      Når opptaksforvalteren oppretter kvotetypen "ORDF" med kvoteprioritet 1
      Og opptaksforvalteren oppretter kvotetypen "ORD" med kvoteprioritet 2
      Så prøves søkere i førstegangsvitnemålskvoten før ordinær kvote

  Regel: En kvotetype kan ha plassflyt til en annen kvotetype

    # Merk: plassflyt på kvotetypenivå er default. Faktisk plassflyt settes
    # per utdanningskvote på utdanningstilbudet og kan overstyre denne.
    Scenario: Sette default plassflyt
      Gitt at kvotetypene "ORD" og "ORDF" finnes
      Når opptaksforvalteren setter at kvotetypen "ORDF" har plassflyt til "ORD"
      Så flyter ledige plasser i ORDF-kvoten til ORD-kvoten som default

  Regel: En kvotetype gjelder for grunnlagene den er koblet til

    Scenario: Koble grunnlag til kvotetype
      Når opptaksforvalteren kobler grunnlagene "VES" og "PRA" til kvotetypen "ORD"
      Så kan søkere som er kvalifisert på grunnlaget "VES" eller "PRA", plasseres i kvotetypen "ORD"

    Scenario: Aldersgrensen følger grunnlaget
      Gitt at grunnlaget "PRA" har aldersgrensen større enn 22 år
      Når opptaksforvalteren kobler grunnlaget "PRA" til kvotetypen "ORD"
      Så gjelder aldersgrensen på grunnlaget "PRA" også for kvotetypen "ORD"
      Men opptaksforvalteren kan ikke sette en egen aldersgrense på kvotetypen "ORD"

    Scenario: Kvotetype uten grunnlag og kvotespørsmål
      Gitt at kvotetypen "TestKvote" verken har grunnlag eller kvotespørsmål
      Når søknadene i opptaket behandles
      Så plasseres ingen søkere automatisk i kvotetypen "TestKvote"

  Regel: En kvotetype kan ha fire ulike rangeringsmetoder

    Scenariomal: Kvoterangering
      Når opptaksforvalteren oppretter en kvotetype med kvoterangering "<metode>"
      Så rangeres søkere i kvoten etter <beskrivelse>

      Eksempler:
        | metode | beskrivelse                  |
        | KP     | konkurransepoeng             |
        | SP     | skolepoeng                   |
        | SPEV   | spesiell vurdering           |
        | IH     | individuell helhetsvurdering |

  Regel: En kvotetype kan slettes når den ikke er i bruk

    Scenario: Slette kvotetype
      Gitt at kvotetypen "TestKvote" ikke er knyttet til noe utdanningstilbud
      Når opptaksforvalteren sletter kvotetypen "TestKvote"
      Så er kvotetypen "TestKvote" slettet

    Scenario: Kan ikke slette kvotetype som er i bruk
      Gitt at kvotetypen "ORD" er knyttet til utdanningstilbud
      Når opptaksforvalteren forsøker å slette kvotetypen "ORD"
      Så får opptaksforvalteren beskjed om at kvotetypen "ORD" er i bruk
