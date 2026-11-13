# language: no
@OPT-REG-SAM-001 @must @implemented @scope-regelverk-2027
Egenskap: Regelverkssamling
  Som opptaksforvalter
  ønsker jeg å opprette og forvalte regelverkssamlinger
  slik at kompetansekrav, rangeringsregler, kvotetyper og grunnlag kan samles og kobles til opptak.

  Rollen i Som-linja gjelder alle scenarioene, med mindre regelen sier noe annet.

  # Avklart 2026-11-09 og 2026-11-10 (svar 14 og 17 i avklaringsmøtet om tilgangsregler i opptak): alle som jobber
  # med opptak, ser alt regelverk. Det finnes ingen egen regelverksforvalter.
  @planned
  Regel: Opptaksforvaltere, saksbehandlere og opptaksinformatører ser regelverkssamlingene ved alle organisasjoner

    Scenariomal: Se en regelverkssamling som en annen organisasjon eier
      Gitt jeg er <rolle> ved en organisasjon
      Og det finnes en regelverkssamling som en annen organisasjon eier
      Når jeg åpner regelverksoversikten
      Så ser jeg regelverkssamlingen

      Eksempler:
        | rolle             |
        | opptaksforvalter  |
        | saksbehandler     |
        | opptaksinformatør |

  # Avklart 2026-11-10 (svar 17): saksbehandleren endrer ikke regelverket, heller ikke ved organisasjonen sin.
  @planned
  Regel: Bare opptaksforvalter oppretter, endrer, kopierer og sletter regelverkssamlinger

    Scenariomal: Saksbehandler og opptaksinformatør ser regelverkssamlingen, men endrer den ikke
      Gitt jeg er <rolle> ved organisasjonen som eier regelverkssamlingen
      Når jeg åpner regelverkssamlingen
      Så <utfall>

      Eksempler:
        | rolle             | utfall                                                                        |
        | opptaksforvalter  | kan jeg endre, kopiere og slette den                                          |
        | saksbehandler     | ser jeg ikke muligheten til å endre, kopiere eller slette den                 |
        | opptaksinformatør | ser jeg ikke muligheten til å endre, kopiere eller slette den                 |

    Scenariomal: Bare opptaksforvalter kan opprette en regelverkssamling
      Gitt jeg er <rolle> ved en organisasjon
      Når jeg åpner regelverksoversikten
      Så <utfall>

      Eksempler:
        | rolle             | utfall                                                         |
        | opptaksforvalter  | kan jeg opprette en regelverkssamling                          |
        | saksbehandler     | ser jeg ikke muligheten til å opprette en regelverkssamling    |
        | opptaksinformatør | ser jeg ikke muligheten til å opprette en regelverkssamling    |

  # Avklart 2026-11-10 (svar 16): brukerne skal ikke drukne i andres regelverkssamlinger.
  # Avklart 2026-11-13 (produkteier): det løses med et filter på organisasjon, ikke med at regelverkssamlingene ved
  # organisasjonen brukeren er ansatt ved, står først. Lista er sortert etter kode. Erstatter regelen
  # «Regelverkssamlingene ved organisasjonen brukeren er ansatt ved, vises først», som ikke var levert.
  @planned
  Regel: Regelverkssamlingene kan filtreres på organisasjonen som eier dem

    Scenario: Filtrere på organisasjon
      Gitt at det finnes regelverkssamlinger ved flere organisasjoner
      Når jeg velger én eller flere organisasjoner som filter
      Så vises kun regelverkssamlingene som eies av de valgte organisasjonene

    Scenario: Regelverkssamlingene er sortert etter kode
      Når jeg åpner regelverksoversikten
      Så er regelverkssamlingene sortert etter kode

  # Justert etter koden 2026-10-14 (retrofitting): fs-admin har navn bare på bokmål, og ved sletting av en
  # samling som er i bruk vises en generell feilmelding.
  Regel: Opptaksforvalter kan opprette en regelverkssamling

    Scenario: Opprette regelverkssamling
      Når jeg oppretter en ny regelverkssamling med kode "UHG2027"
      Og jeg angir navnet på bokmål
      Så er regelverkssamlingen opprettet
      Og den eies av organisasjonen jeg er opptaksforvalter ved

    # Avklart av produkteier 2026-11-09.
    @planned
    Scenario: Kan ikke opprette regelverkssamling for en annen organisasjon
      Når jeg oppretter en ny regelverkssamling
      Så ser jeg ikke muligheten til å velge en annen organisasjon som eier enn organisasjonen jeg er opptaksforvalter ved

  Regel: En regelverkssamling er bundet til én organisasjon

    Scenario: Regelverkssamling eies av organisasjonen som opprettet den
      Gitt at regelverkssamlingen "UHG2027" er opprettet av HK-dir
      Så eier HK-dir regelverkssamlingen
      Og andre organisasjoner kan ikke redigere den uten å kopiere den først

  Regel: En regelverkssamling kan kopieres til en annen organisasjon

    Scenario: Kopiere regelverkssamling
      Gitt at regelverkssamlingen "UHG2027" eies av HK-dir
      Når jeg kopierer regelverkssamlingen til organisasjonen jeg er opptaksforvalter ved
      Så får organisasjonen jeg er opptaksforvalter ved en egen kopi av regelverkssamlingen med alt innhold
      Og endringer i originalen påvirker ikke kopien

    # Avklart av produkteier 2026-11-09.
    @planned
    Scenario: Kan ikke kopiere regelverkssamling til en annen organisasjon
      Gitt at regelverkssamlingen "UHG2027" eies av HK-dir
      Når jeg kopierer regelverkssamlingen
      Så ser jeg ikke muligheten til å kopiere den til en annen organisasjon enn organisasjonen jeg er opptaksforvalter ved

  @draft @openquestion
  Regel: En regelverkssamling kan deaktiveres
    # ÅPNE SPØRSMÅL:
    # - I dag har deaktivering ingen virkning: inaktive samlinger kan fortsatt velges for nye opptak
    #   (verifisert 2026-10-14). Skal de skjules når samling velges for et nytt opptak?

    Scenario: Deaktivere regelverkssamling
      Gitt at regelverkssamlingen "UHG2027" er aktiv
      Når jeg deaktiverer regelverkssamlingen
      Så er regelverkssamlingen ikke lenger tilgjengelig for nye opptak
      Men eksisterende opptak som bruker den påvirkes ikke

  Regel: En regelverkssamling kan slettes når den ikke er knyttet til et opptak

    Scenario: Slette regelverkssamling som ikke er i bruk
      Gitt at regelverkssamlingen "TestSamling" ikke er knyttet til noe opptak
      Når jeg sletter regelverkssamlingen
      Så er regelverkssamlingen slettet

    Scenario: Kan ikke slette regelverkssamling som er i bruk
      Gitt at regelverkssamlingen "UHG2027" er knyttet til opptaket "Samordna opptak 2027"
      Når jeg forsøker å slette regelverkssamlingen
      Så blir regelverkssamlingen ikke slettet
      Og jeg får beskjed om at regelverkssamlingen ikke kunne slettes

  Regel: Regelverkssamlingen inneholder kompetanseregelverk, rangeringsregelverk, kvotetyper, grunnlag og mangelkoder

    Scenario: Se innholdet i en regelverkssamling
      Gitt at regelverkssamlingen "UHG2027" er opprettet
      Når jeg åpner regelverkssamlingen
      Så ser jeg oversikt over kompetanseregelverk
      Og jeg ser oversikt over rangeringsregelverk
      Og jeg ser oversikt over kvotetyper
      Og jeg ser oversikt over grunnlag
      Og jeg ser oversikt over mangelkoder