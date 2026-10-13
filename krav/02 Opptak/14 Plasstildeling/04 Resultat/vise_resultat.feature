# language: no
# GitHub: #585
@OPT-PLA-RES-001 @must @draft
Egenskap: Vise resultatet av plasstildelingen
  Som saksbehandler
  ønsker jeg å se resultatet av en plasstildeling før den publiseres
  slik at jeg kan kvalitetssikre resultatet og forklare det i etterkant.

  # Kilde: tasks/opptak/plasstildeling/design.md (mål, del 2 om tilgangsstyring og forklarbarhet),
  # oppgave.md (oppgave 7) og Confluence «Opprette og konfigurere opptakskjøringsrunde» (steg 2 og 3).
  # Opptaksforvalter utfører plasstildelingen. Saksbehandler kvalitetssikrer resultatet (design.md, roller).
  # Status i kode: gjenstår.

  Bakgrunn:
    Gitt at saksbehandler ved lærestedet er innlogget
    Og at plasstildelingsrunden "Hovedrunde" i opptaket "Samordna opptak 2027" har en plasstildeling som ikke er publisert

  Regel: Saksbehandler ser ett tydelig resultat per søknad

    Scenariomal: Resultat for en søknad
      Gitt at søkeren "Kari Nordmann" fikk <resultat> på "Sykepleie, høst 2027"
      Når saksbehandler ser resultatet av plasstildelingen
      Så vises "<visning>" for søknaden til "Sykepleie, høst 2027"

      Eksempler:
        | resultat                   | visning                    |
        | tilbud                     | Tilbud                     |
        | ventelisteplass nummer 12  | Venteliste, nummer 12      |
        | bortfall                   | Bortfall                   |
        | avslag                     | Avslag                     |

  Regel: Saksbehandler ser totaltall for plasstildelingen

    Scenario: Totaltall for plasstildelingen
      Når saksbehandler ser resultatet av plasstildelingen
      Så ser saksbehandler disse totaltallene
        | Totaltall                     |
        | Planlagte studieplasser       |
        | Tilbud                        |
        | Tilbud på første prioritet    |
        | Søkere på venteliste          |

    Scenario: Resultat per utdanningstilbud
      Når saksbehandler velger utdanningstilbudet "Sykepleie, høst 2027" i resultatet
      Så ser saksbehandler tilbud, venteliste og poenggrense per utdanningskvote

  Regel: Det kan spores at en plass kom via plassflyt

    Scenario: Tilbud gitt via plassflyt
      Gitt at søkeren "Kari Nordmann" fikk tilbud i "Ordinær" på en plass som fløt fra "Førstegangsvitnemål"
      Når saksbehandler ser resultatet for søkeren
      Så ser saksbehandler at plassen kom fra utdanningskvoten "Førstegangsvitnemål"

  Regel: Saksbehandler ser bare søkere til egne utdanningstilbud

    # design.md del 2: tilgang i dag er alt-eller-ingenting. Inndeling per organisasjon er et personvernkrav.
    Scenario: Resultat for egne utdanningstilbud
      Gitt at saksbehandler har tilgang fra "Universitetet i Bergen"
      Når saksbehandler ser resultatet av plasstildelingen
      Så ser saksbehandler bare søkere til utdanningstilbud ved "Universitetet i Bergen"

  @openquestion
  Regel: Lærestedene kontrollerer resultatet før publisering i samordna opptak

    # ÅPNE SPØRSMÅL:
    # - Beskrevet i Confluence «Opprette og konfigurere opptakskjøringsrunde» (mai 2026) og
    #   «Leveranse: Plasstildeling» (godkjenne eller avslå resultatet), men ikke i design.md.
    #   Er dette med for 2027?
    # - Gjelder kontrollen også lokale opptak, der lærestedet selv er forvaltende organisasjon?
    Scenario: Lærested avviser resultatet
      Gitt at resultatet er sendt til lærestedene for kontroll
      Når saksbehandler ved lærestedet avviser resultatet for "Sykepleie, høst 2027" med en begrunnelse
      Så ser opptaksforvalter ved forvaltende organisasjon at resultatet er avvist med begrunnelsen

    Scenario: Publisering selv om et lærested har avvist
      Gitt at ett lærested har avvist resultatet
      Når opptaksforvalter ved forvaltende organisasjon publiserer plasstildelingen
      Så blir plasstildelingen publisert
      Og lærestedets status «ikke godkjent» står uendret

# ÅPNE SPØRSMÅL:
# - Tilgangsstyring for opptaksforvalter i samordna opptak: skal opptaksforvalter ved ett lærested
#   se resultater for alle utdanningstilbud i opptaket, eller bare egne? design.md kaller dette et
#   personvernfunn (del 2). Inndeling per organisasjon gjelder også opptaksforvalter, ikke bare saksbehandler.
# - Når en søker har både et tilbud og et kansellert resultat på samme utdanningstilbud, hva skal vises?
# - Resultatet lagres i dag to steder (per plasstildeling og på søknadsalternativet). Hvilket er fasit
#   for visningen i saksbehandlingen?
# - Skal saksbehandler kunne sammenligne to plasstildelinger i samme plasstildelingsrunde (prøvetildelinger)?
# - Skal oppsummeringsbildet i saksbehandlingen vise status per søknadsalternativ fra plasstildelingen?
#   (Confluence, raffinering 2026-09-08, oppgave 6)
# - Tilgang til plasstildelingen er i dag gitt bare til rollen opptaksleder, og gir innsyn i alle søkere
#   i opptaket. Skal saksbehandler ha tilgang, slik brukerhistorien sier?
# - Uten tilgang ser brukeren i dag en tom liste, ikke en feilmelding. Da kan ingen se forskjell på
#   «ingen resultater» og «ingen tilgang». Hva skal brukeren se?
# - Antall tilbud som skal gis krever i dag tilgangen til å se opptaket. Med bare tilgang til plasstildelingen
#   vises 0. Skal tilgangen til plasstildelingen være nok?
#
# Kilde: også Confluence «Plasstildelingsløpet i Opptak» (kap. 8 og 10).
