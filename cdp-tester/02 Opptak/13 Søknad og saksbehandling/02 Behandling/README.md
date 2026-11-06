# CDP-tester: Behandling

Tester for kravet [gi_tilbudsgaranti_ved_tidlig_opptak.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) (`@OPT-BEH-BEH-007`), i `gi_tilbudsgaranti_ved_tidlig_opptak.feature` i denne mappa.

## Krever

| Nøkkel | Type | Brukes av |
|---|---|---|
| `opptak-forvalter-forvaltende` | testbruker | alle scenarioer, unntatt «Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket» |
| `opptak-forvalter-deltakende` | testbruker | oppsettet |
| `opptak-tilbyder` | testbruker | «Tidligopptakstilbud fra tilbyder går foran poengsummen», «Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket» |
| `opptak-samordna-tidlig-opptak` | testdata (oppsett) | de utledede testcasene om poenggrensen, fristen og utdanningstilbud som ikke tilbyr tidlig opptak |
| `utdanningstilbud-deltakende` | testdata | oppsettet, og de utledede testcasene om poenggrensen |
| `utdanningstilbud-deltakende-uten-tidlig-opptak` | testdata | oppsettet, og «… utdanningstilbud som ikke tilbyr tidlig opptak» |
| `opptak-tidlig-opptak-med-sokere` | testdata | scenarioene om gjennomføringen og prøvekjøringen |
| `opptak-tidlig-opptak-uten-tilbudsgarantitype` | testdata | «Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak» |
| `tilbudsgarantitype-tidlig-opptak` | testdata | scenarioene om gjennomføringen (Utfylling S) |
| `tilbudsgarantitype-gir-ikke-tilbud` | testdata | «Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet» |
| `tilbudsgarantitype-gir-tilbud-ikke-tidlig-opptak` | testdata | «Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet», «Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket» |
| `tilbudsgarantitype-tidligopptakstilbud-tilbyder` | testdata | «Tidligopptakstilbud fra tilbyder går foran poengsummen», «Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket» |
| `konklusjon-deltar` | testdata | «Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon» |
| `soker-tidlig-opptak-oppfyller-kravene` | testdata | «Tilbudsgaranti ut fra poenggrensen», «… ikke gir tilbud blir erstattet», «… gir tilbud blir erstattet», «En ny gjennomføring fjerner ikke tilbudsgarantien», «… prøvekjøringen lagrer ingenting» |
| `soker-tidlig-opptak-deltar-ikke` | testdata | «Søkere som ikke deltar får ikke tilbudsgaranti», «Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak» |
| `soker-tidlig-opptak-uten-konklusjon` | testdata | «Søknader uten konklusjon er ikke med i tidligopptaket», «Se antall søkere med saker …», «Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket» |
| `soker-tidlig-opptak-ikke-kvalifisert` | testdata | «Søkere som ikke er kvalifisert får ikke tilbudsgaranti» |
| `soker-tidlig-opptak-to-alternativer` | testdata | «Tilbudsgaranti på det høyest prioriterte søknadsalternativet», «Tidligopptakstilbud fra tilbyder går foran poengsummen», «Tilbudsgarantien flyttes …» |
| `soker-tidlig-opptak-sak-ikke-behandlet` | testdata | «Bare ferdig behandlede saker er med i tidligopptaket» |
| `soker-tidlig-opptak-reservert-under-grensen` | testdata | «Reservert studieplass gir tilbudsgaranti uten poenggrense» |
| `soker-tidlig-opptak-reservert-ikke-kvalifisert` | testdata | «Reservert studieplass gir tilbudsgaranti uten kvalifisering» |
| `soker-tidlig-opptak-poeng-flere-kvoter` | testdata | «Den høyeste poengsummen til søknadsalternativet gjelder» |
| `soker-tidlig-opptak-annen-garanti-hoyere-prioritet` | testdata | «Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket» |
| `soker-tidlig-opptak-behandlet-etter-gjennomforing` | testdata | «Ny gjennomføring tar med en sak som er blitt ferdig behandlet» |
