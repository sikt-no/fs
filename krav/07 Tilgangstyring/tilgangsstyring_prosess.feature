# language: no
@skip @støtteprosesser @sikkerhet
Egenskap:  Tilgangsstyringsprosess
  Som systemadministrator ved organisasjon som bruker FS til studieadministrasjon, trenger jeg å kunne administrerer hvilke maskinbrukere som
til enhver tid har tilgang til å se data om våre utdanninger, studenter og søkere, for å sikre våre virksomhetsdata og personvern for personer registrert hos oss.
# senere iterasjon Sikt kan administrere FØR læresteder kan administrere

  Bakgrunn:
    Gitt at systemadministrastor er på tilgangsstyringsside

        #Navigere til oppretting av ny bruker/behandle søknad om bruker - dette kommer ikke i første iterasjon

  Scenariomal: Systemadministrator oppretter ny bruker
    Gitt at "<systemadministrator>" klikker på "Opprett ny bruker"
    Så oppretter "<systemadministrator>" "<ny bruker>" med tom maskinbrukerprofil

    Eksempler:
      |systemadministrator|ny bruker|
      |Cal El Supermann   |maskinbrukerID-detserbarerartutforandre|

  Scenariomal: Systemadministrator behandler søknad om maskinbruker
    Gitt at "<systemadministrator>" ser varsel om ubehandlet søknad om maskinbruker
    Når "<systemadministrator>" navigerer til "Behandle søknad om maskinbruker"
    Så ser "<systemadministrator>" en oversikt over "<maskinbrukersøknader>" til behandling

    Eksempler:
      |systemadministrator|maskinbrukersøknader|
      |Cal El Supermann   |søknad1, 2, 3|

  Scenariomal: Systemadministrator avslår søknad om ny maskinbruker
    Gitt at "<systemadministrator>" ser "<maskinbrukersøknader>" til behandling som ikke skal godkjennes
    Når "<systemadministrator>" avslår søknad om å opprette ny maskinbruker
    Så opprettes ikke ny maskinbruker og "<søker>" mottar avslag

    Eksempler:
      |systemadministrator|maskinbrukersøknader|søker|
      |Cal El Supermann   |søknad1, 2, 3|Sopra Steria|

  Scenariomal: Systemadministrator godkjenner søknad om ny maskinbruker
    Gitt at "<systemadministrator>" ser "<maskinbrukersøknader>" til behandling som skal godkjennes
    Når  "<systemadministrator>" godkjenner søknad om å opprette ny maskinbruker
    Så opprettes "<ny bruker>" med maskinbrukerprofil med "<søkers>" forhåndsutfylte info

    Eksempler:
      |systemadministrator|maskinbrukersøknader|søkers|
      |Cal El Supermann   |søknad1, 2, 3|Sopra Steria, bla bla bal|

  Scenario: systemadministrator kan legge til ny integrasjonsbruker
    Når systemadmin står på side
    Så får systemadmin legge til ny integrasjonsbruker
    Så får systemadmin sette aktiv periode for integrasjonsbruker

  Scenario: systemadministrator får endre integrasjonsbruker (flere ulike scenarier??)

  Scenario: systemadministrator får deaktivere integrasjonsbruker (sette utløpsdato, slette først?)

  Scenario: motta forespørsel om tilgang fra API-brukere

  Scenario: avslå forespørsel om tilgang-brukere

  Scenario: godta forespørsel om tilgang fra API-brukere
