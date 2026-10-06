# language: no
# GitHub: #604
#
# Avklart 18.09.2026:
# - Aktør er søkeren selv i personflaten, ikke saksbehandler. Saksbehandlerens
#   tilsvarende behov ligger som et skisse-scenario i behandle_søknad.feature
#   (@OPT-BEH-BEH-001) og er ikke rørt her.
# - Kravet plasseres under 12 Registrere søknad, ikke under 04 Kompetanse,
#   fordi det beskriver hva søkeren ser i søknadskonteksten.
#
# Avklart 22.09.2026:
# - Resultatene deles ikke opp etter kilde. Hvor resultatene stammer fra er
#   håndtert i arkitekturen og er ikke dette kravets sak. All ordbruk om
#   «kilder» er derfor fjernet.
# - Ingen filtrering og ingen utelatelser. Søkeren ser alt systemet har
#   registrert om hen — ikke bare det som er relevant for dette opptaket, og
#   ikke en utvalgt delmengde.
# - Snittet mot @OPT-SØK-SØK-003 (veilede_om_dokumentasjon.feature, #572):
#   #572 dekker hva søkeren må laste opp, dette kravet hva søkeren slipper.
#   Personopplysninger fra folkeregisteret hører til #572 og er ikke med her.
#
# Avklart 25.09.2026 — designet for dokumentasjonssteget:
# - Søkeren ser resultatene INNE i søknaden, ikke ved å navigere ut til
#   resultatvisningen. Det lukker det åpne spørsmålet som har stått siden
#   18.09. Regelen om navigering til @KOM-RES-RES-001 utgår, og den betingede
#   avhengigheten til #559 faller bort. Den rikere varianten som sto som
#   @could er nå hovedflyten.
# - Kladd-scenarioet utgår med navigeringen. Kladd-bevaring er en generell
#   egenskap ved søknaden, ikke noe dette kravet eier.
# - Resultatene grupperes på utdanningsnivå, videregående først. Samme
#   struktur og rekkefølge som @OPT-BEH-BEH-005 på saksbehandlersiden — de to
#   ble besluttet uavhengig og landet likt.
#
# BEGREPSBRUK
#
# «Digitale resultater» brukes gjennomgående, også i @OPT-BEH-BEH-005.
# Sub-domenet hadde tidligere fire ord for overlappende ting.
#
# «Andre resultater» er alt som ikke er et vitnemål eller en grad —
# enkeltemner og øvrig dokumentasjon samlet. Det avviker bevisst fra
# @OPT-BEH-BEH-005, der saksbehandleren får enkeltemner i resultatoversikten
# og øvrig dokumentasjon som egen seksjon. Søkeren trenger mindre finkorning.
# Avviket skal ikke «harmoniseres» bort uten en ny beslutning.
#
# UI-detaljer. Ordlyd, plassering, ikoner og hvordan seksjoner utvides hører i
# se_digitale_resultater_i_søknad.design.md, jf. utdype-implementasjon.
#
@OPT-SØK-SØK-004 @must @planned
Egenskap: Se digitale resultater i søknaden
  Som søker
  ønsker jeg å se hvilke digitale resultater systemet allerede har om meg
  slik at jeg vet hva jeg ikke trenger å dokumentere med manuell opplasting.

  Resultatene systemet allerede har, er hentet fra autoritative kilder og skal
  ikke lastes opp på nytt.

  Bakgrunn:
    Gitt at søkeren er innlogget på personflaten
    Og søkeren har startet en søknad på et opptak

  Regel: Søkeren ser de digitale resultatene i søknaden

    Scenario: Se at dokumentasjonen er hentet automatisk
      Gitt at søkeren har digitale resultater
      Når søkeren kommer til dokumentasjonssteget i søknaden
      Så ser søkeren at systemet har hentet dokumentasjon automatisk
      Og søkeren blir ikke bedt om å laste den opp
      Og søkeren får vite at saksbehandleren ser dokumentasjonen når søknaden behandles
      # AVKLART 25.09.2026: siste ledd er nytt. Søkeren skal vite at det hen
      # ser her er det samme saksbehandleren får se — det er en opplysning om
      # innsyn, ikke en UI-detalj. Speiler @OPT-BEH-BEH-005.

    Scenario: Resultatene vises gruppert på nivå
      Gitt at søkeren har resultater fra flere utdanningsnivåer
      Når søkeren kommer til dokumentasjonssteget i søknaden
      Så ser søkeren resultatene gruppert på utdanningsnivå
      Og videregående opplæring vises før høyere utdanning

    Scenario: Se opplysninger om et resultat
      Gitt at søkeren har et vitnemål
      Når søkeren kommer til dokumentasjonssteget i søknaden
      Så ser søkeren vitnemålet med følgende opplysninger
        | felt            |
        | Tittel          |
        | Utsteder        |
        | Utstedelsesdato |

    Scenariomal: Se tilleggsopplysning for et resultat fra <nivå>
      Gitt at søkeren har et vitnemål fra <nivå>
      Når søkeren kommer til dokumentasjonssteget i søknaden
      Så ser søkeren i tillegg <tilleggsopplysning>

      Eksempler:
        | nivå                   | tilleggsopplysning         |
        | videregående opplæring | om vitnemålet gir generell studiekompetanse |
        | høyere utdanning       | hvilken grad vitnemålet gir |

    Scenario: Se at et resultat er hentet automatisk
      Gitt at søkeren har et digitalt resultat
      Når søkeren kommer til dokumentasjonssteget i søknaden
      Så ser søkeren at resultatet er hentet automatisk
      # Merkelappen sier hvordan resultatet kom inn, ikke hvor det kom fra.
      # Søkeren trenger å vite at hen ikke må laste det opp selv; hvilken
      # kilde det stammer fra er ikke søkerens sak.

    Scenario: Se andre resultater
      Gitt at søkeren har resultater som verken er vitnemål eller grad
      Når søkeren velger å se andre resultater
      Så ser søkeren de øvrige resultatene
      # «Andre resultater» samler enkeltemner og øvrig dokumentasjon, og er
      # lukket som standard fordi de sjelden er avgjørende for søkeren.

    Scenario: Søker uten digitale resultater
      Gitt at søkeren ikke har digitale resultater
      Når søkeren kommer til dokumentasjonssteget i søknaden
      Så ser søkeren at systemet ikke har digitale resultater om hen
      Og søkeren får vite at all dokumentasjon må lastes opp manuelt
      # PRESISERT 25.09.2026: gjelder bare når det er bekreftet at søkeren
      # ikke har noe. Kunne ikke opplysningene hentes, gjelder regelen under —
      # instruksen om manuell opplasting skal ikke gis på usikkert grunnlag.

  @draft @openquestion
  Regel: Det fremgår når grunnlaget er ufullstendig

    # ÅPNE SPØRSMÅL:
    # - Hva skal søkeren gjøre når opplysningene ikke kunne hentes? Vente og
    #   prøve igjen, laste opp manuelt i mellomtiden, eller begge deler? Det
    #   henger sammen med dokumentasjonsfristen: en søker som venter på en
    #   kilde som er nede kan gå glipp av fristen. Reist 25.09.2026.
    # - Designet dekker ikke disse tilstandene. De må utformes før de kan
    #   implementeres.
    #
    # Regelen speiler @OPT-BEH-BEH-005. Konsekvensen er ulik: der er risikoen
    # et feilvedtak, her er det at søkeren laster opp noe hen ikke trengte —
    # eller konkluderer med at vitnemålet ikke er registrert.

    Scenario: Resultater fra en utsteder kunne ikke hentes
      Gitt at søkeren har resultater fra flere utstedere
      Og resultatene fra én av utstederne ikke kunne hentes
      Når søkeren kommer til dokumentasjonssteget i søknaden
      Så ser søkeren resultatene som ble hentet
      Og søkeren ser hvilken utsteder det finnes resultater fra som ikke kunne hentes

    Scenario: Ingen av resultatene kunne hentes
      Gitt at søkeren har digitale resultater
      Og ingen av dem kunne hentes
      Når søkeren kommer til dokumentasjonssteget i søknaden
      Så ser søkeren at hen har resultater som ikke kunne hentes
      Men søkeren får ikke beskjed om at all dokumentasjon må lastes opp manuelt

    Scenario: Det er ukjent om søkeren har resultater
      Gitt at det ikke lar seg avgjøre om søkeren har digitale resultater
      Når søkeren kommer til dokumentasjonssteget i søknaden
      Så ser søkeren at det ikke er avklart hvilke resultater systemet har om hen
