# language: no

@ORG-ADM-FUS-001 @must
Egenskap: Fusjonere organisasjoner
  Som en systemadministrator
  ønsker jeg å registrere at to eller flere institusjoner fusjonerer
  slik at det historiske forholdet mellom institusjoner bevares og den nye institusjonen er korrekt registrert.

  # ÅPNE SPØRSMÅL:
  # - Hva skjer med studenter, ansatte og studieprogram knyttet til de fusjonerte institusjonene?
  # - Skal fusjonering varsle andre systemer som bruker organisasjonsdata?
  # - Trenger fusjonering en godkjenningsprosess, eller kan det utføres direkte?
  # - Norsk fusjonering: Hentes data til ny institusjon fra Brønnøysundregistrene (org.nr.), eller registreres manuelt?

  Regel: Norsk fusjonering oppretter en ny institusjon

    @must @planned
    Scenario: To norske utdanningsinstitusjoner fusjonerer til én ny
      Gitt at to norske utdanningsinstitusjoner fusjonerer
      Når jeg registrerer fusjoneringen
      Så skal det opprettes en ny organisasjon for den fusjonerte institusjonen
      Og de to gamle institusjonene skal markeres som inaktive
      Og den nye institusjonen skal ha en referanse til de to institusjonene den oppstod fra

  Regel: Navnehistorikken fra fusjonerte institusjoner arves av den nye

    @must @planned
    Scenario: Navnehistorikk fra begge institusjonene videreføres ved fusjonering
      Gitt at to organisasjoner fusjonerer til en ny organisasjon
      Når den nye organisasjonen opprettes
      Så skal navnehistorikken fra begge de fusjonerte organisasjonene vises i den nye organisasjonens historikk

  Regel: Utenlandsk fusjonering behandles annerledes enn norsk

    @should @planned
    Scenario: To utenlandske institusjoner fusjonerer — én videreføres
      Gitt at to utenlandske institusjoner fusjonerer
      Når jeg registrerer fusjoneringen
      Så skal én av institusjonene beholdes som gjeldende organisasjon
      Og den andre skal markeres som inaktiv
      Og den inaktiverte skal knyttes til den beholdte som sin etterfølger

    @should @planned
    Scenario: Norsk og utenlandsk institusjon fusjonerer
      Gitt at en norsk og en utenlandsk institusjon fusjonerer
      Når jeg registrerer fusjoneringen
      Så skal systemet gi veiledning om hvilke regler som gjelder for denne kombinasjonen