# Slik jobber vi med krav

Denne mappa inneholder akseptansekravene for løsningene som lages av studieadministrasjon i Sikt. Kravene skrives som Gherkin-scenarioer i `.feature`-filer. De er lesbare kravspesifikasjoner for domeneeksperter, og driver de automatiserte testene i `tester/`. Kravet beskriver atferden løsningen skal ha, og koden sjekkes mot kravet, ikke omvendt.

Er du ny? [Kom i gang med krav og akseptansetest i FS](../kom-i-gang.html) er en innføring i hvor kravene ligger, hvordan en kravfil ser ut, og hele prosessen steg for steg, fra kravene skrives til leveransen er godkjent i akseptansetesten.

Det finnes også tre presentasjoner. [Slik jobber vi med krav](https://sikt-no.github.io/fs/presentasjoner/slik-jobber-vi-med-krav.html) er for alle, [Krav – detaljert presentasjon](https://sikt-no.github.io/fs/presentasjoner/krav-detaljert.html) går i detalj på taggene, skillene, verifiseringen og testene, og [Testfasene](https://sikt-no.github.io/fs/presentasjoner/testfasene.html) går gjennom fasene i akseptansetesten, etter teststrategien.

Dette dokumentet er de gjeldende konvensjonene for alle kravfiler. Claude leser den samme fila (via `.claude/rules/gherkin-conventions.md`), så det finnes bare én versjon av reglene.

FS Kravforvaltning sjekker noen av reglene i dette dokumentet automatisk, og viser brudd som «Avvik fra konvensjoner». Reglene som sjekkes er merket med *(sjekkes automatisk)*. Sjekkene står i `fs-kravforvaltning/server/parse.ts` og er testet i `fs-kravforvaltning/server/parse.test.ts`. Endrer du en merket regel, eller legger du til en regel som kan sjekkes, må `parse.ts` og testene oppdateres i samme endring.

## Kort fortalt

### Hvor kravene ligger

Mappene har tre nivåer: **Domene → Sub-domene → Kapabilitet**, og feature-filene ligger bare på kapabilitetsnivå, for eksempel:

```
krav/02 Opptak/10 Regelverk/01 Regelverkssamling/regelverkssamling.feature
```

`02 Opptak` er domenet, `10 Regelverk` sub-domenet og `01 Regelverkssamling` kapabiliteten. Se *Mappestruktur*.

Løp som går på tvers av domener, beskrives som flyter i `krav/_Flyter`. Se *Flyter*.

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
- Taggene er en unik ID (`@DOM-SUB-KAP-NNN`), prioritet (`@must`, `@should`, `@could` eller `@wont`) og status, og eventuelt `@scope-<slug>`, som kobler kravet til et scope og en oppgave. Se *Tags*.
- Et krav som bygger på et annet krav, får `@depends-on-<Feature-ID>`, og en henvisning får `@ref-<Feature-ID>`. Se *Referanser*.
- **Gitt** er forutsetningene, **Når** er handlingen, og **Så** er det forventede resultatet. Se *Gode scenarioer*.
- Uklarheter gjettes ikke. De skrives i en `# ÅPNE SPØRSMÅL:`-kommentar, og en `Regel:` eller et `Scenario:` med spørsmål tagges `@openquestion`. Se *Åpne spørsmål*.

### Livsløpet til et krav

| Status | Betyr | Settes av |
|---|---|---|
| `@draft` | Utkast, ikke validert. Alle nye krav starter her, eventuelt som skjelett | `fs-scope` / `fs-krav` |
| `@planned` | Validert og klart til å bygges | `fs-krav`, etter en gjennomgang, eller når det er sagt at kravet skal ha `@planned` |
| `@in-progress` | Hentet inn i en oppgave, eller delvis levert | `fs-specify` / `fs-specify-delta`, eller `fs-verify` når noe av kravet er levert |
| `@implemented` | Bygget, og verifisert mot koden | `fs-verify` (også direkte fra `@draft` eller `@planned`, med «Verifiser» uansett status) |
| `@deprecated` | Levert, men skal fjernes | `fs-krav`. `fs-verify` sletter fila (eller blokken, for en del) når koden er borte |

Se *Kravstatus* og *Implementasjonsstatus*.

### Skills for kravarbeid

`fs-scope` brukes før kravene skrives: initiativet avgrenses og deles i oppgaver, og det bestemmes hvilke krav hver oppgave har. Den skriver scope-fila (`tasks/<domene>/scope-<slug>.md`), oppretter oppgavene, lager skjelett-krav (`@draft`, brukerhistorie og `Regel:`-titler uten scenarioer) og setter `@scope-<slug>` på kravene. Den kan kjøres på nytt når som helst. Se *Scope*.

`fs-krav` brukes til:

- **Nye krav:** aktør, brukerhistorie, regler og scenarioer avklares, og fila skrives som `@draft`. Et skjelett fra `fs-scope` fylles ut der det ligger.
- **Validering av en mappe:** utkastene gås gjennom ett spørsmål om gangen, de åpne spørsmålene lukkes, og det som er bekreftet, får `@planned`.
- **Fjerning av krav:** krav som ikke er levert, slettes. Leverte krav får `@deprecated`. Se *Avvikling*.
- **Endring av leverte krav:** den nye delen legges ved siden av den gamle som `@draft`. Når den er validert, får den `@planned`, og den gamle delen får `@deprecated`. Se *Endring av levert krav*.
- **Flyter:** et løp på tvers av domener, fase for fase, med kravene hver fase bygger på. Se *Flyter*.

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

- Features skal deles etter **prosesser**, ikke etter komponenter. En fil eller regel per entitet, med opprette, endre og slette, eller per skjerm, er ofte et tegn på at kravet er delt etter komponenter.
- Steg og titler skrives med domenets ord (se *Terminologi*). Tabell- og kolonnenavn, kodeverdier (`GODTATT_MEN_ANNULLERT`), API-kall og JSON hører ikke hjemme der. Grensesnittet står i `<feature>.design.md`. Kilder kan nevnes i `#`-kommentarer.
- Hver feature-fil skal tydelig beskrive hva featuren gjør og hvilken verdi den gir. Skriv en god beskrivelse under `Egenskap:`-linja. *(at beskrivelsen finnes, sjekkes automatisk)*
- Unngå for store scenarioer. Test helst bare én funksjonalitet per scenario. Noen scenarioer blir naturlig lengre fordi arbeidsflyten krever det.
- Alle scenarioer følger rekkefølgen Gitt → Når → Så:
  - **Gitt**: forutsetningene som må være på plass før handlingen skjer
  - **Når**: hovedhandlingen som testes
  - **Så**: forventet resultat
- Det er lov med flere av hvert nøkkelord etter hverandre (med `Og`/`Men`), men aldri i en annen rekkefølge. *(sjekkes automatisk)*
- Bruk datatabeller og `Scenariomal:` med `Eksempler:` for datadrevne scenarioer.
- Bruk for det meste bestemt form på roller når handlinger utføres: «personen», «administratoren».

### Krav fra kode, skisser eller FS-klienten

- Kilden er grunnlag for spørsmål, ikke fasit. Avklar først prosessen og aktøren, og bruk så kilden til å finne reglene.
- Spør for hver regel som kommer fra kilden: er dette ønsket atferd, eller bare slik koden er? Er svaret uklart, blir det et `# ÅPNE SPØRSMÅL:`.
- Kontrollspørsmål: ville kravet fortsatt vært riktig om koden ble skrevet om fra bunnen?

## Filnavn

- Filnavn skrives i snake_case: `se_søknad.feature`, `lage_opptak.feature`. *(sjekkes automatisk)*
- Navnet beskriver funksjonaliteten eller prosessen med et verb og et substantiv.

## Mappestruktur

Tre nivåer: **Domene → Sub-domene → Kapabilitet**

Feature-filer skal **kun** ligge på kapabilitetsnivå (nivå 3). *(sjekkes automatisk)* Sub-domener nummereres fra `10`, kapabiliteter fra `01`. `99 Demo` følger ikke nummereringen. *(sjekkes automatisk)* Unntaket er `_Flyter`, som har ett nivå: `krav/_Flyter/<NN Prosess>/flyt.feature`, med prosessene nummerert fra `10`. *(sjekkes automatisk)* Se *Flyter*.

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
- `_Flyter` – løp på tvers av domener (se *Flyter*)

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

- `@draft` – Utkast. Kravteksten er ikke ferdig, eller kravet er et skjelett fra `fs-scope` (brukerhistorie og `Regel:`-titler uten scenarioer; et skjelett gir ikke avvik): åpne spørsmål, uavklart scope, eller mangler review. Skal ikke legges til grunn for implementasjon som den er. **Alle nye krav starter som `@draft`**, og blir stående slik til de er validert. `@planned` settes bare på validerte krav – validert i en gjennomgang (`fs-krav`, modus B), eller når det eksplisitt er sagt at kravet skal ha `@planned`. Et krav uten status regnes som ikke validert. Før kravet blir `@in-progress`, sjekker `fs-specify` / `fs-specify-delta` det mot koden. Et krav som må endres etter sjekken, blir stående som `@planned`.

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

Unntaket er «Verifiser» på en egenskap eller en regel i FS Kravforvaltning: brukeren ber `fs-verify` verifisere *uansett status*. Finnes alt i koden, og brukeren bekrefter, kan `fs-verify` gi en `@draft`- eller `@planned`-egenskap statusen `@implemented` direkte, og fjerne `@draft`, `@planned` eller `@in-progress` fra en regel under en `@implemented` egenskap, så regelen er levert. Det gjelder bare det brukeren ba om, og aldri en regel under en egenskap som ikke er levert.

Det andre unntaket er et krav som er delvis levert: `fs-verify` gir en `@draft`- eller `@planned`-egenskap statusen `@in-progress` når noe av den finnes i koden, også når kravet ikke er i en spesifikasjon. Se *Delvis levert*.

En flyt i `krav/_Flyter` hentes ikke inn i en oppgave, og hopper over `@in-progress`: `fs-verify` gir en `@planned` flyt statusen `@implemented`. Se *Flyter*.

Et krav skal ha nøyaktig én av disse på `Egenskap:`-tag-linja. Ikke sett to samtidig, og ikke la et krav stå uten status. På `Regel:`/`Scenario:` brukes `@draft` og `@deprecated`. `@planned` og `@in-progress` er bare lov på en del under en `@implemented` egenskap, når et levert krav endres (se *Endring av levert krav*). `@implemented` på en del er bare lov under en `@in-progress` egenskap, for en del som er levert (se *Delvis levert*). Under en `@implemented` egenskap har en levert del ingen egen statustag. *(sjekkes automatisk)*

Den tidligere taggen `@levert` er erstattet av `@implemented`. *(sjekkes automatisk)*

### Delvis utkast

En `Egenskap:` kan være `@planned` selv om enkelte regler eller scenarioer fortsatt er utkast, **når det er en bevisst beslutning**: hovedflyten er avklart og kan implementeres, mens en avgrenset del venter på avklaring.

Det samme gjelder `@in-progress` og `@implemented`. En `@implemented` egenskap med `@draft`-deler betyr at alt som ikke er `@draft` er levert, mens `@draft`-delene er videre ønsker som ikke er avklart eller bygget enda.

- Delen tagges `@draft @openquestion` på `Regel:`- eller `Scenario:`-linja, og følges av en `# ÅPNE SPØRSMÅL:`-kommentar som beskriver hva som mangler.
- `@draft` på en `Regel:` gjelder alle scenarioene under den.
- `# ÅPNE SPØRSMÅL:` er påkrevd sammen med `@openquestion`. *(sjekkes automatisk)* En `@draft`-del uten `@openquestion` er et utkast som ikke er gjennomgått enda. *(sjekkes automatisk)*
- En `@draft`-del skal ikke implementeres før den er avklart. Når den er avklart, fjernes `@draft`, `@openquestion` og den besvarte kommentaren. `Egenskap:`-taggen endres ikke av det.
- Under en `@implemented` egenskap fjernes ikke `@draft` uten videre, for da ser delen levert ut. En avklart del får `@planned` i stedet, og delen den erstatter, får `@deprecated`. Se *Endring av levert krav*. Unntaket er når `fs-verify` har funnet delen i koden og brukeren har bekreftet det (*Implementasjonsstatus*).
- Under en `Egenskap:` som selv er `@draft` skal deler **ikke** tagges `@draft` (det er dekket av egenskapen). *(sjekkes automatisk)* `@openquestion` kan fortsatt brukes for å peke ut konkrete spørsmål.

Forskjellen på `@openquestion` alene og `@draft @openquestion`:

| Tagging på `Regel:`/`Scenario:` | Betyr |
|---|---|
| `@openquestion` | Delen er klar til implementasjon, og bygges og leveres som den står. Spørsmålet må fortsatt besvares, og står i verify-rapporten og testplanen til det er lukket. |
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
- En `@planned`- eller `@in-progress`-del er ikke levert, og endres på stedet, uten ny blokk og uten `@deprecated`. Statustaggen blir stående. Er delen `@in-progress`, skal oppgaven som har hentet den inn, vite om endringen, og det noteres i spesifikasjonen.
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

### Delvis levert

Er noe av et krav levert, men ikke alt, er egenskapen `@in-progress`, og delene som er levert, er `@implemented`. Det settes av `fs-verify` når den finner delene i koden, og brukeren bekrefter.

- `@implemented` står på `Regel:` når alle scenarioene i regelen er funnet, ellers på hvert `Scenario:`/`Scenariomal:` som er funnet. På et scenario under en `@implemented` regel er taggen overflødig. *(sjekkes automatisk)*
- `@implemented` på en del er bare lov under en `@in-progress` egenskap. *(sjekkes automatisk)* Delen kombineres ikke med en annen statustag. *(sjekkes automatisk)*
- En del som ikke er levert, har ingen statustag. Er det uklart om den skal bygges, endres eller fjernes, får den `@openquestion` og en `# ÅPNE SPØRSMÅL:` (se *Oppfølging*). `@draft`-deler står urørt.
- Var egenskapen `@draft` eller `@planned`, setter `fs-verify` den til `@in-progress`, også når kravet ikke er i en spesifikasjon. Det står i verify-rapporten, så kravet kan hentes inn i en oppgave med `fs-specify`.
- Når resten er levert, gir `fs-verify` egenskapen `@implemented`, og fjerner `@implemented` fra delene i samme endring.
- En `@implemented` egenskap settes aldri tilbake til `@in-progress`. Mangler noe i et levert krav, står det i verify-rapporten.
- En `@implemented` del er levert, og endres ikke på stedet. Skal den bort, byttes `@implemented` med `@deprecated` (*Avvikling*). Skal den endres, legges den nye delen ved siden av som `@draft`, som i *Endring av levert krav*. Når den er validert, fjernes `@draft` (delen skal bygges, som resten av egenskapen), og den gamle delen får `@deprecated`.
- I akseptansetesten testes delene som er `@implemented`, og resten av kravet venter på verifisering.

```gherkin
@BRU-APP-API-001 @must @in-progress
Egenskap: ...

  @implemented
  Regel: Hovedflyt som er levert
    Scenario: ...

  Regel: Varsling
    @implemented
    Scenario: Varsel på e-post
      ...

    @openquestion
    Scenario: Varsel i løsningen
      # ÅPNE SPØRSMÅL:
      # - Ikke funnet i koden. Skal varselet i løsningen bygges, eller fjernes fra kravet?
      ...
```

### Scope

Sier hvilket scope (og dermed hvilken oppgave) kravet hører til. Scopet er planen for et initiativ: mål, avgrensning, og oppgavene initiativet deles i, med kravene hver oppgave har. Det står i `tasks/<domene>/scope-<slug>.md` (se *Scope* i [`tasks/README.md`](../tasks/README.md)), og lages og endres med `fs-scope`.

```
@BRU-APP-API-001 @must @draft @scope-applikasjoner-iterasjon-3
```

- Formatet er `@scope-<slug>`, der `<slug>` er kebab-case: små bokstaver a–z, tall og `-`, og starter med bokstav eller tall. *(sjekkes automatisk)*
- Slugen er den samme som i `scope-<slug>.md`, og unik på tvers av domener (det siste sjekkes på scope-fila, se *Scope* i `tasks/README.md`).
- Taggen står på `Egenskap:`-tag-linja, og et krav har høyst én. Det samme gjelder en del. *(sjekkes automatisk)*
- På `Regel:` eller `Scenario:`/`Scenariomal:` er taggen bare lov under en `@implemented` egenskap, for en del som endres i et nytt scope (se *Endring av levert krav*). Delen hører da til det nye scopet, og resten av egenskapen til det gamle. *(sjekkes automatisk)*
- Taggen er ikke en statustag, og endrer ikke livsløpet. Statusen leses fra statustaggene, ikke fra scope-fila.
- Taggen settes av `fs-scope`, og av `fs-krav` når et nytt krav skrives i et scope. `fs-krav` og `fs-specify` endrer den ellers ikke, men foreslår `fs-scope` når et krav ikke passer i scopet.
- Kravene i et scope kan testes for seg: `npx playwright test --grep @scope-<slug>`.

### Referanser

Sier at et krav peker på et annet krav. Det er to typer, og de skiller seg på hva referansen betyr:

| Tag | Betyr |
|---|---|
| `@depends-on-<Feature-ID>` | Delen bygger på kravet. Endres kravet, må delen sjekkes, og delen kan ikke leveres før kravet |
| `@ref-<Feature-ID>` | Henvisning for den som leser: «se også», «står der», «avgjøres der» |

**Testen for typen:** Må denne delen sjekkes hvis kravet det pekes på, endres? Ja gir `@depends-on-`, nei gir `@ref-`.

```gherkin
  @depends-on-OPT-OVO-INN-001
  Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det
    # Tidlig opptak må være slått på både på opptaket og på utdanningstilbudet.

  @ref-OPT-PLA-TIL-002
  Regel: Opptaksforvalter setter tak for antall tilbud per tildelingsrunde
    # Hvordan taket brukes i plasstildelingen, står der.
```

- Formatet er `@depends-on-` eller `@ref-` og Feature-ID-en uten `@`: `@depends-on-OPT-BEH-BEH-011`. *(sjekkes automatisk)*
- Taggen står på delen referansen gjelder: `Egenskap:`, `Regel:` eller `Scenario:`/`Scenariomal:`. Bygger hele kravet på et annet krav, står den på `Egenskap:`-tag-linja, etter eventuell `@scope-<slug>`. Taggen på `Egenskap:` gjelder alle scenarioene i kravet.
- Taggen peker på hele kravet. Bygger delen bare på noen regler eller scenarioer i kravet, settes et anker i kravet det pekes på (se *Anker* under). Kommentaren under taggen er ellers valgfri, og forklarer referansen når det trengs.
- Retningen gir seg av hvor taggen står. Den andre retningen, «hva bygger på dette kravet?», skrives ikke ned, men finnes med `grep`. Unntaket er ankeret.
- Et krav refererer ikke til seg selv. *(sjekkes automatisk)*
- En del har hver referanse én gang, og har enten `@depends-on-` eller `@ref-` til et krav, ikke begge. *(sjekkes automatisk)*
- ID-en må finnes, `@depends-on-` går ikke i ring (A → B → A), og regeltitlene i «…» under taggen må finnes i kravet det pekes på. Det krever flere filer, og sjekkes av `fs-krav-avvik`.
- Taggen er ikke en statustag, og endrer ikke livsløpet.

#### Anker

`@depends-on-` peker på hele kravet. Bygger en del av krav A bare på noen regler eller scenarioer i krav B, får de delene i B `@ref-A`. Det er ankeret:

> Har A `@depends-on-B`, og har en `Regel:` eller et `Scenario:`/`Scenariomal:` i B `@ref-A`, bygger A bare på de delene av B som har `@ref-A`. Har ingen del i B `@ref-A`, bygger A på hele B. `@ref-A` på `Egenskap:` i B betyr også hele kravet.

Eksempel (ankeret finnes ikke i repoet):

```gherkin
# A: OPT-OPT-UTD-004
  @depends-on-OPT-BEH-BEH-011
  Regel: Opptaksforvalter kan velge saksbehandlertildelingsregel per utdanningstilbud

# B: OPT-BEH-BEH-011
  @ref-OPT-OPT-UTD-004
  Regel: Opptaksforvalteren ved forvaltende organisasjon setter opp tildelingsreglene for opptaket
```

- Ankeret er en vanlig `@ref-`, og leses også som en henvisning: «A bygger på denne delen». Den som endrer delen, ser hvilke krav som må sjekkes, rett over delen.
- Ankeret gjelder bare når A har `@depends-on-B`. Ellers er `@ref-A` i B en vanlig henvisning.
- A kan være en flyt: en fase med `@depends-on-B` bygger på delene i B som har `@ref-<flytens ID>`.
- Ankeret sier hvilket krav som bygger på delen, ikke hvilken del av A. Har A flere deler med `@depends-on-B` (for eksempel flere faser i en flyt), skilles de med regeltitlene i «…» i kommentaren under taggen i A: delen bygger på ankrene som ligger i de reglene i B. Et scenario med ankeret hører til regelen over.
- Slik leses hvilken del av B som gjelder:
  1. Ankrene innenfor reglene i «…» under taggen i A.
  2. Står det ingen regler i «…», eller ligger ingen av ankrene i dem: alle ankrene.
  3. Uten anker: reglene i «…» (alle, når det står flere).
  4. Ellers hele kravet.
- Ankeret settes av `fs-krav`, sammen med `@depends-on-`. At ankeret og regeltittelen i «…» peker på samme del, krever flere filer, og sjekkes av `fs-krav-avvik`.
- Ankeret sier også når A kan leveres. En fase er levert når delen den bygger på (lest som over), er levert, eller hele kravet (`@implemented`) når den bygger på hele kravet. Se *Flyter*.

Dette er ikke referanser, og blir stående som kommentarer:

- **Historikk:** «flyttet hit fra …», «skilt ut fra …», «Feature-ID-en var …». Den gamle ID-en finnes ikke lenger, eller tilhører et annet krav.
- **Åpne spørsmål:** et krav som nevnes i `# ÅPNE SPØRSMÅL:`. Referansen settes når spørsmålet er besvart.
- **Mapper:** en henvisning til en mappe (`14 Plasstildeling/`) og ikke til ett krav.

Referansene i begge retninger:

| Spørsmål | Svar |
|---|---|
| Hva må sjekkes når kravet endres? | `grep -rn "@depends-on-OPT-BEH-BEH-011" krav/` |
| Hva henger sammen med kravet? | `grep -rnE "@(depends-on\|ref)-OPT-BEH-BEH-011" krav/` |
| Hvilke deler av kravet bygger andre krav på? | `@ref-` på `Regel:`/`Scenario:`-linjene i kravet (ankrene) |
| Hvilke tester bygger på kravet? | `npx playwright test --grep @depends-on-OPT-BEH-BEH-011` |
| Hvilke CDP-tester må sjekkes når kravet endres? | `grep -rn "@depends-on-OPT-BEH-BEH-011" cdp-tester/` |

CDP-testene i [`cdp-tester/`](../cdp-tester/README.md) bruker de samme taggene, med de samme betydningene: `@depends-on-<Feature-ID>` på en test som må sjekkes når kravet endres, og `@ref-<Feature-ID>` på et krav testen bare bruker som forutsetning. Kravene peker ikke tilbake til testene.

Referansene settes av `fs-krav`. Når et krav endres, slettes eller får ny ID, lister `fs-krav` kravene som refererer til det. `fs-specify` og `fs-specify-delta` tar med kravene det bygges på, og sier fra når et av dem ikke er `@planned` eller lenger.

### Type

- `@e2e` – ende-til-ende brukerreiser
- `@integration` – API-integrasjonstester
- `@demo` – demo/eksempeltester (kjøres lokalt som standard)
- `@ci` – tester som kjøres automatisk i CI-pipeline

`@only` og `@focus` skal ikke sjekkes inn i en kravfil. playwright-bdd gjør `@only` om til `test.only`, så resten av testene hoppes over. `@focus` har ingen virkning i playwright-bdd, og er en rest fra andre verktøy. *(sjekkes automatisk)*

### Oppfølging

Sier noe om at et **konkret scenario eller regel** har en uavklart detalj, selv om resten av kravet er klart til implementasjon.

- `@openquestion` – Scenarioet/regelen har en uavklart detalj som må besvares, men delen bygges, verifiseres og testes som den står. Plasseres på scenario- eller regel-nivå (ikke på `Egenskap:` – bruk `@draft` hvis hele kravet er utkast, og `@draft @openquestion` hvis hele regelen/scenarioet er utkast, se *Delvis utkast*). *(sjekkes automatisk)* Skal **alltid** følges av en `# ÅPNE SPØRSMÅL:`-kommentar like under som beskriver spørsmålet. *(sjekkes automatisk)* Taggen gjør det mulig å søke på tvers av krav-mappa (`grep -r @openquestion krav/`) for å finne gjenstående avklaringer. En `Egenskap:` kan være `@planned` selv om ett scenario er `@openquestion` – det markerer at delen er klar, men at en detalj må avklares. Skal delen holdes utenfor til spørsmålet er besvart, tagges den `@draft @openquestion`.

## Flyter

> **Pilot.** Konvensjonen prøves ut på tre flyter i Opptaksløpet (saksbehandlertildeling, automatisk saksbehandling og mangelmelding), og evalueres etterpå. Bakgrunnen står i `forslag-flyter-og-referanser.md` i rota av repoet.

En flyt beskriver et løp på tvers av domener, fase for fase: «hva skjer fra … til …?». Den er en egen feature-fil i `krav/_Flyter`. Hver `Regel:` er en fase, og `@depends-on-` på regelen peker på kravene fasen går gjennom (se *Referanser*). Reglene står i kravene. Flyten gjentar dem ikke, men beskriver overleveringene mellom dem.

```
krav/_Flyter/
└── 10 Opptaksløpet/
    ├── opptaksløpet.feature        # oversikt: fasene i hele løpet
    ├── saksbehandlertildeling.feature
    └── mangelmelding.feature
```

- **Prosess:** et livsløp på tvers av domener, som Opptaksløpet. Prosessene nummereres fra `10` i livsløpsrekkefølge, og speiler ikke domenene. Flytene ligger rett under prosessen, uten flere mappenivåer. *(sjekkes automatisk)*
- **Oversiktsflyt:** én per prosess, med samme navn som prosessen og ID-en `@FLY-<prosess>-<prosess>-001` (`@FLY-OPT-OPT-001` for Opptaksløpet). Hver `Regel:` er en fase i hele løpet, og `@depends-on-` peker på flyten for fasen.
- **ID:** `@FLY-<prosess>-<flyt>-NNN`, for eksempel `@FLY-OPT-SAK-001`. Formatet er det samme som for Feature-ID, og sjekkes på samme måte.
- **Tagger:** som et krav: ID, prioritet og status, og typisk `@e2e`.
- **Flyt på flyt:** en fase kan bygge på en annen flyt med `@depends-on-FLY-…`. Flyten den bygger på, ligger i samme prosess.
- **Fase uten krav:** en fase uten `@depends-on-` viser at kravet mangler. Fasen får `@openquestion` og en `# ÅPNE SPØRSMÅL:` som sier hvilket krav som mangler, og kravet skrives med `fs-scope` eller `fs-krav`.
- **Kjente brudd** i løpet (for eksempel en Jira-sak) står i en kommentar under beskrivelsen.
- **Scenarioene** er få, tynne og deklarative. Det som skjedde i en tidligere fase, står som en tilstand i `Gitt`: `Gitt søkeren har tilbudsgaranti fra tidligopptaket`. Gherkin har ikke løkker: en runde fram og tilbake blir ett scenario per utfall.

```gherkin
# language: no
@FLY-OPT-TID-001 @should @draft @e2e
Egenskap: Tidlig opptak
  Søkeren søker tidlig opptak, får søknaden vurdert, får tilbudsgaranti,
  og får tilbud i hovedopptaket.
  # Kjent brudd: STEK-263, tilbudsgarantien fra tidligopptaket leses ikke i hovedopptaket.

  @depends-on-OPT-BEH-BEH-007 @depends-on-OPT-PLA-TIL-002
  Regel: Tilbudsgarantien gir tilbud i hovedopptaket
    Scenario: Søkeren med tilbudsgaranti får tilbud i hovedopptaket
      Gitt søkeren har tilbudsgaranti fra tidligopptaket
      Når plasstildelingen i hovedopptaket gjennomføres
      Så får søkeren tilbud på søknadsalternativet
```

### Hva er en flyt?

En kandidat er en flyt når den:

1. går over minst to sub-domener eller domener
2. har en overlevering: en tilstand som én aktør eller ett system lager, og en annen bruker
3. svarer på et spørsmål noen faktisk stiller: «hva skjer fra … til …?»

Faller den på terskelen, holder det med `@depends-on-` eller `@ref-` mellom kravene. En fase som er ett krav uten overlevering inni seg, er en fase, ikke en egen flyt.

### To statuser

Et brudd i overleveringen kan skjules av kravene. Testene for hvert krav setter opp tilstanden selv, så de kan gå grønt selv om det ene kravet aldri får det det andre lager. Bare flyten tester overleveringen.

| Status | Kommer fra | Sier |
|---|---|---|
| Fremdrift | Statusen på delene av kravene flyten bygger på | «3 av 5 faser levert» |
| Flytens egen status | Taggen på flyten | at overleveringene virker i koden |

En fase er levert når delen av hvert krav den bygger på, er levert, og flytene den bygger på, er `@implemented`. Delen er den samme som følges (se *Anker*): ankrene innenfor reglene i «…» under taggen (alle ankrene når ingen ligger i dem), ellers reglene i «…», ellers hele kravet. Om en del er levert, leses av taggene som i *Delvis levert* og *Endring av levert krav*:

- Er kravet `@in-progress`, er delen levert når den selv er `@implemented`. En regel er levert når alle scenarioene i den er det.
- Er kravet `@implemented`, er delen levert når den ikke er `@planned` eller `@in-progress`. Da holder den på å endres.
- Er kravet `@draft` eller `@planned`, er ingenting levert.
- En del som er `@draft` eller `@deprecated`, blir ikke levert. Peker ankeret på en slik del, er fasen ikke levert, og FS Kravforvaltning varsler.
- Peker ankeret på flere deler, må alle være levert.

En flyt kan derfor være `@implemented` selv om et krav den bygger på, ikke er levert som helhet. Endres delen flyten bygger på, er fasen ikke levert lenger, og FS Kravforvaltning varsler at flyten er bak kravene.

Flytens egen status går `@draft` →(`fs-krav`)→ `@planned` →(`fs-verify`)→ `@implemented`. Den hentes ikke inn i en oppgave, og hopper over `@in-progress`. `fs-verify` setter `@implemented` når alle fasene er levert, og den har funnet i koden både stedet der hver overlevering lages og stedet der den brukes.

I akseptansetesten tas flytene som går gjennom kravene i leveransen, med (`fs-testplan`), og overleveringene testes: hele flyten når den er `@implemented`, ellers de leverte fasene i leveransen.

Flytene finnes med `grep`, som referansene:

| Spørsmål | Svar |
|---|---|
| Hvilke flyter går gjennom kravet? | `grep -rln "@depends-on-OPT-OPT-UTD-004" krav/_Flyter/` |
| Hva må sjekkes når kravet endres, også flytene? | `grep -rn "@depends-on-OPT-OPT-UTD-004" krav/` |

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

Disse reglene gjelder for alle kravfiler. Tvetydige ord skal **avklares** før teksten skrives eller godkjennes. Hvert domene kan ha en begrepsliste i `krav/<NN Domene>/begreper.md`. Bruk den når den finnes.

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
