# language: no
# GitHub: #1247
@OPT-SOK-VIS-001 @must @planned
Egenskap: Se status på egen søknad
  Som en søker
  ønsker jeg å se hvilken status søknaden min har
  slik at jeg vet om jeg må gjøre noe mer eller bare vente på svar.

  Bakgrunn:
    Gitt at søkeren er innlogget med ID-porten
    Og søkeren har levert minst én søknad i inneværende opptak

  Regel: Statusen vises med klar tekst og forklaring

    Scenario: Søkeren har levert en komplett søknad
      Gitt at søknaden er registrert med status "Mottatt"
      Når søkeren åpner søknadsoversikten
      Så vises statusen "Mottatt — venter på saksbehandling"
      Og søkeren ser dato for innsending

    Scenario: Søkeren mangler obligatoriske vedlegg
      Gitt at søknaden er registrert uten obligatorisk vitnemål
      Når søkeren åpner søknadsoversikten
      Så vises statusen "Mangler vedlegg — last opp dokumenter"
      Og søkeren får en knapp for å laste opp vedlegg

  Regel: Statusvisningen dekker alle kjente søknadstilstander

    Scenariomal: Status vises korrekt for hver søknadstilstand
      Gitt at søknaden har intern status <intern_status>
      Når søkeren åpner søknadsoversikten
      Så vises teksten "<visningstekst>" til søkeren
      Og handlingsknappen er <knapp_synlig>

      Eksempler:
        | intern_status   | visningstekst                          | knapp_synlig |
        | mottatt         | Mottatt — venter på saksbehandling     | skjult       |
        | mangler_vedlegg | Mangler vedlegg — last opp dokumenter  | synlig       |
        | under_vurdering | Under vurdering hos saksbehandler      | skjult       |
        | innvilget       | Innvilget — se tilbudsbrev             | synlig       |
        | avslått         | Avslått — se begrunnelse               | synlig       |

  Regel: Trukne søknader skjules fra hovedoversikten

    @openquestion
    Scenario: Søkeren har trukket en søknad
      # ÅPNE SPØRSMÅL:
      # - Skal trukne søknader være helt skjult, eller vises i en sammenfoldet "Tidligere søknader"-seksjon?
      Gitt at søkeren har én aktiv søknad og én trukket søknad
      Når søkeren åpner søknadsoversikten
      Så vises kun den aktive søknaden i hovedlisten

  @draft @openquestion
  Regel: Søkeren varsles når statusen endres
    # ÅPNE SPØRSMÅL:
    # - Skal varselet gå på e-post, SMS eller begge deler?
    # - Skal søkeren kunne reservere seg mot varsler?

    Scenario: Søkeren får varsel når søknaden er innvilget
      Gitt at søknaden har status "Under vurdering"
      Når søknaden får status "Innvilget"
      Så får søkeren et varsel om at statusen er endret

# ÅPNE SPØRSMÅL:
# - Hvilken tekst skal vises hvis søkeren har flere søknader med ulik status?
