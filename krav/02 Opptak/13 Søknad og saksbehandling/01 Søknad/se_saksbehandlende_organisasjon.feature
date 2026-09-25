# language: no
# GitHub: #622
#
# Kilde: STEK-516, STEK-517, STEK-518 under epic STEK-521. Alle tre hadde tom
# beskrivelse i Jira; innholdet under er avklart i kravsamtale 23.09.2026.
#
# Avklart 23.09.2026:
# - FS eier kontaktopplysningene og viser verdiene direkte til søkeren. Kravet
#   er ikke en lenke ut til lærestedets egne sider.
# - «Institusjon» i Jira-titlene betyr organisasjon i generell forstand.
# - Kravet gjelder organisasjonen som har ansvar for å behandle saken — aldri
#   den enkelte saksbehandleren. Jira-titlene bruker «saksbehandler» løsere
#   enn dette; her er begrepet strammet inn.
# - Saksbehandlende organisasjon er ikke kjent før søknaden er blitt til en
#   eller flere saker, og det skjer etter innsending — i noen tilfeller ikke
#   umiddelbart. Kravet dekker derfor også tilstanden før saken finnes.
# - Hvor kontaktopplysningene lagres er bevisst ikke beskrevet. Se
#   oppfølgingspunkt nederst.
#
@OPT-SØK-SØK-005 @should @draft
Egenskap: Se saksbehandlende organisasjon for søknadsalternativene
  Som søker
  ønsker jeg å se hvilken organisasjon som behandler hvert av søknadsalternativene mine, og hvordan jeg når dem
  slik at jeg kan ta kontakt med riktig organisasjon når jeg har spørsmål.

  Kravet omfatter kun organisasjonen som har behandlingsansvar, aldri den
  enkelte saksbehandleren. Søkeren skal ikke se navn på personer.

  Bakgrunn:
    Gitt jeg er innlogget på personflaten
    Og jeg har sendt inn en søknad på et opptak

  Regel: Søker ser hvilken organisasjon som behandler hvert søknadsalternativ

    Scenario: Søker ser saksbehandlende organisasjon per alternativ
      Gitt søknaden min er blitt til saker
      Når jeg åpner den innsendte søknaden min
      Så ser jeg hvilken organisasjon som behandler hvert søknadsalternativ

    Scenario: Saken for et alternativ er ikke opprettet ennå
      Gitt søknaden min har et søknadsalternativ som ennå ikke er blitt til en sak
      Når jeg åpner den innsendte søknaden min
      Så ser jeg søknadsalternativet i oversikten
      Og jeg får vite at ansvarlig organisasjon ikke er avklart ennå

  Regel: Søker ser kontaktinformasjon til saksbehandlende organisasjon

    Scenario: Søker ser kontaktopplysningene for et alternativ
      Gitt jeg ser hvilken organisasjon som behandler et søknadsalternativ
      Når jeg ser nærmere på alternativet
      Så ser jeg følgende kontaktopplysninger om organisasjonen
        | opplysning            |
        | Navn                  |
        | E-postadresse         |
        | Telefonnummer         |
        | Lenke til opptaksside |

    @openquestion
    Scenario: Organisasjonen mangler en av kontaktopplysningene
      # ÅPNE SPØRSMÅL: Hva ser søkeren når organisasjonen ikke har registrert
      # f.eks. telefonnummer? Utelates feltet, eller vises det tomt?
      Gitt organisasjonen som behandler alternativet mangler en kontaktopplysning
      Når jeg ser nærmere på alternativet
      Så ser jeg de kontaktopplysningene organisasjonen har registrert

  Regel: Organisasjonen vedlikeholder kontaktinformasjonen som vises til søkere

    Scenario: Registrere kontaktinformasjon for opptak
      Gitt jeg er opptaksforvalter
      Når jeg registrerer kontaktinformasjon for opptakssaker ved min organisasjon
      Så er opplysningene tilgjengelige for søkere med alternativer min organisasjon behandler

    Scenario: Endre registrert kontaktinformasjon
      Gitt min organisasjon har registrert kontaktinformasjon for opptakssaker
      Når jeg endrer opplysningene
      Så ser søkerne de oppdaterte opplysningene

# ÅPNE SPØRSMÅL:
# - Hvem kan registrere kontaktinformasjonen? Fellestekster (@OPT-OPT-TEK-001)
#   lar kun forvaltende organisasjon redigere, men her må hver deltakende
#   organisasjon kunne sette sin egen — ellers kan ikke UiO oppgi sin adresse i
#   et samordna opptak. Avklares med Sofie og Patrik.
# - Når flere søknadsalternativer behandles av samme organisasjon: vises
#   kontaktinformasjonen per alternativ, eller samlet én gang?
# - Skal kontaktopplysningene kunne angis på flere språk, slik fellestekster
#   krever (bokmål, nynorsk, engelsk, samisk)?
#
# OPPFØLGINGSPUNKT (lagring, bevisst utenfor kravet):
# - ORGANISASJONSEPOSTADRESSE og ORGANISASJONSTELEFON finnes allerede i
#   databasen og er lesbare via utdanningsregisteret (experimental), men det
#   finnes ingen mutation for å vedlikeholde dem, og typene er for grovkornede
#   til å skille ut «opptak» (kun EKSTERN/INTERN, og FIRMA for telefon).
#   Valget mellom å utvide utdanningsregisteret og å registrere på opptaket
#   hører til løsningsarbeidet.
# - Overlapp mot #472 «To-veis kommunikasjon mellom saksbehandler og søker»:
#   samme brukerbehov løst inne i systemet. Direktemelding er nedprioritert nå,
#   men de to bør ses i sammenheng senere.
