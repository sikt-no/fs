# language: no
# GitHub: #216, #598
@OPT-PLA-INN-002 @must @draft @scope-plasstildeling-2027 @depends-on-OPT-REG-KVO-003
Egenskap: Plassflyt mellom utdanningskvoter
  Som opptaksforvalter
  ønsker jeg at ledige plasser i en utdanningskvote flyter til en utdanningskvote jeg har pekt på
  slik at studieplasser ikke går tapt når det er for få kvalifiserte søkere i en utdanningskvote.

  # Standard plassflyt settes i regelverkssamlingen, se
  # 10 Regelverk/04 Kvoter/sette_plassflyt.feature (flyttet dit 2026-10-21, fra opptaket).
  # Her står hva plasstildelingen gjør med plassflyten.
  # AVKLART 2026-10-09: Plassflyt er bare at ubrukte plasser flyter mellom utdanningskvoter i et opptak.
  # At en plasstildelingsrunde bygger på forrige plasstildelingsrunde, er informasjonsarv, ikke plassflyt.
  #
  # ÅPNE SPØRSMÅL:
  # - Å flytte bare noen av de ledige plassene («flytt N av M») er ikke støttet. Trengs det?
  # - Flyter flere utdanningskvoter til samme mottaker, avgjør kvoteprioriteten rekkefølgen
  #   («Plasstildelingsløpet i Opptak», kap. 4). Skal det stå som et scenario?
  #
  # AVKLART 2026-10-15: Forgrening trengs ikke. Hver kvote har én mottaker, og flere kvoter kan ha samme
  # mottaker (sette_plassflyt.feature).
  # Kilde: tasks/opptak/plasstildeling/design.md (prinsipp 3, oppgave 3) og oppgave.md (gap-analyse oppgave 3).
  # Vernet mot sirkulær plassflyt kommer fra GitHub #598.
  # Status i kode: løst (oppgave.md). Kandidat for @implemented etter verifisering.
  # Begrep: «kvoteflyt» heter nå «plassflyt».

  Bakgrunn:
    Gitt at utdanningstilbudet "Sykepleie, høst 2027" er med i plasstildelingsrunden "Hovedrunde" i opptaket "Samordna opptak 2027"

  Regel: Ledige plasser går til den første kvoten i kjeden som finnes på utdanningstilbudet

    # AVKLART 2026-10-13: HK-dir har ikke funnet noen avvik fra standardisert plassflyt. Eksempel fra HK-dir:
    # samiskspråklig kvote går til Nordland, Troms og Finnmark-kvoten hvis den finnes, ellers til nordnorsk
    # kvote, ellers til ordinær kvote.
    # AVKLART 2026-10-15: Hver kvote har én mottaker, så eksempelet er en kjede. Finnes ikke mottakeren på
    # utdanningstilbudet, går de ledige plassene videre i kjeden til den første kvoten som finnes.

    Scenariomal: Plassflyt etter hvilke utdanningskvoter utdanningstilbudet har
      Gitt at standard plassflyt er "Samisk" til "Nordland, Troms og Finnmark", "Nordland, Troms og Finnmark" til "Nordnorsk" og "Nordnorsk" til "Ordinær"
      Og at utdanningstilbudet har utdanningskvotene <utdanningskvoter>
      Og at "Samisk" har ledige plasser
      Når plasstildelingen gjennomføres
      Så flyter de ledige plassene i "Samisk" til "<mottaker>"

      Eksempler:
        | utdanningskvoter                                               | mottaker                    |
        | Samisk, Nordland, Troms og Finnmark, Nordnorsk og Ordinær      | Nordland, Troms og Finnmark |
        | Samisk, Nordnorsk og Ordinær                                   | Nordnorsk                   |
        | Samisk og Ordinær                                              | Ordinær                     |

    # AVKLART 2026-10-21 (produkteier): Utdanningstilbudet trenger ikke å ha alle kvotetypene, bare hovedkvoten.
    # Flytretningen gjelder likevel: kvotene utdanningstilbudet har, følger kjeden mot hovedkvoten.
    Scenariomal: Flytretningen gjelder selv om utdanningstilbudet ikke har alle kvotene
      Gitt at standard plassflyt i regelverkssamlingen er "Samisk språkkompetanse (SAM)" til "Nordnorsk (NN)", "Nordnorsk (NN)" til "Førstegangsvitnemål (ORDF)" og "Førstegangsvitnemål (ORDF)" til "Ordinær kvote (ORD)"
      Og at "Ordinær kvote (ORD)" er hovedkvoten
      Og at utdanningstilbudet har utdanningskvotene <utdanningskvoter>
      Når plasstildelingen gjennomføres
      Så flyter ledige plasser <flyt>

      Eksempler:
        | utdanningskvoter                                                                                                   | flyt                                                                                                   |
        | "Samisk språkkompetanse (SAM)", "Nordnorsk (NN)", "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)"            | fra "Samisk språkkompetanse (SAM)" til "Nordnorsk (NN)", til "Førstegangsvitnemål (ORDF)" og til "Ordinær kvote (ORD)" |
        | "Nordnorsk (NN)", "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)"                                            | fra "Nordnorsk (NN)" til "Førstegangsvitnemål (ORDF)" og til "Ordinær kvote (ORD)"                      |

  Regel: Overskytende plasser flyter til den utdanningskvoten det er pekt på

    Scenario: Ledige plasser flyter til mottakende utdanningskvote
      Gitt at det skal gis 20 tilbud i utdanningskvoten "Førstegangsvitnemål"
      Og at det skal gis 100 tilbud i utdanningskvoten "Ordinær"
      Og at utdanningskvoten "Førstegangsvitnemål" har 12 kvalifiserte søkere
      Og at ledige plasser i "Førstegangsvitnemål" flyter til "Ordinær"
      Når plasstildelingen gjennomføres
      Så får 12 søkere tilbud i utdanningskvoten "Førstegangsvitnemål"
      Og det gis inntil 108 tilbud i utdanningskvoten "Ordinær"

    Scenario: Plassflyt i flere ledd
      Gitt at ledige plasser i "Samisk" flyter til "Førstegangsvitnemål"
      Og at ledige plasser i "Førstegangsvitnemål" flyter til "Ordinær"
      Og at både "Samisk" og "Førstegangsvitnemål" har færre kvalifiserte søkere enn tilbud som skal gis
      Når plasstildelingen gjennomføres
      Så ender de ledige plassene fra begge utdanningskvotene i "Ordinær"

    Scenario: Hovedkvoten sender ikke plasser videre
      Gitt at "Ordinær" er hovedkvote
      Og at "Ordinær" har færre kvalifiserte søkere enn tilbud som skal gis
      Når plasstildelingen gjennomføres
      Så blir de ledige plassene i "Ordinær" stående ubrukt

  Regel: Plassflyt går i en kjede innenfor utdanningstilbudet

    Scenario: Vanligste kjede i UHG
      Gitt at standard plassflyt for opptaket er "Førstegangsvitnemål" til "Ordinær"
      Og at "Ordinær" er hovedkvote
      Når plasstildelingen gjennomføres for et utdanningstilbud med utdanningskvotene "Førstegangsvitnemål" og "Ordinær"
      Så flyter ledige plasser i "Førstegangsvitnemål" til "Ordinær"

    Scenario: Plassflyt mellom utdanningstilbud
      Gitt at standard plassflyt for opptaket er satt
      Når plasstildelingen gjennomføres
      Så flyter ledige plasser bare mellom utdanningskvoter på samme utdanningstilbud

  Regel: Det kan spores at en plass kom via plassflyt

    # Visningen er beskrevet i 04 Resultat/vise_resultat.feature (opptaksforvalter, før publisering)
    # og 04 Resultat/se_publisert_resultat.feature (saksbehandler, etter publisering).
    Scenario: Tilbud gitt via plassflyt
      Gitt at søkeren "Kari Nordmann" fikk tilbud i "Ordinær" på en plass som fløt fra "Førstegangsvitnemål"
      Så er det lagret at plassen kom fra utdanningskvoten "Førstegangsvitnemål"
