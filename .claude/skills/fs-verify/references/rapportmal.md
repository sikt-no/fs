# Rapportmal for fs-verify

Rapporten fra `fs-verify` og `fs-verify-agent-teams` følger denne malen, så to kjøringer kan sammenlignes. Rapporten er resultatet av kjøringen: den skrives til fil, og brukeren får et kort sammendrag i chat og blir bedt om å gå gjennom rapporten (*Rapport og oppsummering* i `fs-verify`). I kjøringen settes bare det som er sikkert, til `@implemented`, når brukeren sier ja. Resten gjøres når brukeren gir rapporten tilbake (*Gjennomgang av en verify-rapport*).

## Regler

- **Avvikene først, det som stemmer kort.** Det leseren skal ta stilling til, står øverst: forslaget, det som er usikkert og avvikene. Tabellene står etter forslaget, som grunnlag, med det som avviker først i hver tabell, og `## Andre funn` står til slutt. En rad som er som forventet (`funnet`, `stemmer`), har bare `fil:linje` som bevis, uten forklaring. Forklaringen står på radene som avviker (`ikke funnet`, `usikker`, `avviker`).
- **Seksjonene står i rekkefølgen under.** `## Oppsummering`, `## Forslag til endringer` og `## Scenarioer` er alltid med. De andre seksjonene tas bare med når de har innhold. Legg ikke til egne seksjoner: det som ikke passer noe sted, er en rad i `## Andre funn` (typen `Merknad`).
- **Varianter** er merket med `[…]` i malen. En linje eller seksjon med et merke er med bare når merket gjelder. Merket skrives ikke i rapporten.
  - `[spesifikasjon]`: scope er en spesifikasjon (`spec/spec-*.md` i et scope).
  - `[agent team]`: kjørt med `fs-verify-agent-teams`.
  - `[per repo]`: repoene er vurdert hver for seg (mer enn én kodeklone, eller brukeren ba om det). Bokstavene og merkene står i *Per repo* under *Kodeklonene* i `fs-verify`: P = fs-plattform, A = fs-admin, M = min-kompetanse, og ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant. Bare repoene som er med i kjøringen, står i rapporten.
  - `[uansett status]`: brukeren ba om å verifisere uansett status (*Verifisere uansett status* i `fs-verify`). `[ikke uansett status]` er det motsatte. `[blandet]`: noen krav uansett status, andre med det vanlige gating-settet.
  - `[flyt]`: scope har en flyt under `krav/_Flyter/` (*Verifisere flyt* i `fs-verify`).
  - `[avhengigheter]`: `@depends-on-` er fulgt minst ett nivå (*Avhengigheter* i `fs-verify`). `[avhengigheter i koden]`: avhengighetene er også verifisert i koden.
  - `[gjennomgang]`: en gjennomgang av en tidligere rapport (*Gjennomgang av en verify-rapport* i `fs-verify`).
  - `[confluence]`: resultatet er lagt i Confluence (*Confluence* i `fs-verify`).
- **Hver seksjon starter med en kort beskrivelse** av hva den inneholder, rett under overskriften: den faste teksten i malen, én eller to setninger. Den står også i en seksjon uten innhold, men ikke i metadataene øverst.
- **Teamvisningen** (*Teamvisning* i `fs-verify`) lages fra rapporten med `references/teamvisning/bygg.mjs`, som leser metadataene, seksjonene og tabellene i denne malen. Endres en seksjon, en kolonne eller en fast tekst som skriptet leser (f.eks. `Repoer`, merkene i `Bevis`, `### Avvik` og `### Stemmer`), oppdateres `bygg.mjs` i samme endring.
- **Faste tekster** står uten `<…>` og skrives som de står. Det i `<…>` fylles inn. Der det står `a | b`, velges én.
- **Tallene regnes ut** fra tabellen `## Scenarioer` (se *Rapport* i `fs-verify`). Tallene i `## Oppsummering`, `## Oversikt per krav` og `## Forslag til endringer` skal stemme med tabellen.
- **`## Scenarioer` leses av FS Kravforvaltning.** Fire kolonner, Feature-ID med `@`, scenariotittelen slik den står i fila, og `Resultat` med små bokstaver: `funnet`, `ikke funnet` eller `usikker`. Resultatet er det som gjelder etter kontrollen. Alle scenarioene i gating-settet har en rad, også de som er funnet.
- **Rekkefølgen på kravene** er den samme i alle tabellene: fil- og mapperekkefølgen i `krav/`, og scenarioene i den rekkefølgen de står i fila. I `## Scenarioer` står `ikke funnet` og `usikker` først, og så `funnet`, hver gruppe i den rekkefølgen.
- **Stier** skrives fra rota av repoet (`fs-admin/src/…:12`). Er de lange og går igjen, forkort dem i lista under metadataene, og bruk forkortelsen overalt.
- **Ikke med i rapporten:** step definitions og tester. Si det i chat hvis det er noe å si (*Etter endringene* i `fs-verify`).

## Mal

````markdown
# Verifisering: <scope>

- **Dato:** YYYY-MM-DD HH:MM
- **Krav:** `<krav-sti eller @scope-<slug>>` (<N> feature-filer)
- **Spec:** `spec/spec-<x>.md`                                         [spesifikasjon]
- **Kode:** `<repo>` (<branch>, <kort sha>, <oppdatert | N bak origin | N bak main | ikke sjekket (Claude-panelet)>), `<repo>` (…)
- **Repoer:** P = fs-plattform, A = fs-admin, M = min-kompetanse · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant   [per repo, bare repoene som er med]
- **Åpne MR-er:** ingen funnet | <N> MR-er i <repo>, <N> i <repo> (<N> med kode for kravene) | ikke sjekket (Claude-panelet)
- **Omfang:** <`@in-progress` | `@deprecated` | flyter | alle krav uansett status | <det brukeren skrev>, skilt med komma> (<valgt | standard, ikke valgt | fra prompten>)
- **Avhengigheter:** ingen | <n> nivå(er), bare status | <n> nivå(er), verifisert i koden | alle nivåer, bare status | alle nivåer, verifisert i koden
- **Bygger på:** `<sti til den forrige rapporten>`                    [gjennomgang]
- **Kontroll:** `fs-verify-kontroll` | manuell (Claude-panelet)
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** <N> finnere (`fs-verify-krav`), <N> kontrollører (`fs-verify-kontroll`)   [agent team]
- **Skjermbilder:** ja | nei | nei (<grunn>)
- **Confluence:** <url> | <url> (utkast)                                [confluence]

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).   [ikke uansett status]
Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).   [uansett status]
Gating-sett: alle scenarioene, minus `@demo`, for `<@DOM-SUB-KAP-NNN>` (verifisert uansett status), og de som ikke er tagget `@draft`, `@deprecated` eller `@demo` for resten.   [blandet, i stedet for de to over]

Stiene er forkortet:                                                    [bare når stier er forkortet]

- `<forkortelse>` = `<sti fra rota av repoet>`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: <N> funnet, <N> ikke funnet, <N> usikker, av <N>
- Mangler: fs-plattform <N> scenarioer, fs-admin <N>, min-kompetanse <N> (<N> usikker)   [per repo]
- Forslag: <N> kan leveres, <N> delvis levert, <N> kan slettes, <N> kan leveres når det er avklart, <N> blir stående
- Tilgang og datakonsistens: <N> stemmer, <N> avviker, <N> ikke funnet, <N> usikker, av <N>
- Regler i koden uten scenario: <N>
- Åpne spørsmål: <N> regler og <N> scenarioer i gating-settet, <N> utenfor gating (`@draft`)
- Endringer gjort: <N> krav og <N> deler fikk ny status, <N> filer og <N> blokker slettet   [når noe er endret]

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Kan leveres**

- `@DOM-SUB-KAP-NNN` — <tittel> (`<krav/…/fil.feature>`): `<status>` → `@implemented`, <n>/<n> funnet `[P ✓ · A ✓ · M –]`   [per repo: merket]
- `@DOM-SUB-KAP-NNN` — Regel: <tittel> (`<krav/…/fil.feature>:<linje>`): `@in-progress` fjernes, <n>/<n> funnet — bygger på `@DOM-SUB-KAP-NNN`, som er `@planned`   [bak, når kravet bygger på et krav som ikke er levert]

**Delvis levert**

- `@DOM-SUB-KAP-NNN` — <tittel> (`<krav/…/fil.feature>`, <n>/<N> funnet): `<@draft | @planned>` → `@in-progress`, og `@implemented` på Regel: <tittel> (linje <n>), Scenario: <tittel> (linje <n>) `[P ✓ · A ✓]`   [per repo: merket for de leverte delene]
- `@DOM-SUB-KAP-NNN` — <tittel> (`<krav/…/fil.feature>`, <n>/<N> funnet): `@implemented` på Regel: <tittel> (linje <n>), Scenario: <tittel> (linje <n>)   [egenskapen er allerede `@in-progress`]

**Kan slettes**

- `@DOM-SUB-KAP-NNN` — <tittel eller del> (`<krav/…/fil.feature>`, hele fila | blokken): ingen spor i <repoer>, søkt etter «<ord>», «<ord>» · referanser som fjernes: `<fil>`: `@depends-on-<ID>`

**Kan leveres når det er avklart**

- `@DOM-SUB-KAP-NNN` — <Regel: tittel | Scenario: tittel | tittel> (`<krav/…/fil.feature>:<linje>`): kan få `@implemented` | kan få ny status `<status>` hvis <det som må avklares> — «<scenario>» (`krav/…:<linje>`) er `usikker` | `ikke funnet` `[P ✓ · A ✗]`: `<repo>/<fil>:<linje>` <hva koden gjør> · mangler i <repo> (<n>), <repo> (<n>)   [per repo: merket og «mangler i»]
- `@DOM-SUB-KAP-NNN` — <del> (`<krav/…/fil.feature>:<linje>`): funnet i koden, men har ingen statustag (`<repo>/<fil>:<linje>`). Verifiser med kravet i scope.   [avhengighet, eller del som ikke var i omfanget]

**Blir stående**

- `@DOM-SUB-KAP-NNN` — <tittel> (`<status>`, <n>/<N> funnet): <hvorfor, f.eks. 1 ikke funnet: «<scenario>»> · mangler i <repo> (<n>), <repo> (<n>)   [per repo: «mangler i»]
- `@DOM-SUB-KAP-NNN` — <tittel eller del> (`@deprecated`): finnes fortsatt i `<repo>/<fil>:<linje>` — <hva som finnes>

                                                                        [en liste uten punkter tas bort, med overskriften]

## Endringer

Det som er endret i kravfilene og i resultatet: i kjøringen (det sikre, når brukeren sa ja) og i gjennomgangen av rapporten.

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <tittel> \| Regel: <tittel> \| Scenario: <tittel> | `@in-progress` → `@implemented` \| `@in-progress` fjernet \| `@implemented` på delen \| slettet \| referanse fjernet i `<fil>` \| `@openquestion` lagt til \| spørsmål fjernet \| `ikke funnet` → `funnet` \| ingen | <spørsmålet og svaret, kort> \| ja i kjøringen |

Ingen endringer. Brukeren sa nei. | Ingen endringer. Ikke besvart.   [når det var noe å sette, men brukeren ikke sa ja, i stedet for tabellen]

## Oversikt per krav                                                   [per repo]

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Mangler i M | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <tittel> | <n>/<N> | <n> \| <n> (<n> usikker) \| 0 \| – | <…> | <…> | <én setning, tom når ingenting mangler> |

Mangler: fs-plattform <n> scenarioer i <n> krav, fs-admin <n> i <n> krav, min-kompetanse <n> i <n> krav (<n> usikker). <n> av <N> krav er funnet i alle repoene. | Alle kravene mangler noe. | Ingen av kravene mangler noe.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P`, `A` og `M` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Fremdrift for flyter                                                [flyt]

Hvilke faser i flyten som er levert, ut fra statusen på delene av kravene fasen bygger på.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-PRO-FLY-NNN` | <regeltittel> | `@DOM-SUB-KAP-NNN` (`@implemented`), `@DOM-SUB-KAP-NNN` (`@in-progress`, Regel: <tittel> levert) | ja \| nei \| mangler krav |

`@FLY-PRO-FLY-NNN`: <n> av <N> faser levert.

### Kravene flytene bygger på                                         [flyt]

Scenarioene i kravene fasene bygger på (delene ankeret peker på), per flyt og krav. `Levert` er statusen fra taggene, og `Funnet i koden` er resultatet av verifiseringen. Fasene med `@wont` er ikke med.

| Flyt | Krav | Egenskap | Status | Levert | Funnet i koden | Ikke levert | Levert, men ikke funnet i koden |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `@FLY-PRO-FLY-NNN` | `@DOM-SUB-KAP-NNN` | <tittel> | `@<status>` | <n>/<N> | <n>/<N> \| – | «<scenario>» (`:<linje>`, <funnet \| ikke funnet \| usikker \| ikke sjekket i koden>); … \| – | «<scenario>» (`:<linje>`, <ikke funnet \| usikker>); … \| – |

`@FLY-PRO-FLY-NNN`: <n> av <N> scenarioer i <N> krav er levert, og <n> av <N> er funnet i koden (<n> har bare status fra taggene).

## Avhengigheter                                                       [avhengigheter]

Kravene som kravene i scope bygger på (`@depends-on-`), med statusen deres. Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | `@DOM-SUB-KAP-NNN` <tittel> | 1 | `@implemented` \| `@in-progress` \| `@planned` \| `@draft` \| `@deprecated` \| finnes ikke | <n>/<N> \| – | <tom \| ikke levert \| ring: <A → B → A> \| Regel: <tittel>> |

### Scenarioer i avhengighetene                                         [avhengigheter i koden]

Resultatet for scenarioene i avhengighetene, verifisert i koden. De teller ikke i `## Oppsummering`.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | funnet \| ikke funnet \| usikker | <som i `## Scenarioer`> |

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | funnet | `<repo>/<fil>:<linje>` |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | funnet | P ✓ · A ✓ · M – — `<fil>:<linje>`, `<fil>:<linje>` |   [per repo: merket for alle repoene som er med]
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | ikke funnet | <hva som finnes> — søkt etter «<ord>», «<ord>» i <repoer> |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | ikke funnet | P ✓ · A ✗ — `<fil>:<linje>`; søkt etter «<ord>», «<ord>» i <repo> |   [per repo: merket for alle repoene, også de som mangler]
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | ikke funnet | ikke funnet på <branch> — finnes i MR !<iid> (åpen, <repo>, <source_branch>): `<fil>:<linje>` — <hva koden gjør> |   [MR]
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | usikker | `<repo>/<fil>:<linje>` — <hvorfor det er uklart, med begge synene når finner og kontroll er uenige> |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | usikker | P ✓ · M ~ — `<fil>:<linje>`: <hvorfor det er uklart> |   [per repo]
| `@FLY-PRO-FLY-NNN` | <scenariotittel> | funnet | lages: `<repo>/<fil>:<linje>` · brukes: `<repo>/<fil>:<linje>` |   [flyt]
| `@FLY-PRO-FLY-NNN` | <scenariotittel> | ikke funnet | fasen er ikke levert: `@DOM-SUB-KAP-NNN` er `@planned` |   [flyt]

## Tilgang og datakonsistens

Om koden gir rollene tilgang slik kravet sier, holder data fra andre organisasjoner utenfor, og ikke gir foreldreløse eller motstridende data ved sletting og endring. Sjekket på kodenivå, ikke testet. Radene er grunnlaget for testbrukerne i testplanen.

### Avvik

Sjekkene der koden ikke gjør det kravet sier, kravet ikke sier noe, eller tilgangssjekken ikke er funnet. Det kravet ikke beskriver, står også i `## Regler uten scenario`.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | tilgang \| organisasjon \| konsistens | <rolle> <handling> <hva> | avviker \| ikke beskrevet \| ikke funnet \| usikker | kravet sier <…> (<scenario eller regel> \| ikke beskrevet), koden gjør <…> — `<repo>/<fil>:<linje>` |

Ingen.   [når alle sjekkene stemmer, i stedet for tabellen]

### Stemmer

Sjekkene der koden gjør det kravet sier.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | tilgang \| organisasjon \| konsistens | <rolle> <oppretter \| leser \| endrer \| sletter> <hva> | stemmer | `<repo>/<fil>:<linje>` |

Ingen.   [når ingen sjekker stemmer, i stedet for tabellen]

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <hva regelen gjør, med verdier, grenser eller meldingen> | validering \| obligatorisk felt \| grense \| standardverdi \| tilgangssjekk \| tilstandsovergang \| annet | `<repo>/<fil>:<linje>` | legg til scenario med `fs-krav` \| testes i fase 2 \| uklart om ønsket \| dekkes av `@draft`-scenario: <tittel> |

## Åpne spørsmål

Hvor mange regler og scenarioer i hvert krav som har `@openquestion`. Spørsmålene stopper ikke leveransen, men står i testplanen til de er besvart.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <tittel> | <n> av <N> | <n> av <N> | <n> |

## Åpne MR-er og brancher

MR-er og brancher som ser ut til å levere kravene. Koden i disse er ikke merget, og regnes ikke som levert.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `<repo>` | [!<iid> <tittel>](<web_url>) (`<source_branch>`) | åpen \| utkast \| branch uten MR | `@DOM-SUB-KAP-NNN` | <n>/<N> | <tom \| bak main \| konflikter \| usikker kobling> |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Kravet er bak koden | `@DOM-SUB-KAP-NNN` | <regel, scenario eller det det gjelder> | <hva koden gjør som kravet ikke sier>, `<repo>/<fil>:<linje>` |
| Kontrollen endret | `@DOM-SUB-KAP-NNN` | «<scenario eller rad>» | <før> → <etter>: <hva kontrollen fant> |   [én rad per resultat kontrollen endret]
| Åpent spørsmål | `@DOM-SUB-KAP-NNN` | «<scenario eller regel>» (`krav/…:<linje>`) | <spørsmålet fra `# ÅPNE SPØRSMÅL:`> |
| Bygger på krav som ikke er levert | `@DOM-SUB-KAP-NNN` | – | bygger på `@DOM-SUB-KAP-NNN` (`<status>`) |   [avhengigheter]
| Levert, men ikke funnet i koden | `@DOM-SUB-KAP-NNN` | «<scenario>» (`krav/…:<linje>`) | <hva som mangler> |   [uansett status, for `@implemented` krav]
| Ikke sjekket | – | <repo eller det som ikke kunne sjekkes> | <hvorfor> |
| Ikke valgt i denne kjøringen | `@DOM-SUB-KAP-NNN` | `<fil>` (`<status>`) | <det som ikke var med i `Omfang`> |
| Krav utenfor scope | `@DOM-SUB-KAP-NNN` | `<fil>` (`<status>`) | <henvisning til `fs-krav` / `fs-specify`> |
| Merknad | `@DOM-SUB-KAP-NNN` | <det det gjelder> | <f.eks. delvis levert uten spesifikasjon, ring i `@depends-on-`, krav som bygde på et slettet krav, forslag om kjent brudd i en flyt> |

````

## Om seksjonene

- **`## Oppsummering`**: tallene for hele kjøringen. `Forslag` teller punktene i hver liste i `## Forslag til endringer`. Linja `Endringer gjort` står når noe er endret.
- **`## Forslag til endringer`**: hva som kan endres i kravene, ut fra resultatene. Står uendret etter at brukeren har svart: det som faktisk ble gjort, står i `## Endringer`. Et punkt er sikkert (*Kan leveres*, *Delvis levert*) bare når alle scenarioene i kravet eller delen er `funnet`, og kontrollen har bekreftet hver rad uten å endre den. Med manuell kontroll (Claude-panelet) står det i spørsmålet. *Kan slettes* er aldri sikkert, fordi et søk uten treff ikke er bevis, og gjøres i gjennomgangen. *Kan leveres når det er avklart* er kravene og delene som kan få ny status når et usikkert eller ikke funnet scenario er avklart, krav der alt er `funnet`, men kontrollen endret en rad (det som må avklares, er «bekreft raden kontrollen endret»), og deler som er funnet i koden, men ikke har statustag (også i avhengighetene, som bare kan få ny status når de verifiseres med seg selv i scope). Et krav kan stå både her og under *Blir stående*: her med det som må avklares, der med resten.
- **`## Endringer`**: det som ble gjort i kravfilene og i resultatet: i kjøringen (de sikre, `Avklart` er «ja i kjøringen»), og i gjennomgangen, i rekkefølgen spørsmålene ble stilt. Seksjonen er med når det var noe å sette eller avklare.
- **`## Oversikt per krav`** `[per repo]`: én rad per krav, og én `Mangler i`-kolonne per repo som er med i kjøringen. Tallene regnes ut fra merkene i `Bevis` i `## Scenarioer`: ✗ og ~ i repoet. Summeringslinja under tabellen og linja `Mangler` i `## Oppsummering` regnes ut fra de samme merkene. I tekst skrives repoene med navn (fs-plattform, fs-admin, min-kompetanse). Skriv aldri «backend», «frontend» eller «begge».
- **`## Fremdrift for flyter`** `[flyt]`: én rad per fase, i rekkefølgen i flyten. En fase er levert når delen av hvert krav den bygger på, er levert (*To statuser* i `krav/README.md`). `mangler krav` når fasen ikke har `@depends-on-`.
- **`### Kravene flytene bygger på`** `[flyt]`: én rad per flyt og krav, med scenarioene i delen fasene bygger på (lest som i *Anker*, et scenario tas med én gang per flyt). `Levert` regnes ut fra taggene, som fremdriften. `Funnet i koden` regnes ut fra `### Scenarioer i avhengighetene` og `## Scenarioer`, og er `–` for krav som bare har status fra taggene. `Ikke levert` lister scenarioene som ikke er levert, med resultatet i koden, og `Levert, men ikke funnet i koden` scenarioene som er tagget som levert, men ikke er funnet. Teamvisningen viser tabellen øverst, med tallene per flyt og en liste per krav.
- **`## Avhengigheter`** `[avhengigheter]`: én rad per par (krav i scope, avhengighet). Avhengighetene teller ikke i `## Oppsummering`, og radene deres står aldri i `## Scenarioer`, fordi tavla «Scopes», `fs-testplan` og `fs-testrapport` leser den tabellen.
- **`## Tilgang og datakonsistens`**: én rad per sjekk (rolle × handling × organisasjon), også de som stemmer, fordi `fs-testplan` lager testbrukerne fra radene. Radene deles i to tabeller: `### Avvik` først (`avviker`, `ikke beskrevet`, `ikke funnet` og `usikker`), så `### Stemmer`. Begge har de samme kolonnene, og rekkefølgen på kravene er den samme i begge. `organisasjon` gjelder at data fra en annen organisasjon verken kan ses eller endres, og `konsistens` at sletting og endring ikke gir foreldreløse eller motstridende data.
- **`## Regler uten scenario`** og **`## Åpne spørsmål`**: leses av `fs-testplan`. `Regler` og `Scenarioer` i `## Åpne spørsmål` er antall med åpne spørsmål av totalt i gating-settet (`<n> av <N>`).
- **`## Andre funn`**: står til slutt, og har bare det som ikke står i de andre tabellene. Et scenario som er `ikke funnet` eller `usikker`, står i `## Scenarioer`, og et tilgangsavvik i `### Avvik` under `## Tilgang og datakonsistens`, ikke her. Kolonnen `Type` er den faste teksten i malen, og radene sorteres i den rekkefølgen typene står i malen, og så i rekkefølgen kravene står i. `Gjelder` har referansen til kravet (`krav/…:<linje>`) når det finnes, og `Hva` til koden (`<repo>/<fil>:<linje>`).
