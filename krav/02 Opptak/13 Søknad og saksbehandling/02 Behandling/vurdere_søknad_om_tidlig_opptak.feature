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
# - Saksbehandleren vurderer begrunnelsen for hele søknaden, ikke for hvert
#   søknadsalternativ.
# - Samme rettighet som for ordinær søknadsbehandling. Ingen egen rolle for
#   tidlig opptak.
# - Vurderingene kan endres fram til svaret er sendt til søkeren.
# - Dokumentasjonen knyttes ikke til de enkelte dokumentasjonskravene. Den
#   ligger på søknaden, og saksbehandleren ser krav og dokumenter hver for seg.
# - Saksbehandleren kan vurdere når som helst, også før dokumentasjonsfristen.
#   Dokumentasjon etter fristen er ikke mulig, se frister_og_tidsperioder.feature.
# - Kvalifisering vurderes mot det ordinære kompetanseregelverket for
#   utdanningstilbudene. Tidlig opptak har ikke eget regelverk.
# - Kvalifiseringen registreres ikke i denne featuren. Den kommer fra den
#   ordinære søknadsbehandlingen, per søknadsalternativ.
#
# BEGREPSBRUK
#
# «Begrunnelse» er grunnlaget søkeren har oppgitt for å søke tidlig opptak
# (tidligopptak_begrunnelsetype). Saksbehandleren registrerer ikke en egen
# begrunnelse, men vurderer om søkerens begrunnelse er dokumentert.
#
@OPT-BEH-BEH-006 @must @draft
Egenskap: Vurdere søknad om tidlig opptak
  Som saksbehandler
  ønsker jeg å vurdere om søkeren oppfyller kravene for tidlig opptak
  slik at søknaden om tidlig opptak konkluderes på riktig grunnlag.

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
      Så er det lagret på søknaden at begrunnelsen <vurdering>

      Eksempler:
        | vurdering            |
        | er dokumentert       |
        | ikke er dokumentert  |

    Scenario: Vurdere før dokumentasjonsfristen har gått ut
      Gitt dokumentasjonsfristen for tidlig opptak er "2027-03-01 23:59"
      Og søkeren har lastet opp dokumentasjon "2027-02-10"
      Når saksbehandler vurderer søknaden "2027-02-12"
      Så kan saksbehandler registrere om begrunnelsen er dokumentert

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

  Regel: Vurderingene kan endres fram til svaret er sendt

    Scenario: Endre vurdering før svaret er sendt
      Gitt saksbehandler har registrert at begrunnelsen er dokumentert
      Og søkeren har ikke fått svar på søknaden om tidlig opptak
      Når saksbehandler registrerer at begrunnelsen ikke er dokumentert
      Så er det lagret på søknaden at begrunnelsen ikke er dokumentert

    Scenario: Vurderingen kan ikke endres etter at svaret er sendt
      Gitt søkeren har fått svar på søknaden om tidlig opptak
      Når saksbehandler ser på vurderingene av søknaden
      Så kan ikke saksbehandler endre vurderingene
