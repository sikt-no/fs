# Verifisering: GSK som fullføres i vår og automatisk ferdigbehandling (fs-plattform!6509, fs-admin!3301)

- **Dato:** 2026-11-04 12:07
- **Krav:** `@OPT-SØK-SØK-018`, `@OPT-BEH-BEH-008`, `@OPT-BEH-BEH-025`, `@OPT-BEH-BEH-036`, `@FLY-OPT-AUT-001` (fasene «Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet» og «Saken blir ferdig behandlet og er klar til å være med i plasstildelingen») (5 feature-filer)
- **Kode:** `fs-plattform` (origin/main, d4c10529a8, oppdatert), `fs-admin` (origin/main, 52a3d0745, oppdatert). Begge er worktrees på origin/main, så de lokale branchene ikke er rørt
- **Åpne MR-er:** 4 MR-er i fs-plattform, 1 i fs-admin (2 med kode for kravene, ikke merget)
- **Omfang:** `@in-progress` for `@OPT-BEH-BEH-025` og `@OPT-BEH-BEH-036`, alle krav uansett status for `@OPT-BEH-BEH-008` og `@OPT-SØK-SØK-018`, flyter (to faser i `@FLY-OPT-AUT-001`) (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 4 finnere (`fs-verify-krav`), 5 kontrollører (`fs-verify-kontroll`), 1–2 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene, minus `@demo`, for `@OPT-SØK-SØK-018`, `@OPT-BEH-BEH-008` (verifisert uansett status), og de som ikke er tagget `@draft`, `@deprecated` eller `@demo` for resten.

Stiene er forkortet:

- `SVC` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `SDL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `JOBB` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app`
- `MC` = `fs-admin/src/domains/soknadsbehandling/features/SakDrawer/components/ManglerCard`
- `MK` = `fs-admin/src/domains/regelverk/features/Mangelkoder`
- `SB` = `fs-admin/src/domains/soknadsbehandling/features`

## Oppsummering

- Scenarioer: 32 funnet, 38 ikke funnet, 21 usikker, av 91
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 5 (3 av dem er delvis levert)
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: 18 stemmer, 15 avviker, 0 ikke funnet, 0 usikker, av 37 (4 ikke beskrevet)
- Regler i koden uten scenario: 55
- Åpne spørsmål: 2 regler og 9 scenarioer i gating-settet, 1 utenfor gating (`@draft`)

## Fremdrift for flyter

Fremdriften kommer fra statusen på delen av kravene fasene bygger på (`@depends-on-`, og ankrene innenfor reglene i «…», ellers alle ankrene, ellers reglene i «…»). Den endrer ingen tagger.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet | `@OPT-BEH-BEH-036` (`@in-progress`, Regel: Opptaksforvalteren merker én mangelkode for generell studiekompetanse som fullføres i vår er `@draft`, Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk ikke levert) | nei |
| `@FLY-OPT-AUT-001` | Saken blir ferdig behandlet og er klar til å være med i plasstildelingen | `@OPT-BEH-BEH-025` (`@in-progress`, Regel: Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort og Regel: Steg som bygger på et steg som ikke kan avgjøres, hoppes over ikke levert), `@OPT-BEH-BEH-029` (`@in-progress`, Regel: Saken kan bare bli Behandlet når den har minst én mangel eller ett grunnlag og Regel: Saksloggen viser endringene i behandlingsstatusen ikke levert) | nei |

`@FLY-OPT-AUT-001`: 0 av 2 faser levert (bare de to fasene er med i denne kjøringen).

Overleveringene i de to fasene er likevel lett etter i koden, siden kravene de bygger på nettopp er levert i fs-plattform!6509 og fs-admin!3301. Resultatet står i `## Scenarioer`.

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-025` | `@OPT-BEH-BEH-015` Automatisk GSK-konklusjon | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-025` kan ikke leveres før dette · Regel: Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk |
| `@OPT-BEH-BEH-025` | `@OPT-BEH-BEH-008` Søknadsmangler | 1 | `@planned` | – | i scope · Scenario: Saken er ferdig behandlet selv om kravelementene ga mangeltekst, Scenario: Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet |
| `@OPT-BEH-BEH-025` | `@OPT-BEH-BEH-036` Automatiske mangler | 1 | `@in-progress` | – | i scope · Scenario: Saken er ferdig behandlet selv om kravelementene ga mangeltekst |
| `@OPT-BEH-BEH-036` | `@OPT-BEH-BEH-020` Kravelementvurdering | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-036` kan ikke leveres før dette · Regel: Saken får automatiske mangeltekster når søkeren ikke er kvalifisert |
| `@OPT-BEH-BEH-036` | `@OPT-BEH-BEH-008` Søknadsmangler | 1 | `@planned` | – | i scope · Regel: Opptaksforvalteren merker én mangelkode …, Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk |
| `@OPT-BEH-BEH-036` | `@OPT-SØK-SØK-018` Oppgi at generell studiekompetanse fullføres i vår | 1 | `@draft` | – | i scope · Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-029` Behandlingsstatus | 1 | `@in-progress` | – | ikke levert (fasen «Saken blir ferdig behandlet …») |

Avhengigheter: 3 på nivå 1 utenfor scope, 3 av dem ikke `@implemented`. Kravene i scope bygger også på hverandre (merket «i scope»).

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-SØK-SØK-018` | Søkeren oppgir at generell studiekompetanse fullføres i vår | usikker | `SVC/soknad/StudiekurvService.java:267` — `soknadskladdSettFullforerVideregaende` setter avkrysningen på søkerens kladd, og leveringen kopierer den til søknaden (`:901`, `:925`, `:932`). Lagret i `MIG/V482__fullforer_videregaende.sql:9`. Søkerens skjerm i min-kompetanse er ikke sjekket |
| `@OPT-SØK-SØK-018` | Søkeren endrer før søknadsfristen at generell studiekompetanse fullføres i vår | usikker | `SVC/soknad/StudiekurvService.java:1038` — fristen sjekkes, og endringen kopieres til søknaden (`:1045`, `:1049`). Fjernes avkrysningen, sletter `SVC/saksbehandling/GskFullforesIVarMangelSync.java:93` den automatiske DUA-mangelen. Min-kompetanse er ikke sjekket |
| `@OPT-SØK-SØK-018` | Søkeren kan ikke endre etter søknadsfristen at generell studiekompetanse fullføres i vår | usikker | `SVC/soknad/StudiekurvService.java:853`, `:1038` — `SVC/opptak/Opptaksfrister.java:54` avviser levering og oppdatering etter fristen, men kladden (`:267`) har ingen fristsjekk. Om søkeren *ser muligheten*, avgjøres i min-kompetanse, som ikke er sjekket |
| `@OPT-BEH-BEH-008` | Opprette mangelkode | funnet | `MK/MangelkodeDetails/MangelkodeDetails.tsx:207-219` — opprettMangeltype med kode, kategori, navn, sperrerOpptak og tekstTilSoker. `SVC/regelverk/MangeltypeService.java:33-66` lagrer, og koden er aktiv som standard |
| `@OPT-BEH-BEH-008` | Tilgjengelige kategorier for mangelkoder | funnet | `MIG/V264__soknadsmangel_kodeverk.sql:37-40` — fire kategorier, vist i `MK/MangelkodeDetails/MangelkodeDetails.tsx:139-143`. Kategorien heter «Kvoter» i kodeverket, ikke «Kvote» |
| `@OPT-BEH-BEH-008` | Opptaksforvalteren ved <organisasjon> forvalter mangelkodene i <opptak> | funnet | avgjort av brukeren: funnet (organisasjonen som forvalter opptaket, eier regelverkssamlingen). `MIG/V264__soknadsmangel_kodeverk.sql:60-85` — krever MODIFISERE_REGELVERK for organisasjonen som eier regelverkssamlingen, ikke for den som forvalter opptaket. Et opptak kan bruke en samling en annen organisasjon eier (`MIG/V280__opptak_v2_skjema.sql:229,250-252`). Finneren: funnet. Kontrollen: usikker |
| `@OPT-BEH-BEH-008` | Søkeren er kvalifisert selv om saken har en mangel i kategorien <kategori> | funnet | `SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:25-36` — kvalifiseringen beregnes fra kravelementene. Ingen klasse under `SVC/regelverk/kvalifisering` leser `sak_mangel` |
| `@OPT-BEH-BEH-008` | Saken kan behandles ferdig selv om den har mangler | funnet | `SVC/saksbehandling/EndreStatusService.java:22-41` — ingen sjekk på mangler. `SB/StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:37-44` setter saken til ferdig behandlet |
| `@OPT-BEH-BEH-008` | Registrere mangel på spesielle krav | funnet | `MC/ManglerCard.tsx:72-79` sender mangelkode og kompetanseregelverk, `SVC/saksbehandling/SakMangelService.java:65-120` lagrer. Kommentaren legges inn etterpå (`MC/Mangel/Mangel.tsx:70-92`) |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant mangelkodene i regelverkssamlingen til opptaket | funnet | `MC/components/MangeltypeCombobox/MangeltypeCombobox.tsx:28-39,62` — filtrert på regelverkssamlingen til opptaket og aktive koder. Backend sjekker ikke samlingen (se tilgang) |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant kompetanseregelverkene til søknadsalternativene i saken | funnet | `MC/components/KompetanseregelverkSelect/KompetanseregelverkSelect.tsx:20-41,73-86` — valgene er kompetanseregelverkene til søknadsalternativene i saken |
| `@OPT-BEH-BEH-008` | Registrere mangel på kvote | ikke funnet | API-et har kvotesporsmalId (`SDL/saksbehandling/mangel.graphqls:58`, `SVC/saksbehandling/SakMangelService.java:432-446`), men fs-admin sender det ikke (`MC/ManglerCard.tsx:72-79`) — søkt etter «kvotesporsmal», «kvotespørsmål», «kvotesporsmalId» i fs-admin |
| `@OPT-BEH-BEH-008` | Saksbehandleren velger blant kvotespørsmålene til søknadsalternativene i saken | ikke funnet | ingen velger i fs-admin. Backend krever bare samme regelverkssamling (`SVC/saksbehandling/SakMangelService.java:439-444`) — søkt som over |
| `@OPT-BEH-BEH-008` | En mangel i kategorien <kategori> <kobling> | ikke funnet | Generelle krav og Poeng avvises med kobling (`SVC/saksbehandling/SakMangelService.java:418-438`), spesielle krav kan knyttes (`KompetanseregelverkSelect.tsx:66,89`), men kvote-raden kan ikke gjøres i fs-admin |
| `@OPT-BEH-BEH-008` | Kommentaren til søkeren er valgfri | funnet | `SDL/saksbehandling/mangel.graphqls:60` — tekstTilSoker er valgfri. `MC/ManglerCard.tsx:72-79` registrerer uten kommentar |
| `@OPT-BEH-BEH-008` | En sak kan ha flere mangler | funnet | `SDL/saksbehandling/sak.graphqls:141` — Sak.mangler er en liste. `MC/ManglerCard.tsx:175-191` viser alle |
| `@OPT-BEH-BEH-008` | Samme mangelkode i kategorien <kategori> kan <tillatt> registreres flere ganger i saken | ikke funnet | `SVC/saksbehandling/SakMangelService.java:494-519` og unik-indeksen `MIG/V291__saksbehandling_skjema.sql:549-551` dekker GSK, STEMPEL og KAR, men kvote-raden («BOS» på ulike kvotespørsmål) kan ikke gjøres i fs-admin |
| `@OPT-BEH-BEH-008` | Slette mangel som er registrert ved en feil | funnet | `MC/Mangel/Mangel.tsx:94-111,143-195` — slett med bekreftelse. `SVC/saksbehandling/SakMangelService.java:351-367` sletter raden |
| `@OPT-BEH-BEH-008` | Saksloggen viser at saksbehandleren <hendelse> | ikke funnet | `MIG/V480__stopp_endringslogg.sql:1-29` fjernet audit-triggerne i saksbehandling, og `SDL/saksbehandling/sak.graphqls:186-205` sier at endringsloggen ikke får nye rader — søkt etter «sakslogg», «sakshendelse», «historikk», «endringslogg», «auditlog» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser at søkeren har lastet opp ny dokumentasjon | funnet | `SB/SakOverviewView/components/SakOverviewTable/SakOverviewTable.tsx:176-181` — «Ny dokumentasjon» når et saksdokument er ulest (`SakStatusBadge.tsx:35-36`). Opplasting sjekker ikke ut mangler |
| `@OPT-BEH-BEH-008` | Saksbehandleren sjekker ut mangelen | ikke funnet | API-et har erUtsjekket (`SDL/saksbehandling/mangel.graphqls:78-79`, `SVC/saksbehandling/SakMangelService.java:217-220`), men fs-admin har ingen handling for å sjekke ut — søkt etter «erUtsjekket», «utsjekk», «sjekk ut», «sjekket ut», «sjekketUt» i fs-admin |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser om søkeren har lest mangelen | ikke funnet | API-et har erLestAvSoker (`SDL/saksbehandling/mangel.graphqls:159-160`), men fs-admin spør ikke etter feltet (`MC/queries.ts:25-52`) — søkt etter «erLestAvSoker», «lestAvSoker», «har lest» |
| `@OPT-BEH-BEH-008` | Registrering av mangel publiserer ikke mangelen | usikker | `SVC/saksbehandling/SakMangelService.java:109` — kanPubliseres er false som standard, og viewet viser bare publiserte (`MIG/V457__soknadsmangel_bare_publiserte.sql:81,131`). Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Saksbehandleren publiserer mangelen | usikker | API-et publiserer én mangel (`SVC/saksbehandling/SakMangelService.java:214-216`), men fs-admin publiserer alle upubliserte samlet (`MC/ManglerCard.tsx:96-113`). Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Saksbehandleren publiserer manglene i saken | usikker | `MC/ManglerCard.tsx:96-113,194-208` publiserer de registrerte manglene samlet, `SVC/saksbehandling/SakMangelService.java:139-141` sender én melding. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren får melding hver gang saksbehandleren publiserer manglene | usikker | `SVC/saksbehandling/SakMangelService.java:147-164` — ny melding når noe upublisert blir publisert. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Saksbehandleren publiserer en sak som bare har automatiske mangler | ikke funnet | `SVC/saksbehandling/SakMangelService.java:283-332` (publiserMangler) tar med beregnede mangler, men fs-admin kaller den ikke, og knappen vises bare når en registrert mangel er upublisert (`MC/ManglerCard.tsx:66,194`) — søkt etter «publiserMangler» i fs-admin |
| `@OPT-BEH-BEH-008` | Saksbehandleren ser at endringene ikke er publisert når <endring> | ikke funnet | «Ikke publisert» vises bare for registrerte mangler med kanPubliseres=false (`MC/Mangel/Mangel.tsx:137-141`). Ny kommentar endrer ikke kanPubliseres (`SVC/saksbehandling/SakMangelService.java:210-213`) — søkt etter «upubliser», «ikke publisert» |
| `@OPT-BEH-BEH-008` | Saksbehandleren blir advart om mangler som ikke er publisert | ikke funnet | `MerkSomBehandletButton.tsx:41-44` og `SVC/saksbehandling/EndreStatusService.java:22-41` setter status uten å se på mangler — søkt etter «advar», «upublisert», «ikkePublisert», «kanPubliseres» i fs-admin |
| `@OPT-BEH-BEH-008` | Publisere manglene når saken settes til ferdig behandlet | ikke funnet | ingen samlet handling — søkt som over |
| `@OPT-BEH-BEH-008` | Avbryte når saken har mangler som ikke er publisert | ikke funnet | ingen advarsel å avbryte — søkt som over |
| `@OPT-BEH-BEH-008` | Søkeren får én melding om manglene som publiseres i saken | usikker | `SVC/saksbehandling/SakMangelService.java:139-141,145-164` — én melding per publisering. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren får melding fra hver saksbehandlende organisasjon som publiserer mangler | usikker | `SVC/saksbehandling/SakMangelService.java:166-169`, `SVC/kommunikasjon/MangelMeldingService.java:31-54` — meldingen sendes per sak, med sakens organisasjon som avsender. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren åpner meldingen om mangel | ikke funnet | meldingen peker til søknaden, men fristen er alltid null (`SVC/kommunikasjon/MangelMeldingService.java:54`) |
| `@OPT-BEH-BEH-008` | Fristen for en mangel publisert <publisert> når <situasjon> | ikke funnet | ingen beregning av frist for mangler, fristForOpplasting settes aldri (`SDL/kommunikasjon/kommunikasjon.graphqls:106-109`) — søkt etter «ettersendingsfrist», «dokumentasjonsfrist», «fristForOpplasting», «mangelfrist», «fristForMangel» i fs-plattform |
| `@OPT-BEH-BEH-008` | Meldingen viser fristen for hvert søknadsalternativ med mangler | ikke funnet | søkt som over |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav gir frist bare for søknadsalternativene med kompetanseregelverket | ikke funnet | søkt som over |
| `@OPT-BEH-BEH-008` | Mangel på <kategori> har ettersendingsfristen | ikke funnet | søkt som over |
| `@OPT-BEH-BEH-008` | Mangel på spesielle krav vises under søknadsalternativene med kompetanseregelverket | usikker | `MIG/V457__soknadsmangel_bare_publiserte.sql:97-131` legger mangelen ut på søknadsalternativene med kompetanseregelverket (`SDL/saksbehandling/sak.graphqls:892`). Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren ser kravene i kompetanseregelverket mangelen gjelder | usikker | standardteksten er med (`MIG/V457__soknadsmangel_bare_publiserte.sql:62-65`), men ingen kobling til kravelementene på en registrert mangel. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren ser kommentaren fra saksbehandleren | usikker | `MIG/V457__soknadsmangel_bare_publiserte.sql:65-66` — saksbehandlerTekst. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Mangel på <kategori> gjelder ikke et bestemt søknadsalternativ | usikker | `MIG/V457__soknadsmangel_bare_publiserte.sql:51-93` — mangler uten kompetanseregelverk gjelder søknaden. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Mangel som er sjekket ut vises ikke for søkeren | usikker | `MIG/V457__soknadsmangel_bare_publiserte.sql:80,130` — viewet utelater utsjekkede. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Søkeren laster opp dokumentasjon for en mangel | usikker | opplastingen er i min-kompetanse, som ikke er sjekket. Det finnes ingen kobling fra dokument til mangel i fs-plattform |
| `@OPT-BEH-BEH-008` | Mangelen står til saksbehandleren har sjekket den ut | usikker | `MIG/V457__soknadsmangel_bare_publiserte.sql:80,130` — mangelen står til den er sjekket ut. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-008` | Saksbehandlende organisasjon ser manglene i saken hos en annen organisasjon | ikke funnet | `sak_mangel` kan leses på tvers (`MIG/V291__saksbehandling_skjema.sql:1714-1718`), men saken hos en annen organisasjon er ikke synlig (`MIG/V501__tilbyderoppslag_per_sak.sql:37-51`), og fs-admin viser bare manglene på den åpne saken (`MC/queries.ts:3-23`) |
| `@OPT-BEH-BEH-008` | Saksbehandlende organisasjon kan ikke endre manglene i saken hos en annen organisasjon | ikke funnet | backend avviser (`MIG/V291__saksbehandling_skjema.sql:1720-1738`), men ManglerCard viser «Legg til», «Slett», «Lagre» og publisering uten å sjekke organisasjonen (`MC/ManglerCard.tsx:137-208`, `MC/Mangel/Mangel.tsx:143-218`) |
| `@OPT-BEH-BEH-008` | Opptaksforvalteren ved forvaltende organisasjon ser manglene i alle sakene | funnet | `MIG/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:20-40` og lesing av `sak_mangel` med SE_SØKNADSBEHANDLING (`MIG/V291__saksbehandling_skjema.sql:1714-1718`). fs-admin viser manglene per sak (`MC/ManglerCard.tsx:38-46`) |
| `@OPT-BEH-BEH-008` | Tilbyderen ser manglene når en annen organisasjon saksbehandler utdanningstilbudet | ikke funnet | lesingen finnes (`MIG/V501__tilbyderoppslag_per_sak.sql:41-51`), men «ser ikke muligheten til å endre» stemmer ikke: redigeringen vises (`MC/ManglerCard.tsx:137-208`) |
| `@OPT-BEH-BEH-008` | Tilgjengelige mangelkoder i filter | ikke funnet | saksfilteret har bare «har mangler», uten mangelkode (`SDL/saksbehandling/sak.graphqls:517-540`, `SVC/saksbehandling/SakFilterConditions.java:440-448`) — søkt etter «mangelkode», «mangeltype» i filterkoden |
| `@OPT-BEH-BEH-008` | Filtrere på mangelkode | ikke funnet | søkt som over |
| `@OPT-BEH-BEH-025` | Saken behandles helautomatisk når søkeren har ett vitnemål, og vitnemålet gir GSK | funnet | `SVC/autosak/SetteGrunnlagService.java:111-130` og `SVC/autosak/FerdigbehandlingService.java:82-101` — bare ett ikke-annullert vitnemål (VM) med GSK gir helautomatisk behandling. Kjøres fra `SVC/autosak/AutomatiskSaksbehandlingService.java:142` |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk når ingen vitnemål gir GSK | funnet | `SVC/autosak/SetteGrunnlagService.java:128-130`, `SVC/autosak/FerdigbehandlingService.java:98-100` — uten GSK settes ikke grunnlag, og saken er ikke helautomatisk |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål | funnet | `SVC/autosak/SetteGrunnlagService.java:111-115` — flere vitnemål gir FlereVitnemaalException, og hele behandlingen rulles tilbake (`SVC/autosak/AutomatiskSaksbehandlingService.java:89`) |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk når søkeren har flere vitnemål, og bare ett gir GSK | funnet | `SVC/autosak/SetteGrunnlagService.java:111-115` — antallet sjekkes før GSK (`:128`) |
| `@OPT-BEH-BEH-025` | Saksbehandleren velger vitnemålet saken behandles automatisk på | ikke funnet | `behandleSakAutomatisk` tar bare sakId (`SDL/autosak/automatisk-saksbehandling.graphqls:52-58`). Saksbehandleren kan velge vitnemål bare for GSK-konklusjonen (`SVC/autosak/gsk/SettGskKonklusjonService.java:60-85`), ikke for grunnlag, poeng og kravelementer — ikke funnet på main — finnes delvis i MR !6549 (åpen, fs-plattform, `vitnemalsbehandling-tabeller`): `V503__vitnemalsbehandling.sql` — tabellen for valgt vitnemål, uten kobling til den automatiske behandlingen |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | funnet | `SVC/autosak/FerdigbehandlingService.java:58-74` — setter ferdig behandlet når saken er helautomatisk og `erAltAvgjort` (`:103-115`: kvalifisering, poengsum for alle kombinasjoner av kvote og grunnlag, ingen ubesvarte kvotespørsmål med automatisk merknad). Eget savepoint (`SVC/autosak/AutomatiskSaksbehandlingService.java:170-176`) |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet selv om kravelementene ga mangeltekst | funnet | `SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:104-117` skriver ikke kvalifisert og mangeltekst. `SVC/autosak/FerdigbehandlingService.java:121-135,151-210` regner det som avgjort |
| `@OPT-BEH-BEH-025` | Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet | ikke funnet | `SVC/autosak/FerdigbehandlingService.java:58-74` setter bare status og sjekker ut DUA. Bare `SVC/saksbehandling/SakMangelService.java:283-331` publiserer — søkt etter «STATUS_KAN_PUBLISERES», «sendMangelMelding», «publiserMangler» i autosak |
| `@OPT-BEH-BEH-025` | Det som kan avgjøres, blir avgjort når <steg> ikke kan avgjøres | ikke funnet | avgjort av brukeren: ikke funnet (kravelement-raden avviker). poengene (`SVC/regelverk/poeng/PoengberegningService.java:162-185`) og kvoten (`SVC/autosak/KvotesporsmalAlgoritmeService.java:210-226`) stemmer. Men når kravelementene ikke kan vurderes (`SVC/autosak/AutomatiskSaksbehandlingService.java:160-168`), lagres søkeren som ikke kvalifisert med mangeltekst (`SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:104-117`), ikke som ikke avgjort, og kvoten utelates |
| `@OPT-BEH-BEH-025` | Saken blir stående som ikke behandlet når et steg ikke kan avgjøres | funnet | `SVC/autosak/FerdigbehandlingService.java:65-67` er den eneste statusendringen i den automatiske behandlingen |
| `@OPT-BEH-BEH-025` | Opptaksforvalteren får varsel første gang en feil i regelverket stopper et steg | ikke funnet | feilene logges bare (`SVC/regelverk/poeng/PoengberegningService.java:165`, `SVC/autosak/KvotesporsmalAlgoritmeService.java:211`) — søkt etter «varsel», «varsl», «notifikasjon», «notification», «regelverksfeil», «feil i regelverk» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-025` | Opptaksforvalteren får varselet om feilen bare første gang | ikke funnet | søkt som over |
| `@OPT-BEH-BEH-025` | <feil i regelverket> stopper <steg> | ikke funnet | 6 av 7 rader har kode (`SVC/regelverk/poeng/PoengberegningEvaluator.java:81-104`, `SVC/autosak/KvotesporsmalAlgoritmeService.java:210`, `AldersberegningsdatoUtleder.java:20`), men «to grunnlag passer like godt» velger ett grunnlag i stedet for å stoppe (`SVC/autosak/SetteGrunnlagService.java:289-298`) |
| `@OPT-BEH-BEH-025` | Saksbehandleren ferdigbehandler saken etter å ha gjort resten | funnet | `SVC/saksbehandling/EndreStatusService.java:22-41` (`endreSaksbehandlingsstatusV3`). `fs-admin/src/domains/soknadsbehandling/hooks/useEndreBehandlingsstatus.ts:12-32` |
| `@OPT-BEH-BEH-025` | Saken blir ikke ferdig behandlet av seg selv når saksbehandleren har gjort resten | funnet | `SVC/regelverk/poeng/SettPoengService.java:192-199` flytter saken til Under behandling. Ferdigbehandlingen kalles bare fra `SVC/autosak/AutomatiskSaksbehandlingService.java:172` |
| `@OPT-BEH-BEH-036` | Saken får en automatisk mangeltekst når <vurdert av> vurderer at et kravelement ikke er oppfylt | funnet | `SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:104-117`, kjørt fra den automatiske behandlingen (`SVC/autosak/AutomatiskSaksbehandlingService.java:137`) og fra saksbehandlerens vurdering (`KvalifiserKravelementV4Service.java:63`) |
| `@OPT-BEH-BEH-036` | Saken får ikke mangeltekst når søkeren er kvalifisert på en annen kravliste | funnet | `SVC/regelverk/kvalifisering/ManglendeKravBeregner.java:104-116` — ELLER mellom kravlistene. `KvalifiseringOppdateringService.java:113` gir ingen mangler |
| `@OPT-BEH-BEH-036` | Saken får mangeltekster i alle kravlistene når søkeren ikke er kvalifisert på noen | funnet | `SVC/regelverk/kvalifisering/ManglendeKravBeregner.java:59-91`, `ManglendeKravTekstService.java:87-93` |
| `@OPT-BEH-BEH-036` | De automatiske mangeltekstene slettes når <vurdert av> vurderer at søkeren er kvalifisert | funnet | `SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:113,213-225` — tekstene settes til null |
| `@OPT-BEH-BEH-036` | Saksbehandleren ser de automatiske mangeltekstene sammen med de registrerte manglene | ikke funnet | `MC/queries.ts:3-23` henter bare de registrerte manglene (`Sak.mangler`). Tekstene finnes bare i `Soknadsmangel` (`MIG/V457__soknadsmangel_bare_publiserte.sql:135-183`), som fs-admin ikke bruker — søkt etter «Soknadsmangel», «manglendeKrav», «mangeltekst», «mangelkilde», «automatiskMangel» i fs-admin |
| `@OPT-BEH-BEH-036` | Søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet | ikke funnet | viewet krever publisert (`MIG/V457__soknadsmangel_bare_publiserte.sql:170`), ny tekst får ikke publisert (`SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:206-209`), og verken `SVC/autosak/FerdigbehandlingService.java:64-68` eller `SVC/saksbehandling/EndreStatusService.java:31-34` publiserer — søkt etter «status_kan_publiseres» (også triggere) i fs-plattform |
| `@OPT-BEH-BEH-036` | Søkeren ser ikke de automatiske mangeltekstene mens saken er under behandling | usikker | API-et viser ikke tekstene før de er publisert (`SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:206-209`, `MIG/V457__soknadsmangel_bare_publiserte.sql:170`). Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-036` | Søkeren ser mangeltekstene per søknadsalternativ | usikker | `MIG/V457__soknadsmangel_bare_publiserte.sql:137-167` gir én rad per søknadsalternativ, men bare når den er publisert. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-036` | Søkeren ser ikke mangelteksten når søknadsalternativet er fjernet | usikker | `MIG/V457__soknadsmangel_bare_publiserte.sql:45` — bare søknadsalternativer som ikke er slettet. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-036` | Saksbehandleren kan ikke endre en automatisk mangeltekst | usikker | ingen mutation skriver tekstene utenom `KvalifiseringOppdateringService`, men fs-admin viser ikke tekstene i det hele tatt, så det kan ikke prøves |
| `@OPT-BEH-BEH-036` | Alle sakene i søknaden får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår | ikke funnet | mangelen settes på alle sakene (`SVC/saksbehandling/GskFullforesIVarMangelSync.java:45-91`, kalt fra `JOBB/SoknadshendelseJobb.java:315`), men saksloggen fylles ikke: `MIG/V480__stopp_endringslogg.sql:1-29` — søkt etter «sakslogg», «sak_hendelse», «historikk», «endringslogg» |
| `@OPT-BEH-BEH-036` | Saken får ikke mangel når ingen mangelkode er merket | ikke funnet | ingen mangel (`SVC/saksbehandling/GskFullforesIVarMangelSync.java:38-40`), men ikke noe varsel når søknaden ikke får mangelen. Bare en fast advarsel på oversikten over mangelkoder (`MK/MangelkoderOverview.tsx:36-58`) — søkt etter «varsel», «notifikasjon» |
| `@OPT-BEH-BEH-036` | Opptaksforvalteren får varselet bare første gang | ikke funnet | ingen varselmekanisme. Advarselen på oversikten vises hver gang (`MK/MangelkoderOverview.tsx:54-58`) |
| `@OPT-BEH-BEH-036` | Søkeren ser den automatiske mangelen i Min kompetanse | usikker | mangelen er publisert (`SVC/saksbehandling/GskFullforesIVarMangelSync.java:70,82`), men viewet viser den bare når saken er under behandling eller ferdig behandlet (`MIG/V457__soknadsmangel_bare_publiserte.sql:14`). En ny sak er ubehandlet. Min-kompetanse er ikke sjekket |
| `@OPT-BEH-BEH-036` | Søkeren får ikke egen melding om den automatiske mangelen | funnet | `SVC/saksbehandling/GskFullforesIVarMangelSync.java:62-91` sender ingen melding, og `SVC/saksbehandling/SakMangelService.java:288-294` teller bare upubliserte mangler |
| `@OPT-BEH-BEH-036` | Mangelen slettes når søkeren endrer søknaden | ikke funnet | slettingen finnes (`SVC/saksbehandling/GskFullforesIVarMangelSync.java:92-101`), men saksloggen fylles ikke (`MIG/V480__stopp_endringslogg.sql:1-29`) |
| `@OPT-BEH-BEH-036` | Mangel som er sjekket ut slettes ikke når søkeren endrer søknaden | funnet | `SVC/saksbehandling/GskFullforesIVarMangelSync.java:100` — sletter bare mangler som ikke er sjekket ut |
| `@OPT-BEH-BEH-036` | Saksbehandleren kan sjekke ut mangelen, men ikke slette den | ikke funnet | slett er skjult for automatiske mangler (`MC/Mangel/Mangel.tsx:143`), men fs-admin har ingen utsjekk — søkt etter «erUtsjekket», «utsjekk», «sjekk ut», «checkout» i fs-admin. API-et (`SVC/saksbehandling/SakMangelService.java:351-367`) stopper ikke sletting av en automatisk mangel |
| `@OPT-BEH-BEH-036` | Mangelen sjekkes ut når saken er behandlet helautomatisk | ikke funnet | utsjekken finnes (`SVC/autosak/FerdigbehandlingService.java:64,213-227`), men saksloggen fylles ikke (`MIG/V480__stopp_endringslogg.sql:1-29`) |
| `@OPT-BEH-BEH-036` | Mangelen sjekkes ikke ut når saken ikke er behandlet helautomatisk | funnet | `SVC/autosak/FerdigbehandlingService.java:58-63` — returnerer før utsjekken når saken ikke er helautomatisk eller ikke alt er avgjort |
| `@OPT-BEH-BEH-036` | Saksbehandleren sjekker ut mangelen når søkeren har dokumentert vitnemålet | ikke funnet | avgjort av brukeren: ikke funnet (saksbehandleren må kunne gjøre det i fs-admin). API-et sjekker ut uten å slette (`SVC/saksbehandling/SakMangelService.java:217-219`), men fs-admin har ingen utsjekk. Finneren: ikke funnet. Kontrollen: usikker, siden steget ikke nevner skjermen |
| `@FLY-OPT-AUT-001` | Saken med mangelen for GSK som fullføres i vår blir ferdig behandlet | funnet | lages: `SVC/saksbehandling/GskFullforesIVarMangelSync.java:45-91` (kalt fra `JOBB/SoknadshendelseJobb.java:315`) · brukes: `SVC/autosak/FerdigbehandlingService.java:64,213-227` — DUA-mangelen (`sak_mangel` med mangelkoden merket `er_gsk_fullfores_i_var`) sjekkes ut, og saken settes til ferdig behandlet (`:65-67`) |
| `@FLY-OPT-AUT-001` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | funnet | lages: `SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:204`, `SVC/regelverk/poeng/PoengsumService.java:170-186` · brukes: `SVC/autosak/FerdigbehandlingService.java:103-148` — kvalifiseringen og poengsummen per kvote og grunnlag leses, og saken settes til ferdig behandlet |
| `@FLY-OPT-AUT-001` | Søkeren ser mangelteksten fra kravelementene når saken er ferdig behandlet | ikke funnet | lages: `SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:205-212` (ny mangeltekst er ikke publisert) · brukes: ikke funnet — viewet søkeren leser, krever publisert (`MIG/V457__soknadsmangel_bare_publiserte.sql:170`), og den automatiske behandlingen publiserer ikke. Søkt etter «status_kan_publiseres», «publiser» og triggere i fs-plattform |
| `@FLY-OPT-AUT-001` | Saken blir ikke ferdig behandlet når poengene ikke kan avgjøres | funnet | lages: `SVC/regelverk/poeng/PoengService.java:61-69`, `PoengberegningEvaluator.java:193` (ingen poengsum når poengtypen ikke kan beregnes) · brukes: `SVC/regelverk/poeng/PoengsumService.java:235` → `SVC/autosak/FerdigbehandlingService.java:61-62` — saken blir stående som ubehandlet |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

| Feature-ID | Sjekk | Rolle og handling | Kravet sier | Koden gjør | Resultat | Bevis |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-SØK-SØK-018` | tilgang | søker oppretter og endrer avkrysningen | søkeren oppgir det i søknaden sin | krever at innlogget søker eier kladden | stemmer | `SVC/soknad/StudiekurvService.java:270-278` — IkkeAutorisertSokerException ellers |
| `@OPT-SØK-SØK-018` | tilgang | søker endrer etter søknadsfristen | kan ikke endre etter fristen | levering og oppdatering av søknaden avvises etter fristen, kladden kan fortsatt endres | stemmer | `SVC/soknad/StudiekurvService.java:853`, `:1038` |
| `@OPT-SØK-SØK-018` | organisasjon | saksbehandler oppretter og endrer avkrysningen på vegne av søkeren | ikke beskrevet | krever MODIFISERE_SØKNADSBEHANDLING i opptakets organisasjon, også etter søknadsfristen | ikke beskrevet | `SVC/soknad/PaVegneAvSoker.java:42-46`, `SVC/soknad/StudiekurvService.java:850-851` · `SB/EndreSoknadView/EndreSoknadView.tsx:173`, `SB/OpprettSoknadView/OpprettSoknadView.tsx:316` |
| `@OPT-SØK-SØK-018` | konsistens | søker eller saksbehandler fjerner avkrysningen | søknaden får en mangel for GSK når det er krysset av | DUA-mangelen synkes per søknadshendelse, og automatiske mangler som ikke er sjekket ut, slettes | stemmer | `SVC/saksbehandling/GskFullforesIVarMangelSync.java:45-101`, `JOBB/SoknadshendelseJobb.java:315` |
| `@OPT-SØK-SØK-018` | konsistens | saksbehandler endrer avkrysningen | ikke beskrevet | skriver både kladden og søknaden | ikke beskrevet | `SVC/soknad/oppdatersoknad/OppdaterSoknadISoknadsbehandlingService.java:219-240` |
| `@OPT-BEH-BEH-008` | tilgang | opptaksforvalter oppretter og endrer mangelkode | opptaksforvalteren ved organisasjonen som forvalter opptaket | krever MODIFISERE_REGELVERK for organisasjonen som eier regelverkssamlingen. fs-admin viser redigeringen også med bare SE_REGELVERK (backend avviser) | avviker | `MIG/V264__soknadsmangel_kodeverk.sql:60-85`, `fs-admin/src/app/regelverk/layout.tsx:10`, `MK/MangelkodeDetails/MangelkodeDetails.tsx:278` |
| `@OPT-BEH-BEH-008` | tilgang | saksbehandler oppretter, endrer og sletter mangel i saken sin | saksbehandlende organisasjon registrerer mangler i saken sin | RLS krever MODIFISERE_SØKNADSBEHANDLING for sakens organisasjon | stemmer | `MIG/V291__saksbehandling_skjema.sql:1720-1738` |
| `@OPT-BEH-BEH-008` | tilgang | saksbehandler publiserer manglene | saksbehandleren ved saksbehandlende organisasjon | krever MODIFISERE_SØKNADSBEHANDLING i sakens organisasjon | stemmer | `SVC/saksbehandling/SakMangelService.java:340-349`, `MIG/V291__saksbehandling_skjema.sql:1726-1733` |
| `@OPT-BEH-BEH-008` | organisasjon | saksbehandler endrer manglene i en annen organisasjons sak | ser ikke muligheten til å endre | backend avviser, men fs-admin viser redigeringen uten å sjekke organisasjonen | avviker | `MC/ManglerCard.tsx:137-208`, `MC/Mangel/Mangel.tsx:143-218` (jf. `SB/PersonaliaCard/PersonaliaCard.tsx:114`) |
| `@OPT-BEH-BEH-008` | organisasjon | saksbehandler leser manglene i en annen organisasjons sak | ser manglene i alle sakene på søknaden | `sak_mangel` kan leses på tvers, men saken hos den andre organisasjonen er ikke synlig | avviker | `MIG/V291__saksbehandling_skjema.sql:1714-1718` mot `MIG/V501__tilbyderoppslag_per_sak.sql:37-51` |
| `@OPT-BEH-BEH-008` | organisasjon | tilbyder leser manglene i saken hos organisasjonen som saksbehandler tilbudet | ser, men endrer ikke | lesingen finnes, skriving avvises i backend, men vises i fs-admin | avviker | `MIG/V501__tilbyderoppslag_per_sak.sql:41-51`, `MC/ManglerCard.tsx:137-208` |
| `@OPT-BEH-BEH-008` | organisasjon | opptaksforvalter leser manglene i alle sakene i opptaket | ser manglene i alle sakene | forvalteren ser sakene og har SE_SØKNADSBEHANDLING | stemmer | `MIG/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:20-40` |
| `@OPT-BEH-BEH-008` | organisasjon | opptaksforvalter uten MODIFISERE_SØKNADSBEHANDLING endrer mangel | ser manglene (ikke beskrevet om endring) | fs-admin viser «Legg til», «Slett», «Lagre» og publisering, og lagringen feiler i backend | avviker | `MIG/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:8-10`, `MC/ManglerCard.tsx:137-208` |
| `@OPT-BEH-BEH-008` | organisasjon | saksbehandler registrerer mangelkode fra en annen regelverkssamling enn opptakets | kan bare velge mangelkodene i regelverkssamlingen til opptaket | bare fs-admin filtrerer, backend sjekker ikke | avviker | `SVC/saksbehandling/SakMangelService.java:65-96`, `MC/components/MangeltypeCombobox/MangeltypeCombobox.tsx:62-72` |
| `@OPT-BEH-BEH-008` | organisasjon | saksbehandler knytter mangel til et kompetanseregelverk ingen søknadsalternativer i saken har | kan bare velge kompetanseregelverkene til søknadsalternativene | backend krever bare samme regelverkssamling | avviker | `SVC/saksbehandling/SakMangelService.java:418-431,450-460` |
| `@OPT-BEH-BEH-008` | tilgang | søker leser manglene sine | søkeren ser de publiserte manglene | viewet slipper inn søkeren og saksbehandlere med tilgang til sakens organisasjon | stemmer | `MIG/V457__soknadsmangel_bare_publiserte.sql:10-17` |
| `@OPT-BEH-BEH-008` | konsistens | opptaksforvalter deaktiverer mangelkode som er i bruk | ikke beskrevet | kan bare deaktiveres, og fremmednøkkelen fra `sak_mangel` står | stemmer | `MK/MangelkodeDetails/MangelkodeDetails.tsx:241-260,282`, `MIG/V291__saksbehandling_skjema.sql:518-519` |
| `@OPT-BEH-BEH-008` | konsistens | opptaksforvalter endrer kategori på en mangelkode som er i bruk | ikke beskrevet | ny kategori tillates uten sjekk av `sak_mangel`, så en mangel med kompetanseregelverk kan ligge under en kategori som ikke tillater kobling | avviker | `SVC/regelverk/MangeltypeService.java:85-87`, `MIG/V291__saksbehandling_skjema.sql:598-600` |
| `@OPT-BEH-BEH-008` | konsistens | saksbehandler sletter mangel | saksloggen viser hendelsen | raden slettes, og endringsloggen fylles ikke | avviker | `SVC/saksbehandling/SakMangelService.java:360`, `MIG/V480__stopp_endringslogg.sql:14-29` |
| `@OPT-BEH-BEH-008` | konsistens | behandlingen skifter organisasjon | ikke beskrevet | mangler fra en organisasjon som ikke lenger behandler noe på søknaden, vises ikke for søkeren | ikke beskrevet | `MIG/V457__soknadsmangel_bare_publiserte.sql:82-93` |
| `@OPT-BEH-BEH-025` | tilgang | saksbehandler setter saken til Behandlet | saksbehandleren ved organisasjonen setter saken til Behandlet | RLS krever MODIFISERE_SØKNADSBEHANDLING, 0 rader gir SakFinnesIkke | stemmer | `MIG/V291__saksbehandling_skjema.sql:1548-1558`, `SVC/saksbehandling/EndreStatusService.java:35-38` |
| `@OPT-BEH-BEH-025` | organisasjon | saksbehandler ved en annen organisasjon endrer saken | saken hos «Universitetet i Oslo» | bare organisasjonen som behandler saken | stemmer | `MIG/V291__saksbehandling_skjema.sql:1551-1556` |
| `@OPT-BEH-BEH-025` | tilgang | den som kaller `behandleSakAutomatisk` endrer saken | ikke beskrevet | ingen egen sjekk, bare RLS. Med bare SE_ blir saken stille ikke ferdig behandlet | ikke beskrevet | `SVC/autosak/AutomatiskSaksbehandlingService.java:92-100`, `SVC/autosak/FerdigbehandlingService.java:65-71` |
| `@OPT-BEH-BEH-025` | konsistens | automatikken setter status og sjekker ut DUA-mangelen | ikke beskrevet | samme savepoint. Feiler det, beholdes resten av behandlingen, og saken blir ikke ferdig | stemmer | `SVC/autosak/AutomatiskSaksbehandlingService.java:170-176`, `SVC/autosak/FerdigbehandlingService.java:64-67` |
| `@OPT-BEH-BEH-025` | konsistens | søkeren har flere vitnemål | søknaden får likevel GSK-konklusjonen fra vitnemålet som gir GSK | ingen GSK-konklusjon når søkeren har flere vitnemål, og hele behandlingen rulles tilbake | avviker | `GskVedtakAutoService.java:80-82`, `SVC/autosak/SetteGrunnlagService.java:111-115` — finnes i MR !6541 (åpen, fs-plattform, `solov/gsk-konklusjon-flere-vitnemaal`) |
| `@OPT-BEH-BEH-025` | konsistens | automatikken endrer mangelteksten | manglene publiseres når saken blir ferdig | ny tekst nullstiller publisering og lest, og ingenting publiserer den igjen | avviker | `SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:203-212`, `SVC/autosak/FerdigbehandlingService.java:58-74` |
| `@OPT-BEH-BEH-036` | tilgang | saksbehandler sletter den automatiske DUA-mangelen | kan sjekke ut, ikke slette | fs-admin skjuler slett, men API-et sletter uten å sjekke `er_registrert_automatisk` | avviker | `SVC/saksbehandling/SakMangelService.java:351-367`, `MC/Mangel/Mangel.tsx:143` |
| `@OPT-BEH-BEH-036` | tilgang | saksbehandler sjekker ut DUA-mangelen | kan sjekke ut | API-et kan, fs-admin har ingen utsjekk | avviker | `SVC/saksbehandling/SakMangelService.java:217-219` |
| `@OPT-BEH-BEH-036` | organisasjon | opptaksforvalter endrer merkingen av mangelkoden | ikke beskrevet (forvalteren ved HK-dir) | RLS skjuler mangelkoder fra andre organisasjoner, og 0 rader gir FinnesIkke | stemmer | `SVC/regelverk/MangeltypeService.java:100-104` |
| `@OPT-BEH-BEH-036` | tilgang | saksbehandler publiserer mangeltekstene | ikke beskrevet | krever MODIFISERE_SØKNADSBEHANDLING i sakens organisasjon | stemmer | `SVC/saksbehandling/SakMangelService.java:285,340-349` |
| `@OPT-BEH-BEH-036` | organisasjon | søker og saksbehandler leser manglene | ikke beskrevet | søkerens egne rader, og saker organisasjonen har tilgang til | stemmer | `MIG/V457__soknadsmangel_bare_publiserte.sql:10-18` |
| `@OPT-BEH-BEH-036` | tilgang | søknadshendelse-jobben setter og sletter DUA-mangelen | ikke beskrevet | skriver som system, uten en brukers tilgang | stemmer | `JOBB/SoknadshendelseJobb.java:311-316` |
| `@OPT-BEH-BEH-036` | konsistens | opptaksforvalter merker mangelkoden | bare én per regelverkssamling, «Generelle krav» og stopper for opptak | validering ved opprett og hver endring, og unik delindeks | stemmer | `SVC/regelverk/MangeltypeService.java:53,98,119-141`, `MIG/V503__soknadsmangeltype_gsk_fullfores_i_var.sql:14-16` |
| `@OPT-BEH-BEH-036` | konsistens | søkeren fjerner krysset | den automatiske mangelen slettes hvis den ikke er sjekket ut | sletter bare automatiske mangler som ikke er sjekket ut | stemmer | `SVC/saksbehandling/GskFullforesIVarMangelSync.java:92-101` |
| `@OPT-BEH-BEH-036` | konsistens | saken blir ferdig behandlet helautomatisk | DUA-mangelen sjekkes ut før saken er ferdig behandlet | utsjekk og status i samme savepoint | stemmer | `SVC/autosak/FerdigbehandlingService.java:64-68`, `SVC/autosak/AutomatiskSaksbehandlingService.java:170-176` |
| `@OPT-BEH-BEH-036` | konsistens | saken blir ferdig behandlet | tekstene publiseres hvis saksbehandleren ikke har gjort det | ingen publisering ved ferdig behandlet | avviker | `SVC/autosak/FerdigbehandlingService.java:64-68`, `SVC/saksbehandling/EndreStatusService.java:31-34` |
| `@OPT-BEH-BEH-036` | konsistens | DUA-mangelen registreres, slettes og sjekkes ut | saksloggen viser hva som skjedde, og hvorfor | endringsloggen fylles ikke lenger, og det logges ikke noe annet sted | avviker | `MIG/V480__stopp_endringslogg.sql:1-29`, `SDL/saksbehandling/sak.graphqls:196` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-SØK-SØK-018` | Avkrysningen er `false` som standard på kladd og søknad | standardverdi | `MIG/V482__fullforer_videregaende.sql:9`, `:12` | testes i fase 2 |
| `@OPT-SØK-SØK-018` | Søknadsfristen sperrer ikke kladden, bare levering og oppdatering av søknaden | grense | `SVC/soknad/StudiekurvService.java:267` mot `:853`, `:1038` | uklart om ønsket |
| `@OPT-SØK-SØK-018` | Saksbehandleren kan oppgi det på vegne av søkeren når søknaden opprettes eller endres, også etter søknadsfristen | tilgangssjekk | `SVC/soknad/PaVegneAvSoker.java:42`, `SVC/soknad/StudiekurvService.java:850-851`, `SB/EndreSoknadView/EndreSoknadView.tsx:173` | legg til scenario med `fs-krav` |
| `@OPT-SØK-SØK-018` | Avkrysningen nullstilles i kladden når søknaden trekkes | tilstandsovergang | `SVC/soknad/StudiekurvService.java:657` | uklart om ønsket |
| `@OPT-SØK-SØK-018` | DUA-mangelen settes bare med en aktiv merket mangelkode, og en manuell eller utsjekket mangel blir stående når avkrysningen fjernes | annet | `SVC/saksbehandling/GskFullforesIVarMangelSync.java:38`, `:51`, `:99-100` | testes i fase 2 |
| `@OPT-SØK-SØK-018` | Forkaster søkeren endringene i kladden, får avkrysningen søknadens verdi igjen (også når saksbehandleren gjenoppretter) | tilstandsovergang | `SVC/soknad/StudiekurvService.java:763`, `:1567-1585`, `:1187`, `:1244` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Mangelkoden må matche `^[A-ZÆØÅ0-9_:,.\-+]{1,…}$` og være unik i regelverkssamlingen («En mangeltype med denne koden finnes allerede i regelverksamlingen») | validering | `fs-admin/src/common/utils/validationUtil/validationUtil.ts:17-21`, `SDL/saksbehandling/mangel.graphqls:244-249` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Kode, kategori og kort beskrivelse er obligatoriske, og kort beskrivelse er maks 100 tegn | obligatorisk felt | `MK/MangelkodeDetails/MangelkodeDetails.tsx:166-173`, `SDL/saksbehandling/mangel.graphqls:105-109` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Informasjon til søker er maks 4000 tegn per språk, og Markdown saneres (rå HTML og javascript:-, data:- og vbscript:-lenker avvises) | grense | `SDL/saksbehandling/mangel.graphqls:117`, `SVC/regelverk/MangeltypeService.java:144-181` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Saksbehandlerens kommentar er maks 4000 tegn, med samme Markdown-validering | grense | `SDL/saksbehandling/mangel.graphqls:60,75`, `SVC/saksbehandling/SakMangelService.java:53-55` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | En mangelkode kan ikke slettes, bare deaktiveres | tilstandsovergang | `MK/MangelkodeDetails/MangelkodeDetails.tsx:241-260,282` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | Bare aktive mangelkoder kan velges når en mangel registreres (bare i fs-admin, backend sjekker ikke) | validering | `MC/components/MangeltypeCombobox/MangeltypeCombobox.tsx:30` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | Mangelkoden for GSK som fullføres i vår: maks én per regelverkssamling, i «Generelle krav» og stopper for opptak | validering | `SVC/regelverk/MangeltypeService.java:119-141`, `MIG/V503__soknadsmangeltype_gsk_fullfores_i_var.sql:14-16` | dekkes av `@draft`-scenario: Bare én mangelkode i regelverkssamlingen kan være merket for generell studiekompetanse som fullføres i vår (`@OPT-BEH-BEH-036`) |
| `@OPT-BEH-BEH-008` | Å registrere, endre, slette eller publisere en mangel flytter en ubehandlet sak til «Under behandling» | tilstandsovergang | `SVC/saksbehandling/SakMangelService.java:115,275,327,365,392-398` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | Søkeren ser ingen mangler på en ubehandlet sak, heller ikke publiserte | tilstandsovergang | `MIG/V457__soknadsmangel_bare_publiserte.sql:14` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | En mangel på spesielle krav kan registreres uten kompetanseregelverk («Ikke valgt») | standardverdi | `MC/components/KompetanseregelverkSelect/KompetanseregelverkSelect.tsx:80-86`, `SVC/saksbehandling/SakMangelService.java:417-431` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | En mangel kan kobles til høyst ett av kompetanseregelverk og kvotespørsmål | validering | `MIG/V291__saksbehandling_skjema.sql:526` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Ny kommentar, ny kobling eller å åpne en utsjekket mangel igjen nullstiller «lest av søker» | tilstandsovergang | `SVC/saksbehandling/SakMangelService.java:209-219,262-268` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Ny beregnet mangeltekst nullstiller publiseringen av den | tilstandsovergang | `SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:208-209` | dekkes av `@draft`-scenario: Saksbehandleren ser at endringene ikke er publisert når <endring> |
| `@OPT-BEH-BEH-008` | Flere mangler oppdateres samlet bare på samme sak, og én feil ruller tilbake alt | validering | `SVC/saksbehandling/SakMangelService.java:122-138,175-187` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Automatisk registrerte mangler kan ikke slettes i fs-admin, og en mangel som stopper for opptak vises rød, de andre gule | tilgangssjekk | `MC/Mangel/Mangel.tsx:113-118,143` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | «Mangler dokumentasjon» på saken teller bare mangler som ikke er sjekket ut, i Generelle krav og Spesielle krav | annet | `SB/PersonaliaCard/PersonaliaCard.tsx:136-139,228-229` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-008` | Kategorien heter «Kvoter» i kodeverket, mens kravet sier «Kvote» | annet | `MIG/V264__soknadsmangel_kodeverk.sql:40` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | Registrering med kanPubliseres=true publiserer og sender melding med en gang (API-et, ikke brukt av fs-admin) | tilstandsovergang | `SVC/saksbehandling/SakMangelService.java:109,116-118` | testes i fase 2 |
| `@OPT-BEH-BEH-008` | Kategorien til en mangelkode kan endres også når koden er i bruk | tilstandsovergang | `SVC/regelverk/MangeltypeService.java:85-87` | uklart om ønsket |
| `@OPT-BEH-BEH-008` | Kvotespørsmålet må ligge i samme regelverkssamling som mangelkoden, men ikke i kvotene til saken | validering | `SVC/saksbehandling/SakMangelService.java:433-446` | uklart om ønsket |
| `@OPT-BEH-BEH-025` | DUA-mangelen sjekkes ut når automatikken setter saken til ferdig behandlet | tilstandsovergang | `SVC/autosak/FerdigbehandlingService.java:213-227` | testes i fase 2 (står i `@OPT-BEH-BEH-036`) |
| `@OPT-BEH-BEH-025` | Et ubesvart kvotespørsmål uten automatisk merknad hindrer ikke ferdig behandlet | annet | `SVC/autosak/FerdigbehandlingService.java:107-114` | uklart om ønsket |
| `@OPT-BEH-BEH-025` | Et uvurdert kravelement hindrer bare når søkeren ikke er kvalifisert i kompetanseregelverket | annet | `SVC/autosak/FerdigbehandlingService.java:151-210` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-025` | Grunnlag satt av saksbehandler gjør at saken ikke behandles helautomatisk | annet | `SVC/autosak/FerdigbehandlingService.java:83-90`, `SVC/autosak/SetteGrunnlagService.java:100-106` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-025` | En sak som allerede er ferdig behandlet, røres ikke | tilstandsovergang | `SVC/autosak/FerdigbehandlingService.java:59,76-80` | testes i fase 2 |
| `@OPT-BEH-BEH-025` | Annullerte vitnemål telles ikke, og kompetansebevis gir ikke helautomatisk | annet | `SVC/autosak/FerdigbehandlingService.java:92-100` | testes i fase 2 |
| `@OPT-BEH-BEH-025` | Søknadsalternativer uten kompetanseregelverk har ingen kvalifisering å avgjøre | annet | `SVC/autosak/FerdigbehandlingService.java:147` | testes i fase 2 |
| `@OPT-BEH-BEH-025` | To grunnlag med samme prioritet: det første etter grunnlagskode velges | annet | `SVC/autosak/SetteGrunnlagService.java:289-298` | uklart om ønsket (motsier raden «to grunnlag passer like godt») |
| `@OPT-BEH-BEH-025` | Saksbehandleren kan sette hvilken som helst status, også Behandlet når noe ikke er avgjort | tilstandsovergang | `SVC/saksbehandling/EndreStatusService.java:22-34` | uklart om ønsket |
| `@OPT-BEH-BEH-025` | Feiler ferdigbehandlingen, beholdes resten av behandlingen, men saken blir ikke ferdig behandlet | annet | `SVC/autosak/AutomatiskSaksbehandlingService.java:170-176` | testes i fase 2 |
| `@OPT-BEH-BEH-025` | Uten kvote finnes ingen kombinasjoner av kvote og grunnlag, og poengene regnes som avgjort | annet | `SVC/autosak/FerdigbehandlingService.java:106` | uklart om ønsket |
| `@OPT-BEH-BEH-025` | Et vitnemål uten utstedelsesdato gir ingen automatisk GSK-konklusjon | annet | `GskVedtakAutoService.java:84-86` | testes i fase 2 |
| `@OPT-BEH-BEH-025` | Saksbehandlerens handlinger flytter saken til «Under behandling» bare fra «Ikke behandlet», så en ferdig behandlet sak flyttes ikke tilbake | tilstandsovergang | `SVC/regelverk/poeng/SettPoengService.java:198`, `SVC/saksbehandling/SakMangelService.java:396` | legg til scenario med `fs-krav` (trolig i `@OPT-BEH-BEH-029`) |
| `@OPT-BEH-BEH-025` | Saksbehandleren velger vitnemål for GSK-konklusjonen når søkeren har flere vitnemål | annet | `SVC/autosak/gsk/SettGskKonklusjonService.java:60-85` | testes i fase 2 |
| `@OPT-BEH-BEH-036` | En inaktiv merket mangelkode gir ingen nye mangler, men sletter fortsatt når krysset fjernes | tilstandsovergang | `SVC/saksbehandling/GskFullforesIVarMangelSync.java:50-53,92-101` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-036` | Krysser søkeren av på nytt etter at DUA-mangelen er sjekket ut, kommer ingen ny mangel | tilstandsovergang | `SVC/saksbehandling/GskFullforesIVarMangelSync.java:54-61,89` | uklart om ønsket |
| `@OPT-BEH-BEH-036` | En sak som kommer til søknaden senere, får DUA-mangelen ved neste søknadshendelse | annet | `SVC/saksbehandling/GskFullforesIVarMangelSync.java:86-89` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-036` | En DUA-mangel saksbehandleren har registrert manuelt, slettes ikke når krysset fjernes | annet | `SVC/saksbehandling/GskFullforesIVarMangelSync.java:99` | testes i fase 2 |
| `@OPT-BEH-BEH-036` | Saksbehandleren kan krysse av for at GSK fullføres i vår når søknaden opprettes eller endres | annet | `SB/OpprettSoknadView/OpprettSoknadView.tsx:71,127,316`, `SB/EndreSoknadView/EndreSoknadView.tsx:71,109,173` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-036` | Ny mangeltekst nullstiller publisering og lest-status | tilstandsovergang | `SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:199-212` | uklart om ønsket (kravet sier at tekstene publiseres ved ferdig behandlet) |
| `@OPT-BEH-BEH-036` | Mangelteksten er én tekst per kompetanseregelverk (med «eller» mellom kravlistene), ikke én per kravelement | annet | `SVC/regelverk/kvalifisering/ManglendeKravTekstService.java:87-93` | uklart om ønsket |
| `@OPT-BEH-BEH-036` | DUA-mangelen gjelder søknaden som helhet, og vises bare så lenge organisasjonen behandler et søknadsalternativ | annet | `MIG/V457__soknadsmangel_bare_publiserte.sql:78,84-93` | testes i fase 2 |
| `@OPT-BEH-BEH-036` | Søkeren ser ingen mangler på en ubehandlet sak | tilstandsovergang | `MIG/V457__soknadsmangel_bare_publiserte.sql:14` | testes i fase 2 |
| `@OPT-BEH-BEH-036` | Advarsel på oversikten over mangelkoder når ingen aktiv kode er merket for GSK som fullføres i vår | validering | `MK/MangelkoderOverview.tsx:30-58` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-036` | Å merke en mangelkode gir ikke DUA-mangel på søknader som finnes fra før, før neste søknadshendelse | tilstandsovergang | `SVC/regelverk/MangeltypeService.java:85-117`, `JOBB/SoknadshendelseJobb.java:315` | uklart om ønsket |
| `@OPT-BEH-BEH-036` | Fjernes merkingen, blir DUA-mangler fra før stående, og slettes aldri av automatikken | tilstandsovergang | `SVC/saksbehandling/GskFullforesIVarMangelSync.java:38-40` | uklart om ønsket |
| `@OPT-BEH-BEH-036` | En merket mangelkode kan ikke flyttes ut av «Generelle krav» eller slutte å stoppe for opptak | validering | `SVC/regelverk/MangeltypeService.java:98,123-127` | testes i fase 2 |
| `@OPT-BEH-BEH-036` | Ved helautomatisk ferdigbehandling sjekkes også en manuelt registrert mangel med den merkede koden ut | annet | `SVC/autosak/FerdigbehandlingService.java:213-227` | uklart om ønsket |
| `@OPT-BEH-BEH-036` | Mangler bokmålsoversettelsen av et kravelement, vises ingen automatisk mangeltekst | annet | `SVC/regelverk/kvalifisering/ManglendeKravTekstService.java:84-95`, `MIG/V457__soknadsmangel_bare_publiserte.sql:169` | uklart om ønsket |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-008` | Søknadsmangler | 2 av 10 | 9 av 48 | 0 (verifisert uansett status: de 7 delene med `@draft @openquestion` er i gating-settet) |
| `@OPT-BEH-BEH-025` | Ferdigbehandle en sak | 0 av 5 | 0 av 15 | 1 |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | [!6549 Tabeller for vitnemålsbehandleren](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6549) (`vitnemalsbehandling-tabeller`) | åpen | `@OPT-BEH-BEH-025` | 0/1 | delvis: tabellen for valgt vitnemål, uten kobling til den automatiske behandlingen |
| `fs-plattform` | [!6541 STEK-249: automatisk GSK-konklusjon med flere vitnemål, uten organisasjon](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6541) (`solov/gsk-konklusjon-flere-vitnemaal`) | åpen | `@OPT-BEH-BEH-025` (konsistensraden om GSK-konklusjonen med flere vitnemål), `@OPT-BEH-BEH-015` | 0/0 | gjelder en tilgangsrad, ikke et scenario |
| `fs-plattform` | [!6539 TOT-2435 MANGEL-hendelse bare når søknaden har upresenterte mangler](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6539) (`TOT-2435-justere-hendelser-for-mangler`) | åpen | `@OPT-BEH-BEH-008` | 0/0 | usikker kobling |
| `fs-plattform` | [!6556 STEK-651: Oppdater saker etter endring i regelverk](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6556) (`mahj/STEK-651`) | åpen | – | 0/0 | usikker kobling, rører ikke kravene |
| `fs-admin` | [!3329 Draft: feat(soknadsbehandling): oppdater saker etter endring i regelverk (STEK-651)](https://gitlab.sikt.no/studieadm/fs-admin/-/merge_requests/3329) (`mahj/STEK-651`) | utkast | – | 0/0 | usikker kobling, rører ikke kravene |

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-008` | scenario | Opptaksforvalteren ved <organisasjon> forvalter mangelkodene i <opptak> | funnet | usikker | `MIG/V264__soknadsmangel_kodeverk.sql:60-85` — tilgangen følger organisasjonen som eier regelverkssamlingen, ikke den som forvalter opptaket (`MIG/V280__opptak_v2_skjema.sql:229,250-252`) |
| `@OPT-BEH-BEH-008` | tilgang | opptaksforvalter uten MODIFISERE_SØKNADSBEHANDLING endrer mangel | – | avviker | tilføyd: `MC/ManglerCard.tsx:137-208` viser redigeringen |
| `@OPT-BEH-BEH-008` | tilgang | opptaksforvalter endrer kategori på en mangelkode som er i bruk | – | avviker | tilføyd: `SVC/regelverk/MangeltypeService.java:85-87` |
| `@OPT-BEH-BEH-008` | regel | 3 regler uten scenario | – | tilføyd | publisering ved registrering, kategori på kode i bruk, kvotespørsmål i samme samling |
| `@OPT-BEH-BEH-025` | scenario | Saksbehandleren velger vitnemålet saken behandles automatisk på | ikke funnet | ikke funnet | beviset utvidet: `SVC/autosak/gsk/SettGskKonklusjonService.java:60-85` (valg av vitnemål for GSK-konklusjonen) og MR !6549 |
| `@OPT-BEH-BEH-025` | tilgang | søkeren har flere vitnemål (GSK-konklusjonen) | usikker | avviker | `GskVedtakAutoService.java:80-82` — ingen konklusjon på main. Finnes i MR !6541 |
| `@OPT-BEH-BEH-025` | regel | 5 regler uten scenario | – | tilføyd | feilet ferdigbehandling, uten kvote, utstedelsesdato, status bare fra Ikke behandlet, valg av vitnemål for GSK |
| `@OPT-BEH-BEH-036` | scenario | Saksbehandleren sjekker ut mangelen når søkeren har dokumentert vitnemålet | ikke funnet | usikker | `SVC/saksbehandling/SakMangelService.java:217-219` — API-et sjekker ut, men fs-admin har ingen utsjekk, og steget nevner ikke skjermen |
| `@OPT-BEH-BEH-036` | tilgang | søknadshendelse-jobben setter og sletter DUA-mangelen | – | stemmer | tilføyd: `JOBB/SoknadshendelseJobb.java:311-316` |
| `@OPT-BEH-BEH-036` | regel | 5 regler uten scenario | – | tilføyd | merking uten søknader fra før, merking fjernet, kategori låst, manuell mangel sjekkes ut, bokmålstekst mangler |
| `@OPT-SØK-SØK-018` | regel | Forkaster søkeren endringene i kladden, får avkrysningen søknadens verdi igjen | – | tilføyd | `SVC/soknad/StudiekurvService.java:1567-1585` |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-008` — Søknadsmangler (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/søknadsmangler.feature`, `@planned` → `@in-progress`, 13/48 funnet) — `@implemented` på: Regel: Opptaksforvalteren forvalter mangelkodene i regelverkssamlingen (linje 45), Regel: Mangler hindrer ikke kvalifiseringen eller at saken blir ferdig behandlet (linje 79), Scenario: Registrere mangel på spesielle krav (linje 105), Scenario: Saksbehandleren velger blant mangelkodene i regelverkssamlingen til opptaket (linje 113), Scenario: Saksbehandleren velger blant kompetanseregelverkene til søknadsalternativene i saken (linje 120), Scenario: Kommentaren til søkeren er valgfri (linje 147), Scenario: En sak kan ha flere mangler (linje 151), Scenario: Slette mangel som er registrert ved en feil (linje 168), Scenario: Saksbehandleren ser at søkeren har lastet opp ny dokumentasjon (linje 190), Scenario: Opptaksforvalteren ved forvaltende organisasjon ser manglene i alle sakene (linje 444). Kravet er ikke i en spesifikasjon
- `@OPT-BEH-BEH-025` — Ferdigbehandle en sak (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/ferdigbehandle_sak.feature`, `@in-progress` blir stående, 9/15 funnet) — `@implemented` på: Regel: Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk (linje 44, `@implemented` fjernes fra scenarioene på linje 58 og 64), Scenario: Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt (linje 103), Scenario: Saken er ferdig behandlet selv om kravelementene ga mangeltekst (linje 111), Scenario: Saken blir stående som ikke behandlet når et steg ikke kan avgjøres (linje 148) — bygger på `@OPT-BEH-BEH-015`, som er `@in-progress`
- `@OPT-BEH-BEH-036` — Automatiske mangler (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_mangler.feature`, `@in-progress` blir stående, 7/21 funnet) — `@implemented` på: Scenario: Søkeren får ikke egen melding om den automatiske mangelen (linje 207), Scenario: Mangel som er sjekket ut slettes ikke når søkeren endrer søknaden (linje 219), Scenario: Mangelen sjekkes ikke ut når saken ikke er behandlet helautomatisk (linje 237) — bygger på `@OPT-BEH-BEH-020`, som er `@in-progress`

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-SØK-SØK-018` — Oppgi at generell studiekompetanse fullføres i vår (`@draft`, 0/3 funnet) — alle tre er usikre, siden søkerens skjerm i min-kompetanse ikke er sjekket
- `@FLY-OPT-AUT-001` — Automatisk saksbehandling (`@planned`, 3/4 funnet i de to fasene) — ingen av de to fasene er levert, og søkeren ser ikke mangelteksten når saken er ferdig behandlet automatisk

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-008` | Søknadsmangler (delvis: `@in-progress`, 10 deler `@implemented`) | `søknadsmangler.feature` | `@planned` | 13/48 |
| `@OPT-BEH-BEH-025` | Ferdigbehandle en sak (delvis: `@in-progress`, 4 deler `@implemented`, `@implemented` fjernet fra 2 scenarioer under den leverte regelen) | `ferdigbehandle_sak.feature` | `@in-progress` | 9/15 |
| `@OPT-BEH-BEH-036` | Automatiske mangler (delvis: `@in-progress`, 3 nye deler `@implemented`) | `automatiske_mangler.feature` | `@in-progress` | 7/21 |

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-SØK-SØK-018` | Oppgi at generell studiekompetanse fullføres i vår | `@draft` | 0/3 | 0 ikke funnet, 3 usikker |
| `@OPT-BEH-BEH-008` | Søknadsmangler | `@in-progress` | 13/48 | 22 ikke funnet, 13 usikker |
| `@OPT-BEH-BEH-025` | Ferdigbehandle en sak | `@in-progress` | 9/15 | 6 ikke funnet, 0 usikker |
| `@OPT-BEH-BEH-036` | Automatiske mangler | `@in-progress` | 7/21 | 9 ikke funnet, 5 usikker |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling | `@planned` | 3/4 | 1 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Overleveringen av mangeltekstene er brutt:** den automatiske behandlingen setter saken til ferdig behandlet, men publiserer ikke mangeltekstene, og søkeren ser bare publiserte (`SVC/autosak/FerdigbehandlingService.java:58-74`, `MIG/V457__soknadsmangel_bare_publiserte.sql:170`). Gjelder `@OPT-BEH-BEH-025`, `@OPT-BEH-BEH-036` og flyten `@FLY-OPT-AUT-001`. Foreslå at bruddet skrives som kjent brudd i flyten med `fs-krav` (modus E)
- **Saksloggen fylles ikke:** `MIG/V480__stopp_endringslogg.sql:1-29` stoppet endringsloggen i saksbehandling, så alle scenarioene som sier at saksloggen viser noe, er ikke funnet (`@OPT-BEH-BEH-008`, `@OPT-BEH-BEH-036`)
- **Utsjekk av mangler mangler i fs-admin:** API-et har `erUtsjekket` (`SVC/saksbehandling/SakMangelService.java:217-219`), men fs-admin har ingen handling for det (`@OPT-BEH-BEH-008`, `@OPT-BEH-BEH-036`)
- **Den nye regelen for å merke mangelkoden er levert, men `@draft`:** alle tre scenarioene i «Opptaksforvalteren merker én mangelkode for generell studiekompetanse som fullføres i vår» (`automatiske_mangler.feature:125`) er funnet (`SVC/regelverk/MangeltypeService.java:52,95-98,119-141`, `MK/MangelkodeDetails/MangelkodeDetails.tsx:400-413`). Regelen er utenfor gating-settet så lenge den er `@draft`. Valider den med `fs-krav`, så kan den leveres. Fasen «Mangelen for GSK som fullføres i vår sjekkes ut …» i flyten har ankeret på regelen, og blir ikke levert før `@draft` er fjernet
- **Saksbehandleren kan oppgi GSK fullføres i vår på vegne av søkeren** (fs-admin!3301, `SB/EndreSoknadView/EndreSoknadView.tsx:173`, `SB/OpprettSoknadView/OpprettSoknadView.tsx:316`), men ingen scenarioer beskriver det. `@OPT-SØK-SØK-018` har bare søkerens scenarioer. Legg til scenario med `fs-krav`
- **Åpent spørsmål:** `@OPT-BEH-BEH-008` «Saksbehandleren publiserer manglene i saken» — publiseringen er endret etter raffineringen og ikke gått gjennom med teamet
- **Åpent spørsmål:** `@OPT-BEH-BEH-008` «Søkeren får melding hver gang saksbehandleren publiserer manglene» — samme spørsmål som over
- **Åpent spørsmål:** `@OPT-BEH-BEH-008` «Saksbehandleren publiserer en sak som bare har automatiske mangler» — samme spørsmål. Koden i dag: «Oppdater mangel i Min kompetanse» kan ikke brukes
- **Åpent spørsmål:** `@OPT-BEH-BEH-008` «Saksbehandleren ser at endringene ikke er publisert når <endring>» — må også en ny mangel, og en mangel som sjekkes ut, publiseres på nytt?
- **Åpent spørsmål:** `@OPT-BEH-BEH-008` «Mangel på <kategori> gjelder ikke et bestemt søknadsalternativ» — gjelder Poeng og Kvote søknaden som helhet? Koden: hele søknaden
- **Åpent spørsmål:** `@OPT-BEH-BEH-008` «Søkeren laster opp dokumentasjon for manglene» — knyttes dokumentasjonen til en bestemt mangel, og hva skjer etter fristen? Koden: ingen kobling
- **Åpent spørsmål:** `@OPT-BEH-BEH-008` «Saksbehandleren finner sakene med en bestemt mangelkode» — det finnes ikke noe krav for listen over saker. Skal utsjekkede tas med, og kan flere mangelkoder velges?
- **Tilgang avviker:** `@OPT-BEH-BEH-008` opptaksforvalter oppretter og endrer mangelkode — kravet sier organisasjonen som forvalter opptaket, koden bruker organisasjonen som eier regelverkssamlingen, `MIG/V264__soknadsmangel_kodeverk.sql:60-85`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` saksbehandler endrer manglene i en annen organisasjons sak — fs-admin viser redigeringen, `MC/ManglerCard.tsx:137-208`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` saksbehandler leser manglene i en annen organisasjons sak — saken er ikke synlig, `MIG/V501__tilbyderoppslag_per_sak.sql:37-51`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` tilbyder endrer manglene — redigeringen vises, `MC/ManglerCard.tsx:137-208`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` opptaksforvalter uten MODIFISERE_SØKNADSBEHANDLING endrer mangel — redigeringen vises, `MC/ManglerCard.tsx:137-208`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` mangelkode fra en annen regelverkssamling — bare fs-admin filtrerer, `SVC/saksbehandling/SakMangelService.java:65-96`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` kompetanseregelverk ingen søknadsalternativer har — backend krever bare samme samling, `SVC/saksbehandling/SakMangelService.java:450-460`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` kategori endres på mangelkode i bruk — `SVC/regelverk/MangeltypeService.java:85-87`
- **Tilgang avviker:** `@OPT-BEH-BEH-008` sletting av mangel uten sakslogg — `MIG/V480__stopp_endringslogg.sql:14-29`
- **Tilgang avviker:** `@OPT-BEH-BEH-025` flere vitnemål — søknaden får ikke GSK-konklusjonen, `GskVedtakAutoService.java:80-82` (MR !6541)
- **Tilgang avviker:** `@OPT-BEH-BEH-025` mangeltekst publiseres ikke igjen — `SVC/regelverk/kvalifisering/KvalifiseringOppdateringService.java:203-212`
- **Tilgang avviker:** `@OPT-BEH-BEH-036` saksbehandler sletter automatisk DUA-mangel — API-et sletter, `SVC/saksbehandling/SakMangelService.java:351-367`
- **Tilgang avviker:** `@OPT-BEH-BEH-036` saksbehandler sjekker ut DUA-mangelen — ingen utsjekk i fs-admin
- **Tilgang avviker:** `@OPT-BEH-BEH-036` publisering når saken er ferdig behandlet — `SVC/autosak/FerdigbehandlingService.java:64-68`
- **Tilgang avviker:** `@OPT-BEH-BEH-036` sakslogg for DUA — `MIG/V480__stopp_endringslogg.sql:1-29`
- **Ikke sjekket:** min-kompetanse finnes ikke lokalt. Scenarioene der søkeren ser eller gjør noe, er `usikker` (API-delen i fs-plattform er vurdert)
- **Ikke valgt i denne kjøringen:** de andre fasene i `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature` (`@planned`)
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-025` bygger på `@OPT-BEH-BEH-015` (`@in-progress`)
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-036` bygger på `@OPT-BEH-BEH-020` (`@in-progress`), `@OPT-BEH-BEH-008` (`@planned`) og `@OPT-SØK-SØK-018` (`@draft`)
- **Delvis levert, men ikke i en spesifikasjon:** `@OPT-BEH-BEH-008` — hent det inn med `fs-specify`
