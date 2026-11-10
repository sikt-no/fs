# language: no
# Kilde: Slack-samtale med fagansvarlige 10.11.2026. Gjenbruken av tilleggspoeng var ikke nevnt i
# leveranseplanen, og kan tas i en senere leveranse.
@OPT-BEH-BEH-042 @should @draft @ref-OPT-BEH-BEH-028
Egenskap: Gjenbruke tilleggspoeng fra tidligere opptak
  Som saksbehandler
  ønsker jeg at søkeren får tilleggspoengene fra et tidligere opptak uten å dokumentere dem på nytt
  slik at søkeren rangeres riktig, og jeg ikke trenger å behandle den samme dokumentasjonen hvert år.

  Søkere som har dokumentert 2 tilleggspoeng for høyere utdanning, fagskole, folkehøyskole eller
  militærtjeneste eller siviltjeneste i ett opptak, beholder de 2 tilleggspoengene i senere opptak
  til universiteter og høyskoler. Poengene gjenbrukes for siste gang i 2027.

  Fra 2028 gjenbrukes bare tilleggspoengene for militærtjeneste eller siviltjeneste, og da som
  1 poeng. De andre tilleggspoengene gjenbrukes ikke lenger.

  # ÅPNE SPØRSMÅL:
  # - Hvor kommer tilleggspoengene fra tidligere opptak fra? Importeres de fra det gamle
  #   opptakssystemet til gjenbrukstabeller før opptaket, som GSK-konklusjonene
  #   (OPT-BEH-BEH-015, STEK-442)?
  # - Gjelder gjenbruken bare samordna opptak, eller også lokale opptak?
  # - Hvordan henger gjenbruken sammen med poengene for høyere utdanning som regnes ut fra
  #   studiepoengene (OPT-BEH-BEH-028)? Hva får søkeren som har 2 gjenbrukte poeng og 1 poeng
  #   regnet ut fra studiepoengene?
  # - Hva skjer med søkeren som har fått poeng for militærtjeneste eller siviltjeneste etter
  #   2027: dokumenteres den nye tjenesten som før, og gir den 1 poeng?
  # - Kan saksbehandleren overstyre et gjenbrukt tilleggspoeng, og ser saksbehandleren at
  #   poenget er gjenbrukt, og fra hvilket opptak?
  # - Hva skal gjenbrukes når søkeren har hatt tilleggspoeng av flere typer i tidligere opptak?
  # - Hvilken prioritet har kravet?

  Regel: Til og med 2027 gjenbrukes 2 tilleggspoeng fra et tidligere opptak

    Scenariomal: Tilleggspoeng for <grunn> gjenbrukes i 2027
      Gitt at søkeren fikk 2 tilleggspoeng for <grunn> i et tidligere opptak
      Når søknaden til opptaket i 2027 behandles
      Så har saken 2 tilleggspoeng for <grunn>

      Eksempler:
        | grunn                               |
        | høyere utdanning                    |
        | fagskole                            |
        | folkehøyskole                       |
        | militærtjeneste eller siviltjeneste |

  @openquestion
  Regel: Fra 2028 gjenbrukes tilleggspoeng for militærtjeneste eller siviltjeneste som 1 poeng
    # ÅPNE SPØRSMÅL:
    # - Gjelder 1 poeng også for søkere som fikk tilleggspoeng for militærtjeneste eller
    #   siviltjeneste før 2027, eller bare for poeng som er gjenbrukt i 2027?

    Scenario: Tilleggspoeng for militærtjeneste eller siviltjeneste gjenbrukes som 1 poeng
      Gitt at søkeren fikk 2 tilleggspoeng for militærtjeneste eller siviltjeneste i et tidligere opptak
      Når søknaden til opptaket i 2028 behandles
      Så har saken 1 tilleggspoeng for militærtjeneste eller siviltjeneste

    Scenario: Tilleggspoenget for militærtjeneste eller siviltjeneste gjenbrukes år etter år
      Gitt at søkeren fikk 1 tilleggspoeng for militærtjeneste eller siviltjeneste i opptaket i 2028
      Når søknaden til opptaket i 2029 behandles
      Så har saken 1 tilleggspoeng for militærtjeneste eller siviltjeneste

  Regel: Fra 2028 gjenbrukes ikke de andre tilleggspoengene

    Scenariomal: Tilleggspoeng for <grunn> gjenbrukes ikke i 2028
      Gitt at søkeren fikk 2 tilleggspoeng for <grunn> i et tidligere opptak
      Når søknaden til opptaket i 2028 behandles
      Så har saken ingen gjenbrukte tilleggspoeng for <grunn>

      Eksempler:
        | grunn            |
        | høyere utdanning |
        | fagskole         |
        | folkehøyskole    |
