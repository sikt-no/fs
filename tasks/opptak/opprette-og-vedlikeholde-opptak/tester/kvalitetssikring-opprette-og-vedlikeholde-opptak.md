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
| 4.5 | Testbrukere og testdata er klare (se «Testbrukere» og «Testdata» i den interne testen) | Testbrukerne fra test 1 brukes. Regelverkssamlingene, utdanningstilbudet til testbruker 2 og regelverket på utdanningstilbudet: [Fylles ut av teamet] | Intern akseptansetest 2 |
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
- **Kjente begrensninger som testansvarlig må vite om**: står i testbeskrivelsen i den interne testen.
