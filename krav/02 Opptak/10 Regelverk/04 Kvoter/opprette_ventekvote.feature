# language: no
@OPT-REG-KVO-005 @must @in-progress @scope-spesialvurdering-2027 @depends-on-OPT-REG-KVO-001 @depends-on-OPT-REG-GRU-001 @depends-on-OPT-REG-RAN-001 @depends-on-OPT-REG-RAN-002
Egenskap: Opprette ventekvote for søkere uten poeng
  Som opptaksforvalter
  ønsker jeg å sette opp en ventekvote for søkere uten poeng i regelverkssamlingen
  slik at søkere som ikke kan få vanlige rangeringspoeng, kan skjønnsvurderes og få tilbudsgaranti.

  # AVKLART 2026-11-06 (produkteier): Ventekvoten er en kvotetype uten plasser. Den er et venterom for søkere
  # som søker på grunnlag av realkompetanse, og søkere helt uten poeng. Kravet gir ikke kvotetypen eller
  # grunnlagene konkrete navn eller koder. De velges av den som oppretter regelverket. Kravet legger til rette
  # for at funksjonen SPEV-kvoten har hatt, også finnes i det nye opptaket.
  # AVKLART 2026-11-06 (produkteier): Ventekvoten har ingen egen rangeringsmetode. Poengene skjules per grunnlag,
  # og søkere på grunnlagene for realkompetanse og helt uten poeng skal ikke få vist poengene. De interne poengene
  # (intern stipulering) settes opp i rangeringsregelverket med egne poengklasser og poengtyper, og brukes bare
  # internt i saksbehandlingen, for å avgjøre om søkeren når opp i konkurransen uten vanlige konkurransepoeng.
  # AVKLART 2026-11-06 (produkteier): Opptaksforvalter setter opp ventekvoten og innstillingene på kvotetypen.

  # Navnene og kodene i scenarioene er bare eksempler.

  Bakgrunn:
    Gitt at opptaksforvalteren er innlogget
    Og at regelverkssamlingen "UHG2027" er opprettet

  @implemented
  Regel: Grunnlagene for søkere uten vanlige konkurransepoeng har skjulte poeng

    Scenariomal: Opprette grunnlag med skjulte poeng
      Når opptaksforvalteren oppretter grunnlaget "<grunnlag>"
      Og opptaksforvalteren angir at grunnlaget brukes i kvalifisering og rangering
      Og opptaksforvalteren angir at poeng skal skjules for søker
      Så er grunnlaget "<grunnlag>" opprettet med skjulte poeng

      Eksempler:
        | grunnlag              |
        | Realkompetanse (REAL) |
        | Uten poeng (HUP)      |

  @implemented
  Regel: Interne poeng settes opp i rangeringsregelverket med egne poengklasser og poengtyper

    Scenario: Opprette poengtype for interne poeng
      Gitt at poengklassen "Intern stipulering (INTSTIP)" og poengvarianten "NOM" finnes
      Når opptaksforvalteren oppretter en poengtype for "INTSTIP" + "NOM"
      Og opptaksforvalteren setter minimum til 0, maksimum til 999,99 og antall desimaler til 2
      Og opptaksforvalteren knytter ingen poengalgoritme til poengtypen
      Så er poengtypen "INTSTIP-NOM" opprettet uten automatisk beregning

    Scenario: Opprette poengformel for interne poeng
      Når opptaksforvalteren oppretter poengformelen "Interne poeng (INTERN)" med uttrykket "INTSTIP"
      Så er poengformelen "Interne poeng (INTERN)" opprettet

    Scenario: Koble grunnlagene til poengtypen for interne poeng
      Gitt at rangeringsregelverket "ORD-RANG" brukes i opptaket
      Når opptaksforvalteren kobler grunnlagene "Realkompetanse (REAL)" og "Uten poeng (HUP)" til poengtypen "INTSTIP-NOM" i rangeringsregelverket
      Så kan saksbehandler sette interne poeng på søkere med grunnlaget "Realkompetanse (REAL)" eller "Uten poeng (HUP)"

  @ref-OPT-BEH-BEH-012
  Regel: Ventekvoten er en kvotetype uten plasser og uten kvotespørsmål
    # At søkerne plasseres automatisk i ventekvoten ut fra grunnlaget, står i automatisk_kvoteplassering.feature.

    Scenario: Opprette ventekvoten
      Gitt at grunnlagene "Realkompetanse (REAL)" og "Uten poeng (HUP)" har skjulte poeng
      Og at poengformelen "Interne poeng (INTERN)" finnes
      Når opptaksforvalteren oppretter kvotetypen "Ventekvote (VENT)" med
        | innstilling         | verdi                                   |
        | Default poengformel | Interne poeng (INTERN)                  |
        | Grunnlag            | Realkompetanse (REAL), Uten poeng (HUP) |
        | Kvotespørsmål       | ingen                                   |
        | Plasser             | uten plasser                            |
      Så er kvotetypen "Ventekvote (VENT)" opprettet uten plasser
      Og søkere med grunnlaget "Realkompetanse (REAL)" eller "Uten poeng (HUP)" kan plasseres i "Ventekvote (VENT)"

  @depends-on-OPT-REG-KVO-003 @depends-on-OPT-REG-KVO-004
  Regel: Ventekvoten får kvoteprioritet og kobles til hovedkvoten i plassflyten
    # AVKLART 2026-11-06 (produkteier): Ventekvoten har ingen plasser, så kvoteprioriteten og koblingen til
    # hovedkvoten i plassflyten har ingen annen virkning enn at kvotetypen følger standardoppsettet for
    # kvotetyper. En kvotetype kan ikke legges på utdanningstilbud før den har begge.

    Scenario: Gi ventekvoten kvoteprioritet og koble den til hovedkvoten
      Gitt at "Ordinær kvote (ORD)" er hovedkvoten i standard plassflyt i regelverkssamlingen
      Og at kvotetypen "Ventekvote (VENT)" er opprettet uten plasser
      Når opptaksforvalteren gir "Ventekvote (VENT)" kvoteprioritet 4 i regelverkssamlingen
      Og opptaksforvalteren kobler "Ventekvote (VENT)" til "Ordinær kvote (ORD)" i standard plassflyt
      Så følger "Ventekvote (VENT)" standardoppsettet for kvotetyper
      Og kan "Ventekvote (VENT)" legges på utdanningstilbudene i opptaket

  Regel: Ventekvoten er standardkvote og stengt for fjerning
    # Hva innstillingene gjør hver for seg, står i kvoterregelverk.feature.
    # AVKLART 2026-11-06 (produkteier): Standardkvoten legges på utdanningstilbudet når det legges til i
    # opptaket. Ventekvoten må derfor være standardkvote før utdanningstilbudene legges til.

    Scenario: Gjøre ventekvoten til standardkvote som er stengt for fjerning
      Gitt at kvotetypen "Ventekvote (VENT)" er opprettet uten plasser
      Og at opptaket "Samordna opptak 2027" bruker regelverkssamlingen "UHG2027"
      Når opptaksforvalteren setter kvotetypen "Ventekvote (VENT)" som standardkvote
      Og opptaksforvalteren stenger kvotetypen "Ventekvote (VENT)" for fjerning fra utdanningstilbudene
      Og utdanningstilbudet "Sykepleie, høst 2027" legges til i opptaket "Samordna opptak 2027"
      Så har utdanningstilbudet "Sykepleie, høst 2027" utdanningskvoten "Ventekvote (VENT)"
      Og "Ventekvote (VENT)" kan ikke fjernes fra utdanningstilbudet "Sykepleie, høst 2027"
