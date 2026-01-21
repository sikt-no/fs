# language: no
@GJE-STR-STR-001 @ci
Egenskap: Kort om studieprogram
  Som admninistrator trenger jeg å raskt kunne se sammenfattet info om en persons studieprogramtilknytninger, for å kunne gi tilpasset informasjon.
# populært kalt lilla boks

  Bakgrunn:
    Gitt administratoren er logget inn
    Gitt at administrator er inne på personsøket

@levert
  Scenario: Personen har ikke noen studieretter
    Når administrator åpner personprofilen til "Misfornøyd Ambassade"
    Så ser administrator melding om "ingen registrert studierett"

@levert
  Scenariomal: Personen har en studierett
    Når administrator åpner personprofilen til "<input>"
    Så ser administrator "<studienivå>"
    Så ser administrator "<programnavn>"
    Så ser administrator "<programkode>"
    Så ser administrator "<lærested>"
    Så ser administrator "<campus>"
    Så ser administrator "<organisasjonsenhet>"
    Så ser administrator "<studierettstatus>"
    Så ser administrator "<studierettsperiode>"
    Så ser administrator "<starttermin>"
    Så ser administrator "<kull>"
    Så ser administrator "<studiepoeng oppnådd>"
    Så ser administrator "<klasse>"

    Eksempler:
      | input                 | studienivå | programnavn        | programkode | lærested | campus   |organisasjonsenhet| studierettstatus| studierettsperiode        | starttermin | kull      | studiepoeng oppnådd | klasse       |
      | Misfornøyd Ambassade  | Master     | Master             | MASTER      | SIKT_THS | Oslo     | Sikt testhøyskole|aktiv            | 01.08.2024                |   2024 HØST | 2024 HØST |           30 av 120 |              |
      | Misfornøyd Ambassade  | Bachelor   | Bachelor           | BACHELOR    | SIKT_THS |Trondheim | Sikt testhøyskole| fullført        | 01.08.2021 til 30.06.2024 |   2021 HØST | 2021 HØST |          180 av 180 |              |
      | Misfornøyd Ambassade  | Bachelor   | Ingeniør           | INGENIØR    | SIKT_THS | Oslo     | Sikt testhøyskole| inndratt        |01.08.2020                 |   2020 HØST | 2020 HØST |            0 av 180 | superingeniør|

@levert
  Scenario: Personen har flere studieretter - navigering
    Når administrator åpner personprofilen til "Bettina Testregina"
    Så kan administrator navigere mellom alle hennes aktive, fremtidige og utløpte studieretter

@levert
  Scenario: Personen har en aktiv, en utløpt og en fremtidig studierett - statusrekkefølge (primærsortering)
    Når administrator åpner personprofilen til "Natalija Liv Lang-Læring"
    Så ser administrator først hennes aktive studierett på "MNM1-LED"
    Så ser administrator hennes fremtige studierett på "BI-ORG"
    Så ser administrator hennes utløpte studieretter på "BA-LAER", "BA-MAT", "BA-SYK"

@levert
  Scenario: Personen har flere aktive studieretter - kronologisk rekkefølge
    Når administrator åpner personprofilen til "Fliniks Flinkisen"
    Så ser administrator den nyeste studieretten "HFB-HIS" med startdato 01.08.2024 før hen ser "HFB-ANT" med startdato 01.08.2023

@levert
  Scenario: Personen har flere aktive studieretter - nivårekkefølge
    Når administrator åpner personprofilen til "Fliniks Flinkisen2"
    Så ser administrator studieretten ved "HFM2-ANT" med startdato 01.08.2024 før hen ser "HFB-HIS" med startdato 01.08.2024

@levert
  Scenario: Personen har flere aktive studieretter - alfabetisk rekkefølge
    Når administrator åpner personprofilen til "Fliniks Flinkisen3"
    Så ser administrator studieretten ved "HFB-ANT" med startdato 01.08.2024 før hen ser "HFB-HIS" med startdato 01.08.2024

@levert
  Scenariomal: Personen har merknad knyttet til en studierett
    Når administrator åpner personprofilen til "<input>"
    Så ser administrator "<merknader>" knyttet til "<program>"

    Eksempler:
      | input              | merknader                                       | program           |
      | Økologisk badering | 50% permisjon frem til 01.01.2025               | MASTER Master     |
      | Ronald Weasley     | Studierett begrenset til fagområde gammelgresk  | BACHELOR Bachelor |
      | Enver Hoxha        | Studierett begrenset til EMNE                   | ENK Emnestudierett|
