# Scope: Tilgang i opptak

- **Slug**: tilgang-i-opptak-2027 (= navnet på mappa og taggen `@scope-tilgang-i-opptak-2027`)
- **Domene**: opptak (se [`../../README.md`](../../README.md#domener))
- **Initiativ**: –
- **Jira**: [TAKE-469](https://sikt.atlassian.net/browse/TAKE-469), [TAKE-470](https://sikt.atlassian.net/browse/TAKE-470)
- **Eier**: –
- **Siste oppdatering**: 2026-11-10

Rette tilgangen i opptak så den følger kravene: hvem som ser og endrer hva, i FS Admin, Min kompetanse og API-et. I dag er tilgangen for åpen, og personopplysninger lekker mellom læresteder.

## Mål

- **Must – personopplysninger (bølge 1):** En organisasjon ser ingenting om en søker uten å være forvalter, tilbyder eller behandler på søknaden. Det gjelder søknaden, personen, dokumentene, sakene, meldingene, resultatet og endringsloggen, i FS Admin og i API-et.
- **Should – åpne data og intern/delt (bølge 2):** Opptak, utdanningstilbud, regelverk og poenggrenser er lukket til de er publisert. Merknader, mangler og meldinger kan være interne.
- **Could – resten:** uttrekk av sakslista, tekster, deaktivert opptak og sortering i regelverksoversikten.
- Hvem som får gjøre hva, kan leses ut av funksjonskravene, ikke av egne tilgangsscenarioer.

## Ikke-mål

- Å se Min kompetanse slik søkeren ser den (svar 32).
- Gjenbruk av enkeltelementer i regelverk (svar 16).
- Statistikk på tvers av institusjoner. Den løses i analyseplattformen (svar 26).
- Forvaltning av roller og handlingskoder i tilgangsstyring. Det hører til `07 Brukeradministrasjon og tilgangsstyring`. Rollene scopet trenger, står under *Åpne spørsmål*.

## Kilder

- [Tilgangskrav mot RLS i opptak](https://claude.ai/artifact/DZKCewPChYJRYA29tVaxiX) — kartleggingen av kravene mot RLS, regel R1–R16 og spørsmål 1–82.
- [Confluence: 2026-11-10 Avklaringsmøte tilgangsregler opptak](https://sikt.atlassian.net/wiki/spaces/PFS/pages/5185372200) — de 32 svarene scopet bygger på. «Svar N» i tabellen viser hit.
- [Confluence: 2026-11-06 Oppfølgingsmøte tilgangsstyring opptak](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5176786948) — prinsippene og prioriteringen: personopplysninger først.
- [Confluence: Roller - nytt forslag 2026-10-12](https://sikt.atlassian.net/wiki/spaces/PFS/pages/5008457773) — rolleforslaget.
- [`krav/02 Opptak/begreper.md`](../../../krav/02%20Opptak/begreper.md) — forvalter, tilbyder, behandler, tilknytning, intern/delt.

## Krav

MoSCoW er et forslag ut fra møtet 2026-11-10 og må bekreftes av produkteier. Must er bølge 1 (personopplysninger), Should bølge 2. Rader uten Feature-ID er krav som ikke er skrevet ennå.

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| Nytt krav, ikke skrevet: tilgang til søknaden | Must | – | – | R1. En organisasjon ser søknaden bare når den er forvalter, tilbyder eller behandler på den. Gjelder også integrasjoner (svar 19). Bølge 1 |
| Nytt krav, ikke skrevet: tilgang til personopplysninger | Must | – | – | R2. Personer bare med tilknytning. Personsøk uten søknad bare for opptaksforvalter hos forvalteren (svar 2, 6). Fortrolig adresse bare for søkeren (svar 3). Kontaktinformasjon fra Folkeregisteret og KRR (svar 5). Bølge 1 |
| `@OPT-SØK-SØK-002` [opprette_søknad_for_person.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/opprette_s%C3%B8knad_for_person.feature) | Must | – | – | Bare opptaksforvalter hos forvalteren oppretter søknad på søkerens vegne (svar 1). Kravet er `@skip` |
| `@OPT-SØK-SØK-008` [trekke_søknad.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/trekke_s%C3%B8knad.feature) | Should | – | – | Søkerens egen trekking (R12). Trekking på søkerens vegne står i `@OPT-SØK-SØK-002` |
| `@OPT-BEH-BEH-043` [se_søknaden_til_en_søker.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/se_s%C3%B8knaden_til_en_s%C3%B8ker.feature) | Must | – | [TAKE-469](https://sikt.atlassian.net/browse/TAKE-469) | Se søknaden til en søker: R1 og R2 for opptaksforvalter, saksbehandler og opptaksinformatør (OPPTAK_INNSYN), med organisasjonens rolle i eksemplene. Skrevet 2026-11-10 |
| `@OPT-BEH-BEH-011` — Regel: Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet [tildele_saksbehandlende_organisasjon.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) | Must | – | – | R3. Ny regel ved siden av: organisasjoner uten tilknytning ser ikke saken. Forvalteren ser alle saker (svar 9) |
| `@OPT-BEH-DOK-001` [skjerme_dokumentasjon.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/03%20Dokumentasjon/skjerme_dokumentasjon.feature) | Must | – | – | R4. Dokumenter følger søknaden. Politiattest: innholdet ser bare behandleren, og tilbyderen etter ja-svar. Andre ser at den er levert (svar 12, 28) |
| `@OPT-BEH-BEH-001` [behandle_søknad.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/behandle_s%C3%B8knad.feature) | Must | – | [TAKE-470](https://sikt.atlassian.net/browse/TAKE-470) | Rettes: bare dokumentforvalter (OPPTAK_DOKUMENTASJON) hos forvalteren laster opp på søkerens vegne (svar 21) |
| `@OPT-SØK-SØK-010` [mine_meldinger.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/mine_meldinger.feature) | Must | – | – | R5. Meldinger til søkeren ses bare av organisasjoner med tilknytning |
| `@OPT-BEH-BEH-016` [hendelseslogg_for_saksbehandling.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/hendelseslogg_for_saksbehandling.feature) | Must | – | – | R13. Loggen har samme grense som det den logger. Ingen, heller ikke API-et, kan endre eller slette den |
| `@OPT-OVO-LOG-001` [hendelseslogg.feature](../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/06%20Hendelseslogg/hendelseslogg.feature) | Must | – | – | R13. Som over, for opptaket |
| `@OPT-PLA-RES-003` — Regel: Saksbehandler ser søknadene organisasjonen er saksbehandlende organisasjon for og søknadene til utdanningstilbudene organisasjonen tilbyr [se_publisert_resultat.feature](../../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/se_publisert_resultat.feature) | Must | – | – | R10. At saksbehandler ser resultatet før publisering (svar 23), står allerede i `@OPT-PLA-RES-001` (endret 2026-10-28). Lagt til: søkertallene følger tilknytningen (svar 26) |
| `@OPT-OVO-SAM-001` — Regel: I et lokalt opptak kan ikke andre organisasjoner legges til [samordna_opptak.feature](../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Should | – | – | R7. API-et skal avvise det samme som FS Admin (svar 19, K1-081). Opptaket er lukket for andre til det er publisert |
| Nytt krav, ikke skrevet: brukere og integrasjoner uten roller | Should | – | – | R15. Bare publiserte data (svar 18). Bølge 2 |
| `@OPT-OPT-UTD-001` — Regel: Opptaksforvalter ved deltakende organisasjon ser kun utdanningstilbud organisasjonen tilbyr [listevisning_utdanningstilbud.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/listevisning_utdanningstilbud.feature) | Should | – | – | R8. Behandleren leser krav, poeng og kvoter på tilbudene den behandler. Ingen ser upubliserte tilbud uten tilknytning |
| `@OPT-REG-SAM-002` tilgang_til_regelverk.feature (PR 996) | Should | – | – | R9. Opptaksinformatører leser regelverket (svar 14). Saksbehandler bare ser (svar 17). Bare opptaksforvalter (MODIFISERE_REGELVERK) endrer |
| `@OPT-OPT-UTD-004` — Regel: Deltakende organisasjon kan ikke endre poenggrensen for tidlig opptak etter fristen [opptaksinnstillinger_utdanningstilbud.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature) | Should | – | – | R11. Poenggrenser er skjult for søkere og brukere uten roller til de er publisert. Tilbydere ser ikke hverandres poenggrenser for tidlig opptak |
| Nytt krav, ikke skrevet: interne og delte merknader | Should | – | – | R6. Delt er standard. Interne ses bare av organisasjonen som skrev dem (svar 10) |
| `@OPT-BEH-BEH-008` — Regel: Organisasjonene som behandler søknaden ser manglene i alle sakene, men endrer bare manglene i saken sin [søknadsmangler.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/s%C3%B8knadsmangler.feature) | Should | – | – | Rettes: interne og delte mangler (svar 10) |
| `@OPT-SØK-MEL-001` [sende_melding_til_søker.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/04%20Meldinger%20og%20oppgaver/sende_melding_til_s%C3%B8ker.feature) | Should | – | – | R5. Avsenderen velger per melding om den er intern. Delt er standard (svar 22) |
| `@OPT-BEH-BEH-004` [velge_vitnemål_som_grunnlag.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/velge_vitnem%C3%A5l_som_grunnlag.feature) | Must | – | – | Rettes (`@OPT-BEH-BEH-004`): behandlerne ser poengene i hverandres saker på samme søknad (svar 20) |
| `@OPT-BEH-BEH-010` [gi_tilbudsgaranti.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti.feature) | Must | – | – | R3. Saksbehandler hos behandleren eller tilbyderen. Forvalterens tilbudsgaranti settes bare maskinelt |
| `@OPT-BEH-BEH-042` (PR 1003) | Must | – | – | Én GSK-konklusjon per søker, på tvers av opptak. Alle behandlere kan endre den, og endringen logges (svar 4, 29) |
| `@OPT-BEH-BEH-003` [registrere_praksis.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/registrere_praksis.feature) | Must | – | – | R3. Tilbyderen ser praksiskalkulatoren (svar 7b) |
| `@OPT-SØK-MEL-004` [se_kommunikasjon_med_søker.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/04%20Meldinger%20og%20oppgaver/se_kommunikasjon_med_s%C3%B8ker.feature) | Must | – | – | R5. Meldinger ses bare med tilknytning, interne bare av avsenderen (svar 11, 22) |
| Nytt krav, ikke skrevet: søkerens endringer | Should | – | – | R12. Søkeren trekker fram til plasstildeling, sletter opplastede dokumenter bare kort tid etter opplasting, og kan ikke endre resultatkoder eller behandler |
| Nytt krav, ikke skrevet: Sikt-brukerstøtte | Should | – | – | Eget spor: få navngitte ansatte, innsyn på tvers av organisasjoner for feilsøking, innsynet logges (svar 32) |
| Nytt krav, ikke skrevet: uttrekk av sakslista | Could | – | – | Formål og bekreftelse før uttrekk. Fødselsnummer bare når brukeren velger det. Saksbehandlere og opptaksforvaltere, ikke opptaksinformatører (svar 25, 30) |
| Nytt krav, ikke skrevet: sortering og filter i regelverksoversikten | Could | – | – | Regelverket ved brukerens organisasjon vises først (svar 16) |
| Nytt krav, ikke skrevet: tekster til søkere | Could | – | – | R16. Hvem ser og endrer tekster (svar 31) |
| `@OPT-OVO-GRU-001` — Regel: Opptaksforvalter kan deaktivere et opptak [opprett_opptak.feature](../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | Could | – | – | R14. Et deaktivert opptak kan leses, men ikke endres. Regelen er `Won't` i opprette-opptak-2027 |
| Nytt krav, ikke skrevet: se Min kompetanse som søkeren | Won't | – | – | Utenfor 2027 (svar 32) |
| Nytt krav, ikke skrevet: gjenbruk av enkeltelementer i regelverk | Won't | – | – | På sikt (svar 16) |

## Mangler i RLS og tilgangsstyring

Reglene R1–R16 i spec-en «Krav til RLS» er utledet fra kravene og svarene om hvem som ikke skal se hva. Med svarene 2026-11-10 er de sikre, unntatt tidsvinduet for sletting av dokumenter (R12) og generiske tekster (R16). Tabellen viser hva som er endret fra spec-en, og hva som må endres i RLS og tilgangsstyring.

«RLS i dag» er fra fs-plattform 8afd511759 (migrert til V457, kartlagt 04.11.2026), og må sjekkes på nytt (plan, steg 1). Rollene i tilgangsstyring er ikke lest fra test eller produksjon.

### Must – personopplysninger

| Regel | Endret 10.11 | RLS i dag | Endring i RLS | Tilgangsstyring |
|---|---|---|---|---|
| R1 Tilknytning åpner søknaden | Bare opptaksforvalter hos forvalteren leverer, endrer og trekker på søkerens vegne (svar 1) | SE_ eller MODIFISERE_SØKNADSBEHANDLING ved én organisasjon gir lesing og skriving av alle søknader i alle opptak | `har_tilgang` byttes med en sjekk mot tilknytningen: forvalter, tilbyder per alternativ og behandler per sak. Skriving på søkerens vegne bare for forvalteren | Opptaksforvalter må ha koden for å handle på søkerens vegne. Ikke kartlagt |
| R2 Persondata følger søknaden | Personsøk og oppslag uten søknad bare for opptaksforvalter hos forvalteren. Kontaktinformasjon fra Folkeregisteret og KRR. Fortrolig adresse bare for søkeren (svar 2, 3, 5, 6) | Én av fem koder ved én organisasjon, også SE_PLASSTILDELING, gir lesing og skriving av alle personer | `kan_lese_personer` byttes med tilknytning via søknadene. Egen gren for personsøk. Fortrolig adresse krever egen tabell med flagg, eller skjules i API-et | Kode for personsøk og oppslag. Ikke kartlagt |
| R3 Saken | Tilbyderen ser også praksiskalkulatoren (7b). Behandlerne ser poengene i hverandres saker (20). Én GSK-konklusjon per søker (4, 29) | Saken er bundet til organisasjonen, men 15 tabeller under den kan leses og 8 endres fra alle organisasjoner | Tabellene under saken går via saken. Lesegren for behandlere på samme søknad. Skrivegrenen for forvalterens tilbudsgaranti fjernes | Tilbudsgaranti-kodene: ikke kartlagt hvem som har dem |
| R4 Dokumenter | Innholdet i politiattesten ser bare behandleren, og tilbyderen etter ja-svar. Forvalteren og opptaksinformatøren ser at den er levert (12, 28). Bare dokumentforvalter laster opp på søkerens vegne (21) | Med søknadskode: alle dokumenter i alle opptak | Dokumentene bindes til tilknytningen. Dokumenttype for politiattest og egne grener | Dokumentforvalter (OPPTAK_DOKUMENTASJON) finnes ikke (TAKE-470) |
| R5 Meldinger | Delt er standard, intern velges per melding (22) | Koden ved én organisasjon gir alle innbokser. Avsenderen sjekkes ikke. Søkeren kan endre alle kolonner | Lesing via tilknytningen, interne bare for avsenderen. Sjekk av avsenderorganisasjon. Søkeren kan bare markere som lest | – |
| R10 Plasstildeling | Saksbehandler ser resultatet før publisering. Søkertall følger tilknytningen (23, 26) | Plasstildelingsrett hos en deltaker gir alle rader, også upubliserte. Publiserte svar kan leses i alle opptak | Deltakeren får bare rader der den er tilbyder eller behandler | – |
| R13 Endringslogg | – | Ingen RLS. API-rollen kan lese, endre og tømme loggen | RLS som speiler tabellen raden kom fra. API-rollen mister UPDATE, DELETE og TRUNCATE | – |
| Opptaksinformatør | Ny rolle (svar 7–15) | SE_SØKNAD gir lesing av alle søknader | Følger av R1 og R2 | OPPTAK_INNSYN finnes ikke (TAKE-469) |

### Should – åpne data og intern/delt

| Regel | Endret 10.11 | RLS i dag | Endring i RLS | Tilgangsstyring |
|---|---|---|---|---|
| R6 Interne merknader | Det samme skillet gjelder mangler (10) | Merknader kan skrives på andre organisasjoners saker. Interne merknader følger saken | Interne bare for organisasjonen som skrev dem. Skriving via saken | – |
| R7 Opptaket | – | Alle ser alle opptak hele tiden. Eieren kan endres | Eier, deltaker eller publisert. Eieren holdes fast | – |
| R8 Utdanningstilbud | – | Alle leser alle tilbud. Deltakere skriver for hverandre | Skriving bare for tilbyder og forvalter. Grenen for eieren av regelverket fjernes | – |
| R9 Regelverk | Opptaksinformatøren leser. Saksbehandler bare ser. Deling er lese og kopiere (14, 16, 17) | Alle innloggede leser alt. Fire tabeller uten RLS kan endres av alle | Lesing for ansatte med en opptaksrolle. RLS på de fire tabellene | MODIFISERE_REGELVERK for opptaksforvalter. Ikke kartlagt |
| R11 Poenggrenser | – | Alle ser alt, hele tiden | Skjult til publisering. Tilbydere ser ikke hverandres for tidlig opptak | – |
| R12 Søkeren | Skjulte poeng avklart (24). Tidsvinduet for sletting er ikke bestemt | Søkeren endrer alle kolonner i egne rader uten frist | Frister i WITH CHECK. Kolonner søkeren ikke kan endre | – |
| R15 Uten tilganger | Bare publiserte data, ingen særtilgang for utdanning.no (18) | Alle innloggede ser alle opptak, tilbud, kvoter, frister, poenggrenser og regelverk | Følger av R7, R8, R9 og R11 | Integrasjoner uten roller må kartlegges |
| Sikt-brukerstøtte | Eget spor (32) | – | – | Ny rolle med logging av innsyn |

### Could

| Regel | Endret 10.11 | RLS i dag | Endring i RLS | Tilgangsstyring |
|---|---|---|---|---|
| R14 Deaktivert opptak | – | Ingen policy ser på status | Skrivegrenene krever aktivt opptak | – |
| R16 Tekster | Tekster til søkere avklart. Generiske tekster ikke avklart (31) | Ikke kartlagt | Skrivegren for tilbyder og behandler | – |
| Uttrekk av sakslista | Ny (25, 30) | – | – | – |

## Plan

1. **Sjekk RLS mot fs-plattform i dag.** Oppdater «RLS i dag» over. Lars.
2. **Kravene for Must inn i krav-repoet** (tabellen under), med rollebegrepene i stegene og relasjonen (forvalter, tilbyder, behandler) i eksemplene. Reglene og scenarioene utledes fra spec-en og svarene 10.11.
3. **Valider kravene for Must** med `fs-krav`, så de blir `@planned`.
4. **Tilgangsstyring:** opprett OPPTAK_INNSYN (TAKE-469) og OPPTAK_DOKUMENTASJON (TAKE-470), gi opptaksforvalter MODIFISERE_REGELVERK, og les hvilke handlingskoder rollene gir i test og produksjon.
5. **RLS-workshop** med Alf og utviklerne på opptak: fordel arbeidet.
6. **Implementer Must.** Ferdig når en sikkerhetstest gjennom API-et viser at en bruker og en integrasjon ved en organisasjon uten tilknytning ikke får noe, i både samordna og lokalt opptak.
7. **Kravene for Should inn i krav-repoet**, valider og implementer. Deretter Could.

Ved siden av: kartlegg integrasjonene som bruker den åpne tilgangen (før steg 6), og avklar med personvernombudet om lekkasjen i dag er et avvik.

### Kravene som skal inn i krav-repoet

Flere av kravene hører til andre scopes. Reglene legges inn der, og scopet her viser til dem. Eierne av de andre scopene må vite om det.

| Regel | Kravfil | Hva som legges inn | MoSCoW |
|---|---|---|---|
| R1 | `@OPT-BEH-BEH-043` se_søknaden_til_en_søker.feature | Gjort om fra OPPTAK_INNSYN-kravet til «Se søknaden til en søker» for alle rollene, med organisasjonens rolle i eksemplene. ✅ Skrevet | Must |
| R1 | `@OPT-SØK-SØK-002` opprette_søknad_for_person.feature | Bare opptaksforvalter hos forvalteren oppretter søknad på søkerens vegne. ✅ Skrevet | Must |
| R1 | `@OPT-SØK-SØK-002` opprette_søknad_for_person.feature | Bare opptaksforvalter hos forvalteren trekker på søkerens vegne. Kravet heter nå «Opprette, endre og trekke søknad på søkerens vegne», fordi `@OPT-SØK-SØK-008` handler om søkeren selv. ✅ Skrevet | Must |
| R2 | `@OPT-SØK-SØK-002` opprette_søknad_for_person.feature | Personsøk og oppslag i Folkeregisteret bare for opptaksforvalter hos forvalteren. Hva søket viser. ✅ Skrevet | Must |
| R2 | `@OPT-BEH-BEH-043` se_søknaden_til_en_søker.feature | Personopplysninger bare med tilknytning. Fortrolig adresse bare for søkeren. Kontaktinformasjon fra Folkeregisteret og KRR. ✅ Skrevet | Must |
| R3 | `@OPT-BEH-BEH-011` tildele_saksbehandlende_organisasjon.feature | Andre organisasjoner ser ikke saken. Forvalteren ser alle saker. Den gamle behandleren mister innsynet når saken flyttes, med mindre den er tilbyder. ✅ Skrevet | Must |
| R3 | `@OPT-BEH-BEH-004` velge_vitnemål_som_grunnlag.feature | Ingen motstrid: grunnlaget i egen sak viser bare egne poengvarianter, og innsynet i de andre sakene står i `@OPT-BEH-BEH-011`. Kommentar lagt inn. ✅ Skrevet | Must |
| R3 | `@OPT-BEH-BEH-003` registrere_praksis.feature | Tilbyderen ser praksiskalkulatoren. ✅ Skrevet | Must |
| R3 | `@OPT-BEH-BEH-010` gi_tilbudsgaranti.feature | Forvalterens tilbudsgaranti settes bare maskinelt. ✅ Skrevet | Must |
| R3 | `@OPT-BEH-BEH-042` (PR 1003) | Én GSK-konklusjon per søker. Alle behandlere kan endre den, og endringen logges | Must |
| R4 | `@OPT-BEH-DOK-001` skjerme_dokumentasjon.feature | Dokumentene følger søknaden. Politiattesten: innholdet bare for behandleren og tilbyderen etter ja-svar. ✅ Skrevet | Must |
| R4 | `@OPT-BEH-BEH-001` behandle_søknad.feature | Rettes: bare dokumentforvalter hos forvalteren laster opp på søkerens vegne. ✅ Skrevet | Must |
| R5 | `@OPT-SØK-MEL-004` se_kommunikasjon_med_søker.feature | Meldinger ses bare med tilknytning, interne bare av avsenderen. ✅ Skrevet | Must |
| R5 | `@OPT-SØK-SØK-010` mine_meldinger.feature | Søkeren leser meldingene, men endrer dem ikke. ✅ Skrevet | Must |
| R10 | `@OPT-PLA-RES-003` se_publisert_resultat.feature | Søkertallene følger tilknytningen. Resultatet før publisering står allerede i `@OPT-PLA-RES-001`. ✅ Skrevet | Must |
| R13 | `@OPT-BEH-BEH-016` hendelseslogg_for_saksbehandling.feature, `@OPT-OVO-LOG-001` hendelseslogg.feature | Loggen har samme grense som det den logger. Ingen kan endre eller slette den. Søkeren ser organisasjonen, ikke saksbehandleren. ✅ Skrevet | Must |
| R5 | `@OPT-SØK-MEL-001` sende_melding_til_søker.feature | Avsenderen velger per melding om den er intern. Delt er standard | Should |
| R6 | Nytt krav: merknader i saken | Delte og interne merknader. Interne bare for organisasjonen som skrev dem | Should |
| R6 | `@OPT-BEH-BEH-008` søknadsmangler.feature | Rettes: interne og delte mangler | Should |
| R7 | `@OPT-OVO-SAM-001` samordna_opptak.feature, `@OPT-OVO-GRU-001` opprett_opptak.feature | Opptaket er lukket til det er publisert. Eieren kan ikke endres. API-et avviser det samme som FS Admin (K1-081) | Should |
| R8 | `@OPT-OPT-UTD-001` listevisning_utdanningstilbud.feature | Behandleren leser krav, poeng og kvoter på tilbudene den behandler | Should |
| R9 | `@OPT-REG-SAM-002` (PR 996) | Opptaksinformatøren leser regelverket. Saksbehandler bare ser. Bør flyttes inn i `@OPT-REG-SAM-001`, etter README-en | Should |
| R11 | `@OPT-OPT-UTD-004`, `@OPT-OPT-UTD-029` | Skjult til publisering. Tilbydere ser ikke hverandres poenggrenser for tidlig opptak | Should |
| R12 | `@OPT-SØK-SØK-008` trekke_søknad.feature, `@OPT-SØK-SØK-019` håndtere_dokumentasjon_i_søknad.feature, `@OPT-SØK-SØK-007` svare_på_tilbud.feature | Trekke fram til plasstildeling. Slette dokumenter bare kort tid etter opplasting. Søkeren endrer ikke resultatkoder eller behandler | Should |
| R15 | `@OPT-SØK-SØK-013` finne_studier.feature, `@OPT-SØK-SØK-015` se_utdanningstilbud.feature | Brukere og integrasjoner uten roller ser bare publiserte data | Should |
| Sikt-brukerstøtte | Nytt krav i `07 Brukeradministrasjon og tilgangsstyring` | Rolle med innsyn på tvers og logging | Should |
| R14 | `@OPT-OVO-GRU-001` opprett_opptak.feature | Et deaktivert opptak kan leses, men ikke endres | Could |
| R16 | `@OPT-SØK-MEL-001` sende_melding_til_søker.feature | Hvem ser og endrer tekster til søkere | Could |
| Uttrekk | Nytt krav: ta ut sakslista | Formål, bekreftelse og fødselsnummer som aktivt valg. Saksbehandlere og opptaksforvaltere | Could |
| Sortering | `@OPT-REG-SAM-001` regelverkssamling.feature | Regelverket ved brukerens organisasjon vises først | Could |

## Åpne spørsmål

- [ ] Skal rollebruken kunne leses maskinelt med taggen `@rolle-<slug>` (for eksempel `@rolle-opptak-forvalter`)? Tagger arves, så taggen settes på det høyeste nivået der den gjelder for alt under. Trengs det ikke, holder det at rollen står i teksten. Se *Tags → Roller* i `krav/README.md`. @matsgm avklarer.
- [ ] Alle krav skal si hvilken rolle som gjør handlingen, også de enkle. Hvordan og når rettes de kravene som ikke gjør det i dag? Det går på tvers av domener og er større enn dette scopet.
- [ ] Eier, team og Jira-epic for scopet.
- [ ] Frist: må bølge 1 være på plass før søknaden åpner for opptak 2027?
- [ ] Ferdig-kriterium: sikkerhetstest gjennom API-et, der en bruker og en integrasjon ved en organisasjon uten tilknytning ikke får noe fra noen av tabellene, i både samordna og lokalt opptak?
- [ ] Hvilke integrasjoner bruker den åpne tilgangen i dag (Politihøgskolen, NetNordic, analyseplattformen, utdanning.no), og hva slutter å virke når tilgangen strammes inn?
- [ ] Er tilgangene (grants) i RLS-oversikten de samme i produksjon?
- [ ] Skal personvernombudet vurdere om lekkasjen mellom læresteder i dag er et avvik?
- [x] `@OPT-BEH-BEH-043` er gjort om til «Se søknaden til en søker», for alle rollene som ser søknaden (2026-11-10).
- [ ] Hvor lenge kan søkeren slette et opplastet dokument (R12)? I dag to timer, kanskje én.
- [ ] Hvilke handlingskoder gir rollene i tilgangsstyring i test og produksjon? Tabellen *Brukerroller i opptak* i `begreper.md` har bare MODIFISERE_REGELVERK (opptaksforvalter) og SE_SØKNAD (opptaksinformatør, foreløpig).
- [ ] Rollekatalogen: OPPTAK_INNSYN for opptaksinformatør (TAKE-469), OPPTAK_DOKUMENTASJON (TAKE-470), MODIFISERE_REGELVERK for opptaksforvalter, og egen lesekode hvis TAKE-360 blir valgt.
- [ ] Hvem ser og endrer generiske tekster (svar 31)?
- [ ] Testbrukere.
- [ ] Hvordan fortrolig adresse følger med når søkeren blir student (svar 3)?

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-10 | Reglene for Must er skrevet inn i kravfilene (`@draft`), unntatt GSK-konklusjonen, som hører til PR 1003 | @karensikt | – |
| 2026-11-10 | *Mangler* følger nå R1–R16 i spec-en, med endringene 10.11. Ny *Plan*, med kravene som skal inn i krav-repoet | @karensikt | – |
| 2026-11-10 | Lagt til *Mangler i krav, RLS og tilgangsstyring* som grunnlag for scopediskusjon | @karensikt | – |
| 2026-11-10 | Rollen OPPTAK_INNSYN heter «opptaksinformatør» i kravene. Stegene bruker begrepet, rollekoden står i begrepslista | @karensikt | – |
| 2026-11-10 | `@tilgang` er erstattet av at alle krav sier rollen. Om `@rolle-<slug>` skal brukes, er åpent | @karensikt | – |
| 2026-11-10 | Opprettet fra avklaringsmøtet 2026-11-10. Lista over hva som mangler, er flyttet hit fra `krav/02 Opptak/tilgang.md` | @karensikt | – |
