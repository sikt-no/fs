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
| `@OPT-SØK-SØK-008` [trekke_søknad.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/trekke_s%C3%B8knad.feature) | Must | – | – | Ny regel: bare opptaksforvalter hos forvalteren trekker på søkerens vegne (svar 1) |
| `@OPT-BEH-BEH-043` [se_søknader_som_opptaksinformatør.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/se_s%C3%B8knader_som_opptaksinformat%C3%B8r.feature) | Must | – | [TAKE-469](https://sikt.atlassian.net/browse/TAKE-469) | Opptaksinformatør (OPPTAK_INNSYN), for førstelinjen |
| `@OPT-BEH-BEH-011` — Regel: Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet [tildele_saksbehandlende_organisasjon.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) | Must | – | – | R3. Ny regel ved siden av: organisasjoner uten tilknytning ser ikke saken. Forvalteren ser alle saker (svar 9) |
| `@OPT-BEH-DOK-001` [skjerme_dokumentasjon.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/03%20Dokumentasjon/skjerme_dokumentasjon.feature) | Must | – | – | R4. Dokumenter følger søknaden. Politiattest: innholdet ser bare behandleren, og tilbyderen etter ja-svar. Andre ser at den er levert (svar 12, 28) |
| `@OPT-BEH-BEH-001` [behandle_søknad.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/behandle_s%C3%B8knad.feature) | Must | – | [TAKE-470](https://sikt.atlassian.net/browse/TAKE-470) | Rettes: bare dokumentforvalter (OPPTAK_DOKUMENTASJON) hos forvalteren laster opp på søkerens vegne (svar 21) |
| `@OPT-SØK-SØK-010` [mine_meldinger.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/mine_meldinger.feature) | Must | – | – | R5. Meldinger til søkeren ses bare av organisasjoner med tilknytning |
| `@OPT-BEH-BEH-016` [hendelseslogg_for_saksbehandling.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/hendelseslogg_for_saksbehandling.feature) | Must | – | – | R13. Loggen har samme grense som det den logger. Ingen, heller ikke API-et, kan endre eller slette den |
| `@OPT-OVO-LOG-001` [hendelseslogg.feature](../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/06%20Hendelseslogg/hendelseslogg.feature) | Must | – | – | R13. Som over, for opptaket |
| `@OPT-PLA-RES-003` — Regel: Saksbehandler ser søknadene organisasjonen er saksbehandlende organisasjon for og søknadene til utdanningstilbudene organisasjonen tilbyr [se_publisert_resultat.feature](../../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/se_publisert_resultat.feature) | Must | – | – | R10. Rettes: saksbehandler ser resultatet også før publisering (svar 23). Søkertall bare for tilbud organisasjonen har (svar 26) |
| `@OPT-OVO-SAM-001` — Regel: I et lokalt opptak kan ikke andre organisasjoner legges til [samordna_opptak.feature](../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | Should | – | – | R7. API-et skal avvise det samme som FS Admin (svar 19, K1-081). Opptaket er lukket for andre til det er publisert |
| Nytt krav, ikke skrevet: brukere og integrasjoner uten roller | Should | – | – | R15. Bare publiserte data (svar 18). Bølge 2 |
| `@OPT-OPT-UTD-001` — Regel: Opptaksforvalter ved deltakende organisasjon ser kun utdanningstilbud organisasjonen tilbyr [listevisning_utdanningstilbud.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/listevisning_utdanningstilbud.feature) | Should | – | – | R8. Behandleren leser krav, poeng og kvoter på tilbudene den behandler. Ingen ser upubliserte tilbud uten tilknytning |
| `@OPT-REG-SAM-002` tilgang_til_regelverk.feature (PR 996) | Should | – | – | R9. Opptaksinformatører leser regelverket (svar 14). Saksbehandler bare ser (svar 17). Bare opptaksforvalter (MODIFISERE_REGELVERK) endrer |
| `@OPT-OPT-UTD-004` — Regel: Deltakende organisasjon kan ikke endre poenggrensen for tidlig opptak etter fristen [opptaksinnstillinger_utdanningstilbud.feature](../../../krav/02%20Opptak/12%20Utdanningstilbud/03%20Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature) | Should | – | – | R11. Poenggrenser er skjult for søkere og brukere uten roller til de er publisert. Tilbydere ser ikke hverandres poenggrenser for tidlig opptak |
| Nytt krav, ikke skrevet: interne og delte merknader | Should | – | – | R6. Delt er standard. Interne ses bare av organisasjonen som skrev dem (svar 10) |
| `@OPT-BEH-BEH-008` — Regel: Organisasjonene som behandler søknaden ser manglene i alle sakene, men endrer bare manglene i saken sin [søknadsmangler.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/s%C3%B8knadsmangler.feature) | Should | – | – | Rettes: interne og delte mangler (svar 10) |
| `@OPT-SØK-MEL-001` [sende_melding_til_søker.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/04%20Meldinger%20og%20oppgaver/sende_melding_til_s%C3%B8ker.feature) | Should | – | – | R5. Avsenderen velger per melding om den er intern. Delt er standard (svar 22) |
| `@OPT-BEH-BEH-004` [velge_vitnemål_som_grunnlag.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/velge_vitnem%C3%A5l_som_grunnlag.feature) | Should | – | – | Rettes (`@OPT-BEH-BEH-004`): behandlerne ser poengene i hverandres saker på samme søknad (svar 20) |
| `@OPT-BEH-BEH-010` [gi_tilbudsgaranti.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti.feature) | Should | – | – | R3. Saksbehandler hos behandleren eller tilbyderen. Forvalterens tilbudsgaranti settes bare maskinelt |
| `@OPT-BEH-BEH-042` (PR 1003) | Should | – | – | Én GSK-konklusjon per søker, på tvers av opptak. Alle behandlere kan endre den, og endringen logges (svar 4, 29) |
| Nytt krav, ikke skrevet: søkerens endringer | Should | – | – | R12. Søkeren trekker fram til plasstildeling, sletter opplastede dokumenter bare kort tid etter opplasting, og kan ikke endre resultatkoder eller behandler |
| Nytt krav, ikke skrevet: Sikt-brukerstøtte | Should | – | – | Eget spor: få navngitte ansatte, innsyn på tvers av organisasjoner for feilsøking, innsynet logges (svar 32) |
| Nytt krav, ikke skrevet: uttrekk av sakslista | Could | – | – | Formål og bekreftelse før uttrekk. Fødselsnummer bare når brukeren velger det. Saksbehandlere og opptaksforvaltere, ikke opptaksinformatører (svar 25, 30) |
| Nytt krav, ikke skrevet: sortering og filter i regelverksoversikten | Could | – | – | Regelverket ved brukerens organisasjon vises først (svar 16) |
| Nytt krav, ikke skrevet: tekster til søkere | Could | – | – | R16. Hvem ser og endrer tekster (svar 31) |
| `@OPT-OVO-GRU-001` — Regel: Opptaksforvalter kan deaktivere et opptak [opprett_opptak.feature](../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | Could | – | – | R14. Et deaktivert opptak kan leses, men ikke endres. Regelen er `Won't` i opprette-opptak-2027 |
| Nytt krav, ikke skrevet: se Min kompetanse som søkeren | Won't | – | – | Utenfor 2027 (svar 32) |
| Nytt krav, ikke skrevet: gjenbruk av enkeltelementer i regelverk | Won't | – | – | På sikt (svar 16) |

## Åpne spørsmål

- [ ] Skal rollebruken kunne leses maskinelt med taggen `@rolle-<slug>` (for eksempel `@rolle-opptak-forvalter`)? Tagger arves, så taggen settes på det høyeste nivået der den gjelder for alt under. Trengs det ikke, holder det at rollen står i teksten. Se *Tags → Roller* i `krav/README.md`. @matsgm avklarer.
- [ ] Alle krav skal si hvilken rolle som gjør handlingen, også de enkle. Hvordan og når rettes de kravene som ikke gjør det i dag? Det går på tvers av domener og er større enn dette scopet.
- [ ] Eier, team og Jira-epic for scopet.
- [ ] Frist: må bølge 1 være på plass før søknaden åpner for opptak 2027?
- [ ] Ferdig-kriterium: sikkerhetstest gjennom API-et, der en bruker og en integrasjon ved en organisasjon uten tilknytning ikke får noe fra noen av tabellene, i både samordna og lokalt opptak?
- [ ] Hvilke integrasjoner bruker den åpne tilgangen i dag (Politihøgskolen, NetNordic, analyseplattformen, utdanning.no), og hva slutter å virke når tilgangen strammes inn?
- [ ] Er tilgangene (grants) i RLS-oversikten de samme i produksjon?
- [ ] Skal personvernombudet vurdere om lekkasjen mellom læresteder i dag er et avvik?
- [ ] Hvilke handlingskoder gir rollene i tilgangsstyring i test og produksjon? Tabellen *Brukerroller i opptak* i `begreper.md` har bare MODIFISERE_REGELVERK (opptaksforvalter) og SE_SØKNAD (opptaksinformatør, foreløpig).
- [ ] Rollekatalogen: OPPTAK_INNSYN for opptaksinformatør (TAKE-469), OPPTAK_DOKUMENTASJON (TAKE-470), MODIFISERE_REGELVERK for opptaksforvalter, og egen lesekode hvis TAKE-360 blir valgt.
- [ ] Hvem ser og endrer generiske tekster (svar 31)?
- [ ] Testbrukere.
- [ ] Hvordan fortrolig adresse følger med når søkeren blir student (svar 3)?

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-10 | Rollen OPPTAK_INNSYN heter «opptaksinformatør» i kravene. Stegene bruker begrepet, rollekoden står i begrepslista | @karensikt | – |
| 2026-11-10 | `@tilgang` er erstattet av at alle krav sier rollen. Om `@rolle-<slug>` skal brukes, er åpent | @karensikt | – |
| 2026-11-10 | Opprettet fra avklaringsmøtet 2026-11-10. Lista over hva som mangler, er flyttet hit fra `krav/02 Opptak/tilgang.md` | @karensikt | – |
