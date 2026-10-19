# language: no
# Jira: SHI-710
@OPT-OPT-UTD-026 @must @draft @scope-utdanningstilbud-i-opptak-2027
Egenskap: Fjerne utdanningstilbud fra opptak
  Som opptaksforvalter
  ønsker jeg å fjerne utdanningstilbud som er lagt til i opptaket ved en feil, før opptaket åpner for søknad
  slik at opptaket bare har utdanningstilbudene som skal ha opptak.

  # AVKLART 2026-10-16 (produktleder): «Publisert» betyr her at opptaket har åpnet for søknad.
  # Etter at opptaket har åpnet for søknad, kan utdanningstilbud bare trekkes,
  # se trekke_utdanningstilbud.feature.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  Regel: Utdanningstilbud kan fjernes før opptaket åpner for søknad

    Scenario: Fjerne utdanningstilbud før søknadsåpning
      Gitt at opptaket ikke har åpnet for søknad
      Når opptaksforvalter fjerner utdanningstilbudet "Sykepleie, høst 2027" fra opptaket
      Så er utdanningstilbudet ikke lenger med i opptaket

    Scenario: Fjerne flere utdanningstilbud av gangen før søknadsåpning
      Gitt at opptaket ikke har åpnet for søknad
      Når opptaksforvalter fjerner utdanningstilbudene "Sykepleie, høst 2027" og "Vernepleie, høst 2027" fra opptaket
      Så er begge utdanningstilbudene ikke lenger med i opptaket

  Regel: Utdanningstilbud kan ikke fjernes etter at opptaket har åpnet for søknad

    Scenario: Muligheten til å fjerne utdanningstilbud vises ikke etter søknadsåpning
      Gitt at opptaket har åpnet for søknad
      Når opptaksforvalter ser listen over utdanningstilbud i opptaket
      Så ser ikke opptaksforvalter muligheten til å fjerne utdanningstilbud

    Scenario: Fjerning av utdanningstilbud etter søknadsåpning avvises
      Gitt at opptaket har åpnet for søknad
      Når det sendes en forespørsel om å fjerne utdanningstilbudet "Sykepleie, høst 2027" fra opptaket
      Så avvises forespørselen
      Og utdanningstilbudet er fortsatt med i opptaket

  # AVKLART 2026-10-16 (produktleder): Lærestedet fjerner egne utdanningstilbud fram til redigeringsfristen
  # for utdanningstilbud (11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature).
  # Forvaltende organisasjon kan fjerne alle utdanningstilbud også etter redigeringsfristen, fram til
  # opptaket åpner for søknad.
  Regel: Opptaksforvalter ved deltakende organisasjon kan fjerne egne utdanningstilbud fram til redigeringsfristen

    Scenario: Deltakende organisasjon fjerner eget utdanningstilbud før redigeringsfristen
      Gitt at opptaksforvalter er ved deltakende organisasjon "Universitetet i Oslo"
      Og at redigering av utdanningstilbud er åpen i opptaket
      Når opptaksforvalter fjerner utdanningstilbudet "Sykepleie, høst 2027", som "Universitetet i Oslo" tilbyr
      Så er utdanningstilbudet ikke lenger med i opptaket

    Scenario: Deltakende organisasjon kan ikke fjerne eget utdanningstilbud etter redigeringsfristen
      Gitt at opptaksforvalter er ved deltakende organisasjon "Universitetet i Oslo"
      Og at redigering av utdanningstilbud er stengt i opptaket
      Når opptaksforvalter vil fjerne utdanningstilbudet "Sykepleie, høst 2027", som "Universitetet i Oslo" tilbyr
      Så avvises forespørselen

    Scenario: Deltakende organisasjon kan ikke fjerne utdanningstilbud en annen organisasjon tilbyr
      Gitt at opptaksforvalter er ved deltakende organisasjon "Universitetet i Oslo"
      Når opptaksforvalter vil fjerne utdanningstilbudet "Medisin, høst 2027", som "Universitetet i Bergen" tilbyr
      Så avvises forespørselen

  Regel: Opptaksforvalter ved forvaltende organisasjon kan fjerne utdanningstilbud etter redigeringsfristen

    Scenario: Forvaltende organisasjon fjerner utdanningstilbud etter redigeringsfristen
      Gitt at opptaksforvalter er ved forvaltende organisasjon "HK-dir"
      Og at redigering av utdanningstilbud er stengt i opptaket
      Og at opptaket ikke har åpnet for søknad
      Når opptaksforvalter fjerner utdanningstilbudet "Sykepleie, høst 2027", som "Universitetet i Oslo" tilbyr
      Så er utdanningstilbudet ikke lenger med i opptaket

# ÅPNE SPØRSMÅL:
# - Kan ett og ett utdanningstilbud fjernes, eller bare flere av gangen? Jira nevner bare handlingen for flere av gangen.
