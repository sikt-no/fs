# language: no

@ORG-ADM-DUP-001 @must
Egenskap: Slå sammen duplikate organisasjoner
  Som en systemadministrator
  ønsker jeg å identifisere og slå sammen duplikate organisasjoner
  slik at registeret ikke inneholder redundante oppføringer.

  # ÅPNE SPØRSMÅL:
  # - Uavklart: Reglene rundt hva som skal slettes og hva som bare skal markeres som inaktivt
  # - Alternativ flyt: Ny organisasjon opprettes med felt fra begge duplikatene, begge duplikatene slettes
  # - Kan norske utdanningsinstitusjoner markeres som inaktive (men ikke slettes) ved sammenslåing?
  # - Hvem har tilgang til å slå sammen organisasjoner?
  # - Bakgrunn: HK-dir legger inn duplikater fordi de ikke får treff ved søk på fullt navn
  # - Bakgrunn: Duplikater kan oppdages ved manuell gjennomgang, det kan finnes mer enn to

  Regel: Navnehistorikk må sjekkes ved duplikatkontroll

    @must @planned
    Scenario: Navnehistorikk for begge kandidater vises under duplikatkontroll
      Gitt at jeg undersøker to organisasjoner som kan være duplikater
      Når jeg åpner duplikatkontrollen for disse to organisasjonene
      Så skal navnehistorikken for begge vises
      Og alle tidligere navn skal vises med gyldighetsdatoer

  Regel: To mulige duplikater kan sammenlignes side om side

    @must @planned
    Scenario: Sammenligne felter for to potensielle duplikater
      Gitt at jeg har funnet to organisasjoner som kan være duplikater
      Når jeg velger begge for sammenligning
      Så skal alle felter vises side om side
      Og felter med ulik verdi skal markeres tydelig

  Regel: Brukeren velger hvilke data som videreføres ved sammenslåing

    @must @planned
    Scenario: Velge verdi per felt der duplikatene har ulik informasjon
      Gitt at jeg sammenligner to duplikate organisasjoner
      Og de har ulike verdier i ett eller flere felter
      Når jeg gjennomfører sammenslåingen
      Så skal jeg for hvert felt med ulik verdi kunne velge hvilken verdi som skal videreføres

    @should @planned
    Scenario: Legge inn ny informasjon som ikke finnes i noen av duplikatene
      Gitt at jeg slår sammen to duplikate organisasjoner
      Og ingen av dem har fylt ut et valgfritt felt
      Når jeg gjennomfører sammenslåingen
      Så skal jeg kunne fylle inn ny informasjon i felter som mangler data i begge organisasjonene

  Regel: Én organisasjon beholdes, den andre deaktiveres eller slettes

    @must @planned
    Scenario: Velge hvilken organisasjon som er den som beholdes
      Gitt at jeg slår sammen to duplikate organisasjoner
      Når jeg gjennomfører sammenslåingen
      Så skal jeg velge hvilken av organisasjonene som beholdes som den gjeldende oppføringen

    @must @planned
    Scenario: Norsk utdanningsinstitusjon kan ikke slettes ved sammenslåing
      Gitt at én av duplikatene er en norsk utdanningsinstitusjon
      Når jeg slår dem sammen
      Så skal den norske utdanningsinstitusjonen alltid beholdes
      Og den andre organisasjonen skal kun kunne markeres som inaktiv, ikke slettes

  Regel: Sammenslåing logges

    @must @planned
    Scenario: Sammenslåing av duplikater registreres i loggen
      Gitt at jeg har gjennomført en sammenslåing av to duplikate organisasjoner
      Så skal det fremgå i systemet hvilke to organisasjoner som ble slått sammen
      Og tidspunktet og den ansvarlige brukeren skal registreres