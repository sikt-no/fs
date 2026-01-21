# language: no

@demo @should
Egenskap: Filtrere og søke i studiekatalogen
  Som en søker
  Ønsker jeg å kunne filtrere og søke etter studier i studiekatalogen
  Slik at jeg kan finne relevante studier å søke på

  Bakgrunn:
    Gitt at søkeren er inne på studiekatalogen
    Og at følgende studier finnes:
      | navn                        | studiested | studienivå | fagområde |
      | Bachelor i informatikk      | Oslo       | Bachelor   | IT        |
      | Master i datascience        | Bergen     | Master     | IT        |
      | Bachelor i økonomi          | Trondheim  | Bachelor   | Økonomi   |
      | Bachelor i sykepleie        | Oslo       | Bachelor   | Helse     |

  Regel: Søkeren skal kunne filtrere studier på ulike kriterier

    Scenario: Filtrere på studiested
      Når søkeren filtrerer på studiested "Oslo"
      Så skal listen vise 2 studier
      Og søkeren skal se "Bachelor i informatikk"
      Og søkeren skal se "Bachelor i sykepleie"

    Scenario: Filtrere på studienivå
      Når søkeren filtrerer på studienivå "Master"
      Så skal listen vise 1 studie
      Og søkeren skal se "Master i datascience"

    Scenario: Filtrere på fagområde
      Når søkeren filtrerer på fagområde "IT"
      Så skal listen vise 2 studier
      Og søkeren skal se "Bachelor i informatikk"
      Og søkeren skal se "Master i datascience"

  Regel: Søkeren skal kunne kombinere flere filtre

    Scenario: Kombinere studiested og studienivå
      Når søkeren filtrerer på studiested "Oslo"
      Og søkeren filtrerer på studienivå "Bachelor"
      Så skal listen vise 2 studier
      Og søkeren skal se "Bachelor i informatikk"
      Og søkeren skal se "Bachelor i sykepleie"

  Regel: Søkeren skal se antall treff

    Scenario: Antall treff vises ved filtrering
      Når søkeren filtrerer på fagområde "IT"
      Så skal søkeren se teksten "2 studier funnet"

  Regel: Søkeren skal få beskjed når ingen studier matcher

    Scenario: Ingen studier matcher filteret
      Når søkeren filtrerer på studiested "Tromsø"
      Så skal listen vise 0 studier
      Og søkeren skal se meldingen "Ingen studier funnet"

  Regel: Søkeren skal kunne søke med fritekst

    Scenario: Fritekst-søk på studienavn
      Når søkeren søker på "informatikk"
      Så skal listen vise 1 studie
      Og søkeren skal se "Bachelor i informatikk"

    Scenario: Fritekst-søk kombinert med filter
      Når søkeren søker på "Bachelor"
      Og søkeren filtrerer på fagområde "IT"
      Så skal listen vise 1 studie
      Og søkeren skal se "Bachelor i informatikk"
