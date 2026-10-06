# language: no
# GitHub: #207
@OPT-BEH-BEH-007 @must @draft
Egenskap: Tildele saksbehandlende organisasjon
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å bestemme hvilken organisasjon som saksbehandler hvert søknadsalternativ
  slik at søkeren får færrest mulig saksbehandlende organisasjoner og søknaden behandles i samsvar med regelverket.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at "Universitetet i Oslo", "UiT Norges arktiske universitet", "NTNU" og "Høgskulen på Vestlandet" deltar i opptaket
    Og at opptaket har en standard tildelingsregel med «Alle som deltar i opptaket»

  Regel: Opptaksforvalteren ved forvaltende organisasjon setter opp tildelingsreglene for opptaket

    Scenario: Opprette tildelingsregel
      Når opptaksforvalteren ved HK-dir oppretter en tildelingsregel med følgende opplysninger
        | felt                      | verdi                    |
        | Kode                      | JOU                      |
        | Beskrivelse               | Journalistutdanning      |
        | Hvem skal saksbehandle    | Tilbydere i samme sektor |
        | Aktiv                     | Ja                       |
      Så finnes tildelingsregelen "JOU" i opptaket

    Scenario: Nytt opptak får standard tildelingsregel med «Alle som deltar i opptaket»
      Når opptaksforvalteren ved HK-dir oppretter et nytt opptak
      Så har opptaket en aktiv standard tildelingsregel med «Alle som deltar i opptaket»

    Scenario: Bytte standard tildelingsregel
      Når opptaksforvalteren ved HK-dir velger "UVH" som standard tildelingsregel for opptaket
      Så fordeles søknadsalternativer til utdanningstilbud uten egen tildelingsregel etter "UVH"

    Scenario: Opptaket kan bare ha én aktiv tildelingsregel med «Alle som deltar i opptaket»
      Gitt at opptaket har en aktiv tildelingsregel med «Alle som deltar i opptaket»
      Når opptaksforvalteren ved HK-dir oppretter en ny aktiv tildelingsregel med «Alle som deltar i opptaket»
      Så avvises tildelingsregelen

    Scenario: Se hvilke utdanningstilbud som er knyttet til tildelingsregelen
      Gitt at 12 utdanningstilbud er knyttet til tildelingsregelen "JOU"
      Når opptaksforvalteren ved HK-dir åpner tildelingsregelen "JOU"
      Så ser opptaksforvalteren at "JOU" er knyttet til 12 utdanningstilbud
      Og opptaksforvalteren kan se utdanningstilbudene som er knyttet til "JOU"

    Scenario: Slette tildelingsregel som ikke er knyttet til utdanningstilbud
      Gitt at ingen utdanningstilbud er knyttet til tildelingsregelen "JOU"
      Når opptaksforvalteren ved HK-dir sletter tildelingsregelen "JOU"
      Så finnes ikke tildelingsregelen "JOU" i opptaket

    Scenario: Tildelingsregel som er knyttet til utdanningstilbud kan ikke slettes
      Gitt at utdanningstilbud er knyttet til tildelingsregelen "JOU"
      Når opptaksforvalteren ved HK-dir åpner tildelingsregelen "JOU"
      Så ser ikke opptaksforvalteren muligheten til å slette "JOU"

    Scenariomal: Tildelingsregel som <bruk> kan ikke deaktiveres
      Gitt at tildelingsregelen "SPE" <bruk>
      Når opptaksforvalteren ved HK-dir deaktiverer tildelingsregelen "SPE"
      Så avvises endringen

      Eksempler:
        | bruk                                |
        | er standard i opptaket              |
        | er knyttet til utdanningstilbud     |

    Scenario: Tildelingsreglene er ikke tilgjengelige i lokale opptak
      Gitt at opptaket "Lokalt opptak høst 2027" er opprettet som lokalt
      Når opptaksforvalteren åpner opptaket "Lokalt opptak høst 2027"
      Så ser ikke opptaksforvalteren tildelingsreglene for opptaket

    Scenario: Deltakende lærested kan ikke endre tildelingsreglene
      Når opptaksforvalteren ved Universitetet i Oslo åpner tildelingsreglene for opptaket
      Så ser ikke opptaksforvalteren muligheten til å opprette, endre eller slette tildelingsregler

  # Lærestedets valg av tildelingsregel per utdanningstilbud står i opptaksinnstillinger_utdanningstilbud.feature (@OPT-OPT-UTD-004).

  Regel: Ved «Alle som deltar i opptaket» saksbehandler lærestedet søkeren har prioritert høyest

    Scenario: Lærestedet på første prioritet saksbehandler hele søknaden
      Gitt at søkeren har en utdanningsbakgrunn uten unntak på standard tildelingsregel
      Og at søkeren har søkt "Informatikk, UiO", "Historie, UiT" og "Sykepleie, NTNU" i den rekkefølgen
      Og at ingen av utdanningstilbudene har egen tildelingsregel
      Når søknadsalternativene fordeles
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for alle søknadsalternativene

    Scenario: Søknadsalternativ med egen tildelingsregel avgjør ikke hvem som saksbehandler resten av søknaden
      Gitt at "Utøvende musikk, NTNU" har tildelingsregelen "UVH"
      Og at søkeren har søkt "Utøvende musikk, NTNU", "Historie, UiT" og "Informatikk, UiO" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "NTNU" saksbehandlende organisasjon for "Utøvende musikk, NTNU"
      Og "UiT Norges arktiske universitet" er saksbehandlende organisasjon for "Historie, UiT" og "Informatikk, UiO"

  Regel: Ved «Bare tilbyderen – også for studieønsker uten egen regel» saksbehandler tilbyderen også søknadsalternativene uten egen tildelingsregel

    Scenario: Tilbyderen saksbehandler søknadsalternativene uten egen tildelingsregel
      Gitt at "Utøvende musikk, NTNU" har tildelingsregelen "SPE"
      Og at søkeren har søkt "Informatikk, UiO" og "Utøvende musikk, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "NTNU" saksbehandlende organisasjon for begge søknadsalternativene

    Scenario: Tilbyderen søkeren har prioritert høyest saksbehandler søknadsalternativene uten egen tildelingsregel
      Gitt at "Utøvende musikk, NTNU" og "Musikkpedagogikk, HVL" har tildelingsregelen "SPE"
      Og at søkeren har søkt "Informatikk, UiO", "Musikkpedagogikk, HVL" og "Utøvende musikk, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "Høgskulen på Vestlandet" saksbehandlende organisasjon for "Musikkpedagogikk, HVL" og "Informatikk, UiO"
      Og "NTNU" er saksbehandlende organisasjon for "Utøvende musikk, NTNU"

  Regel: Ved «Bare tilbyderen – bare dette studieønsket» saksbehandler tilbyderen bare søknadsalternativet med tildelingsregelen

    Scenario: Tilbyderen saksbehandler ikke søkerens andre søknadsalternativer
      Gitt at "Utøvende musikk, NTNU" har tildelingsregelen "UVH"
      Og at søkeren har søkt "Utøvende musikk, NTNU" og "Informatikk, UiO" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "NTNU" saksbehandlende organisasjon for "Utøvende musikk, NTNU"
      Og "Universitetet i Oslo" er saksbehandlende organisasjon for "Informatikk, UiO"

    Scenario: Hver tilbyder saksbehandler sitt eget søknadsalternativ når standardregelen gjelder bare søknadsalternativet
      Gitt at opptaket "Fagskoleopptak 2027" har en standard tildelingsregel med «Bare tilbyderen – bare dette studieønsket»
      Og at søkeren har søkt "Elektrofag, Fagskolen Innlandet" og "Helsefag, Fagskolen i Viken" i "Fagskoleopptak 2027"
      Når søknadsalternativene fordeles
      Så er "Fagskolen Innlandet" saksbehandlende organisasjon for "Elektrofag, Fagskolen Innlandet"
      Og "Fagskolen i Viken" er saksbehandlende organisasjon for "Helsefag, Fagskolen i Viken"

  Regel: Ved «Tilbydere i samme sektor» saksbehandler én organisasjon alle søknadsalternativene i sektoren

    Scenario: Tilbyderen søkeren har prioritert høyest i sektoren saksbehandler hele sektoren
      Gitt at "Journalistikk, HVL" og "Journalistikk, UiT" har tildelingsregelen "JOU"
      Og at søkeren har søkt "Informatikk, UiO", "Journalistikk, HVL" og "Journalistikk, UiT" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "Høgskulen på Vestlandet" saksbehandlende organisasjon for alle søknadsalternativene

    Scenario: Organisasjonen som er valgt på tildelingsregelen saksbehandler hele sektoren
      Gitt at "Journalistikk, HVL" og "Journalistikk, UiT" har tildelingsregelen "JOU"
      Og at "UiT Norges arktiske universitet" er valgt som organisasjon på "JOU"
      Og at søkeren har søkt "Journalistikk, HVL" og "Journalistikk, UiT" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "UiT Norges arktiske universitet" saksbehandlende organisasjon for begge søknadsalternativene

    Scenario: Søknadsalternativer i ulike sektorer fordeles hver for seg
      Gitt at "Paramedisin, NTNU" har tildelingsregelen "PAP"
      Og at "Journalistikk, HVL" har tildelingsregelen "JOU"
      Og at søkeren har søkt "Paramedisin, NTNU", "Journalistikk, HVL" og "Informatikk, UiO" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "NTNU" saksbehandlende organisasjon for "Paramedisin, NTNU" og "Informatikk, UiO"
      Og "Høgskulen på Vestlandet" er saksbehandlende organisasjon for "Journalistikk, HVL"

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Avklares med domeneekspert: Skal en sektor være avgrenset til bestemte organisasjoner,
    #   eller er sektoren bare utdanningstilbudene som har samme tildelingsregel (slik det er
    #   bygget, og slik HK-dirs wiki beskriver det: «Alle T-rollene som tilbyr et slikt studium,
    #   kan behandle for det samme»)?
    Scenario: Sektoren består av utdanningstilbudene med samme tildelingsregel
      Gitt at "Journalistikk, HVL" og "Journalistikk, UiT" har tildelingsregelen "JOU"
      Når opptaksforvalteren ved NTNU velger tildelingsregelen "JOU" for "Journalistikk, NTNU"
      Så er "Journalistikk, NTNU" med i sektoren for "JOU"

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Avklares med domeneekspert: Skal «Bare tilbyderen – også for studieønsker uten egen regel»
    #   gå foran sektoren uansett søkerens prioritering (slik det er bygget), eller skal søkerens
    #   prioritet avgjøre hvem som saksbehandler søknadsalternativene uten egen tildelingsregel?
    #   HK-dirs wiki sier ikke hva som gjelder når søkeren har både SPE og JOU.
    Scenario: Tildelingsregel der bare tilbyderen saksbehandler går foran sektoren
      Gitt at "Journalistikk, HVL" har tildelingsregelen "JOU"
      Og at "Utøvende musikk, NTNU" har tildelingsregelen "SPE"
      Og at søkeren har søkt "Journalistikk, HVL", "Utøvende musikk, NTNU" og "Informatikk, UiO" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "NTNU" saksbehandlende organisasjon for "Utøvende musikk, NTNU" og "Informatikk, UiO"
      Og "Høgskulen på Vestlandet" er saksbehandlende organisasjon for "Journalistikk, HVL"

    Scenariomal: Opptaksforvalteren kan velge <organisasjon> som organisasjon for sektoren
      Når opptaksforvalteren ved HK-dir velger "<organisasjon>" som organisasjon på "JOU"
      Så saksbehandler "<organisasjon>" søknadsalternativene med tildelingsregelen "JOU"

      Eksempler:
        | organisasjon                    |
        | UiT Norges arktiske universitet |
        | HK-dir                          |

    Scenario: Organisasjonen for sektoren må delta i opptaket
      Gitt at "Universitetet i Bergen" ikke deltar i opptaket
      Når opptaksforvalteren ved HK-dir velger organisasjon på "JOU"
      Så ser ikke opptaksforvalteren "Universitetet i Bergen" blant valgene

  Regel: Unntak for utdanningsbakgrunn og ledige studieplasser overstyrer tildelingsregelen

    Scenario: Legge til unntak for utdanningsbakgrunn
      Når opptaksforvalteren ved HK-dir legger til følgende unntak på tildelingsregelen "JOU"
        | utdanningsbakgrunn  | fordeles til |
        | Realkompetanse      | Tilbyder     |
        | Utenlandsk          | HK-dir       |
        | Rudolf Steinerskole | HK-dir       |
      Så gjelder unntakene for søknadsalternativene med tildelingsregelen "JOU"

    Scenariomal: HK-dir saksbehandler hele søknaden når søkeren har utdanningsbakgrunn <utdanningsbakgrunn>
      Gitt at tildelingsreglene har unntak som fordeler "<utdanningsbakgrunn>" til HK-dir
      Og at søkeren har utdanningsbakgrunn "<utdanningsbakgrunn>"
      Og at søkeren har søkt "Informatikk, UiO", "Historie, UiT" og "Sykepleie, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "HK-dir" saksbehandlende organisasjon for alle søknadsalternativene

      Eksempler:
        | utdanningsbakgrunn  |
        | Utenlandsk          |
        | Rudolf Steinerskole |

    Scenario: Hver tilbyder saksbehandler sitt eget søknadsalternativ når søkeren har realkompetanse
      Gitt at tildelingsreglene har unntak som fordeler "Realkompetanse" til tilbyder
      Og at søkeren har utdanningsbakgrunn "Realkompetanse"
      Og at søkeren har søkt "Informatikk, UiO", "Historie, UiT" og "Sykepleie, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Informatikk, UiO"
      Og "UiT Norges arktiske universitet" er saksbehandlende organisasjon for "Historie, UiT"
      Og "NTNU" er saksbehandlende organisasjon for "Sykepleie, NTNU"

    Scenario: Unntaket går foran tildelingsregel der bare tilbyderen saksbehandler
      Gitt at "Utøvende musikk, NTNU" har tildelingsregelen "SPE"
      Og at "SPE" har unntak som fordeler "Utenlandsk" til HK-dir
      Og at søkeren har utdanningsbakgrunn "Utenlandsk"
      Og at søkeren har søkt "Informatikk, UiO" og "Utøvende musikk, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "HK-dir" saksbehandlende organisasjon for begge søknadsalternativene

    Scenario: Tildelingsregel uten unntak for søkerens utdanningsbakgrunn følges som vanlig
      Gitt at "Utøvende musikk, NTNU" har tildelingsregelen "UVH" uten unntak
      Og at søkeren har utdanningsbakgrunn "Utenlandsk"
      Og at søkeren har søkt "Informatikk, UiO" og "Utøvende musikk, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "NTNU" saksbehandlende organisasjon for "Utøvende musikk, NTNU"
      Og "HK-dir" er saksbehandlende organisasjon for "Informatikk, UiO"

    Scenario: Tilbyderen saksbehandler søknadsalternativ til ledig studieplass
      Gitt at "Ledige studieplasser fordeles til tilbyder" er valgt på tildelingsregelen til "Informatikk, UiO"
      Og at "Informatikk, UiO" tilbyr ledige studieplasser
      Og at ledige studieplasser i opptaket har åpnet
      Når søkeren søker ledig studieplass på "Informatikk, UiO"
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Informatikk, UiO"

    Scenario: Ledig studieplass går foran unntak for utdanningsbakgrunn
      Gitt at "Ledige studieplasser fordeles til tilbyder" er valgt på tildelingsregelen til "Informatikk, UiO"
      Og at ledige studieplasser i opptaket har åpnet
      Og at søkeren har utdanningsbakgrunn "Utenlandsk"
      Når søkeren søker ledig studieplass på "Informatikk, UiO"
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Informatikk, UiO"

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Avklares med domeneekspert: HK-dirs wiki sier at tilbyderen alltid saksbehandler søknad
    #   om ledig studieplass (UHG og FSU). Designet og koden har likevel avkrysningen «Ledige
    #   studieplasser fordeles til tilbyder» per tildelingsregel. Skal det være et valg, eller
    #   alltid gjelde? Gjelder det alltid, erstatter dette scenarioet de to over.
    # - Avklares med domeneekspert: Gjelder det fortsatt etter at perioden for ledige studieplasser
    #   er stengt, for eksempel når saksbehandleren legger til søknadsalternativet på vegne av
    #   søkeren? I dag: ja, koden ser bare på om ledige studieplasser har åpnet. Har opptaket
    #   ingen dato for ledige studieplasser, gjelder det aldri.
    Scenario: Tilbyderen saksbehandler alltid søknadsalternativ til ledig studieplass
      Gitt at "Informatikk, UiO" tilbyr ledige studieplasser
      Og at ledige studieplasser i opptaket har åpnet
      Når søkeren søker ledig studieplass på "Informatikk, UiO"
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Informatikk, UiO"

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Hvor i FS Admin velger opptaksforvalteren at et lærested saksbehandles av en annen
  #   organisasjon? Valget finnes i API-et, men ikke i designet.
  Regel: Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket

    Scenario: Organisasjonen som saksbehandler på vegne av lærestedet får søknadsalternativene
      Gitt at "Arkitektur- og designhøgskolen i Oslo" og "OsloMet" deltar i opptaket
      Og at "OsloMet" saksbehandler på vegne av "Arkitektur- og designhøgskolen i Oslo"
      Og at søkeren har søkt "Arkitektur, AHO"
      Når søknadsalternativene fordeles
      Så er "OsloMet" saksbehandlende organisasjon for "Arkitektur, AHO"

    Scenario: Organisasjonen som saksbehandler på vegne av lærestedet må delta i opptaket
      Gitt at "Universitetet i Bergen" ikke deltar i opptaket
      Når opptaksforvalteren ved HK-dir velger "Universitetet i Bergen" til å saksbehandle på vegne av "Arkitektur- og designhøgskolen i Oslo"
      Så avvises valget

    Scenario: Endret valg gjelder bare søknadsalternativer som ikke er fordelt
      Gitt at "Arkitektur, AHO" er fordelt til "Arkitektur- og designhøgskolen i Oslo"
      Når opptaksforvalteren ved HK-dir velger "OsloMet" til å saksbehandle på vegne av "Arkitektur- og designhøgskolen i Oslo"
      Så er "Arkitektur- og designhøgskolen i Oslo" fortsatt saksbehandlende organisasjon for "Arkitektur, AHO"

  Regel: Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast

    Scenariomal: Søknadsalternativene fordeles når <hendelse>
      Når <hendelse>
      Så fordeles søknadsalternativene som ikke har saksbehandlende organisasjon

      Eksempler:
        | hendelse                                                          |
        | søkeren sender inn søknaden                                       |
        | søkeren endrer søknaden                                           |
        | saksbehandleren legger til et søknadsalternativ på vegne av søkeren |

    Scenario: Søknaden får én sak per saksbehandlende organisasjon
      Gitt at søkerens søknadsalternativer fordeles til "NTNU" og "Universitetet i Oslo"
      Når søknadsalternativene er fordelt
      Så har søknaden én sak hos "NTNU" og én sak hos "Universitetet i Oslo"

    Scenario: Tilbyder som ikke er saksbehandlende organisasjon får ingen sak
      Gitt at søkeren har søkt "Informatikk, UiO" og "Sykepleie, NTNU"
      Og at begge søknadsalternativene er fordelt til "Universitetet i Oslo"
      Så har ikke "NTNU" noen sak for søknaden

    Scenario: Ny prioritering endrer ikke saksbehandlende organisasjon
      Gitt at søkeren har søkt "Informatikk, UiO" og "Historie, UiT" i den rekkefølgen
      Og at begge søknadsalternativene er fordelt til "Universitetet i Oslo"
      Når søkeren prioriterer "Historie, UiT" foran "Informatikk, UiO"
      Så er "Universitetet i Oslo" fortsatt saksbehandlende organisasjon for begge søknadsalternativene

    Scenario: Nytt søknadsalternativ uten egen tildelingsregel får samme saksbehandlende organisasjon som før
      Gitt at søkeren har søkt "Informatikk, UiO", og søknadsalternativet er fordelt til "Universitetet i Oslo"
      Når søkeren legger til "Sykepleie, NTNU" som første prioritet
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Sykepleie, NTNU"

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Avklares med domeneekspert: HK-dirs wiki sier at når søkeren legger til et studium med
    #   SPE, JOU, TRA eller PAP, skal også søknadsalternativene som allerede er fordelt, få ny
    #   saksbehandlende organisasjon. I dag får bare det nye søknadsalternativet ny organisasjon.
    #   Prinsippene «færrest mulig saksbehandlende organisasjoner» og «færrest mulig endringer»
    #   trekker hver sin vei. Hva skal gjelde?
    Scenario: Nytt søknadsalternativ der bare tilbyderen saksbehandler endrer ikke søknadsalternativene som er fordelt
      Gitt at søkeren har søkt "Informatikk, UiO", og søknadsalternativet er fordelt til "Universitetet i Oslo"
      Når søkeren legger til "Utøvende musikk, NTNU" med tildelingsregelen "SPE"
      Så er "NTNU" saksbehandlende organisasjon for "Utøvende musikk, NTNU"
      Og "Universitetet i Oslo" er fortsatt saksbehandlende organisasjon for "Informatikk, UiO"

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Avklares med domeneekspert, sammen med spørsmålet over: HK-dirs wiki sier at når søkeren
    #   sletter søknadsalternativet med SPE eller JOU som fordelingen bygget på, skal de andre
    #   søknadsalternativene få ny saksbehandlende organisasjon. I dag beholder de organisasjonen,
    #   også når søkeren ikke lenger har søkt noe hos den. Hva skal gjelde?
    Scenario: Sletting av søknadsalternativet fordelingen bygget på endrer ikke de andre søknadsalternativene
      Gitt at søkeren har søkt "Utøvende musikk, NTNU" med tildelingsregelen "SPE" og "Informatikk, UiO"
      Og at begge søknadsalternativene er fordelt til "NTNU"
      Når søkeren sletter "Utøvende musikk, NTNU"
      Så er "NTNU" fortsatt saksbehandlende organisasjon for "Informatikk, UiO"

  Regel: Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak

    Scenario: Søkeren bytter til utenlandsk utdanningsbakgrunn
      Gitt at søkerens søknadsalternativer er fordelt til "Universitetet i Oslo"
      Når søkeren endrer utdanningsbakgrunn til "Utenlandsk"
      Så er "HK-dir" saksbehandlende organisasjon for alle søknadsalternativene

    Scenario: Søkeren bytter til realkompetanse
      Gitt at søkeren har søkt "Informatikk, UiO" og "Historie, UiT"
      Og at begge søknadsalternativene er fordelt til "Universitetet i Oslo"
      Når søkeren endrer utdanningsbakgrunn til "Realkompetanse"
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Informatikk, UiO"
      Og "UiT Norges arktiske universitet" er saksbehandlende organisasjon for "Historie, UiT"

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Avklares med domeneekspert, sammen med de to spørsmålene om å legge til og slette
    #   søknadsalternativer: HK-dirs wiki sier at bytte fra realkompetanse til norsk, nordisk,
    #   utenlandsk, IB eller steinerskole skal fordele søknadsalternativene på nytt. I dag flytter
    #   bare bytte til en bakgrunn med unntak. Det samme gjelder bytte fra utenlandsk til norsk:
    #   HK-dir beholder saken. Hva skal gjelde?
    Scenario: Bytte fra realkompetanse til norsk utdanningsbakgrunn flytter ingen søknadsalternativer
      Gitt at søkeren har utdanningsbakgrunn "Realkompetanse"
      Og at "Universitetet i Oslo" og "UiT Norges arktiske universitet" saksbehandler hvert sitt søknadsalternativ
      Når søkeren endrer utdanningsbakgrunn til "Norsk"
      Så er saksbehandlende organisasjon uendret for alle søknadsalternativene

    Scenariomal: Saksbehandleren endrer utdanningsbakgrunnen til <utdanningsbakgrunn>
      Gitt at søkeren har søkt "Informatikk, UiO" og "Historie, UiT"
      Og at begge søknadsalternativene er fordelt til "Universitetet i Oslo"
      Når saksbehandleren ved Universitetet i Oslo endrer søkerens utdanningsbakgrunn til "<utdanningsbakgrunn>"
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Informatikk, UiO"
      Og "UiT Norges arktiske universitet" er saksbehandlende organisasjon for "Historie, UiT"

      Eksempler:
        | utdanningsbakgrunn |
        | Realkompetanse     |
        | Dispensasjon       |

    Scenariomal: Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen <frist>
      Gitt at fristen for selvbetjent endring av utdanningsbakgrunn <frist>
      Og at søkerens søknadsalternativer er fordelt til "Universitetet i Oslo"
      Når saksbehandleren ved Universitetet i Oslo endrer søkerens utdanningsbakgrunn til "Utenlandsk"
      Så er <organisasjon> saksbehandlende organisasjon for alle søknadsalternativene

      Eksempler:
        | frist             | organisasjon           |
        | ikke har gått ut  | "HK-dir"               |
        | har gått ut       | "Universitetet i Oslo" |

    Scenario: Opptaksforvalteren ved forvaltende organisasjon er ikke bundet av fristen
      Gitt at fristen for selvbetjent endring av utdanningsbakgrunn har gått ut
      Og at søkerens søknadsalternativer er fordelt til "Universitetet i Oslo"
      Når opptaksforvalteren ved HK-dir endrer søkerens utdanningsbakgrunn til "Utenlandsk"
      Så er "HK-dir" saksbehandlende organisasjon for alle søknadsalternativene

    Scenario: Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til
      Gitt at "Informatikk, UiO" har tilbudsgaranti
      Når "Informatikk, UiO" flyttes fra "Universitetet i Oslo" til "HK-dir"
      Så starter saksbehandlingen av "Informatikk, UiO" på nytt hos "HK-dir"
      Og "Informatikk, UiO" har fortsatt tilbudsgaranti

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Avklares med domeneekspert: Workshoprapporten (29.05.2026) foreslår at en flyttet sak får
    #   status «Overført», og at dokumentene merkes som uleste hos den nye organisasjonen.
    #   Statusen skifter til «Under behandling» ved første endring. Ikke bygget. Skal det med,
    #   og hører det i så fall hjemme her eller i et eget krav om endring av B-rolle sammen med
    #   de andre behovene fra workshopen (merknader, batch-flytting)?
    Scenario: Flyttet søknadsalternativ vises som overført hos organisasjonen det flyttes til
      Når "Informatikk, UiO" flyttes fra "Universitetet i Oslo" til "HK-dir"
      Så har saken hos "HK-dir" status «Overført»
      Og dokumentene i saken er merket som uleste hos "HK-dir"

  Regel: Saksbehandlende organisasjon ser bare saker hos organisasjonen

    Scenario: Saksbehandleren ser bare saken hos organisasjonen sin
      Gitt at søknaden har saker hos "Universitetet i Oslo" og "UiT Norges arktiske universitet"
      Når saksbehandleren ved Universitetet i Oslo åpner søknaden
      Så ser saksbehandleren bare saken hos "Universitetet i Oslo"

    Scenario: Søkeren ser saksbehandlende organisasjon, men ikke sakene
      Gitt at søknaden har saker hos "Universitetet i Oslo" og "UiT Norges arktiske universitet"
      Når søkeren ser søknaden sin
      Så ser søkeren saksbehandlende organisasjon for hvert søknadsalternativ
      Men søkeren ser ikke sakene

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Avklares med domeneekspert: Skal tilbyderen se søknadsalternativene til utdanningstilbudene
    #   sine når en annen organisasjon saksbehandler dem, og i så fall hva skal tilbyderen se og
    #   gjøre? Tilbyderen setter tilbudsgaranti (STEK-339), søkeren skal i noen tilfeller kontakte
    #   tilbyderen (HK-dirs wiki), og samordnet_opptak.feature sier at saksbehandlere kan se info
    #   om utdanningstilbudene sine.
    # - Avklares med domeneekspert, sammen med tilgangsstyringen: Skal opptaksforvalteren ved
    #   forvaltende organisasjon se alle sakene i opptaket? Forvalteren kan endre utdanningsbakgrunn
    #   uten frist og uten egen sak, men ser i dag bare saker hos organisasjonen sin.
    Scenario: Tilbyderen ser søknadsalternativ som en annen organisasjon saksbehandler
      Gitt at "Historie, UiT" er fordelt til "Universitetet i Oslo"
      Når saksbehandleren ved UiT Norges arktiske universitet ser søknadsalternativene til utdanningstilbudene ved UiT
      Så ser saksbehandleren "Historie, UiT"
