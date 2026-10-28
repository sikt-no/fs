# language: no
# Generert av fs-testcaser-cdp 2026-10-27
# Krav: krav/02 Opptak/11 Opprette og vedlikeholde opptak/07 Oversikt over opptak/listevisning_og_sok_i_opptak.feature @ 0f010d4 (blob d36c44ad7668865284438ddd0ffa1616503188ad)
#
# Lista viser også «Status», som ikke er med i kravet.
# Hvilke opptak testbrukeren ser, avhenger av flagget «opptak-filter-organisasjon» (se miljøfila).
@TST-OPT-OVO-OVE-001 @depends-on-OPT-OVO-OVE-001
Egenskap: Listevisning og søk i opptak
  Opptaksforvalteren ser en liste over opptakene på «Opptak», kan søke på navn, filtrere på type, sortere og
  åpne et opptak.

  Regel: Liste over alle opptak

    Scenario: Se liste over opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptakene i «opptak-oversikt-flere-typer» finnes
      Når jeg går til «Opptak»
      Så ser jeg en liste under «Opptak» med minst to opptak
      Og lista har disse kolonnene
        | Kolonne         |
        | Navn            |
        | Type            |
        | Organisasjon    |
        | Opprettet       |
        | Utdanningstilbud |
      # Kravet kaller kolonnen «Antall utdanningstilbud». Skjermen kaller den «Utdanningstilbud», og viser et tall.

    Scenario: Liste er sortert etter når opptaket ble opprettet som standard
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptakene i «opptak-oversikt-flere-typer» finnes
      Når jeg går til «Opptak»
      Så står «Sortert etter» «Opprettet» og «Synkende» ved «Sortering» [Sjekk begrep: hvordan valget vises]
      Og datoene i «Opprettet» går fra nyeste til eldste nedover i lista

    # «Sortering» åpner «Sorteringsfelt» med «Opprettet», «Status», «Type» og «Organisasjon». «Endre sorteringsretning» bytter mellom «Stigende» og «Synkende».
    # Organisasjon sorteres på organisasjonskoden, ikke forkortelsen som vises. Se den utledede testcasen.
    Scenariomal: Velge sorteringsretning for <felt>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptakene i «opptak-oversikt-flere-typer» finnes
      Og jeg har åpnet «Opptak»
      Når jeg velger «<kolonne>» i «Sorteringsfelt» under «Sortering»
      Og jeg velger «<retning på skjermen>» med «Endre sorteringsretning»
      Så står «Sortert etter» «<kolonne>» og «<retning på skjermen>»
      Og verdiene i «<kolonne>» står i <retning> rekkefølge nedover i lista <hvordan>

      Eksempler:
        | felt         | retning  | kolonne      | retning på skjermen | hvordan                                       |
        | opprettet    | stigende | Opprettet    | Stigende            | (eldste først)                                |
        | opprettet    | synkende | Opprettet    | Synkende            | (nyeste først)                                |
        | type         | stigende | Type         | Stigende            | (alfabetisk)                                  |
        | type         | synkende | Type         | Synkende            | (omvendt alfabetisk)                          |
        | organisasjon | stigende | Organisasjon | Stigende            | (etter organisasjonskoden, se kommentaren)    |
        | organisasjon | synkende | Organisasjon | Synkende            | (etter organisasjonskoden, se kommentaren)    |

    # Teknikk: ekvivalensklasser (sorteringsnøkkelen for organisasjon er koden, ikke teksten som vises)
    # Testcasen dokumenterer rekkefølgen, og er bestått når rekkefølgen følger organisasjonskoden.
    @utledet
    Scenario: Liste over alle opptak: rekkefølgen etter sortering på organisasjon
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptakene i «opptak-oversikt-flere-typer» finnes ved minst to organisasjoner
      Og jeg har åpnet «Opptak»
      Når jeg velger «Organisasjon» i «Sorteringsfelt» under «Sortering»
      Og jeg velger «Stigende» med «Endre sorteringsretning»
      Så følger rekkefølgen i «Organisasjon» organisasjonskodene [Sjekk testdata: organisasjonskodene i «opptak-oversikt-flere-typer»], ikke forkortelsene alfabetisk

    Scenario: Alle opptak er lastet inn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og testbrukeren ser færre enn 51 opptak
      Når jeg går til «Opptak»
      Så viser «Viser N av M rader» like tall for N og M
      Og jeg ser ikke «Last inn flere»

    Scenario: Navigere til detaljside for opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-samordna-uten-utdanningstilbud» finnes
      Og jeg har åpnet «Opptak»
      Når jeg skriver navnet på opptaket «opptak-samordna-uten-utdanningstilbud» i «Opptaksnavn»
      Og jeg velger opptaket i lista
      Så ser jeg siden til opptaket, med navnet på opptaket øverst
      Og jeg ser «Oppsummert» og «Oppgaver»

  Regel: Søk og filtrering av opptak

    Scenario: Fritekst-søk på navn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-samordna-uten-utdanningstilbud» finnes
      Og jeg har åpnet «Opptak»
      Når jeg skriver navnet på opptaket «opptak-samordna-uten-utdanningstilbud» i «Opptaksnavn»
      Så står opptaket i lista
      Og hver rad i lista har søketeksten i «Navn»

    # Teknikk: ekvivalensklasser (store og små bokstaver, del av navnet, nynorsk og engelsk navn, ingen treff)
    # [Sjekk testdata: navnene på nynorsk og engelsk må være ulike bokmål, ellers prøver ikke de to radene noe nytt]
    @utledet
    Scenariomal: Søk og filtrering av opptak: søk på <søket>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-samordna-uten-utdanningstilbud» finnes
      Og jeg har åpnet «Opptak»
      Når jeg skriver «<søketekst>» i «Opptaksnavn»
      Så <resultat>

      Eksempler:
        | søket                 | søketekst                                                       | resultat                                                                      |
        | små bokstaver         | navnet på bokmål med små bokstaver                              | står opptaket «opptak-samordna-uten-utdanningstilbud» i lista                 |
        | store bokstaver       | navnet på bokmål med store bokstaver                            | står opptaket «opptak-samordna-uten-utdanningstilbud» i lista                 |
        | del av navnet         | de tre første ordene i navnet på bokmål                         | står opptaket «opptak-samordna-uten-utdanningstilbud» i lista                 |
        | navnet på nynorsk     | navnet på nynorsk                                               | står opptaket «opptak-samordna-uten-utdanningstilbud» i lista                 |
        | navnet på engelsk     | navnet på engelsk                                               | står opptaket «opptak-samordna-uten-utdanningstilbud» i lista                 |
        | ingen treff           | Finnes ikke qzx                                                 | ser jeg «Ingen opptak funnet» og «Prøv å justere filtrene dine»               |
      # Søket på nynorsk og engelsk: kravet sier «søk på navn», ikke hvilket språk. Treffer det ikke, er det et funn av typen «Kravet dekker ikke».

    # AVKLART 2026-10-21 i kravet: ingen opptakstype er valgt når filteret åpnes, og filteret har ikke valget «Alle opptakstyper».
    Scenario: Tilgjengelige opptakstyper i filter
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Opptak»
      Når jeg åpner «Type»-filteret
      Så er valgene «Lokalt opptak», «Samordna opptak til fagskoler» og «Samordna opptak til universiteter og høgskoler» [Sjekk begrep: filteret kan vise kodene «LOKAL», «FSU» og «UHG»]
      Og valgene står i alfabetisk rekkefølge
      Og ingen av valgene er valgt

    Scenario: Filtrere på opptakstype
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptakene i «opptak-oversikt-flere-typer» finnes
      Og jeg har åpnet «Opptak»
      Når jeg velger «Samordna opptak til universiteter og høgskoler» i «Type»-filteret
      Så har hver rad i lista samme type i «Type» [Sjekk begrep: lista viser koden «UHG»]
      Og lista har minst én rad

    Scenario: Kombinere filtre
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptakene i «opptak-oversikt-flere-typer» finnes
      Og jeg har åpnet «Opptak»
      Når jeg skriver «test» i «Opptaksnavn»
      Og jeg velger «Samordna opptak til universiteter og høgskoler» i «Type»-filteret
      Så har hver rad i lista «test» i «Navn» og samme type i «Type»
      Og lista har færre eller like mange rader som da bare «Opptaksnavn» var fylt ut
