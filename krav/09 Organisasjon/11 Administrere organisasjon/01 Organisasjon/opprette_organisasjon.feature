# language: no

@ORG-ADM-OPP-001 @must
Egenskap: Opprette organisasjon
  Som en systemadministrator
  ønsker jeg å opprette en ny organisasjon
  slik at nye norske læresteder eller deres samarbeidsvirksomheter i Norge eller utlandet kan registreres i systemet.

  Regel: Norsk organisasjon henter data fra Brønnøysundregistrene

    @should
    Scenario: Organisasjonsnummer gir automatisk utfylling fra Brønnøysund
      Gitt at jeg oppretter en ny norsk organisasjon
      Når jeg oppgir organisasjonsnummer
      Så skal systemet hente navn, adresse og organisasjonstype fra Brønnøysundregistrene automatisk

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
      Når jeg fyller ut navn, organisasjonstype, landkode og originalspråkkode og lagrer
      Så skal organisasjonen opprettes og tildeles organisasjonsid

    Scenario: Landkode er obligatorisk
      Gitt at jeg oppretter en organisasjon
      Når jeg forsøker å lagre uten å ha valgt landkode
      Så skal systemet hindre lagring og be meg fylle ut landkode

    Scenario: Originalspråkkode er obligatorisk
      Gitt at jeg oppretter en organisasjon
      Når jeg forsøker å lagre uten å ha valgt originalspråkkode
      Så skal systemet hindre lagring og be meg velge en ISO 639-språkkode

  Regel: Valgfrie felter kan registreres

    Scenario: Registrere kortnavn
      Når jeg fyller ut kortnavn for organisasjonen
      Så skal kortnavnet lagres og brukes i søk

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

    Scenario: Registrere URL
      Når jeg fyller ut URL for organisasjonen
      Så skal URL-en lagres på organisasjonen

    Scenario: Registrere SCHAC-kode
      Når jeg fyller ut SCHAC-kode for organisasjonen
      Så skal SCHAC-koden lagres på organisasjonen

  Regel: Erasmuskode verifiseres mot HEI-registeret

    Scenario: Erasmuskode verifiseres mot HEI-registeret ved registrering
      Når jeg registrerer en Erasmuskode
      Så skal systemet slå opp koden mot HEI-registeret
      Og vise om koden er gyldig

    Scenario: Ugyldig Erasmuskode gir advarsel
      Når jeg registrerer en Erasmuskode som ikke finnes i HEI-registeret
      Så skal jeg se en advarsel om at koden ikke ble funnet
      Og kunne velge om jeg likevel ønsker å lagre den

  Regel: Navn og originalspråk registreres

    Scenario: Originalnavn registreres på originalspråk i originaltegn
      Gitt at jeg oppretter en organisasjon
      Når jeg registrerer organisasjonsnavnet
      Så skal navnet lagres på originalspråket i originaltegn

    Scenario: Originalspråk velges fra ISO 639-standard
      Gitt at jeg registrerer et originalnavn
      Når jeg velger språkkode for originalspråket
      Så skal jeg kunne velge fra ISO 639-språkkoder

    Scenario: Alternative navn kan legges til på andre språk
      Gitt at jeg oppretter en organisasjon med originalnavn
      Når jeg ønsker å legge til et alternativt navn
      Så skal jeg kunne registrere et navn på et annet språk
      Og knytte det til en ISO 639-språkkode

    Scenario: Engelsk navn vises under for organisasjoner med ikke-norsk alfabet
      Gitt at en organisasjon har navn på ikke-norsk alfabet
      Og har et alternativt navn på engelsk
      Så skal det engelske navnet vises under organisasjonsnavnet

    Scenario: Oppfordring om engelsk navn dersom dette mangler
      Gitt at en organisasjon har navn på ikke-norsk alfabet
      Og ingen alternative navn er registrert
      Så skal systemet vise en oppfordring om å registrere et engelsk navn

  Regel: Akkreditering registreres av NOKUT for norske læresteder

    Scenario: Akkrediteringsfelt vises kun for norske læresteder
      Gitt at jeg oppretter et norsk lærested
      Så skal akkrediteringsfeltet vises og være skrivebeskyttet
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
# - Eksakt format og regler for organisasjonskode per land?
# - Skal norske organisasjoner ha faste språkkoder (NO, NYNO, SAMISK, ENG) i tillegg til ISO 639,
#   eller er ISO 639 tilstrekkelig for alle? Mulig konflikt med tidligere krav om faste koder.