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

    Scenario: Saksbehandler ser resultatet per utdanningskvote
      Gitt at søkeren "Kari Nordmann" fikk tilbud i "Førstegangsvitnemål" og kansellert i "Ordinær" på "Sykepleie, høst 2027"
      Når saksbehandler ser resultatet for søkeren
      Så ser saksbehandler tilbud i "Førstegangsvitnemål" og kansellert i "Ordinær"

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

    # AVKLART 2026-10-14: Tilgang til plasstildelingen er nok. I dag krever tallet tilgang til opptaket, og ellers vises 0.
    Scenario: Antall tilbud som skal gis vises med tilgang til plasstildelingen
      Gitt at saksbehandler har tilgang til plasstildelingen, men ikke til opptaket
      Og at antall tilbud som skal gis i "Sykepleie, høst 2027" i "Hovedrunde" er 30
      Når saksbehandler velger utdanningstilbudet "Sykepleie, høst 2027" i resultatet
      Så ser saksbehandler at antall tilbud som skal gis er 30

  Regel: Det kan spores at en plass kom via plassflyt

    Scenario: Tilbud gitt via plassflyt
      Gitt at søkeren "Kari Nordmann" fikk tilbud i "Ordinær" på en plass som fløt fra "Førstegangsvitnemål"
      Når saksbehandler ser resultatet for søkeren
      Så ser saksbehandler at plassen kom fra utdanningskvoten "Førstegangsvitnemål"

  Regel: Saksbehandler ser søknadene organisasjonen har behandlerrolle for

    # design.md del 2: tilgang i dag er alt-eller-ingenting. Inndeling per organisasjon er et personvernkrav.
    # Behandlerrollen bestemmes av reglene for saksbehandlertildeling, se
    # 13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature.
    Scenario: Resultat for søknad organisasjonen har behandlerrolle for
      Gitt at saksbehandler har tilgang fra "Universitetet i Bergen"
      Og at "Universitetet i Bergen" har behandlerrolle for søknaden til "Kari Nordmann" på "Sykepleie, høst 2027" ved "Høgskulen på Vestlandet"
      Når saksbehandler ser resultatet av plasstildelingen
      Så ser saksbehandler resultatet for søknaden til "Kari Nordmann"

    Scenario: Resultat for søknad organisasjonen ikke har behandlerrolle for
      Gitt at saksbehandler har tilgang fra "Universitetet i Bergen"
      Og at "Universitetet i Bergen" ikke har behandlerrolle for søknaden til "Ola Nordmann"
      Når saksbehandler ser resultatet av plasstildelingen
      Så ser saksbehandler ikke søknaden til "Ola Nordmann"

    # AVKLART 2026-10-14: Manglende tilgang skjuler resultatet (designmønsteret for krav). I dag ser brukeren en tom liste.
    Scenario: Bruker uten tilgang til plasstildelingen
      Gitt at brukeren ikke har tilgang til plasstildelingen i opptaket "Samordna opptak 2027"
      Når brukeren ser opptaket "Samordna opptak 2027"
      Så ser brukeren ikke resultatet av plasstildelingen

  Regel: Opptaksforvalter ved deltakende organisasjon ser søknadene organisasjonen har behandlerrolle for

    Scenario: Opptaksforvalter ved deltakende organisasjon ser resultatet for søknadene organisasjonen behandler
      Gitt at opptaksforvalter har tilgang fra "Universitetet i Bergen", som deltar i opptaket
      Og at "Universitetet i Bergen" har behandlerrolle for søknaden til "Kari Nordmann"
      Og at "Universitetet i Bergen" ikke har behandlerrolle for søknaden til "Ola Nordmann"
      Når opptaksforvalter ser resultatet av plasstildelingen
      Så ser opptaksforvalter resultatet for søknaden til "Kari Nordmann"
      Men opptaksforvalter ser ikke søknaden til "Ola Nordmann"

    Scenario: Opptaksforvalter ved forvaltende organisasjon ser alle søknadene
      Gitt at opptaksforvalter har tilgang fra den forvaltende organisasjonen i opptaket
      Når opptaksforvalter ser resultatet av plasstildelingen
      Så ser opptaksforvalter resultatet for alle søknadene i opptaket

  Regel: Lærestedene kontrollerer resultatet før plasstildelingsrunden publiseres

    # AVKLART 2026-10-14 (domeneekspert): Kontrollen er at lærestedene og forvaltende
    # organisasjon har en oversiktlig måte å se om resultatet i runden er korrekt før det
    # publiseres. Ved større feil endres antall tilbud som skal gis eller tilsvarende
    # innstillinger, og plasstildelingen kjøres på nytt i runden før en ny kontroll.
    # Fram til publisering kan lærestedene også endre saksbehandlingen (for eksempel
    # tilbudsgaranti eller ny poengberegning). Godkjenning eller avvisning med status er ikke med.
    # Kontrollen gjelder både samordna og lokale opptak.
    Scenario: Lærestedet kontrollerer resultatet før publisering
      Gitt at plasstildelingen i "Hovedrunde" ikke er publisert
      Når saksbehandler ved lærestedet ser resultatet av plasstildelingen
      Så ser saksbehandler resultatet for søknadene organisasjonen har behandlerrolle for
      Og søkerne ser ikke resultatet

    Scenario: Ny plasstildeling etter endret antall tilbud
      Gitt at plasstildelingen i "Hovedrunde" ikke er publisert
      Og at antall tilbud som skal gis i "Sykepleie, høst 2027" i "Hovedrunde" er endret fra 30 til 35
      Når opptaksforvalter ved forvaltende organisasjon starter en ny plasstildeling i "Hovedrunde"
      Så bruker den nye plasstildelingen 35 tilbud for "Sykepleie, høst 2027"
      Og lærestedene kan kontrollere resultatet av den nye plasstildelingen

  Regel: Plasstildelinger i samme plasstildelingsrunde kan sammenlignes

    Scenario: Sammenligne to plasstildelinger i samme plasstildelingsrunde
      Gitt at plasstildelingsrunden "Hovedrunde" har to plasstildelinger som ikke er publisert
      Når saksbehandler sammenligner de to plasstildelingene for "Sykepleie, høst 2027"
      Så ser saksbehandler tilbud, venteliste og poenggrense per utdanningskvote for hver av plasstildelingene

  Regel: Oppsummeringen av søknaden viser resultatet fra plasstildelingen

    # AVKLART 2026-10-14: Oppsummeringen viser resultatet fra den siste publiserte plasstildelingen.
    # Kilde: Confluence, raffinering 2026-09-08, oppgave 6.
    Scenariomal: Resultat per søknadsalternativ i oppsummeringen
      Gitt at søkeren "Kari Nordmann" fikk <resultat> på "Sykepleie, høst 2027" i den publiserte plasstildelingen i "Hovedrunde"
      Når saksbehandler ser oppsummeringen av søknaden til "Kari Nordmann"
      Så vises "<visning>" for søknadsalternativet "Sykepleie, høst 2027"

      Eksempler:
        | resultat                  | visning               |
        | tilbud                    | Tilbud                |
        | ventelisteplass nummer 12 | Venteliste, nummer 12 |
        | avslag                    | Avslag                |

# Resultatet lagres i dag to steder (per plasstildeling og på søknadsalternativet). Hvor resultatet
# lagres, avgjør teamet (avklart 2026-10-14).
#
# Kilde: også Confluence «Plasstildelingsløpet i Opptak» (kap. 8 og 10).
