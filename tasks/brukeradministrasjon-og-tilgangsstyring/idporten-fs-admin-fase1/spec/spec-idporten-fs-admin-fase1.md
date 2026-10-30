# Spec: ID-porten som utsteder i coprocessoren (fase 1)

## Kilde

- **Type:** `lokal`
- **Lokal kilde:**
  - **Kilde-mappe:** `krav/07 Brukeradministrasjon og tilgangsstyring/10 Pålogging` (repo-relativ, sikt-no/fs)
  - **Filter:** kun `.feature`-filer med `@planned` på `Egenskap:`. Én av tre filer i mappa passerte; `feide_innlogging.feature` og `idporten_pålogging.feature` (opptakspilot) er ikke i scope.
- **Krav-issue:** [sikt-no/fs#476](https://github.com/sikt-no/fs/issues/476) — Innlogging til FS Admin for fagskoleansatte
- **Avklaringsissue:** [sikt-no/fs#514](https://github.com/sikt-no/fs/issues/514) — betaling og avtaler for ID-porten (avklart 18.09.2026: Sikt betaler)
- **Bakgrunn:** [Påloggingsløsninger (med og uten fnr og d-nr)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5022777363) i Confluence, seksjonen «Faser», rad **1. ID-porten som utsteder i coprocessoren**
- **Hentet:** `2026-09-18`

## Krav

Fase 1 av ID-porten-innlogging for FS Admin: coprocessoren i `tilgangsstyring` skal godta tokener utstedt av ID-porten som en egen utsteder, ved siden av Feide og Maskinporten, og utstede det interne tokenet med identitet og autentiseringsmetode. Tilgangssettet er tomt inntil fase 2a. Innloggingsflyten i fs-admin (fase 1b) og tilganger for ikke-Feide-brukere (fase 2a) er **ikke** en del av denne specen.

- **`autentisere_med_idporten.feature`** (`@TIL-PÅL-PÅL-003 @must @integration @planned`) — Autentisere mot FS GraphQL API med ID-porten. Tre regler: ID-porten som egen utsteder (gyldig token godtas, ugyldig avvises), tomt tilgangssett gir kun åpen funksjonalitet, og ID-portens testmiljø kan brukes i utvikling og test. ([krav-input/local/01 Pålogging/autentisere_med_idporten.feature](krav-input/local/01%20P%C3%A5logging/autentisere_med_idporten.feature))

Beslutninger fra Confluence som kravet bygger på:

- ID-porten integreres **direkte**, ikke via Feide («Feide login with ID-porten» er forkastet).
- Sikt er selv klient hos Digdir; én ny utsteder i coprocessoren dekker både FS Admin og Min kompetanse.
- `amr` settes til utstedernavnet (`["idporten"]`). `acr` bæres ikke videre; det legges inn når noe skal håndheve det.
- Å **kreve** `loa-high` for saksbehandling er parkert.
- Tilgangsoppslaget skal returnere tomt for en ID-porten-bruker, ikke feile.

## Skisser

Ingen skisser registrert. Kravet er på API-nivå (`@integration`) og har ingen brukerflate.

## Åpne spørsmål

Kravspørsmål som må avklares før eller under `bat-analyze`. De tre første står også som `# ÅPNE SPØRSMÅL:` i kravfila.

- [ ] **Audiens.** Hvilken audiens skal coprocessoren kreve på ID-porten-tokenet? Kan FS GraphQL API settes som audiens i autorisasjonsflyten fs-admin starter, eller trengs token exchange som for Feide? Confluence (fase 1) forutsetter direkte validering uten exchange.
- [ ] **Subjekt.** Hva blir subjektet i det interne tokenet for en ID-porten-bruker: fødselsnummer (`pid`) eller ID-portens egen `sub`?
- [ ] **Testutsteder.** Skal ID-portens testmiljø behandles som test-Maskinporten, altså kun godtas mot syntetiske datamiljøer og avvises mot produksjonsdata? (`@openquestion` på scenarioet «Token fra ID-portens testmiljø godtas i syntetiske datamiljøer».)
- [ ] **Forutsetning utenfor kravet.** Klientregistrering hos Digdir (fase 0) er ikke bestilt per 18.09.2026 og blokkerer ende-til-ende-test, også i testmiljø. Fase 1 utvikles mot ID-portens testmiljø i mellomtiden.
