# language: no
# GitHub: #456
@OPT-SØK-SØK-005 @must @draft
Egenskap: Se svar på søknad om tidlig opptak
  Som søker
  ønsker jeg å se utfallet av tidlig opptak for hvert av søknadsalternativene mine
  slik at jeg tidlig vet hvilke studier jeg er sikret plass på, og rekker å omprioritere søknaden min.

  # Kravet forutsetter at søkeren har søkt om tidlig opptak, at saksbehandler har konkludert,
  # og at tilbudsgarantier for tidlig opptak er tildelt. Selve tildelingen er beskrevet i
  # krav/02 Opptak/11 Opptak/06 Tidlig opptak/publisere_svar_på_tidlig_opptak.feature.
  #
  # Avgrensning: Kravet gjelder kun svaret på tidlig opptak. Andre tilbudsgarantier —
  # særlig reservert studieplass — kommer fra en annen kilde og vises uavhengig av dette
  # svaret. En søker kan derfor se "ikke innvilget" på tidlig opptak og samtidig ha
  # reservert studieplass på samme søknadsalternativ.
  Bakgrunn:
    Gitt at søkeren er innlogget

  Regel: Svaret på tidlig opptak blir synlig for søkeren på opptakets publiseringsdato

    Scenario: Svaret er ikke synlig før publiseringsdatoen
      Gitt at publiseringsdatoen for svar på tidlig opptak ikke er passert
      Og at søkeren har fått tilbudsgaranti for tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren svar på tidlig opptak på noen av søknadsalternativene

    Scenario: Svaret blir synlig fra publiseringsdatoen
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Når søkeren åpner søknaden sin
      Så ser søkeren svar på tidlig opptak på hvert av søknadsalternativene sine

  Regel: Søkeren ser utfallet av tidlig opptak per søknadsalternativ

    Scenario: Søkeren er innvilget tidlig opptak på et søknadsalternativ
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at søkeren er innvilget tidlig opptak på søknadsalternativet "Sykepleie, høst 2027"
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak er innvilget på "Sykepleie, høst 2027"

    # Dekker også søknadsalternativer der det ligger en tilbudsgaranti som ikke gir tilbud,
    # for eksempel et registrert avslag på tidlig opptak. Utfallet for søkeren er det samme.
    Scenario: Søkeren deltok, men nådde ikke opp på et søknadsalternativ
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at søknadsalternativet "Profesjonsstudiet i medisin, høst 2027" tilbyr tidlig opptak
      Og at søkeren deltok i tidlig opptak på dette søknadsalternativet
      Men søkeren har ikke fått tilbudsgaranti for tidlig opptak på søknadsalternativet
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak ikke er innvilget på "Profesjonsstudiet i medisin, høst 2027"

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Hvilken formulering skal søkeren se her? Viewet kaller tilstanden "bortfalt", men
    #   det ordet skal ikke brukes i kommunikasjon med søker (notat 2026-09-23).
    #   Formuleringen under er en plassholder til ordlyden er avklart.
    Scenario: Søkeren er innvilget på et høyere prioritert søknadsalternativ
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at søkeren er innvilget tidlig opptak på søknadsalternativet med prioritet 1
      Og at søknadsalternativet "Fysioterapi, høst 2027" har prioritet 3
      Men søkeren har ikke fått tilbudsgaranti for tidlig opptak på "Fysioterapi, høst 2027"
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak ikke gjelder "Fysioterapi, høst 2027" fordi søkeren er innvilget på et høyere prioritert søknadsalternativ

    Scenario: Søknadsalternativet har egen tilbudsgaranti selv om søkeren er innvilget på høyere prioritet
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at søkeren er innvilget tidlig opptak på søknadsalternativet med prioritet 1
      Og at søknadsalternativet "Fysioterapi, høst 2027" har prioritet 3
      Og at tilbyder har gitt tilbudsgaranti for tidlig opptak på "Fysioterapi, høst 2027"
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak er innvilget på "Fysioterapi, høst 2027"

    Scenario: Saksbehandler har konkludert med at søkeren ikke deltar i tidlig opptak
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at saksbehandler har konkludert med at søkeren ikke deltar i tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak ikke er innvilget på søknadsalternativene sine

    Scenario: Reservert studieplass gir ikke innvilget tidlig opptak
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at søkeren har reservert studieplass på søknadsalternativet "Sykepleie, høst 2027"
      Men søkeren har ikke fått tilbudsgaranti for tidlig opptak på søknadsalternativet
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak ikke er innvilget på "Sykepleie, høst 2027"

    Scenario: Søknadsalternativet tilbyr ikke tidlig opptak
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at utdanningstilbudet "Historie, høst 2027" ikke deltar i tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser søkeren at "Historie, høst 2027" ikke tilbyr tidlig opptak

  Regel: Søkeren ser egen poengsum og poenggrense der søkeren deltok uten å nå opp

    Scenario: Poengsum og poenggrense vises når søkeren deltok og ikke nådde opp
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at søkeren deltok i tidlig opptak på søknadsalternativet "Profesjonsstudiet i medisin, høst 2027"
      Men søkeren har ikke fått tilbudsgaranti for tidlig opptak på søknadsalternativet
      Når søkeren åpner søknaden sin
      Så ser søkeren sin egen poengsum på "Profesjonsstudiet i medisin, høst 2027"
      Og søkeren ser poenggrensen for tidlig opptak på "Profesjonsstudiet i medisin, høst 2027"

    Scenario: Poengsum og poenggrense vises ikke når søkeren er innvilget
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at søkeren er innvilget tidlig opptak på søknadsalternativet "Sykepleie, høst 2027"
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense på "Sykepleie, høst 2027"

    Scenario: Poengsum og poenggrense vises ikke når søkeren ikke deltar i tidlig opptak
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at saksbehandler har konkludert med at søkeren ikke deltar i tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense på noen av søknadsalternativene

    Scenario: Poengsum og poenggrense vises ikke på søknadsalternativer uten tidlig opptak
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at utdanningstilbudet "Historie, høst 2027" ikke deltar i tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense på "Historie, høst 2027"

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Hvor hentes teksten i det samlede svaret fra? Saksbehandlers tidligopptakskonklusjon,
  #   eller en generisk tekst som settes sammen av utfallene per søknadsalternativ?
  # - Hva vises når flere saksbehandlere har konkludert ulikt på samme søknad?
  #   Én søknad kan ha flere saker, og sakene kan i teorien ha ulik konklusjon.
  Regel: Søkeren ser et samlet svar for hele søknaden

    Scenariomal: Samlet svar på søknaden om tidlig opptak
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at søkerens samlede utfall i tidlig opptak er "<utfall>"
      Når søkeren åpner søknaden sin
      Så ser søkeren det samlede svaret "<samlet svar>" for søknaden

      Eksempler:
        | utfall                                   | samlet svar                                       |
        | innvilget på minst ett søknadsalternativ | Du er innvilget tidlig opptak                     |
        | deltok, men nådde ikke opp               | Du var med i tidlig opptak, men nådde ikke opp    |
        | grunnlaget er ikke godt nok dokumentert  | Du har ikke dokumentert grunnlaget ditt godt nok  |

# ÅPNE SPØRSMÅL:
# - Hva ser en søker som aldri har søkt om tidlig opptak? Dette er noe annet enn at
#   saksbehandler har konkludert med at søkeren ikke deltar. Forventet er at svaret på
#   tidlig opptak ikke vises i det hele tatt, men dette er ikke bekreftet.
# - Hva skjer med svaret når søkeren trekker søknaden, og hva skjer hvis søknadsalternativet
#   gjenopprettes? Dette er et mer generelt spørsmål om trukne søknader og tilbudsgarantier,
#   og hører sannsynligvis hjemme i et overordnet krav om søknadsbehandling enn her.
# - Hva ser søkeren på et søknadsalternativ som er lagt til etter fristen for tidlig opptak?
#   Uavklart i koordineringsmøtet 2026-09-15.
# - Skal svaret vises på både norsk og engelsk, på linje med meldingen til søkeren?
