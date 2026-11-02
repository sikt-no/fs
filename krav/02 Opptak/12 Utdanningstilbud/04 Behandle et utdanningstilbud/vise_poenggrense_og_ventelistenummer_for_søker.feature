# language: no
@OPT-OPT-UTD-029 @should @planned @scope-utdanningstilbud-2027
Egenskap: Vise poenggrense og ventelistenummer for søker
  Som opptaksforvalter
  ønsker jeg å bestemme om søkere skal se poenggrensen og ventelistenummeret sitt for utdanningstilbudet
  slik at søkerne får informasjonen som passer for utdanningstilbudet.

  # Kilde: Figma, FS Admin - Seksjon Opptak, node 18797:108875 (Opptaksinnstillinger, Søknadsprosess).
  # Flyttet hit fra opptaksinnstillinger_utdanningstilbud.feature (OPT-OPT-UTD-004) 2026-11-02.

  # AVKLART 2026-11-02: Søkeren ser poenggrensen og ventelistenummeret bare i resultatet i Min kompetanse,
  # etter at plasstildelingen er publisert. Hva søkeren ser, står i OPT-PLA-RES-002.
  # AVKLART 2026-11-02: Poenggrensen er poenggrensen fra plasstildelingen, per utdanningskvote. Innstillingen
  # gjelder ikke poenggrensen for tidlig opptak, som søkeren ser i se_svar_på_tidlig_opptak.feature.

  @draft @openquestion
  Regel: Opptaksforvalter bestemmer om poenggrensen vises for søker
    # ÅPNE SPØRSMÅL:
    # - Er det lov å overstyre visningen for søkere i samordna opptak? Bør dette være en opptaksinnstilling i stedet?

    Scenario: Poenggrensen vises for søker som standard
      Når opptaksforvalter legger til utdanningstilbudet "Sykepleie, høst 2027" i opptaket
      Så er det valgt at poenggrense skal vises for søkere på utdanningstilbudet "Sykepleie, høst 2027"

    Scenario: Velge å skjule poenggrensen for søker
      Når opptaksforvalter angir at poenggrense ikke skal vises for søkere på utdanningstilbudet "Sykepleie, høst 2027"
      Så ser søkerne ikke poenggrensen for "Sykepleie, høst 2027"

  @draft @openquestion
  Regel: Opptaksforvalter bestemmer om ventelistenummeret vises for søker
    # ÅPNE SPØRSMÅL:
    # - Er det lov å overstyre visningen for søkere i samordna opptak? Bør dette være en opptaksinnstilling i stedet?

    Scenario: Ventelistenummeret vises for søker som standard
      Når opptaksforvalter legger til utdanningstilbudet "Sykepleie, høst 2027" i opptaket
      Så er det valgt at ventelistenummer skal vises for søkere på utdanningstilbudet "Sykepleie, høst 2027"

    Scenario: Velge å skjule ventelistenummeret for søker
      Når opptaksforvalter angir at ventelistenummer ikke skal vises for søkere på utdanningstilbudet "Sykepleie, høst 2027"
      Så ser søkerne ikke ventelistenummeret sitt for "Sykepleie, høst 2027"
