---
name: fs-e2e-kravrapport
description: Lager en rapport over alle kravene i `krav/` med status, og hvilke av dem som har grønne eller røde e2e-tester i fs-admin. Leser kravene i dette repoet og henter `test-results/results.json` fra test-e2e-jobbene i en pipeline i fs-admin på GitLab (standard den nyeste ferdige pipelinen for MR !2996). Kobler krav-ID-taggene på Playwright-testene mot feature-filene, og skriver en markdown-rapport med oppsummering, røde og grønne krav, alle krav som ikke er implementert, ikke implementerte regler og scenarioer i leverte krav, leverte krav uten test, hele kravlista og avvik (doble ID-er, filer uten ID, tagger som ikke finnes). Retagger aldri. Trigges av "kravrapport", "e2e-kravrapport", "kravliste", "hvilke krav er testet", "hvilke krav er grønne", "hvilke krav er ikke implementert", "krav-dekning i e2e", "rapport over krav fra pipelinen", "fs-e2e-kravrapport".
allowed-tools: Read, Bash, Write, AskUserQuestion
---

# E2e-kravrapport

## Task

$ARGUMENTS

## Din rolle

Du viser hvor kravene står: hvilken status de har, og hva e2e-testene i fs-admin sier om dem. Du teller og grupperer, og retagger ingenting. `@implemented` eies av `fs-verify`.

## I FS Kravforvaltning

Skillen trenger Bash for å kjøre scriptet og `glab`, så den virker i terminalen, ikke i Claude-panelet.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md). Er den bak, spør før du henter. Rapporten er aldri nyere enn kravene den leser.

## Kilder

1. **Kravene:** `krav/` i dette repoet. Fra hver feature-fil leser scriptet ID, tittel, status og prioritet på `Egenskap:`, og regler og scenarioer med egen status.
2. **Testresultatene:** `test-results/results.json` fra artefaktene til test-e2e-jobbene i fs-admin, én jobb per profil. En Playwright-test som utfører et scenario fra kravene, har feature-ID-en som tag, for eksempel `{ tag: '@OPT-REG-SAM-001' }` (se *Koblingen til kravene* i `e2e/README.md` i fs-admin). JUnit-rapporten tar ikke med taggene.

## Kjør scriptet

Fra rota av repoet:

```sh
node .claude/skills/fs-e2e-kravrapport/kravrapport.ts [--mr 2996] [--pipeline <id>] [--krav krav] [--domene OPT] [--ut fil.md]
```

- Uten `--pipeline` velges den nyeste pipelinen for MR-en som er `success` eller `failed`. En pipeline som kjører, har ingen artefakter ennå. Etter at !2996 er merget, kjører testene nattlig på `main` i fs-admin, og da finner `--mr` ingenting. Bruk `--pipeline <id>` fra den nattlige kjøringen.
- `--domene` filtrerer på starten av ID-en: `OPT`, eller `OPT-REG` for bare regelverk.
- `--krav` er en annen `krav/`-mappe enn den i repoet.
- Krever Node 24 eller nyere, `glab` innlogget mot gitlab.sikt.no (`glab auth status`) og `unzip`. Mangler innloggingen, be brukeren kjøre `! glab auth login --hostname gitlab.sikt.no`.

Uten domene blir rapporten lang (rundt 180 krav og 100 deler). Skriv den til fil med `--ut`, i et midlertidig område og ikke i repoet, med mindre brukeren sier hvor den skal ligge.

## Rapporten

| Del | Innhold |
| --- | --- |
| Oppsummering | Antall krav per status og per e2e-resultat. |
| Rød | Minst én test med kravets ID feilet. |
| Ustabil eller ikke kjørt | En test besto først på retry (`flaky`), eller ble hoppet over. I en seriell suite gjør ett rødt steg resten «ikke kjørt». |
| Grønn | Alle testene med kravets ID besto. |
| Ikke implementert | Alle krav med status `@draft`, `@planned`, `@in-progress` eller uten status, også dem som har en test. |
| Ikke implementerte deler av implementerte krav | Regler og scenarioer med egen status som ikke er levert, i et krav som er `@implemented` eller `@deprecated`. En regel arver statusen til kravet, og et scenario arver statusen til regelen. |
| Implementert, uten e2e-test | `@implemented` eller `@deprecated`, men ingen test har ID-en. |
| Alle krav | Hele kravlista med status, prioritet, e2e-resultat og fil. |
| Avvik | Tagger på tester som ikke finnes i kravene, ID-er som står i to filer, og feature-filer uten ID. |
| Tester uten krav-tag | Testene i `e2e/tester/` i fs-admin som ikke er koblet til noe krav. Smoketester som bare sjekker at en side vises, skal ikke ha tag. |

## Vis fram

1. Står «Mangler results.json» i toppen, er rapporten ufullstendig: en jobb feilet før Playwright skrev resultatene. Si det først, og ikke tolk tallene for «uten test» som ekte.
2. Vis oppsummeringen i chat: tallene, de røde kravene med testene som feilet, «Ikke implementert» gruppert per domene og status, og avvikene. Lenk til pipelinen, og si hvilken branch og commit kravene er lest fra.
3. Si hvor hele rapporten ligger.
4. Foreslå neste steg der det passer: `fs-verify` for et krav som er grønt, men ikke `@implemented`, og `fs-krav` for doble ID-er og filer uten ID.

## Begrensninger

- «Implementert, uten e2e-test» tar med alle leverte krav, også dem som hører til andre apper enn fs-admin (for eksempel søkersiden i Min kompetanse under `OPT-SØK-SØK`). Gruppen sier at ingen e2e-test i fs-admin dekker kravet, ikke at kravet mangler test.
- Testene er koblet til hele kravet, ikke til en regel eller et scenario. Et grønt krav kan ha regler som ingen test dekker.

## Hva skillen ikke gjør

- Retagger ikke kravene, og endrer ikke feature-filene.
- Endrer ikke testene i fs-admin eller taggene på dem.
- Starter ikke pipelines og kjører ikke Playwright.
- Kjører aldri git add/commit/push.
