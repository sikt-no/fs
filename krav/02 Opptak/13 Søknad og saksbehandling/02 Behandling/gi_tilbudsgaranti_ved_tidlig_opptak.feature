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
# Poenggrensen for tidlig opptak settes per utdanningstilbud, se
# opptaksinnstillinger_utdanningstilbud.feature.
#
# Featuren slutter når tilbudsgarantiene er tildelt. Publiseringen og
# meldingen til søkerne står i publisere_svar_på_tidlig_opptak.feature
# (OPT-OPT-TID-001), og hva søkeren ser, i se_svar_på_tidlig_opptak.feature
# (OPT-SØK-SØK-012). Begge kommer med #642.
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
# - (Endret 09.10.2026: det er ingen egen publiseringsdato. Svaret publiseres
#   når tidligopptaket gjennomføres, se publisere_svar_på_tidlig_opptak.feature.)
#   Svar publiseres til alle søkerne samtidig på én publiseringsdato for
#   tidlig opptak. Datoen knyttes til opptaket, ikke til utdanningstilbudet.
# - (Endret 08.10.2026, se under.) Tilbudsgarantien holder bare så lenge
#   søkeren beholder søknadsalternativet på samme prioritet.
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
#   ganger. En ny gjennomføring fjerner ingen tilbudsgarantier. (Endret
#   09.10.2026: det er ingen publiseringsdato. Gjennomføringen publiserer svaret
#   til søkerne, men prøvekjøringen gjør det ikke.)
# - En behandler med T-rolle kan sette tilbudsgaranti manuelt uten betingelser.
#   (Utvidet 08.10.2026: også B-rolle og F-rolle kan sette tilbudsgaranti, se under.)
#   Det gjelder også når søkeren ikke deltar i tidligopptaket, og det er slik
#   feil rettes etter at tidligopptaket er gjennomført.
#
# AVKLART I JIRA (lagt inn 07.10.2026)
#
# - Bare saker som er ferdig behandlet, er med (STEK-425, 01.09.2026).
# - Poengsummen er den høyeste søkeren har til søknadsalternativet, uansett kvote
#   (STEK-269, 27.08.2026). I det gamle systemet var den hardkodet til ordinær kvote.
# - Gjennomføringen gir tilbudsgarantien som opptaksforvalter. En tilbudsgaranti fra
#   opptaksforvalter som ikke gir tilbud, erstattes. En som gir tilbud, røres ikke, og
#   søkeren får da ingen ny tilbudsgaranti på lavere prioritet (STEK-269, 12.08.2026).
# - Tilbudsgarantitypen for tidlig opptak hentes fra opptakets kodeverk, ikke hardkodet.
#   Det må finnes nøyaktig én aktiv type i kategorien for tidlig opptak som gir tilbud
#   og kan brukes av opptaksforvalter (STEK-269).
# - Tilbudsgarantiene deles ut selv om de overskrider kvoten. Opptaksforvalter får et
#   varsel, og fanger det i prøvekjøringen (STEK-269, STEK-426). Varselgrensen er en
#   andel av kvoten som opptaksforvalter kan angi ved gjennomføringen.
# - Opptaksforvalter får en rapport over utfallet (STEK-489).
#
# AVKLART 08.10.2026
#
# - Søkeren har aldri mer enn én tilbudsgaranti fra tidligopptaket. Når en ny
#   gjennomføring gir tilbudsgaranti på et høyere prioritert søknadsalternativ,
#   fjernes tilbudsgarantien på det lavere. Dette er unntaket fra at en ny
#   gjennomføring ikke fjerner tilbudsgarantier. Koden lar i dag den gamle
#   tilbudsgarantien stå (TidligopptakTilbudsgarantiService), og må endres.
# - Tilbudsgarantien faller bort når søkeren fjerner søknadsalternativet eller
#   trekker søknaden. Legger søkeren søknadsalternativet inn igjen før
#   søknadsfristen for opptaket, gjelder tilbudsgarantien igjen, uansett
#   prioritet (prioriteten er endret 08.10.2026, se under).
# - Tilbudsgarantien følger søknadsalternativet, uansett prioritet. Den faller
#   ikke bort når søkeren flytter søknadsalternativet ned, eller når et nytt
#   søknadsalternativ legges over. Garantien betyr at søkeren aldri blir forbigått
#   på søknadsalternativet: søkeren får tilbud der, uansett poeng, med mindre
#   søkeren når opp på et søknadsalternativ med høyere prioritet. Prioriteten
#   avgjør hvilket tilbud søkeren får, ikke om garantien gjelder. Det samme
#   gjelder når søkeren legger søknadsalternativet inn igjen før søknadsfristen.
#   Dette erstatter regelen fra 25.09 om samme prioritet, og stemmer med koden.
#
# AVKLART 08.10.2026 (etter review fra fagperson i STEK-269)
#
# - Et tidligopptakstilbud fra tilbyder (FOP) teller i gjennomføringen. Søkeren
#   får tidligopptakstilbud på det høyest prioriterte søknadsalternativet som
#   enten har et tidligopptakstilbud fra før, eller oppfyller kravene. Ingen
#   søknadsalternativer under får tilbudsgaranti. Et tidligopptakstilbud fra før
#   gjelder uansett konklusjon, om saken er ferdig behandlet, og poengsum
#   (fagperson i STEK-269, 30.09.2026). Implementert på fs-plattform-branchen
#   STEK-503_sett_sammen_tidligopptak_konklusjoner_for_soker, ikke på main.
# - Alle tre rollene (B-rolle, T-rolle og F-rolle) kan sette tilbudsgaranti manuelt,
#   hver med sitt eget sett med tilbudsgarantityper (domeneekspert, med henvisning til
#   Confluence OP «Tilbudsgaranti»). Det stemmer med STEK-270/262 og koden.
# - Manuell tilbudsgaranti har ingen betingelser knyttet til tidlig opptak, heller
#   ikke for typer som gjelder tidlig opptak. Tilbudsgaranti er generell, og gis av
#   flere grunner enn tidlig opptak. Betingelsen fra dagens løsning (tidligsvar bare
#   når søkeren har søkt om tidlig opptak) videreføres ikke.
# - Kodeverkene tidlig opptak bygger på (begrunnelser, konklusjoner og
#   tilbudsgarantityper) legges inn i databasen per opptak, og vedlikeholdes ikke i
#   løsningen nå. At opptaksforvalter kan forvalte dem, kommer senere, bekreftet av
#   produkteier (STEK-349). Det skrives ikke krav for det nå.
#
# BEGREPSBRUK
#
# - «Innvilget tidlig opptak» (brukt i #642) betyr at søkeren har fått
#   tilbudsgaranti gjennom tidligopptaket.
# - «Gjennomføre tidligopptaket» er det samme som tildelingsrutinen i #642.
# - Behandler med T-rolle er tilbyder. Manuell tilbudsgaranti fra T-rolle er
#   det #642 kaller tilbudsgaranti gitt av tilbyder.
# - «Tidligopptakstilbud» er en tilbudsgaranti av en type i kategorien for tidlig
#   opptak som gir tilbud: den gjennomføringen setter (FOR), eller den tilbyder
#   setter manuelt (FOP), f.eks. når søkeren ikke kan poengberegnes.
#
@OPT-BEH-BEH-007 @must @in-progress
Egenskap: Gi tilbudsgaranti ved tidlig opptak
  Som opptaksforvalter
  ønsker jeg å gjennomføre tidligopptaket
  slik at søkere som deltar, og som har nok poeng, får tilbudsgaranti uten å vente på hovedopptaket.

  Bakgrunn:
    Gitt søkeren har søkt om tidlig opptak
    Og "Sykepleie, høst 2027" tilbyr tidlig opptak med poenggrense 50

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
        | prioritet | søknadsalternativ     | tilbyr tidlig opptak | poenggrense      | kvalifisert | poeng |
        | 1         | Sykepleie, høst 2027  | ja                   | <grense sykepl.> | ja          | 55    |
        | 2         | Vernepleie, høst 2027 | ja                   | 40               | ja          | 55    |
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får søkeren tilbudsgaranti på <garanti>
      Og søkeren får ikke tilbudsgaranti på <ikke garanti>

      Eksempler:
        | grense sykepl. | garanti                 | ikke garanti            |
        | 50             | "Sykepleie, høst 2027"  | "Vernepleie, høst 2027" |
        | 60             | "Vernepleie, høst 2027" | "Sykepleie, høst 2027"  |

    Scenario: Bare ferdig behandlede saker er med i tidligopptaket
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Og saken er ikke ferdig behandlet
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får ikke søkeren tilbudsgaranti på "Sykepleie, høst 2027"
      Og opptaksforvalter ser at saken ikke er ferdig behandlet

    Scenario: Den høyeste poengsummen til søknadsalternativet gjelder
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har følgende poeng til "Sykepleie, høst 2027":
        | kvote                      | poeng |
        | Ordinær kvote              | 48    |
        | Førstegangsvitnemålskvoten | 52    |
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får søkeren tilbudsgaranti på "Sykepleie, høst 2027"

    Scenario: Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Og opptaksforvalter har satt en tilbudsgaranti som ikke gir tilbud på "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får søkeren tilbudsgaranti for tidlig opptak på "Sykepleie, høst 2027"

    Scenario: Tilbudsgaranti på et høyere prioritert søknadsalternativ gir ingen ny tilbudsgaranti
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søknaden har følgende søknadsalternativer:
        | prioritet | søknadsalternativ     | tilbudsgaranti fra opptaksforvalter |
        | 1         | Historie, høst 2027   | gir tilbud                          |
        | 2         | Sykepleie, høst 2027  | ingen                               |
      Og søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får ikke søkeren tilbudsgaranti på "Sykepleie, høst 2027"

    Scenario: Tidligopptakstilbud fra tilbyder går foran poengsummen
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søknaden har følgende søknadsalternativer:
        | prioritet | søknadsalternativ     | tilbyr tidlig opptak | poenggrense | kvalifisert | poeng | tilbudsgaranti fra tilbyder |
        | 1         | Sykepleie, høst 2027  | ja                   | 50          | ja          | ingen | tidligopptakstilbud         |
        | 2         | Vernepleie, høst 2027 | ja                   | 40          | ja          | 55    | ingen                       |
      Når opptaksforvalter gjennomfører tidligopptaket
      Så har søkeren tidligopptakstilbud på "Sykepleie, høst 2027"
      Og søkeren får ikke tilbudsgaranti på "Vernepleie, høst 2027"

    Scenario: Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum
      Gitt det er ikke konkludert om søkeren deltar i tidligopptaket
      Og søknaden kan ikke poengberegnes
      Og tilbyder har gitt tidligopptakstilbud på "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så har søkeren fortsatt tidligopptakstilbud på "Sykepleie, høst 2027"
      Og opptaksforvalter ser at søkeren har tidligopptakstilbud på "Sykepleie, høst 2027"

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

    Scenario: Tilbudsgarantien flyttes til et høyere prioritert søknadsalternativ ved ny gjennomføring
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søkeren fikk tilbudsgaranti på "Vernepleie, høst 2027" som prioritet 2 da tidligopptaket ble gjennomført
      Og søkeren når nå poenggrensen for "Sykepleie, høst 2027" som prioritet 1
      Når opptaksforvalter gjennomfører tidligopptaket på nytt
      Så får søkeren tilbudsgaranti på "Sykepleie, høst 2027"
      Og søkeren har ikke lenger tilbudsgaranti på "Vernepleie, høst 2027"

    Scenario: Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak
      Gitt søkeren fikk ikke tilbudsgaranti på "Sykepleie, høst 2027" i tidligopptaket
      Når hovedopptaket kjøres
      Så behandles "Sykepleie, høst 2027" i det ordinære opptaket

  Regel: Opptaksforvalter ser utfallet av tidligopptaket

    Scenario: Se utfallet for hver søker
      Når opptaksforvalter gjennomfører tidligopptaket
      Så ser opptaksforvalter utfallet for hvert søknadsalternativ som er vurdert
      Og opptaksforvalter ser antall søkere per utfall, per behandlende organisasjon og per utdanningstilbud

    Scenario: Se utdanningstilbud med mangelfulle innstillinger
      Gitt "Vernepleie, høst 2027" tilbyr tidlig opptak uten poenggrense
      Når opptaksforvalter prøvekjører tidligopptaket
      Så ser opptaksforvalter at "Vernepleie, høst 2027" mangler poenggrense

    # Varselet er et sikkerhetsnett (avklart 08.10.2026). Opptaksforvalter setter
    # poenggrensen høyt nok til at tilbudsgarantiene ikke bruker opp kvoten, f.eks.
    # som medianen av poengene som skulle til for å komme inn på utdanningstilbudet
    # året før. Systemet beregner ikke grensen. Det er ingen sperre mot at
    # tilbudsgarantiene overskrider kvoten, så plasstildelingen må likevel håndtere
    # det (se gjennomføre_plasstildeling.feature).
    Scenario: Varsel når tilbudsgarantiene overskrider kvoten
      Gitt "Sykepleie, høst 2027" har 10 plasser i kvoten tilbudsgarantiene tas fra
      Og 12 søkere oppfyller kravene til tilbudsgaranti på "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får de 12 søkerne tilbudsgaranti på "Sykepleie, høst 2027"
      Og opptaksforvalter får varsel om at tilbudsgarantiene overskrider kvoten for "Sykepleie, høst 2027"

    Scenario: Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak
      Gitt opptaket har ikke nøyaktig én aktiv tilbudsgarantitype for tidlig opptak som gir tilbud
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får ingen søkere tilbudsgaranti
      Og opptaksforvalter ser at tilbudsgarantitypen for tidlig opptak mangler eller er tvetydig

  # Tre roller kan sette tilbudsgaranti manuelt, hver i sitt eget felt og med sitt eget
  # sett med tilbudsgarantityper (avklart med domeneekspert 08.10.2026, se Confluence OP
  # «Tilbudsgaranti»). Hvilke typer en rolle kan bruke, står på tilbudsgarantitypen i
  # opptakets kodeverk.
  #
  # - B-rolle: saksbehandler ved organisasjonen som behandler saken.
  #   Eksempler fra dagens løsning: etter klage, reservert plass.
  # - T-rolle: tilbyder, organisasjonen som tilbyr utdanningstilbudet.
  #   Eksempler: særskilt vurdering, tidligsvar (forhåndsopptak).
  # - F-rolle: opptaksforvalter ved organisasjonen som eier opptaket.
  #   Eksempler: etter telefonsamtale, forhåndsløfte.
  Regel: Behandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt

    Scenariomal: Sette tilbudsgaranti i feltet for rollen
      Gitt behandleren har <rolle>
      Og tilbudsgarantitypen "<type>" kan brukes av <rolle>
      Når behandleren setter tilbudsgarantien "<type>" på "Sykepleie, høst 2027"
      Så har søkeren tilbudsgarantien "<type>" fra <rolle> på "Sykepleie, høst 2027"

      Eksempler:
        | rolle   | type                                     |
        | B-rolle | Tilbudsgaranti innvilges etter klage     |
        | T-rolle | Tilbudsgaranti, særskilt vurdering       |
        | F-rolle | Tilbudsgaranti gitt etter telefonsamtale |

    Scenario: Bare tilbudsgarantitypene for rollen kan velges
      Gitt behandleren har B-rolle
      Og tilbudsgarantitypen "Tilbudsgaranti, særskilt vurdering" kan bare brukes av T-rolle
      Når behandleren skal sette tilbudsgaranti på "Sykepleie, høst 2027"
      Så kan ikke behandleren velge "Tilbudsgaranti, særskilt vurdering"

    Scenario: Behandler ser ikke muligheten til å sette tilbudsgaranti for en rolle behandleren ikke har
      Gitt behandleren har B-rolle
      Og behandleren har ikke T-rolle eller F-rolle
      Når behandleren ser på "Sykepleie, høst 2027" i saken
      Så ser behandleren muligheten til å sette tilbudsgaranti fra B-rolle
      Men behandleren ser ikke muligheten til å sette tilbudsgaranti fra T-rolle eller F-rolle

    Scenario: Se tilbudsgarantiene fra alle rollene
      Gitt søkeren har følgende tilbudsgarantier på "Sykepleie, høst 2027":
        | rolle   | type                                     |
        | B-rolle | Tilbudsgaranti innvilges etter klage     |
        | F-rolle | Tilbudsgaranti gitt etter telefonsamtale |
      Når behandleren ser på "Sykepleie, høst 2027" i saken
      Så ser behandleren begge tilbudsgarantiene og hvilken rolle som har satt dem

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

  Regel: Tilbudsgarantien gjelder i hovedopptaket

    Scenario: Tilbudsgarantien gir tilbud i hovedopptaket
      Gitt søkeren har tilbudsgaranti på "Sykepleie, høst 2027" som prioritet 1
      Når hovedopptaket kjøres
      Så får søkeren tilbud på "Sykepleie, høst 2027"

    Scenario: Søkeren får tilbud på et høyere prioritert søknadsalternativ
      Gitt søkeren har tilbudsgaranti på "Sykepleie, høst 2027" som prioritet 2
      Og søkeren når opp til "Historie, høst 2027" som prioritet 1 i hovedopptaket
      Når hovedopptaket kjøres
      Så får søkeren tilbud på "Historie, høst 2027"

    Scenario: Søkeren blir ikke forbigått på søknadsalternativet med tilbudsgaranti
      Gitt søkeren har tilbudsgaranti på "Sykepleie, høst 2027" som prioritet 2
      Og søkeren når ikke opp til "Historie, høst 2027" som prioritet 1 i hovedopptaket
      Og søkeren har færre poeng enn poenggrensen for "Sykepleie, høst 2027" i hovedopptaket
      Når hovedopptaket kjøres
      Så får søkeren tilbud på "Sykepleie, høst 2027"

    Scenariomal: Tilbudsgarantien følger søknadsalternativet når prioriteten endres
      Gitt søkeren har tilbudsgaranti på "Sykepleie, høst 2027" som prioritet 2
      Når søkeren <endring>
      Så har søkeren fortsatt tilbudsgaranti på "Sykepleie, høst 2027"

      Eksempler:
        | endring                                          |
        | flytter "Sykepleie, høst 2027" til prioritet 1   |
        | flytter "Sykepleie, høst 2027" til prioritet 3   |
        | legger til "Historie, høst 2027" som prioritet 1 |

    Scenariomal: Tilbudsgarantien faller bort når søknadsalternativet fjernes
      Gitt søkeren har tilbudsgaranti på "Sykepleie, høst 2027" som prioritet 1
      Når søkeren <handling>
      Så har søkeren ikke lenger tilbudsgaranti på "Sykepleie, høst 2027"

      Eksempler:
        | handling                                    |
        | fjerner "Sykepleie, høst 2027" fra søknaden |
        | trekker søknaden                            |

    # Dette er ett tilfelle av en generell oppførsel: å fjerne et søknadsalternativ
    # eller trekke søknaden er en deaktivering, ikke en sletting (soknadsalternativ.slettet
    # i koden), og saksbehandlingen gjelder igjen når søknadsalternativet legges inn
    # igjen. Det finnes ikke noe generelt krav for den oppførselen ennå, f.eks. i
    # 01 Søknad/trekke_søknad.feature eller prioritere_søknadsalternativer.feature
    # (påpekt i review av PR #654, 09.10.2026).
    Scenariomal: Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen
      Gitt søknadsfristen for opptaket er "2027-04-15 23:59"
      Og søkeren hadde tilbudsgaranti på "Sykepleie, høst 2027" som prioritet 1
      Og søkeren fjernet "Sykepleie, høst 2027" fra søknaden "2027-04-01"
      Når søkeren legger inn "Sykepleie, høst 2027" igjen som prioritet <prioritet> "2027-04-08"
      Så har søkeren tilbudsgaranti på "Sykepleie, høst 2027" igjen

      Eksempler:
        | prioritet |
        | 1         |
        | 2         |
