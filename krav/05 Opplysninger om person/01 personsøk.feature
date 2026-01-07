# language: no
@støtteprosesser 
Egenskap: Personsøk
  Som administrator trenger jeg å kunne søke opp personer knyttet til lærestedet (organisasjonen) jeg jobber for, uten av jeg på forhånd nødvendigvis vet om personen er søker, student eller resultateier hos oss, for å kunne ivareta informasjons- og veiledningsplikten vår på en god måte.
  Hvis jeg har søkt opp en personer etter gitte kriterier, så må jeg enten få se den personen som matcher søket mitt, eller få opp en liste med relevante personer som matcher søket mitt.

  Bakgrunn:
    Gitt at administrator er inne på personsøket
  # Returerer ingen treff

  Scenario: Administrator er ansatt ved organisasjon ved gjennomføring av personsøk
  Gitt administratoren er ansatt ved organisasjon
  Så ser administrator "Borghild Aga"

  @harTest @levert
  Scenario: Administrator søker på en verdi som ikke finnes
    Når administrator søker på "Erik Akselabb"
    Så skal administrator få ingen resultater og informeres om at det er ingen resultater

  @harTest @levert
  Scenariomal: Administrator søker på en kombinasjon av flere numeriske verdier
    Når administrator søker på "<input>"
    Så skal administrator få ingen resultater og informeres om at det er ingen resultater

    Eksempler:
      | input                |
      | 03891099923 99999910 |
      |          11 99999911 |

  @harTest @levert
  Scenariomal: Administrator gjør fritekstsøk etter personer som gir ett svar
    Når administrator søker på "<input>"
    Så ser administrator personprofilen til "<output>"

    Eksempler:
      | inputtype     | input                            | output               |
      | navn          | Misfornøyd Ambassade             | Misfornøyd Ambassade |
      | fødselsdato   |                       03.09.2010 | Misfornøyd Ambassade |
      | fødselsnummer |                      03891099923 | Misfornøyd Ambassade |
      | telefonnummer |                         99999910 | Misfornøyd Ambassade |
      | e-post org    | misfornoyd_ambassade@sikt-ths.no | Misfornøyd Ambassade |
      | studentnummer |                               10 | Misfornøyd Ambassade |
      | feidebruker   |                           123409 | Misfornøyd Ambassade |
      | privat e-post | misfornoyd@mail.com              | Misfornøyd Ambassade |



      
      #|søknadsnummer|MAS-0101010  | Hermione Granger | (vi har ikke søk på søknadsnummer ennå? Ta det samtidig med søknad?)
  #|personløpenummer|1000001|Hermione Granger| (vi har ikke søk på personløpenummer ennå, til vurdering)

  @harTest @levert
  Scenariomal: Administrator søker på en kombinasjon av navn og e-post
    Når administrator søker på "<input>"
    Så ser administrator personprofilen til "<output>"

    Eksempler:
      | input                      | output               |
      | Misfornøyd Ambassade @sikt | Misfornøyd Ambassade |
      | Ambassade misfornoy        | Misfornøyd Ambassade |

  @harTest @levert
  Scenariomal: Case insensitive søk på navn
    Når administrator søker på "<input>"
    Så ser administrator personprofilen til "<output>"

    Eksempler:
      | input                | output               |
      | misfornøyd ambassade | Misfornøyd Ambassade |
      | misFornøyd AmbAssade | Misfornøyd Ambassade |
  
  Scenario: Administrator søker på verdi med flere svar
    Når administrator søker på "Duck"
    Så skal administrator få se "Dolly Duck" i en liste
    Så skal administrator få se "Donald Duck" i en liste
    Så skal administrator få se "Hetti Duck" i en liste

  @harTest
  Scenario: Resultat gir mer enn 1000 treff
    Når administrator søker på "A"
    Så skal administrator få se ingen resultater og en feilemelding som indikerer at søket må begrenses
