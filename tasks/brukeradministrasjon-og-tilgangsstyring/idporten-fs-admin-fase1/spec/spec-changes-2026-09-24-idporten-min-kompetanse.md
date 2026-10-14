# Delta-spec: ID-porten for personer via Min Kompetanse, og tilganger som følger applikasjonen — 2026-09-24-idporten-min-kompetanse

> Eksisterende krav som ikke er nevnt i denne delta-en forblir gjeldende. Endringer her erstatter eller utvider tidligere krav på de berørte områdene.

## Kilde

- **Type:** `test`
- **Kildefiler** (repo `sikt-no/fs`, lokal working tree, ucommittet):
  - [`autentisere_person_med_idporten.feature`](krav-input/changes/2026-09-24-idporten-min-kompetanse/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/10%20P%C3%A5logging/01%20P%C3%A5logging/autentisere_person_med_idporten.feature) (`@TIL-PÅL-PÅL-004 @should`)
  - [`autentisere_med_idporten.feature`](krav-input/changes/2026-09-24-idporten-min-kompetanse/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/10%20P%C3%A5logging/01%20P%C3%A5logging/autentisere_med_idporten.feature) (`@TIL-PÅL-PÅL-003 @must`, GitHub #476)
- **Manifest:** [krav-input/changes/2026-09-24-idporten-min-kompetanse/manifest.md](krav-input/changes/2026-09-24-idporten-min-kompetanse/manifest.md)
- **Hentet:** `2026-09-24 22:30`

## Krav

### Krav

**TIL-PÅL-PÅL-004: Autentisere personer mot FS GraphQL API med ID-porten** (`@should`, nytt krav)

Gjelder en person som bruker Min Kompetanse, har gyldig ID-porten-token for FS GraphQL API og ikke er registrert som bruker i tilgangsstyring.

- **Regel: Tilgangene følger applikasjonen personen er innlogget gjennom**
  - *Person får grunntilgangen via Min Kompetanse.* Forespørselen autentiseres, og det interne tokenet inneholder grunntilgangen alle brukere har.
  - *Samme person får ingen organisasjonstilganger via FS Admin.* Forespørselen autentiseres, men tokenet har ingen organisasjonstilganger. Personen når bare det som er åpent for alle innloggede brukere.
- **Regel: Personen trenger ingen registrering i tilgangsstyring**
  - *Innlogging via Min Kompetanse registrerer ikke personen.* Personen er fortsatt uregistrert etter forespørselen.
- **Regel: En applikasjon som ikke er registrert for ID-porten, får bare det som er åpent**
  - *Token utstedt til en ukjent klient.* Forespørselen autentiseres, men tokenet har ingen organisasjonstilganger. Personen når bare det som er åpent for alle innloggede brukere.

**TIL-PÅL-PÅL-003: Autentisere mot FS GraphQL API med ID-porten** (`@must`, allerede `@in-progress`, tatt med som kontekst for 004)

Gjelder en saksbehandler ved en fagskole uten Feide-konto som bruker FS Admin.

- **Regel: ID-porten er en egen utsteder i coprocessoren, uavhengig av Feide**
  - Et gyldig token godtas. Det interne tokenet bærer saksbehandlerens identitet og autentiseringsmetode `"idporten"`.
  - Et token med ugyldig signatur eller utløpt gyldighet avvises som uautentisert og når ikke subgrafene.
- **Regel: Tokenet må være utstedt for FS GraphQL API**
  - Et token med annen audiens avvises som uautentisert og når ikke subgrafene.
- **Regel: Autentiseringsnivået (acr) bæres videre, men håndheves ikke i fase 1**
  - `idporten-loa-substantial`, `idporten-loa-high` og `selfregistered-email` godtas alle, og verdien bæres i det interne tokenet.
- **Regel: Tilgangssettet følger personens tildelinger**
  - En uregistrert saksbehandler autentiseres uten organisasjonstilganger og når bare det som er åpent for alle innloggede.
  - En registrert saksbehandler med tildelt rolle får organisasjonstilgangene rollen gir.
- **Regel: ID-portens testmiljø kan brukes i utvikling og test**
  - Et token fra testmiljøet godtas mot syntetiske datamiljøer.
  - Et token fra testmiljøet avvises mot miljøer med produksjonsdata og når ikke subgrafene.

## Skisser

Ingen skisser registrert.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/07 Brukeradministrasjon og tilgangsstyring/10 Pålogging/01 Pålogging/autentisere_person_med_idporten.feature` | `@TIL-PÅL-PÅL-004 @should @integration @planned` | `@TIL-PÅL-PÅL-004 @should @integration @in-progress` |

`autentisere_med_idporten.feature` (TIL-PÅL-PÅL-003) var allerede `@in-progress` og er ikke endret. Ingen retagging er utestående.

## Åpne spørsmål

- [x] **Grunntilgang eller åpent for alle innloggede?** 004 sier at Min Kompetanse gir «grunntilgangen alle brukere har». FS Admin og ukjent klient gir «kun det som er åpent for alle innloggede brukere». Er dette to ulike tilgangssett, altså gulvroller mot åpne roller? Kravteksten bør bruke samme begrep som tilgangsstyringen ellers.
  - **Beslutning (2026-09-24):** Ja, det er to ulike sett. «Grunntilgangen» er gulvrollene, og «åpent for alle innloggede» er de åpne rollene. Via Min Kompetanse får personen altså mer enn via FS Admin eller en ukjent klient.
  - **Begrunnelse:** Scenariene under regelen «Tilgangene følger applikasjonen» skal vise at samme person får ulike tilgangssett avhengig av applikasjonen. Ordlyden i 004 bør strammes inn via `bat-krav` slik at begrepene samsvarer med tilgangsstyringen for øvrig.
- [x] **Registrert person via Min Kompetanse.** Bakgrunnen i 004 forutsetter at personen er uregistrert. Hva skal skje når en registrert person med tildelte roller logger inn via Min Kompetanse: får personen rollene sine, eller bare det Min Kompetanse tillater?
  - **Beslutning (2026-09-24):** Personen får de tildelte rollene sine, men bare så langt Min Kompetanse sitt tak tillater. Gulvet kommer i tillegg.
  - **Begrunnelse:** Det følger regelen «Tilgangene følger applikasjonen» og er samme mønster som Feide-stien. 004 har ikke et scenario for dette ennå, så det bør legges til via `bat-krav`.
- [x] **Gjelder 003-reglene også for Min Kompetanse?** 004 gjentar ikke reglene om signatur, audiens, acr og testmiljø. Kravene bør si om de gjelder alle ID-porten-klienter, eller bare FS Admin.
  - **Beslutning (2026-09-24):** Ja. Reglene gjelder alle ID-porten-klienter, også Min Kompetanse og ukjente klienter. acr bæres videre, men håndheves ikke for noen klient i fase 1.
  - **Begrunnelse:** Reglene handler om utstederen og ikke om applikasjonen. 003 er skrevet med FS Admin som aktør, og det kan formuleres mer generelt via `bat-krav`.
- [x] **GitHub-issue for 004 mangler.** Kravfila sier at issuet opprettes når Min Kompetanse-integrasjonen planlegges. Det kan lages via `bat-krav`.
  - **Beslutning (2026-09-24):** Vent. Issuet opprettes når Min Kompetanse-integrasjonen planlegges formelt.
  - **Begrunnelse:** Dette er en sporbarhetsoppgave og blokkerer ikke analyse eller plan. Oppfølgingen står fortsatt i kravfila.
- [x] **Forutsetninger hos Digdir, utenfor kravene.** Min Kompetanse må være registrert klient hos Digdir (004). Sikt må også være registrert klient (003, fase 0), og det var ikke bestilt per 18.09.2026.
  - **Beslutning (2026-09-24):** Dette er en ekstern forutsetning som ligger utenfor kravene. Den blokkerer produksjonssetting, men ikke analyse, plan eller utvikling mot ID-portens testmiljø.
  - **Begrunnelse:** Registreringene hos Digdir er bestillinger og ikke oppførsel i systemet. De følges opp utenfor BAT-flyten.
