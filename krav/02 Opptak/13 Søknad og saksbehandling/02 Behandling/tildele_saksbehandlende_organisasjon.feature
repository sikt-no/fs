# language: no
# GitHub: #207
@OPT-BEH-BEH-011 @must @implemented
Egenskap: Tildele saksbehandlende organisasjon
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å bestemme hvilken organisasjon som saksbehandler hvert søknadsalternativ
  slik at søkeren får færrest mulig saksbehandlende organisasjoner og søknaden behandles i samsvar med regelverket.

  I et samordna opptak søker søkeren på utdanningstilbud ved flere læresteder i én søknad.
  Hvert søknadsalternativ må saksbehandles av én organisasjon, som vurderer dokumentasjonen,
  setter grunnlaget og regner ut poengene. Som hovedregel saksbehandler lærestedet søkeren har
  prioritert høyest hele søknaden, også studiene ved de andre lærestedene. Da har søkeren én
  organisasjon å forholde seg til. Noen studier må likevel saksbehandles av lærestedet som tilbyr
  dem, for eksempel studier med opptaksprøve. Noen søkere må saksbehandles av HK-dir, for eksempel
  søkere med utenlandsk utdanning.

  Løsningen fordeler derfor hvert søknadsalternativ til en saksbehandlende organisasjon etter
  behandlertildelingsregler som opptaksforvalteren setter opp. Søknaden blir til én sak hos hver
  saksbehandlende organisasjon. Det er organisasjonen som har ansvaret, ikke en enkelt
  saksbehandler, og det er organisasjonen som får tilgang til saken.

  Kravet har fire deler:
  1. Oppsett – opptaksforvalteren setter opp behandlertildelingsreglene for opptaket.
  2. Fordeling – hvordan hver fordeling og hvert unntak avgjør hvem som saksbehandler.
  3. Endring – når fordelingen ligger fast, og når søknadsalternativer flyttes.
  4. Innsyn – hvem som ser sakene.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at "Universitetet i Oslo", "UiT Norges arktiske universitet", "NTNU" og "Høgskulen på Vestlandet" deltar i opptaket
    Og at opptaket har en standard behandlertildelingsregel med «Alle som deltar i opptaket»

  # ── 1. Oppsett ───────────────────────────────────────────────

  @ref-OPT-OPT-UTD-004 @ref-FLY-OPT-SAK-001
  Regel: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket
    # Lærestedets valg av behandlertildelingsregel per utdanningstilbud står der.

    Scenario: Opprette behandlertildelingsregel
      Når opptaksforvalteren ved HK-dir oppretter en behandlertildelingsregel med følgende opplysninger
        | felt                      | verdi                    |
        | Kode                      | JOU                      |
        | Beskrivelse               | Journalistutdanning      |
        | Hvem skal saksbehandle    | Tilbydere i samme sektor |
        | Aktiv                     | Ja                       |
      Så finnes behandlertildelingsregelen "JOU" i opptaket

    Scenario: Nytt opptak får standard behandlertildelingsregel med «Alle som deltar i opptaket»
      Når opptaksforvalteren ved HK-dir oppretter et nytt opptak
      Så har opptaket en aktiv standard behandlertildelingsregel med «Alle som deltar i opptaket»

    Scenario: Bytte standard behandlertildelingsregel
      Når opptaksforvalteren ved HK-dir velger "UVH" som standard behandlertildelingsregel for opptaket
      Så fordeles søknadsalternativer til utdanningstilbud uten egen behandlertildelingsregel etter "UVH"

    Scenario: Opptaket kan bare ha én aktiv behandlertildelingsregel med «Alle som deltar i opptaket»
      Gitt at opptaket har en aktiv behandlertildelingsregel med «Alle som deltar i opptaket»
      Når opptaksforvalteren ved HK-dir oppretter en ny aktiv behandlertildelingsregel med «Alle som deltar i opptaket»
      Så avvises behandlertildelingsregelen

    Scenario: Se hvilke utdanningstilbud som er knyttet til behandlertildelingsregelen
      Gitt at 12 utdanningstilbud er knyttet til behandlertildelingsregelen "JOU"
      Når opptaksforvalteren ved HK-dir åpner behandlertildelingsregelen "JOU"
      Så ser opptaksforvalteren at "JOU" er knyttet til 12 utdanningstilbud
      Og opptaksforvalteren kan se utdanningstilbudene som er knyttet til "JOU"

    Scenario: Slette behandlertildelingsregel som ikke er knyttet til utdanningstilbud
      Gitt at ingen utdanningstilbud er knyttet til behandlertildelingsregelen "JOU"
      Når opptaksforvalteren ved HK-dir sletter behandlertildelingsregelen "JOU"
      Så finnes ikke behandlertildelingsregelen "JOU" i opptaket

    Scenario: Behandlertildelingsregel som er knyttet til utdanningstilbud kan ikke slettes
      Gitt at utdanningstilbud er knyttet til behandlertildelingsregelen "JOU"
      Når opptaksforvalteren ved HK-dir åpner behandlertildelingsregelen "JOU"
      Så ser ikke opptaksforvalteren muligheten til å slette "JOU"

    Scenariomal: Behandlertildelingsregel som <bruk> kan ikke deaktiveres
      Gitt at behandlertildelingsregelen "SPE" <bruk>
      Når opptaksforvalteren ved HK-dir deaktiverer behandlertildelingsregelen "SPE"
      Så avvises endringen

      Eksempler:
        | bruk                                |
        | er standard i opptaket              |
        | er knyttet til utdanningstilbud     |

    Scenario: Behandlertildelingsreglene er ikke tilgjengelige i lokale opptak
      Gitt at opptaket "Lokalt opptak høst 2027" er opprettet som lokalt
      Når opptaksforvalteren åpner opptaket "Lokalt opptak høst 2027"
      Så ser ikke opptaksforvalteren behandlertildelingsreglene for opptaket

    Scenario: Deltakende lærested kan ikke endre behandlertildelingsreglene
      Når opptaksforvalteren ved Universitetet i Oslo åpner behandlertildelingsreglene for opptaket
      Så ser ikke opptaksforvalteren muligheten til å opprette, endre eller slette behandlertildelingsregler

  # ── 2. Fordeling ─────────────────────────────────────────────

  Regel: Ved «Alle som deltar i opptaket» saksbehandler lærestedet søkeren har prioritert høyest

    Scenario: Lærestedet på første prioritet saksbehandler hele søknaden
      Gitt at søkeren har en utdanningsbakgrunn uten unntak på standard behandlertildelingsregel
      Og at søkeren har søkt "Informatikk, UiO", "Historie, UiT" og "Sykepleie, NTNU" i den rekkefølgen
      Og at ingen av utdanningstilbudene har egen behandlertildelingsregel
      Når søknadsalternativene fordeles
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for alle søknadsalternativene

    Scenario: Søknadsalternativ med egen behandlertildelingsregel avgjør ikke hvem som saksbehandler resten av søknaden
      Gitt at "Utøvende musikk, NTNU" har behandlertildelingsregelen "UVH"
      Og at søkeren har søkt "Utøvende musikk, NTNU", "Historie, UiT" og "Informatikk, UiO" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "NTNU" saksbehandlende organisasjon for "Utøvende musikk, NTNU"
      Og "UiT Norges arktiske universitet" er saksbehandlende organisasjon for "Historie, UiT" og "Informatikk, UiO"

  Regel: Ved «Bare tilbyderen – også for studieønsker uten egen regel» saksbehandler tilbyderen også søknadsalternativene uten egen behandlertildelingsregel

    Scenario: Tilbyderen saksbehandler søknadsalternativene uten egen behandlertildelingsregel
      Gitt at "Utøvende musikk, NTNU" har behandlertildelingsregelen "SPE"
      Og at søkeren har søkt "Informatikk, UiO" og "Utøvende musikk, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "NTNU" saksbehandlende organisasjon for begge søknadsalternativene

    Scenario: Tilbyderen søkeren har prioritert høyest saksbehandler søknadsalternativene uten egen behandlertildelingsregel
      Gitt at "Utøvende musikk, NTNU" og "Musikkpedagogikk, HVL" har behandlertildelingsregelen "SPE"
      Og at søkeren har søkt "Informatikk, UiO", "Musikkpedagogikk, HVL" og "Utøvende musikk, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "Høgskulen på Vestlandet" saksbehandlende organisasjon for "Musikkpedagogikk, HVL" og "Informatikk, UiO"
      Og "NTNU" er saksbehandlende organisasjon for "Utøvende musikk, NTNU"

  Regel: Ved «Bare tilbyderen – bare dette studieønsket» saksbehandler tilbyderen bare søknadsalternativet med behandlertildelingsregelen

    Scenario: Tilbyderen saksbehandler ikke søkerens andre søknadsalternativer
      Gitt at "Utøvende musikk, NTNU" har behandlertildelingsregelen "UVH"
      Og at søkeren har søkt "Utøvende musikk, NTNU" og "Informatikk, UiO" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "NTNU" saksbehandlende organisasjon for "Utøvende musikk, NTNU"
      Og "Universitetet i Oslo" er saksbehandlende organisasjon for "Informatikk, UiO"

    Scenario: Hver tilbyder saksbehandler sitt eget søknadsalternativ når standardregelen gjelder bare søknadsalternativet
      Gitt at opptaket "Fagskoleopptak 2027" har en standard behandlertildelingsregel med «Bare tilbyderen – bare dette studieønsket»
      Og at søkeren har søkt "Elektrofag, Fagskolen Innlandet" og "Helsefag, Fagskolen i Viken" i "Fagskoleopptak 2027"
      Når søknadsalternativene fordeles
      Så er "Fagskolen Innlandet" saksbehandlende organisasjon for "Elektrofag, Fagskolen Innlandet"
      Og "Fagskolen i Viken" er saksbehandlende organisasjon for "Helsefag, Fagskolen i Viken"

  Regel: Ved «Tilbydere i samme sektor» saksbehandler én organisasjon alle søknadsalternativene i sektoren

    Scenario: Tilbyderen søkeren har prioritert høyest i sektoren saksbehandler hele sektoren
      Gitt at "Journalistikk, HVL" og "Journalistikk, UiT" har behandlertildelingsregelen "JOU"
      Og at søkeren har søkt "Informatikk, UiO", "Journalistikk, HVL" og "Journalistikk, UiT" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "Høgskulen på Vestlandet" saksbehandlende organisasjon for alle søknadsalternativene

    Scenario: Organisasjonen som er valgt på behandlertildelingsregelen saksbehandler hele sektoren
      Gitt at "Journalistikk, HVL" og "Journalistikk, UiT" har behandlertildelingsregelen "JOU"
      Og at "UiT Norges arktiske universitet" er valgt som organisasjon på "JOU"
      Og at søkeren har søkt "Journalistikk, HVL" og "Journalistikk, UiT" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "UiT Norges arktiske universitet" saksbehandlende organisasjon for begge søknadsalternativene

    Scenario: Søknadsalternativer i ulike sektorer fordeles hver for seg
      Gitt at "Paramedisin, NTNU" har behandlertildelingsregelen "PAP"
      Og at "Journalistikk, HVL" har behandlertildelingsregelen "JOU"
      Og at søkeren har søkt "Paramedisin, NTNU", "Journalistikk, HVL" og "Informatikk, UiO" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "NTNU" saksbehandlende organisasjon for "Paramedisin, NTNU" og "Informatikk, UiO"
      Og "Høgskulen på Vestlandet" er saksbehandlende organisasjon for "Journalistikk, HVL"

    Scenario: Sektoren er lærestedene som har utdanningstilbud med samme behandlertildelingsregel
      Gitt at "Journalistikk, HVL" og "Journalistikk, UiT" har behandlertildelingsregelen "JOU"
      Når opptaksforvalteren ved NTNU velger behandlertildelingsregelen "JOU" for "Journalistikk, NTNU"
      Så er "NTNU" med i sektoren for "JOU"

    Scenario: Søkerens prioritering avgjør hvem som saksbehandler søknadsalternativene uten egen behandlertildelingsregel
      Gitt at "Journalistikk, HVL" har behandlertildelingsregelen "JOU"
      Og at "Utøvende musikk, NTNU" har behandlertildelingsregelen "SPE"
      Og at søkeren har søkt "Journalistikk, HVL", "Utøvende musikk, NTNU" og "Informatikk, UiO" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "Høgskulen på Vestlandet" saksbehandlende organisasjon for "Journalistikk, HVL" og "Informatikk, UiO"
      Og "NTNU" er saksbehandlende organisasjon for "Utøvende musikk, NTNU"
      # AVKLART 08.10.2026 med domeneekspert: verken SPE eller JOU sier at tilbyderen bare skal
      # saksbehandle sine egne søknadsalternativer, så søkerens prioritering avgjør.

    Scenariomal: Opptaksforvalteren kan velge <organisasjon> som organisasjon for sektoren
      Når opptaksforvalteren ved HK-dir velger "<organisasjon>" som organisasjon på "JOU"
      Så saksbehandler "<organisasjon>" søknadsalternativene med behandlertildelingsregelen "JOU"

      Eksempler:
        | organisasjon                    |
        | UiT Norges arktiske universitet |
        | HK-dir                          |

    Scenario: Organisasjonen for sektoren må delta i opptaket
      Gitt at "Universitetet i Bergen" ikke deltar i opptaket
      Når opptaksforvalteren ved HK-dir velger organisasjon på "JOU"
      Så ser ikke opptaksforvalteren "Universitetet i Bergen" blant valgene

  Regel: Unntak for utdanningsbakgrunn og ledige studieplasser overstyrer behandlertildelingsregelen

    Scenario: Legge til unntak for utdanningsbakgrunn
      Når opptaksforvalteren ved HK-dir legger til følgende unntak på behandlertildelingsregelen "JOU"
        | utdanningsbakgrunn  | fordeles til |
        | Utenlandsk          | HK-dir       |
        | Rudolf Steinerskole | HK-dir       |
      Så gjelder unntakene for søknadsalternativene med behandlertildelingsregelen "JOU"

    Scenariomal: HK-dir saksbehandler hele søknaden når søkeren har utdanningsbakgrunn <utdanningsbakgrunn>
      Gitt at behandlertildelingsreglene har unntak som fordeler "<utdanningsbakgrunn>" til HK-dir
      Og at søkeren har utdanningsbakgrunn "<utdanningsbakgrunn>"
      Og at søkeren har søkt "Informatikk, UiO", "Historie, UiT" og "Sykepleie, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "HK-dir" saksbehandlende organisasjon for alle søknadsalternativene

      Eksempler:
        | utdanningsbakgrunn  |
        | Utenlandsk          |
        | Rudolf Steinerskole |

    Scenario: Hver tilbyder saksbehandler sitt eget søknadsalternativ når søkeren har realkompetanse
      Gitt at søkeren har utdanningsbakgrunn "Realkompetanse"
      Og at søkeren har søkt "Informatikk, UiO", "Historie, UiT" og "Sykepleie, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Informatikk, UiO"
      Og "UiT Norges arktiske universitet" er saksbehandlende organisasjon for "Historie, UiT"
      Og "NTNU" er saksbehandlende organisasjon for "Sykepleie, NTNU"
      # AVKLART 07.10.2026 i PR #684: søkere med realkompetanse saksbehandles alltid av tilbyderen.
      # Det er ikke et unntak opptaksforvalteren legger på behandlertildelingsregelen.

    Scenario: Unntaket går foran behandlertildelingsregel der bare tilbyderen saksbehandler
      Gitt at "Utøvende musikk, NTNU" har behandlertildelingsregelen "SPE"
      Og at "SPE" har unntak som fordeler "Utenlandsk" til HK-dir
      Og at standardregelen har unntak som fordeler "Utenlandsk" til HK-dir
      Og at søkeren har utdanningsbakgrunn "Utenlandsk"
      Og at søkeren har søkt "Informatikk, UiO" og "Utøvende musikk, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "HK-dir" saksbehandlende organisasjon for begge søknadsalternativene

    Scenario: Behandlertildelingsregel uten unntak for søkerens utdanningsbakgrunn følges som vanlig
      Gitt at "Utøvende musikk, NTNU" har behandlertildelingsregelen "UVH" uten unntak
      Og at søkeren har utdanningsbakgrunn "Utenlandsk"
      Og at søkeren har søkt "Informatikk, UiO" og "Utøvende musikk, NTNU" i den rekkefølgen
      Når søknadsalternativene fordeles
      Så er "NTNU" saksbehandlende organisasjon for "Utøvende musikk, NTNU"
      Og "HK-dir" er saksbehandlende organisasjon for "Informatikk, UiO"

    Scenario: Tilbyderen saksbehandler alltid søknadsalternativ til ledig studieplass
      Gitt at "Informatikk, UiO" tilbyr ledige studieplasser
      Og at ledige studieplasser i opptaket har åpnet
      Når søkeren søker ledig studieplass på "Informatikk, UiO"
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Informatikk, UiO"
      # AVKLART 08.10.2026 i PR #684: tilbyderen saksbehandler alltid ledig studieplass. Det er ikke et
      # valg per behandlertildelingsregel, så avkrysningen «Ledige studieplasser fordeles til tilbyder» i designet
      # og koden er et avvik.

    Scenario: Ledig studieplass går foran unntak for utdanningsbakgrunn
      Gitt at ledige studieplasser i opptaket har åpnet
      Og at søkeren har utdanningsbakgrunn "Utenlandsk"
      Når søkeren søker ledig studieplass på "Informatikk, UiO"
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Informatikk, UiO"

    Scenario: Tilbyderen saksbehandler ledig studieplass som legges til på vegne av søkeren
      Gitt at ledige studieplasser i opptaket har åpnet
      Når saksbehandleren legger til ledig studieplass på "Informatikk, UiO" på vegne av søkeren
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Informatikk, UiO"
      # AVKLART 08.10.2026 i PR #684: det som avgjør, er om ledige studieplasser har åpnet. Om perioden
      # for ledige studieplasser er stengt, spiller ingen rolle.

  @ref-FLY-OPT-SAK-001
  Regel: Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket
    # AVKLART 23.10.2026 i STEK-579 (Ingrid Helset, Marit Bjørnerud Rønning): valget er et unntak for
    # lærested på behandlertildelingsregelen, som opptaksforvalteren ved forvaltende organisasjon setter.
    # Lærestedet er fortsatt tilbyder av utdanningstilbudet.

    Scenario: Legge til unntak for lærested
      Gitt at "Arkitektur- og designhøgskolen i Oslo" og "OsloMet" deltar i opptaket
      Når opptaksforvalteren ved HK-dir legger til følgende unntak for lærested på standardregelen
        | saksbehandles av | på vegne av                           |
        | OsloMet          | Arkitektur- og designhøgskolen i Oslo |
      Så gjelder unntaket for søknadsalternativene som fordeles etter standardregelen

    Scenario: Organisasjonen som saksbehandler på vegne av lærestedet får søknadsalternativene
      Gitt at "Arkitektur- og designhøgskolen i Oslo" og "OsloMet" deltar i opptaket
      Og at standardregelen har unntak for lærested der "OsloMet" saksbehandler på vegne av "Arkitektur- og designhøgskolen i Oslo"
      Og at søkeren har søkt "Arkitektur, AHO"
      Når søknadsalternativene fordeles
      Så er "OsloMet" saksbehandlende organisasjon for "Arkitektur, AHO"

    Scenariomal: Unntaket for lærested gjelder også når <tilfelle>
      Gitt at "Arkitektur- og designhøgskolen i Oslo" og "OsloMet" deltar i opptaket
      Og at "Arkitektur, AHO" har behandlertildelingsregelen "UVH"
      Og at "UVH" har unntak for lærested der "OsloMet" saksbehandler på vegne av "Arkitektur- og designhøgskolen i Oslo"
      Og at <forutsetning>
      Når søknadsalternativene fordeles
      Så er "OsloMet" saksbehandlende organisasjon for "Arkitektur, AHO"

      Eksempler:
        | tilfelle                        | forutsetning                                             |
        | bare tilbyderen saksbehandler   | søkeren har søkt "Arkitektur, AHO"                       |
        | søkeren har realkompetanse      | søkeren har realkompetanse og har søkt "Arkitektur, AHO" |
        | søkeren søker ledig studieplass | søkeren har søkt ledig studieplass på "Arkitektur, AHO"  |

    Scenariomal: Organisasjonene i unntaket for lærested må delta i opptaket
      Gitt at "Universitetet i Bergen" ikke deltar i opptaket
      Når opptaksforvalteren ved HK-dir legger til unntak for lærested på standardregelen
      Så ser ikke opptaksforvalteren "Universitetet i Bergen" blant valgene i <kolonne>

      Eksempler:
        | kolonne            |
        | «Saksbehandles av» |
        | «På vegne av»      |

    Scenario: Forvaltende organisasjon kan saksbehandle på vegne av et lærested
      Gitt at "Arkitektur- og designhøgskolen i Oslo" deltar i opptaket
      Og at standardregelen har unntak for lærested der "HK-dir" saksbehandler på vegne av "Arkitektur- og designhøgskolen i Oslo"
      Og at søkeren har søkt "Arkitektur, AHO"
      Når søknadsalternativene fordeles
      Så er "HK-dir" saksbehandlende organisasjon for "Arkitektur, AHO"

    Scenario: Lærestedet kan bare ha ett unntak for lærested per behandlertildelingsregel
      Gitt at standardregelen har unntak for lærested der "OsloMet" saksbehandler på vegne av "Arkitektur- og designhøgskolen i Oslo"
      Når opptaksforvalteren ved HK-dir legger til et nytt unntak for lærested på standardregelen
      Så kan ikke opptaksforvalteren velge "Arkitektur- og designhøgskolen i Oslo" i «På vegne av»

    Scenario: Nytt unntak for lærested gjelder bare søknadsalternativer som ikke er fordelt
      Gitt at "Arkitektur, AHO" er fordelt til "Arkitektur- og designhøgskolen i Oslo"
      Når opptaksforvalteren ved HK-dir legger til unntak for lærested der "OsloMet" saksbehandler på vegne av "Arkitektur- og designhøgskolen i Oslo"
      Så er "Arkitektur- og designhøgskolen i Oslo" fortsatt saksbehandlende organisasjon for "Arkitektur, AHO"

    Scenario: Organisasjon i et unntak for lærested kan ikke tas ut av opptaket
      Gitt at den aktive standardregelen har unntak for lærested der "OsloMet" saksbehandler på vegne av "Arkitektur- og designhøgskolen i Oslo"
      Når opptaksforvalteren ved HK-dir tar "OsloMet" ut av opptaket
      Så avvises endringen

  # ── 3. Endring ───────────────────────────────────────────────

  @ref-FLY-OPT-SAK-001 @ref-OPT-BEH-BEH-032
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
      Gitt at søkeren har søkt "Sykepleie, NTNU" og "Informatikk, UiO"
      Og at "Sykepleie, NTNU" skal saksbehandles av "NTNU" og "Informatikk, UiO" av "Universitetet i Oslo"
      Når søknadsalternativene fordeles
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

    Scenario: Nytt søknadsalternativ uten egen behandlertildelingsregel får samme saksbehandlende organisasjon som før
      Gitt at søkeren har søkt "Informatikk, UiO", og søknadsalternativet er fordelt til "Universitetet i Oslo"
      Når søkeren legger til "Sykepleie, NTNU" som første prioritet
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Sykepleie, NTNU"

    Scenario: Nytt søknadsalternativ der bare tilbyderen saksbehandler endrer ikke søknadsalternativene som er fordelt
      Gitt at søkeren har søkt "Informatikk, UiO", og søknadsalternativet er fordelt til "Universitetet i Oslo"
      Når søkeren legger til "Utøvende musikk, NTNU" med behandlertildelingsregelen "SPE"
      Så er "NTNU" saksbehandlende organisasjon for "Utøvende musikk, NTNU"
      Og "Universitetet i Oslo" er fortsatt saksbehandlende organisasjon for "Informatikk, UiO"

    Scenario: Sletting av søknadsalternativet fordelingen bygget på endrer ikke de andre søknadsalternativene
      Gitt at søkeren har søkt "Utøvende musikk, NTNU" med behandlertildelingsregelen "SPE" og "Informatikk, UiO"
      Og at begge søknadsalternativene er fordelt til "NTNU"
      Når søkeren sletter "Utøvende musikk, NTNU"
      Så er "NTNU" fortsatt saksbehandlende organisasjon for "Informatikk, UiO"
      # AVKLART 07.10.2026 i PR #684: saksbehandlende organisasjon bestemmes av søknaden søkeren
      # sendte inn først. Som hovedregel endres den ikke når søkeren sender inn på nytt, endrer
      # prioriteringen, sletter eller legger til søknadsalternativer.

  @depends-on-OPT-OVO-FRI-001 @ref-FLY-OPT-SAK-001
  # OPT-OVO-FRI-001: «Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn»
  Regel: Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak
    # AVKLART 22.10.2026: Fristen for endring av utdanningsbakgrunn gjelder bare saksbehandlerens endring.
    # Søkeren kan endre utdanningsbakgrunnen så lenge søknaden kan endres, og søknadsalternativene flyttes
    # hver gang.

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

    Scenariomal: Bytte fra <utdanningsbakgrunn> til norsk utdanningsbakgrunn flytter ingen søknadsalternativer
      Gitt at søkeren har utdanningsbakgrunn "<utdanningsbakgrunn>"
      Og at søkerens søknadsalternativer er fordelt
      Når søkeren endrer utdanningsbakgrunn til "Norsk"
      Så er saksbehandlende organisasjon uendret for alle søknadsalternativene
      # AVKLART 08.10.2026 med domeneekspert: søkeren skal bare oppleve å bytte saksbehandlende
      # organisasjon når det er nødvendig.

      Eksempler:
        | utdanningsbakgrunn |
        | Realkompetanse     |
        | Utenlandsk         |

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
      Gitt at fristen for endring av utdanningsbakgrunn <frist>
      Og at søkerens søknadsalternativer er fordelt til "Universitetet i Oslo"
      Når saksbehandleren ved Universitetet i Oslo endrer søkerens utdanningsbakgrunn til "Utenlandsk"
      Så er <organisasjon> saksbehandlende organisasjon for alle søknadsalternativene

      Eksempler:
        | frist             | organisasjon           |
        | ikke har gått ut  | "HK-dir"               |
        | har gått ut       | "Universitetet i Oslo" |

    Scenario: Opptaksforvalteren ved forvaltende organisasjon er ikke bundet av fristen
      Gitt at fristen for endring av utdanningsbakgrunn har gått ut
      Og at søkerens søknadsalternativer er fordelt til "Universitetet i Oslo"
      Når opptaksforvalteren ved HK-dir endrer søkerens utdanningsbakgrunn til "Utenlandsk"
      Så er "HK-dir" saksbehandlende organisasjon for alle søknadsalternativene

    Scenariomal: Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til
      Gitt at "Informatikk, UiO" har tilbudsgaranti fra <rolle>
      Når "Informatikk, UiO" flyttes fra "Universitetet i Oslo" til "HK-dir"
      Så starter saksbehandlingen av "Informatikk, UiO" på nytt hos "HK-dir"
      Og "Informatikk, UiO" har fortsatt tilbudsgaranti fra <rolle>

      Eksempler:
        | rolle            |
        | saksbehandler    |
        | tilbyder         |
        | opptaksforvalter |

    Scenario: Organisasjonen søknadsalternativet flyttes til, får en ubehandlet sak
      Gitt at søknaden ikke har sak hos "HK-dir"
      Og at saken hos "Universitetet i Oslo" er under behandling
      Når "Informatikk, UiO" flyttes fra "Universitetet i Oslo" til "HK-dir"
      Så har søknaden en ubehandlet sak hos "HK-dir" med "Informatikk, UiO"
      # AVKLART 04.11.2026: status «Overført» og uleste dokumenter (workshoprapporten 29.05.2026)
      # er tatt ut av kravet. Det tas opp igjen hvis det meldes behov.

    Scenario: Interne merknader blir igjen hos organisasjonen søknadsalternativet flyttes fra
      Gitt at saksbehandleren ved Universitetet i Oslo har skrevet en intern merknad i saken
      Når "Informatikk, UiO" flyttes fra "Universitetet i Oslo" til "HK-dir"
      Så ser ikke saksbehandleren ved HK-dir den interne merknaden

    Scenario: Organisasjonen søknadsalternativet flyttes til, ser dokumentene søkeren har lastet opp
      Gitt at søkeren har lastet opp et vitnemål til søknaden
      Og at "Informatikk, UiO" er fordelt til "Universitetet i Oslo"
      Når "Informatikk, UiO" flyttes fra "Universitetet i Oslo" til "HK-dir"
      Så ser saksbehandleren ved HK-dir vitnemålet

  # ── 4. Innsyn ────────────────────────────────────────────────

  @ref-FLY-OPT-SAK-001 @ref-OPT-BEH-BEH-032
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

    Scenario: Saksbehandleren ved forvaltende organisasjon ser bare saken hos forvaltende organisasjon
      Gitt at søknaden har saker hos "HK-dir" og "Universitetet i Oslo"
      Når saksbehandleren ved HK-dir åpner søknaden
      Så ser saksbehandleren bare saken hos "HK-dir"

    Scenario: Saksbehandleren ser alle søknadsalternativene på søknaden
      Gitt at søkeren har søkt "Informatikk, UiO" og "Historie, UiT" i den rekkefølgen
      Og at "Informatikk, UiO" er fordelt til "Universitetet i Oslo" og "Historie, UiT" til "UiT Norges arktiske universitet"
      Når saksbehandleren ved Universitetet i Oslo åpner saken hos "Universitetet i Oslo"
      Så ser saksbehandleren "Informatikk, UiO" og "Historie, UiT" med prioritet, tilbyder og saksbehandlende organisasjon
      Men saksbehandleren ser ikke saksbehandlingen av "Historie, UiT"
      # AVKLART 05.11.2026 i den interne akseptansetesten: saksbehandleren skal se hele søknaden når hen står
      # i en sak. Saksbehandlingen av søknadsalternativene i andre saker vises ikke.

    Scenario: Saksbehandleren ser dokumentene søkeren har lastet opp
      Gitt at søkeren har lastet opp et vitnemål til søknaden
      Når saksbehandleren ved Universitetet i Oslo åpner saken hos "Universitetet i Oslo"
      Så ser saksbehandleren vitnemålet

  Regel: Opptaksforvalteren ved forvaltende organisasjon ser alle sakene i opptaket

    Scenario: Opptaksforvalteren ved HK-dir ser sakene hos alle saksbehandlende organisasjoner
      Gitt at søknaden har saker hos "Universitetet i Oslo" og "UiT Norges arktiske universitet"
      Når opptaksforvalteren ved HK-dir åpner søknaden
      Så ser opptaksforvalteren sakene hos "Universitetet i Oslo" og "UiT Norges arktiske universitet"

  @ref-FLY-OPT-SAK-001
  Regel: Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet

    Scenario: Tilbyderen ser søknadsalternativ som en annen organisasjon saksbehandler
      Gitt at "Historie, UiT" er fordelt til "Universitetet i Oslo"
      Når saksbehandleren ved UiT Norges arktiske universitet ser søknadsalternativene til utdanningstilbudene ved UiT
      Så ser saksbehandleren "Historie, UiT"
      Og saksbehandleren ser saksbehandlingen "Universitetet i Oslo" har gjort på "Historie, UiT"

    Scenario: Tilbyderen setter tilbudsgaranti
      Gitt at "Historie, UiT" er fordelt til "Universitetet i Oslo"
      Når saksbehandleren ved UiT Norges arktiske universitet setter tilbudsgaranti på "Historie, UiT"
      Så har "Historie, UiT" tilbudsgaranti

    Scenario: Tilbyderen kan ikke endre saksbehandlingen
      Gitt at "Historie, UiT" er fordelt til "Universitetet i Oslo"
      Når saksbehandleren ved UiT Norges arktiske universitet ser "Historie, UiT"
      Så ser ikke saksbehandleren de interne merknadene til "Universitetet i Oslo"
      Og saksbehandleren ser ikke muligheten til å endre grunnlaget eller poengene
      # AVKLART 08.10.2026 i PR #684: tilbyderen ser saken, men ikke de interne merknadene, og kan bare
      # sette tilbudsgaranti. AVKLART 04.11.2026: tilbyderen ser ikke dokumentene i saken. Endres 05.11.2026:
      # tilbyderen skal se dokumentene søkeren har lastet opp (se «Tilbyderen ser dokumentene søkeren har lastet opp»).

    Scenario: Tilbyderen ser alle søknadsalternativene på søknaden
      Gitt at søkeren har søkt "Informatikk, UiO", "Historie, UiT" og "Sykepleie, NTNU" i den rekkefølgen
      Og at alle søknadsalternativene er fordelt til "Universitetet i Oslo"
      Når saksbehandleren ved UiT Norges arktiske universitet åpner saken med "Historie, UiT"
      Så ser saksbehandleren "Informatikk, UiO", "Historie, UiT" og "Sykepleie, NTNU" med prioritet, tilbyder og saksbehandlende organisasjon
      Men saksbehandleren ser ikke saksbehandlingen av "Informatikk, UiO" og "Sykepleie, NTNU"
      # AVKLART 05.11.2026 i den interne akseptansetesten: tilbyderen skal se hele søknaden, men saksbehandlingen
      # bare for søknadsalternativene til utdanningstilbudene sine.

    Scenario: Tilbyderen ser dokumentene søkeren har lastet opp
      Gitt at "Historie, UiT" er fordelt til "Universitetet i Oslo"
      Og at søkeren har lastet opp et vitnemål til søknaden
      Når saksbehandleren ved UiT Norges arktiske universitet åpner saken med "Historie, UiT"
      Så ser saksbehandleren vitnemålet
      Men saksbehandleren kan ikke endre eller slette vitnemålet
      # AVKLART 12.11.2026 i STEK-687: tilbyderen ser dokumentene i saken, men kan ikke endre dem.
