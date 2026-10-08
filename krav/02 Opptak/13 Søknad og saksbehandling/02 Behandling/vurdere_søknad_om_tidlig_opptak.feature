# language: no
# GitHub: #TBD
#
# KILDER
#
# Delleveranse 3 av initiativet #456 Behandle søknader om tidlig opptak.
# Hovedkilde: Jira STEK-188 «Forvalte og behandle tidligopptak». STEK-188
# beskriver Confluence PFS 4518412300 «Behandling av søknad om tidlig opptak»
# som «ikke helt riktig», og går foran den der de sier ulikt.
# Søkeren flagger ønske om tidlig opptak, velger begrunnelse og laster opp
# dokumentasjon i Min kompetanse (#525). Denne featuren tar over derfra.
#
# Saksbehandleren vurderer om søkerens begrunnelse er dokumentert. Om søkeren
# er kvalifisert, avgjøres i den ordinære søknadsbehandlingen per
# søknadsalternativ, og saksbehandleren ser resultatet her. Konklusjonen og
# tilbudsgarantien står i gi_tilbudsgaranti_ved_tidlig_opptak.feature.
#
# AVKLART 25.09.2026
#
# - Samme rettighet som for ordinær søknadsbehandling. Ingen egen rolle for
#   tidlig opptak.
# - Dokumentasjonen knyttes ikke til de enkelte dokumentasjonskravene. Den
#   ligger på søknaden, og saksbehandleren ser krav og dokumenter hver for seg.
# - Saksbehandleren kan vurdere når som helst, også før dokumentasjonsfristen.
#   Dokumentasjon etter fristen er ikke mulig, se frister_og_hendelser.feature.
# - Kvalifisering vurderes mot det ordinære kompetanseregelverket for
#   utdanningstilbudene. Tidlig opptak har ikke eget regelverk.
# - Kvalifiseringen registreres ikke i denne featuren. Den kommer fra den
#   ordinære søknadsbehandlingen, per søknadsalternativ.
#
# AVKLART 07.10.2026
#
# - Saksbehandleren vurderer begrunnelsen og konkluderer per organisasjon. En
#   søknad med søknadsalternativer ved flere organisasjoner får en vurdering og
#   en konklusjon fra hver av organisasjonene.
# - Vurdering og konklusjon er to steg. Saksbehandleren vurderer først om
#   begrunnelsen er dokumentert, og velger så om søkeren deltar i tidligopptaket.
# - (Endret 08.10.2026, se under.) Er begrunnelsen ikke dokumentert, kan
#   saksbehandleren bare konkludere med at søkeren ikke deltar.
# - Konklusjonen krever ikke at kvalifiseringen er vurdert. Kvalifiseringen
#   sjekkes per søknadsalternativ når tidligopptaket gjennomføres, se
#   gi_tilbudsgaranti_ved_tidlig_opptak.feature.
# - Vurderingen og konklusjonen låses når opptaksforvalteren har gjennomført
#   tidligopptaket. Feil etter det rettes med manuell tilbudsgaranti fra T-rolle.
# - En søknad som ikke er konkludert når tidligopptaket gjennomføres, er ikke
#   med, og kan ikke konkluderes etterpå.
#
# AVKLART 08.10.2026
#
# - Saksbehandleren kan bare konkludere når søkeren selv har søkt om tidlig
#   opptak. Tilbudsgaranti fra tidligopptaket får bare søkere som har søkt.
#   Koden sjekker ikke dette i dag (SettTidligopptakKonklusjonService), og må
#   endres.
# - Er begrunnelsen ikke dokumentert, registreres det som en mangel på søknaden, og
#   søkeren får beskjed om den. Etter det vurderer saksbehandleren fritt om søkeren
#   skal delta i tidligopptaket. Dette erstatter regelen fra 07.10 om at «ikke
#   dokumentert» bare kan gi «deltar ikke». Avklart med fs-specify mot skissen i
#   FS-Admin, som har én konklusjon uten eget dokumentasjonssteg.
#
# BEGREPSBRUK
#
# «Begrunnelse» er grunnlaget søkeren har oppgitt for å søke tidlig opptak
# (tidligopptak_begrunnelsetype). Saksbehandleren registrerer ikke en egen
# begrunnelse, men vurderer om søkerens begrunnelse er dokumentert.
#
@OPT-BEH-BEH-008 @must @in-progress
Egenskap: Vurdere søknad om tidlig opptak
  Som saksbehandler
  ønsker jeg å vurdere søkerens begrunnelse for tidlig opptak og konkludere om søkeren deltar i tidligopptaket
  slik at søkere med dokumentert begrunnelse kan få tilbudsgaranti når tidligopptaket gjennomføres.

  # Konklusjonene saksbehandleren kan velge, legges inn i databasen per opptak, og
  # vedlikeholdes ikke i løsningen nå (avklart 08.10.2026, se
  # gi_tilbudsgaranti_ved_tidlig_opptak.feature).

  Bakgrunn:
    Gitt saksbehandler er innlogget i løsningen
    Og saksbehandler er inne på en søknad der søkeren har søkt om tidlig opptak

  Regel: Saksbehandler ser søkerens grunnlag for tidlig opptak

    Scenario: Se søkerens begrunnelse for tidlig opptak
      Gitt søkeren har oppgitt begrunnelsen "Fullført videregående opplæring"
      Når saksbehandler ser på søknaden
      Så ser saksbehandler at søkeren har søkt om tidlig opptak
      Og saksbehandler ser begrunnelsen "Fullført videregående opplæring"

    Scenario: Se dokumentasjonskrav for begrunnelsen
      Gitt begrunnelsen søkeren har oppgitt har tilknyttede dokumentasjonskrav
      Når saksbehandler ser på søknaden
      Så ser saksbehandler hvilken dokumentasjon søkeren må levere for begrunnelsen

    Scenario: Se dokumentasjon søkeren har levert
      Gitt søkeren har lastet opp dokumentasjon for tidlig opptak
      Når saksbehandler ser på søknaden
      Så ser saksbehandler dokumentasjonen søkeren har levert

  Regel: Saksbehandler vurderer om begrunnelsen er dokumentert

    Scenariomal: Registrere om begrunnelsen er dokumentert
      Når saksbehandler registrerer at begrunnelsen <vurdering>
      Så er det lagret at begrunnelsen <vurdering>

      Eksempler:
        | vurdering           |
        | er dokumentert      |
        | ikke er dokumentert |

    Scenario: Vurdere før dokumentasjonsfristen har gått ut
      Gitt dokumentasjonsfristen for tidlig opptak er "2027-03-01 23:59"
      Og søkeren har lastet opp dokumentasjon "2027-02-10"
      Når saksbehandler vurderer søknaden "2027-02-12"
      Så kan saksbehandler registrere om begrunnelsen er dokumentert

  Regel: Saksbehandler konkluderer om søkeren deltar i tidligopptaket

    Scenariomal: Konkludere når begrunnelsen er dokumentert
      Gitt saksbehandler har registrert at begrunnelsen er dokumentert
      Når saksbehandler konkluderer med at søkeren <konklusjon> i tidligopptaket
      Så er det lagret at søkeren <konklusjon> i tidligopptaket

      Eksempler:
        | konklusjon  |
        | deltar      |
        | ikke deltar |

    Scenario: Manglende dokumentasjon blir en mangel søkeren får beskjed om
      Når saksbehandler registrerer at begrunnelsen ikke er dokumentert
      Så er det registrert en mangel på søknaden for dokumentasjon av tidlig opptak
      Og søkeren får beskjed om at dokumentasjonen for tidlig opptak mangler

    Scenariomal: Konkludere når begrunnelsen ikke er dokumentert
      Gitt saksbehandler har registrert at begrunnelsen ikke er dokumentert
      Og søkeren har fått beskjed om at dokumentasjonen for tidlig opptak mangler
      Når saksbehandler konkluderer med at søkeren <konklusjon> i tidligopptaket
      Så er det lagret at søkeren <konklusjon> i tidligopptaket

      Eksempler:
        | konklusjon  |
        | deltar      |
        | ikke deltar |

    Scenario: Kan ikke konkludere før begrunnelsen er vurdert
      Gitt det er ikke registrert om begrunnelsen er dokumentert
      Når saksbehandler skal konkludere
      Så kan ikke saksbehandler konkludere

    Scenario: Kan ikke konkludere når søkeren ikke har søkt om tidlig opptak
      Gitt saksbehandler er inne på en annen søknad der søkeren ikke har søkt om tidlig opptak
      Når saksbehandler ser på søknaden
      Så kan ikke saksbehandler konkludere om søkeren deltar i tidligopptaket

    Scenario: Konkludere før kvalifiseringen er vurdert
      Gitt saksbehandler har registrert at begrunnelsen er dokumentert
      Og kvalifiseringen til "Sykepleie, høst 2027" er ikke vurdert i søknadsbehandlingen
      Når saksbehandler konkluderer med at søkeren deltar i tidligopptaket
      Så er det lagret at søkeren deltar i tidligopptaket

    Scenario: Konklusjon per organisasjon
      Gitt søknaden har følgende søknadsalternativer:
        | søknadsalternativ     | organisasjon |
        | Sykepleie, høst 2027  | OsloMet      |
        | Vernepleie, høst 2027 | NTNU         |
      Og saksbehandler ved OsloMet har konkludert med at søkeren deltar i tidligopptaket
      Når saksbehandler ved NTNU konkluderer med at søkeren ikke deltar i tidligopptaket
      Så deltar søkeren i tidligopptaket ved OsloMet
      Og søkeren deltar ikke i tidligopptaket ved NTNU

  Regel: Kvalifisering hentes fra den ordinære søknadsbehandlingen

    Scenario: Se kvalifisering for søknadsalternativer med tidlig tilbud
      Gitt søknaden har følgende søknadsalternativer:
        | søknadsalternativ     | tidlig tilbud | kvalifisert |
        | Sykepleie, høst 2027  | ja            | ja          |
        | Vernepleie, høst 2027 | ja            | nei         |
        | Historie, høst 2027   | nei           | ja          |
      Når saksbehandler ser på søknaden
      Så ser saksbehandler at søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og saksbehandler ser at søkeren ikke er kvalifisert til "Vernepleie, høst 2027"

  Regel: Vurderingen og konklusjonen kan endres til tidligopptaket er gjennomført

    Scenario: Endre vurdering før tidligopptaket er gjennomført
      Gitt saksbehandler har registrert at begrunnelsen er dokumentert
      Og tidligopptaket er ikke gjennomført
      Når saksbehandler registrerer at begrunnelsen ikke er dokumentert
      Så er det lagret at begrunnelsen ikke er dokumentert

    Scenario: Endre konklusjon før tidligopptaket er gjennomført
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og tidligopptaket er ikke gjennomført
      Når saksbehandler konkluderer med at søkeren ikke deltar i tidligopptaket
      Så er det lagret at søkeren ikke deltar i tidligopptaket

    Scenario: Låst etter at tidligopptaket er gjennomført
      Gitt opptaksforvalter har gjennomført tidligopptaket
      Når saksbehandler ser på søknaden om tidlig opptak
      Så kan ikke saksbehandler endre vurderingen av begrunnelsen
      Og saksbehandler kan ikke endre konklusjonen

    Scenario: Kan ikke konkludere etter at tidligopptaket er gjennomført
      Gitt det er ikke konkludert om søkeren deltar i tidligopptaket
      Og opptaksforvalter har gjennomført tidligopptaket
      Når saksbehandler ser på søknaden om tidlig opptak
      Så kan ikke saksbehandler konkludere
