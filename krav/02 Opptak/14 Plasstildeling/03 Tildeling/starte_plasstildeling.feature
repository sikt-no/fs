# language: no
# GitHub: #216
@OPT-PLA-TIL-001 @must @draft @scope-plasstildeling-2027
Egenskap: Starte en plasstildeling
  Som opptaksforvalter
  ønsker jeg å starte en plasstildeling i en plasstildelingsrunde
  slik at studieplassene fordeles ut fra rangeringen og innstillingene i opptaket.

  # Kilde: tasks/opptak/plasstildeling/design.md (beslutning 3, oppgave 4), oppgave.md (oppgave 4) og
  # Confluence «Fra saksbehandling til plasstildeling» (2026-09-04).
  # Plasstildelingen utføres som en bestilling og kjører i bakgrunnen. Én plasstildelingsrunde kan ha mange
  # plasstildelinger: prøvetildelinger som ikke publiseres, og til slutt én som publiseres.
  # Status i kode: løst (oppgave.md). Kandidat for @implemented etter verifisering.

  Bakgrunn:
    Gitt at opptakets forvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"

  Regel: Opptaksforvalter bestiller en plasstildeling som kjører i bakgrunnen

    Scenario: Starte plasstildeling
      Når opptaksforvalter starter en plasstildeling i "Hovedrunde"
      Så kjøres plasstildelingen i bakgrunnen
      Og opptaksforvalter ser status for plasstildelingen

    # AVKLART 2026-10-14 (designarbeidet i FS-Admin): Bare opptakets forvalter starter plasstildeling.
    # Lærestedene setter antall tilbud for utdanningstilbudene sine.
    Scenario: Opptaksforvalter ved deltakende organisasjon kan ikke starte plasstildeling
      Gitt at opptaksforvalter har tilgang fra "Universitetet i Bergen", som deltar i opptaket
      Når opptaksforvalter ser plasstildelingsrunden "Hovedrunde"
      Så ser opptaksforvalter ikke muligheten til å starte en plasstildeling

    Scenario: Plasstildeling fryser grunnlaget ved start
      Gitt at søknadsbehandlingen har rangert søkerne til opptaket
      Når opptaksforvalter starter en plasstildeling i "Hovedrunde"
      Så bruker plasstildelingen rangeringen slik den var da plasstildelingen startet
      Og grunnlaget lagres sammen med plasstildelingen

    # AVKLART 2026-10-14 (designarbeidet i FS-Admin): Det er ingen sperre mellom perioden for lærestedene
    # og start av plasstildeling. Opptakets forvalter styrer fristene.
    Scenario: Starte plasstildeling mens perioden for antall tilbud er åpen
      Gitt at perioden for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" er åpen
      Og at antall tilbud som skal gis i "Sykepleie, høst 2027" i "Hovedrunde" er 30
      Når opptaksforvalter starter en plasstildeling i "Hovedrunde"
      Så blir plasstildelingen startet
      Og plasstildelingen bruker 30 tilbud for "Sykepleie, høst 2027"

    # AVKLART 2026-10-08: Plasstildelingen henter søknadene i opptaket når opptaksforvalter starter den.
    # AVKLART 2026-10-15: Bare saker som er ferdig behandlet (FERDIG_BEHANDLET), er med i plasstildelingen.
    # Statusen gjelder per sak, altså søknaden slik den ligger hos én saksbehandlende organisasjon, som i
    # tidligopptaket (13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature).
    # Hvordan saken blir ferdig behandlet, også av den automatiske behandlingen, står i kravet taggen peker på
    # (flyttet dit 2026-10-26). Av sakene som er med, kan søknadsalternativer som er kvalifisert og
    # poengberegnet, eller har tilbudsgaranti, få tilbud.
    # Gap mot koden: koden krever ikke at saken er ferdig behandlet. En søknad er med når alt dette er
    # oppfylt: søknadsalternativet er ikke slettet og har en behandlersak, saken er kvalifisert mot
    # utdanningstilbudets kompetanseregelverk, saken har en aktiv kvote som skal kvoteplasseres og som også er
    # kvote på utdanningstilbudet, og saken har poengsum etter utdanningstilbudets rangeringsregelverk.
    # Søkeren må ha fødselsdato, ellers feiler hele plasstildelingen.
    @depends-on-OPT-BEH-BEH-025
    Scenario: Bare saker som er ferdig behandlet, er med
      Gitt at saken til "Kari Nordmann" er ferdig behandlet
      Og at saken til "Ola Nordmann" ikke er ferdig behandlet
      Når opptaksforvalter starter en plasstildeling i "Hovedrunde"
      Så er saken til "Kari Nordmann" med i plasstildelingen
      Men saken til "Ola Nordmann" er ikke med i plasstildelingen

    Scenariomal: Søknadsalternativer som kan få tilbud
      Gitt at saken til "Kari Nordmann" er ferdig behandlet
      Og at søknadsalternativet "Sykepleie, høst 2027" <tilstand>
      Når opptaksforvalter starter en plasstildeling i "Hovedrunde"
      Så <kan> søknadsalternativet få tilbud

      Eksempler:
        | tilstand                          | kan      |
        | er kvalifisert og poengberegnet   | kan      |
        | har tilbudsgaranti                | kan      |
        | er kvalifisert, men uten poengsum | kan ikke |
        | er ikke kvalifisert               | kan ikke |

    Scenario: Ny plasstildeling i samme plasstildelingsrunde
      Gitt at plasstildelingsrunden "Hovedrunde" har en plasstildeling som ikke er publisert
      Når opptaksforvalter starter en ny plasstildeling i "Hovedrunde"
      Så beregnes en ny plasstildeling fra oppdatert grunnlag
      Og den forrige plasstildelingen er fortsatt tilgjengelig

  @depends-on-OPT-REG-RUN-001
  Regel: En plasstildeling bygger på forrige publiserte plasstildelingsrunde når rundetypen sier det

    # Endret 2026-10-24: Om plasstildelingen bygger på forrige publiserte plasstildelingsrunde, er en innstilling
    # i rundetypen. I samordna opptak har Supplering og Etterfylling den, og Hovedtildeling ikke.
    Scenario: Plasstildeling som ikke bygger på en tidligere plasstildelingsrunde
      Gitt at rundetypen "Hovedtildeling" ikke har innstillingen "Bygger på forrige publiserte plasstildelingsrunde"
      Når opptaksforvalter starter en plasstildeling i "Hovedrunde"
      Så bygger plasstildelingen ikke på noen tidligere plasstildelingsrunde

    # AVKLART 2026-10-14 (domeneekspert): En plasstildeling tar alltid med alle kvalifiserte kvotesøknader
    # når den starter. Når den bygger på forrige publiserte plasstildelingsrunde, tar den også med resultatet
    # per kvotesøknad fra den publiserte plasstildelingen (tilbud, venteliste og bortfall) og søkernes svar på
    # tilbud og venteliste. Hva det betyr for fordelingen, står i gjennomføre_plasstildeling.feature.
    Scenario: Plasstildeling som bygger på forrige publiserte plasstildelingsrunde
      Gitt at rundetypen "Supplering" har innstillingen "Bygger på forrige publiserte plasstildelingsrunde"
      Og at plasstildelingsrunden "Hovedrunde" har en publisert plasstildeling
      Og at opptaket har plasstildelingsrunden "Suppleringsrunde" med rundetype "Supplering"
      Når opptaksforvalter starter en plasstildeling i "Suppleringsrunde"
      Så bygger plasstildelingen på den publiserte plasstildelingen i "Hovedrunde"
      Og alle kvalifiserte kvotesøknader er med i grunnlaget
      Og resultatet per kvotesøknad fra den publiserte plasstildelingen i "Hovedrunde" er med i grunnlaget
      Og søkernes svar på tilbud og venteliste er med i grunnlaget

    # AVKLART 2026-10-08: starten avvises.
    # Gap mot koden («Plasstildelingsløpet i Opptak», kap. 1–2): i dag kjøres en slik plasstildelingsrunde som en
    # hovedtildeling. Plasstildelingsrunden det bygges på, utledes som opptakets sist publiserte plasstildelingsrunde.
    Scenario: Forrige plasstildelingsrunde er ikke publisert
      Gitt at rundetypen "Supplering" har innstillingen "Bygger på forrige publiserte plasstildelingsrunde"
      Og at plasstildelingsrunden "Hovedrunde" ikke har en publisert plasstildeling
      Når opptaksforvalter starter en plasstildeling i "Suppleringsrunde"
      Så blir plasstildelingen ikke startet
      Og opptaksforvalter får beskjed om at forrige plasstildelingsrunde må publiseres først

  Regel: Plasstildelingen starter ikke på et tomt grunnlag

    Scenario: Ingen rangerte søkere
      Gitt at opptaket har utdanningskvoter
      Men søknadsbehandlingen har ingen rangerte søkere i opptaket
      Når opptaksforvalter starter en plasstildeling i "Hovedrunde"
      Så blir plasstildelingen ikke startet
      Og opptaksforvalter får beskjed om at grunnlaget for plasstildelingen er tomt

  @openquestion
  Regel: En plasstildeling som feiler erstattes av en ny

    # ÅPNE SPØRSMÅL:
    # - Hovedspørsmål fra design.md: skal en plasstildeling kunne kjøres om, avbrytes eller korrigeres
    #   i enkeltresultater? Et ja betyr en annen løsning, ikke en justering. Dagens beslutning er nei:
    #   rett saksbehandlingsfeil og bestill en ny.
    # - At en plasstildeling feilet er ikke synlig i dag. Hva skal opptaksforvalter se?
    Scenario: Plasstildeling feiler
      Gitt at opptaksforvalter har startet en plasstildeling i "Hovedrunde"
      Når plasstildelingen feiler
      Så ser opptaksforvalter at plasstildelingen feilet
      Og opptaksforvalter kan starte en ny plasstildeling i "Hovedrunde"

# ÅPNE SPØRSMÅL:
# - Skal det finnes en kontroll før start som viser søkere som faller ut av grunnlaget
#   (kvalifisert, men mangler poengsum, kvote eller grunnlag)? Se «Fra saksbehandling til plasstildeling», D6.
# - Hvordan fanges det opp at en søker har endret søknaden sin mellom plasstildelingsrunder?
#   I koden vet kjøringen ikke hvilke studieønsker som er nye, så vernet «et nytt ønske skal ikke
#   fortrenge et eksisterende tilbud» virker ikke.
# - Svar leses i koden bare fra plasstildelingsrunden det bygges på, ikke fra alle tidligere plasstildelingsrunder. Et svar fra
#   hovedrunden som ikke er gitt på nytt, er usynlig i den tredje plasstildelingsrunden. Skal alle tidligere svar telle?
# - Rekkefølgen på plasstildelingsrundene avgjøres i koden av når de ble publisert, ikke av løpenummeret.
#   Er det riktig?
# - Er «skal kvoteplasseres» på sakens kvote riktig tolket som «denne kvoten er med i plasstildelingen»?
#   («Fra saksbehandling til plasstildeling», D2)
# - Uten poengformel på kvotetypen beregnes ingen poengsum, og søkeren faller stille ut av grunnlaget.
#   Bør det valideres eller varsles? (D5)
# - Et utdanningstilbud uten kompetanseregelverk eller rangeringsregelverk får ingen søkere i
#   plasstildelingen. Skal starten avvises, eller skal opptaksforvalter få et varsel?
# - Et opptak uten utdanningskvoter gir i dag en tom plasstildeling uten feil. Bare når det finnes
#   utdanningskvoter, men ingen søknader, feiler plasstildelingen. Skal et opptak uten utdanningskvoter
#   også avvises?
#
# AVKLART 2026-10-08: Opptaksforvalter starter plasstildelingen. Den startes ikke av systemet på en dato.
