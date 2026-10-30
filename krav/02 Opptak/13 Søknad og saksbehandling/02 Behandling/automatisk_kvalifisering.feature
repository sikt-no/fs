# language: no
#
# Grovutkast 21.10.2026. Kildene er samlet, men ingen regel er gjennomgått med
# produkteier eller Team Puff. Reglene bygger på dagens FS-klient, koden i ny
# stack og brukerhistoriene i Confluence. Følg «Krav fra kode, skisser eller
# FS-klienten» i krav/README.md i valideringen: for hver regel må det avklares
# om det er ønsket atferd, eller bare slik koden er.
#
# Føring: Det nye skal fungere slik det fungerer i FS-klienten i dag. Den
# automatiske vurderingen brukes sammen med den manuelle, der saksbehandleren
# vurderer kravene i steget «Spesielle opptakskrav».
#
# KILDER
#
# Jira: FOL-35 (initiativet, akseptansetest 30.11.2026, peker på
# @OPT-REG-KRA-002), STEK-218 med STEK-219 (la stå), STEK-221 (sporing),
# STEK-226/227 (fagkrav og karakter) og STEK-228 (kobling til
# vitnemålskravkode), STEK-272 (kvalifisering per grunnlag og unntak),
# STEK-240, STEK-454, STEK-457, STEK-435, STEK-593, STEK-505, STEK-582.
#
# Confluence PFS: 4544528389 «Brukerhistorier Automatisering av kravelement»,
# 4481548346 «2026-03-19 raffinering Automatisering av kravelement»,
# 4500094994 «Løsningsforslag Automatisering av kravelementer», 4482957314
# «Automatisering av kravelement». TT1 4005331003 «Koble opptakskrav til
# Kvoter / grunnlag». Sidene om forretningsregler er tomme maler.
#
# GitHub: #199, kriteriet «Systemet skal automatisk sette hvilke spesielle
# opptakskrav som er dekket». #511 (koble spesielle opptakskrav til kvoter),
# #263 (gjenbruk av vurderingen når regelverket er uendret).
#
# FS-klienten (gitlab.sikt.no/fs/fs-klient): «Godkjenn» i Søknad samlebilde
# (w_soknad_saml.srw:5024–5118, pk_opptakvtm.p_godkjennvtm) og rutinen
# FS158.001 vurderer kravene sammen med grunnlag og poeng. «Beregn» i
# Vitnemålbehandling (w_vitnemalsbehandling.srw:2504–2712) og «Fullfør» i
# Søknad samlebilde (w_soknad_saml.srw:4505–4647) regner ut fagprofilen og om
# søkeren er kvalifisert. FS157.001 beregner kvalifisert for mange søkere.
# Kravelementet har en kravkode per reform («V-Krav R94» og «V-Krav KL»).
# Fagprofilen har «La stå», og hvilket vitnemål automatikken brukte. Manuell
# og beregnet vurdering står i egne felt for kompetansekravet og
# søknadsalternativet, og beregningen rører ikke de manuelle feltene. Regelen
# ligger i PL/SQL. Oppfølging: FS102.004 «Ikke-kvalifiserte søkere – spesielle
# opptakskrav» og FS120.002 «Brev til søkere med manglende fagkrav».
#
# Ny stack: AutomatiskKravelementVurderingService (kontrollmotoren) og
# KvalifiseringEvaluator i opptak-service (fs-plattform), kalt fra
# behandleSakAutomatisk etter poengberegningen. Manuelt:
# KvalifiserKravelementV4Service og KvalifiserKravelementUnntakService. I
# fs-admin viser steget «Spesielle opptakskrav» (KravlisteStudierCard) kravene
# per sak, med «Velg krav per grunnlag» og «Nullstill krav». Det vises ikke om
# en vurdering er gjort automatisk.
#
# AVGRENSNING
#
# - Kravelementene, kompetanseregelverket og koblingen til vitnemålet settes
#   opp i regelverket (kravelement.feature, kompetanseregelverk.feature).
# - Hvordan kontrollmotoren avgjør om et fagkrav er oppfylt (hvilke fag som
#   teller, snitt eller beste karakter), eies av Team Puff.
# - GSK-konklusjonen settes i automatisk_gsk_konklusjon.feature. Grunnlaget og
#   poengene settes i automatisk_grunnlag.feature (@OPT-BEH-BEH-019) og
#   automatisk_poengberegning.feature (@OPT-BEH-BEH-018), som ennå bare ligger
#   på hver sin branch.
# - Hvordan saksbehandleren velger vitnemål for søkere med flere vitnemål,
#   står i velge_vitnemål_som_grunnlag.feature (@OPT-BEH-BEH-004).
@OPT-BEH-BEH-020 @must @planned
Egenskap: Automatisk vurdering av spesielle opptakskrav
  Som saksbehandler
  ønsker jeg at systemet vurderer om søkerens elektroniske vitnemål oppfyller de spesielle opptakskravene
  slik at jeg bare trenger å vurdere kravene som ikke kan avgjøres fra vitnemålet.

  De spesielle opptakskravene er satt sammen av kravelementer, for eksempel
  Matematikk R1 eller en karakter i et fag. Har søkeren ett elektronisk
  vitnemål, vurderer systemet hvert kravelement som er koblet til vitnemålet,
  og registrerer om det er oppfylt, og eventuelt karakteren. Ut fra
  kravelementene avgjør systemet om søkeren er kvalifisert, for hvert grunnlag
  søknaden har.

  Vurderinger som saksbehandleren har gjort, endres aldri av automatikken. Det
  fremgår om et kravelement er vurdert automatisk eller av saksbehandleren.

  # Avklart 30.10.2026: er søkeren ikke kvalifisert, får saken automatiske mangeltekster for
  # kravelementene som ikke er oppfylt, og de slettes når søkeren blir kvalifisert
  # (OPT-BEH-BEH-008). Den automatiske vurderingen gjør ikke noe med manglene saksbehandleren
  # har registrert. I FS-klienten sletter «Godkjenn» dem.
  # Avklart 30.10.2026: vurderingen av vitnemålet og praksisautomatikken
  # (knytte_praksis_til_opptakskrav.feature, OPT-BEH-BEH-006) vurderer hver sine kravelementer,
  # og møtes ikke. Saksbehandlerens vurdering låser kravelementet i begge.
  # Avklart 30.10.2026: fjernes et studieønske, blir kravelementene det ga, og vurderingen av
  # dem, stående (STEK-505). Søkeren ser mangeltekstene per søknadsalternativ, og ser dem ikke
  # lenger når søknadsalternativet er fjernet (OPT-BEH-BEH-008).
  # Avklart 30.10.2026: FS157.001 i FS-klienten, som beregner om søkerne er kvalifisert for et
  # helt opptak, dekkes av OPT-BEH-BEH-026 «Beregne automatisk på nytt».

  @depends-on-OPT-REG-KRA-002 @ref-FLY-OPT-AUT-001
  Regel: Kravelementer som er koblet til vitnemålet, vurderes automatisk
    # Koblingen er kravkoden for vitnemålet, som settes på kravelementet i
    # regelverket. Én kravkode sjekker vitnemål fra både R94 og Kunnskapsløftet.

    Scenario: Fagkrav som er oppfylt på vitnemålet
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Og at vitnemålet har Matematikk R1
      Og at søknaden har fagkravet Matematikk R1, koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er fagkravet Matematikk R1 oppfylt

    Scenario: Fagkrav som ikke er oppfylt på vitnemålet
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Og at vitnemålet ikke har Matematikk R1
      Og at søknaden har fagkravet Matematikk R1, koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er fagkravet Matematikk R1 ikke oppfylt

    Scenario: Karakteren fra vitnemålet registreres på fagkravet
      Gitt at søkeren har ett elektronisk vitnemål med karakteren 5 i Fysikk 1
      Og at søknaden har fagkravet Fysikk 1, koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er fagkravet Fysikk 1 oppfylt
      Og fagkravet Fysikk 1 har karakteren 5

    Scenario: Fagkrav uten karakter oppfylles uten karakter
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Og at vitnemålet har faget som fagkravet krever, uten tallkarakter
      Og at søknaden har fagkravet, koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er fagkravet oppfylt
      Og fagkravet har ingen karakter

    Scenario: Karakterkrav får karakteren fra vitnemålet
      Gitt at søkeren har ett elektronisk vitnemål med karakteren 4 i engelsk
      Og at søknaden har karakterkravet engelsk, koblet til vitnemålet
      Når søknaden behandles automatisk
      Så har karakterkravet engelsk karakteren 4

    Scenario: Beste karakter gjelder for programfag matematikk
      Gitt at søkeren har ett elektronisk vitnemål med karakteren 5 i Matematikk R1 og karakteren 3 i Matematikk S1
      Og at søknaden har kravelementet programfag matematikk, koblet til vitnemålet
      Når søknaden behandles automatisk
      Så har kravelementet programfag matematikk karakteren 5

    Scenario: Kravelement som ikke er koblet til vitnemålet, vurderes ikke
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Og at søknaden har et kravelement som ikke er koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er kravelementet ikke vurdert

    Scenario: Kravelementer fra en annen sak i søknaden vurderes ikke i saken
      # STEK-593.
      Gitt at søknaden har saker hos "Universitetet i Oslo" og "UiT Norges arktiske universitet"
      Og at "Informatikk, UiO" har kravelementet "Matematikk R2"
      Og at ingen av søknadsalternativene i saken hos "UiT Norges arktiske universitet" har kravelementet "Matematikk R2"
      Når kravelementene i saken hos "UiT Norges arktiske universitet" vurderes automatisk
      Så er "Matematikk R2" ikke vurdert i saken hos "UiT Norges arktiske universitet"

    Scenario: Kravelement vurderes mot vitnemål fra R94
      Gitt at søkeren har ett elektronisk vitnemål fra R94
      Og at søknaden har et kravelement som er koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er kravelementet vurdert mot vitnemålet fra R94

    Scenario: Ugyldig karakter må vurderes manuelt
      Gitt at søkeren har ett elektronisk vitnemål med en ugyldig karakter i Fysikk 1
      Og at søknaden har fagkravet Fysikk 1, koblet til vitnemålet
      Når søknaden behandles automatisk
      Så har fagkravet Fysikk 1 ingen karakter
      Og saksbehandleren ser at fagkravet må vurderes manuelt

  @depends-on-OPT-BEH-BEH-004 @ref-FLY-OPT-AUT-001
  Regel: Kravelementene vurderes bare mot ett entydig vitnemål
    # Har søkeren flere vitnemål, velger saksbehandleren vitnemålet først.

    Scenariomal: Ingen automatisk vurdering når <grunn>
      Gitt at <grunn>
      Og at søknaden har et kravelement som er koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er kravelementet ikke vurdert

      Eksempler:
        | grunn                                                                                                    |
        | søkeren har flere elektroniske vitnemål som ikke er annullert, og saksbehandleren ikke har valgt vitnemål |
        | søkerens eneste elektroniske dokument er et kompetansebevis                                              |
        | søkeren ikke har noe elektronisk vitnemål                                                                |

    Scenario: Kravelementene vurderes mot vitnemålet saksbehandleren har valgt
      # Ikke bygget i dag: koden vurderer bare når søkeren har ett vitnemål.
      Gitt at søkeren har flere elektroniske vitnemål som ikke er annullert
      Og at saksbehandleren har valgt ett av vitnemålene som grunnlag
      Og at søknaden har et kravelement som er koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er kravelementet vurdert mot vitnemålet saksbehandleren har valgt

    Scenario: Kompetansebevis ved siden av vitnemålet stopper ikke vurderingen
      # Ikke bygget i dag: koden krever at vitnemålet er søkerens eneste dokument.
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Og at søkeren har et elektronisk kompetansebevis
      Og at søknaden har et kravelement som er koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er kravelementet vurdert mot vitnemålet

  @depends-on-OPT-REG-KRA-001 @ref-OPT-BEH-BEH-015 @ref-FLY-OPT-AUT-001
  Regel: Om søkeren er kvalifisert, avgjøres per grunnlag
    # Kravlistene er alternativer (ELLER), og kravelementene i en kravliste må
    # alle være oppfylt (OG), med mindre regelverket sier noe annet. Krever
    # kompetansekravet generell studiekompetanse, må søknaden ha en positiv
    # GSK-konklusjon.

    Scenario: Kvalifisert når alle kravelementene i en kravliste er oppfylt
      Gitt at kompetansekravet for grunnlaget krever Matematikk R1 og Fysikk 1
      Og at kravelementene Matematikk R1 og Fysikk 1 er oppfylt
      Når kravene er vurdert
      Så er søkeren kvalifisert på grunnlaget

    Scenario: Kvalifisert når én av kravlistene er oppfylt
      Gitt at kompetansekravet for grunnlaget krever Matematikk R1 og Fysikk 1, eller Matematikk R1 og Kjemi 1
      Og at kravelementene Matematikk R1 og Kjemi 1 er oppfylt
      Og at kravelementet Fysikk 1 ikke er oppfylt
      Når kravene er vurdert
      Så er søkeren kvalifisert på grunnlaget

    Scenario: Karakteren må nå karakterkravet
      Gitt at kompetansekravet for grunnlaget krever karakteren 4 i engelsk
      Og at kravelementet for engelsk har karakteren 3
      Når kravene er vurdert
      Så er søkeren ikke kvalifisert på grunnlaget

    Scenario: Søkeren kan være kvalifisert på ett grunnlag og ikke på et annet
      Gitt at saken har grunnlagene "VES" og "PRA"
      Og at saksbehandleren har lagt inn et unntak for et kravelement på grunnlaget "PRA"
      Når kravene er vurdert
      Så er søkeren kvalifisert på grunnlaget "VES"
      Og søkeren er ikke kvalifisert på grunnlaget "PRA"

    # Avklart 30.10.2026: i den automatiske vurderingen avgjøres kvalifiseringen per grunnlag.
    # Om den også må avgjøres per poengvariant, er et spørsmål i OPT-BEH-BEH-022.

  @ref-FLY-OPT-AUT-001
  Regel: Kravelementene vurderes i den automatiske behandlingen
    # Vurderingen kommer etter poengberegningen og før kvalifiseringen beregnes
    # på nytt.

    Scenario: Kravelementet vurderes i den automatiske behandlingen
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Og at søknaden har et kravelement som er koblet til en kravkode som kan vurderes automatisk
      Når søknaden behandles automatisk
      Så er kravelementet vurdert

    Scenario: Feil i vurderingen stopper ikke resten av behandlingen
      Gitt at vurderingen av kravelementene ikke lar seg gjennomføre for søknaden
      Når søknaden behandles automatisk
      Så er kravelementene ikke vurdert
      Og resten av den automatiske behandlingen er gjennomført

  Regel: Saksbehandlerens vurdering av et kravelement endres ikke av automatikken
    # Saksbehandleren kan også velge "la stå" på kravelementet uten å endre
    # vurderingen, og det er da låst på samme måte. Et kravelement som
    # saksbehandleren bare ser på, er ikke låst. Låsen gjelder ett kravelement,
    # ikke hele saken.

    Scenario: Saksbehandleren overstyrer vurderingen automatikken har satt
      Gitt at søknaden har fagkravet Fysikk 1, vurdert automatisk som ikke oppfylt
      Når saksbehandleren setter at fagkravet Fysikk 1 er oppfylt
      Så er fagkravet Fysikk 1 oppfylt
      Og fagkravet Fysikk 1 er låst mot automatisk vurdering

    Scenario: Saksbehandleren overstyrer karakteren som automatikken har satt
      Gitt at søknaden har fagkravet Fysikk 1, vurdert automatisk med karakteren 4
      Når saksbehandleren setter karakteren 5 på fagkravet Fysikk 1
      Så har fagkravet Fysikk 1 karakteren 5
      Og fagkravet Fysikk 1 er låst mot automatisk vurdering

    Scenario: Kravelement som saksbehandleren vurderer, låses
      Gitt at søknaden har et kravelement som er vurdert automatisk
      Når saksbehandleren endrer vurderingen av kravelementet
      Så er kravelementet låst mot automatisk vurdering

    Scenario: Saksbehandleren velger "la stå" på kravelementet
      Gitt at søknaden har et kravelement som er vurdert automatisk
      Når saksbehandleren velger "la stå" på kravelementet
      Så er kravelementet låst mot automatisk vurdering
      Og vurderingen av kravelementet er som før

    Scenario: Kravelement som saksbehandleren bare ser på, vurderes automatisk igjen
      Gitt at søknaden har et kravelement som er vurdert automatisk
      Og at saksbehandleren har sett på kravelementet uten å endre vurderingen eller velge "la stå"
      Når søknaden behandles automatisk
      Så er kravelementet vurdert automatisk på nytt

    Scenario: Låst kravelement vurderes ikke på nytt
      Gitt at søknaden har et kravelement som er låst mot automatisk vurdering
      Når søknaden behandles automatisk
      Så er vurderingen av kravelementet uendret

    Scenario: Andre kravelementer vurderes selv om saksbehandleren har vurdert ett
      Gitt at saksbehandleren har vurdert Matematikk R1 på søknaden
      Og at søknaden har fagkravet Fysikk 1, koblet til en kravkode som kan vurderes automatisk
      Når søknaden behandles automatisk
      Så er fagkravet Fysikk 1 vurdert automatisk
      Og vurderingen av Matematikk R1 er uendret

    Scenario: Nullstilt kravelement kan vurderes automatisk igjen
      Gitt at søknaden har et kravelement som er låst mot automatisk vurdering
      Når saksbehandleren nullstiller vurderingen av kravelementet
      Og søknaden behandles automatisk
      Så er kravelementet vurdert automatisk på nytt

    Scenario: Unntak per grunnlag endres ikke
      Gitt at saksbehandleren har lagt inn et unntak for et kravelement på et grunnlag
      Når søknaden behandles automatisk
      Så er unntaket uendret

  Regel: Når grunnlaget endres, vurderes kravene på nytt

    Scenario: Kravelementer for et grunnlag som fjernes, beholder vurderingen
      Gitt at et kravelement er vurdert for et grunnlag
      Når grunnlaget fjernes fra søknaden
      Og grunnlaget legges til igjen
      Så har kravelementet den samme vurderingen som før

    Scenario: Kravelementer for et nytt grunnlag vurderes
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Når saken får et nytt grunnlag med kravelementer som er koblet til vitnemålet
      Og søknaden behandles automatisk
      Så er kravelementene for det nye grunnlaget vurdert

  Regel: Det fremgår at kravelementet er vurdert automatisk

    Scenario: Se at kravelementet er vurdert automatisk
      Gitt at et kravelement er vurdert automatisk
      Når saksbehandleren ser på de spesielle opptakskravene
      Så ser saksbehandleren at kravelementet er vurdert automatisk
      Og saksbehandleren ser hvilket vitnemål vurderingen bygger på

    Scenario: Manuell endring fjerner markeringen som automatisk vurdert
      Gitt at et kravelement er vurdert automatisk
      Når saksbehandleren endrer vurderingen av kravelementet
      Så er kravelementet ikke lenger markert som vurdert automatisk

    Scenario: Endringsloggen viser at automatikken vurderte kravelementet
      Gitt at et kravelement er vurdert automatisk
      Når saksbehandleren ser i endringsloggen
      Så ser saksbehandleren at kravelementet ble vurdert av den automatiske behandlingen

    @openquestion
    Scenario: Finne søkere som ikke er kvalifisert
      # ÅPNE SPØRSMÅL:
      # - FS-klienten har rapporten FS102.004 «Ikke-kvalifiserte søkere –
      #   spesielle opptakskrav» og brevet FS120.002 til søkere med manglende
      #   fagkrav. Hva trengs i ny stack: et filter i saksoversikten, en
      #   rapport eller begge?
      Gitt at noen søkere i opptaket ikke er kvalifisert på de spesielle opptakskravene
      Når saksbehandleren ser etter søkerne som ikke er kvalifisert
      Så finner saksbehandleren søkerne som ikke er kvalifisert
