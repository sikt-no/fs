# language: no
@OPT-BEH-BEH-016 @should @draft @ref-OPT-BEH-BEH-012
Egenskap: Hendelseslogg for saksbehandling
  Som saksbehandler
  ønsker jeg en logg over hvem som har gjort hvilke endringer på søkeren og søknaden, og når
  slik at jeg kan følge opp og etterprøve saksbehandlingen.

  # Kilde: bør-behov fra Politihøgskolen (sporbarhet), se
  # 15 Lærestedsspesifikke behov/01 Politihøgskolen/opptak_ved_politihøgskolen.feature. Antatt et generelt
  # behov i saksbehandlingen, ikke bare for Politihøgskolen.
  # Tilsvarer 11 Opprette og vedlikeholde opptak/06 Hendelseslogg/hendelseslogg.feature, som gjelder
  # endringer på opptaket. Begge bygger på en generell revisjonsmekanisme som gjelder på tvers av FS.
  # Beslektede krav som allerede logger i endringsloggen for saken:
  # - søknadsmangler.feature (saksloggen viser mangler som er registrert og endret)
  # - OPT-BEH-BEH-012 (endringsloggen viser at maskinbrukeren har plassert søkeren i kvoten)
  #
  # ÅPNE SPØRSMÅL:
  # - Hvilke endringer skal logges: status, kvalifisering, poeng, dokumentasjon, tildeling til saksbehandler?
  # - Er dette den samme endringsloggen for saken som finnes i dag, utvidet, eller en egen logg?
  # - Vises hvem som gjorde endringen som rolle og organisasjon, som i hendelsesloggen for opptak?

  Regel: Saksbehandler kan se hvilke endringer som er gjort på en søker

    Scenario: Saksbehandler ser endringene på søkeren
      Gitt at en annen saksbehandler har endret statusen på søkeren
      Når saksbehandleren åpner søkeren
      Så ser saksbehandleren hvem som endret statusen, og når

  # Avklart 2026-11-10 (R13 i spec-en «Krav til RLS» og spørsmål 34): loggen har samme grense som det den logger.
  # I dag har loggtabellene ingen RLS, og API-rollen kan endre og tømme dem.
  Regel: Loggen for saken ses bare av dem som ser saken

    Scenariomal: Se loggen for saken ut fra organisasjonens rolle
      Gitt søknaden er i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og behandleren har endret statusen i saken
      Og jeg er <rolle> ved <organisasjon>
      Når jeg åpner loggen for saken
      Så <ser> jeg endringen

      Eksempler:
        | rolle             | organisasjon                          | ser      |
        | saksbehandler     | behandleren av søknadsalternativet    | ser      |
        | saksbehandler     | tilbyderen av søknadsalternativet     | ser      |
        | opptaksforvalter  | forvalteren av opptaket               | ser      |
        | opptaksinformatør | behandleren av søknadsalternativet    | ser      |
        | saksbehandler     | en organisasjon uten rolle i opptaket | ser ikke |

    Scenario: En intern merknad vises ikke i loggen for andre organisasjoner
      Gitt behandleren har skrevet en intern merknad i saken
      Og jeg er saksbehandler ved tilbyderen av søknadsalternativet
      Når jeg åpner loggen for saken
      Så ser jeg ikke den interne merknaden

  Regel: Søkeren ser hvilken organisasjon som gjorde endringen, men ikke saksbehandleren

    Scenario: Søkeren ser organisasjonen i endringene i saken sin
      Gitt saksbehandleren ved behandleren har endret statusen i saken
      Når søkeren ser endringene i søknaden sin i Min kompetanse
      Så ser søkeren at endringen ble gjort av behandleren
      Men søkeren ser ikke navnet på saksbehandleren

  Regel: Ingen kan endre eller slette loggen

    Scenario: Endring av loggen avvises i API-et
      Gitt en integrasjon har rollen saksbehandler ved behandleren av søknadsalternativet
      Når integrasjonen forsøker å endre eller slette en hendelse i loggen gjennom API-et
      Så avvises det
