---
issue: sikt-no/fs#455
related:
  - sikt-no/fs#31
  - sikt-no/fs#434
  - sikt-no/fs#435
  - sikt-no/fs#438
  - sikt-no/fs#439
  - sikt-no/fs#440
  - sikt-no/fs#441
  - sikt-no/fs#442
  - sikt-no/fs#443
  - sikt-no/fs#444
  - sikt-no/fs#445
  - sikt-no/fs#446
  - sikt-no/fs#447
status: draft
target: backend
from: fs-admin
---

# Hand-off til `backend`: SuperGrafen-schema utvidelse for Applikasjon-administrasjon (Iter 2 + 3)

## Kontekst

Initiativ [#31](https://github.com/sikt-no/fs/issues/31) leverer "Grunnleggende selvbetjent brukeradministrasjon for API-brukere via FS Admin". To iterasjoner i scope nå:

- **Iterasjon 2 (#434)** — Support: oversikt og passordbytte. Sub-issues: [#438](https://github.com/sikt-no/fs/issues/438), [#439](https://github.com/sikt-no/fs/issues/439), [#440](https://github.com/sikt-no/fs/issues/440), [#441](https://github.com/sikt-no/fs/issues/441), [#442](https://github.com/sikt-no/fs/issues/442), [#443](https://github.com/sikt-no/fs/issues/443).
- **Iterasjon 3 (#435)** — Grunnleggende tilgangsstyring for intern support. Sub-issues: [#444](https://github.com/sikt-no/fs/issues/444), [#445](https://github.com/sikt-no/fs/issues/445), [#446](https://github.com/sikt-no/fs/issues/446), [#447](https://github.com/sikt-no/fs/issues/447).

Krav er spesifisert som `.feature`-filer på branchen [`fruitbat`](https://github.com/sikt-no/fs/tree/fruitbat) i `sikt-no/fs`, under `krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/`. Filene har `# GitHub: #NNN` kommentar-markører som peker til sub-issues.

## Hvorfor blokkerer dette fs-admin

fs-admin har i dag UI for `Maskinbruker` (lesevisning, søk, passordbytte) bygd på dagens [`Maskinbruker`](https://github.com/sikt-no/fs/blob/fruitbat/...) GraphQL-type. Krav-modellen forutsetter en utvidet entitet (`Applikasjon`) med felter og operasjoner som ikke finnes i schemaet i dag. fs-admin kan derfor ikke implementere ~80 % av Iter 2 + Iter 3-funksjonaliteten før schemaet er utvidet, fordi:

- Apollo Client 4 er schema-styrt — vi kan ikke skrive queries/mutations mot felter som ikke finnes.
- `npm run compile` (codegen) ville feilet ved bygg.
- Stub-er på klient-siden ville maskere reelle integrasjons-problemer og duplisere modellering.

Vi kan parallellisere lokal komponent-arbeid (rename-skjelett, layout, bekreftelses-dialoger) mot et stub-schema, men reell levering krever upstream-schemaet ferdig.

## Hva som mangler i `schema.graphql` (per fruitbat)

Følgende er sjekket mot `schema.graphql` i `fs-admin`-repoet (Maskinbruker-typen rundt linje 19692, MaskinbrukereFilter rundt linje 19756, mutations rundt linje 20840):

### Felter på `Maskinbruker` (eller en ny `Applikasjon`-type)

| Felt | Type | Hvor kravet står | Hvorfor |
|---|---|---|---|
| `autentiseringstype` | enum `AutentiseringstypeApplikasjon { FS, Feide, Maskinporten }` | [`opprette_applikasjon.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature) Regel: "Opprettelse krever valg av autentiseringstype" | Driver all UI-forgrening: passordbytte gjelder kun FS, opprettelse verifiserer ID for Feide/Maskinporten. |
| `beskrivelse` | `String` (mutable) | [`rediger_beskrivelse.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/rediger_beskrivelse.feature) | Vises i listevisning + detaljside; redigerbar. |
| `ansvarlig` | union/objekt — Feide-bruker eller (@could) Feide-gruppe | [`administrere_ansvarlig.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/administrere_ansvarlig.feature) | Helt nytt konsept, separat fra eksisterende `kontaktperson`. Ansvarlig arver passordbytte-rett. Søk er begrenset til applikasjonens organisasjon. |
| `miljøer` | `[Miljø!]` (de miljøer applikasjonen er aktiv i) | [`se_detaljer.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/se_detaljer.feature) + listevisning | Vises som kolonne i liste og som datagruppe i detaljside. Avledet fra rolletilordninger? Eller egen modellering? |
| `aktiv` (eller `oppfølgingsstatus`) | `Boolean` / enum | [`deaktivere_applikasjon.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/deaktivere_applikasjon.feature) | Listevisning trenger "Oppfølgingsstatus"-kolonne; deaktivering må kunne skje uten at roller mistes. |
| Sporingsfelt: `opprettetAv`, `opprettetTidspunkt`, `endretAv`, `endretTidspunkt` | `Person`/`String` + `DateTime` | [`se_detaljer.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/se_detaljer.feature) Scenario: "Se sporingsinfo" | Direkte UI-krav i Iter 2; også fundament for Iter 4 endringslogg (#436, ikke i scope nå men nær). |

### Mutations

Foreslåtte signaturer er forhandlebare — backend kjenner schemaets stil bedre. Bruk dem som et utgangspunkt og endre etter konvensjon.

| Mutation | Brukervendt fra | Notes |
|---|---|---|
| `opprettApplikasjon(input: OpprettApplikasjonInput!): OpprettApplikasjonResultat` | [`opprette_applikasjon.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature) (#446) | Input forgrener på `autentiseringstype`. FS: visningsnavn + organisasjon. Feide/Maskinporten: ekstern ID + organisasjon, verifiseres mot kilden. Visningsnavn må være globalt unikt for FS. ID-er må være unike per type. |
| `deaktiverApplikasjon(input: DeaktiverApplikasjonInput!): DeaktiverApplikasjonResultat` | [`deaktivere_applikasjon.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/deaktivere_applikasjon.feature) (#447) | Reversibelt; bevarer roller, men gir ikke tilgang så lenge deaktivert. |
| `reaktiverApplikasjon(input: ReaktiverApplikasjonInput!): ReaktiverApplikasjonResultat` | samme | Symmetrisk. Krever bekreftelse i UI. |
| `tilordneRollerTilApplikasjon(input: TilordneRollerInput!): TilordneRollerResultat` | [`tilordne_rolle.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/tilordne_rolle.feature) (#444, #450) | Én operasjon kan tilordne flere roller i ett valgt miljø + valgt organisasjon. Server må håndheve at brukeren har rettighet til å tildele de valgte rollene. |
| `fjerneRollerFraApplikasjon(input: FjerneRollerInput!): FjerneRollerResultat` | [`fjerne_rolle.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/fjerne_rolle.feature) (#445, #451) | Bulk i ett miljø. Server håndhever at brukeren har rettighet til å fjerne de valgte rollene. |
| `settAnsvarligForApplikasjon(input: SettAnsvarligInput!): SettAnsvarligResultat` | [`administrere_ansvarlig.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/administrere_ansvarlig.feature) (#442) | Sett, endre, fjerne. Søk-skoping til applikasjonens organisasjon ligger i query, ikke mutation. |
| `redigerBeskrivelseForApplikasjon(input: RedigerBeskrivelseInput!): RedigerBeskrivelseResultat` | [`rediger_beskrivelse.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/rediger_beskrivelse.feature) (#443) | Trivielt; krever rettighet over applikasjonens organisasjon. |

`genererOgSettNyttPassord` finnes allerede ([`schema.graphql` linje 20840](https://github.com/sikt-no/fs/blob/fruitbat/) — sjekk fs-admin sin checkout). Den må utvides slik at den kun er tilgjengelig for applikasjoner med `autentiseringstype = FS` (server-håndhevd, ikke bare UI-gating).

### Filter / søk på `maskinbrukere`-query

Dagens `MaskinbrukereFilter` har bare `trengerPassordBytte: Boolean`. Krav forutsetter:

- Fritekst-søk på navn (server-side, ikke fuse.js på 1000 rader klient-side som i dag).
- Filter på organisasjon (per-org picker, ikke connection-status).
- @could: filter på rolle.
- Paginering 50 om gangen via `first: 50` + cursor — schemaet støtter `Connection`-mønsteret allerede, så dette er primært en søke-/filter-utvidelse.

### Permissions / rolle-modell

Krav refererer til to admin-roller som ikke finnes i koden i dag:

- `applikasjonsadministrator` — per organisasjon
- `super-applikasjonsadministrator` — globalt, ser alle applikasjoner inkl. de uten organisasjon

Forventet schema-fasade:

- `Me`-typen får felt for å si "har jeg disse rollene, og for hvilke organisasjoner". Brukes til å gate UI-knapper før mutation.
- Mutations server-håndhever rettigheten og returnerer typed feil-union ved mangel (jf. eksisterende mønster med `MeldStudentTilVurderingErrors`).
- Listevisning filtrerer server-side på synlighet (super ser alle, vanlig admin ser egne organisasjoner pluss applikasjoner med roller i egne organisasjoner — sistnevnte er en kryss-organisasjon-regel, se [`listevisning_og_sok.feature`](https://github.com/sikt-no/fs/blob/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature) Regel: "Synlighet styres av administrasjonsrettigheter").

### Eksterne integrasjoner

- **Feide-API**: ID-verifikasjon ved opprettelse av Feide-applikasjon, og bruker/gruppe-søk innen organisasjon for `ansvarlig`.
- **Maskinporten-API**: ID-verifikasjon ved opprettelse av Maskinporten-applikasjon. Sannsynligvis en ny ekstern integrasjon på backend-siden.

Hvor disse oppslagene gjøres (i fs-admin BFF, i SuperGrafen-resolver, eller direkte mot Feide/Maskinporten fra klient) er åpent — backend bør avgjøre med hensyn til auth-token-håndtering og caching.

## Forslått leveranse-rekkefølge

Hvis backend ønsker å pakke dette i flere PR-er, foreslås:

1. **Felter (lese-side):** `beskrivelse`, `miljøer`, `aktiv`, sporingsfelt, og synlighets-filtrering på `maskinbrukere`-query. Søke/filter-utvidelser. — Lar fs-admin levere det meste av Iter 2 lesevisning.
2. **`ansvarlig` + `redigerBeskrivelse` + `settAnsvarlig`:** resterende Iter 2-funksjonalitet.
3. **`autentiseringstype` + `opprettApplikasjon`:** åpner Iter 3 opprettelse.
4. **Rolle-mutations (`tilordneRoller`, `fjerneRoller`):** resten av Iter 3 tilgangsstyring.
5. **`deaktiverApplikasjon` + `reaktiverApplikasjon`:** Iter 3 livssyklus.
6. **Permissions-modell** (`Me`-utvidelser): kan landes hvor som helst men trengs før admin-gating slår til.

Rekkefølge er en anbefaling — backend velger selv.

## Acceptance shape (når er hand-offen "ferdig")

- Schema-changes er deployet til SuperGrafen (eller eksponert i fs-admin sin lokale `schema.graphql` via codegen).
- fs-admin sin `npm run compile` produserer typer for alle nye felter/mutations.
- Backend lukker den linkede issuen når changes er merged til main.
- (Bonus: en kort migrasjons-note hvis noe i eksisterende `Maskinbruker`-API skal deprekeres til fordel for nytt `Applikasjon`-API.)

## Åpne spørsmål backend bør avgjøre

- **Renaming på schema-nivå:** Skal typen `Maskinbruker` deprekeres og en ny `Applikasjon`-type innføres, eller utvides eksisterende `Maskinbruker` med nye felter? Begge har konsekvenser for fs-admin sin migrasjon.
- **`kontaktperson` vs `ansvarlig`:** Skal `kontaktperson` fjernes fra Maskinbruker-typen, eller leve videre ved siden av nytt `ansvarlig`-felt? Krav-tekstene snakker bare om ansvarlig.
- **Roller-modellen:** I dag har `Maskinbruker` to separate connections — `apiTilgangerV2` og `datatilganger`. Krav-modellen forventer én "roller"-flate (rolle × miljø). Skal disse slås sammen, eller eksponere en projisert union?
- **Sporings-felter:** Allerede modellert internt? Hvor mye Iter 4-endringslogg (#436) skal forskutteres nå?
- **Maskinporten-eierskap:** Hvor verifiseres Maskinporten-ID? Backend (resolver) eller fs-admin BFF?

## Referanser

- Initiativ: [#31](https://github.com/sikt-no/fs/issues/31)
- Iterasjons-parents: [#434](https://github.com/sikt-no/fs/issues/434), [#435](https://github.com/sikt-no/fs/issues/435)
- Sub-issues: [#438](https://github.com/sikt-no/fs/issues/438) – [#447](https://github.com/sikt-no/fs/issues/447), pluss referanse-issues [#448](https://github.com/sikt-no/fs/issues/448) – [#451](https://github.com/sikt-no/fs/issues/451)
- Krav-filer: `krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/01 Iterasjon 2.../` og `02 Iterasjon 3.../` på `fruitbat`
- fs-admin lokal analyse: `docs/ACTIVE/analysis-applikasjon-administrasjon-iter2-3.md` i `admissio-soknadsbehandling`-repoet (ikke i coord-repo)
