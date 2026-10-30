# language: no
#
# KILDER
#
# Behovet kom fra kravarbeidet 30.10.2026: når nye resultater lastes inn fra KREG,
# må saksbehandleren kunne søke fram sakene som har nye resultater, delt på
# VGS-resultater, fagskoleresultater og resultater fra høyere utdanning.
#
# Det finnes ikke noen mekanisme for å merke en sak med nye resultater i dag
# (sjekket i fs-plattform og fs-admin på main 30.10.2026). Filteret for saker har
# ikke noe valg for nye resultater, og resultatene hentes bare når saken fordeles.
# Abonnementet på endringer i KREG er ikke avklart (OPT-BEH-BEH-030).
#
# Varselet til saksbehandleren når det valgte grunnlaget blir utdatert, står i
# varsle_om_nytt_vitnemål.feature (OPT-BEH-BEH-021). Dette kravet handler om å finne
# sakene, ikke om varselet.
#
# AVKLART 30.10.2026
#
# - Kravet står i en egen fil, og utvider ikke OPT-BEH-BEH-021.
# - Saken har ikke lenger nye resultater når saken er behandlet på nytt, manuelt
#   eller automatisk.
# - Alle tre gruppene kommer fra KREG. Resultater fra fagskoler og høyere utdanning
#   er ikke i KREG i dag, men blir tilgjengelige gjennom et felles API som KREG skal
#   tilby (se også #422 og #246).
# - Et vitnemål som annulleres i KREG, er også et nytt resultat. Hva annulleringen
#   gjør med saken, står i OPT-BEH-BEH-034 (PR #865).
#
@OPT-BEH-BEH-035 @must @draft @ref-OPT-BEH-BEH-021
Egenskap: Finne saker med nye resultater
  Som saksbehandler
  ønsker jeg å filtrere sakene på om søkeren har fått nye resultater fra KREG, fordelt på VGS-resultater, fagskoleresultater og resultater fra høyere utdanning
  slik at jeg finner sakene der resultatene er endret etter at saken er behandlet.

  Resultatene som importeres fra KREG etter at saken er behandlet, er nye resultater,
  også når et vitnemål annulleres.
  Saken har nye resultater til den er behandlet på nytt. Saksbehandleren kan
  filtrere sakene på hvilken gruppe de nye resultatene hører til.

  @depends-on-OPT-BEH-BEH-030
  Regel: Saken har nye resultater når resultater importeres etter at saken er behandlet
    # Hvordan resultatene importeres, også gjennom abonnementet, står i OPT-BEH-BEH-030.

    Scenario: Saken får nye resultater når søkeren får et nytt vitnemål etter behandlingen
      Gitt at saken til "Eva Berg" er behandlet
      Når søkeren får et nytt vitnemål fra videregående skole i KREG
      Og vitnemålet er importert
      Så har saken nye VGS-resultater

    Scenario: Saken får nye resultater når vitnemålet annulleres etter behandlingen
      Gitt at saken til "Eva Berg" er behandlet
      Når søkerens vitnemål fra videregående skole annulleres i KREG
      Og annulleringen er importert
      Så har saken nye VGS-resultater

    Scenario: Resultatene som importeres før saken er behandlet, er ikke nye resultater
      Gitt at saken til "Eva Berg" ikke er behandlet
      Når søkerens resultater importeres fra KREG
      Så har saken ingen nye resultater

    Scenariomal: De nye resultatene hører til en gruppe
      Gitt at saken til "Eva Berg" er behandlet
      Når søkeren får resultater fra <utdanning> i KREG
      Og resultatene er importert
      Så har saken nye <gruppe>

      Eksempler:
        | utdanning          | gruppe                             |
        | videregående skole | VGS-resultater                     |
        | fagskole           | fagskoleresultater                 |
        | høyere utdanning   | resultater fra høyere utdanning    |

  Regel: Saken har ikke lenger nye resultater når saken er behandlet på nytt

    @openquestion
    Scenario: Saksbehandleren behandler saken på nytt
      # ÅPNE SPØRSMÅL:
      # - Hva er å behandle saken på nytt? Er det nok at saksbehandleren endrer noe i
      #   saken, eller må saken settes til ferdig behandlet?
      Gitt at saken til "Eva Berg" har nye VGS-resultater
      Når saksbehandler behandler saken på nytt
      Så har saken ingen nye resultater

    Scenario: Den automatiske behandlingen behandler saken på nytt
      Gitt at saken til "Eva Berg" har nye VGS-resultater
      Når søknaden behandles automatisk
      Så har saken ingen nye resultater

  Regel: Søk og filtrering av saker med nye resultater

    Bakgrunn:
      Gitt saksbehandler er innlogget i løsningen
      Og opptaket "Samordna opptak 2027" har følgende saker:
        | søker         | nye resultater                         | saksbehandlingsstatus |
        | Kari Nordmann | VGS-resultater                         | ferdig behandlet      |
        | Per Hansen    | fagskoleresultater                     | under behandling      |
        | Anne Lie      | resultater fra høyere utdanning        | ferdig behandlet      |
        | Lise Berg     | VGS-resultater og fagskoleresultater   | ferdig behandlet      |
        | Ola Nordmann  | ingen                                  | ferdig behandlet      |

    Scenario: Filteret for nye resultater er ikke i bruk som standard
      Når saksbehandler åpner sakslisten i opptaket "Samordna opptak 2027"
      Så ser saksbehandler sakene til "Kari Nordmann", "Per Hansen", "Anne Lie", "Lise Berg" og "Ola Nordmann"

    Scenariomal: Filtrere på nye resultater
      Når saksbehandler filtrerer på saker med nye <gruppe>
      Så vises kun <saker>

      Eksempler:
        | gruppe                          | saker                                     |
        | VGS-resultater                  | sakene til "Kari Nordmann" og "Lise Berg" |
        | fagskoleresultater              | sakene til "Per Hansen" og "Lise Berg"    |
        | resultater fra høyere utdanning | saken til "Anne Lie"                      |

    @openquestion
    Scenario: Gruppene for nye resultater kombineres med eller
      # ÅPNE SPØRSMÅL:
      # - Skal saksbehandleren kunne velge flere grupper samtidig, og kombineres de
      #   da med «eller», som valgene for konklusjon i OPT-BEH-BEH-009?
      Når saksbehandler filtrerer på saker med nye VGS-resultater eller nye resultater fra høyere utdanning
      Så vises kun sakene til "Kari Nordmann", "Lise Berg" og "Anne Lie"

    Scenario: Filteret for nye resultater kombineres med saksbehandlingsstatus
      Når saksbehandler filtrerer på saker med nye fagskoleresultater
      Og saksbehandler filtrerer på saksbehandlingsstatusen "under behandling"
      Så vises kun saken til "Per Hansen"
