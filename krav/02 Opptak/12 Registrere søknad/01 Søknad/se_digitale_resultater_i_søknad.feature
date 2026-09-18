# language: no
# GitHub: #604
#
# STATUS 18.09.2026: utkastet er skrevet i en avklaringsrunde med produkteier.
# Beslutningene under er tatt og skal ikke gjenåpnes uten grunn — det som
# gjenstår står som ÅPNE SPØRSMÅL nederst. Kravet står som @draft til de er
# lukket.
#
# Avklart i denne runden:
# - Aktør er søkeren selv i personflaten, ikke saksbehandler. Saksbehandlerens
#   tilsvarende behov ligger som et skisse-scenario i behandle_søknad.feature
#   (@OPT-BEH-BEH-001) og er ikke rørt her.
# - Kravet plasseres under 12 Registrere søknad, ikke under 04 Kompetanse,
#   fordi det beskriver hva søkeren ser i søknadskonteksten. Innholdet i selve
#   resultatvisningen eies av @KOM-RES-RES-001.
# - Avgrenset til videregående skole og høyere utdanning. Fagskole, godkjenning
#   av utenlandsk utdanning og språkprøver er bevisst utelatt; de mangler
#   datakilde og hører til initiativ #208 som helhet.
# - Første leveranse er lenke til eksisterende resultatvisning. Den rikere
#   varianten — oppsummering på overskriftsnivå inne i søknaden — er tatt med
#   som en @could-regel så ambisjonen er dokumentert uten å binde leveransen.
# - Meldingen er finkornet per resultattype. Søkeren skal se både hva systemet
#   har og hva det ikke har; taushet om en resultattype svarer ikke på
#   spørsmålet «hva slipper jeg å laste opp».
#
@OPT-SØK-SØK-004 @must @draft
Egenskap: Se digitale resultater i søknaden
  Som søker
  ønsker jeg å se hvilke digitale resultater systemet allerede har om meg
  slik at jeg vet hva jeg ikke trenger å dokumentere med manuell opplasting.

  Resultatene systemet allerede har, hentes fra autoritative kilder og skal
  ikke lastes opp på nytt. Dette kravet dekker resultater fra videregående
  skole og fra høyere utdanning. Fagskoleresultater, godkjenning av
  utenlandsk utdanning og språkprøver er ikke med i denne avgrensningen.

  Kravet grenser mot @OPT-SØK-SØK-003 (veilede_om_dokumentasjon.feature,
  #572), som dekker hvilken dokumentasjon søkeren må laste opp. Dette kravet
  dekker den andre halvdelen: hva søkeren slipper å laste opp.

  Bakgrunn:
    Gitt personen er en søker
    Og personen har startet en søknad på et opptak

  Regel: Søker ser hvilke digitale resultater systemet har

    Scenario: Systemet har resultater fra begge kilder
      Gitt personen har registrerte resultater fra videregående skole
      Og personen har registrerte resultater fra høyere utdanning
      Når personen kommer til dokumentasjonssteget i søknaden
      Så ser personen at systemet har resultater fra videregående skole
      Og ser personen at systemet har resultater fra høyere utdanning
      Og ser personen at disse resultatene ikke må lastes opp

    Scenariomal: Systemet har resultater fra bare én kilde
      Gitt personen har registrerte resultater fra <kilden med resultater>
      Og personen har ingen registrerte resultater fra <kilden uten resultater>
      Når personen kommer til dokumentasjonssteget i søknaden
      Så ser personen at systemet har resultater fra <kilden med resultater>
      Og ser personen at systemet ikke har resultater fra <kilden uten resultater>

      Eksempler:
        | kilden med resultater | kilden uten resultater |
        | videregående skole    | høyere utdanning       |
        | høyere utdanning      | videregående skole     |

    Scenario: Systemet har ingen digitale resultater om søkeren
      Gitt personen har ingen registrerte resultater fra videregående skole
      Og personen har ingen registrerte resultater fra høyere utdanning
      Når personen kommer til dokumentasjonssteget i søknaden
      Så ser personen at systemet ikke har digitale resultater om personen
      Og ser personen at all dokumentasjon må lastes opp manuelt

  Regel: Søker kommer til resultatsiden for å se detaljene

    Scenario: Søker går fra søknaden til sine registrerte resultater
      Gitt personen er i dokumentasjonssteget i søknaden
      Når personen velger å se sine registrerte resultater
      Så kommer personen til visningen av egne resultater i personflaten
      # Innholdet i resultatvisningen er beskrevet i @KOM-RES-RES-001
      # (04 Kompetanse/10 Resultater/01 Resultater/se_egne_resultater.feature)

    @openquestion
    Scenario: Søker kommer tilbake til søknaden etter å ha sett resultatene
      # ÅPNE SPØRSMÅL: Bevares en påbegynt søknad automatisk når søkeren
      # navigerer til resultatvisningen, eller må søknaden lagres først?
      Gitt personen har lastet opp dokumentasjon i søknaden
      Og personen har gått til visningen av egne resultater
      Når personen går tilbake til søknaden
      Så er opplysningene og dokumentene personen har lagt inn fortsatt der

  @could
  Regel: Søker ser resultatene oppsummert i søknaden

    Scenario: Søker ser antall resultater per resultattype
      Gitt personen har ett vitnemål fra videregående skole
      Og personen har to resultatsett fra høyere utdanning
      Når personen kommer til dokumentasjonssteget i søknaden
      Så ser personen antall vitnemål fra videregående skole
      Og ser personen antall resultatsett fra høyere utdanning

    Scenario: Søker utvider en resultattype for å se hva den inneholder
      Gitt personen ser resultattypene oppsummert i søknaden
      Når personen utvider en resultattype
      Så ser personen de enkelte resultatsettene innenfor resultattypen

# ÅPNE SPØRSMÅL:
# - Bevares en påbegynt søknad automatisk når søkeren navigerer til
#   resultatvisningen? Se @openquestion-scenarioet over.
# - Hva regnes som «registrerte resultater fra høyere utdanning» — alt som er
#   tilgjengelig via vitnemålsportalen, eller bare det som er relevant for
#   opptaket det søkes på?
# - Ordlyd og utforming av meldingene er ikke beskrevet her. De hører hjemme i
#   se_digitale_resultater_i_søknad.design.md (skillen utdype-implementasjon).
# - @KOM-RES-RES-001 (se_egne_resultater.feature) er i dag en tre-linjers
#   skisse. Lenkemålet for dette kravet er altså reelt sett uspesifisert — det
#   kravet må fylles ut før leveransen kan bygges.
