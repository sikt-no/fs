# language: no

Egenskap: Gruppesøk
Som administrator trenger jeg å kunne søke opp en gruppe personer som deler samme kriterier, for å kunne behandle disse samlet videre, jeg trenger noen lett tilgjengelige søkefiltre
som hjelper meg å finne grupper av personer jeg ofte jobber med. 

  Bakgrunn:
    Gitt administrator er inne på gruppesøket

  Scenario: Gruppesøket gir ingen treff  
    Når administrator søker på et utplukk eller en kombinasjon av verdier som ikke gir noen treff
    Så får administrator ingen resultater og melding om at søket ikke gir noen treff

  Scenariomal: Gruppesøket gir treff
    Når administrator får "<treff i gruppesøket>"
    Så ser administrator opplysninger om "<navn>"
    Så ser administrator opplysninger om "<fødselsdato>"
    Så ser administrator opplysninger om "<studentnummer>"
    Så ser administrator opplysninger om "<feidebruker>"
    Så ser administrator opplysninger om "<aktive studieretter>"
    Så ser administrator opplysninger om "<betalingsopplysninger>"
    Så ser administrator opplysninger om "<permisjon>"
    Så ser administrator opplysninger om "<aktive søknader>"
    Så ser administrator opplysninger om "<merknad på studierett>"

    Eksempler:
      | treff i gruppesøket    | navn                   | fødselsdato | studentnummer | feidebruker            | aktive studieretter       | betalingsopplysninger | permisjon     | aktive søknader | merknad på studierett        |
      | Misfornøyd Ambassade   | Misfornøyd Ambassade   |  03.09.2010 |            10 | no310236284_elev_2_8a  | BACHELOR Bachelor         | betalt                |               |                 |                              |
      | Kranglete Artisjokk    | Kranglete Artisjokk    |  28.01.2014 |            11 | no310480428_elev_1_7b  | INGENIØR Ingeniør         | betalt                |               |                 |                              |
      | Økologisk badering     | Økologisk Badering     |  22.02.2009 |            12 | no310236284_elev_4_10a | Flere aktive studieretter | betalt                | 50% Permisjon |                 |                              |
      | Familiær Bane          | Familiær Bane          |  13.06.2012 |            13 | no310480428_elev_1_5b  | SYKEPLEIE Sykepleie       | ikke betalt           |               |                 | Startsamtale V26 1. des 2025 |
      | Oppjaget Bas           | Oppjaget Bas           |  08.12.2013 |            14 | no310236284_elev_3_6b  | BACHELOR Bachelor         | betalt                |               |                 |                              |
      | Uemosjonell Betaling   | Uemosjonell Betaling   |  07.02.2013 |            15 | no310236284_elev_3_6a  | JORDMOR Jordmor           | betalt                |               |                 |                              |
      | Eksemplarisk bevegelse | Eksemplarisk Bevegelse |  15.08.2009 |            16 | no310480428_elev_1_8b  | Ingen aktiv studierett    | ikke betalt           |               |                 |                              |
      | Uvitende Bjrønunge     | Uvitende Bjørnunge     |  25.08.2013 |            17 | no310236284_elev_4_5b  | Ingen aktiv studierett    | ikke betalt           |               |                 |                              |
      | Fiolett Bokhylle       | Fiolett Bokhylle       |  10.10.2010 |            18 | no310236284_elev_3_9b  | Enkeltemnestudierett      | betalt                |               | Søkernr (gml FS)|                              |
      | Vertikal Branngate     | Vertikal Branngate     |  05.03.2010 |            19 | no310236284_elev_3_8a  | Ingen aktiv studierett    | ikke betalt           |               | Søknadsnr       |                              |


  Scenariomal: Søk og filtrering på studieprogram
    Når administrator søker og filtrerer på "<studieprogram>"
    Så ser administrator "<studenter på studieprogram>"
    
  Eksempler:
      |studieprogram  |studenter på studieprogram|
      |Studieprogram 1|Navn Navnesen 1           | 
      |Studieprogram 1|Navn Navnesen 2           | 

  Scenario: Administrator får autocomplete støtte ved søk på studieprogram #tror dette er en egen funksjon
    Når administrator begynner å skrive  "jor" i studieprogramfeltet
    Så skal saksbehandler få opp autocomplete forslag "JORDMOR Jordmor"

   Scenariomal: Søk og filtrering på emne
    Når administrator søker og filtrerer på "<emne>"
    Så ser administrator "<studenter på emne>"
    
  Eksempler:
      |emne           |studenter på emne         |
      |Studieprogram 1|Navn Navnesen 1           | 
      |Studieprogram 1|Navn Navnesen 2           |      

  Scenario: Søk og filtrering på startermin
    Når administrator søker og filtrerer på "<starttermin>"
    Så ser administrator "<studenter med starttermin>"

  Eksempler:
      |starttermin  |studenter med starttermin |
      |Høst 2025    |Navn Navnesen 1           | 
      |Høst 2025    |Navn Navnesen 2           | 

  Scenario: Søk og filtrering på kull
    Når administrator søker og filtrerer på "<kull>"
    Så ser administrator "<studenter med kull>"

  Eksempler:
      |kull         |studenter med kull        |
      |Høst 2025    |Navn Navnesen 1           | 
      |Høst 2025    |Navn Navnesen 2           |     

  Scenario: Søk og filtrering ikke betalt semesteravgift inneværende termin
    Når administrator søker og filtrerer på "har ikke betalt semesteravgift"
    Så ser administrator "<studenter som ikke har betalt semesteravgift>" inneværende termin

  Eksempler:
      |har ikke betalt semesteravgift|studenter som ikke har betalt semesteravgift|
      |ikke betalt  |Navn Navnesen 1           | 
      |ikke betalt  |Navn Navnesen 2           |  

    Scenario: Søk og filtrering betalt semesteravgift inneværende termin
    Når administrator søker og filtrerer på "har betalt semesteravgift"
    Så ser administrator "<studenter som har betalt semesteravgift>"

  Eksempler:
      |har betalt semesteravgift|studenter som har betalt semesteravgift|
      |betalt  |Navn Navnesen 1           | 
      |betalt  |Navn Navnesen 2           |  

  Scenario: Søk og filtrering ikke registrert inneværende termin
    Når administrator søker og filtrerer på "har ikke registrert seg"
    Så ser administrator "<studenter som ikke har registrert seg>" inneværende termin

  Eksempler:
      |har ikke registrert seg|studenter som ikke har registrert seg|
      |ikke registert |Navn Navnesen 1           | 
      |ikke registrert|Navn Navnesen 2           |  

   Scenario: Søk og filtrering registrert inneværende termin
    Når administrator søker og filtrerer på "har registrert seg"
    Så ser administrator "<studenter som har registrert seg>" inneværende termin

  Eksempler:
      |har registrert seg|studenter som har registrert seg|
      |registert |Navn Navnesen 1           | 
      |registrert|Navn Navnesen 2           |  


   Scenario: Søk og filtrering aktiv studierett
    Når administrator søker og filtrerer på "aktiv studierett"
    Så ser administrator "<studenter med aktiv studierettstatus>" 

  Eksempler:
      |aktiv studierett|studenter med aktiv studieretsstatus|
      |Aktiv|Navn Navnesen 1           | 
      |Aktiv|Navn Navnesen 2           |  
      
   Scenario: Søk og filtrering utløpt studierett
    Når administrator søker og filtrerer på "utløpt studierettsstatus"
    Så ser administrator "<studenter med utløpt studierettstatus>" 

  Eksempler:
      |utløpt studierett|studenter med utløpt studieretsstatus|
      |Utløpt |Navn Navnesen 1           | 
      |Utløpt |Navn Navnesen 2           |  
      
   Scenario: Søk og filtrering kommende studierett
    Når administrator søker og filtrerer på "kommende studierett"
    Så ser administrator "<studenter med kommende studierettstatus>" 

  Eksempler:
      |kommende studierett|studenter med kommende studieretsstatus|
      |Kommende|Navn Navnesen 1           | 
      |Kommende|Navn Navnesen 2           |  

      
  Scenario: Søk og filtrering på statsborgerskap ukjent
    Når administrator søker og filtrerer på "ukjent"
    Så ser administrator "<personer>" med "<statsborgerskap i resten av verden" 

  Eksempler:
   |personer| statsborgerskap i resten av verden|
  |Navn Navnesen 1           | ukjent|
   |Navn Navnesen 2           |ukjent| 
   
   Scenario: Søk og filtrering på norsk/nordisk statsborgerskap
    Når administrator søker og filtrerer på "norsk/nordisk statsborgerskap"
    Så ser administrator "<personer>" med "<statsborgerskap i Norge eller Norden>" 

  Eksempler:
   |personer| statsborgerskap i Norge eller Norden|
  |Navn Navnesen 1           | Norge|
   |Navn Navnesen 2           | Sverige| 
      
   Scenario: Søk og filtrering på statsborgerskap i EU eller EØS, ekskludert Norden 
    Når administrator søker og filtrerer på "EU-statsborgerskap"
    Så ser administrator "<personer>" med "<statsborgerskap i EU/EØS" 

  Eksempler:
   |personer| statsborgerskap i EU/EØS|
  |Navn Navnesen 1           | Tyskland|
   |Navn Navnesen 2           | Kroatia| 
   
   Scenario: Søk og filtrering på statsborgerskap i resten av verden
    Når administrator søker og filtrerer på "resten av verden"
    Så ser administrator "<personer>" med "<statsborgerskap i resten av verden" 

  Eksempler:
   |personer| statsborgerskap i resten av verden|
  |Navn Navnesen 1           | Brasil|
   |Navn Navnesen 2           | Kina| 

  Scenario: Søk og filtrering på permisjon
    Når administrator søker og filtrerer på "permisjon"
    Så ser administrator "<personer>" med "<permisjonsprosent>" som gjelder dagens dato

  Eksempler:
   |personer| permisjonsprosent|
  |Navn Navnesen 1           |100%|
   |Navn Navnesen 2           |50%| 


  Scenario: Søk og filtrering studenter med merknad
    Når administrator søker og filtrerer på "merknad"
    Så ser administrator "<personer>" med "<merknad>" for studieprogram

  Eksempler:
   |personer| merknad|
  |Navn Navnesen 1          |skal ha UDI-rapport|
   |Navn Navnesen 2           |har 14 barn har fått ett til| 

  Scenario: Gruppesøk med flere valg innenfor samme filter viser svar fra begge filter. Dette vises med "eller" funskjonalitet, dvs at person må treffe på minst 1 av filterene, ikke nødvendigvis flere.
    Når administrator filtrerer på starttermin "2023 Høst"
    Og administrator filtrerer på starttermin "2024 Høst"
    Når administrator trykker Søk etter gruppe av personer
    Så ser administrator "personer som er tilknyttet minst en termin"

     Eksempler:
   |personer som er tilknyttet minst en av terminene| 
  |Navn Navnesen 1           | 
   |Navn Navnesen 2           |
       
  Scenariomal: Gruppesøk med flere valg innenfor mellom filter viser svar på personer som treffer begge. Det vises med "og" funskjonalitet, dvs at personen må treffe på alle filtere for å være med i lista.
    Når administrator søker på "<startterminer>"
    Og administrator søker på "<studieprogram>"
    Og administrator søker på "<har betalt semesteravgift>"
    Så vises resultatliste med personer tilknyttet "<terminer>" og "<studieprogram>" som "<har betalt semesteravgift>"

    Eksempler:
      | startterminer | studieprogram | har betalt semesteravgift |
      |     2024 HØST | MASTER        | ja                        |
      |      2023 VÅR | JORDMOR       | ja                        |

