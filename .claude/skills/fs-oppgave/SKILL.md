---
name: fs-oppgave
description: Livsløpet til en oppgave i `tasks/<domene>/<slug>/` i dette repoet, ut fra malene i `tasks/mal/`. Oppretter en ny oppgave (`oppgave.md` fra malen, og en rad i domenets `roadmap.md`), flytter en oppgave mellom faser (prioritert → utforskning → utvikling → innføring → levert), og lager artefaktene overgangen krever (`design.md`, `<lag>/plan-<slug>.md`), samt review-filer (`reviews/rNN-<fra>-til-<til>.md`) med reviewer-historikk. Holder `oppgave.md` (fase, lenker, statuslogg) og `roadmap.md` i synk. Rører ikke `spec/`, GitHub-issues eller krav-tagger. Trigges av "ny oppgave", "opprett oppgave", "start en oppgave", "flytt oppgaven til utforskning/utvikling/innføring/levert", "faseovergang", "lag design.md", "lag lagplan", "plan for frontend/backend/subgraph", "review av oppgave", "skriv review", "oppdater roadmap".
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion
---

# Oppgave

## Task

$ARGUMENTS

## Din rolle

Du holder orden på oppgavemappa: metadata, fase, statuslogg, roadmap og artefaktene som hører til hver faseovergang. Du kopierer malene i [`tasks/mal/`](../../../tasks/mal/) og fyller inn det som er kjent. Resten av innholdet (problem, design, arbeidsoppgaver, observasjoner) skriver teamet selv, eller du skriver det sammen med brukeren når de ber om det.

**[`tasks/README.md`](../../../tasks/README.md) er autoritativ.** Står det noe annet der enn her, gjelder README-en.

Skillen har tre moduser. Velg ut fra invokasjonen, eller spør med `AskUserQuestion`:

- **A — Ny oppgave**
- **B — Faseovergang**
- **C — Review**

## Oppstart (gjør dette FØRST)

1. **Les `tasks/README.md`** (domenelista, de fire reglene, fasetabellen og «Hva som produseres per faseovergang»).
2. **Finn oppgavemappa** (modus B og C). Oppga brukeren en sti eller slug, bruk den. En slug slås opp med `Glob` `tasks/*/<slug>/`, og gir den mer enn ett treff, spør hvilken. Ellers lister du `tasks/<domene>/<slug>/` (unntatt `mal/`) og spør med `AskUserQuestion`.
3. **Les `tasks/<domene>/README.md`**, særlig «Teamkonvensjoner». Domenet kan ha egne regler, for eksempel at en reviewer som ikke er eier må ha sett oppgaven før den flyttes.
4. **Les `oppgave.md`** i oppgavemappa (modus B og C) og `tasks/<domene>/roadmap.md`.

Datoer tas fra samtalekonteksten (`# currentDate`). Filer skrives med Read, Write og Edit, ikke med `date`, `>>`, `cp` eller andre shell-konstruksjoner, så skillen virker likt på macOS, Linux og Windows. `Bash` brukes bare til `gh`.

## Modus A — Ny oppgave

1. **Domene.** Bare verdiene i domenetabellen i `tasks/README.md` er gyldige. Finnes ikke domenet, pek på «Legge til et nytt domene» i README-en og stopp. Denne skillen oppretter ikke domener.
2. **Issue.** Spør om issue-nummeret (én oppgave ≙ én issue). Er `gh` tilgjengelig, hent tittel og labels med `gh issue view <n> --repo sikt-no/fs --json title,labels,url` og foreslå dem. Har oppgaven ikke issue enda, skriv `–` i metadata og legg et punkt under `## Åpne punkter` om at issue mangler (malen har ikke seksjonen, så opprett den nederst i fila) (se `tasks/brukeradministrasjon-og-tilgangsstyring/applikasjoner-visning-delta/oppgave.md`).
3. **Slug.** Kebab-case, lesbar beskrivelse, ikke issue-nummeret. Æ/ø/å skrives som ae/o/a. Sjekk med `Glob` at `tasks/<domene>/<slug>/` ikke finnes fra før.
4. **Øvrige metadata.** Spør bare om det som ikke kan utledes: prioritet (Must/Should/Could/Won't), eier, initiativ, og sti til kravene under `krav/` hvis de finnes. Ukjente felt får `–`.
5. **Skriv `tasks/<domene>/<slug>/oppgave.md`** fra `tasks/mal/oppgave.md`:
   - Fjern malkommentaren (`<!-- … -->`) øverst.
   - Erstatt alle plassholdere (`<Oppgavetittel>`, `NNNN`, `<domene>`, `<slug>`, `@brukernavn`). Behold ingen «x | y | z»-valglister: `Fase: prioritert`.
   - Lenker til filer som ikke finnes enda (`design.md`, `spec/`, `reviews/`) settes til `–`, og fylles inn når artefaktet lages.
   - Lenken til kravene skrives som relativ markdown-lenke med `%20` for mellomrom, som i eksisterende oppgaver.
   - Statusloggen får én linje: `| <dato> | Tatt inn i veikart (prioritert) | <eier eller –> | – |`.
6. **Oppdater `tasks/<domene>/roadmap.md`**, se *Roadmap* under.

## Modus B — Faseovergang

Fasene er **prioritert → utforskning → utvikling → innføring → levert**, én om gangen. Spør hvis brukeren vil hoppe over en fase.

### Før overgangen

- **Review.** Mellom hver fase skal en tredjepart ha gjort et review for improvement. Finnes det ingen `reviews/r*-<fra>-til-<til>.md` med utfallet «Ingen verdifulle forbedringer», si det, og tilby modus C. Brukeren kan velge å flytte likevel. Da noteres det i statuslogglinja («uten review»).
- **Domeneregler.** Sjekk «Teamkonvensjoner» (for eksempel at en reviewer som ikke er eier har sett oppgaven). Er de ikke oppfylt, advar.

### Artefakter per overgang

| Overgang | Gjør |
|----------|------|
| prioritert → utforskning | Lag `design.md` fra `tasks/mal/design.md`. Fjern malkommentaren, sett tittel og issue-lenke, og la seksjonene stå med malteksten til teamet fyller dem ut. Finnes `design.md` alt, la den være. |
| utforskning → utvikling | Spør hvilke lag som skal endres (`AskUserQuestion`, flervalg: `spec`, `frontend`, `backend`, `subgraph`, `tester`, `db`, `dokumentasjon`, pluss «Annet»). For hvert lag: lag `<lag>/plan-<slug>.md` fra `tasks/mal/plan.md` (fjern malkommentaren, sett `<lag>`, tittel og lenker). Finnes planen alt (for eksempel fra `bat-plan`), la den være. Oppdater «Lag/roller i bruk» og plan-lenkene i `oppgave.md`. |
| utvikling → innføring | Les planfilene i `<lag>/plan-*.md`. Er det uavkryssede bokser, eller ingen PR-er under «Lenker» i `oppgave.md`, advar. Spør om PR-lenker og legg dem inn. |
| innføring → levert | Alle planbokser skal være avkrysset, og PR-ene lenket. Mangler noe, advar. Flytt raden i roadmapen fra «Aktive oppgaver» til «Ferdig». |

Advarsler stopper ikke overgangen. Brukeren bestemmer.

### Oppdater `oppgave.md` og roadmapen

- Sett `**Fase**:` til den nye fasen.
- Legg en ny linje **øverst** i statusloggen (rett under tabellhodet). Loggen er append-only med nyeste linje først. Endre aldri eksisterende linjer. Eksempel: `| 2026-09-27 | prioritert → utforskning | @eier | [r01](reviews/r01-prioritert-til-utforskning.md) |`.
- Oppdater lenkene til nye artefakter.
- Oppdater roadmapen, se *Roadmap*.

### Rapporter til slutt

Si hvilken **issue-status** og hvilken **krav-tag** fasetabellen i `tasks/README.md` forventer nå, men endre dem ikke. Issue-status settes i GitHub-prosjektet av teamet. Krav-taggene eies av `fs-krav`, `fs-specify` / `fs-specify-delta` og verifiseringen. Foreslå neste steg når det passer (for eksempel `fs-specify` i utforskning, `bat-analyze` / `bat-plan` før utvikling).

## Modus C — Review

1. **Overgang.** Reviewet gjelder overgangen fra oppgavens nåværende fase til neste, med mindre brukeren sier noe annet.
2. **Reviewer.** Spør om reviewer. Les «Reviewers som har sett oppgaven» og «Eier» i `oppgave.md`. Er revieweren eier, advar: reviewet skal gjøres av en tredjepart. Var forrige review «Forbedringer foreslått», må neste reviewer være en som ikke står på lista. Er revieweren alt på lista, advar.
3. **Nummer.** `NN` = antall filer i `reviews/` + 1, med to siffer (`r01`, `r02`, …).
4. **Skriv `reviews/rNN-<fra>-til-<til>.md`** fra `tasks/mal/review.md`. Fjern malkommentaren, og fyll inn tittel, lenker, reviewer, dato, «Tidligere reviewere på denne oppgaven» og PR. Utfall og observasjoner fylles inn av revieweren. Gir brukeren utfall og observasjoner, skriv dem inn.
5. **Oppdater `oppgave.md`:** legg revieweren til i «Reviewers som har sett oppgaven», sett review-lenken til `[reviews/](reviews/)`, og legg en linje øverst i statusloggen (`Review rNN: <utfall>`, med lenke til fila).
6. **Utfall «Forbedringer foreslått»:** fasen står. Minn om at en *annen* tredjepart må gjøre neste review. Utfall «Ingen verdifulle forbedringer»: tilby modus B.

## Roadmap

`tasks/<domene>/roadmap.md` har ulik layout fra domene til domene (opptak har for eksempel «Harde tidsrammer» og en egen initiativtabell). Rediger derfor ut fra overskriftene `## Aktive oppgaver` og `## Ferdig` og kolonnene i tabellen som står der, ikke ut fra faste linjenumre.

- **Ny oppgave:** legg en rad i «Aktive oppgaver», med samme kolonner som tabellen har. Issue-cella er `[#N](https://github.com/sikt-no/fs/issues/N)` eller `–`, og mappe-cella er `[<slug>](<slug>/)`.
- **Faseovergang:** oppdater fase-cella (og reviewere-cella hvis tabellen har den).
- **Levert:** flytt raden til «Ferdig» med dagens dato, i kolonnene den tabellen har.
- Oppdater alltid `Siste oppdatering: <dato>`.
- Mangler roadmapen, eller har den ikke disse overskriftene, si det og spør før du endrer strukturen.

## Kontroll før du avslutter

- **Glob-regelen.** Sjekk med `Glob` at oppgave-rota ikke har `spec-*.md`, `analysis-*.md`, `plan-*.md` eller `verification-*.md`. Malene kopieres alltid til `oppgave.md`, `design.md`, `<lag>/plan-<slug>.md` og `reviews/rNN-….md`. Treff rapporteres, og flyttes bare hvis brukeren ber om det.
- **Plassholdere.** Sjekk med `Grep` at nye filer ikke har igjen `NNNN`, `<Oppgavetittel>`, `<slug>`, `<lag>` eller `ÅÅÅÅ-MM-DD`, bortsett fra der verdien faktisk er ukjent og brukeren har sagt det.
- **Oppsummer:** filer som er laget eller endret, ny fase, advarsler, og forventet issue-status og krav-tag. Minn brukeren på at endringene ikke er committet, og at faseovergangen normalt går som en PR som noen reviewer.

## Gjør ikke

- Rører ikke `spec/` (eies av `fs-specify` / `fs-specify-delta`), `flow.md` (eies av alfred), `memory.md` eller BAT-artefaktene i `<lag>/` utover å lage en ny `plan-<slug>.md` fra malen.
- Endrer ikke `.feature`-filer eller krav-tagger under `krav/`.
- Oppretter, endrer eller lukker ikke GitHub-issues, og endrer ikke status i GitHub-prosjekter. `gh` brukes bare til å lese.
- Oppretter ikke domener, og endrer ikke malene i `tasks/mal/`.
- Kjører aldri `git add`, `commit`, `push` eller andre git-mutasjoner.
