# language: no
@OPT-SØK-MEL-004 @should @draft @scope-meldinger-varslinger-og-oppgaver
Egenskap: Se kommunikasjon med søker
  Som saksbehandler ved saksbehandlende organisasjon
  ønsker jeg å se all kommunikasjon med søkeren
  slik at jeg kan dokumentere hva søkeren har fått beskjed om, også i en klagesak.

  Opptaksforvalteren følger med på utsendingene: hvem som har fått dem, og hvilke som har feilet.
  Saksbehandleren og opptaksforvalteren ser også hva som har skjedd med søknaden og manglene over tid.

  # Kilde: workshop om meldinger 2026-11-09 (Miro), K12, K2-2, K3-2, K4-2, K5-3 og svar 9.
  # Blokkert: bygger på den nye sporingsloggen, og endringsloggen er stoppet (BAT-324).
  # At saksbehandleren ser om søkeren har lest en mangel, står i
  # 02 Behandling/søknadsmangler.feature (@OPT-BEH-BEH-008).
  # Endringene i saken står i 02 Behandling/hendelseslogg_for_saksbehandling.feature (@OPT-BEH-BEH-016).

  Regel: Saksbehandleren ser meldingene til søkeren med dato og klokkeslett
    # Søkeren kan ikke svare på meldinger nå (sende_melding_til_søker.feature).
    # Når søkeren kan svare, skal svarene også vises her.

    Scenario: Saksbehandleren ser meldingen om en mangel
      Gitt at søkeren har fått en melding om en mangel
      Når saksbehandleren åpner søkerens søknad
      Så ser saksbehandleren meldingen med dato og klokkeslett

  Regel: Saksbehandleren ser om søkeren har åpnet meldingen

    Scenario: Saksbehandleren ser at søkeren har åpnet meldingen
      Gitt at søkeren har åpnet en melding om søknaden
      Når saksbehandleren åpner søkerens søknad
      Så ser saksbehandleren at søkeren har åpnet meldingen

    Scenario: Saksbehandleren ser at søkeren ikke har åpnet meldingen
      Gitt at søkeren ikke har åpnet en melding om søknaden
      Når saksbehandleren åpner søkerens søknad
      Så ser saksbehandleren at søkeren ikke har åpnet meldingen

  Regel: Saksbehandleren og opptaksforvalteren ser hva som har skjedd med søknaden over tid

    Scenariomal: Opptaksforvalteren ser at <hendelse>
      Gitt at <hendelse>
      Når opptaksforvalteren åpner søkerens søknad
      Så ser opptaksforvalteren hendelsen med tidspunkt, i rekkefølgen hendelsene skjedde

      Eksempler:
        | hendelse                                                                  |
        | søkeren har levert søknaden                                               |
        | søkeren har endret søknaden                                               |
        | opptaksforvalteren har lagt til et søknadsalternativ etter søknadsfristen |

    Scenario: Saksbehandleren ser forløpet til en mangel
      Gitt at en mangel er opprettet på søkerens søknad
      Og at søkeren har lastet opp dokumentasjon for mangelen
      Og at saksbehandleren har sjekket ut mangelen
      Når saksbehandleren åpner mangelen
      Så ser saksbehandleren tidspunktet for hver hendelse
        | hendelse                         |
        | mangelen ble opprettet           |
        | søkeren fikk varsel om mangelen  |
        | søkeren lastet opp dokumentasjon |
        | mangelen ble sjekket ut          |

  Regel: Opptaksforvalteren ser mottakerne av en utsending og utsendingene som feilet

    Scenario: Opptaksforvalteren ser at en utsending feilet
      Gitt at en melding er sendt til to søkere
      Og at utsendingen til den ene søkeren feilet
      Når opptaksforvalteren ser på utsendingen
      Så ser opptaksforvalteren begge søkerne som mottakere
      Og opptaksforvalteren ser hvilken søker utsendingen feilet for
