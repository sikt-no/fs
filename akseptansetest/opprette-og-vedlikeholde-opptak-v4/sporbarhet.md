# Sporbarhet – Opprette og vedlikeholde opptak v4

- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155553291
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5157978133
- **Laget**: 2026-10-30, flyttet ut av testplanen (versjon 4 ble laget 2026-10-29 av fs-testplan)
- **Oppdatert**: 2026-10-30 av fs-testrapport (fase 2, agentisk funksjonstest)

---

Sporbarhet per krav for «Opprette og vedlikeholde opptak», versjon 4. Raden følger scenarioet fra kravet til koden og til testen. «Kode (fase 1)» er resultatet og den første referansen fra verify-rapporten 28.10 (forkortelsene står der). «Testcase, teknikk og resultat (fase 2)» er fra [Testrapport – agentisk funksjonstest – Opprette og vedlikeholde opptak v4](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5158567942): foreslått status fra kjøringen 29.10.2026 13:22, ikke bekreftet av testansvarlig. Testplanen: [Testplan – Opprette og vedlikeholde opptak v4](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155553291).

| Krav | Scenario | Kode (fase 1) | Testcase, teknikk og resultat (fase 2) | Flyt (fase 3) |
|---|---|---|---|---|
| `@OPT-OVO-GRU-001` | Opprette et samordna opptak | funnet — `OOP:49-54` | Bestått (fra kravet) | |
| `@OPT-OVO-GRU-001` | Opprette et lokalt opptak | funnet — `OOP:88-100` | Ikke testet (fra kravet) | |
| `@OPT-OVO-GRU-001` | Lagre opptak uten navn | funnet — `AMP:188-199` | Bestått (fra kravet) | |
| `@OPT-OVO-GRU-001` | Lagre opptak uten regelverkssamling | funnet — `AMP:201-204` | Bestått (fra kravet) | |
| `@OPT-OVO-GRU-001` | Lagre opptak uten opptakstype | funnet — `AMP:200` | Bestått (fra kravet) | |
| `@OPT-OVO-GRU-001` | Lagre opptak uten <innstilling> | funnet — `AMP:205-208` | 3 bestått (fra kravet) | |
| `@OPT-OVO-GRU-001` | Angi opptaksnavn på flere språk | funnet — `OI:42-94` | Bestått (fra kravet) | |
| `@OPT-OVO-GRU-001` | Lagre opptak med navn på alle obligatoriske språk | funnet — `AMP:338-348` | Bestått (fra kravet) | |
| `@OPT-OVO-GRU-001` | Navn mangler på et obligatorisk språk | funnet — `AMP:188-199` | 3 bestått (fra kravet) | |
| `@OPT-OVO-SAM-001` | Legge til lærested i samordna opptak | funnet — `OM/Samordning/Samordning.tsx:72-101` | Bestått (fra kravet) | |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | funnet — `USS:148-158` | Ikke testet (fra kravet) | |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar, ser ikke opptaket | usikker — `OV/hooks/useGetOpptak.tsx:15-25` | Bestått (fra kravet) | |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar, kan ikke åpne opptaket | ikke funnet — `fs-admin/src/app/opptak/[id]/layout.tsx:34-39` | Ikke bestått (fra kravet) | |
| `@OPT-OVO-SAM-001` | Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket | funnet — `OOM:606-627` | Ikke testet (fra kravet) | |
| `@OPT-OVO-SAM-001` | Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket | funnet — `OM/Samordning/components/SamordnedeOrganisasjoner/SamordnedeOrganisasjoner.tsx:54-58` | Bestått (fra kravet) | |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger | funnet — `fs-admin/src/app/opptak/[id]/rediger/layout.tsx:52-55` | Ikke testet (fra kravet) | |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger | ikke funnet — `OD/OpptakDetails.tsx:89-98` | Ikke testet (fra kravet) | |
| `@OPT-OVO-SAM-001` | Lokalt opptak tillater ikke andre organisasjoner | funnet — `AMP:302-304,426-437` | Ikke testet (fra kravet) | |
| `@OPT-OVO-SAM-001` | Legge til organisasjon som finnes i utdanningsregisteret | funnet — `IOM.tsx:49-62` | Bestått (fra kravet) | |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til | funnet — `IOM.tsx:49-62` | Bestått (fra kravet) | |
| `@OPT-OVO-SAM-001` | Filtrere på universiteter og høyskoler | funnet — `…/OrganisasjonFilters/OrganisasjonFilters.tsx:60-66,97-103` | Bestått (fra kravet) | |
| `@OPT-OVO-SAM-001` | Filtrere på fagskoler | funnet | Bestått (fra kravet) | |
| `@OPT-OVO-SAM-001` | Se og navigere til saksbehandlertildelingen for opptaket | usikker — `OM/Samordning/Samordning.tsx:50-60` | Bestått (fra kravet) | |
| `@OPT-OVO-SAM-001` | Saksbehandlertildeling er ikke relevant for lokale opptak | funnet — `AMP:426` | Ikke testet (fra kravet) | |
| `@OPT-OVO-INN-001` | Endre opptakstype når ingen utdanningstilbud er knyttet til opptaket | funnet — `AOS:193-195,229-240` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Kan ikke endre opptakstype når utdanningstilbud er knyttet til opptaket | funnet — `AOS:195,239` | Ikke testet (fra kravet) | |
| `@OPT-OVO-INN-001` | Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket | funnet — `AOS:241-252` | Ikke testet (fra kravet) | |
| `@OPT-OVO-INN-001` | Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket | funnet — `OOM:229-231` | Ikke testet (fra kravet) | |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud | funnet — `AOS:303-334` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel uten mulighet for unntak | funnet — `ACI:105` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Sette startnummer for søknader i opptaket | funnet — `AOS:277-288` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Startnummeret er 1 når opptaksforvalter ikke har satt det | usikker — `AEO:30` | Ikke bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Sette maks antall søknadsalternativer | funnet — `AOS:289-301` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Aktivere tidlig opptak | funnet — `AOS:362-370` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Sette lenke til informasjon om tidlig opptak | funnet — `AOS:335-349` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Lenken må være satt når tidlig opptak er aktivert | funnet — `AMP:217-224` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Aktivere ledige studieplasser | funnet — `AOS:354-361` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Legge til utdanningsbakgrunner fra godkjent liste | funnet — `AOS:171-175` | Ikke testet (fra kravet) | |
| `@OPT-OVO-INN-001` | Legge til flere utdanningsbakgrunner | funnet — `AOS:255-272` | Ikke testet (fra kravet) | |
| `@OPT-OVO-INN-001` | Fjerne en utdanningsbakgrunn fra opptaket | funnet — `PU:72-74` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Utdanningsbakgrunn som søkere har valgt, kan ikke fjernes | funnet — `MIG/V429__soknad_utdanningsbakgrunn_fra_opptak_v2.sql:31-40` | Ikke testet (fra kravet) | |
| `@OPT-OVO-INN-001` | Den siste utdanningsbakgrunnen kan ikke fjernes | funnet — `AOS:266-270` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Opplasting er åpen når opptaksforvalter ikke har endret innstillingen | funnet — `AEO:26` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Åpne for dokumentasjonsopplasting | funnet — `AOS:371-377` | Bestått (fra kravet) | |
| `@OPT-OVO-INN-001` | Stenge for dokumentasjonsopplasting | funnet — `AOS:371-377` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette når redigering av utdanningstilbud åpner | funnet — `MIG/V444__opptakshendelse_kategorier_og_rekkefolge.sql:40` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette når redigering av utdanningstilbud stenger | funnet — `MIG/V444…:41` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette frist for å trekke utdanningstilbud | funnet — `MIG/V440__opptakshendelsestype_utdanningstilbud_trekk.sql:5` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten fristen for å trekke utdanningstilbud | ikke funnet — `KU:6-9` | Ikke bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Fristen for å trekke utdanningstilbud kan være samme dag som redigeringen stenger, eller senere | funnet — `AMP:233-256` | 2 bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Varsel når fristen for å trekke utdanningstilbud er før redigeringen stenger | ikke funnet | Ikke bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette søknadsdato | funnet — `MIG/V444…:42` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette ordinær søknadsfrist | funnet — `MIG/V444…:43` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette omprioriteringsfrist | funnet — `MIG/V444…:44` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette frist for sletting av søknadsalternativer | funnet — `MIG/V444…:45` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette informasjonsdato for dokumentasjon | funnet — `MIG/V444…:46` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette ettersendingsfrist | funnet — `MIG/V444…:47` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette informasjonsfrist for ledige studieplasser | funnet — `MIG/V444…:51` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser kan søkes | funnet — `MIG/V444…:52` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser stenger for søkning | funnet — `MIG/V444…:53` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette søknadsfrist for tidlig opptak | funnet — `MIG/V444…:48` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette dokumentasjonsfrist for tidlig opptak | funnet — `MIG/V444…:49` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten <frist> når tidlig opptak er aktivert | funnet — `FK:37,50-52` | 3 bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette frist for poenggrenser for tidlig opptak | funnet — `MIG/V444…:21-22,50` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette dato for når hovedopptaket publiseres og søker kan forvente svar | funnet — `MIG/V444…:57` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette første svarfrist som informasjon til søkere | ikke funnet — `OPS/HendelseInputValidering.java:28-38` | Ikke bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette dato for aldersberegning | funnet — `MIG/V444…:55` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Standarddato når datoen ikke er satt | funnet — `OPS/AldersberegningsdatoDefault.java:19-21,34-50` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Sette frist for endring av utdanningsbakgrunn | funnet — `MIG/V444…:54` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Legge til utdanningsbakgrunn med avvikende frister | funnet — `PU:67-112` | Bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten <frist> | funnet — `FK:36-39` | 10 ikke bestått (fra kravet, F6: testen nådde ikke tilstanden) | |
| `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten <frist> når ledige studieplasser er aktivert | funnet — `FK:38` | 3 bestått (fra kravet) | |
| `@OPT-OVO-FRI-001` | Dato for aldersberegning og avvikende frister kan stå tomme | funnet — `AMP:241` | Bestått (fra kravet) | |
| `@OPT-OVO-OVE-001` | Se liste over opptak | funnet — `OV/components/OpptakResultList/OpptakResultList.tsx:61-78` | Ikke testet (fra kravet) | |
| `@OPT-OVO-OVE-001` | Liste er sortert etter når opptaket ble opprettet som standard | funnet — `OV/hooks/useGetOpptakOverviewState.ts:11-14` | Ikke testet (fra kravet) | |
| `@OPT-OVO-OVE-001` | Velge sorteringsretning for <felt> | funnet — `OV/components/OpptakOrderBy/OpptakOrderBy.tsx:20,22,23` | 6 ikke testet (fra kravet, testdata) | |
| `@OPT-OVO-OVE-001` | Liste viser de 50 første opptakene | funnet — `useGetOpptakOverviewState.ts:15` | Ikke testet (fra kravet) | |
| `@OPT-OVO-OVE-001` | Laste inn 50 flere opptak | funnet — `OpptakResultList.tsx:29-31,45` | Ikke testet (fra kravet) | |
| `@OPT-OVO-OVE-001` | Alle opptak er lastet inn | funnet — `fs-admin/src/common/components/lists/components/ListBody/components/FetchMoreButton/FetchMoreButton.tsx:124` | Bestått (fra kravet) | |
| `@OPT-OVO-OVE-001` | Navigere til detaljside for opptak | funnet — `OpptakResultList.tsx:56-59` | Bestått (fra kravet) | |
| `@OPT-OVO-OVE-001` | Fritekst-søk på navn | funnet — `OV/components/filter/OpptakSearchFilter/OpptakSearchFilter.tsx:16-23` | Bestått (fra kravet) | |
| `@OPT-OVO-OVE-001` | Tilgjengelige opptakstyper i filter | funnet — `OV/components/filter/OpptakTypeFilter/OpptakTypeFilter.tsx:13-20,33-35,53` | Ikke bestått (fra kravet) | |
| `@OPT-OVO-OVE-001` | Filtrere på opptakstype | funnet — `OpptakTypeFilter.tsx:37-40,49-59` | Ikke testet (fra kravet) | |
| `@OPT-OVO-OVE-001` | Kombinere filtre | funnet — `useGetOpptak.tsx:21-26` | Ikke testet (fra kravet) | |
