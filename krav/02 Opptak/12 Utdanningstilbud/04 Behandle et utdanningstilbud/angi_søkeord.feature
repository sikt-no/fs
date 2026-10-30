# language: no
# Jira: SHI-695
@OPT-OPT-UTD-017 @must @implemented @scope-utdanningstilbud-2027
Egenskap: Angi søkeord på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å angi søkeord på utdanningstilbudet
  slik at søkere lettere finner tilbud som har ukjente navn i Min kompetanse.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

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

  Regel: Søkeord hjelper søkeren å finne utdanningstilbud i Min kompetanse

    @in-progress @openquestion
    Scenario: Søker finner utdanningstilbud via søkeord
      # ÅPNE SPØRSMÅL:
      # - Søkeordene tas med i søket i fs-plattform !6482 (https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6482), uten endring i Min kompetanse. Lukkes av fs-verify når den er merget.
      Gitt at utdanningstilbudet har søkeordet "Lege"
      Når søkeren søker på "Lege" i Min kompetanse
      Så vises utdanningstilbudet i søkeresultatet
