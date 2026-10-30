# Analysis: ID-porten for personer via Min Kompetanse (iterasjon 3)

## Problem Statement

Delta-spec-en [`spec-changes-2026-09-24-idporten-min-kompetanse.md`](../spec/spec-changes-2026-09-24-idporten-min-kompetanse.md)
legger til **TIL-PÅL-PÅL-004**. En person som logger inn med ID-porten, skal få tilganger ut fra
applikasjonen hun kommer via:

- Via Min Kompetanse får personen grunntilgangen (gulvet).
- Via FS Admin og via en ukjent klient får personen bare de åpne rollene.
- Innloggingen registrerer ikke personen.

Delta-en tar også med **TIL-PÅL-PÅL-003** som kontekst, og den har tre beslutninger som utvider kravteksten:

1. «Grunntilgang» og «åpent for alle innloggede» er to ulike sett: gulvroller mot åpne roller.
2. En registrert person får de tildelte rollene sine via Min Kompetanse, men bare så langt taket
   tillater. Gulvet kommer i tillegg.
3. Reglene i 003 om signatur, audiens, acr og testmiljø gjelder alle ID-porten-klienter.

Sett fra koden er tilgangsberegningen allerede riktig for 004. Det som mangler, er koblingen fra
ID-porten-tokenets `client_id` til en applikasjon med tak. I dag ser coprocessoren bort fra
`client_id`, og alle ID-porten-innlogginger får de samme åpne rollene.

## Current State

### Coprocessoren: ID-porten-grenen

- `IdportenAuthenticator` bygger et `AuthorizationCodeResult("idporten", client_id, sub, …, pid, …, acr)`
  (`tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/IdportenAuthenticator.java:47-56`).
  `client_id` bæres altså gjennom.
- `hentActualOrgTilganger` (`CoprocessorService.java:743-750`) går ubetinget til
  `tilgangerForApneRoller(env)` når utstederen er `idporten`. `client_id` og `nin` brukes ikke.
  Kommentaren der sier «Her finnes det ikke noe tak, bare modellens gulv».
- `client_id` brukes bare i claimet `client_id` i det interne tokenet (`CoprocessorService.java:765, 945`).

### Tilgangsberegningen (0061)

`tilganger_for_bruker(env, bruker, app, org_begrensning)` (`0061-sudo-orgtilganger.sql:259-282`)
regner ut `(tak(app) ∩ (tildelinger(bruker) ∪ grunntilganger)) ∪ åpne − nekt(bruker)`.
Funksjonen `kombiner_tildelinger` gjør beregningen (`0061…sql:217-241`).

- **Gulvet heter «grunntilgang» i koden.** Tabellen er `bruker_grunntilgang`, funksjonen er
  `raa_grunntilganger(env)` (`0061…sql`). Gulvet er per (organisasjon, rolle, miljø) og har ikke
  noe subjekt. `docs/tilgangsmodell.md:154, 171-237` beskriver det som «gulvet», som bare løfter
  brukerdimensjonen og er begrenset av taket.
- **Åpne roller** er en egen dimensjon (`raa_apne_roller` / `utvidede_apne_roller`) som legges til
  utenfor taket.
- Med `bruker = NULL` (uregistrert) blir `raa_tilganger` NULL, og NULL-konkateneringen gir bare
  gulvet (kommentar `0061…sql:253-255`). Resultatet blir `(tak ∩ gulv) ∪ åpne`.
- Med `app = NULL` (ukjent klient) gir `raa_delegeringstilganger` NULL, og
  `ARRAY(SELECT … FROM unnest(NULL))` gir `'{}'`. Da er taket tomt, og resultatet blir `åpne − nekt`.
- Vetoene: `applikasjon_er_deaktivert` (`0019…sql`) ser på `maskinbruker_applikasjon`,
  `feide_applikasjon` og `maskinporten_applikasjon`. `bruker_er_deaktivert` (`0033…sql`) ser bare
  på `feide_bruker`. En deaktivert app gir **tomt** resultat, ikke engang åpne roller.

### Selektorene for coprocessoren (0063, 0077)

- Hver selektor som `${coprocessor_role}` har EXECUTE på, filtrerer på `subgrafrolle`
  (`0063-subgrafroller-i-claim.sql:9-12, 40-107`).
- `tilganger_for_feidetjeneste_og_bruker` (`0063…sql:73-86`) slår opp `feide_applikasjon` på
  `service_id` og `feide_bruker` på `feide_id`, og sender `NULL` som organisasjonsbegrensning.
- `tilganger_for_apne_roller` (`0077-apne-roller-uten-tildelinger.sql:23-32`) har ingen identitet
  og ingen app. Headeren sier at en bruker uten den «havner UNDER gulvet», men det funksjonen
  gir, er de åpne rollene.

### Applikasjonene og takene

- `applikasjon_brukerdelegering` har en FK rett mot `feide_applikasjon`
  (`0003-create-tilgangsstyring-tables.sql:472-474`), med kommentaren «delegering gjelder kun
  Feide-apper». Tabellkommentaren er gjentatt i `0043…sql:105-114`.
- `feide_applikasjon.client_id` er Feide-klientens OAuth-id. Et eksempel er
  «Min kompetanse (test)», `e59e013f-…` (`0003…sql:237-240`). Det er ikke en ID-porten-klient.
- Det finnes ingen `idporten_applikasjon`, og ingen `tilganger_for_idporten*`. Søk i `*.sql` og
  `*.java` gir null treff.

### Eksempeldata for Min Kompetanse (alt i `context:@eksempeldata`)

| Hva | Innhold | Kilde |
|---|---|---|
| Feide-app | `-21` «Min kompetanse (test)», org 7777 | `0003…sql:237-238` |
| Tak | `student` @ 7777 og 7778, `test` | `0003…sql:517-520` |
| FS Admins tak | `saksbehandler` @ 7777 og 7778 | `0003…sql:521-` |
| Gulv | `student` @ 7777 og 7778, `test` | `0013-tilgangsmodell.sql:491-493` |
| Navnerom for `student` | `sis` (subgraf), så rollen slipper gjennom claimfilteret | `0063…sql:209-222` |

Med dataene over gir Feide-stien allerede det 004 beskriver: en uregistrert bruker via
Min Kompetanse får `student` fra gulvet, og via FS Admin får hun ingenting utover åpne roller.
Ingen av radene finnes i deployerte miljø, fordi `@eksempeldata` ikke kjører der (`--contexts=rds`,
se `0051…sql:72-77`).

### Personsubjektet (ucommittet)

`0078-personsubjekt.sql` (tidligere `0073`, renummerert etter rebasen på main) og pgTAP-filen
`69_personsubjekt.sql` ligger fortsatt ucommittet. Innholdet er som i iterasjon 2: Feide-rettighetene,
`opprett_personsubjekt` og ingen coprocessoroppslag. Plan v2 Task #1–#4 er ikke gjennomført.

### Plan v2

[`plan-idporten-fs-admin-fase1-v2.md`](plan-idporten-fs-admin-fase1-v2.md) har allerede tatt
Min Kompetanse inn som tilrettelegging (Task #5, #7, #12, T1, og sporbarhetslinjen for 004). Ingen
av tasks-ene er gjennomført i koden.

### Tester

- `IdportenCoprocessorTest.java` er ende-til-ende-testen med én fast `CLIENT_ID` (`:116, :203`).
- `IdportenAuthenticatorTest.java` har én `TEST_CLIENT_ID` (`:93, :140`).
- `68_apne_roller_uten_tildelinger.sql` fester `tilganger_for_apne_roller`. `37_…` og `42_…` fester
  takene.
- Ingen test sender samme `pid` via to ulike `client_id`-er.

## Key Findings

1. **Tilgangsformelen gir allerede 004. Det som mangler, er oppslaget.** `tilganger_for_bruker` med
   `bruker = NULL` gir `(tak ∩ gulv) ∪ åpne`. Med Min Kompetanses tak blir det gulvet, med FS Admins
   tak blir det bare åpne roller (saksbehandler ∩ student = ∅), og med `app = NULL` blir det bare åpne.
   Regel 1 og 3 i 004 er dermed spørsmål om data og om hvilken app `client_id` peker på. Det trengs
   ingen ny beregningslogikk. Beslutning 1 i delta-spec-en («grunntilgang» = gulvet) samsvarer
   ordrett med kodens begrep `bruker_grunntilgang` / `raa_grunntilganger`.

2. **I dag feiler scenariet «Person får grunntilgangen via Min Kompetanse».** ID-porten-grenen
   (`CoprocessorService.java:748-750`) gir åpne roller for alle klienter. Scenariene «ingen
   organisasjonstilganger via FS Admin» og «ukjent klient» består, men bare fordi *alle* får det
   samme. En test som bare sjekker de to, oppdager ikke at Min Kompetanse mangler gulvet.

3. **Det finnes ingen vei fra ID-porten-`client_id` til en applikasjon.** `feide_applikasjon.client_id`
   er Feide-klientens id, og FK-en på `applikasjon_brukerdelegering` tillater bare Feide-apper
   (`0003…sql:472-474`). Et tak for en ID-porten-klient kan ikke lagres uten en skjemaendring. Dette
   er det plan v2 Task #5 dekker.

4. **En ukjent klient feiler lukket, men en deaktivert app feiler hardere.** Med `app = NULL` gir
   formelen åpne roller, og det stemmer med 004 regel 3. Det gjelder også når `client_id`-claimet
   mangler. Er appen derimot registrert og **deaktivert**, gir `tilganger_for_bruker` tomt resultat
   (`0061…sql:280`), altså ikke engang åpne roller. `applikasjon_er_deaktivert` kjenner dessuten bare
   de tre eksisterende apptabellene. En ny ID-porten-apptabell blir ikke sett av vetoet, med mindre
   den legges inn der.

5. **NULL-fella i organisasjonsbegrensningen.** `p_begrenset_til_organisasjonskoder = NULL` betyr
   *ubegrenset*. Kommentaren i `tilganger_for_feidebruker_med_fs_fiktivt_fnr` (`0063…sql:94-96`)
   advarer mot akkurat det. Feide-stien sender NULL med vilje, fordi taket gjør avgrensningen. Det
   samme gjelder for ID-porten, og det holder bare så lenge et tomt eller ukjent tak gir `'{}'` og
   ikke blir tolket som «ingen begrensning».

6. **Beslutning 2 (registrert person via Min Kompetanse) følger av samme formel.** Når personen er
   registrert, gir `tilganger_for_bruker(env, person, MK-app, NULL)`
   `(MK-tak ∩ (tildelinger ∪ gulv)) ∪ åpne − nekt`. En saksbehandler med roller fra FS Admin får
   altså bare det Min Kompetanses tak bærer (`student` i eksempeldata). Oppslaget krever
   personkoblingen fra plan v2 Task #7. Det finnes ennå ikke noe scenario i 004 og ingen test for det.
   `bruker_er_deaktivert` kjenner bare `feide_bruker`, så personer har ikke noe deaktiveringsveto.

7. **«Innlogging registrerer ikke personen» er oppfylt av konstruksjonen.** Coprocessorrollen har
   bare `USAGE` på skjemaene (`0009-grant-coprocessor-role.sql:12-14`) og EXECUTE på `STABLE`-selektorer.
   `TilgangsstyringDataTilgangerService` gjør bare `selectFrom`. Feide-stien registrerer heller ikke
   brukere ved innlogging. Kravet kan testes direkte: ingen `personsubjekt`-rad etter en innlogging.

8. **003-reglene gjelder allerede per utsteder og ikke per klient, bortsett fra audiensen.** Signatur,
   utløp og testmiljø-gaten ligger på tenantene `idporten` / `idporten-test` og er uavhengige av
   `client_id`. acr bæres for alle (iterasjon 1). Audiensen er fortsatt ikke satt i noen profil
   (`application.properties:237`), så 003-regelen om audiens er uoppfylt for alle klienter. Siden
   FS Admin og Min Kompetanse ber om samme audiens, kan audiensen ikke skille appene. `client_id` er
   den eneste diskriminatoren.

9. **Kodekommentarene bruker «gulv» om åpne roller, og det er i strid med beslutning 1.**
   `CoprocessorService.java:744-747` («bare modellens gulv»), javadoc-en på `tilgangerForApneRoller`
   (`TilgangsstyringDataTilgangerService.java:~69-74`, «Gulvet for en innlogget bruker …») og
   headeren i `0077…sql:6-9` («havner UNDER gulvet») kaller de åpne rollene gulvet. Dokumentasjonen
   (`docs/tilgangsmodell.md`) holder skillet riktig. Når Min Kompetanse-stien gir det faktiske gulvet,
   blir kommentarene direkte misvisende.

10. **Gulv og tak for Min Kompetanse finnes bare i eksempeldata.** I deployerte miljø finnes verken
    `bruker_grunntilgang`-rader eller Min Kompetanses tak i migreringene. Om 004 gir noe i test eller
    produksjon, avhenger av data som forvaltes utenfor repoet. Det kan ikke leses ut av koden.

11. **Sudo-stien for en ID-porten-bruker gir tomt resultat.** Når `sudoUsername` er satt, bygges et
    `AuthorizationCodeResult` med `issuer = null` (`CoprocessorService.java:651-655`). ID-porten-grenen
    treffes da ikke, `externalServiceId` er null, og resultatet blir `Orgtilganger.EMPTY`, ikke engang
    åpne roller. Ingen av kravene omtaler sudo for ID-porten-brukere.

## Technical Constraints

- **Liquibase-checksum:** kjørte changesets kan ikke redigeres. `0078` er ukjørt og kan endres. FK-en
  og vetoet (`0003`, `0019`) må endres i nye filer.
- **Claimfilteret:** hver ny selektor for coprocessoren må filtrere på `subgrafrolle`, og den må
  grantes bare til `${coprocessor_role}` (0063, 0077).
- **SECURITY DEFINER** for coprocessorselektorene, fordi rollen ikke har tabellrettigheter (0077,
  kommentar linje 15-16).
- **Tidsbudsjett:** 900 ms totalt, inntil 500 ms databaseoppslag (`docs/tidsbudsjett.md`). Oppslaget
  for (env, `client_id`, `pid`) må være ett kall.
- **Takregelen (0043):** taket må følge rollekatalogen. En ny rolle som brukes gjennom en app, trenger
  takrader i samme endring. Det gjelder nå begge takene til Min Kompetanse og FS Admin.
- **Fødselsnummer sladdes i logg** (`Fodselsnummer.sladd`).
- **Dokumentasjon og kommentarer** (RETNINGSLINJER): kommentarer som beskriver åpne roller som gulv,
  skal ikke bli stående når gulvet får en egen betydning på ID-porten-stien.

## Dependencies

- **Internt:**
  - `CoprocessorService.hentActualOrgTilganger` og `TilgangsstyringDataTilgangerService`: ny gren på
    `client_id` (funn 2).
  - `applikasjon_brukerdelegering` (FK), `applikasjon_er_deaktivert` og `docs/tilgangsmodell.md`
    (funn 3 og 4).
  - Personoppslaget fra plan v2 Task #7 (funn 6).
  - `IdportenCoprocessorTest` og JWKS-stubben: trenger flere `client_id`-er og samme `pid` (funn 2).
  - `tilgangsstyring-new-jooq`: regenerering for nye tabeller og funksjoner.
- **Eksternt:**
  - Digdir: ID-porten-klienter for FS Admin og Min Kompetanse. Det gir `client_id`-verdiene og
    audiensen. Dette er en ekstern forutsetning (delta-beslutning 5).
- **Cross-contributor:**
  - **Min Kompetanse (frontend, kompetanse-domenet):** innlogging med ID-porten og tokenforespørsel
    mot FS GraphQL API-audiensen. Uten det finnes det ingen klient å teste mot utenfor stubben.
  - **Forvaltning av tak og gulv:** i deployerte miljø må Min Kompetanses tak og gulvradene finnes
    (funn 10). Det er rolleforvaltning, ikke kode.

## Requirements Impact

| Krav / regel | Status i koden i dag | Vurdering |
|---|---|---|
| **004** — Min Kompetanse gir grunntilgangen | **Ikke dekket** | Funn 1–3. Formelen er klar, men oppslaget på `client_id` mangler. |
| — samme person via FS Admin får ingen organisasjonstilganger | Dekket, men av feil grunn | Funn 2: alle får åpne roller. |
| — innlogging registrerer ikke personen | Dekket av konstruksjonen | Funn 7. Kan festes med en test. |
| — ukjent klient får bare åpne roller | Dekket, men av feil grunn | Funn 2 og 4. Deaktivert app gir tomt. |
| Beslutning 1: gulv ≠ åpne roller | Riktig i modellen, feil i kommentarer | Funn 9. |
| Beslutning 2: registrert person via Min Kompetanse | **Ikke dekket** | Funn 6. Krever personoppslaget, og mangler scenario. |
| Beslutning 3: 003-reglene for alle klienter | Delvis | Funn 8. Audiensen er uoppfylt for alle klienter. |
| **003** — øvrige regler | Uendret fra iterasjon 2 | Se analyse v2. |

- **Krav adressert av eksisterende kode:** 004 regel 2 (ingen registrering). Tilgangsformelen og
  eksempeldataene for Min Kompetanse (tak og gulv).
- **Krav med risiko:**
  - Scenariene «via FS Admin» og «ukjent klient» består i dag uten at mekanismen finnes. Uten en test
    som også dekker Min Kompetanse, kan en implementasjon se grønn ut uten å være riktig (funn 2).
  - Deaktivert ID-porten-app. Det kan gi tomt resultat eller ikke bli oppdaget i det hele tatt (funn 4).
- **Manglende krav oppdaget:**
  - Et scenario for registrert person via Min Kompetanse (beslutning 2). Det er vedtatt, men ikke
    skrevet inn i 004.
  - Hva en deaktivert ID-porten-applikasjon skal gi, sammenlignet med en ukjent klient (funn 4).
  - Sudo for ID-porten-brukere (funn 11).

## Krav-input referanse

- **Delta-spec (primær):** [`spec-changes-2026-09-24-idporten-min-kompetanse.md`](../spec/spec-changes-2026-09-24-idporten-min-kompetanse.md)
- **Delta-manifest:** [`krav-input/changes/2026-09-24-idporten-min-kompetanse/manifest.md`](../spec/krav-input/changes/2026-09-24-idporten-min-kompetanse/manifest.md)
- **Forrige delta:** [`spec-changes-2026-09-23-idporten-personsubjekt.md`](../spec/spec-changes-2026-09-23-idporten-personsubjekt.md)
- **Analyse, iterasjon 2:** [`analysis-idporten-fs-admin-fase1-v2.md`](analysis-idporten-fs-admin-fase1-v2.md)

## Open Questions

- [x] **Deaktivert ID-porten-applikasjon.** Hva skal en person få når `client_id` peker på en
      registrert, men deaktivert app?
      (a) Tomt resultat, slik `tilganger_for_bruker` gjør for Feide-apper i dag.
      (b) Bare åpne roller, altså det samme som en ukjent klient (004 regel 3).
      (c) Avvise forespørselen som uautentisert.
      **Besluttet (a).** En deaktivert ID-porten-app gir tomt resultat, uten organisasjonstilganger
      og uten åpne roller. Begrunnelse: det er samme veto som for Feide-apper (`0061…sql:280`), og
      deaktivering er et bevisst stengsignal som er sterkere enn «ukjent». **Konsekvens for planen:**
      den nye apptabellen må inn i `applikasjon_er_deaktivert`. Ellers blir vetoet stille borte
      (funn 4).
- [x] **Scenario for registrert person via Min Kompetanse.** Beslutning 2 finnes ikke i 004.
      (a) Legg scenariet inn i 004 via `bat-krav` før planen oppdateres.
      (b) La planen og testene dekke det, og skriv kravet senere.
      **Besluttet (b).** Planen og testene dekker beslutning 2 nå, og kravet skrives inn i 004 senere.
      Begrunnelse: det holder oppdateringen av planen i gang uten en ny runde med krav. **Konsekvens:**
      `bat-verify` har ikke noe scenario å sjekke dette mot før 004 er oppdatert. Planen bør føre det
      som en test som sporer til delta-beslutning 2, og som et utestående kravpunkt.
- [x] **Tak og gulv i deployerte miljø.** Min Kompetanses tak og gulvradene finnes bare i
      eksempeldata (funn 10). Skal analysen regne med at de finnes i test og produksjon, eller skal
      det være en eksplisitt forutsetning for utrulling?
      (a) Eksplisitt forutsetning for utrulling. (b) Regn med at de finnes. (c) Legg dem i en migrering.
      **Besluttet (b).** Gulvet og taket for Min Kompetanses Feide-app finnes allerede i test og
      produksjon, og ID-porten-taket kopieres fra det. Planen trenger ingen egen forutsetning.
      Begrunnelse: brukerens kunnskap om de deployerte miljøene. Funn 10 står fordi repoet ikke viser
      det, men det regnes ikke som en risiko.
- [x] **«Gulv»-begrepet i koden.** Tre kommentarer kaller åpne roller for gulvet (funn 9). Skal
      rettingen høre til denne tasken, eller er det en egen opprydning?
      (a) Rett i denne tasken. (b) Egen opprydning.
      **Besluttet (a).** Java-kommentarene i `CoprocessorService.java:744-747` og javadoc-en på
      `tilgangerForApneRoller` rettes når ID-porten-grenen skrives om (plan v2 Task #7). Headeren i
      `0077` står, fordi migreringen er kjørt. `docs/tilgangsmodell.md` er fasit for begrepene.
      Begrunnelse: kommentarene sitter på koden som uansett endres, og de blir misvisende i det øyeblikket
      Min Kompetanse-stien gir det faktiske gulvet.
- [x] **Sudo for ID-porten-brukere.** Sudo med `sudoUsername` gir tomt resultat for en ID-porten-bruker
      (funn 11). Er det innenfor scope, eller skal det bare noteres?
      (a) Noter, utenfor scope. (b) Innenfor scope.
      **Besluttet (a).** Det føres som en kjent begrensning i planen. Begrunnelse: ingen krav ber om det,
      sudo-brukernavnet er en Feide-identitet, og tomt resultat feiler lukket.
