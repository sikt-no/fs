# language: no
@skip @personopplysninger
Egenskap: Se og endre egne samtykker
  Som student har jeg behov for å kunne se og endre mine egne samtykker i Min kompetanse, så jeg vet hvilke data
  jeg deler med hvem. Som administrator har jeg behov for å se hva en student har samtykket til, så jeg kan veilede studenten basert på den informasjonen jeg finner, dersom det skulle bli nødvendig.

  Bakgrunn:
    Gitt at person er logget på Min kompetanse
    Gitt at person har en personprofil

  Scenariomal: Se mine egne samtykker
    Når "<person>" ser på sin profil
    Så ser personen "<samtykker>"

    Eksempler:
      | person | samtykker |

  Scenariomal: Endre egne samtykker
    Når "<person>" endrer sine "<samtykker>"
    Så ser personen endrede "<samtykker>"
    Så ser <administrator> endrede "<samtykker>"

    Eksempler:
      | person | Administrator | Samtykker                         |
      |      1 |             1 |Mitt bilde kan brukes i studieadministrativ sammenheng|
      |      2 |             2 |Jeg vil ha Europeisk studentbevis |
      |      3 |             3 |Jeg vil søke lån automatisk hos Lånekassen |
