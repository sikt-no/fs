# language: no
# GitHub: #586
@OPT-PLA-RES-002 @must @draft
Egenskap: Publisere resultatet til søkerne
  Som opptaksforvalter
  ønsker jeg å bestemme når resultatet av en plasstildeling blir synlig for søkerne
  slik at resultatet kan kvalitetssikres før søkerne får svar.

  # Kilde: tasks/opptak/plasstildeling/design.md (beslutning 2, prinsipp 4, del 2 «Søkeren skal kunne forstå svaret sitt»),
  # oppgave.md (oppgave 8) og Confluence «2026-09-08 Raffinering plasstildeling» (oppgave 7).
  # Beregning og publisering er to separate steg. Det gjør ubegrensede prøvetildelinger mulig.
  # Melding til søker og vedtaksbrev: se 11 Opptak/05 Tekster/svarmeldingsmal.feature og 09 Kommunikasjon.
  # Status i kode: delvis. Ventelistenummeret når ikke fram til søkeren.

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at runden "Hovedrunde" i opptaket "Samordna opptak 2027" har en plasstildeling som ikke er publisert

  Regel: Søkerne ser ikke resultatet før det er publisert

    Scenario: Prøvetildeling som ikke publiseres
      Når opptaksforvalter lar være å publisere plasstildelingen
      Så ser ingen søkere resultatet av plasstildelingen

    Scenario: Publisere plasstildeling
      Når opptaksforvalter publiserer plasstildelingen
      Så ser søkerne resultatet sitt i Min kompetanse
      Og søkere med tilbud får melding om at svar foreligger med svarfristen for runden

    @openquestion
    Scenario: Bare én publisert plasstildeling per runde
      # ÅPNE SPØRSMÅL:
      # - Kan en runde ha mer enn én publisert plasstildeling, for eksempel hvis en feil oppdages etter publisering?
      Gitt at runden "Hovedrunde" har en publisert plasstildeling
      Når opptaksforvalter vil publisere en annen plasstildeling i runden "Hovedrunde"
      Så blir den andre plasstildelingen ikke publisert

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
      Så ser søkeren at hun står som nummer 12 på ventelisten til "Sykepleie, høst 2027"

    Scenario: Poenggrense skjult for søker
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" ikke viser poenggrense for søkere
      Når plasstildelingen er publisert
      Så ser søkerne ikke poenggrensen for "Sykepleie, høst 2027"

# ÅPNE SPØRSMÅL:
# - Poenggrensen søkeren ser i dag kommer fra en annen kilde enn plasstildelingen. Vedtaket må
#   begrunnes med poenggrensen fra plasstildelingen (se gjennomføre_plasstildeling.feature).
# - Arv av svartype ved publisering er uavklart (oppgave.md, gap-analyse oppgave 7).
# - Skal søkere få varsel på e-post/SMS ved publisering, og påminnelse før svarfristen? Hører det hjemme i 09 Kommunikasjon?
# - Vedtaksbrev med klagerett: se Confluence «Vedtaksbrev og svar på opptaket». Hvor skal kravet ligge?
# - Hvilke søkere får melding: bare de med tilbud, eller også de på venteliste og med avslag?
