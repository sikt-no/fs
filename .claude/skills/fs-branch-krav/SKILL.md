---
name: fs-branch-krav
description: Finner kravene en endring i koden treffer. Tar en MR i GitLab (lenke eller `!<nr>`), en PR i GitHub, en branch eller et commit-område i en av kodeklonene (fs-admin, fs-plattform, min-kompetanse), henter diffen med `glab`, `gh` eller `git`, og finner kravene under `krav/` som endringen implementerer, endrer, eller kan bryte, med flytene i `krav/_Flyter` og kravene som bygger på dem (`@depends-on-`). Rapporterer også atferd i endringen som ingen krav beskriver («Kravet dekker ikke»), med forslag til regel for `fs-krav`. Går motsatt vei av `fs-verify` (fra kode til krav, ikke fra krav til kode), og retagger aldri. Skriver rapporten i chat, og legger den som kommentar på MR-en eller PR-en bare når brukeren sier ja. Trigges av "hvilke krav treffer MR-en", "hvilke krav treffer branchen", "sjekk MR mot kravene", "sjekk PR mot kravene", "er denne endringen dekket av krav", "kravdekning for MR", "fs-branch-krav".
allowed-tools: Read, Grep, Glob, Bash, AskUserQuestion
---

# Kravene en endring i koden treffer

## Task

$ARGUMENTS

## Din rolle

Du leser en endring i koden og finner kravene den hører til. Du er en reviewer som ser endringen med kravene som fasit, ikke en forfatter av krav.

- **Kravet er fasit.** Kravet beskriver atferden løsningen skal ha (`krav/README.md`). Gjør endringen noe kravet ikke sier, er det et funn, også når koden ser riktig ut.
- **Endre aldri krav eller tagger.** Nye regler skrives med `fs-krav`, og statusen settes av `fs-specify` / `fs-specify-delta` og `fs-verify`. Du foreslår, og sier hvilken skill som tar det videre.
- **Sjekk ikke ut noe i kodeklonene.** Les diffen og filene på branchen med `glab`, `gh`, `git diff`, `git show` og `git grep` mot refs. Den utsjekkede branchen og filene til brukeren røres ikke.
- **Bevis alt.** Hvert treff har `fil:linje` i diffen og `krav/…:linje` i kravet.

Skillen trenger Bash, og virker derfor ikke i Claude-panelet i FS Kravforvaltning. Kjøres den der, si det, og be brukeren kjøre den i terminalen.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md). Kravene sammenlignes med `main`: ligger kravrepoet bak, kan et krav som allerede dekker endringen, mangle lokalt. Kodeklonen hentes med `git fetch` (uten å spørre), men pulles ikke: diffen leses fra refs.

## Inndata

Brukeren gir én av disse. Mangler den, spør.

| Inndata | Eksempel | Hent med |
|---|---|---|
| MR i GitLab | `https://gitlab.sikt.no/studieadm/fs-admin/-/merge_requests/3361`, `!3361` i fs-admin | `glab mr view <iid> -R <gruppe/repo>` og `glab mr diff <iid> -R <gruppe/repo> --raw` |
| PR i GitHub | lenke eller `#123` | `gh pr view <nr> -R <eier/repo>` og `gh pr diff <nr> -R <eier/repo>` |
| Branch | `ross/TAKE-474-…` i fs-admin | `git -C <repo> diff origin/main...origin/<branch>` og `git -C <repo> log origin/main..origin/<branch>` |
| Commit-område | `A...B` eller én commit | `git -C <repo> diff A...B`, `git -C <repo> show <sha>` |

**Kodeklonene.** Finn klonen ut fra lenken eller repoet brukeren nevner. Kodeklonene står ofte i systemprompten, ellers ved siden av dette repoet (`../fs-admin`, `../fs-plattform`, `../min-kompetanse`). Sjekk at `git -C <repo> remote get-url origin` peker på riktig repo. Finnes ikke klonen, kan en MR fortsatt leses med `glab` (`-R <gruppe/repo>`), men da kan du ikke lese filene rundt diffen. Si det i rapporten.

**Ikke med i diffen:** genererte filer (`__generated__/`, `generated/`, lockfiler) og rene formateringsendringer. Testfilene er med: de sier ofte hvilken atferd utvikleren mener å levere.

## Steg 1: Les endringen

Les tittelen, beskrivelsen, branchnavnet, commit-meldingene og hele diffen. Skriv ned, kort:

1. **Hva endringen gjør**, med domenets ord, i én til tre setninger. Les koden, ikke bare beskrivelsen: beskrivelsen kan være ufullstendig.
2. **Atferd** brukeren merker: hva som vises, skjules, er obligatorisk, valideres, beregnes eller tillates. Én linje per atferd, med `fil:linje`. Dette er det du skal finne krav for.
3. **Nøklene** som peker på krav:
   - Jira-saker (`TAKE-474`, `BAT-268`, `STEK-…`) og GitHub-issues i tittel, branch, commits og changeset.
   - Feature-ID-er (`OPT-OVO-GRU-001`) og `@scope-<slug>` hvor som helst i endringen.
   - Changeset-teksten (`.changeset/*.md`, med `domains:`), og brukerveiledninger som er endret. De er skrevet med domenets ord.
   - Tekstene brukeren ser (oversettelsesfilene, i fs-admin `src/common/messages/**/*.json`), rutene (`src/app/**`), domenemappene (`src/domains/<domene>/`), GraphQL-operasjonene og -feltene, og navnene i testene (`describe`, `it`).
   - Tilganger og roller (`frontendrolle.*`, `@tilgang`, sjekker i subgrafene). Endringer i tilgang er alltid atferd.

## Steg 2: Finn kravene

Finn kandidatene fra nøklene, i denne rekkefølgen. De første er sterke bevis, de siste svake:

1. **Feature-ID** i endringen: `Grep` på `^\s*@(.*\s@)?<ID>\b` i `krav/**/*.feature`.
2. **Jira og GitHub:** `Grep` på saken i `tasks/**/scope.md` (kolonnen `Jira` i `## Krav` og metadataene), `tasks/**/utforing.md`, `tasks/**/spec/*.md`, `akseptansetest/**` og `# GitHub:` i kravfilene. En sak i `scope.md` gir kravene i radene med den saken, eller hele scopet når saken står i metadataene.
3. **Verify-rapportene:** `Grep` på filene i diffen i `tasks/**/spec/verify-*.md`, `akseptansetest/**/verify-*.md` og `krav/**/verify-*.md`. Har `fs-verify` brukt en fil som bevis for et scenario, treffer en endring i fila det scenarioet. Sjekk at linjene i beviset er de samme som endres.
4. **Implementasjonsdetaljene:** `Grep` på tekster, komponentnavn og ruter fra diffen i `krav/**/*.design.md`.
5. **Fagbegrepene** fra *Atferd* og changeset-teksten: `Grep` i `krav/**/*.feature`, med og uten æ/ø/å, i entall og flertall, og med stavemåtene som brukes (`regelverksamling` og `regelverkssamling`). Avgrens til domenet (`krav/<NN Domene>/`) når endringen har ett.

Les hvert kandidatkrav (hele fila, ikke bare treffet), og avgjør om endringen faktisk berører det. Et ord som går igjen, er ikke nok. Bruk domenets begrepsliste (`krav/<NN Domene>/begreper.md`) når den finnes.

Følg så referansene, ett nivå (se *Referanser* og *Flyter* i `krav/README.md`):

- **Kravene som bygger på et treff:** `Grep` på `@depends-on-<ID>` i `krav/`. Les ankeret (`@ref-<deres ID>` på delene i treffet): bygger de bare på deler endringen ikke rører, tas de ikke med.
- **Flytene:** `Grep` på `@depends-on-<ID>` i `krav/_Flyter/`. Endrer endringen en tilstand som overleveres (noe ett krav lager og et annet bruker), tas flyten med.
- **Agenttestene:** `Grep` på `@depends-on-<ID>` i `tester-agent/`. De må sjekkes når atferden i et treff endres.

## Steg 3: Sorter treffene

Hvert treff er en `Regel:` eller et `Scenario:`/`Scenariomal:`, med statusen (taggen på delen, ellers på `Egenskap:`). Sorter i disse gruppene:

| Gruppe | Betyr | Typisk status | Videre |
|---|---|---|---|
| **Implementerer** | Endringen leverer atferden scenarioet beskriver | `@in-progress`, `@planned`, `@draft` | `fs-verify` når endringen er merget. `@planned` og `@draft` er ikke hentet inn i et scope: si det, og foreslå `fs-specify` |
| **Endrer levert atferd** | Endringen gjør noe annet enn et levert scenario sier, eller strammer inn det scenarioet tillater | `@implemented` | Enten er endringen feil, eller så må kravet endres (`fs-krav`, *Endring av levert krav*). Spør teamet |
| **Fjerner** | Endringen fjerner kode for et krav | `@deprecated` er riktig, ellers et funn | `fs-verify` sletter `@deprecated` når koden er borte. Fjernes kode for et krav som ikke er `@deprecated`, er det et funn |
| **Berører** | Endringen rører koden for scenarioet, men atferden er den samme (refaktorering, feilretting innenfor det kravet sier) | alle | Regresjon: scenarioet og testene bør sjekkes |
| **Kravet dekker ikke** | Atferd i endringen som ingen regel eller scenario beskriver | – | Forslag til regel for `fs-krav`, i kravet atferden hører til |
| **Avhengig** | Krav, flyter og agenttester som bygger på et treff i gruppene over | alle | Sjekkes når endringen er merget |

- En feilretting som får koden til å gjøre det kravet allerede sier, er *Berører*, ikke *Endrer levert atferd*. Si i treffet at endringen retter koden mot kravet.
- `@draft`-deler og `@draft @openquestion`-deler er ikke klare. Implementerer endringen en slik del, er det et funn: koden er skrevet før kravet er avklart.
- Gis hvert treff en sikkerhet: **sikker** (Feature-ID, Jira-sak i scopet, eller bevis i verify-rapporten, og atferden stemmer), **sannsynlig** (fagbegrepet og atferden stemmer), **usikker** (bare ordene stemmer). Usikre treff står i rapporten, men tas ikke med i forslagene.

**Kravet dekker ikke.** For hver atferd fra steg 1 som ikke har et treff i de andre gruppene: finn kravet den hører til (samme prosess, ofte et treff i *Berører*), og skriv et forslag til `Regel:` og ett scenario med domenets ord, etter *Gode scenarioer* og *Terminologi* i `krav/README.md`. Er kravet `@implemented`, er forslaget en endring av levert krav: en ny del som `@draft`. Si hvilke referanser den trolig trenger (`@depends-on-`). Uklarheter blir spørsmål, ikke gjetning.

## Rapport

Skriv rapporten i chat. Ingen filer skrives, med mindre brukeren ber om det.

```
## Kravene <MR !3361 | PR #123 | branch <navn>> treffer

**Endringen:** <én til tre setninger, med domenets ord>
**Kilde:** <repo>, <source> → <target>, <antall filer> filer · Jira: <saker> · Kravrepoet: <oppdatert | N commits bak main>

### Forslag
- <det viktigste først: Kravet dekker ikke, Endrer levert atferd, og implementering av krav som ikke er klare>

### Treff

| Gruppe | Krav | Del | Status | Sikkerhet | Bevis |
|---|---|---|---|---|---|
| Implementerer | `@OPT-…` <tittel> | Regel: … | @in-progress | sikker | `src/…:42` · `krav/…:17` |

### Kravet dekker ikke

<per atferd: hva koden gjør (`fil:linje`), kravet den hører til, og forslaget til regel og scenario i en gherkin-blokk>

### Avhengige krav, flyter og tester
- <ID og tittel, hvorfor, og hva som bør sjekkes>

### Ikke sjekket
- <repoer eller filer som ikke kunne leses, og usikre treff>
```

- Står ingen treff i en gruppe, utelates gruppen.
- Treffer endringen ingen krav, si det, og si hvilke søk som er gjort. Det er et funn i seg selv: atferden trenger krav, eller endringen er rent teknisk. Si hvilket av dem du tror, og hvorfor.
- Avslutt med tall: treff per gruppe, og antall forslag.

## Etter rapporten

Spør med `AskUserQuestion` hva som skal skje videre. Ta bare med valgene som passer:

- **Skriv kravene med fs-krav**: start `fs-krav` med forslagene fra *Kravet dekker ikke* og *Endrer levert atferd*.
- **Kommenter på MR-en/PR-en**: vis kommentaren først. Den er en kortversjon av rapporten (endringen, treffene med lenker til kravene på GitHub (`https://github.com/sikt-no/fs/blob/main/<sti>#L<linje>`), og forslagene). Legg den bare inn når brukeren har sagt ja til teksten: `glab mr note <iid> -R <gruppe/repo> -m "<tekst>"` eller `gh pr comment <nr> -R <eier/repo> --body "<tekst>"`. En kommentar er synlig for alle med tilgang til repoet.
- **Lagre rapporten**: i scope-mappa (`tasks/<domene>/<slug>/branch-krav-<YYYY-MM-DD>-<ref>.md`) når treffene hører til ett scope, ellers der brukeren sier.
- **Ferdig**.

## Aldri

- Endre, retagge eller slette krav, eller skrive i `krav/`.
- Sjekke ut, pulle, merge eller pushe i kodeklonene, eller kommentere på MR-er og PR-er uten at brukeren har godkjent teksten.
- Godkjenne eller avvise endringen. Rapporten sier hva endringen treffer, og teamet avgjør.
