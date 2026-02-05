# language: no

@KOD-NUS-INT-001 @must
Egenskap: Automatisk oppdatering av nus- og isced-koder
  Som FS-systemet
  Ønsker jeg å automatisk synkronisere NUS- og ISCED-kodetabeller fra SSBs KLASS API
  Slik at utdanningsklassifiseringen alltid er oppdatert med offisielle standarder

  # ÅPNE SPØRSMÅL:
  # - SSB API versjonshåndtering: Hvordan identifisere at nye versjoner er tilgjengelige?
  # - Feilhåndtering: Hva gjør vi hvis SSB API er nede flere dager?
  # - ISCED-kilde: Hentes ISCED-koder også fra SSB eller fra UNESCO direkte?

  FS-systemet poller SSBs KLASS API daglig for å oppdage endringer i
  NUS-klassifikasjonen. Med 5884 aktive NUS-koder som brukes av emner,
  studieprogrammer og kvalifikasjoner, er det kritisk at endringer
  anvendes korrekt: kun på aktive utdanninger, aldri retrospektivt.

  Bakgrunn:
    Gitt FS-integrasjonstjenesten kjører som scheduled job
    Og SSBs KLASS API er tilgjengelig på "https://data.ssb.no/api/klass/v1"
    Og følgende NUS-klassifikasjon er konfigurert:
      | klassifikasjon_id | navn                                | versjon |
      | 36                | Norsk standard for utdanningsgruppering | 6       |
    Og systemet har følgende varslingsinnstillinger:
      | rolle               | varsling_kanal | varsel_type   |
      | systemadministrator | FS Admin       | ISCED_mapping |
      | studieplanlegger    | epost          | NUS_endring   |

  @must @planned
  Regel: Systemet skal polle SSB KLASS API daglig for endringer

    Integrasjonen kjører automatisk hver natt og sjekker om det
    finnes nye versjoner eller endringer i NUS-klassifikasjonen.

    @must @planned
    Scenario: Daglig polling uten endringer
      Gitt forrige synkronisering var "2024-11-19 03:00"
      Og SSB API har versjon "6" av NUS-klassifikasjonen
      Og lokal database har versjon "6"
      Når scheduled job kjører kl "03:00"
      Så skal lokal versjon fortsatt være "6"
      Og synkroniseringsloggen skal inneholde "Ingen endringer funnet"
      Og neste polling skal være planlagt til "03:00" neste dag

    @must @planned
    Scenario: Oppdage og importere nye NUS-koder
      Gitt SSB har publisert versjon "7" av NUS-klassifikasjonen
      Og versjon 7 inneholder følgende endringer:
        | endring_type | nuskode | navn                             |
        | NY           | 621105  | Barnehagelærerutdanning, 4-årig  |
        | NY           | 741203  | Master i kunstig intelligens     |
        | ENDRET       | 621101  | Barnehagelærerutdanning, 2-årig  |
        | UTGÅTT       | 621102  | Førskolelærerutdanning, 3-årig   |
      Når scheduled job kjører kl "03:00"
      Så skal lokal database inneholde NUS-kode "621105" med navn "Barnehagelærerutdanning, 4-årig"
      Og lokal database skal inneholde NUS-kode "741203" med navn "Master i kunstig intelligens"
      Og NUS-kode "621101" skal ha oppdatert navn "Barnehagelærerutdanning, 2-årig"
      Og NUS-kode "621102" skal ha status "UTGÅTT"
      Og lokal versjon skal være "7"

  @must @planned
  Regel: Endringer skal kun gjelde aktive utdanninger

    NUS-endringer må aldri anvendes retrospektivt. Historiske data
    beholder sin opprinnelige klassifisering.

    @must @planned
    Scenario: NUS-navneendring påvirker kun aktive emner
      Gitt NUS-kode "621101" har navn "Førskolelærer"
      Og følgende emner bruker denne koden:
        | emnekode | navn                  | status  | siste_versjon |
        | PED1000  | Pedagogikk grunnkurs  | AKTIV   | 2024-HØST     |
        | PED2000  | Pedagogikk fordypning | AKTIV   | 2024-HØST     |
        | PED3000  | Pedagogikk master     | NEDLAGT | 2020-VÅR      |
      Når SSB endrer NUS-kode "621101" til navn "Barnehagelærer"
      Og endringen prosesseres
      Så skal NUS_ENKELTUTDANNING.NUSENKELTUTDNAVN være "Barnehagelærer"
      Og emne "PED1000" skal vise NUS-navn "Barnehagelærer"
      Og emne "PED2000" skal vise NUS-navn "Barnehagelærer"
      Men emne "PED3000" skal beholde historisk NUS-navn "Førskolelærer"
      Og KODETABELL_ENDRINGER skal inneholde:
        | felt                    | verdi          |
        | nuskode                 | 621101         |
        | gammel_verdi            | Førskolelærer  |
        | ny_verdi                | Barnehagelærer |
        | påvirkede_aktive_emner  | 2              |
        | upåvirkede_historiske   | 1              |

    @must @planned
    Scenario: Utgått NUS-kode beholdes for aktive studieprogrammer
      Gitt NUS-kode "621102" har status "AKTIV"
      Og koden brukes av følgende studieprogram:
        | programkode | navn                           | status | studenter |
        | BARN-BA     | Bachelor i barnehagepedagogikk | AKTIV  | 245       |
      Når SSB markerer NUS-kode "621102" som utgått
      Og endringen prosesseres
      Så skal NUS_ENKELTUTDANNING.STATUS_AKTIV være "N" for kode "621102"
      Men NUS-kode "621102" skal fortsatt eksistere i databasen
      Og studieprogram "BARN-BA" skal fortsatt referere til NUS-kode "621102"
      Og studieplanleggere skal ha mottatt varsel om utgått kode

  @must @planned
  Regel: Batch-prosessering med fornuftige grenser

    For å unngå ytelsesproblemer og sikre sporbarhet, skal større
    oppdateringer deles opp i håndterbare batches.

    @must @planned
    Scenariomal: Store oppdateringer deles i batches
      Gitt SSB har <totalt_antall> endringer å prosessere
      Når systemet importerer endringene
      Så skal endringene være fordelt på batches med maks <batch_størrelse> per batch
      Og hver batch skal ha egen commit i databasen
      Og alle <totalt_antall> endringer skal være importert

      Eksempler:
        | totalt_antall | batch_størrelse | kommentar                   |
        | 10            | 10              | Små endringer i én batch    |
        | 100           | 50              | Typisk månedlig oppdatering |
        | 500           | 100             | Større revisjoner           |
        | 5000          | 500             | Full re-klassifisering      |

    @must @planned
    Scenario: Feil i én batch påvirker ikke tidligere batches
      Gitt systemet prosesserer 10 batches med NUS-endringer
      Og batch 1-5 er fullført
      Når batch 6 feiler pga databasefeil
      Så skal batch 1-5 fortsatt være committet
      Og batch 6-10 skal være rullet tilbake
      Og synkroniseringsloggen skal vise hvilke batches som feilet

    @should @planned
    Scenario: Gjenoppta avbrutt batch-prosessering
      Gitt en tidligere synkronisering fullførte batch 1-3 av 10
      Og prosessen ble avbrutt pga nettverksfeil
      Når scheduled job kjører på nytt
      Så skal prosesseringen fortsette fra batch 4
      Og batch 1-3 skal ikke prosesseres på nytt
      Og synkroniseringsloggen skal vise "Gjenopptatt fra batch 4"

  @must @planned
  Regel: Varsling skal være målrettet basert på type endring

    Ulike interessenter trenger ulik informasjon om endringer
    i kodetabellene. Systemadministratorer skal se varsler direkte
    i FS Admin brukerflaten, mens studieplanleggere får e-postvarsler.

    @must @planned
    Scenario: Studieplanleggere varsles om NUS-endringer via e-post
      Gitt NUS-kode "621101" brukes av studieprogrammer:
        | programkode | fakultet   | studieplanlegger          |
        | BARN-BA     | Pedagogikk | ped-plan@institusjon.no   |
        | LÆRER-MA    | Pedagogikk | ped-plan@institusjon.no   |
        | SPES-PED    | Spesialped | spes-plan@institusjon.no  |
      Når NUS-kode "621101" endrer navn
      Og endringen prosesseres
      Så skal "ped-plan@institusjon.no" motta e-post med emne "NUS-endring påvirker 2 program"
      Og e-posten skal nevne "BARN-BA" og "LÆRER-MA"
      Og "spes-plan@institusjon.no" skal motta e-post med emne "NUS-endring påvirker 1 program"
      Og e-posten skal nevne "SPES-PED"
      Og alle varsler skal inneholde gammel og ny verdi
      Og alle varsler skal inneholde antall berørte studenter
      Og alle varsler skal inneholde lenke til detaljert rapport

    @must @planned
    Scenario: Systemadministratorer varsles om ISCED-mapping endringer i FS Admin
      Gitt NUS-kode "621101" har ISCED-mapping:
        | felt        | verdi |
        | ISCED2011_P | 645   |
        | ISCEDKODE   | 0112  |
      Når SSB endrer ISCED-mapping til:
        | felt        | verdi |
        | ISCED2011_P | 655   |
        | ISCEDKODE   | 0111  |
      Og endringen prosesseres
      Så skal det opprettes et varsel i FS Admin med:
        | felt             | verdi                             |
        | varsel_type      | ISCED_MAPPING_ENDRING             |
        | prioritet        | HØY                               |
        | synlig_for_rolle | systemadministrator               |
        | tittel           | ISCED-mapping endret for NUS 621101 |
      Og varselet skal vise endring fra "645" til "655" for ISCED2011_P
      Og varselet skal vise endring fra "0112" til "0111" for ISCEDKODE
      Og varselet skal vises i systemadministrator-dashboardet
      Og varselet skal kunne kvitteres ut
      Men studieplanleggere skal ikke se dette varselet

  @must @planned
  Regel: All synkronisering skal være fullt sporbar

    @must @planned
    Scenario: Synkronisering logges med alle detaljer
      Gitt lokal database har NUS-versjon "6"
      Og SSB har NUS-versjon "7" med 20 endringer
      Når scheduled job kjører kl "03:00"
      Og synkroniseringen fullføres kl "03:02:35"
      Så skal INTEGRASJONS_LOGG inneholde en rad med:
        | felt                | verdi                            |
        | kilde_api           | https://data.ssb.no/api/klass/v1 |
        | kilde_versjon       | 7                                |
        | lokal_versjon_før   | 6                                |
        | lokal_versjon_etter | 7                                |
      Og detaljert endringslogg skal finnes i KODETABELL_ENDRINGER
      Og loggene skal være tilgjengelige i minimum 7 år

  @should @planned
  Regel: Systemet skal håndtere feil resilient

    @should @planned
    Scenario: Synkronisering fortsetter med eksisterende data når SSB API er nede
      Gitt SSB API er utilgjengelig
      Og forrige vellykkede synkronisering var "2024-11-18"
      Når scheduled job kjører
      Så skal synkroniseringsloggen vise "SSB API utilgjengelig"
      Og lokale NUS-koder skal være uendret
      Og neste synkronisering skal planlegges som normalt

    @should @planned
    Scenario: Systemadministrator varsles når SSB API er nede over lengre tid
      Gitt SSB API har vært utilgjengelig i 3 dager
      Og forrige vellykkede synkronisering var "2024-11-15"
      Når scheduled job kjører
      Så skal det opprettes et varsel i FS Admin med:
        | felt        | verdi                                      |
        | varsel_type | API_UTILGJENGELIG                          |
        | prioritet   | HØY                                        |
        | tittel      | SSB KLASS API utilgjengelig i over 48 timer |
      Og varselet skal vise dato for siste vellykkede synkronisering

  @e2e @should @planned
  Scenario: Komplett synkroniseringsflyt fra SSB til FS
    Gitt det er "2024-11-20 03:00"
    Og lokal database har NUS-versjon "6"
    Og SSB har publisert NUS-versjon "7" med 13 endringer
    Når scheduled job starter synkronisering
    Og synkroniseringen fullføres
    Så skal lokal database ha NUS-versjon "7"
    Og alle 13 endringer skal være importert
    Og synkroniseringsloggen skal vise status "FULLFØRT"
    Og berørte studieplanleggere skal ha mottatt e-postvarsler
    Og systemadministrator-dashboardet skal vise synkroniseringsrapport
    Og neste synkronisering skal være planlagt til "2024-11-21 03:00"
