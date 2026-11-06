# language: no
# Jira: SHI-688
@OPT-OPT-UTD-010 @must @implemented @scope-utdanningstilbud-2027
Egenskap: Registrere poengopplysninger for utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å se median poengsum fra forrige opptak og registrere poenggrense for årets tidligopptak
  slik at søkere får et realistisk bilde av konkurransen om studieplassene.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Median poengsum fra forrige opptak vises
    # AVKLART 2026-10-22: Medianen finnes i databasen. Den registreres ikke av opptaksforvalter, og vises på utdanningstilbudet.
    # Avklart 05.11.2026 (Marit): medianen er fra forrige opptak, uansett hvor lenge siden
    # det var. Har utdanningstilbudet ingen median fra forrige opptak, vises ikke en eldre median.
    # Det er den samme medianen som brukes i tidligopptaket når poenggrensen ikke er satt.

    @in-progress @openquestion
    Scenario: Se median poengsum for de opptatte i forrige opptak
      # ÅPNE SPØRSMÅL:
      # - Ikke funnet i main (verify 2026-10-22): fs-admin viser «Ikke tilgjengelig» og henter ikke medianen. Branchen einor/shi-688-feat-median-og-poenggrenser i fs-admin henter og viser den. Leveres scenarioet når den er merget?
      Gitt at utdanningstilbudet har en median poengsum fra forrige opptak
      Så vises median poengsum for de opptatte i forrige opptak

    @draft
    Scenario: Median fra et eldre opptak vises ikke
      Gitt at utdanningstilbudet ikke har en median poengsum fra forrige opptak
      Men utdanningstilbudet har en median poengsum fra et eldre opptak
      Så vises ikke median poengsum

  Regel: Poenggrense for årets tidligopptak kan registreres og vises
    # AVKLART 2026-10-22: Det er én poenggrense per utdanningstilbud, ikke per kvote.

    Scenario: Registrere poenggrense for tidligopptak
      Når opptaksforvalter registrerer poenggrensen for årets tidligopptak
      Så lagres poenggrensen på utdanningstilbudet

    Scenario: Se registrert poenggrense for tidligopptak
      Gitt at det er registrert en poenggrense for årets tidligopptak
      Så vises poenggrensen for tidligopptak
