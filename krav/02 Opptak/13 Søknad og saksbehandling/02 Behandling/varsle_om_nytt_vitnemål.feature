# language: no
# GitHub: #612
#
# Leveranse L6 av seks i initiativet #607 Vitnemålsbehandling. Skilt ut fra
# vitnemålsbehandling.feature 08.10.2026. Kilder, bakgrunn, avgrensninger og
# oversikten over leveransene står i vitnemålsbehandling.md i samme mappe.
#
# Bygger på L2. Selvstendig, men gir bare mening etter L2, siden det er det
# låste grunnlaget som kan bli utdatert.
#
@OPT-BEH-BEH-010 @must @draft
Egenskap: Varsle om nytt vitnemål
  Som saksbehandler i opptak
  ønsker jeg å bli varslet når grunnlaget jeg har valgt, blir utdatert
  slik at søkeren ikke blir poengberegnet på et vitnemål som er erstattet.

  Når saksbehandleren har lagt et vitnemål til grunn, er poengene låst mot
  automatisk reberegning. Låsing alene gjør at et valgt grunnlag kan bli
  stille utdatert: søkeren forbedrer et fag, Nasjonal vitnemålsdatabase
  sender et nytt vitnemål, og poenget står fast på det gamle uten at noen
  oppdager det.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg kan se og endre søknadsbehandling for organisasjonen som behandler saken
    Og jeg er inne på søknaden til en søker

  Regel: Saksbehandleren varsles når det valgte grunnlaget blir utdatert

    Scenario: Varsel når søkeren får et nytt vitnemål
      Gitt jeg har lagt et vitnemål til grunn
      Når søkeren får et nytt eller endret vitnemål fra Nasjonal vitnemålsdatabase
      Så blir jeg varslet om at grunnlaget jeg valgte er utdatert
      # AVKLART 21.09.2026: låsing kombineres med varsling. Låsing alene gjør
      # at et valgt grunnlag kan bli stille utdatert — søkeren forbedrer et
      # fag, NVB sender et nytt vitnemål, og poenget står fast på det gamle
      # uten at noen oppdager det.
      #
      # Samme hensyn er allerede tatt i ny stack: KregUtilgjengeligFeil stopper
      # behandlingen når KREG er nede, «for å unngå behandling på mulig
      # utdatert grunnlag». Varselet her er den andre siden av det hensynet.
      #
      # Utformingen av varselet hører i varsle_om_nytt_vitnemål.design.md.
