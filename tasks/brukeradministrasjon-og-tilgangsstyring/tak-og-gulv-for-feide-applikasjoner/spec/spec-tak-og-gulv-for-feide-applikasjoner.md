# Spec: Tak og gulv for Feide-applikasjoner

## Kilde

- **Scope:** `tasks/brukeradministrasjon-og-tilgangsstyring/tak-og-gulv-for-feide-applikasjoner/`
- **Kilde-mappe:** `krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/03 Iterasjon 4 - Grunnleggende selvbetjent administrasjon/`
- **Jira:** [BAT-411](https://sikt.atlassian.net/browse/BAT-411)
- **Hentet:** `2026-11-04`

## Omfang

To nye faner på detaljsiden for Feide-applikasjoner i FS Admin, én for taket og én for gulvet. Applikasjonsadministratoren ser rollene som gjelder nå, med gyldighetstidsrommet, og tildeler og fjerner forretningsroller per organisasjon og miljø. Forvaltningen krever applikasjonsadministrator-rollen både for applikasjonseieren og for organisasjonen på raden, i samme miljø. Tak fra organisasjonssamlinger vises med kilde, men forvaltes ikke her. Nekt, endringslogg og å sette gyldighetsperioden er ikke med.

## Krav

- **`tildele_roller_i_taket.feature`** (`@BRU-APP-API-018`) — se, tildele og fjerne forretningsroller i taket til en Feide-applikasjon, med samlingstak per organisasjon. ([krav/07 …/tildele_roller_i_taket.feature](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/03%20Iterasjon%204%20-%20Grunnleggende%20selvbetjent%20administrasjon/tildele_roller_i_taket.feature))
- **`tildele_roller_i_gulvet.feature`** (`@BRU-APP-API-019`) — se, tildele og fjerne forretningsroller i gulvet til en Feide-applikasjon. ([krav/07 …/tildele_roller_i_gulvet.feature](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/03%20Iterasjon%204%20-%20Grunnleggende%20selvbetjent%20administrasjon/tildele_roller_i_gulvet.feature))

## Skisser

Ingen skisse: fanene for tak og gulv følger mønsteret fra rollefanen for personbrukere og applikasjoner i FS Admin. Referanse: [FS-Admin – Målbilde, «Brukeradministrasjon v 1.0»](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331) og [`tildele_roller.design.md`](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/tildele_roller.design.md) for personbrukere (BRU-PER-GRU-003).

## Implementasjonsdetaljer

- **`tildele_roller_i_taket.feature`** — [tildele_roller_i_taket.design.md](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/03%20Iterasjon%204%20-%20Grunnleggende%20selvbetjent%20administrasjon/tildele_roller_i_taket.design.md) (2 åpne designspørsmål)
- **`tildele_roller_i_gulvet.feature`** — [tildele_roller_i_gulvet.design.md](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/03%20Iterasjon%204%20-%20Grunnleggende%20selvbetjent%20administrasjon/tildele_roller_i_gulvet.design.md) (2 åpne designspørsmål)

## Kodesjekk

- **Sjekket:** fs-plattform (origin/main e70cfb4fa3), fs-admin (origin/main 6816bd2d6)
- `@BRU-APP-API-019`: kravet sier at applikasjonsadministratoren tildeler og fjerner roller i gulvet. Koden har bare lesepolicyen på `applikasjon_brukergrunntilgang`, app-rollen kan ikke skrive, og kommentaren sier at gulvet skal få et eget privilegium (`fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0099-gulv-per-applikasjon.sql:12`, `:99`, `:101`). Grafen har ingen typer eller mutasjoner for gulvet. **Koden skal endres:** skrivemuligheten bygges med applikasjonsadministrator-rollen både for applikasjonseieren og for organisasjonen på raden, i samme miljø, som for taket (`kan_forvalte_delegering`). Kommentaren i 0099 om eget privilegium følges ikke.
- `@BRU-APP-API-018`: kravet sier at tak fra en organisasjonssamling vises per organisasjon, med kilde. Grafen leser og skriver bare direkte rader i `applikasjon_brukerdelegering`, så samlingstak er ikke synlige (`fs-plattform/tilgangsstyring/docs/tilgangsmodell.md:627`, `FeideApplikasjon.brukerdelegeringer` i `schema_delegeringstak.graphqls:169`). **Koden skal endres:** grafen må vise samlingstak per medlemsorganisasjon, med kilde. Forvaltning av samlingstak er ikke med.
- Gyldighetstidsrommet: FS Admin viser det med dato i rollelisten for personbrukere (`fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/components/PersonbrukerRollerResultList/PersonbrukerRollerResultList.tsx:133`), og kan ikke sette det. Kravene følger det. Ingen avvik.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/07 …/tildele_roller_i_taket.feature` | `@BRU-APP-API-018 @must @planned @scope-tak-og-gulv-for-feide-applikasjoner` | `@BRU-APP-API-018 @must @in-progress @scope-tak-og-gulv-for-feide-applikasjoner` |
| `krav/07 …/tildele_roller_i_gulvet.feature` | `@BRU-APP-API-019 @must @planned @scope-tak-og-gulv-for-feide-applikasjoner` | `@BRU-APP-API-019 @must @in-progress @scope-tak-og-gulv-for-feide-applikasjoner` |

## Åpne spørsmål

Ingen kravspørsmål. Åpne designspørsmål står i implementasjonsdetaljene, og tittel, mål og ikke-mål i `scope.md` er utkast til gjennomlesing.

## Rute

fs-plattform → fs-admin
