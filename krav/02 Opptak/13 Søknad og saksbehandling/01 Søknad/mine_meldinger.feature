# language: no
@OPT-SØK-SØK-010 @must @implemented
Egenskap: Se meldinger om egne søknader
  Som en søker
  ønsker jeg å se meldingene jeg har fått om søknadene mine
  slik at jeg får med meg kvitteringer, mangler og annen beskjed fra lærestedet.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse

  Regel: Meldingslisten viser søkerens egne, ikke-arkiverte meldinger

    Scenario: Søkeren ser meldingene sine
      Gitt at søkeren har mottatt meldinger
      Når søkeren åpner meldingsoversikten
      Så vises søkerens meldinger i en liste

    Scenario: Arkiverte meldinger vises ikke
      Gitt at søkeren har både arkiverte og ikke-arkiverte meldinger
      Når søkeren åpner meldingsoversikten
      Så vises kun de ikke-arkiverte meldingene

    Scenario: Søkeren har ingen meldinger
      Gitt at søkeren ikke har mottatt meldinger
      Når søkeren åpner meldingsoversikten
      Så får søkeren beskjed om at det ikke finnes meldinger

  Regel: Søkeren kan filtrere meldingene

    Scenario: Tilgjengelige meldingstyper i filter
      Når søkeren åpner meldingstypefilteret
      Så inneholder filteret meldingstypene søkeren har mottatt meldinger av
      Og "Alle typer" er valgt som standard

    Scenariomal: Filtrere på meldingstype <type>
      Gitt at søkeren har meldinger av flere meldingstyper
      Når søkeren velger <type> som filter
      Så vises kun meldinger av typen <type>

      Eksempler:
        | type       |
        | KVITTERING |
        | MANGEL     |
        | DOKUMENT   |
        | GENERELL   |

    Scenario: Tilgjengelige år i filter
      Når søkeren åpner årsfilteret
      Så inneholder filteret årene søkeren har mottatt meldinger i
      Og "Alle år" er valgt som standard

    Scenario: Filtrere på år
      Gitt at søkeren har meldinger fra flere år
      Når søkeren velger et år som filter
      Så vises kun meldinger mottatt det året

    Scenario: Vise kun uleste meldinger
      Gitt at søkeren har både leste og uleste meldinger
      Når søkeren velger å vise kun uleste meldinger
      Så vises kun de uleste meldingene

    Scenario: Kombinere filtre
      Når søkeren kombinerer meldingstype, år og uleste
      Så vises kun meldinger som matcher alle kriteriene

  Regel: Meldinger merkes som lest når de åpnes

    Scenario: Søkeren åpner en ulest melding
      Gitt at søkeren har en ulest melding
      Når søkeren åpner meldingen
      Så vises innholdet i meldingen
      Og meldingen er merket som lest

    Scenario: Søkeren ser hvor mange uleste meldinger som finnes
      Gitt at søkeren har uleste meldinger
      Når søkeren er innlogget i Min kompetanse
      Så vises antall uleste meldinger

  Regel: Kvitteringsmeldinger viser hvilken søknad de gjelder

    Scenario: Søkeren åpner en kvittering for en levert søknad
      Gitt at søkeren har mottatt en melding av typen KVITTERING for en levert søknad
      Når søkeren åpner meldingen
      Så vises hvilket opptak og hvilke utdanningstilbud kvitteringen gjelder
