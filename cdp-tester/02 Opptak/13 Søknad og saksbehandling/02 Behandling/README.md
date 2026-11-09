# CDP-tester: Behandling

Tester for kravet [gi_tilbudsgaranti_ved_tidlig_opptak.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) (`@OPT-BEH-BEH-007`), i `gi_tilbudsgaranti_ved_tidlig_opptak.feature` i denne mappa.

## Krever

| Nøkkel | Type | Brukes av |
|---|---|---|
| `opptak-forvalter-forvaltende` | testbruker | alle scenarioer (gjennomføring og prøvekjøring) |
| `opptak-saksbehandler-behandlende-tidlig-opptak` | testbruker | alle scenarioer (Klargjøring K og S) |
| `opptak-tilbyder-behandlende` | testbruker | «Tidligopptakstilbud fra tilbyder går foran poengsummen», «Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum», «Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket», og den utledede om tidligopptakstilbud uten søknad om tidlig opptak |
| `soker-tidlig-opptak` | testbruker | den utledede om et trukket søknadsalternativ |
| `poenggrenser-tidlig-opptak` | testdata (oppsett) | alle scenarioer |
| `opptak-tidlig-opptak` | testdata | alle scenarioer |
| `utdanningstilbud-tidlig-opptak` | testdata | de fleste scenarioene |
| `utdanningstilbud-tidlig-opptak-andre` | testdata | «Tilbudsgaranti på det høyest prioriterte søknadsalternativet», «Tidligopptakstilbud fra tilbyder går foran poengsummen», «Tilbudsgarantien flyttes …», og den utledede om et trukket søknadsalternativ |
| `utdanningstilbud-uten-tidlig-opptak` | testdata | «Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket» |
| `utdanningstilbud-tidlig-opptak-med-median` | testdata | regelen om medianen |
| `utdanningstilbud-tidlig-opptak-uten-median` | testdata | «Ingen tilbudsgaranti uten poenggrense og uten median fra forrige opptak» |
| `tilbudsgarantitype-tidlig-opptak` | testdata | alle scenarioer som gjennomfører |
| `tilbudsgarantitype-tilbyder-tidligopptakstilbud` | testdata | scenarioene med tidligopptakstilbud fra tilbyder |
| `tilbudsgarantitype-forvalter-gir-tilbud` | testdata | «Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet», «Annen tilbudsgaranti på et høyere prioritert søknadsalternativ …» |
| `tilbudsgarantitype-forvalter-gir-ikke-tilbud` | testdata | «Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet» |
| `tilbudsgarantitype-reservert-studieplass` | testdata | scenarioene med reservert studieplass |
| `opptak-tidlig-opptak-uten-tilbudsgarantitype` | testdata | «Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak» |
| `opptak-tidlig-opptak-to-tilbudsgarantityper` | testdata | «Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak» |
| `sak-tidlig-opptak-kvalifisert` | testdata | de fleste scenarioene (én søker per scenario) |
| `sak-tidlig-opptak-ikke-kvalifisert` | testdata | «Søkere som ikke er kvalifisert får ikke tilbudsgaranti», «Reservert studieplass gir tilbudsgaranti uten kvalifisering» |
| `sak-tidlig-opptak-kvalifisering-ikke-vurdert` | testdata | «Kvalifisering som ikke er vurdert gir ikke tilbudsgaranti» |
| `sak-tidlig-opptak-grunnlag-kvalifisert-og-ikke-kvalifisert` | testdata | den utledede om kvalifiseringen med flere grunnlag |
| `sak-tidlig-opptak-grunnlag-ikke-vurdert-og-ikke-kvalifisert` | testdata | den utledede om kvalifiseringen med flere grunnlag |
| `sak-tidlig-opptak-to-kvoter` | testdata | «Den høyeste poengsummen til søknadsalternativet gjelder» |
| `sak-tidlig-opptak-poeng-i-kvote-uten-kvoteplassering` | testdata | den utledede om en kvote søkeren ikke skal kvoteplasseres i |
| `sak-tidlig-opptak-uten-poengsum` | testdata | «Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum», og den utledede om manglende poengsum |
| `sak-tidlig-opptak-prioritet-1-uten-tidlig-opptak` | testdata | «Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket» |
| `sak-uten-soknad-om-tidlig-opptak` | testdata | den utledede om tidligopptakstilbud uten søknad om tidlig opptak |
| `sak-tidlig-opptak-median-over` | testdata | regelen om medianen |
| `sak-tidlig-opptak-median-lik` | testdata | regelen om medianen |
| `sak-tidlig-opptak-median-under` | testdata | regelen om medianen |
| `sak-tidlig-opptak-uten-median` | testdata | «Ingen tilbudsgaranti uten poenggrense og uten median fra forrige opptak» |
| `sak-tidlig-opptak-to-saker` | testdata | den utledede om en søker med to saker |
