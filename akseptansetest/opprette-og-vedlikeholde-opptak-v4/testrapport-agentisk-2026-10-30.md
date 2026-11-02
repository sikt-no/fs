# Testrapport – agentisk funksjonstest – Opprette og vedlikeholde opptak v4

- **Nivå**: agentisk
- **Fase**: 2
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155553291
- **Scope**: @scope-opprette-opptak-2027
- **Grunnlag**: `kjoring-2026-10-29-1322/resultat.md`, lest 2026-10-30. Årsakene til «Ikke bestått» er hentet fra [verify-2026-10-29-1502.md](verify-2026-10-29-1502.md) (verifiseringen av testcasene som ikke besto)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5158567942
- **Laget**: 2026-10-30 av fs-testrapport

---

Testrapport for «Opprette og vedlikeholde opptak». Den bygger på den agentiske kjøringen 29.10.2026 kl. 13:22 i TEST, og på verifiseringen av testcasene som ikke besto, samme dag kl. 15:02.

Statusene er agentens forslag. Testansvarlig har ikke gått gjennom dem ennå, og funnene har ingen alvorlighetsgrad.

## Oppsummering

| Felt | Innhold |
|---|---|
| Kjøring | kjoring-2026-10-29-1322, startet av Mats Gimming Myhre, mot TEST (https://test-fsadmin.sikt.no). Versjonen i TEST er ikke lest |
| Testcaser | 96 bestått, 23 ikke bestått, 28 ikke testet, 0 ikke fylt ut, av 147 (foreslått av agenten, eksemplene i scenariomalene talt hver for seg) |
| Fra scenarioene i kravene | 105 testcaser |
| Utledet av agenten | 42 testcaser (negativ testing, obligatoriske felt, grenseverdier og regler uten scenario) |
| Funn | 14 funn (F1–F14), ingen med alvorlighetsgrad ennå: [Fylles ut av testansvarlig]. Av dem 6 «Kravet dekker ikke» (F7–F12) |
| Testdata | Nei: oppsettet laget 2 av 6 nøkler. Fire verdier mangler i miljøfila (`regelverkssamling-lokalt`, `utdanningstilbud-deltakende`, `regelverkssamling-samordna-annen` og `opptak-utdanningsbakgrunn-valgt-av-soker`), og `opptak-oversikt-over-50` finnes ikke (47 opptak i TEST) |
| Gjennomgått av testansvarlig | [Fylles ut av testansvarlig] |
| Stikkprøve av beståtte testcaser | [Fylles ut av testansvarlig] (størrelsen avgjøres etter en risikovurdering, det er ikke noe fast antall) |
| Inngangskriterium til intern akseptansetest | Ikke oppfylt ennå (se «Inngangskriteriet til intern akseptansetest») |

## Inngangskriteriet til intern akseptansetest

Sjekkes for seg, fordi det er inngangen til fase 3. Den agentiske rapporten har ingen beslutning, bare dette.

| Kriterium | Oppfylt |
|---|---|
| Alle testcasene er kjørt (ingen «ikke fylt ut», og «ikke testet» har begrunnelse) | Ja: alle 147 har status, og alle 28 «Ikke testet» har en begrunnelse. 27 av dem skyldes testdata som manglet, og blir testet først når verdiene er fylt ut og oppsettet er kjørt på nytt |
| Ingen funn med «Stopper» står åpne | Kan ikke avgjøres ennå: ingen av de 14 funnene har alvorlighetsgrad. [Fylles ut av testansvarlig] |
| Testansvarlig har gått gjennom rapporten, også funnene og stikkprøven av de beståtte | [Fylles ut av testansvarlig] |

Forutsetning 6 i testplanen (testansvarlig og teamet har gått gjennom testcasene før kjøringen) var ikke oppfylt før denne kjøringen.

## Resultat per krav

| Krav | Feature-ID | Status på kravet | Bestått | Ikke bestått | Ikke testet |
|---|---|---|---|---|---|
| Opprette et opptak | `@OPT-OVO-GRU-001` | `@implemented`, én regel `@in-progress` | 20 | 2 | 1 |
| Samordna opptak | `@OPT-OVO-SAM-001` | `@in-progress` | 13 | 1 | 7 |
| Innstillinger for opptak | `@OPT-OVO-INN-001` | `@implemented` | 23 | 5 | 7 |
| Frister og hendelser for opptak | `@OPT-OVO-FRI-001` | `@in-progress` | 31 | 14 | 0 |
| Listevisning og søk i opptak | `@OPT-OVO-OVE-001` | `@implemented` | 9 | 1 | 13 |
| **Til sammen** | | | **96** | **23** | **28** |

Per regel og teknikk («Positiv (fra kravet)» er scenarioene i kravet, de andre er utledet av agenten):

| Krav | Regel | Teknikk | Bestått | Ikke bestått | Ikke testet |
|---|---|---|---|---|---|
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | Opptaksforvalter kan opprette et opptak | Positiv (fra kravet) | 1 | 0 | 1 |
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | Opptaksforvalter kan opprette et opptak | Ekvivalensklasse | 0 | 2 | 0 |
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak | Positiv (fra kravet) | 3 | 0 | 0 |
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | Utdanningsbakgrunner, poenglikhetsregel og maks antall søknadsalternativer må være satt for å lagre et opptak | Positiv (fra kravet) | 3 | 0 | 0 |
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | Utdanningsbakgrunner, poenglikhetsregel og maks antall søknadsalternativer må være satt for å lagre et opptak | Ekvivalensklasse | 1 | 0 | 0 |
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne | Positiv (fra kravet) | 5 | 0 | 0 |
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne | Ekvivalensklasse | 3 | 0 | 0 |
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne | Grenseverdi | 4 | 0 | 0 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak | Positiv (fra kravet) | 1 | 0 | 0 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak | Ekvivalensklasse | 3 | 0 | 1 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud | Positiv (fra kravet) | 0 | 0 | 1 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Organisasjoner som ikke deltar, kan ikke se opptaket | Positiv (fra kravet) | 1 | 1 | 0 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | En deltakende organisasjon kan ikke fjernes fra opptaket så lenge den har utdanningstilbud i det | Positiv (fra kravet) | 1 | 0 | 1 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger i opptaket | Positiv (fra kravet) | 0 | 0 | 2 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | I et lokalt opptak kan ikke andre organisasjoner legges til | Positiv (fra kravet) | 0 | 0 | 1 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Kun organisasjoner som finnes i utdanningsregisteret kan legges til som deltakere | Positiv (fra kravet) | 2 | 0 | 0 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Opptaksforvalter kan begrense hvilke lærestedstyper som får delta i opptaket | Positiv (fra kravet) | 2 | 0 | 0 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Opptaksforvalter kan begrense hvilke lærestedstyper som får delta i opptaket | Ekvivalensklasse | 2 | 0 | 0 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Opptaksforvalter ved forvaltende organisasjon kan se og navigere til saksbehandlertildelingen i samordna opptak | Positiv (fra kravet) | 1 | 0 | 1 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan endre opptakstype så lenge ingen utdanningstilbud er knyttet til opptaket | Positiv (fra kravet) | 1 | 0 | 1 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan endre regelverkssamling så lenge ingen utdanningstilbud er knyttet til opptaket | Positiv (fra kravet) | 0 | 0 | 2 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter setter standard poenglikhetsregel for opptaket | Positiv (fra kravet) | 2 | 0 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter setter standard poenglikhetsregel for opptaket | Beslutningstabell | 2 | 0 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan sette startnummer for søknadene | Positiv (fra kravet) | 1 | 1 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan sette startnummer for søknadene | Grenseverdi | 2 | 1 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan sette startnummer for søknadene | Ekvivalensklasse | 0 | 2 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter setter tak for antall søknadsalternativer | Positiv (fra kravet) | 1 | 0 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter setter tak for antall søknadsalternativer | Grenseverdi | 1 | 1 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan åpne for tidlig opptak | Positiv (fra kravet) | 3 | 0 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan åpne for tidlig opptak | Ekvivalensklasse | 2 | 0 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan åpne for tidlig opptak | Tilstandsovergang | 0 | 0 | 1 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan åpne for tidlig opptak | Beslutningstabell | 1 | 0 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan åpne for søknad på ledige studieplasser | Positiv (fra kravet) | 1 | 0 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan åpne for søknad på ledige studieplasser | Beslutningstabell | 1 | 0 | 0 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket | Positiv (fra kravet) | 2 | 0 | 3 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | Opptaksforvalter kan styre om søkere kan laste opp dokumentasjon | Positiv (fra kravet) | 3 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne åpne og stenge for redigering av utdanningstilbud | Positiv (fra kravet) | 2 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne åpne og stenge for redigering av utdanningstilbud | Ekvivalensklasse | 0 | 1 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for å trekke utdanningstilbud | Positiv (fra kravet) | 3 | 2 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne åpne for søkning | Positiv (fra kravet) | 1 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne sette generell søknadsfrist for opptaket | Positiv (fra kravet) | 1 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne sette omprioriteringsfrist | Positiv (fra kravet) | 1 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for sletting av søknadsalternativer | Positiv (fra kravet) | 1 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdato for dokumentasjon og ettersendingsfrist | Positiv (fra kravet) | 2 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for ledige studieplasser | Positiv (fra kravet) | 3 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak | Positiv (fra kravet) | 6 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak | Beslutningstabell | 1 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for opptaksresultat | Positiv (fra kravet) | 1 | 1 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter setter dato for aldersberegning | Positiv (fra kravet) | 2 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn | Positiv (fra kravet) | 1 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | Opptaksforvalter kan legge til utdanningsbakgrunner med avvikende frister | Positiv (fra kravet) | 1 | 0 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | De ordinære fristene må være satt for å lagre opptaket | Positiv (fra kravet) | 4 | 10 | 0 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | De ordinære fristene må være satt for å lagre opptaket | Ekvivalensklasse | 1 | 0 | 0 |
| [Listevisning og søk i opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/07%20Oversikt%20over%20opptak/listevisning_og_sok_i_opptak.feature) | Liste over alle opptak | Positiv (fra kravet) | 2 | 0 | 10 |
| [Listevisning og søk i opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/07%20Oversikt%20over%20opptak/listevisning_og_sok_i_opptak.feature) | Liste over alle opptak | Ekvivalensklasse | 0 | 0 | 1 |
| [Listevisning og søk i opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/07%20Oversikt%20over%20opptak/listevisning_og_sok_i_opptak.feature) | Søk og filtrering av opptak | Positiv (fra kravet) | 1 | 1 | 2 |
| [Listevisning og søk i opptak](https://github.com/sikt-no/fs/blob/3d8fba3/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/07%20Oversikt%20over%20opptak/listevisning_og_sok_i_opptak.feature) | Søk og filtrering av opptak | Ekvivalensklasse | 6 | 0 | 0 |

## Regler uten scenario

Reglene fra «Regler uten scenario» i testplanen (fra verifiseringen 28.10), og om de er testet i fase 2.

| Krav | Regel i koden | Testet i fase 2 | Kravet bør få scenario |
|---|---|---|---|
| `@OPT-OVO-GRU-001` | Navnet er høyst 100 tegn på hvert språk | ja: 100 og 101 tegn, bestått | nei |
| `@OPT-OVO-GRU-001` | Et navn med bare mellomrom regnes som manglende | ja: bestått | nei |
| `@OPT-OVO-GRU-001` | Opptakstypene avhenger av samordna eller lokalt | ja: ikke bestått (F9, F10) | ja (`fs-krav`) |
| `@OPT-OVO-GRU-001` | Maks antall søknadsalternativer forhåndsutfylles med 10 | ja: sett i «Lagre opptak uten maks antall søknadsalternativer» | nei |
| `@OPT-OVO-SAM-001` | Invitasjonsmodalen viser bare aktive læresteder, skjuler de som er lagt til, og søker i navn, forkortelse og kode | delvis: søket er bestått. At de som er lagt til, skjules, ble sett, men testen ble ikke kjørt (testdata). Nedlagte læresteder vises (F12) | nei |
| `@OPT-OVO-SAM-001` | En deltaker som er sektororganisasjon i en tildelingsregel, kan ikke fjernes | nei: krever saksbehandlertildeling (som planlagt) | ja (`fs-krav`) |
| `@OPT-OVO-SAM-001` | Et samordna opptak kan ikke gjøres lokalt med deltakere eller egne tildelingsregler | nei: skjemaet tilbyr det ikke (som planlagt) | ja (`fs-krav`) |
| `@OPT-OVO-SAM-001` | En deltaker kan bare endre utdanningstilbud mens fasen er åpen | nei: ingen testcase, og testdata manglet | nei |
| `@OPT-OVO-SAM-001` | Tidlig opptak, dokumentopplasting og krever studierett vises alltid som påslått på oversikten | nei: testdata manglet (`opptak-samordna-med-utdanningstilbud`) | nei |
| `@OPT-OVO-INN-001` | Tidlig opptak kan ikke slås av mens et utdanningstilbud tilbyr det | nei: testdata manglet | ja (`fs-krav`) |
| `@OPT-OVO-INN-001` | Bekreftelse før tidlig opptak eller ledige studieplasser slås av | ja: bestått | ja (`fs-krav`) |
| `@OPT-OVO-INN-001` | En tillatt poenglikhetsregel som brukes av et utdanningstilbud, kan ikke fjernes | nei: krever et tilbud med unntak (som planlagt) | ja (`fs-krav`) |
| `@OPT-OVO-INN-001` | Med overstyring av poenglikhet må minst én regel være valgt | ja: bestått | nei |
| `@OPT-OVO-INN-001` | Lenken til tidlig opptak må være en http- eller https-adresse | ja: bestått | nei |
| `@OPT-OVO-INN-001` | Startnummer og maks søknadsalternativer må være større enn 0 | ja: ikke bestått (F7) | ja (`fs-krav`) |
| `@OPT-OVO-INN-001` | Samme utdanningsbakgrunn kan ikke oppgis to ganger | nei: skjemaet tilbyr det ikke (som planlagt) | nei |
| `@OPT-OVO-FRI-001` | En delvis utfylt dato i et valgfritt felt gir «Ugyldig dato …» | nei: testcasen brukte et obligatorisk felt (F11) | nei |
| `@OPT-OVO-FRI-001` | En obligatorisk frist kan ikke tømmes: forrige verdi kommer tilbake | ja: bestått | nei |
| `@OPT-OVO-FRI-001` | Standarddatoen for aldersberegning settes bare når publiseringsdatoen er satt | delvis: standarddatoen er bestått, tilfellet uten publiseringsdato er ikke laget (obligatorisk i skjemaet) | nei |
| `@OPT-OVO-FRI-001` | Avvikende frister kan bare settes på utdanningsbakgrunner som er valgt i opptaket | ja: «Legg til utdanningsbakgrunner» viste bare den valgte | nei |
| `@OPT-OVO-FRI-001` | Kortene for tidlig opptak og ledige studieplasser vises bare når valget er på | ja: bestått | ja (`fs-krav`) |
| `@OPT-OVO-OVE-001` | Lista har status, selv om kravet sier at status ikke er med | nei: avklares i kravet (som planlagt) | ja (`fs-krav`) |
| `@OPT-OVO-OVE-001` | Organisasjonsfilteret i lista er bak flagget `opptak-filter-organisasjon` | delvis: oppførselen tyder på at flagget er på | ja (`fs-krav`) |
| `@OPT-OVO-OVE-001` | Fritekst-søket er delstreng uten skille på store og små bokstaver | ja: bestått | nei |
| `@OPT-OVO-OVE-001` | Nytt søk eller filter starter på 50 igjen, filter og sortering i URL-en, «Nullstill», «Ingen opptak funnet» | delvis: «Ingen opptak funnet» er bestått, og søket står i URL-en | nei |

Testet: 13 av 25. Delvis: 4. Ikke testet: 8, av dem 5 som planlagt i testplanen og 3 fordi testdata manglet eller testcasen mangler.

Verifiseringen 15:02 fant 21 nye regler uten scenario, 7 av dem fra testcasene som ikke besto. De står i [verify-2026-10-29-1502.md](verify-2026-10-29-1502.md), og er input til neste versjon av testene.

## Testdata og bevis

| Felt | Innhold |
|---|---|
| Testdata | Laget av oppsettet: `opptak-samordna-uten-utdanningstilbud` og `opptak-en-utdanningsbakgrunn`. Ikke laget: `opptak-lokalt`, `opptak-samordna-med-utdanningstilbud`, `opptak-samordna-tilbud-med-tidlig-opptak` og `opptak-oversikt-flere-typer`. Mangler i miljøfila: `regelverkssamling-lokalt`, `utdanningstilbud-deltakende`, `regelverkssamling-samordna-annen` og `opptak-utdanningsbakgrunn-valgt-av-soker`. Finnes ikke: `opptak-oversikt-over-50`. `utdanningsbakgrunner-godkjente` har navn som ikke finnes i TEST («Utenlandsk utdanning», «Steinerskole»). Forslagene til verdier står i resultatet |
| Kan kjøres på nytt | Ja, når verdiene er fylt ut i miljøfila. Oppsettet lager nye opptak med kjøringen i navnet. Opptakene fra denne kjøringen blir liggende (opptak kan ikke slettes) |
| Bevis | `akseptansetest/opprette-og-vedlikeholde-opptak-v4/kjoring-2026-10-29-1322/` (`resultat.md` er i git, de 57 skjermbildene er lokale og ikke i git) |

## Ikke bestått

Årsaken er fra verifiseringen 15:02, som har lest koden for hver av dem.

| Nr | Scenario | Faktisk resultat | Funn |
|---|---|---|---|
| 1 | SAM «Organisasjon som ikke deltar, kan ikke åpne opptaket» | FVT ser hele siden til opptaket. Lesingen er åpen for alle i databasen og API-et | F1 (feil i koden) |
| 2 | FRI «Opptaket kan ikke lagres uten fristen for å trekke utdanningstilbud» | Fristen kan tømmes, og opptaket lagres | F2 (feil i koden. TAKE-436 er «Won't do», men koden er ikke endret) |
| 3 | FRI «Varsel når fristen for å trekke utdanningstilbud er før redigeringen stenger» | Ingen varsel | F3 (mangler i koden, delvis i MR !6450) |
| 4 | FRI «Sette første svarfrist som informasjon til søkere» | Feltet finnes ikke | F4 (åpent spørsmål Q19 / TAKE-414) |
| 5 | INN «Startnummeret er 1 når opptaksforvalter ikke har satt det» | Lagres tomt | F5 (finnes bare i MR !6415) |
| 6–15 | FRI «Opptaket kan ikke lagres uten <frist>» (10 eksempler) | Forrige verdi kommer tilbake når feltet forlates. «Lagre» kan velges | F6 (koden har sperren, men testen nådde ikke tilstanden: testcasen var feil) |
| 16 | INN «… : ugyldig startnummer «0»» | Bare «En av de angitte verdiene er ugyldig», ikke lagret | F7 (kravet dekker ikke) |
| 17 | INN «… : 0 søknadsalternativer» | Som over | F7 (kravet dekker ikke) |
| 18 | INN «… : ugyldig startnummer «1,5»» | Lagret med 15, uten melding | F8 (kravet dekker ikke) |
| 19 | INN «… : ugyldig startnummer «abc»» | Lagret uten startnummer, uten melding | F8 (kravet dekker ikke) |
| 20 | GRU «… : opptakstypene i et lokalt opptak» | HYU er et valg i et lokalt opptak | F9 (sannsynlig feil i fs-admin: konstanten skjuler fortsatt FSU, som heter HYU etter V479) |
| 21 | GRU «… : opptakstypene i et samordna opptak» | Fire typer med nye navn | F10 (testen er utdatert etter V479) |
| 22 | OVE «Tilgjengelige opptakstyper i filter» | Fem koder: HYU, LOKAL, TEST_IT, UHG, UHM | F10 (testen er utdatert, og har en fast liste med typer som avhenger av miljøet) |
| 23 | FRI «… : dato som er delvis fylt ut» | Ingen melding, forrige verdi kommer tilbake | F11 (testcasen var feil: meldingen gjelder bare valgfrie felt) |

Etter årsak: 5 er feil eller mangler i koden (1, 2, 3, 5, 20), 1 venter på et åpent spørsmål (4), 13 er testcaser som var feil eller utdaterte (6–15, 21, 22, 23), og 4 er «Kravet dekker ikke» (16–19). 17 av de 23 var ventet i testplanen: 1–5 og 16–17 står i «Kjente begrensninger», og testplanen sa at 6–15 trolig ikke ville bestå («Testcaser som skal lages»). De nye er 18–23.

## Bestått, men faktisk resultat avviker

Testcaser med «Bestått» der «Faktisk resultat» beskriver noe annet enn forventet resultat, eller der agenten oversatte ordene i testen til ordene i skjermen. Testansvarlig ser på dem og avgjør status. Skillen endrer ikke statusen.

| Nr | Scenario | Forventet resultat | Faktisk resultat |
|---|---|---|---|
| 1 | Alle testcaser som bruker Utfylling A eller O | Opptakstypen «Samordna opptak til universiteter og høgskoler», og «Tilbud per tildelingsrunde» forhåndsutfylt med 1 | Opptakstypen heter «Samordna opptak til grunnstudier ved universiteter og høyskoler» (det eneste UHG-valget, som er valgt). «Tilbud per tildelingsrunde» finnes ikke |
| 2 | GRU «Opprette et samordna opptak» | Én rad i søket. «Administreres av» viser «HK-DIR» | To rader med samme navn (oppsettet og testen bruker samme navn). Redigeringssiden viser «Administrator: HK-dir» |
| 3 | GRU «Lagre opptak uten navn» | Bare de tre navnefeltene i banneret | Første forsøk viste også regelverkssamlingen, fordi agentens valg ikke ble registrert. Andre forsøk ga det forventede |
| 4 | GRU «Lagre opptak uten opptakstype» | Kommentaren i testen: «Du må velge opptakstype før du kan sette frister» | Meldingen vises ikke, og «Fyll inn testdatoer» virker uten opptakstype. Resten var som forventet |
| 5 | INN «Endre opptakstype når ingen utdanningstilbud er knyttet til opptaket» | «Samordna opptak til fagskoler» | Valgte «Samordna opptak til høyere yrkesfaglig utdanning» (FSU har fått koden HYU, V479) |
| 6 | INN «Fjerne en utdanningsbakgrunn fra opptaket» og «Den siste utdanningsbakgrunnen kan ikke fjernes» | «Steinerskole» | «Videregående steinerskole», som i oppsettet |
| 7 | FRI «… : en obligatorisk frist kan ikke tømmes» | Feltet forlates ved å velge «Omprioriteringsfrist» | Feltet ble forlatt ved å klikke på en overskrift. Resultatet var som forventet |
| 8 | FRI «Legge til utdanningsbakgrunn med avvikende frister» (å sette tilbake) | «Ja, fortsett» i «Er du sikker?» | «Fjern» fjernet kortet uten å spørre |
| 9 | FRI «Sette dato for aldersberegning» og «Dato for aldersberegning og avvikende frister kan stå tomme» | Datoen settes fra en notert verdi | Datoen var ikke satt fra før. Feltet viste standarddatoen 31.12.2027, så å sette den samme datoen endret ikke det som vises |
| 10 | FRI og INN, tidlig opptak og ledige studieplasser | Ett scenario om gangen | Scenarioene med de samme stegene ble kjørt én gang sammen, med kontrollen av alle feltene |
| 11 | OVE «Alle opptak er lastet inn» | «Viser N av M rader» med like tall | Skjermen viser «47 rader i listen». 47 rader i DOM-en, ingen «Last inn flere» |
| 12 | OVE «… : søk på navnet på nynorsk» | Søket prøver noe annet enn bokmål | Navnet på nynorsk er det samme som på bokmål, så eksemplet prøver ikke noe nytt |

## Ikke testet

Testansvarlig vurderer begrunnelsene før beslutningen.

| Nr | Scenario | Begrunnelse |
|---|---|---|
| 1 | GRU «Opprette et lokalt opptak» | `regelverkssamling-lokalt` mangler i miljøfila |
| 2 | SAM «… : organisasjon som allerede er lagt til» | `opptak-samordna-med-utdanningstilbud` ble ikke laget |
| 3 | SAM «Organisasjon som ikke deltar kan ikke legge til utdanningstilbud» | Som over |
| 4 | SAM «Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket» | Som over |
| 5 | SAM «Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger» | `regelverkssamling-samordna-annen` mangler i miljøfila |
| 6 | SAM «Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger» | `opptak-samordna-med-utdanningstilbud` ble ikke laget |
| 7 | SAM «Lokalt opptak tillater ikke andre organisasjoner» | `opptak-lokalt` ble ikke laget |
| 8 | SAM «Saksbehandlertildeling er ikke relevant for lokale opptak» | Som over |
| 9 | INN «Kan ikke endre opptakstype når utdanningstilbud er knyttet til opptaket» | `opptak-samordna-med-utdanningstilbud` ble ikke laget |
| 10 | INN «Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket» | `regelverkssamling-samordna-annen` mangler i miljøfila |
| 11 | INN «Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket» | `opptak-samordna-med-utdanningstilbud` ble ikke laget |
| 12 | INN «… : kan ikke slås av når et utdanningstilbud tilbyr tidlig opptak» | `opptak-samordna-tilbud-med-tidlig-opptak` ble ikke laget |
| 13 | INN «Legge til utdanningsbakgrunner fra godkjent liste» | «Utenlandsk utdanning» og «Steinerskole» (miljøfila) finnes ikke i TEST |
| 14 | INN «Legge til flere utdanningsbakgrunner» | Som over |
| 15 | INN «Utdanningsbakgrunn som søkere har valgt, kan ikke fjernes» | `opptak-utdanningsbakgrunn-valgt-av-soker` mangler i miljøfila (krever en søknad i Min kompetanse) |
| 16–24 | OVE «Se liste over opptak», «Liste er sortert etter når opptaket ble opprettet som standard», «Velge sorteringsretning for <felt>» (6 eksempler) og «… : rekkefølgen etter sortering på organisasjon» | `opptak-oversikt-flere-typer` ble ikke laget, fordi `opptak-lokalt` mangler |
| 25–26 | OVE «Filtrere på opptakstype» og «Kombinere filtre» | Som over |
| 27–28 | OVE «Liste viser de 50 første opptakene» og «Laste inn 50 flere opptak» | `opptak-oversikt-over-50` finnes ikke: testbrukeren ser 47 opptak (kjent fra testplanen) |

Talt: 1 + 7 + 7 + 13 = 28. Rad 16–24 er 9 testcaser (2 + 6 eksempler + 1).

## Funn

Sortert som i resultatet, siden ingen har alvorlighetsgrad ennå. «Fase funnet» er 2. «Kravet dekker ikke» avklares i kravet, ikke bare i testen.

| # | Fase funnet | Testcase | Type | Hva skjedde | Alvorlighetsgrad | Sak | Oppfølging |
|---|---|---|---|---|---|---|---|
| F1 | 2 | SAM «Organisasjon som ikke deltar, kan ikke åpne opptaket» | Feil | En organisasjon som ikke deltar, ser hele siden til et samordna opptak via adressen. Lesingen er åpen også for fristene og deltakerlista (`V280:1054-1055,1080-1081,1105-1106`) | [Fylles ut av testansvarlig] | [Fylles ut av teamet] | Feil i løsningen: teamet lager oppgave (kjent fra verifiseringen 28.10) |
| F2 | 2 | FRI «Opptaket kan ikke lagres uten fristen for å trekke utdanningstilbud» | Feil | Trekkfristen er valgfri i FS Admin og API-et. TAKE-436 er «Won't do», men koden sier fortsatt «Optional until TAKE-436», og en branch i fs-plattform fjerner fristen | [Fylles ut av testansvarlig] | [Fylles ut av teamet] | Feil i løsningen: teamet lager oppgave, og branchen `feature/take-436-fjern-trekkfrist` avklares |
| F3 | 2 | FRI «Varsel når fristen for å trekke utdanningstilbud er før redigeringen stenger» | Feil | Ingen varsel | [Fylles ut av testansvarlig] | [Fylles ut av teamet] | Feil i løsningen: delvis i MR !6450 (begge fristene har samme rekkefølge, 9, så de sammenlignes ikke) |
| F4 | 2 | FRI «Sette første svarfrist som informasjon til søkere» | Feil | Feltet finnes ikke på opptaket. Svarfristen finnes på hovedrunden | [Fylles ut av testansvarlig] | TAKE-414 (Backlog) | Avhenger av det åpne spørsmålet Q19. `fs-krav`: er første svarfrist svarfristen på hovedrunden, eller en dato på opptaket? |
| F5 | 2 | INN «Startnummeret er 1 når opptaksforvalter ikke har satt det» | Feil | Et tømt startnummer lagres tomt | [Fylles ut av testansvarlig] | MR !6415 | Feil i løsningen: MR !6415 (migrasjonen må nummereres om) |
| F6 | 2 | FRI «Opptaket kan ikke lagres uten <frist>» (10 eksempler) | Feil (i resultatet) | Et tømt obligatorisk felt får forrige verdi tilbake, så banneret vises aldri. Sperren finnes i koden (verifiseringen 15:02: funnet) | [Fylles ut av testansvarlig] | – | Testcasen var feil: `fs-testcaser-cdp` bruker «Tøm alle datoer» eller et nytt opptak. At forrige verdi kommer tilbake uten melding, er en regel uten scenario (`fs-krav`) |
| F7 | 2 | INN «… : ugyldig startnummer «0»» og «… : 0 søknadsalternativer» | Kravet dekker ikke | Skjemaet godtar 0, og API-et avviser det med en generell melding, uten melding ved feltet | [Fylles ut av testansvarlig] | – | `fs-krav`: er minste verdi 1, og hvilken melding skal vises ved feltet? |
| F8 | 2 | INN «… : ugyldig startnummer «1,5»» og «… «abc»» | Kravet dekker ikke | Feltet fjerner det som ikke er siffer. «1,5» lagres som 15, og «abc» lagres uten startnummer, uten melding | [Fylles ut av testansvarlig] | – | `fs-krav`: er det ønsket at feltet stille fjerner tegn, eller skal det gi en melding? |
| F9 | 2 | GRU «… : opptakstypene i et lokalt opptak» | Kravet dekker ikke (i resultatet). Verifiseringen 15:02: sannsynlig feil i fs-admin | HYU er et valg i et lokalt opptak. Konstanten i fs-admin skjuler fortsatt FSU, som heter HYU etter V479, og enhetstesten mocker FSU | [Fylles ut av testansvarlig] | [Fylles ut av teamet] | Feil i løsningen (`OPPTAKSTYPE_KODER_SAMORDNA` i fs-admin). `fs-krav`: hvilke typer skal et lokalt opptak kunne ha (jf. `@OPT-OVO-GRU-003`)? |
| F10 | 2 | GRU «… : opptakstypene i et samordna opptak» og OVE «Tilgjengelige opptakstyper i filter» | Kravet dekker ikke | Fire typer i samordna opptak og fem koder i filteret, med navnene og kodene etter V479 | [Fylles ut av testansvarlig] | – | Testcasen var feil (utdatert etter TAKE-456): `fs-testcaser-cdp`. `fs-krav`: skal «Testopptak (teknisk)» være et valg, og skal filteret vise koden eller navnet? |
| F11 | 2 | FRI «… : dato som er delvis fylt ut» | Kravet dekker ikke | I et obligatorisk felt kommer forrige verdi tilbake uten melding. Meldingen gjelder bare valgfrie felt | [Fylles ut av testansvarlig] | – | Testcasen var feil: `fs-testcaser-cdp` bruker et valgfritt felt. `fs-krav`: skal et obligatorisk felt gi en melding? |
| F12 | 2 | (ingen test) «Inviter organisasjoner til samordningen» | Kravet dekker ikke | Lista har læresteder som er merket nedlagt i navnet | [Fylles ut av testansvarlig] | – | `fs-krav`: skal nedlagte læresteder kunne inviteres? (regel uten scenario i verifiseringen 28.10) |
| F13 | 2 | Oppsettet | Feil (i oppsettet og miljøfila) | Oppsettet laget 2 av 6 nøkler | [Fylles ut av testansvarlig] | – | Utenfor testen: verdiene fylles ut i `cdp-tester/_Miljøer/test.md` (forslagene står i resultatet), og oppsettet kjøres på nytt |
| F14 | 2 | (ingen test) «Opprett» på «Opptak» | Observasjon (universell utforming) | Lenken under «LOKALT OPPTAK» har ikke skjermlesertekst, og heter bare «Opprett» (WCAG 2.4.4) | [Fylles ut av testansvarlig] | – | Til fase 3, «Opplevelse og helhet» |

## Neste steg

1. **Testansvarlig** går gjennom rapporten og funnene, gir funnene alvorlighetsgrad, og tar stikkprøver av de beståtte etter en risikovurdering. Start med «Bestått, men faktisk resultat avviker».
2. **Testdata:** fyll ut de fire verdiene i miljøfila, og kjør oppsettet og de 28 «Ikke testet» på nytt (ny kjøring med `/cdp`).
3. **Testene:** oppdater testene med `fs-testcaser-cdp`: opptakstypene etter V479, «Opptaket kan ikke lagres uten <frist>», den delvise datoen, navnet i oppsettet, og ordene i «Endringer i testene» i resultatet.
4. **«Kravet dekker ikke»** (F7–F12): `fs-krav`, med spørsmålene i «Oppfølging».
5. **Feil i koden** (F1–F3, F5, F9): tilbake til teamet. F4 venter på Q19.
6. Når inngangskriteriet er oppfylt (ingen «Stopper» åpne, og testansvarlig har gått gjennom): `fs-testcaser-intern` lager testcasene for fase 3.

## Læring

Fylles ut etter det korte møtet mellom testerne og teamlederne.

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
- Testcaser som var feil eller uklare: F6, F10 og F11 (utdatert etter TAKE-456, et obligatorisk felt som ikke kan tømmes, og meldingen som bare gjelder valgfrie felt). Oppsettet og testen brukte samme navn på et opptak. Fire verdier i miljøfila var ikke fylt ut før kjøringen
- Regler uten scenario som burde vært i kravet: opptakstypene for samordna og lokalt opptak, minste verdi for startnummer og maks søknadsalternativer, bekreftelsen før et valg med frister slås av, og at kortene bare vises når valget er på (se «Regler uten scenario»)
