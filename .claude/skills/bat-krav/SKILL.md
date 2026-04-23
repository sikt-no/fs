---
name: bat-krav
description: >
  Initiativ-nivå kravarbeid i utviklingsmodellen. Bruk når brukeren snakker om
  et initiativ, kravspesifikasjon, systemkrav, eller vil binde flere kapabiliteter
  sammen under én brukerhistorie. Trigges av: "definere krav for initiativ",
  "kravspesifikasjon", "systemkrav", "starte kravarbeid", "lage kravdokument",
  "fullføre krav i mappe", "få krav klare til planning", "tagge med planned",
  "ferdigstille drafts". Produserer nye `.feature`-filer (og evt.
  `systemkrav.md`) fra bunnen, ELLER går gjennom en eksisterende mappe og
  tagger hver `Egenskap:` med `@planned` — enten ved å erstatte `@draft`
  etter at draft-innholdet er avklart, eller ved å legge til `@planned` på
  krav som mangler status. Ikke bruk for enkeltstående feature-filer uten
  initiativ-kontekst – bruk `skrive-krav` til det.
---

# Definere krav

## Hensikt

Spesifisere funksjonelle krav for et initiativ ved hjelp av brukerhistorier og Gherkin-scenarios (Gitt-Når-Så). Resultatet lagres som `.feature`-filer i `krav/`-mappen, strukturert etter **Domene → Sub-domene → Kapabilitet**. Valgfritt kan det også opprettes et overordnet `systemkrav.md`-dokument som binder flere features sammen for initiativet.

Skillen støtter også **iterativ fullføring** av allerede skisserte krav: Gå gjennom en mappe og få hver `Egenskap:` tagget med `@planned`. For krav som står som `@draft` må innholdet avklares før taggen byttes til `@planned`. Krav som mangler status får `@planned` lagt til (etter en kjapp sjekk om innholdet er klart; er det ikke det, behandles det som draft først).

## Forutsetninger

- Arbeidet skjer i `krav/`-mappen i dette repoet
- Konvensjoner er definert i `.claude/rules/gherkin-conventions.md` — følg dem
- Kjente persona: administrator, søker, student, saksbehandler
- **GitHub-saksnummer er påkrevd** når fila opprettes, slettes, `Egenskap:`-tittelen endres, eller `# GitHub:`-referansen byttes — se *Når må GitHub-issue synkroniseres?* under. Endringer i scenarios, regler eller brukerhistorie krever **ikke** GitHub-oppdatering.
- `gh` CLI brukes for å verifisere og opprette issues. Repo utledes automatisk fra git remote (typisk `sikt-no/fs`), og kan overstyres med `--repo`.

## Arbeidsmoduser

Skillen har to moduser. Velg modus basert på hva brukeren ber om. Hvis det er uklart, spør.

| Modus | Når | Følg |
|-------|-----|------|
| **A. Nytt kravarbeid** | Bruker starter på et nytt initiativ / skal lage nye krav fra bunnen | *Prosess: Nytt kravarbeid* (steg 1–9) |
| **B. Fullføre krav i mappe** | Bruker peker på en eksisterende mappe og vil få alle `Egenskap:` tagget `@planned`. Trigge-ord: "fullføre krav i [mappe]", "få kravene klare", "tagge med planned", "ferdigstille iterasjon N" | *Prosess: Fullføre krav i mappe* (steg F1–F5) |

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

### 1a. Verifiser eller opprett GitHub-issue

**Hvis brukeren oppgir et eksisterende saksnummer**, verifiser det med `gh` og vis tittelen tilbake til brukeren for bekreftelse:

```bash
gh issue view 1234 --json number,title,state,url
```

Hvis issuet er lukket, eller tittelen ikke matcher det brukeren forventer, stopp og avklar.

**Hvis brukeren ikke har et issue**, tilby å opprette et. **Spør alltid om parent issue først** — alle nye krav-issues skal linkes som sub-issue til et overordnet initiativ/epic:

1. Spør: *"Hvilket parent-issue (initiativ/epic) skal dette nye issuet linkes under?"* — ikke fortsett uten svar.
2. Verifiser parent-issuet: `gh issue view <PARENT> --json id,number,title,state` — bekreft med brukeren at det er riktig.
3. Avklar tittel og kort beskrivelse for det nye issuet sammen med brukeren.
4. Opprett issuet:

   ```bash
   gh issue create \
     --title "<TITTEL>" \
     --body "<BESKRIVELSE med referanse til parent: Parent: #<PARENT>>"
   ```

   Noter issue-nummeret fra outputen (f.eks. `#1250`).
5. Link som sub-issue til parent. GitHub bruker intern issue-ID (ikke issue-nummer) for sub-issue-API-et. **Bruk `-F` (stor F)** — `-f` sender strenger, og API-et krever integer (ellers feiler det med `422 Invalid property`):

   ```bash
   # Hent intern ID for det nye issuet
   NEW_ID=$(gh api repos/{owner}/{repo}/issues/<NEW_NUMBER> --jq .id)

   # Legg det til som sub-issue under parent (merk: -F, ikke -f)
   gh api repos/{owner}/{repo}/issues/<PARENT_NUMBER>/sub_issues \
     -X POST \
     -F sub_issue_id="$NEW_ID"
   ```

   Verifiser med `gh api repos/{owner}/{repo}/issues/<PARENT>/sub_issues --jq '[.[] | {number, title, state}]'`.

   Sub-issue-API-et er verifisert tilgjengelig på `sikt-no/fs`. Hvis kallet feiler med 404/403 på andre repo, fall tilbake til en tekstlig `Parent: #<PARENT>`-linje i body og informer brukeren.

6. Bruk det nye issue-nummeret videre i `GitHub: #<NNNN>`-linjen i `Egenskap`.

**Ved oppdatering av eksisterende krav:** steg 1a gjelder kun når selve identiteten endres (fila opprettes/slettes, `Egenskap:`-tittelen endres, eller saksnummeret skal byttes). Ved ren innholdsredigering — nye/endrede scenarios, justerte regler, nye åpne spørsmål — trenger du ikke verifisere eller oppdatere GitHub. Se tabellen i *Når må GitHub-issue synkroniseres?*.

Hvis tittelen på `Egenskap:` endres, oppdater også tittelen på det linkede issuet: `gh issue edit <NNN> --title "<ny Egenskap-tittel>"`.

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
- **Eventuelle `systemkrav.md`** i samme område

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

### 6. Bekreft og skriv feature-filen

Bekreft samlet innhold med brukeren før du skriver til disk.

Feature-ID settes som tag på filen: `@DOM-SUB-KAP-NNN` (3-bokstavs forkortelser for domene/sub-domene/kapabilitet, utledet fra mappenavn, pluss neste ledige løpenummer).

Format:

```gherkin
# language: no
# GitHub: #1234
@DOM-SUB-KAP-NNN @must
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

# ÅPNE SPØRSMÅL:
# - {spørsmål}
```

**GitHub-saksnummer er påkrevd** og plasseres som en Gherkin-kommentar `# GitHub: #NNNN` på **linjen rett over tag-linjen** for `Egenskap`-en (mellom `# language: no` og `@DOM-SUB-KAP-NNN`-taggen). Referansen tilhører egenskapen konseptuelt, men skrives utenfor `Egenskap`-blokken slik at den er synlig uten å scrolle gjennom brukerhistorien.

Ved oppdatering: hvis eksisterende fil mangler `# GitHub:`-linjen, legg den til rett over tag-linjen. Hvis en egenskap dekker flere issues, list alle: `# GitHub: #1234, #1250`.

Hvis en fil noen gang inneholder flere `Egenskap:`-blokker, plasseres én `# GitHub:`-kommentar over hver sine tag-linje — slik at referansen alltid er direkte knyttet til egenskapen like under.

Filnavn: `snake_case.feature` med verb + substantiv, f.eks. `opprette_organisasjon.feature`, `se_søknad.feature`.

### 7. Valgfritt: opprett eller oppdater `systemkrav.md`

Hvis initiativet omfatter flere features, eller det er nyttig med en overordnet beskrivelse, opprett eller oppdater en `systemkrav.md` i domene- eller sub-domene-mappen. Les malen fra `references/mal-systemkrav.md`.

Hver kapabilitet skal ha en Feature-ID som klikkbar relativ lenke til `.feature`-filen. Husk URL-koding: mellomrom = `%20`, `å` = `%C3%A5`, `ø` = `%C3%B8`, `æ` = `%C3%A6`.

### 8. Oppdater kravoversikten

Etter at feature-filen er lagret, oppdater den genererte oversikten hvis verktøyet finnes i repoet:

```bash
cd krav-parser && npm run generate-overview
```

Hvis verktøyet ikke er tilgjengelig, hopp over — `krav-oversikt.md` regenereres typisk i CI.

### 9. Oppsummer

Vis brukeren:

- Sti til opprettet/oppdatert `.feature`-fil (som klikkbar markdown-lenke)
- Feature-ID som ble tildelt
- **GitHub-saksnummer som er linket** (`#NNNN`), og parent-issue hvis nyopprettet (`↳ under #<PARENT>`)
- Antall scenarios og prioritet
- Åpne spørsmål som gjenstår
- Sti til `systemkrav.md` hvis opprettet
- Neste steg: foreslå `lage-steps`-skillen for å implementere step-definitions

## Prosess: Fullføre krav i mappe

Bruk når brukeren peker på en mappe med eksisterende `.feature`-filer som skal ferdigstilles.

**Mål:** Hver `Egenskap:` i mappen ender opp tagget med `@planned` på `Egenskap:`-linjen. Det er to veier dit:

| Startstatus | Vei til `@planned` |
|-------------|--------------------|
| `@draft` | Lukk åpne spørsmål og konkretiser scenarios. Bytt deretter `@draft` med `@planned`. |
| Ingen status (hverken `@draft` eller `@planned`) | Bekreft at innholdet er klart. Er det klart: legg til `@planned` direkte. Er det ikke klart: behandle som draft først. |
| Allerede `@planned` / `@in-progress` / `@implemented` | Ingen endring. |

Bakgrunnen: `@draft` markerer at *kravteksten* er utkast (kravstatus), og `@planned` markerer at *kravet er klart til implementasjon* (implementasjonsstatus). Når et draft er ferdigstilt, fjernes `@draft` og erstattes av `@planned` — vi beholder ikke begge samtidig, og vi lar ikke krav stå uten status. Se `gherkin-conventions.md` for den autoritative definisjonen.

### F1. Identifiser mappen

Spør brukeren hvilken mappe som skal gjennomgås (eller bruk den de allerede har nevnt). Bekreft absolutt sti før du begynner. Alle `.feature`-filer i mappen og dens undermapper inngår i gjennomgangen.

### F2. Kartlegg status

Les hver `.feature`-fil og klassifiser hvert krav basert på tags på `Egenskap:`-nivå:

| Kategori | Tag-kombinasjon | Tiltak |
|----------|-----------------|--------|
| **Draft** | `@draft` finnes | F4: lukk spørsmål, deretter bytt `@draft` → `@planned` |
| **Uten status** | Verken `@draft` eller `@planned` (heller ikke `@in-progress`/`@implemented`) | F3: avklar med bruker, deretter legg til `@planned` |
| **Allerede klar** | `@planned`, `@in-progress` eller `@implemented` finnes, og `@draft` finnes ikke | Ingen endring — rapporter som klar |

Vis brukeren en oversikt før du gjør endringer, med klikkbare lenker:

```
Oversikt for <mappe>:

Draft som skal bli @planned (N):
- [fil1.feature](relativ/sti/fil1.feature) — <Egenskap-tittel>

Uten status — skal bli @planned (M):
- [fil2.feature](relativ/sti/fil2.feature) — <Egenskap-tittel>

Allerede klar (K):
- [fil3.feature](relativ/sti/fil3.feature) — <Egenskap-tittel> (@planned)
```

Vent på bekreftelse før du går videre.

### F3. Håndter krav uten status

For hvert "uten status"-krav, still brukeren ett raskt spørsmål:

> *"[tittel] mangler status. Er innholdet klart til implementasjon slik det står? (a) Ja → jeg legger til `@planned` direkte, (b) Nei, trenger avklaring først → jeg behandler det som et draft og går gjennom scenarios med deg."*

Grupper gjerne flere krav i samme spørsmål.

- **(a) Direkte `@planned`:** Gjør en kjapp sanity-sjekk av filen (åpne spørsmål, skisse-pregede scenarios, terminologi) og flagg til bruker hvis noe ser uferdig ut *før* du legger til taggen. Ellers: legg `@planned` på `Egenskap:`-tag-linjen (typisk etter MoSCoW-tag: `@must @planned`) og gå videre.
- **(b) Behandle som draft:** Legg `@draft` på tag-linjen, og inkluder kravet i F4-køen.

### F4. Fullfør `@draft`-krav og bytt tag til `@planned`

Ta ett draft-krav om gangen. For hvert:

1. **Les hele filen grundig** — inkludert `# ÅPNE SPØRSMÅL:`, `# TODO:`-linjer, kommentarer som peker til Confluence/eksterne kilder, og alle scenarios.
2. **Les relatert kontekst:**
   - Andre `.feature`-filer i samme kapabilitet for stil og gjenbruk
   - Eksisterende step-definisjoner i `tester/steps/**/*.ts` — gjenbruk formuleringer som allerede er implementert
   - Evt. `systemkrav.md` i samme område
3. **Oppsummer for brukeren** hva som mangler eller er uavklart:
   - Åpne spørsmål som ikke er besvart
   - Skisse-pregede scenarios uten konkrete data / forventet resultat
   - Uklare feltlister, rolle-navn, feilmeldinger, forretningsregler
   - Terminologi-avvik (`institusjon`, `institusjonsnummer` — se `gherkin-conventions.md`)
   - Manglende `Bakgrunn:` der det ville redusert duplisering
4. **Still konkrete spørsmål** for å lukke hull. Hovedregel: *aldri finn på valideringsregler, feilmeldinger eller forretningslogikk — spør brukeren*. Marker forslag tydelig som "forslag" hvis du presenterer dem for reaksjon.
5. **Oppdater filen** basert på svarene: revider og konkretiser scenarios, legg til manglende scenarios, fjern besvarte `# ÅPNE SPØRSMÅL:`-kommentarer, stram opp språk, rett terminologi, og sørg for at Gherkin-konvensjonene følges (Scenariomal + Eksempler, deklarativ stil, én atferd per scenario).
6. **Bytt `@draft` med `@planned`** på `Egenskap:`-tag-linjen når alle åpne spørsmål er besvart og scenarios er konkrete nok til implementasjon. Ikke behold begge. Eksempel: `@BRU-APP-API-001 @must @draft` → `@BRU-APP-API-001 @must @planned`.
7. **Bekreft endringen med brukeren** før du skriver til disk hvis scenarios endres vesentlig. Mindre opprettinger (terminologi, formatering) kan skrives direkte.

**Hvis et draft ikke lar seg fullføre i denne sesjonen** (venter på ekstern input, produktavklaring, design-beslutning): behold `@draft`, dokumenter gjenværende usikkerhet som oppdatert `# ÅPNE SPØRSMÅL:`, og rapporter tydelig i F5 at kravet fortsatt er draft.

**GitHub-synk:** Typisk fullføring endrer *innhold* — ikke identitet — så `gh`-flyten er ikke relevant. Se tabellen i *Når må GitHub-issue synkroniseres?*. Oppdater bare hvis `Egenskap:`-tittelen endres eller fila flyttes/omdøpes.

### F5. Oppsummer arbeidet

Når hele mappen er gjennomgått, rapportér til brukeren:

- Antall krav som nå er tagget `@planned` (fordelt på "direkte fra manglende status" vs. "fullført fra draft")
- Antall krav som fortsatt er `@draft`, med grunn (venter på ekstern avklaring, produktinput, etc.)
- Antall krav som var `@planned`/`@in-progress`/`@implemented` fra før og ikke ble endret
- Samlet liste over gjenstående `# ÅPNE SPØRSMÅL:` på tvers av filer — som en enkelt punktliste brukeren kan ta med inn i neste avklaringsrunde
- Forslag til neste steg: `lage-steps` for `@planned`-krav, eller oppdatere tilhørende `systemkrav.md` hvis innholdet er vesentlig endret

Kjør kravoversikten til slutt hvis verktøyet finnes:

```bash
cd krav-parser && npm run generate-overview
```

## Feilhåndtering

- Hvis brukeren ikke vet hvilket domene: vis strukturen fra `krav-oversikt.md` og la dem velge
- Hvis en eksisterende feature dekker samme funksjonalitet: foreslå å utvide den i stedet for ny fil
- Hvis aktør/terminologi er tvetydig: stopp og avklar før du skriver
- Hvis mappen fra modus B er tom eller ikke finnes: stopp og be brukeren bekrefte stien
- Hvis et `@draft`-krav har så mange åpne spørsmål at det ikke kan fullføres i én sesjon: rapporter tidlig, foreslå å dele opp, og la brukeren prioritere hvilke krav som skal fullføres først

## Referanser

- **`.claude/rules/gherkin-conventions.md`** — autoritative prosjektkonvensjoner for mappestruktur, Feature-ID, tags, terminologi
- **`references/mal-systemkrav.md`** — mal for overordnet `systemkrav.md`-dokument
- **`krav/krav-oversikt.md`** — generert oversikt over alle eksisterende features
