---
name: bat-krav
description: >
  Initiativ-nivå kravarbeid i utviklingsmodellen. Bruk når brukeren snakker om
  et initiativ, kravspesifikasjon, systemkrav, eller vil binde flere kapabiliteter
  sammen under én brukerhistorie. Trigges av: "definere krav for initiativ",
  "kravspesifikasjon", "systemkrav", "starte kravarbeid", "lage kravdokument".
  Produserer et overordnet `systemkrav.md` og én eller flere `.feature`-filer
  i `krav/`-repoet, med brukerhistorier, MoSCoW-prioritering og åpne spørsmål.
  Ikke bruk for enkeltstående feature-filer uten initiativ-kontekst – bruk
  `skrive-krav` til det.
---

# Definere krav

## Hensikt

Spesifisere funksjonelle krav for et initiativ ved hjelp av brukerhistorier og Gherkin-scenarios (Gitt-Når-Så). Resultatet lagres som `.feature`-filer i `krav/`-mappen, strukturert etter **Domene → Sub-domene → Kapabilitet**. Valgfritt kan det også opprettes et overordnet `systemkrav.md`-dokument som binder flere features sammen for initiativet.

## Forutsetninger

- Arbeidet skjer i `krav/`-mappen i dette repoet
- Konvensjoner er definert i `.claude/rules/gherkin-conventions.md` — følg dem
- Kjente persona: administrator, søker, student, saksbehandler
- **GitHub-saksnummer er påkrevd** når fila opprettes, slettes, `Egenskap:`-tittelen endres, eller `# GitHub:`-referansen byttes — se *Når må GitHub-issue synkroniseres?* under. Endringer i scenarios, regler eller brukerhistorie krever **ikke** GitHub-oppdatering.
- `gh` CLI brukes for å verifisere og opprette issues. Repo utledes automatisk fra git remote (typisk `sikt-no/fs`), og kan overstyres med `--repo`.

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

## Prosess

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

## Feilhåndtering

- Hvis brukeren ikke vet hvilket domene: vis strukturen fra `krav-oversikt.md` og la dem velge
- Hvis en eksisterende feature dekker samme funksjonalitet: foreslå å utvide den i stedet for ny fil
- Hvis aktør/terminologi er tvetydig: stopp og avklar før du skriver

## Referanser

- **`.claude/rules/gherkin-conventions.md`** — autoritative prosjektkonvensjoner for mappestruktur, Feature-ID, tags, terminologi
- **`references/mal-systemkrav.md`** — mal for overordnet `systemkrav.md`-dokument
- **`krav/krav-oversikt.md`** — generert oversikt over alle eksisterende features
