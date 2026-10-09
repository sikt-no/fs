# Rapportmal for fs-verify

Rapporten fra `fs-verify` og `fs-verify-agent-teams` følger denne malen, så to kjøringer kan sammenlignes linje for linje. Den samme teksten skrives i chat og til fil (filnavnet står i *Rapport* i `fs-verify`).

## Regler

- **Alle seksjonene står med, i rekkefølgen under.** En seksjon uten innhold får teksten som står i malen (f.eks. «Ingen.»). Ta aldri ut en seksjon, og legg ikke til egne seksjoner. Det som ikke passer noe sted, står under `## Oppfølging`.
- **Varianter** er merket med `[…]` i malen. En linje eller seksjon med et merke er med bare når merket gjelder. Merket skrives ikke i rapporten.
  - `[oppgave]`: scope er en oppgave eller en spesifikasjon.
  - `[agent team]`: kjørt med `fs-verify-agent-teams`.
  - `[per repo]`: repoene er vurdert hver for seg. Bokstavene står i *Kodeklonene* i `fs-verify`: P = fs-plattform, A = fs-admin, M = min-kompetanse. Bare repoene som er med i kjøringen, står i rapporten.
  - `[uansett status]`: brukeren ba om å verifisere uansett status (*Verifisere uansett status* i `fs-verify`). `[ikke uansett status]` er det motsatte.
- **Faste tekster** står uten `<…>` og skrives som de står. Det i `<…>` fylles inn. Der det står `a | b`, velges én.
- **Tallene regnes ut** fra tabellen `## Scenarioer` og fra endringene du har gjort (se *Rapport* i `fs-verify`). Tallene i `## Oppsummering`, `## Oversikt per krav` og `Gating funnet` skal stemme med tabellen.
- **`## Scenarioer` leses av FS Kravforvaltning.** Fire kolonner, Feature-ID med `@`, scenariotittelen slik den står i fila, og `Resultat` med små bokstaver: `funnet`, `ikke funnet` eller `usikker`. Resultatet er det som gjelder etter kontrollen.
- **Rekkefølgen på kravene** er den samme i alle tabellene: fila- og mappe-rekkefølgen i `krav/`, og scenarioene i den rekkefølgen de står i fila.
- **Stier** skrives fra rota av repoet (`fs-admin/src/…:12`). Er de lange og går igjen, forkort dem i lista under metadataene, og bruk forkortelsen overalt.
- **Ikke med i rapporten:** step definitions og tester. Si det i chat hvis det er noe å si (*Etter endringene* i `fs-verify`).

## Mal

````markdown
# Verifisering: <scope>

- **Dato:** YYYY-MM-DD HH:MM
- **Krav:** `<krav-sti eller oppgave>` (<N> feature-filer)
- **Spec:** `spec/spec-<x>.md`                                         [oppgave, bare når scope er en spesifikasjon]
- **Kode:** `<repo>` (<kort sha>), `<repo>` (<kort sha>)
- **Kontroll:** `fs-verify-kontroll` | manuell (Claude-panelet)
- **Team:** <N> finnere (`fs-verify-krav`), <N> kontrollører (`fs-verify-kontroll`), <N>–<N> feature-filer per finner   [agent team]
- **Skjermbilder:** ja | nei | nei (<grunn>)

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`.   [ikke uansett status]
Gating-sett: alle scenarioene i scope, også `@draft`, `@planned` og `@openquestion`, minus `@demo` (verifisert uansett status).   [uansett status]

Stiene er forkortet:                                                    [bare når stier er forkortet]

- `<forkortelse>` = `<sti fra rota av repoet>`

## Oversikt per krav                                                   [per repo]

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <tittel> | <n>/<N> | <repo>, <repo> \| ingen | <én til tre setninger> |

Gjenstår: <verdi> <N>, <verdi> <N>, ingen <N>.

## Oppsummering

- Scenarioer: <N> funnet, <N> ikke funnet, <N> usikker, av <N>
- Krav levert (status satt til `@implemented`): <N>
- Deler levert (status fjernet fra delen): <N>
- Krav og deler som ikke er levert: <N>
- Slettet (`@deprecated`): <N> filer, <N> regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: <N>

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.   [per repo]

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | funnet | `<repo>/<fil>:<linje>` — <hva koden gjør> |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | ikke funnet | <hva som finnes> — søkt etter «<ord>», «<ord>» i <repoer> |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | usikker | `<repo>/<fil>:<linje>` — <hvorfor det er uklart> |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | funnet | P: funnet · A: ikke relevant · M: funnet — `<fil>:<linje>`, `<fil>:<linje>` |   [per repo]

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | ikke funnet | usikker | `<repo>/<fil>:<linje>` — <hva kontrollen fant> |

Kontrollen endret ingen resultater.                                    [når tabellen er tom, i stedet for den]

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <tittel> | `<fil>` | `@in-progress` \| `@planned` \| `@draft` | <n>/<n> |
| `@DOM-SUB-KAP-NNN` | Regel: <tittel> | `<fil>` | `@in-progress` | <n>/<n> |

Ingen.                                                                  [når ingenting er levert, i stedet for tabellen]

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <tittel> | `@in-progress` | <n>/<N> | <N> ikke funnet, <N> usikker |
| `@DOM-SUB-KAP-NNN` | <tittel> | `@draft` | <N>/<N> | Alt funnet. Brukeren svarte «Nei» på ny status |
| `@DOM-SUB-KAP-NNN` | <tittel> | `@draft` | <N>/<N> | Alt funnet, men `@openquestion` står igjen |
| `@DOM-SUB-KAP-NNN` | <tittel> | `@in-progress` | <n>/<N> | Brukeren svarte «Noe mangler»: <hva> |
| `@DOM-SUB-KAP-NNN` | <tittel> | `@in-progress` | <n>/<N> | Brukeren svarte «Avbryt» |

Ingen.                                                                  [når alt er levert, i stedet for tabellen]

## Slettet

- `<fil>` (hele kravet)
- `<fil>` — Regel: <tittel>

Ingen.                                                                  [når ingenting er slettet, i stedet for lista]

## @deprecated som fortsatt finnes i koden

- **`<feature-ID>` — <tittel eller del>** (`<fil>`)
  - `<repo>/<fil>:<linje>` — <hva som finnes>

Ingen.                                                                  [når ingenting finnes, i stedet for lista]

## Oppfølging

- **<kort overskrift>:** <funn i koden som ikke er et scenario, men som bør følges opp, med `<fil>:<linje>`>
- **Ikke sjekket:** <det som ikke kunne sjekkes, og hvorfor, f.eks. et repo som ikke er blant kodeklonene>
- **Krav utenfor scope:** `<fil>` (`<status>`) — <henvisning til `fs-krav` / `fs-specify`>

Ingen.                                                                  [når det ikke er noe, i stedet for lista]
````

## Om seksjonene

- **`## Oversikt per krav`** `[per repo]`: én rad per krav i scope. `Funnet` er funnet av gating-settet. `Gjenstår` er repoene som må endres, med navn, i rekkefølgen fs-plattform, fs-admin, min-kompetanse og skilt med komma (`fs-plattform`, `fs-admin, min-kompetanse`), eller `ingen`. Skriv aldri «backend», «frontend» eller «begge». Repoene kommer fra radene som ikke er `funnet` (`delvis` og `mangler` teller). Linja under teller kravene per verdi som forekommer, med flest først, og `ingen` til slutt, også med 0. Bokstavene i `Bevis` står i rekkefølgen P, A, M.
- **`## Levert`**: kravene og delene som har fått ny status i denne kjøringen. `Fra` er statusen før. En del (regel eller scenario) skrives som `Regel: <tittel>` eller `Scenario: <tittel>`.
- **`## Ikke levert`**: alle kravene og delene i scope som ble verifisert, men ikke levert, med statusen de fortsatt har. `Hvorfor` er én av formene i malen. Krav som ikke ble verifisert (allerede levert, ikke klare), står under *Krav utenfor scope* i `## Oppfølging`.
- **`## Oppfølging`**: bare funn som ikke står i en annen seksjon. Hvert punkt har en kort overskrift i fet skrift, og `fil:linje` når det handler om kode.
