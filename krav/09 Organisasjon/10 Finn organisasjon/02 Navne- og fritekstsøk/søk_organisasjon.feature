# language: no

@ORG-SØK-SØK-001 @must
Egenskap: Søk etter organisasjon
  Som en studieadministrator som ikke har en presis identifikator
  ønsker jeg å søke med navn, akronym eller nøkkelord
  slik at jeg finner riktig organisasjon — eller oppdager at jeg må opprette en ny.

  Bakgrunn:
    Gitt at jeg er på organisasjonssøket

  Regel: Søk på navn eller akronym gir liste med treff

    Scenariomal: Søk på navn, del av navn eller akronym gir liste
      Når jeg søker på "<søkeverdi>"
      Så skal jeg se en liste med organisasjoner der navn eller akronym inneholder "<søkeverdi>"

      Eksempler:
        | søkeverdi             | type        |
        | Université Paris Cité | fullt navn  |
        | NMBU                  | akronym     |
        | univer                | del av navn |

  Regel: Søket finner også treff i navnehistorikken

    Scenario: Søk på historisk navn gir treff på nåværende organisasjon
      Gitt at organisasjonen "OsloMet" tidligere het "Høgskolen i Oslo og Akershus"
      Når jeg søker på "Høgskolen i Oslo og Akershus"
      Så skal jeg se "OsloMet" i resultatlisten
      Og det skal fremgå at treffet er basert på et historisk navn

  Regel: Fritekstsøk på tvers av felter

    Scenario: Søk på en verdi gir treff i navn og URL
      Når jeg søker på "oslo"
      Så skal jeg se organisasjoner der "oslo" finnes i navn eller URL

    Scenario: Søk på flere ord gir kun treff der alle ord finnes
      Når jeg søker på "Kyiv teknologi"
      Så skal jeg kun se organisasjoner der både "Kyiv" og "teknologi" finnes i søkbare felter

    Scenario: Minustegn foran et ord ekskluderer det fra treff
      Når jeg søker på "teknologi -computer"
      Så skal jeg se organisasjoner med "teknologi" som ikke har "computer" i søkbare felter

  Regel: Søket tolererer skrivefeil

    Scenario: Søk på feilstavet navn gir likevel treff
      Når jeg søker på "Univeristetet i Oslo"
      Så skal jeg se "Universitetet i Oslo" i resultatlisten

  Regel: Søk uten treff gir hjelp til å finne riktig

    Scenario: Forslag til alternative søk ved ingen treff
      Når jeg søker på en verdi som ikke gir treff
      Så skal jeg se meldingen "Ingen organisasjoner funnet"
      Og jeg skal få forslag til alternative søkeformuleringer

  Regel: Søkeresultatlisten viser nøkkelinformasjon

    Scenario: Søkeresultatlisten viser relevante felter
      Når jeg søker og får treff
      Så skal hvert resultat vise organisasjonskode, navn, akronym, organisasjonstype og Erasmuskode

    Scenario: Organisasjonstype er hentet fra Brønnøysundregistrene
      Gitt at organisasjonen er norsk og registrert i Brønnøysundregistrene
      Når jeg ser søkeresultatet
      Så skal organisasjonstypen vises slik den er registrert i Brønnøysundregistrene

# ÅPNE SPØRSMÅL:
# - Hvilke felter skal inngå i fritekstsøket — navn, URL, andre?
# - Skal URL-søk støttes direkte eller kun som del av fritekst?
# - I hvilken rekkefølge skal treff sorteres (relevans, navn, organisasjonskode)?