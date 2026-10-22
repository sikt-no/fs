# language: no
@OPT-OVO-SAM-001 @must @in-progress @scope-opprette-opptak-2027
Egenskap: Samordna opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å invitere læresteder til å delta
  slik at de kan bidra med utdanningstilbud og behandle søknader.

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet som samordna

  Regel: Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak

    Scenario: Legge til lærested i samordna opptak
      Når opptaksforvalter ved forvaltende organisasjon legger til organisasjonen "Universitetet i Oslo" som deltaker i opptaket
      Så kan opptaksforvalter ved Universitetet i Oslo knytte utdanningstilbud ved Universitetet i Oslo til opptaket
  # Følgevirkninger: Deltakende organisasjoner kan få søknader de er saksbehandlende organisasjon for etter saksbehandlertildelingen
  # Deltakende organisasjoners opptaksforvaltere kan se og vedlikeholde info på egne utdanningstilbud, og saksbehandlere kan se info om egne utdanningstilbud

  Regel: Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud

    Scenario: Organisasjon som ikke deltar kan ikke legge til utdanningstilbud
      Gitt at organisasjonen "NTNU" ikke er lagt til som deltaker i opptaket
      Så kan ikke NTNU knytte utdanningstilbud til opptaket

  # AVKLART 2026-10-16 (produktleder)
  @openquestion
  Regel: Organisasjoner som ikke deltar, kan ikke se opptaket
    # ÅPNE SPØRSMÅL:
    # - Kommentaren etter regelen viser til listevisning_utdanningstilbud.feature i fritekst. Skal regelen
    #   ha @ref-OPT-OPT-UTD-001?

    Scenario: Organisasjon som ikke deltar, ser ikke opptaket
      Gitt at organisasjonen "NTNU" ikke er lagt til som deltaker i opptaket
      Når opptaksforvalter ved NTNU ser listen over opptak
      Så ser ikke opptaksforvalter opptaket "Samordna opptak 2027"

    # AVKLART 2026-10-19 (produkteier, etter akseptansetesten 2.2): Regelen gjelder også når opptaksforvalter
    # går rett til siden til opptaket, ikke bare listen.
    Scenario: Organisasjon som ikke deltar, kan ikke åpne opptaket
      Gitt at organisasjonen "NTNU" ikke er lagt til som deltaker i opptaket
      Når opptaksforvalter ved NTNU går rett til siden til opptaket "Samordna opptak 2027"
      Så ser ikke opptaksforvalter opptaket "Samordna opptak 2027"

  # Hvilke utdanningstilbud en deltakende organisasjon ser i opptaket, står i
  # 12 Utdanningstilbud/02 Utdanningstilbud i opptak/listevisning_utdanningstilbud.feature.

  # AVKLART 2026-10-16 (produktleder)
  # AVKLART 2026-10-19 (produkteier): Etter at søknaden har åpnet, kan utdanningstilbud bare trekkes, ikke fjernes
  # (12 Utdanningstilbud/02 Utdanningstilbud i opptak/fjerne_utdanningstilbud.feature). En deltaker med
  # utdanningstilbud kan derfor ikke fjernes fra opptaket etter søknadsåpning, fordi søknadene gjelder
  # utdanningstilbudene.
  @openquestion
  Regel: En deltakende organisasjon kan ikke fjernes fra opptaket så lenge den har utdanningstilbud i det
    # ÅPNE SPØRSMÅL:
    # - Avklaringen viser til fjerne_utdanningstilbud.feature i fritekst. Skal regelen ha
    #   @ref-OPT-OPT-UTD-026?

    Scenario: Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket
      Gitt at "Universitetet i Oslo" har knyttet utdanningstilbudet "Sykepleie, høst 2027" til opptaket
      Når opptaksforvalter ved forvaltende organisasjon vil fjerne "Universitetet i Oslo" som deltaker i opptaket
      Så avvises forespørselen
      Og opptaksforvalter får beskjed om at utdanningstilbudene til Universitetet i Oslo må fjernes først

    Scenario: Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket
      Gitt at "Universitetet i Oslo" ikke har utdanningstilbud i opptaket
      Når opptaksforvalter ved forvaltende organisasjon fjerner "Universitetet i Oslo" som deltaker i opptaket
      Så er "Universitetet i Oslo" ikke lenger deltaker i opptaket

  @openquestion
  Regel: Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger i opptaket
    # ÅPNE SPØRSMÅL:
    # - Forvaltende organisasjon = eierorganisasjon for det samordna opptaket. Er ordlyden utvetydig nok
    #   når det gjelder tilgangsstyring og roller? Er spørsmålet besvart, fjernes det.

    Scenario: Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger
      Gitt at HK-dir har opprettet og dermed er forvalter av opptaket "Samordna opptak 2027"
      Når opptaksforvalter ved HK-dir åpner opptaket
      Så kan opptaksforvalter ved HK-dir endre innstillinger, frister og regelverk

    # AVKLART 2026-10-19: Opptaksforvalter ved deltakende organisasjon skal ha innsyn i alle frister og innstillinger på opptaket.
    Scenario: Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger
      Gitt at organisasjonen "Universitetet i Oslo" er lagt til som deltaker
      Når opptaksforvalter ved Universitetet i Oslo åpner opptaket
      Så kan opptaksforvalter ved Universitetet i Oslo se alle innstillinger og frister som er satt på opptaket
      Men opptaksforvalter ved Universitetet i Oslo kan ikke endre frister, regelverk eller andre innstillinger

  # AVKLART 2026-10-12: Det er ikke gitt at skillet mellom samordna og lokale opptak skal bevares.
  # Det er derfor nok at brukergrensesnittet ikke gjør det mulig å legge til andre organisasjoner
  # eller sette saksbehandlertildeling i et lokalt opptak. API-et trenger ikke sperre det.
  Regel: I et lokalt opptak kan ikke andre organisasjoner legges til

    Scenario: Lokalt opptak tillater ikke andre organisasjoner
      Gitt at opptaket "Lokalt opptak høst 2027" er opprettet som lokalt
      Så er det ikke mulig å legge til andre organisasjoner som deltakere

  Regel: Kun organisasjoner som finnes i utdanningsregisteret kan legges til som deltakere

    Scenario: Legge til organisasjon som finnes i utdanningsregisteret
      Når opptaksforvalter ved forvaltende organisasjon legger til organisasjonen "Universitetet i Oslo" som deltaker
      Så legges organisasjonen til som deltaker i opptaket

    Scenario: Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til
      Gitt at organisasjonen "Ukjent organisasjon" ikke finnes i utdanningsregisteret
      Så kan organisasjonen "Ukjent organisasjon" ikke legges til som deltaker i opptaket

  Regel: Opptaksforvalter kan begrense hvilke lærestedstyper som får delta i opptaket

    Scenario: Filtrere på universiteter og høyskoler
      Når opptaksforvalter filtrerer på lærestedstype universitet og høyskole
      Så er kun norske universiteter og høyskoler tilgjengelige som deltakere

    Scenario: Filtrere på fagskoler
      Når opptaksforvalter filtrerer på lærestedstype fagskole
      Så er kun norske fagskoler tilgjengelige som deltakere

  # Saksbehandlertildelingen er beskrevet i detalj i tildele_saksbehandlende_organisasjon.feature
  # (@OPT-BEH-BEH-011, PR #684), og løses av Puff.
  # AVKLART 2026-10-19 (produkteier, etter fs-verify, erstatter avklaringen 2026-10-12): I et samordna opptak
  # skal det være mulig å sette innstillinger for saksbehandlertildeling for opptaket, men det løses av Puff i
  # tildele_saksbehandlende_organisasjon.feature. I denne iterasjonen
  # skal opptaksforvalter kunne se saksbehandlertildelingen for opptaket og navigere dit.
  # At feltet «Saksbehandlertildeling» vises skrivebeskyttet på utdanningstilbud i lokale opptak, er ikke
  # prioritert (akseptansetesten 2.11).
  @openquestion
  Regel: Opptaksforvalter ved forvaltende organisasjon kan se og navigere til saksbehandlertildelingen i samordna opptak
    # ÅPNE SPØRSMÅL:
    # - Kommentaren over regelen viser til tildele_saksbehandlende_organisasjon.feature (OPT-BEH-BEH-011) i
    #   fritekst. Skal regelen ha @ref-OPT-BEH-BEH-011?

    Scenario: Se og navigere til saksbehandlertildelingen for opptaket
      Gitt at opptaket "Samordna opptak 2027" er samordna
      Når opptaksforvalter ved forvaltende organisasjon åpner opptaket
      Så ser opptaksforvalter saksbehandlertildelingen for opptaket
      Og opptaksforvalter kan navigere til saksbehandlertildelingen for opptaket

    Scenario: Saksbehandlertildeling er ikke relevant for lokale opptak
      Gitt at opptaket "Lokalt opptak høst 2027" er opprettet som lokalt
      Når opptaksforvalter åpner opptaket
      Så ser ikke opptaksforvalter saksbehandlertildelingen for opptaket
