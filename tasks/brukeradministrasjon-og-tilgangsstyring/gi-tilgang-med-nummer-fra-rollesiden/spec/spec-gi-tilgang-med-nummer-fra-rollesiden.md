# Spec: Gi en person tilgang med nummer fra rollesiden

## Kilde

- **Oppgave:** `tasks/brukeradministrasjon-og-tilgangsstyring/gi-tilgang-med-nummer-fra-rollesiden/`
- **Kilde-mappe:** `krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere`
- **GitHub:** [#491](https://github.com/sikt-no/fs/issues/491), [#492](https://github.com/sikt-no/fs/issues/492), [#514](https://github.com/sikt-no/fs/issues/514)
- **Hentet:** `2026-10-07`

## Omfang

Brukeradministratoren finner en rolle i rolleoversikten, ser brukerne som har rollen, og gir
rollen til en person med fødselsnummer, D-nummer eller SNR for en organisasjon og et miljø hen
administrerer. Personen opprettes hvis hen ikke finnes, og blir synlig for
brukeradministratoren gjennom tildelingen. Svaret er det samme uansett om personen fantes.
Spesifikasjonen dekker ikke søk etter rolle, å legge til eller fjerne andre brukere fra
rollesiden, personsøk i SIS, flere roller i samme operasjon, gjenkjenning ved pålogging og hvor
navnet kommer fra; de delene er `@draft`.

## Krav

- **`se_brukere_på_rolle.feature`** (`@BRU-PER-ROL-001`) — rolleoversikten med rollene brukeradministratoren kan tildele, og rollens oversiktsside med brukerne som har rollen aktivt tildelt og som brukeradministratoren ellers kan se. ([krav/…/3 - Rollevisning/se_brukere_på_rolle.feature](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/3%20-%20Rollevisning/se_brukere_på_rolle.feature))
- **`administrere_brukere_på_rolle.feature`** (`@BRU-PER-ROL-002`) — regelen «Gi rollen til en person med fødselsnummer, D-nummer eller SNR»: organisasjon og miljø velges blant dem brukeradministratoren administrerer, og bare rollen på siden gis. ([krav/…/3 - Rollevisning/administrere_brukere_på_rolle.feature](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/3%20-%20Rollevisning/administrere_brukere_på_rolle.feature))
- **`gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.feature`** (`@BRU-PER-GRU-013`) — reglene for tildelingen: den første tildelingen med nummer, samme svar uansett, nummeret vises ikke, gyldige kontrollsifre, testperson i ekte miljø, og bare roller brukeradministratoren har rett til å tildele. ([krav/…/1 - Grunnleggende brukeradministrasjon/gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.feature](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.feature))
  - Regelen «Den første tildelingen gis med fødselsnummer, D-nummer eller SNR» har `@openquestion`: hvordan rollene som ligger igjen på en Feide-bruker vises på personens detaljside.
  - Regelen «En testperson kan ikke få tilgang i et ekte miljø» har `@openquestion`: om en ekte person kan få tilgang i et testmiljø, og om SNR eller et FS-generert nummer er en testperson.

### Utenfor scope (`@draft`)

- **`se_brukere_på_rolle.feature` — scenario `Søke fram en rolle`** — ikke gjennomgått.
- **`administrere_brukere_på_rolle.feature` — scenario `Legge til en bruker på en rolle`** — venter på: batch-operasjon, valideringer, stedkoder og tidsbegrensning, delte roller.
- **`administrere_brukere_på_rolle.feature` — scenario `Fjerne en bruker fra en rolle`** — venter på: batch-operasjon.
- **`gi_en_person_tilgang_…feature` — scenario `Flere roller gis i samme operasjon der inngangen lar brukeradministratoren velge roller`** — venter på: hvilken inngang som lar brukeradministratoren velge flere roller når nummeret oppgis.
- **`gi_en_person_tilgang_…feature` — regel `Personen kan søkes opp i FS-SIS i stedet for å oppgi nummeret`** — venter på: prioritet, søkefelt, utvalg og om treff avslører tildelinger.
- **`gi_en_person_tilgang_…feature` — regel `Personen gjenkjennes ved pålogging, uansett påloggingsmåte`** — venter på: om det gjelder alle Feide-brukere, og om en person med SNR gjenkjennes.
- **`gi_en_person_tilgang_…feature` — regel `Navnet hentes fra påloggingen`** — venter på: hva som vises for en person som bare logger inn med ID-porten og ikke har navn, og om det er akseptabelt at listen avslører om personen har logget inn før.
- **`gi_en_person_tilgang_…feature` — reglene `En personbruker kan registreres før hen har logget inn første gang` og `En registrering må gi personbrukeren minst én tildeling`** — foreslått fjernet, venter på bekreftelse.
- **`gi_en_person_tilgang_…feature` — reglene `Registrert, men ikke logget inn, er en varig tilstand` og `En registrert personbruker som ikke lenger har roller`** — venter på: skrives om til personmodellen, eller fjernes.

## Skisser

Ingen skisse: det finnes ingen skisser. Implementasjonsdetaljene bygger på eksisterende mønstre i FS Admin («Tildel roller»-dialogen og personbrukere-listen).

## Implementasjonsdetaljer

- **`se_brukere_på_rolle.feature`** — [se_brukere_på_rolle.design.md](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/3%20-%20Rollevisning/se_brukere_på_rolle.design.md) (4 åpne designspørsmål)
- **`administrere_brukere_på_rolle.feature`** — [administrere_brukere_på_rolle.design.md](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/3%20-%20Rollevisning/administrere_brukere_på_rolle.design.md) (3 åpne designspørsmål)
- **`gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.feature`** — [gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.design.md](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.design.md) (2 åpne designspørsmål)

Alle tekstene i implementasjonsdetaljene er forslag som Kjetil må godkjenne.

## Kodesjekk

- **Sjekket:** fs-plattform `main` (`c285371f1`), !6014 (`tilgangsstyring/personsubjekt-inflight-migrering`, `bdba9d2f3`), !6015 (`tilgangsstyring/personsubjekt-api`, `3629e0141`); fs-admin `main` (`24c76aa7`). `CL` = `tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog`.

**Finnes:**

- Personsubjektet, med fødselsnummeret unikt og CHECK på 11 siffer og kontrollsifre (fs-plattform `CL/0085-personsubjekt.sql:120-147`, `:132`, `:138`). Testperson = Skatteetatens syntetiske serie, `er_syntetisk` (`CL/0079-syntetiske-miljoer-og-domener.sql:75-89`).
- Alle brukeradministratorer har person-privilegiene: `BRUKERADMIN_PERSON_LES/_SKRIV/_TILDELING_SKRIV` er implisert fra `BRUKERADMINISTRASJON_*`, som brukeradministrator-rollen gir (`CL/0085-personsubjekt.sql:53-69`, `CL/0058-forretnings-og-ui-roller-brukeradmin.sql:78-85`). Stemmer med GRU-013.
- Synlighet gjennom tildeling (`CL/0085-personsubjekt.sql:186-233`) og, i !6014, gjennom hjemorganisasjonen til en koblet Feide-bruker (!6014 `CL/0086-personsubjekt-inflight-migrering.sql:440-470`).
- Pålogging med Feide finner personen på fødselsnummeret og oppretter ikke en ny (!6014 `CL/0086-…:270-291`).
- !6015: `Personsubjekt`, `personsubjekter(filter: {roller, organisasjoner, miljoer, navnContains})` og `tildelPersonsubjektTilganger` (!6015 `tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_personsubjekt.graphqls:84-114`, `:217-219`). Ingen oppslag på nummer, med vilje (`:92-93`).
- fs-admin: «Tildel roller»-dialogen med organisasjon (låst når det er én), miljø og roller (`src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/components/TildelRolleModal/TildelRolleModal.tsx:123-130`, `:348-387`), og tekstene (`src/common/messages/nb/domains.json:157-185`).

**Avvik og mangler (kravet er riktig, koden skal endres eller bygges):**

- `BRU-PER-GRU-013`, `BRU-PER-ROL-002`: operasjonen som tar nummer, organisasjon, miljø og rolle, oppretter personen ved behov, gir tildelingen og svarer likt, finnes ikke. Den er iterasjon 4 i !6015s spec (!6015 `tilgangsstyring/docs/specs/personsubjekt-api/spec-personsubjekt-api.md:55`, `:124`, `:135-137`). `tildelPersonsubjektTilganger` kan ikke brukes, fordi den gir `PersonsubjektIkkeFunnet` for en person brukeradministratoren ikke ser (!6015 `CL/0087-tildeling-til-personsubjekt.sql:26-39`, `:97-110`). Koden skal bygges.
- `BRU-PER-GRU-013`: `tilgangsstyring.opprett_person(fodselsnummer, fornavn, etternavn)` krever navn, gir ingen tildeling, og gir 23505 når personen finnes (`CL/0085-personsubjekt.sql:563-596`). Kravet sier at navnet kommer fra første pålogging og at svaret er det samme. Koden skal endres.
- `BRU-PER-GRU-013`: ugyldig nummer finnes bare som SQLSTATE 23514 (`CL/0085-personsubjekt.sql:588-593`), ingen feiltype i API-et. Koden skal bygges.
- `BRU-PER-GRU-013`: ingenting hindrer at en testperson får en tildeling i et ekte miljø. Invarianten er «ikke håndhevet ennå» for tildelinger (fs-plattform `tilgangsstyring/docs/syntetiske-og-ekte-data.md:55-56`, `:81`). Koden skal bygges.
- `BRU-PER-GRU-013`: SNR finnes ikke i koden. CHECK-en godtar også FS-genererte numre (`CL/0085-personsubjekt.sql:136-137`). Kravet om kontrollsifre er oppfylt for alle tre typene.
- `BRU-PER-ROL-001`: ingen spørring gir rollene brukeradministratoren kan tildele på tvers av organisasjoner og miljøer. `tildelbareTilgangskoder(organisasjonId, miljoId)` svarer for ett par, gir hele katalogen eller ingenting, og teller ikke person-retten (`CL/0057-tildelinger-splittes-etter-subjekttype.sql:405-431`). Koden skal bygges.
- `BRU-PER-ROL-001`: kravet sier «aktivt tildelt». Filteret `roller` treffer brukere som har rollen «aktivt, direkte eller arvet» (fs-plattform `…/experimental/schema_brukeradmin.graphqls:164`, !6015 `schema_personsubjekt.graphqls:105`). Rollens oversiktsside skal vise direkte tildelinger. Koden skal endres. **Forslag, må bekreftes av Kjetil.**
- `BRU-PER-ROL-001`, `BRU-PER-GRU-013`: RLS gir synlighet også gjennom en lukket tildeling, med vilje (`CL/0085-personsubjekt.sql:200-201`). Som for Feide-brukere skal brukere med bare inaktive tildelinger skjules av et filter i API-et, ikke i RLS. **Forslag, må bekreftes av Kjetil.**
- fs-admin: rolleoversikten og rollens oversiktsside finnes ikke. Tilgangsstyring har bare rutene `src/app/tilgangsstyring/personbrukere/` og `src/app/tilgangsstyring/applikasjoner/`. Skal bygges.
- fs-admin: ingen støtte for personsubjekter (ingen treff på `personsubjekt` i `src`). «Tildel roller» tildeler bare til Feide-brukere (`…/TildelRolleModal/hooks/useTildelFeideBrukerTilganger.tsx:61-77`), så «Flere roller gis etterpå fra detaljsiden for personen» trenger en person-variant. Skal bygges.
- fs-admin: ingen sjekk av kontrollsifre i produksjonskoden; `src/domains/person/utils/formatFodselsnummer.ts:1` sjekker bare 11 siffer. Skal bygges.

**Til orientering, for `@draft`-delene:**

- Pålogging med ID-porten gir ingen tilganger i dag (fs-plattform `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/CoprocessorService.java:747-748`).
- !6014 kobler bare ansatte Feide-brukere til personen (!6014 `CoprocessorService.java:732`, `:764-766`). Gjelder spørsmålet «Gjelder det alle Feide-brukere?».
- !6014 kopierer navnet fra Feide-brukeren bare når personen opprettes ved påloggingen. En person brukeradministratoren har opprettet med nummer, får ikke navnet når Feide-brukeren kobles senere (!6014 `CL/0086-…:251-258`, `:282-290`). Gjelder regelen «Navnet hentes fra påloggingen».

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/07 …/3 - Rollevisning/se_brukere_på_rolle.feature` | `@BRU-PER-ROL-001 @planned` | `@BRU-PER-ROL-001 @in-progress` |
| `krav/07 …/3 - Rollevisning/administrere_brukere_på_rolle.feature` | `@BRU-PER-ROL-002 @planned` | `@BRU-PER-ROL-002 @in-progress` |
| `krav/07 …/1 - Grunnleggende brukeradministrasjon/gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.feature` | `@BRU-PER-GRU-013 @must @planned` | `@BRU-PER-GRU-013 @must @in-progress` |

Ingen krav ble holdt tilbake.

## Åpne spørsmål

- [ ] Bekreft forslaget i kodesjekken: rollens oversiktsside viser bare direkte tildelinger, ikke arvede.
- [ ] Bekreft forslaget i kodesjekken: brukere med bare inaktive tildelinger skjules av et filter i API-et, som for Feide-brukere.

## Rute

fs-plattform → fs-admin
