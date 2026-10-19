# language: no
@OPT-OVO-GRU-001 @must @implemented @scope-opprette-opptak-2027
Egenskap: Opprette et opptak
  Som opptaksforvalter
  ønsker jeg å opprette et opptak for organisasjonen jeg er opptaksforvalter ved
  slik at utdanningstilbud kan knyttes til det og søkere kan søke.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget

  Regel: Opptaksforvalter kan opprette et opptak

    Scenario: Opprette et samordna opptak
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter velger at opptaket skal være samordnet
      Og opptaksforvalter gir opptaket navnet "Samordna opptak 2027"
      Og opptaksforvalter knytter til regelverkssamlingen "UHG 2027"
      Og opptaksforvalter setter opptakstype
      Og opptaksforvalter legger til minst en organisasjon til samordningen
      Og opptaksforvalter lagrer opptaket
      Så er opptaket opprettet
      Og organisasjonen forvalter opptaket

    Scenario: Opprette et lokalt opptak
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter velger at opptaket skal være lokalt
      Og opptaksforvalter gir opptaket navnet "Lokalt opptak høst 2027"
      Og opptaksforvalter knytter til regelverkssamlingen "Lokalt regelverk"
      Og opptaksforvalter setter opptakstype
      Og opptaksforvalter lagrer opptaket
      Så er opptaket opprettet
      Og organisasjonen forvalter opptaket

  Regel: Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak

    Scenario: Lagre opptak uten navn
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter knytter til regelverkssamlingen "UHG 2027"
      Og opptaksforvalter setter opptakstype
      Men opptaksforvalter gir ikke opptaket et navn
      Så kan opptaket ikke lagres

    Scenario: Lagre opptak uten regelverkssamling
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter gir opptaket navnet "Samordna opptak 2027"
      Og opptaksforvalter setter opptakstype
      Men opptaksforvalter knytter ikke til en regelverkssamling
      Så kan opptaket ikke lagres

    Scenario: Lagre opptak uten opptakstype
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter gir opptaket navnet "Samordna opptak 2027"
      Og opptaksforvalter knytter til regelverkssamlingen "UHG 2027"
      Men opptaksforvalter setter ikke opptakstype
      Så kan opptaket ikke lagres

  # AVKLART 2026-10-19: Utdanningsbakgrunner, poenglikhetsregel, antall søknadsalternativer og tak for antall tilbud
  # per tildelingsrunde må være satt for å opprette et opptak. Startnummer for søknader er ikke obligatorisk,
  # se 03 Innstillinger/innstillinger.feature.
  @in-progress
  Regel: Utdanningsbakgrunner, poenglikhetsregel, maks antall søknadsalternativer og tak for tilbud per tildelingsrunde må være satt for å lagre et opptak

    Scenariomal: Lagre opptak uten <innstilling>
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter gir opptaket navnet "Samordna opptak 2027"
      Og opptaksforvalter knytter til regelverkssamlingen "UHG 2027"
      Og opptaksforvalter setter opptakstype
      Men opptaket mangler <innstilling>
      Så kan opptaket ikke lagres

      Eksempler:
        | innstilling                               |
        | utdanningsbakgrunner                      |
        | standard poenglikhetsregel                |
        | maks antall søknadsalternativer           |
        | tak for antall tilbud per tildelingsrunde |

  # Endret 2026-10-19 etter akseptansetesten: de to reglene om navn er slått sammen, fordi de testet det samme.
  # Atferden er den samme. Samisk er valgfritt.
  Regel: Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne

    Scenario: Angi opptaksnavn på flere språk
      Gitt at opptaksforvalter har opprettet opptaket "Samordna opptak 2027"
      Når opptaksforvalter angir navn på bokmål, nynorsk, engelsk og samisk
      Så er navnene lagret på alle fire språk

    Scenario: Lagre opptak med navn på alle obligatoriske språk
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter gir opptaket disse navnene
        | språk   | navn                       |
        | bokmål  | Samordna opptak 2027       |
        | nynorsk | Samordna opptak 2027       |
        | engelsk | Coordinated admission 2027 |
      Og opptaksforvalter lagrer opptaket
      Så er opptaket lagret med navn på bokmål, nynorsk og engelsk

    Scenariomal: Navn mangler på et obligatorisk språk
      Når opptaksforvalter oppretter et nytt opptak
      Og opptaksforvalter gir opptaket navn på alle obligatoriske språk unntatt <språk>
      Så kan opptaket ikke lagres

      Eksempler:
        | språk   |
        | bokmål  |
        | nynorsk |
        | engelsk |

  @draft @openquestion
  # ÅPNE SPØRSMÅL:
  # - Hva kopieres og hva kopieres ikke?
  # - Forslag: innstillinger, eventuelle inviterte læresteder, opptakstype og fellestekster kopieres.
  #   Frister kopieres ikke, Utdanningstilbud og regelverkssamling kopieres ikke, men legges til eksplisitt
  Regel: Det skal være mulig å gjenbruke innstillinger fra et tidligere opptak

    Scenario: Opprette opptak basert på tidligere opptak
      Gitt at opptaket "Samordna opptak 2026" finnes med innstillinger, frister og fellestekster
      Når opptaksforvalter oppretter et nytt opptak basert på "Samordna opptak 2026"
      Så kopieres innstillinger fra det tidligere opptaket som utgangspunkt

  @draft @openquestion
  # ÅPNE SPØRSMÅL:
  # - Hva skjer med søknader og vedtak i opptaket når det deaktiveres?
  # - Skal deaktivering kunne reverseres?
  Regel: Opptaksforvalter kan deaktivere et opptak

    Scenario: Deaktivere opptak
      Gitt at opptaket "Samordna opptak 2027" finnes
      Når opptaksforvalter deaktiverer opptaket
      Så settes opptaket til utløpt
      Og det er ikke lenger mulig å gjøre endringer på opptaket
      Og det er ikke lenger mulig å utføre søknadsbehandling eller plasstildeling i opptaket
      Men opptaket kan brukes som grunnlag for å opprette et nytt opptak

  # Hendelseslogg er flyttet til 06 Hendelseslogg/hendelseslogg.feature fordi den venter på generell løsning. Må gjennomgås mht hva som logges.
