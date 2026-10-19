# Delta-spec: ID-porten-autentisering og personsubjekt uten Feide — 2026-09-23-idporten-personsubjekt

> Eksisterende krav som ikke er nevnt i denne delta-en forblir gjeldende. Endringer her erstatter eller utvider tidligere krav på de berørte områdene.

## Kilde

- **Type:** `test`
- **Kildefiler** (repo `sikt-no/fs`, begge ucommittet i working tree per henting):
  - [`krav/07 …/10 Pålogging/01 Pålogging/autentisere_med_idporten.feature`](<krav-input/changes/2026-09-23-idporten-personsubjekt/krav/07 Brukeradministrasjon og tilgangsstyring/10 Pålogging/01 Pålogging/autentisere_med_idporten.feature>)
  - [`krav/07 …/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon/opprette_person_uten_feide.feature`](<krav-input/changes/2026-09-23-idporten-personsubjekt/krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon/opprette_person_uten_feide.feature>)
- **Manifest:** [krav-input/changes/2026-09-23-idporten-personsubjekt/manifest.md](krav-input/changes/2026-09-23-idporten-personsubjekt/manifest.md)
- **Hentet:** `2026-09-23 15:46`

## Krav

### Krav

- **`autentisere_med_idporten.feature` — `@TIL-PÅL-PÅL-003 @must @integration`** (GitHub #476) — Forespørsler FS Admin gjør med en saksbehandlers ID-porten-token mot FS GraphQL API skal autentiseres. Kravet har seks regler:
  - **Egen utsteder:** ID-porten er en egen utsteder i coprocessoren, uavhengig av Feide. Et gyldig token gir et internt token med saksbehandlerens identitet og autentiseringsmetode `"idporten"`. Utløpt token eller ugyldig signatur avvises som uautentisert og når ikke subgrafene.
  - **Audiens:** tokenet må være utstedt for FS GraphQL API. Et token med en annen audiens avvises som uautentisert og når ikke subgrafene.
  - **acr:** autentiseringsnivået (`idporten-loa-substantial`, `idporten-loa-high`, `selfregistered-email`) bæres videre i det interne tokenet, men håndheves ikke i fase 1.
  - **Tilgangssett:** tilgangssettet følger personens tildelinger. En uregistrert person får ingen organisasjonstilganger, bare det som er åpent for alle innloggede. En registrert person med tildelt rolle får organisasjonstilgangene rollen gir.
  - **Testmiljø:** tokener fra ID-portens testmiljø godtas mot syntetiske datamiljøer og avvises mot miljøer med produksjonsdata.
  - **Forutsetning (kommentar i fila):** Sikt må være registrert klient hos Digdir (fase 0).

  ([krav-input/…/autentisere_med_idporten.feature](<krav-input/changes/2026-09-23-idporten-personsubjekt/krav/07 Brukeradministrasjon og tilgangsstyring/10 Pålogging/01 Pålogging/autentisere_med_idporten.feature>))

- **`opprette_person_uten_feide.feature` — `@BRU-PER-GRU-013 @must`** (GitHub #629) — En administrator skal kunne registrere en ansatt uten Feide-konto og gi henne tilganger før første innlogging med ID-porten. Kravet har seks regler:
  - **Fødselsnummer identifiserer personen:** en ny ansatt opprettes med den tildelte rollen. En som allerede er registrert på samme fødselsnummer får rollen lagt til på den eksisterende personen. Ugyldig fødselsnummer eller D-nummer avvises.
  - **Atskilt fra Feide-flyten:** rettigheten for Feide-brukere og rettigheten for personer uten Feide gir ikke tilgang til hverandres flyt, i noen av retningene.
  - **Før første innlogging:** ved første ID-porten-innlogging gjenkjennes den ansatte som den registrerte personen og har tilgangene rollen gir.
  - **Navn:** navnet administratoren oppga lagres, og det er sporbart hvem som opprettet personen.
  - **Synlighet:** synligheten følger tildelingene. En administrator finner personen og ser rollene hun selv har tildelt. En administrator uten rettighet i organisasjonen finner ingen person. En registrering i en annen organisasjon røpes ikke: rollen legges på den eksisterende personen, men administratoren ser bare egne tildelinger.
  - **Fjerning:** en person fjernes ved at alle tildelinger fjernes. Mister personen sin eneste tildeling, har hun ingen organisasjonstilganger og er ikke lenger synlig. Tildelinger gitt av andre organisasjoner beholdes.

  ([krav-input/…/opprette_person_uten_feide.feature](<krav-input/changes/2026-09-23-idporten-personsubjekt/krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon/opprette_person_uten_feide.feature>))

## Skisser

Ingen skisser registrert.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/07 …/10 Pålogging/01 Pålogging/autentisere_med_idporten.feature` | `@TIL-PÅL-PÅL-003 @must @integration @planned` | `@TIL-PÅL-PÅL-003 @must @integration @in-progress` |
| `krav/07 …/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon/opprette_person_uten_feide.feature` | `@BRU-PER-GRU-013 @must @planned` | `@BRU-PER-GRU-013 @must @in-progress` |

Begge filene er retagget direkte i `sikt-no/fs`. Ingen retagging er utestående.

## Åpne spørsmål

- [x] Kravene skal bruke samme personidentitet. Kravet sier at fødselsnummeret identifiserer personen (BRU-PER-GRU-013) og at en ID-porten-innlogging gjenkjennes som den registrerte personen.
  - **Beslutning:** `pid` (fødselsnummer eller D-nummer) fra ID-porten-tokenet er nøkkelen mot det registrerte personsubjektet, ikke ID-portens `sub`.
  - **Begrunnelse:** Avgjort i workshopen. Spørsmålet om «pid eller sub» er derfor fjernet fra TIL-PÅL-PÅL-003. `bat-analyze` tar bare den tekniske løsningen.
- [x] Rettigheten «administrere personer uten Feide-konto» er ny og atskilt fra Feide-rettigheten. Kravet sier ikke hva rettigheten heter eller hvem som tildeler den.
  - **Beslutning:** Delegeres til `bat-analyze`. Analysen skal se på hvordan rettigheten for å administrere Feide-brukere er modellert i dag, og foreslå navn og tildeling for en parallell rettighet.
  - **Begrunnelse:** Kravet stiller bare krav om at de to rettighetene er atskilte i begge retninger. Navn og tildeling er modelleringsvalg som bør følge eksisterende mønster.
- [x] BRU-PER-GRU-013 beskriver en administrasjonsflyt: registrere, søke opp, se og fjerne. Ligger den flaten i scope for denne tasken (tilgangsstyring-subgrafen), eller i fs-admin-tasken som kommer etterpå? `flow.md` sier at innloggingsflaten i fs-admin tas som egen task.
  - **Beslutning:** Backend-delen hører til denne tasken: database, API og mutasjoner i `fs-plattform/tilgangsstyring`. Den dekker registrering, avvisning av ugyldig fødselsnummer, atskilte rettigheter, synlighet og fjerning via tildelinger. Skjermbildene i fs-admin tas i fs-admin-tasken som kommer etterpå.
  - **Begrunnelse:** Følger fordelingen i `flow.md`: denne tasken er fs-plattform, og flaten i fs-admin kommer som egen task.
- [ ] Fase 0-forutsetningen for TIL-PÅL-PÅL-003 står fortsatt: Sikt må være registrert klient hos Digdir.
  - **Status 2026-09-23:** Registreringen er fortsatt ikke bestilt. Det er en ekstern avhengighet. Den blokkerer ikke analyse eller implementasjon, men uten den kan flyten ikke testes ende til ende mot ekte ID-porten. Spørsmålet står åpent til registreringen er på plass.
