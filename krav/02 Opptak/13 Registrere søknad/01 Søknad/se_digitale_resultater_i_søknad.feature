# language: no
# GitHub: #604
#
# STATUS 22.09.2026: utkastet fra 18.09 er omarbeidet. Beslutningene under er
# tatt og skal ikke gjenåpnes uten grunn — det som gjenstår står som ÅPNE
# SPØRSMÅL nederst. Alle avklaringer er lukket, og kravet er satt @planned.
#
# Avklart 18.09.2026:
# - Aktør er søkeren selv i personflaten, ikke saksbehandler. Saksbehandlerens
#   tilsvarende behov ligger som et skisse-scenario i behandle_søknad.feature
#   (@OPT-BEH-BEH-001) og er ikke rørt her.
# - Kravet plasseres under 12 Registrere søknad, ikke under 04 Kompetanse,
#   fordi det beskriver hva søkeren ser i søknadskonteksten. Innholdet i selve
#   resultatvisningen eies av @KOM-RES-RES-001.
# - Den rikere varianten — oppsummering inne i søknaden — er tatt med som en
#   @could-regel så ambisjonen er dokumentert uten å binde leveransen.
#   MERK: utkastet forutsatte at første leveranse er en lenke ut til
#   resultatvisningen. Det er IKKE besluttet — se åpent spørsmål nederst.
#
# Avklart 22.09.2026:
# - Resultatene deles ikke opp etter kilde. Videregående skole og høyere
#   utdanning kommer fra samme endepunkt, og de ekte kildene er mange. Hvor
#   resultatene stammer fra er håndtert i arkitekturen og er ikke dette
#   kravets sak. All ordbruk om «kilder» er derfor fjernet.
# - Kravet beskriver resultatene samlet, uten oppdeling per type. Dette
#   erstatter beslutningen fra 18.09 om finkornet melding per resultattype.
# - Ingen filtrering og ingen utelatelser. Søkeren ser alt systemet har
#   registrert om hen — ikke bare det som er relevant for dette opptaket, og
#   ikke en utvalgt delmengde. Avgrensningen i utkastet fra 18.09 («kun
#   videregående skole og høyere utdanning; ikke fagskole, godkjenning av
#   utenlandsk utdanning eller språkprøver») utgår derfor: å utelate deler av
#   det systemet allerede vet er mer arbeid enn å vise alt.
# - Snittet mot @OPT-SØK-SØK-003 (veilede_om_dokumentasjon.feature, #572):
#   #572 dekker hva søkeren må laste opp, dette kravet hva søkeren slipper.
#   Personopplysninger fra folkeregisteret hører til #572 og er ikke med her.
# - Søknaden ligger som kladd inntil den sendes inn, og kladden bevares når
#   søkeren navigerer til resultatvisningen. Søkeren skal ikke måtte lagre
#   først, og skal ikke varsles om at noe kan gå tapt. Kladd-funksjonaliteten
#   finnes allerede i løsningen.
#
@OPT-SØK-SØK-004 @must @planned
Egenskap: Se digitale resultater i søknaden
  Som søker
  ønsker jeg å se hvilke digitale resultater systemet allerede har om meg
  slik at jeg vet hva jeg ikke trenger å dokumentere med manuell opplasting.

  Resultatene systemet allerede har, er hentet fra autoritative kilder og skal
  ikke lastes opp på nytt.

  AVHENGIGHET (betinget, se åpent spørsmål nederst): Hvis søkeren må navigere
  ut, sender kravet søkeren videre til visningen av egne resultater
  i @KOM-RES-RES-001, se_egne_resultater.feature under
  04 Kompetanse/10 Resultater/01 Resultater. Den er i dag en tre-linjers
  skisse, og må fylles ut under #559 før dette kravet kan leveres.

  Bakgrunn:
    Gitt jeg er innlogget på personflaten
    Og jeg har startet en søknad på et opptak

  Regel: Søker ser om systemet har digitale resultater

    Scenario: Systemet har registrerte resultater om søkeren
      Gitt jeg har registrerte resultater
      Når jeg kommer til dokumentasjonssteget i søknaden
      Så ser jeg at systemet har registrerte resultater om meg
      Og jeg blir ikke bedt om å laste dem opp

    Scenario: Systemet har ingen registrerte resultater om søkeren
      Gitt jeg har ingen registrerte resultater
      Når jeg kommer til dokumentasjonssteget i søknaden
      Så ser jeg at systemet ikke har registrerte resultater om meg
      Og jeg får vite at all dokumentasjon må lastes opp manuelt

  @openquestion
  Regel: Søker kommer til resultatvisningen for å se detaljene

    # ÅPNE SPØRSMÅL: Skal søkeren se detaljene om sine registrerte resultater
    # inne i søknaden, eller navigere ut til resultatvisningen i personflaten?
    # Hele denne regelen forutsetter det siste. Blir svaret «inne i søknaden»,
    # utgår regelen og erstattes av innhold i @could-regelen under.

    Scenario: Søker går fra søknaden til sine registrerte resultater
      Gitt jeg er i dokumentasjonssteget i søknaden
      Når jeg velger å se mine registrerte resultater
      Så kommer jeg til visningen av egne resultater i personflaten
      # Innholdet i resultatvisningen er beskrevet i @KOM-RES-RES-001

    Scenario: Søker kommer tilbake til kladden etter å ha sett resultatene
      Gitt jeg har lastet opp dokumentasjon i søknadskladden
      Og jeg har gått til visningen av egne resultater
      Når jeg går tilbake til kladden
      Så er opplysningene og dokumentene jeg har lagt inn fortsatt der

  @could
  Regel: Søker ser resultatene oppsummert i søknaden

    Scenario: Søker ser hvor mange resultater systemet har
      Gitt jeg har registrerte resultater
      Når jeg kommer til dokumentasjonssteget i søknaden
      Så ser jeg hvor mange registrerte resultater systemet har om meg

    Scenario: Søker utvider oppsummeringen for å se de enkelte resultatene
      Gitt jeg ser resultatene oppsummert i søknaden
      Når jeg utvider oppsummeringen
      Så ser jeg de enkelte resultatene

# ÅPNE SPØRSMÅL:
# - Får søkeren all informasjonen inne på siden, eller må hen navigere ut til
#   resultatvisningen for å se detaljene? Ikke besluttet. Valget avgjør om
#   @openquestion-regelen «Søker kommer til resultatvisningen» består, og om
#   avhengigheten til @KOM-RES-RES-001 / #559 i det hele tatt gjelder.
#   Avklares som en del av designarbeidet, ikke i kravteksten.
# - Ordlyd og utforming av meldingene er ikke beskrevet her. De hører hjemme i
#   se_digitale_resultater_i_søknad.design.md (skillen utdype-implementasjon).
