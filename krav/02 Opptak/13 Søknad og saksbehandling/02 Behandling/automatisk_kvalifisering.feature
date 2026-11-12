# language: no
# BEGREPER (2026-11-10): Bytt «saksbehandlende organisasjon» med «behandler» når fila likevel endres. Se krav/02 Opptak/begreper.md.
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
# ligger i PL/SQL. FS-klienten har også FS102.004 «Ikke-kvalifiserte søkere – spesielle
# opptakskrav» og FS120.002 «Brev til søkere med manglende fagkrav». Avklart 06.11.2026: et
# filter i saksoversikten holder (scenarioet «Finne søkere som ikke er kvalifisert»).
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
#   automatisk_poengberegning.feature (@OPT-BEH-BEH-018).
# - Hvordan saksbehandleren velger vitnemål for søkere med flere vitnemål,
#   står i velge_vitnemål_som_grunnlag.feature (@OPT-BEH-BEH-004). At
#   kravelementene vurderes automatisk mot vitnemålet saksbehandleren har
#   valgt, står i behandle_automatisk_på_valgt_vitnemål.feature (@OPT-BEH-BEH-039).
@OPT-BEH-BEH-020 @must @in-progress @scope-automatisk-kvalifisering-og-poengsum @ref-OPT-BEH-BEH-025
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
  # (OPT-BEH-BEH-036). Den automatiske vurderingen gjør ikke noe med manglene saksbehandleren
  # har registrert. I FS-klienten sletter «Godkjenn» dem.
  # Avklart 30.10.2026: vurderingen av vitnemålet og praksisautomatikken
  # (knytte_praksis_til_opptakskrav.feature, OPT-BEH-BEH-006) vurderer hver sine kravelementer,
  # og møtes ikke. Saksbehandlerens vurdering låser kravelementet i begge.
  # Avklart 30.10.2026: fjernes et studieønske, blir kravelementene det ga, og vurderingen av
  # dem, stående (STEK-505). Søkeren ser mangeltekstene per søknadsalternativ, og ser dem ikke
  # lenger når søknadsalternativet er fjernet (OPT-BEH-BEH-036).
  # Avklart 30.10.2026: FS157.001 i FS-klienten, som beregner om søkerne er kvalifisert for et
  # helt opptak, dekkes av OPT-BEH-BEH-026 «Beregne automatisk på nytt».
  # Avklart 03.11.2026: vurderingen krever ikke GSK, så saksbehandleren kan få kravelementene
  # vurdert før GSK er satt. Om saken behandles helautomatisk, og stopper uten GSK, avgjøres i
  # OPT-BEH-BEH-025.

  @depends-on-OPT-REG-KRA-002 @ref-FLY-OPT-AUT-001 @implemented
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
      Gitt at søknaden har saker hos to saksbehandlende organisasjoner
      Og at et søknadsalternativ i saken hos den ene saksbehandlende organisasjonen har et kravelement
      Og at ingen av søknadsalternativene i saken hos den andre saksbehandlende organisasjonen har kravelementet
      Når kravelementene i saken hos den andre saksbehandlende organisasjonen vurderes automatisk
      Så er kravelementet ikke vurdert i saken hos den andre saksbehandlende organisasjonen

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

  @depends-on-OPT-BEH-BEH-004 @ref-FLY-OPT-AUT-001 @implemented
  Regel: Kravelementene vurderes bare mot ett entydig vitnemål
    # Har søkeren flere vitnemål, velger saksbehandleren vitnemålet først (OPT-BEH-BEH-039).

    @deprecated
    Scenariomal: Ingen automatisk vurdering når <grunn> (avvikles)
      Gitt at <grunn>
      Og at søknaden har et kravelement som er koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er kravelementet ikke vurdert

      Eksempler:
        | grunn                                                                                                    |
        | søkeren har flere elektroniske vitnemål som ikke er annullert, og saksbehandleren ikke har valgt vitnemål |
        | søkerens eneste elektroniske dokument er et kompetansebevis                                              |
        | søkeren ikke har noe elektronisk vitnemål                                                                |

    # Avklart 06.11.2026: kompetansebevis kommer ikke fra KREG, så raden om kompetansebevis er tatt ut.
    Scenariomal: Ingen automatisk vurdering når <grunn>
      Gitt at <grunn>
      Og at søknaden har et kravelement som er koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er kravelementet ikke vurdert

      Eksempler:
        | grunn                                                                                                    |
        | søkeren har flere elektroniske vitnemål som ikke er annullert, og saksbehandleren ikke har valgt vitnemål |
        | søkeren ikke har noe elektronisk vitnemål                                                                |

    Scenario: Opplastet kompetansebevis stopper ikke vurderingen
      # Avklart 06.11.2026: kompetansebevis kommer bare som dokumenter søkeren laster opp, ikke
      # fra KREG. Saksbehandleren finner sakene med filteret «Ubehandlet opplastet dok.» i
      # saksoversikten. Filteret er ikke beskrevet i et krav ennå.
      Gitt at søkeren har ett elektronisk vitnemål som ikke er annullert
      Og at søkeren har lastet opp et kompetansebevis
      Og at søknaden har et kravelement som er koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er kravelementet vurdert mot vitnemålet

  @depends-on-OPT-REG-KRA-001 @ref-OPT-BEH-BEH-015 @ref-FLY-OPT-AUT-001 @implemented
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
    # Avklart 05.11.2026: også i vitnemålsbehandleren avgjøres kvalifiseringen per grunnlag,
    # ikke per poengvariant (OPT-BEH-BEH-022, «Kravelementene vurderes per grunnlag»).

  @ref-FLY-OPT-AUT-001 @implemented
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

  @draft @openquestion @ref-OPT-BEH-BEH-022
  Regel: Kravelementene vurderes i samme bilde som fagene
    # ÅPNE SPØRSMÅL:
    # - Skal kravelementene kunne vurderes i samme bilde som fagene i
    #   vitnemålsbehandleren, under «2. Grunnlag», så saksbehandleren slipper
    #   å klikke fram og tilbake mellom steg 2 og steg 3? Det gjelder både
    #   elektroniske og manuelt innlagte vitnemål, og «3. Spesielle
    #   opptakskrav» må vise det som er vurdert i steg 2. Innspill fra Ingrid
    #   Grimstad Helset på siden med åpne spørsmål for vitnemålsbehandlingen
    #   05.11.2026, og teamet bak vitnemålsbehandleren er enig.
    # - Skissen «Steg 2 Grunnlag – behandle e-vitnemål» (Figma, FS-Admin –
    #   Seksjon Opptak) har allerede en grå seksjon «Spesielle opptakskrav»
    #   nederst i steg 2, under fagene. Grått betyr at den ikke hører til
    #   vitnemålsbehandleren. Hvem lager den, og skal den stå der eller
    #   lenger opp?
    # AVKLART 11.11.2026: når poengvariantene på samme grunnlag har ulikt
    # fagvalg, kontrolleres kravelementene mot vitnemålet og fagene i
    # poengvarianten saksbehandleren lagrer (OPT-BEH-BEH-022, «Kravelementene
    # kontrolleres mot fagene i poengvarianten som lagres»).

    Scenario: Vurdere kravelementene i grunnlaget
      Gitt saksbehandleren har lagt et vitnemål til grunn i vitnemålsbehandleren
      Når saksbehandleren ser grunnlaget på søknaden
      Så ser saksbehandleren kravelementene for hvert grunnlag sammen med fagene
      Og saksbehandleren kan vurdere kravelementene uten å gå til spesielle opptakskrav

    Scenario: Spesielle opptakskrav viser vurderingen fra grunnlaget
      Gitt saksbehandleren har vurdert et kravelement i grunnlaget
      Når saksbehandleren går til spesielle opptakskrav
      Så ser saksbehandleren vurderingen fra grunnlaget

  Regel: Saksbehandlerens vurdering av et kravelement endres ikke av automatikken
    # Kravelementet låses når saksbehandleren registrerer en karakter eller en
    # vurdering på det. Det finnes ikke et eget valg for å låse kravelementet
    # uten å registrere noe (avklart 09.11.2026). Et kravelement som
    # saksbehandleren bare ser på, er ikke låst. Låsen gjelder ett kravelement,
    # ikke hele saken.

    @implemented
    Scenario: Saksbehandleren overstyrer vurderingen automatikken har satt
      Gitt at søknaden har fagkravet Fysikk 1, vurdert automatisk som ikke oppfylt
      Når saksbehandleren setter at fagkravet Fysikk 1 er oppfylt
      Så er fagkravet Fysikk 1 oppfylt
      Og fagkravet Fysikk 1 er låst mot automatisk vurdering

    @implemented
    Scenario: Saksbehandleren overstyrer karakteren som automatikken har satt
      Gitt at søknaden har fagkravet Fysikk 1, vurdert automatisk med karakteren 4
      Når saksbehandleren setter karakteren 5 på fagkravet Fysikk 1
      Så har fagkravet Fysikk 1 karakteren 5
      Og fagkravet Fysikk 1 er låst mot automatisk vurdering

    @implemented
    Scenario: Kravelement som saksbehandleren vurderer, låses
      Gitt at søknaden har et kravelement som er vurdert automatisk
      Når saksbehandleren endrer vurderingen av kravelementet
      Så er kravelementet låst mot automatisk vurdering

    @implemented
    Scenario: Kravelement som saksbehandleren bare ser på, vurderes automatisk igjen
      Gitt at søknaden har et kravelement som er vurdert automatisk
      Og at saksbehandleren har sett på kravelementet uten å endre vurderingen
      Når søknaden behandles automatisk
      Så er kravelementet vurdert automatisk på nytt

    @implemented
    Scenario: Låst kravelement vurderes ikke på nytt
      Gitt at søknaden har et kravelement som er låst mot automatisk vurdering
      Når søknaden behandles automatisk
      Så er vurderingen av kravelementet uendret

    @implemented
    Scenario: Andre kravelementer vurderes selv om saksbehandleren har vurdert ett
      Gitt at saksbehandleren har vurdert Matematikk R1 på søknaden
      Og at søknaden har fagkravet Fysikk 1, koblet til en kravkode som kan vurderes automatisk
      Når søknaden behandles automatisk
      Så er fagkravet Fysikk 1 vurdert automatisk
      Og vurderingen av Matematikk R1 er uendret

    @implemented
    Scenario: Nullstilt kravelement kan vurderes automatisk igjen
      Gitt at saksbehandleren har satt at fagkravet Norsk er oppfylt, med karakteren 4
      Når saksbehandleren nullstiller karakteren og vurderingen av fagkravet Norsk
      Og søknaden behandles automatisk
      Så er fagkravet Norsk vurdert automatisk på nytt

    Scenario: Nullstilt karakter beregnes automatisk igjen
      Gitt at saksbehandleren har satt at fagkravet Norsk er oppfylt, med karakteren 4
      Når saksbehandleren nullstiller karakteren på fagkravet Norsk
      Og søknaden behandles automatisk
      Så har fagkravet Norsk karakteren fra vitnemålet
      Og fagkravet Norsk er oppfylt, som saksbehandleren satte

    Scenario: Nullstilt vurdering settes automatisk igjen
      Gitt at saksbehandleren har satt at fagkravet Norsk er oppfylt, med karakteren 4
      Når saksbehandleren nullstiller vurderingen av fagkravet Norsk
      Og søknaden behandles automatisk
      Så er det vurdert automatisk om fagkravet Norsk er oppfylt
      Og fagkravet Norsk har karakteren 4, som saksbehandleren satte

    @implemented
    Scenario: Unntak per grunnlag endres ikke
      Gitt at saksbehandleren har lagt inn et unntak for et kravelement på et grunnlag
      Når søknaden behandles automatisk
      Så er unntaket uendret

  @implemented
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

    @implemented
    Scenario: Se at kravelementet er vurdert automatisk
      Gitt at et kravelement er vurdert automatisk
      Når saksbehandleren ser på de spesielle opptakskravene
      Så ser saksbehandleren at kravelementet er vurdert automatisk
      Og saksbehandleren ser hvilket vitnemål vurderingen bygger på

    @implemented
    Scenario: Manuell endring fjerner markeringen som automatisk vurdert
      Gitt at et kravelement er vurdert automatisk
      Når saksbehandleren endrer vurderingen av kravelementet
      Så er kravelementet ikke lenger markert som vurdert automatisk

    Scenario: Endringsloggen viser at automatikken vurderte kravelementet
      Gitt at et kravelement er vurdert automatisk
      Når saksbehandleren ser i endringsloggen
      Så ser saksbehandleren at kravelementet ble vurdert av den automatiske behandlingen

    @implemented
    Scenario: Finne søkere som ikke er kvalifisert
      # Avklart 06.11.2026 (økt med fagfolk): et filter i saksoversikten holder. Rapporten
      # FS102.004 «Ikke-kvalifiserte søkere – spesielle opptakskrav» og brevet FS120.002 fra
      # FS-klienten trengs ikke i denne flyten.
      # Avklart 06.11.2026 (Jøran, PR #966): filteret «Ikke kvalifiserte» holder, selv om det ikke
      # skiller spesielle opptakskrav fra generell studiekompetanse. Saksbehandleren ser grunnen i
      # saken.
      Gitt at noen søkere i opptaket ikke er kvalifisert på de spesielle opptakskravene
      Når saksbehandleren ser etter søkerne som ikke er kvalifisert
      Så finner saksbehandleren søkerne som ikke er kvalifisert
