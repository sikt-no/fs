# language: no
@skip @støtteprosesser @sikkerhet
Egenskap: 08 Teknisk: API-brukerprofil
  Som systemadministrator har jeg behov for å kunne se detaljer og endre på innstillnger og tilganger som gjelder for den enkelte brukerprofilene
  som har tilganger ved mitt lærested. 

  Bakgrunn:
    Gitt at systemadministrator er inne på maskinbrukerprofil

  Scenariomal: Systemadministrator ser opplysninger om maskinbrukerprofil
    Når "<systemadministrator>" ser på maskinbrukerprofilen til "<maskinbruker>"
    Så ser systemadministrator "<beskrivelse>" av hvilken organsisasjon (hvem) som bruker maskinbrukeren til hva
    Så ser systemadministrator "<eierorganisasjon>" som er organisasjonen som er ansvarlig for maskinbrukerens tilganger og behandler søknader om tilgang til data
    Så ser systemadministrator maskinbrukerens "<kontaktperson>"
    Så ser systemadministrator "<kontakttelefon>" for kontaktperson
    Så ser systemadministrator "<kontakte-post>" for maskinbrukeren
    Så ser systemadministrator maskinbrukerens "<roller>" med "<tilgangstype>" og hvilket "<API>" rollen gjelder
 #her kan vil legge på mer info etterhvert som det blir aktuelt, feks etter designet:
    Så ser systemadministrator hvilken dato de enkelte tilgangene er gitt
    Så ser systemadministrator mulighet til å inndra de enkelte tilgangene fra maskinbruker
    Så ser systemadministrator mulighet til å legge til nye tilganger/behandle søknad om nye tilganger

    Eksempler:
      | systemadministrator | maskinbruker | beskrivelse | kontaktperson | kontakttelefon | kontakte-post     | roller         | tilgangstype |API      |
      |Bodhild Aga          |SIOporten     |bla bla      |Ola Johansen   |99887766        |ola.johansen@sio.no|studentdata_les1|data          |FSgraphQL|
