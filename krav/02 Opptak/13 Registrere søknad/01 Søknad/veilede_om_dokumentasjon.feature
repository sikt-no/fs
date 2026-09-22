# language: no
# GitHub: #572
@OPT-SØK-SØK-003 @must @planned
Egenskap: Veilede søker om hvilken dokumentasjon som skal lastes opp
  Som søker
  ønsker jeg å vite hvilken dokumentasjon søknaden min krever
  slik at jeg ikke sender inn opplysninger som ikke skal behandles.

  Bakgrunn:
    Gitt jeg er innlogget på personflaten
    Og jeg har startet en søknad på et opptak

  Regel: Søker får vite hvilken dokumentasjon søknaden krever

    @openquestion
    Scenario: Søker ser hvilken dokumentasjon som er etterspurt
      Når jeg skal laste opp dokumentasjon på søknaden
      Så ser jeg hvilken dokumentasjon som er etterspurt for denne søknaden
      # ÅPNE SPØRSMÅL:
      # - Hvor kommer listen over etterspurt dokumentasjon fra? Er den knyttet
      #   til opptaket, til utdanningstilbudet, eller til hva søkeren søker på
      #   grunnlag av (dispensasjon, tidlig opptak, realkompetanse)? Det finnes
      #   ingen krav som beskriver denne sammenhengen i dag.

    Scenario: Søker får vite at uetterspurt dokumentasjon kan bli slettet
      Når jeg skal laste opp dokumentasjon på søknaden
      Så får jeg vite at dokumentasjon som ikke er etterspurt kan bli slettet

  Regel: Søker velger dokumenttype ved opplasting

    Scenariomal: Søker angir hva dokumentet er
      Når jeg laster opp et dokument
      Og jeg angir at dokumentet er av typen <dokumenttype>
      Så er dokumentet registrert med typen <dokumenttype>

      Eksempler:
        | dokumenttype                    |
        | Vitnemål eller karakterutskrift |
        | Legeerklæring                   |
        | Politiattest                    |
        | Annen dokumentasjon             |

  Regel: Dokumentasjon som hentes fra autoritative kilder skal ikke lastes opp

    Scenario: Søker slipper å laste opp norsk vitnemål
      Gitt vitnemålet mitt er tilgjengelig fra Nasjonal vitnemålsdatabase
      Når jeg skal laste opp dokumentasjon på søknaden
      Så ser jeg at vitnemålet mitt allerede er hentet inn
      Og jeg blir ikke bedt om å laste det opp

    Scenario: Søker slipper å dokumentere personopplysninger
      Gitt personopplysningene mine er hentet fra folkeregisteret
      Når jeg fyller ut søknaden
      Så blir jeg ikke bedt om å dokumentere navn, fødselsnummer eller adresse

# ÅPNE SPØRSMÅL:
# - Ordlyden i veiledningen er ikke fastsatt her. Konkret tekst, plassering og
#   utforming hører i en <feature>.design.md ved siden av denne fila, jf.
#   utdype-implementasjon-skillen. Steffen Andre Marstein har en åpen oppgave
#   om UX for dokumentopplasting fra møtet 28.08.2026.
# - Løsningen begrenser ikke hva søkeren kan laste opp — det er en bevisst
#   beslutning. Juristens tiltak om å begrense dokumentkategorier er derfor
#   ikke dekket av dette kravet.
