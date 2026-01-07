# language: no
@skip @støtteprosesser @sikkerhet
Egenskap: Tilgangskontroll
  Som organisasjoner som bruker FS til studieadministrasjon, må vi være trygge på at kun aktive, autoriserte brukere som får tilgang til å se data om våre søkere og studenter (tidligere og aktive), for å sikre deres data/opplysninger og personvern.
  # Scenarier for FS Admin

  Bakgrunn:
    Gitt at person er ansatt i FS-organisasjon
    Gitt at ansatt er innlogget på FS Admin
    #Antagelse: må være ansatt for å kunne logge på FS Admin i det hele tatt
    #FS-organisasjon er lærested, opptaksinstand eller utviklerorgansiasjon Sikt/FS

  Scenario: Innlogget ansatt har ikke FS-bruker
    Gitt at ansatt ikke har FS-bruker
    Når ansatt er på startsiden
    Så får person ikke tilgang til noe data
    Så får person beskjed om at hen ikke er bruker
    Så får person lenke til informasjon om brukere i FS Admin
    #infoside om hvem som kan bli brukere og aktuelle kontaktpunkter, ev. henvisning til søknadsskjemaer?

  Scenariomal: Innlogget ansatt har inaktiv FS-bruker
    Gitt at ansatt har inaktiv FS-bruker
    Når "<inaktiv bruker>" er på "<en side>"
    Så får person ikke tilgang til noe data
    Så får person beskjed om at hen har "<inaktiv brukerstatus>"
    Så får person mulighet til å "søke om å gjenåpne bruker"

    Eksempler:
      | inaktiv bruker    | en side   | inaktiv brukerstatus                                                                                                           |
      | Ada Utløpt Nilsen | startside | Din FS-bruker er utløpt 12.03.2024. Du har ikke lenger tilgang til FS Admin ved Sikthøyskolen                                  |
      | Abel Låst Hansen  | personsøk | Din FS-bruker er låst 01.06.2023 på grunn av manglende passordbytte. Du har ikke lenger tilgang til FS Admin ved Sikthøyskolen |

  Scenario: Innlogget ansatt har aktiv FS-bruker
    Gitt at ansatt har aktiv FS-bruker
    Når aktiv bruker "Borghild Aga" er på startsiden
    Så får "Borghild Aga" se sin hjemside
    Så får "Borghild Aga" tilgang til å lese data for organisasjon "7777 Sikthøyskolen"

    #tilgangskontroll til menyvalg for systemadministratorer

  Scenario: bruker er ikke systemadministrator
    Når bruker "Ada Martinsen" ikke er systemadministrator
    Så får "Ada Martinsen" ikke se oversiktsside for tilgangsstyring i menyvalget

  Scenariomal: Bruker er systemadministrator
    Når "<bruker>" er systemadministrator for FS ved "<organisasjon>"
    Så får "<bruker>" opp menyvalg for tilgangsstyring

    Eksempler:
      | bruker           | organisasjon                               |
      | Borghild Aga     |                         7777 Sikthøyskolen |
      | Cal-El Supermann | Sikt Kunnskapssektorens tjenesteleverandør |
    # vi prioriterer i første omgang eksempel nr 2!

  Scenariomal: systemadministrator navigerer til oversiktsside for tilgangsstyring
    Når "<systemadministrator>" klikker på menyvalget for tilgangsstyring
    Så kommer "<systemadministrator>" til oversiktsside for tilgangsstyring

    Eksempler:
      | systemadministrator |
      | Bodhild Aga         |
      | Cal-El Supermann    |