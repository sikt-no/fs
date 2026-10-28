# language: no
# GitHub: #586
@OPT-PLA-RES-002 @must @draft @scope-plasstildeling-2027
Egenskap: Publisere resultatet til søkerne
  Som opptaksforvalter
  ønsker jeg å bestemme når resultatet av en plasstildeling blir synlig for søkerne
  slik at resultatet kan kvalitetssikres før søkerne får svar.

  # Kilde: tasks/opptak/plasstildeling/design.md (beslutning 2, prinsipp 4, del 2 «Søkeren skal kunne forstå svaret sitt»),
  # oppgave.md (oppgave 8) og Confluence «2026-09-08 Raffinering plasstildeling» (oppgave 7).
  # Beregning og publisering er to separate steg. Det gjør ubegrensede prøvetildelinger mulig.
  # Melding til søker: se 13 Søknad og saksbehandling/01 Søknad/mine_meldinger.feature.
  # Status i kode: delvis. Ventelistenummeret når ikke fram til søkeren.

  Bakgrunn:
    Gitt at opptakets forvalter er innlogget
    Og at plasstildelingsrunden "Hovedrunde" i opptaket "Samordna opptak 2027" har en plasstildeling som ikke er publisert

  Regel: Søkerne ser ikke resultatet før det er publisert

    Scenario: Prøvetildeling som ikke publiseres
      Når opptaksforvalter lar være å publisere plasstildelingen
      Så ser ingen søkere resultatet av plasstildelingen

    Scenario: Publisere plasstildeling
      Når opptaksforvalter publiserer plasstildelingen
      Så ser søkerne resultatet sitt i Min kompetanse
      Og søkere med tilbud får melding om at svar foreligger med svarfristen for plasstildelingsrunden

    @openquestion
    Scenario: Bare én publisert plasstildeling per plasstildelingsrunde
      # ÅPNE SPØRSMÅL:
      # - Kan en plasstildelingsrunde ha mer enn én publisert plasstildeling, for eksempel hvis en feil oppdages etter publisering?
      Gitt at plasstildelingsrunden "Hovedrunde" har en publisert plasstildeling
      Når opptaksforvalter vil publisere en annen plasstildeling i "Hovedrunde"
      Så blir den andre plasstildelingen ikke publisert

  Regel: Opptaksforvalter velger hvilken plasstildeling i plasstildelingsrunden som publiseres

    # Sammenligningen av plasstildelinger står i vise_resultat.feature.
    Scenario: Publisere plasstildelingen med ønsket resultat
      Gitt at plasstildelingsrunden "Hovedrunde" har plasstildelingene "Prøve 1" og "Prøve 2", som ikke er publisert
      Og at opptaksforvalter har sammenlignet "Prøve 1" og "Prøve 2"
      Når opptaksforvalter publiserer "Prøve 2"
      Så ser søkerne resultatet fra "Prøve 2"
      Og "Prøve 1" blir ikke publisert

  @openquestion
  Regel: Opptaksforvalter velger tidspunkt for publisering

    # ÅPNE SPØRSMÅL:
    # - Automatisk publisering på tidspunkt er avgrenset bort for 2027 (oppgave.md). Confluence
    #   «Opprette og konfigurere opptakskjøringsrunde» beskriver publisering straks eller planlagt.
    #   Skal planlagt publisering være med?
    Scenario: Planlagt publisering
      Når opptaksforvalter planlegger publisering av plasstildelingen til "2027-07-15 08:00"
      Så ser søkerne resultatet sitt fra "2027-07-15 08:00"

  Regel: Søkeren ser resultatet med begrunnelse

    Scenario: Søker ser vedtak med begrunnelse
      Gitt at plasstildelingen er publisert
      Når søkeren "Kari Nordmann" ser resultatet sitt for "Sykepleie, høst 2027"
      Så ser søkeren disse opplysningene
        | Opplysning                                    |
        | Tilbud, venteliste eller avslag               |
        | Kvalifisering                                 |
        | Rangering                                     |
        | Poenggrense                                   |
        | Organisasjonen som har behandlet søknaden     |
        | Svarfrist                                     |

    Scenario: Søker ser ventelistenummer
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" viser ventelistenummer for søkere
      Og at søkeren "Kari Nordmann" står som nummer 12 på ventelisten
      Når plasstildelingen er publisert
      Så ser søkeren at søkeren står som nummer 12 på ventelisten til "Sykepleie, høst 2027"

    Scenario: Poenggrense skjult for søker
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" ikke viser poenggrense for søkere
      Når plasstildelingen er publisert
      Så ser søkerne ikke poenggrensen for "Sykepleie, høst 2027"

    @openquestion
    Scenario: Søker ser bare tilbudet når en annen utdanningskvote er kansellert
      # ÅPNE SPØRSMÅL:
      # - Er «kansellert» et eget resultat, eller er det bortfall? Resultatlista i gjennomføre_plasstildeling.feature
      #   har tilbud, venteliste, bortfall og avslag, og kaller dette bortfall.
      Gitt at søkeren "Kari Nordmann" konkurrerer om "Sykepleie, høst 2027" i utdanningskvotene "Førstegangsvitnemål" og "Ordinær"
      Og at søkeren fikk tilbud i "Førstegangsvitnemål" og kansellert i "Ordinær"
      Når plasstildelingen er publisert
      Så ser søkeren tilbud på "Sykepleie, høst 2027"
      Men søkeren ser ikke det kansellerte resultatet i "Ordinær"

# ÅPNE SPØRSMÅL:
# - Poenggrensen søkeren ser i dag kommer fra en annen kilde enn plasstildelingen. Vedtaket må
#   begrunnes med poenggrensen fra plasstildelingen (se gjennomføre_plasstildeling.feature).
# - Arv av svartype ved publisering er uavklart (oppgave.md, gap-analyse oppgave 7).
# - Skal søkere få varsel på e-post/SMS ved publisering, og påminnelse før svarfristen? Hører det hjemme i 13 Søknad og saksbehandling/01 Søknad/mine_meldinger.feature?
# - Vedtaksbrev med klagerett: se Confluence «Vedtaksbrev og svar på opptaket». Hvor skal kravet ligge?
# - Hvilke søkere får melding: bare de med tilbud, eller også de på venteliste og med avslag?
# - Publisering kan ikke angres i dag. Svarfristen og publiseringstidspunktet kan nullstilles på plasstildelingsrunden,
#   men plasstildelingen står fortsatt som publisert. Skal det være mulig å angre en publisering?
# - Et søknadsalternativ uten utdanningskvote er ikke med i plasstildelingen, og søkeren får ikke noe svar.
#   Hva skal søkeren se?
#
# AVKLART 2026-10-14: Har søkeren tilbud i én utdanningskvote og kansellert i en annen på samme
# utdanningstilbud, ser søkeren bare tilbudet. I dag ser søkeren «kansellert» (A3, videreført fra admissio).
#
# Kilde: også Confluence «Plasstildelingsløpet i Opptak» (kap. 8).
