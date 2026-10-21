# Testplan – Grunnleggende brukeradministrasjon

- **Leveranse**: mappe
- **Kilde**: `krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon/`
- **Scope**: @scope-grunnleggende-brukeradministrasjon, @scope-restanser-etter-onboarding, @scope-synlighet-og-gjelder-for   (bare på deler av kravene; testplanen gjelder alt som er levert i mappa)
- **Scope-fil**: [scope-grunnleggende-brukeradministrasjon](../../tasks/brukeradministrasjon-og-tilgangsstyring/scope-grunnleggende-brukeradministrasjon.md), [scope-restanser-etter-onboarding](../../tasks/brukeradministrasjon-og-tilgangsstyring/scope-restanser-etter-onboarding.md), [scope-synlighet-og-gjelder-for](../../tasks/brukeradministrasjon-og-tilgangsstyring/scope-synlighet-og-gjelder-for.md)
- **Oppgaver**: [brukeradministrasjon-og-tilgangsstyring/grunnleggende-brukeradministrasjon](../../tasks/brukeradministrasjon-og-tilgangsstyring/grunnleggende-brukeradministrasjon/oppgave.md), [brukeradministrasjon-og-tilgangsstyring/roller-gjelder-for](../../tasks/brukeradministrasjon-og-tilgangsstyring/roller-gjelder-for/oppgave.md)
- **Krav**: 12 feature-filer, 5 `@implemented`, commit `64d875a` (2026-10-21). Lest fra `origin/main` med `git show`, fordi branchen `akseptansetest/testflyt-skills` er 57 commits bak main og ikke har kravene.
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/edit-v2/5125963817 (utkast), under [Testplaner](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126062121/Testplaner)
- **Laget**: 2026-10-21 av fs-testplan

---

Testplan for «Grunnleggende brukeradministrasjon». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Brukeradministratorer kan se en liste over personbrukerne i FS Admin: dem som har hjemorganisasjon i organisasjonene de administrerer, og dem som har en aktiv rolle der. De kan søke på navn og Feide-ID, og filtrere på status, hjemorganisasjon og rolle. På detaljsiden ser de navn, Feide-ID, hjemorganisasjon og status, og rollene til personbrukeren med «Gjelder for» og miljø, med filtre. De kan fjerne én eller flere roller, og deaktivere en personbruker uten at tildelingene fjernes. |
| Versjon | [Fylles ut: versjon eller dato for deploy] |
| Testmiljø | Produksjon: [Fylles ut: URL] |
| Feature-flagg | Ingen |
| Kilde | Kravmappa [1 - Grunnleggende brukeradministrasjon](https://github.com/sikt-no/fs/tree/64d875ae3a521113de8354e1788bd57642507196/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon) |
| Scope | Ingen for hele leveransen. Deler av kravene har `@scope-grunnleggende-brukeradministrasjon`, `@scope-restanser-etter-onboarding` og `@scope-synlighet-og-gjelder-for` · [scope-filene på GitHub](https://github.com/sikt-no/fs/tree/64d875ae3a521113de8354e1788bd57642507196/tasks/brukeradministrasjon-og-tilgangsstyring) |
| Saker | Levert: [#143](https://github.com/sikt-no/fs/issues/143) (initiativ [#350](https://github.com/sikt-no/fs/issues/350)), [#479](https://github.com/sikt-no/fs/issues/479), [#480](https://github.com/sikt-no/fs/issues/480), [#481](https://github.com/sikt-no/fs/issues/481), [#482](https://github.com/sikt-no/fs/issues/482) · [BAT-299](https://sikt.atlassian.net/browse/BAT-299). Venter: [BAT-298](https://sikt.atlassian.net/browse/BAT-298), [BAT-325](https://sikt.atlassian.net/browse/BAT-325), [BAT-326](https://sikt.atlassian.net/browse/BAT-326) |
| Berører andre team | [Fylles ut: står ikke i oppgavene] |
| Kjente begrensninger | <ul><li>Testen går i produksjon. Deaktivering og fjerning av roller endrer de ekte tilgangene til testbrukerne, og må settes tilbake etterpå (se *Testdata*).</li><li>Reaktivering lagrer ikke historikken: det som var lagret om deaktiveringen, blir borte, og det lagres ikke når og av hvem reaktiveringen ble gjort. Reaktivering er ikke med i testen, men brukes for å sette testdataene tilbake.</li><li>Verifiseringen 14.10 fant ikke sikkert 6 av scenarioene: valglistene for organisasjon og miljø når en rolle fjernes, kan vise organisasjoner og miljøer der administratoren ikke har rett (serveren avviser fjerningen, rettes i BAT-326). Filtervalgene for hjemorganisasjon og rolle i listen, og for organisasjon og miljø i rollevisningen, kan vise valg som ikke finnes i listen. Det er sannsynlig at testen gir funn her.</li><li>Synligheten i listen regnes fra alle aktive tildelinger, ikke bare roller (rettes i BAT-298). Scenarioene om synlighet som er levert, består, men en personbruker med bare en tilgang kan også bli vist.</li><li>Fanen «Tilganger» er slått av på detaljsiden. De to scenarioene om tilganger som faller bort eller består når en rolle fjernes, kan ikke sjekkes på detaljsiden. [Fylles ut: hvordan testerne sjekker tilgangene]</li><li>Listen kan ikke sorteres (sorteringen er utkast). Den er sortert etter navn i stigende rekkefølge.</li></ul> |

### Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | [Fylles ut: navn] | Brukeradministrator, i alle miljøer | [Fylles ut: organisasjon A] | Listen, søk og filtre, detaljsiden, rollene, fjerne roller og deaktivere (`@BRU-PER-GRU-001`, `-004`, `-007`, `-008`, `-012`) |
| 2 | [Fylles ut: navn] | Brukeradministrator | [Fylles ut: organisasjon B] | Synlighet: personbrukere med hjemorganisasjon i organisasjon B og en aktiv rolle i organisasjon A (`@BRU-PER-GRU-001`). Roller i en organisasjon testbruker 1 ikke administrerer (`@BRU-PER-GRU-012`) |
| 3 | [Fylles ut: navn] | Brukeradministrator, i bare ett miljø | [Fylles ut: organisasjon A] | Synlighet når rollen gjelder i et miljø testbrukeren ikke administrerer (`@BRU-PER-GRU-001`) |

Testbrukerne finnes i minst to organisasjoner, så vi kan teste at ingen ser data de ikke skal se.

### Testdata

Testdataene er testbrukernes egne: testerne deaktiverer og fjerner roller fra hverandre, og setter det tilbake etterpå.

| Hva | Navn | Hvor | Kan settes tilbake |
|---|---|---|---|
| Personbruker med flere aktive roller i organisasjon A, også den samme rollen i flere kombinasjoner av organisasjon og miljø (fjernes) | [Fylles ut: hvilken testbruker] | FS Admin, Brukeradministrasjon | Ja: rollene tildeles på nytt etter testen |
| Personbruker med aktive roller som deaktiveres | [Fylles ut: hvilken testbruker] | FS Admin, Brukeradministrasjon | Ja: reaktiveres etter testen. Historikken om deaktiveringen blir borte (se *Kjente begrensninger*) |
| Personbruker med roller i både organisasjon A og B, og en rolle testbruker 1 ikke har rett til å fjerne | [Fylles ut: hvilken testbruker] | FS Admin, Brukeradministrasjon | Ingenting endres |
| Personbruker med hjemorganisasjon utenfor organisasjon A og en aktiv rolle i organisasjon A, i et miljø testbruker 1 administrerer | [Fylles ut: hvilken testbruker] | FS Admin, Brukeradministrasjon | Ingenting endres |
| Personbruker med hjemorganisasjon utenfor organisasjon A og eneste aktive rolle i organisasjon A i et annet miljø enn det testbruker 3 administrerer | [Fylles ut: navn] | FS Admin, Brukeradministrasjon | Ingenting endres |
| Personbruker med et domene i Feide-ID-en som ikke er registrert på noen organisasjon | [Fylles ut: navn] | FS Admin, Brukeradministrasjon | Ingenting endres |
| Personbruker med en rolle som gir tilganger, og en tilgang som både er tildelt direkte og følger av rollen | [Fylles ut: navn] | [Fylles ut: tilganger kan ikke tildeles i FS Admin] | [Fylles ut] |
| Flere enn 50 personbrukere testbruker 1 kan se, for «last inn flere» | – | FS Admin, Brukeradministrasjon | Ingenting endres |

## Omfang

Det som testes, er kravene som er `@implemented`. Feature-ID-ene her er kravene resten av testflyten bruker.

### 1 - Grunnleggende brukeradministrasjon

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Aktivere og deaktivere en personbrukers samlede tilganger](https://github.com/sikt-no/fs/blob/64d875ae3a521113de8354e1788bd57642507196/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/aktivere_og_deaktivere_bruker.feature) | `@BRU-PER-GRU-004` | `@implemented` (endres) | 2 |
| [Fjerne roller fra en personbruker](https://github.com/sikt-no/fs/blob/64d875ae3a521113de8354e1788bd57642507196/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/fjerne_roller.feature) | `@BRU-PER-GRU-012` | `@implemented` (endres) | 7 |
| [Se detaljer for personbruker](https://github.com/sikt-no/fs/blob/64d875ae3a521113de8354e1788bd57642507196/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/se_detaljer.feature) | `@BRU-PER-GRU-007` | `@implemented` | 5 |
| [Listevisning og søk i personbrukere](https://github.com/sikt-no/fs/blob/64d875ae3a521113de8354e1788bd57642507196/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | `@BRU-PER-GRU-001` | `@implemented` (endres) | 17 |
| [Se en personbrukers roller](https://github.com/sikt-no/fs/blob/64d875ae3a521113de8354e1788bd57642507196/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/vise_roller.feature) | `@BRU-PER-GRU-008` | `@implemented` (endres) | 7 |

Til sammen 38 scenarioer.

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet, har åpne spørsmål eller er demo, og som ikke er under endring. Hele det leverte kravet testes, også delene som ble levert i et scope («Se brukerens roller med «Gjelder for»» i `@scope-synlighet-og-gjelder-for`).

De automatiske testene av de samme kravene: `npx playwright test --grep "@BRU-PER-GRU-001|@BRU-PER-GRU-004|@BRU-PER-GRU-007|@BRU-PER-GRU-008|@BRU-PER-GRU-012"`

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke bekreftet dem ennå. De tas med i testen når de er `@implemented`.

| Krav | Feature-ID | Status | Hva som venter |
|---|---|---|---|
| [Aktivere og deaktivere en personbrukers samlede tilganger](https://github.com/sikt-no/fs/blob/64d875ae3a521113de8354e1788bd57642507196/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/aktivere_og_deaktivere_bruker.feature) | `@BRU-PER-GRU-004` | `@planned` | Scenarioet «Reaktivere en deaktivert personbruker» (`@scope-grunnleggende-brukeradministrasjon`). Ikke funnet 14.10: historikken lagres ikke |
| [Fjerne roller fra en personbruker](https://github.com/sikt-no/fs/blob/64d875ae3a521113de8354e1788bd57642507196/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/fjerne_roller.feature) | `@BRU-PER-GRU-012` | `@planned` | Regelen «Valglistene følger rettigheten til å fjerne roller fra personbrukere», 2 scenarioer (`@scope-restanser-etter-onboarding`, BAT-326) |
| [Listevisning og søk i personbrukere](https://github.com/sikt-no/fs/blob/64d875ae3a521113de8354e1788bd57642507196/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | `@BRU-PER-GRU-001` | `@planned` | Scenarioene «Hjemorganisasjonene i filteret vises med akronym» og «Søke i hjemorganisasjonsfilteret» (`@scope-restanser-etter-onboarding`, BAT-325) |
| [Listevisning og søk i personbrukere](https://github.com/sikt-no/fs/blob/64d875ae3a521113de8354e1788bd57642507196/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/s%C3%B8ke_opp_bruker.feature) | `@BRU-PER-GRU-001` | `@planned` | Scenarioet «Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer» (`@scope-synlighet-og-gjelder-for`, BAT-298) |
| [Se en personbrukers roller](https://github.com/sikt-no/fs/blob/64d875ae3a521113de8354e1788bd57642507196/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/vise_roller.feature) | `@BRU-PER-GRU-008` | `@planned` | Scenarioene «Organisasjonene i filteret vises med akronym» og «Søke i organisasjonsfilteret» (`@scope-restanser-etter-onboarding`, BAT-325) |

Ingen av delene er hentet inn i en spesifikasjon ennå (`fs-specify`).

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| `@BRU-PER-GRU-003` Tildele roller til en personbruker | `@planned`: kommer senere (`@scope-restanser-etter-onboarding`, BAT-326) |
| `@BRU-PER-GRU-002` Se en personbrukers tilganger | `@draft`: planlagt etter v1 |
| `@BRU-PER-GRU-009` Tildele tilganger til en personbruker | `@draft`: planlagt etter v1 |
| `@BRU-PER-GRU-011` Fjerne tilganger fra en personbruker | `@draft`: planlagt etter v1 |
| `@BRU-PER-GRU-005` Sette stedkoder for en tildeling | `@draft`: utsatt til en senere versjon (#483) |
| `@BRU-PER-GRU-006` Sette start- og sluttidspunkt for tildelinger | `@draft`: utsatt til en senere versjon (#484) |
| `@BRU-PER-GRU-010` Automatisk synkronisering av roller fra namespacet «frontend/fs-admin» | `@draft`: har eget issue (#552) |
| `@BRU-PER-GRU-001` Scenariomal «Velge sorteringsretning for navn» | `@draft @openquestion`: API-et støtter ikke sortering på navn ennå, og hvem som følger opp er ikke avklart |
| `@BRU-PER-GRU-001` Regel «Sist brukt-kolonne og sortering», 2 scenarioer | `@draft @openquestion`: planlagt etter v1 |
| `@BRU-PER-GRU-001` 4 scenarioer om synlighet via datatilgang | `@deprecated`: skal fjernes (`@scope-synlighet-og-gjelder-for`, BAT-298) |
| `@BRU-PER-GRU-007` Regel «Sist brukt», 1 scenario | `@draft @openquestion`: tidspunktet personbrukeren sist brukte løsningen, lagres ikke |
| `@BRU-PER-GRU-008` Scenarioene «Se tidsbegrensning på en rolle» og «Se stedkoder på en rolle» | `@draft @openquestion`: kommer med tidsbegrensning og stedkoder |
| `@BRU-PER-GRU-012` Regel «Fjerning av roller lagres i historikk», 2 scenarioer | `@draft @openquestion`: hvem som skal se historikken, hvor lenge den lagres, og om det må sjekkes med juss |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | Ishfaq Khan | Eier testen fra start til beslutning, og skriver beslutningen i testrapporten |
| Kontaktperson i teamet | [Fylles ut: navn] | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | [Fylles ut: navn] | [Fylles ut: hvilke deler] |
| Eksterne testere | Brukeradministratorer fra lærestedene: [Fylles ut: hvilke læresteder og hvem] | Ekstern akseptansetest av hovedflyten |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Intern akseptansetest | [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | Avklares med de eksterne partene |
| Spørsmål underveis | Slack-tråden «Akseptansetesting Grunnleggende brukeradministrasjon» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdataene er identifisert og tilgjengelige | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake eller lages på nytt | [Fylles ut av teamet]. Fjernede roller tildeles på nytt, og deaktiverte testbrukere reaktiveres. Historikken om deaktiveringen blir borte. |
| 4 | Testbrukerne finnes i rollene leveransen gjelder, i minst to organisasjoner | [Fylles ut av teamet] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten | Delvis: 32 av 38 funnet, 6 usikre (verifiseringen 2026-10-14, og 2026-10-19 for «Gjelder for»). Kontrollert av `fs-verify-kontroll`. [Fylles ut: hvem som har kontrollert rapporten] |
| 6 | Testcasene er laget og gått gjennom av testansvarlig | Laget, venter på gjennomgang av testansvarlig |
| 7 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |

## Kriterier for godkjent

Testansvarlig skriver hva som skal til for at testen blir godkjent, helst før utviklingen starter.

[Fylles ut av testansvarlig]

## Funn og alvorlighetsgrad

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men resten av testcasene testes hvis det er mulig.

## Beslutning

| Utfall | Hva skjer videre |
| --- | --- |
| Godkjent | Leveransen går videre til ekstern akseptansetest eller til innføring. |
| Godkjent med forbehold | Kjente mangler listes i sluttrapporten, med ansvarlig og frist. Rettingen testes før innføring. |
| Ikke godkjent | Leveransen går tilbake til teamet med funnene. |

Testansvarlig skriver beslutningen og begrunnelsen i sluttrapporten. Rettede funn testes på nytt i versjonen som skal godkjennes. Hvem som beslutter etter den eksterne akseptansetesten, avklares med de eksterne partene.

## Status i flyten

| Steg | Side | Status | Dato |
|---|---|---|---|
| 1. Testplan | (denne siden) | Laget | 2026-10-21 |
| 2. Verifisering (`fs-verify`) | – | Venter | |
| 3. Testrapport – verifisering | – | Venter | |
| 4. Intern akseptansetest | [Intern akseptansetest – Grunnleggende brukeradministrasjon](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/edit-v2/5126127626) (utkast) | Klar til test | 2026-10-21 |
| 5. Testrapport – intern | – | Venter | |
| 6. Ekstern akseptansetest | – | Venter | |
| 7. Testrapport – ekstern | – | Venter | |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
