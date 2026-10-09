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
# - (Endret 09.10.2026, se under.) Vurdering og konklusjon er to steg.
#   Saksbehandleren vurderer først om begrunnelsen er dokumentert, og velger så
#   om søkeren deltar i tidligopptaket.
# - (Endret 08.10.2026 og 09.10.2026, se under.) Er begrunnelsen ikke
#   dokumentert, kan saksbehandleren bare konkludere med at søkeren ikke deltar.
# - Konklusjonen krever ikke at kvalifiseringen er vurdert. Kvalifiseringen
#   sjekkes per søknadsalternativ når tidligopptaket gjennomføres, se
#   gi_tilbudsgaranti_ved_tidlig_opptak.feature.
# - (Endret 09.10.2026, se under.) Vurderingen og konklusjonen låses når
#   opptaksforvalteren har gjennomført tidligopptaket. Feil etter det rettes med
#   manuell tilbudsgaranti fra T-rolle.
# - En søknad som ikke er konkludert når tidligopptaket gjennomføres, er ikke
#   med. (Endret 09.10.2026, se under: den kan konkluderes etterpå.)
#
# AVKLART 08.10.2026
#
# - Saksbehandleren kan bare konkludere når søkeren selv har søkt om tidlig
#   opptak. Tilbudsgaranti fra tidligopptaket får bare søkere som har søkt.
#   Koden sjekker ikke dette i dag (SettTidligopptakKonklusjonService), og må
#   endres.
# - (Endret 09.10.2026, se under.) Er begrunnelsen ikke dokumentert, registreres
#   det som en mangel på søknaden, og søkeren får beskjed om den. Etter det
#   vurderer saksbehandleren fritt om søkeren skal delta i tidligopptaket. Dette
#   erstatter regelen fra 07.10 om at «ikke dokumentert» bare kan gi «deltar
#   ikke». Avklart med fs-specify mot skissen i FS-Admin, som har én konklusjon
#   uten eget dokumentasjonssteg.
#
# AVKLART 09.10.2026 (review av PR #654)
#
# - Vurderingen og konklusjonen er ett steg. Saksbehandleren velger én
#   konklusjon blant konklusjonene opptaket har, og ingen andre. Hver konklusjon
#   sier om søkeren deltar i tidligopptaket (deltar_i_tidligopptak i kodeverket
#   tidligopptak_konklusjon). Om begrunnelsen er dokumentert, ligger i
#   konklusjonen, f.eks. «KFF – Kan få tidlig opptak, har godkjent grunn».
#   Erstatter de to stegene fra 07.10, og stemmer med koden og skissen i FS-Admin.
# - Systemet oppretter ingen mangel. Mangler dokumentasjonen, oppretter
#   saksbehandleren en vanlig søknadsmangel, og søkeren får beskjed om den på
#   samme måte som for andre mangler. Erstatter regelen fra 08.10 om at
#   «ikke dokumentert» registreres som en mangel.
# - Konklusjonen låses ikke. Saksbehandleren kan sette og endre den også etter
#   at tidligopptaket er gjennomført. Det endrer ikke tilbudsgarantier som alt er
#   gitt, eller svaret søkeren alt har fått, men en ny gjennomføring tar den med.
#   Erstatter låsingen fra 07.10.
#
# BEGREPSBRUK
#
# «Begrunnelse» er grunnlaget søkeren har oppgitt for å søke tidlig opptak
# (tidligopptak_begrunnelsetype). Saksbehandleren registrerer ikke en egen
# begrunnelse, men vurderer om søkerens begrunnelse er dokumentert, og velger en
# konklusjon ut fra det.
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

  Regel: Saksbehandler konkluderer om søkeren deltar i tidligopptaket
    # Vurderingen og konklusjonen er ett steg: konklusjonen sier både om
    # begrunnelsen er dokumentert og om søkeren deltar. Mangler dokumentasjonen,
    # oppretter saksbehandleren en vanlig søknadsmangel. Systemet gjør det ikke
    # (avklart 09.10.2026).

    Scenario: Velge blant konklusjonene opptaket har
      Gitt opptaket har følgende konklusjoner for tidlig opptak:
        | konklusjon                                       | deltar i tidligopptaket |
        | KFF – Kan få tidlig opptak, har godkjent grunn   | ja                      |
        | KIF – Kan ikke få tidlig opptak, mangler grunn   | nei                     |
      Når saksbehandler skal konkludere
      Så kan saksbehandler velge blant konklusjonene til opptaket, og ingen andre

    Scenariomal: Konkludere om søkeren deltar i tidligopptaket
      Når saksbehandler konkluderer med "<konklusjon>"
      Så er det lagret at søkeren <deltar> i tidligopptaket

      Eksempler:
        | konklusjon                                     | deltar      |
        | KFF – Kan få tidlig opptak, har godkjent grunn | deltar      |
        | KIF – Kan ikke få tidlig opptak, mangler grunn | ikke deltar |

    Scenario: Konkludere før dokumentasjonsfristen har gått ut
      Gitt dokumentasjonsfristen for tidlig opptak er "2027-03-01 23:59"
      Og søkeren har lastet opp dokumentasjon "2027-02-10"
      Når saksbehandler vurderer søknaden "2027-02-12"
      Så kan saksbehandler konkludere om søkeren deltar i tidligopptaket

    # Har søkeren ikke søkt om tidlig opptak, er hele steget for tidlig opptak
    # skjult i saksbehandlingen (avklart 09.10.2026, review av PR #654).
    Scenario: Søknad uten ønske om tidlig opptak viser ikke tidlig opptak
      Gitt saksbehandler er inne på en annen søknad der søkeren ikke har søkt om tidlig opptak
      Når saksbehandler ser på søknaden
      Så ser ikke saksbehandler tidlig opptak i saken

    Scenario: Konkludere før kvalifiseringen er vurdert
      Gitt kvalifiseringen til "Sykepleie, høst 2027" er ikke vurdert i søknadsbehandlingen
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

  Regel: Konklusjonen kan endres også etter at tidligopptaket er gjennomført

    Scenario: Endre konklusjon før tidligopptaket er gjennomført
      Gitt saksbehandler har konkludert med at søkeren deltar i tidligopptaket
      Og tidligopptaket er ikke gjennomført
      Når saksbehandler konkluderer med at søkeren ikke deltar i tidligopptaket
      Så er det lagret at søkeren ikke deltar i tidligopptaket

    Scenario: Endre konklusjonen etter at tidligopptaket er gjennomført
      Gitt søkeren fikk tilbudsgaranti på "Sykepleie, høst 2027" da tidligopptaket ble gjennomført
      Og svaret på tidlig opptak er publisert
      Når saksbehandler konkluderer med at søkeren ikke deltar i tidligopptaket
      Så er det lagret at søkeren ikke deltar i tidligopptaket
      Og søkeren har fortsatt tilbudsgaranti på "Sykepleie, høst 2027"
      Og svaret søkeren har fått på tidlig opptak, er ikke endret
