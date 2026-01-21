# language: no
@OPP-PRO-PRO-004 @skip @personopplysning
Egenskap: Se og endre egne kontaktopplysninger
  Som person har jeg behov for å kunne se mine egne kontaktopplysninger i Min kompetanse, så jeg vet hvilke opplysninger
  som er registrert om meg som søker, student eller resultateier. Som person har jeg også behov for å kunne endre noen av disse opplysningene. 
  Jeg har også behov for at lærestedet får se riktig kontaktopplysninger om meg slik at jeg blir behandlet riktig

  Bakgrunn:
    Gitt det finnes kontaktopplysninger om en bruker

  Scenariomal: Se mine egne kontaktopplysninger
    Når "<person>" ser på sin profil
    Så ser person "<telefonnummer>"
    Så ser person "<e-post>"
    Så ser person "<kontaktadresse>

  Scenariomal: administrator ser brukers kontaktopplysninger
    Gitt at administrator er inne på FS-admin
    Når "<administrator>" ser på personprofil
  #Så ser administrator "<telefonnummer>"
  #Så ser administrator "<e-postadresse>"
  #Så ser administrator "<kontaktadresse>"

    Eksempler:
      | telefonnummer | e-postadresse | kontaktadresse |

  Scenariomal: Endre egen kontaktadresse
    Når "<person>" endrer "<kontaktadresse>"
    Så ser "<person>" oppdatert "<kontaktadresse>"
    Så ser administrator oppdatert "<kontaktadresse>"

    Eksempler:
      | person     | land    | gate og gatenummer | postnummer | poststed  |
      | testperson | Danmark | Smørbrødgade 3     |       9999 | København |
