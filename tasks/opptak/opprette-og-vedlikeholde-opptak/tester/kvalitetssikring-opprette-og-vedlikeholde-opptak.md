# Kvalitetssikring i teamet – Opprette og vedlikeholde opptak

- **Oppgave**: [tasks/opptak/opprette-og-vedlikeholde-opptak](../oppgave.md)
- **Krav**: `@OPT-OVO-GRU-001` (`@implemented`, med en `@planned`-regel), `@OPT-OVO-SAM-001`, `@OPT-OVO-INN-001` og `@OPT-OVO-FRI-001` (`@in-progress`), slik de står i [sikt-no/fs#754](https://github.com/sikt-no/fs/pull/754), commit `0ee0b59` (19.10.2026, ikke merget)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5121048577
- **Laget**: 2026-10-19 av fs-akseptansetest

---

Sjekklista «Klar for akseptansetest» for intern akseptansetest 2. Den er teamets eget ansvar og sendes ikke til testerne. Minst én annen person enn den som utviklet saken går gjennom lista. Felt merket **[Fylles ut av teamet]** kan ikke ses i repoet.

| Felt | Innhold |
|---|---|
| Gått gjennom av | [Fylles ut av teamet] (en annen enn den som utviklet saken) |
| Dato | [Fylles ut av teamet] |
| Gjelder | Intern akseptansetest 2, etter intern akseptansetest 1 (19.10.2026) og kravendringene i [sikt-no/fs#754](https://github.com/sikt-no/fs/pull/754) |

## Saken og kravene

Informasjon til teamet og testansvarlig. Den står ikke på testsidene.

| Felt | Innhold |
|---|---|
| Sak | [sikt-no/fs#211](https://github.com/sikt-no/fs/issues/211) · Epic [TAKE-318](https://sikt.atlassian.net/browse/TAKE-318) |
| Krav | [opprett_opptak.feature](https://github.com/sikt-no/fs/blob/krav/opptak-akseptansetest/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) (`@OPT-OVO-GRU-001`, `@implemented`, med en `@planned`-regel), [samordna_opptak.feature](https://github.com/sikt-no/fs/blob/krav/opptak-akseptansetest/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) (`@OPT-OVO-SAM-001`), [innstillinger.feature](https://github.com/sikt-no/fs/blob/krav/opptak-akseptansetest/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) (`@OPT-OVO-INN-001`) og [frister_og_hendelser.feature](https://github.com/sikt-no/fs/blob/krav/opptak-akseptansetest/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) (`@OPT-OVO-FRI-001`), alle `@in-progress` unntatt den første. Versjonen i [sikt-no/fs#754](https://github.com/sikt-no/fs/pull/754), commit `0ee0b59` (ikke merget) |
| Endret siden runde 1 | Kravene sier nå at innstillingene og fristene settes og finnes på opptaket. Virkningen hos søkeren, i saksbehandlingen og for utdanningstilbudene står i andre krav. Nye scenarioer: utdanningsbakgrunner, poenglikhetsregel, antall søknadsalternativer og tak for utdanningstilbud må være satt for å lagre; fristene kan stå tomme; taket er forhåndsutfylt med 1; startnummeret er 1 når det ikke er satt; opptakstype og regelverkssamling kan endres når som helst, med varsel når utdanningstilbud mister reglene; den siste utdanningsbakgrunnen kan ikke fjernes; tidlig opptak krever søknadsfrist og dokumentasjonsfrist; en organisasjon som ikke deltar, kan ikke åpne opptaket; en deltaker med utdanningstilbud kan ikke fjernes; en deltaker ser alle innstillinger og frister |
| Berører andre team | Shinkansen (utdanningstilbud og redigeringsfristene), Puff (saksbehandlertildeling og fristen for endring av utdanningsbakgrunn), Min kompetanse (frister, tidlig opptak, dokumentasjonsopplasting), plasstildeling (publiseringsdato og tak for utdanningstilbud) |
| Teknisk | Samordna opptak ligger bak feature-flagget `opptak-opprett-samordna` (på i test) |
| Testdata mot kravene | Kravene bruker «Universitetet i Oslo» som deltaker og «NTNU» som organisasjon som ikke deltar. I testen er NTNU deltaker og Fagskolen Vestfold og Telemark organisasjonen som ikke deltar, fordi det er organisasjonene til testbrukerne |

### Viktige endringer fra FS-klienten

Til introen i testmøtet.

- Opptakstype er et fast kodeverk som bare brukes til kategorisering. Opptaket arver ikke innstillinger fra opptakstypen.
- Samordning er en egenskap ved opptaket: forvaltende organisasjon inviterer læresteder, og bare forvaltende organisasjon kan endre innstillinger, frister og regelverk.
- Utdanningsbakgrunn styrer avvikende frister, ikke hvem som kan søke.
- Standard poenglikhetsregel settes på opptaket, ikke på rangeringsregelverket.
- Fristene har klokkeslett, og kan stå tomme.
- Navnet på opptaket skal være på bokmål, nynorsk og engelsk. Samisk er valgfritt.

### Sporing fra testtilfelle til krav

| Intern 2 | Ekstern | Krav | Scenario |
|---|---|---|---|
| 1.1 | 1 | `@OPT-OVO-INN-001` | Taket er forhåndsutfylt med 1 · Opplasting er åpen når opptaksforvalter ikke har endret innstillingen |
| 1.2 | 1 | `@OPT-OVO-GRU-001`, `@OPT-OVO-FRI-001` | Opprette et samordna opptak · Lagre opptak med navn på alle obligatoriske språk · Lagre opptaket uten frister |
| 1.3a–d | – | `@OPT-OVO-GRU-001` | Lagre opptak uten utdanningsbakgrunner / standard poenglikhetsregel / maks antall søknadsalternativer / tak for utdanningstilbud |
| – | 2 | `@OPT-OVO-GRU-001` | Navn mangler på et obligatorisk språk (bestått i runde 1) |
| – | 3 | `@OPT-OVO-SAM-001` | Legge til lærested · Filtrere på universiteter og høyskoler · Filtrere på fagskoler |
| 2.1 | 4 | `@OPT-OVO-SAM-001` | Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket |
| – | 5 | `@OPT-OVO-SAM-001` | Sette regler for fordeling av søknader til saksbehandlerorganisasjoner (bestått i runde 1) |
| 3.1 | – | `@OPT-OVO-INN-001` | Endre opptakstype |
| 3.2 | 6 | `@OPT-OVO-INN-001`, `@OPT-OVO-SAM-001` | Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket · Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger |
| 3.3 | 7 | `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001` | Aktivere ledige studieplasser · de tre datoene for ledige studieplasser |
| 3.4 | 8 | `@OPT-OVO-INN-001` | Lenken må være satt når tidlig opptak er aktivert |
| 3.5a–b | – | `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten søknadsfristen / dokumentasjonsfristen for tidlig opptak |
| 3.6 | 9 | `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001` | Aktivere tidlig opptak · Sette lenke · Sette søknadsfrist, dokumentasjonsfrist og frist for poenggrenser for tidlig opptak |
| 3.7 | 10 | `@OPT-OVO-INN-001` | Stenge og åpne for dokumentasjonsopplasting |
| 3.8 | 10 | `@OPT-OVO-INN-001` | Startnummeret er 1 når det ikke er satt · Sette startnummer |
| 3.9 | – | `@OPT-OVO-INN-001` | Endre taket etter at opptaket er opprettet |
| 3.10–3.15 | 11 | `@OPT-OVO-FRI-001` | Redigering av utdanningstilbud · Søknadsdato · Ordinær søknadsfrist · Omprioriteringsfrist · Frist for sletting · Dokumentasjonsfrister · Frist for endring av utdanningsbakgrunn · Publisering av hovedopptaket |
| 3.16–3.17 | 12 | `@OPT-OVO-FRI-001` | Standarddato når datoen ikke er satt · Sette dato for aldersberegning |
| 3.18 | 13 | `@OPT-OVO-FRI-001` | Legge til utdanningsbakgrunn med avvikende frister |
| 4.1 | 14 | `@OPT-OVO-SAM-001` | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger |
| 4.2 | – | `@OPT-OVO-SAM-001` | Legge til lærested i samordna opptak |
| 5.1–5.2 | – | `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar, ser ikke opptaket · kan ikke åpne opptaket |
| 6.1 | – | `@OPT-OVO-SAM-001` | Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket |
| 6.2–6.3 | – | `@OPT-OVO-INN-001` | Varsel før regelverkssamlingen byttes · Bytte regelverkssamling når utdanningstilbud er knyttet til opptaket |
| 7.1 | – | `@OPT-OVO-GRU-001` | Opprette et lokalt opptak |
| 7.2 | – | `@OPT-OVO-INN-001` | Den siste utdanningsbakgrunnen kan ikke fjernes |

Ikke med i testene: «Sette første svarfrist som informasjon til søkere» (`@openquestion`, Q19), gjenbruk og deaktivering av opptak (`@draft @openquestion`), krav om studierett (`@draft`), og virkningene som står i andre krav (`@draft`-reglene for uløst arbeid i #754).

## 1. Kravene er dekket (funksjonell test)

| # | Sjekk | Status | Kilde |
|---|---|---|---|
| 1.1 | Hvert scenario i kravet er gått gjennom og bekreftet med `fs-verify` | Mangler. Siste verifisering er fra 15.10.2026 (24 funnet, 12 ikke funnet og 11 usikre av 47). Kravene er endret i #754 etter det, med nye scenarioer. Kjør `fs-verify` på nytt når #754 er merget | [verify-rapport 15.10.2026](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/verify-11%20Opprette%20og%20vedlikeholde%20opptak-2026-10-15-1402.md) |
| 1.2 | Ingen `@openquestion` gjenstår. Det som er bevisst utsatt, står beskrevet | OK, med ett unntak: «Sette første svarfrist som informasjon til søkere» er `@openquestion` (Q19). Den er ikke med i testen | `frister_og_hendelser.feature` |
| 1.3 | `@draft`-delene som ikke skal testes nå, er kjent for testansvarlig | OK: gjenbruke innstillinger fra et tidligere opptak, deaktivere opptak og krav om studierett. De står i «Ikke med i denne testen» | `opprett_opptak.feature`, `innstillinger.feature` |
| 1.4 | Kravendringene i #754 er merget før testen | [Fylles ut av teamet] | [sikt-no/fs#754](https://github.com/sikt-no/fs/pull/754) |

## 2. Helheten virker fortsatt (ende-til-ende-test)

| # | Sjekk | Status | Kilde |
|---|---|---|---|
| 2.1 | Teamet har kjørt den faste «gylne stien» med testdata: forberede opptak → søknadsregistrering → søknadsbehandling → etterbehandling | [Fylles ut av teamet] | |
| 2.2 | Det er sjekket hva saken påvirker hos andre team, og de berørte teamene er informert: Shinkansen (utdanningstilbud og redigeringsfristene), Puff (saksbehandlertildeling og fristen for endring av utdanningsbakgrunn), Min kompetanse (frister, tidlig opptak, dokumentasjonsopplasting), plasstildeling (publiseringsdato og tak for utdanningstilbud) | Teamene er kjent. Om de er informert om endringene i #754: [Fylles ut av teamet] | Intern akseptansetest 1, «Berører andre team?» |
| 2.3 | Kontrakter og grensesnitt mellom komponentene (GraphQL-skjema, API) er uendret, eller endringen er avklart med teamene som bruker dem | [Fylles ut av teamet] | |

## 3. Relevante brukergrupper er sjekket

| # | Sjekk | Status | Kilde |
|---|---|---|---|
| 3.1 | Funksjonen er testet med hver rolle i kravene: opptaksforvalter ved forvaltende organisasjon, opptaksforvalter ved deltakende organisasjon, opptaksforvalter ved en organisasjon som ikke deltar, og opptaksforvalter ved et lærested med lokalt opptak | [Fylles ut av teamet] | Rollene i kravene |
| 3.2 | Feilsituasjoner og grensetilfeller er prøvd: obligatoriske felt som mangler, tidlig opptak uten lenke og frister, siste utdanningsbakgrunn, deltaker med utdanningstilbud | [Fylles ut av teamet] | |

## 4. Teknisk grunnmur

| # | Sjekk | Status | Kilde |
|---|---|---|---|
| 4.1 | Automatiske tester er grønne i CI, og det er lagt til tester for det nye | [Fylles ut av teamet] | |
| 4.2 | Det som manglet i test 1, er deployet til test-fsadmin: endre opptakstype og regelverkssamling (TAKE-396), lenken til informasjon om tidlig opptak, og innstillingen for dokumentasjonsopplasting | Ifølge teamet 19.10.2026: ja. Bekreft i miljøet: [Fylles ut av teamet] | |
| 4.3 | Feilene i koden fra test 1 er rettet: fs-admin krever alle fristene, datoene for tidlig opptak må settes for å lagre ledige studieplasser, «Søker kan laste opp dokumenter» er ikke krysset av fra start, to koder for dokumentasjonsfristen for tidlig opptak, og en organisasjon som ikke deltar kan åpne siden til opptaket | [Fylles ut av teamet, per feil] | [sikt-no/fs#754](https://github.com/sikt-no/fs/pull/754), «Til review» |
| 4.4 | De nye scenarioene fra #754 er bygget: lagre uten utdanningsbakgrunner, poenglikhetsregel, antall søknadsalternativer eller tak; taket er forhåndsutfylt med 1; startnummer 1 når det ikke er satt; den siste utdanningsbakgrunnen kan ikke fjernes; varsel før regelverkssamlingen byttes; en deltaker med utdanningstilbud kan ikke fjernes; tidlig opptak krever søknadsfrist og dokumentasjonsfrist | [Fylles ut av teamet, per scenario]. Det som ikke er bygget, flyttes til «Ikke testbart nå» i den interne testen | |
| 4.5 | Testbrukere og testdata er klare (se kolonnene «Testbruker» og «Testdata» i den interne testen) | Testbrukerne fra test 1 brukes. Regelverkssamlingene, utdanningstilbudet til testbruker 2 og regelverket på utdanningstilbudet: [Fylles ut av teamet] | Intern akseptansetest 2 |
| 4.6 | Universell utforming er sjekket der det er nytt grensesnitt (tastatur, skjermleser), blant annet varselet før regelverkssamlingen byttes | [Fylles ut av teamet] | |

## 5. Overlevering

| # | Sjekk | Status | Kilde |
|---|---|---|---|
| 5.1 | Testdokumentet for intern akseptansetest 2 er laget og kvalitetssikret | OK, utkast 19.10.2026. Teamet fyller ut feltene merket [Fylles ut] og [Sjekk begrep] | `tester/akseptansetest-intern-opprette-og-vedlikeholde-opptak-2.md` |
| 5.2 | Siden er opprettet i Confluence | OK, under «Kvalitetssikring og akseptansetester "Opprette opptak"» | |
| 5.3 | Statusen i GitHub og Jira er oppdatert | [Fylles ut av teamet] | |
| 5.4 | Designer har sett over løsningen der det er relevant (varselet før regelverkssamlingen byttes, feltet for lenken til tidlig opptak) | [Fylles ut av teamet] | |

## Oppsummering

- **Klar for akseptansetest**: [Fylles ut av teamet] (Ja / Nei / Ja, med forbehold)
- **Mangler før testen**: #754 merget, ny `fs-verify`, svar på 4.2–4.5.
- **Det testerne ikke kan gjøre**: står i «Dette kan du ikke gjøre i testen» i den interne testen. Fyll ut det som ikke er i testmiljøet.
