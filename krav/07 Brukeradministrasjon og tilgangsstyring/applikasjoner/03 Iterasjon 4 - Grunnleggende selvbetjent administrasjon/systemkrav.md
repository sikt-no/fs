# Systemkrav: Iterasjon 4 — Grunnleggende selvbetjent administrasjon

## Oversikt

**Domene:** 07 Brukeradministrasjon og tilgangsstyring / Applikasjoner / applikasjoner

**Aktører:**
- Lokal administrator (kunde-side bruker med applikasjonsadministrator-rollen for egen organisasjon)
- Sikt support (super-applikasjonsadministrator eller applikasjonsadministrator)

**Formål:** Lokale administratorer skal kunne administrere egne applikasjoner uten å gå via Sikt support, og endringer skal være sporbare. Iterasjonen handler primært om **sporbarhet** — selve den selvbetjente funksjonaliteten (oversikt over egne applikasjoner, tilordne/fjerne roller på egne) er allerede dekket av features fra Iterasjon 2 og 3 gjennom rettighets­regler basert på applikasjonsadministrator-rollen.

## Brukerreise

1. En lokal administrator hos et lærested logger inn og ser en **oversikt over egne applikasjoner** — de som tilhører organisasjonen administratoren har applikasjonsadministrator-rollen for, og applikasjoner fra andre organisasjoner som har tilgang til lærestedets data via roller (dekkes av [`BRU-APP-API-001`](../01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature)).
2. Administrator **tilordner og fjerner roller** på egne applikasjoner etter behov (dekkes av [`BRU-APP-API-007`](../02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/tilordne_rolle.feature) og [`BRU-APP-API-008`](../02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/fjerne_rolle.feature)).
3. Når administrator ønsker å spore historikk eller forstå hva som har skjedd med en applikasjon, åpnes **endringsloggen** på detaljsiden — ny i denne iterasjonen.

Verdien i Iterasjon 4 er altså primært sporbarhet og dokumentasjon av rettighetsmodellen. De selvbetjente operasjonene er teknisk på plass tidligere, men får i denne iterasjonen sin formelle "klar til bruk"-status.

## Kapabiliteter

### K16 — Endringslogg for applikasjon

**Feature-ID:** [`BRU-APP-API-016`](endringslogg.feature) | **GitHub:** [#453](https://github.com/sikt-no/fs/issues/453)

**Prioritet:** Må ha · **Status:** Utkast

**Brukerhistorie:** Som bruker med administrasjonsrettigheter for en applikasjon ønsker jeg å se en endringslogg over hvem som har gjort hva, slik at jeg kan spore historikken og ha grunnlag for feilsøking og kontroll.

**Kort beskrivelse:** Loggen er tilgjengelig fra detaljsiden, kun for brukere med administrasjonsrettigheter for applikasjonen. Detaljer om hva som logges, hvordan loggposter struktureres, retention og filtrering er åpne spørsmål — derav `@draft` og fire `@openquestion`-scenarios.

### Funksjonalitet dekket av features fra tidligere iterasjoner

For ikke å duplisere innhold er K11–K14 (selvbetjent oversikt og rolle-administrasjon) implementert via rettighetsregler i features fra Iterasjon 2 og 3. Disse refereres her for at den selvbetjente brukerreisen skal være lesbar:

- **K11, K12 — Oversikt over egne applikasjoner og applikasjoner med tilgang til lærestedets data:** Reglen «Synlighet styres av administrasjonsrettigheter» i [`BRU-APP-API-001`](../01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature).
- **K13 — Selvbetjent tilordning av rolle:** Regelen «Rolletildeling gjelder en organisasjon administratoren har rettighet for» i [`BRU-APP-API-007`](../02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/tilordne_rolle.feature).
- **K14 — Selvbetjent fjerning av rolle:** Regelen «Bruker kan kun fjerne roller de har rettighet til å fjerne» i [`BRU-APP-API-008`](../02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/fjerne_rolle.feature).

## Åpne spørsmål

- **Hva skal logges (K16):** Alle administrative handlinger, eller kun de sensitive (passord, roller, deaktivering)? Skal autentiseringshistorikk inngå i samme logg eller holdes atskilt?
- **Loggpostens innhold (K16):** Hvem + tidspunkt + type, eller også før/etter-verdier? Hvordan håndteres sensitive felter?
- **Retention (K16):** Hvor lenge beholdes loggen? Evig, tidsbegrenset, eller styrt av plattform-policy?
- **Rekkefølge, paginering, filtrering (K16):** Trengs filtrering på type endring eller person? Paginering 50 om gangen som andre lister?

Detaljer ligger i [`endringslogg.feature`](endringslogg.feature) som `@openquestion`-scenarios.

## Notater

- Den opprinnelige Iterasjon 4 hadde fire planlagte features (`oversikt_egne_applikasjoner`, `applikasjoner_med_tilgang_til_larested`, `selvbetjent_tilordning_rolle`, `selvbetjent_fjerning_rolle`). Disse er bevisst slått sammen med eksisterende features via rettighetsregler i stedet for å bli egne filer — det reduserer duplisering og holder logikken samlet med den generelle administrative flyten.
- Hvis det senere viser seg at den selvbetjente brukerreisen skiller seg vesentlig fra support-flyten (f.eks. egen onboarding, andre rettighetsregler, forenklet UI), kan det være riktig å dele opp igjen i egne features.
