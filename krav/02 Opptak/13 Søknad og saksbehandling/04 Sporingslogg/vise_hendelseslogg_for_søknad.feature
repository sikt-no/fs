# language: no
@OPT-BEH-SPO-002 @must @draft
Egenskap: Vise hendelseslogg for søknad
  Som saksbehandler
  ønsker jeg å se hva som er gjort og vurdert i søknaden, av hvem, når og hvorfor
  slik at jeg forstår hva som har skjedd med søknaden.

  Hendelsesloggen for søknaden skal dekke to behov:
  Kontinuitet i saksbehandlingen: en søknad følger ikke én saksbehandler, og den som tar over,
  må se hva som er vurdert, av hvem og hvorfor.
  Klager og påstander fra søkeren: saksbehandleren må kunne avgjøre om søkeren gjorde det hen hevder,
  og behandle klager på likt grunnlag.

  Kravene sier hva saksbehandleren ser i hendelsesloggen for søknaden, ikke hva som logges.
  Innsynsloggen vises ikke i første versjon, og er ikke med her.

  Bakgrunn:
    Gitt saksbehandleren er innlogget i løsningen
    Og saksbehandleren ser detaljsiden for en søknad

  Regel: Hendelsesloggen viser hendelsene i søknaden

    Scenario: Se hendelsesloggen for søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hendelsene i søknaden med nyeste hendelse først
      Og hver hendelse viser følgende informasjon:
        | felt              |
        | Tidspunkt         |
        | Handling          |
        | Utført av         |
        | Verdi før         |
        | Verdi etter       |

    @openquestion
    Scenario: Se historikken for et felt i søknaden
      # ÅPNE SPØRSMÅL:
      # - Skal saksbehandleren se historikken der feltet står i søknaden, eller ved å filtrere hendelsesloggen på feltet?
      Gitt poengene for søkeren er justert flere ganger
      Når saksbehandleren ser historikken for poengene
      Så ser saksbehandleren alle endringene av poengene med nyeste endring først
      Og saksbehandleren ser hvem som gjorde hver endring, og når

    @openquestion
    Scenario: Se at en handling feilet
      # ÅPNE SPØRSMÅL:
      # - Skal saksbehandleren se handlinger som feilet, eller bare opptakets forvalter?
      Gitt søkeren forsøkte å sende inn søknaden uten at innsendingen lyktes
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren at innsendingen feilet
      Og saksbehandleren ser feilmeldingen søkeren fikk

  Regel: Hendelsesloggen viser hva søkeren har gjort i søknaden

    Scenario: Se at søkeren har sendt inn søknaden
      Gitt søkeren har sendt inn søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren når søknaden ble sendt inn
      Og saksbehandleren ser søknadsalternativene i den rekkefølgen søkeren sendte dem

    Scenario: Se at søkeren har endret rekkefølgen på søknadsalternativene
      Gitt søkeren har endret rekkefølgen på søknadsalternativene
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren rekkefølgen på søknadsalternativene før og etter endringen

    Scenario: Se at søkeren har lagt til et søknadsalternativ
      Gitt søkeren har lagt til et søknadsalternativ
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hvilket søknadsalternativ søkeren la til

    @openquestion
    Scenario: Se at søkeren har fjernet et søknadsalternativ
      # ÅPNE SPØRSMÅL:
      # - Hvordan vises et søknadsalternativ som er fjernet, når utdanningstilbudet ikke lenger finnes?
      Gitt søkeren har fjernet et søknadsalternativ
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hvilket søknadsalternativ søkeren fjernet

    @openquestion
    Scenario: Se at et søknadsalternativ har utgått
      # ÅPNE SPØRSMÅL:
      # - Fjerner løsningen søknadsalternativer når utdanningstilbudet ikke lenger tilbys, og hvilke årsaker finnes?
      # - Er det søkeren eller saksbehandleren som trenger å se dette?
      Gitt et søknadsalternativ er fjernet fra søknaden fordi utdanningstilbudet ikke lenger tilbys
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hvilket søknadsalternativ som er fjernet
      Og saksbehandleren ser årsaken til at søknadsalternativet er fjernet

    Scenario: Se at søkeren har endret utdanningsbakgrunnen
      Gitt søkeren har endret utdanningsbakgrunnen
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren utdanningsbakgrunnen før og etter endringen

    Scenario: Se at søkeren har trukket søknaden
      Gitt søkeren har trukket søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren når søknaden ble trukket

    Scenario: Se at søkeren har gjenopptatt søknaden
      Gitt søkeren har gjenopptatt søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren når søknaden ble gjenopptatt

    Scenario: Se at søkeren har svart på et tilbud
      Gitt søkeren har svart på et tilbud
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hvilket tilbud søkeren svarte på, og svaret søkeren ga
      Og saksbehandleren ser når søkeren svarte

  Regel: Hendelsesloggen viser endringene på dokumentene i søknaden

    @openquestion
    Scenario: Se at søkeren har lastet opp et dokument
      # ÅPNE SPØRSMÅL:
      # - Skal saksbehandleren se filnavnet, eller bare dokumenttypen? Filnavn kan avsløre sensitive forhold.
      Gitt søkeren har lastet opp et dokument
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren når dokumentet ble lastet opp
      Og saksbehandleren ser dokumenttypen

    Scenario: Se at søkeren har slettet et dokument
      Gitt søkeren har slettet et dokument
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hvilket dokument søkeren slettet, og når

    Scenario: Se at søkeren har meldt at opplastingen er ferdig
      Gitt søkeren har meldt at hen er ferdig med å laste opp dokumenter
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren når søkeren meldte at opplastingen var ferdig

    Scenario: Se at søkeren har endret samtykket til lagring av dokumenter
      Gitt søkeren har endret samtykket til lagring av dokumenter
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren samtykket før og etter endringen

  Regel: Hendelsesloggen viser saksbehandlernes vurderinger med begrunnelse

    Scenario: Se vurderingen av generell studiekompetanse
      Gitt en saksbehandler har vurdert generell studiekompetanse for søkeren
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren om generell studiekompetanse ble godkjent
      Og saksbehandleren ser begrunnelsen for vurderingen

    @openquestion
    Scenario: Se endringene i grunnlaget
      # ÅPNE SPØRSMÅL:
      # - Gjelder det kvalifikasjonsgrunnlaget, rangeringsgrunnlaget eller begge?
      Gitt en saksbehandler har registrert eller justert grunnlaget for søkeren
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren grunnlaget før og etter endringen
      Og saksbehandleren ser begrunnelsen for endringen

    @openquestion
    Scenario: Se vurderingen av et opplastet dokument
      # ÅPNE SPØRSMÅL:
      # - Hvilke vurderinger kan saksbehandleren gjøre av et opplastet dokument eller vitnemål:
      #   godkjent, underkjent, ikke relevant, eller andre?
      # - Skal saksbehandleren kunne godkjenne vitnemål manuelt, og gjelder det bare opplastede vitnemål?
      # - Skal vurderingen av vitnemål ha et eget krav, skilt fra vurderingen av andre dokumenter?
      Gitt en saksbehandler har vurdert et opplastet dokument
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren vurderingen av dokumentet før og etter endringen
      Og saksbehandleren ser begrunnelsen for vurderingen

    @openquestion
    Scenario: Se endringene i poengene
      # ÅPNE SPØRSMÅL:
      # - Kjønnspoeng sier noe om kjønn. Gjør det denne delen av loggen til en behandling av særlige kategorier personopplysninger?
      Gitt en saksbehandler har registrert eller justert poengene for søkeren manuelt
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren poengene før og etter endringen
      Og saksbehandleren ser begrunnelsen for endringen

    Scenario: Se vurderingen av et spesielt opptakskrav
      Gitt en saksbehandler har vurdert et spesielt opptakskrav for søkeren
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren vurderingen av opptakskravet før og etter endringen
      Og saksbehandleren ser begrunnelsen for vurderingen

    @openquestion
    Scenario: Se vurderingen av en kvote
      # ÅPNE SPØRSMÅL:
      # - Gjelder det en utdanningskvote, og at søkeren får en kvotesøknad i den?
      # - Noen kvoter, som samisk kvote, kan si noe om etnisk tilhørighet. Gjør det denne delen av loggen til en behandling av særlige kategorier personopplysninger?
      Gitt en saksbehandler har vurdert om søkeren skal være med i en kvote
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren kvoten, og om søkeren er med i kvoten
      Og saksbehandleren ser begrunnelsen for vurderingen

  Regel: Hendelsesloggen viser saksbehandlernes oppfølging av søknaden med begrunnelse

    @openquestion
    Scenario: Se at statusen er endret
      # ÅPNE SPØRSMÅL:
      # - Er det behandlingsstatusen til saken (søknaden slik den ligger hos én saksbehandlende organisasjon)?
      Gitt en saksbehandler har endret statusen på søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren statusen før og etter endringen
      Og saksbehandleren ser begrunnelsen for endringen

    @openquestion
    Scenario: Se at søknaden er fordelt til en annen saksbehandlende organisasjon
      # ÅPNE SPØRSMÅL:
      # - Hvilke årsaker til en fordeling må kunne registreres?
      # - Er det søknaden eller ett søknadsalternativ som fordeles?
      Gitt søknaden er fordelt til en annen saksbehandlende organisasjon
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren den saksbehandlende organisasjonen før og etter fordelingen
      Og saksbehandleren ser årsaken til fordelingen

    @openquestion
    Scenario: Se at søknaden er fordelt til en annen saksbehandler
      # ÅPNE SPØRSMÅL:
      # - Fordeles søknader til enkeltsaksbehandlere i FS Admin, og hvem gjør det?
      Gitt søknaden er fordelt til en annen saksbehandler
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hvilken saksbehandler søknaden var fordelt til før og etter fordelingen
      Og saksbehandleren ser årsaken til fordelingen

    Scenario: Se at en mangel er registrert
      Gitt en saksbehandler har registrert en mangel i søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hvilken mangel som ble registrert
      Og saksbehandleren ser begrunnelsen for mangelen

    Scenario: Se at en mangel er fjernet
      Gitt en saksbehandler har fjernet en mangel i søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hvilken mangel som ble fjernet
      Og saksbehandleren ser begrunnelsen for at mangelen ble fjernet

    @openquestion
    Scenario: Se at en merknad er lagt til
      # ÅPNE SPØRSMÅL:
      # - Hva er forskjellen på interne og eksterne merknader, og skal begge vises?
      # - Skal det også vises når en merknad endres eller slettes?
      Gitt en saksbehandler har lagt til en merknad i søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren merknaden, og når den ble lagt til

  @openquestion
  Regel: Hendelsesloggen viser endringer opptaksforvalteren har gjort på vegne av søkeren
    # ÅPNE SPØRSMÅL:
    # - Skal søkeren få kvittering hver gang opptaksforvalteren endrer søknaden på søkerens vegne?
    # - Skal også saksbehandleren kunne endre søknaden på søkerens vegne?

    Scenario: Se at opptaksforvalteren har endret søknaden på vegne av søkeren
      Gitt opptaksforvalteren har endret rekkefølgen på søknadsalternativene på vegne av søkeren
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren rekkefølgen før og etter endringen
      Og saksbehandleren ser at endringen ble gjort av opptaksforvalteren på vegne av søkeren

  @openquestion
  Regel: Hendelsesloggen viser endringer i søkerens personopplysninger
    # ÅPNE SPØRSMÅL:
    # - Skal saksbehandleren se endringer i søkerens personopplysninger, eller bare søkeren og opptakets forvalter?
    # - Hører endringene til hendelsesloggen for søknaden, eller til en egen logg for søkerens profil?
    # - Skal søkeren få kvittering når opptaksforvalteren endrer personopplysningene?

    Scenario: Se at søkeren har endret personopplysningene sine
      Gitt søkeren har endret e-postadressen sin
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren e-postadressen før og etter endringen

    Scenario: Se at opptaksforvalteren har endret søkerens personopplysninger
      Gitt opptaksforvalteren har endret søkerens e-postadresse
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren e-postadressen før og etter endringen
      Og saksbehandleren ser at endringen ble gjort av opptaksforvalteren

  @openquestion
  Regel: Hendelsesloggen viser vurderingene den automatiske behandlingen har gjort
    # ÅPNE SPØRSMÅL:
    # - Hvilke vurderinger fra den automatiske behandlingen skal vises? Kravene for den automatiske
    #   saksbehandlingen venter på hendelsesloggen for grunnlag, poeng, kvoteplassering, mangler og behandlingsstatus.

    Scenario: Se at den automatiske behandlingen har vurdert et opptakskrav
      Gitt den automatiske behandlingen har vurdert at søkeren oppfyller et opptakskrav
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren vurderingen av opptakskravet
      Og saksbehandleren ser at vurderingen ble gjort av den automatiske behandlingen

  @openquestion
  Regel: Hendelsesloggen viser hvem som gjorde endringen
    # ÅPNE SPØRSMÅL:
    # - Skal saksbehandleren også se hvilken ansatt som gjorde endringen? Saksbehandlerne i HK-dir vil se navn,
    #   så de kan spørre den som gjorde vurderingen. Forvaltningen mener organisasjonen er nok. Juristene vurderer det.

    Scenario: Se at søkeren gjorde endringen
      Gitt søkeren har endret rekkefølgen på søknadsalternativene
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren søkerens navn som den som gjorde endringen

    Scenario: Se rollen og organisasjonen til den som endret søknaden
      Gitt en annen saksbehandler har endret statusen på søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren rollen og organisasjonen til den som endret statusen

  Regel: Søk og filtrering av hendelser

    @openquestion
    Scenario: Fritekst-søk i hendelsene
      # ÅPNE SPØRSMÅL:
      # - Hva skal det kunne søkes i: handlingen, verdiene før og etter, begrunnelsen eller merknadene?
      Når saksbehandleren søker med fritekst i hendelsesloggen
      Så filtreres listen til hendelser som matcher søket

    Scenario: Filtrere på tidsrom
      Når saksbehandleren velger et tidsrom som filter
      Så vises kun hendelser i det valgte tidsrommet

    Scenario: Tilgjengelige handlinger i filter
      Når saksbehandleren åpner handlingsfilteret
      Så inneholder filteret alle handlinger som er representert i den ufiltrerte listen
      Og hver handling vises kun én gang
      Og handlingene er sortert alfabetisk
      Og "Alle handlinger" er valgt som standard

    Scenario: Filtrere på handling
      Når saksbehandleren velger en handling som filter
      Så vises kun hendelser med den valgte handlingen

    Scenario: Tilgjengelige utførere i filter
      Når saksbehandleren åpner filteret for hvem som utførte handlingen
      Så inneholder filteret disse verdiene i denne rekkefølgen
        | Utført av     |
        | Alle utførere |
        | Søkeren       |
        | En ansatt     |
        | Systemet      |
      Og "Alle utførere" er valgt som standard

    Scenario: Filtrere på hvem som utførte handlingen
      Når saksbehandleren velger hvem som utførte handlingen som filter
      Så vises kun hendelser utført av den valgte utføreren

    Scenario: Kombinere filtre
      Når saksbehandleren kombinerer flere filtre
      Så vises kun hendelser som matcher alle kriteriene

  @openquestion @ref-FEL-TAB-TAB-002
  Regel: Hendelsesloggen for søknaden kan hentes ut samlet
    # ÅPNE SPØRSMÅL:
    # - Hvem skal kunne hente ut hendelsesloggen?
    # - Gjelder filteret saksbehandleren har valgt, også for uttrekket?
    # - Hva må fjernes før uttrekket utleveres til søkeren, politiet eller en fagforening? Juristene vurderer det.

    Scenario: Hente ut hendelsesloggen for en klagesak
      Når saksbehandleren henter ut hendelsesloggen for søknaden
      Så får saksbehandleren hendelsene i søknaden samlet i ett uttrekk

  @openquestion
  Regel: Synlighet via saksbehandlende organisasjon og opptakets forvalter
    # ÅPNE SPØRSMÅL:
    # - Dette er forslaget fra innsiktsarbeidet, og det er ikke avklart. Ser lærestedet bare søknadene det behandler?
    # - Hva gjelder i lokale opptak, der lærestedet også er opptakets forvalter?
    # - Er «organisasjonen som behandler søknaden» den saksbehandlende organisasjonen? En søknad kan ha flere, én per søknadsalternativ.
    # - Ser saksbehandleren det andre saksbehandlere har gjort i samme søknad? I dag varierer det mellom fagskole,
    #   UHG og realkompetanse.

    Scenario: Saksbehandler ved organisasjonen som behandler søknaden ser hendelsesloggen
      Gitt saksbehandleren er saksbehandler ved organisasjonen som behandler søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hendelsene i søknaden

    Scenario: Saksbehandler hos opptakets forvalter ser hendelsesloggen
      Gitt saksbehandleren er saksbehandler hos opptakets forvalter
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hendelsene i søknaden

  @openquestion
  Regel: Hendelsesloggen viser søkerens innlogginger
    # ÅPNE SPØRSMÅL:
    # - Skal bare opptakets forvalter se søkerens innlogginger, eller også lærestedet i lokale opptak?
    # - Skal IP-adressen vises? Juristene vurderer om den kan lagres.
    # - Er det FS eller innloggingsløsningen som skal fange innlogginger som mislyktes?

    Scenario: Se at søkeren har logget inn
      Gitt søkeren har logget inn
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren når søkeren logget inn
      Og saksbehandleren ser innloggingsmetoden

    Scenario: Se at søkeren ikke har logget inn i et tidsrom
      Gitt søkeren ikke har logget inn i et tidsrom
      Når saksbehandleren velger tidsrommet som filter
      Så ser saksbehandleren at søkeren ikke har logget inn i tidsrommet

    Scenario: Se at innloggingen for søkeren mislyktes
      Gitt innloggingen for søkeren har mislyktes
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren når innloggingen mislyktes
      Og saksbehandleren ser hvilken feil som oppsto

  @openquestion
  Regel: Hendelsesloggen viser meldingene til søkeren
    # ÅPNE SPØRSMÅL:
    # - Hvor ligger meldingene og når de ble lest, når Baksiden er erstattet?
    # - Dekker den nye løsningen for utsendelser at meldingene vises her?

    Scenario: Se at en melding er sendt til søkeren
      Gitt en melding om en frist er sendt til søkeren
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren kanalen, tittelen og om sendingen lyktes

    Scenario: Se at søkeren har åpnet en melding
      Gitt søkeren har åpnet en melding om en frist
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren når søkeren åpnet meldingen

  @openquestion
  Regel: Hendelsesloggen henger sammen når søkeren får nytt fødselsnummer
    # ÅPNE SPØRSMÅL:
    # - Hvor lenge skal koblingen mellom gammelt og nytt fødselsnummer lagres?

    Scenario: Se hendelsene fra før søkeren fikk nytt fødselsnummer
      Gitt søkeren har fått nytt fødselsnummer etter at søknaden ble sendt inn
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hendelsene fra både før og etter at fødselsnummeret ble endret
      Og saksbehandleren ser når fødselsnummeret ble endret

# ÅPNE SPØRSMÅL:
# - Gjelder hendelsesloggen hele søknaden, med hendelsene i alle sakene, eller én sak (søknaden slik den ligger
#   hos én saksbehandlende organisasjon)? Saksbehandlerne i HK-dir mener det er nyttig å se hva alle har gjort
#   i søknaden, særlig i fagskole og for realkompetanse.
# - Skal påbegynte endringer som ikke ble sendt inn, vises?
# - Registrerer saksbehandleren karakterer manuelt fra opplastede vitnemål, og skal det vises i hendelsesloggen?
# - Hvilke endringer må saksbehandleren alltid begrunne? Kravet viser begrunnelsen for alle vurderingene og
#   endringene, ut fra kravet fra KREG om at endringer skal være sporbare og begrunnet.
# - Vurderinger og merknader fra søkerens tidligere opptak er saksdata, ikke logg. Hvilket krav skal beskrive dem?
# - «Hendelseslogg for saksbehandling» (OPT-BEH-BEH-016) beskriver den samme loggen, og OPT-BEH-BEH-025 viser til den.
#   Skal den tas inn i dette kravet og slettes, eller beholdes som eget krav?
# - Hvor beskrives det som bare gjelder lagring: IP-adresse, lagringstid, om ansatte lagres med navn, og innsynsloggen?
