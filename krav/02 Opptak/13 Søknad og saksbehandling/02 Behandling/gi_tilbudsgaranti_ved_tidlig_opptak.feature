# language: no
# GitHub: #TBD
#
# KILDER
#
# Delleveranse 4 og 5 av initiativet #456 Behandle søknader om tidlig opptak.
# Hovedkilde: Jira STEK-188 «Forvalte og behandle tidligopptak». STEK-188
# beskriver Confluence PFS 4518412300 «Behandling av søknad om tidlig opptak»
# som «ikke helt riktig», og går foran den der de sier ulikt.
#
# Tidlig opptak er én av flere typer tilbudsgaranti. Generell håndtering av
# tilbudsgaranti hører til Jira STEK-241 «Tilbudsgaranti», se også
# Confluence PFS 3885400152 «Tilbudsgaranti».
#
# Vurderingene konklusjonen bygger på står i vurdere_søknad_om_tidlig_opptak.feature.
# Poenggrensen for tidlig tilbud settes per utdanningstilbud, se
# opptaksinnstillinger_utdanningstilbud.feature.
#
# Featuren slutter når tilbudsgarantiene er tildelt. Publiseringsdatoen og
# meldingen til søkerne står i publisere_svar_på_tidlig_opptak.feature
# (OPT-OPT-TID-001), og hva søkeren ser, i se_svar_på_tidlig_opptak.feature
# (OPT-SØK-SØK-005). Begge kommer med #642.
#
# AVKLART 25.09.2026
#
# - Saksbehandleren konkluderer på hele søknaden. Konklusjonen kalles ikke
#   et vedtak. Det endelige vedtaket er plasstildelingen i hovedopptaket.
# - Konklusjonen gir ikke tilbudsgaranti. Den merker hvilke
#   søknadsalternativer søkeren deltar i tidligopptaket på: de som er
#   markert for tidlig tilbud, og der søkeren er kvalifisert i den ordinære
#   søknadsbehandlingen.
# - Opptaksforvalteren gjennomfører tidligopptaket. Da får søkere som deltar,
#   og som har poeng over poenggrensen, tilbudsgaranti på søknadsalternativet.
# - En behandler med T-rolle kan sette tilbudsgaranti manuelt, for eksempel
#   når søknaden ikke kan poengberegnes.
# - Om søkeren ikke får tilbudsgaranti, gjelder det bare tidlig opptak.
#   Søknadsalternativene behandles videre i det ordinære opptaket.
# - Svar publiseres til alle søkerne samtidig på én publiseringsdato for
#   tidlig opptak. Datoen knyttes til opptaket, ikke til utdanningstilbudet.
# - Vurdering og konklusjon krever samme rettighet som ordinær
#   søknadsbehandling.
# - Konklusjonen kan endres fram til svaret er publisert. Etter det er den låst.
# - Tilbudsgarantien holder bare så lenge søkeren beholder
#   søknadsalternativet på samme prioritet.
# - Garantien er et minimum. Når søkeren når opp på et høyere prioritert
#   søknadsalternativ, gjelder ordinær plasstildeling.
#
# BEGREPSBRUK
#
# - «Innvilget tidlig opptak» (brukt i #642) betyr at søkeren har fått
#   tilbudsgaranti gjennom tidligopptaket.
# - «Gjennomføre tidligopptaket» er det samme som tildelingsrutinen i #642.
# - Behandler med T-rolle er tilbyder. Manuell tilbudsgaranti fra T-rolle er
#   det #642 kaller tilbudsgaranti gitt av tilbyder.
#
@OPT-BEH-BEH-007 @must @draft
Egenskap: Gi tilbudsgaranti ved tidlig opptak
  Som saksbehandler
  ønsker jeg å avgjøre hvilke søkere som deltar i tidligopptaket
  slik at kvalifiserte søkere får tilbudsgaranti uten å vente på hovedopptaket.

  Bakgrunn:
    Gitt saksbehandler er innlogget i løsningen
    Og søkeren har søkt om tidlig opptak
    Og "Sykepleie, høst 2027" er markert for tidlig tilbud med poenggrense 50

  Regel: Konklusjonen avgjør hvilke søknadsalternativer søkeren deltar i tidligopptaket på

    Scenariomal: Deltakelse ut fra vurderingene
      Gitt saksbehandler har registrert at begrunnelsen <dokumentert>
      Og søkeren <kvalifisert> til "Sykepleie, høst 2027"
      Når saksbehandler konkluderer søknaden om tidlig opptak
      Så <deltar> søkeren i tidligopptaket på "Sykepleie, høst 2027"

      Eksempler:
        | dokumentert          | kvalifisert          | deltar      |
        | er dokumentert       | er kvalifisert       | deltar      |
        | er dokumentert       | ikke er kvalifisert  | deltar ikke |
        | ikke er dokumentert  | er kvalifisert       | deltar ikke |
        | ikke er dokumentert  | ikke er kvalifisert  | deltar ikke |

    Scenario: Deltakelse bare der søkeren er kvalifisert og tidlig tilbud gis
      Gitt saksbehandler har registrert at begrunnelsen er dokumentert
      Og søknaden har følgende søknadsalternativer:
        | søknadsalternativ     | tidlig tilbud | kvalifisert |
        | Sykepleie, høst 2027  | ja            | ja          |
        | Vernepleie, høst 2027 | ja            | nei         |
        | Historie, høst 2027   | nei           | ja          |
      Når saksbehandler konkluderer søknaden om tidlig opptak
      Så deltar søkeren i tidligopptaket på "Sykepleie, høst 2027"
      Og søkeren deltar ikke i tidligopptaket på "Vernepleie, høst 2027"
      Og søkeren deltar ikke i tidligopptaket på "Historie, høst 2027"

    Scenario: Søknaden kan ikke konkluderes før begrunnelsen er vurdert
      Gitt det er ikke registrert om begrunnelsen er dokumentert
      Når saksbehandler skal konkludere søknaden om tidlig opptak
      Så kan ikke søknaden konkluderes

    Scenario: Søknaden kan ikke konkluderes før kvalifiseringen er vurdert
      Gitt saksbehandler har registrert at begrunnelsen er dokumentert
      Men kvalifiseringen til "Sykepleie, høst 2027" er ikke vurdert i søknadsbehandlingen
      Når saksbehandler skal konkludere søknaden om tidlig opptak
      Så kan ikke søknaden konkluderes

  Regel: Konklusjonen kan endres fram til svaret er publisert

    Scenario: Endre konklusjon før svaret er publisert
      Gitt søkeren deltar i tidligopptaket på "Sykepleie, høst 2027"
      Og søkeren har ikke fått svar på søknaden om tidlig opptak
      Når saksbehandler endrer konklusjonen slik at begrunnelsen ikke er dokumentert
      Så deltar ikke søkeren i tidligopptaket på "Sykepleie, høst 2027"

    Scenario: Konklusjonen kan ikke endres etter at svaret er publisert
      Gitt søkeren har fått svar på søknaden om tidlig opptak
      Når saksbehandler ser på konklusjonen
      Så kan ikke saksbehandler endre konklusjonen

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Gir poeng lik poenggrensen tilbudsgaranti? STEK-188 sier «over».
  # - Må gjennomføringen skje før publiseringsdatoen, og kan den kjøres
  #   flere ganger? Prosesshypotesen i notatet «2026-09-23 tidligopptaks-svar
  #   til søker» (se #642) sier før, som prosessrekkefølge og ikke systemregel,
  #   og nevner omkjøringer.
  Regel: Opptaksforvalter gjennomfører tidligopptaket

    Scenariomal: Tilbudsgaranti ut fra poenggrensen
      Gitt søkeren deltar i tidligopptaket på "Sykepleie, høst 2027"
      Og søkeren har <poeng> poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så <garanti> søkeren tilbudsgaranti på "Sykepleie, høst 2027"

      Eksempler:
        | poeng | garanti  |
        | 55    | får      |
        | 45    | får ikke |

    Scenario: Søkere som ikke deltar får ikke tilbudsgaranti
      Gitt søkeren deltar ikke i tidligopptaket på "Sykepleie, høst 2027"
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får ikke søkeren tilbudsgaranti på "Sykepleie, høst 2027"

    Scenario: Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak
      Gitt søkeren fikk ikke tilbudsgaranti på "Sykepleie, høst 2027" i tidligopptaket
      Når hovedopptaket kjøres
      Så behandles "Sykepleie, høst 2027" i det ordinære opptaket

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Kan manuell tilbudsgaranti bare settes når søknaden ikke kan
  #   poengberegnes, eller også i andre tilfeller? STEK-188 sier «feks.».
  # - Må søkeren delta i tidligopptaket på søknadsalternativet for at
  #   manuell tilbudsgaranti kan settes?
  Regel: Behandler med T-rolle kan sette tilbudsgaranti manuelt

    Scenario: Sette tilbudsgaranti når søknaden ikke kan poengberegnes
      Gitt behandleren har T-rolle
      Og søkeren deltar i tidligopptaket på "Sykepleie, høst 2027"
      Og søknaden kan ikke poengberegnes
      Når behandleren setter tilbudsgaranti på "Sykepleie, høst 2027"
      Så har søkeren tilbudsgaranti på "Sykepleie, høst 2027"

    Scenario: Behandler uten T-rolle kan ikke sette tilbudsgaranti manuelt
      Gitt behandleren har ikke T-rolle
      Når behandleren ser på søknaden
      Så ser ikke behandleren muligheten til å sette tilbudsgaranti

  Regel: Tilbudsgarantien gjelder i hovedopptaket

    Scenario: Tilbudsgarantien gir tilbud i hovedopptaket
      Gitt søkeren har tilbudsgaranti på "Sykepleie, høst 2027"
      Og søkeren har beholdt "Sykepleie, høst 2027" på samme prioritet
      Når hovedopptaket kjøres
      Så får søkeren tilbud på "Sykepleie, høst 2027"

    Scenario: Søkeren får tilbud på et høyere prioritert søknadsalternativ
      Gitt søkeren har tilbudsgaranti på "Sykepleie, høst 2027" som prioritet 2
      Og søkeren når opp til "Historie, høst 2027" som prioritet 1 i hovedopptaket
      Når hovedopptaket kjøres
      Så får søkeren tilbud på "Historie, høst 2027"

    Scenario: Tilbudsgarantien faller bort når søknadsalternativet flyttes ned
      Gitt søkeren har tilbudsgaranti på "Sykepleie, høst 2027" som prioritet 1
      Når søkeren flytter "Sykepleie, høst 2027" til prioritet 2
      Så har søkeren ikke lenger tilbudsgaranti på "Sykepleie, høst 2027"

# ÅPNE SPØRSMÅL:
# - Hva skjer med søknader om tidlig opptak som ikke blir konkludert?
# - Hva skjer med søknader som konkluderes etter at tidligopptaket er
#   gjennomført? Tidligere avklart at svaret da publiseres straks, men det
#   var før modellen med gjennomføring og poenggrense. Må avklares på nytt.
