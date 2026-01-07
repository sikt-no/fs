# language: no
@opptak @skip @nih
Egenskap: Opprette søknad for person
  Som saksbehandler i opptak trenger jeg av og til å kunne opprette søknader for personer som ikke klarer å opprette dette selv om de
  er i en gruppe som skal kunne søke på aktuelle utdanningstilbud. Grunner til å ikke kunne opprette egen søknad kan være at søker ikke har
  norsk eID eller får , eller har fått innvilget å søke opptak etter at søknadsfrist har utløpt.

  Bakgrunn:
    Gitt at administrator er saksbehandler i opptak (eller opptaksleder) for utdanningstilbud/opptaksinstans
    Gitt at administrator har vurdert at søknad MÅ opprettes for person
    Gitt at saksbehandler er på søknadsbehandlingssiden

    Scenario: Administrator oppretter søknad for person som allerede har søkt på utdanningstilbud
      Når administrator oppretter søknad for person og denne personen allerede har registrert søknad til utdanningstilbud
      Så får administrator beskjed om det og ny søknad opprettes ikke
      
 @nih
  Scenario: Administrator oppretter søknad for person som har norsk fnr
    Gitt at personen ikke har søkt på "<utdanningstilbud>" før i denne "<opptaksperioden>"
    Når administrator oppretter søknad for "<person med norsk fnr>" med "<individuell søknadsfrist>"
    Så mottar "<person med norsk eID>" varsel om søknad til utfylling i Min kompetanse og kan levere søknad innen "<individuell søknadsfrist>"

    Eksempler:
   |utdanningstilbud|opptaksperioden|person med norsk fnr|individuell søknadsfrist|

    Scenariomal: Administrator oppretter søknad for person med fnr eller dnr og får automatisk oppdatert person- og kontaktinformasjon
      Gitt at administrator oppretter søknad for person med fnr eller dnr
      Når saksbehandler legger inn "<fnr eller dnr>"
      Så kommer person- og kontaktinformasjon automatisk opp i "<søknad>".

      Eksempler:
      |fnr eller dnr|søknad|
      |01018912345  |uhf-1234|
      |51018912345  |ma-1234 |

   
    Scenario: Administrator oppretter søknad for ny person uten norsk fnr/dnr
      Gitt at personen ikke har søkt på "<utdanningstilbud>" før i denne "<opptaksperioden>"
      Gitt at personen ikke får logget på Min kompetanse uten norsk eID
      Når administrator oppretter søknad for "<ny person uten norsk fnr>" med "<individuell søknadsfrist>"
      Så mottar "<ny person uten norsk eID>" varsel om søknad til utfylling i Min kompetanse og kan levere søknad innen "<individuell søknadsfrist>"

      Eksempler:
        |utdanningstilbud|opptaksperioden|ny person uten norsk fnr|individuell søknadsfrist|

  Scenariomal: Administrator oppretter søknad for person uten norsk fnr/dnr og må legge inn grunnleggende opplysninger for person
    Gitt at administrator oppretter søknad for person uten fnr/dnr
    Når saksbehandler legger inn "<navn>"
    Når saksbehandler legger inn "<fødselsdato>"
    Når saksbehandler legger inn "<kjønn>"
    Når saksbehandler legger inn "<statsborgerskap>"
    Når saksbehandler legger inn "<e-post>"
    Når saksbehandler legger inn "<telefonnummer>"
    Når saksbehandler legger inn "<kontaktadresse>"
    Så kommer registrert person- og kontaktinformasjon opp i "<søknad>".

    Eksempler:
      |navn         |fødselsdato|kjønn  |statsborgerskap|e-post                |telefonnummer |kontaktadresse               |søknad   |
      |evita peron  |10.01.1989 |kvinne |argentina      |evita.person@gamil.com|00 34 1234567 |buoulebar i argentina et sted|ma-1234  |
      |enver hoxa |01.04.2005   |mann   |albania        |enhver.hoxa@hotmail.com|00 34 1234567|finn en albansk adresse      | evu-1234|


Scenariomal: Både saksbehandler og søker kan se at en søknad er opprettet manuelt
    Gitt at en "<søknad>" er oppretta manuelt av "<saksbehandler>"
    Når en "<saksbehandler>" ser på en søknad
    Når en "<søker>" ser på en søknad
    Så kan både "<saksbehandler>" og "<søker>" se at denne søknaden er opprettet manuelt
    Så kan både "<saksbehandler>" og "<søker>" se hvilken "<saksbehandler som har opprettet søknaden>"
    Så kan både "<saksbehandler>"og "<søker>" se "<når søknaden er opprettet>"

  Eksempler:
  |søknad|saksbehandler|søker|saksbehandler som har opprettet søknaden|når søknaden er opprettet|

  Scenario: Saksbehandler legger til ett utdanningstilbud som nytt søknadsalternativ i søknad
    Gitt at personen har en aktiv søknad
    Når saksbehandler legger til ett nytt utdanningstilbud i søknad
    Så får personen opprettet ett nytt søknadsalterativ i søknaden
