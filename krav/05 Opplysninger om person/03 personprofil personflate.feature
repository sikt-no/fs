# language: no
@skip @personopplysning
Egenskap: Se og endre egne person- og kontaktopplysninger
  Som person har jeg behov for å kunne se mine egne person- og kontaktopplysninger i Min kompetanse, så jeg vet hvilke opplysninger
  som er registrert om meg som søker, student eller resultateier. Som person har jeg også behov for å kunne endre 

  Bakgrunn:
    Gitt at person er logget på Min kompetanse
    Gitt at person har en personprofil

  Scenariomal: Se mine egne personopplysninger
    Når "<person>" ser på sin profil
    Så ser personen "<navn>"
    Så ser personen "<bilde>"
    Så ser personen "<Studentinformasjon>"
    #Så ser personen "<fødselsdato>"
    #Så ser personen "<statsborgerskap>"

    Eksempler:
      | person | navn | bilde | Studentinformasjon | fødselsdato | statsborgerskap |

  Scenariomal: Se mine egne kontaktopplysninger
    Når "<person>" ser på sin profil
    Så ser personen "<telefonnummer>"
    Så ser personen "<e-post>"
    Så ser personen "<kontaktadresse>

#Scenariomal: Endre kontaktopplysninger
#Når "<personen>" endrer "<kontaktopplysninger>"
#Så ser "<personen>" oppdaterte "<kontaktopplysninger>"
# Eksempler: "<kontaktopplysninger>"
# | person | land | gate og gatenummer | postnummer | poststed | 
# | testperson | Danmark | Smørbrødgade 3 | 9999 | København | 

  Scenariomal: Legge til kontaktperson
    Når "<person>" oppgir "<kontaktperson info>"
    Så ser "<person>" registrert "<kontaktperson info>"
    Og "<administrator>" ser oppdatert "<kontaktperson info>"

    Eksempler:
      | person     | kontaktperson info | administrator |
      | astrid aga | mamma              | bodhild aga   |
      | per ulv    | jeg er syk         | bodhild aga   |

  Scenariomal: Se og endre Språk og målform
    Når "<person>" legger til <språk og målform>
    Så ser "<person>" oppdatert <språk og målform> 
    # Mulig det bør være to forskjellige steg for person og administrator, siden de er i forskjellige brukerflater.
    Så ser "<administrator>" oppdatert <språk og målform>

    Eksempler:
      | person      | språk og målform | administrator |
      | Ola Normann | Norsk bokmål     | bodhild aga§  |
      | King Arthur | Engelsk          | bodhild aga   |
      | Ivar Aasen  | Nynorsk          | bodhild aga   |
