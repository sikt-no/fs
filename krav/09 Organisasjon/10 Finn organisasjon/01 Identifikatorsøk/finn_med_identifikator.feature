# language: no

@ORG-SØK-IDE-001 @must
Egenskap: Finn organisasjon med identifikator
  Som en studieadministrator som vet hvilken organisasjon jeg leter etter
  ønsker jeg å slå den opp med en presis identifikator
  slik at jeg kommer direkte til riktig organisasjonsprofil uten å måtte velge fra en liste.

  Bakgrunn:
    Gitt at jeg er på organisasjonssøket

  Regel: Søk på unik identifikator gir direktetreff

    Scenariomal: Organisasjonen vises direkte ved søk på identifikator
      Når jeg søker på "<søkeverdi>"
      Så skal jeg se organisasjonsprofilen direkte

      Eksempler:
        | søkeverdi | identifikator       |
        | 1234      | organisasjonskode   |
        | 971035854 | organisasjonsnummer |
        | N OSLO01  | Erasmuskode         |
        | 999885022 | PIC-nummer          |