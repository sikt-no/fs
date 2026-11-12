# language: no
# Generert av fs-testcaser-cdp 2026-11-05
# Krav: krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature @ a5d270e1 (blob f9f9df0246d9ddcc52c6c14fe69c73139723330d)
#
# Scenarioene har de samme titlene som i kravet, i samme rekkefølge, og testcasene med @utledet er utledet fra reglene.
# fs-testcaser-cdp legger til scenarioene som mangler, når blob-hashen over ikke lenger er lik kravfila.
#
# Stegene som går igjen:
#
# Utfylling T: åpne fanen for tidlig opptak (som «opptak-forvalter-forvaltende»)
#   1. Gå til «Opptak», og åpne opptaket.
#   2. Velg «Gå til plasstildeling».
#   3. Velg fanen «Tidlig opptak». Lista «Utdanningstilbud» vises, med «Poenggrense tidlig opptak» per utdanningstilbud.
#
# Utfylling P: prøvekjøre tidligopptaket (etter Utfylling T)
#   1. Velg «Kjør tidligopptak». Dialogen «Kjøre tidligopptak?» åpnes, med «Dette er en prøvekjøring. …».
#   2. Vent til «Beregner resultatet…» er borte. Tabellene «Søkere» og «Resultat» vises.
#
# Utfylling G: gjennomføre tidligopptaket (etter Utfylling P)
#   1. Velg «Kjør tidligopptak» i dialogen.
#   2. «Tidligopptaket er kjørt. N tilbudsgarantier er satt totalt.» vises, og dialogen lukkes.
#   En gjennomføring publiserer svaret til søkerne, og kan ikke settes tilbake. Scenarioene med Utfylling G kjøres bare
#   i et opptak der det er avtalt («Kan gjennomføres» på «opptak-tidlig-opptak-med-sokere» i miljøfila). Ellers blir de
#   «Ikke testet».
#
# Utfylling S: se tilbudsgarantien på søknadsalternativet (som «opptak-forvalter-forvaltende»)
#   1. Gå til sakene i opptaket, søk på søknadsnummeret til søkeren, og åpne saken.
#   2. Finn søknadsalternativet. Les «Tilbudsgaranti fra forvalter» (og «Tilbudsgaranti fra tilbyder»).
#   Tilbudsgarantien gjennomføringen setter, er typen i kategorien for tidlig opptak i opptaket
#   («tilbudsgarantitype-tidlig-opptak» i miljøfila). «Ikke valgt» betyr ingen tilbudsgaranti fra forvalter.
#
# Utfylling R: sett poenggrensen tilbake (avsluttende steg)
#   1. Utfylling T. Skriv poenggrensen utdanningstilbudet hadde før scenarioet i feltet, og velg «Lagre poenggrenser».
#   2. «Poenggrensene er lagret.» vises.
@TST-OPT-BEH-BEH-001 @depends-on-OPT-BEH-BEH-007
Egenskap: Gi tilbudsgaranti ved tidlig opptak
  Opptaksforvalteren setter poenggrensene, prøvekjører og gjennomfører tidligopptaket, og søkere som deltar, er
  kvalifisert og har nok poeng, får tilbudsgaranti på det høyest prioriterte søknadsalternativet.

  Regel: Opptaksforvalter gjennomfører tidligopptaket

    @endrer-data
    Scenariomal: Tilbudsgaranti ut fra poenggrensen
      # Poenggrensen settes ut fra søkerens poengsum, så scenarioet ikke trenger én søker per eksempel.
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-oppfyller-kravene» har søkt om tidlig opptak i «opptak-tidlig-opptak-med-sokere», deltar, er kvalifisert, og har poengsummen P på søknadsalternativet med høyest prioritet
      Og jeg har åpnet fanen for tidlig opptak som i Utfylling T
      Når jeg skriver <poenggrense> i «Poenggrense tidlig opptak» for utdanningstilbudet, og velger «Lagre poenggrenser»
      Og jeg gjennomfører tidligopptaket som i Utfylling P og G
      Og jeg åpner saken som i Utfylling S
      Så står <garanti> i «Tilbudsgaranti fra forvalter» på søknadsalternativet
      # Setter tilbake:
      Og jeg setter poenggrensen tilbake som i Utfylling R

      Eksempler:
        | poenggrense | garanti                                         |
        | P minus 5   | tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» |
        | P           | tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» |
        | P pluss 5   | «Ikke valgt»                                    |

    Scenario: Søkere som ikke deltar får ikke tilbudsgaranti
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-deltar-ikke» har konklusjonen at søkeren ikke deltar, er kvalifisert og har poengsum over poenggrensen
      Og jeg har gjennomført tidligopptaket i «opptak-tidlig-opptak-med-sokere» som i Utfylling T, P og G
      Når jeg åpner saken til «soker-tidlig-opptak-deltar-ikke» som i Utfylling S
      Så står «Ikke valgt» i «Tilbudsgaranti fra forvalter» på søknadsalternativet

    Scenario: Søknader uten konklusjon er ikke med i tidligopptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-uten-konklusjon» har søkt om tidlig opptak, saken er behandlet uten konklusjon, og søkeren har poengsum over poenggrensen
      Og jeg har gjennomført tidligopptaket i «opptak-tidlig-opptak-med-sokere» som i Utfylling T, P og G
      Når jeg åpner saken til «soker-tidlig-opptak-uten-konklusjon» som i Utfylling S
      Så står «Ikke valgt» i «Tilbudsgaranti fra forvalter» på søknadsalternativet

    Scenario: Søkere som ikke er kvalifisert får ikke tilbudsgaranti
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-ikke-kvalifisert» deltar, er ikke kvalifisert, og har poengsum over poenggrensen
      Og jeg har gjennomført tidligopptaket i «opptak-tidlig-opptak-med-sokere» som i Utfylling T, P og G
      Når jeg åpner saken til «soker-tidlig-opptak-ikke-kvalifisert» som i Utfylling S
      Så står «Ikke valgt» i «Tilbudsgaranti fra forvalter» på søknadsalternativet

    @endrer-data
    Scenariomal: Tilbudsgaranti på det høyest prioriterte søknadsalternativet
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-to-alternativer» deltar, og har to søknadsalternativer som tilbyr tidlig opptak, er kvalifisert til begge, og har poengsummen P på begge
      Og jeg har åpnet fanen for tidlig opptak som i Utfylling T
      Når jeg skriver <grense prioritet 1> i «Poenggrense tidlig opptak» for søknadsalternativet med prioritet 1, og P minus 10 for søknadsalternativet med prioritet 2, og velger «Lagre poenggrenser»
      Og jeg gjennomfører tidligopptaket som i Utfylling P og G
      Og jeg åpner saken som i Utfylling S
      Så står tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet med prioritet <garanti>
      Og «Tilbudsgaranti fra forvalter» er «Ikke valgt» på søknadsalternativet med prioritet <ikke garanti>
      # Setter tilbake:
      Og jeg setter poenggrensene tilbake som i Utfylling R

      Eksempler:
        | grense prioritet 1 | garanti | ikke garanti |
        | P minus 5          | 1       | 2            |
        | P pluss 5          | 2       | 1            |

    Scenario: Bare ferdig behandlede saker er med i tidligopptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-sak-ikke-behandlet» deltar, er kvalifisert og har poengsum over poenggrensen, og saken er ikke behandlet
      Og jeg har åpnet fanen for tidlig opptak i «opptak-tidlig-opptak-med-sokere» som i Utfylling T
      Når jeg prøvekjører tidligopptaket som i Utfylling P
      Så står et tall over 0 i «Har saker som ikke er behandlet», med «Må behandles»
      Og jeg lukker dialogen med «Avbryt», gjennomfører tidligopptaket som i Utfylling P og G, og åpner saken til «soker-tidlig-opptak-sak-ikke-behandlet» som i Utfylling S
      Og «Tilbudsgaranti fra forvalter» er «Ikke valgt» på søknadsalternativet

    Scenario: Reservert studieplass gir tilbudsgaranti uten poenggrense
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-reservert-under-grensen» deltar, er kvalifisert, har reservert studieplass på søknadsalternativet, og har poengsum under poenggrensen
      Og jeg har gjennomført tidligopptaket i «opptak-tidlig-opptak-med-sokere» som i Utfylling T, P og G
      Når jeg åpner saken til «soker-tidlig-opptak-reservert-under-grensen» som i Utfylling S
      Så står tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet

    Scenario: Reservert studieplass gir tilbudsgaranti uten kvalifisering
      # Kravet har et åpent spørsmål om dette, og scenarioet testes som det står.
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-reservert-ikke-kvalifisert» deltar, har reservert studieplass på søknadsalternativet, og er ikke kvalifisert
      Og jeg har gjennomført tidligopptaket i «opptak-tidlig-opptak-med-sokere» som i Utfylling T, P og G
      Når jeg åpner saken til «soker-tidlig-opptak-reservert-ikke-kvalifisert» som i Utfylling S
      Så står tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet

    Scenario: Den høyeste poengsummen til søknadsalternativet gjelder
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-poeng-flere-kvoter» deltar, er kvalifisert, har poengsum under poenggrensen i ordinær kvote, og over poenggrensen i en annen kvote på søknadsalternativet
      Og jeg har gjennomført tidligopptaket i «opptak-tidlig-opptak-med-sokere» som i Utfylling T, P og G
      Når jeg åpner saken til «soker-tidlig-opptak-poeng-flere-kvoter» som i Utfylling S
      Så står tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet

    @endrer-data
    Scenario: Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-oppfyller-kravene» deltar, er kvalifisert og har poengsum over poenggrensen
      Og jeg har åpnet saken til «soker-tidlig-opptak-oppfyller-kravene» som i Utfylling S
      Og jeg har valgt tilbudsgarantitypen «tilbudsgarantitype-gir-ikke-tilbud» i «Tilbudsgaranti fra forvalter» på søknadsalternativet, og ser «Tilbudsgaranti lagret»
      Når jeg gjennomfører tidligopptaket som i Utfylling T, P og G
      Og jeg åpner saken som i Utfylling S
      Så står tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet

    @endrer-data
    Scenario: Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-oppfyller-kravene» deltar, er kvalifisert og har poengsum over poenggrensen
      Og jeg har åpnet saken til «soker-tidlig-opptak-oppfyller-kravene» som i Utfylling S
      Og jeg har valgt tilbudsgarantitypen «tilbudsgarantitype-gir-tilbud-ikke-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet, og ser «Tilbudsgaranti lagret»
      Når jeg gjennomfører tidligopptaket som i Utfylling T, P og G
      Og jeg åpner saken som i Utfylling S
      Så står tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet

    Scenario: Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-annen-garanti-hoyere-prioritet» deltar, har tilbudsgarantitypen «tilbudsgarantitype-gir-tilbud-ikke-tidlig-opptak» fra forvalter på søknadsalternativet med prioritet 1, og er kvalifisert og har poengsum over poenggrensen på søknadsalternativet med prioritet 2, som tilbyr tidlig opptak
      Og jeg har gjennomført tidligopptaket i «opptak-tidlig-opptak-med-sokere» som i Utfylling T, P og G
      Når jeg åpner saken til «soker-tidlig-opptak-annen-garanti-hoyere-prioritet» som i Utfylling S
      Så står tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet med prioritet 2

    @endrer-data
    Scenario: Tidligopptakstilbud fra tilbyder går foran poengsummen
      Gitt jeg er logget inn som «opptak-tilbyder»
      Og søkeren «soker-tidlig-opptak-to-alternativer» deltar, og har to søknadsalternativer som tilbyr tidlig opptak, med poengsum over poenggrensen på søknadsalternativet med prioritet 2
      Og jeg har åpnet saken til «soker-tidlig-opptak-to-alternativer», og valgt tilbudsgarantitypen «tilbudsgarantitype-tidligopptakstilbud-tilbyder» i «Tilbudsgaranti fra tilbyder» på søknadsalternativet med prioritet 1, og ser «Tilbudsgaranti lagret»
      Og jeg bytter testbruker til «opptak-forvalter-forvaltende»
      Når jeg gjennomfører tidligopptaket i «opptak-tidlig-opptak-med-sokere» som i Utfylling T, P og G
      Og jeg åpner saken som i Utfylling S
      Så står tilbudsgarantitypen «tilbudsgarantitype-tidligopptakstilbud-tilbyder» i «Tilbudsgaranti fra tilbyder» på søknadsalternativet med prioritet 1
      Og «Tilbudsgaranti fra forvalter» er «Ikke valgt» på søknadsalternativet med prioritet 2
      # Setter tilbake:
      Og jeg bytter testbruker til «opptak-tilbyder», og velger «Ikke valgt» i «Tilbudsgaranti fra tilbyder» på søknadsalternativet med prioritet 1

    @endrer-data
    Scenario: En ny gjennomføring fjerner ikke tilbudsgarantien
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-oppfyller-kravene» har tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» etter at tidligopptaket er gjennomført, med poengsummen P
      Og jeg har åpnet fanen for tidlig opptak i «opptak-tidlig-opptak-med-sokere» som i Utfylling T
      Når jeg skriver P pluss 5 i «Poenggrense tidlig opptak» for utdanningstilbudet, og velger «Lagre poenggrenser»
      Og jeg gjennomfører tidligopptaket som i Utfylling P og G
      Og jeg åpner saken som i Utfylling S
      Så står fortsatt tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet
      # Setter tilbake:
      Og jeg setter poenggrensen tilbake som i Utfylling R

    Scenario: Ny gjennomføring tar med en sak som er blitt ferdig behandlet
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-behandlet-etter-gjennomforing» deltar, er kvalifisert og har poengsum over poenggrensen, og saken ble behandlet etter forrige gjennomføring
      Og jeg har åpnet saken til «soker-tidlig-opptak-behandlet-etter-gjennomforing» som i Utfylling S, og ser «Ikke valgt» i «Tilbudsgaranti fra forvalter»
      Når jeg gjennomfører tidligopptaket i «opptak-tidlig-opptak-med-sokere» på nytt som i Utfylling T, P og G
      Og jeg åpner saken som i Utfylling S
      Så står tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet

    @endrer-data
    Scenario: Tilbudsgarantien flyttes til et høyere prioritert søknadsalternativ ved ny gjennomføring
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-to-alternativer» deltar, og har to søknadsalternativer som tilbyr tidlig opptak, er kvalifisert til begge, og har poengsummen P på begge
      Og jeg har skrevet P pluss 5 i «Poenggrense tidlig opptak» for søknadsalternativet med prioritet 1, og P minus 10 for søknadsalternativet med prioritet 2, lagret, og gjennomført tidligopptaket som i Utfylling T, P og G
      Og jeg ser tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet med prioritet 2, som i Utfylling S
      Når jeg skriver P minus 5 i «Poenggrense tidlig opptak» for søknadsalternativet med prioritet 1, og velger «Lagre poenggrenser»
      Og jeg gjennomfører tidligopptaket som i Utfylling P og G
      Og jeg åpner saken som i Utfylling S
      Så står tilbudsgarantitypen «tilbudsgarantitype-tidlig-opptak» i «Tilbudsgaranti fra forvalter» på søknadsalternativet med prioritet 1
      Og «Tilbudsgaranti fra forvalter» er «Ikke valgt» på søknadsalternativet med prioritet 2
      # Setter tilbake:
      Og jeg setter poenggrensene tilbake som i Utfylling R

    Scenario: Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak
      # Krever at plasstildelingen i hovedopptaket kan kjøres i opptaket. [Sjekk begrep: stegene i plasstildelingen]
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-deltar-ikke» har «Ikke valgt» i «Tilbudsgaranti fra forvalter» etter at tidligopptaket er gjennomført i «opptak-tidlig-opptak-med-sokere»
      Når jeg velger «Gå til plasstildeling» i opptaket, og kjører plasstildelingen [Sjekk begrep]
      Så står søknadsalternativet til «soker-tidlig-opptak-deltar-ikke» i resultatet fra plasstildelingen, med et resultat fra den ordinære rangeringen [Sjekk begrep]

    # Teknikk: grenseverdianalyse (0 og 999,9 er gyldige, under 0 og over 999,9 rettes til grensen; én desimal)
    @utledet @endrer-data
    Scenariomal: Opptaksforvalter gjennomfører tidligopptaket: poenggrensen <verdi>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen for tidlig opptak i «opptak-samordna-tidlig-opptak» som i Utfylling T
      Når jeg skriver «<verdi>» i «Poenggrense tidlig opptak» for utdanningstilbudet «utdanningstilbud-deltakende», og går ut av feltet
      Så står «<vises>» i feltet
      Og når jeg velger «Lagre poenggrenser», åpner siden på nytt og velger fanen «Tidlig opptak», står «<vises>» i feltet
      # Setter tilbake:
      Og jeg skriver «50» i feltet, og velger «Lagre poenggrenser»

      Eksempler:
        | verdi  | vises                          |
        | 0      | 0,0                            |
        | 999,9  | 999,9                          |
        | 1000   | 999,9                          |
        | -1     | 0,0 [Sjekk begrep: minustegnet] |
        | 50,55  | én desimal [Sjekk begrep: 50,5 eller 50,6] |

    # Teknikk: tilstandsoverganger (endret og ikke lagret → lagret)
    @utledet @endrer-data
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: poenggrenser som ikke er lagret
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen for tidlig opptak i «opptak-samordna-tidlig-opptak» som i Utfylling T
      Når jeg skriver «60» i «Poenggrense tidlig opptak» for utdanningstilbudet «utdanningstilbud-deltakende», uten å lagre
      Og jeg velger «Kjør tidligopptak»
      Så ser jeg «Du har poenggrenser som ikke er lagret. Lagre dem før du kjører tidligopptak, så kjøringen bruker de nye grensene.» i dialogen «Kjøre tidligopptak?»
      Og «Kjør tidligopptak» i dialogen er ikke tilgjengelig, og tabellene «Søkere» og «Resultat» vises ikke
      Og når jeg velger «Avbryt», velger «Lagre poenggrenser», ser «Poenggrensene er lagret.» og velger «Kjør tidligopptak» igjen, vises «Beregner resultatet…» eller tabellene «Søkere» og «Resultat»
      # Setter tilbake:
      Og jeg velger «Avbryt», skriver «50» i feltet, og velger «Lagre poenggrenser»

    # Teknikk: ekvivalensklasser (prøvekjøring og gjennomføring; prøvekjøringen lagrer ingenting)
    @utledet
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: prøvekjøringen lagrer ingenting
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-oppfyller-kravene» har «Ikke valgt» i «Tilbudsgaranti fra forvalter» på søknadsalternativet, som i Utfylling S
      Og jeg har åpnet fanen for tidlig opptak i «opptak-tidlig-opptak-med-sokere» som i Utfylling T
      Når jeg prøvekjører tidligopptaket som i Utfylling P, og noterer tallene i «Søkere» og «Resultat»
      Og jeg velger «Avbryt», og prøvekjører igjen som i Utfylling P
      Så er tallene i «Søkere» og «Resultat» de samme som første gang
      Og når jeg velger «Avbryt» og åpner saken til «soker-tidlig-opptak-oppfyller-kravene» som i Utfylling S, står fortsatt «Ikke valgt» i «Tilbudsgaranti fra forvalter»

    # Teknikk: ekvivalensklasser (tilbyr tidlig opptak / tilbyr ikke tidlig opptak)
    @utledet
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: utdanningstilbud som ikke tilbyr tidlig opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen for tidlig opptak i «opptak-samordna-tidlig-opptak» som i Utfylling T
      Når jeg finner utdanningstilbudet «utdanningstilbud-deltakende-uten-tidlig-opptak» i lista
      Så står «Ikke tidlig opptak her» i «Poenggrense tidlig opptak», og det er ikke noe felt for poenggrensen
      Og utdanningstilbudet «utdanningstilbud-deltakende» har et felt for poenggrensen

    # Teknikk: – (det som vises over og i lista)
    @utledet
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: fristen for poenggrensene
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner fanen for tidlig opptak i «opptak-samordna-tidlig-opptak» som i Utfylling T
      Så ser jeg «Frist for å fylle inn poenggrenser:» med datoen {DATO:+75} og klokkeslettet 23:59
      Og kolonnene «T.O. søkere totalt» og «T.O. søkere 1. pri.» vises i lista

  Regel: Opptaksforvalter ser utfallet av tidligopptaket

    @endrer-data
    Scenario: Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon
      # Saker uten konklusjon telles med, også når de er behandlet. Tallet i skjermen er antall søkere.
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-tidlig-opptak-uten-konklusjon» har søkt om tidlig opptak, og saken er behandlet uten konklusjon
      Og jeg har prøvekjørt tidligopptaket i «opptak-tidlig-opptak-med-sokere» som i Utfylling T og P, og noterer tallet N i «Har saker som ikke er behandlet»
      Når jeg velger «Avbryt», åpner saken til «soker-tidlig-opptak-uten-konklusjon», og velger konklusjonen «konklusjon-deltar» i «Konklusjon» under tidlig opptak
      Og jeg prøvekjører tidligopptaket igjen som i Utfylling T og P
      Så står N minus 1 i «Har saker som ikke er behandlet»
      Og står det 0, vises «Alt behandlet». Ellers vises «Må behandles»
      # Setter tilbake:
      Og jeg velger «Avbryt», åpner saken til «soker-tidlig-opptak-uten-konklusjon», og velger «Ikke valgt» i «Konklusjon»

    Scenario: Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-tidlig-opptak-uten-tilbudsgarantitype» har ikke nøyaktig én aktiv tilbudsgarantitype for tidlig opptak som gir tilbud
      Og jeg har åpnet fanen for tidlig opptak som i Utfylling T
      Når jeg velger «Kjør tidligopptak»
      Så ser jeg en feilmelding i dialogen «Kjøre tidligopptak?» som sier at tilbudsgarantitypen for tidlig opptak mangler eller er tvetydig («Fant ingen tilbudsgarantitype …» eller «Fant N tilbudsgarantityper …») [Sjekk begrep: meldingen er fra API-et]
      Og «Kjør tidligopptak» i dialogen er ikke tilgjengelig

  Regel: Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket

    @endrer-data
    Scenario: Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket
      Gitt jeg er logget inn som «opptak-tilbyder»
      Og søkeren «soker-tidlig-opptak-uten-konklusjon» har søkt om tidlig opptak, uten konklusjon, og har «Ikke valgt» i «Tilbudsgaranti fra tilbyder»
      Og jeg har åpnet saken til «soker-tidlig-opptak-uten-konklusjon» i «opptak-tidlig-opptak-med-sokere»
      Når jeg velger tilbudsgarantitypen «tilbudsgarantitype-tidligopptakstilbud-tilbyder» i «Tilbudsgaranti fra tilbyder» på søknadsalternativet
      Og jeg ser «Tilbudsgaranti lagret», og åpner saken på nytt
      Så står tilbudsgarantitypen «tilbudsgarantitype-tidligopptakstilbud-tilbyder» i «Tilbudsgaranti fra tilbyder» på søknadsalternativet
      # Setter tilbake:
      Og jeg velger «Ikke valgt» i «Tilbudsgaranti fra tilbyder», og ser «Tilbudsgaranti lagret»
