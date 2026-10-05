# Slik jobber vi med krav

Denne mappa inneholder akseptansekravene for løsningene som lages av studieadministrasjon i Sikt. Kravene skrives som Gherkin-scenarioer i `.feature`-filer. De er lesbare kravspesifikasjoner for domeneeksperter, og driver de automatiserte testene i `tester/`.

Dette dokumentet er de gjeldende konvensjonene for alle kravfiler. Claude leser den samme fila (via `.claude/rules/gherkin-conventions.md`), så det finnes bare én versjon av reglene.

FS Kravforvaltning sjekker noen av reglene i dette dokumentet automatisk, og viser brudd som «Avvik fra konvensjoner». Reglene som sjekkes er merket med *(sjekkes automatisk)*. Sjekkene står i `fs-kravforvaltning/server/parse.ts` og er testet i `fs-kravforvaltning/server/parse.test.ts`. Endrer du en merket regel, eller legger du til en regel som kan sjekkes, må `parse.ts` og testene oppdateres i samme endring.

## Kort fortalt

### Hvor kravene ligger

Mappene har tre nivåer: **Domene → Sub-domene → Kapabilitet**, og feature-filene ligger bare på kapabilitetsnivå, for eksempel:

```
krav/02 Opptak/10 Regelverk/01 Regelverkssamling/regelverkssamling.feature
```

`02 Opptak` er domenet, `10 Regelverk` sub-domenet og `01 Regelverkssamling` kapabiliteten. Se *Mappestruktur*.

### Hvordan en kravfil ser ut

```gherkin
# language: no
# GitHub: #1234
@OPT-REG-SAM-001 @must @draft
Egenskap: Regelverkssamling
  Som opptaksforvalter
  ønsker jeg å opprette og forvalte regelverkssamlinger
  slik at …

  Regel: …
    Scenario: …
      Gitt …
      Når …
      Så …
```

- `# GitHub:` er valgfri, og peker på issuet kravet hører til. Den står rett over tag-linja.
- Taggene er en unik ID (`@DOM-SUB-KAP-NNN`), prioritet (`@must`, `@should`, `@could` eller `@wont`) og status. Se *Tags*.
- **Gitt** er forutsetningene, **Når** er handlingen, og **Så** er det forventede resultatet. Se *Gode scenarioer*.
- Uklarheter gjettes ikke. De skrives i en `# ÅPNE SPØRSMÅL:`-kommentar, og en `Regel:` eller et `Scenario:` med spørsmål tagges `@openquestion`. Se *Åpne spørsmål*.

### Livsløpet til et krav

| Status | Betyr | Settes av |
|---|---|---|
| `@draft` | Utkast, ikke validert. Alle nye krav starter her | `fs-krav` |
| `@planned` | Validert og klart til å bygges | `fs-krav`, etter en gjennomgang, eller når det er sagt at kravet skal ha `@planned` |
| `@in-progress` | Hentet inn i en oppgave | `fs-specify` / `fs-specify-delta` |
| `@implemented` | Bygget, og verifisert mot koden | `fs-verify` |
| `@deprecated` | Levert, men skal fjernes | `fs-krav`. `fs-verify` sletter fila (eller blokken, for en del) når koden er borte |

Se *Kravstatus* og *Implementasjonsstatus*.

### Skills for kravarbeid

`fs-krav` brukes til:

- **Nye krav:** aktør, brukerhistorie, regler og scenarioer avklares, og fila skrives som `@draft`.
- **Validering av en mappe:** utkastene gås gjennom ett spørsmål om gangen, de åpne spørsmålene lukkes, og det som er bekreftet, får `@planned`.
- **Fjerning av krav:** krav som ikke er levert, slettes. Leverte krav får `@deprecated`. Se *Avvikling*.
- **Endring av leverte krav:** den nye delen legges ved siden av den gamle som `@draft`. Når den er validert, får den `@planned`, og den gamle delen får `@deprecated`. Se *Endring av levert krav*.

## Språk

Vi skriver Gherkin på norsk. Start hver feature-fil med: *(sjekkes automatisk)*

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

`Eksempler:` brukes bare sammen med `Scenariomal:`, ikke med vanlig `Scenario:`. *(sjekkes automatisk)*

Nøkkelordene skrives nøyaktig som i tabellen, med stor forbokstav og kolon etter. En linje som ligner et nøkkelord uten å være det (`Scenarioz:`, `scenario:`, `Feature:`), leses som beskrivelse, og scenarioet under forsvinner uten feilmelding. *(sjekkes automatisk)*

Fila må kunne leses som Gherkin. Kan den ikke det, viser FS Kravforvaltning sist gyldige versjon med feilen over, og fila får avviket «Parse-feil» på linja der feilen står. *(sjekkes automatisk)*

## Gode scenarioer

Gherkin er et språk som alle andre, og må skrives godt for å være nyttig og forståelig. <https://automationpanda.com/bdd/> er en god guide til å skrive gode scenarioer og features, og <https://cucumber.io/docs/gherkin/reference/> er en god introduksjon.

- Features skal deles etter **prosesser**, ikke etter komponenter.
- Hver feature-fil skal tydelig beskrive hva featuren gjør og hvilken verdi den gir. Skriv en god beskrivelse under `Egenskap:`-linja. *(at beskrivelsen finnes, sjekkes automatisk)*
- Unngå for store scenarioer. Test helst bare én funksjonalitet per scenario. Noen scenarioer blir naturlig lengre fordi arbeidsflyten krever det.
- Alle scenarioer følger rekkefølgen Gitt → Når → Så:
  - **Gitt**: forutsetningene som må være på plass før handlingen skjer
  - **Når**: hovedhandlingen som testes
  - **Så**: forventet resultat
- Det er lov med flere av hvert nøkkelord etter hverandre (med `Og`/`Men`), men aldri i en annen rekkefølge. *(sjekkes automatisk)*
- Bruk datatabeller og `Scenariomal:` med `Eksempler:` for datadrevne scenarioer.
- Bruk for det meste bestemt form på roller når handlinger utføres: «personen», «administratoren».

## Filnavn

- Filnavn skrives i snake_case: `se_søknad.feature`, `lage_opptak.feature`. *(sjekkes automatisk)*
- Navnet beskriver funksjonaliteten eller prosessen med et verb og et substantiv.

## Mappestruktur

Tre nivåer: **Domene → Sub-domene → Kapabilitet**

Feature-filer skal **kun** ligge på kapabilitetsnivå (nivå 3). *(sjekkes automatisk)* Sub-domener nummereres fra `10`, kapabiliteter fra `01`. `_Interne prosesser` og `99 Demo` følger ikke nummereringen. *(sjekkes automatisk)*

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

Unngå å kalle sub-domener og kapabiliteter det samme (f.eks. `Søk/Søk`). Bruk heller et beskrivende navn som skiller nivåene, f.eks. `Finn organisasjon/Søk og identifikasjon`. *(sjekkes automatisk)*

## Tags

### Feature-ID

Hver feature **må tagges** med en unik ID. ID-en legges inn manuelt som tag i feature-filen. *(sjekkes automatisk)*

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

En feature har høyst én prioritet. *(sjekkes automatisk)*

### Kravstatus

Sier noe om selve **kravteksten** – er den ferdig skrevet, avklart og klar til bruk?

- `@draft` – Utkast. Kravteksten er ikke ferdig: åpne spørsmål, uavklart scope, eller mangler review. Skal ikke legges til grunn for implementasjon som den er. **Alle nye krav starter som `@draft`**, og blir stående slik til de er validert. `@planned` settes bare på validerte krav – validert i en gjennomgang (`fs-krav`, modus B), eller når det eksplisitt er sagt at kravet skal ha `@planned`. Et krav uten status regnes som ikke validert.

`@draft` kan stå på to nivåer:

- **På `Egenskap:`** – hele kravet er utkast.
- **På `Regel:` eller `Scenario:`/`Scenariomal:`** – bare denne delen er utkast, mens resten av egenskapen er `@planned`, `@in-progress` eller `@implemented`. Se *Delvis utkast* under.

### Implementasjonsstatus

Sier noe om **koden** – er funksjonaliteten bygget?

- `@deprecated` – Avviklet. Kravet var levert, men skal fjernes. Koden finnes kanskje fortsatt, og kravfila blir stående til det er vist at koden er borte. Se *Avvikling* under
- `@implemented` – Ferdig implementert og levert (settes av `fs-verify` når koden er verifisert)
- `@in-progress` – Under arbeid. Kravet er plukket inn i en aktiv flyt (settes av `fs-specify` / `fs-specify-delta` når de henter kravet inn i en spec), og er ikke ferdig implementert enda
- `@planned` – Planlagt for implementasjon (kravet er klart, men ingen har begynt på det)

Implementasjonsstatusen beveger seg langs én akse, og hvert steg har én eier:

`@draft` →(`fs-krav`)→ `@planned` →(`fs-specify` / `fs-specify-delta`)→ `@in-progress` →(`fs-verify`)→ `@implemented` →(`fs-krav`)→ `@deprecated` →(`fs-verify`)→ slettet

Et krav skal ha nøyaktig én av disse på `Egenskap:`-tag-linja. Ikke sett to samtidig, og ikke la et krav stå uten status. På `Regel:`/`Scenario:` brukes `@draft` og `@deprecated`. `@planned` og `@in-progress` er bare lov på en del under en `@implemented` egenskap, når et levert krav endres (se *Endring av levert krav*). `@implemented` settes aldri på en del: en levert del har ingen egen statustag. *(sjekkes automatisk)*

Den tidligere taggen `@levert` er erstattet av `@implemented`. *(sjekkes automatisk)*

### Delvis utkast

En `Egenskap:` kan være `@planned` selv om enkelte regler eller scenarioer fortsatt er utkast, **når det er en bevisst beslutning**: hovedflyten er avklart og kan implementeres, mens en avgrenset del venter på avklaring.

Det samme gjelder `@in-progress` og `@implemented`. En `@implemented` egenskap med `@draft`-deler betyr at alt som ikke er `@draft` er levert, mens `@draft`-delene er videre ønsker som ikke er avklart eller bygget enda.

- Delen tagges `@draft @openquestion` på `Regel:`- eller `Scenario:`-linja, og følges av en `# ÅPNE SPØRSMÅL:`-kommentar som beskriver hva som mangler.
- `@draft` på en `Regel:` gjelder alle scenarioene under den.
- `# ÅPNE SPØRSMÅL:` er påkrevd sammen med `@openquestion`. *(sjekkes automatisk)* En `@draft`-del uten `@openquestion` er et utkast som ikke er gjennomgått enda. *(sjekkes automatisk)*
- En `@draft`-del skal ikke implementeres før den er avklart. Når den er avklart, fjernes `@draft`, `@openquestion` og den besvarte kommentaren. `Egenskap:`-taggen endres ikke av det.
- Under en `@implemented` egenskap fjernes ikke `@draft` uten videre, for da ser delen levert ut. En avklart del får `@planned` i stedet, og delen den erstatter, får `@deprecated`. Se *Endring av levert krav*.
- Under en `Egenskap:` som selv er `@draft` skal deler **ikke** tagges `@draft` (det er dekket av egenskapen). *(sjekkes automatisk)* `@openquestion` kan fortsatt brukes for å peke ut konkrete spørsmål.

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

### Avvikling

Et krav som skal fjernes, slettes ikke med en gang hvis det er levert. Koden finnes fortsatt, og kravet er påminnelsen om at den må bort.

- Et krav som ikke er levert (`@draft` eller `@planned`), slettes direkte.
- Et levert krav (`@implemented`) får `@deprecated` i stedet for `@implemented` på `Egenskap:`-tag-linja. Det settes av `fs-krav` når kravet fjernes.
- Skal bare en del av et levert krav bort, tagges delen `@deprecated` på `Regel:`- eller `Scenario:`-linja. `@deprecated` på en `Regel:` gjelder alle scenarioene under den. `Egenskap:`-taggen endres ikke.
- `@deprecated` på en del er bare lov under en `Egenskap:` som er `@implemented` eller `@in-progress`. Under `@draft` eller `@planned` er ingenting levert, så delen slettes direkte. *(sjekkes automatisk)*
- Under en `Egenskap:` som selv er `@deprecated`, skal deler **ikke** tagges `@deprecated`. *(sjekkes automatisk)*
- En del kan ikke være både `@draft` og `@deprecated`. *(sjekkes automatisk)*
- Det som er `@deprecated`, skal ikke implementeres videre. `fs-specify` og `fs-specify-delta` tar det inn i en spec for å fjerne koden, sammen med annet arbeid. Taggen blir stående til koden er borte.
- `fs-verify` sjekker om koden fortsatt finnes. Er den borte, slettes fila (for en `@deprecated` egenskap) eller blokken (for en `@deprecated` del). Finnes den fortsatt, blir kravet stående, og `fs-verify` viser hvor i koden den er.

```gherkin
@BRU-APP-API-001 @must @implemented
Egenskap: ...

  Regel: Hovedflyt som fortsatt gjelder
    Scenario: ...

  @deprecated
  Regel: Eksport til CSV
    Scenario: ...
```

### Endring av levert krav

Et krav som er levert (`@implemented`), endres ikke på stedet. Den leverte teksten beskriver koden som finnes, og den nye teksten beskriver det som skal bygges. Begge står i fila til koden er endret.

- Egenskapen blir stående som `@implemented`. Statusen for endringen står på delen (`Regel:` eller `Scenario:`/`Scenariomal:`).
- Den nye eller endrede delen legges som en egen blokk, rett etter delen den erstatter. Den starter som `@draft` (med `@openquestion` og `# ÅPNE SPØRSMÅL:` ved uklarheter), som alle nye krav.
- Den nye delen får den tittelen kravet skal ha, ikke en tittel som beskriver endringen. Blir den lik tittelen på den gamle delen, får den gamle ` (avvikles)` bak tittelen, så titlene er unike: `Scenario: Se brukerens roller (avvikles)`. Ellers står den gamle delen urørt så lenge den nye er utkast. Forkastes den nye delen, fjernes ` (avvikles)` igjen.
- Når den nye delen er validert (`fs-krav`), byttes `@draft` med `@planned`, og delen den erstatter, får `@deprecated` i samme endring. En del som bare fjernes, får `@deprecated` (se *Avvikling*). Et rent tillegg har ingen gammel del.
- Delen går deretter langs samme akse som en egenskap: `@planned` →(`fs-specify` / `fs-specify-delta`)→ `@in-progress` →(`fs-verify`)→ levert. Når `fs-verify` har funnet koden, fjernes `@in-progress` fra delen, og delen arver `@implemented` fra egenskapen. `@deprecated`-delen slettes av `fs-verify` når koden er borte.
- `@planned` og `@in-progress` på en del er bare lov under en `@implemented` egenskap. Under `@draft`, `@planned` eller `@in-progress` er ingenting levert, så delen endres på stedet. *(sjekkes automatisk)*
- En del har høyst én statustag. `@planned` og `@in-progress` kombineres ikke med hverandre, med `@draft` eller med `@deprecated`. *(sjekkes automatisk)*

FS Kravforvaltning viser et levert krav med `@planned`- eller `@in-progress`-deler med statusen «endres».

```gherkin
@BRU-APP-API-001 @must @implemented
Egenskap: ...

  Regel: Hovedflyt som ikke endres
    Scenario: ...

  @deprecated
  Regel: Eksport til CSV
    Scenario: ...

  @planned
  Regel: Eksport til Excel
    Scenario: ...

  Regel: Visning av roller

    @deprecated
    Scenario: Se brukerens roller (avvikles)
      ...

    @planned
    Scenario: Se brukerens roller
      ...
```

### Type

- `@e2e` – ende-til-ende brukerreiser
- `@integration` – API-integrasjonstester
- `@demo` – demo/eksempeltester (kjøres lokalt som standard)
- `@ci` – tester som kjøres automatisk i CI-pipeline

`@only` og `@focus` skal ikke sjekkes inn i en kravfil. playwright-bdd gjør `@only` om til `test.only`, så resten av testene hoppes over. `@focus` har ingen virkning i playwright-bdd, og er en rest fra andre verktøy. *(sjekkes automatisk)*

### Oppfølging

Sier noe om at et **konkret scenario eller regel** har en uavklart detalj, selv om resten av kravet er klart til implementasjon.

- `@openquestion` – Scenarioet/regelen har en uavklart detalj som må besvares før implementasjon kan begynne i akkurat den delen. Plasseres på scenario- eller regel-nivå (ikke på `Egenskap:` – bruk `@draft` hvis hele kravet er utkast, og `@draft @openquestion` hvis hele regelen/scenarioet er utkast, se *Delvis utkast*). *(sjekkes automatisk)* Skal **alltid** følges av en `# ÅPNE SPØRSMÅL:`-kommentar like under som beskriver spørsmålet. *(sjekkes automatisk)* Taggen gjør det mulig å søke på tvers av krav-mappa (`grep -r @openquestion krav/`) for å finne gjenstående avklaringer. En `Egenskap:` kan være `@planned` selv om ett scenario er `@openquestion` – det markerer at hovedflyten er klar, men at en detalj må lukkes før delen kan implementeres.

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

Bruk ikke `# TODO:` for åpne spørsmål. *(sjekkes automatisk)* FS Kravforvaltning viser bare `# ÅPNE SPØRSMÅL:` som spørsmål, og `@openquestion` er det `grep -r @openquestion krav/` finner.

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
| identitetsleverandør | idP (forkortelsen er innarbeidet blant utviklere, men ikke blant dem som administrerer applikasjoner) |
| applikasjonseier | organisasjon (kun i applikasjonskrav, der organisasjonen opptrer i to roller: den som eier applikasjonen, og den hvis data en tilgang «gjelder for») |

### Konkrete henvisninger

Steg og titler skal si konkret hvem eller hva de gjelder. Ord som «egne», «mine», «dem» og «denne» lar leseren gjette. Hvert steg skal også kunne leses alene, fordi det blir en egen step definition og kan gjenbrukes i andre scenarioer.

- **«egne», «egen», «eget»** er greit når eieren står i samme setning og eierskapet er bokstavelig: `søkerens egne søknader`, `min egen profil`. Det er også greit når ordet betyr *separat*: `i eget vindu`, `i en egen kolonne`. Gjelder det hva en rolle har tilgang til eller er knyttet til, skriv relasjonen: `organisasjonene jeg administrerer`, ikke `egne organisasjoner`.
- **«min», «mine», «mitt»** følger samme regel som «egne»: greit når eierskapet er bokstavelig (`min profil`, `mine søknader`), ikke når det gjelder en rolles tilknytning. Skriv `organisasjonen jeg administrerer`, ikke `min organisasjon`.
- **«dem», «de», «disse», «en av dem»** skal ikke peke til et annet steg eller en tittel. Skriv det det gjelder på nytt. Står ordet det peker på i samme steg, er det greit: `Når jeg velger flere roller og fjerner dem i én operasjon`.
- **«den», «denne», «dette»** som peker til et annet steg, følger samme regel: `Så ser jeg denne applikasjonen` blir `Så ser jeg applikasjonen`, og `den organisasjonen` blir `organisasjonen applikasjonen tilhører`. Bruk bestemt form, og legg til det som skiller når det er flere av samme slag. Det er greit når ordet det peker på, står i samme steg (`endrer prioriteringen og lagrer den`), når «den» er artikkel foran et adjektiv (`den valgte organisasjonen`, `den nye beskrivelsen`), og når «det» er formelt subjekt (`det finnes`).
- **«sin», «sine», «sitt»** er greit, fordi det alltid peker på subjektet i samme setning: `Så ser søkerne resultatet sitt`.

| Ikke skriv | Skriv |
|------------|-------|
| `Scenario: Brukeradministrator ser personbrukere fra egne organisasjoner` | `Scenario: Brukeradministrator ser personbrukere fra organisasjonene jeg administrerer` |
| `Og en personbruker har hjemorganisasjon i en av dem` | `Og en personbruker har hjemorganisasjon i en av organisasjonene jeg administrerer` |
| `Men jeg ser ikke muligheten til å endre dem` (etter et steg om vitnemål, grunnlag og poeng) | `Men jeg ser ikke muligheten til å endre grunnlaget` (eller det «dem» faktisk gjelder) |
| `Scenario: Deltakende organisasjon ser kun sine egne` | `Scenario: Deltakende organisasjon ser kun utdanningstilbudene sine` |
| `Så er applikasjonen opprettet på min organisasjon` | `Så er applikasjonen opprettet på organisasjonen jeg administrerer` |
| `Så ser jeg denne applikasjonen i listen` | `Så ser jeg applikasjonen i listen` |
