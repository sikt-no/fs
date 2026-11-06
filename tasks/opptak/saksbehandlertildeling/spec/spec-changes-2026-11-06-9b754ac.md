# Delta-spec: Saksbehandleren og tilbyderen ser hele søknaden og dokumentene — 2026-11-06-9b754ac

> Eksisterende krav som ikke er nevnt i denne delta-en forblir gjeldende. Endringer her erstatter eller utvider tidligere krav på de berørte områdene.

## Kilde

- **Scope:** `tasks/opptak/saksbehandlertildeling/`
- **Type:** `commit`
- **Commit:** [`9b754ac40dee54380a1db3afbd0bdaff29f310a1`](https://github.com/sikt-no/fs/commit/9b754ac40dee54380a1db3afbd0bdaff29f310a1), parent `75e18722fda2aeed2633f4239c1b344868a6c022` (branchen `krav/saksbehandlertildeling-v2`, PR #936)
- **Lokalt:** `git diff 75e18722fda2aeed2633f4239c1b344868a6c022...9b754ac40dee54380a1db3afbd0bdaff29f310a1 -- krav/`
- **Hentet:** 2026-11-06 08:47

## Omfang

Fem tillegg i et levert krav, fra funnene i den interne akseptansetesten 05.11.2026. Saksbehandleren og tilbyderen ser alle søknadsalternativene på søknaden når de står i en sak, med prioritet, tilbyder og saksbehandlende organisasjon, men saksbehandlingen bare for sine egne. De ser også dokumentene søkeren har lastet opp, og den nye organisasjonen ser dem etter at et søknadsalternativ er flyttet. Lesemodusen i saken (det brukeren ikke har lov til, skal være skjult) er ikke med her, og følges opp i STEK-672.

## Krav

### Endret _(diff-status: `modified`)_

Egenskapen er fortsatt `@implemented`. De fem scenarioene er nye blokker (rene tillegg), og erstatter ingen levert del.

- **`tildele_saksbehandlende_organisasjon.feature` — Regel «Saksbehandlende organisasjon ser bare saker hos organisasjonen», scenario «Saksbehandleren ser alle søknadsalternativene på søknaden»** (`@OPT-BEH-BEH-011`) — saksbehandleren ser alle søknadsalternativene med prioritet, tilbyder og saksbehandlende organisasjon, men ikke saksbehandlingen av søknadsalternativene i andre saker. ([før](https://github.com/sikt-no/fs/blob/75e18722fda2aeed2633f4239c1b344868a6c022/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature)) · ([etter](https://github.com/sikt-no/fs/blob/9b754ac40dee54380a1db3afbd0bdaff29f310a1/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature)) ([krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature))
- **Samme regel, scenario «Saksbehandleren ser dokumentene søkeren har lastet opp»** (`@OPT-BEH-BEH-011`) — dokumentene søkeren har lastet opp til søknaden, vises i saken. Lenker som over.
- **Regel «Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak», scenario «Organisasjonen søknadsalternativet flyttes til, ser dokumentene søkeren har lastet opp»** (`@OPT-BEH-BEH-011`) — etter flytting ser saksbehandleren ved organisasjonen søknadsalternativet flyttes til, dokumentene søkeren har lastet opp. Lenker som over.
- **Regel «Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet», scenario «Tilbyderen ser alle søknadsalternativene på søknaden»** (`@OPT-BEH-BEH-011`) — tilbyderen ser alle søknadsalternativene med prioritet, tilbyder og saksbehandlende organisasjon, men saksbehandlingen bare for søknadsalternativene til utdanningstilbudene sine. Lenker som over.
- **Samme regel, scenario «Tilbyderen ser dokumentene søkeren har lastet opp»** (`@OPT-BEH-BEH-011`) — tilbyderen ser dokumentene, men kan ikke endre eller slette dem. Erstatter avklaringen 04.11.2026 i kommentaren under «Tilbyderen kan ikke endre saksbehandlingen» (tilbyderen ser ikke dokumentene). Lenker som over.

## Avhengigheter

- **`@OPT-OVO-FRI-001`** `frister_og_hendelser.feature` — `@in-progress`. Brukes av regelen «Søknadsalternativene flyttes …» (fristen for endring av utdanningsbakgrunn). Scenarioet om dokumenter etter flytting bruker ikke fristen. ([krav/02 Opptak/11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature](../../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature))

## Skisser

Ingen skisse foreløpig. Om det finnes skisser for hvordan alle søknadsalternativene og dokumentene skal vises i saken, er ikke avklart (se «Åpne spørsmål»).

## Implementasjonsdetaljer

Kravet har ingen fil med implementasjonsdetaljer (`tildele_saksbehandlende_organisasjon.design.md`). Brukeren valgte å hoppe over den for denne endringen: tilleggene gjelder den eksisterende saksvisningen i FS Admin.

## Kodesjekk

Bygger på verifiseringen 04.11.2026 (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/verify-tildele_saksbehandlende_organisasjon-2026-11-04-1317.md`) og den agentiske testen 05.11.2026. Ingen av de fem er bygget i dag:

- Tilbyderen ser bare egne rader i `sak_soknadsalternativ` (fs-plattform `V501__tilbyderoppslag_per_sak.sql:22-35`, testen `TilbyderSerSakenRLSIT.tilbyderSerBareEgneAlternativer`).
- Saksbehandleren ser bare søknadsalternativene i saken sin (RLS på sakens organisasjon, `V501:37-52`).
- Dokumentlesingen krever tilgang i saksdokumentets organisasjon, og har ingen gren for tilbyderen (`V499__dokument_rls_via_sak.sql:21-24`).
- Ved flytting blir saken søknadsalternativet flyttes fra, stående med dokumentene, og den nye saken får dem ikke (`BehandlertildelingService.flyttBehandlere`, javadoc).

Ingen krav er holdt tilbake.

## Jira

- **[STEK-612](https://sikt.atlassian.net/browse/STEK-612)** (T-rollen skal se saker i sakerV2) har beslutning 1 og 2: om tilbyderen skal se søkerens andre søknadsalternativer, og hvilke detaljer (vitnemål, poeng, kvoter, mangler, dokumentasjon). Kravet svarer nå: tilbyderen ser alle søknadsalternativene (ikke saksbehandlingen av de andre), og dokumentene søkeren har lastet opp. At tilbyderen ser saken, er levert i STEK-576.
- **[STEK-662](https://sikt.atlassian.net/browse/STEK-662)** (propager sakene når tildelingsjobben flytter et søknadsalternativ) gjelder samme flytting, men kompetanseregelverk, kravelementer og kvoter, ikke dokumentene.
- **[STEK-672](https://sikt.atlassian.net/browse/STEK-672)** (lesemodus i saken) er ikke med i denne spesifikasjonen, men berører de samme skjermene.
- **[STEK-675](https://sikt.atlassian.net/browse/STEK-675)** (laget 06.11.2026): saksbehandleren ser alle søknadsalternativene og dokumentene på søknaden, også etter flytting.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 …/tildele_saksbehandlende_organisasjon.feature` — Scenario: Organisasjonen søknadsalternativet flyttes til, ser dokumentene søkeren har lastet opp | `@planned` | `@in-progress` |
| `krav/02 …/tildele_saksbehandlende_organisasjon.feature` — Scenario: Saksbehandleren ser alle søknadsalternativene på søknaden | `@planned` | `@in-progress` |
| `krav/02 …/tildele_saksbehandlende_organisasjon.feature` — Scenario: Saksbehandleren ser dokumentene søkeren har lastet opp | `@planned` | `@in-progress` |
| `krav/02 …/tildele_saksbehandlende_organisasjon.feature` — Scenario: Tilbyderen ser alle søknadsalternativene på søknaden | `@planned` | `@in-progress` |
| `krav/02 …/tildele_saksbehandlende_organisasjon.feature` — Scenario: Tilbyderen ser dokumentene søkeren har lastet opp | `@planned` | `@in-progress` |

Egenskapen står som `@implemented`.

## Åpne spørsmål

- [ ] Finnes det skisser for hvordan alle søknadsalternativene og dokumentene skal vises i saken for saksbehandleren og tilbyderen? (Må undersøkes.)
- [ ] Personvern (fra STEK-612): når tilbyderen ser søknadsalternativer ved andre læresteder, bør valget begrunnes i migrasjonen, som i V329. Trengs en personvernvurdering før det bygges?
- [ ] Skal dokumentene flyttes til den nye saken ved flytting, eller vises fra søknaden uavhengig av saken? (Løsningsvalg for teamet. Kravet sier bare at den nye organisasjonen ser dem.)

## Rute

fs-plattform → fs-admin
