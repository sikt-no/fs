# language: no
# GitHub: #456, #525
#
# KILDER
#
# Delleveranse 2 av initiativet #456 Behandle søknader om tidlig opptak.
# Jira STEK-267 «Søker må kunne uttrykke ønske om å delta i tidlig opptak» og
# TOT-2296 «Min kompetanse: Tidlig opptak». Designskisse i Figma
# «Min Kompetanse 2026», node 2769-1614 (lenken står i STEK-267).
#
# Featuren slutter når søkeren har søkt om tidlig opptak. Vurderingen står i
# vurdere_søknad_om_tidlig_opptak.feature (OPT-BEH-BEH-008), tilbudsgarantien i
# gi_tilbudsgaranti_ved_tidlig_opptak.feature (OPT-BEH-BEH-007), og svaret i
# se_svar_på_tidlig_opptak.feature (OPT-SØK-SØK-012).
#
# Hva søkeren må dokumentere, og hvordan dokumentasjonen lastes opp, står i
# veilede_om_dokumentasjon.feature. Søknadsfristen for tidlig opptak settes i
# frister_og_hendelser.feature.
#
# AVKLART I JIRA OG KODEN (07.10.2026)
#
# - Søkeren ber om tidlig opptak én gang for hele søknaden, ikke per
#   søknadsalternativ (STEK-188).
# - Søkeren velger én begrunnelse fra listen opptaket har satt opp. Bare aktive
#   begrunnelser kan velges. Hver begrunnelse har et navn, en forklaring og en
#   tekst om hva søkeren må dokumentere (STEK-267).
# - Tidlig opptak kan bare søkes når opptaket tilbyr tidlig opptak, eller når
#   minst ett av søknadsalternativene tilbyr tidlig opptak.
# - (Endret 09.10.2026, se under.) Søkeren kan bytte begrunnelse fram til
#   søknadsfristen for tidlig opptak.
# - Søkeren får kvittering når begrunnelsen settes eller byttes (TOT-2384).
# - Ønsket om tidlig opptak blir stående når søknaden endres, eller når hele søknaden trekkes.
#
# AVKLART 08.10.2026
#
# - (Endret 09.10.2026, se under.) Søkeren kan trekke ønsket om tidlig opptak
#   fram til søknadsfristen for tidlig opptak, men ikke etter. Koden har i dag
#   ingen måte å gjøre det på (sokTidligOpptak krever en begrunnelse), og må endres.
# - Søkeren ser når søknaden om tidlig opptak sist ble endret. Ønske fra Min
#   kompetanse i STEK-267. Koden lagrer ikke tidspunktet i dag, og må endres.
#   (Endret 09.10.2026: søkeren ser når hen søkte, siden bytte ikke er et krav.)
# - Opptak som ikke krever begrunnelse, f.eks. lokale opptak ved OsloMet, legger
#   inn en begrunnelse «Ingen begrunnelse» uten dokumentasjonskrav. Det trengs
#   ingen egen funksjonalitet for det.
# - (Endret 09.10.2026, se under.) Søkeren ser en lenke til lærestedets egen
#   side om tidlig opptak («Les mer») per søknadsalternativ. Lenken settes per
#   utdanningstilbud, se opptaksinnstillinger_utdanningstilbud.feature. Ønske fra
#   Min kompetanse i STEK-267. Koden har ikke noe felt for lenken i dag, og må endres.
#
# AVKLART 09.10.2026 (review av PR #654)
#
# - Søkeren kan ikke trekke ønsket om tidlig opptak i første versjon. Søknaden
#   om tidlig opptak er «fire and forget», avklart med fagperson, og skissene
#   viser det ikke. Søkeren kan fortsatt trekke hele søknaden
#   (trekke_søknad.feature). Regelen «Søkeren kan trekke ønsket om tidlig opptak
#   innen fristen» er fjernet.
# - Lenken til informasjon om tidlig opptak («Les mer») hører til opptaket, og
#   settes av opptakseieren, ikke per utdanningstilbud. Søkeren ser én lenke for
#   opptaket. Ønsket i STEK-267 gjelder «opptaket/institusjonen sin egen
#   info-side», f.eks. samordnaopptak.no. Lenken settes i
#   11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature.
# - Å bytte begrunnelse er ikke et krav i første versjon, siden skissene ikke
#   viser det. Koden tillater det i dag (sokTidligOpptak skriver over
#   begrunnelsen, og sender ny kvittering når den er endret), og det kan bli
#   stående. Scenarioet «Bytte begrunnelse før fristen» er fjernet.
# - Scenarioet om begrunnelsen «Ingen begrunnelse» er fjernet. Det er
#   konfigurasjon av opptaket, ikke en egen funksjon (se avklaringen fra 08.10).
# - Søkeren ser begrunnelsene med hva som må dokumenteres for hver av dem, og
#   velger én. Kravet sier ikke i hvilken rekkefølge, eller når
#   dokumentasjonskravet vises (avklart med Daniel). Scenarioet «Se hva som må
#   dokumenteres for begrunnelsen» er slått sammen med «Se begrunnelsene søkeren
#   kan velge».
# - Fjerner søkeren alle søknadsalternativene som tilbyr tidlig opptak etter å ha
#   søkt, blir ønsket om tidlig opptak stående. Det får så være: søkeren kan ikke
#   få tilbudsgaranti fra tidligopptaket, og svaret viser at søknadsalternativene
#   ikke tilbyr tidlig opptak (se_svar_på_tidlig_opptak.feature). Det er ingen
#   egen regel for det.
#
@OPT-SØK-SØK-011 @must @in-progress
Egenskap: Søke om tidlig opptak
  Som søker
  ønsker jeg å søke om tidlig opptak med en begrunnelse
  slik at jeg kan få tidlig svar på om jeg er sikret plass på studiet jeg ønsker meg mest.

  # Begrunnelsene søkeren kan velge, legges inn i databasen per opptak, og
  # vedlikeholdes ikke i løsningen nå (avklart 08.10.2026, se
  # gi_tilbudsgaranti_ved_tidlig_opptak.feature).

  Bakgrunn:
    Gitt søkeren er innlogget
    Og søkeren har en søknad til opptaket "Samordna opptak 2027"

  Regel: Søkeren ber om tidlig opptak etter at søknaden er sendt
    # Bevisst produktvalg: litt friksjon, så ikke alle krysser av for tidlig opptak
    # uten å trenge det. Fra skissen i Min kompetanse (avklart 08.10.2026).

    Scenario: Søke om tidlig opptak fra søknadsdetaljene
      Gitt "Sykepleie, høst 2027" tilbyr tidlig opptak
      Og søkeren har sendt søknaden med søknadsalternativet "Sykepleie, høst 2027"
      Når søkeren ser på søknadsdetaljene
      Så ser søkeren muligheten til å søke om tidlig opptak

    Scenario: Kan ikke søke om tidlig opptak før søknaden er sendt
      Gitt "Sykepleie, høst 2027" tilbyr tidlig opptak
      Og søkeren har ikke sendt søknaden
      Når søkeren fyller ut søknaden
      Så ser ikke søkeren muligheten til å søke om tidlig opptak

  Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det

    Scenario: Søke om tidlig opptak med en begrunnelse
      Gitt "Sykepleie, høst 2027" tilbyr tidlig opptak
      Og søknaden har søknadsalternativet "Sykepleie, høst 2027"
      Når søkeren søker om tidlig opptak med begrunnelsen "Fullført videregående opplæring"
      Så har søkeren søkt om tidlig opptak med begrunnelsen "Fullført videregående opplæring"
      Og søkeren får kvittering for søknaden om tidlig opptak

    Scenario: Se hvilke søknadsalternativer som tilbyr tidlig opptak
      Gitt søknaden har følgende søknadsalternativer:
        | søknadsalternativ    | tilbyr tidlig opptak |
        | Sykepleie, høst 2027 | ja                   |
        | Historie, høst 2027  | nei                  |
      Når søkeren ser på søknaden
      Så ser søkeren at "Sykepleie, høst 2027" tilbyr tidlig opptak
      Og søkeren ser at "Historie, høst 2027" ikke tilbyr tidlig opptak

    Scenario: Se informasjon om tidlig opptak i opptaket
      Gitt opptaket har lenken "https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html" til informasjon om tidlig opptak
      Når søkeren ser på søknaden
      Så ser søkeren lenken til informasjon om tidlig opptak

    Scenario: Kan ikke søke om tidlig opptak når ingen søknadsalternativer tilbyr det
      Gitt opptaket "Samordna opptak 2027" tilbyr ikke tidlig opptak
      Og ingen av søknadsalternativene tilbyr tidlig opptak
      Når søkeren ser på søknaden
      Så ser ikke søkeren muligheten til å søke om tidlig opptak

  Regel: Søkeren velger én begrunnelse fra opptakets liste

    Scenario: Se begrunnelsene søkeren kan velge
      Gitt opptaket "Samordna opptak 2027" har følgende begrunnelser for tidlig opptak:
        | begrunnelse                         | aktiv |
        | Fullført videregående opplæring     | ja    |
        | Fullført fagskole                   | ja    |
        | Gammel begrunnelse                  | nei   |
      Når søkeren skal søke om tidlig opptak
      Så kan søkeren velge mellom "Fullført videregående opplæring" og "Fullført fagskole"
      Og søkeren ser hva som må dokumenteres for hver av begrunnelsene
      Og søkeren kan ikke velge "Gammel begrunnelse"

    Scenario: Se når søkeren søkte om tidlig opptak
      Gitt søkeren søkte om tidlig opptak med begrunnelsen "Fullført fagskole" "2027-01-15"
      Når søkeren ser på søknaden
      Så ser søkeren at søknaden om tidlig opptak ble sendt "2027-01-15"

  Regel: Tidlig opptak kan bare søkes innen søknadsfristen for tidlig opptak

    Scenario: Kan ikke søke om tidlig opptak etter fristen
      Gitt søknadsfristen for tidlig opptak er "2027-03-01 23:59"
      Når søkeren prøver å søke om tidlig opptak "2027-03-02"
      Så har ikke søkeren søkt om tidlig opptak
      Og søkeren ser at fristen for å søke om tidlig opptak er ute

  Regel: Søknaden om tidlig opptak gjelder hele søknaden

    Scenario: Søknaden om tidlig opptak blir stående når søknadsalternativene endres
      Gitt søkeren har søkt om tidlig opptak med begrunnelsen "Fullført videregående opplæring"
      Når søkeren legger til søknadsalternativet "Vernepleie, høst 2027"
      Så har søkeren fortsatt søkt om tidlig opptak med begrunnelsen "Fullført videregående opplæring"
