# language: no
# GitHub: #585
@OPT-PLA-RES-001 @must @draft @scope-plasstildeling-2027
Egenskap: Se resultatet av plasstildelingen før publisering
  Som opptaksforvalter
  ønsker jeg å se resultatet av en plasstildeling før den publiseres
  slik at jeg kan kvalitetssikre resultatet før søkerne og saksbehandlerne får se det.

  # Kilde: tasks/opptak/plasstildeling/design.md (mål, del 2 om tilgangsstyring og forklarbarhet),
  # oppgave.md (oppgave 7) og Confluence «Opprette og konfigurere opptakskjøringsrunde» (steg 2 og 3).
  # AVKLART 2026-10-14: Før publisering ser bare opptaksforvalter plasstildelingen: hos opptakets
  # forvalter alle søknadene, og ved et deltakende lærested søknadene organisasjonen er saksbehandlende organisasjon for.
  # Det saksbehandler ser etter publisering, står i se_publisert_resultat.feature. Det søkeren ser,
  # står i publisere_resultat.feature.
  # Status i kode: gjenstår.

  Bakgrunn:
    Gitt at opptakets forvalter er innlogget
    Og at plasstildelingsrunden "Hovedrunde" i opptaket "Samordna opptak 2027" har en plasstildeling som ikke er publisert

  Regel: Opptaksforvalter ser ett tydelig resultat per søknad

    Scenariomal: Resultat for en søknad
      Gitt at søkeren "Kari Nordmann" fikk <resultat> på "Sykepleie, høst 2027"
      Når opptaksforvalter ser resultatet av plasstildelingen
      Så vises "<visning>" for søknaden til "Sykepleie, høst 2027"

      Eksempler:
        | resultat                   | visning                    |
        | tilbud                     | Tilbud                     |
        | ventelisteplass nummer 12  | Venteliste, nummer 12      |
        | bortfall                   | Bortfall                   |
        | avslag                     | Avslag                     |

    @openquestion
    Scenario: Opptaksforvalter ser resultatet per utdanningskvote
      # ÅPNE SPØRSMÅL:
      # - Er «kansellert» et eget resultat, eller er det bortfall? Resultatlista i gjennomføre_plasstildeling.feature
      #   har tilbud, venteliste, bortfall og avslag, og kaller dette bortfall.
      Gitt at søkeren "Kari Nordmann" fikk tilbud i "Førstegangsvitnemål" og kansellert i "Ordinær" på "Sykepleie, høst 2027"
      Når opptaksforvalter ser resultatet for søkeren
      Så ser opptaksforvalter tilbud i "Førstegangsvitnemål" og kansellert i "Ordinær"

  Regel: Opptaksforvalter ser totaltall for plasstildelingen

    Scenario: Totaltall for plasstildelingen
      Når opptaksforvalter ser resultatet av plasstildelingen
      Så ser opptaksforvalter disse totaltallene
        | Totaltall                     |
        | Planlagte studieplasser       |
        | Tilbud                        |
        | Tilbud på første prioritet    |
        | Søkere på venteliste          |

    Scenario: Resultat per utdanningstilbud
      Når opptaksforvalter velger utdanningstilbudet "Sykepleie, høst 2027" i resultatet
      Så ser opptaksforvalter tilbud, venteliste og poenggrense per utdanningskvote

    # AVKLART 2026-10-14: Tilgang til plasstildelingen er nok. I dag krever tallet tilgang til opptaket, og ellers vises 0.
    Scenario: Antall tilbud som skal gis vises med tilgang til plasstildelingen
      Gitt at opptaksforvalter ved lærestedet har tilgang til plasstildelingen, men ikke til opptaket
      Og at antall tilbud som skal gis i "Sykepleie, høst 2027" i "Hovedrunde" er 30
      Når opptaksforvalter velger utdanningstilbudet "Sykepleie, høst 2027" i resultatet
      Så ser opptaksforvalter at antall tilbud som skal gis er 30

    # AVKLART 2026-10-15 (domeneekspert): Lærestedene skal se antall tilbud som skal gis, og om utdanningstilbudet
    # gir tilbud til alle kvalifiserte.
    Scenario: Tilbud til alle kvalifiserte vises i resultatet
      Gitt at utdanningstilbudet "Vernepleie, høst 2027" skal gi tilbud til alle kvalifiserte
      Når opptaksforvalter ved lærestedet velger utdanningstilbudet "Vernepleie, høst 2027" i resultatet
      Så ser opptaksforvalter at utdanningstilbudet gir tilbud til alle kvalifiserte

  Regel: Det kan spores at en plass kom via plassflyt

    Scenario: Tilbud gitt via plassflyt
      Gitt at søkeren "Kari Nordmann" fikk tilbud i "Ordinær" på en plass som fløt fra "Førstegangsvitnemål"
      Når opptaksforvalter ser resultatet for søkeren
      Så ser opptaksforvalter at plassen kom fra utdanningskvoten "Førstegangsvitnemål"

  Regel: Bare opptaksforvalter ser plasstildelingen før den er publisert

    # AVKLART 2026-10-14: Organisasjonen ser søknadene den er saksbehandlende organisasjon for, og i tillegg alle
    # søknadene til utdanningstilbudene den tilbyr, også når en annen organisasjon saksbehandler dem.

    # design.md del 2: tilgang i dag er alt-eller-ingenting. Inndeling per organisasjon er et personvernkrav.
    # Hvilken organisasjon som er saksbehandlende organisasjon, bestemmes av reglene for saksbehandlertildeling, se
    # 13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature.
    Scenario: Opptaksforvalter ved deltakende organisasjon ser resultatet for søknadene organisasjonen behandler
      Gitt at opptaksforvalter har tilgang fra "Universitetet i Bergen", som deltar i opptaket
      Og at "Universitetet i Bergen" er saksbehandlende organisasjon for søknaden til "Kari Nordmann"
      Og at "Universitetet i Bergen" ikke er saksbehandlende organisasjon for søknaden til "Ola Nordmann" på "Vernepleie, høst 2027" ved "Høgskulen på Vestlandet"
      Når opptaksforvalter ser resultatet av plasstildelingen
      Så ser opptaksforvalter resultatet for søknaden til "Kari Nordmann"
      Men opptaksforvalter ser ikke søknaden til "Ola Nordmann"

    Scenario: Opptaksforvalter ved tilbyderen ser søknadene til utdanningstilbudene organisasjonen tilbyr
      Gitt at opptaksforvalter har tilgang fra "Universitetet i Bergen", som tilbyr "Medisin, høst 2027"
      Og at "Universitetet i Oslo" er saksbehandlende organisasjon for søknaden til "Ola Nordmann" på "Medisin, høst 2027"
      Når opptaksforvalter ser resultatet av plasstildelingen
      Så ser opptaksforvalter resultatet for søknaden til "Ola Nordmann" på "Medisin, høst 2027"

    Scenario: Opptakets forvalter ser alle søknadene
      Gitt at opptaksforvalter har tilgang som opptakets forvalter
      Når opptaksforvalter ser resultatet av plasstildelingen
      Så ser opptaksforvalter resultatet for alle søknadene i opptaket

    Scenario: Saksbehandler ser ikke plasstildelingen før den er publisert
      Gitt at saksbehandler ved lærestedet er innlogget
      Når saksbehandler ser opptaket "Samordna opptak 2027"
      Så ser saksbehandler ikke resultatet av plasstildelingen i "Hovedrunde"

    # AVKLART 2026-10-14: Manglende tilgang skjuler resultatet (designmønsteret for krav). I dag ser brukeren en tom liste.
    Scenario: Bruker uten tilgang til plasstildelingen
      Gitt at brukeren ikke har tilgang til plasstildelingen i opptaket "Samordna opptak 2027"
      Når brukeren ser opptaket "Samordna opptak 2027"
      Så ser brukeren ikke resultatet av plasstildelingen

  Regel: Lærestedene kontrollerer resultatet før plasstildelingsrunden publiseres

    # AVKLART 2026-10-14 (domeneekspert): Kontrollen er at lærestedene og opptakets
    # forvalter har en oversiktlig måte å se om resultatet i runden er korrekt før det
    # publiseres. Ved større feil endres antall tilbud som skal gis eller tilsvarende
    # innstillinger, og plasstildelingen kjøres på nytt i runden før en ny kontroll.
    # Fram til publisering kan lærestedene også endre saksbehandlingen (for eksempel
    # tilbudsgaranti eller ny poengberegning). Godkjenning eller avvisning med status er ikke med.
    # Kontrollen gjelder både samordna og lokale opptak. Det er opptaksforvalter ved lærestedet som kontrollerer.
    # AVKLART 2026-10-15 (domeneekspert): Lærestedene kan endre antall tilbud som skal gis og tilbud til alle
    # kvalifiserte bare i perioden som er satt på plasstildelingsrunden (antall_tilbud_som_skal_gis.feature).
    # Etter perioden ser lærestedene bare resultatet, og melder feil til opptakets forvalter (HK-dir) på
    # e-post. Opptakets forvalter kan fortsatt endre antall tilbud, og kan utvide perioden på runden.
    # Saksbehandlingen kan lærestedene endre fram til publisering, også etter perioden.
    Scenario: Lærestedet kontrollerer resultatet før publisering
      Gitt at plasstildelingen i "Hovedrunde" ikke er publisert
      Når opptaksforvalter ved lærestedet ser resultatet av plasstildelingen
      Så ser opptaksforvalter resultatet for søknadene organisasjonen er saksbehandlende organisasjon for, og for søknadene til utdanningstilbudene organisasjonen tilbyr
      Og søkerne og saksbehandlerne ser ikke resultatet

    Scenario: Ny plasstildeling etter endret antall tilbud
      Gitt at plasstildelingen i "Hovedrunde" ikke er publisert
      Og at antall tilbud som skal gis i "Sykepleie, høst 2027" i "Hovedrunde" er endret fra 30 til 35
      Når opptakets forvalter starter en ny plasstildeling i "Hovedrunde"
      Så bruker den nye plasstildelingen 35 tilbud for "Sykepleie, høst 2027"
      Og lærestedene kan kontrollere resultatet av den nye plasstildelingen

  Regel: Plasstildelinger i samme plasstildelingsrunde kan sammenlignes

    Scenario: Sammenligne to plasstildelinger i samme plasstildelingsrunde
      Gitt at plasstildelingsrunden "Hovedrunde" har to plasstildelinger som ikke er publisert
      Når opptaksforvalter sammenligner de to plasstildelingene for "Sykepleie, høst 2027"
      Så ser opptaksforvalter tilbud, venteliste og poenggrense per utdanningskvote for hver av plasstildelingene

# Resultatet lagres i dag to steder (per plasstildeling og på søknadsalternativet). Hvor resultatet
# lagres, avgjør teamet (avklart 2026-10-14).
#
# Kilde: også Confluence «Plasstildelingsløpet i Opptak» (kap. 8 og 10).
