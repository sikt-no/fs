# language: no
# GitHub: #585
@OPT-PLA-RES-003 @must @draft
Egenskap: Se publisert resultat av plasstildelingen
  Som saksbehandler
  ønsker jeg å se det publiserte resultatet av plasstildelingen for søknadene organisasjonen behandler
  slik at jeg kan forklare resultatet og følge opp søkerne.

  # Delt ut fra vise_resultat.feature 2026-10-14. Før publisering ser bare opptaksforvalter
  # plasstildelingen (vise_resultat.feature). Etter publisering ser saksbehandler resultatet for
  # søknadene organisasjonen er saksbehandlende organisasjon for. Det søkeren ser, står i publisere_resultat.feature.
  # Status i kode: gjenstår.

  Bakgrunn:
    Gitt at saksbehandler ved lærestedet er innlogget
    Og at plasstildelingen i plasstildelingsrunden "Hovedrunde" i opptaket "Samordna opptak 2027" er publisert

  Regel: Saksbehandler ser det publiserte resultatet per søknad

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

    @openquestion
    Scenario: Saksbehandler ser resultatet per utdanningskvote
      # ÅPNE SPØRSMÅL:
      # - Er «kansellert» et eget resultat, eller er det bortfall? Resultatlista i gjennomføre_plasstildeling.feature
      #   har tilbud, venteliste, bortfall og avslag, og kaller dette bortfall.
      Gitt at søkeren "Kari Nordmann" fikk tilbud i "Førstegangsvitnemål" og kansellert i "Ordinær" på "Sykepleie, høst 2027"
      Når saksbehandler ser resultatet for søkeren
      Så ser saksbehandler tilbud i "Førstegangsvitnemål" og kansellert i "Ordinær"

    Scenario: Tilbud gitt via plassflyt
      Gitt at søkeren "Kari Nordmann" fikk tilbud i "Ordinær" på en plass som fløt fra "Førstegangsvitnemål"
      Når saksbehandler ser resultatet for søkeren
      Så ser saksbehandler at plassen kom fra utdanningskvoten "Førstegangsvitnemål"

  Regel: Saksbehandler ser poenggrense og totaltall for det publiserte resultatet

    Scenario: Poenggrense per utdanningskvote
      Når saksbehandler velger utdanningstilbudet "Sykepleie, høst 2027" i det publiserte resultatet
      Så ser saksbehandler tilbud, venteliste og poenggrense per utdanningskvote

    Scenario: Totaltall for det publiserte resultatet
      Når saksbehandler ser resultatet av plasstildelingen
      Så ser saksbehandler disse totaltallene
        | Totaltall                     |
        | Planlagte studieplasser       |
        | Tilbud                        |
        | Tilbud på første prioritet    |
        | Søkere på venteliste          |

  Regel: Saksbehandler ser søknadene organisasjonen er saksbehandlende organisasjon for og søknadene til utdanningstilbudene organisasjonen tilbyr

    # AVKLART 2026-10-14: Gjelder hele tiden, ikke bare etter publisering. Tilbyderen ser også søknadene til
    # utdanningstilbudene sine når en annen organisasjon saksbehandler dem.

    # design.md del 2: tilgang i dag er alt-eller-ingenting. Inndeling per organisasjon er et personvernkrav.
    # Hvilken organisasjon som er saksbehandlende organisasjon, bestemmes av reglene for saksbehandlertildeling, se
    # 13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature.
    Scenario: Resultat for søknad organisasjonen er saksbehandlende organisasjon for
      Gitt at saksbehandler har tilgang fra "Universitetet i Bergen"
      Og at "Universitetet i Bergen" er saksbehandlende organisasjon for søknaden til "Kari Nordmann" på "Sykepleie, høst 2027" ved "Høgskulen på Vestlandet"
      Når saksbehandler ser resultatet av plasstildelingen
      Så ser saksbehandler resultatet for søknaden til "Kari Nordmann"

    Scenario: Resultat for søknad organisasjonen ikke er saksbehandlende organisasjon for
      Gitt at saksbehandler har tilgang fra "Universitetet i Bergen"
      Og at "Universitetet i Bergen" ikke er saksbehandlende organisasjon for søknaden til "Ola Nordmann" på "Vernepleie, høst 2027" ved "Høgskulen på Vestlandet"
      Når saksbehandler ser resultatet av plasstildelingen
      Så ser saksbehandler ikke søknaden til "Ola Nordmann"

    Scenario: Saksbehandler ved tilbyderen ser søknadene til utdanningstilbudene organisasjonen tilbyr
      Gitt at saksbehandler har tilgang fra "Universitetet i Bergen", som tilbyr "Medisin, høst 2027"
      Og at "Universitetet i Oslo" er saksbehandlende organisasjon for søknaden til "Ola Nordmann" på "Medisin, høst 2027"
      Når saksbehandler ser resultatet av plasstildelingen
      Så ser saksbehandler resultatet for søknaden til "Ola Nordmann" på "Medisin, høst 2027"

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
