# language: no
# Generert av fs-testcaser-cdp 2026-11-04
# Flyt: krav/_Flyter/10 Opptaksløpet/saksbehandlertildeling.feature @ c6d5e79e (blob 61fda4b350569b2e59351b3e2fd4197e00c0839c), på branchen krav/saksbehandlertildeling-v2
#
# Overleveringen fra regelen på utdanningstilbudet til sakene hos saksbehandlende organisasjon. Testene bruker oppsettet og nøklene i
# cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/ (README.md og oppsett.feature), og de samme formuleringene for
# søknader, fordeling og «B-rolle» som testene der. Reglene og søknadene er laget av oppsettet gjennom løsningen, ikke lagt inn direkte.
@TST-OPT-SAK-001 @depends-on-FLY-OPT-SAK-001
Egenskap: Saksbehandlertildeling
  Fra reglene settes på utdanningstilbudene, til riktig organisasjon har saken: søknaden sendes inn, søknadsalternativene fordeles, og den
  saksbehandlende organisasjonen ser saken.


  @depends-on-OPT-BEH-BEH-011
  Regel: Søknadsalternativene fordeles når søknaden sendes

    Scenario: Søknaden blir én sak hos hver saksbehandlende organisasjon
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og utdanningstilbudet «tilbud-deltakende-isolert» har regelen «K{KJØRING}-ISO», og «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel» har ikke egen regel (oppsettet har satt regelen på utdanningstilbudet)
      Og søknaden «soknad-norsk» er sendt inn av søkeren, med studieønskene «tilbud-deltakende-isolert», «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel», «tilbud-deltakende-laerested» og «tilbud-saksbehandlende-laerested» i den rekkefølgen, og fordelt
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
      Og {ORG:opptak-forvalter-deltakende} står som «B-rolle» på «tilbud-deltakende-isolert»
      Og søknaden har én rad hos {ORG:opptak-saksbehandler-saksbehandlende} og én rad hos {ORG:opptak-forvalter-deltakende} i «Saker i opptak», med samme «Søknadsnummer»
      # Søknaden har to saker til, for «tilbud-deltakende-laerested» og «tilbud-saksbehandlende-laerested», som følger av unntakene for lærested.

    Scenario: Organisasjonen som saksbehandler på vegne av lærestedet får saken
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og regelen «K{KJØRING}-LAE» har {ORG:opptak-saksbehandler-tilbyder} i «Saksbehandles av» og {ORG:opptak-forvalter-deltakende} i «På vegne av», og står på «tilbud-deltakende-laerested»
      Og søknaden «soknad-norsk» med «tilbud-deltakende-laerested» er sendt inn og fordelt
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så har søknaden en sak hos {ORG:opptak-saksbehandler-tilbyder} med «tilbud-deltakende-laerested»
      Og {ORG:opptak-saksbehandler-tilbyder} står som «B-rolle» på «tilbud-deltakende-laerested»


  @depends-on-OPT-BEH-BEH-011 @depends-on-OPT-BEH-BEH-010
  Regel: Den saksbehandlende organisasjonen ser saken

    Scenario: Saksbehandleren ved den saksbehandlende organisasjonen ser saken
      Gitt jeg er logget inn som «opptak-saksbehandler-saksbehandlende»
      Og søknaden «soknad-norsk» har saker hos {ORG:opptak-saksbehandler-saksbehandlende} og {ORG:opptak-forvalter-deltakende}
      Når jeg åpner søknaden «soknad-norsk» i «Saker i opptak» under «Søknadsbehandling»
      Så ser jeg saken hos {ORG:opptak-saksbehandler-saksbehandlende}, med «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel» og {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle»

    @endrer-data
    Scenario: Tilbyderen kan sette tilbudsgaranti på søknadsalternativet som en annen organisasjon saksbehandler
      Gitt jeg er logget inn som «opptak-saksbehandler-tilbyder»
      Og «tilbudsgarantityper» finnes i opptaket (ellers er scenarioet ikke testbart)
      Og «tilbud-tilbyder-uten-regel» er fordelt til {ORG:opptak-saksbehandler-saksbehandlende} i søknaden «soknad-norsk», og har «Ikke valgt» i «Tilbudsgaranti fra tilbyder»
      Når jeg åpner saken til søknaden «soknad-norsk», velger «Søknadsalternativer», og velger en tilbudsgaranti i «Tilbudsgaranti fra tilbyder» for «tilbud-tilbyder-uten-regel»
      Så ser jeg «Tilbudsgaranti lagret»
      Og jeg åpner saken på nytt, og tilbudsgarantien står i «Tilbudsgaranti fra tilbyder» for «tilbud-tilbyder-uten-regel»
      # Setter tilbake:
      Og jeg velger «Ikke valgt» i «Tilbudsgaranti fra tilbyder» for «tilbud-tilbyder-uten-regel», og ser «Tilbudsgaranti lagret»
