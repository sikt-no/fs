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
# tilbudsgaranti står i gi_tilbudsgaranti.feature (OPT-BEH-BEH-010), og hører
# til Jira STEK-241 «Tilbudsgaranti», se også
# Confluence PFS 3885400152 «Tilbudsgaranti».
#
# Vurderingen og konklusjonen står i vurdere_søknad_om_tidlig_opptak.feature.
# Poenggrensen for tidlig opptak settes per utdanningstilbud, se
# opptaksinnstillinger_utdanningstilbud.feature.
#
# Featuren slutter når tilbudsgarantiene er tildelt. Publiseringen og
# meldingen til søkerne står i publisere_svar_på_tidlig_opptak.feature
# (OPT-BEH-BEH-014), og hva søkeren ser, i se_svar_på_tidlig_opptak.feature
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
# - (Endret 08.10.2026, se under og gi_tilbudsgaranti.feature, OPT-BEH-BEH-010.)
#   Tilbudsgarantien holder bare så lenge søkeren beholder søknadsalternativet på
#   samme prioritet.
# - Garantien er et minimum. Når søkeren når opp på et høyere prioritert
#   søknadsalternativ, gjelder ordinær plasstildeling.
#
# AVKLART 07.10.2026
#
# - Poeng lik poenggrensen gir tilbudsgaranti.
# - Søkeren får tilbudsgaranti bare på søknadsalternativer der søkeren er
#   kvalifisert. Er kvalifiseringen ikke vurdert, gis det ikke garanti, og
#   opptaksforvalteren ser det i utfallet. (Unntak 13.10.2026, foreløpig: reservert
#   studieplass gir tilbudsgaranti uten at søkeren er kvalifisert, se notatet om
#   reservert studieplass under.)
# - Søkeren får tilbudsgaranti på høyst ett søknadsalternativ: det høyest
#   prioriterte som oppfyller kravene (som i se_svar_på_tidlig_opptak.feature).
# - En søknad som ikke er konkludert, er ikke med i tidligopptaket.
# - Opptaksforvalteren kan prøvekjøre og gjennomføre tidligopptaket flere
#   ganger. En ny gjennomføring fjerner ingen tilbudsgarantier. (Endret
#   09.10.2026: det er ingen publiseringsdato. Gjennomføringen publiserer svaret
#   til søkerne, men prøvekjøringen gjør det ikke.)
# - Manuell tilbudsgaranti står i gi_tilbudsgaranti.feature (OPT-BEH-BEH-010).
#   Den krever ikke at søkeren deltar i tidligopptaket, og det er slik feil
#   rettes etter at tidligopptaket er gjennomført.
#
# AVKLART I JIRA (lagt inn 07.10.2026)
#
# - Bare saker som er ferdig behandlet, er med (STEK-425, 01.09.2026).
# - Poengsummen er den høyeste søkeren har til søknadsalternativet etter tilbudets
#   kompetanseregelverk, uansett kvote (STEK-269, 27.08.2026; STEK-582). I det gamle
#   systemet var den hardkodet til ordinær kvote.
# - Gjennomføringen gir tilbudsgarantien som opptaksforvalter. Bare tilbudsgaranti for
#   tidlig opptak og reservert studieplass påvirker tidligopptaket. En annen tilbudsgaranti
#   fra opptaksforvalter, også en som gir tilbud, stopper ikke søkeren lavere ned, og
#   erstattes på søknadsalternativet som får tilbudsgaranti fra tidligopptaket. Den går da
#   tapt. (Endret 20.10.2026, som i STEK-503. Var: en som gir tilbud, røres ikke, og
#   søkeren får ingen ny tilbudsgaranti på lavere prioritet, STEK-269, 12.08.2026.)
# - Tilbudsgarantitypen for tidlig opptak hentes fra opptakets kodeverk, ikke hardkodet.
#   Det må finnes nøyaktig én aktiv type i kategorien for tidlig opptak som gir tilbud
#   og kan brukes av opptaksforvalter (STEK-269).
# - Tilbudsgarantiene deles ut selv om de overskrider kvoten. Opptaksforvalter får et
#   varsel, og fanger det i prøvekjøringen (STEK-269, STEK-426). Varselgrensen er en
#   andel av kvoten som opptaksforvalter kan angi ved gjennomføringen. Er den ikke
#   angitt, er grensen 30 prosent av kvoten (avklart 09.10.2026).
# - Opptaksforvalter får en rapport over utfallet (STEK-489).
#
# AVKLART 08.10.2026
#
# - Søkeren har aldri mer enn én tilbudsgaranti fra tidligopptaket. Når en ny
#   gjennomføring gir tilbudsgaranti på et høyere prioritert søknadsalternativ,
#   fjernes tilbudsgarantien på det lavere. Dette er unntaket fra at en ny
#   gjennomføring ikke fjerner tilbudsgarantier. Rettet i koden i MR 6136
#   (merget 13.10.2026).
#   (Bekreftet med fagperson 13.10.2026: tilbudsgarantien på det lavere
#   søknadsalternativet fjernes. Har den første gjennomføringen overskrevet en
#   annen kode, f.eks. en negativ garanti fra opptaksforvalter eller en
#   reservasjon, går den koden tapt. Det er akseptert.)
# - At tilbudsgarantien følger søknadsalternativet uansett prioritet, faller bort
#   når søknadsalternativet fjernes, og gjelder igjen når det legges inn igjen før
#   søknadsfristen, står i gi_tilbudsgaranti.feature (OPT-BEH-BEH-010). Det gjelder
#   også tilbudsgarantien fra tidligopptaket.
#
# AVKLART 08.10.2026 (etter review fra fagperson i STEK-269)
#
# - Et tidligopptakstilbud fra tilbyder (FOP) teller i gjennomføringen. Søkeren
#   får tidligopptakstilbud på det høyest prioriterte søknadsalternativet som
#   enten har et tidligopptakstilbud fra før, eller oppfyller kravene. Ingen
#   søknadsalternativer under får tilbudsgaranti. Et tidligopptakstilbud fra før
#   gjelder uansett konklusjon, om saken er ferdig behandlet, og poengsum
#   (fagperson i STEK-269, 30.09.2026). Implementert i STEK-503.
# - (09.10.2026) Opptaksforvalter kan gjennomføre tidligopptaket mer enn én gang. En ny
#   gjennomføring tar med saker som er blitt ferdig behandlet, eller har fått
#   konklusjon, siden forrige gjennomføring. Det er likevel lurt å prøvekjøre til
#   ingen saker står igjen som ikke er ferdig behandlet eller mangler konklusjon, før
#   tidligopptaket gjennomføres. (Dokumentasjonen på STEK-503 sa at det bare
#   gjennomføres én gang. Den er rettet.)
#   Mulig forbedring, ikke et krav: sikring mot en ny gjennomføring ved en feil
#   etter at svarene er synlige for søkerne, se STEK-590 (13.10.2026).
# - (09.10.2026) Har søkeren reservert studieplass på et søknadsalternativ som tilbyr
#   tidlig opptak, får søkeren tilbudsgaranti fra tidligopptaket der uten å nå
#   poenggrensen, når søkeren deltar og saken er ferdig behandlet. Søkeren har alt en
#   plass fra et tidligere opptak. Reservasjonen gir ikke i seg selv innvilget tidlig
#   opptak (se_svar_på_tidlig_opptak.feature). Stemmer med STEK-503.
#   (13.10.2026, foreløpig) Kvalifisering kreves heller ikke: søkeren får tilbudsgaranti
#   med reservert studieplass (RSO eller RES) også når søkeren ikke er kvalifisert, eller
#   kvalifiseringen ikke er vurdert. Fagperson avklarte dette, men har sendt spørsmålet
#   videre til en annen domeneekspert, så avklaringen er foreløpig.
# - Manuell tilbudsgaranti har ingen betingelser knyttet til tidlig opptak, heller
#   ikke for typer som gjelder tidlig opptak. Tilbudsgaranti er generell, og gis av
#   flere grunner enn tidlig opptak. Betingelsen fra dagens løsning (tidligsvar bare
#   når søkeren har søkt om tidlig opptak) videreføres ikke. At tilbyder bare gir
#   FOP eller FAL til søkere med godkjent grunn (fagperson i PR #654, 01.10.2026),
#   er praksis, ikke en regel i systemet (avklart 12.10.2026).
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

    Scenario: Reservert studieplass gir tilbudsgaranti uten poenggrense
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søkeren har reservert studieplass på "Sykepleie, høst 2027"
      Og søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har 40 poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får søkeren tilbudsgaranti på "Sykepleie, høst 2027"

    @openquestion
    Scenario: Reservert studieplass gir tilbudsgaranti uten kvalifisering
      # ÅPNE SPØRSMÅL:
      # - Gir reservert studieplass (RSO eller RES) tilbudsgaranti også når søkeren ikke er
      #   kvalifisert, eller kvalifiseringen ikke er vurdert? Fagperson svarte ja 13.10.2026, men
      #   har sendt spørsmålet videre til en annen domeneekspert, så svaret er foreløpig. Koden
      #   gjør det (STEK-582). Se notatet om reservert studieplass øverst i fila.
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søkeren har reservert studieplass på "Sykepleie, høst 2027"
      Og søkeren er ikke kvalifisert til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får søkeren tilbudsgaranti på "Sykepleie, høst 2027"

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

    Scenario: Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Og opptaksforvalter har satt en tilbudsgaranti som gir tilbud på "Sykepleie, høst 2027"
      Og tilbudsgarantien er ikke for tidlig opptak
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får søkeren tilbudsgaranti for tidlig opptak på "Sykepleie, høst 2027"

    Scenario: Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og søknaden har følgende søknadsalternativer:
        | prioritet | søknadsalternativ     | tilbudsgaranti fra opptaksforvalter |
        | 1         | Historie, høst 2027   | gir tilbud                          |
        | 2         | Sykepleie, høst 2027  | ingen                               |
      Og tilbudsgarantien på "Historie, høst 2027" er ikke for tidlig opptak
      Og søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får søkeren tilbudsgaranti på "Sykepleie, høst 2027"

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

    Scenario: Ny gjennomføring tar med en sak som er blitt ferdig behandlet
      Gitt saken til søkeren var ikke ferdig behandlet da tidligopptaket ble gjennomført
      Og saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og saken er nå ferdig behandlet
      Og søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og søkeren har 55 poeng til "Sykepleie, høst 2027"
      Når opptaksforvalter gjennomfører tidligopptaket på nytt
      Så får søkeren tilbudsgaranti på "Sykepleie, høst 2027"

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
      Og opptaksforvalter ser antall søkere som er vurdert, og antall tilbudsgarantier som er satt
      Og opptaksforvalter ser antall søkere per utfall, per behandlende organisasjon og per utdanningstilbud

    # Saker uten konklusjon telles med, også når de er ferdig behandlet: de er ikke med i
    # tidligopptaket, og opptaksforvalteren gjør det samme med begge (avklart 13.10.2026).
    Scenario: Se antall saker som ikke er ferdig behandlet eller mangler konklusjon
      Gitt 2 søkere som har søkt om tidlig opptak, har saker som ikke er ferdig behandlet
      Og 1 søker som har søkt om tidlig opptak, har en ferdig behandlet sak uten konklusjon
      Når opptaksforvalter prøvekjører tidligopptaket
      Så ser opptaksforvalter at 3 saker ikke er ferdig behandlet eller mangler konklusjon

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

    Scenario: Kvotevarsel ved 30 prosent når grensen ikke er angitt
      Gitt "Sykepleie, høst 2027" har 10 plasser i kvoten tilbudsgarantiene tas fra
      Og 4 søkere oppfyller kravene til tilbudsgaranti på "Sykepleie, høst 2027"
      Når opptaksforvalter prøvekjører tidligopptaket uten å angi grensen for kvotevarsel
      Så får opptaksforvalter varsel om at tilbudsgarantiene overskrider 30 prosent av kvoten for "Sykepleie, høst 2027"

    Scenario: Angi grensen for kvotevarsel
      Gitt "Sykepleie, høst 2027" har 10 plasser i kvoten tilbudsgarantiene tas fra
      Og 6 søkere oppfyller kravene til tilbudsgaranti på "Sykepleie, høst 2027"
      Når opptaksforvalter prøvekjører tidligopptaket med varsel når mer enn 50 prosent av kvoten får tilbudsgaranti
      Så får opptaksforvalter varsel om at tilbudsgarantiene overskrider 50 prosent av kvoten for "Sykepleie, høst 2027"

    Scenario: Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak
      Gitt opptaket har ikke nøyaktig én aktiv tilbudsgarantitype for tidlig opptak som gir tilbud
      Når opptaksforvalter gjennomfører tidligopptaket
      Så får ingen søkere tilbudsgaranti
      Og opptaksforvalter ser at tilbudsgarantitypen for tidlig opptak mangler eller er tvetydig

  # Manuell tilbudsgaranti fra behandler, tilbyder og opptaksforvalter, og at
  # tilbudsgarantien følger søknadsalternativet, står i gi_tilbudsgaranti.feature
  # (OPT-BEH-BEH-010). At tilbudsgarantien gir tilbud, dekkes av
  # 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature. Reglene er flyttet
  # 14.10.2026, fordi de gjelder alle tilbudsgarantier, ikke bare tidlig opptak
  # (STEK-241, STEK-188).
  Regel: Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket

    Scenario: Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket
      Gitt behandleren har T-rolle
      Og det er ikke konkludert med at søkeren deltar i tidligopptaket
      Når behandleren setter tilbudsgaranti på "Sykepleie, høst 2027"
      Så har søkeren tilbudsgaranti på "Sykepleie, høst 2027"
