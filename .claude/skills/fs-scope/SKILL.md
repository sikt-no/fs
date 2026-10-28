---
name: fs-scope
description: Avgrenser et initiativ og deler det i oppgaver i dette repoet, før kravene skrives. Lager og reviderer scope-fila `tasks/<domene>/scope-<slug>.md` (mål, ikke-mål, kilder, og oppgavene med kravene hver oppgave har), oppretter oppgavene (`tasks/<domene>/<slug>/oppgave.md` fra `tasks/mal/oppgave.md`, med `Scope:`), lager skjelett-krav (`@draft`, brukerhistorie og `Regel:`-titler uten scenarioer) og setter `@scope-<slug>` på kravene. Kildene er valgfrie: GitHub-initiativet og sub-issues, Confluence og Jira, Figma-skisser (skjermene blir forslag til oppgaver og krav), markdown-filer og nettadresser. Kan kjøres på nytt når som helst, også når `fs-krav` eller `fs-specify` finner noe som ikke passer i scopet. Skriver aldri scenarioer, og setter ingen annen status enn `@draft`. Trigges av "initiativ", "sette scope", "sette omfang", "dele opp initiativet", "ny oppgave", "opprett oppgave", "hvilke krav hører til oppgaven", "flytte krav mellom oppgaver", "kravspesifikasjon", "starte kravarbeid", "lage kravdokument", "status på scopet", "fs-scope".
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, AskUserQuestion
---

# Scope

## Task

$ARGUMENTS

## Din rolle

Du svarer på spørsmålet *hva er med, og i hvilken oppgave?* Du avgrenser initiativet sammen med brukeren, deler det i oppgaver, og bestemmer hvilke krav (feature-filer) hver oppgave har. Resultatet er en plan som kan endres: scope-fila, oppgavene, skjelett-kravene og `@scope-<slug>`-taggen på kravene.

Hvordan kravene oppfører seg (regler og scenarioer), skrives med `fs-krav` etterpå. Hva som bygges nå, bestemmes med `fs-specify`. FS Kravforvaltning viser oppgavene på tavla «Oppgaver», og kolonnen utledes av taggene og spesifikasjonene. Den settes ikke for hånd.

**[`krav/README.md`](../../../krav/README.md) og [`tasks/README.md`](../../../tasks/README.md) er autoritative.** Står det noe annet der enn her, gjelder README-ene. Taggen er beskrevet under *Scope* i `krav/README.md`, og scope-fila under *Scope* i `tasks/README.md`.

Kravspesifisering er ikke lineær. Skillen kan kjøres på nytt når som helst (modus B), og `fs-krav` og `fs-specify` sender brukeren hit når de finner noe som ikke passer i scopet, i stedet for å endre scopet selv.

Skillen har tre moduser. Velg ut fra invokasjonen, eller spør med `AskUserQuestion`:

- **A — Nytt scope**
- **B — Revider scope**
- **C — Status**

## Oppstart (gjør dette FØRST)

0. **Sjekk branchen** i dette repoet mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md). Er den bak, spør før du henter. I Claude-panelet (uten Bash) hoppes sjekken over.
1. **Les `tasks/README.md`** (domenetabellen, *Scope*, *Tavla* og reglene for oppgave-rota) og *Tags* i `krav/README.md`.
2. **Finn scopet** (modus B og C). Oppga brukeren en slug, en sti eller en oppgave, bruk den. En slug slås opp med `Glob` `tasks/*/scope-<slug>.md`, og en oppgave med `Glob` `tasks/*/<slug>/oppgave.md` (scopet står i `Scope:`). Ellers lister du `tasks/*/scope-*.md` og spør med `AskUserQuestion`.
3. **Les det som finnes:** scope-fila (modus B og C), `oppgave.md` i oppgavene i domenet, og kravene med taggen (`Grep` `@scope-<slug>` under `krav/`). Kravene i `krav/` og oppgavene i `tasks/` leses alltid. Det er ikke en kilde brukeren må oppgi.

Datoer tas fra samtalekonteksten (`# currentDate`). Filer skrives med Read, Write og Edit, ikke med `date`, `>>`, `cp` eller andre shell-konstruksjoner, så skillen virker likt på macOS, Linux og Windows. `Bash` brukes bare til `gh` (bare lesing) og til å sjekke branchen.

## Kilder

Ingen kilde er en forutsetning. Spør hva som finnes (`AskUserQuestion`, flervalg), og hent det brukeren oppgir:

- **GitHub:** initiativet og sub-issuene, med `gh issue view <n> --repo sikt-no/fs --json title,body,labels,url` og `gh api repos/sikt-no/fs/issues/<n>/sub_issues`. Bare lesing.
- **Confluence og Jira:** Atlassian-MCP-en (`mcp__claude_ai_Atlassian_Rovo__*`), med `getConfluencePage` og `getJiraIssue` når brukeren gir en lenke eller ID. Søk bare når brukeren ber om det.
- **Figma-skisser:** se *Figma som kilde* under.
- **Markdown-filer i repoet:** med `Read`.
- **Nettadresser:** med `WebFetch`.

Kildene skrives under `## Kilder` i scope-fila, med lenke og en kort linje om hva de er.

### Figma som kilde

Brukeren gir en eller flere Figma-lenker. Skjermene og flytene i skissen blir kandidater til oppgaver og krav.

1. **Parse URL-en** som i `fs-specify`: `fileKey` fra stien, og `nodeId` fra `node-id`-parameteren med `-` byttet til `:`. Mangler `node-id`, hent på fil- eller sidenivå.
2. **Hent strukturen** med verktøyene som bare leser: `get_metadata` først, så `get_screenshot` på de viktigste rammene, og `get_design_context` ved behov. Ikke hardkod servernavnet. Bruk serveren som har disse verktøyene.
3. **Foreslå** oppgaver og krav ut fra skjermene: «skjermen *Runder* → kapabilitet `14 Plasstildeling/01 Runder`, krav *Opprette runde*». Brukeren bekrefter. Skjermer uten krav, og krav uten skjerm, nevnes i oppsummeringen.
4. **I scopet:** Figma-lenkene står under `## Kilder` med node-ID og tittel, og tabellen får lenke til rammen som dekker kravet i kolonnen `Skisse`.
5. **Lagre ingenting.** Figma-artefaktene lagres av `fs-specify` når kravene hentes inn. Den bruker skisselenkene i scope-tabellen som utgangspunkt.

**Ingen Figma-MCP, eller ikke logget inn:** som i `fs-specify` (*Figma-skisser*, punkt 5 og 6). Si hvordan den legges til og logges inn i terminalen, og spør om brukeren vil fortsette uten, eller beskrive skissen selv.

## Opprette en oppgave

Brukes i modus A og B når en ny oppgave trengs.

1. **Domene.** Oppgavene i et scope ligger i samme domene som scope-fila. Bare verdiene i domenetabellen i `tasks/README.md` er gyldige. Finnes ikke domenet, pek på «Legge til et nytt domene» i README-en og stopp. Skillen oppretter ikke domener.
2. **Issue.** Én oppgave ≙ én Jira-sak (se *Forholdet til Jira og GitHub* i `tasks/README.md`). Spør etter saksnøkkelen. Har oppgaven ikke issue enda, skriv `–` i metadata og legg et punkt under `## Åpne punkter` nederst i fila om at issue mangler. Før en ny Jira-sak foreslås for oppgaven, kjør `jira-overlapp-sjekk`, så saken ikke overlapper med en som finnes.
3. **Slug.** Kebab-case, lesbar beskrivelse, ikke issue-nummeret. Æ/ø/å skrives som ae/o/a. Sjekk med `Glob` at `tasks/<domene>/<slug>/` ikke finnes fra før.
4. **Skriv `tasks/<domene>/<slug>/oppgave.md`** fra `tasks/mal/oppgave.md`:
   - Fjern malkommentaren (`<!-- … -->`) øverst.
   - Erstatt alle plassholdere. Ukjente felt får `–`. Behold ingen «x | y | z»-valglister. `Fase` utelates (den er valgfri, og leses ikke av FS Kravforvaltning).
   - `- **Scope**: [scope-<slug>](../scope-<slug>.md)`. Har oppgaven scope, lenker ikke `oppgave.md` til kravene i tillegg: scope-raden er kilden.
   - Statusloggen får én linje: `| <dato> | Opprettet i scope-<slug> | <eier eller –> | – |`.
5. **`roadmap.md` røres ikke.**

## Modus A — Nytt scope

1. **Samle kildene** (se *Kilder*) og oppsummer kort: mål, aktører, beslutninger og det som er uklart.
2. **Avgrens med brukeren, ett spørsmål om gangen:** mål, ikke-mål, og hva som er utsatt.
3. **Slug og domene.** Slugen er kebab-case (a–z, 0–9 og `-`), og unik på tvers av alle `tasks/*/scope-*.md`, siden taggen ikke har domene. Går initiativet over flere domener, lag ett scope per domene.
4. **Del i oppgaver.** Oppgaver som finnes, gjenbrukes og får `Scope:` i `oppgave.md` (har de et annet scope fra før, spør). Nye opprettes som i *Opprette en oppgave*. Har en oppgave en håndskrevet `## Oppgaver`-tabell, bruk den som utgangspunkt, og spør om den skal stå eller fjernes når scopet er skrevet.
5. **Kartlegg kravene per oppgave.** Finn feature-filene som finnes (`Grep` på titler og begreper under `krav/`), og foreslå plassering av nye. Før nye mapper lages: sjekk at nummeret ikke er brukt fra før på samme nivå, og at sub-domenet og kapabiliteten ikke heter det samme (se *Mappestruktur* i `krav/README.md`). Kravene og `Regel:`-titlene deles etter prosess og skrives med domenets ord, se *Krav fra kode, skisser eller FS-klienten* i `krav/README.md`. Bekreft med brukeren.
6. **Skjelett-filer for nye krav.** Vis innholdet, og bekreft før det skrives til disk:

   ```gherkin
   # language: no
   # GitHub: #1234
   @DOM-SUB-KAP-NNN @must @draft @scope-<slug>
   Egenskap: <tittel>
     Som <aktør>
     ønsker jeg å <handling>
     slik at <verdi>.

     # ÅPNE SPØRSMÅL:
     # - <det som er uklart>

     Regel: <forretningsregel>

     Regel: <forretningsregel>
   ```

   - `# GitHub:` bare når oppgaven har issue.
   - Feature-ID: neste ledige løpenummer i kapabiliteten (se *Feature-ID* i `krav/README.md`).
   - MoSCoW fra scope-tabellen.
   - Ingen scenarioer. Et skjelett gir ikke avvik i FS Kravforvaltning.
   - Filnavn i snake_case, med verb og substantiv.
7. **Krav som finnes, får `@scope-<slug>`** på `Egenskap:`-tag-linja, sist på linja, med én `Edit`. Er egenskapen `@implemented`, og bare en del endres i dette scopet, settes taggen på delen (`Regel:`/`Scenario:`) i stedet. Har kravet (eller delen) et annet scope fra før, spør. Bytt aldri statustaggen.
8. **Skriv `tasks/<domene>/scope-<slug>.md`** fra `tasks/mal/scope.md` (se *Scope-fila*), og oppsummer: oppgavene, kravene per oppgave med status, åpne spørsmål, og neste steg (`fs-krav` per skjelett-fil, og `fs-specify` når kravene er `@planned`). Oppgavene vises nå på tavla i «I scope».

## Modus B — Revider scope

Kjøres når brukeren ber om det, eller når `fs-krav` eller `fs-specify` foreslår det. Én endring om gangen, bekreftet av brukeren:

- **Legge til et krav:** finnes kravet, få det taggen (som A7). Er det nytt, lag et skjelett (som A6).
- **Flytte et krav mellom oppgaver:** bare tabellen endres. Taggen er den samme.
- **Flytte et krav til et annet scope:** bytt `@scope-<gammel>` med `@scope-<ny>`, og flytt raden til den andre scope-fila.
- **Dele, slå sammen eller legge til oppgaver:** nye oppgaver opprettes som i *Opprette en oppgave*.
- **Ta en oppgave ut av scopet:** fjern `Scope:` fra `oppgave.md`, og legg en linje øverst i statusloggen (`Tatt ut av scope-<slug>`).
- **Utsette eller endre MoSCoW:** endre MoSCoW i tabellen og MoSCoW-taggen i kravet. Utsatte krav kan stå i raden `(ikke tildelt)`.
- **Ta et krav ut av scopet:** fjern taggen og raden. Ut fra statusen:
  - `@draft` eller `@planned`: foreslå `@wont`, eller sletting med `fs-krav` (modus C).
  - `@in-progress`: advar om at spesifikasjonen i oppgaven som har hentet kravet inn, må oppdateres. Tavla flagger kortet. Er kravet delvis levert (`@implemented`-deler), si det: de leverte delene er i koden, og fjernes med `fs-krav` (modus C).
  - `@implemented` eller `@deprecated`: fjern bare taggen.

Tabellen skrives over på plass, og `Siste oppdatering` settes til dagens dato.

## Modus C — Status

Ingen endringer. Per oppgave: kolonnen på tavla (se *Tavla* i `tasks/README.md`), og hvilke krav som er skjelett, `@draft`, `@planned`, `@in-progress` (og av dem delvis levert) og `@implemented`. I tillegg:

- krav med taggen som ikke står i tabellen
- rader som peker på Feature-ID-er som ikke finnes, eller på krav uten taggen eller med et annet scope
- krav i raden `(ikke tildelt)`
- `@planned`-krav uten spesifikasjon (ikke i noen `spec/spec-*.md` i oppgaven)

Foreslå modus B for avvikene.

## Scope-fila

`tasks/<domene>/scope-<slug>.md`, fra `tasks/mal/scope.md`:

```markdown
# Scope: <tittel>

- **Slug**: <slug>
- **Initiativ**: [#NNN](https://github.com/sikt-no/fs/issues/NNN) | –
- **Eier**: @… | –
- **Siste oppdatering**: <dato>

## Mål

## Ikke-mål

## Kilder

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [slug](slug/) | `@OPT-PLA-RUN-001` [runder.feature](../../krav/…) | Must | [Runder](https://figma.com/…?node-id=…) | #… | |
| (ikke tildelt) | … | Could | – | – | |

## Åpne spørsmål
```

- Én rad per krav. En oppgave med flere krav har flere rader.
- Lenkene er relative fra `tasks/<domene>/`: oppgaven `[slug](slug/)`, kravet `../../krav/<sti>` med `%20` for mellomrom.
- Status står ikke i tabellen. Den leses alltid fra taggene i kravene, så den ikke kan bli utdatert.
- En del av et levert krav skrives `` `@DOM-SUB-KAP-NNN` — Regel: <tittel> ``.

## Kontroll før du avslutter

- **Taggene og tabellen stemmer.** `Grep` `@scope-<slug>` under `krav/`: hvert krav med taggen står i tabellen, og hver Feature-ID i tabellen har taggen.
- **Høyst én scope-tag** per egenskap eller del.
- **Oppgavene finnes** som mapper i samme domene, og `oppgave.md` har `Scope:` som peker på scope-fila.
- **Plassholdere.** `Grep` i nye filer etter `NNNN`, `<slug>`, `<tittel>` og `ÅÅÅÅ-MM-DD`.
- **Oppsummer:** filene som er laget eller endret, og neste steg. Minn brukeren på at endringene ikke er committet.

## Gjør ikke

- Skriver ikke scenarioer. Det gjør `fs-krav`.
- Setter ikke `@planned`, `@in-progress`, `@implemented` eller `@deprecated`, og setter `@draft` bare på skjelett-filer den lager selv.
- Sletter ikke krav. Fjerning går gjennom `fs-krav` (modus C).
- Rører ikke `spec/`, `utforing.md` eller `roadmap.md`, og skriver ikke `Fase`.
- Oppretter eller endrer ikke issues i GitHub eller Jira.
- Lagrer ikke Figma-artefakter. Det gjør `fs-specify`.
- Kjører aldri `git add`, `commit`, `push` eller andre git-mutasjoner.

## Referanser

- **[`krav/README.md`](../../../krav/README.md)**: *Scope* (taggen), *Feature-ID*, *Mappestruktur* og tag-aksen.
- **[`tasks/README.md`](../../../tasks/README.md)**: *Scope* (scope-fila), domenetabellen, *Tavla* og reglene for oppgave-rota.
- **[`tasks/mal/scope.md`](../../../tasks/mal/scope.md)** og **[`tasks/mal/oppgave.md`](../../../tasks/mal/oppgave.md)**: malene.
- **`fs-krav`**: fyller ut skjelett-filene (regler og scenarioer) og validerer dem (`@draft` → `@planned`).
- **`fs-specify`** / **`fs-specify-delta`**: henter `@planned`-krav inn i en oppgave, med kravene og skisselenkene fra scope-raden som utgangspunkt.
- **`fs-verify`**: verifiserer kravene mot koden.
