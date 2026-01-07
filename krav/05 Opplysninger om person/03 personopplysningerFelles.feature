# language: no
@skip @personopplysning
Egenskap: Se og endre egne personopplysninger
  Som person har jeg behov for å kunne se mine egne personopplysninger i Min kompetanse, så jeg vet hvilke opplysninger
  som er registrert om meg som søker, student eller resultateier. Som person har jeg også behov for å kunne endre noen av disse opplysningene. 
  Jeg har også behov for at lærestedet får se riktig kontakt og personopplysninger om meg slik at jeg blir behandlet riktig

  Bakgrunn:
    Gitt det finnes personopplysninger om en bruker

  Scenariomal: Se egne personopplysninger
    Gitt at bruker er inne på Min kompetanse
    Når "<person>" ser på sin profil
    Så ser personen "<navn>"
    Så ser personen "<bilde>"
    Så ser personen "<institusjons e-post>"
    Så ser personen "<studentnummer>"
    #Vurderes i senere versjoner
      #Så ser personen "<fødselsdato>"
      #Så ser personen "<statsborgerskap>"
      #Så ser personen "<Bankkonto>" + endre Bankkonto
      #Så ser personen "<Hjemstedsadresse>"

    Eksempler:
      | person | navn | bilde | institusjons e-post | studentnummer | fødselsdato | statsborgerskap | Bankkonto | Hjemstedsadresse |

  Scenariomal: administrator ser brukers personopplysninger
    Gitt at administrator er inne på FS-admin
    Når "<administrator>" ser på personprofil
    Så ser administrator "<navn>"
    Så ser administrator "<Studentinformasjon>"
    Så ser administrator "<fødselsdato>"
    Så ser administrator "<statsborgerskap>"
    Så ser administrator "<fødselsnummer>"
    Så ser administrator "<studentnummer>"
    Så ser administrator "<feidebrukernavn>"
    Så ser administrator "<kontaktspråk>"
#Administrator skal evt. kunne se bilde dersom person har samtykket til dette. Trenger juridisk avklaring
    Så ser administrator "<bilde>"

    Eksempler:
      | navn | fødselsdato | fødselsnummer | studentnummer | feidebrukernavn | statsborgerskap | kontaktspråk | telefonnummer | e-postadresse | postadresse |

  Scenariomal: Se mine egne kontaktopplysninger
    Når "<person>" ser på sin profil
    Så ser person "<telefonnummer>"
    Så ser person "<e-post>"
    Så ser person "<kontaktadresse>

  Scenariomal: administrator ser brukers kontaktopplysninger
    Gitt at administrator er inne på FS-admin
    Når "<administrator>" ser på personprofil
    Så ser administrator "<telefonnummer>"
    Så ser administrator "<e-postadresse>"
    Så ser administrator "<kontaktadresse>"

    Eksempler:
      | telefonnummer | e-postadresse | kontaktadresse |

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
