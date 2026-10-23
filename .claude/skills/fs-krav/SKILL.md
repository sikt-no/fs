---
name: fs-krav
description: >
  Kravarbeid på feature-fil-nivå i `krav/`-treet i dette repoet: regler og
  scenarioer. Å avgrense et initiativ og dele det i oppgaver gjøres med
  `fs-scope` først. Trigges av: "skrive krav", "lage feature-fil",
  "skrive BDD-scenario", "fylle ut skjelett", "fullføre krav i mappe",
  "få krav klare til planning", "tagge med planned",
  "ferdigstille drafts", "fjerne krav", "slette krav", "avvikle krav". Produserer nye `.feature`-filer fra bunnen (alltid som
  `@draft`), fyller ut skjelett-filer fra `fs-scope`, ELLER fasiliterer en valideringsgjennomgang av kravene i en
  eksisterende mappe. Bare krav som valideres i gjennomgangen, eller som brukeren
  eksplisitt sier er klare, får `@planned` på `Egenskap:`. Resten forblir
  `@draft` med åpne spørsmål dokumentert. Leser scope-fila når kravet har
  `@scope-<slug>`, og foreslår `fs-scope` når et krav ikke passer i scopet.
  Fjerner også krav: ikke-leverte krav slettes, leverte krav (`@implemented`)
  tagges `@deprecated` til `fs-verify` har vist at koden er borte. Endrer
  leverte krav ("endre krav", "oppdatere levert krav", "ny versjon av regel"):
  egenskapen blir stående `@implemented`, den nye delen legges ved siden av som
  `@draft` og får `@planned` når den er validert, og delen den erstatter får
  `@deprecated`. Skriver flyter i `krav/_Flyter` ("skriv en flyt", "flyt for",
  "hva skjer fra … til …"): et løp på tvers av domener, med én `Regel:` per
  fase og `@depends-on-` til kravene fasen bygger på.
---

# Definere krav

## Hensikt

Spesifisere funksjonelle krav ved hjelp av brukerhistorier og Gherkin-scenarios (Gitt-Når-Så). Resultatet lagres som `.feature`-filer i `krav/`-mappen, strukturert etter **Domene → Sub-domene → Kapabilitet**.

**Alle nye krav får `@draft`** og blir stående slik til de er validert.

Hvilke krav et initiativ har, og hvilken oppgave de hører til, bestemmes med `fs-scope` (scope-fila `tasks/<domene>/scope-<slug>.md` og taggen `@scope-<slug>`). Denne skillen skriver hvordan kravene oppfører seg, og endrer ikke scopet. Se *Utenfor scopet*.

Skillen fasiliterer derfor også **validering** av skisserte krav (modus B): Gå gjennom kravene i en mappe sammen med brukeren, lukk åpne spørsmål og konkretiser scenarioene. **`@planned` settes bare på krav som er validert i gjennomgangen, eller som brukeren eksplisitt sier skal ha `@planned`.** Skillen setter aldri `@planned` på eget skjønn, og aldri bare fordi innholdet «ser ferdig ut». En egenskap kan bli `@planned` selv om enkelte regler eller scenarioer bevisst står igjen som `@draft @openquestion` (se *Delvis utkast* i `krav/README.md`). Krav som mangler status regnes som ikke validert, og behandles som `@draft`.

## Forutsetninger

- Arbeidet skjer i `krav/`-mappen i dette repoet. Skillen skriver bare i `krav/`-treet, ikke i `tasks/`. Den leser kodeklonene når et levert krav endres (D1), men endrer dem ikke. Ellers sjekkes kravene mot koden i `fs-specify`.
- Konvensjoner er definert i `krav/README.md` — følg dem, den er autoritativ. Ren Gherkin-syntaks står i `references/gherkin-syntax.md`.
- Kjente persona: administrator, søker, student, saksbehandler
- **GitHub-issue er valgfritt.** Oppgir brukeren et issue når kravet opprettes, skrives det som `# GitHub: #NNNN` over tag-linja (se steg A6). Skillen oppretter, endrer, linker eller lukker ikke GitHub-issues, og kjører ikke `gh`.
- **Confluence-bakgrunn er ofte tilgjengelig** via Atlassian-MCP (`mcp__claude_ai_Atlassian_Rovo__*`). Draft-filer refererer gjerne til kilden med en kommentar som `# Krav fra Confluence: K6 ...`. Bruk MCP-en til å hente siden når brukeren oppgir en URL/ID — **ikke** søk bredt i Confluence av eget initiativ; spør først.

## Sjekk branchen (gjør dette aller først)

Før du leser eller skriver krav: sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md). Er den bak, spør du før du henter. I Claude-panelet i FS Kravforvaltning (uten Bash) hoppes sjekken over. Kommer skrivingen lenge etter oppstarten (f.eks. retaggingen i B5), sjekk på nytt rett før.

## Arbeidsmoduser

Skillen har fem moduser. Velg modus basert på hva brukeren ber om. Hvis det er uklart, spør.

| Modus | Når | Følg |
|-------|-----|------|
| **A. Nytt kravarbeid** | Bruker skal lage nye krav, eller fylle ut en skjelett-fil fra `fs-scope` | *Prosess: Nytt kravarbeid* (steg A1–A7) |
| **B. Fullføre krav i mappe** | Bruker peker på en eksisterende mappe og vil gå gjennom og validere kravene, slik at de validerte kan få `@planned`. Trigge-ord: "fullføre krav i [mappe]", "få kravene klare", "tagge med planned", "ferdigstille iterasjon N" | *Prosess: Fullføre krav i mappe* (steg B1–B6) |
| **C. Fjerne krav** | Bruker vil slette et krav, eller en regel/et scenario i et krav. Trigge-ord: "fjerne krav", "slette krav", "avvikle", "dette skal ikke lenger gjelde" | *Prosess: Fjerne krav* (steg C1–C4) |
| **D. Endre levert krav** | Bruker vil endre eller utvide et krav som er `@implemented`. Trigge-ord: "endre krav", "oppdatere levert krav", "ny versjon av regel", "kravet skal nå være" | *Prosess: Endre levert krav* (steg D1–D4) |
| **E. Skrive flyt** | Bruker vil beskrive et løp på tvers av domener. Trigge-ord: "skriv en flyt", "flyt for", "hva skjer fra … til …", "pilot for flyt" | *Prosess: Skrive flyt* (steg E1–E5) |

Modusene kan kjedes: fullføring avdekker ofte behov for nye scenarios eller nye features, som da følger modus A videre.

## Prosess: Nytt kravarbeid

### A1. Forstå initiativet

**Scope først.** Har kravet `@scope-<slug>` (eller skal det skrives i et scope brukeren nevner), les `tasks/*/scope-<slug>.md`: mål, ikke-mål, kilder, og raden kravet står i (oppgave, MoSCoW, skisse, issue). Hent kildene som står der, når de trengs. Det som står i scopet, spørres det ikke om på nytt. Er initiativet ikke avgrenset ennå, og brukeren vil dele det i oppgaver, foreslå `fs-scope` først.

Hvis brukeren allerede har jobbet med et initiativ i denne samtalen, bruk det uten å spørre på nytt. Ellers, spør brukeren om det scopet ikke svarer på:

- Hva heter initiativet / hvilken funksjonalitet skal spesifiseres?
- Hvem er aktørene?
- Hvilket domene hører dette til? (se `krav/` for eksisterende domener)
- **Bygger kravet på kode, schema, skisser eller FS-klienten** (også når det står i scopet)? Følg da *Krav fra kode, skisser eller FS-klienten* i `krav/README.md`.
- **Hører kravet til et GitHub-issue?** (f.eks. `#1234`). Valgfritt: svarer brukeren "nei" eller "hopp over", skrives fila uten `# GitHub:`-linje.
- **Finnes det bakgrunnsinformasjon i Confluence** som skal legges til grunn? (side-URL, tiny-link eller side-ID — f.eks. en kravspesifikasjon, en workshop-oppsummering, eller en K-nummerert kravliste). Hvis ja, hent innholdet via `mcp__claude_ai_Atlassian_Rovo__getConfluencePage` før du begynner å skrive scenarios. Bruker sier "nei" eller "hopp over" → fortsett uten.

### A2. Plasser kravet riktig i mappestrukturen

**Finnes skjelett-fila** (fra `fs-scope`: `@draft`, brukerhistorie og `Regel:`-titler uten scenarioer), fyll den ut der den ligger. Plasseringen, Feature-ID-en, MoSCoW og scope-taggen er bestemt. Gå til A3.

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

**Flyter:** beskriver brukeren et løp på tvers av domener, og ikke ett krav, er det en flyt. Den ligger i `krav/_Flyter/<NN Prosess>/`, ikke på kapabilitetsnivå. Gå til modus E.

### A3. Les eksisterende kontekst

Før du skriver nye scenarios, les:

- **Relaterte feature-filer** i samme kapabilitet/sub-domene for å unngå duplisering og matche stil
- **Krav i andre mapper som kravet bygger på eller henviser til**, og kravene som refererer til dem (`Grep "@(depends-on|ref)-<ID>"` i `krav/`). De blir referanser i det nye kravet, se *Referanser mellom krav* under
- **Eksisterende step-definisjoner** i `tester/steps/**/*.ts` for å se hvilke Gherkin-fraser som allerede er implementert — gjenbruk dem når det passer
- **Domenets begrepsliste** (se *Terminologi* i `krav/README.md`), hvis den finnes

Presenter kort hva som finnes fra før, og avklar om nytt krav skal legges i ny fil eller i eksisterende.

### A4. Bruk eventuell Example Mapping-output

Hvis teamet har kjørt en Example Mapping-workshop:

- Blå kort (regler) → `Regel:`-seksjoner i Gherkin
- Grønne kort (eksempler) → `Scenario:` under hver `Regel`
- Røde kort (spørsmål) → `# ÅPNE SPØRSMÅL:`-kommentarer

Spør brukeren om de har slik output tilgjengelig. Hvis ikke, gå videre.

### A5. Definer kravet iterativt

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

### A6. Bekreft og skriv feature-filen

Bekreft samlet innhold med brukeren før du skriver til disk.

Feature-ID settes som tag på filen: `@DOM-SUB-KAP-NNN` (3-bokstavs forkortelser for domene/sub-domene/kapabilitet, utledet fra mappenavn, pluss neste ledige løpenummer). Tag-linja er alltid `@DOM-SUB-KAP-NNN @<moscow> @draft`. Skrives kravet i et scope, får det scope-taggen sist: `@DOM-SUB-KAP-NNN @<moscow> @draft @scope-<slug>`. I en skjelett-fil står tag-linja fra før, og endres ikke, bortsett fra at referanser kan legges til sist. Referanser til andre krav (`@depends-on-<ID>`, `@ref-<ID>`) står på delen de gjelder, se *Referanser mellom krav* under.

Når du legger til en ny `Regel:` eller et nytt scenario i en fil som allerede er `@planned`/`@in-progress`, tagges den nye delen `@draft @openquestion` til den er validert, med mindre brukeren eksplisitt sier at den er klar. Er fila `@implemented`, følg modus D (*Endre levert krav*): leverte deler endres ikke på stedet.

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

**`# GitHub:`-linja er valgfri.** Den skrives bare når brukeren har oppgitt et issue, som en Gherkin-kommentar `# GitHub: #NNNN` på **linjen rett over tag-linjen** for `Egenskap`-en (mellom `# language: no` og `@DOM-SUB-KAP-NNN`-taggen). Referansen tilhører egenskapen konseptuelt, men skrives utenfor `Egenskap`-blokken slik at den er synlig uten å scrolle gjennom brukerhistorien.

Dekker en egenskap flere issues, list alle: `# GitHub: #1234, #1250`. En eksisterende `# GitHub:`-linje blir stående når fila endres, flyttes eller omdøpes.

Får et krav ny Feature-ID, oppdater referansene til den gamle ID-en i samme endring: `Grep "@(depends-on|ref)-<gammel ID>"` i `krav/`, og bytt til den nye. En fil som bare flyttes eller omdøpes, beholder ID-en, så referansene står urørt.

Hvis en fil noen gang inneholder flere `Egenskap:`-blokker, plasseres én `# GitHub:`-kommentar over hver sine tag-linje — slik at referansen alltid er direkte knyttet til egenskapen like under.

Filnavn: `snake_case.feature` med verb + substantiv, f.eks. `opprette_organisasjon.feature`, `se_søknad.feature`.

### A7. Oppsummer

Vis brukeren:

- Sti til opprettet/oppdatert `.feature`-fil (som klikkbar markdown-lenke)
- Feature-ID som ble tildelt
- GitHub-issue (`#NNNN`), hvis brukeren oppga et
- Antall scenarios og prioritet
- Åpne spørsmål som gjenstår
- At kravet står som `@draft`
- Neste steg: valider kravet gjennom modus B (*Fullføre krav i mappe*). Først når det er validert og har fått `@planned`, kan `fs-specify` hente det inn i en oppgavemappe og `lage-steps` implementere step-definitions

### Utenfor scopet

Skriver du et nytt krav som ikke står i scopet, eller hører kravet til en annen oppgave enn den det står i, skriv det som før, men si fra, og foreslå `fs-scope` (modus B) for å oppdatere scopet. Endre ikke scope-fila, `oppgave.md` eller `@scope-*`-taggene selv, bortsett fra å sette scope-taggen på et nytt krav som skrives i et scope (A6).

## Prosess: Fullføre krav i mappe

Bruk når brukeren peker på en mappe med eksisterende `.feature`-filer som skal ferdigstilles.

**Mål:** Fasilitere en gjennomgang der kravene i mappen valideres sammen med brukeren. Målet er *validerte krav*, ikke flest mulig `@planned`-tagger. Et krav som ikke er validert, forblir `@draft` — det er et fullt gyldig utfall av gjennomgangen.

**`@planned` settes bare når ett av disse er oppfylt:**

1. Kravet er gått gjennom i denne gjennomgangen, åpne spørsmål i hovedflyten er lukket, og brukeren har bekreftet at kravet er validert.
2. Brukeren sier eksplisitt at et bestemt krav skal ha `@planned` (f.eks. fordi det allerede er validert i et møte eller en workshop). Gjengi da hvilket krav det gjelder, og sett taggen uten å gå gjennom innholdet.

Skillen foreslår aldri `@planned` ut fra egen vurdering av at innholdet «ser ferdig ut».

| Startstatus | Håndtering |
|-------------|------------|
| `@draft` | Gå gjennom kravet (B5). Validert → bytt `@draft` med `@planned` på `Egenskap:`. Deler som bevisst skal vente kan stå igjen som `@draft @openquestion`. Ikke validert → behold `@draft` og dokumenter hva som mangler. |
| Ingen status — gjelder eldre filer | Regnes som ikke validert. Legg til `@draft` og ta kravet med i gjennomgangen (B4). |
| Allerede `@planned` / `@in-progress` / `@implemented` / `@deprecated` | Ingen endring. Unntak: `@draft`-deler under en `@implemented` egenskap valideres som i modus D (steg D3). |

Bakgrunnen: `@draft` markerer at *kravteksten* er utkast (kravstatus), og `@planned` markerer at *kravet er klart til implementasjon* (implementasjonsstatus). Når et draft er ferdigstilt, fjernes `@draft` og erstattes av `@planned` på `Egenskap:` — vi beholder ikke begge samtidig på samme linje, og vi lar ikke krav stå uten status. `@draft` kan likevel stå igjen på enkelt-`Regel:`/`Scenario:` under en `@planned` egenskap når det er en bevisst beslutning. Se `krav/README.md` (*Kravstatus* og *Delvis utkast*) for den autoritative definisjonen.

**Denne skillen eier overgangene `@draft` → `@planned` og `@implemented` → `@deprecated` (modus C), på egenskaper og, når et levert krav endres, på deler (modus D).** Resten av implementasjonsaksen (`@in-progress`, `@implemented`, og slettingen av `@deprecated`-krav) er beskrevet i `krav/README.md` og settes ikke her. Et krav du finner som `@in-progress` er plukket inn i en oppgave, og skal stå urørt.

### Interaksjonsprinsipp: ett spørsmål om gangen

**Ikke list opp alle åpne spørsmål i én stor blokk.** Still **ett spørsmål** og vent på svar før du går til neste. Dette er et ufravikelig prinsipp for modus B — brukeren har eksplisitt bedt om det, og en lang spørsmålsliste fører til at mange spørsmål blir hoppet over eller misforstått.

Praktiske regler:

- **Én fil om gangen, ett spørsmål om gangen.** Ikke bland spørsmål om flere filer i samme runde.
- **Tilby flervalg** (a/b/c) med konkrete alternativer når det er naturlig. Brukeren svarer raskere på "a" eller "b" enn på et åpent spørsmål, og det reduserer feiltolking.
- **Bruk `TodoWrite`** for å holde oversikt over gjenværende filer og spørsmål. Oppdater fortløpende slik at brukeren ser progresjon.
- **Når du har nok informasjon til å foreslå en konkret fil-endring:** presenter forslaget (gjerne som diff eller full kodeblokk) og spør om brukeren vil **(a) skrive** eller **(b) justere**. Én beslutning om gangen.
- **Tverrgående avklaringer først.** Hvis flere filer trenger samme avklaring (f.eks. aktør, terminologi), ta disse som separate overordnede spørsmål før du går ned i hver fil. Fortsatt ett spørsmål om gangen.
- **Ikke dump oppsummeringer av alt som er uklart.** Pek på én ting, få svar, gå videre.

### B1. Identifiser mappen

Spør brukeren hvilken mappe som skal gjennomgås (eller bruk den de allerede har nevnt). Bekreft absolutt sti før du begynner. Alle `.feature`-filer i mappen og dens undermapper inngår i gjennomgangen.

### B2. Spør om Confluence-bakgrunn

Før du begynner å avklare draftene, still dette spørsmålet til brukeren:

> *"Finnes det en Confluence-side med bakgrunnsinformasjon jeg skal legge til grunn når jeg fyller ut draftene? (side-URL, tiny-link eller side-ID). Hvis ikke: svar 'nei' eller 'hopp over'."*

Mange draft-filer inneholder allerede en peker som `# Krav fra Confluence: K6 ...`. Disse peker vanligvis til en kilde brukeren kjenner, men skillen skal **ikke søke i Confluence av eget initiativ** — vent på at brukeren oppgir URL/ID eller bekrefter at det ikke er relevant.

Når brukeren oppgir en kilde:
- Hent siden med `mcp__claude_ai_Atlassian_Rovo__getConfluencePage` (bruk `contentFormat: "markdown"` hvis du bare trenger tekst).
- Les igjennom og noter hvilke K-nummer / seksjoner som korresponderer med hvilke filer i mappen.
- Bruk Confluence-innholdet aktivt i B5 når du foreslår scenario-formuleringer og avklarer åpne spørsmål — men **ikke** finn på detaljer som ikke står i kilden; det skal fortsatt avklares med brukeren.

Hvis brukeren svarer "nei" / "hopp over": fortsett uten, og støtt deg på eksisterende `.feature`-filer, step-definisjoner og brukerens svar i B5.

### B3. Kartlegg status

Les hver `.feature`-fil og klassifiser hvert krav basert på tags på `Egenskap:`-nivå:

| Kategori | Tag-kombinasjon | Tiltak |
|----------|-----------------|--------|
| **Draft** | `@draft` finnes | B5: gjennomgang. `@planned` bare hvis validert |
| **Uten status** | Verken `@draft` eller `@planned` (heller ikke `@in-progress`/`@implemented`) | B4: legg til `@draft`, deretter gjennomgang i B5 |
| **Avviklet** | `@deprecated` finnes | Ingen endring — rapporter som avviklet. Slettes av `fs-verify` når koden er borte |
| **Allerede klar** | `@planned`, `@in-progress` eller `@implemented` finnes, og `@draft` finnes ikke | Ingen endring — rapporter som klar. Har fila `@draft`-deler på `Regel:`/`Scenario:`, list dem og spør om noen skal avklares nå (B5, trinn 5–6 for den delen). Under `@implemented`: bruk modus D, steg D3 (delen får `@planned`, og delen den erstatter, `@deprecated`) |

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

### B4. Håndter krav uten status

Et krav uten status er ikke validert. Legg `@draft` på `Egenskap:`-tag-linjen (typisk etter MoSCoW-tag: `@must @draft`) og ta kravet med i B5-køen.

Unntak: Har brukeren eksplisitt sagt at et bestemt krav skal ha `@planned`, settes `@planned` direkte (jf. *Mål* over). Ikke spør brukeren om et krav «er klart» for å åpne for denne snarveien — den skal komme fra brukeren.

### B5. Gjennomgå `@draft`-krav og valider

Ta ett draft-krav om gangen. For hvert:

1. **Les hele filen grundig** — inkludert `# ÅPNE SPØRSMÅL:`, `# TODO:`-linjer, kommentarer som peker til Confluence/eksterne kilder, og alle scenarios.
2. **Les relatert kontekst:**
   - Andre `.feature`-filer i samme kapabilitet for stil og gjenbruk
   - Eksisterende step-definisjoner i `tester/steps/**/*.ts` — gjenbruk formuleringer som allerede er implementert
   - Confluence-siden fra B2 hvis brukeren oppga en — slå opp K-nummeret (eller tilsvarende seksjonsreferanse) som nevnes i filens `# Krav fra Confluence:`-kommentar, og bruk innholdet som grunnlag for forslag
3. **Oppsummer for brukeren** hva som mangler eller er uavklart:
   - Åpne spørsmål som ikke er besvart
   - Skisse-pregede scenarios uten konkrete data / forventet resultat
   - Uklare feltlister, rolle-navn, feilmeldinger, forretningsregler
   - Avvik fra *Gode scenarioer* og *Terminologi* i `krav/README.md`
   - Manglende `Bakgrunn:` der det ville redusert duplisering
   - Referanser: `@depends-on-` og `@ref-` til ID-er som ikke finnes, og referanser som står i fritekst i kommentarene (se *Referanser mellom krav* under). Spør om de skal bli tagger
   - For en flyt (`krav/_Flyter/`): faser uten `@depends-on-` og uten åpent spørsmål, og scenarioer som gjentar en regel fra kravet de bygger på (se *Prosess: Skrive flyt*). En flyt får `@planned` bare når hver fase har `@depends-on-` eller et åpent spørsmål om kravet som mangler
4. **Still konkrete spørsmål — ett om gangen.** Jf. interaksjonsprinsippet: ikke dump hele spørsmålslisten i én blokk. Still ett spørsmål, gi (a)/(b)/(c)-alternativer der det er naturlig, og vent på svar før du går til neste. Hovedregel: *aldri finn på valideringsregler, feilmeldinger eller forretningslogikk — spør brukeren*. Marker forslag tydelig som "forslag" hvis du presenterer dem for reaksjon.
5. **Oppdater filen** basert på svarene: revider og konkretiser scenarios, legg til manglende scenarios, fjern besvarte `# ÅPNE SPØRSMÅL:`-kommentarer, stram opp språk, rett terminologi, og sørg for at Gherkin-konvensjonene følges (Scenariomal + Eksempler, deklarativ stil, én atferd per scenario).
6. **Be brukeren om validering.** Når åpne spørsmål i hovedflyten er besvart og scenariene er konkrete nok til implementasjon, spør: *"Er [tittel] validert slik det står nå? (a) Ja → `@planned`, (b) Nei → beholder `@draft`."* Bytt `@draft` med `@planned` på `Egenskap:`-tag-linjen bare ved (a). Ikke behold begge. Eksempel: `@BRU-APP-API-001 @must @draft` → `@BRU-APP-API-001 @must @planned`.

   **Delvis utkast:** Gjenstår det spørsmål som bare gjelder en avgrenset `Regel:` eller et enkelt scenario, spør brukeren: *"(a) Vent med hele kravet — behold `@draft` på egenskapen, (b) Sett egenskapen til `@planned` og la [regel/scenario] stå som `@draft @openquestion`."* Velges (b): flytt `@draft` fra `Egenskap:` ned til den aktuelle delen sammen med `@openquestion`, og sørg for at `# ÅPNE SPØRSMÅL:` under delen beskriver hva som mangler. Velg aldri (b) på egen hånd — det skal være en bevisst beslutning.
7. **Bekreft endringen med brukeren** før du skriver til disk hvis scenarios endres vesentlig. Mindre opprettinger (terminologi, formatering) kan skrives direkte.

**Hvis et draft ikke lar seg fullføre i denne sesjonen** (venter på ekstern input, produktavklaring, design-beslutning) og delvis utkast ikke er aktuelt: behold `@draft`, dokumenter gjenværende usikkerhet som oppdatert `# ÅPNE SPØRSMÅL:`, og rapporter tydelig i B6 at kravet fortsatt er draft.

### B6. Oppsummer arbeidet

Når hele mappen er gjennomgått, rapportér til brukeren:

- Antall krav som nå er tagget `@planned` (fordelt på "validert i gjennomgangen" vs. "satt etter eksplisitt beskjed fra bruker")
- Antall krav som fortsatt er `@draft` (inkludert eldre krav uten status som fikk `@draft`), med grunn (venter på ekstern avklaring, produktinput, etc.)
- `@planned`-krav med `@draft`-deler: hvilke regler/scenarioer som venter, og hvorfor
- Antall krav som var `@planned`/`@in-progress`/`@implemented`/`@deprecated` fra før og ikke ble endret
- Samlet liste over gjenstående `# ÅPNE SPØRSMÅL:` på tvers av filer — som en enkelt punktliste brukeren kan ta med inn i neste avklaringsrunde
- Forslag til neste steg: `lage-steps` for `@planned`-krav, eller `fs-specify` for å hente dem inn i en oppgavemappe

## Prosess: Fjerne krav

Et krav som er levert, slettes ikke med en gang. Koden finnes fortsatt, og kravet er påminnelsen om at den må bort. Se *Avvikling* i `krav/README.md` for den autoritative regelen.

### C1. Finn kravet

Finn fila, og eventuelt regelen eller scenarioet, som skal bort. Er det uklart, spør. Les `Egenskap:`-tag-linja, og taggene på delen.

### C2. Velg håndtering ut fra status

| Hva skal bort | Status på `Egenskap:` | Håndtering |
|---------------|------------------------|------------|
| Hele kravet | `@draft`, `@planned` eller ingen status | Ikke levert. Slett fila. |
| Hele kravet | `@implemented` | Bytt `@implemented` med `@deprecated` på `Egenskap:`-tag-linja. Fjern eventuelle `@deprecated` på deler (de er dekket av egenskapen). |
| Hele kravet | `@in-progress` | Har kravet `@implemented`-deler, er det delvis levert (*Delvis levert* i `krav/README.md`): bytt `@in-progress` med `@deprecated` på `Egenskap:`, og fjern `@implemented` og `@deprecated` fra delene. Ellers: spør om noe av kravet allerede er levert (fra en tidligere iterasjon). Ja → som `@implemented`. Nei → slett fila, og si fra at oppgaven som har hentet kravet inn, må oppdateres. |
| Hele kravet | `@deprecated` | Allerede avviklet. Ingen endring. |
| En regel/et scenario | `@draft` eller `@planned` | Ikke levert. Slett blokken (med tagger og kommentarer). |
| En regel/et scenario | `@implemented` eller `@in-progress` | Er delen `@draft`, `@planned` eller `@in-progress`, er den ikke levert: slett blokken (erstatter den en `@deprecated`-del, spør om den gamle delen skal gjelde igjen, og fjern i så fall `@deprecated` og ` (avvikles)` i tittelen fra den). Er delen `@implemented` (delvis levert, under `@in-progress`), er den levert: bytt `@implemented` med `@deprecated`. Er delen uten status under `@in-progress`, spør om den er levert fra en tidligere iterasjon (ja → `@deprecated`, nei → slett blokken). Ellers: legg `@deprecated` på `Regel:`-/`Scenario:`-linja. `Egenskap:`-taggen endres ikke. |

**Mekanikk:** én `Edit` på tag-linja. Bare statustaggen byttes; feature-ID, MoSCoW og andre tagger står urørt: `@BRU-APP-API-001 @must @implemented` → `@BRU-APP-API-001 @must @deprecated`. Mangler delen en tag-linje, legg en ny linje med `@deprecated` rett over `Regel:`/`Scenario:`, med samme innrykk.

### C3. Bekreft før du sletter

Finn referansene til kravet: `Grep "@(depends-on|ref)-<ID>"` i `krav/`. Fjernes hele kravet, gjelder alle. Fjernes en del, gjelder de som handler om delen, ut fra kommentaren under taggen. Vis brukeren hva som skal skje (fil, del, `@deprecated` eller sletting), med kravene som refererer til det, og vent på bekreftelse. Krav med `@depends-on-` må kanskje endres selv: spør. Slettes kravet, fjernes referansene til det i samme endring. Får det `@deprecated`, blir referansene stående til `fs-verify` sletter kravet. Slett aldri en fil eller blokk uten bekreftelse. Hele filer slettes med `rm "<sti>"`. Kjører skillen uten Bash (for eksempel i Claude-panelet i FS Kravforvaltning), kan den ikke slette filer: si da hvilken fil brukeren må slette selv.

### C4. Oppsummer

- Hvilke krav/deler som ble slettet, og hvilke som fikk `@deprecated`
- Referanser til kravet som ble fjernet, og krav med `@depends-on-` som må følges opp
- Step definitions i `tester/steps/` som hørte til slettede scenarioer (listes, slettes ikke)
- Neste steg for `@deprecated`: fjern koden, og kjør `fs-verify` for å slette kravet når koden er borte

## Prosess: Endre levert krav

Et levert krav endres ikke på stedet. Den leverte teksten beskriver koden som finnes, og den nye teksten beskriver det som skal bygges. Begge står i fila til koden er endret. Se *Endring av levert krav* i `krav/README.md` for den autoritative regelen.

Endringen spores på delen, ikke på egenskapen:

- Egenskapen blir stående som `@implemented`.
- Den nye eller endrede delen går `@draft` →(validering)→ `@planned`. Deretter tar `fs-specify` / `fs-specify-delta` og `fs-verify` over.
- Delen den erstatter, får `@deprecated` når den nye blir `@planned`.

### D1. Finn kravet og delen

Finn fila og regelen eller scenarioet som skal endres. Er det uklart, spør. Les `Egenskap:`-tag-linja:

| Status på `Egenskap:` | Håndtering |
|------------------------|------------|
| `@implemented` | Fortsett med D2. |
| `@draft` eller `@planned` | Ingenting er levert. Endre delen på stedet (modus A/B). |
| `@in-progress` | Er delen `@implemented` (delvis levert, *Delvis levert* i `krav/README.md`), er den levert: legg den nye delen ved siden av som `@draft` (D2). Når den er validert, fjernes `@draft`, og den gamle delen får `@deprecated` i stedet for `@implemented`. Er delen uten status, spør om den allerede er levert (fra en tidligere iterasjon). Nei → endre på stedet, og si fra at oppgaven som har hentet kravet inn, må oppdateres. Ja → som en `@implemented` del. |
| `@deprecated` | Kravet er avviklet. Skal det gjelde igjen, er det et nytt krav (modus A). |

Hvilke deler endringen gjelder, avklares med brukeren, én om gangen: endres, fjernes eller legges til?

Les så taggene på delen som endres. Er den `@draft`, `@planned` eller `@in-progress`, er den ikke levert. Endre den på stedet, uten ny blokk og uten `@deprecated`, og behold statustaggen. En `@draft`-del valideres som i D3, og en `@planned`-del som i modus B. Er delen `@in-progress`, si fra at spesifikasjonen i oppgaven som har hentet den inn, må oppdateres med endringen. Ny blokk (D2) lages bare for deler som er levert, det vil si deler uten egen statustag.

Finn kravene som bygger på kravet: `Grep "@depends-on-<ID>"` i `krav/`. List dem for brukeren, med delen taggen står på, og spør om noen av dem må endres sammen med kravet.

Finn koden for den leverte delen i kodeklonene (fs-admin, fs-plattform), og vis `fil:linje`. Bruk klonene som står i systemprompten, og spør om stien bare hvis de mangler. Sjekk branchen i hver klone før du leter ([`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md)). Har brukeren ingen klone, gå videre: `fs-specify` sjekker kravet mot koden før det blir `@in-progress`. Den nye delen skrives (D2) ut fra hva koden gjør i dag, ikke bare ut fra den gamle teksten. Følg *Krav fra kode, skisser eller FS-klienten* i `krav/README.md`: spør om det koden gjør, er ønsket atferd. Gjør koden noe annet enn den leverte teksten sier, spør før D2: *«Den leverte delen sier X, koden gjør Y. Hva skal den nye delen bygge på?»*

### D2. Skriv den nye delen som `@draft`

- **Endring:** legg den nye versjonen som en egen blokk rett etter delen den erstatter, tagget `@draft` (og `@openquestion` med `# ÅPNE SPØRSMÅL:` når noe er uklart). Den nye blokken får den tittelen kravet skal ha, som regel den samme som den gamle. Ikke legg inn detaljer om hva som er endret for å skille dem: tittelen blir stående når den gamle delen er slettet. Blir titlene like, legg ` (avvikles)` bak tittelen på den gamle blokken (`Scenario: Se brukerens roller (avvikles)`), så titlene er unike (playwright-bdd lager én test per scenario). Ellers står den gamle blokken urørt. Forkaster brukeren den nye delen, fjern ` (avvikles)` igjen.
- **Tillegg:** legg den nye blokken der den hører hjemme, tagget `@draft`. Det finnes ingen gammel del.
- **Fjerning:** følg modus C (steg C2): den leverte delen får `@deprecated`.

Endres hele kravet, gjelder det samme for hver regel som endres. Uendrede regler står urørt. Er kravet så endret at det ikke lenger henger sammen, foreslå et nytt krav (modus A), og at det gamle avvikles (modus C).

Samme regler som i modus A: ikke finn på forretningslogikk, spør. Bekreft innholdet med brukeren før du skriver til disk.

### D3. Valider

Gå gjennom den nye delen som i B5 (ett spørsmål om gangen). Når hovedflyten er avklart, spør: *"Er [tittel] validert slik det står nå? (a) Ja → `@planned` (og [gammel del] får `@deprecated`), (b) Nei → beholder `@draft`."* Ta med parentesen bare når delen erstatter en gammel del.

Ved (a), i samme endring:

- Den nye delen: bytt `@draft` med `@planned` på `Regel:`-/`Scenario:`-linja, og fjern `@openquestion` og besvarte `# ÅPNE SPØRSMÅL:`.
- Delen den erstatter (ikke ved et rent tillegg): legg `@deprecated` på `Regel:`-/`Scenario:`-linja (ny linje med samme innrykk hvis den mangler tagger). ` (avvikles)` i tittelen blir stående, og tittelen på den nye delen endres ikke.
- `Egenskap:`-tag-linja endres ikke.

En del har høyst én statustag. `@planned` står aldri sammen med `@draft` eller `@deprecated`.

Setter brukeren eksplisitt at delen skal ha `@planned`, gjelder det samme unntaket som i B4.

### D4. Oppsummer

- Hvilke deler som er `@planned`, og hvilke som fortsatt er `@draft` (med åpne spørsmål)
- Hvilke deler som fikk `@deprecated`, og hvilken ny del de erstattes av
- Koden for den leverte delen (`fil:linje`), eller at den ikke ble sjekket fordi brukeren ikke hadde kodeklonene
- Kravene med `@depends-on-` til kravet, og om de må endres
- Step definitions i `tester/steps/` som hører til `@deprecated`-delene (listes, slettes ikke)
- Neste steg: `fs-specify` / `fs-specify-delta` henter `@planned`-delene inn i en oppgave (`@planned` → `@in-progress` på delen), og `fs-verify` fjerner `@in-progress` når koden er på plass og sletter `@deprecated`-delene når den gamle koden er borte

## Prosess: Skrive flyt

En flyt beskriver et løp på tvers av domener, fase for fase. Den autoritative regelen står i *Flyter* i `krav/README.md`. Flyten gjentar ikke reglene i kravene: den sier hvilke krav hver fase bygger på, og beskriver overleveringene mellom dem.

Still spørsmålene ett om gangen, som i modus B.

### E1. Sjekk terskelen

Gå gjennom de tre kriteriene i *Hva er en flyt?* med brukeren:

1. Går løpet over minst to sub-domener eller domener?
2. Har det en overlevering: en tilstand som én aktør eller ett system lager, og en annen bruker?
3. Svarer det på et spørsmål noen faktisk stiller: «hva skjer fra … til …?»

Faller kandidaten på terskelen, skriv ingen flyt. Foreslå `@depends-on-` eller `@ref-` mellom kravene i stedet (*Referanser mellom krav*). Er løpet ett krav uten overlevering inni seg, er det en fase i en annen flyt, ikke en egen flyt.

### E2. Plassering og ID

- **Prosessen:** finn prosessmappa i `krav/_Flyter/` (`Glob "krav/_Flyter/*/"`). Finnes ikke prosessen, foreslå navn og nummer (fra `10`, i livsløpsrekkefølge), og lag mappa bare når brukeren har bekreftet.
- **Filnavnet:** snake_case, etter løpet: `saksbehandlertildeling.feature`, `fra_søknad_til_studieplass.feature`.
- **ID:** `@FLY-<prosess>-<flyt>-NNN`, med tre bokstaver for prosessen og flyten (`@FLY-OPT-SAK-001` for Opptaksløpet → Saksbehandlertildeling). Sjekk at ID-en er ledig: `Grep "@FLY-<prosess>-<flyt>-"` i `krav/_Flyter/`.
- **Oversiktsflyten** for prosessen (`<prosess>.feature`, f.eks. `opptaksløpet.feature`) har én `Regel:` per fase i hele løpet. Finnes den ikke, lag den som skjelett (`@draft`, beskrivelse og `Regel:`-titler uten scenarioer), med ID-en `@FLY-<prosess>-<prosess>-001`. Legg til `@depends-on-<ID til den nye flyten>` på fasen flyten hører til, og lag fasen hvis den mangler.

### E3. Fasene

Finn fasene sammen med brukeren, i den rekkefølgen løpet går. Hver fase blir én `Regel:`, med en tittel som sier hva som skjer i fasen («Søknadsalternativene fordeles når søknaden sendes»).

For hver fase:

1. **Finn kravene** fasen går gjennom: søk i `krav/` etter begrepene, og les kravene. Les statusen. Les ikke bare tittelen: kravet skal faktisk beskrive det som skjer i fasen.
2. **Sett `@depends-on-<ID>`** på `Regel:`-linja for hvert krav (*Referanser mellom krav*). En fase kan bygge på en annen flyt i samme prosess med `@depends-on-FLY-…`. Bygger fasen bare på noen regler eller scenarioer i et stort krav, sett ankeret `@ref-<flytens ID>` på de delene i kravet (*Anker* i `krav/README.md`, og *Referanser mellom krav* under).
3. **Fase uten krav:** finnes ikke kravet, skriv fasen uten `@depends-on-`, tagg den `@openquestion`, og skriv en `# ÅPNE SPØRSMÅL:` som sier hvilket krav som mangler, og hvor det kan høre hjemme. Noter det til oppsummeringen. Kravet skrives med `fs-scope` (når det hører til et initiativ) eller modus A.
4. **Overlapp:** beskriver to eller flere krav den samme regelen, si fra. Spør hvilket krav som skal eie regelen. Ryddingen gjøres i kravene (modus B for `@draft`/`@planned`, modus D for leverte krav), ikke i flyten.

### E4. Scenarioene

- Ett eller få scenarioer per fase, deklarative og tynne. De beskriver overleveringen, ikke reglene.
- Det som skjedde i en tidligere fase, står som en tilstand i `Gitt`: `Gitt søkeren har tilbudsgaranti fra tidligopptaket`. Scenarioer kaller ikke andre scenarioer.
- Det `Så` sier, er det neste fase eller neste aktør bruker: `Så er søkeren med når tidligopptaket gjennomføres`.
- Gjenta ikke valideringsregler, feilmeldinger eller felter fra kravene. Trenger leseren dem, står de i kravet `@depends-on-` peker på.
- Gherkin har ikke løkker. En runde fram og tilbake (søkeren dokumenterer en mangel, saksbehandleren sjekker den ut) blir ett scenario for runden, og ett scenario per annet utfall.
- Bruk samme stegformuleringer som kravene der det går. Da gir de én felles step definition (`Grep` i `tester/steps/` og i kravene).
- **Kjente brudd** i løpet (f.eks. en Jira-sak der overleveringen ikke virker) står i en kommentar under beskrivelsen: `# Kjent brudd: STEK-263, …`.

### E5. Skriv fila og oppsummer

Fila følger malen i *Flyter* i `krav/README.md`: `# language: no`, tag-linja `@FLY-<prosess>-<flyt>-NNN @<moscow> @draft @e2e` (og `@scope-<slug>` hvis flyten hører til et scope), `Egenskap:` med en beskrivelse av løpet fra start til slutt, og fasene. En flyt har ingen brukerhistorie (Som / ønsker / slik at), fordi den går over flere aktører. Vis fila før du skriver den.

Oppsummer:

- Stien og ID-en, og fasen i oversiktsflyten
- **Fremdriften:** hver fase med kravene og statusen deres. En fase er levert når delen den bygger på, er levert: delene med ankeret, ellers regelen i «…», ellers hele kravet (*Flyter* i `krav/README.md`)
- Faser uten krav, med forslag til `fs-scope` eller modus A
- Overlapp som ble funnet, og kjente brudd
- Neste steg: valider flyten med modus B (`@draft` → `@planned`). Når kravene er levert, verifiserer `fs-verify` flyten (overleveringene i koden), og setter `@implemented`. Flyten hentes ikke inn i en oppgave med `fs-specify`

## Referanser mellom krav

Et krav peker på et annet krav med `@depends-on-<Feature-ID>` eller `@ref-<Feature-ID>`. Den autoritative regelen står i *Referanser* i `krav/README.md`.

- **Testen for typen:** Må denne delen sjekkes hvis kravet det pekes på, endres? Ja gir `@depends-on-`, nei gir `@ref-`. Bruker et scenario i delen en verdi eller en innstilling fra kravet («settes i X»), er det `@depends-on-`. Er du i tvil, spør.
- **Plassering:** på delen referansen gjelder. Bygger hele kravet på et annet krav, står taggen sist på `Egenskap:`-tag-linja, etter `@scope-<slug>`. På en `Regel:` eller et `Scenario:` uten tagger lager du en ny tag-linje rett over, med samme innrykk. Har delen tagger fra før, legges referansen til sist på samme linje.
- **Kommentaren:** stien eller filnavnet tas bort når taggen sier det samme. Det som forklarer referansen, blir stående: «Etter at opptaket er publisert, kan utdanningstilbud bare trekkes.»
- **Anker:** bygger delen bare på noen regler eller scenarioer i kravet B det pekes på, får de delene i B `@ref-<ID til kravet med @depends-on->` (*Anker* i `krav/README.md`). Spør brukeren hvilke deler det gjelder, og vis endringen i B før du skriver den. Ankeret settes i samme endring som `@depends-on-`, og fjernes når `@depends-on-` fjernes. Har kravet flere deler med `@depends-on-B` som bygger på ulike deler av B, skriv regeltittelen i «…» i kommentaren under hver tag i tillegg.
- **Når en del med anker endres eller slettes** (modus B, C og D): `@ref-<ID>` på delen sier hvilke krav som bygger på den. List dem, som for `@depends-on-` på hele kravet. Flyttes eller deles delen, følger ankeret med til delen som har innholdet.
- **Blir stående som kommentar:** historikk («flyttet hit», «skilt ut fra», «Feature-ID-en var»), krav som nevnes i `# ÅPNE SPØRSMÅL:`, og henvisninger til en mappe. Peker en historikk-kommentar på en ID som nå tilhører et annet krav, settes aldri en tag.
- **Sjekk at ID-en finnes** før du setter taggen: `Grep "^\s*@(.*\s@)?<ID>\b"` i `krav/**/*.feature`. Har to filer samme ID, si fra, og sett ikke taggen før det er ryddet.
- **Statusen endres ikke** av en referanse. En referanse kan settes på en levert del uten at delen får `@draft`, siden atferden er den samme.

## Feilhåndtering

- Hvis brukeren ikke vet hvilket domene: vis strukturen fra `krav-oversikt.md` og la dem velge
- Hvis en eksisterende feature dekker samme funksjonalitet: foreslå å utvide den i stedet for ny fil
- Hvis aktør/terminologi er tvetydig: stopp og avklar før du skriver
- Hvis mappen fra modus B er tom eller ikke finnes: stopp og be brukeren bekrefte stien
- Hvis et `@draft`-krav har så mange åpne spørsmål at det ikke kan fullføres i én sesjon: rapporter tidlig, foreslå å dele opp, og la brukeren prioritere hvilke krav som skal fullføres først

## Referanser

- **`krav/README.md`** — autoritative prosjektkonvensjoner for mappestruktur, Feature-ID, tags, terminologi
- **`references/gherkin-syntax.md`** — ren Gherkin-syntaks (norske nøkkelord, blokkstruktur, tag-plassering). Sier ingenting om prosjektets konvensjoner — det eier konvensjonsfila over
- **`references/eksempel-feature.feature`** — gullstandard-eksempel på en ferdigstilt (`@planned`) `.feature`-fil med `# GitHub:` (valgfri), MoSCoW-tag, `Bakgrunn`, flere `Regel`-blokker, `Scenariomal` med `Eksempler`, `@openquestion`-tag på ett scenario, en `Regel` som bevisst står som `@draft @openquestion`, og `# ÅPNE SPØRSMÅL:`-kommentarer. Et nytt krav fra modus A ser likt ut, men med `@draft` i stedet for `@planned` og uten `@draft` på enkeltdeler
- **`krav/krav-oversikt.md`** — generert oversikt over alle eksisterende features
- **`lage-steps`** — søsken-skill i dette repoet. Implementerer step-definitions i `tester/steps/` for `@planned`-krav (ikke for `@draft`-deler)
- **`fs-specify`** / **`fs-specify-delta`** — søsken-skills i dette repoet. Henter `@planned`-krav, og `@planned`-deler i leverte krav, inn i en oppgavemappe under `tasks/`
- **`fs-verify`** — søsken-skill i dette repoet. Verifiserer leverte krav, og flytene: fremdriften fra kravene, og at overleveringene virker i koden
- **`fs-scope`** — søsken-skill i dette repoet. Avgrenser initiativet, deler det i oppgaver, lager skjelett-filene og setter `@scope-<slug>`. Kjøres før denne skillen, og på nytt når et krav ikke passer i scopet
