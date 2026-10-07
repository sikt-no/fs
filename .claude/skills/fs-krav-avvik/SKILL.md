---
name: fs-krav-avvik
description: Ser etter avvik fra konvensjonene i `.feature`-filene i en mappe eller fil under `krav/`, for reglene som krever skjønn og derfor ikke sjekkes automatisk av FS Kravforvaltning (Avvik-modusen). Reglene leses fra `krav/README.md` (bl.a. *Konkrete henvisninger* om «egne», «mine», «dem» og «denne», *Terminologi*, *Gode scenarioer*), `.claude/rules/listevisning-pattern.md` for listevisninger og `.claude/rules/design-patterns-for-krav.md`. Rapporterer hvert funn med `fil:linje`, regel, forslag til ny tekst, og om det er bare ordlyd eller trenger faglig avklaring. Retter bare funn som er bare ordlyd, og bare når brukeren sier ja. Endrer aldri tagger. Trigges av "se etter avvik i mappe", "sjekk konvensjonene i", "review kravteksten", "gå gjennom ordlyden", "finn «egne» og «dem»", "finn «min» og «denne»", "fs-krav-avvik".
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

## Kilder (les FØRST)

1. `krav/README.md`: hele fila. Særlig *Gode scenarioer*, *Aktører* og *Terminologi* (med *Ord som krever avklaring*, *Foretrukne begreper* og *Konkrete henvisninger*).
2. `.claude/rules/design-patterns-for-krav.md`.
3. `.claude/rules/listevisning-pattern.md`, bare for filer som beskriver en oversiktsside med en liste (se *Når mønsteret gjelder* der).

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

## Klassifiser hvert funn

| Klasse | Betyr | Eksempel |
|---|---|---|
| **Bare ordlyd** | Det finnes én riktig omskriving, og den følger av fila selv. | «en av dem» rett etter «organisasjonene jeg administrerer» |
| **Trenger avklaring** | Det finnes flere mulige betydninger, eller rettingen endrer hva kravet sier. | «egne utdanningstilbud»: de saksbehandleren har tilgang til, eller organisasjonens? |

Er du i tvil, er det *trenger avklaring*.

Statusen avgjør hvordan et funn kan rettes:

- `@draft`, `@planned`, `@in-progress`: teksten kan endres der den står. Under `@planned` er kravet validert, så et funn som *trenger avklaring* bør tilbake til `fs-krav` (modus B).
- `@implemented` (og deler uten egen status under den): leverte deler endres ikke på stedet (*Endring av levert krav*). Er det bare ordlyd, og atferden er den samme, kan brukeren velge et bevisst unntak og endre på stedet. Si det i rapporten, og la brukeren velge.

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
3. Funn som *trenger avklaring*: ikke rett. Foreslå `fs-krav` (modus B for `@draft`/`@planned`, modus D for leverte krav), med spørsmålene fra rapporten.
4. Oppsummer per fil hva som er endret. Er stegtekst endret, søk i `tester/steps/` etter den gamle teksten, og si fra om step definitions som må oppdateres.
