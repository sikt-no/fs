# language: no
# GitHub: #628
#
# SKILT UT 23.09.2026 fra registrere_praksis.feature (@OPT-BEH-BEH-003).
# Praksiskalkulatoren skal stå uavhengig av opptakskrav, jf. innspill i
# løsningsforslaget (Confluence PFS 4996071435): «kalkulatoren bør heller
# vere uavhengig, enn knytt til spesielle opptakskrav». Kobling til
# kravelement og automatisk oppfylling er derfor flyttet hit som en egen,
# senere feature. Innholdet er flyttet uendret; avklaringene datert
# 16.09.2026 ble gjort mens det lå i registrere_praksis.feature.
#
# Regnereglene for praksis, og dagens løsning i FS-klienten, er beskrevet i
# registrere_praksis.feature og registrere_praksis.dagens-løsning-i-fs-klienten.md.
#
@OPT-BEH-BEH-004 @could @draft
Egenskap: Knytte praksis til opptakskrav
  Som opptakssaksbehandler
  ønsker jeg å knytte søkerens beregnede praksis til opptakskrav som krever praksis
  slik at opptakskravet kan vurderes på grunnlag av praksisberegningen.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg har rollen opptakssaksbehandler
    Og jeg er inne på søknaden til en søker

  Regel: Praksis knyttes til opptakskrav på ett eller flere søknadsalternativer

    Scenario: Knytte praksis til et opptakskrav på et søknadsalternativ
      Gitt søknaden har et søknadsalternativ med et opptakskrav som krever praksis
      Når jeg knytter den registrerte praksisen til opptakskravet
      Så er praksisen lagt til grunn for det opptakskravet på søknadsalternativet

    Scenario: Knytte samme praksis til flere søknadsalternativer
      Gitt søknaden har flere søknadsalternativer med opptakskrav som krever praksis
      Når jeg knytter den registrerte praksisen til opptakskravet på flere av søknadsalternativene
      Så er praksisen lagt til grunn for opptakskravet på hvert av de valgte søknadsalternativene

    Scenario: Praksis uten knytning påvirker ikke opptakskrav
      Gitt søkeren har registrerte praksisperioder
      Og praksisen ikke er knyttet til et opptakskrav
      Når jeg åpner søknadsalternativene
      Så er ingen opptakskrav vurdert på grunnlag av praksisen

    Scenario: Knytte samme praksis til flere ulike kravelementer
      Gitt søknaden har søknadsalternativer med ulike opptakskrav som krever praksis
      Når jeg knytter den registrerte praksisen til flere ulike kravelementer
      Så er praksisen lagt til grunn for hvert av de valgte kravelementene
      # AVKLART 16.09.2026: samme praksis kan knyttes til flere ulike
      # kravelementer, ikke bare til samme kravelement på flere
      # søknadsalternativer.

    @openquestion
    Scenario: AVKLAR om et utvalg av praksisperiodene kan knyttes per kravelement
      # ÅPNE SPØRSMÅL:
      # - Gjelder knytningen alltid *all* registrert praksis, eller kan et
      #   utvalg av periodene knyttes til ett kravelement og et annet utvalg
      #   til et annet?
      # - Avklaringen om at samme praksis kan knyttes til flere ulike
      #   kravelementer gjør dette spørsmålet skarpere, ikke mindre viktig.
      #   Løsningsforslaget sier at «vanlegaste forskjellen er vel kva
      #   praksis som reknast for å vere relevant» — ulike kravelementer kan
      #   altså ha ulike krav til hva som teller. Da kan relevans ikke være
      #   ett flagg per praksisperiode, slik det er i FS i dag; den må være
      #   per kombinasjon av periode og kravelement.
      # - Henger derfor direkte sammen med «Markere om en praksisperiode er
      #   relevant» i registrere_praksis.feature. De to må besluttes sammen — svaret
      #   avgjør datamodellen, og det er det siste store strukturelle
      #   spørsmålet i featuren.
      Gitt spørsmålet er åpent

    # FLYTTET 23.09.2026 fra registrere_praksis.feature. Kalkulatoren viser
    # både sum av oppgitte perioder og sum justert for overlapp; hvilken
    # som legges til grunn for et opptakskrav hører til koblingen.

    Scenario: Saksbehandleren velger hvilken sum som legges til grunn
      Gitt søkeren har overlappende praksisperioder
      Og både sum av oppgitte perioder og sum justert for overlapp er vist
      Når jeg velger hvilken av summene som skal legges til grunn
      Så er den valgte summen lagt til grunn for vurderingen av opptakskravet

    @openquestion
    Scenario: AVKLAR hvilken sum som gjelder når saksbehandleren ikke velger
      # ÅPNE SPØRSMÅL:
      # - Saksbehandleren velger hvilken sum som legges til grunn ved
      #   overlapp. Hva gjelder når det ikke er gjort et aktivt valg — er
      #   den justerte summen forhåndsvalgt, eller kan opptakskravet ikke
      #   vurderes før valget er tatt?
      # - Skal valget og begrunnelsen kunne etterprøves i ettertid?
      Gitt spørsmålet er åpent

  # MERK 16.09.2026: reglene under er NY funksjonalitet, ikke videreføring.
  # Verifisert i FS-klienten finnes det ingen kobling mellom praksisperioder
  # og kravelement. Praksis og fagprofil (kravelementkode + status_bestatt)
  # ligger som uavhengige faner i samme vindu, og saksbehandleren leser
  # summen og setter status manuelt. Løsningsforslaget beskriver dagens FS som
  # at systemet «sjekkar om søkar oppfyller opptakskravet» — det stemmer ikke.
  # Se registrere_praksis.dagens-løsning-i-fs-klienten.md, avsnittet «Kobling
  # til kravelement: finnes ikke». Det betyr at reglene under trenger mer
  # avklaring enn resten av featuren, og at sporbarhet for en automatisk satt
  # status må designes fra bunnen.

  Regel: Opptakskravet registreres automatisk som oppfylt når praksiskravet er nådd

    Scenario: Opptakskravet registreres som oppfylt
      Gitt et søknadsalternativ har et opptakskrav som krever 2 år praksis
      Og praksisen er knyttet til det opptakskravet
      Når samlet praksis som legges til grunn er 2,00 år
      Så registreres opptakskravet som oppfylt

    Scenario: Opptakskravet registreres ikke som oppfylt når praksisen er for kort
      Gitt et søknadsalternativ har et opptakskrav som krever 2 år praksis
      Og praksisen er knyttet til det opptakskravet
      Når samlet praksis som legges til grunn er 1,50 år
      Så registreres opptakskravet ikke som oppfylt

    @openquestion
    Scenario: AVKLAR hvor praksiskravet hentes fra
      # ÅPNE SPØRSMÅL:
      # - Opptakskravet vurderes mot et krav om antall år praksis. Hentes
      #   dette fra minimumskravet på kravelementet i kompetanseregelverket,
      #   eller oppgis det et annet sted?
      # - Kompetanseregelverket uttrykker minimumskrav som karakter og
      #   bestått/ikke bestått. Skal praksiskrav uttrykkes i samme
      #   minimumskrav-felt som antall år, eller trenger kravelementet et
      #   eget felt for praksisomfang?
      Gitt spørsmålet er åpent

    @openquestion
    Scenario: AVKLAR om oppfylt opptakskrav reverseres
      # ÅPNE SPØRSMÅL:
      # - Praksisberegningen justeres automatisk når en praksisperiode legges
      #   til eller slettes. Skal et opptakskrav som er registrert som
      #   oppfylt settes tilbake til ikke oppfylt når samlet praksis faller
      #   under kravet, eller består statusen til saksbehandleren endrer den
      #   manuelt?
      # - Skal saksbehandleren varsles når en endring i praksisperiodene
      #   endrer statusen på et opptakskrav?
      Gitt spørsmålet er åpent

    @openquestion
    Scenario: AVKLAR forholdet til manuell kvalifisering
      # ÅPNE SPØRSMÅL:
      # - Saksbehandleren kan i dag manuelt angi at en søker er kvalifisert
      #   for kravelementene i et opptak. Hva skjer når den automatiske
      #   praksisberegningen og den manuelle angivelsen er uenige — hvilken
      #   av dem gjelder?
      Gitt spørsmålet er åpent
