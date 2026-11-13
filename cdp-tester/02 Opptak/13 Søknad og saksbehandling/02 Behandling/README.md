# CDP-tester: Behandling

Tester for kravet [tildele_saksbehandlende_organisasjon.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) (`@OPT-BEH-BEH-011`), i `tildele_saksbehandlende_organisasjon.feature` i denne mappa.

Flyten [saksbehandlertildeling.feature](../../../_L%C3%B8p/10%20Opptaksl%C3%B8pet/saksbehandlertildeling.feature) (`@FLY-OPT-SAK-001`) i `_Løp/` bruker de samme nøklene og det samme oppsettet.

Alt som endres, skjer i opptaket `opptak-samordna-saksbehandlertildeling`. Utdanningstilbudene og organisasjonene i eksemplene i kravet er byttet med nøklene under. Det brukes høyst fem søkere i hele kjøringen: `soker-1` (norsk utdanningsbakgrunn), `soker-2` (utenlandsk), `soker-3` (steinerskole), `soker-4` (realkompetanse) og `soker-5` (endring og flytting). Søknadene fra oppsettet gjenbrukes på tvers av scenarioene, og `soker-5` sender søknaden på nytt i hvert scenario som trenger en annen fordeling.

Tester for kravet [gi_tilbudsgaranti_ved_tidlig_opptak.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) (`@OPT-BEH-BEH-007`), i `gi_tilbudsgaranti_ved_tidlig_opptak.feature` i denne mappa. De bruker opptaket `opptak-tidlig-opptak`. Søkerne står som lister i miljøfila, fordi en søker ikke kan brukes på nytt etter gjennomføringen av tidligopptaket.

## Krever

| Nøkkel | Type | Brukes av |
|---|---|---|
| `opptak-forvalter-forvaltende` | testbruker | tildele saksbehandlende organisasjon: de fleste scenarioene (regler, unntak, frist, lese sakene, flytte saken). Tidligopptaket: alle scenarioer (gjennomføring og prøvekjøring) |
| `opptak-forvalter-deltakende` | testbruker | «Deltakende lærested kan ikke endre behandlertildelingsreglene», «Sektoren er lærestedene som har utdanningstilbud med samme behandlertildelingsregel», og utledet testcase om valg av regel på utdanningstilbudet |
| `opptak-forvalter-deltakende-annen` | testbruker | organisasjon i «Legge til unntak for lærested» og «Legg til unntak er deaktivert når alle deltakerne har et unntak» (bare som `{ORG:…}`) |
| `opptak-forvalter-ikke-deltakende` | testbruker | organisasjon som ikke deltar, i «Organisasjonen for sektoren må delta i opptaket» og «Organisasjonene i unntaket for lærested må delta i opptaket» (bare som `{ORGNAVN:…}`) |
| `opptak-saksbehandler-saksbehandlende` | testbruker | «Saksbehandleren ser bare saken hos organisasjonen sin», «Saksbehandleren endrer utdanningsbakgrunnen til …», frist og flytting |
| `opptak-saksbehandler-forvaltende` | testbruker | «Saksbehandleren ved forvaltende organisasjon ser bare saken hos forvaltende organisasjon», «Interne merknader blir igjen …» |
| `opptak-saksbehandler-tilbyder` | testbruker | «Tilbyderen ser søknadsalternativ som en annen organisasjon saksbehandler», «Tilbyderen setter tilbudsgaranti», «Tilbyderen kan ikke endre saksbehandlingen» |
| `soker-1` | testbruker | `soknad-norsk`, «Søkeren ser saksbehandlende organisasjon, men ikke sakene» |
| `soker-2` | testbruker | `soknad-utenlandsk`, «Ledig studieplass går foran unntak for utdanningsbakgrunn» |
| `soker-3` | testbruker | `soknad-steinerskole` |
| `soker-4` | testbruker | `soknad-realkompetanse` |
| `soker-5` | testbruker | `soknad-endring-og-flytting`, og alle scenarioer som sender søknaden på nytt |
| `behandlertildelingsregler-i-opptaket` | testdata (oppsett) | alle scenarioer som leser, åpner eller velger en regel |
| `soknad-norsk` | testdata (oppsett) | fordeling og innsyn for norsk utdanningsbakgrunn, unntak for lærested, «Søknaden får én sak per saksbehandlende organisasjon» |
| `soknad-utenlandsk` | testdata (oppsett) | «HK-dir saksbehandler hele søknaden …», «Unntaket går foran …», «Behandlertildelingsregel uten unntak …» |
| `soknad-steinerskole` | testdata (oppsett) | «HK-dir saksbehandler hele søknaden …» |
| `soknad-realkompetanse` | testdata (oppsett) | «Hver tilbyder saksbehandler sitt eget søknadsalternativ når søkeren har realkompetanse», «Unntaket for lærested gjelder også når …» |
| `soknad-endring-og-flytting` | testdata (oppsett) | «Unntaket for lærested gjelder også når …» (ledig studieplass) |
| `opptak-samordna-saksbehandlertildeling` | testdata | alle scenarioer og oppsettet |
| `opptak-samordna-annet` | testdata | «Nytt opptak får standard behandlertildelingsregel …» |
| `opptak-lokalt-eksisterende` | testdata | «Behandlertildelingsreglene er ikke tilgjengelige i lokale opptak» |
| `tilbud-saksbehandlende-uten-regel` | testdata | fordeling og innsyn (utdanningstilbud ved `opptak-saksbehandler-saksbehandlende`, uten egen regel) |
| `tilbud-saksbehandlende-sektor-organisasjon` | testdata | sektor med valgt organisasjon |
| `tilbud-saksbehandlende-tilbyder` | testdata | tilbyder-regel med unntak for utdanningsbakgrunn, og ledig studieplass |
| `tilbud-saksbehandlende-laerested` | testdata | unntak for lærested der forvaltende organisasjon saksbehandler |
| `tilbud-tilbyder-uten-regel` | testdata | fordeling og innsyn (utdanningstilbud ved `opptak-saksbehandler-tilbyder`, uten egen regel) |
| `tilbud-tilbyder-sektor` | testdata | sektor uten valgt organisasjon |
| `tilbud-deltakende-isolert` | testdata | «Bare tilbyderen – bare dette studieønsket» |
| `tilbud-deltakende-tilbyder` | testdata | «Bare tilbyderen – også for studieønsker uten egen regel» |
| `tilbud-deltakende-sektor` | testdata | sektor uten valgt organisasjon |
| `tilbud-deltakende-laerested` | testdata | unntak for lærested der tilbyderen saksbehandler på vegne av lærestedet, og ledig studieplass |
| `frist-utdanningsbakgrunn` | testdata | scenarioer om frist for endring av utdanningsbakgrunn |
| `tilbudsgarantityper` | testdata | «Tilbyderen setter tilbudsgaranti», «Søknadsalternativet saksbehandles på nytt …» |
| `ledige-studieplasser-apnet` | testdata | scenarioer om ledig studieplass |
| `utdanningsbakgrunner-godkjente` | testdata | utdanningsbakgrunnene søkerne velger |
| `opptak-saksbehandler-behandlende-tidlig-opptak` | testbruker | alle scenarioer (Klargjøring K og S) |
| `opptak-saksbehandler-behandlende-tidlig-opptak-andre` | testbruker | den utledede om en søker med to saker (saken hos NTNU) |
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
| `tilbudsgarantitype-reservert-studieplass-behandler` | testdata | scenarioene med reservert studieplass fra behandler |
| `tilbudsgarantitype-reservert-studieplass-forvalter` | testdata | «Reservert studieplass fra opptaksforvalter blir erstattet» (utledet) |
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
