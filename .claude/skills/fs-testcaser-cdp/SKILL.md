---
name: fs-testcaser-cdp
description: Lager og oppdaterer de varige CDP-testene i `cdp-tester/`, Gherkin som en agent kjører i Chrome med `cdp`-skillen mot et testmiljø, fra kravene under `krav/` (og testcasene i `akseptansetest/` når de finnes). Valgfritt steg 4b i akseptansetestflyten, og kan også kjøres manuelt, uten testplan, for å lage nye tester eller oppdatere eksisterende når kravene er endret. Hvert scenario i gating-settet som er `@implemented`, blir et uavhengig, konkret scenario med skjermens ord, testbruker og testdata som nøkler (ikke navn), og en `Så` agenten kan se. Referansene til kravene er `@depends-on-<Feature-ID>` (og `@ref-`), identiske `Regel:`- og `Scenario:`-titler, og en header med kravfila og commit og blob-hash, som gir en diff når kravet er endret. Roller og testdata avklares fra samme grunnlag som resten av flyten: testplanens tabeller (kolonnene `Nøkkel`, `Søk/URL`, `Utgangstilstand`, `Brukes av`), eller de samme spørsmålene når testplan mangler. Skriver `cdp-tester/<kravstien>/<fil>.feature` og `README.md` («Krever», «Ikke kjørbart»). Endrer aldri `krav/`. Trigges av "lag CDP-tester", "oppdater CDP-tester", "CDP-kjøring", "cdp-tester", "kjørbare tester for kravet", "tester for CDP", "steg 4b", "fs-testcaser-cdp".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# CDP-tester

## Task

$ARGUMENTS

## Din rolle

Du gjør kravene om til varige tester som en agent kan kjøre i Chrome, uten å gjette. Kravene i `krav/` er deklarative, og sier hva som skal gjelde. Testene her sier hvordan det sjekkes i skjermen: skjermens ord, konkrete verdier og noe som kan ses. Konvensjonene står i [`cdp-tester/README.md`](../../../cdp-tester/README.md).

Steget er valgfritt i akseptansetestflyten (steg 4b i [`akseptansetest/README.md`](../../../akseptansetest/README.md)), og kan også kjøres manuelt.

- **Kravene er fasit for hva som testes.** Testene dekker gating-settet som er `@implemented`, i rekkefølgen i feature-fila. Endre aldri kravene eller taggene i `krav/`. Er et scenario ikke testbart som det står (uklart, mangler forventet resultat, motsier koden), noter det i «Ikke kjørbart», og foreslå `fs-krav`.
- **Testene er varige.** De overlever testplaner og akseptansetester. Derfor har de nøkler for testbruker og testdata, aldri navn, Feide-ID eller `testbruker <nr>`, og ingen miljø-URL.
- **Samme grunnlag som resten av flyten.** Roller og testdata kommer fra testplanen, eller fra de samme spørsmålene når den mangler: [`.claude/references/akseptansetest/roller-og-testdata.md`](../../references/akseptansetest/roller-og-testdata.md). Spør aldri teamet om noe testplanen allerede svarer på.
- **Gjett aldri det bare teamet vet.** Det som mangler, står som `[Fylles ut: <hva>]`, og scenarioet kjøres ikke før det er utfylt.
- **Overskriv aldri håndrettede scenarioer.** Finnes testfila fra før, vis en diff og foreslå.
- **Alltid et testmiljø, aldri produksjon.**
- **Publiser aldri til Confluence uten ja.** Se [`confluence.md`](../../references/akseptansetest/confluence.md).

## I FS Kravforvaltning

Skillen står ikke i lista over skills i Claude-panelet ennå, så den brukes fra Claude Code i terminalen. Uten Bash: bruk `Grep` og `Glob` i stedet for `grep` og `git`, og skriv `commit ikke sjekket (Claude-panelet)` i headeren.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md), og i kodeklonene du leser. Er den bak, spør før du henter.

## Kilder (les FØRST)

1. [`cdp-tester/README.md`](../../../cdp-tester/README.md): mappestrukturen, Gherkin-reglene, referansene og «Krever».
2. [`references/mal-cdp.md`](references/mal-cdp.md): malene for testfila, `README.md` og resultatet.
3. [`.claude/references/akseptansetest/roller-og-testdata.md`](../../references/akseptansetest/roller-og-testdata.md): spørsmålene og kolonnene.
4. [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md): kravene i en testplan, og gating-settet.
5. [`.claude/references/akseptansetest/testcase-regler.md`](../../references/akseptansetest/testcase-regler.md): R1 (testbrukeren står i testen), R4 (ordene fra skjermen), R5 (alle verdiene), R7 (forventet resultat kan ses) og R8 (sjekk at det er lagret) gjelder også her. R10 (avhengigheter mellom testcaser) gjelder ikke: CDP-scenarioene er uavhengige.
6. [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md) før du leser fra eller skriver til Confluence.

## 1. Avgjør måten

Argumentet avgjør:

| Argument | Måte |
|---|---|
| en testplan (`akseptansetest/<slug>`, eller en slug som finnes der) | **Fra flyten (steg 4b).** Kravene er de i «Omfang» i testplanen. Roller, testdata og miljø fra testplanens tabeller |
| krav: en feature-fil, en mappe, `@scope-<slug>`, en oppgave eller en Feature-ID | **Manuelt.** Kravene finnes etter *Finn kravene* i `krav-fra-testplan.md` |
| en eksisterende test i `cdp-tester/` | **Manuelt, oppdatering** (se steg 5) |

Er det uklart, spør (`AskUserQuestion`).

**Fra flyten:** les `testplan.md`, og siden i Confluence når den finnes (teamet kan ha fylt ut mer der). Har teamet ikke svart ja på CDP-spørsmålet («Skal en CDP-agent kjøre testene?»), si det, og spør om det skal endres i testplanen (`fs-testplan`) eller om du skal fortsette manuelt.

**Manuelt:** finn en testplan som dekker kravene (`grep -rl "<Feature-ID>" akseptansetest/*/testplan.md`, nyeste først), og bruk tabellene i den når den har kolonnen `Nøkkel`. Finnes ingen, spør du etter en konkret verdi per nøkkel (steg 3), og bruker svarene bare til denne kjøringen: de lagres ikke i testene. Foreslå `fs-testplan` for å lagre dem, men krev det ikke.

## 2. Finn scenarioene og ordene

1. Kravene og gating-settet per krav, som i `krav-fra-testplan.md`. Bare krav som er `@implemented` (og de leverte delene i et endret krav) blir tester. Manuelt på et krav som ikke er `@implemented`: si det, og spør om det skal lages likevel (testen kjøres ikke før kravet er levert).
2. Les verify-rapporten for kravene når den finnes. Et scenario som er `ikke funnet` eller `usikker` der, kommer i «Ikke kjørbart» til teamet har svart.
3. **Ordene fra skjermen:** `testcaser-intern.md` når den finnes (ordene og verdiene, uten avhengighetene mellom casene), `<feature>.design.md` og skissene, og koden (fs-admin for saksbehandlere og forvaltere, min-kompetanse for søkeren): menyer, ruter, felt, knapper, `Så`-tekster og feilmeldinger. Se *Lese koden* i `roller-og-testdata.md`. Merk det du ikke finner, `[Sjekk begrep]`.
4. **Hva agenten kan se:** noe som ikke finnes i miljøet, eller som ikke kan ses i skjermen, kommer i «Ikke kjørbart», med grunn.

## 3. Nøkler: roller og testdata

1. Fra scenarioene (`Gitt`-stegene og rollene i kravet): lag nøklene for testbrukere og testdata, i kebab-case uten æ, ø og å. Skriv dem i seksjonen «Krever» i `cdp-tester/<sti>/README.md`, med en beskrivelse (ikke et navn) og hvilke scenarioer som bruker dem.
2. Slå opp hver nøkkel i testplanen (kolonnen `Nøkkel`, og `Brukes av`), eller spør etter en konkret verdi manuelt med spørsmålene i `roller-og-testdata.md`. Mangler nøkkelen i testplanen eller svaret, står den som `[Fylles ut: <hva>]` i oppsummeringen, og scenarioet kjøres ikke.
3. Stopp hvis en verdi ser ut som et ekte fødselsnummer eller et ekte navn.

## 4. Skriv testene

For hvert krav, skriv `cdp-tester/<kravets sti under krav/>/<samme filnavn som kravet>`, etter malen:

- Header med kravfila, commit og blob-hash (`git rev-parse origin/main:<sti>`), og hva den er generert fra. Taggene: `@TST-…` og `@depends-on-<Feature-ID>` på `Egenskap:`. For en test som går over flere domener: `cdp-tester/_Løp/<NN Prosess>/<test>.feature`, med ett `@depends-on-` per krav.
- `Regel:`- og `Scenario:`-titlene identiske med kravets. En `Scenariomal:` gir én rad i `Eksempler:` per eksempel i kravet.
- `Gitt` har testbruker som nøkkel, start (menyvei eller URL, med ordene fra skjermen), og testdata som nøkler. Aldri «fra forrige scenario».
- `Når`: én handling per steg, skjermens ord i «», alle verdier med.
- `Så`: noe agenten ser. Gjør kravets generelle `Så` konkret (en tekst, et antall, noe synlig eller borte). Lagrer scenarioet noe, åpnes siden på nytt før `Så`.
- `@endrer-data` på scenarioet når det endrer data, med avsluttende steg som setter tilbake.
- Scenarioer som ikke kan kjøres, står ikke i fila, men i «Ikke kjørbart» i `README.md`, med grunn og når det kan kjøres.

Sjekkliste før du viser fram:

| # | Sjekk |
|---|---|
| 1 | Hvert scenario i gating-settet er generert eller står i «Ikke kjørbart» |
| 2 | Ingen filer i `krav/` er endret, og ingen test ligger der |
| 3 | Ingen testfil har navn, Feide-ID, `testbruker <nr>`, passord eller miljø-URL |
| 4 | Hvert scenario er uavhengig, og har en `Så` agenten kan se |
| 5 | Referansene er sjekket (se under) |
| 6 | Det som må fylles ut, er merket `[Fylles ut …]` eller `[Sjekk begrep]`, og står i oppsummeringen |

**Referansesjekken** (ved hver generering og oppdatering):

1. Hver `@depends-on-` og `@ref-` peker på en Feature-ID som finnes i nøyaktig én feature-fil under `krav/`.
2. Hver `Regel:` og hvert `Scenario:` finnes i den fila med samme tittel.
3. Hash i headeren er lik hash for kravfila nå. Er den ulik, er testen utdatert (se steg 5).
4. Hvert scenario i gating-settet er generert eller står i «Ikke kjørbart».

## 5. Oppdatere eksisterende tester

Finnes testfila fra før:

1. Sammenlign blob-hashen i headeren med kravfila nå. Er de like, og ingen nye `@implemented`-scenarioer er kommet til, er det ingenting å gjøre.
2. Ellers, list hva som er endret i kravet: nye, endrede og fjernede `Regel:` og `Scenario:`, med titlene (`git diff <commit-i-headeren>..origin/main -- <kravfila>`).
3. Vis forslaget som en diff mot testfila. Scenarioer som er rettet for hånd (andre steg enn skillen ville skrevet), nevnes, og skrives aldri over uten ja.
4. Skriv det brukeren godkjenner, og oppdater headeren (commit, hash, dato) og «Krever» og «Ikke kjørbart».
5. Fjernede krav: foreslå å slette testen, men slett aldri uten ja.

## 6. Vis fram

Vis en kort oppsummering: antall tester og scenarioer generert (og endret, ved oppdatering), antall `@endrer-data`, «Ikke kjørbart» med grunner, nøklene som mangler og det som må fylles ut. Skriv aldri til Confluence uten ja.

Si hva som er neste steg: kjør testene med `cdp`-skillen (se *Før en kjøring*), eller `fs-testplan` for å fylle ut nøklene.

## Før en kjøring

`cdp`-skillen har ingen sikkerhetsregler. Gjelder for agenten som kjører testene, og står her fordi det er `fs-testcaser-cdp` som lager det som kjøres:

- **Miljø-guard.** Før første handling: sjekk at URL-en er testmiljøet fra testplanen (eller det brukeren oppga), og avbryt hvis den er produksjon eller et annet domene enn FS Admin og Feide.
- **Lesende kjøring som standard.** Scenarioer med `@endrer-data` hoppes over til brukeren ber om dem. Aldri `Fetch.*`, `Network.setCookie(s)`, `Storage.clear*` eller `clearBrowserCookies`, og aldri `handleJavaScriptDialog({accept:true})` uten at scenarioet sier hva dialogen er (eksemplene i `dialogs.md` aksepterer alt).
- **Tilkobling.** `cdp`-skillen kobler til brukerens kjørende Chrome (`chrome://inspect/#remote-debugging`, brukeren klikker Allow), og agenten ser alle cookies i profilen. Bruk en egen Chrome-profil per testbruker (`--user-data-dir`), og la brukeren logge inn med Feide testbruker selv. Bytte av testbruker er bytte av profil, ikke cookies.
- **Bevis.** Tekst og DOM (`Runtime.evaluate`) er primærbevis, skjermbilder sekundære. Tell rader i skjermen, ikke via GraphQL: et direkte API-kall kan gi flere rader enn løsningen viser. Resultatet skrives til `kjoring-<YYYY-MM-DD-HHMM>/resultat.md` (se malen), aldri til `/tmp`. Skjermbilder legges i samme mappe, men er ignorert av git (`.gitignore`): bare `resultat.md` committes, og den viser til bildene som «lokalt, ikke i git».
- **Installasjon.** `browser-harness-js` og `bun` må være installert av brukeren. Serveren lytter uautentisert på `127.0.0.1:9876`. Avslutt med `browser-harness-js --stop` etter kjøringen.
- **Foreslå, ikke fyll ut.** Agenten skriver foreslått status. En tester bekrefter den. Ingen «Status» på testcaser eller i testrapporten fylles ut av agenten.

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene, scope-fila eller `oppgave.md`.
- Kjører ikke testene. Den lager og oppdaterer dem, og sier hvordan de kjøres.
- Lager ikke testcasene (`fs-testcaser-intern`, `fs-testcaser-ekstern`), testplanen (`fs-testplan`) eller rapportene (`fs-testrapport`).
- Kjører aldri git add/commit/push, og kjører aldri `git pull` i kodeklonene.
