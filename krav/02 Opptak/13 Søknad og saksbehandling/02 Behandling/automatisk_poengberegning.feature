# language: no
#
# Grovutkast 21.10.2026. Kildene er samlet, men ingen regel er gjennomgått med
# produkteier eller Team Puff. Reglene bygger på dagens FS-klient, koden i ny
# stack og brukerhistoriene i Confluence. Følg «Krav fra kode, skisser eller
# FS-klienten» i krav/README.md i valideringen: for hver regel må det avklares
# om det er ønsket atferd, eller bare slik koden er.
#
# Føring: Det nye skal fungere slik det fungerer i FS-klienten i dag. Den samme
# beregningen brukes i den manuelle saksbehandlingen, der det finnes egne krav
# (vitnemålsbehandlingen, se vitnemålsbehandling.md i samme mappe).
#
# KILDER
#
# Jira: FOL-36 (initiativet, akseptansetest 30.11.2026), STEK-218 (det som er
# bygget, med STEK-219 «la stå», STEK-220, STEK-221 sporing, STEK-223–225),
# STEK-454 (bare ett vitnemål), STEK-430/431 (på vent), STEK-507, STEK-512/513,
# STEK-514, STEK-529, SOPP-44 (manuelle poeng overstyres ikke).
#
# Confluence PFS: 4392517645 «2026-02-25 Raffinering 100% helautomatisk
# poengberegning», 4405231624 «Helautomatisk poengberegning – brukerhistorier»,
# 4390191266 «Poengberegning – Automatisert», 4954554392 «Automatisk
# saksbehandling av flere elektroniske vitnemål», 4609146881 «Forretningsregler
# – Poeng».
#
# GitHub: #199 (automatisk saksbehandling, grunnutdanning), #375 (lukket, uten
# innhold), #386 (tilleggspoeng, avgrensning).
#
# FS-klienten (gitlab.sikt.no/fs/fs-klient): knappen «Godkjenn» i
# vitnemålsrammen i Søknad samlebilde (w_soknad_saml.srw, pk_opptakvtm.
# p_godkjennvtm) beregner for én søker. Rutinen FS158.001 «Automatisk behandling
# av søkere med godkjent elektronisk vitnemål» (wr_fs158_001.srw,
# pk_fs158001) beregner for mange. Beregningen ligger i PL/SQL
# (pk_opptakvtm.f_atomiskPoengvtm), ikke i klienten. Manuell endring av poeng
# setter «la stå» (w_soknad_saml.srw:3146–3154).
#
# Ny stack: opptak-service AutomatiskPoengberegningService, PoengService og
# VgsDokumentVitnemaalService i fs-plattform, kalt fra behandleSakAutomatisk.
# Bare kalt fra en mutation, ikke fra en jobb eller hendelse. I fs-admin
# starter knappen «Behandle automatisk» den for én sak, bak flagget
# automatisk-soknadsbehandling-trigger, og poengene vises i steget «Poeng»
# (PoengberegningCard).
#
# AVGRENSNING
#
# - Selve beregningen (hvilke karakterer som teller, avrunding, satser, tak)
#   eies av Team Puff, og er ikke med her.
# - Alders- og kjønnspoeng, tilleggspoeng (FOL-39, #386), 23/5-regelen
#   (FOL-37) og poengsum per kvote er egne saker.
# - Automatisk valg av beste vitnemål eller fagkombinasjon (#562) er ikke med.
#   Søkere med flere vitnemål behandles i vitnemålsbehandlingen.
# - Søknadsmangler: søknadsmangler.feature har allerede «Mangelen sjekkes ut
#   når vitnemålet behandles automatisk». «Godkjenn» i FS-klienten fjerner også
#   søknadsmanglene for vitnemålet.
@OPT-BEH-BEH-018 @must @draft @ref-OPT-BEH-BEH-008
Egenskap: Automatisk poengberegning
  Som saksbehandler
  ønsker jeg at poengene fra søkerens elektroniske vitnemål beregnes automatisk
  slik at jeg bare trenger å behandle poengene der grunnlaget ikke er entydig.

  Har søkeren ett elektronisk vitnemål, beregner systemet karakterpoeng,
  realfagspoeng og språkpoeng fra det, og legger dem i poengtypene regelverket
  har koblet til beregningen. Har søkeren flere vitnemål, beregnes ingenting
  automatisk, og saksbehandleren velger grunnlaget i vitnemålsbehandlingen. Den
  samme beregningen brukes da på grunnlaget saksbehandleren har valgt.

  Poeng som saksbehandleren har satt eller låst, beregnes aldri på nytt. Det
  fremgår om et poeng er beregnet automatisk eller satt av saksbehandleren, og
  hvilket vitnemål det bygger på.

  # ÅPNE SPØRSMÅL:
  # - Når skal poengene beregnes? Se regelen «Når poengene beregnes».
  # - Hvordan skal saksbehandleren finne søknadene som er behandlet automatisk?
  # - Skal automatikken kunne skrus av etter en dato, eller bare kjøre i en
  #   periode? HK-dir ble spurt i februar 2026, og svaret er ikke funnet.

  @depends-on-OPT-REG-RAN-002
  Regel: Poeng fra søkerens eneste vitnemål
    # Poengtypene og koblingen til beregningen settes opp i regelverket.

    Scenario: Poeng beregnes fra søkerens eneste vitnemål
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Og at søknaden har poengtyper som er koblet til beregningen fra vitnemålet
      Når poengene beregnes automatisk
      Så har poengtypene fått poeng beregnet fra vitnemålet

    Scenariomal: Poengklasser som beregnes fra vitnemålet
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Og at søknaden har en poengtype i poengklassen <poengklasse> som er koblet til beregningen fra vitnemålet
      Når poengene beregnes automatisk
      Så har poengtypen fått <poeng> beregnet fra vitnemålet

      Eksempler:
        | poengklasse | poeng          |
        | KAR         | karakterpoeng  |
        | REA         | realfagspoeng  |
        | SPR         | språkpoeng     |

    Scenario: Poengtype som ikke er koblet til beregningen, beregnes ikke
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Og at søknaden har en poengtype som ikke er koblet til beregningen fra vitnemålet
      Når poengene beregnes automatisk
      Så er poengtypen uendret

    @openquestion
    Scenario: Opplastet dokumentasjon hindrer ikke beregningen
      # ÅPNE SPØRSMÅL:
      # - Brukerhistorien (PFS 4405231624) sier at én VM og et kompetansebevis
      #   lastet opp som fil skal beregnes, og at saksbehandleren justerer
      #   etterpå. STEK-454 sier «ingen kompetansebevis». Gjelder STEK-454 bare
      #   kompetansebevis fra NVB, så de to er forenlige?
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Og at søkeren har lastet opp et kompetansebevis
      Når poengene beregnes automatisk
      Så har poengtypene fått poeng beregnet fra det elektroniske vitnemålet

  Regel: Ingen automatisk beregning uten ett entydig vitnemål

    Scenariomal: Ingen automatisk poengberegning når <grunn>
      Gitt at <grunn>
      Når poengene beregnes automatisk
      Så får søknaden ingen poeng beregnet automatisk

      Eksempler:
        | grunn                                                         |
        | søkeren har flere elektroniske vitnemål som ikke er annullert |
        | søkerens eneste elektroniske dokument er et kompetansebevis   |
        | søkerens eneste elektroniske vitnemål er annullert            |
        | søkeren ikke har noe elektronisk vitnemål                     |

    @openquestion
    Scenario: Automatisk beregnede poeng når vitnemålet ikke lenger er entydig
      # ÅPNE SPØRSMÅL:
      # - Ny stack nullstiller poeng som er beregnet automatisk, og skriver
      #   «Fant ikke entydig vitnemål», når søkeren ikke lenger har ett
      #   entydig vitnemål. Er det ønsket? Hva gjør FS-klienten?
      Gitt at søknaden har poeng som er beregnet automatisk fra et vitnemål
      Og at søkeren har fått et vitnemål til
      Når poengene beregnes automatisk
      Så er de automatisk beregnede poengene fjernet
      Og det fremgår at poengene ikke er beregnet fordi søkeren ikke har ett entydig vitnemål

  @openquestion
  Regel: Når poengene beregnes
    # ÅPNE SPØRSMÅL:
    # - Hvilke av anledningene under skal starte beregningen, og hvilke skal
    #   saksbehandleren starte selv? Det som er kjent, er listet som scenarioer.
    # - FS-klienten har ingen beregning som starter av seg selv. Saksbehandleren
    #   starter den med «Godkjenn» for én søker, eller med rutinen FS158.001 for
    #   mange. Brukerhistorien (PFS 4405231624) vil at systemet starter
    #   beregningen selv. Ny stack starter den bare med «Behandle automatisk»
    #   for én søknad.
    # - Hva skjer med et vitnemål som kommer etter ettersendingsfristen?
    # - FS158.001 plukker ut søknader der GSK er godkjent, kontrollmotoren ikke
    #   gir USANN, og «Kan saksbehandles» ikke er satt. Har velger for med eller
    #   uten følgeskjema, sletting av DUA-mangler og omkjøring av tidligere
    #   beregninger. Hvilke av disse skal videreføres?

    Scenario: Søknad med elektronisk vitnemål kommer inn
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Når søknaden sendes inn
      Så beregnes poengene automatisk

    Scenario: Søkeren får vitnemål innen ettersendingsfristen
      Gitt at søkeren har sendt inn søknaden uten elektronisk vitnemål
      Når søkeren får et elektronisk vitnemål før ettersendingsfristen
      Så beregnes poengene automatisk

    @ref-OPT-BEH-BEH-004
    Scenario: Saksbehandleren har satt sammen grunnlaget
      # Hvordan saksbehandleren velger vitnemål og fag, står i
      # vitnemålsbehandlingen. Poengene beregnes med den samme beregningen.
      Gitt at søkeren har dokumentasjon som ikke kan beregnes automatisk
      Når saksbehandleren har satt sammen grunnlaget fra opplastet og elektronisk dokumentasjon
      Så beregnes poengene fra grunnlaget saksbehandleren har satt sammen

    Scenario: Saksbehandleren starter beregningen for én søknad
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Når saksbehandleren starter den automatiske poengberegningen for søknaden
      Så beregnes poengene automatisk

    Scenario: Saksbehandleren starter beregningen for flere søknader
      Gitt at flere søkere i opptaket har ett elektronisk vitnemål som ikke er annullert
      Når saksbehandleren starter den automatiske poengberegningen for søknadene
      Så beregnes poengene automatisk for hver av søknadene

  Regel: Poeng som saksbehandleren har satt, beregnes ikke på nytt

    Scenario: Poeng som saksbehandleren endrer, låses
      Gitt at søknaden har et poeng som er beregnet automatisk
      Når saksbehandleren endrer poenget
      Så er poenget låst mot automatisk beregning

    Scenario: Låst poeng beregnes ikke på nytt
      Gitt at søknaden har et låst poeng
      Når poengene beregnes automatisk
      Så er det låste poenget uendret

    @ref-OPT-BEH-BEH-004
    Scenario: Låse opp et poeng
      # Står også i velge_vitnemål_som_grunnlag.feature. Når kravene valideres,
      # bør regelen bare stå ett av stedene.
      Gitt at søknaden har et låst poeng
      Når saksbehandleren låser opp poenget
      Og poengene beregnes automatisk
      Så er poenget beregnet automatisk på nytt

    Scenario: Poeng som ikke er låst, beregnes på nytt
      Gitt at søknaden har et poeng som er beregnet automatisk
      Og at poenget ikke er låst
      Når poengene beregnes automatisk på nytt
      Så er poenget erstattet med det nye beregnede poenget

    Scenario: Saksbehandlerens merknad er uendret
      Gitt at saksbehandleren har skrevet en merknad på et poeng
      Når poengene beregnes automatisk
      Så er merknaden uendret

  Regel: Sporbarhet

    Scenario: Se at poenget er beregnet automatisk
      Gitt at søknaden har et poeng som er beregnet automatisk
      Når saksbehandleren ser på poengene
      Så ser saksbehandleren at poenget er beregnet automatisk
      Og saksbehandleren ser hvilket vitnemål poenget er beregnet fra

    Scenario: Se hvorfor poengene ikke er beregnet
      Gitt at poengene ikke kunne beregnes automatisk
      Når saksbehandleren ser på poengene
      Så ser saksbehandleren hvorfor poengene ikke er beregnet

    Scenario: Se poengene etter at beregningen er startet
      # I fs-admin vises poengene først når siden lastes på nytt.
      Gitt at saksbehandleren er inne på søknaden
      Når saksbehandleren starter den automatiske poengberegningen for søknaden
      Så ser saksbehandleren poengene som ble beregnet

    @openquestion
    Scenario: Finne søknader som er behandlet automatisk
      # ÅPNE SPØRSMÅL:
      # - Brukerbehov fra raffineringen (PFS 4392517645): å kunne søke opp hvem
      #   som er behandlet automatisk, gjerne med skille mellom helautomatisk og
      #   halvautomatisk. FS158.001 har «Vis tidligere behandlinger». Er det
      #   et filter i saksoversikten, en logg, eller begge?
      Gitt at noen søknader i opptaket er behandlet automatisk
      Når saksbehandleren ser etter søknadene som er behandlet automatisk
      Så finner saksbehandleren søknadene som er behandlet automatisk
