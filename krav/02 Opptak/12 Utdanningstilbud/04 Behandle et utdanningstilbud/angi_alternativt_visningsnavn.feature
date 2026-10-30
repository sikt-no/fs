# language: no
# Jira: SHI-780
@OPT-OPT-UTD-033 @must @draft @scope-utdanningstilbud-2027
Egenskap: Angi alternativt visningsnavn til Min kompetanse
  Som opptaksforvalter
  ønsker jeg å angi et alternativt navn på utdanningstilbudet på flere språk
  slik at søkeren ser utdanningstilbudet i Min kompetanse med navnet som passer opptaket.

  # ÅPNE SPØRSMÅL:
  # - Hvor i Min kompetanse brukes det alternative visningsnavnet: i søket etter studier, i studiekurven, i søknaden, i tilbudet, eller alle steder?

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Alternativt visningsnavn kan angis per språk

    Scenariomal: Angi alternativt visningsnavn på <språk>
      Når opptaksforvalter angir et alternativt visningsnavn på <språk>
      Så lagres det alternative visningsnavnet på <språk> for utdanningstilbudet

      Eksempler:
        | språk      |
        | bokmål     |
        | nynorsk    |
        | engelsk    |
        | nordsamisk |

  Regel: Utdanningstilbudet viser både navnet fra utdanningsregisteret og det alternative visningsnavnet

    Scenario: Se navnet fra utdanningsregisteret og det alternative visningsnavnet
      Gitt at utdanningstilbudet har navnet "Bachelor i sykepleie" fra utdanningsregisteret
      Og at utdanningstilbudet har det alternative visningsnavnet "Sykepleie, deltid Gjøvik"
      Så ser opptaksforvalter navnet "Bachelor i sykepleie" fra utdanningsregisteret på utdanningstilbudet
      Og opptaksforvalter ser det alternative visningsnavnet "Sykepleie, deltid Gjøvik" på utdanningstilbudet

    Scenario: Bare det alternative visningsnavnet kan endres
      Når opptaksforvalter redigerer utdanningstilbudet
      Så kan opptaksforvalter endre det alternative visningsnavnet
      Men opptaksforvalter kan ikke endre navnet fra utdanningsregisteret

  @depends-on-OPT-OVO-FRI-001 @depends-on-OPT-OPT-UTD-002
  Regel: Deltakende organisasjoner kan endre det alternative visningsnavnet bare i perioden opptaket er åpent for redigering
    # Når redigering av utdanningstilbud åpner og stenger, settes i fristene for opptaket.
    # Bygger på «Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering» i OPT-OPT-UTD-002.

    Scenario: Kan ikke endre det alternative visningsnavnet før redigering åpner
      Gitt at redigering av utdanningstilbud i opptaket åpner "2026-10-01"
      Og at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter vil endre det alternative visningsnavnet "2026-09-30"
      Så kan opptaksforvalter ikke endre det alternative visningsnavnet

    Scenario: Kan endre det alternative visningsnavnet i perioden opptaket er åpent for redigering
      Gitt at redigering av utdanningstilbud i opptaket åpner "2026-10-01" og stenger "2027-06-06"
      Og at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter endrer det alternative visningsnavnet "2026-10-15"
      Så er det alternative visningsnavnet lagret

    Scenario: Kan ikke endre det alternative visningsnavnet etter at redigering stenger
      Gitt at redigering av utdanningstilbud i opptaket stenger "2027-06-06"
      Og at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter vil endre det alternative visningsnavnet "2027-06-07"
      Så kan opptaksforvalter ikke endre det alternative visningsnavnet

    Scenario: Opptaksforvalter ved forvaltende organisasjon kan endre det alternative visningsnavnet etter at redigering stenger
      Gitt at redigering av utdanningstilbud i opptaket stengte "2027-06-06"
      Og at opptaksforvalter er ved forvaltende organisasjon
      Når opptaksforvalter endrer det alternative visningsnavnet "2027-06-10"
      Så er det alternative visningsnavnet lagret

  Regel: Søkeren ser det alternative visningsnavnet i Min kompetanse, og ellers navnet fra utdanningsregisteret

    Scenariomal: Søkeren ser det alternative visningsnavnet på <språk>
      Gitt at utdanningstilbudet har det alternative visningsnavnet "<alternativt navn>" på <språk>
      Når søkeren ser utdanningstilbudet i Min kompetanse på <språk>
      Så vises utdanningstilbudet med navnet "<alternativt navn>"

      Eksempler:
        | språk      | alternativt navn                 |
        | bokmål     | Sykepleie, deltid Gjøvik         |
        | nynorsk    | Sjukepleie, deltid Gjøvik        |
        | engelsk    | Nursing, part-time Gjøvik        |
        | nordsamisk | Buohccidivššár, oasseáigi Gjøvik |

    Scenario: Søkeren ser navnet fra utdanningsregisteret når det alternative visningsnavnet ikke er angitt
      Gitt at utdanningstilbudet ikke har noe alternativt visningsnavn
      Og at utdanningstilbudet har navnet "Bachelor i sykepleie" fra utdanningsregisteret
      Når søkeren ser utdanningstilbudet i Min kompetanse på bokmål
      Så vises utdanningstilbudet med navnet "Bachelor i sykepleie"

    Scenario: Søkeren ser navnet fra utdanningsregisteret når det alternative visningsnavnet mangler på språket søkeren bruker
      Gitt at utdanningstilbudet har det alternative visningsnavnet "Sykepleie, deltid Gjøvik" på bokmål
      Og at utdanningstilbudet ikke har noe alternativt visningsnavn på engelsk
      Og at utdanningstilbudet har navnet "Bachelor in Nursing" på engelsk fra utdanningsregisteret
      Når søkeren ser utdanningstilbudet i Min kompetanse på engelsk
      Så vises utdanningstilbudet med navnet "Bachelor in Nursing"
