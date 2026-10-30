# language: no
@OPT-PLA-INN-003 @should @draft @scope-plasstildeling-2027 @depends-on-OPT-PLA-INN-001
Egenskap: Kontrollere antall tilbud som skal gis
  Som opptaksforvalter
  ønsker jeg å finne utdanningstilbudene der antall tilbud som skal gis bør sjekkes
  slik at feil kan rettes før plasstildelingen.

  # Skilt ut 2026-10-28 (produkteier) fra antall_tilbud_som_skal_gis.feature, så søk, sortering, varsel og
  # kontroll kan leveres etter det som er @must. Filteret på om antall tilbud er satt, står der.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"

  Regel: Opptaksforvalter kan søke, filtrere og sortere utdanningstilbudene
    # Lagt til 2026-10-28 etter brukertestene med HK-dir (oktober 2026): «filtrere på lærested», «søk på navn» og
    # «sortering på alle kolonnene». Følger mønsteret for listevisning (.claude/rules/listevisning-pattern.md).

    Scenariomal: Velge sorteringsretning for <felt>
      Når opptaksforvalter velger å sortere på <felt> i <retning> rekkefølge
      Så vises utdanningstilbudene sortert etter <felt> i <retning> rekkefølge

      Eksempler:
        | felt                                   | retning  |
        | utdanningstilbud                       | stigende |
        | utdanningstilbud                       | synkende |
        | tilbyder                               | stigende |
        | studieplasser                          | synkende |
        | ledige plasser å gi tilbud til         | synkende |
        | antall tilbud som skal gis i runden    | synkende |

    Scenario: Fritekst-søk på navn
      Når opptaksforvalter søker med fritekst på navnet på utdanningstilbudet
      Så filtreres listen til utdanningstilbud som matcher søket

    Scenario: Tilgjengelige tilbydere i filter
      Når opptaksforvalter åpner tilbyderfilteret
      Så viser tilbyderfilteret organisasjonene som tilbyr utdanningstilbud i opptaket
      Og hver organisasjon vises kun én gang
      Og organisasjonene er sortert alfabetisk
      Og "Alle tilbydere" er valgt som standard

    Scenario: Filtrere på tilbyder
      Når opptaksforvalter velger "Universitetet i Bergen" som filter
      Så vises kun utdanningstilbudene "Universitetet i Bergen" tilbyr

    Scenario: Tilbyderne i filteret vises med akronym
      Når opptaksforvalter åpner tilbyderfilteret
      Så vises akronymet under navnet på hver organisasjon
      Men organisasjonskoden vises når organisasjonen ikke har akronym

    Scenario: Søke i tilbyderfilteret
      Når opptaksforvalter skriver inn tekst i tilbyderfilteret
      Så viser tilbyderfilteret bare organisasjonene der navnet eller akronymet inneholder den innskrevne teksten

    Scenario: Kombinere filtre
      Når opptaksforvalter kombinerer filteret for antall tilbud med tilbyderfilteret
      Så vises kun utdanningstilbud som matcher alle kriteriene

  Regel: Opptaksforvalter varsles når antall tilbud som skal gis er høyere enn ledige plasser
    # Lagt til 2026-10-28 etter brukertesten med HK-dir 2026-10-27 («varsel om overskredet antall plasser»).
    # Varselet stopper ikke lagringen: et lærested kan ha grunn til å gi flere tilbud enn ledige plasser.

    Scenario: Varsel når antall tilbud er høyere enn ledige plasser
      Gitt at ledige plasser å gi tilbud til for "Sykepleie, høst 2027" er 42
      Når opptaksforvalter setter totalt antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" for "Sykepleie, høst 2027" til 50
      Så får utdanningstilbudet "Sykepleie, høst 2027" et varsel om at antall tilbud som skal gis er høyere enn ledige plasser
      Men antall tilbud som skal gis er lagret

    Scenario: Ingen varsel når antall tilbud er innenfor ledige plasser
      Gitt at ledige plasser å gi tilbud til for "Sykepleie, høst 2027" er 42
      Når opptaksforvalter setter totalt antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" for "Sykepleie, høst 2027" til 40
      Så får utdanningstilbudet "Sykepleie, høst 2027" ikke varsel om antall tilbud

  @openquestion
  Regel: Opptakets forvalter kontrollerer antall tilbud lærestedene har satt før plasstildelingen
    # ÅPNE SPØRSMÅL:
    # - Hvilken terskel skal antall tilbud som skal gis sammenlignes med studieplassene etter?
    # - Hva skal antall tilbud sammenlignes med for å vurdere overbooking? HK-10169 (statistikk for overbooking
    #   fra tidligere år) er ikke dekket.
    # Lagt til 2026-10-28 etter brukertesten med HK-dir 2026-10-27: HK-dir kontrollerer det lærestedene har satt:
    # «ønska tilbud opp mot planlagte studieplasser (terskelverdi?), alle kvalifiserte tilbud, mangler antall tilbud
    # som skal gis, antall tilbud som skal gis opp mot overbooking».

    Scenariomal: Opptakets forvalter ser utdanningstilbud som skal kontrolleres
      Gitt at lærestedene har satt antall tilbud som skal gis for plasstildelingsrunden "Hovedrunde"
      Når opptakets forvalter kontrollerer antall tilbud som skal gis i "Hovedrunde"
      Så ser opptakets forvalter utdanningstilbudene som <avvik>

      Eksempler:
        | avvik                                                        |
        | har antall tilbud som skal gis over terskelen for studieplassene |
        | gir tilbud til alle kvalifiserte                             |
        | mangler antall tilbud i minst én utdanningskvote             |
