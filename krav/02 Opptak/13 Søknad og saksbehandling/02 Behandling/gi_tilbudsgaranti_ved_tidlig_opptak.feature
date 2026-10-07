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
# Vurderingen og konklusjonen står i vurdere_søknad_om_tidlig_opptak.feature.
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
# - Konklusjonen kalles ikke et vedtak. Det endelige vedtaket er
#   plasstildelingen i hovedopptaket.
# - Konklusjonen gir ikke tilbudsgaranti. Opptaksforvalteren gjennomfører
#   tidligopptaket, og da får søkere som deltar, og som er kvalifisert og har
#   nok poeng, tilbudsgaranti på søknadsalternativet.
# - Om søkeren ikke får tilbudsgaranti, gjelder det bare tidlig opptak.
#   Søknadsalternativene behandles videre i det ordinære opptaket.
# - Svar publiseres til alle søkerne samtidig på én publiseringsdato for
#   tidlig opptak. Datoen knyttes til opptaket, ikke til utdanningstilbudet.
# - Tilbudsgarantien holder bare så lenge søkeren beholder
#   søknadsalternativet på samme prioritet.
# - Garantien er et minimum. Når søkeren når opp på et høyere prioritert
#   søknadsalternativ, gjelder ordinær plasstildeling.
#
# AVKLART 07.10.2026
#
# - Poeng lik poenggrensen gir tilbudsgaranti.
# - Søkeren får tilbudsgaranti bare på søknadsalternativer der søkeren er
#   kvalifisert. Er kvalifiseringen ikke vurdert, gis det ikke garanti, og
#   opptaksforvalteren ser det i utfallet.
# - Søkeren får tilbudsgaranti på høyst ett søknadsalternativ: det høyest
#   prioriterte som oppfyller kravene (som i se_svar_på_tidlig_opptak.feature).
# - En søknad som ikke er konkludert, er ikke med i tidligopptaket.
# - Opptaksforvalteren kan prøvekjøre og gjennomføre tidligopptaket flere
#   ganger. En ny gjennomføring fjerner ingen tilbudsgarantier. Systemet sjekker
#   ikke mot publiseringsdatoen: å gjennomføre før den er opptaksforvalterens
#   ansvar.
# - En behandler med T-rolle kan sette tilbudsgaranti manuelt uten betingelser.
#   Det gjelder også når søkeren ikke deltar i tidligopptaket, og det er slik
#   feil rettes etter at tidligopptaket er gjennomført.
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
  Som opptaksforvalter
  ønsker jeg å gjennomføre tidligopptaket
  slik at søkere som deltar, og som har nok poeng, får tilbudsgaranti uten å vente på hovedopptaket.

  Bakgrunn:
    Gitt søkeren har søkt om tidlig opptak
    Og "Sykepleie, høst 2027" er markert for tidlig tilbud med poenggrense 50

  Regel: Opptaksforvalter gjennomfører tidligopptaket

    Scenariomal: Tilbudsgaranti ut fra poenggrensen
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har <poeng> poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så <garanti> søkeren tilbudsgaranti på "Sykepleie, høst 2027"

      Eksempler:
        | poeng | garanti  |
        | 55    | får      |
        | 50    | får      |
        | 45    | får ikke |

    Scenario: Søkere som ikke deltar får ikke tilbudsgaranti
      Gitt saksbehandler har konkludert med at søkeren ikke deltar i tidligopptaket
      Og søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får ikke søkeren tilbudsgaranti på "Sykepleie, høst 2027"

    Scenario: Søknader uten konklusjon er ikke med i tidligopptaket
      Gitt det er ikke konkludert om søkeren deltar i tidligopptaket
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får ikke søkeren tilbudsgaranti på "Sykepleie, høst 2027"

    Scenario: Søkere som ikke er kvalifisert får ikke tilbudsgaranti
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søkeren er ikke kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får ikke søkeren tilbudsgaranti på "Sykepleie, høst 2027"

    Scenario: Kvalifisering som ikke er vurdert gir ikke tilbudsgaranti
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og kvalifiseringen til "Sykepleie, høst 2027" er ikke vurdert i søknadsbehandlingen
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får ikke søkeren tilbudsgaranti på "Sykepleie, høst 2027"
      Og opptaksforvalter ser at kvalifiseringen ikke er vurdert for søkeren

    Scenariomal: Tilbudsgaranti på det høyest prioriterte søknadsalternativet
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søknaden har følgende søknadsalternativer:
        | prioritet | søknadsalternativ     | tidlig tilbud | poenggrense      | kvalifisert | poeng |
        | 1         | Sykepleie, høst 2027  | ja            | <grense sykepl.> | ja          | 55    |
        | 2         | Vernepleie, høst 2027 | ja            | 40               | ja          | 55    |
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får søkeren tilbudsgaranti på <garanti>
      Og søkeren får ikke tilbudsgaranti på <ikke garanti>

      Eksempler:
        | grense sykepl. | garanti                 | ikke garanti            |
        | 50             | "Sykepleie, høst 2027"  | "Vernepleie, høst 2027" |
        | 60             | "Vernepleie, høst 2027" | "Sykepleie, høst 2027"  |

    Scenario: Prøvekjøre tidligopptaket
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter prøvekjører tidligopptaket
      Så ser opptaksforvalter at søkeren ville fått tilbudsgaranti på "Sykepleie, høst 2027"
      Men søkeren har ikke tilbudsgaranti på "Sykepleie, høst 2027"

    Scenario: Gjennomføre tidligopptaket på nytt
      Gitt søkeren fikk tilbudsgaranti på "Sykepleie, høst 2027" da tidligopptaket ble gjennomført
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Og poenggrensen for "Sykepleie, høst 2027" er endret til 60
      Når opptaksforvalter gjennomfører tidligopptaket på nytt
      Så har søkeren fortsatt tilbudsgaranti på "Sykepleie, høst 2027"

    Scenario: Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak
      Gitt søkeren fikk ikke tilbudsgaranti på "Sykepleie, høst 2027" i tidligopptaket
      Når hovedopptaket kjøres
      Så behandles "Sykepleie, høst 2027" i det ordinære opptaket

  Regel: Behandler med T-rolle kan sette tilbudsgaranti manuelt

    Scenario: Sette tilbudsgaranti når søknaden ikke kan poengberegnes
      Gitt behandleren har T-rolle
      Og søknaden kan ikke poengberegnes
      Når behandleren setter tilbudsgaranti på "Sykepleie, høst 2027"
      Så har søkeren tilbudsgaranti på "Sykepleie, høst 2027"

    Scenario: Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket
      Gitt behandleren har T-rolle
      Og det er ikke konkludert med at søkeren deltar i tidligopptaket
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
