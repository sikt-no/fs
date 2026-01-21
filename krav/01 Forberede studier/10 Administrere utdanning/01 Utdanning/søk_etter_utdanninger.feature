# language: no

@FOR-ADM-UTD-004
Egenskap: Søk etter utdanninger
Som studieplanlegger har jeg behov for å kunne søke opp utdanninger og utdanningstilbud som finnes for å kunne vedlikeholde utdanninger og skaffe meg oversikt over utdanninger og utdanningstilbud.
Som opptaksleder har jeg også behov for å kunne søke opp utdanningstilbud som finnes, for å kunne knytte dem til opptak. 

  Bakgrunn:
    Gitt administrator er inne på utdanningssøket

  Scenario: Søk etter utdanninger gir ikke treff
    Når administrator søker på et utplukk eller en kombinasjon av verdier som ikke gir noen treff
    Så får administrator ingen resultater og melding om at søket ikke gir noen treff

  Scenariomal: Søk etter utdanninger gir treff
    Når administrator søker på et utplukk av utdanninger med en kombinasjon av verdier som gir treff
    Så får administrator se resultater av utdanningssøket

  Scenariomal: Resultater fra utdanningssøket vises i en oversikt
  # merk at studienivå og fagområde skal utledes fra NUS/ISCED-klassifisering slik at dataene blir interoperable internasjonalt og på tvers av læresteder. Andre klassifiseringer skal ikke videreføres.
    Når administrator får resultater av utdanningssøket
    Så ser administrator "<studienivå>"
    Så ser administrator "<navn på utdanning>"
    Så ser administrator "<kode på utdanning>"
    Så ser administrator opplysninger om "<fagområde>"
    Så ser administrator opplysninger om "<status>"

    Eksempler:
     |studienivå| navn på utdanning  | kode på utdanning| fagområde         | status|
     |Bachelor  | Antikkens kultur   | HFB-ANT          | klassiske studier | aktiv |

  Scenariomal: Søk og filtrering studieprogramstatus
    Når administrator søker og filtrerer på "<status>"
    Så ser administrator "<utdanninger med valgt status>"

    Eksempler:
      |status|utdanninger med valgt status|
      |aktiv|aktivt studieprogram her        |
      |utløpt|utløpt på dato studieprogram her         |
      |utkast|studieprogram ennå ikke opprettet her    |

  Scenariomal: Søk og filtrering på studienivå
    Når administrator søker og filtrerer på "<studienivå>"
    Så ser administrator "<utdanninger på studienivå>"
    
  Eksempler:
      |studienivå|utdanninger på studienivå|
      |master|Master i idehistorie          |
      |fagskole|fagskolestudium i natur og kultur         |

  Scenario: Administrator får autocomplete støtte ved søk på studieprogram #tror dette er en egen funksjon, laget til gruppesøk, kan gjenbrukes?
    Når administrator begynner å skrive  "jor" i studieprogramfeltet
    Så skal saksbehandler få opp autocomplete forslag "JORDMOR Jordmor"

   Scenariomal: Søk og filtrering på utdanning
    Når administrator søker og filtrerer på "<input>"
    Så ser administrator "<resultater>"
    
  Eksempler:
      |input         |utdanninger       |
      |ant1100|antikkens kultur         |
      |ant|antikkens kultur, antropologi, antagonistisk litteratur|
  

  Scenario: Søk og filtrering på startermin
    Når administrator søker og filtrerer på "<starttermin>"
    Så ser administrator "<utdanninger med starttermin>"

  Eksempler:
      |starttermin  |utdanninger med starttermin |
      |Høst 2025    |Navn Navnesen 1           | 
      |Høst 2025    |Navn Navnesen 2           | 

  Scenario: Søk og filtrering på kull
    Når administrator søker og filtrerer på "<kull>"
    Så ser administrator "<utdanninger med kull>"

  Eksempler:
      |kull         |utdanninger med kull        |
      |Høst 2025    |Navn Navnesen 1           | 
      |Høst 2025    |Navn Navnesen 2           |     
