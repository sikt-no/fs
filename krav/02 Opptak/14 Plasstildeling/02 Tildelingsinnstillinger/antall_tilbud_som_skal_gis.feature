# language: no
# GitHub: #583
@OPT-PLA-INN-001 @must @draft
Egenskap: Antall tilbud som skal gis per utdanningskvote
  Som opptaksforvalter
  ønsker jeg å bestemme hvor mange tilbud som skal gis i hver utdanningskvote i en runde
  slik at plasstildelingen fyller studieplassene uten å gi for mange eller for få tilbud.

  # Kilde: tasks/opptak/plasstildeling/oppgave.md (oppgave 2), design.md (begrepsforklaringer),
  # Confluence «2026-09-08 Raffinering plasstildeling» (oppgave 2) og raffinering 2026-10-07.
  # Antall tilbud som skal gis settes per utdanningskvote for den enkelte runde.
  # Opptaksforvalter ved lærestedet setter tallene for egne utdanningstilbud innenfor perioden
  # som er satt på runden (se 01 Runder/legge_til_runde.feature).
  # Opptaksforvalter ved forvaltende organisasjon kan endre tallene også utenfor perioden.
  # Begrep: «overbooking», «måltall» og «opptaksparametere» erstattes av «antall tilbud som skal gis».

  Bakgrunn:
    Gitt at opptaksforvalter ved lærestedet er innlogget
    Og at opptaket "Samordna opptak 2027" har runden "Hovedrunde" med rundetype "Hovedtildeling"
    Og at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvotene "Førstegangsvitnemål" og "Ordinær"

  Regel: Opptaksforvalter setter antall tilbud som skal gis per utdanningskvote for runden

    # Opptaksforvalter slår opp siden for å sette antall tilbud som skal gis og ser
    # en liste over utdanningstilbud med sine utdanningskvoter.
    # Tallet settes direkte i utdanningskvoten. Totalt antall tilbud som skal gis
    # for utdanningstilbudet beregnes automatisk som summen av utdanningskvotene.

    Scenario: Sette antall tilbud i en utdanningskvote for runden
      Når opptaksforvalter setter antall tilbud som skal gis i utdanningskvoten "Ordinær" til 150 for runden "Hovedrunde"
      Og opptaksforvalter setter antall tilbud som skal gis i utdanningskvoten "Førstegangsvitnemål" til 128 for runden "Hovedrunde"
      Så gir plasstildelingen i runden inntil 150 tilbud i utdanningskvoten "Ordinær"
      Og totalt antall tilbud som skal gis for utdanningstilbudet vises som 278

    # Gap mot koden («Plasstildelingsløpet i Opptak», kap. 1 og 3): mangler tallet, bruker koden
    # kvotens «ønsket antall deltakere» i stedet for 0. Bekreftet 2026-10-08 at kravet gjelder.
    Scenario: Default er null
      Gitt at opptaksforvalter ikke har satt antall tilbud som skal gis i utdanningskvotene for runden
      Så er antall tilbud som skal gis i hver utdanningskvote 0
      Og opptaksforvalter ser et tydelig varsel om at det ikke er lagt inn tall i utdanningskvoten

  Regel: Opptaksforvalter ser grunnlaget for å sette antall tilbud

    Scenario: Se grunnlag for antall tilbud
      Når opptaksforvalter ser antall tilbud som skal gis for utdanningstilbudet "Sykepleie, høst 2027"
      Så ser opptaksforvalter disse opplysningene
        | Opplysning                                     |
        | Antall studieplasser                           |
        | Antall tilbud som skal gis per utdanningskvote |
        | Totalt antall tilbud som skal gis              |
        | Antall tilbud gitt per utdanningskvote         |
        | Antall tilbud akseptert per utdanningskvote    |
        | Antall søkere på venteliste                    |

    # Antall tilbud gitt, antall aksepterte og antall på venteliste oppdateres
    # etterhvert som publisering av tilbud er gjort og svar begynner å komme inn fra søkere.

  Regel: Et utdanningstilbud kan gi tilbud til alle kvalifiserte

    # Opptaksforvalter kan velge dette i stedet for å sette tall i utdanningskvotene.
    Scenario: Tilbud til alle kvalifiserte på utdanningstilbudet
      Når opptaksforvalter angir at utdanningstilbudet "Sykepleie, høst 2027" skal gi tilbud til alle kvalifiserte
      Så får alle kvalifiserte søkere tilbud uavhengig av poengsum
      Og utdanningstilbudet har ingen poenggrense

  @openquestion
  Scenario: Prosentfordeling som ikke gir hele tall
    # ÅPNE SPØRSMÅL:
    # - Hvordan avrundes antall tilbud når prosentandelen ikke gir hele tall?
    #   Forslag: restplassen går til kvoten som ikke kan viderefordele plasser til andre kvoter.
    #   I UHG-opptak er dette normalt ordinær kvote, fordi førstegangsvitnemålskvoten kan
    #   viderefordele ubrukte plasser til ordinær, men ikke omvendt.
    #   Stemmer dette som hovedregel? Finnes det unntak?
    Gitt at utdanningstilbudet skal gi 277 tilbud totalt
    Og at kvotefordelingen er 50 % førstegangsvitnemål og 50 % ordinær
    Når plasstildelingen beregner antall tilbud som skal gis
    Så skal det gis 138 tilbud i utdanningskvoten "Førstegangsvitnemål"
    Og det skal gis 139 tilbud i utdanningskvoten "Ordinær"

  Regel: I suppleringsrunder settes antall ønsket ja-svar

    # Styrer kompensasjonstilbud ved opprykk, se 03 Tildeling/kompensasjonstilbud_ved_opprykk.feature.
    Scenario: Sette antall ønsket ja-svar
      Gitt at opptaket har runden "Suppleringsrunde" med rundetype "Supplering"
      Når opptaksforvalter setter antall ønsket ja-svar til 120 for utdanningstilbudet "Sykepleie, høst 2027" i runden "Suppleringsrunde"
      Så gir plasstildelingen i runden kompensasjonstilbud til antall ja-svar når 120

  @openquestion
  Regel: I etterfylling gis nøyaktig det antallet tilbud som er satt

    # ÅPNE SPØRSMÅL:
    # - Kommer fra Confluence «Samordnet plasstildeling» (mai 2026), ikke bekreftet i design.md.
    #   Stemmer det at lærestedet selv må regne inn forventet frafall i etterfylling?
    Scenario: Etterfylling gir det antallet tilbud som er satt
      Gitt at opptaket har runden "Etterfylling" med rundetype "Etterfylling"
      Når opptaksforvalter setter antall tilbud som skal gis i utdanningskvoten "Ordinær" til 10 for runden "Etterfylling"
      Så gir plasstildelingen 10 nye tilbud i utdanningskvoten "Ordinær"
      Og plasstildelingen kompenserer ikke for frafall

# AVKLARTE SPØRSMÅL (raffinering 2026-10-07):
# - Opptaksforvalter ved forvaltende organisasjon kan endre antall tilbud også utenfor
#   lærestedenes periode. Se 01 Runder/legge_til_runde.feature.
# - Siste lagrede tall er korrekt uavhengig av hvem som satte det.
# - Standard plassflyt for opptaket er en opptaksinnstilling, men løses som del av
#   arbeidet med å lage plasstildelingen. Gjenåpnet 2026-10-08: om plassflyten settes på opptaket
#   eller per utdanningstilbud er uavklart, se 02 Tildelingsinnstillinger/plassflyt.feature.
# - Antall tilbud som skal gis settes direkte per utdanningskvote.
#   Totalt antall tilbud er utledet (summen av utdanningskvotene), ikke satt eksplisitt.
# - Default i utdanningskvotene er null, med tydelig varsel.
#
# ÅPNE SPØRSMÅL:
# - Supplering: er antall tilbud for runden et absolutt tall, eller et tillegg (delta) til det som
#   allerede er gitt? Confluence «Samordnet plasstildeling» sier delta.
# - Begrep: oppgave.md sier at «overbooking» skal hete «antall ønskede ja-svar», mens design.md sier
#   at «overbooking» skal hete «antall tilbud som skal gis». Hvilken gjelder? Fila følger design.md.
#   I koden er «overbooking» det totale tallet for runden, ikke et tillegg (A11 i «Plasstildelingsløpet i Opptak»).
# - Negative tall: skal det være mulig å redusere antall aktive tilbud i en suppleringsrunde?
#   Ikke verifisert mot dagens løsning.
# - Merbehov senere: nøkkeltall fra fjorårets opptak med forslag til antall ønsket ja-svar.