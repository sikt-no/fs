# language: no
# GitHub: #583
@OPT-PLA-INN-001 @must @draft
Egenskap: Antall tilbud som skal gis per utdanningskvote
  Som opptaksforvalter
  ønsker jeg å bestemme hvor mange tilbud som skal gis i hver utdanningskvote i en runde
  slik at plasstildelingen fyller studieplassene uten å gi for mange eller for få tilbud.

  # Kilde: tasks/opptak/plasstildeling/oppgave.md (oppgave 2), design.md (begrepsforklaringer) og
  # Confluence «2026-09-08 Raffinering plasstildeling» (oppgave 2).
  # Totalt antall tilbud og relativ fordeling per utdanningskvote settes på utdanningstilbudet, se
  # 12 Utdanningstilbud/03 Opptaksinnstillinger/sette_studieplasser_og_antall_tilbud.feature og
  # 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature. Denne fila beskriver hvordan
  # plasstildelingen bruker tallene, og hva som settes per runde.
  # Opptaksforvalter ved lærestedet setter tallene for egne utdanningstilbud innenfor perioden
  # som er satt på runden (se 01 Runder/legge_til_runde.feature).
  # Begrep: «overbooking» og «måltall» erstattes av «antall tilbud som skal gis».

  Bakgrunn:
    Gitt at opptaksforvalter ved lærestedet er innlogget
    Og at opptaket "Samordna opptak 2027" har runden "Hovedrunde" med rundetype "Hovedtildeling"
    Og at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvotene "Førstegangsvitnemål" og "Ordinær"

  Regel: Antall tilbud per utdanningskvote beregnes fra relativ fordeling

    Scenario: Beregne antall tilbud fra prosentfordeling
      Gitt at utdanningstilbudet skal gi 278 tilbud totalt
      Og at kvotefordelingen er 50 % førstegangsvitnemål og 50 % ordinær
      Når plasstildelingen beregner antall tilbud som skal gis
      Så skal det gis 139 tilbud i utdanningskvoten "Førstegangsvitnemål"
      Og det skal gis 139 tilbud i utdanningskvoten "Ordinær"

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

  @openquestion
  Regel: Opptaksforvalter kan justere antall tilbud per utdanningskvote for runden

    # ÅPNE SPØRSMÅL:
    # - Er tallet for runden en overstyring av det som er beregnet fra relativ fordeling,
    #   eller er det det eneste tallet plasstildelingen bruker?
    # - Confluence (raffinering 2026-09-08) sier at det bare er mulig å registrere antall per
    #   utdanningskvote, og at totalen vises automatisk. Utdanningstilbud-kravet sier at totalen settes
    #   og fordeles med prosent. Hvilken retning gjelder?
    Scenario: Sette antall tilbud i en utdanningskvote for runden
      Når opptaksforvalter setter antall tilbud som skal gis i utdanningskvoten "Ordinær" til 150 for runden "Hovedrunde"
      Så gir plasstildelingen i runden inntil 150 tilbud i utdanningskvoten "Ordinær"
      Og totalt antall tilbud som skal gis for utdanningstilbudet vises automatisk

  Regel: Opptaksforvalter ser grunnlaget for å sette antall tilbud

    Scenario: Se grunnlag for antall tilbud
      Når opptaksforvalter ser antall tilbud som skal gis for utdanningstilbudet "Sykepleie, høst 2027"
      Så ser opptaksforvalter disse opplysningene
        | Opplysning                                     |
        | Antall planlagte studieplasser                 |
        | Antall tilbud gitt per utdanningskvote         |
        | Antall tilbud akseptert per utdanningskvote    |
        | Antall tilbud som skal gis per utdanningskvote |
        | Totalt antall tilbud som skal gis              |

  Regel: Et utdanningstilbud kan gi tilbud til alle kvalifiserte

    Scenario: Tilbud til alle kvalifiserte på utdanningstilbudet
      Når opptaksforvalter angir at utdanningstilbudet "Sykepleie, høst 2027" skal gi tilbud til alle kvalifiserte
      Så får alle kvalifiserte søkere tilbud uavhengig av poengsum
      Og utdanningstilbudet har ingen poenggrense

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

# ÅPNE SPØRSMÅL:
# - Supplering: er antall tilbud for runden et absolutt tall, eller et tillegg (delta) til det som
#   allerede er gitt? Confluence «Samordnet plasstildeling» sier delta.
# - Begrep: oppgave.md sier at «overbooking» skal hete «antall ønskede ja-svar», mens design.md sier
#   at «overbooking» skal hete «antall tilbud som skal gis». Hvilken gjelder? Fila følger design.md.
# - Fire tall i fire tabeller (antall studieplasser, ønsket antall deltakere, overbook, ønsket antall tilbud).
#   Hvilket er fasit, og hvilke skal opptaksforvalter se?
# - Negative tall: skal det være mulig å redusere antall aktive tilbud i en suppleringsrunde?
#   Ikke verifisert mot dagens løsning.
# - Kan opptaksforvalter ved forvaltende organisasjon endre tallene på vegne av lærestedet,
#   også utenfor lærestedenes periode?
# - Merbehov senere: nøkkeltall fra fjorårets opptak med forslag til antall ønsket ja-svar.
