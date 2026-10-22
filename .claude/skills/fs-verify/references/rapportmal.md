# Rapportmal for fs-verify

Rapporten fra `fs-verify` og `fs-verify-agent-teams` følger denne malen, så to kjøringer kan sammenlignes linje for linje. Rapporten skrives til fil før brukeren blir spurt, og oppdateres med svarene i samme kjøring (*Rapport og endringer* i `fs-verify`). I chat står bare et sammendrag og lenken (filnavnet står i *Rapport* i `fs-verify`).

## Regler

- **Alle seksjonene står med, i rekkefølgen under.** En seksjon uten innhold får teksten som står i malen (f.eks. «Ingen.»). Ta aldri ut en seksjon, og legg ikke til egne seksjoner. Det som ikke passer noe sted, står under `## Oppfølging`.
- **Varianter** er merket med `[…]` i malen. En linje eller seksjon med et merke er med bare når merket gjelder. Merket skrives ikke i rapporten.
  - `[oppgave]`: scope er en oppgave eller en spesifikasjon.
  - `[agent team]`: kjørt med `fs-verify-agent-teams`.
  - `[per repo]`: repoene er vurdert hver for seg. Bokstavene står i *Kodeklonene* i `fs-verify`: P = fs-plattform, A = fs-admin, M = min-kompetanse. Bare repoene som er med i kjøringen, står i rapporten.
  - `[uansett status]`: brukeren ba om å verifisere uansett status (*Verifisere uansett status* i `fs-verify`). `[ikke uansett status]` er det motsatte.
  - `[flyt]`: scope har en flyt under `krav/_Flyter/` (*Verifisere flyt* i `fs-verify`).
  - `[avhengigheter]`: `@depends-on-` er fulgt minst ett nivå (*Avhengigheter* i `fs-verify`). `[avhengigheter i koden]`: avhengighetene er også verifisert i koden.
  - `[gjennomgang]`: kjøringen er en gjennomgang av en tidligere rapport (*Gjennomgang av en verify-rapport* i `fs-verify`).
  - `[blandet]`: noen krav er verifisert *uansett status*, og andre med det vanlige gating-settet (f.eks. «Annet» i *Omfang og avhengigheter*).
  - `[confluence]`: resultatet er lagt i Confluence (*Confluence* i `fs-verify`). Linja skrives inn etter at siden er laget, i samme kjøring.
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
- **Krav:** `<krav-sti, oppgave eller @scope-<slug>>` (<N> feature-filer)
- **Spec:** `spec/spec-<x>.md`                                         [oppgave, bare når scope er en spesifikasjon]
- **Kode:** `<repo>` (<branch>, <kort sha>, <oppdatert | N bak origin | N bak main | ikke sjekket (Claude-panelet)>), `<repo>` (…)
- **Omfang:** <`@in-progress` | `@deprecated` | flyter | alle krav uansett status | <det brukeren skrev>, skilt med komma> (<valgt | standard, ikke valgt | fra prompten>)
- **Avhengigheter:** ingen | <n> nivå(er), bare status | <n> nivå(er), verifisert i koden | alle nivåer, bare status | alle nivåer, verifisert i koden
- **Bygger på:** `<sti til den forrige rapporten>`                    [gjennomgang]
- **Kontroll:** `fs-verify-kontroll` | manuell (Claude-panelet)
- **Team:** <N> finnere (`fs-verify-krav`), <N> kontrollører (`fs-verify-kontroll`), <N>–<N> feature-filer per finner   [agent team]
- **Skjermbilder:** ja | nei | nei (<grunn>)
- **Confluence:** <url> | <url> (utkast)                                [confluence]

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).   [ikke uansett status]
Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).   [uansett status]
Gating-sett: alle scenarioene, minus `@demo`, for `<@DOM-SUB-KAP-NNN>`, `<@DOM-SUB-KAP-NNN>` (verifisert uansett status), og de som ikke er tagget `@draft`, `@deprecated` eller `@demo` for resten.   [blandet, i stedet for de to over]

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

## Fremdrift for flyter                                                [flyt]

Fremdriften kommer fra statusen på kravene fasene bygger på (`@depends-on-`). Den endrer ingen tagger.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-PRO-FLY-NNN` | <regeltittel> | `@DOM-SUB-KAP-NNN` (`@implemented`), `@DOM-SUB-KAP-NNN` (`@planned`) | ja \| nei \| mangler krav |

`@FLY-PRO-FLY-NNN`: <n> av <N> faser levert.

## Avhengigheter                                                       [avhengigheter]

Kravene i scope bygger på disse kravene (`@depends-on-`, <n> nivå(er) | alle nivåer). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | `@DOM-SUB-KAP-NNN` <tittel> | 1 | `@implemented` \| `@in-progress` \| `@planned` \| `@draft` \| `@deprecated` \| finnes ikke | <n>/<N> \| – | <tom \| ikke levert, `@DOM-SUB-KAP-NNN` kan ikke leveres før dette \| ring: <A → B → A> \| Regel: <tittel>> |

Avhengigheter: <N> på nivå 1, <N> på nivå 2 …, <N> av dem ikke `@implemented`.

### Scenarioer i avhengighetene                                         [avhengigheter i koden]

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | funnet \| ikke funnet \| usikker | <som i `## Scenarioer`> |

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.   [per repo]

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | funnet | `<repo>/<fil>:<linje>` — <hva koden gjør> |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | ikke funnet | <hva som finnes> — søkt etter «<ord>», «<ord>» i <repoer> |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | usikker | `<repo>/<fil>:<linje>` — <hvorfor det er uklart> |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | funnet | P: funnet · A: ikke relevant · M: funnet — `<fil>:<linje>`, `<fil>:<linje>` |   [per repo]
| `@FLY-PRO-FLY-NNN` | <scenariotittel> | funnet | lages: `<repo>/<fil>:<linje>` · brukes: `<repo>/<fil>:<linje>` — <hva som overleveres> |   [flyt]
| `@FLY-PRO-FLY-NNN` | <scenariotittel> | ikke funnet | lages: `<repo>/<fil>:<linje>` · brukes: ikke funnet — søkt etter «<ord>» i <repoer> |   [flyt]
| `@FLY-PRO-FLY-NNN` | <scenariotittel> | ikke funnet | fasen er ikke levert: `@DOM-SUB-KAP-NNN` er `@planned` — ikke søkt |   [flyt]

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | ikke funnet | usikker | `<repo>/<fil>:<linje>` — <hva kontrollen fant> |

Kontrollen endret ingen resultater.                                    [når tabellen er tom, i stedet for den]

## Forslag til endringer

**Kan leveres**

- `@DOM-SUB-KAP-NNN` — <tittel> (`<krav/…/fil.feature>`, `<status>` → `@implemented`, <n>/<n> funnet)
- `@DOM-SUB-KAP-NNN` — Regel: <tittel> (`<krav/…/fil.feature>:<linje>`, `@in-progress` fjernes, <n>/<n> funnet) — bygger på `@DOM-SUB-KAP-NNN`, som er `@planned`   [bak, når kravet bygger på et krav som ikke er levert]

**Delvis levert**

- `@DOM-SUB-KAP-NNN` — <tittel> (`<krav/…/fil.feature>`, `<status>` → `@in-progress`, <n>/<N> funnet) — `@implemented` på: Regel: <tittel> (linje <n>), Scenario: <tittel> (linje <n>)

**Kan slettes**

- `@DOM-SUB-KAP-NNN` — <tittel eller del> (`<krav/…/fil.feature>`, hele fila | blokken) — ingen spor i <repoer>, søkt etter «<ord>», «<ord>» · referanser som fjernes: `<fil>`: `@depends-on-<ID>`

**Blir stående**

- `@DOM-SUB-KAP-NNN` — <tittel> (`<status>`, <n>/<N> funnet) — <hvorfor>

Ingen.                                                                  [under en overskrift uten punkter]

## Levert

Venter på svar.                                                         [før brukeren har svart, i stedet for tabellen]

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <tittel> | `<fil>` | `@in-progress` \| `@planned` \| `@draft` | <n>/<n> |
| `@DOM-SUB-KAP-NNN` | Regel: <tittel> | `<fil>` | `@in-progress` | <n>/<n> |
| `@DOM-SUB-KAP-NNN` | <tittel> (delvis: `@in-progress`, <n> deler `@implemented`) | `<fil>` | `@planned` \| `@draft` \| `@in-progress` | <n>/<N> |

Ingen.                                                                  [når ingenting er levert, i stedet for tabellen]

## Ikke levert

Venter på svar.                                                         [før brukeren har svart, i stedet for tabellen]

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <tittel> | `@in-progress` | <n>/<N> | <N> ikke funnet, <N> usikker |
| `@DOM-SUB-KAP-NNN` | <tittel> | `@draft` | <N>/<N> | Alt funnet. Brukeren valgte «Ikke endre noe» |
| `@DOM-SUB-KAP-NNN` | <tittel> | `@in-progress` | <n>/<N> | Brukeren sa at noe mangler: <hva> |
| `@DOM-SUB-KAP-NNN` | <tittel> | `@in-progress` | <n>/<N> | Brukeren avbrøt gjennomgangen |
| `@DOM-SUB-KAP-NNN` | <tittel> | `@in-progress` | <n>/<N> | Ikke besvart |

Ingen.                                                                  [når alt er levert, i stedet for tabellen]

## Slettet

Venter på svar.                                                         [før brukeren har svart, i stedet for lista]

- `<fil>` (hele kravet)
- `<fil>` — Regel: <tittel>
- Referanse fjernet: `@depends-on-<ID>` | `@ref-<ID>` i `<fil>` (<Egenskap | Regel: <tittel>>)

Ingen.                                                                  [når ingenting er slettet, i stedet for lista]

## Avklaringer                                                         [gjennomgang]

| Feature-ID | Del | Spørsmål | Svar | Endring |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | Scenario: <tittel> | <spørsmålet, slik det ble stilt> | <svaret> | <`ikke funnet` → `funnet` \| `@openquestion` lagt til \| spørsmål fjernet \| foreslått `fs-krav` \| ingen> |

Ingen avklaringer.                                                     [når ingenting ble gått gjennom, i stedet for tabellen]

## @deprecated som fortsatt finnes i koden

- **`<feature-ID>` — <tittel eller del>** (`<fil>`)
  - `<repo>/<fil>:<linje>` — <hva som finnes>

Ingen.                                                                  [når ingenting finnes, i stedet for lista]

## Oppfølging

- **<kort overskrift>:** <funn i koden som ikke er et scenario, men som bør følges opp, med `<fil>:<linje>`>
- **Åpent spørsmål:** `<@DOM-SUB-KAP-NNN>` «<scenario eller regel>» — <spørsmålet fra `# ÅPNE SPØRSMÅL:`>   [ett punkt per `@openquestion` i gating-settet]
- **Ikke sjekket:** <det som ikke kunne sjekkes, og hvorfor, f.eks. et repo som ikke er blant kodeklonene>
- **Krav utenfor scope:** `<fil>` (`<status>`) — <henvisning til `fs-krav` / `fs-specify`>
- **Ikke valgt i denne kjøringen:** `<fil>` (`<status>`) — <det som ikke var med i `Omfang`, f.eks. `@deprecated`>
- **Bygger på krav som ikke er levert:** `<@DOM-SUB-KAP-NNN>` bygger på `<@DOM-SUB-KAP-NNN>` (`<status>`)   [avhengigheter]
- **Levert, men ikke funnet i koden:** `<@DOM-SUB-KAP-NNN>` «<scenario>» — <hva som mangler>   [uansett status, for `@implemented` krav]

Ingen.                                                                  [når det ikke er noe, i stedet for lista]
````

## Om seksjonene

- **`## Oversikt per krav`** `[per repo]`: én rad per krav i scope. `Funnet` er funnet av gating-settet. `Gjenstår` er repoene som må endres, med navn, i rekkefølgen fs-plattform, fs-admin, min-kompetanse og skilt med komma (`fs-plattform`, `fs-admin, min-kompetanse`), eller `ingen`. Skriv aldri «backend», «frontend» eller «begge». Repoene kommer fra radene som ikke er `funnet` (`delvis` og `mangler` teller). Linja under teller kravene per verdi som forekommer, med flest først, og `ingen` til slutt, også med 0. Bokstavene i `Bevis` står i rekkefølgen P, A, M.
- **`## Fremdrift for flyter`** `[flyt]`: én rad per fase, i rekkefølgen i flyten. En fase er levert når alle kravene den bygger på, er `@implemented` (en flyt den bygger på, også). `mangler krav` når fasen ikke har `@depends-on-`. Linja under tabellen står én gang per flyt.
- **`## Avhengigheter`** `[avhengigheter]`: én rad per par (krav i scope, avhengighet), sortert på krav i scope og så nivå. På nivå 2 og lenger er `Krav i scope` kravet i scope kjeden starter i. `Funnet` er `<n>/<N>` av gating-settet (som *uansett status*) når avhengighetene er verifisert i koden, ellers `–`. Merknaden «kan ikke leveres før dette» står bare på nivå 1, når avhengigheten ikke er `@implemented`. Avhengighetene teller ikke i `## Oppsummering`, og radene deres står aldri i `## Scenarioer`, fordi tavla «Oppgaver», `fs-testplan` og `fs-testrapport` leser den tabellen.
- **`## Forslag til endringer`**: det som ble foreslått før brukeren svarte, med stiene til kravene, så forslaget kan leses i fila mens spørsmålene stilles. Står uendret når svarene er gitt; det som faktisk ble gjort, står i `## Levert`, `## Ikke levert` og `## Slettet`.
- **«Venter på svar.»** står i `## Levert`, `## Ikke levert` og `## Slettet` bare mellom at fila skrives og at brukeren har svart. Når kjøringen er ferdig, står det aldri igjen.
- **`## Avklaringer`** `[gjennomgang]`: ett punkt per spørsmål i gjennomgangen, i rekkefølgen de ble stilt. `Endring` sier hva som ble gjort i kravfila eller i resultatet.
- **`## Levert`**: kravene og delene som har fått ny status i denne kjøringen. `Fra` er statusen før. En del (regel eller scenario) skrives som `Regel: <tittel>` eller `Scenario: <tittel>`.
- **`## Ikke levert`**: alle kravene og delene i scope som ble verifisert, men ikke levert, med statusen de fortsatt har. `Hvorfor` er én av formene i malen. Krav som ikke ble verifisert (allerede levert, ikke klare), står under *Krav utenfor scope* i `## Oppfølging`.
- **`## Oppfølging`**: bare funn som ikke står i en annen seksjon. Hvert punkt har en kort overskrift i fet skrift, og `fil:linje` når det handler om kode.
