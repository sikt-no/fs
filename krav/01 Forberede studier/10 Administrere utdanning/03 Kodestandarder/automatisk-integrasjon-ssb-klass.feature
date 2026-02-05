# language: no

@KOD-NUS-INT-001 @must
Egenskap: Automatisk integrasjon med SSBs KLASS API for NUS-koder
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
      | klassifikasjon_id | navn                               | versjon |
      | 36              | Norsk standard for utdanningsgruppering | 6      |
    Og systemet har følgende varslingsmottakere konfigurert:
      | rolle                | epost_liste                     | varsel_type    |
      | systemadministrator  | sysadmin@institusjon.no        | ISCED_mapping  |
      | studieplanlegger     | planlegging@institusjon.no     | NUS_endring    |

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
      Så skal systemet:
        | handling                          | resultat                        |
        | Koble til SSB KLASS API          | HTTP 200 OK                     |
        | Sjekke gjeldende versjon          | Versjon 6                       |
        | Sammenligne med lokal versjon     | Ingen endring                   |
        | Logge polling-resultat            | "Ingen endringer funnet"        |
      Og ingen oppdateringer skal gjøres
      Og neste polling skal planlegges kl "03:00" neste dag

    @must @planned
    Scenario: Oppdage og hente nye NUS-koder
      Gitt SSB har publisert versjon "7" av NUS-klassifikasjonen
      Og versjon 7 inneholder:
        | endring_type | nuskode | navn                            |
        | NY          | 621105  | Barnehagelærerutdanning, 4-årig |
        | NY          | 741203  | Master i kunstig intelligens     |
        | ENDRET      | 621101  | Barnehagelærerutdanning, 2-årig |
        | UTGÅTT      | 621102  | Førskolelærerutdanning, 3-årig  |
      Når scheduled job kjører kl "03:00"
      Så skal systemet hente alle endringer fra SSB
      Og prosessere endringene i følgende rekkefølge:
        | steg | handling                    | antall |
        | 1    | Legg til nye koder         | 2      |
        | 2    | Oppdater eksisterende      | 1      |
        | 3    | Marker utgåtte som inaktive | 1      |
      Og lokal versjon skal oppdateres til "7"

  @must @planned
  Regel: Endringer skal kun gjelde aktive utdanninger

    NUS-endringer må aldri anvendes retrospektivt. Historiske data
    beholder sin opprinnelige klassifisering.

    @must @planned
    Scenario: Oppdatering av NUS-kode for aktive emner
      Gitt NUS-kode "621101" endres fra "Førskolelærer" til "Barnehagelærer"
      Og følgende emner bruker denne koden:
        | emnekode | navn                  | status    | siste_versjon |
        | PED1000  | Pedagogikk grunnkurs  | AKTIV     | 2024-HØST    |
        | PED2000  | Pedagogikk fordypning | AKTIV     | 2024-HØST    |
        | PED3000  | Pedagogikk master     | NEDLAGT   | 2020-VÅR     |
      Når endringen prosesseres
      Så skal NUS_ENKELTUTDANNING.NUSENKELTUTDNAVN oppdateres
      Og endringen skal gjelde for:
        | emnekode | anvendes | årsak                          |
        | PED1000  | JA      | Aktiv - bruker gjeldende kode  |
        | PED2000  | JA      | Aktiv - bruker gjeldende kode  |
        | PED3000  | NEI     | Nedlagt - beholder historisk   |
      Og KODETABELL_ENDRINGER skal logge:
        """
        {
          "tidspunkt": "2024-11-20T03:15:00",
          "nuskode": "621101",
          "gammel_verdi": "Førskolelærer",
          "ny_verdi": "Barnehagelærer",
          "påvirkede_aktive_emner": 2,
          "upåvirkede_historiske": 1
        }
        """

    @must @planned
    Scenario: Håndtering av utgått NUS-kode i bruk
      Gitt NUS-kode "621102" markeres som utgått av SSB
      Og koden brukes av aktive studieprogrammer:
        | programkode | navn                      | status | studenter |
        | BARN-BA    | Bachelor i barnehagepedagogikk | AKTIV  | 245       |
      Når endringen prosesseres
      Så skal NUS_ENKELTUTDANNING.STATUS_AKTIV settes til "N"
      Men koden skal IKKE slettes fra databasen
      Og studieprogrammet skal fortsatt referere til koden
      Og studieplanleggere skal varsles om utgått kode

  @must @planned
  Regel: Batch-prosessering med fornuftige grenser

    For å unngå ytelsesproblemer og sikre sporbarhet, skal større
    oppdateringer deles opp i håndterbare batches.

    @must @planned
    Scenariomal: Prosessere endringer i batches
      Gitt SSB har <totalt_antall> endringer
      Når systemet prosesserer endringene
      Så skal de deles i batches på <batch_størrelse>
      Og hver batch skal committes separat
      Og ved feil skal kun gjeldende batch rulles tilbake

      Eksempler:
        | totalt_antall | batch_størrelse | forventet_tid | kommentar                    |
        | 10           | 10              | < 1 sekund    | Små endringer i én batch     |
        | 100          | 50              | < 10 sekunder | Typisk månedlig oppdatering  |
        | 500          | 100             | < 1 minutt    | Større revisjoner            |
        | 5000         | 500             | < 10 minutter | Full re-klassifisering       |

    @should @planned
    Scenario: Gjenoppta avbrutt batch-prosessering
      Gitt systemet prosesserte 3 av 10 batches
      Og prosessen ble avbrutt pga nettverksfeil
      Når scheduled job kjører på nytt
      Så skal systemet:
        | sjekk                          | handling                       |
        | Identifisere siste batch       | Batch 3 fullført              |
        | Validere konsistens            | Batches 1-3 korrekt anvendt   |
        | Gjenoppta fra batch 4          | Fortsette prosessering         |
      Og ikke re-prosessere allerede fullførte batches

  @must @planned
  Regel: Varsling skal være målrettet basert på type endring

    Ulike interessenter trenger ulik informasjon om endringer
    i kodetabellene.

    @must @planned
    Scenario: Varsle studieplanleggere om NUS-endringer
      Gitt NUS-kode "621101" brukes av studieprogrammer:
        | programkode | fakultet    | studieplanlegger           |
        | BARN-BA    | Pedagogikk  | ped-plan@institusjon.no   |
        | LÆRER-MA   | Pedagogikk  | ped-plan@institusjon.no   |
        | SPES-PED   | Spesialped  | spes-plan@institusjon.no  |
      Når koden endrer navn eller status
      Så skal følgende varsler sendes:
        | mottaker                  | emne                           | innhold_inkluderer           |
        | ped-plan@institusjon.no  | NUS-endring påvirker 2 program | BARN-BA, LÆRER-MA           |
        | spes-plan@institusjon.no | NUS-endring påvirker 1 program | SPES-PED                     |
      Og varselet skal inneholde:
        - Gammel og ny verdi
        - Antall berørte studenter
        - Lenke til detaljert rapport

    @must @planned
    Scenario: Varsle systemadministratorer om ISCED-mapping endringer
      Gitt NUS-kode "621101" har ISCED-mapping:
        | felt           | gammel_verdi | ny_verdi |
        | ISCED2011_P    | 645         | 655      |
        | ISCEDKODE      | 0112        | 0111     |
      Når mapping-endringen oppdages
      Så skal systemadministratorer få varsel med:
        """
        ISCED-mapping endret for NUS 621101:
        - ISCED2011_P: 645 → 655 (Bachelor → Master nivå)
        - ISCEDKODE: 0112 → 0111 (Forskjellig detaljklassifisering)
        
        Påvirker internasjonal rapportering for:
        - 3 studieprogrammer
        - 15 emner
        - DBH-rapport for neste kvartal
        """
      Men studieplanleggere skal IKKE varsles om denne endringen

  @must @planned
  Regel: All synkronisering skal være fullt sporbar

    @must @planned
    Scenario: Komplett logging av synkroniseringshendelse
      Når daglig synkronisering gjennomføres
      Så skal følgende logges i INTEGRASJONS_LOGG:
        | felt                  | eksempel_verdi                          |
        | integrasjon_id        | NUS-SYNC-2024-11-20-030000            |
        | kilde_api             | https://data.ssb.no/api/klass/v1      |
        | start_tidspunkt       | 2024-11-20 03:00:00                   |
        | slutt_tidspunkt       | 2024-11-20 03:02:35                   |
        | kilde_versjon         | 7                                      |
        | lokal_versjon_før     | 6                                      |
        | lokal_versjon_etter   | 7                                      |
        | antall_nye            | 2                                      |
        | antall_oppdaterte     | 15                                     |
        | antall_deaktiverte    | 3                                      |
        | batch_info            | {"totalt": 5, "fullført": 5}          |
        | feil                  | null                                   |
        | varsler_sendt         | 8                                      |
      Og detaljert endringslogg skal lagres i KODETABELL_ENDRINGER
      Og loggene skal være tilgjengelige i minimum 7 år

  @should @planned
  Regel: Systemet skal håndtere feil resilient

    @should @planned
    Scenario: Håndtere utilgjengelig SSB API
      Gitt SSB API har vært nede i 2 dager
      Og forrige vellykkede synk var "2024-11-18"
      Når scheduled job kjører
      Så skal systemet:
        | forsøk | handling                    | resultat              |
        | 1      | Koble til SSB API          | Connection timeout    |
        | 2      | Vente 30 sekunder          | -                     |
        | 3      | Prøve backup-endpoint      | Connection timeout    |
      Og logge feilen med detaljer
      Og sende varsel til systemadministrator hvis:
        - API har vært nede > 48 timer
        - Siste synk er > 7 dager gammel
      Og fortsette med eksisterende kodetabeller

  @e2e @should @planned
  Scenario: Komplett integrasjonsflyt med alle komponenter
    Gitt det er "2024-11-20 03:00"
    Og SSB har publisert nye NUS-endringer kl "2024-11-19 14:00"
    Når FS-integrasjonstjenesten starter
    Så skal følgende skje i rekkefølge:
      | tid    | komponent              | handling                                      | status   |
      | 03:00  | Scheduler              | Trigger daglig integrasjonsjobb              | OK       |
      | 03:00  | Integrasjonstjeneste   | Koble til SSB KLASS API                     | OK       |
      | 03:01  | API-klient             | GET /classifications/36/codesAt?date=2024-11-20 | 200 OK   |
      | 03:01  | Parser                 | Parse 5887 NUS-koder (3 nye, 10 endrede)    | OK       |
      | 03:01  | Validator              | Validere dataformat og konsistens            | OK       |
      | 03:02  | Database               | START TRANSACTION                            | OK       |
      | 03:02  | Batch-prosessor        | Prosesser batch 1/2 (250 koder)             | OK       |
      | 03:02  | Batch-prosessor        | Prosesser batch 2/2 (13 koder)              | OK       |
      | 03:02  | Logger                 | Logg alle endringer til audit-tabell        | OK       |
      | 03:02  | Database               | COMMIT TRANSACTION                           | OK       |
      | 03:03  | Varslingstjeneste      | Send 5 varsler til studieplanleggere        | OK       |
      | 03:03  | Varslingstjeneste      | Send 1 varsel til systemadministrator       | OK       |
      | 03:03  | GraphQL-cache          | Invalider berørte cache-entries             | OK       |
      | 03:03  | Rapportgenerator       | Generer synkroniseringsrapport             | OK       |
      | 03:04  | Scheduler              | Planlegg neste kjøring 2024-11-21 03:00    | OK       |
    Og integrasjonsrapporten skal være tilgjengelig i systemadministrator-dashboardet