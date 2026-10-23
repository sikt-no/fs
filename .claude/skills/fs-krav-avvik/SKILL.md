---
name: fs-krav-avvik
description: Ser etter avvik fra konvensjonene i `.feature`-filene i en mappe eller fil under `krav/`, for reglene som krever skjønn og derfor ikke sjekkes automatisk av FS Kravforvaltning (Avvik-modusen). Reglene leses fra `krav/README.md` (bl.a. *Konkrete henvisninger* om «egne», «mine», «dem» og «denne», *Terminologi*, *Gode scenarioer*), `.claude/rules/listevisning-pattern.md` for listevisninger og `.claude/rules/design-patterns-for-krav.md`. Sjekker også referansene mellom krav (`@depends-on-` og `@ref-`) som krever flere filer: ID-er som ikke finnes, `@depends-on-` i ring, regeltitler i «…» under taggen som ikke finnes i kravet det pekes på, ankre (`@ref-` på en del i kravet det pekes på) som ikke stemmer med regeltittelen, og referanser som står i fritekst. For flyter i `krav/_Flyter/`: faser uten krav, flyt på flyt på tvers av prosesser, og regler gjentatt i flyten. Rapporterer hvert funn med `fil:linje`, regel, forslag til ny tekst, og om det er bare ordlyd eller trenger faglig avklaring. Retter bare funn som er bare ordlyd, og bare når brukeren sier ja. Endrer aldri tagger. Trigges av "se etter avvik i mappe", "sjekk konvensjonene i", "review kravteksten", "gå gjennom ordlyden", "finn «egne» og «dem»", "finn «min» og «denne»", "fs-krav-avvik".
allowed-tools: Read, Grep, Glob, Edit, AskUserQuestion
---

# Avvik i kravtekst

## Task

$ARGUMENTS

## Din rolle

Du leser kravene og finner tekst som bryter konvensjonene, der det trengs skjønn for å se det. Du er en reviewer, ikke en forfatter.

- **Reglene står i kildene, ikke her.** Les dem hver gang (se *Kilder*). Ikke sjekk regler som ikke står der, og ikke finn på egne.
- **Ikke gjenta de automatiske sjekkene.** Reglene som er merket *(sjekkes automatisk)* i `krav/README.md`, vises allerede i Avvik-modusen i FS Kravforvaltning. Hopp over dem. Ser du et slikt brudd, nevn det på én linje nederst og vis til Avvik-modusen.
- **Endre aldri tagger.** Statusovergangene eies av `fs-krav`, `fs-specify` / `fs-specify-delta` og `fs-verify`.
- **Endre aldri betydningen.** Du retter bare ordlyd som er entydig, og bare når brukeren har sagt ja. Alt som krever en faglig avgjørelse, går til brukeren og videre til `fs-krav`.

## I FS Kravforvaltning

I Claude-panelet virker AskUserQuestion: brukeren får spørsmålet som et kort med valgene. Hopper brukeren over, still spørsmålene i svaret, og vent på brukeren.

## Sjekk branchen (gjør dette aller først)

Før du leser eller skriver krav: sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md). Er den bak, spør du før du henter. I Claude-panelet i FS Kravforvaltning (uten Bash) hoppes sjekken over.

## Kilder (les FØRST)

1. `krav/README.md`: hele fila. Særlig *Gode scenarioer* (med *Krav fra kode, skisser eller FS-klienten*), *Aktører* og *Terminologi* (med *Ord som krever avklaring*, *Foretrukne begreper* og *Konkrete henvisninger*).
2. `.claude/rules/design-patterns-for-krav.md`.
3. `.claude/rules/listevisning-pattern.md`, bare for filer som beskriver en oversiktsside med en liste (se *Når mønsteret gjelder* der).
4. Domenets begrepsliste (se *Terminologi* i `krav/README.md`), hvis den finnes.

## Scope

Brukeren oppgir en mappe eller fil under `krav/`. Mangler den, spør. Finn filene med `Glob` (`<sti>/**/*.feature`). Er det mer enn 15 filer, si hvor mange, og spør om du skal ta alle eller en undermappe først.

## Slik går du gjennom en fil

1. **Status.** Noter statustaggen på `Egenskap:`, og statusen på `Regel:`/`Scenario:` som har en egen.
2. **Les hele fila**, også beskrivelsen og kommentarene. Steg og titler veier tyngst: de blir step definitions og vises i lister.
3. **Hopp over** deler som er `@deprecated` (de skal slettes) og tekst i `# ÅPNE SPØRSMÅL:` (spørsmål kan være uferdige).
4. **Vurder hver regel fra kildene.** Bruk `Grep` for å finne kandidater raskt, men les konteksten før du melder et funn. Et ord i seg selv er ikke et avvik. Eksempler fra *Konkrete henvisninger*:
   - `Grep` på `\b([Ee]gne|[Ee]gen|[Ee]get)\b`: avvik bare når eieren ikke står i setningen eller relasjonen er uklar («egne organisasjoner»). Ikke avvik: «søkerens egne søknader», «i eget vindu».
   - `Grep` på `\b(dem|disse)\b`: avvik når ordet peker til et annet steg eller en tittel. Ikke avvik når det ordet peker på, står i samme steg.
   - `Grep` på `\b(min|mine|mitt)\b`: som «egne». Avvik når det gjelder en rolles tilknytning («min organisasjon»), ikke ved bokstavelig eierskap («min profil»).
   - `Grep` på `\b(den|denne|dette)\b`: avvik når ordet peker til et annet steg («Så ser jeg denne applikasjonen»). Ikke avvik når det står i samme steg, når «den» er artikkel foran et adjektiv («den valgte organisasjonen»), eller når «det» er formelt subjekt.
   - «sin/sine/sitt» er ikke avvik.
   - `Grep` på `\b[A-ZÆØÅ]{2,}_[A-ZÆØÅ_]+\b|\b[a-zæøå]+_[a-zæøå_]+\b|\b[a-zæøå]+[A-ZÆØÅ][A-Za-zæøå]*\b|HTTP \d{3}|"[a-zæøå_]+":|\b(GET|POST|PUT|DELETE) /`: ord fra koden (*Gode scenarioer*), avvik i steg, tabeller og titler. Ikke avvik: `#`-kommentarer, tagger, `<parameter>` i `Scenariomal:`, feature-filnavn og testdata («SIKT_THS»). Treffer én verdi i en tabellkolonne, vurder hele kolonnen. Kodeverdier uten understrek («MANGEL», «GENERELL») finner ikke Grep, så de vurderes mot begrepslista. Bare ordlyd når domeneordet står i fila eller i begrepslista, ellers trenger avklaring.
5. **Referanser** (*Referanser* i `krav/README.md`). Formatet, referanser til kravet selv og doble referanser sjekkes automatisk. Her sjekker du det som krever flere filer. Linja «Ikke avvik: … tagger» over gjelder ikke referansetaggene.
   - `Grep` på `@(depends-on|ref)-[A-ZÆØÅ]{2,4}-[A-ZÆØÅ]{2,4}-[A-ZÆØÅ]{2,4}-\d{3}` i fila. For hver ID: `Grep` på `^\s*@(.*\s@)?<ID>\b` i `krav/**/*.feature`. Avvik når ingen fil har ID-en på en tag-linje, eller når mer enn én fil har den.
   - **Ring:** følg `@depends-on-` fra fila. Les tag-linjene i kravet det pekes på, og fortsett med de `@depends-on-` som står der, til et krav uten `@depends-on-`. Avvik når kjeden kommer tilbake til et krav som allerede er i kjeden. Stopp etter 10 ledd, og meld det.
   - **Regeltittel som ikke finnes:** gjelder en referanse én regel, står regeltittelen i «…» i kommentaren rett under taggen (*Referanser*). For hver `@depends-on-` og `@ref-` med en slik kommentar: les `Regel:`-linjene i kravet det pekes på. Avvik når teksten i «…» ikke er en regeltittel der, for eksempel fordi regelen har fått nytt navn eller er flyttet til et annet krav. Gjelder bare «…» som står alene på linja, eller etter `<Feature-ID>:`, ikke sitater og testdata midt i en setning («SPE»). Ligner én regel i kravet mye på teksten, foreslå den, og spør om det er den samme regelen.
   - **Anker** (*Anker* i `krav/README.md`). For hver `@ref-<A>` på en `Regel:` eller et `Scenario:` i fila: har A `@depends-on-<fila sin ID>`, er det et anker. For hver `@depends-on-<B>` i fila: les ankrene i B (`@ref-<fila sin ID>` på delene i B). Avvik når:
     - regeltittelen i «…» under `@depends-on-B` ikke er en av delene i B med ankeret, eller regelen over et scenario med ankeret. Ankeret og kommentaren sier ulike ting.
     - `@depends-on-B` har en regeltittel i «…», men B har ingen anker. Foreslå ankeret på regelen i B (kommentaren kan bli stående som forklaring).
   - **Referanse i fritekst:** en Feature-ID eller et `.feature`-filnavn i en kommentar, som ikke er historikk («flyttet», «skilt ut», «var»), ikke står i `# ÅPNE SPØRSMÅL:` og ikke er en mappe. Foreslå `@depends-on-` eller `@ref-` etter testen i README-en.
   - Funnene her er alltid *trenger avklaring*: rettingen er en tag, eller avgjør hvilken regel referansen gjelder.
6. **Prosess.** Alle reglene og scenarioene i fila er å opprette, endre og slette én eller flere entiteter, og verken brukerhistorien eller reglene sier hvilken prosess de hører til: *trenger avklaring*, med spørsmålet «Hvilken prosess hører dette til?». Gjelder ikke flyter (`krav/_Flyter/`). Ikke avvik når forvaltningen av grunndataene er prosessen, for eksempel kodeverk. Unntaket gjelder bare når brukerhistorien eller beskrivelsen sier det. Ellers trenger det avklaring, med spørsmålet om det er kodeverk. En fil som beskriver én skjerm eller komponent, er ikke avvik alene: skjerm er et tegn for `fs-krav` og `fs-scope`, ikke for denne sjekken.
7. **Flyter** (*Flyter* i `krav/README.md`), bare for filer under `krav/_Flyter/`. Mappenivået og ID-formatet sjekkes automatisk.
   - **Fase uten krav:** en `Regel:` uten `@depends-on-` og uten `@openquestion`. Fasen sier ikke hvilket krav den bygger på, og heller ikke at kravet mangler. Gjelder ikke et skjelett (`Regel:` uten scenarioer) i en `@draft` oversiktsflyt.
   - **Flyt på flyt:** en `@depends-on-FLY-…` som peker på en flyt i en annen prosessmappe.
   - **Ring** (punkt 5) gjelder også mellom flyter, og mellom flyter og krav.
   - **Regel gjentatt i flyten:** et scenario som beskriver en valideringsregel, en feilmelding eller felter som står i kravet fasen bygger på, i stedet for overleveringen. Les kravet før du melder det.
   - **Flyt som faller på terskelen:** flyten går ikke over minst to sub-domener eller domener (les mappene til kravene i `@depends-on-`), eller har ingen overlevering. Foreslå referanser mellom kravene i stedet.
   - Funnene her er alltid *trenger avklaring*, og rettes med `fs-krav` (modus E for flyter).

## Klassifiser hvert funn

| Klasse | Betyr | Eksempel |
|---|---|---|
| **Bare ordlyd** | Det finnes én riktig omskriving, og den følger av fila selv. | «en av dem» rett etter «organisasjonene jeg administrerer» |
| **Trenger avklaring** | Det finnes flere mulige betydninger, eller rettingen endrer hva kravet sier. | «egne utdanningstilbud»: de saksbehandleren har tilgang til, eller organisasjonens? |

Er du i tvil, er det *trenger avklaring*.

Statusen avgjør hvordan et funn kan rettes:

- `@draft`, `@planned`, `@in-progress`: teksten kan endres der den står. Under `@planned` er kravet validert, så et funn som *trenger avklaring* bør tilbake til `fs-krav` (modus B).
- `@implemented` (og deler uten egen status under den), og `@implemented`-deler under en `@in-progress` egenskap (*Delvis levert*): leverte deler endres ikke på stedet (*Endring av levert krav*). Er det bare ordlyd, og atferden er den samme, kan brukeren velge et bevisst unntak og endre på stedet. Si det i rapporten, og la brukeren velge.

## Rapport

Skriv rapporten i chat, gruppert per fil:

```
### <sti til fila> — @<status>

| Linje | Regel (README-seksjon) | Nå | Forslag | Klasse |
|---|---|---|---|---|
| L133 | Konkrete henvisninger | `Og en personbruker har hjemorganisasjon i en av dem` | `… i en av organisasjonene jeg administrerer` | Bare ordlyd |
```

- Filer uten funn listes samlet på én linje til slutt.
- For hvert funn som *trenger avklaring*: skriv spørsmålet som må besvares, i stedet for et forslag.
- Avslutt med tall: antall filer, funn per klasse, og funn i leverte krav.

## Rette (bare når brukeren sier ja)

1. Spør om du skal rette funnene som er *bare ordlyd*. Brukeren kan velge alle, per fil, eller enkeltfunn. Funn i leverte krav rettes bare når brukeren eksplisitt har valgt det bevisste unntaket.
2. Rett med `Edit`. Endre bare teksten i funnet, ikke tagger, rekkefølge eller annen tekst.
3. Funn som *trenger avklaring*: ikke rett. Foreslå `fs-krav` (modus B for `@draft`/`@planned`, modus D for leverte krav), med spørsmålene fra rapporten. Funn under *Referanser* rettes også av `fs-krav`, som setter, endrer eller fjerner taggen. Funn under *Flyter* rettes med `fs-krav` modus E.
4. Oppsummer per fil hva som er endret. Er stegtekst endret, søk i `tester/steps/` etter den gamle teksten, og si fra om step definitions som må oppdateres.
