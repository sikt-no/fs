# language: no
# GitHub: #610
#
# Leveranse L4c i initiativet #607 Vitnemålsbehandling. Skilt ut 12.11.2026
# i gjennomgangen med domeneekspertene: yrkesfaglig vitnemål med påbygging
# til generell studiekompetanse er et unntak, og leveres etter kjernen i L3
# og L4a. Kilder, bakgrunn og oversikten over leveransene står i
# vitnemålsbehandling.md i samme mappe.
#
# «Stryke et fag som overlapper med påbygging på kompetansebevis» er flyttet
# hit fra L4a (endre_fag_i_grunnlaget.feature), i versjonen fra før
# 12.11.2026. Endringen samme dag til «Fag som overlapper med påbygging,
# legges inn som forbedring» viste seg å være feil, og er rullet tilbake.
# «Poenggivende fag på yrkesfagsløpet kan tas med i kvoten for
# førstegangsvitnemål» er flyttet hit fra L3 (velge_fag_per_poengvariant.feature).
#
# Reglene for beregning og lagring i L2 («Poengene beregnes og lagres når
# saksbehandleren bruker dem») gjelder også her.
#
@OPT-BEH-BEH-046 @should @draft @depends-on-OPT-BEH-BEH-022 @depends-on-OPT-BEH-BEH-023
Egenskap: Behandle yrkesfaglig vitnemål med påbygging
  Som saksbehandler i opptak
  ønsker jeg å sette sammen grunnlaget for søkere med yrkesfaglig vitnemål og påbygging til generell studiekompetanse
  slik at søkeren blir riktig poengberegnet uten at det samme faget teller to ganger.

  Søkere med yrkesfaglig vitnemål og påbygging til generell studiekompetanse
  har fag på to dokumenter som overlapper. Fagvalget per poengvariant (L3)
  og tilleggsfagene og forbedringene (L4a) er ikke nok alene, fordi
  kontrollmotoren bruker fagkoden, og fagene på det yrkesfaglige vitnemålet
  har andre fagkoder enn fagene i påbyggingen.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg er inne på søknaden til en søker
    Og jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

  @openquestion
  Regel: Fag som overlapper med påbyggingen, teller bare én gang
    # ÅPNE SPØRSMÅL:
    # - Hvordan skal fag som overlapper med påbyggingen, håndteres?
    #   Kontrollmotoren bruker fagkoden. Norsk på det yrkesfaglige vitnemålet
    #   har ikke en fagkode som gir generell studiekompetanse, og karakteren
    #   fra norsk på yrkesfag og norsk i påbyggingen skal ikke telle begge.
    #   Det er derfor ikke nok å legge inn karakteren fra påbyggingen som
    #   forbedring på faget på vitnemålet (endret og rullet tilbake
    #   12.11.2026). Er det riktig at faget på vitnemålet strykes, og at
    #   faget fra påbyggingen legges inn under tilleggsfag, slik scenarioet
    #   under sier?

    Scenario: Stryke et fag som overlapper med påbygging på kompetansebevis
      Gitt søkeren har et yrkesfaglig vitnemål
      Og jeg har lagt til fagene fra påbyggingen til generell studiekompetanse under tilleggsfag
      Og jeg har vurdert at et fag på vitnemålet overlapper med et fag i påbyggingen
      Når jeg stryker faget på vitnemålet
      Så inngår faget på vitnemålet ikke i beregningen
      Og faget fra påbyggingen inngår i stedet
      # AVKLART 07.10.2026: hvilke fag som overlapper, er saksbehandlerens
      # vurdering, fordi reglene har mange unntak. Hovedreglene: norsk
      # strykes på vitnemålet og hentes fra kompetansebeviset. Matematikk og
      # naturfag strykes fra vitnemålet bare når faget er ført med henholdsvis
      # 224 og 140 timer samlet på kompetansebeviset.
      #
      # AVKLART 03.11.2026: påbyggingen er et opplastet kompetansebevis, og
      # fagene fra den legges til under tilleggsfag. Scenarioet gjelder fag
      # med ulik fagkode som overlapper, f.eks. norsk på det yrkesfaglige
      # vitnemålet og norsk i påbyggingen. Et fag med samme fagkode er en
      # forbedring («Et tilleggsfag kan ikke ha samme fagkode som et fag på
      # vitnemålet» i L4a).
      #
      # 12.11.2026 (gjennomgang med domeneekspertene): scenarioet ble endret
      # til «Fag som overlapper med påbygging, legges inn som forbedring», og
      # rullet tilbake samme dag, fordi det ikke virker når fagkodene er ulike.
      # Se spørsmålet over.

  Regel: Poenggivende fag på yrkesfagsløpet kan tas med i kvoten for førstegangsvitnemål

    Scenario: Poenggivende fag på yrkesfagsløpet kan tas med i kvoten for førstegangsvitnemål
      Gitt søkeren kvalifiserer til kvoten for førstegangsvitnemål med yrkesfaglig vitnemål og studiekompetansefagene
      Og søkeren har et fag som gir språk- eller realfagspoeng
      Og jeg har vurdert at faget er tatt senest det semesteret søkeren oppnådde generell studiekompetanse
      Når jeg velger faget for poengvarianten for kvoten for førstegangsvitnemål
      Så inngår faget i beregningen for poengvarianten
      # Samordna opptaks wiki, «Kvoter»: fag som gir språk- eller
      # realfagspoeng, tatt samtidig med studiekompetansefagene, kan tas med
      # i kvoten for førstegangsvitnemål.
      #
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene, i L3): løsningen
      # håndhever ikke unntaket. Saksbehandleren kan velge forbedringer i
      # poengvarianten for førstegangsvitnemål, og får varselet i «Varsel om
      # forbedringer i poengvarianten for førstegangsvitnemål når jeg
      # <handling>» (L3).
