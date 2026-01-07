# language: no
@skip @støtteprosesser
Egenskap: 08 Teknisk: Gi tilbakemelding 
  Som bruker trenger jeg å kunne gi tilbakemeldinger enkelt og raskt via brukerflatene, slik at teamene kan få innsikt i mine erfaringer, problemer og behov så tidlig som mulig, og så enkelt og greit som mulig.
  Jeg vil gjerne gi tilbakemeldinger både i en testfase, og på funksjonalitet i produksjon.

  Bakgrunn:
    Gitt at bruker er på innlogget på FS Admin eller Min Kompetanse

  Scenariomal: Bruker gir tilbakemelding
    Når bruker er på "<en side>"
    Så kan bruker gi "<tilbakemelding>" om feil eller forbedringer

    Eksempler:
      | en side      |tilbakemelding|
      | gruppesøk i FS Admin    | feilmelding|
      | personprofil i Min kompetanse |forbedringsforslag|
      | begrepsside for student i FS Portal|forbedringsforslag|

   Scenario: Bruker sender inn feilmelding 
    Når bruker sender inn feilmelding
    Så opprettes bug til vurdering

  Scenario: Bruker sender inn forbedringsønske
    Når bruker sender inn feilmelding
    Så opprettes forbedringssak til vurdering    

   Scenario: Bruker beskriver tilbakemelding skriftlig
    Når bruker gir tilbakemelding
    Så kan bruker skrive den i tekst    

  Scenario: Bruker tar skjermbilde
    Når bruker gir tilbakemelding
    Så kan bruker ta skjermbilde av innhold i nettleser

  Scenario: Bruker annoterer på skjermbilde
    Gitt at bruker tar skjermbilde
    Når bruker gir tilbakemelding med skjermbilde
    Så kan bruker annotere på skjermbilde

  Scenario: Bruker fjerner skjermbilde
    Gitt at bruker tar skjermbilde
    Når bruker gir tilbakemelding
    Så kan bruker fjerne skjermbilde og ta nytt ved behov
