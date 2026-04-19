# language: no

@ORG-ADM-FUS-001 @must
Egenskap: Fusjonere organisasjoner
  Som en systemadministrator
  ønsker jeg å registrere at to eller flere organsisasjoner fusjonerer
  slik at det historiske forholdet mellom organisasjoner bevares og den nye organisasjonen er korrekt registrert.

  # ÅPNE SPØRSMÅL:
  # - Hva skjer med studenter, ansatte og studieprogram knyttet til de fusjonerte organisasjonene?
  # - Skal fusjonering varsle andre systemer som bruker organisasjonsdata?
  # - Trenger fusjonering en godkjenningsprosess, eller kan det utføres direkte?
  # - Norsk fusjonering: Hentes data til ny organisasjon fra Brønnøysundregistrene (org.nr.), eller registreres manuelt?

  Regel: Norsk fusjonering oppretter en ny organisasjon

    @must @planned
    Scenario: To norske læresteder fusjonerer til én ny
      Gitt at to norske læresteder fusjonerer
      Når jeg registrerer fusjoneringen
      Så skal det opprettes en ny organisasjon for det fusjonerte lærestedet
      Og de to gamle lærestedene skal markeres som inaktive
      Og det nye lærestedet skal ha en referanse til de to lærestedene den oppstod fra

  Regel: Navnehistorikken fra fusjonerte organisasjoner arves av den nye

    @must @planned
    Scenario: Navnehistorikk fra begge organisasjonene videreføres ved fusjonering
      Gitt at to organisasjoner fusjonerer til en ny organisasjon
      Når den nye organisasjonen opprettes
      Så skal navnehistorikken fra begge de fusjonerte organisasjonene vises i den nye organisasjonens historikk

  Regel: Utenlandsk fusjonering behandles annerledes enn norsk

    @should @planned
    Scenario: To utenlandske organisasjoner fusjonerer — én videreføres
      Gitt at to utenlandske organisasjoner fusjonerer
      Når jeg registrerer fusjoneringen
      Så skal én av organisasjonene beholdes som gjeldende organisasjon
      Og den andre skal markeres som inaktiv
      Og den inaktiverte skal knyttes til den beholdte som sin etterfølger

    @should @planned
    Scenario: Norsk og utenlandsk organisasjon fusjonerer
      Gitt at en norsk og en utenlandsk organisasjon fusjonerer
      Når jeg registrerer fusjoneringen
      Så skal systemet gi veiledning om hvilke regler som gjelder for denne kombinasjonen