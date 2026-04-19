# language: no

@ORG-ADM-OPP-001 @must
Egenskap: Opprette organisasjon
  Som en systemadministrator
  ønsker jeg å opprette en ny organisasjon
  slik at nye norske læresteder eller deres samarbeidsvirksomheter i Norge eller utlandet kan registreres i systemet.

  Regel: Norsk organisasjon henter data fra Brønnøysundregistrene

    Scenario: Organisasjonsnummer gir automatisk utfylling fra Brønnøysund
      Gitt at jeg oppretter en ny norsk organisasjon
      Når jeg oppgir organisasjonsnummer
      Så skal systemet hente navn, adresse og organisasjonstype fra Brønnøysundregistrene automatisk

    Scenario: Organisasjonstype settes fra Brønnøysundregistrene
      Gitt at jeg oppretter en norsk organisasjon med gyldig organisasjonsnummer
      Når dataene hentes fra Brønnøysundregistrene
      Så skal organisasjonstype settes til verdien fra Brønnøysundregistrene

  Regel: Organisasjonsid tildeles automatisk

    Scenario: Ny organisasjonsid tildeles ved opprettelse
      Når jeg oppretter en ny organisasjon
      Så skal systemet automatisk tildele en unik organisasjonsid

    Scenario: Organisasjonsidformat for norske læresteder
      Gitt at jeg oppretter en norsk organisasjon
      Så skal organisasjonsid følge formatet for norske læresteder

    Scenario: Organisasjonsidformat for utenlandske organisasjoner
      Gitt at jeg oppretter en utenlandsk organisasjon
      Så skal organisasjonsid følge formatet landnummer + løpenummer, f.eks. "444+12345" for India

  Regel: Obligatoriske felter må fylles ut

    Scenario: Opprette organisasjon med obligatoriske felter
      Når jeg fyller ut navn, organisasjonstype og URL og lagrer
      Så skal organisasjonen opprettes og tildeles organisasjonsid

  Regel: Valgfrie felter kan registreres

    Scenario: Registrere akronym
      Når jeg fyller ut akronym for organisasjonen
      Så skal akronymet lagres og brukes i søk

    Scenario: Registrere by
      Når jeg fyller ut by for organisasjonen
      Så skal byen lagres på organisasjonen

    Scenario: Registrere NSD-kode
      Når jeg fyller ut NSD-kode
      Så skal NSD-koden lagres på organisasjonen

    Scenario: Registrere PIC-nummer fra EU
      Når jeg fyller ut PIC-nummer
      Så skal PIC-nummeret lagres på organisasjonen

    Scenario: Registrere godkjent betalingsinstitusjon
      Når jeg markerer organisasjonen som godkjent betalingsinstitusjon
      Så skal dette lagres på organisasjonen

    Scenario: Registrere landkode
      Når jeg velger registrert landkode for organisasjonen
      Så skal landkoden lagres på organisasjonen

  Regel: Erasmuskode verifiseres mot HEI-registeret

    Scenario: Erasmuskode verifiseres mot HEI-registeret ved registrering
      Når jeg registrerer en Erasmuskode
      Så skal systemet slå opp koden mot HEI-registeret
      Og vise om koden er gyldig

    Scenario: Ugyldig Erasmuskode gir advarsel
      Når jeg registrerer en Erasmuskode som ikke finnes i HEI-registeret
      Så skal jeg se en advarsel om at koden ikke ble funnet
      Og kunne velge om jeg likevel ønsker å lagre den

  Regel: Språkkoder settes basert på nasjonalitet

    Scenario: Norsk organisasjon får norske språkkoder
      Gitt at organisasjonen er norsk
      Så skal språkkodene NO, NYNO, SAMISK og ENG være tilgjengelige

    Scenario: Utenlandsk organisasjon får internasjonale språkkoder
      Gitt at organisasjonen er utenlandsk
      Så skal språkkodene ORG og ENG være tilgjengelige

  Regel: Utenlandske organisasjoner kan ha visningsnavn

    Scenario: Visningsnavn for utenlandsk organisasjon
      Gitt at jeg oppretter en utenlandsk organisasjon
      Når jeg fyller ut visningsnavn
      Så skal visningsnavnet brukes der organisasjonens navn vises for brukere

  Regel: Akkreditering registreres av NOKUT

    Scenario: Akkreditering kan ikke settes av systemadministrator
      Gitt at jeg oppretter en organisasjon
      Så skal akkrediteringsfeltet være skrivebeskyttet for systemadministratorer
      Og det skal fremgå at akkreditering registreres av NOKUT

  Regel: Organisasjonen må godkjennes før den er aktiv

    Scenario: Ny organisasjon er i forslagsstatus til den godkjennes
      Når jeg lagrer en ny organisasjon
      Så skal organisasjonen ha status "Forslag" inntil den godkjennes

    Scenario: Godkjenne organisasjonsforslaget
      Gitt at en ny organisasjon er i status "Forslag"
      Når jeg godkjenner forslaget
      Så skal organisasjonen bli aktiv og søkbar

# ÅPNE SPØRSMÅL:
# - Hvem kan opprette organisasjoner — kun SIKT-ansatte, eller også lokale administratorer?
# - Skal visningsnavn være et eget felt, eller kun brukes for utenlandske inst.?
# - Eksakt format og regler for organisasjonsID per land?
