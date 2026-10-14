# Task #12 Completion Report: Dokumentasjon

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-25
**Task**: Dokumentasjon
**Priority**: Medium
**Size**: S

## Summary
`docs/tilgangsmodell.md` beskriver nå personer uten Feide og ID-porten-stien. Et nytt kapittel dekker
personsubjektet, rettighetene, registreringen, synligheten, innloggingen, taket, appene, utstederen og de
kjente begrensningene. Tekst som var blitt usann, er rettet på stedet. Headeren «HVORFOR KUN
FeideApplikasjon» i `schema_delegeringstak.graphqls` sier nå det som gjelder. Det samme gjelder to
beskrivelser i samme fil som påsto at bare Feide-apper har tak.

## Files Created
Ingen.

## Files Modified
### 1. `fs-plattform/tilgangsstyring/docs/tilgangsmodell.md`
- Innledningen og «Hvor ting bor»: ID-porten er med som flyt, og `0078`–`0086` er nevnt.
- Subjekttabellen har fått `person` / `personsubjekt` og `idporten_applikasjon`. Navneskillet mellom
  basen og API-et står rett under tabellen.
- Privilegielisten har fått `BRUKERADMIN_PERSON_*`. «Person-flaten» om Feide-privilegiene er rettet til
  «Feide-brukerflaten».
- `subjektnavn` gjelder både `feide_bruker` og `person`.
- Tildelingstabellen: taket gjelder `feide_applikasjon` og `idporten_applikasjon`, og nekt gjelder kun
  `feide_bruker`.
- Delegeringstaket: garantien er nå kompositt-FK-en med CHECK på de to apptypene, ikke den gamle FK-en.
- Selektortabellen: raden for `tilganger_for_apne_roller` (0077) er byttet ut med
  `tilganger_for_idporten_bruker` (0083). Avsnittet om funksjoner som bare er GRANT-et til
  coprocessorrollen, nevner `tilganger_for_idporten_bruker` og `idporten_klient_finnes` (0084). Avsnittet
  om `tilganger_for_apne_roller` er fjernet.
- Nytt kapittel «Personer uten Feide og ID-porten»:
  - personsubjektet og `personsubjekt_med_navn`
  - personfamilien og at den er atskilt fra Feide-rettighetene
  - registrering: `registrer_person`, restlekkasjen, fødselsnummervalideringen og at blankt navn gir en
    generell feil
  - synlighet og fjerning (0086), med asymmetrien mot Feide-siden
  - innlogging: tabell over formelen for registrert, uregistrert, ukjent og deaktivert, og hvorfor ukjent
    og deaktivert app gir forskjellig svar
  - taket som avgjør gulvet: FS Admin nei, Min Kompetanse ja, og regelen som står uten test
  - ID-porten-appene med kopiert og deretter uavhengig tak, og T1
  - utsteder og audiens
  - kjente begrensninger
- RLS: typesplitten med tre grener, lukket for ukjente menneskelige typer, og et eget punkt for
  `personsubjekt`.
- Miljøløse tabeller: raden for `idporten_applikasjon` er lagt til.
- Testdekning: en linje for settene 69–77.

### 2. `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_delegeringstak.graphqls`
- Headeren «HVORFOR KUN FeideApplikasjon» sier nå at en takrad kan høre til begge apptypene
  (kompositt-FK + CHECK), og at flaten likevel bare dekker Feide-apper. Grunnene:
  `kan_forvalte_delegering` slår opp eierorganisasjonen i `feide_applikasjon`, ID-porten-appene finnes
  ikke i grafen, og ID-porten-taket endres via migrering til T1 er avklart.
- Beskrivelsen av `LeggTilBrukerdelegeringerInput.applikasjonId` og beskrivelsen av
  `BrukerdelegeringApplikasjonFinnesIkke` sa «Kun Feide-applikasjoner har et delegeringstak». Det er
  rettet til «Bare Feide-applikasjoners tak forvaltes her».

### 3. `fs-plattform/tilgangsstyring/demo/idporten/README.md`
Setningen «samme dual-utsteder-oppsett som `platon-production`» var usann etter Task #8. Den er erstattet
med en henvisning til «Utsteder og audiens».

## Key Features Implemented
### ✅ Personer uten Feide og ID-porten er dokumentert i tilgangsmodellen
### ✅ Utdatert tekst er rettet på stedet (0077-selektoren, FK-garantien, subjektnavn, nekt, schema-headeren)

## Project skills consulted
Ingen passet. Oppgaven er ren dokumentasjon. `subgraph-expand` og `subgraph-plan` gjelder nye felt eller
typer, og her endres bare kommentarer og beskrivelser. RETNINGSLINJER.md, «Dokumentasjon og kommentarer»,
er fulgt: intensjonen først, kort tekst, ingen historiefortelling. Begrunnelsene står der de trengs for å
forstå regelen.

## Test Results
- `mise exec -- mvn -q -o -pl :tilgangsstyring-app test-compile`: exit 0. Graphitron genererer fra det
  endrede skjemaet.
- `mise exec -- mvn -q -o -pl :tilgangsstyring-app test -Dtest='DelegeringstakGraphqlTest,*Schema*'`:
  13 av 14 besto. `DelegeringstakGraphqlTest.lesefeltet` feilet. Den står på listen over kjente,
  urelaterte feil i Task #11, og feilen gjelder data (`erAktivNaa`), ikke beskrivelser.
- Påstandene i teksten er sjekket mot migreringene 0013, 0076 og 0078–0086: nekt-FK-en,
  `bruker_er_deaktivert`, synlighetsfilteret på Feide-siden, `idporten_applikasjon_skriv` og GRANT-ene.

## Technical Decisions
### 1. Ett nytt kapittel og punktvise rettelser, ikke et eget dokument
**Hvorfor:** planen legger dokumentasjonen i `tilgangsmodell.md`, og tekst som var blitt feil, sto spredt i
dokumentet. Rettelsene står på stedet. Kapittelet samler det som bare gjelder personer.
### 2. Utstederen er beskrevet i tilgangsmodellen, med en lenke til `en-instans-for-alle-miljo.md`
**Hvorfor:** ingen eksisterende docs-fil beskrev ID-porten-tenantene. `en-instans-for-alle-miljo.md`
beskriver bare gaten på subgraf-stien og stemmer fortsatt, så den er ikke rørt.
`coprocessor-metrikker.md` dekker allerede telleren for ukjente klienter.
### 3. To begrensninger utover akseptansekriteriet
Ingen nekt og ingen deaktivering av personen, fordi `brukerrollenekt` og `bruker_er_deaktivert` bare
kjenner `feide_bruker` (analyse v3, funn 6). Det står med fordi formelen viser «− nekt» for personer, og
leddet er alltid tomt.

## Build Status
✅ **Build successful**: `test-compile` gir exit 0
✅ **Ingen kodeendring**: bare kommentarer, beskrivelser og markdown
✅ **Ingen migreringsfiler er rørt**

## Integration Points
- Skjemabeskrivelsene er endret, så SDL-en har en ren tekstdiff. Det er ingen strukturell endring.
- `demo/idporten`: skriptene ser ikke ut til å sette `aud`. Da avviser audienskravet fra Task #8 tokenene
  deres. Dette er ikke verifisert og ikke rettet, fordi det ligger utenfor dokumentasjonsoppgaven.

## Acceptance Criteria Met
- ✅ `person` og navneskillet, typesplitten og den lukkede grenen, personfamilien, `idporten_applikasjon` med
  kopiert og deretter uavhengig tak, den nye FK-en, at taket avgjør gulvet og at regelen står uten test.
  Evidens: `tilgangsmodell.md`, under subjekttabellen, «Delegeringstaket», RLS-punktet og kapittelet
  «Personer uten Feide og ID-porten».
- ✅ Kjente begrensninger: sporing, saksbehandlergren (0069), hjemorganisasjon (0073) og sudo. Evidens:
  «Kjente begrensninger».
- ✅ Ukjent app gir åpne roller, deaktivert app gir tomt. Evidens: «Innlogging», med tabell og avsnitt.
- ✅ Restlekkasjen ved gjenregistrering. Evidens: «Registrering og tildeling».
- ✅ Headeren «HVORFOR KUN FeideApplikasjon» er rettet. Evidens: `schema_delegeringstak.graphqls:11–17`.
- ✅ RETNINGSLINJER er fulgt. Hvert avsnitt har intensjonen først, og det er ingen saksreferanser i
  koden eller skjemaet. Migreringsnumrene står i docs, som i resten av dokumentet.
- ✅ Carry-over fra Task #4, #5, #7, #8, #9, #10 og #11 er tatt inn.

## Next Steps
- Reviewer: se over hvordan asymmetrien i 0086 er formulert i «Synlighet og fjerning» (Task #11 ber om at
  valget bekreftes).
- Oppfølging: kontroller `demo/idporten` mot audienskravet.

## Conclusion
Dokumentasjonen er i tråd med koden slik den står etter Task #1–#11. Klar for review.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
