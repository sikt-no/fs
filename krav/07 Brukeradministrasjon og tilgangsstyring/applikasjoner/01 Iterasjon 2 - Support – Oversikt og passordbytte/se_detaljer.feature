# language: no
# GitHub: #439
@BRU-APP-API-002 @must @implemented
Egenskap: Se detaljer for applikasjon
  Som bruker
  ønsker jeg å se detaljer for en applikasjon, organisert i logiske datagrupper,
  slik at jeg har oversikt over applikasjonen.

  # Krav fra Confluence: K3 Se detaljer for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: Detaljer organiseres i logiske datagrupper

    Scenario: Se felter som vises for alle applikasjoner
      Så ser jeg følgende informasjon:
        | felt                       |
        | Navn                       |
        | Beskrivelse                |
        | Identitetsleverandør       |
        | Applikasjonseier           |
        | Miljøer                    |
        | Status                     |
        | Opprettet av               |
        | Tidspunkt for opprettelse  |
        | Sist endret av             |
        | Tidspunkt for sist endring |

    @deprecated
    Scenario: Se ekstern ID fra identitetsleverandør
      Gitt applikasjonen har en ekstern ID fra identitetsleverandøren
      Så ser jeg den eksterne ID-en

    @in-progress
    Scenario: Se Tjeneste-ID for Feide-applikasjon
      Gitt applikasjonen har Feide som identitetsleverandør
      Så ser jeg applikasjonens Tjeneste-ID

    @in-progress
    Scenario: Se Client-ID for Maskinporten-applikasjon
      Gitt applikasjonen har Maskinporten som identitetsleverandør
      Så ser jeg applikasjonens Client-ID

    @in-progress
    Scenario: Se brukernavn for FS-applikasjon
      Gitt applikasjonen har FS som identitetsleverandør
      Så ser jeg applikasjonens brukernavn

    @deprecated
    Scenario: Se intern ID
      Så ser jeg applikasjonens interne ID

  Regel: Detaljer kan redigeres direkte fra detaljer-fanen

    Scenario: Aktivere redigering av detaljer
      Når jeg velger å redigere
      Så blir alle redigerbare felter i detaljer-fanen omgjort til inputfelter
