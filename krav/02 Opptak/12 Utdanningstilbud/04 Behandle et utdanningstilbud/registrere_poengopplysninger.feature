# language: no
# Jira: SHI-688
@OPT-OPT-UTD-010 @must @draft
Egenskap: Registrere poengopplysninger for utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å se fjorårets median poengsum og registrere poenggrense for årets tidligopptak
  slik at søkere får et realistisk bilde av konkurransen om studieplassene.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Median poengsum for fjoråret vises

    Scenario: Se median poengsum for fjorårets opptatte
      Gitt at utdanningstilbudet har en median poengsum fra fjorårets opptak
      Så vises median poengsum for fjorårets opptatte

  Regel: Poenggrense for årets tidligopptak kan registreres og vises

    Scenario: Registrere poenggrense for tidligopptak
      Når opptaksforvalter registrerer poenggrensen for årets tidligopptak
      Så lagres poenggrensen på utdanningstilbudet

    Scenario: Se registrert poenggrense for tidligopptak
      Gitt at det er registrert en poenggrense for årets tidligopptak
      Så vises poenggrensen for tidligopptak

# ÅPNE SPØRSMÅL:
# - Hvor hentes fjorårets median poengsum fra? Kilden er ikke avklart (må utredes).
# - Skal median beregnes automatisk fra opptaksdata, eller registreres manuelt?
# - Gjelder poenggrensen for tidligopptak per kvote, eller er det én samlet grense per utdanningstilbud?
