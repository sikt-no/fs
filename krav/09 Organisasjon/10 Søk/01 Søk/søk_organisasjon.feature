# language: no

@ORG-SØK-SØK-001 @must
Egenskap: Søk organisasjon
  Som en studieadministrator
  ønsker jeg å søke etter en organisasjon
  slik at jeg raskt finner den organisasjonen jeg trenger eller finner ut at jeg må opprette en ny organisasjon.

  Bakgrunn:
    Gitt at jeg er på organisasjonssøket

  Regel: Søk på unik identifikator gir direktetreff

    Scenariomal: Søk på identifikator viser organisasjonen direkte
      Når jeg søker på "<søkeverdi>"
      Så skal jeg se organisasjonsprofilen til "Universitetet i Oslo"

      Eksempler:
        | søkeverdi | identifikator        |
        | 1234      | institusjonsnummer   |
        | 971035854 | organisasjonsnummer  |
        | N OSLO01  | Erasmuskode          |
        | 999885022 | PIC-nummer           |

  Regel: Søk på navn eller akronym gir liste med treff

    Scenariomal: Søk på navn eller del av navn gir liste
      Når jeg søker på "<søkeverdi>"
      Så skal jeg se en liste med organisasjoner der navn inneholder "<søkeverdi>"

      Eksempler:
        | søkeverdi            |
        | Universitetet i Oslo |
        | UiO                  |
        | univer               |

    Scenario: Søk på navn finner også treff i navnehistorikken
      Gitt at organisasjonen "Norges idrettshøgskole" tidligere het "Statens idrettshøgskole"
      Når jeg søker på "Statens idrettshøgskole"
      Så skal jeg se "Norges idrettshøgskole" i resultatlisten
      Og det skal fremgå at treffet er basert på et historisk navn

  Regel: Fritekstsøk på tvers av felter

    Scenario: Søk på en verdi gir treff i navn og URL
      Når jeg søker på "oslo"
      Så skal jeg se organisasjoner der "oslo" finnes i navn eller URL

  Regel: Søk på flere ord krever treff på alle ord

    Scenario: Søk på to ord gir kun treff der begge ord finnes
      Når jeg søker på "Kyiv teknologi"
      Så skal jeg kun se organisasjoner der både "Kyiv" og "teknologi" finnes i søkbare felter

  Regel: Søk kan ekskludere verdier

    Scenario: Minustegn foran et ord ekskluderer det fra treff
      Når jeg søker på "teknologi -computer"
      Så skal jeg se organisasjoner med "teknologi" som ikke har "computer" i søkbare felter

  Regel: Søk tolererer skrivefeil

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
      Så skal hvert resultat vise institusjonsnummer, navn, akronym, organisasjonstype og Erasmuskode

    Scenario: Organisasjonstype er hentet fra Brønnøysundregistrene
      Gitt at organisasjonen er norsk og registrert i Brønnøysundregistrene
      Når jeg ser søkeresultatet
      Så skal organisasjonstypen vises slik den er registrert i Brønnøysundregistrene

# ÅPNE SPØRSMÅL:
# - Hvilke felter skal inngå i fritekstsøket — Navn, URL, andre?
# - Skal URL-søk støttes direkte eller kun som del av fritekst?
# - Hvilken rekkefølge skal treff sorteres i (relevans, navn, instnr)?