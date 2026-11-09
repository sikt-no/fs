# Analysis: ID-porten-autentisering og personsubjekt uten Feide (iterasjon 2)

## Problem Statement

Delta-spec-en [`spec-changes-2026-09-23-idporten-personsubjekt.md`](../spec/spec-changes-2026-09-23-idporten-personsubjekt.md)
har to krav:

- **TIL-PÅL-PÅL-003 (endret):** tre regler som var åpne spørsmål i iterasjon 1, er nå hard krav.
  Tokenet må være utstedt for FS GraphQL API (audiens). Testmiljø-tokener avvises mot
  produksjonsdata. En ID-porten-bruker **med** tildelte roller får organisasjonstilgangene rollen
  gir. Tidligere var tilgangssettet «tomt inntil ikke-Feide-brukere er innført».
- **BRU-PER-GRU-013 (nytt):** en administrator registrerer en ansatt uten Feide-konto på
  fødselsnummer og navn, tildeler en rolle i forkant, og den ansatte gjenkjennes ved første
  ID-porten-innlogging. Egen rettighet, atskilt fra Feide-rettigheten. Synligheten følger
  tildelingene, og en registrering i en annen organisasjon skal ikke røpes.

Beslutningene fra delta-spec-en er utgangspunkt: `pid` er personnøkkelen, analysen foreslår
rettigheten, og scope er backend i `fs-plattform/tilgangsstyring`. Skjermbildene i fs-admin tas
i en egen task.

Sett fra koden har iterasjon 1 levert hele autentiseringssiden. Den ucommittede `0073` har lagt
datamodellen for personsubjektet. Mellom dem mangler koblingen: coprocessoren slår aldri opp et
personsubjekt, tildelingsflaten godtar bare Feide-brukere, og 0073 bruker Feide-rettighetene
som kravet sier skal holdes atskilt.

## Current State

### Levert i iterasjon 1 (Task #1–#7, committet på `BAT-239-idporten-coprocessor`)

- `IdportenAuthenticator` verifiserer mot tenantene `idporten` / `idporten-test` og legger `pid`
  i `nin`, ID-portens `sub` i `subject` og `client_id` i `clientId`
  (`tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/IdportenAuthenticator.java:47-54`).
- `acr` bæres for alle utstedere (`CoprocessorService.java:550`).
- Testutstederen gates til syntetiske miljø (Task #3). ID-porten gates bort fra subgraf-stien
  (Task #4, BAT-243).
- **Tilgangsoppslaget for ID-porten gir alltid åpne roller:**
  `hentActualOrgTilganger` (`CoprocessorService.java:528-530`) yielder
  `tilgangerForApneRoller(env)` uten å se på `nin`. Databasefunksjonen er
  `tilganger_for_apne_roller` fra `0072-apne-roller-uten-tildelinger.sql:23`.

### Ucommittet i working tree: `0073-personsubjekt.sql`

`tilgangsstyring-new-db/src/main/resources/db/changelog/0073-personsubjekt.sql`, med
pgTAP-filen `src/test/sql/64_personsubjekt.sql` og justeringer i testene 26 og 62:

- Ny subjekttype `person` (aktørledd `bruker`) og tabellen `personsubjekt(subjekt_id,
  subjekt_type, fodselsnummer)`. Fødselsnummeret er `UNIQUE` og formsjekkes med `^[0-9]{11}$`,
  bevisst uten modulus-11.
- RLS: `personsubjekt_les` / `_skriv` gjenbruker **`brukere_i_mine_feidebruker_les/skriv_organisasjoner()`**,
  og `WITH CHECK` krever **`BRUKERADMIN_FEIDEBRUKER_SKRIV`**.
- `subjektnavn` løsnes for `person` (CHECK, DEFAULT, lesegren, sporings-FK-ene).
- `opprett_personsubjekt(fnr, fornavn, etternavn)` er `SECURITY DEFINER` og krever
  `BRUKERADMIN_FEIDEBRUKER_SKRIV`. Den skriver `subjekt`, `personsubjekt` og `subjektnavn` i én
  transaksjon. Duplisert fødselsnummer gir `23505`.
- App-rollen mister INSERT og UPDATE på `personsubjekt`, men beholder DELETE.
- Ingen Java-, jOOQ- eller GraphQL-kode kaller funksjonen ennå. Søk på
  `personsubjekt`/`opprettPersonsubjekt` i `*.java`/`*.graphqls` gir null treff.

### Tildelingsflaten (0036/0057)

- `subjekt_er_feide_bruker(subjekt_id)` (`0057-tildelinger-splittes-etter-subjekttype.sql:80-90`)
  er typetesten som alle policyene på `subjektrolletildeling` bruker. Den tester **bare**
  `subjekt_type = 'feide_bruker'`. Splitten er person/ikke-person, og alt som ikke er
  `feide_bruker` følger applikasjonsgrenen: `BRUKERADMIN_WSBRUKER_LES/_SKRIV` og
  `BRUKERADMIN_TILDELING_SKRIV`.
- `tildel_brukertilgang` (`0057…sql:290-325`) kaller `krev_feidebruker_tildelingsrett`,
  **`krev_feide_bruker(p_subjekt_id)`** og `krev_tilgangskode`. Den er `SECURITY INVOKER`.

### Rettighetsmodellen for brukeradministrasjon

| Flate | Les | Skriv (subjekt) | Tildeling |
|---|---|---|---|
| Applikasjoner | `BRUKERADMIN_WSBRUKER_LES` | `BRUKERADMIN_WSBRUKER_SKRIV` | `BRUKERADMIN_TILDELING_SKRIV` |
| Feide-brukere (0052–0054) | `BRUKERADMIN_FEIDEBRUKER_LES` | `BRUKERADMIN_FEIDEBRUKER_SKRIV` | `BRUKERADMIN_FEIDEBRUKER_TILDELING_SKRIV` |

Forretningsrollene `BRUKERADMINISTRASJON_LES/_SKRIV/_TILDELING` impliserer Feide-privilegiene
(`0058-forretnings-og-ui-roller-brukeradmin.sql:83-85`). Delegeringstaket for brukeradmin settes
i `0059-delegeringstak-brukeradmin.sql:35-41`. Chokepoint-disiplinen er at privilegiekoden
navngis ett sted, for eksempel `orger_med_feidebruker_tildelingsrett()`.

### GraphQL-flaten

`schema_brukeradmin.graphqls` (experimental) og `stable/applikasjoner.graphqls:140` er bygd
rundt typen `FeideBruker` (`@table` `feide_bruker`): `feideBrukere`-connection,
`FeideBrukerTilgang`, `tildelFeideBrukerTilganger` / `fjernFeideBrukerTilganger` (`@service`),
og `opprettFeideBruker(feideId)` i `schema_exp.graphqls:420`. Beskrivelsene kaller dem
«personbrukere», men typen, tabellen og filtrene (`FeideBrukereFilterConditions`) er
Feide-spesifikke.

### Audiens

`quarkus.oidc.idporten.token.audience` er ikke satt i noen profil
(`application.properties:221`: «token.audience er ikke satt — audiensen avklares med
fs-admin»). Det var beslutning (a) i iterasjon 1.

## Key Findings

1. **0073 bruker Feide-rettighetene, og kravet forbyr akkurat det.** BRU-PER-GRU-013,
   regelen «Flyten er atskilt fra Feide-flyten», krever at Feide-rettigheten ikke gir tilgang
   til personflyten, og omvendt. 0073 gater lesing, skriving og `opprett_personsubjekt` på
   `BRUKERADMIN_FEIDEBRUKER_LES/_SKRIV`, og kommentaren sier at det er gjort «bevisst». Begge
   scenariene under regelen feiler med 0073 slik den står. Siden 0073 ikke er committet eller
   kjørt noe sted, kan den endres i stedet for å rettes med en ny migrering.

2. **En person faller i applikasjonsgrenen på tildelingsflaten.** `subjekt_er_feide_bruker` gir
   `false` for `person`. Tildelingsrader på en person styres derfor av
   `BRUKERADMIN_WSBRUKER_*` og `BRUKERADMIN_TILDELING_SKRIV`, som er applikasjonsadministratorens
   nøkler. Det er den samme bypass-typen 0057 ble skrevet for å lukke. Konsekvensen er at en
   applikasjonsadministrator kan se og skrive persontildelinger, og en brukeradministrator
   kan det ikke.

3. **Personen kan ikke tildeles noe gjennom eksisterende funksjoner.** `tildel_brukertilgang`
   kaller `krev_feide_bruker` og avviser en `person` med P0002. Selv med den sperren fjernet er
   en nyopprettet person usynlig for kalleren fordi `personsubjekt_les` går via tildelinger, og
   `SECURITY INVOKER`-oppslag finner den ikke. Kravets «registrerer den ansatte **og** tildeler
   en rolle» må derfor skje i én operasjon som ser forbi RLS, på samme måte som
   `opprett_personsubjekt` gjør for navneraden.

4. **Duplisert fødselsnummer gir `23505`, mens kravet sier «legg rollen på den eksisterende».**
   Scenariene «allerede registrert» og «registrering i en annen organisasjon røpes ikke» krever
   at en ny registrering på et kjent fødselsnummer gir en tildeling på den eksisterende personen.
   Utfallet skal ikke skille seg fra en helt ny registrering. `uq_personsubjekt_fodselsnummer`
   som unntak lar kalleren se forskjellen, altså at personen er registrert et annet sted. Det er
   et eksistens-orakel på fødselsnummer.

5. **Ugyldig fødselsnummer avvises ikke.** Kravet sier at «noe annet enn et gyldig fødselsnummer
   eller D-nummer» avvises. 0073 sjekker bare elleve sifre, og sier eksplisitt at modulus-11
   «hører hjemme der nummeret oppstår». `Fodselsnummer.java` i `tilgangsstyring-app` har
   kontrollsiffervektene (`K1_VEKTER`/`K2_VEKTER`) og serieklassifisering (`erSyntetiskSerie`,
   `erFsGenerert`), men ligger i coprocessor-pakken og ikke i `tilgangsstyring-service`, der
   `@service`-klassene for grafflaten bor.

6. **Coprocessoren slår ikke opp personen ved innlogging.** Regelen «Innlogget med ID-porten med
   tildelte roller» og regelen om første innlogging krever et oppslag fra `nin`
   (= `pid`) til `personsubjekt` og videre til tildelingene. I dag går ID-porten-grenen
   ubetinget til `tilganger_for_apne_roller` (`CoprocessorService.java:528-530`). Det trengs en
   ny databasefunksjon for coprocessor-rollen, i samme familie som `tilganger_for_*`, og en ny
   gren i `hentActualOrgTilganger`. `tilgangerForApneRoller` blir fallback når personen ikke
   finnes.

7. **Delegeringstaket for ID-porten-stien er udefinert.** Feide-personer får snittet av sine
   tildelinger og delegeringstaket til Feide-tjenesten de kommer via
   (`tilganger_for_feidetjeneste_og_bruker`, `tilganger_for_bruker(env, app, bruker, …)`).
   ID-porten-tokenet har en `client_id`, altså fs-admins ID-porten-klient, men ingen
   applikasjonssubjekt er koblet til den. Uten et tak får personen alle sine tildelinger
   ubegrenset, og det er en annen modell enn for Feide. Iterasjon 1 unngikk spørsmålet fordi
   tilgangssettet var tomt.

8. **Audiens er nå et krav, ikke et åpent spørsmål.** Scenariet «Token utstedt for en annen
   tjeneste avvises» er ikke oppfylt: ingen profil setter `quarkus.oidc.idporten.token.audience`,
   så enhver audiens godtas. Verdien avhenger av klientregistreringen hos Digdir, som ikke er
   bestilt (åpent spørsmål 4 i delta-spec-en). Mekanismen kan likevel pinnes og testes mot den
   lokale JWKS-stubben med en testverdi.

9. **Personer kan ikke være aktører, og kravet trenger det heller ikke.** Sporings-FK-ene i ni
   tabeller peker fortsatt på `feide_bruker`. 0073 lar dette stå med vilje (kommentar i
   `26_sporing_delte_aktorkolonner.sql`). Administratorer er Feide-brukere, så kravet treffes
   ikke. Det blir en begrensning den dagen en person uten Feide skal administrere noe selv.

10. **Grafflaten har ingen persontype.** `FeideBruker` er både type og tabell. Søk, detaljer,
    tilgangslisten og tildel/fjern må enten få en parallell `Person`-type eller en felles
    abstraksjon (interface/union) over `feide_bruker` og `personsubjekt`. Synlighetsreglene i
    kravet (søk, se tildelte roller, ikke se andre organisasjoner) gjelder begge. Valget påvirker
    fs-admin-tasken, som konsumerer skjemaet.

11. **Fjerning er allerede riktig modellert, bortsett fra DELETE.** Kravet sier at en person
    fjernes ved at alle tildelinger fjernes. Da er personen usynlig, men raden står. Det følger
    av `personsubjekt_les`. 0073 beholder likevel DELETE for app-rollen («opprettet ved en feil»).
    Kravet nevner ingen slik sti, og en DELETE gjør at en senere registrering på samme
    fødselsnummer får et nytt subjekt. Det er et avvik fra «fødselsnummeret identifiserer
    personen».

## Technical Constraints

- **Liquibase-checksum:** kjørte changesets kan ikke redigeres. 0073 er ukjørt og ucommittet og
  kan fortsatt endres. 0057-policyene må derimot endres med `DROP` + `CREATE` i en ny fil, slik
  0057 selv gjorde.
- **RLS-rekursjon:** typetesten på `subjektrolletildeling` må lese `subjekt`, som er globalt
  lesbar. Den kan ikke lese `personsubjekt`, fordi policyen der leser `subjektrolletildeling`
  («infinite recursion», dokumentert i 0023 og 0057).
- **Chokepoint-disiplin:** hver privilegiekode navngis i én funksjon (`orger_med_*_tildelingsrett`,
  `brukere_i_mine_*_organisasjoner`). En ny personrettighet skal følge samme mønster.
- **Feilkontrakt:** 42501-meldingen er kontrakt for feilrutingen i grafflaten
  (`ManglerTildelingsrett`). Klienten skal ikke kunne skille rettene på feilformen (0057).
- **`SECURITY DEFINER` flytter porten fra RLS inn i funksjonen.** Privilegiesjekken må være
  første setning (mønster: `opprett_personsubjekt`, `tilganger_for_sudo` i 0061).
- **Coprocessorens tidsbudsjett:** 900 ms totalt og inntil 500 ms databaseoppslag
  (`docs/tidsbudsjett.md`). Personoppslaget må være ett kall, ikke oppslag pluss
  tilgangsberegning i to runder.
- **Fødselsnummer sladdes i logg** (`Fodselsnummer.sladd`). Det gjelder også feilmeldinger fra
  den nye registreringsflaten.
- **Dokumentasjon:** `docs/tilgangsmodell.md` beskriver subjekttypene og nøklene. Den må
  oppdateres sammen med modellen (RETNINGSLINJER, «Dokumentasjon og kommentarer»).

## Dependencies

- **Internt:**
  - `0073-personsubjekt.sql` + pgTAP 26/62/64: må justeres for funn 1, 4, 5 og 11.
  - `0057`-policyene og `tildel_brukertilgang` / `fjern_brukertilgang`: typetesten og
    subjektsjekken (funn 2 og 3).
  - `0052`–`0054`, `0058`, `0059`: mønsteret for en ny privilegiefamilie, forretningsrolle og
    delegeringstak.
  - `CoprocessorService.hentActualOrgTilganger` + `TilgangsstyringDataTilgangerService`: nytt
    personoppslag (funn 6).
  - `tilgangsstyring-new-jooq`: må regenereres for ny tabell og nye funksjoner.
  - `tilgangsstyring-service` + `schema_brukeradmin.graphqls`: ny grafflate (funn 10).
  - `application*.properties`: audiens (funn 8).
- **Eksternt:**
  - Digdir: klientregistrering, som gir verdien for audiens og `client_id`. Ikke bestilt.
- **Cross-contributor:**
  - **fs-admin (frontend):** skjermbildene for registrering, søk, visning og fjerning av personer.
    De konsumerer grafflaten fra funn 10, så typevalget der må avtales før fs-admin-tasken
    planlegges. Innloggingsflaten (NextAuth mot ID-porten) avgjør også den faktiske audiensen.
  - **Rolleforvaltning:** hvem som får den nye personrettigheten i test og produksjon. Det skjer
    via forretningsrolle og tildeling, ikke i kode.

## Requirements Impact

| Krav / regel | Status i koden i dag | Vurdering |
|---|---|---|
| **TIL-PÅL-PÅL-003** — egen utsteder, gyldig/ugyldig | Dekket (iterasjon 1) | Ingen endring. |
| — audiens må være FS GraphQL API | **Ikke dekket** | Funn 8. Mekanismen kan bygges nå, verdien venter på Digdir. |
| — `acr` bæres, håndheves ikke | Dekket | Ingen endring. |
| — uten tildelte roller → åpne roller | Dekket (0072, Task #5) | Blir fallback-grenen i funn 6. |
| — med tildelte roller → rollens orgtilganger | **Ikke dekket** | Funn 6 og 7. |
| — testmiljø godtas syntetisk / avvises mot produksjon | Dekket (Task #3) | Regelen er nå krav i stedet for `@openquestion`. Ingen endring. |
| **BRU-PER-GRU-013** — ny person opprettes med rolle | Delvis (0073 oppretter, tildeling mangler) | Funn 3. |
| — allerede registrert → rolle på eksisterende | **I strid** (23505) | Funn 4. |
| — ugyldig fnr / D-nummer avvises | **Ikke dekket** (bare form) | Funn 5. |
| — Feide-rett ≠ person-rett, begge veier | **I strid** (0073 bruker Feide-rett) | Funn 1 og 2. |
| — gjenkjent ved første innlogging | **Ikke dekket** | Funn 6. |
| — navn lagres, opprettelse sporbar | Dekket (0073, `subjektnavn`) | Ingen endring. |
| — synlighet følger tildelinger | Dekket i basen (0073 RLS), men med feil nøkkel | Funn 1. Ingen graf-flate (funn 10). |
| — registrering i annen organisasjon røpes ikke | **I strid** (23505-orakel) | Funn 4. |
| — fjerning via tildelinger, andre organisasjoner beholdes | Dekket av modellen | Funn 11: DELETE-stien er et avvik. |

- **Krav adressert av eksisterende kode:** fire av seks regler i TIL-PÅL-PÅL-003. For
  BRU-PER-GRU-013: navn og sporing.
- **Krav med risiko:** atskilte rettigheter (funn 1 og 2) og ikke-røping (funn 4). Begge er
  sikkerhetsegenskaper, der 0073 slik den står gir feil svar.
- **Manglende krav oppdaget:**
  - Delegeringstaket for ID-porten-stien (funn 7). Ingen av kravene sier om fs-admins tak skal
    begrense en persons tilganger.
  - Hvilket navn som gjelder når en person registreres på nytt av en annen organisasjon, med
    et annet navn. Kravet dekker bare første registrering.
  - Deaktivering: Feide-brukere har `AKTIV`/`DEAKTIVERT`, personer har ingen status. Kravet nevner
    det ikke.

## Krav-input referanse

- **Delta-spec (primær):** [`spec-changes-2026-09-23-idporten-personsubjekt.md`](../spec/spec-changes-2026-09-23-idporten-personsubjekt.md)
- **Delta-manifest:** [`krav-input/changes/2026-09-23-idporten-personsubjekt/manifest.md`](../spec/krav-input/changes/2026-09-23-idporten-personsubjekt/manifest.md)
- **Spec, iterasjon 1:** [`spec-idporten-fs-admin-fase1.md`](../spec/spec-idporten-fs-admin-fase1.md)
- **Analyse, iterasjon 1:** [`analysis-idporten-fs-admin-fase1.md`](analysis-idporten-fs-admin-fase1.md)

## Open Questions

- [x] **Rettighetsfamilie for personer.** Hva skal den nye rettigheten hete, og hvordan
      tildeles den? (Delegert fra delta-spec-en.)
      Alternativer:
      (a) Full parallell familie etter 0052–0054: `BRUKERADMIN_PERSON_LES`, `_SKRIV` og
      `_TILDELING_SKRIV`, med egne chokepoint-funksjoner, en egen forretningsrolle
      (f.eks. `BRUKERADMINISTRASJON_PERSON`) og et eget delegeringstak.
      (b) Én enkelt `BRUKERADMIN_PERSON_SKRIV` som dekker lesing, opprettelse og tildeling.
      (c) Samme tre privilegier som i (a), men impliserte av de eksisterende forretningsrollene
      `BRUKERADMINISTRASJON_*`.
      **Besluttet (a).** Begrunnelse: mønsteret fra 0052–0054 gir hver flate sine egne
      LES/SKRIV/TILDELING-privilegier med én chokepoint-funksjon per kode. Atskillelsen kravet
      krever gjelder dermed også på rollenivå. Med (c) ville alle som i dag har
      `BRUKERADMINISTRASJON_*`, fått personrettigheten automatisk. 0073 skrives om til å bruke
      personprivilegiene i stedet for `BRUKERADMIN_FEIDEBRUKER_*`.
- [x] **Typetesten på tildelingsflaten.** Hvordan skal `subjektrolletildeling`-policyene skille
      personer? Alternativer: (a) en tredje gren for `person`, med egen nøkkel, (b) utvide
      `subjekt_er_feide_bruker` til «er menneske» med felles nøkkel. Alternativ (b) er i strid med
      kravet om atskilte rettigheter.
      **Besluttet (a).** Det blir en ny typetest `subjekt_er_person` mot den globalt lesbare
      `subjekt`-tabellen, og en egen gren med `BRUKERADMIN_PERSON_*` som nøkkel i de fire
      policyene (`_les`, `_skriv`, `_tildeling_insert`, `_tildeling_lukk`). Applikasjonsgrenen får
      samtidig `NOT subjekt_er_person`, så personer ikke lenger faller inn der (funn 2). Endringen
      skrives som `DROP` + `CREATE` i en ny migrering, slik 0057 gjorde. Begrunnelse: følger av
      beslutningen om rettighetsfamilie. Alternativ (b) ville gitt Feide-administratorer
      personrett.
- [x] **Registrer-og-tildel.** Skal registreringen være én operasjon (definer-funksjon:
      finn-eller-opprett på fødselsnummer og tildel i samme transaksjon), eller to steg der
      personen gjøres synlig på en annen måte mellom opprettelse og tildeling?
      **Besluttet: én operasjon.** Det blir en `SECURITY DEFINER`-funksjon, f.eks.
      `registrer_person(fnr, fornavn, etternavn, rolle, org, miljø)`, som erstatter
      `opprett_personsubjekt` som eneste inngang. Den finner eller oppretter personen på
      fødselsnummeret og tildeler i samme transaksjon. Utfallet er det samme for ny og kjent
      person, så funn 3 og 4 løses samtidig, og personen blir synlig i det øyeblikket tildelingen
      skrives.
      **Konsekvens for planen:** privilegiesjekken må være ubetinget og komme først. Både
      `BRUKERADMIN_PERSON_SKRIV` og `BRUKERADMIN_PERSON_TILDELING_SKRIV` må kreves i
      (org, miljø) før fødselsnummeret slås opp. Sjekkes `_SKRIV` bare når personen er ny, får en
      administrator med bare tildelingsrett ulikt utfall for ny og kjent person, og da er
      orakelet tilbake. `uq_personsubjekt_fodselsnummer` blir stående som dybdeforsvar, men skal
      aldri nå kalleren som `23505`.
- [x] **Navn ved gjenregistrering.** Når en annen organisasjon registrerer et kjent fødselsnummer
      med et annet navn: (a) behold eksisterende navn, (b) nytt navn erstatter (temporal rad),
      (c) avvis ved avvik. Alternativ (c) røper at personen finnes.
      **Besluttet (a).** For en kjent person ignoreres det oppgitte navnet, og `registrer_person`
      skriver ingen ny `subjektnavn`-rad. Begrunnelse: med (b) kunne en hvilken som helst
      organisasjon endre navnet andre organisasjoner ser, og (c) røper at personen finnes.
      Navneendring hører hjemme i en egen, senere flyt.
      **Akseptert restlekkasje:** etter tildelingen ser administratoren det lagrede navnet. Er det
      et annet enn hun skrev inn, forstår hun at personen var registrert fra før. Det røper
      verken hvor eller med hvilke tildelinger, og kravet («ser kun tildelingene hun selv har
      gitt») holder. Planen bør likevel nevne dette i dokumentasjonen.
- [x] **Fødselsnummervalidering.** Hvor skal modulus-11 håndheves, og hvilke serier skal godtas?
      Alternativer: (a) i databasen (ny CHECK/funksjon), (b) i `@service`-laget med en delt
      `Fodselsnummer`-klasse. Må avklares: skal FS-genererte fiktive nummer som ikke består
      modulus-11 godtas i syntetiske miljø?
      **Besluttet (b).** Valideringen gjøres i `@service`-laget. `Fodselsnummer` flyttes fra
      coprocessor-pakken til et sted både `tilgangsstyring-app` og `tilgangsstyring-service` når.
      Godkjent er ordinære fødselsnumre og D-numre (måned 01–12) med gyldige kontrollsifre, og
      Skatteetatens syntetiske serie (Tenor, måned + 80). FS-genererte numre (måned + 50,
      pnr ≥ 70000) avvises. Ugyldig nummer gir en typet GraphQL-feil. Databasen beholder
      formsjekken fra 0073. Begrunnelse: ID-porten leverer aldri FS-genererte numre, så en person
      registrert på et slikt nummer kan aldri logge inn. Seriekunnskapen finnes allerede i Java,
      og 0073 sier med vilje at modulus-11 ikke hører hjemme i en tilgangstabell. Feilmeldinger
      sladder nummeret med `Fodselsnummer.sladd`.
- [x] **Delegeringstak for ID-porten-stien.** Skal en persons tilganger via fs-admin begrenses av
      et delegeringstak? Alternativer: (a) koble ID-porten-`client_id` til fs-admins
      applikasjonssubjekt og bruke `tilganger_for_bruker`-snittet, (b) ingen tak i fase 1, bare
      tildelinger ∪ åpne roller, (c) et eget tak for ID-porten-klienten.
      Underveis ble også (a') vurdert: samme tak som Feide-appen, men uten gulv for personer.
      **Besluttet (c), med gulv.** ID-porten-klienten blir en egen applikasjon med egen tabell
      (f.eks. `idporten_applikasjon`, nøklet på `client_id`, som `maskinporten_applikasjon`) og
      et eget delegeringstak. Personen får den vanlige formelen via `tilganger_for_bruker`
      uendret: `(tak ∩ (tildelinger ∪ gulv)) ∪ åpne − nekt`. En ukjent `client_id` gir bare
      åpne roller og feiler dermed lukket.
      **Begrunnelse:** ID-porten-stien skal ikke legges inn i Feide-flyten. Å koble klienten til
      `feide_applikasjon` ville gjort tabellnavnet misvisende. Personer skal også kunne få
      tilgangsgulvet.
      **Avklaringer fra drøftingen:** taket er en egenskap ved appen, og organisasjonene i
      resultatet kommer fra tildelingene, ikke fra Feide-realm (`tilganger_for_feidetjeneste_og_bruker`
      sender `NULL` som organisasjonsbegrensning, 0063). Taket gir derfor mening uten en
      Feide-organisasjon. Gulvet er ikke avgrenset til hjemorganisasjonen
      (`docs/tilgangsmodell.md`, «Gulvet gjelder alle organisasjoner — begrenset av taket»), så
      en person får gulvet fra alle organisasjoner i ID-porten-appens tak, akkurat som en
      Feide-bruker får det fra Feide-appens tak i dag.
      **Konsekvenser for planen:**
      - `applikasjon_brukerdelegering` har FK rett mot `feide_applikasjon`. Dokumentasjonen kaller
        det en databasegaranti for at «delegering gjelder kun Feide-apper». Enten må FK-en løsnes
        til å dekke `idporten_applikasjon`, eller så trengs en egen delegeringstabell. Det er et
        valg for `bat-plan`, og dokumentasjonen må oppdateres.
      - Ny subjekttype for ID-porten-appen, med sin plass i `subjekt_er_person`-splitten
        (applikasjonsgrenen), og forvaltning av tak og registrering av `client_id`.
      - Coprocessoren trenger et oppslag for (env, `client_id`, fødselsnummer) i ett kall,
        etter mønsteret fra `tilganger_for_feidetjeneste_og_bruker`, inkludert
        `subgrafrolle`-filteret fra 0063.
      - `client_id` er ukjent til Digdir-registreringen finnes. Tester kjøres mot den lokale
        JWKS-stubben med en testklient.
- [x] **GraphQL-form for personer.** Alternativer: (a) egen `Person`-type med egne felter og
      mutasjoner, (b) felles interface over `FeideBruker` og `Person` (f.eks. `Personbruker`),
      (c) utvid `FeideBruker`. Alternativ (c) passer dårlig med `@table`.
      **Besluttet: egen type `IdPortenBruker`.** Det er (a), men med et navn som sier i API-et
      hva typen er ment for. Den får en parallell flate til `FeideBruker` med egen connection,
      tilganger, registrering og fjerning av tilganger. Filtre og `@service`-klasser er egne, og
      ingen Feide-typer gjenbrukes.
      **Merk for planen:** databasen bruker i dag det motsatte prinsippet. 0073 kaller
      subjekttypen `person` og tabellen `personsubjekt` med vilje («subjektet er mennesket, ikke
      innloggingsmetoden»). Med `IdPortenBruker` i API-et og `person` i basen er
      navneforskjellen bevisst: API-et navngir bruksområdet, basen navngir subjektet. `bat-plan`
      bør enten dokumentere dette skillet eller ta stilling til om basen skal følge API-et.
      Rettighetskodene (`BRUKERADMIN_PERSON_*`) står i samme valg.
- [x] **DELETE på `personsubjekt`.** Skal app-rollen beholde DELETE (0073), eller skal fjerning
      bare skje via tildelinger, slik kravet beskriver?
      **Besluttet: behold DELETE i basen.** Det viktige er at en administrator bare kan slette
      tildelinger. Grafflaten får derfor ingen mutasjon som sletter en `IdPortenBruker`, bare
      fjerning av tilganger. DELETE-privilegiet og `personsubjekt_skriv` blir stående som i 0073,
      som en opprydningssti utenfor API-et. Funn 11 er dermed håndtert: kravets fjerning via
      tildelinger er den eneste stien en administrator har. `personsubjekt_skriv` må likevel
      bytte nøkkel til personprivilegiet (spørsmål 1).
- [x] **Audiensverdi i dev/test.** Pinne en testaudiens nå (mot JWKS-stubben) og la
      produksjonsverdien vente på Digdir, eller vente med hele audienskravet?
      **Besluttet: pinn nå, fail-closed.** `quarkus.oidc.idporten.token.audience` (og tilsvarende
      for `idporten-test`) settes fra en påkrevd konfigurasjonsverdi. `application-test.properties`
      får en testverdi, og avvisning ved feil audiens testes mot JWKS-stubben. Mangler verdien i en
      profil, feiler oppstarten, i stedet for at alle audienser godtas. Begrunnelse: kravet er nå
      en regel, og en stille «godta alt» er den farligste feiltilstanden.
      **Konsekvens for planen:** én deployment betjener alle miljø, og
      `application-platon-production.properties` har ID-porten-tenantene konfigurert. Med
      påkrevd audiens kan branchen ikke rulles ut til produksjon før Digdir-verdien finnes. Ellers
      må ID-porten-tenantene slås av i produksjonsprofilen til da. `bat-plan` må velge en av
      delene.
