# language: no
# GitHub: #216
@OPT-PLA-TIL-001 @must @draft
Egenskap: Starte en plasstildeling
  Som opptaksforvalter
  ønsker jeg å starte en plasstildeling i en runde
  slik at studieplassene fordeles ut fra rangeringen og innstillingene i opptaket.

  # Kilde: tasks/opptak/plasstildeling/design.md (beslutning 3, oppgave 4), oppgave.md (oppgave 4) og
  # Confluence «Fra saksbehandling til plasstildeling» (2026-09-04).
  # Plasstildelingen utføres som en bestilling og kjører i bakgrunnen. Én runde kan ha mange
  # plasstildelinger: prøvetildelinger som ikke publiseres, og til slutt én som publiseres.
  # Status i kode: løst (oppgave.md). Kandidat for @implemented etter verifisering.

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" har runden "Hovedrunde" med rundetype "Hovedtildeling"

  Regel: Opptaksforvalter bestiller en plasstildeling som kjører i bakgrunnen

    Scenario: Starte plasstildeling
      Når opptaksforvalter starter en plasstildeling i runden "Hovedrunde"
      Så kjøres plasstildelingen i bakgrunnen
      Og opptaksforvalter ser status for plasstildelingen

    Scenario: Plasstildeling fryser grunnlaget ved start
      Gitt at søknadsbehandlingen har rangert søkerne til opptaket
      Når opptaksforvalter starter en plasstildeling i runden "Hovedrunde"
      Så bruker plasstildelingen rangeringen slik den var da plasstildelingen startet
      Og grunnlaget lagres sammen med plasstildelingen

    # AVKLART 2026-10-08: Plasstildelingen henter søknadene i opptaket når opptaksforvalter starter den.
    @openquestion
    Scenario: Søknader som er med i plasstildelingen
      # ÅPNE SPØRSMÅL:
      # - Er det nok at søknaden er kvalifisert, eller må den ha status ferdigbehandlet?
      #   Koden krever ikke ferdigbehandlet. En søknad er med når alt dette er oppfylt:
      #   søknadsalternativet er ikke slettet og har en behandlersak, saken er kvalifisert mot
      #   utdanningstilbudets kompetanseregelverk, saken har en aktiv kvote som skal kvoteplasseres
      #   og som også er kvote på utdanningstilbudet, og saken har poengsum etter utdanningstilbudets
      #   rangeringsregelverk. Søkeren må ha fødselsdato, ellers feiler hele plasstildelingen.
      Gitt at søknaden til "Kari Nordmann" på "Sykepleie, høst 2027" er kvalifisert
      Når opptaksforvalter starter en plasstildeling i runden "Hovedrunde"
      Så er søknaden til "Kari Nordmann" på "Sykepleie, høst 2027" med i plasstildelingen

    Scenario: Ny plasstildeling i samme runde
      Gitt at runden "Hovedrunde" har en plasstildeling som ikke er publisert
      Når opptaksforvalter starter en ny plasstildeling i runden "Hovedrunde"
      Så beregnes en ny plasstildeling fra oppdatert grunnlag
      Og den forrige plasstildelingen er fortsatt tilgjengelig

  Regel: En plasstildeling etter hovedtildelingen bygger på forrige publiserte runde

    Scenario: Plasstildeling i hovedtildelingen
      Når opptaksforvalter starter en plasstildeling i runden "Hovedrunde"
      Så bygger plasstildelingen ikke på noen tidligere runde

    Scenario: Plasstildeling i en senere runde
      Gitt at runden "Hovedrunde" har en publisert plasstildeling
      Og at opptaket har runden "Suppleringsrunde" med rundetype "Supplering"
      Når opptaksforvalter starter en plasstildeling i runden "Suppleringsrunde"
      Så bygger plasstildelingen på den publiserte plasstildelingen i "Hovedrunde"
      Og tidligere tilbud, ventelister og svar er med i grunnlaget

    # AVKLART 2026-10-08: starten avvises.
    # Gap mot koden («Plasstildelingsløpet i Opptak», kap. 1–2): i dag kjøres en slik runde som en
    # hovedtildeling. Runden det bygges på, utledes som opptakets sist publiserte runde.
    Scenario: Senere runde uten publisert forrige runde
      Gitt at runden "Hovedrunde" ikke har en publisert plasstildeling
      Når opptaksforvalter starter en plasstildeling i runden "Suppleringsrunde"
      Så blir plasstildelingen ikke startet
      Og opptaksforvalter får beskjed om at forrige runde må publiseres først

  Regel: Plasstildelingen starter ikke på et tomt grunnlag

    Scenario: Ingen rangerte søkere
      Gitt at opptaket har utdanningskvoter
      Men søknadsbehandlingen har ingen rangerte søkere i opptaket
      Når opptaksforvalter starter en plasstildeling i runden "Hovedrunde"
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
      Gitt at opptaksforvalter har startet en plasstildeling i runden "Hovedrunde"
      Når plasstildelingen feiler
      Så ser opptaksforvalter at plasstildelingen feilet
      Og opptaksforvalter kan starte en ny plasstildeling i runden "Hovedrunde"

# ÅPNE SPØRSMÅL:
# - Kan opptaksforvalter ved lærestedet starte plasstildeling, eller bare forvaltende organisasjon?
#   I lokale opptak er det samme organisasjon.
# - Skal det finnes en kontroll før start som viser søkere som faller ut av grunnlaget
#   (kvalifisert, men mangler poengsum, kvote eller grunnlag)? Se «Fra saksbehandling til plasstildeling», D6.
# - Kan en plasstildeling startes mens perioden for å endre antall tilbud fortsatt er åpen?
# - Hvordan fanges det opp at en søker har endret søknaden sin mellom runder?
#   I koden vet kjøringen ikke hvilke studieønsker som er nye, så vernet «et nytt ønske skal ikke
#   fortrenge et eksisterende tilbud» virker ikke.
# - Svar leses i koden bare fra runden det bygges på, ikke fra alle tidligere runder. Et svar fra
#   hovedrunden som ikke er gitt på nytt, er usynlig i den tredje runden. Skal alle tidligere svar telle?
# - Rekkefølgen på rundene avgjøres i koden av når de ble publisert, ikke av løpenummeret.
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
