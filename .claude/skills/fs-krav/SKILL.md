---
name: fs-krav
description: >
  Initiativ-nivå kravarbeid i `krav/`-treet i dette repoet. Bruk når brukeren snakker om
  et initiativ, kravspesifikasjon, eller vil binde flere kapabiliteter
  sammen under én brukerhistorie. Trigges av: "definere krav for initiativ",
  "kravspesifikasjon", "starte kravarbeid", "lage kravdokument",
  "fullføre krav i mappe", "få krav klare til planning", "tagge med planned",
  "ferdigstille drafts". Produserer nye `.feature`-filer fra bunnen (alltid som
  `@draft`), ELLER fasiliterer en valideringsgjennomgang av kravene i en
  eksisterende mappe. Bare krav som valideres i gjennomgangen, eller som brukeren
  eksplisitt sier er klare, får `@planned` på `Egenskap:`. Resten forblir
  `@draft` med åpne spørsmål dokumentert. Brukes også for enkeltstående
  feature-filer ("skrive krav", "lage feature-fil", "skrive BDD-scenario").
---

# Definere krav

## Hensikt

Spesifisere funksjonelle krav for et initiativ ved hjelp av brukerhistorier og Gherkin-scenarios (Gitt-Når-Så). Resultatet lagres som `.feature`-filer i `krav/`-mappen, strukturert etter **Domene → Sub-domene → Kapabilitet**.

**Alle nye krav får `@draft`** og blir stående slik til de er validert.

Skillen fasiliterer derfor også **validering** av skisserte krav (modus B): Gå gjennom kravene i en mappe sammen med brukeren, lukk åpne spørsmål og konkretiser scenarioene. **`@planned` settes bare på krav som er validert i gjennomgangen, eller som brukeren eksplisitt sier skal ha `@planned`.** Skillen setter aldri `@planned` på eget skjønn, og aldri bare fordi innholdet «ser ferdig ut». En egenskap kan bli `@planned` selv om enkelte regler eller scenarioer bevisst står igjen som `@draft @openquestion` (se *Delvis utkast* i `gherkin-conventions.md`). Krav som mangler status regnes som ikke validert, og behandles som `@draft`.

## Forutsetninger

- Arbeidet skjer i `krav/`-mappen i dette repoet. Skillen leser og skriver kun `krav/`-treet — ikke `tasks/`.
- Konvensjoner er definert i `.claude/rules/gherkin-conventions.md` — følg dem, den er autoritativ. Ren Gherkin-syntaks står i `references/gherkin-syntax.md`.
- Kjente persona: administrator, søker, student, saksbehandler
- **GitHub-saksnummer er påkrevd** når fila opprettes, slettes, `Egenskap:`-tittelen endres, eller `# GitHub:`-referansen byttes — se *Når må GitHub-issue synkroniseres?* under. Endringer i scenarios, regler eller brukerhistorie krever **ikke** GitHub-oppdatering.
- GitHub-operasjonene (verifisering, opprettelse, sub-issue-linking, tittel-oppdatering, lukking) kan delegeres til `fs-github`-skillen når den er tilgjengelig. Er den ikke det, kjører denne skillen `gh`-kommandoene selv — se *GitHub-operasjoner* under steg 1a. Denne skillen avgjør uansett *når* en operasjon skal kjøres.
- **Confluence-bakgrunn er ofte tilgjengelig** via Atlassian-MCP (`mcp__claude_ai_Atlassian_Rovo__*`). Draft-filer refererer gjerne til kilden med en kommentar som `# Krav fra Confluence: K6 ...`. Bruk MCP-en til å hente siden når brukeren oppgir en URL/ID — **ikke** søk bredt i Confluence av eget initiativ; spør først.

## Arbeidsmoduser

Skillen har to moduser. Velg modus basert på hva brukeren ber om. Hvis det er uklart, spør.

| Modus | Når | Følg |
|-------|-----|------|
| **A. Nytt kravarbeid** | Bruker starter på et nytt initiativ / skal lage nye krav fra bunnen | *Prosess: Nytt kravarbeid* (steg 1–7) |
| **B. Fullføre krav i mappe** | Bruker peker på en eksisterende mappe og vil gå gjennom og validere kravene, slik at de validerte kan få `@planned`. Trigge-ord: "fullføre krav i [mappe]", "få kravene klare", "tagge med planned", "ferdigstille iterasjon N" | *Prosess: Fullføre krav i mappe* (steg F1–F5) |

Modusene kan kjedes: fullføring avdekker ofte behov for nye scenarios eller nye features, som da følger modus A videre.

## Når må GitHub-issue synkroniseres?

GitHub sporer *kravets eksistens og identitet* — ikke kravets innhold. Innholdet eies av `.feature`-fila, og git-historikken gir sporbarhet.

| Endring i `.feature` | Oppdater GitHub? |
|----------------------|------------------|
| Ny fil opprettes | **Ja** — opprett issue (linket som sub-issue), sett `# GitHub: #NNN` |
| Fil slettes | **Ja** — lukk tilhørende issue med forklaring |
| Tittel på `Egenskap:` endres | **Ja** — oppdater issue-tittel så de er i synk |
| `# GitHub:`-referanse byttes (nytt saksnr) | **Ja** — verifiser nytt issue, oppdater fila |
| Scenarios legges til / endres / fjernes | Nei |
| `Regel:`-seksjoner endres | Nei |
| Brukerhistorien justeres (`Som en... / ønsker... / slik at...`) | Nei |
| Tags (`@must`, `@implemented`, ...) endres | Nei |
| Åpne spørsmål legges til / fjernes | Nei |
| Filen flyttes eller omdøpes | Nei — `# GitHub:`-referansen følger med |

Praktisk konsekvens: når brukeren ber om å legge til et scenario eller rette en `Regel:`, er `gh`-flyten i steg 1a ikke relevant. Hopp direkte til filendringen.

## Prosess: Nytt kravarbeid

### 1. Forstå initiativet

Hvis brukeren allerede har jobbet med et initiativ i denne samtalen, bruk det uten å spørre på nytt. Ellers, spør brukeren:

- Hva heter initiativet / hvilken funksjonalitet skal spesifiseres?
- Hvem er aktørene?
- Hvilket domene hører dette til? (se `krav/` for eksisterende domener)
- **Hvilket GitHub-saksnummer hører kravet til?** (f.eks. `#1234`)
- **Finnes det bakgrunnsinformasjon i Confluence** som skal legges til grunn? (side-URL, tiny-link eller side-ID — f.eks. en kravspesifikasjon, en workshop-oppsummering, eller en K-nummerert kravliste). Hvis ja, hent innholdet via `mcp__claude_ai_Atlassian_Rovo__getConfluencePage` før du begynner å skrive scenarios. Bruker sier "nei" eller "hopp over" → fortsett uten.

### 1a. Verifiser eller opprett GitHub-issue

Dette steget eier *hva* som skal avklares med brukeren. Selve `gh`-kallene er beskrevet under *GitHub-operasjoner* nedenfor.

**Hvis brukeren oppgir et eksisterende saksnummer:** verifiser issuet, og vis tittelen tilbake til brukeren for bekreftelse. Stopp og avklar hvis issuet er lukket eller tittelen ikke matcher.

**Hvis brukeren ikke har et issue:** tilby å opprette et. Avklar disse to tingene først:

1. **Parent-issue (initiativ/epic)** — alle nye krav-issues skal linkes som sub-issue. Spør: *"Hvilket parent-issue (initiativ/epic) skal dette nye issuet linkes under?"* og ikke fortsett uten svar. Verifiser parent-issuet og bekreft med brukeren at det er riktig.
2. **Tittel og kort beskrivelse** for det nye issuet (inkludér gjerne en `Parent: #<PARENT>`-linje i body som backup hvis sub-issue-koblingen feiler).

Opprett deretter issuet og link det som sub-issue til parent. Bruk det returnerte issue-nummeret videre i `# GitHub: #<NNNN>`-linjen i `.feature`-fila.

**Ved oppdatering av eksisterende krav:** steg 1a gjelder kun når selve identiteten endres (fila opprettes/slettes, `Egenskap:`-tittelen endres, eller saksnummeret skal byttes). Ved ren innholdsredigering — nye/endrede scenarios, justerte regler, nye åpne spørsmål — trenger du ikke verifisere eller oppdatere GitHub. Se tabellen i *Når må GitHub-issue synkroniseres?*.

Hvis tittelen på `Egenskap:` endres, oppdater tittelen på det linkede issuet så de er i synk.

#### GitHub-operasjoner

**Er `fs-github`-skillen tilgjengelig, deleger dit** — den eier disse operasjonene og holder dem oppdatert. Er den ikke det, kjør kommandoene under direkte. Begge veier gir samme resultat.

Forutsetter at `gh` er installert og autentisert. Repo utledes fra git remote (`sikt-no/fs`); overstyr med `--repo <owner>/<repo>` ved behov.

```bash
# Verifisere et issue — returner tittel og state til brukeren for bekreftelse
gh issue view <NNN> --json number,title,state,url

# Opprette nytt issue — plukk ut issue-nummeret fra outputen
gh issue create --title "<TITTEL>" --body "<BODY>"

# Oppdatere tittel / lukke
gh issue edit <NNN> --title "<NY TITTEL>"
gh issue close <NNN> --comment "<KORT BEGRUNNELSE>"
```

**Linke det nye issuet som sub-issue under parent** — to fallgruver, begge nødvendige:

```bash
# 1. Sub-issue-API-et bruker intern ID, ikke issue-nummer
NEW_ID=$(gh api repos/{owner}/{repo}/issues/<NEW_NUMBER> --jq .id)

# 2. Bruk -F (stor F). -f sender streng, og API-et krever integer → 422 Invalid property
gh api repos/{owner}/{repo}/issues/<PARENT_NUMBER>/sub_issues \
  -X POST \
  -F sub_issue_id="$NEW_ID"

# Verifiser at koblingen er på plass
gh api repos/{owner}/{repo}/issues/<PARENT_NUMBER>/sub_issues \
  --jq '[.[] | {number, title, state}]'
```

Feiler sub-issue-kallet (404/403 forekommer på repo der API-et ikke er tilgjengelig): issuet er allerede opprettet, så ikke opprett det på nytt. Rapportér at koblingen manglet, og støtt deg på `Parent: #<PARENT>`-linja i body.

### 2. Plasser kravet riktig i mappestrukturen

Feature-filer skal **kun** plasseres på kapabilitetsnivå (nivå 3):

```
krav/
└── [NN] [Domene]/
    └── [NN] [Sub-domene]/
        └── [NN] [Kapabilitet]/
            └── feature-navn.feature
```

Sjekk `krav/krav-oversikt.md` og bla i `krav/`-mappen for å:
- Finne riktig eksisterende plassering for funksjonaliteten
- Oppdage om det allerede finnes en relatert feature som skal utvides i stedet
- Finne neste ledige løpenummer for Feature-ID

Hvis en ny sub-domene eller kapabilitet må opprettes, bekreft navnet med brukeren før du lager mappen. Bruk toposiffer-prefiks (`10`, `11`, `12` ...) i tråd med eksisterende konvensjon.

**Tverrgående kapabiliteter:** Skillet mellom *hva* (domene-spesifikt) og *hvordan* (`10 Felleskrav`) er beskrevet i konvensjonsfilen. Ved tvil, spør.

### 3. Les eksisterende kontekst

Før du skriver nye scenarios, les:

- **Relaterte feature-filer** i samme kapabilitet/sub-domene for å unngå duplisering og matche stil
- **Eksisterende step-definisjoner** i `tester/steps/**/*.ts` for å se hvilke Gherkin-fraser som allerede er implementert — gjenbruk dem når det passer

Presenter kort hva som finnes fra før, og avklar om nytt krav skal legges i ny fil eller i eksisterende.

### 4. Bruk eventuell Example Mapping-output

Hvis teamet har kjørt en Example Mapping-workshop:

- Blå kort (regler) → `Regel:`-seksjoner i Gherkin
- Grønne kort (eksempler) → `Scenario:` under hver `Regel`
- Røde kort (spørsmål) → `# ÅPNE SPØRSMÅL:`-kommentarer

Spør brukeren om de har slik output tilgjengelig. Hvis ikke, gå videre.

### 5. Definer kravet iterativt

For hvert krav, avklar med brukeren:

**Brukerhistorie (plasseres under `Egenskap:`):**
- Som en `{AKTØR}` ønsker jeg å `{HANDLING}` slik at `{VERDI}`

**Prioritet (MoSCoW-tag):**
- `@must` / `@should` / `@could` / `@wont`

**Status:** alltid `@draft` for nye krav — også når innholdet virker ferdig. Overgangen til `@planned` skjer først når kravet er validert (modus B), eller når brukeren eksplisitt ber om det. Ikke tagg enkelt-regler eller -scenarioer `@draft` i et nytt krav; det dekkes av `@draft` på `Egenskap:`. Bruk `@openquestion` + `# ÅPNE SPØRSMÅL:` for å peke ut konkrete uklarheter.

**Scenarios (Gherkin):**
- `Gitt` — forutsetning/kontekst
- `Når` — handlingen som utføres
- `Så` — forventet resultat
- `Og` / `Men` for påfølgende ledd i samme blokk

Bruk `Regel:` for å gruppere relaterte scenarios under forretningsregler.

**Ikke anta:** Aldri finn på feilmeldinger, valideringsregler eller forretningslogikk. Spør brukeren. Marker uklarheter som `# ÅPNE SPØRSMÅL:`-kommentarer i filen.

### Gherkin beste praksis

- **Ett scenario = én atferd** — ikke test flere ting i ett scenario
- **Deklarativ stil** — skriv HVA som skal skje, ikke HVORDAN (unngå "klikk på knapp")
- **Konkrete eksempler** — bruk spesifikke verdier, ikke generiske plassholdere
- **`Scenariomal`** for variasjoner av samme scenario med ulike data — `Eksempler:` skal KUN brukes med `Scenariomal:`
- **`Bakgrunn:`** for felles forutsetninger som gjelder alle scenarios i filen
- **Norsk Gherkin** — `# language: no` øverst, norske nøkkelord
- **Terminologi** — se konvensjonsfilen for ord som krever avklaring (f.eks. "institusjon" → organisasjon vs. lærested)
- **Tredjeperson i steps** — skriv «Når opptaksforvalteren søker …», ikke «Når jeg søker …». Førsteperson hører bare hjemme i brukerhistorien under `Egenskap:` («ønsker jeg å»). Vær konsekvent gjennom hele fila
- **Korte scenariotitler** — én linje som beskriver atferden, uten «og», «eller», «fordi» eller «slik at». En konjunksjon i tittelen betyr som regel to atferder, og da bør scenariet deles
- **Ingen punktlister i steps** — `-`-lister under et steg gir parse-feil. Bruk en datatabell (`| kolonne |`) eller en doc string (`"""`)

### 6. Bekreft og skriv feature-filen

Bekreft samlet innhold med brukeren før du skriver til disk.

Feature-ID settes som tag på filen: `@DOM-SUB-KAP-NNN` (3-bokstavs forkortelser for domene/sub-domene/kapabilitet, utledet fra mappenavn, pluss neste ledige løpenummer). Tag-linja er alltid `@DOM-SUB-KAP-NNN @<moscow> @draft`.

Når du legger til en ny `Regel:` eller et nytt scenario i en fil som allerede er `@planned`/`@in-progress`, tagges den nye delen `@draft @openquestion` til den er validert, med mindre brukeren eksplisitt sier at den er klar.

Format:

```gherkin
# language: no
# GitHub: #1234
@DOM-SUB-KAP-NNN @must @draft
Egenskap: {EGENSKAP_NAVN}
  Som en {AKTØR}
  ønsker jeg å {HANDLING}
  slik at {VERDI}.

  Bakgrunn:
    Gitt {FELLES_FORUTSETNING}

  Regel: {FORRETNINGSREGEL}

    Scenario: {SCENARIO_NAVN}
      Gitt {FORUTSETNING}
      Når {HANDLING}
      Så {FORVENTET_RESULTAT}

    Scenariomal: {NAVN_PÅ_VARIASJON}
      Gitt {FORUTSETNING_MED_<parameter>}
      Når {HANDLING_MED_<parameter>}
      Så {FORVENTET_RESULTAT_MED_<parameter>}

      Eksempler:
        | parameter | annet_felt |
        | verdi_a   | resultat_a |
        | verdi_b   | resultat_b |

# ÅPNE SPØRSMÅL:
# - {spørsmål}
```

`Scenariomal` brukes når samme atferd skal verifiseres med flere konkrete dataverdier — `Eksempler:` skal aldri brukes uten en `Scenariomal:` over seg. For et fullt utfylt eksempel med realistiske scenarios, se `references/eksempel-feature.feature`.

**GitHub-saksnummer er påkrevd** og plasseres som en Gherkin-kommentar `# GitHub: #NNNN` på **linjen rett over tag-linjen** for `Egenskap`-en (mellom `# language: no` og `@DOM-SUB-KAP-NNN`-taggen). Referansen tilhører egenskapen konseptuelt, men skrives utenfor `Egenskap`-blokken slik at den er synlig uten å scrolle gjennom brukerhistorien.

Ved oppdatering: hvis eksisterende fil mangler `# GitHub:`-linjen, legg den til rett over tag-linjen. Hvis en egenskap dekker flere issues, list alle: `# GitHub: #1234, #1250`.

Hvis en fil noen gang inneholder flere `Egenskap:`-blokker, plasseres én `# GitHub:`-kommentar over hver sine tag-linje — slik at referansen alltid er direkte knyttet til egenskapen like under.

Filnavn: `snake_case.feature` med verb + substantiv, f.eks. `opprette_organisasjon.feature`, `se_søknad.feature`.

### 7. Oppsummer

Vis brukeren:

- Sti til opprettet/oppdatert `.feature`-fil (som klikkbar markdown-lenke)
- Feature-ID som ble tildelt
- **GitHub-saksnummer som er linket** (`#NNNN`), og parent-issue hvis nyopprettet (`↳ under #<PARENT>`)
- Antall scenarios og prioritet
- Åpne spørsmål som gjenstår
- At kravet står som `@draft`
- Neste steg: valider kravet gjennom modus B (*Fullføre krav i mappe*). Først når det er validert og har fått `@planned`, kan `fs-specify` hente det inn i en oppgavemappe og `lage-steps` implementere step-definitions

## Prosess: Fullføre krav i mappe

Bruk når brukeren peker på en mappe med eksisterende `.feature`-filer som skal ferdigstilles.

**Mål:** Fasilitere en gjennomgang der kravene i mappen valideres sammen med brukeren. Målet er *validerte krav*, ikke flest mulig `@planned`-tagger. Et krav som ikke er validert, forblir `@draft` — det er et fullt gyldig utfall av gjennomgangen.

**`@planned` settes bare når ett av disse er oppfylt:**

1. Kravet er gått gjennom i denne gjennomgangen, åpne spørsmål i hovedflyten er lukket, og brukeren har bekreftet at kravet er validert.
2. Brukeren sier eksplisitt at et bestemt krav skal ha `@planned` (f.eks. fordi det allerede er validert i et møte eller en workshop). Gjengi da hvilket krav det gjelder, og sett taggen uten å gå gjennom innholdet.

Skillen foreslår aldri `@planned` ut fra egen vurdering av at innholdet «ser ferdig ut».

| Startstatus | Håndtering |
|-------------|------------|
| `@draft` | Gå gjennom kravet (F4). Validert → bytt `@draft` med `@planned` på `Egenskap:`. Deler som bevisst skal vente kan stå igjen som `@draft @openquestion`. Ikke validert → behold `@draft` og dokumenter hva som mangler. |
| Ingen status — gjelder eldre filer | Regnes som ikke validert. Legg til `@draft` og ta kravet med i gjennomgangen (F3). |
| Allerede `@planned` / `@in-progress` / `@implemented` | Ingen endring. |

Bakgrunnen: `@draft` markerer at *kravteksten* er utkast (kravstatus), og `@planned` markerer at *kravet er klart til implementasjon* (implementasjonsstatus). Når et draft er ferdigstilt, fjernes `@draft` og erstattes av `@planned` på `Egenskap:` — vi beholder ikke begge samtidig på samme linje, og vi lar ikke krav stå uten status. `@draft` kan likevel stå igjen på enkelt-`Regel:`/`Scenario:` under en `@planned` egenskap når det er en bevisst beslutning. Se `gherkin-conventions.md` (*Kravstatus* og *Delvis utkast*) for den autoritative definisjonen.

**Denne skillen eier bare overgangen `@draft` → `@planned`.** Resten av implementasjonsaksen (`@in-progress`, `@implemented`) er beskrevet i `gherkin-conventions.md` og settes ikke her. Et krav du finner som `@in-progress` er plukket inn i en oppgave, og skal stå urørt.

### Interaksjonsprinsipp: ett spørsmål om gangen

**Ikke list opp alle åpne spørsmål i én stor blokk.** Still **ett spørsmål** og vent på svar før du går til neste. Dette er et ufravikelig prinsipp for modus B — brukeren har eksplisitt bedt om det, og en lang spørsmålsliste fører til at mange spørsmål blir hoppet over eller misforstått.

Praktiske regler:

- **Én fil om gangen, ett spørsmål om gangen.** Ikke bland spørsmål om flere filer i samme runde.
- **Tilby flervalg** (a/b/c) med konkrete alternativer når det er naturlig. Brukeren svarer raskere på "a" eller "b" enn på et åpent spørsmål, og det reduserer feiltolking.
- **Bruk `TodoWrite`** for å holde oversikt over gjenværende filer og spørsmål. Oppdater fortløpende slik at brukeren ser progresjon.
- **Når du har nok informasjon til å foreslå en konkret fil-endring:** presenter forslaget (gjerne som diff eller full kodeblokk) og spør om brukeren vil **(a) skrive** eller **(b) justere**. Én beslutning om gangen.
- **Tverrgående avklaringer først.** Hvis flere filer trenger samme avklaring (f.eks. aktør, terminologi), ta disse som separate overordnede spørsmål før du går ned i hver fil. Fortsatt ett spørsmål om gangen.
- **Ikke dump oppsummeringer av alt som er uklart.** Pek på én ting, få svar, gå videre.

### F1. Identifiser mappen

Spør brukeren hvilken mappe som skal gjennomgås (eller bruk den de allerede har nevnt). Bekreft absolutt sti før du begynner. Alle `.feature`-filer i mappen og dens undermapper inngår i gjennomgangen.

### F1.5. Spør om Confluence-bakgrunn

Før du begynner å avklare draftene, still dette spørsmålet til brukeren:

> *"Finnes det en Confluence-side med bakgrunnsinformasjon jeg skal legge til grunn når jeg fyller ut draftene? (side-URL, tiny-link eller side-ID). Hvis ikke: svar 'nei' eller 'hopp over'."*

Mange draft-filer inneholder allerede en peker som `# Krav fra Confluence: K6 ...`. Disse peker vanligvis til en kilde brukeren kjenner, men skillen skal **ikke søke i Confluence av eget initiativ** — vent på at brukeren oppgir URL/ID eller bekrefter at det ikke er relevant.

Når brukeren oppgir en kilde:
- Hent siden med `mcp__claude_ai_Atlassian_Rovo__getConfluencePage` (bruk `contentFormat: "markdown"` hvis du bare trenger tekst).
- Les igjennom og noter hvilke K-nummer / seksjoner som korresponderer med hvilke filer i mappen.
- Bruk Confluence-innholdet aktivt i F4 når du foreslår scenario-formuleringer og avklarer åpne spørsmål — men **ikke** finn på detaljer som ikke står i kilden; det skal fortsatt avklares med brukeren.

Hvis brukeren svarer "nei" / "hopp over": fortsett uten, og støtt deg på eksisterende `.feature`-filer, step-definisjoner og brukerens svar i F4.

### F2. Kartlegg status

Les hver `.feature`-fil og klassifiser hvert krav basert på tags på `Egenskap:`-nivå:

| Kategori | Tag-kombinasjon | Tiltak |
|----------|-----------------|--------|
| **Draft** | `@draft` finnes | F4: gjennomgang. `@planned` bare hvis validert |
| **Uten status** | Verken `@draft` eller `@planned` (heller ikke `@in-progress`/`@implemented`) | F3: legg til `@draft`, deretter gjennomgang i F4 |
| **Allerede klar** | `@planned`, `@in-progress` eller `@implemented` finnes, og `@draft` finnes ikke | Ingen endring — rapporter som klar. Har fila `@draft`-deler på `Regel:`/`Scenario:`, list dem og spør om noen skal avklares nå (F4, trinn 5–6 for den delen) |

Vis brukeren en oversikt før du gjør endringer, med klikkbare lenker:

```
Oversikt for <mappe>:

Til gjennomgang — @draft (N):
- [fil1.feature](relativ/sti/fil1.feature) — <Egenskap-tittel>

Til gjennomgang — uten status, får @draft (M):
- [fil2.feature](relativ/sti/fil2.feature) — <Egenskap-tittel>

Allerede klar (K):
- [fil3.feature](relativ/sti/fil3.feature) — <Egenskap-tittel> (@planned)
  - @draft-del: <Regel-/Scenario-tittel>
```

Vent på bekreftelse før du går videre.

### F3. Håndter krav uten status

Et krav uten status er ikke validert. Legg `@draft` på `Egenskap:`-tag-linjen (typisk etter MoSCoW-tag: `@must @draft`) og ta kravet med i F4-køen.

Unntak: Har brukeren eksplisitt sagt at et bestemt krav skal ha `@planned`, settes `@planned` direkte (jf. *Mål* over). Ikke spør brukeren om et krav «er klart» for å åpne for denne snarveien — den skal komme fra brukeren.

### F4. Gjennomgå `@draft`-krav og valider

Ta ett draft-krav om gangen. For hvert:

1. **Les hele filen grundig** — inkludert `# ÅPNE SPØRSMÅL:`, `# TODO:`-linjer, kommentarer som peker til Confluence/eksterne kilder, og alle scenarios.
2. **Les relatert kontekst:**
   - Andre `.feature`-filer i samme kapabilitet for stil og gjenbruk
   - Eksisterende step-definisjoner i `tester/steps/**/*.ts` — gjenbruk formuleringer som allerede er implementert
   - Confluence-siden fra F1.5 hvis brukeren oppga en — slå opp K-nummeret (eller tilsvarende seksjonsreferanse) som nevnes i filens `# Krav fra Confluence:`-kommentar, og bruk innholdet som grunnlag for forslag
3. **Oppsummer for brukeren** hva som mangler eller er uavklart:
   - Åpne spørsmål som ikke er besvart
   - Skisse-pregede scenarios uten konkrete data / forventet resultat
   - Uklare feltlister, rolle-navn, feilmeldinger, forretningsregler
   - Terminologi-avvik (`institusjon`, `institusjonsnummer` — se `gherkin-conventions.md`)
   - Manglende `Bakgrunn:` der det ville redusert duplisering
4. **Still konkrete spørsmål — ett om gangen.** Jf. interaksjonsprinsippet: ikke dump hele spørsmålslisten i én blokk. Still ett spørsmål, gi (a)/(b)/(c)-alternativer der det er naturlig, og vent på svar før du går til neste. Hovedregel: *aldri finn på valideringsregler, feilmeldinger eller forretningslogikk — spør brukeren*. Marker forslag tydelig som "forslag" hvis du presenterer dem for reaksjon.
5. **Oppdater filen** basert på svarene: revider og konkretiser scenarios, legg til manglende scenarios, fjern besvarte `# ÅPNE SPØRSMÅL:`-kommentarer, stram opp språk, rett terminologi, og sørg for at Gherkin-konvensjonene følges (Scenariomal + Eksempler, deklarativ stil, én atferd per scenario).
6. **Be brukeren om validering.** Når åpne spørsmål i hovedflyten er besvart og scenariene er konkrete nok til implementasjon, spør: *"Er [tittel] validert slik det står nå? (a) Ja → `@planned`, (b) Nei → beholder `@draft`."* Bytt `@draft` med `@planned` på `Egenskap:`-tag-linjen bare ved (a). Ikke behold begge. Eksempel: `@BRU-APP-API-001 @must @draft` → `@BRU-APP-API-001 @must @planned`.

   **Delvis utkast:** Gjenstår det spørsmål som bare gjelder en avgrenset `Regel:` eller et enkelt scenario, spør brukeren: *"(a) Vent med hele kravet — behold `@draft` på egenskapen, (b) Sett egenskapen til `@planned` og la [regel/scenario] stå som `@draft @openquestion`."* Velges (b): flytt `@draft` fra `Egenskap:` ned til den aktuelle delen sammen med `@openquestion`, og sørg for at `# ÅPNE SPØRSMÅL:` under delen beskriver hva som mangler. Velg aldri (b) på egen hånd — det skal være en bevisst beslutning.
7. **Bekreft endringen med brukeren** før du skriver til disk hvis scenarios endres vesentlig. Mindre opprettinger (terminologi, formatering) kan skrives direkte.

**Hvis et draft ikke lar seg fullføre i denne sesjonen** (venter på ekstern input, produktavklaring, design-beslutning) og delvis utkast ikke er aktuelt: behold `@draft`, dokumenter gjenværende usikkerhet som oppdatert `# ÅPNE SPØRSMÅL:`, og rapporter tydelig i F5 at kravet fortsatt er draft.

**GitHub-synk:** Typisk fullføring endrer *innhold* — ikke identitet — så GitHub-operasjonene i steg 1a er ikke relevante. Se tabellen i *Når må GitHub-issue synkroniseres?*. Oppdater bare hvis `Egenskap:`-tittelen endres eller fila flyttes/omdøpes.

### F5. Oppsummer arbeidet

Når hele mappen er gjennomgått, rapportér til brukeren:

- Antall krav som nå er tagget `@planned` (fordelt på "validert i gjennomgangen" vs. "satt etter eksplisitt beskjed fra bruker")
- Antall krav som fortsatt er `@draft` (inkludert eldre krav uten status som fikk `@draft`), med grunn (venter på ekstern avklaring, produktinput, etc.)
- `@planned`-krav med `@draft`-deler: hvilke regler/scenarioer som venter, og hvorfor
- Antall krav som var `@planned`/`@in-progress`/`@implemented` fra før og ikke ble endret
- Samlet liste over gjenstående `# ÅPNE SPØRSMÅL:` på tvers av filer — som en enkelt punktliste brukeren kan ta med inn i neste avklaringsrunde
- Forslag til neste steg: `lage-steps` for `@planned`-krav, eller `fs-specify` for å hente dem inn i en oppgavemappe

## Feilhåndtering

- Hvis brukeren ikke vet hvilket domene: vis strukturen fra `krav-oversikt.md` og la dem velge
- Hvis en eksisterende feature dekker samme funksjonalitet: foreslå å utvide den i stedet for ny fil
- Hvis aktør/terminologi er tvetydig: stopp og avklar før du skriver
- Hvis mappen fra modus B er tom eller ikke finnes: stopp og be brukeren bekrefte stien
- Hvis et `@draft`-krav har så mange åpne spørsmål at det ikke kan fullføres i én sesjon: rapporter tidlig, foreslå å dele opp, og la brukeren prioritere hvilke krav som skal fullføres først

## Referanser

- **`.claude/rules/gherkin-conventions.md`** — autoritative prosjektkonvensjoner for mappestruktur, Feature-ID, tags, terminologi
- **`references/gherkin-syntax.md`** — ren Gherkin-syntaks (norske nøkkelord, blokkstruktur, tag-plassering). Sier ingenting om prosjektets konvensjoner — det eier konvensjonsfila over
- **`references/eksempel-feature.feature`** — gullstandard-eksempel på en ferdigstilt (`@planned`) `.feature`-fil med `# GitHub:`, MoSCoW-tag, `Bakgrunn`, flere `Regel`-blokker, `Scenariomal` med `Eksempler`, `@openquestion`-tag på ett scenario, en `Regel` som bevisst står som `@draft @openquestion`, og `# ÅPNE SPØRSMÅL:`-kommentarer. Et nytt krav fra modus A ser likt ut, men med `@draft` i stedet for `@planned` og uten `@draft` på enkeltdeler
- **`krav/krav-oversikt.md`** — generert oversikt over alle eksisterende features
- **`fs-github`-skillen** — *valgfri*. Samme `gh`-operasjoner som steg 1a beskriver. Deleger dit når den er tilgjengelig
- **`lage-steps`** — søsken-skill i dette repoet. Implementerer step-definitions i `tester/steps/` for `@planned`-krav (ikke for `@draft`-deler)
- **`fs-specify`** / **`fs-specify-delta`** — søsken-skills i dette repoet. Henter `@planned`-krav inn i en oppgavemappe under `tasks/`
