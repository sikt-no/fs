# language: no
@OPP-PRO-PRO-001
Egenskap: Personprofil
            Som administrator trenger jeg å kunne få opp person- og kontaktopplysninger for personer jeg slår opp for å sikre at jeg snakker med riktig person før jeg kan gi mer informasjon eller veiledning.
            Det er likegyldig om tilknytningsforholdet er at personen jeg har søkt på en utdanning, har eller har hatt studierett, har resultater registrert, eller kun er registrert som fagperson.
            #Happy path - mulig bilde må ut i første produksjonsiterasjon
  @ci
  Scenariomal: Administrator ser person- og kontaktopplysninger i en personprofil
    Gitt at administrator er inne på personsøket
    Når administrator søker på unik "<input>"
    Så ser administrator følgende informasjon
      | felt            | verdi             |
      | navn            | <navn>            |
      | fødselsdato     | <fødselsdato>     |
      | fødselsnummer   | <fødselsnummer>   |
      | studentnummer   | <studentnummer>   |
      | feidebrukernavn | <feidebrukernavn> |
      | statsborgerskap | <statsborgerskap> |
      | kontaktspråk    | <kontaktspråk>    |
      | bilde           | <bilde>           |
      | telefonnummer   | <telefonnummer>   |
      | e-postadresse   | <e-postadresse>   |
      | postadresse     | <postadresse>     |
    Eksempler:
      | input                | navn                 | fødselsdato | fødselsnummer | studentnummer | feidebrukernavn       | statsborgerskap | kontaktspråk | bilde  | telefonnummer | e-postadresse                                        | postadresse           |
      | Misfornøyd Ambassade | Misfornøyd Ambassade |  03.09.2010 |   03891099923 | 10            | no310236284_elev_2_8a | norsk           | norsk        | nei    |      99999910 | misfornoyd@mail.com, misfornoyd_ambassade@sikt-ths.no| Fritjof Nansens Vei 19|

  Scenariomal: Folkeregistrert adresse er noe annet enn postadresse
    Gitt at "<folkeregistrert adresse>" er forskjellig fra "<postadresse>"
    Når administrator åpner personprofilen til "<navn>"
    Så kan administrator klikke på merknad om at flere adresser er registrert for å få opp "<folkeregistrert adresse>"
    Eksempler:
      |navn               |folkeregistrert adresse|postadresse |
      |Vertikal Branngate |Fridtjof Nansens vei 19|Vestgrensa 4|
      |Kranglete Artisjokk|Fridtjof Nansens vei 19|Vestgrensa 4|

  @skip
  Scenario: Person har ikke samtykket til å dele bilde
    Gitt at brukeren "Per Askeladd" ikke har samtykket til å dele bilde
    Når administrator åpner personprofilen til "Per Askeladd"
    Så får ikke administrator se bilde

  @skip
  Scenariomal: Person har fortrolig adresse
            #trusselutsatte personer med adressesperre, folkeregisterloven § 10-4, beskyttelseseinstruks § 4, jf § 3 jf offentlighetsloven §24-3-2-1
    Gitt "<Person med fortrolig adresse>" er registrert med "<adressesperrekode>"
    Når administrator åpner profilen til "<Person med fortrolig adresse>"
    Så ser administrator merknad om "fortrolig adresse" og "<kontaktpunkt>" for personen
    Eksempler:
      | Person med fortrolig adresse | adressesperrekode | kontaktpunkt              |
      | Maria Maridalen Much         | FORTROLIG         | Institutt for informatikk |
      | Henning Honningsvåg          | STRENGT FORTROLIG | Sentraladministrasjon     |

  @skip
  Scenariomal: Person er registrert med sanksjon i RUST (register for utstestengte studenter)
            #usikkert om vi bør bruke detaljert hjemmel (§3-7-8 studentopptak - bruk av falsk dokumentasjon, $4-8-1.2 Utestening og bortvisning grovt forstyrrende eller grovt klanderverdig opptreden
            # §4-8-2 Utestengig og bortvisning, grovt klanderverdig opptreden, §4-8-3 Utestengig og bortvisning - fusk eller forsettelig medvirkning til fusk. 4-10-3 Utestengig etter skikkethetsverudering
            # eller mer effekt (Opptakskarantene, Påmeldingsnekt med periode)
            #tror kanskje vi bør gjemme hjemmelsgrunnlaget med tilgangsstyring, men at effekten med periode bør fremheves pga høyere infoverdi
    Gitt "<Person med sanksjon>" er registrert med aktiv "<sanksjonskode>"
    Når administrator åpner profilen til "<Person med sanksjon>"
    Så ser administrator "<utestengingsmerknad>" og "<kontaktpunkt>" for personen

    Eksempler:
      | Person med sanksjon| sanksjonskode     | utestengingsmerknad | kontaktpunkt          |
      | Familiær Bane      | UTESTENGT         | SKIKKETHET          | Medisinsk fakultet    |
      | Diego Maradona     | EKSAMENSKARANTENE | FUSK                | Sentraladministrasjon |