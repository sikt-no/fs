# Slik jobber vi med krav

Denne mappa inneholder akseptansekravene for løsningene som lages av studieadministrasjon i Sikt. Kravene skrives som Gherkin-scenarioer i `.feature`-filer. De er lesbare kravspesifikasjoner for domeneeksperter, og driver de automatiserte testene i `tester/`.

Dette dokumentet er de gjeldende konvensjonene for alle kravfiler. Claude leser den samme fila (via `.claude/rules/gherkin-conventions.md`), så det finnes bare én versjon av reglene.

Kravvieweren sjekker noen av reglene i dette dokumentet automatisk, og viser brudd som «Avvik fra konvensjoner». Reglene som sjekkes er merket med *(sjekkes i vieweren)*. Sjekkene står i `viewer/server/parse.ts` og er testet i `viewer/server/parse.test.ts`. Endrer du en merket regel, eller legger du til en regel som kan sjekkes, må `parse.ts` og testene oppdateres i samme endring.

## Språk

Vi skriver Gherkin på norsk. Start hver feature-fil med: *(sjekkes i vieweren)*

```gherkin
# language: no
```

| Engelsk         | Norsk       |
| --------------- | ----------- |
| Feature         | Egenskap    |
| Rule            | Regel       |
| Background      | Bakgrunn    |
| Scenario        | Scenario    |
| ScenarioOutline | Scenariomal |
| Examples        | Eksempler   |
| Given           | Gitt        |
| When            | Når         |
| Then            | Så          |
| And             | Og          |
| But             | Men         |

`Eksempler:` brukes bare sammen med `Scenariomal:`, ikke med vanlig `Scenario:`. *(sjekkes i vieweren)*

## Gode scenarioer

Gherkin er et språk som alle andre, og må skrives godt for å være nyttig og forståelig. <https://automationpanda.com/bdd/> er en god guide til å skrive gode scenarioer og features, og <https://cucumber.io/docs/gherkin/reference/> er en god introduksjon.

- Features skal deles etter **prosesser**, ikke etter komponenter.
- Hver feature-fil skal tydelig beskrive hva featuren gjør og hvilken verdi den gir. Skriv en god beskrivelse under `Egenskap:`-linja.
- Unngå for store scenarioer. Test helst bare én funksjonalitet per scenario. Noen scenarioer blir naturlig lengre fordi arbeidsflyten krever det.
- Alle scenarioer følger rekkefølgen Gitt → Når → Så:
  - **Gitt**: forutsetningene som må være på plass før handlingen skjer
  - **Når**: hovedhandlingen som testes
  - **Så**: forventet resultat
- Det er lov med flere av hvert nøkkelord etter hverandre (med `Og`/`Men`), men aldri i en annen rekkefølge. *(sjekkes i vieweren)*
- Bruk datatabeller og `Scenariomal:` med `Eksempler:` for datadrevne scenarioer.
- Bruk for det meste bestemt form på roller når handlinger utføres: «personen», «administratoren».

## Filnavn

- Filnavn skrives i snake_case: `se_søknad.feature`, `lage_opptak.feature`. *(sjekkes i vieweren)*
- Navnet beskriver funksjonaliteten eller prosessen med et verb og et substantiv.

## Mappestruktur

Tre nivåer: **Domene → Sub-domene → Kapabilitet**

Feature-filer skal **kun** ligge på kapabilitetsnivå (nivå 3). *(sjekkes i vieweren)* Sub-domener nummereres fra `10`, kapabiliteter fra `01`.

```
krav/
└── [NN] [Domene]/
    └── [NN] [Sub-domene]/
        └── [NN] [Kapabilitet]/
            └── feature_navn.feature
```

Eksempel:

```
krav/
└── 02 Opptak/
    └── 10 Regelverk/
        └── 02 Krav/
            └── kompetanseregelverk.feature
```

### Domener

- `01 Utdanning` – planlegging og administrasjon av utdanning
- `02 Opptak` – opptaksprosessen
- `03 Gjennomføre studier` – studiegjennomføring
- `04 Kompetanse` – resultater og kvalifikasjoner
- `05 Opplysninger om person` – persondata
- `07 Brukeradministrasjon og tilgangsstyring` – pålogging, tilganger og brukere
- `08 Teknisk` – tekniske funksjoner
- `09 Organisasjon` – organisasjonsforvaltning
- `10 Felleskrav` – tverrgående funksjonalitet
- `99 Demo` – demo og testing
- `_Interne prosesser` – egne arbeidsprosesser (f.eks. GitHub-automatisering)

### Tverrgående kapabiliteter: hva vs. hvordan

Noen kapabiliteter – som søk, filtrering og eksport – går igjen på tvers av domener. Skillet mellom **hva** og **hvordan** avgjør hvor kravet hører hjemme:

| Spørsmål | Tilhører |
|----------|----------|
| *Hva* søkes det etter? (felter, regler, domene-spesifikke filtere) | Det aktuelle domenet |
| *Hvordan* fungerer søk generelt? (fuzzy matching, paginering, UI-mønstre) | `10 Felleskrav` |

**Eksempel – søk etter organisasjon:**

- Regelen «søk på Erasmuskode gir direktetreff» er *hva* → `09 Organisasjon/10 Finn organisasjon/`
- Generelle søkemønstre som gjelder alle domener → `10 Felleskrav/`

Unngå å kalle sub-domener og kapabiliteter det samme (f.eks. `Søk/Søk`). Bruk heller et beskrivende navn som skiller nivåene, f.eks. `Finn organisasjon/Søk og identifikasjon`.

## Tags

### Feature-ID

Hver feature **må tagges** med en unik ID. ID-en legges inn manuelt som tag i feature-filen. *(sjekkes i vieweren)*

```
@DOM-SUB-KAP-NNN
```

- `DOM` = 3-bokstavs forkortelse for domene
- `SUB` = 3-bokstavs forkortelse for sub-domene
- `KAP` = 3-bokstavs forkortelse for kapabilitet
- `NNN` = unikt løpenummer per feature (001, 002, 003 …)

Forkortelsene utledes logisk fra mappenavnet (vanligvis de tre første bokstavene, men med unntak for lesbarhet). Avklar med teamet hvis du er usikker.

Eksempler:

- `@OPT-REG-KRA-002` = Opptak → Regelverk → Krav → feature 002
- `@OPT-SØK-SØK-001` = Opptak → Søknad og saksbehandling → Søknad → feature 001

Ved ny feature: sjekk eksisterende features i samme mappe for å finne neste ledige løpenummer.

### Prioritet (MoSCoW)

- `@must` / `@should` / `@could` / `@wont`

En feature har høyst én prioritet. *(sjekkes i vieweren)*

### Kravstatus

Sier noe om selve **kravteksten** – er den ferdig skrevet, avklart og klar til bruk?

- `@draft` – Utkast. Kravteksten er ikke ferdig: åpne spørsmål, uavklart scope, eller mangler review. Skal ikke legges til grunn for implementasjon som den er. **Alle nye krav starter som `@draft`**, og blir stående slik til de er validert. `@planned` settes bare på validerte krav – validert i en gjennomgang (`fs-krav`, modus B), eller når det eksplisitt er sagt at kravet skal ha `@planned`. Et krav uten status regnes som ikke validert.

`@draft` kan stå på to nivåer:

- **På `Egenskap:`** – hele kravet er utkast.
- **På `Regel:` eller `Scenario:`/`Scenariomal:`** – bare denne delen er utkast, mens resten av egenskapen er `@planned`, `@in-progress` eller `@implemented`. Se *Delvis utkast* under.

### Implementasjonsstatus

Sier noe om **koden** – er funksjonaliteten bygget?

- `@implemented` – Ferdig implementert og levert
- `@in-progress` – Under arbeid. Kravet er plukket inn i en aktiv flyt (settes av `fs-specify` / `fs-specify-delta` når de henter kravet inn i en spec), og er ikke ferdig implementert enda
- `@planned` – Planlagt for implementasjon (kravet er klart, men ingen har begynt på det)

Implementasjonsstatusen beveger seg langs én akse, og hvert steg har én eier:

`@draft` →(`fs-krav`)→ `@planned` →(`fs-specify` / `fs-specify-delta`)→ `@in-progress` →(verifisering)→ `@implemented`

Et krav skal ha nøyaktig én av disse på `Egenskap:`-tag-linja. Ikke sett to samtidig, og ikke la et krav stå uten status. `@planned`, `@in-progress` og `@implemented` hører bare hjemme på `Egenskap:` – på `Regel:`/`Scenario:` er `@draft` den eneste statustaggen. *(sjekkes i vieweren)*

Den tidligere taggen `@levert` er erstattet av `@implemented`.

### Delvis utkast

En `Egenskap:` kan være `@planned` selv om enkelte regler eller scenarioer fortsatt er utkast, **når det er en bevisst beslutning**: hovedflyten er avklart og kan implementeres, mens en avgrenset del venter på avklaring.

Det samme gjelder `@in-progress` og `@implemented`. En `@implemented` egenskap med `@draft`-deler betyr at alt som ikke er `@draft` er levert, mens `@draft`-delene er videre ønsker som ikke er avklart eller bygget enda.

- Delen tagges `@draft @openquestion` på `Regel:`- eller `Scenario:`-linja, og følges av en `# ÅPNE SPØRSMÅL:`-kommentar som beskriver hva som mangler.
- `@draft` på en `Regel:` gjelder alle scenarioene under den.
- `# ÅPNE SPØRSMÅL:` er påkrevd sammen med `@openquestion`. *(sjekkes i vieweren)* En `@draft`-del uten `@openquestion` er et utkast som ikke er gjennomgått enda.
- En `@draft`-del skal ikke implementeres før den er avklart. Når den er avklart, fjernes `@draft`, `@openquestion` og den besvarte kommentaren. `Egenskap:`-taggen endres ikke av det.
- Under en `Egenskap:` som selv er `@draft` skal deler **ikke** tagges `@draft` (det er dekket av egenskapen). *(sjekkes i vieweren)* `@openquestion` kan fortsatt brukes for å peke ut konkrete spørsmål.

Forskjellen på `@openquestion` alene og `@draft @openquestion`:

| Tagging på `Regel:`/`Scenario:` | Betyr |
|---|---|
| `@openquestion` | Delen er klar til implementasjon, men en detalj må lukkes før akkurat den detaljen bygges. |
| `@draft @openquestion` | Delen som helhet er ikke klar, og skal holdes utenfor implementasjonen til den er avklart. |

```gherkin
@BRU-APP-API-001 @must @planned
Egenskap: ...

  Regel: Hovedflyt som er avklart
    Scenario: ...

  @draft @openquestion
  Regel: Varsling ved utløpt passord
    # ÅPNE SPØRSMÅL:
    # - Skal varselet gå på e-post, i løsningen, eller begge deler?
    Scenario: ...
```

### Type

- `@e2e` – ende-til-ende brukerreiser
- `@integration` – API-integrasjonstester
- `@demo` – demo/eksempeltester (kjøres lokalt som standard)
- `@ci` – tester som kjøres automatisk i CI-pipeline

### Oppfølging

Sier noe om at et **konkret scenario eller regel** har en uavklart detalj, selv om resten av kravet er klart til implementasjon.

- `@openquestion` – Scenarioet/regelen har en uavklart detalj som må besvares før implementasjon kan begynne i akkurat den delen. Plasseres på scenario- eller regel-nivå (ikke på `Egenskap:` – bruk `@draft` hvis hele kravet er utkast, og `@draft @openquestion` hvis hele regelen/scenarioet er utkast, se *Delvis utkast*). *(sjekkes i vieweren)* Skal **alltid** følges av en `# ÅPNE SPØRSMÅL:`-kommentar like under som beskriver spørsmålet. *(sjekkes i vieweren)* Taggen gjør det mulig å søke på tvers av krav-mappa (`grep -r @openquestion krav/`) for å finne gjenstående avklaringer. En `Egenskap:` kan være `@planned` selv om ett scenario er `@openquestion` – det markerer at hovedflyten er klar, men at en detalj må lukkes før delen kan implementeres.

## Åpne spørsmål

Uklarheter dokumenteres med en `# ÅPNE SPØRSMÅL:`-kommentar, med ett spørsmål per `- `-linje. På en `Regel:` eller et `Scenario:` tagges delen med `@openquestion` (eller `@draft @openquestion`), se *Oppfølging* og *Delvis utkast*.

Kommentaren står enten mellom taggen og nøkkelordlinja, eller rett under nøkkelordlinja:

```gherkin
@openquestion
# ÅPNE SPØRSMÅL:
# - Spørsmål her
Scenario: ...

@openquestion
Scenario: ...
  # ÅPNE SPØRSMÅL:
  # - Spørsmål her
```

I en `Egenskap:` som selv er `@draft` kan spørsmål som gjelder hele kravet stå under beskrivelsen, uten `@openquestion`.

Bruk ikke `# TODO:` for åpne spørsmål. Vieweren viser bare `# ÅPNE SPØRSMÅL:` som spørsmål, og `@openquestion` er det `grep -r @openquestion krav/` finner.

## Aktører

- administrator, søker, student, saksbehandler

## Terminologi

Disse reglene gjelder for alle kravfiler. Tvetydige ord skal **avklares** før teksten skrives eller godkjennes.

### Ord som krever avklaring

| Ord brukt | Mener du … |
|-----------|------------|
| `institusjon` | **organisasjon** (generelt begrep for alle typer registrerte enheter) – eller – **lærested** (spesifikt: universitet, høyskole eller fagskole)? |
| `institusjonsnummer` | **organisasjonskode** (systemets interne kode, erstatter institusjonsnummer) – eller – **organisasjonsnummer** (eksternt registreringsnummer, f.eks. fra Brønnøysundregistrene)? |

### Foretrukne begreper

| Bruk dette | Ikke dette |
|------------|------------|
| organisasjon | institusjon (med mindre du mener lærested spesifikt) |
| lærested | institusjon (når du mener universitet, høyskole eller fagskole) |
| organisasjonskode | institusjonsnummer |
| organisasjonsnummer | (reservert for eksternt registreringsnummer – ikke bruk som synonym for organisasjonskode) |
