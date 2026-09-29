# Kom i gang i FS-repoet

Denne veiledningen er skrevet for deg som skal **skrive krav** i dette repoet,
og som ikke har jobbet i et kodelager før. Den forutsetter ingenting om git.

Målet er ikke at du skal lære git. Målet er at du skal vite nok til å vite
*hva du ber om* — enten du spør en kollega eller Claude Code.

## Hva som ligger her

Dette repoet inneholder kravene til FS, ikke selve FS-koden.

| Mappe | Innhold | Hvem jobber her |
|---|---|---|
| `krav/` | Gherkin-filer (`.feature`) — kravene, lesbare for alle | Domeneeksperter |
| `tester/` | Testkode som kjører kravene automatisk | Utviklere |
| `veikart/`, `tasks/` | Planlegging og pågående arbeid | Alle |

Kravene er skrevet på norsk i et format som heter Gherkin. Det samme kravet
fungerer både som kravspesifikasjon og som grunnlag for automatiske tester.
Konvensjonene ligger i `.claude/rules/gherkin-conventions.md`.

## Mentalmodellen: teksten din finnes fire steder

Dette er den viktigste innsikten, og den som løser mest forvirring. Samme fil
kan ha fire ulike versjoner samtidig:

| Sted | Hva det er | Hvem ser det |
|---|---|---|
| Arbeidsmappa | Fila slik den ligger på maskinen din nå | Bare du |
| Commit | Et lagret øyeblikksbilde med en beskrivelse | Bare du, til du pusher |
| Din branch på GitHub | Kopi av arbeidet ditt på serveren | Alle som vet hvor de skal se |
| `main` | Den offisielle versjonen alle henter fra | Alle |

Nesten all forvirring rundt git kommer av å ikke vite hvilket av disse fire
stedene man snakker om. «Jeg lagret jo!» — ja, i arbeidsmappa. Det er tre steg
unna at noen andre ser det.

## Ordlista

- **Repo** — hele prosjektmappa med all historikk. `sikt-no/fs` er repoet.
- **Clone** — laste ned repoet til maskinen din. Gjøres én gang.
- **Branch** (gren) — en egen arbeidslinje der du kan jobbe uten å påvirke
  andre.
- **Commit** — å lagre et øyeblikksbilde med en forklaring på *hvorfor*. Tenk
  «versjon med begrunnelse», ikke «lagre».
- **Push** — dytte commitene dine opp til GitHub. Før du pusher, finnes
  arbeidet bare på din maskin.
- **Pull** — hente ned andres endringer fra GitHub til din maskin.
- **PR** (Pull Request) — «jeg foreslår at dette legges inn i `main`, se over
  det». Det er her folk kommenterer og diskuterer.
- **MR** (Merge Request) — nøyaktig det samme som en PR. GitLab kaller det MR,
  GitHub kaller det PR. Sikt bruker begge plattformer, derfor hører du begge
  ord. Ingen praktisk forskjell.
- **Merge** — å faktisk legge endringene inn i `main` etter godkjenning.

## Arbeidsflyten: fem steg

For kravarbeid er det egentlig bare denne:

1. Hent siste versjon av `main`
2. Lag en branch — **én branch per sak**
3. Skriv kravet
4. Commit og push — nå ser andre det
5. Opprett PR — folk kommenterer, så merges det

Regelen om én branch per sak er viktigere enn den ser ut. Blander du to saker
på samme branch, kan de ikke lenger godkjennes hver for seg.

## Hva du eier, og hva du kan delegere

Du trenger ikke lære git-kommandoer. Du trenger å vite hva du ber om.

Be om det med vanlige ord:

- «lag en branch for dette kravet»
- «commit og push dette»
- «hent siste fra main»
- «lag PR på dette»
- «hvilken branch står jeg på, og har jeg noe ulagret?»

Dette eier du selv:

- Innholdet i kravene — det er fagkompetansen din
- Beslutningen om når noe er klart for PR
- Å svare på kommentarer i PR-en (det skjer i nettleseren)

## Slik jobber folk faktisk her

Alle nylige sammenslåinger til `main` har gått via PR. Typiske branch-navn er
`krav/tilgangskatalog-api` eller `opptak/registrere-praksis` — altså
`område/kort-beskrivelse`.

**PR er like mye et diskusjonsverktøy som en godkjenning.** Flere åpne PR-er er
eksplisitt merket «Utkast til designdiskusjon». Du kan fint åpne en PR på et
uferdig utkast for å få innspill — det er en vanlig og ønsket bruk.

To ting som er greit å vite:

- `main` er ikke teknisk beskyttet. Du *kan* pushe rett dit. Ikke gjør det —
  hele poenget med PR er at noen ser over kravet først.
- `.github/FS-github-oppsett.md` er delvis utdatert. Den beskriver `type:`- og
  `priority:`-labels som obligatoriske, men de finnes ikke i repoet. I praksis
  brukes prosessområde-labels: `Opptak`, `Kompetanse`, `Person`,
  `Organisasjon`, `initiativ` og noen flere.

## Sammenhengen mellom krav og GitHub-issues

Hvert krav peker på et GitHub-issue med en kommentar øverst i fila:

```gherkin
# language: no
# GitHub: #604
@OPT-SØK-SØK-004 @must @draft
Egenskap: ...
```

Issuet sporer at kravet *finnes*. Innholdet i kravet eies av `.feature`-fila,
og git-historikken gir sporbarheten. Det betyr:

- Ny fil, slettet fil, eller endret `Egenskap:`-tittel → oppdater issuet
- Nye eller endrede scenarioer → ikke gjør noe med issuet

Issues organiseres hierarkisk: et **initiativ** er paraplyen, og enkeltsaker
henger under som undersaker.

## Tags du vil møte i kravene

- `@DOM-SUB-KAP-NNN` — unik Feature-ID, utledet fra mappestrukturen
- `@must` / `@should` / `@could` / `@wont` — prioritet
- `@draft` — kravteksten er ikke ferdig avklart ennå
- `@planned` — kravet er klart til implementasjon
- `@in-progress` / `@implemented` — status på koden
- `@openquestion` — ett enkelt scenario har en uavklart detalj, selv om resten
  av kravet er klart

Et krav går typisk `@draft` → `@planned` → `@in-progress` → `@implemented`.

## Verktøystøtte i Claude Code

Repoet har egne skills som kjenner konvensjonene:

| Skill | Når |
|---|---|
| `/skrive-krav` | Én enkeltstående feature-fil |
| `/bat-krav` | Kravarbeid på initiativnivå, eller ferdigstille drafts i en mappe |
| `/utdype-implementasjon` | UI- og designdetaljer, i en `.design.md` ved siden av kravet |
| `/lage-steps` | Koble kravet til automatiske tester (for utviklere) |

En viktig arbeidsdeling: `.feature`-fila beskriver **hva** som skal skje.
Ordlyd, knappeplassering og utforming hører hjemme i en `.design.md`-fil ved
siden av. Det holder kravene lesbare og robuste mot designendringer.

## Når det går galt

| Situasjon | Hva du ber om |
|---|---|
| «Jeg vet ikke hvor jeg er» | «hvilken branch står jeg på, og har jeg noe ulagret?» |
| «Jeg har rotet i en fil» | «forkast endringene mine i den fila» |
| «Jeg skrev på feil branch» | «flytt endringene mine til en ny branch» |
| «Noen andre har endret samme fil» | «hjelp meg løse konflikten» |
| «Jeg vil se hva jeg har endret» | «vis meg diffen» |

Det viktigste: **git mister nesten aldri noe du har committet.** Har du
committet, kan det hentes tilbake. Derfor er «commit ofte» billig forsikring,
også midt i et halvferdig krav.

## Videre lesing

- [Konvensjoner for Gherkin i FS](.claude/rules/gherkin-conventions.md)
- [Mønster for listevisninger i krav](.claude/rules/listevisning-pattern.md)
- [Designmønstre for krav](.claude/rules/design-patterns-for-krav.md)
- [GitHub-oppsett for FS](.github/FS-github-oppsett.md) — se forbeholdet om
  labels over
- [Oversikt over alle krav](krav/krav-oversikt.md)
- [Utviklingsmodellen](https://fs.sikt.no/utviklerhandbok/utviklingsmodell/)
