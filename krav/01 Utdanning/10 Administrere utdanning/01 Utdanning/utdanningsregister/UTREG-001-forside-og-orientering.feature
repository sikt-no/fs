# language: no
# ============================================================
# FEATURE 1 – FORSIDE OG ORIENTERING
# ============================================================

Egenskap: UTREG-001 Forside og orientering for offentlig visning
  Som en besøkende uten innlogging 
  ønsker jeg å få en introduksjon til utdanningsregisteret
  slik at jeg forstår hva registeret inneholder og hvordan jeg kan bruke det.

  Prioritet: Må ha

  Regel: Forsiden skal gi en kort introduksjon til utdanningsregisteret

    Scenario: Besøkende ser introduksjonstekst om utdanningsregisteret
      Gitt at jeg besøker den offentlige visningen
      Når forsiden lastes
      Så skal jeg se en introduksjonstekst som forklarer hva utdanningsregisteret er
      Og teksten skal være på norsk og forståelig uten teknisk forkunnskaper

    Scenario: Forsiden viser totalt antall registrerte utdanninger
      Gitt at jeg besøker forsiden
      Når forsiden lastes
      Så skal jeg se det totale antallet registrerte utdanninger hentet fra registeret
      Og antallet skal reflektere gjeldende tilstand på tvers av alle organisasjoner

  Regel: Forsiden skal gi tilgang til videre ressurser

    Scenario: Besøkende finner lenke til API-informasjon og åpne data
      Gitt at jeg er på forsiden
      Når jeg ser etter teknisk informasjon
      Så skal jeg se en tydelig lenke til API-dokumentasjon og åpne data på fs.sikt.no
      Og lenken skal åpnes i ny fane
      Og lenketeksten skal gjøre det klart at destinasjonen omhandler åpne data og API-tilgang

    Scenario: Besøkende finner lenke til FS Admin
      Gitt at jeg er på forsiden
      Når jeg ser etter lenke til administrasjonsgrensesnittet
      Så skal jeg se en tydelig lenke til FS Admin
      Og det skal fremgå av lenken at FS Admin krever innlogging
      Og lenken skal være synlig uten at jeg selv er innlogget