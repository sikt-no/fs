# language: no

@GJE-STU-PLA-01 @must
Egenskap: Studieplanlegging for studenter
  Som en student på et studieprogram
  Ønsker jeg å planlegge min studieprogresjon
  Slik at jeg kan fullføre graden min innen normert tid

  # ÅPNE SPØRSMÅL:
  # - Venteliste: Skal studenter automatisk flyttes fra venteliste ved avmelding?
  # - Varslinger: Hvilke hendelser skal utløse e-postvarsling til veileder?

  Studieplanlegging er en kritisk funksjon som lar studenter
  velge emner for kommende semestre basert på studieprogrammets
  krav og egne interesser. Planen må ta hensyn til forutsetninger,
  kapasitet og studiepoengkrav.

  Bakgrunn:
    Gitt studenten "Emma Larsen" med studentnummer "123456" er logget inn
    Og studenten er på studieprogrammet "Informatikk - bachelor"
    Og studieprogrammet krever 180 studiepoeng for fullføring
    Og studenten har fullført 60 studiepoeng
    Og følgende emner er tilgjengelige for neste semester:
      | emnekode | emnenavn                        | studiepoeng | forutsetninger | kapasitet |
      | INF2100  | Prosjektarbeid i informatikk    | 10          | INF1000        | 30        |
      | INF2200  | Datamaskinarkitektur            | 10          |                | 50        |
      | MAT2000  | Lineær algebra                  | 10          | MAT1000        | 100       |
      | INF2300  | Databaser og datamodellering    | 10          | INF1000        | 40        |
      | FIL1000  | Examen philosophicum            | 10          |                | 200       |

  @must @implemented
  Regel: Studenter kan legge til emner i studieplanen sin

    Denne regelen dekker den grunnleggende funksjonaliteten for å
    bygge opp en studieplan ved å legge til emner.

    @must @implemented
    Scenario: Legge til et emne i studieplanen
      Gitt studieplanen for neste semester er tom
      Og emnet "INF2200" har 45 ledige plasser
      Når studenten legger til "INF2200" i studieplanen
      Så skal "INF2200" vises i studieplanen
      Og antall planlagte studiepoeng skal være 10
      Og emnet skal vises med status "planlagt"

    @should @planned
    Scenario: Legge til flere emner i studieplanen
      Gitt studieplanen inneholder emnet "INF2200"
      Når studenten legger til følgende emner:
        | emnekode |
        | MAT2000  |
        | FIL1000  |
      Så skal studieplanen inneholde 3 emner
      Og antall planlagte studiepoeng skal være 30

    @must @implemented
    Scenario: Maksimalt antall studiepoeng per semester
      Gitt studieprogrammet tillater maksimalt 30 studiepoeng per semester
      Og studieplanen inneholder emner med totalt 20 studiepoeng
      Når studenten legger til et emne med 10 studiepoeng
      Så skal emnet bli lagt til i studieplanen
      Og studenten skal se informasjonen "Du har nå planlagt maksimalt antall studiepoeng"

  @must @implemented
  Regel: Emner med forutsetninger kan kun planlegges hvis forutsetningene er oppfylt

    Systemet skal automatisk verifisere at studenten har bestått
    nødvendige forutsetningsemner før et emne kan legges til i planen.

    @must @implemented
    Scenario: Planlegge emne med oppfylte forutsetninger
      Gitt studenten har bestått "INF1000" med karakter "B"
      Og emnet "INF2100" krever "INF1000" som forutsetning
      Når studenten legger til "INF2100" i studieplanen
      Så skal emnet bli lagt til i studieplanen
      Og forutsetningsstatusen skal vises som "oppfylt"

    @must @implemented
    Scenario: Kan ikke planlegge emne med manglende forutsetninger
      Gitt studenten ikke har bestått "MAT1000"
      Og emnet "MAT2000" krever "MAT1000" som forutsetning
      Når studenten forsøker å legge til "MAT2000" i studieplanen
      Så skal studenten se feilmeldingen "Du mangler forutsetningen: MAT1000 - Kalkulus"
      Og emnet skal ikke legges til i studieplanen
      Og studenten skal se en lenke til emnebeskrivelsen for "MAT1000"

    @should @in-progress
    Scenario: Emne med flere manglende forutsetninger
      Gitt emnet "INF3000" krever følgende forutsetninger:
        | emnekode | emnenavn                     |
        | INF2100  | Prosjektarbeid i informatikk |
        | INF2300  | Databaser og datamodellering |
      Og studenten har ikke bestått noen av disse emnene
      Når studenten forsøker å legge til "INF3000" i studieplanen
      Så skal studenten se feilmeldingen:
        """
        Du mangler følgende forutsetninger:
        - INF2100 - Prosjektarbeid i informatikk
        - INF2300 - Databaser og datamodellering
        """
      Og emnet skal ikke legges til i studieplanen

  @should @planned
  Regel: Studieplanen må ta hensyn til emnekapasitet

    Når studenter planlegger emner, skal systemet vise tilgjengelig
    kapasitet og varsle om emner som kan bli fulle.

    @should @planned
    Scenario: Planlegge emne med god kapasitet
      Gitt emnet "FIL1000" har kapasitet på 200 studenter
      Og det er 50 studenter som har planlagt emnet
      Når studenten legger til "FIL1000" i studieplanen
      Så skal emnet bli lagt til med kapasitetsindikator "god"
      Og studenten skal se "150 plasser tilgjengelig"

    @should @planned
    Scenario: Planlegge emne med begrenset kapasitet
      Gitt emnet "INF2100" har kapasitet på 30 studenter
      Og det er 25 studenter som har planlagt emnet
      Når studenten legger til "INF2100" i studieplanen
      Så skal emnet bli lagt til med kapasitetsindikator "begrenset"
      Og studenten skal se advarselen "Kun 5 plasser igjen - tidlig påmelding anbefales"

    @must @planned
    Scenario: Planlegge emne som er fullt
      Gitt emnet "INF2100" har kapasitet på 30 studenter
      Og det er 30 studenter som allerede har planlagt emnet
      Når studenten forsøker å legge til "INF2100" i studieplanen
      Så skal studenten se advarselen "Emnet er fullt - du blir satt på venteliste"
      Og studenten skal få valget:
        | alternativ                           |
        | Legg til på venteliste               |
        | Velg et annet emne                   |
        | Få varsel når plass blir ledig       |

  @must @implemented
  Regel: Studieplanen må følge studieprogrammets krav til studiepoeng

    @must @implemented
    Scenario: Kan ikke overskride maksimalt antall studiepoeng
      Gitt studieprogrammet tillater maksimalt 30 studiepoeng per semester
      Og studieplanen inneholder emner med totalt 30 studiepoeng
      Når studenten forsøker å legge til et emne med 10 studiepoeng
      Så skal studenten se feilmeldingen "Maksimalt 30 studiepoeng per semester"
      Og emnet skal ikke legges til i studieplanen
      Og studenten skal se en lenke til "Søk om utvidet studiebelastning"

    @could @planned
    Scenario: Systemet anbefaler studiepoeng for normert progresjon
      Gitt studenten har fullført 60 av 180 studiepoeng
      Og studenten er i sitt tredje semester
      Når studenten åpner studieplanleggeren
      Så skal systemet anbefale "30 studiepoeng dette semesteret for normert progresjon"
      Og studenten skal se en progresjonsgraf

  @must @in-progress
  Regel: Studieplanen må valideres før den kan sendes til godkjenning

    @must @implemented
    Scenario: Gyldig studieplan sendes til godkjenning
      Gitt studieplanen inneholder følgende emner:
        | emnekode | emnenavn                     | studiepoeng | status   |
        | INF2200  | Datamaskinarkitektur         | 10          | planlagt |
        | FIL1000  | Examen philosophicum         | 10          | planlagt |
        | INF2300  | Databaser og datamodellering | 10          | planlagt |
      Og alle forutsetninger er oppfylt
      Og totalt antall studiepoeng er 30
      Når studenten klikker på "Send til godkjenning"
      Så skal studieplanen få status "venter på godkjenning"
      Og studieveileder skal motta varsel om ny studieplan
      Og studenten skal se bekreftelsen "Studieplanen er sendt til godkjenning"

    @must @in-progress
    Scenariomal: Ugyldig studieplan kan ikke sendes til godkjenning
      Gitt studieplanen har følgende problem: <problem>
      Når studenten forsøker å sende planen til godkjenning
      Så skal studenten se feilmeldingen "<feilmelding>"
      Og studieplanen skal ikke sendes til godkjenning
      Og problemet skal markeres i studieplanen

      Eksempler:
        | problem                              | feilmelding                                        |
        | ingen emner valgt                    | Studieplanen må inneholde minst ett emne           |
        | manglende forutsetninger             | Noen emner har uoppfylte forutsetninger            |
        | overstiger maks studiepoeng          | Studieplanen overstiger maksimalt antall studiepoeng |
        | emne med tidskollisjon               | To emner har overlappende undervisningstid         |

  @should @planned
  Regel: Studenter kan endre studieplanen før godkjenningsfristen

    @should @implemented
    Scenario: Fjerne emne fra studieplanen
      Gitt studieplanen inneholder emnene "INF2200" og "FIL1000"
      Og studieplanen har status "kladd"
      Når studenten fjerner "FIL1000" fra studieplanen
      Så skal studieplanen kun inneholde "INF2200"
      Og antall planlagte studiepoeng skal oppdateres til 10

    @must @planned
    Scenario: Kan ikke endre godkjent studieplan etter frist
      Gitt studieplanen har status "godkjent"
      Og endringsfristen "15. august 2024" har passert
      Og dagens dato er "20. august 2024"
      Når studenten forsøker å endre studieplanen
      Så skal studenten se feilmeldingen "Endringsfristen har passert"
      Og studenten skal se en lenke til "Søk om endring av studieplan"

  @e2e @should @planned
  Scenario: Komplett studieplanleggingsflyt fra start til godkjenning
    Gitt studenten starter med en tom studieplan for "Høst 2024"
    Når studenten gjennomfører følgende steg:
      | steg | handling                                    | forventet resultat              |
      | 1    | Søker etter emner i informatikk             | Viser 15 tilgjengelige emner    |
      | 2    | Filtrerer på "obligatoriske emner"          | Viser 3 obligatoriske emner     |
      | 3    | Legger til INF2200 i planen                 | Emnet legges til                |
      | 4    | Legger til FIL1000 i planen                 | Emnet legges til                |
      | 5    | Sjekker studiepoeng                         | Viser 20 av 30 mulige           |
      | 6    | Legger til INF2300 i planen                 | Emnet legges til                |
      | 7    | Validerer studieplanen                      | Ingen feil funnet               |
      | 8    | Sender til godkjenning                      | Status endres til "venter"      |
    Så skal studieplanen være komplett
    Og studieveileder skal ha mottatt varsel
    Og studenten skal kunne se status i studentportalen

  @should @planned
  Scenario: Håndtering av venteliste ved avmelding
    Gitt studenten er på venteliste for emnet "INF2100"
    Og studenten er nummer 3 på ventelisten
    Når en annen student melder seg av emnet
    Så skal studenten rykke opp til plass 2 på ventelisten
    Og studenten skal motta varsel om oppdatert ventelistestatus
