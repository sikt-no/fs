# language: no

Egenskap: Tilby utdanning
Som administrator ved lærested som tilbyr utdanning i Norge trenger jeg å aktivt tilby utdanning til
  søkere og studenter i en periode.

  Scenariomal: Opprette utdanningstilbud i tid
    Gitt at utdanning finnes og er tilknyttet minst ett lærested
    Når administrator registrerer "<utdanning>" som et aktivt utdanningstilbud
    Så opprettes utdanningsinstans for "<utdanning>"

    Eksempler:
    |utdanning                             |
    |studieprogram HFB-ANT Antikkens kultur|
    |emne ANT1100 Antikkens verden         |
    |kurs EVU1530 emne uten studiepoeng    |
    |studieprogram MNM2 Nisseverksted      |

    Scenario: Tilgjengeliggjøre utdanningstilbud for søknad
     Gitt at utdanningstilbudet er opprettet
      Når administrator registrerer opptak på utdanningen
      Så blir utdanningstilbudet tilgjengelig for søknad
