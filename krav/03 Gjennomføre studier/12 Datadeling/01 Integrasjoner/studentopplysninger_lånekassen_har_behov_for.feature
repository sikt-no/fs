# language: no
@GJE-DAT-INT-001 @lånekassen @fs @fsgraphql
Egenskap: Studentopplysninger til Lånekassen
  Som maskinbruker for Lånekassen trenger jeg tilgang på studentopplysninger fra FS-læresteder slik at Lånekassen har riktig informasjon om
  hvilke studenter som studerer på hvilke studier ved hvilke læresteder, samt nødvendige oppdateringer i informasjon om studiegjennomføring, forhåndsgodkjenninger og oppnådde resultater.
  Formålet med datainnhentingen er at Lånekassen kan behandle saker om studiestøtte, og datainnhentingen er hjemlet i utdanningsstøttelovens § 21 og § 23 med forskrift.

  Bakgrunn:
    Gitt at FSGraphQL-API er tilgjengelig for Lånekassen
    Og at Lånekassen har gyldig autentisering mot FSGraphQL-API
    Og at lærestedet har aktive studenter registrert i FS

  @mengde
  Scenario: Tilgjengeliggjøre oversikt over aktive studenter ved lærested
    Gitt at lærestedet har aktive studenter for inneværende semester
    Når Lånekassen spør etter aktive studenter ved lærestedet gjennom FSGraphQL-API
    Så returneres en liste med alle aktive studenter
    Og listen inneholder nødvendige identifikatorer og studieinformasjon
    Og kun studenter med gyldig studentstatus inkluderes

  @enkeltvis
  Scenario: Tilgjengeliggjøre detaljert informasjon om enkelt student
    Gitt at en student "<studentnavn>" er aktiv ved lærestedet
    Når Lånekassen ber om informasjon om denne studenten gjennom FSGraphQL-API
    Så returneres studentens detaljerte studieinformasjon
    Og informasjonen inneholder studieprogram, studiepoeng og studieprogresjon
    Eksempler:
      | studentnavn         |
      | Kranglete Artisjokk |
      | Misfornøyd Ambassade|

  @forhåndsgodkjenning
  Scenario: Tilgjengeliggjøre forhåndsgodkjenning for utvekslingsstudenter
    Gitt at en student har søkt om forhåndsgodkjenning av utvekslingsstudier
    Og at lærestedet har behandlet og godkjent søknaden
    Når Lånekassen ber om informasjon om forhåndsgodkjenning gjennom FSGraphQL-API
    Så returneres godkjenningsstatus og detaljer om utvekslingen
    Og informasjonen inneholder utenlandsk lærested og godkjente studiepoeng
    Og godkjenningsperiode og studieprogramtilknytning inkluderes

  @hendelser @sanntid
  Scenario: Lytte på hendelser om endringer i studentstatus
    Gitt at Lånekassen har etablert abonnement på studentstatusendringer
    Når en students status endres ved lærestedet
    Så sendes en hendelse til Lånekassen gjennom FSGraphQL-API
    Og hendelsen inneholder oppdatert studentinformasjon
    Og kun relevante endringer som påvirker låneberettigelse rapporteres

  @feilhåndtering
  Scenario: Håndtere forespørsler om ikke-eksisterende studenter
    Gitt at Lånekassen ber om informasjon om en student som ikke finnes ved lærestedet
    Når forespørselen sendes gjennom FSGraphQL-API
    Så returneres en tydelig melding om at studenten ikke er registrert
    Og ingen sensitive data lekkes i feilmeldingen

  @sikkerhet @personvern
  Scenario: Sikre at kun autoriserte data deles med Lånekassen
    Gitt at en student har begrenset samtykke til datadeling
    Når Lånekassen ber om studentens informasjon
    Så returneres kun data som studenten har samtykket til å dele
    Og eventuelle restriksjoner dokumenteres i responsen

  @dataformat @standardisering
  Scenario: Levere studentdata i standardisert format til Lånekassen
    Gitt at lærestedet har studentinformasjon lagret i FS
    Når Lånekassen ber om studentdata gjennom FSGraphQL-API
    Så formateres dataene i henhold til GraphQL-skjemaet
    Og alle obligatoriske felt for lånesaksbehandling inkluderes
    Og dataformatene er konsistente på tvers av alle forespørsler

  @ytelse @responsivitet
  Scenario: Sikre rask respons på forespørsler fra Lånekassen
    Gitt at Lånekassen sender en forespørsel om studentdata
    Når forespørselen behandles av FSGraphQL-API
    Så returneres svar innen akseptabel responstid
    Og systemet håndterer flere samtidige forespørsler effektivt

  @begrensninger @stordata
  Scenario: Håndtere store mengder studentdata
    Gitt at lærestedet har et stort antall aktive studenter
    Når Lånekassen ber om oversikt over alle aktive studenter
    Så implementeres paginering for å håndtere store datasett
    Og responsen returneres i håndterbare porsjoner
    Og ytelsen påvirkes ikke negativt av datamengden

  @logging @overvåking
  Scenario: Logge og overvåke API-bruk fra Lånekassen
    Gitt at Lånekassen gjør forespørsler mot FSGraphQL-API
    Når forespørslene behandles
    Så logges all API-bruk for overvåking og feilsøking
    Og responstider og feilrater overvåkes kontinuerlig
    Og varsler sendes ved uvanlig høy feilrate

  @sikkerhet @autentisering
  Scenario: Autentisere og autorisere Lånekassens tilgang
    Gitt at Lånekassen forsøker å koble til FSGraphQL-API
    Når autentiseringsforespørsel sendes
    Så valideres Lånekassens legitimasjon mot konfigurerte tilganger
    Og kun autoriserte operasjoner tillates
    Og alle tilgangsforsøk logges for sikkerhet
    Og tilgangsnivået begrenses til kun nødvendige studentdata

  # =========================================================================
  # FREMTIDIGE ØNSKEDE UTVIDELSER - IKKE I FØRSTE VERSJON
  # =========================================================================

  Scenario: Tilgjengeliggjøre aktiv studierett for preutfylling av søknad
    Gitt at en student har aktiv studierett ved lærestedet på tidspunktet hen søker studiestøtte
    Når Lånekassen ber om studentens aktive studierett gjennom FSGraphQL-API
    Så returneres informasjon om lærested og studieprogram studenten har studierett ved
    Og informasjonen kan brukes til preutfylling av Lånekassens søknadsskjema
    Og studenten kan bekrefte eller avkrefte om opplysningene stemmer

  Scenario: Håndtere studiestøttesøkere uten aktiv studierett
    Gitt at en som søker studiestøtte ikke har registrert studierett på søknadstidspunktet
    Når Lånekassen ber om studentens aktive studierett gjennom FSGraphQL-API
    Så returneres melding om at studenten ikke har aktiv studierett
    Og studenten må selv velge fra liste i Lånekassens søknadssystem

  Scenario: Validere studierett som forutsetning for utdanningsstøtte
    Gitt at det stilles krav om registrert studierett for å søke utdanningsstøtte
    Når en student forsøker å søke uten aktiv studierett
    Så skal systemet hindre videre søknadsprosess
    Og studenten får informasjon om hvordan de kan registrere studierett

  Scenario: Spore bytte av institusjon og studieprogram
    Gitt at en student bytter fra ett studieprogram til et annet
    Når endringen registreres i FS
    Så sendes varsel til Lånekassen om studieprogrambytte
    Og historikk over tidligere studieprogram bevares
    Og informasjon om tidspunkt for bytte inkluderes

  Scenario: Registrere studieavbrudd
    Gitt at en student avbryter sine studier
    Når avbruddet registreres i FS
    Så sendes varsel til Lånekassen om studieavbrudd
    Og avbruddstidspunkt og årsak dokumenteres
    Og studentens låneberettigelse kan revurderes

  @fremtidig
  Scenario: Håndtere studiepermisjon
    Gitt at en student tar permisjon fra sine studier
    Når permisjonen registreres i FS
    Så sendes varsel til Lånekassen om studiepermisjon
    Og permisjonsperiode sendes til Lånekassen slik at studiestøtten kan justeres