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
# Avklart 01.10.2026 — raffinering med utviklere (se Confluence):
# - Regelen «Det fremgår når grunnlaget er ufullstendig» utgår. Kompetanse-
#   subgrafen har en rad som viser hvilke resultater som finnes, uavhengig av
#   om kilden kan nås der og da. Søkeren varsles derfor aldri om delvis eller
#   mislykket henting — mangler et resultat, forblir det tomt, og søkeren får
#   en generell forklaring (se .design.md). Scenarioene under utgår med den.
#
# Avklart 14.10.2026 — hvor søkeren ser resultatene:
# - Resultatene vises i steget «Last opp dokumentasjon» i søknaden (steg 3 i
#   Figma-skissen «Konsept dokumentopplastning», node 3920:14210), før søkeren
#   blir bedt om å laste opp noe. Seksjonstittel og plassering i steget hører
#   i .design.md.
# - Steget «søkeren blir ikke bedt om å laste opp» utgår. Det er dekket av at
#   søkeren ser at dokumentasjonen er hentet automatisk, og hva søkeren må
#   laste opp, eies av @OPT-SØK-SØK-003 (#572).
# - For videregående vitnemål ser søkeren hvilken kompetanse vitnemålet gir,
#   for eksempel generell studiekompetanse eller yrkeskompetanse, ikke bare om
#   det gir generell studiekompetanse.
# - Finnes et resultat, men detaljene ikke kunne hentes, ser søkeren det som
#   er kjent, uten beskjed om at noe mangler (som beslutningen 01.10.2026 om
#   at søkeren aldri varsles om delvis henting). Søkeren skal ikke laste opp
#   resultatet. Figma: rammen «Frame 1000002327».
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
# se_digitale_resultater_i_søknad.design.md, jf. fs-implementasjonsdetaljer.
#
@OPT-SØK-SØK-004 @must @planned @scope-digitale-resultater-i-soknad
Egenskap: Se digitale resultater i søknaden
  Som søker
  ønsker jeg å se hvilke digitale resultater systemet allerede har om meg
  slik at jeg vet hva jeg ikke trenger å dokumentere med manuell opplasting.

  Resultatene systemet allerede har, er hentet fra autoritative kilder og skal
  ikke lastes opp på nytt.

  Bakgrunn:
    Gitt at søkeren er innlogget på personflaten
    Og søkeren har startet en søknad på et opptak

  Regel: Søkeren ser de digitale resultatene i steget «Last opp dokumentasjon»

    Scenario: Se at dokumentasjonen er hentet automatisk
      Gitt at søkeren har digitale resultater
      Når søkeren kommer til steget «Last opp dokumentasjon» i søknaden
      Så ser søkeren at systemet har hentet dokumentasjon automatisk
      Og resultatene vises før opplastingen av dokumentasjon
      Og søkeren får vite at saksbehandleren ser dokumentasjonen når søknaden behandles
      # AVKLART 25.09.2026: siste ledd er nytt. Søkeren skal vite at det hen
      # ser her er det samme saksbehandleren får se — det er en opplysning om
      # innsyn, ikke en UI-detalj. Speiler @OPT-BEH-BEH-005.

    Scenario: Resultatene vises gruppert på nivå
      Gitt at søkeren har resultater fra videregående opplæring og høyere utdanning
      Når søkeren kommer til steget «Last opp dokumentasjon» i søknaden
      Så ser søkeren resultatene gruppert på utdanningsnivå
      Og videregående opplæring vises før høyere utdanning

    Scenario: Se opplysninger om et resultat
      Gitt at søkeren har et vitnemål
      Når søkeren kommer til steget «Last opp dokumentasjon» i søknaden
      Så ser søkeren vitnemålet med følgende opplysninger
        | felt            |
        | Tittel          |
        | Utsteder        |
        | Utstedelsesdato |

    Scenariomal: Se tilleggsopplysning for et resultat fra <nivå>
      Gitt at søkeren har et vitnemål fra <nivå>
      Når søkeren kommer til steget «Last opp dokumentasjon» i søknaden
      Så ser søkeren <tilleggsopplysning>

      Eksempler:
        | nivå                   | tilleggsopplysning                 |
        | videregående opplæring | hvilken kompetanse vitnemålet gir  |
        | høyere utdanning       | hvilken grad vitnemålet gir        |

    @draft @openquestion
    Scenario: Se et resultat der bare utstederen er kjent
      # ÅPNE SPØRSMÅL:
      # - Hvilke opplysninger vet vi alltid om et resultat: utsteder og
      #   utdanningsnivå, eller mer?
      Gitt at søkeren har et digitalt resultat fra høyere utdanning der bare utstederen er kjent
      Når søkeren kommer til steget «Last opp dokumentasjon» i søknaden
      Så ser søkeren utstederen av resultatet under høyere utdanning
      Og søkeren ser at resultatet er hentet automatisk
      Men søkeren får ikke beskjed om at opplysninger om resultatet mangler

    Scenario: Se at et resultat er hentet automatisk
      Gitt at søkeren har et digitalt resultat
      Når søkeren kommer til steget «Last opp dokumentasjon» i søknaden
      Så ser søkeren at resultatet er hentet automatisk
      # Merkelappen sier hvordan resultatet kom inn, ikke hvor det kom fra.
      # Søkeren trenger å vite at hen ikke må laste det opp selv; hvilken
      # kilde det stammer fra er ikke søkerens sak.

    Scenario: Andre resultater er lukket som standard
      Gitt at søkeren har resultater som verken er vitnemål eller grad
      Når søkeren kommer til steget «Last opp dokumentasjon» i søknaden
      Så ser søkeren at det finnes andre resultater
      Men de andre resultatene vises ikke før søkeren velger å se dem
      # Lukket fordi de sjelden er avgjørende for søkeren.

    Scenario: Se andre resultater
      Gitt at søkeren har resultater som verken er vitnemål eller grad
      Og søkeren er i steget «Last opp dokumentasjon» i søknaden
      Når søkeren velger å se andre resultater
      Så ser søkeren enkeltemnene og den øvrige dokumentasjonen
      # «Andre resultater» samler enkeltemner og øvrig dokumentasjon.

    Scenariomal: Samme forklaring vises uansett årsak til manglende resultater
      Gitt at <årsak>
      Når søkeren kommer til steget «Last opp dokumentasjon» i søknaden
      Så ser søkeren én samlet forklaring på at systemet ikke har digitale resultater om hen
      Og søkeren får vite at all dokumentasjon må lastes opp manuelt

      Eksempler:
        | årsak                                    |
        | søkeren ikke har digitale resultater      |
        | henting av søkerens resultater har feilet |
