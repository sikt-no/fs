# language: no
@OPT-BEH-BEH-038 @must @draft @scope-automatisk-grunnlag-og-poeng @ref-OPT-BEH-BEH-030 @ref-OPT-BEH-BEH-033
Egenskap: Importere resultater fra høyere utdanning
  Som saksbehandler
  ønsker jeg at søkerens resultater fra høyere utdanning importeres av seg selv
  slik at poengene for høyere utdanning regnes ut fra resultatene søkeren har.

  Resultatene hentes fra en annen tjeneste enn KREG. Poengene for høyere utdanning
  (OPT-BEH-BEH-028) bruker studiepoengene, nivået, om emnet er bestått, lærestedet,
  og om emnet er innpasset fra et annet lærested.
  # ÅPNE SPØRSMÅL:
  # - Hva heter tjenesten for resultater fra høyere utdanning?
  # - Hentes resultatene også når saken opprettes, som vitnemålene fra KREG (OPT-BEH-BEH-030)?
  # - Hva skjer når tjenesten ikke svarer? Behandles søknaden videre, som når KREG ikke svarer?
  # - Kan et resultat trekkes tilbake i tjenesten, og skal det da fjernes fra opptakssystemet?
  # Når det er avklart hvordan importen skal fungere, lages en flyt i krav/_Flyter/10 Opptaksløpet:
  # importen henter resultatene, nye resultater for søkeren lagres, og poengene for høyere utdanning
  # regnes ut på nytt med poengalgoritmen (OPT-BEH-BEH-028).

  Regel: Resultatene importeres jevnlig for aktive søkere
    # Hvor ofte importen kjører, står i OPT-BEH-BEH-033.
    # Avklart 04.11.2026: som importen fra KREG gjelder importen aktive søkere: søkere med en søknad
    # som ikke er trukket, i et opptak som ikke er avsluttet. Hendelsene for den automatiske
    # saksbehandlingen (OPT-OVO-FRI-001) gjelder ikke importen.

    Scenario: Søkeren får et nytt resultat etter at søknaden er levert
      Gitt at søkeren har levert søknaden
      Og at opptaket ikke er avsluttet
      Og at søkeren har fått et nytt resultat fra høyere utdanning
      Når importen av resultater fra høyere utdanning kjører
      Så er resultatet importert uten at søkeren har endret søknaden

    Scenario: Resultatene importeres ikke etter at opptaket er avsluttet
      Gitt at opptaket er avsluttet
      Og at søkeren har fått et nytt resultat fra høyere utdanning
      Når importen av resultater fra høyere utdanning kjører
      Så er resultatet ikke importert

    @depends-on-OPT-OVO-FRI-001
    Scenario: Resultatene importeres etter at den automatiske saksbehandlingen er avsluttet
      Gitt at «Automatisk saksbehandling avsluttes» er "2027-07-15 12:00" i opptaket
      Og at klokken er 2027-07-15 kl. 12:01
      Og at opptaket ikke er avsluttet
      Og at søkeren har fått et nytt resultat fra høyere utdanning
      Når importen av resultater fra høyere utdanning kjører
      Så er resultatet importert

  Regel: Opplysningene poengene for høyere utdanning trenger, importeres

    Scenario: Opplysningene om et emne importeres
      Gitt at søkeren har bestått et emne ved et lærested
      Når importen av resultater fra høyere utdanning kjører
      Så er disse opplysningene om emnet importert:
        | opplysning                                     |
        | studiepoeng                                    |
        | om emnet er høyere utdanning eller fagskole    |
        | om emnet er bestått                            |
        | lærestedet                                     |
        | om emnet er innpasset, og fra hvilket lærested |
