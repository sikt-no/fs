# language: no
  @skip @studieadministrasjon
  Egenskap: Utdanningsoversikt for person
    Som administrator har jeg behov for en samlet utdanningsoversikt for personer jeg informerer og veileder, slik at jeg kan gi dem riktig informasjon og
  sakssvarende veiledning for deres situasjon.

  Bakgrunn:
      Gitt administratoren er logget inn
      Gitt at administrator er inne på personprofilen til en person som har studierett

    #Førsteversjon - sortering pr planlagt termin
    Scenariomal: Utdanningsoversikt visning sortert etter planlagt termin i studieplan
      Gitt at administrator sorterer utdanningsoversikten sorter etter planlagt semester
      Gitt at administrator velger Viser emner fra "<studieprogram>"
      Når administrator ser på utdanningsoversikten til "<student>"
      Så ser administrator "<emner>" sortert etter planlagt termin
      Så ser administrator "<utdanningsplanelementer>" sortert etter "<planlagt termin>"
      Eksempler:
      |studieprogram|student|emner|utdanningsplanelementer|planlagt termin|

        #andreversjon - sortering pr studieoppbygging (emnekombinasjon og emnestatus)
    Scenariomal: Utdanningsoversikt visning sortert etter studieoppbyggingsstruktur
      Gitt at administrator sorterer utdanningsoversikten sorter etter studieoppbyggingsstruktur
      Gitt at administrator velger Viser emner fra "<studieprogram>"
      Når administrator ser på utdanningsoversikten til "<student>"
      Så ser administrator "<emner>" sortert etter "<studieoppbyggingsstruktur>"
      Så ser administrator "<utdanningsplanelementer>" sortert etter "<studieoppbyggingsstruktur>"
      Eksempler:
        |studieprogram|student|emner|utdanningsplanelementer|studieoppbyggingsstruktur|

        #tredjeversjon - sortering etter gjennomføring
    Scenariomal: Utdanningsoversikt visning sortert etter planlagt termin i studieplan
      Gitt at administrator sorterer utdanningsoversikten sorter etter gjennomføringsstatus
      Gitt at administrator velger "Viser alle emner"
      Når administrator ser på utdanningsoversikten til "<student>"
      Så ser administrator alle "<emner>" sortert etter "<gjennomføringsstatus>"
      Så ser administrator alle "<utdanningsplanelementer>" sortert etter etter "<gjennomføringsstatus>"
      Eksempler:
       |student|emner|utdanningsplanelementer|gjennomføringsstatus|

      #aktuelt uavhengig av versjon
    Scenariomal: Emnevisning i utdanningsoverskt
      Gitt at administrator ser på utdanningsoversikt
      Når administrator ser på "<emne>" i utdanningsoversikt
      Så ser administrator "<emnekode og emnenavn>"
      Så ser administrator "<antall studiepoeng>" emnet gir
      Så ser administrator "<aktuelle statuser>" for emne
      Eksempler:
      |emne|emnekode og emnenavn|antall studiepoeng|aktuelle statuser|

    Scenariomal: Utdanningsplanelement i utdanningsoverskt
      Gitt at administrator ser på utdanningsoversikt
      Når administrator ser på "<utdanningsplanelement>" i utdanningsoversikt
      Så ser administrator "<navn på planelement>"
      Så ser administrator "<antall studiepoeng>" elementet gir
      Så ser administrator "<aktuelle statuser>" for elementet
      Eksempler:
        |utdanningsplanelement|navn på planelement|antall studiepoeng|aktuelle statuser|

    Scenariomal: Utvid visning av emne eller utdanningsplanelement
      Gitt at administrator er på "<utdanningsoversiktvisning>"
      Når administrator klikker på nedtrekksmenyen for "<emne/utdanningsplanelement>"
      Så ser administrator utvidet visning for "<emne/utdanningsplanelement>"
      Eksempler:
      |utdanningsoversiktvisning|emne/utdanningsplanelement|emne/utdanningsplanelement|
      |planlagt termin          |eksempel                  |eksempel                  |
      |studieoppbygging         |eksempel                  |eksempel                  |
      |studiegjennomføring      |eksempel                  |eksempel                  |

    Scenario: Utvidet emnevisning
      Gitt at administrator utvider visning av emne
      Når administrator ser på utvidet visning av emne
      Så ser administrator valgte utdanningstilbud
      Så ser administrator behandlerorganisasjon
      Så ser administrator saksbehandler
      Så ser administrator tidslinje for søknadsprosessen