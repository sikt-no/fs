# language: no
# Jira: SHI-688
@OPT-OPT-UTD-010 @must @implemented @scope-utdanningstilbud-2027
Egenskap: Registrere poengopplysninger for utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å se fjorårets median poengsum og registrere poenggrense for årets tidligopptak
  slik at søkere får et realistisk bilde av konkurransen om studieplassene.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Median poengsum for fjoråret vises
    # AVKLART 2026-10-22: Medianen finnes i databasen. Den registreres ikke av opptaksforvalter, og vises på utdanningstilbudet.

    @in-progress
    Scenario: Se median poengsum for fjorårets opptatte
      Gitt at utdanningstilbudet har en median poengsum fra fjorårets opptak
      Så vises median poengsum for fjorårets opptatte

  Regel: Poenggrense for årets tidligopptak kan registreres og vises
    # AVKLART 2026-10-22: Det er én poenggrense per utdanningstilbud, ikke per kvote.

    Scenario: Registrere poenggrense for tidligopptak
      Når opptaksforvalter registrerer poenggrensen for årets tidligopptak
      Så lagres poenggrensen på utdanningstilbudet

    Scenario: Se registrert poenggrense for tidligopptak
      Gitt at det er registrert en poenggrense for årets tidligopptak
      Så vises poenggrensen for tidligopptak
