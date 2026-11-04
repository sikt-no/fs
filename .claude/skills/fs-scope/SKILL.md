---
name: fs-scope
description: Avgrenser et initiativ i dette repoet, før kravene skrives. Lager og reviderer scopet, én mappe `tasks/<domene>/<slug>/` med `scope.md` fra `tasks/mal/scope.md` (mål, ikke-mål, kilder, Jira-sakene, og kravene med saken hvert krav hører til), lager skjelett-krav (`@draft`, brukerhistorie og `Regel:`-titler uten scenarioer) og setter `@scope-<slug>` på kravene. Kildene er valgfrie: GitHub-initiativet og sub-issues, Confluence og Jira, Figma-skisser (skjermene blir forslag til krav), markdown-filer og nettadresser. Kan kjøres på nytt når som helst, også når `fs-krav` eller `fs-specify` finner noe som ikke passer i scopet. Skriver aldri scenarioer, og setter ingen annen status enn `@draft`. Trigges av "initiativ", "sette scope", "sette omfang", "nytt scope", "dele opp initiativet", "dele et scope", "hvilke krav hører til scopet", "flytte krav mellom scopes", "flytte krav mellom Jira-saker", "kravspesifikasjon", "starte kravarbeid", "lage kravdokument", "status på scopet", "fs-scope".
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, AskUserQuestion
---

# Scope

## Task

$ARGUMENTS

## Din rolle

Du svarer på spørsmålet *hva er med?* Du avgrenser initiativet sammen med brukeren, og bestemmer hvilke krav (feature-filer) som hører til, og hvilken Jira-sak hvert krav hører til. Resultatet er en plan som kan endres: scope-mappa med `scope.md`, skjelett-kravene og `@scope-<slug>`-taggen på kravene. Ingen begynner å bygge her: scopet definerer omfanget.

Hvordan kravene oppfører seg (regler og scenarioer), skrives med `fs-krav` etterpå. Hva som bygges nå, bestemmes med `fs-specify`. FS Kravforvaltning viser scopene på tavla «Scopes», og kolonnen utledes av taggene og spesifikasjonene. Den settes ikke for hånd.

**[`krav/README.md`](../../../krav/README.md) og [`tasks/README.md`](../../../tasks/README.md) er autoritative.** Står det noe annet der enn her, gjelder README-ene. Taggen er beskrevet under *Scope* i `krav/README.md`, og `scope.md` under *Scope* i `tasks/README.md`.

Kravspesifisering er ikke lineær. Skillen kan kjøres på nytt når som helst (modus B), og `fs-krav` og `fs-specify` sender brukeren hit når de finner noe som ikke passer i scopet, i stedet for å endre scopet selv.

Skillen har tre moduser. Velg ut fra invokasjonen, eller spør med `AskUserQuestion`:

- **A — Nytt scope**
- **B — Revider scope**
- **C — Status**

## Oppstart (gjør dette FØRST)

0. **Sjekk branchen** i dette repoet mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md). Er den bak, spør før du henter. I Claude-panelet (uten Bash) hoppes sjekken over.
1. **Les `tasks/README.md`** (domenetabellen, *Scope*, *Tavla* og reglene for scope-rota) og *Tags* i `krav/README.md`.
2. **Finn scopet** (modus B og C). Oppga brukeren en slug, en sti eller en Jira-sak, bruk den. En slug slås opp med `Glob` `tasks/*/<slug>/scope.md`, og en Jira-sak med `Grep` etter saksnøkkelen i `tasks/*/*/scope.md`. Ellers lister du `tasks/*/*/scope.md` og spør med `AskUserQuestion`.
3. **Les det som finnes:** `scope.md` (modus B og C), de andre `scope.md` i domenet, og kravene med taggen (`Grep` `@scope-<slug>` under `krav/`). Kravene i `krav/` og scopene i `tasks/` leses alltid. Det er ikke en kilde brukeren må oppgi.

Datoer tas fra samtalekonteksten (`# currentDate`). Filer skrives med Read, Write og Edit, ikke med `date`, `>>`, `cp` eller andre shell-konstruksjoner, så skillen virker likt på macOS, Linux og Windows. `Bash` brukes bare til `gh` (bare lesing) og til å sjekke branchen.

## Kilder

Ingen kilde er en forutsetning. Spør hva som finnes (`AskUserQuestion`, flervalg), og hent det brukeren oppgir:

- **GitHub:** initiativet og sub-issuene, med `gh issue view <n> --repo sikt-no/fs --json title,body,labels,url` og `gh api repos/sikt-no/fs/issues/<n>/sub_issues`. Bare lesing.
- **Confluence og Jira:** Atlassian-MCP-en (`mcp__claude_ai_Atlassian_Rovo__*`), med `getConfluencePage` og `getJiraIssue` når brukeren gir en lenke eller ID. Søk bare når brukeren ber om det.
- **Figma-skisser:** se *Figma som kilde* under.
- **Markdown-filer i repoet:** med `Read`.
- **Nettadresser:** med `WebFetch`.

Kildene skrives under `## Kilder` i `scope.md`, med lenke og en kort linje om hva de er.

### Figma som kilde

Brukeren gir en eller flere Figma-lenker. Skjermene og flytene i skissen blir kandidater til krav.

1. **Parse URL-en** som i `fs-specify`: `fileKey` fra stien, og `nodeId` fra `node-id`-parameteren med `-` byttet til `:`. Mangler `node-id`, hent på fil- eller sidenivå.
2. **Hent strukturen** med verktøyene som bare leser: `get_metadata` først, så `get_screenshot` på de viktigste rammene, og `get_design_context` ved behov. Ikke hardkod servernavnet. Bruk serveren som har disse verktøyene.
3. **Foreslå** krav ut fra skjermene: «skjermen *Runder* → kapabilitet `14 Plasstildeling/01 Runder`, krav *Opprette runde*». Brukeren bekrefter. Skjermer uten krav, og krav uten skjerm, nevnes i oppsummeringen.
4. **I scopet:** Figma-lenkene står under `## Kilder` med node-ID og tittel, og krav-tabellen får lenke til rammen som dekker kravet i kolonnen `Skisse`.
5. **Lagre ingenting.** Figma-artefaktene lagres av `fs-specify` når kravene hentes inn. Den bruker skisselenkene i krav-tabellen som utgangspunkt.

**Ingen Figma-MCP, eller ikke logget inn:** som i `fs-specify` (*Figma-skisser*, punkt 5 og 6). Si hvordan den legges til og logges inn i terminalen, og spør om brukeren vil fortsette uten, eller beskrive skissen selv.

## Jira-sakene

Et scope har én eller flere Jira-saker (se *Forholdet til Jira og GitHub* i `tasks/README.md`). Sakene står i `Jira` i metadataene, og kolonnen `Jira` i krav-tabellen sier hvilken sak hvert krav hører til.

- Spør etter saksnøklene. Har scopet én sak, får alle radene den.
- Har scopet ingen sak ennå, skriv `–` i `Jira`, og legg et punkt under `## Åpne spørsmål` om at saken mangler.
- Før en ny Jira-sak foreslås, kjør `jira-overlapp-sjekk`, så saken ikke overlapper med en som finnes. Skillen oppretter ikke saken selv.

## Modus A — Nytt scope

1. **Samle kildene** (se *Kilder*) og oppsummer kort: mål, aktører, beslutninger og det som er uklart.
2. **Avgrens med brukeren, ett spørsmål om gangen:** mål, ikke-mål, og hva som er utsatt.
3. **Domene.** Bare verdiene i domenetabellen i `tasks/README.md` er gyldige. Finnes ikke domenet, pek på «Legge til et nytt domene» i README-en og stopp. Skillen oppretter ikke domener. Går initiativet over flere domener, lag ett scope per domene.
4. **Slug.** Kebab-case (a–z, 0–9 og `-`), lesbar beskrivelse, ikke issue-nummeret. Æ/ø/å skrives som ae/o/a. Slugen er unik på tvers av alle domener, siden taggen ikke har domene: sjekk med `Glob` `tasks/*/<slug>/` at den ikke finnes fra før.
5. **Jira-sakene** (se *Jira-sakene*).
6. **Kartlegg kravene.** Finn feature-filene som finnes (`Grep` på titler og begreper under `krav/`), og foreslå plassering av nye. Før nye mapper lages: sjekk at nummeret ikke er brukt fra før på samme nivå, og at sub-domenet og kapabiliteten ikke heter det samme (se *Mappestruktur* i `krav/README.md`). Kravene og `Regel:`-titlene deles etter prosess og skrives med domenets ord, se *Krav fra kode, skisser eller FS-klienten* i `krav/README.md`. Har scopet flere Jira-saker, avklar hvilken sak hvert krav hører til. Bekreft med brukeren.
7. **Skjelett-filer for nye krav.** Vis innholdet, og bekreft før det skrives til disk:

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

   - `# GitHub:` bare når initiativet har issue.
   - Feature-ID: neste ledige løpenummer i kapabiliteten (se *Feature-ID* i `krav/README.md`).
   - MoSCoW fra krav-tabellen.
   - Ingen scenarioer. Et skjelett gir ikke avvik i FS Kravforvaltning.
   - Filnavn i snake_case, med verb og substantiv.
8. **Krav som finnes, får `@scope-<slug>`** på `Egenskap:`-tag-linja, sist på linja, med én `Edit`. Er egenskapen `@implemented`, og bare en del endres i dette scopet, settes taggen på delen (`Regel:`/`Scenario:`) i stedet. Har kravet (eller delen) et annet scope fra før, spør. Bytt aldri statustaggen.
9. **Skriv `tasks/<domene>/<slug>/scope.md`** fra `tasks/mal/scope.md` (se *scope.md*), og oppsummer: Jira-sakene, kravene med status og sak, åpne spørsmål, og neste steg (`fs-krav` per skjelett-fil, og `fs-specify` når kravene er `@planned`). Scopet vises nå på tavla i «Avgrenset».

## Modus B — Revider scope

Kjøres når brukeren ber om det, eller når `fs-krav` eller `fs-specify` foreslår det. Én endring om gangen, bekreftet av brukeren:

- **Legge til et krav:** finnes kravet, få det taggen (som A8). Er det nytt, lag et skjelett (som A7). Raden får MoSCoW, skisse og Jira-sak.
- **Legge til eller fjerne en Jira-sak:** endre `Jira` i metadataene, og kolonnen `Jira` i radene saken gjelder. Kjør `jira-overlapp-sjekk` før en ny sak foreslås.
- **Flytte et krav mellom Jira-saker:** bare kolonnen `Jira` i raden endres. Taggen er den samme.
- **Flytte et krav til et annet scope:** bytt `@scope-<gammel>` med `@scope-<ny>`, og flytt raden til den andre `scope.md`.
- **Dele et scope:** lag et nytt scope som i modus A (med mappe, `scope.md` og slug), og flytt kravene dit som over. Spesifikasjonene og `utforing.md` blir i scopet de ble skrevet i. Er et krav som flyttes, hentet inn i en spesifikasjon der, si det, så spesifikasjonen kan oppdateres.
- **Slå sammen to scopes:** flytt kravene til det ene scopet som over. Det andre scopet blir stående til mappa er tom for annet enn `scope.md`. Skillen sletter ikke mapper, og flytter ikke `spec/` eller `utforing.md`: si hva som må flyttes for hånd.
- **Utsette eller endre MoSCoW:** endre MoSCoW i tabellen og MoSCoW-taggen i kravet. Et utsatt krav blir stående i tabellen med MoSCoW `Won't` eller en kommentar.
- **Ta et krav ut av scopet:** fjern taggen og raden. Ut fra statusen:
  - `@draft` eller `@planned`: foreslå `@wont`, eller sletting med `fs-krav` (modus C).
  - `@in-progress`: advar om at spesifikasjonen i scopet som har hentet kravet inn, må oppdateres. Tavla flagger kortet. Er kravet delvis levert (`@implemented`-deler), si det: de leverte delene er i koden, og fjernes med `fs-krav` (modus C).
  - `@implemented` eller `@deprecated`: fjern bare taggen.

Tabellen skrives over på plass, `Siste oppdatering` settes til dagens dato, og endringen får en linje øverst i `## Statuslogg`.

## Modus C — Status

Ingen endringer. Kolonnen på tavla (se *Tavla* i `tasks/README.md`), og per Jira-sak hvilke krav som er skjelett, `@draft`, `@planned`, `@in-progress` (og av dem delvis levert) og `@implemented`. I tillegg:

- krav med taggen som ikke står i tabellen
- rader som peker på Feature-ID-er som ikke finnes, eller på krav uten taggen eller med et annet scope
- rader uten Jira-sak når scopet har flere saker, og saker i radene som ikke står i `Jira`
- utsatte krav (`Won't`, eller utsatt i kommentaren)
- `@planned`-krav uten spesifikasjon (ikke i noen `spec/spec-*.md` i scopet)

Foreslå modus B for avvikene.

## scope.md

`tasks/<domene>/<slug>/scope.md`, fra `tasks/mal/scope.md`:

```markdown
# Scope: <tittel>

- **Slug**: <slug>
- **Domene**: <domene>
- **Initiativ**: [#NNN](https://github.com/sikt-no/fs/issues/NNN) | –
- **Jira**: [BAT-…](https://sikt.atlassian.net/browse/BAT-…), [BAT-…](https://sikt.atlassian.net/browse/BAT-…) | –
- **Eier**: @… | –
- **Siste oppdatering**: <dato>

## Mål

## Ikke-mål

## Kilder

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-PLA-RUN-001` [runder.feature](../../../krav/…) | Must | [Runder](https://figma.com/…?node-id=…) | [BAT-…](https://sikt.atlassian.net/browse/BAT-…) | |
| `@OPT-PLA-RUN-002` [….feature](../../../krav/…) | Could | – | – | Utsatt |

## Åpne spørsmål

## Statuslogg

| Dato | Hendelse | Av | Lenke til review |
|------|----------|----|------------------|
| <dato> | Opprettet med fs-scope | <eier eller –> | – |
```

- Fjern malkommentaren (`<!-- … -->`) øverst, og erstatt alle plassholdere. Ukjente felt får `–`. Behold ingen «x | y»-valglister.
- `Slug` er navnet på mappa, og `Domene` er domenemappa.
- Én rad per krav.
- Lenkene er relative fra `tasks/<domene>/<slug>/`: kravet `../../../krav/<sti>` med `%20` for mellomrom.
- Status står ikke i tabellen. Den leses alltid fra taggene i kravene, så den ikke kan bli utdatert.
- En del av et levert krav skrives `` `@DOM-SUB-KAP-NNN` — Regel: <tittel> ``.
- `## Statuslogg` er append-only, med ny linje på toppen.

## Kontroll før du avslutter

- **Taggene og tabellen stemmer.** `Grep` `@scope-<slug>` under `krav/`: hvert krav med taggen står i tabellen, og hver Feature-ID i tabellen har taggen.
- **Høyst én scope-tag** per egenskap eller del.
- **Mappa og metadataene stemmer:** `Slug` er navnet på mappa, `Domene` er domenemappa, og slugen finnes ikke i et annet domene.
- **Jira-sakene stemmer:** sakene i radene står i `Jira`, og har scopet flere saker, har hver rad sin sak.
- **Plassholdere.** `Grep` i nye filer etter `NNNN`, `<slug>`, `<tittel>` og `ÅÅÅÅ-MM-DD`.
- **Oppsummer:** filene som er laget eller endret, og neste steg. Minn brukeren på at endringene ikke er committet.

## Gjør ikke

- Skriver ikke scenarioer. Det gjør `fs-krav`.
- Setter ikke `@planned`, `@in-progress`, `@implemented` eller `@deprecated`, og setter `@draft` bare på skjelett-filer den lager selv.
- Sletter ikke krav. Fjerning går gjennom `fs-krav` (modus C).
- Rører ikke `spec/`, `utforing.md` eller `roadmap.md`, og sletter eller flytter ikke scope-mapper.
- Oppretter eller endrer ikke issues i GitHub eller Jira.
- Lagrer ikke Figma-artefakter. Det gjør `fs-specify`.
- Kjører aldri `git add`, `commit`, `push` eller andre git-mutasjoner.

## Referanser

- **[`krav/README.md`](../../../krav/README.md)**: *Scope* (taggen), *Feature-ID*, *Mappestruktur* og tag-aksen.
- **[`tasks/README.md`](../../../tasks/README.md)**: *Scope* (`scope.md`), domenetabellen, *Tavla* og reglene for scope-rota.
- **[`tasks/mal/scope.md`](../../../tasks/mal/scope.md)**: malen.
- **`fs-krav`**: fyller ut skjelett-filene (regler og scenarioer) og validerer dem (`@draft` → `@planned`).
- **`fs-specify`** / **`fs-specify-delta`**: henter `@planned`-krav inn i scopet, med kravene og skisselenkene fra krav-tabellen som utgangspunkt.
- **`fs-verify`**: verifiserer kravene mot koden.
- **`jira-overlapp-sjekk`**: sjekker en ny Jira-sak mot sakene som finnes.
