# language: no
# Jira: SHI-695
@OPT-OPT-UTD-017 @must @implemented @scope-utdanningstilbud-2027
Egenskap: Angi søketagger på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å angi søketagger på utdanningstilbudet
  slik at søkere lettere finner tilbud som har ukjente navn i Min kompetanse.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  @deprecated
  Regel: Søkeord kan angis på utdanningstilbudet
    # AVKLART 2026-10-22: Søkeord er fritekst, med forslag fra søkeord som allerede er brukt.
    # Et utdanningstilbud har høyst 20 søkeord, og et søkeord har høyst 50 tegn. Det er ingen krav til format.

    Scenario: Legge til søkeord på utdanningstilbud
      Når opptaksforvalter legger til søkeordet "Lege" på utdanningstilbudet
      Så lagres søkeordet på utdanningstilbudet

    Scenario: Legge til flere søkeord på samme utdanningstilbud
      Når opptaksforvalter legger til søkeordene "Lege" og "Design" på utdanningstilbudet
      Så lagres begge søkeordene på utdanningstilbudet

    Scenario: Fjerne søkeord fra utdanningstilbud
      Gitt at utdanningstilbudet har søkeordet "Design"
      Når opptaksforvalter fjerner søkeordet "Design"
      Så er søkeordet ikke lenger lagret på utdanningstilbudet

  @planned
  Regel: Søketagger velges fra kodesettet
    # Søketaggene er et fast kodesett. Opptaksforvalter kan ikke skrive inn egne søketagger.

    Scenario: Legge til søketagg på utdanningstilbud
      Når opptaksforvalter velger søketaggen "Lege" på utdanningstilbudet
      Så lagres søketaggen på utdanningstilbudet

    Scenario: Legge til flere søketagger på samme utdanningstilbud
      Når opptaksforvalter velger søketaggene "Lege" og "Medisin" på utdanningstilbudet
      Så lagres begge søketaggene på utdanningstilbudet

    Scenario: Fjerne søketagg fra utdanningstilbud
      Gitt at utdanningstilbudet har søketaggen "Medisin"
      Når opptaksforvalter fjerner søketaggen "Medisin"
      Så er søketaggen ikke lenger lagret på utdanningstilbudet

    Scenario: Bare søketagger som gjelder for opptakstypen kan velges
      Gitt at en søketagg ikke gjelder for opptakstypen til opptaket
      Når opptaksforvalter velger søketagger på utdanningstilbudet
      Så kan ikke søketaggen velges

    Scenario: Søketagger som ikke er aktive kan ikke velges
      Gitt at en søketagg ikke lenger er aktiv i kodesettet
      Når opptaksforvalter velger søketagger på utdanningstilbudet
      Så kan ikke søketaggen velges

    Scenario: Et utdanningstilbud har høyst 20 søketagger
      Gitt at utdanningstilbudet har 20 søketagger
      Når opptaksforvalter velger en søketagg til
      Så kan ikke utdanningstilbudet lagres

  Regel: Søketagger hjelper søkeren å finne utdanningstilbud i Min kompetanse

    @in-progress
    Scenario: Søker finner utdanningstilbud via søketagg
      Gitt at utdanningstilbudet har søketaggen "Lege"
      Når søkeren søker på "Lege" i Min kompetanse
      Så vises utdanningstilbudet i søkeresultatet
