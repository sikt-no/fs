# language: no
# GitHub: #456
@OPT-SØK-SØK-005 @must @draft
Egenskap: Se svar på søknad om tidlig opptak
  Som søker
  ønsker jeg å se utfallet av tidlig opptak for hvert av søknadsalternativene mine
  slik at jeg tidlig vet hvilke studier jeg er sikret plass på, og rekker å omprioritere søknaden min.

  # Kravet forutsetter at søkeren har søkt om tidlig opptak, at saksbehandler har konkludert,
  # og at tilbudsgarantier for tidlig opptak er tildelt. Vurderingen, konklusjonen og
  # tildelingen står i gi_tilbudsgaranti_ved_tidlig_opptak.feature (OPT-BEH-BEH-007, #654).
  # Publiseringsdatoen og meldingen til søkeren står i
  # krav/02 Opptak/11 Opptak/06 Tidlig opptak/publisere_svar_på_tidlig_opptak.feature.
  # "Tilbudsgaranti gitt av tilbyder" her er det 007 kaller manuell tilbudsgaranti fra T-rolle.
  #
  # Avgrensning: Kravet gjelder kun svaret på tidlig opptak. Andre tilbudsgarantier —
  # særlig reservert studieplass — kommer fra en annen kilde og vises uavhengig av dette
  # svaret. En søker kan derfor se "ikke innvilget" på tidlig opptak og samtidig ha
  # reservert studieplass på samme søknadsalternativ.
  #
  # Svaret bygger kun på tilbudsgarantien for tidlig opptak fra opptaksforvalter. En
  # tilbudsgaranti gitt av tilbyder vises aldri som innvilget tidlig opptak til søkeren.
  Bakgrunn:
    Gitt at søkeren er innlogget

  # "Publisert" betyr at begge forutsetningene er oppfylt — det som inntreffer sist avgjør.
  # Svaret skal aldri bli synlig før det finnes noe å svare på.
  Regel: Svaret på tidlig opptak publiseres når tidligopptaket er gjennomført og publiseringsdatoen er passert

    Scenario: Svaret er ikke synlig før publiseringsdatoen
      Gitt at tidligopptaket er gjennomført
      Og at søkeren har fått tilbudsgaranti for tidlig opptak fra opptaksforvalter
      Men publiseringsdatoen for svar på tidlig opptak er ikke passert
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren svar på tidlig opptak på noen av søknadsalternativene

    Scenario: Svaret er ikke synlig før tidligopptaket er gjennomført
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Men tidligopptaket er ikke gjennomført
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren svar på tidlig opptak på noen av søknadsalternativene

    Scenario: Svaret blir synlig når tidligopptaket er gjennomført og publiseringsdatoen er passert
      Gitt at tidligopptaket er gjennomført
      Og at publiseringsdatoen for svar på tidlig opptak er passert
      Når søkeren åpner søknaden sin
      Så ser søkeren svar på tidlig opptak på hvert av søknadsalternativene sine

  # Dette er noe annet enn at saksbehandler har konkludert med at søkeren ikke deltar.
  # Den søkeren har søkt, og ser "ikke innvilget" på søknadsalternativene sine.
  Regel: Svaret på tidlig opptak vises bare til søkere som har søkt om tidlig opptak

    Scenario: Søkeren har ikke søkt om tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren ikke har søkt om tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser søkeren ingenting om tidlig opptak i søknaden

  Regel: Søkeren er innvilget tidlig opptak på høyst ett søknadsalternativ

    Scenario: Høyst ett søknadsalternativ er innvilget
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren deltar i tidlig opptak på flere av søknadsalternativene sine
      Når søkeren åpner søknaden sin
      Så ser søkeren innvilget tidlig opptak på høyst ett søknadsalternativ

  Regel: Søkeren ser utfallet av tidlig opptak per søknadsalternativ

    Scenario: Søkeren er innvilget tidlig opptak på et søknadsalternativ
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren har tilbudsgaranti for tidlig opptak fra opptaksforvalter på søknadsalternativet "Sykepleie, høst 2027"
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak er innvilget på "Sykepleie, høst 2027"

    # Dekker også søknadsalternativer der det ligger en tilbudsgaranti som ikke gir tilbud,
    # for eksempel et registrert avslag på tidlig opptak. Utfallet for søkeren er det samme.
    Scenario: Søkeren deltok, men nådde ikke opp på et søknadsalternativ
      Gitt at svaret på tidlig opptak er publisert
      Og at søknadsalternativet "Profesjonsstudiet i medisin, høst 2027" tilbyr tidlig opptak
      Og at søkeren deltok i tidlig opptak på dette søknadsalternativet
      Men søkeren er ikke innvilget tidlig opptak på noen av søknadsalternativene sine
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak ikke er innvilget på "Profesjonsstudiet i medisin, høst 2027"

    # Viewet kaller tilstanden "bortfalt". Det ordet brukes ikke mot søker — ordlyden under
    # er den avklarte teksten.
    Scenario: Søkeren er innvilget på et høyere prioritert søknadsalternativ
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren er innvilget tidlig opptak på søknadsalternativet med prioritet 1
      Og at søknadsalternativet "Fysioterapi, høst 2027" har prioritet 3
      Når søkeren åpner søknaden sin
      Så ser søkeren svaret "Du har fått tidlig opptak på høyere prioritet" på søknadsalternativet "Fysioterapi, høst 2027"

    Scenario: Tilbudsgaranti fra tilbyder endrer ikke utfallet på et lavere prioritert søknadsalternativ
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren er innvilget tidlig opptak på søknadsalternativet med prioritet 1
      Og at søknadsalternativet "Fysioterapi, høst 2027" har prioritet 3
      Og at tilbyder har gitt tilbudsgaranti for tidlig opptak på "Fysioterapi, høst 2027"
      Når søkeren åpner søknaden sin
      Så ser søkeren svaret "Du har fått tidlig opptak på høyere prioritet" på søknadsalternativet "Fysioterapi, høst 2027"

    Scenario: Saksbehandler har konkludert med at søkeren ikke deltar i tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at saksbehandler har konkludert med at søkeren ikke deltar i tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak ikke er innvilget på søknadsalternativene sine

    Scenario: Reservert studieplass gir ikke innvilget tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren har reservert studieplass på søknadsalternativet "Sykepleie, høst 2027"
      Men søkeren har ikke tilbudsgaranti for tidlig opptak fra opptaksforvalter på søknadsalternativet
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak ikke er innvilget på "Sykepleie, høst 2027"

    Scenario: Søknadsalternativet tilbyr ikke tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at utdanningstilbudet "Historie, høst 2027" ikke deltar i tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser søkeren at "Historie, høst 2027" ikke tilbyr tidlig opptak

    # Et alternativ lagt til etter at tidligopptaket er gjennomført er i praksis utelukket:
    # gjennomføringen skjer omtrent en måned etter at opptaket har stengt.
    Scenario: Søknadsalternativ lagt til etter fristen for søknad om tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren la til søknadsalternativet "Masterstudiet i rettsvitenskap, høst 2027" etter fristen for søknad om tidlig opptak, men før opptaket stengte
      Når søkeren åpner søknaden sin
      Så ser søkeren svar på tidlig opptak på "Masterstudiet i rettsvitenskap, høst 2027" på lik linje med de andre søknadsalternativene

  Regel: Søkeren ser egen poengsum og poenggrense der søkeren deltok uten å nå opp

    Scenario: Poengsum og poenggrense vises når søkeren deltok og ikke nådde opp
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren deltok i tidlig opptak på søknadsalternativet "Profesjonsstudiet i medisin, høst 2027"
      Men søkeren er ikke innvilget tidlig opptak på noen av søknadsalternativene sine
      Når søkeren åpner søknaden sin
      Så ser søkeren sin egen poengsum på "Profesjonsstudiet i medisin, høst 2027"
      Og søkeren ser poenggrensen for tidlig opptak på "Profesjonsstudiet i medisin, høst 2027"

    Scenario: Poengsum og poenggrense vises ikke når søkeren er innvilget
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren er innvilget tidlig opptak på søknadsalternativet "Sykepleie, høst 2027"
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense på "Sykepleie, høst 2027"

    Scenario: Poengsum og poenggrense vises ikke når søkeren er innvilget på høyere prioritet
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren er innvilget tidlig opptak på søknadsalternativet med prioritet 1
      Og at søknadsalternativet "Fysioterapi, høst 2027" har prioritet 3
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense på "Fysioterapi, høst 2027"

    Scenario: Poengsum og poenggrense vises ikke når søkeren ikke deltar i tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at saksbehandler har konkludert med at søkeren ikke deltar i tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense på noen av søknadsalternativene

    Scenario: Poengsum og poenggrense vises ikke på søknadsalternativer uten tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at utdanningstilbudet "Historie, høst 2027" ikke deltar i tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense på "Historie, høst 2027"

  # Teksten er utledet av utfallene i søknaden, ikke en tekst saksbehandler skriver.
  Regel: Søkeren ser et samlet svar for hele søknaden

    Scenariomal: Samlet svar på søknaden om tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at søkerens samlede utfall i tidlig opptak er "<utfall>"
      Når søkeren åpner søknaden sin
      Så ser søkeren det samlede svaret "<samlet svar>" for søknaden

      Eksempler:
        | utfall                                  | samlet svar                                                                     |
        | innvilget på ett søknadsalternativ      | Du har fått innvilget tidlig opptak                                             |
        | dokumentert grunnlag, nådde ikke opp    | Du har dokumentert grunner for tidlig opptak, men nådde ikke opp i konkurransen  |
        | grunnlaget er ikke godt nok dokumentert | Du har ikke dokumentert grunnlaget ditt godt nok                                 |

  # Saksbehandlerne vurderer hvert sitt søknadsalternativ, så utfallet per søknadsalternativ
  # er aldri tvetydig. Tidligopptakskonklusjonen settes derimot per sak, og én søknad kan ha
  # flere saker — derfor trenger bare det samlede svaret en regel for ulike konklusjoner.
  Regel: Det samlede svaret bygger på det mest positive saksbehandlingsresultatet

    Scenario: Innvilget tidlig opptak går foran et ubehandlet søknadsalternativ
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren er innvilget tidlig opptak på ett søknadsalternativ
      Og at et annet søknadsalternativ ikke er ferdig behandlet
      Når søkeren åpner søknaden sin
      Så ser søkeren det samlede svaret "Du har fått innvilget tidlig opptak" for søknaden

    Scenario: Godkjent grunnlag går foran avslått grunnlag
      Gitt at svaret på tidlig opptak er publisert
      Og at en saksbehandler har konkludert med at søkeren har dokumentert grunnlaget sitt
      Og at en annen saksbehandler har konkludert med at søkeren ikke har dokumentert grunnlaget sitt
      Men søkeren er ikke innvilget tidlig opptak på noen av søknadsalternativene sine
      Når søkeren åpner søknaden sin
      Så ser søkeren det samlede svaret "Du har dokumentert grunner for tidlig opptak, men nådde ikke opp i konkurransen" for søknaden

# ÅPNE SPØRSMÅL:
# - Kravet forutsetter at tildelingen gir hver søker tilbudsgaranti på høyst ett
#   søknadsalternativ — det høyest prioriterte — og at en tilbudsgaranti fra tilbyder der
#   blir en tilbudsgaranti fra opptaksforvalter. STEK-269 avklarer det første: "gir
#   automatikken kun garanti på høyeste relevante prioritet". Men
#   gi_tilbudsgaranti_ved_tidlig_opptak.feature (OPT-BEH-BEH-007, #654) har ingen regel om
#   det — der får alle som deltar og er over poenggrensen garanti. Må samkjøres med #654.
# - Hva skjer med svaret når søkeren trekker søknaden, og hva skjer hvis søknadsalternativet
#   gjenopprettes? Dette er et mer generelt spørsmål om trukne søknader og tilbudsgarantier,
#   og hører sannsynligvis hjemme i et overordnet krav om søknadsbehandling enn her.
# - Skal svaret vises på både norsk og engelsk, på linje med meldingen til søkeren?
