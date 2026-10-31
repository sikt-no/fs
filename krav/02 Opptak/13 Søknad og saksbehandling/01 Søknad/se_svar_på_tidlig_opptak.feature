# language: no
# GitHub: #456
@OPT-SØK-SØK-012 @must @in-progress
Egenskap: Se svar på søknad om tidlig opptak
  Som søker
  ønsker jeg å se utfallet av tidlig opptak for hvert av søknadsalternativene mine
  slik at jeg tidlig vet hvilke studier jeg er sikret plass på, og rekker å omprioritere søknaden min.

  # Kravet forutsetter at søkeren har søkt om tidlig opptak, at saksbehandler har konkludert,
  # og at tilbudsgarantier for tidlig opptak er tildelt. Vurderingen, konklusjonen og
  # tildelingen står i gi_tilbudsgaranti_ved_tidlig_opptak.feature (OPT-BEH-BEH-007, #654).
  # Publiseringen og meldingen til søkeren står i
  # krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/publisere_svar_på_tidlig_opptak.feature.
  # "Tilbudsgaranti gitt av tilbyder" her er manuell tilbudsgaranti fra tilbyder, se
  # gi_tilbudsgaranti.feature (OPT-BEH-BEH-010).
  #
  # Avgrensning: Kravet gjelder kun svaret på tidlig opptak. Andre tilbudsgarantier —
  # særlig reservert studieplass — kommer fra en annen kilde og vises uavhengig av dette
  # svaret. En søker kan derfor se "ikke innvilget" på tidlig opptak og samtidig ha
  # reservert studieplass på samme søknadsalternativ.
  #
  # Svaret bygger kun på tilbudsgarantien for tidlig opptak fra opptaksforvalter, som
  # gjennomføringen setter. En tilbudsgaranti gitt av tilbyder vises ikke i seg selv som
  # innvilget. Et tidligopptakstilbud fra tilbyder (FOP) regnes med i gjennomføringen, og
  # gir tilbudsgaranti for tidlig opptak på søknadsalternativet (OPT-BEH-BEH-007). Da vises
  # det som innvilget.
  Bakgrunn:
    Gitt at søkeren er innlogget

  # "Publisert" betyr at opptaksforvalter har gjennomført tidlig opptak. Det er ingen
  # egen publiseringsdato (avklart 09.10.2026, review av PR #654). Svaret skal aldri bli
  # synlig før det finnes noe å svare på.
  Regel: Svaret på tidlig opptak blir synlig når tidlig opptak er gjennomført

    Scenario: Svaret er ikke synlig før tidlig opptak er gjennomført
      Gitt at tidlig opptak ikke er gjennomført
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren svar på tidlig opptak i søknaden

    Scenario: Svaret blir synlig når tidlig opptak er gjennomført
      Gitt at tidlig opptak er gjennomført
      Og at det er konkludert om søkeren deltar i tidlig opptaket i alle sakene
      Når søkeren åpner søknaden sin
      Så ser søkeren svar på tidlig opptak i søknaden

    # En søker som har søkt, skal ha fått en konklusjon før tidlig opptak gjennomføres. Mangler
    # konklusjonen i en sak, er søknadsalternativene i saken ikke med i tidlig opptak, og
    # får ingen tilbudsgaranti (gi_tilbudsgaranti_ved_tidlig_opptak.feature). De behandles
    # i det ordinære opptaket (avklart med fagperson 13.10.2026).
    Scenario: Søkeren ser ikke svar på tidlig opptak der saken ikke har konklusjon
      Gitt at tidlig opptak er gjennomført
      Og at søkeren har søkt om tidlig opptak
      Men det er ikke konkludert om søkeren deltar i tidlig opptak i saken som gjelder et bestemt søknadsalternativ
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren svar på tidlig opptak for det bestemte søknadsalternativet

  # Etter at hovedopptaket er publisert, er det svaret fra hovedopptaket som gjelder
  # (avklart 20.10.2026, som i koden).
  Regel: Svaret på tidlig opptak vises frem til hovedopptaket er publisert

    Scenario: Svaret på tidlig opptak vises ikke etter at hovedopptaket er publisert
      Gitt at tidlig opptak er gjennomført
      Og at søkeren har søkt om tidlig opptak
      Og at hovedopptaket er publisert
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren svar på tidlig opptak i søknaden

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
      Så ser søkeren at tidlig opptak er innvilget for høyst ett søknadsalternativ

  Regel: Søkeren ser utfallet av tidlig opptak per søknadsalternativ

    Scenario: Søkeren er innvilget tidlig opptak på et søknadsalternativ
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren har tilbudsgaranti for tidlig opptak fra opptaksforvalter på søknadsalternativet på et bestemt søknadsalternativ
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak er innvilget på det bestemte søknadsalternativet

    # Dekker også søknadsalternativer der det ligger en tilbudsgaranti som ikke gir tilbud,
    # for eksempel et registrert avslag på tidlig opptak. Utfallet for søkeren er det samme.
    Scenario: Søkeren deltok, men nådde ikke opp på et søknadsalternativ
      Gitt at svaret på tidlig opptak er publisert
      Og at et bestemt søknadsalternativ tilbyr tidlig opptak
      Og at søkeren deltok i tidlig opptak på dette søknadsalternativet
      Men søkeren er ikke innvilget tidlig opptak på noen av søknadsalternativene sine
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak ikke er innvilget på det bestemte søknadsalternativet

    Scenario: Innvilget tidlig opptak vises ikke på et søknadsalternativ med lavere prioritet enn et annet søknadsalternativ som er innvilget
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren er innvilget tidlig opptak på søknadsalternativet med prioritet 1
      Og at et søknadsalternativet med prioritet 3 deltar i tidlig opptak
      Og at tilbyder har gitt tilbudsgaranti for tidlig opptak på søknadsalternativet med prioritet 3
      Når søkeren åpner søknaden sin
      Så ser søkeren innvilget tidlig opptak på søknadsalternativet med prioritet 1 men ikke på søknadsalternativet med prioritet 3

    Scenario: Saksbehandler har konkludert med at søkeren ikke deltar i tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at saksbehandler har konkludert med at søkeren ikke deltar i tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser søkeren at tidlig opptak ikke er innvilget

    Scenario: Søknadsalternativ lagt til etter fristen for søknad om tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren la til et bestemt søknadsalternativ etter fristen for søknad om tidlig opptak, men før opptaket stengte
      Når søkeren åpner søknaden sin
      Så ser søkeren svar på tidlig opptak for det bestemte søknadsalternativet på lik linje med de andre søknadsalternativene

  Regel: Søkeren ser egen poengsum og poenggrense der søkeren deltok uten å nå opp

    Scenario: Poengsum og poenggrense vises når søkeren deltok og ikke nådde opp
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren deltok i tidlig opptak på et bestemt søknadsalternativ
      Men søkeren er ikke innvilget tidlig opptak på noen av søknadsalternativene sine
      Når søkeren åpner søknaden sin
      Så ser søkeren sin egen poengsum for det bestemte søknadsalternativet
      Og søkeren ser poenggrensen for tidlig opptak for det bestemte søknadsalternativet

    Scenario: Poengsum og poenggrense vises ikke når søkeren er innvilget
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren er innvilget tidlig opptak på et bestemt søknadsalternativ
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense for det bestemte søknadsalternativet

    Scenario: Poengsum og poenggrense vises ikke når søkeren er innvilget på høyere prioritet
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren er innvilget tidlig opptak på søknadsalternativet med prioritet 1
      Og at søkeren deltok i tidlig opptak på søknadsalternativet med prioritet 3
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense for søknadsalternativet med prioritet 3

    Scenario: Poengsum og poenggrense vises ikke når søkeren ikke deltar i tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at saksbehandler har konkludert med at søkeren ikke deltar i tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense for noen av søknadsalternativene

    # Avklart 20.10.2026, som i koden (STEK-582).
    Scenario: Poengsum og poenggrense vises ikke når søkeren ikke er kvalifisert
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren deltok i tidlig opptak på et bestemt søknadsalternativ
      Men søkeren er ikke kvalifisert til det bestemte søknadsalternativet
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense for det bestemte søknadsalternativet

    Scenario: Poengsum og poenggrense vises ikke på søknadsalternativer uten tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Og at et bestemt utdanningstilbud ikke deltar i tidlig opptak
      Når søkeren åpner søknaden sin
      Så ser ikke søkeren poengsum og poenggrense for det bestemte utdanningstilbudet

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

  Regel: Svaret vises på språket søkeren har valgt

    Scenariomal: Se svaret på det valgte språket
      Gitt søkeren har valgt <språk> i Min kompetanse
      Og svaret på tidlig opptak er publisert
      Når søkeren åpner søknaden sin
      Så ser søkeren svaret på tidlig opptak på <språk>

      Eksempler:
        | språk      |
        | bokmål     |
        | nynorsk    |
        | nordsamisk |
        | engelsk    |

# AVKLART 08.10.2026: Trekker søkeren søknaden eller fjerner søknadsalternativet,
# faller tilbudsgarantien bort, og søkeren ser ikke noe svar på søknadsalternativet.
# Legges søknadsalternativet inn igjen før søknadsfristen for opptaket, gjelder
# tilbudsgarantien igjen. Se gi_tilbudsgaranti.feature (OPT-BEH-BEH-010). Det er
# ett tilfelle av at fjerning er deaktivering, ikke sletting, som det ikke finnes
# noe generelt krav for ennå (påpekt i review av PR #654, 09.10.2026).
#
# AVKLART 08.10.2026: Svaret vises på språket søkeren har valgt i Min kompetanse,
# på samme måte som meldingen om svaret (publisere_svar_på_tidlig_opptak.feature).
